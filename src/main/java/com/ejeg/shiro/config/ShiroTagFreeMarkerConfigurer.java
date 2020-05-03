package com.ejeg.shiro.config;

import com.jagregory.shiro.freemarker.ShiroTags;
import freemarker.template.Configuration;
import freemarker.template.TemplateException;
import org.springframework.web.servlet.view.freemarker.FreeMarkerConfigurer;

import java.io.IOException;

/**
 * 自定义FreemarkerConfigurer类
 */
public class ShiroTagFreeMarkerConfigurer extends FreeMarkerConfigurer {

    @Override
    public void afterPropertiesSet() throws IOException, TemplateException {
        // TODO Auto-generated method stub
        super.afterPropertiesSet();
        Configuration cfg = this.getConfiguration();
        //shiro标签
        cfg.setSharedVariable("shiro", new ShiroTags());
    }
}