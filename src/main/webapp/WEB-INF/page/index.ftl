<#include 'variable/variable.ftl' /><#--引入变量-->
<html>
<meta charset="utf-8">
<title>LayUI后台管理系统</title>
<meta name="renderer" content="webkit">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta http-equiv="Access-Control-Allow-Origin" content="*">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="format-detection" content="telephone=no">
<link rel="icon" href="${ctx }/images/favicon.ico">
<link rel="stylesheet" href="${ctx }/layui/css/layui.css" media="all"/>
<link rel="stylesheet" href="${ctx }/css/main.css" media="all"/>
<link rel="stylesheet" href="${ctx }/css/index.css" media="all"/>

<script>
    var ctx = "${ctx }";
</script>


<body class="main_body">
<div class="layui-layout layui-layout-admin">
    <!-- 顶部 -->
    <div class="layui-header header">
        <div class="layui-main">
            <a href="#" class="logo">Layui后台管理系统</a>
            <#--<%--			<!-- 显示/隐藏菜单 &ndash;&gt;
                        <a href="javascript:;" class="iconfont hideMenu icon-menu1"></a>--%>-->
            <!-- 顶部右侧菜单 -->
            <ul class="layui-nav top_menu">
                <li class="layui-nav-item showNotice" id="showNotice" pc>
                    <img src="/images/message.png" class="layui-nav-img">
                    系统公告
                </li>
                <li class="layui-nav-item">
                    <a href="javascript:;">
                        <img src="//tva1.sinaimg.cn/crop.0.0.118.118.180/5db11ff4gw1e77d3nqrv8j203b03cweg.jpg"
                             class="layui-nav-img">
                        <@shiro.principal property="fullname" />
                    </a>
                    <dl class="layui-nav-child">
                        <dd><a onclick="updPassword()">修改密码</a></dd>
                        <dd><a href="/loginOut">退出</a></dd>
                    </dl>
                </li>
            </ul>
        </div>
    </div>
    <!-- 左侧导航 -->
    <div class="layui-side layui-bg-black">
        <div class="navBar">
            <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
            <ul class="layui-nav layui-nav-tree" lay-shrink="all" lay-filter="test">
                <#list menus as item>
                <#--				<li class="layui-nav-item layui-nav-itemed layui-this" >
                                    <a class="layui-icon layui-icon-home layui-this" href="javascript:;" onclick="goFirst()"> 后台首页</a>
                                </li>-->
                    <li class="layui-nav-item layui-icon">
                        <a class="layui-icon " href="javascript:;">${item.icon } ${item.title}</a>
                        <#if item.children?size != 0>
                            <dl class="layui-nav-child">
                                <#list item.children as item2>
                                    <dd><a class="layui-icon " href="javascript:;" data-type="tabAdd"
                                           path=${item2.href }>${item2.icon } ${item2.title }</a></dd>
                                </#list>
                            </dl>
                        </#if>
                    </li>
                </#list>
            </ul>
        </div>
    </div>
    <!-- 右侧内容 -->
    <div class="layui-body layui-form">
        <div class="layui-tab marg0 layui-icon" lay-allowclose="true" lay-filter="bodyTab" id="top_tabs_box">
            <ul class="layui-tab-title top_tab" id="top_tabs">
                <li class="layui-this first-tab layui-icon" lay-id="1"><i class="iconfont "></i><cite
                            class="layui-icon">&#xe68e; 首页</cite></li>
            </ul>
            <div class="layui-tab-content clildFrame">
                <div class="layui-tab-item layui-show">
                    <iframe src="${ctx }/main"></iframe>
                </div>
            </div>
        </div>
    </div>
</div>


<script type="text/javascript" src="${ctx }/layui/layui.js"></script>
<script type="text/javascript" src="${ctx }/js/index.js"></script>
</body>
</html>

<script type="text/javascript">
    function goFirst() {
        layui.use(['jquery', 'element'], function () {
            var $ = layui.jquery;
            var element = layui.element; //Tab的切换功能，切换事件监听等，需要依赖element模块
            element.tabChange('bodyTab', 1);//切换tab*/
        });
    }


    function updPassword() {
        layui.use(['jquery', 'element', 'layer'], function () {
            var $ = layui.jquery;
            var element = layui.element; //Tab的切换功能，切换事件监听等，需要依赖element模块
            var arr = new Array();
            var flag = false;
            //拿到所有的tabs的text
            $("#top_tabs").each(function () {
                $(this).find("li").each(function () {
                    var basic = $(this).text();
                    var context = basic.substring(0, basic.length - 1);
                    arr.push(context);
                })
            })


            //当前点击的名称
            var title = '修改密码';
            $.each(arr, function (index, value) {
                if (value == title) {
                    element.tabChange('bodyTab', title);//切换tab*/
                    flag = true;
                    return;
                }

            });


            var url = '/goChangePassword';
            var title = '修改密码';

            if (!flag) {
                //新增一个Tab项
                element.tabAdd('bodyTab', {
                    title: title, //用于演示
                    content: '<iframe src="' + url + '"></iframe>',//支持传入html
                    id: title,//实际使用一般是规定好的id，这里以时间戳模拟下
                })
                element.tabChange('bodyTab', title);//切换tab*/
            }
        })

    }

</script>