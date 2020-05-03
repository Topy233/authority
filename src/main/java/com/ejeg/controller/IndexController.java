package com.ejeg.controller;


import com.ejeg.annotation.SystemLog;
import com.ejeg.pojo.Menu;
import com.ejeg.pojo.TbAdmin;
import com.ejeg.service.AdminService;
import com.ejeg.util.ResultUtil;
import com.ejeg.util.ShiroUtils;
import com.fasterxml.jackson.annotation.JsonIgnore;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.DigestUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * 首页
 */
@Controller
public class IndexController {

    @Autowired
    private AdminService adminService;


    /**
     * 首页
     *
     * @param map
     * @return
     */
    @RequestMapping(value = "/index")
    public String index(ModelMap map) {
        TbAdmin admin = (TbAdmin) SecurityUtils.getSubject().getPrincipal();
        List<Menu> menus = null;
        if (admin != null) {
            // 得到用户菜单
            menus = adminService.getMenus(admin);
        }
        map.addAttribute("menus", menus);

        return "page/index";
    }


    /**
     * 后台管理
     *
     * @return
     */
    @RequestMapping("/main")
    public String main() {
        return "page/tabs/main";
    }


    /**
     * 退出
     *
     * @return
     */
    @SystemLog("退出")
    @RequestMapping(value = "/loginOut")
    public String loginOut() {
        ShiroUtils.logout();
        return "redirect:/login";
    }

    /**
     * 跳转修改密码页面
     *
     * @return
     */
    @SystemLog("跳转-修改密码页面")
    @RequestMapping("/goChangePassword")
    public String goChangePassword(ModelMap map) {
        TbAdmin user = (TbAdmin) SecurityUtils.getSubject().getPrincipal();
        map.addAttribute("username", user.getUsername());
        return "page/user/changePassword";
    }

    /**
     * 修改密码
     *
     * @param newPwd
     * @return
     */
    @SystemLog("提交-修改密码")
    @RequestMapping("/sys/updPwd")
    @ResponseBody
    public ResultUtil changePassword(String oldPwd, String newPwd) {
        ResultUtil resultUtil = new ResultUtil();
        TbAdmin user = (TbAdmin) SecurityUtils.getSubject().getPrincipal();

        if (user.getPassword().equals(DigestUtils.md5DigestAsHex(oldPwd.getBytes()))) {
            user.setPassword(DigestUtils.md5DigestAsHex(newPwd.getBytes()));
            try {
                adminService.updPassword(user);
                SecurityUtils.getSubject().logout();
                resultUtil.setCode(0);
            } catch (Exception e) {
                resultUtil.setCode(500);
                e.printStackTrace();
            }
        } else {
            resultUtil.setCode(600);
        }

        return resultUtil;
    }


}
