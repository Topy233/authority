package com.ejeg.mapper;

import com.ejeg.pojo.TbRolesMenus;
import com.ejeg.pojo.TbRolesMenusExample;
import com.ejeg.pojo.TbRolesMenusKey;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface TbRolesMenusMapper {
    long countByExample(TbRolesMenusExample example);

    int deleteByExample(TbRolesMenusExample example);

    int deleteByPrimaryKey(TbRolesMenusKey key);

    int insert(TbRolesMenus record);

    int insertSelective(TbRolesMenusKey record);

    List<TbRolesMenusKey> selectByExample(TbRolesMenusExample example);

    int updateByExampleSelective(@Param("record") TbRolesMenusKey record, @Param("example") TbRolesMenusExample example);

    int updateByExample(@Param("record") TbRolesMenusKey record, @Param("example") TbRolesMenusExample example);

    int deleteRoleId(long roleId);
}