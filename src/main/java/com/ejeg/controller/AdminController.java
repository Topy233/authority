package com.ejeg.controller;

import com.ejeg.annotation.SystemLog;
import com.ejeg.pojo.TbAdmin;
import com.ejeg.pojo.TbMenus;
import com.ejeg.pojo.TbRoles;
import com.ejeg.service.AdminService;
import com.ejeg.util.JsonUtils;
import com.ejeg.util.ResultUtil;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * 管理员管理
 */
@Controller
public class AdminController {
    @Autowired
    private AdminService adminService;

    /**
     * sql监控
     *
     * @return
     */
    @SystemLog(value = "查看-sql监控")
    @RequestMapping("/sys/druid")
    public String druid() {
        return "redirect:/druid/index.html";
    }

    /**
     * 跳转角色管理界面
     *
     * @return
     */
    @SystemLog(value = "查看-角色管理")
    @RequiresPermissions(
            value = {"sys:role:select"},
            logical = Logical.OR)
    @RequestMapping(value = "/roleList")
    public String roleManager() {
        return "/page/admin/roleList";
    }

    /**
     * 跳转管理员列表界面
     *
     * @return
     */
    @SystemLog(value = "查看-管理员列表")
    @RequiresPermissions(
            value = {"sys:admin:select"},
            logical = Logical.OR)
    @RequestMapping(value = "/adminList")
    public String adminList() {
        return "/page/admin/adminList";
    }

    /**
     * 跳转菜单管理界面
     *
     * @return
     */
    @SystemLog(value = "查看-菜单管理页面")
    @RequiresPermissions(
            value = {"sys:menu:select"},
            logical = Logical.OR)
    @RequestMapping(value = "/menuList")
    public String menuList() {
        return "/page/admin/menuList";
    }

    /**
     * 角色管理数据
     *
     * @return
     */
    @RequestMapping(value = "/sys/getRoleList")
    @ResponseBody
    public ResultUtil getRoleList(Integer page, Integer limit) {
        return adminService.getRoles(page, limit);
    }

    /**
     * 管理员列表
     *
     * @param page
     * @param limit
     * @return
     */
    @RequestMapping("/sys/getAdminList")
    @ResponseBody
    public ResultUtil getAdminList(Integer page, Integer limit) {
        return adminService.getAdmin(page, limit);
    }

    /**
     * 菜单管理
     *
     * @return
     */
    @RequestMapping("/sys/getMenusList")
    @ResponseBody
    public ResultUtil getMenusList(Integer page, Integer limit) {
        return adminService.getMenusList(page, limit);
    }

    /**
     * 删除角色
     *
     * @param roleId
     * @return
     */
    @SystemLog(value = "删除角色")
    @RequestMapping("/delRole/{roleId}")
    @ResponseBody
    public ResultUtil delRole(@PathVariable("roleId") Long roleId) {
        ResultUtil resultUtil = new ResultUtil();
        try {
            adminService.deleteRole(roleId);
            resultUtil.setCode(0);
        } catch (Exception e) {
            e.printStackTrace();
            resultUtil.setCode(500);
        }
        return resultUtil;
    }

    /**
     * 编辑权限
     *
     * @param role
     * @param model
     * @return
     */
    @SystemLog(value = "编辑权限")
    @RequestMapping("/sys/editRole")
    public String editRoles(TbRoles role, Model model) {
        TbRoles tbRoles = adminService.editRole(role);
        model.addAttribute("role", tbRoles);
        return "page/admin/editRole";
    }

    /**
     * 树形结构（指定）
     *
     * @param roleId
     * @return
     */
    @RequestMapping(
            value = "/getTreeData",
            produces = {"text/json;charset=UTF-8"})
    @ResponseBody
    public String initzTree(@RequestParam(value = "roleId", defaultValue = "-1") Long roleId) {
        TbAdmin admin = new TbAdmin();
        admin.setRoleId(roleId);
        return JsonUtils.objectToJson(adminService.geTreeData(admin));
    }

    /**
     * 所有的树
     *
     * @param roleId
     * @return
     */
    @RequestMapping(
            value = "/getAllTreeData",
            produces = {"text/json;charset=UTF-8"})
    @ResponseBody
    public String getTree(@RequestParam(value = "roleId", defaultValue = "-1") Long roleId) {
        TbAdmin admin = new TbAdmin();
        admin.setRoleId(roleId);
        adminService.getAllTreeData();
        return JsonUtils.objectToJson(adminService.getAllTreeData());
    }

