package com.ejeg.service;

import com.ejeg.pojo.TbLog;
import com.ejeg.pojo.UserSearch;
import com.ejeg.util.ResultUtil;

import java.util.Date;

public interface LogService {
    //添加日志
    public void insLog(TbLog log);

    //获取日志列表
    ResultUtil selLogList(Integer page, Integer limit, UserSearch search);

    //删除指定日期以前的日志
    public int delLogsByDate(Date date);
}
