<#include '../variable/variable.ftl'>
<html>
<head>
    <meta charset="utf-8">
    <title>用户列表</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport"
          content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
    <meta http-equiv="expires" content="Wed, 26 Feb 1997 08:21:57 GMT">
    <meta name="format-detection" content="telephone=no">
    <link rel="stylesheet" href="${ctx }/layui/css/layui.css" media="all"/>
    <script>
        var ctx = "${ctx}";
    </script>
    <script type="text/javascript" src="${ctx }/layui/layui.js"></script>

    <script type="text/html" id="statusTpl">

        {{#  if(d.status === '0'){ }}
        <span style="color: #FFB800;">未激活</span>
        {{#  } else if(d.status === '1'){ }}
        <span style="color: #01AAED;">正常</span>
        {{#  } else{ }}
        <span style="color: #FF5722;">禁用</span>
        {{#  } }}


    </script>
</head>
<body class="childrenBody">
<blockquote class="layui-elem-quote news_search">
    <form class="layui-form">
        <div>
            <div class="layui-inline">
                <div class="layui-input-inline">
                    <input type="text" id="nickname" value="" placeholder="请输入昵称"
                           class="layui-input search_input">
                </div>
                <div class="layui-input-inline layui-form">
                    <select name="sex" class="" id="sex">
                        <option value="-1" selected>请选择</option>
                        <option value="1">男</option>
                        <option value="0">女</option>
                    </select>
                </div>
                <div class="layui-input-inline layui-form">
                    <select name="status" class="" id="status">
                        <option value="-1">请选择账户状态</option>
                        <option value="0">未激活</option>
                        <option value="1">正常</option>
                        <option value="2">禁用</option>
                    </select>
                </div>
            </div>
        </div>
        <div style="margin-top: 1%">
            <div class="layui-inline">
                <input type="text" id="createTimeStart"
                       class="layui-input userName" name="createTimeStart"
                       placeholder="注册时间(开始)" value="">
            </div>
            <div class="layui-inline">
                <input type="text" id="createTimeEnd" class="layui-input userName"
                       name="createTimeEnd" placeholder="注册时间(结束)" value="">
            </div>
            <a class="layui-btn search_btn" lay-submit="" data-type="search"
               lay-filter="search" id="search">查询</a>
            <#--                <div class="layui-inline">
                                <a class="layui-btn layui-btn-normal userAdd_btn">添加用户</a>
                            </div>-->
            <div class="layui-inline">
                <@shiro.hasPermission name="sys:manage:delete">
                    <a class="layui-btn layui-btn-danger batchDel">批量删除</a>
                </@shiro.hasPermission>
            </div>
        </div>
</blockquote>
</form>
<div class="layui-form">
    <table id="userList" lay-filter="userManage" id="userManage"></table>
</div>
<script type="text/html" id="barEdit">
    <@shiro.hasPermission name="sys:manage:update">
        <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    </@shiro.hasPermission>
    <@shiro.hasPermission name="sys:manage:delete">
        <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
    </@shiro.hasPermission>
</script>

</body>
</html>
<script>
    layui.use(['form', 'layer', 'jquery', 'table', 'laydate'], function () {
        var table = layui.table;
        var layer = layui.layer;
        var form = layui.form;
        var $ = layui.jquery;
        var laydate = layui.laydate;


        //加载页面数据
        table.render({
            id: 'userList',
            elem: '#userList',
            url: ctx + '/user/getUserList' //数据接口
            ,
            limit: 10//每页默认数
            ,
            limits: [10, 20, 30, 40],
            cols: [[ //表头
                {
                    type: 'checkbox'
                },
                {
                    field: 'uid',
                    title: 'ID',
                    width: 60
                },
                {
                    field: 'eMail',
                    title: '邮箱'
                },
                {
                    field: 'nickname',
                    title: '昵称'
                },
                {
                    field: 'sex',
                    title: '性别',
                    templet: function (d) {
                        return d.sex == '1' ? '男' : '女';
                    }
                },
                {
                    field: 'birthday',
                    title: '出生日期',
                    templet: '<div>{{ formatTime(d.birthday,"yyyy-MM-dd")}}</div>'
                },
                {
                    field: 'address',
                    title: '地址'
                },
                {
                    field: 'phone',
                    title: '手机',
                    width: 120
                },
                {
                    field: 'status',
                    title: '状态',
                    templet: '#statusTpl'
                },
                {
                    field: 'createTime',
                    title: '注册日期',
                    templet: '<div>{{ formatTime(d.createTime,"yyyy-MM-dd hh:mm:ss")}}</div>'
                }, {
                    title: '操作',
                    toolbar: '#barEdit'
                }]],
            page: true
            , where: {timestamp: (new Date()).valueOf()}
            //开启分页
        });


        //渲染日期控件
        var start = laydate.render({
            elem: '#createTimeStart',
            type: 'datetime',
            max: new Date().valueOf(),
            btns: ['clear', 'confirm'],
            done: function (value, date) {
                endMax = end.config.max;
                end.config.min = date;
                end.config.min.month = date.month - 1;
            }
        });


        var end = laydate.render({
            elem: '#createTimeEnd',
            type: 'datetime',
            max: new Date().valueOf(),
            done: function (value, date) {
                if ($.trim(value) == '') {
                    var curDate = new Date();
                    date = {
                        'date': curDate.getDate(),
                        'month': curDate.getMonth() + 1,
                        'year': curDate.getFullYear()
                    };
                }
                start.config.max = date;
                start.config.max.month = date.month - 1;
            }
        })


        //监听工具事件
        table.on('tool(userManage)', function (obj) {
            var data = obj.data;
            if (obj.event === 'del') {
                layer.confirm('真的删除行么', function (index) {
                    $.ajax({
                        url: ctx + '/sys/delUserById/' + data.uid,
                        type: "get",
                        success: function (d) {
                            if (d.code == 0) {
                                obj.del();
                            } else {
                                layer.msg("权限不足！", {
                                    icon: 5
                                });
                            }
                        }
                    })
                    layer.close(index);
                });
            } else if (obj.event === 'edit') {
                layer.open({
                    type: 2,
                    title: "编辑用户",
                    area: ['500px', '650px'],
                    content: ctx + "/user/editUser/" + data.uid
                })
            }

        });


        //查询
        $(".search_btn").click(function () {
            var nickname = $('#nickname');
            var sex = $('#sex');
            var status = $('#status');
            var createTimeStart = $('#createTimeStart');
            var createTimeEnd = $('#createTimeEnd');

            //表格重载
            table.reload('userList', {
                url: '/user/searchUser'
                , where: {
                    nickname: nickname.val(),
                    sex: sex.val(),
                    status: status.val(),
                    createTimeStart: createTimeStart.val(),
                    createTimeEnd: createTimeEnd.val(),
                } //设定异步数据接口的额外参数

            });
        })


        //批量删除
        $(".batchDel").click(function () {
            var checkStatus = table.checkStatus('userList'); //idTest 即为基础参数 id 对应的值
            var data = checkStatus.data;

            var str = '';
            if (data.length > 0) {
                $.each(data, function (index, element) {
                    str += element.uid + ",";
                });

                var uidStr = str.substring(0, str.length - 1);
                layer.confirm('是否将选中的全部删除？', function (index) {
                    $.ajax({
                        url: ctx + '/sys/bachDelUser/' + uidStr,//接口地址
                        type: "get",
                        success: function (d) {
                            if (d.code == 0) {
                                layer.msg('批量删除成功！');
                                //删除成功，刷新页面
                                table.reload('userList', {})
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


    })


    //格式化时间
    function formatTime(datetime, fmt) {
        if (datetime == null || datetime == 0) {
            return "";
        }
        if (parseInt(datetime) == datetime) {
            if (datetime.length == 10) {
                datetime = parseInt(datetime) * 1000;
            } else if (datetime.length == 13) {
                datetime = parseInt(datetime);
            }
        }
        datetime = new Date(datetime);
        var o = {
            "M+": datetime.getMonth() + 1, //月份
            "d+": datetime.getDate(), //日
            "h+": datetime.getHours(), //小时
            "m+": datetime.getMinutes(), //分
            "s+": datetime.getSeconds(), //秒
            "q+": Math.floor((datetime.getMonth() + 3) / 3), //季度
            "S": datetime.getMilliseconds()
            //毫秒
        };
        if (/(y+)/.test(fmt))
            fmt = fmt.replace(RegExp.$1, (datetime.getFullYear() + "")
                .substr(4 - RegExp.$1.length));
        for (var k in o)
            if (new RegExp("(" + k + ")").test(fmt))
                fmt = fmt.replace(RegExp.$1,
                    (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k])
                        .substr(("" + o[k]).length)));
        return fmt;
    }
</script>