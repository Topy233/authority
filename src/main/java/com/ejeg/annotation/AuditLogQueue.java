package com.ejeg.annotation;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;

import com.ejeg.pojo.AuditLog;
import org.springframework.stereotype.Component;

/**
 * 创建日志的存放队列
 */
@Component
public class AuditLogQueue {
    //    BlockingDequeu为双端阻塞队列，blockingQueue阻塞队列
    private BlockingQueue<AuditLog> blockingQueue = new LinkedBlockingQueue<AuditLog>();

    public void add(AuditLog auditLog) {
        blockingQueue.add(auditLog);
    }

    //poll从队列的头部获取到信息
    public AuditLog poll() throws InterruptedException {
        return blockingQueue.poll(1, TimeUnit.SECONDS);//每秒钟执行一次

    }
}
