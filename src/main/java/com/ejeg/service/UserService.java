package com.ejeg.service;

import com.ejeg.pojo.TbUsers;
import com.ejeg.pojo.UserSearch;
import com.ejeg.util.ResultUtil;


public interface UserService {
    //获得用户表数据
    ResultUtil getUsers(Integer page, Integer limit);

    //添加用户
    void insUser(TbUsers tbUsers);

    //删除用户
    void delUserById(Long uid);

    //获取要修改用户的信息
    TbUsers getTbUserById(String uid);

    //修改用户
    int updUser(TbUsers tbUsers);

    //查询用户
    ResultUtil searchUser(UserSearch userSearch);

    //批量删除用户
    void bachDelUser(String str);


}
