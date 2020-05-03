<#include '../variable/variable.ftl'>
<html>
<head>
    <meta charset="utf-8">
    <title>管理员列表</title>
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
    <#--<link rel="stylesheet" href="${ctx }/css/list.css" media="all" />-->
    <script>
        var ctx = "${ctx}";
    </script>
</head>
<body class="childrenBody">
<input type="hidden" id="adminId"
       value="${roleId! }"/>
<blockquote class="layui-elem-quote list_search">
    <@shiro.hasPermission name="sys:admin:insert">
        <div class="layui-inline">
            <a class="layui-btn layui-btn-normal adminAdd_btn"><i
                        class="layui-icon">&#xe608;</i> 添加管理员</a>
        </div>
    </@shiro.hasPermission>
    <@shiro.hasPermission name="sys:admin:delete">
        <div class="layui-inline">
            <a class="layui-btn layui-btn-danger batchDel"><i
                        class="layui-icon">&#xe640;</i>批量删除</a>
        </div>
    </@shiro.hasPermission>
</blockquote>
<!-- 数据表格 -->
<table id="adminList" lay-filter="test" id="adminList"></table>
<script type="text/javascript" src="${ctx }/layui/layui.js"></script>
<#--	<script type="text/javascript" src="${ctx }/page/admin/adminList.js"></script>-->
<script type="text/html" id="barEdit">
    <@shiro.hasPermission name="sys:admin:update">
        <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    </@shiro.hasPermission>
    <@shiro.hasPermission name="sys:admin:delete">
        <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
    </@shiro.hasPermission>
</script>
</body>
</html>
<script>
    layui.use(['element', 'layer', 'form', 'upload', 'treeGrid', 'jquery', 'table'], function () {
        var table = layui.table;
        var element = layui.element;
        var layer = layui.layer;
        var form = layui.form;
        var upload = layui.upload;
        var treeGrid = layui.treeGrid;
        var $ = layui.jquery;


        //数据表格
        table.render({
            id: 'adminList',
            elem: '#adminList'
            , url: ctx + '/sys/getAdminList' //数据接口
            , cellMinWidth: 80
            , toolbar: true
            , limit: 10//每页默认数
            , limits: [10, 20, 30, 40]
            , cols: [[ //表头
                {type: 'checkbox'}
                , {field: 'id', title: 'ID', sort: true}
                , {field: 'username', title: '登陆名'}
                , {field: 'fullname', title: '全称'}
                , {field: 'eMail', title: '邮箱'}
                , {
                    field: 'sex', title: '性别', templet: function (d) {
                        return d.sex == '1' ? '男' : '女';
                    }
                }
                , {field: 'birthday', title: '出生日期', templet: '<div>{{ formatTime(d.birthday,"yyyy-MM-dd")}}</div>'}
                , {field: 'address', title: '地址'}
                , {field: 'phone', title: '联系方式'}
                , {field: 'roleName', title: '角色'}
                , {title: '操作', toolbar: '#barEdit'}
            ]]
            , page: true //开启分页
            , where: {timestamp: (new Date()).valueOf()}
        });


        //监听工具条
        table.on('tool(test)', function (obj) {
            var data = obj.data, adminId = $("#adminId").val();
            if (obj.event === 'del') {
                if (data.id == adminId) {
                    layer.msg("不允许删除自己！", {icon: 5});
                    return;
                }
                layer.confirm('真的删除行么', function (index) {
                    $.ajax({
                        url: ctx + '/sys/delAdminById/' + data.id,
                        type: "get",
                        success: function (d) {
                            if (d.code == 0) {
                                //obj.del();
                                layer.msg('删除成功！');
                                table.reload('adminList', {})
                            } else {
                                layer.msg("权限不足，联系超管！", {icon: 5});
                            }
                        }
                    })
                    layer.close(index);
                });
            } else if (obj.event === 'edit') {
                if (data.id == '1') {
                    layer.msg("不允许编辑此用户！", {icon: 5});
                    return;
                }
                if (data.id == adminId) {
                    layer.msg("不允许编辑自己！", {icon: 5});
                    return;
                }
                layer.open({
                    type: 2,
                    title: "编辑管理员",
                    area: ['420px', '750px'],
                    content: ctx + "/sys/editAdmin/" + data.id,//这里content是一个普通的String
                })
            }
        });


        //添加管理员
        $(".adminAdd_btn").click(function () {
            var index = layui.layer.open({
                title: "添加管理员",
                type: 2,
                content: "addAdmin",
            });
            layui.layer.full(index);
        });


        //批量删除
        $(".batchDel").click(function () {
            var checkStatus = table.checkStatus('adminList'); //idTest 即为基础参数 id 对应的值
            var data = checkStatus.data;
            var flag = false;
            var str = '';
            var adminId = $("#adminId").val();

            if (data.length > 0) {
                $.each(data, function (index, element) {
                    if (element.roleName == '超级管理员') {
                        flag = true;
                        layer.msg('超级管理员无法删除！');
                    }
                    if (element.roleId == adminId) {
                        flag = true;
                        layer.msg('无法删除自己！');
                    }

                    str += element.id + ",";

                });
                if (flag) {
                    return;
                }

                var roleStr = str.substring(0, str.length - 1);
                layer.confirm('是否将选中的全部删除？', function (index) {
                    $.ajax({
                        url: ctx + '/sys/bachDelAdmin/' + roleStr,//接口地址
                        type: "get",
                        success: function (d) {
                            if (d.code == 0) {
                                layer.msg('批量删除成功！');
                                //删除成功，刷新页面
                                table.reload('adminList', {})
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


    //格式化时间
    function formatTime(datetime, fmt) {
        if (parseInt(datetime) == datetime) {
            if (datetime.length == 10) {
                datetime = parseInt(datetime) * 1000;
            } else if (datetime.length == 13) {
                datetime = parseInt(datetime);
            }
        }
        datetime = new Date(datetime);
        var o = {
            "M+": datetime.getMonth() + 1,                 //月份
            "d+": datetime.getDate(),                    //日
            "h+": datetime.getHours(),                   //小时
            "m+": datetime.getMinutes(),                 //分
            "s+": datetime.getSeconds(),                 //秒
            "q+": Math.floor((datetime.getMonth() + 3) / 3), //季度
            "S": datetime.getMilliseconds()             //毫秒
        };
        if (/(y+)/.test(fmt))
            fmt = fmt.replace(RegExp.$1, (datetime.getFullYear() + "").substr(4 - RegExp.$1.length));
        for (var k in o)
            if (new RegExp("(" + k + ")").test(fmt))
                fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
        return fmt;
    }
</script>