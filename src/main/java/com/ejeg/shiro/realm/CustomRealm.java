package com.ejeg.shiro.realm;

import com.ejeg.mapper.AdminMenusMapper;
import com.ejeg.mapper.TbAdminMapper;
import com.ejeg.pojo.TbAdmin;
import com.ejeg.pojo.TbAdminExample;
import com.ejeg.pojo.TbMenus;
import org.apache.commons.lang.StringUtils;
import org.apache.shiro.authc.*;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.crypto.hash.Md5Hash;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.*;


public class CustomRealm extends AuthorizingRealm {

    @Autowired
    private TbAdminMapper tbAdminMapper;

    @Autowired
    private AdminMenusMapper adminMenusMapper;

    private static Logger logger = LoggerFactory.getLogger(CustomRealm.class);

    public CustomRealm() {
        logger.info("CustomRealm------------------------------");
    }

    @Override
    public String getName() {
        return "CustomRealm";
    }

    /**
     * realm授权方法 从输入参数principalCollection得到身份信息 根据身份信息到数据库查找权限信息 将权限信息添加给授权信息对象
     * 返回 授权信息对象(判断用户访问url是否在权限信息中没有体现)
     */
    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principalCollection) {
        TbAdmin admin = (TbAdmin) principalCollection.getPrimaryPrincipal();
        Long roleId = admin.getRoleId();
/*		Subject subject = ShiroUtils.getSubject();
		subject.getSession().setAttribute("roleId",roleId);*/
        List<String> permsList = null;


        List<TbMenus> menuList = adminMenusMapper.getMenus(roleId);
        permsList = new ArrayList<>(menuList.size());
        for (TbMenus menu : menuList) {
            if (menu.getPerms() != null && !"".equals(menu.getPerms())) {
                permsList.add(menu.getPerms());
            }
        }

        // 用户权限列表
        Set<String> permsSet = new HashSet<String>();
        for (String perms : permsList) {
            if (StringUtils.isBlank(perms)) {
                continue;
            }
            permsSet.addAll(Arrays.asList(perms.trim().split(",")));
        }

        SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
        info.setStringPermissions(permsSet);
        return info;
    }

    /**
     * 表单认证过滤器认证时会调用自定义Realm的认证方法进行认证，成功回到index.do，再跳转到index.jsp页面
     * <p>
     * 前提：表单认证过滤器收集和组织用户名和密码信息封装为token对象传递给此方法
     * <p>
     * token:封装了身份信息和凭证信息 2步骤：比对身份 信息；比对凭证
     */
    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
        String username = (String) token.getPrincipal();
        String password = new String((char[]) token.getCredentials());

        // 查询用户信息
        TbAdminExample example = new TbAdminExample();
        TbAdminExample.Criteria criteria = example.createCriteria();
        criteria.andUsernameEqualTo(username);
        List<TbAdmin> admins = tbAdminMapper.selectByExample(example);


        // 账号不存在
        if (admins == null || admins.size() == 0) {
            throw new UnknownAccountException("账号不存在!");
        }
        password = new Md5Hash(password).toString();
        // 密码错误
        if (!password.equals(admins.get(0).getPassword())) {
            throw new IncorrectCredentialsException("账号或密码不正确!");
        }

        // 账号未分配角色
        if (admins.get(0).getRoleId() == null || admins.get(0).getRoleId() == 0) {
            throw new UnknownAccountException("账号未分配角色!");
        }

/*
		//放入roleId
		Long roleId = (Long) admins.get(0).getRoleId();
		Subject subject = ShiroUtils.getSubject();
		subject.getSession().setAttribute("roleId",roleId);
		subject.getSession().setAttribute("username", username);
*/

        //SimpleAuthenticationInfo代表该用户的认证信息，其实就是数据库中的用户名、密码、加密密码使用的盐
        //存在数据库中的密码是对用户真是密码通过md5加盐加密得到的，保证安全，及时数据泄露，也得不到真正的用户密码
        //getName()返回该realm的名字，代表该认证信息的来源是该realm，作用不大，一般都是单realm
        //该方法返回后，上层会对token和SimpleAuthenticationInfo进行比较，首先比较Principal()，然后将token的Credentials
        //进行md5加上SimpleAuthenticationInfo中的盐加密，加密结果和SimpleAuthenticationInfo的Credentials比较


        SimpleAuthenticationInfo info = new SimpleAuthenticationInfo(admins.get(0), password, getName());
        return info;
    }
}