    /**
     * 跳转添加角色界面
     *
     * @return
     */
    @SystemLog(value = "跳转-添加角色页面")
    @RequestMapping("/addRole")
    public String addRoles() {
        return "page/admin/addRole";
    }

    /**
     * 检查角色是否唯一
     *
     * @param roleName
     * @return
     */
    @RequestMapping("/sys/checkRoleName")
    @ResponseBody
    public ResultUtil checkRoleName(Long roleId, String roleName) {
        boolean flag = adminService.checkRoleName(roleId, roleName);
        if (flag) {
            return new ResultUtil(500, "角色名：" + roleName + "已存在，请重新填写！");
        }
        return new ResultUtil(0);
    }

    /**
     * 添加角色
     *
     * @param role
     * @param m
     * @return
     */
    @SystemLog(value = "提交-添加角色")
    @RequestMapping("/sys/insRole")
    @ResponseBody
    public ResultUtil insRole(TbRoles role, String m) {
        adminService.insRole(role, m);
        return ResultUtil.ok();
    }

    /**
     * 修改角色
     *
     * @param roles
     * @param m
     * @return
     */
    @SystemLog(value = "编辑角色")
    @RequestMapping("/sys/updRole")
    @ResponseBody
    public ResultUtil updateRole(TbRoles roles, String m) {
        adminService.updRole(roles, m);
        return ResultUtil.ok();
    }

    /**
     * 批量删除角色
     *
     * @param roleId
     * @return
     */
    @SystemLog(value = "批量删除角色")
    @RequestMapping("/sys/batchDelRoles/{rolesId}")
    @ResponseBody
    public ResultUtil batchDel(@PathVariable("rolesId") String roleId) {
        ResultUtil resultUtil = new ResultUtil();
        try {
            adminService.batchDel(roleId);
            resultUtil.setCode(0);
        } catch (Exception e) {
            resultUtil.setCode(500);
            e.printStackTrace();
        }
        return resultUtil;
    }

    /**
     * 删除管理员列表
     *
     * @param roleId
     * @return
     */
    @SystemLog(value = "删除管理员")
    @RequestMapping("/sys/delAdminById/{rolesId}")
    @ResponseBody
    public ResultUtil delAdmin(@PathVariable("rolesId") Long roleId) {
        try {
            adminService.delAdminById(roleId);
            return ResultUtil.ok();
        } catch (Exception e) {
            e.printStackTrace();
            return ResultUtil.error();
        }
    }

    /**
     * 编辑管理员列表
     *
     * @return
     */
    @SystemLog(value = "编辑管理员")
    @RequestMapping("/sys/editAdmin/{id}")
    public String editAdmin(@PathVariable("id") Long roleId, ModelMap map) {
        TbAdmin tbAdmin = adminService.getTbAdminById(roleId);
        map.addAttribute("TbAdmin", tbAdmin);
        return "page/admin/editAdmin";
    }

    /**
     * 跳转添加管理员界面
     *
     * @return
     */
    @SystemLog(value = "跳转-添加管理员页面")
    @RequestMapping("/addAdmin")
    public String addAdmin(ModelMap map) {
        List<TbRoles> list = adminService.getRoles();
        map.addAttribute("list", list);
        return "/page/admin/addAdmin";
    }

    /**
     * 编辑管理员
     *
     * @param tbAdmin
     * @return
     */
    @SystemLog(value = "提交-编辑管理员")
    @RequestMapping("/sys/updAdmin")
    @ResponseBody
    public ResultUtil editAdmin(TbAdmin tbAdmin) {
        ResultUtil resultUtil = new ResultUtil();
        try {
            adminService.updAdminById(tbAdmin);
            resultUtil.setCode(0);
        } catch (Exception e) {
            resultUtil.setCode(500);
            e.printStackTrace();
        }
        return resultUtil;
    }

    /**
     * 添加管理员
     *
     * @param tbAdmin
     * @return
     */
    @SystemLog(value = "添加管理员")
    @RequestMapping("/sys/addAdmin")
    @ResponseBody
    public ResultUtil addAdmin(TbAdmin tbAdmin) {
        ResultUtil resultUtil = new ResultUtil();
        try {
            adminService.addAdmin(tbAdmin);
            resultUtil.setCode(0);
        } catch (Exception e) {
            resultUtil.setCode(500);
            e.printStackTrace();
        }
        return resultUtil;
    }

