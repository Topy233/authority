package com.ejeg.pojo;

import java.io.Serializable;

public class TbRolesMenus implements Serializable {
	private Long menuId;

    private Long roleId;

    public TbRolesMenus() {
    }

    public Long getMenuId() {
        return menuId;
    }

    public void setMenuId(Long menuId) {
        this.menuId = menuId;
    }

    public Long getRoleId() {
        return roleId;
    }

    public void setRoleId(Long roleId) {
        this.roleId = roleId;
    }


}