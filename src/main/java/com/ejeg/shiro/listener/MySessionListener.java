package com.ejeg.shiro.listener;


import org.apache.shiro.session.Session;
import org.apache.shiro.session.SessionListener;

import java.util.Date;


public class MySessionListener implements SessionListener {
    @Override
    public void onStart(Session session) {//会话创建时触发
        System.err.println("会话创建：" + new Date() + "-->" + session.getId());
    }

    @Override
    public void onExpiration(Session session) {//会话过期时触发
        System.err.println("会话过期：" + new Date() + "-->" + session.getId());
    }

    @Override
    public void onStop(Session session) {//退出/会话过期时触发
        System.err.println("会话停止：" + new Date() + "-->" + session.getId());
    }
}
