<#include '../variable/variable.ftl'>
<html>
<head>
    <meta charset="utf-8">
    <title>菜单列表</title>
    <meta name="viewport"
          content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${ctx }/layui/css/layui.css">
    <style type="text/css">
        /* 数据表格复选框正常显示 */
        .layui-table-cell .layui-form-checkbox[lay-skin="primary"] {
            top: 50%;
            transform: translateY(-50%);
        }
    </style>
    <script src="${ctx }/layui/layui.js"></script>
    <script>
        var ctx = "${ctx}";
    </script>

</head>
<body class="layui-layout-body" style="overflow: auto">
<br/>
<div class="layui-btn-group TableTools" style="margin-left: 10px">
    <@shiro.hasPermission name="sys:menu:insert">
        <button class="layui-btn" id="addMenu">添加菜单</button>
    </@shiro.hasPermission>
    <@shiro.hasPermission name="sys:menu:update">
        <button class="layui-btn" id="editMenu">编辑菜单</button>
    </@shiro.hasPermission>
    <@shiro.hasPermission name="sys:menu:delete">
        <button class="layui-btn layui-btn-danger" id="delMenu">删除菜单</button>
    </@shiro.hasPermission>
</div>
<div>

    <table class="layui-hidden" id="treeTable" lay-filter="treeTable"></table>
</div>
<script>
    layui.use(['element', 'layer', 'form', 'upload', 'treeGrid', 'jquery'], function () {
        var treeGrid = layui.treeGrid, form = layui.form, //很重要
            $ = layui.jquery, table = layui.table;
        var treeTable = treeGrid.render({
            id: 'treeTable',
            elem: '#treeTable',
            url: ctx + '/sys/getMenusList',
            cellMinWidth: 100,
            treeId: 'menuId'//树形id字段名称
            ,
            treeUpId: 'parentId'//树形父id字段名称
            ,
            treeShowName: 'title'//以树形式显示的字段
            ,
            cols: [[{
                field: 'menuId',
                title: ' ',
                type: 'checkbox',
                unresize: true
            }, {
                field: 'title',
                title: '菜单名'
            }, {
                field: 'icon',
                title: '图标',
                templet: '#iconTpl'
            }, {
                field: 'href',
                title: '链接'
            }, {
                field: 'perms',
                title: '权限标识'
            }
            ]],
            page: false
        });


        $("#addMenu").click(function () {
            var checkStatus = treeGrid.checkStatus('treeTable')
                , data = checkStatus.data, a = 0;
            if (data.length > 1) {
                layer.msg("只能选择一个！", {
                    icon: 5
                });
                return;
            }
            if (data != '') {
                a = data[0].menuId;
            }
            if (a == undefined || a != 1) {
                if (a == undefined) {
                    a = 0;
                }
                //添加顶级菜单
                layer.open({
                    type: 2,
                    title: "添加菜单",
                    area: ['470px', '500px'],
                    content: ctx + "/sys/goAddMenus" + a, //这里content是一个普通的String
                    end: function () {
                        location.reload();
                    }
                })
            } else {
                layer.msg("此菜单不允许操作！", {
                    icon: 5
                });
                return;
            }

        })

        $("#editMenu").click(function () {
            var checkStatus = treeGrid.checkStatus('treeTable')
                , data = checkStatus.data, a = '';
            if (data.length > 1) {
                layer.msg("只能选择一个！", {
                    icon: 5
                });
                return;
            }
            if (data != '') {
                a = data[0].menuId;
            }

            if (a == '') {
                layer.msg("请选择要操作的菜单！", {
                    icon: 5
                });
                return;
            }
            if (a == 1) {
                layer.msg("不允许操作的菜单！", {
                    icon: 5
                });
                return;
            }
            //添加顶级菜单
            layer.open({
                type: 2,
                title: "编辑菜单",
                area: ['470px', '500px'],
                content: ctx + "/sys/goUpdMenusById/" + a //这里content是一个普通的String
            })

        })

        $("#delMenu").click(function () {
            var checkStatus = treeGrid.checkStatus('treeTable')
                , data = checkStatus.data, a = '';
            if (data.length > 1) {
                layer.msg("只能选择一个！", {
                    icon: 5
                });
                return;
            }
            if (data != '') {
                a = data[0].menuId;
            }
            if (a == '') {
                layer.msg("请选择要操作的菜单！", {
                    icon: 5
                });
                return;
            }
            if (a == 1) {
                layer.msg("不允许删除！", {
                    icon: 5
                });
                return;
            }
            layer.confirm('真的删除行么', function (index) {
                $.ajax({
                    url: ctx + '/sys/delMenusById/' + a,
                    type: "post",
                    success: function (d) {
                        if (d.code == 0) {
                            layer.msg("删除成功！", {
                                icon: 1
                            });
                            setTimeout(function () {
                                treeGrid.reload("treeTable", {})
                            }, 500);
                            //刷新父页面
                            treeGrid.reload();
                        } else {
                            layer.msg(d.msg, {
                                icon: 5
                            });
                        }
                    }
                })


                layer.close(index);
            });

        })
    });
</script>

<script type="text/html" id="barTools">
    <@shiro.hasPermission name="sys:menu:update">
        <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    </@shiro.hasPermission>
    <@shiro.hasPermission name="sys:menu:delete">
        <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
    </@shiro.hasPermission>
</script>
<script type="text/html" id="iconTpl">
    {{#  if(d.icon === null){ }}

    {{#  } else{ }}
    <i class="layui-icon">{{ d.icon }}</i>
    {{#  } }}
</script>
<script type="text/html" id="radioTpl">
    <span style="top:50%"><input type="radio" name="menuId" value="{{d.menuId}}" title=" "
                                 lay-filter="radiodemo"></span>
</script>
</body>
</html>