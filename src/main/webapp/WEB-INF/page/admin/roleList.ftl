<#include '../variable/variable.ftl'>
<html>
<head>
    <meta charset="utf-8">
    <title>角色管理</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
    <meta http-equiv="expires" content="Wed, 26 Feb 1997 08:21:57 GMT">
    <link rel="stylesheet" href="${ctx }/layui/css/layui.css" media="all"/>
    <#--<link rel="stylesheet" href="${ctx }/css/font_eolqem241z66flxr.css"
        media="all" />-->
    <#--<link rel="stylesheet" href="${ctx }/css/list.css" media="all" />-->
    <script>
        var ctx = "${ctx}";
    </script>
</head>
<body class="childrenBody">
<blockquote class="layui-elem-quote list_search">
    <@shiro.hasPermission name="sys:role:insert">
        <div class="layui-inline">
            <a class="layui-btn layui-btn-normal roleAdd_btn"><i
                        class="layui-icon">&#xe608;</i> 添加角色</a>
        </div>
    </@shiro.hasPermission>
    <@shiro.hasPermission name="sys:role:delete">
        <div class="layui-inline">
            <a class="layui-btn layui-btn-danger batchDel"
               data-type="delCheckData"><i class="layui-icon">&#xe640;</i>批量删除</a>
        </div>
    </@shiro.hasPermission>
</blockquote>
<!-- 数据表格 -->
<table id="roleList" class="roleList" lay-filter="roleList" id="roleList"></table>
<script type="text/javascript" src="${ctx }/layui/layui.js"></script>
<script type="text/html" id="barEdit">
    <@shiro.hasPermission name="sys:role:update">
        <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    </@shiro.hasPermission>
    <@shiro.hasPermission name="sys:role:delete">
        <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
    </@shiro.hasPermission>
</script>
</body>
</html>
<script>
    layui.use(['element', 'layer', 'form', 'treeGrid', 'jquery', 'table'], function () {
        var table = layui.table;
        var element = layui.element;
        var layer = layui.layer;
        var form = layui.form;
        var treeGrid = layui.treeGrid;
        var $ = layui.jquery;


        //数据表格
        table.render({
            id: 'roleList',
            elem: '#roleList'
            , url: ctx + '/sys/getRoleList' //数据接口
            , cellMinWidth: 80
            , limit: 10//每页默认数
            , limits: [10, 20, 30, 40]
            , cols: [[ //表头
                {type: 'checkbox'}
                , {field: 'roleId', title: 'ID', sort: true}
                , {field: 'roleName', title: '角色名'}
                , {field: 'roleRemark', title: '角色描述'}
                , {title: '操作', toolbar: '#barEdit'}
            ]]
            , page: true //开启分页
            , where: {timestamp: (new Date()).valueOf()}
        });


        //监听行工具事件
        table.on('tool(roleList)', function (obj) {
            var data = obj.data;

            if (obj.event === 'del') {
                layer.confirm('真的删除行么？', function (index) {
                    if (data.roleName == '超级管理员') {
                        layer.msg('超级管理员无法删除！');
                        return;
                    } else {
                        $.ajax({
                            url: ctx + '/delRole/' + data.roleId,
                            type: "get",
                            success: function (data) {
                                if (data.code == 0) {
                                    layer.msg('删除成功！')
                                    table.reload('roleList')
                                } else {
                                    layer.msg("权限不足，联系超管！", {icon: 5});
                                }
                            }
                        })
                    }
                    //obj.del();
                    layer.close(index);
                });
            } else if (obj.event === 'edit') {
                layer.open({
                    type: 2,
                    title: "编辑角色",
                    area: ['400px', '600px'],
                    content: ctx + '/sys/editRole?roleId=' + data.roleId

                })

            }
        });


        //添加角色
        $(".roleAdd_btn").click(function () {
            var index = layui.layer.open({
                title: "添加角色",
                type: 2,
                content: "addRole",
            });
            layui.layer.full(index);
        });


        //批量删除
        $(".batchDel").click(function () {
            var checkStatus = table.checkStatus('roleList'); //idTest 即为基础参数 id 对应的值
            var data = checkStatus.data;
            var flag = false;
            var str = '';

            if (data.length > 0) {
                $.each(data, function (index, element) {
                    if (element.roleName == '超级管理员') {
                        flag = true;
                        layer.msg('管理员无法删除！');
                    } else {
                        str += element.roleId + ",";
                    }
                });
                if (flag) {
                    return;
                }

                var roleStr = str.substring(0, str.length - 1);
                layer.confirm('是否将选中的全部删除？', function (index) {
                    $.ajax({
                        url: ctx + '/sys/batchDelRoles/' + roleStr,//接口地址
                        type: "get",
                        success: function (d) {
                            if (d.code == 0) {
                                layer.msg('批量删除成功！')
                                //删除成功，刷新父页面
                                table.reload('roleList', {})
                            } else {
                                layer.msg("权限不足，联系超管！", {icon: 5});
                            }
                        }
                    })
                })


            } else {
                layer.msg('请选择数据！');
            }
        })

    });
</script>