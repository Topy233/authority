<#include '../variable/variable.ftl'>
<html>
<head>
    <meta charset="utf-8">
    <title>添加管理员</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <link rel="stylesheet" href="${ctx }/layui/css/layui.css" media="all"/>
    <script>
        var ctx = "${ctx}";
    </script>
    <style type="text/css">
        .layui-form-item .layui-inline {
            width: 33.333%;
            float: left;
            margin-right: 0;
        }

        @media ( max-width: 1240px) {
            .layui-form-item .layui-inline {
                width: 100%;
                float: none;
            }
        }
    </style>
</head>
<body class="childrenBody">
<form class="layui-form" style="width: 80%;" id="aaf">
    <div class="layui-form-item">
        <label class="layui-form-label">登录名</label>
        <div class="layui-input-block">
            <input type="text" id="username" class="layui-input userName"
                   lay-verify="required" placeholder="请输入登陆名" name="username" value="">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">密码</label>
        <div class="layui-input-block">
            <input type="password" id="password" class="layui-input userName"
                   lay-verify="pass" placeholder="请输入密码" name="password" value="">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">确认密码</label>
        <div class="layui-input-block">
            <input type="password" class="layui-input userName"
                   lay-verify="repass" placeholder="请输入确认密码" value="">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">姓名</label>
        <div class="layui-input-block">
            <input type="text" name="fullname" class="layui-input userName"
                   lay-verify="required" placeholder="请输入姓名" value="">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">邮箱</label>
        <div class="layui-input-block">
            <input type="text" id="eMail" name="eMail" class="layui-input userName"
                   lay-verify="email" placeholder="请输入邮箱" value="">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">性别</label>
        <div class="layui-input-block">
            <input type="radio" name="sex" value="1" title="男" checked>
            <input type="radio" name="sex" value="0" title="女">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">出生日期</label>
        <div class="layui-input-block">
            <input type="text" id="birthday" class="layui-input userName"
                   name="birthday" lay-verify="required" placeholder="请输入出生日期" autocomplete="off">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">地址</label>
        <div class="layui-input-block">
            <input type="text" name="address" class="layui-input userName" lay-verify="required" placeholder="请输入地址"
                   value="">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">手机号</label>
        <div class="layui-input-block">
            <input type="text" name="phone" class="layui-input userName"
                   lay-verify="phone" placeholder="请输入手机号" value="">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">分配角色</label>
        <div class="layui-input-block">
            <select name="roleId" id="roleId">
                <#list list as item>
                    <option value="${item.roleId}">${item.roleName}</option>
                </#list>
            </select>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn" lay-submit="" lay-filter="addAdmin">立即提交</button>
        </div>
    </div>
</form>
<script type="text/javascript" src="${ctx }/layui/layui.js"></script>
</body>
</html>
<script>
    layui.use(['form', 'layer', 'laydate'], function () {
        var form = layui.form;
        var layer = layui.layer;
        var laydate = layui.laydate;
        var $ = layui.jquery;


        //渲染日期控件
        laydate.render({
            elem: '#birthday' //指定元素
            , max: 'new Date()'
        });


        //自定义验证规则
        form.verify({
            pass: [/(.+){6,16}$/, '密码必须6到16位']
            , repass: function (value) {
                var repassvalue = $('#password').val();
                if (value != repassvalue) {
                    return '两次输入的密码不一致!';
                }
            }
        });


        //立即提交
        form.on("submit(addAdmin)", function (data) {
            //弹出loading
            var index = top.layer.msg('数据提交中，请稍候', {icon: 16, time: false, shade: 0.8});
            var msg, flag = false;
            $.ajax({
                type: "post",
                url: ctx + '/sys/addAdmin',
                async: false,
                data: data.field,
                dataType: "json",
                success: function (d) {
                    if (d.code == 0) {
                        msg = "管理员添加成功！";
                        flag = true;
                        $("#aaf")[0].reset();
                    } else {
                        msg = d.msg;
                    }
                }
            });
            setTimeout(function () {
                top.layer.close(index);
                if (flag) {
                    top.layer.msg(msg, {icon: 1});
                } else {
                    top.layer.msg(msg, {icon: 5});
                }
                //刷新父页面
                parent.location.reload();
            }, 2000);
            return false;
        })


    })
</script>