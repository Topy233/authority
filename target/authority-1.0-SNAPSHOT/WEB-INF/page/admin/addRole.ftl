<#include '../variable/variable.ftl'>
<html>
<head>
    <meta charset="utf-8">
    <title>添加角色</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <link rel="stylesheet" href="${ctx }/layui/css/layui.css" media="all"/>
    <link rel="stylesheet" href="${ctx }/css/zTreeStyle/zTreeStyle.css" media="all" type="text/css"/>
    <script type="text/javascript" src="${ctx }/layui/layui.js"></script>
    <script type="text/javascript" src="${ctx }/js/jquery-1.4.4.min.js"></script>
    <script type="text/javascript" src="${ctx }/js/jquery.ztree.all.js"></script>
    <script>
        var ctx = "${ctx}";
    </script>
    <style type="text/css">
        .layui-form-item .layui-inline {
            width: 33.333%;
            float: left;
            margin-right: 0;
        }

        @media (max-width: 1240px) {
            .layui-form-item .layui-inline {
                width: 100%;
                float: none;
            }
        }
    </style>
</head>
<body class="childrenBody">
<form class="layui-form" style="width:80%;" id="arf">
    <!-- 权限提交隐藏域 -->
    <input type="hidden" id="m" name="m"/>
    <div class="layui-form-item">
        <label class="layui-form-label">角色名</label>
        <div class="layui-input-block">
            <input type="text" id="roleName" class="layui-input userName" lay-verify="required" placeholder="请输入角色名"
                   name="roleName" ">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">角色描述</label>
        <div class="layui-input-block">
            <textarea placeholder="请输入角色描述" class="layui-textarea linksDesc" lay-verify="required"
                      name="roleRemark"></textarea>
        </div>
    </div>
    <!--权限树xtree  -->
    <div class="layui-form-item">
        <label class="layui-form-label">分配权限：</label>
        <div style="padding-left:10%">
            <input id="checkAllTrue" href="#" type="button" value="全选">
            <input id="checkAllFalse" href="#" type="button" value="取消全选">
        </div>
        <ul id="xtree1" class="ztree" style="width:200px;margin-left: 105px"></ul>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn" lay-submit="" lay-filter="addRole">立即提交</button>
        </div>
    </div>
</form>
<#--<script type="text/javascript" src="${ctx }/page/admin/addRole.js"></script>-->
</body>
</html>
<script>
    layui.use(['form', 'layer', 'laydate'], function () {
        var form = layui.form;
        var layer = layui.layer;
        var laydate = layui.laydate;


        //角色名唯一性校验
        $("#roleName").blur(function () {
            var roleName = $("#roleName").val();
            //向服务器发送get或post方式请求
            var param = {"roleName": roleName};//请求参数为json格式

            if ($("#roleName").val().length != 0) {
                $.ajax({
                    type: "post",
                    url: ctx + "/sys/checkRoleName",
                    data: param,
                    dataType: "json",
                    success: function (data) {
                        if (data.code != 0) {
                            top.layer.msg(data.msg);
                            $("#roleName").val("");
                            $("#roleName").focus();
                        }
                    }
                });
            }
        })

        form.on("submit(addRole)", function (data) {
            var treeObj = $.fn.zTree.getZTreeObj("xtree1");
            var list = treeObj.getCheckedNodes(true);

            /*            for (var i = 0; i < list.length; i++) {
                            nodeJson[i] = { "name": list[i].name, "id": list[i].id };
                        }*/
            //菜单id
            var mStr = "";
            for (var i = 0; i < list.length; i++) {
                mStr += list[i].menuId + ",";

            }
            //去除字符串末尾的‘,’
            mStr = mStr.substring(0, mStr.length - 1);
            var m = $("#m");
            //将权限字符串写进隐藏域
            m.val(mStr);
            //弹出loading
            var index = top.layer.msg('数据提交中，请稍候', {icon: 16, time: false, shade: 0.8});
            var msg;
            $.ajax({
                type: "POST",
                url: ctx + "/sys/insRole",
                data: $("#arf").serialize(),
                success: function (d) {
                    if (d.code == 0) {
                        msg = "添加成功";
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

    //tree
    var menu = {
        setting: {
            view: {
                showIcon: false,
            },
            data: {
                simpleData: {
                    enable: true,
                    idKey: "menuId",
                    pIdKey: "parentId",
                },
                key: {
                    name: "title",
                }
            },
            check: {
                enable: true
            }
        },
        loadMenuTree: function () {
            $.ajax({
                type: "post",
                url: ctx + '/getAllTreeData',
                dataType: "json",
                success: function (data) {
                    $.fn.zTree.init($("#xtree1"), menu.setting, data);
                }
            })
        }
    };

    $().ready(function (data) {
        menu.loadMenuTree();
    });


    function checkNode(e) {
        var zTree = $.fn.zTree.getZTreeObj("xtree1"),
            type = e.data.type,
            nodes = zTree.getSelectedNodes();
        console.log(type.indexOf("All"));
        if (type.indexOf("All") < 0 && nodes.length == 0) {
            alert("请先选择一个节点");
        }
        if (type == "checkAllTrue") {
            zTree.checkAllNodes(true);
        } else if (type == "checkAllFalse") {
            zTree.checkAllNodes(false);
        }
    }

    $("#checkAllTrue").bind("click", {type: "checkAllTrue"}, checkNode);
    $("#checkAllFalse").bind("click", {type: "checkAllFalse"}, checkNode);

</script>
