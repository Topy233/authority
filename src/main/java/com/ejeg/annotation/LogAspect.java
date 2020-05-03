package com.ejeg.annotation;

import com.alibaba.druid.support.json.JSONUtils;
import com.ejeg.pojo.TbAdmin;
import com.ejeg.pojo.TbLog;
import com.ejeg.service.LogService;
import com.ejeg.util.IpUtils;
import com.ejeg.util.JsonUtils;
import com.fasterxml.jackson.annotation.JsonAutoDetect;
import org.apache.shiro.SecurityUtils;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.lang.reflect.Method;
import java.util.Date;


/**
 * 使用AOP面向切面编程的方式实现登录拦截 将请求跳转到登录页面
 */
@Aspect
@Component
public class LogAspect {

    @Autowired
    private AuditLogQueue auditLogQueue;

    @Resource
    private LogService logServiceImp;

    private static final Logger logger = LoggerFactory.getLogger(LogAspect.class);


    @Before("@annotation(com.ejeg.annotation.SystemLog)")
    public Object doBefore(JoinPoint joinPoint) {
        Object[] ob = joinPoint.getArgs();
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        HttpSession session = request.getSession();
        //读取session中的用户
        TbAdmin user = (TbAdmin) SecurityUtils.getSubject().getPrincipal();
        //请求的IP
        //String ip = request.getRemoteAddr();

        String requestURI = request.getRequestURI();

        String ip = IpUtils.getHostIp();
        String method = joinPoint.getSignature().getDeclaringTypeName() +
                "." + joinPoint.getSignature().getName();

        //获取用户请求方法的参数并序列化为JSON格式字符串
        String params = "";
        if (joinPoint.getArgs() != null && joinPoint.getArgs().length > 0) {
            System.out.println(joinPoint.getArgs().length);
            for (int i = 0; i < joinPoint.getArgs().length; i++) {
                params += JsonUtils.objectToJson(joinPoint.getArgs()[i]) + ";";
            }
        }
        try {
            String operation = getControllerMethodDescription(joinPoint);
            String username = user.getUsername();
            TbLog log = new TbLog();
            log.setCreateTime(new Date());
            log.setIp(ip);
            log.setOperation(operation);
            log.setParams(params);
            log.setUsername(username);
            log.setMethod(requestURI);
            logServiceImp.insLog(log);
            //保存数据库
        } catch (Exception e) {
            //记录本地异常日志
            logger.error("==前置通知异常==");
            logger.error("异常信息", e.getMessage());
        }

        return ob;
    }

    /**
     * 获取注解中对方法的描述信息 用于Controller层注解
     *
     * @param joinPoint 切点
     * @return 方法描述
     * @throws Exception
     */
    public static String getControllerMethodDescription(JoinPoint joinPoint) throws Exception {
        String targetName = joinPoint.getTarget().getClass().getName();
        String methodName = joinPoint.getSignature().getName();
        Object[] arguments = joinPoint.getArgs();
        Class targetClass = Class.forName(targetName);
        Method[] methods = targetClass.getMethods();
        String description = "";
        for (Method method : methods) {
            if (method.getName().equals(methodName)) {
                Class[] clazzs = method.getParameterTypes();
                if (clazzs.length == arguments.length) {
                    description = method.getAnnotation(SystemLog.class).value();
                    break;
                }
            }
        }
        return description;
    }

}
