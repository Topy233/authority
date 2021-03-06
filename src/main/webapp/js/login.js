layui.use(['form', 'layer'], function () {
    var form = layui.form,
        layer = parent.layer === undefined ? layui.layer : parent.layer,
        $ = layui.jquery;


    //登录按钮事件
    form.on("submit(login)", function (data) {
        $.ajax({
            type: "POST",
            url: ctx + "/sys/login",
            data: $("#form").serialize(),
            success: function (result) {
                if (result.code == 0) {//登录成功
                    parent.location.href = ctx + '/index';
                } else {
                    layer.msg(result.msg, {icon: 5});
                    refreshCode();
                }
            }
        });
        return false;
    })
});

//刷新验证码
function refreshCode() {
    /*    $("input[name=vcode]").val("");*/
    var captcha = document.getElementById("captcha");
    captcha.src = ctx + "/sys/vcode?t=" + new Date().getTime();
}
