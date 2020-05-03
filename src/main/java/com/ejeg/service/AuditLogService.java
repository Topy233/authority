package com.ejeg.service;

import com.ejeg.pojo.AuditLog;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AuditLogService {

    /**
     * 对消息队列的日志进行批量处理
     *
     * @param auditLogList
     */
    public void batchLog(List<AuditLog> auditLogList) {
        auditLogList.parallelStream().forEach((e) -> {
            System.out.println(e.toString());
        });
    }
}