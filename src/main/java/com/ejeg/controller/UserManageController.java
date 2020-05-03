package com.ejeg.controller;

import com.ejeg.annotation.SystemLog;
import com.ejeg.pojo.TbUsers;
import com.ejeg.pojo.UserSearch;
import com.ejeg.service.UserService;
import com.ejeg.util.ResultUtil;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 用户管理
 */
@Controller
public class UserManageController {

    @Autowired
    private UserService userService;

    /**
     * 跳转添加用户
     *
     * @return
     */
    @SystemLog(value = "跳转-添加用户页面")
    @RequiresPermissions(value = {"sys:monitor:insert"}, logical = Logical.OR)
    @RequestMapping("/addUser")
    public String addUser() {
        return "page/user/addUser";
    }


    /**
     * 跳转到管理用户
     *
     * @return
     */
    @SystemLog(value = "查看-管理用户页面")
    @RequiresPermissions(value = {"sys:manage:select"}, logical = Logical.OR)
    @RequestMapping("/userManager")
    public String goUserManager() {
        return "page/user/userManage";
    }


    /**
     * 管理用户
     *
     * @param page
     * @param limit
     * @return
     */
    @SystemLog(value = "查看-管理用户")
    @RequestMapping("/user/getUserList")
    @ResponseBody
    public ResultUtil userManager(Integer page, Integer limit) {
        return userService.getUsers(page, limit);
    }


    /**
     * 添加用户
     *
     * @param tbUsers
     * @return
     */
    @SystemLog(value = "提交-添加用户")
    @RequestMapping("/insUser")
    @ResponseBody
    public ResultUtil insUser(TbUsers tbUsers) {
        try {
            userService.insUser(tbUsers);
            return ResultUtil.ok();
        } catch (Exception e) {
            e.printStackTrace();
            return new ResultUtil(502, "添加失败！");
        }
    }


    /**
     * 删除用户（id）
     *
     * @param uid
     * @return
     */
    @SystemLog(value = "删除用户")
    @RequestMapping("/sys/delUserById/{id}")
    @ResponseBody
    public ResultUtil delUser(@PathVariable("id") Long uid) {
        ResultUtil resultUtil = new ResultUtil();
        try {
            userService.delUserById(uid);
            resultUtil.setCode(0);
        } catch (Exception e) {
            resultUtil.setCode(500);
            e.printStackTrace();
        }
        return resultUtil;
    }


    /**
     * 跳转到修改页面
     *
     * @param uid
     * @param map
     * @return
     */
    @SystemLog(value = "跳转-修改页面")
    @RequestMapping("/user/editUser/{uid}")
    public String goUpdUser(@PathVariable("uid") String uid, ModelMap map) {
        TbUsers tbUsers = userService.getTbUserById(uid);
        map.addAttribute("TbUsers", tbUsers);
        return "page/user/editUser";
    }


    /**
     * 修改用户
     *
     * @param tbUsers
     * @return
     */
    @SystemLog(value = "提交-修改用户")
    @RequestMapping("/user/editUser")
    @ResponseBody
    public ResultUtil updUser(TbUsers tbUsers) {
        ResultUtil resultUtil = new ResultUtil();

        try {
            userService.updUser(tbUsers);
            resultUtil.setCode(0);
        } catch (Exception e) {
            resultUtil.setCode(500);
            e.printStackTrace();
        }
        return resultUtil;
    }

    /**
     * 查询用户
     *
     * @param userSearch
     * @return
     */
    @SystemLog(value = "查询用户")
    @RequestMapping("/user/searchUser")
    @ResponseBody
    public ResultUtil searchUser(Integer page, Integer limit, UserSearch userSearch) {
        ResultUtil resultUtil = userService.searchUser(userSearch);

        return resultUtil;
    }


    /**
     * 批量删除用户
     *
     * @param str
     * @return
     */
    @SystemLog(value = "批量删除用户")
    @RequestMapping("/sys/bachDelUser/{uid}")
    @ResponseBody
    public ResultUtil bachDel(@PathVariable("uid") String str) {
        ResultUtil resultUtil = new ResultUtil();
        try {
            userService.bachDelUser(str);
            resultUtil.setCode(0);
        } catch (Exception e) {
            resultUtil.setCode(500);
            e.printStackTrace();
        }
        return resultUtil;
    }


}
