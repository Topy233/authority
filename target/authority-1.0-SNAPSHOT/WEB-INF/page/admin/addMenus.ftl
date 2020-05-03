<#include '../variable/variable.ftl'>
<html>
<head>
    <meta charset="utf-8">
    <title>添加菜单</title>
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
    <script type="text/javascript" src="${ctx }/layui/layui.js"></script>
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
        <label class="layui-form-label">菜单名</label>
        <div class="layui-input-block">
            <input type="text" id="title" class="layui-input "
                   placeholder="请输入菜单名" name="title" value="">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">父节点</label>
        <div class="layui-input-block">
            <select name="parentId" id="parentId">
                <option value="" selected></option>
                <#list menus as item>
                    <option value="${item.menuId}">${item.title}</option>
                </#list>
            </select>
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label layui-icon">图标</label>
        <div class="layui-input-block">
            <input type="text" id="icon" name="icon" class="layui-input "
                   placeholder="请输入图标字符" value="">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">链接</label>
        <div class="layui-input-block">
            <input type="text" id="href" name="href" class="layui-input  "
                   placeholder="请输入链接" value="">
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-form-item">
            <label class="layui-form-label">权限标识</label>
            <div class="layui-input-block">
                <input type="text" id="perms" name="perms" class="layui-input "
                       placeholder="请输入权限标识" value="<#--${TbMenus.perms!}-->">
            </div>
        </div>
        <div class="layui-form-item">


            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button class="layui-btn" lay-submit="" lay-filter="addMenus">立即提交</button>
                </div>
            </div>
</form>

</body>
</html>
<script>
    layui.use(['form', 'layer', 'laydate'], function () {
        var form = layui.form;
        var layer = layui.layer;
        var laydate = layui.laydate;
        var $ = layui.jquery;


        //菜单名唯一性校验
        $("#title").blur(function () {
            var title = $("#title").val();
            //向服务器发送get或post方式请求
            var param = {"title": title};//请求参数为json格式

            if ($("#title").val().length != 0) {
                $.ajax({
                    type: "post",
                    url: ctx + "/sys/checkTitle",
                    data: param,
                    dataType: "json",
                    success: function (data) {
                        if (data.code != 0) {
                            top.layer.msg(data.msg);
                            $("#title").val("");
                            $("#title").focus();
                        }
                    }
                });
            }
        })


        //立即提交
        form.on("submit(addMenus)", function (data) {
            //弹出loading
            var index = top.layer.msg('数据提交中，请稍候', {icon: 16, time: false, shade: 0.8});
            var msg, flag = false;
            $.ajax({
                type: "post",
                url: ctx + '/sys/addMenus',
                async: false,
                data: data.field,
                dataType: "json",
                success: function (d) {
                    if (d.code == 0) {
                        msg = "菜单添加成功！";
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