    /**
     * 批量删除管理员列表
     *
     * @param strId
     * @return
     */
    @SystemLog(value = "批量删除管理员")
    @RequestMapping("/sys/bachDelAdmin/{id}")
    @ResponseBody
    public ResultUtil bachDelAdmin(@PathVariable("id") String strId) {
        ResultUtil resultUtil = new ResultUtil();
        try {
            adminService.bachDelAdmin(strId);
            resultUtil.setCode(0);
        } catch (Exception e) {
            resultUtil.setCode(500);
            e.printStackTrace();
        }
        return resultUtil;
    }

    /**
     * 删除菜单
     *
     * @param menusId
     * @return
     */
    @SystemLog(value = "删除菜单")
    @RequestMapping("/sys/delMenusById/{id}")
    @ResponseBody
    public ResultUtil delMenusById(@PathVariable("id") Long menusId) {
        ResultUtil resultUtil = new ResultUtil();
        try {
            adminService.delMenusById(menusId);

            resultUtil.setCode(0);
        } catch (Exception e) {
            resultUtil.setCode(500);
            e.printStackTrace();
        }
        return resultUtil;
    }

    /**
     * 跳转编辑菜单
     *
     * @return
     */
    @SystemLog(value = "查看-编辑菜单页面")
    @RequestMapping("/sys/goUpdMenusById/{id}")
    public String updMenus(@PathVariable("id") Long menusId, ModelMap map) {
        TbMenus tbMenus = adminService.selMenusById(menusId);
        map.addAttribute("TbMenus", tbMenus);
        List<TbMenus> allMenus = adminService.getAllMenus();
        map.addAttribute("menus", allMenus);
        return "page/admin/editMenus";
    }

    /**
     * 编辑菜单根据标签
     *
     * @param tbMenus
     * @return
     */
    @SystemLog(value = "提交-编辑菜单")
    @RequestMapping("/sys/updateMenusById")
    @ResponseBody
    public ResultUtil updMenusById(TbMenus tbMenus) {
        System.out.println(tbMenus.getParentId());

        ResultUtil resultUtil = new ResultUtil();
        tbMenus.setSpread("false");

        if (tbMenus.getParentId() == null) {
            tbMenus.setParentId(Long.parseLong("0"));
        }
        try {
            adminService.updMenus(tbMenus);
            resultUtil.setCode(0);
        } catch (Exception e) {
            resultUtil.setCode(500);
            e.printStackTrace();
        }
        return resultUtil;
    }

    /**
     * 跳转到添加菜单页面
     *
     * @param menusId
     * @return
     */
    @SystemLog(value = "跳转-添加菜单页面")
    @RequestMapping("/sys/goAddMenus{id}")
    public String goAddMenus(@PathVariable("id") Long menusId, ModelMap map) {
        List<TbMenus> allMenus = adminService.getAllMenus();
        map.addAttribute("menus", allMenus);
        return "/page/admin/addMenus";
    }

    /**
     * 检查菜单名是否唯一
     *
     * @param title
     * @return
     */
    @RequestMapping("/sys/checkTitle")
    @ResponseBody
    public ResultUtil checkTitle(String title) {
        boolean flag = adminService.checkTitle(title);
        if (flag) {
            return new ResultUtil(500, "菜单名：" + title + "已存在，请重新填写！");
        }
        return new ResultUtil(0);
    }

    /**
     * 添加菜单
     *
     * @param tbMenus
     * @return
     */
    @SystemLog(value = "提交-添加菜单")
    @RequestMapping("/sys/addMenus")
    @ResponseBody
    public ResultUtil addMenus(TbMenus tbMenus) {
        tbMenus.setSpread("false");
        if (tbMenus.getParentId() == null) {
            tbMenus.setParentId(Long.parseLong("0"));
        }
        ResultUtil resultUtil = new ResultUtil();
        try {
            adminService.addMenus(tbMenus);
            resultUtil.setCode(0);
        } catch (Exception e) {
            e.printStackTrace();
            resultUtil.setCode(500);
        }

        return resultUtil;
    }
}
