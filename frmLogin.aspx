<%@ Page Language="VB" AutoEventWireup="false" CodeFile="frmLogin.aspx.vb" Inherits="Login" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <title><%= ConfigurationManager.AppSettings("Title").ToString().Trim()%></title>

    <link href="Images/favicon.ico" rel="shortcut icon" type="image/x-icon" />

    <!-- Latest compiled and minified CSS -->
    <link href="CSS/bootstrap.css" rel="stylesheet" type="text/css" />
    <link href="CSS/style.css" rel="stylesheet" type="text/css" />

    <!-- Latest compiled and minified JavaScript -->
    <script src="Scripts/jquery-1.12.4.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(window).on("load resize", function (e) {
			$("img.bg-img").hide();
            var $url = $("img.bg-img").attr("src");
            $('.full-background').css('backgroundImage', 'url(' + $url + ')');
		   
            $('.loginfrm').css({
                "margin-top": ($(window).height() - $(".loginfrm").outerHeight()) / 2 + "px",
                "margin-left": ($(window).width() - $(".loginfrm").outerWidth()) * 3 / 4 + "px"
            });
            $('input[type="text"], input[type="password"]').focus(function () {
                $(this).data('placeholder', $(this).attr('placeholder')).attr('placeholder', '');
            }).blur(function () {
                $(this).attr('placeholder', $(this).data('placeholder'));
            });
        });
    </script>
    <script type="text/javascript">
        function fnReset() {
            document.getElementById("txtUserName").value = "";
            document.getElementById("txtPassword").value = "";
            document.getElementById("txtUserName").focus();
            return false;
        }
        function fnValidate() {
            if (document.getElementById("txtUserName").value == "") {
                alert("User name can't be left blank");
                document.getElementById("txtUserName").focus();
                return false;
            }
            else if (document.getElementById("txtPassword").value == "") {
                alert("Password can't be left blank");
                document.getElementById("txtPassword").focus();
                return false;
            }
            else
                return true;
        }
        function fnSetFocus() {
            document.getElementById("hdnRes").value = screen.availWidth + "*" + screen.availHeight;
        }
    </script>
    
    <!-- WARNING: Respond.js doesn't work if you view the page via file: -->
    <!--[if lt IE 9]>
  <script src="Scripts/html5shiv.min.js"></script>
  <script src="Scripts/respond.min.js"></script>
<![endif]-->
</head>
<body onload="fnSetFocus();">
    <form id="form1" runat="server">
        <div class="full-background">
            <img src="Images/login-bg.jpg" class="bg-img" />
        </div>
        <div class="loginfrm cls-4">
            <div class="login-box"></div>
            <div class="login-box">
                <div class="login-box-msg">
                    <!--<asp:Image ID="imgLogo1" runat="server" ImageUrl="~/Images/p_g-logo.png" alt="RRD Logo" class="logo1" />-->
                    <h3 class="title">Login To</h3>
                    <img src="Images/JaguarLogo_l.png" alt="Jaguar Logo" class="logo1" />
                </div>
                <div class="login-box-body clearfix">
                    <div class="frm-group" data-validate="Enter username">
                        <input type="text" placeholder="Username" id="txtUserName" runat="server" name="Username" class="form-ctrl" />
                        <span class="form-ctrl-icon" data-placeholder="&#xf007;"></span>
                    </div>
                    <div class="frm-group" data-validate="Enter password">
                        <input type="password" placeholder="Password" id="txtPassword" runat="server" name="Password" class="form-ctrl" />
                        <span class="form-ctrl-icon" data-placeholder="&#xf023;"></span>
                    </div>

                </div>
                <div class="text-center"><span id="dvMessage" runat="server" class="label label-danger labeldanger"></span></div>
                <div class="login-box-footer clearfix">
                    <asp:Button ID="btnSubmit" Text="Submit" CssClass="btns btn-submit w-100" runat="server" OnClientClick="return fnValidate();" />
                </div>
            </div>
            <%--<div class="login-box alt">
                <div class="toggle"></div>
            </div>--%>
        </div>
        <input type="hidden" id="hdnRes" runat="server" name="hdnRes">
    </form>
</body>
</html>
