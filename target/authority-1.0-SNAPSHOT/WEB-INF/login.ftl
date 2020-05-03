<#include '/page/variable/variable.ftl' /><#--引入变量-->
<head>
    <meta charset="utf-8">
    <title>登录</title>
    <link rel="stylesheet" href="/layui/css/layui.css" media="all"/>
    <link rel="stylesheet" href="/css/login.css" media="all"/>
</head>
<body>

<script>
    var ctx = "${ctx }";
</script>


<div class="video_mask"></div>
<div class="login">
    <h1>登录</h1>
    <form class="layui-form" id="form">
        <div class="layui-form-item">
            <input class="layui-input" name="username" placeholder="用户名" value="admin" lay-verify="required" type="text"
                   autocomplete="off">
        </div>
        <div class="layui-form-item">
            <input class="layui-input" name="password" placeholder="密码" value="123456" lay-verify="required"
                   type="password" autocomplete="off">
        </div>
        <div class="layui-form-item form_code">
            <input class="layui-input" style="width: 140px;" name="vcode" placeholder="验证码" lay-verify="required"
                   type="text" autocomplete="off" maxlength="4" value="aaaa">
            <div class="code"><img id="captcha" src="${ctx }/sys/vcode" width="100" height="36"
                                   onclick="refreshCode(this)"></div>
        </div>
        <button class="layui-btn login_btn" lay-submit="" lay-filter="login" id="btn">登录</button>
    </form>
</div>
<script type="text/javascript" src="${ctx }/layui/layui.js"></script>
<script type="text/javascript" src="${ctx }/js/login.js"></script>
</body>
</html>