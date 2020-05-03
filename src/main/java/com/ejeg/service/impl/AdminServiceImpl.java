package com.ejeg.service.impl;

import com.ejeg.mapper.*;
import com.ejeg.pojo.*;
import com.ejeg.service.AdminService;
import com.ejeg.util.ResultUtil;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class AdminServiceImpl implements AdminService {

    @Autowired
    private AdminMenusMapper adminMenusMapper;

    @Autowired
    private TbRolesMapper tbRolesMapper;

    @Autowired
    private TbAdminMapper tbAdminMapper;

    @Autowired
    private TbMenusMapper tbMenusMapper;

    @Autowired
    private TbRolesMenusMapper tbRolesMenusMapper;


    /**
     * 获得菜单的map
     *
     * @param tbAdmin
     * @return
     */
    @Override
    public List<Menu> getMenus(TbAdmin tbAdmin) {
        List<Menu> results = new ArrayList<>();
        List<TbMenus> menus = adminMenusMapper.getMenus(tbAdmin.getRoleId());
        for (int i = 0; i < menus.size(); i++) {
            if (menus.get(i).getParentId() == 0) {
                Menu menu = new Menu();
                menu.setTitle(menus.get(i).getTitle());
                menu.setIcon(menus.get(i).getIcon());
                menu.setHref(menus.get(i).getHref());
                menu.setSpread(menus.get(i).getSpread());
                List<Menu> menus2 = new ArrayList<>();
                for (int j = 0; j < menus.size(); j++) {
                    if (menus.get(j).getParentId() == menus.get(i).getMenuId()) {
                        Menu menu2 = new Menu();
                        menu2.setTitle(menus.get(j).getTitle());
                        menu2.setIcon(menus.get(j).getIcon());
                        menu2.setHref(menus.get(j).getHref());
                        menu2.setSpread(menus.get(j).getSpread());
                        menus2.add(menu2);
                    }
                }
                menu.setChildren(menus2);
                results.add(menu);
            }
        }
        return results;

    }


    /**
     * 获取所有角色
     *
     * @param page
     * @param limit
     * @return
     */
    @Override
    public ResultUtil getRoles(Integer page, Integer limit) {
        PageHelper.startPage(page, limit);
        TbRolesExample example = new TbRolesExample();
        List<TbRoles> list = tbRolesMapper.selectByExample(example);
        PageInfo<TbRoles> pageInfo = new PageInfo<TbRoles>(list);
        ResultUtil resultUtil = new ResultUtil();
        resultUtil.setCode(0);
        resultUtil.setCount(pageInfo.getTotal());
        resultUtil.setData(pageInfo.getList());
        return resultUtil;

    }

    /**
     * 获得所有的角色
     *
     * @return
     */
    @Override
    public List<TbRoles> getRoles() {
        TbRolesExample example = new TbRolesExample();
        List<TbRoles> list = tbRolesMapper.selectByExample(example);
        return list;
    }

    /**
     * 管理员列表
     *
     * @param page
     * @param limit
     * @return
     */
    @Override
    public ResultUtil getAdmin(Integer page, Integer limit) {
        PageHelper.startPage(page, limit);
        TbAdminExample tbAdminExample = new TbAdminExample();
        List<TbAdmin> list = tbAdminMapper.selectByExample(tbAdminExample);
        // 将roleName写进TbAdmin
        for (TbAdmin tbAdmin : list) {
            // tbAdmin.setRoleName();
            List<TbRoles> roles = getRoles();
            for (TbRoles tbRole : roles) {
                if (tbRole.getRoleId() == tbAdmin.getRoleId()) {
                    tbAdmin.setRoleName(tbRole.getRoleName());
                }
            }
        }

        PageInfo<TbAdmin> pageInfo = new PageInfo<TbAdmin>(list);
        ResultUtil resultUtil = new ResultUtil();
        resultUtil.setCode(0);
        resultUtil.setCount(pageInfo.getTotal());
        resultUtil.setData(pageInfo.getList());

        return resultUtil;
    }

    /**
     * 获得菜单的集合
     *
     * @param page
     * @param limit
     * @return
     */
    @Override
    public ResultUtil getMenusList(Integer page, Integer limit) {
        PageHelper.startPage(page, limit);
        TbMenusExample tbMenusExample = new TbMenusExample();
        List<TbMenus> list = tbMenusMapper.selectByExample(tbMenusExample);

        PageInfo<TbMenus> pageInfo = new PageInfo<>(list);
        ResultUtil resultUtil = new ResultUtil();
        resultUtil.setCode(0);
        resultUtil.setCount(pageInfo.getTotal());
        resultUtil.setData(pageInfo.getList());

        return resultUtil;
    }

    /**
     * 删除角色
     *
     * @param roleId
     * @return
     */
    @Override
    public int deleteRole(Long roleId) {
        int a = tbRolesMapper.deleteByPrimaryKey(roleId);
        TbMenusExample tbMenusExample = new TbMenusExample();
        TbRolesMenusKey tbRolesMenusKey = new TbRolesMenusKey();
        tbRolesMenusKey.setRoleId(roleId);
        int b = tbRolesMenusMapper.deleteRoleId(roleId);

        return a + b;
    }


    /**
     * 编辑角色
     *
     * @param role
     * @return
     */
    @Override
    public TbRoles editRole(TbRoles role) {
        return tbRolesMapper.selectByPrimaryKey(role.getRoleId());
    }

    /**
     * tree数据（指定）
     *
     * @param tbAdmin
     * @return
     */
    @Override
    public List<TbMenus> geTreeData(TbAdmin tbAdmin) {
        TbMenusExample tbMenusExample = new TbMenusExample();
        List<TbMenus> allMenus = tbMenusMapper.selectByExample(tbMenusExample);
        Long roleId = tbAdmin.getRoleId();
        if (!roleId.equals(Long.valueOf("-1"))) {
            TbRolesMenusExample tbRolesMenusExample = new TbRolesMenusExample();
            TbRolesMenusExample.Criteria criteria = tbRolesMenusExample.createCriteria();
            criteria.andRoleIdEqualTo(roleId);
            List<TbRolesMenusKey> roleMenus = tbRolesMenusMapper.selectByExample(tbRolesMenusExample);
            for (TbMenus m : allMenus) {
                for (TbRolesMenusKey tbMenus : roleMenus) {
                    if (tbMenus.getMenuId() == m.getMenuId()) {
                        m.setChecked("true");
                    }
                }
            }
        }
        return allMenus;

    }

    /**
     * 所有的tree数据
     *
     * @return
     */
    @Override
    public List<TbMenus> getAllTreeData() {
        TbMenusExample tbMenusExample = new TbMenusExample();
        List<TbMenus> allMenus = tbMenusMapper.selectByExample(tbMenusExample);
        for (TbMenus m : allMenus) {
            m.setChecked("true");
        }
        return allMenus;
    }


    /**
     * 校验角色名是否唯一
     *
     * @param roleName
     * @return
     */
    @Override
    public boolean checkRoleName(Long roleId, String roleName) {
        TbRolesExample tbRolesExample = new TbRolesExample();
        TbRolesExample.Criteria criteria = tbRolesExample.createCriteria();
        criteria.andRoleNameEqualTo(roleName);
        if (roleId != null) {
            criteria.andRoleIdNotEqualTo(roleId);
        }
        List<TbRoles> list = tbRolesMapper.selectByExample(tbRolesExample);
        if (list.size() == 0) {
            return false;
        }
        return true;
    }


    /**
     * 添加角色
     *
     * @param tbRoles
     * @param m
     */
    @Override
    public void insRole(TbRoles tbRoles, String m) {
        tbRolesMapper.insert(tbRoles);

        String[] arr = m.split(",");
        for (int i = 0; i < arr.length; i++) {
            TbRolesMenus tbRolesMenus = new TbRolesMenus();
            tbRolesMenus.setMenuId(Long.parseLong(arr[i]));
            tbRolesMenus.setRoleId(tbRoles.getRoleId());

            tbRolesMenusMapper.insert(tbRolesMenus);
        }

    }

    /**
     * 修改角色
     *
     * @param tbRoles
     * @param m
     */
    @Override
    public void updRole(TbRoles tbRoles, String m) {
        tbRolesMapper.updateByPrimaryKey(tbRoles);
        tbRolesMenusMapper.deleteRoleId(tbRoles.getRoleId());

        String[] arr = m.split(",");
        for (int i = 0; i < arr.length; i++) {
            TbRolesMenus tbRolesMenus = new TbRolesMenus();
            tbRolesMenus.setMenuId(Long.parseLong(arr[i]));
            tbRolesMenus.setRoleId(tbRoles.getRoleId());

            tbRolesMenusMapper.insert(tbRolesMenus);
        }
    }

    /**
     * 批量删除角色
     *
     * @param roleIDStr
     */
    @Override
    public void batchDel(String roleIDStr) {
        String[] arr = roleIDStr.split(",");
        for (int i = 0; i < arr.length; i++) {
            tbRolesMapper.deleteByPrimaryKey(Long.parseLong(arr[i]));
        }

    }


    /**
     * 根据id删除管理员列表
     *
     * @param roleId
     */
    @Override
    public void delAdminById(Long roleId) {
        tbAdminMapper.deleteByPrimaryKey(roleId);
    }


    /**
     * 查询管理员列表(编辑)
     *
     * @param roleId
     * @return
     */
    @Override
    public TbAdmin getTbAdminById(Long roleId) {
        TbAdmin tbAdmin = tbAdminMapper.selectByPrimaryKey(roleId);
        TbRolesExample tbRolesExample = new TbRolesExample();
        List<TbRoles> roles = getRoles();
        tbAdmin.setList(roles);

        return tbAdmin;
    }


    /**
     * 修改权限列表
     *
     * @param tbAdmin
     */
    @Override
    public void updAdminById(TbAdmin tbAdmin) {
        TbAdmin admin = tbAdminMapper.selectByPrimaryKey(tbAdmin.getId());
        tbAdmin.setPassword(admin.getPassword());
        tbAdmin.setSalt(admin.getSalt());
        tbAdminMapper.updateByPrimaryKey(tbAdmin);
    }


    /**
     * 添加管理员
     *
     * @param tbAdmin
     */
    @Override
    public int addAdmin(TbAdmin tbAdmin) {
        int ins = tbAdminMapper.insert(tbAdmin);
        return ins;
    }


    /**
     * 批量删除管理员列表
     *
     * @param idStr
     */
    @Override
    public void bachDelAdmin(String idStr) {
        String[] arr = idStr.split(",");
        for (int i = 0; i < arr.length; i++) {
            tbAdminMapper.deleteByPrimaryKey(Long.parseLong(arr[i]));
        }
    }

    /**
     * 删除菜单根据id
     *
     * @param id
     */
    @Override
    public void delMenusById(Long id) {
        tbMenusMapper.deleteByPrimaryKey(id);
        TbRolesMenusExample tbRolesMenusExample = new TbRolesMenusExample();
        TbRolesMenusExample.Criteria criteria = tbRolesMenusExample.createCriteria();
        criteria.andMenuIdEqualTo(id);
        tbRolesMenusMapper.deleteByExample(tbRolesMenusExample);
    }

    /**
     * 查询菜单（id）
     *
     * @param menuId
     */
    @Override
    public TbMenus selMenusById(Long menuId) {
        TbMenus tbMenus = tbMenusMapper.selectByPrimaryKey(menuId);
        return tbMenus;
    }

    /**
     * 修改菜单
     *
     * @param tbMenus
     */
    @Override
    public void updMenus(TbMenus tbMenus) {
        tbMenusMapper.updateByPrimaryKey(tbMenus);
    }

    /**
     * 获得所有的菜单
     *
     * @return
     */
    @Override
    public List<TbMenus> getAllMenus() {
        TbMenusExample tbMenusExample = new TbMenusExample();
        List<TbMenus> tbMenus = tbMenusMapper.selectByExample(tbMenusExample);
        return tbMenus;
    }

    /**
     * 检查菜单名称是否唯一
     *
     * @param title
     * @return
     */
    @Override
    public boolean checkTitle(String title) {
        TbMenusExample tbMenusExample = new TbMenusExample();
        TbMenusExample.Criteria criteria = tbMenusExample.createCriteria();
        criteria.andTitleEqualTo(title);
        List<TbMenus> tbMenus = tbMenusMapper.selectByExample(tbMenusExample);
        if (tbMenus.size() > 0) {
            return true;
        }
        return false;
    }

    /**
     * 添加菜单
     *
     * @param tbMenus
     */
    @Override
    public void addMenus(TbMenus tbMenus) {
        tbMenusMapper.insert(tbMenus);
    }

    /**
     * 修改密码
     *
     * @param
     */
    @Override
    public void updPassword(TbAdmin tbAdmin) {
        tbAdminMapper.updateByPrimaryKey(tbAdmin);

    }


}
