package com.ejeg.service.impl;

import com.ejeg.mapper.TbUsersMapper;
import com.ejeg.pojo.TbUsers;
import com.ejeg.pojo.TbUsersExample;
import com.ejeg.pojo.UserSearch;
import com.ejeg.service.UserService;
import com.ejeg.util.MyUtil;
import com.ejeg.util.ResultUtil;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;

import java.util.Date;
import java.util.List;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private TbUsersMapper tbUsersMapper;


    /**
     * 管理用户
     *
     * @param page
     * @param limit
     * @return
     */
    @Override
    public ResultUtil getUsers(Integer page, Integer limit) {
        PageHelper.startPage(page, limit);
        TbUsersExample tbUsersExample = new TbUsersExample();
        List<TbUsers> list = tbUsersMapper.selectByExample(tbUsersExample);
        PageInfo<TbUsers> pageInfo = new PageInfo<>(list);
        ResultUtil resultUtil = new ResultUtil();
        resultUtil.setCode(0);
        resultUtil.setData(pageInfo.getTotal());
        resultUtil.setData(pageInfo.getList());

        return resultUtil;
    }


    /**
     * 添加用户
     *
     * @param tbUsers
     * @return
     */
    @Override
    public void insUser(TbUsers tbUsers) {
        tbUsers.setPassword(DigestUtils.md5DigestAsHex(tbUsers.getPassword().getBytes()));
        String code = MyUtil.getStrUUID();
        tbUsers.seteCode(code);
        Date date = new Date();
        tbUsers.setCreateTime(date);
        tbUsers.setStatus("1");
        tbUsersMapper.insert(tbUsers);
    }

    /**
     * 删除用户（id）
     *
     * @param uid
     */
    @Override
    public void delUserById(Long uid) {
        tbUsersMapper.deleteByPrimaryKey(uid);
    }


    /**
     * 修改的用户信息
     *
     * @param uid
     * @return
     */
    @Override
    public TbUsers getTbUserById(String uid) {
        TbUsers tbUsers = tbUsersMapper.selectByPrimaryKey(Long.parseLong(uid));
        return tbUsers;
    }


    /**
     * 修改用户
     *
     * @param tbUsers
     * @return
     */
    @Override
    public int updUser(TbUsers tbUsers) {
        TbUsers user = tbUsersMapper.selectByPrimaryKey(tbUsers.getUid());
        tbUsers.setPassword(DigestUtils.md5DigestAsHex(user.getPassword().getBytes()));
        String code = MyUtil.getStrUUID();
        tbUsers.seteCode(code);
        tbUsers.setCreateTime(new Date());
        int a = tbUsersMapper.updateByPrimaryKey(tbUsers);
        return a;
    }

    /**
     * 查询用户
     *
     * @param userSearch
     * @return
     */
    @Override
    public ResultUtil searchUser(UserSearch userSearch) {
        TbUsersExample tbUsersExample = new TbUsersExample();
        TbUsersExample.Criteria criteria = tbUsersExample.createCriteria();

        if (userSearch.getNickname() != null && !"".equals(userSearch.getNickname())) {
            criteria.andNicknameLike("%" + userSearch.getNickname() + "%");
        }

        if (userSearch.getSex() != null && !"-1".equals(userSearch.getSex())) {
            criteria.andSexEqualTo(userSearch.getSex());
        }

        if (userSearch.getStatus() != null && !"-1".equals(userSearch.getStatus())) {
            criteria.andStatusEqualTo(userSearch.getStatus());
        }

        if (userSearch.getCreateTimeStart() != null && !"".equals(userSearch.getCreateTimeStart())) {
            criteria.andCreateTimeGreaterThanOrEqualTo(MyUtil.getDateByString(userSearch.getCreateTimeStart()));
        }
        if (userSearch.getCreateTimeEnd() != null && !"".equals(userSearch.getCreateTimeEnd())) {
            criteria.andCreateTimeLessThanOrEqualTo(MyUtil.getDateByString(userSearch.getCreateTimeEnd()));
        }


        List<TbUsers> list = tbUsersMapper.selectByExample(tbUsersExample);
        PageInfo<TbUsers> pageInfo = new PageInfo<TbUsers>(list);
        ResultUtil resultUtil = new ResultUtil();
        resultUtil.setCode(0);
        resultUtil.setCount(pageInfo.getTotal());
        resultUtil.setData(pageInfo.getList());
        return resultUtil;

    }


    /**
     * 批量删除用户
     *
     * @param str
     */
    @Override
    public void bachDelUser(String str) {
        String[] arr = str.split(",");
        for (int i = 0; i < arr.length; i++) {
            tbUsersMapper.deleteByPrimaryKey(Long.parseLong(arr[i]));
        }

    }
}
