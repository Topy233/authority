layui.config({
    base: "js/"
}).use(['jquery', 'element', 'layer'], function () {
    var $ = layui.jquery;
    var element = layui.element; //Tab的切换功能，切换事件监听等，需要依赖element模块


    //监听导航点击
    element.on('nav(test)', function (elem) {
        //如果不存在子级
        if ($(this).siblings().length == 0) {
            var arr = new Array();
            var flag = false;

            //拿到所有的tabs的text
            $("#top_tabs").each(function () {
                $(this).find("li").each(function () {
                    var basic = $(this).text();
                    var context = basic.substring(0, basic.length - 1);
                    arr.push(context);
                })
            })


            //当前点击的名称
            var title = $(this).text();
            $.each(arr, function (index, value) {
                if (value == title) {
                    element.tabChange('bodyTab', title);//切换tab*/
                    flag = true;
                    return;
                }

            });


            var url = $(this).attr("path");
            if (!flag) {
                //新增一个Tab项
                element.tabAdd('bodyTab', {
                    title: elem.text(), //用于演示
                    content: '<iframe src="' + url + '"></iframe>',//支持传入html
                    id: title,//实际使用一般是规定好的id，这里以时间戳模拟下
                })
                element.tabChange('bodyTab', title);//切换tab*/
            }

        }

    })


});


