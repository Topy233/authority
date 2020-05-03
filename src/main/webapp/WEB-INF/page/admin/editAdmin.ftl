<#include '../variable/variable.ftl'>
<html>
<head>
    <meta charset="utf-8">
    <title>编辑管理员</title>
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
<form class="layui-form" style="width: 80%;">
    <!-- 管理员id -->
    <input type="hidden" name="id" value=""/>
    <div class="layui-form-item">
        <label class="layui-form-label">ID</label>
        <div class="layui-input-block">
            <input type="text" id="id" class="layui-input userName"
                   lay-verify="required" readonly="readonly" name="id" value="${TbAdmin.id}">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">登录名</label>
        <div class="layui-input-block">
            <input type="text" id="username" class="layui-input userName"
                   lay-verify="required" readonly="readonly" name="username" value="${TbAdmin.username}">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">姓名</label>
        <div class="layui-input-block">
            <input type="text" name="fullname" class="layui-input userName"
                   lay-verify="required" placeholder="请输入姓名" value="${TbAdmin.fullname}">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">邮箱</label>
        <div class="layui-input-block">
            <input type="text" name="eMail" id="eMail" class="layui-input userName"
                   lay-verify="email" placeholder="请输入邮箱" value="${TbAdmin.eMail}">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">性别</label>
        <div class="layui-input-block">
            <#if TbAdmin.sex.equals("0")>
                <input type="radio" name="sex" value="1" title="男">
                <input type="radio" name="sex" value="0" title="女" checked>
            <#else>
                <input type="radio" name="sex" value="1" title="男" checked>
                <input type="radio" name="sex" value="0" title="女">
            </#if>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">出生日期</label>
        <div class="layui-input-block">
            <input type="text" id="birthday" class="layui-input userName"
                   name="birthday" lay-verify="required" placeholder="请输入出生日期"
                   value="${TbAdmin.birthday?string("yyyy-MM-dd")}">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">地址</label>
        <div class="layui-input-block">
            <input type="text" name="address" class="layui-input userName" lay-verify="required" placeholder="请输入地址"
                   value="${TbAdmin.address}">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">手机号</label>
        <div class="layui-input-block">
            <input type="text" name="phone" class="layui-input userName"
                   lay-verify="phone" placeholder="请输入手机号" value="${TbAdmin.phone}">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">分配角色</label>
        <div class="layui-input-block">
            <select name="roleId" id="roleId">
                <#list TbAdmin.list as item>
                    <#if item.roleId == TbAdmin.roleId>
                        <option value="${item.roleId}" selected>${item.roleName}</option>
                    <#else >
                        <option value="${item.roleId}">${item.roleName}</option>
                    </#if>
                </#list>
            </select>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn" lay-submit="" lay-filter="updAdmin">立即保存</button>
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

        laydate.render({
            elem: '#birthday' //指定元素
            , max: 'new Date()'
        });


        //立即提交
        form.on("submit(updAdmin)", function (data) {
            ///弹出loading
            var index = top.layer.msg('数据提交中，请稍候', {icon: 16, time: false, shade: 0.8});
            var msg;
            $.ajax({
                type: "post",
                url: ctx + "/sys/updAdmin",
                data: data.field,
                dataType: "json",
                success: function (d) {
                    if (d.code == 0) {
                        msg = "修改成功！";
                    } else {
                        msg = d.msg;
                    }
                }
            });
            setTimeout(function () {
                top.layer.close(index);
                top.layer.msg(msg);
                layer.closeAll("iframe");
                //刷新父页面
                parent.location.reload();
            }, 2000);
            return false;
        })


    })
</script>