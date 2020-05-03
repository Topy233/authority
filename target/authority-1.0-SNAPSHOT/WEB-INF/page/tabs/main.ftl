<#include '../variable/variable.ftl' /><#--引入变量-->
<html>
<head>
    <meta charset="utf-8">
    <title>后台首页</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <link rel="stylesheet" href="${ctx}/layui/css/layui.css" media="all"/>
    <#--    <link rel="stylesheet" href="${ctx}/css/font_eolqem241z66flxr.css" media="all" />-->
    <link rel="stylesheet" href="${ctx}/css/main.css" media="all"/>
    <script type="text/javascript" src="${ctx}/js/echarts.js"></script>
</head>
<body class="childrenBody" style="margin: 1%">
<blockquote class="layui-elem-quote">
    <p>欢迎使用Layui后台管理系统！</p>

</blockquote>
<fieldset class="layui-elem-field layui-field-title">
    <legend>信息统计</legend>
</fieldset>
<div>
    <table class="layui-table">
        <colgroup>
            <col width="150">
            <col width="200">
            <col>
        </colgroup>
        <thead>
        <tr>
            <th><strong>统计</strong></th>
            <th><strong>用户</strong></th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>总数</td>
            <td class="userTotal">85624</td>
        </tr>
        <tr>
            <td>今日</td>
            <td class="usersToday">186</td>
        </tr>
        <tr>
            <td>昨日</td>
            <td class="usersYestoday">324</td>
        </tr>
        <tr>
            <td>本周</td>
            <td class="usersYearWeek">845</td>
        </tr>
        <tr>
            <td>本月</td>
            <td class="usersMonth">3564</td>
        </tr>
        </tbody>
    </table>
</div>
<#--<fieldset class="layui-elem-field layui-field-title">
    <legend>网站用户性别占比</legend>
</fieldset>
<div id="info" style="width: 600px; height: 400px;"></div>-->


<div class="sysNotice col">
    <blockquote class="layui-elem-quote title">系统基本参数</blockquote>
    <table class="layui-table">
        <colgroup>
            <col width="150">
            <col>
        </colgroup>
        <tbody>
        <tr>
            <td>当前版本</td>
            <td class="version">测试版</td>
        </tr>
        <tr>
            <td>开发作者</td>
            <td class="author">admin</td>
        </tr>
        <tr>
            <td>网站首页</td>
            <td class="homePage">http://localhost:8080/index</td>
        </tr>
        <tr>
            <td>服务器环境</td>
            <td class="server">jetty+spring+springmvc+mybatis</td>
        </tr>
        <tr>
            <td>数据库版本</td>
            <td class="dataBase">5.7</td>
        </tr>
        <tr>
            <td>最大上传限制</td>
            <td class="maxUpload">000</td>
        </tr>
        </tbody>
    </table>

</div>
</div>


<script type="text/javascript" src="${ctx}/layui/layui.js"></script>
<#--<script type="text/javascript" src="${ctx}/js/main.js"></script>-->

</body>
</html>