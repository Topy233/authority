<#include '../variable/variable.ftl'>
<html>
<head>
    <meta charset="utf-8">
    <title>修改</title>
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

    <script type="text/javascript" src="${ctx }/layui/layui.js"></script>
</head>
<body class="childrenBody">
<form class="layui-form" style="width: 80%;" id="auf" method="post">
    <div class="layui-form-item">
        <label class="layui-form-label">编号</label>
        <div class="layui-input-block">
            <input type="text" id="uid" name="uid" class="layui-input "
                   lay-verify="required" readonly value="${TbUsers.uid! }">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">邮箱</label>
        <div class="layui-input-block">
            <input type="text" id="eMail" name="eMail" class="layui-input userName"
                   lay-verify="required" lay-verify="email" placeholder="请输入邮箱" value="${TbUsers.eMail! }">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">昵称</label>
        <div class="layui-input-block">
            <input type="text" id="nickname" class="layui-input userName"
                   lay-verify="required" placeholder="请输入昵称" name="nickname" value="${TbUsers.nickname! }">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">性别</label>
        <div class="layui-input-block">
            <#if TbUsers.sex.equals("1")>
                <input type="radio" name="sex" value="1" title="男" checked>
                <input type="radio" name="sex" value="0" title="女">
            <#else >
                <input type="radio" name="sex" value="1" title="男">
                <input type="radio" name="sex" value="0" title="女" checked>
            </#if>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">出生日期</label>
        <div class="layui-input-block">
            <input type="text" id="birthday" class="layui-input userName"
                   name="birthday" lay-verify="required" placeholder="请输入出生日期" autocomplete="off"
                   value="${TbUsers.birthday?string("yyyy-MM-dd")}">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">地址</label>
        <div class="layui-input-block">
            <input type="text" name="address" class="layui-input userName" lay-verify="required" placeholder="请输入地址"
                   value="${TbUsers.address! }">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">手机号</label>
        <div class="layui-input-block">
            <input type="text" name="phone" class="layui-input userName"
                   lay-verify="required" lay-verify="phone" placeholder="请输入手机号" value="${TbUsers.phone! }">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">账号状态</label>
        <div class="layui-input-block">
            <select name="status" id="status">
                <#if TbUsers.status.equals("0")>
                    <option value="0" selected>未激活</option>
                    <option value="1">正常</option>
                    <option value="2">禁用</option>
                <#elseif TbUsers.status.equals("1")>
                    <option value="0">未激活</option>
                    <option value="1" selected>正常</option>
                    <option value="2">禁用</option>
                <#else >
                    <option value="0">未激活</option>
                    <option value="1">正常</option>
                    <option value="2" selected>禁用</option>
                </#if>
            </select>
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn" lay-submit="" lay-filter="udpUser">立即提交</button>
        </div>
    </div>


</form>
</body>
</html>
<script>
    layui.use(['form', 'layer', 'jquery', 'laydate'], function () {
        var form = layui.form;
        var layer = layui.layer;
        var $ = layui.jquery;
        var laydate = layui.laydate;


        laydate.render({
            elem: '#birthday' //指定元素
            , max: 'new Date()'
        });


        form.on("submit(udpUser)", function (data) {
            //弹出loading
            var index = top.layer.msg('数据提交中，请稍候', {icon: 16, time: false, shade: 0.8});
            var msg, flag = false;
            $.ajax({
                type: "post",
                url: ctx + '/user/editUser',
                async: false,
                data: data.field,
                dataType: "json",
                success: function (d) {
                    if (d.code == 0) {
                        msg = "修改成功";
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
            }, 1000);
            return false;
        })

    })
</script>