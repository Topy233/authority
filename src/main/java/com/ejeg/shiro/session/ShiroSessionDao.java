package com.ejeg.shiro.session;

import com.ejeg.shiro.cache.ShiroSpringCacheManager;
import org.apache.shiro.cache.Cache;
import org.apache.shiro.session.Session;
import org.apache.shiro.session.mgt.eis.CachingSessionDAO;

import java.io.Serializable;

public class ShiroSessionDao extends CachingSessionDAO {

    private Cache<String, Session> cache;

    public ShiroSessionDao(ShiroSpringCacheManager cacheManager) {
        String cacheName = getActiveSessionsCacheName();
        this.setCacheManager(cacheManager);
        this.cache = getCacheManager().getCache(cacheName);
    }

    @Override
    protected void doUpdate(Session session) {
        if (session == null) {
            return;
        }
        cache.put(session.getId().toString(), session);
    }

    @Override
    protected void doDelete(Session session) {
        if (session == null) {
            return;
        }
        cache.remove(session.getId().toString());
    }

    @Override
    protected Serializable doCreate(Session session) {
        if (session == null) {
            return null;
        }
        Serializable sessionId = this.generateSessionId(session);
        assignSessionId(session, sessionId);
        cache.put(sessionId.toString(), session);
        return sessionId;
    }

    @Override
    protected Session doReadSession(Serializable sessionId) {
        if (sessionId == null) {
            return null;
        }

        Session session = (Session) cache.get(sessionId.toString());
        return session;
    }
}