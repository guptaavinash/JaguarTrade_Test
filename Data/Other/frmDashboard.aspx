<%@ Page Title="" Language="C#" MasterPageFile="~/Data/MasterPages/Site.master" AutoEventWireup="true" CodeFile="frmDashboard.aspx.cs" Inherits="Data_Other_frmDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        var ht = 0;
        function fnfailed() {
            alert("Due to some technical reasons, we are unable to process your request !");
            $("#dvloader").hide();
        }
        $(document).ready(function () {
            ht = $(window).height();
            fnGetTableData();
			 $('.main-box').css({
                "position":"relative"
            });
            $('.middle-align').css({
                "max-width": "98%"
            });

        });

        function fnGetTableData() {
            $("#txtfilter").val('');
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            $("#dvloader").show();
            PageMethods.fnGetTableData(LoginID, UserID, RoleID, fnGetTableData_pass, fnfailed);
        }
        function fnGetTableData_pass(res) {
            //  alert(res);
            if (res.split("|^|")[0] == "0") {
                $("#divReport").html(res.split("|^|")[1]);

                var wid = $("#tblReport").width();
                var thead = $("#tblReport").find("thead").eq(0).html();
                $("#divHeader").html("<table id='tblReport_header' class='table table-bordered table-sm' style='margin-top:100px; margin-bottom:0; width:" + (wid - 1) + "px; min-width:" + (wid - 1) + "px;'><thead>" + thead + "</thead></table>");
                $("#tblReport").css("width", wid);
                $("#tblReport").css("min-width", wid);
                for (i = 0; i < $("#tblReport").find("th").length; i++) {
                    var th_wid = $("#tblReport").find("th")[i].clientWidth;
                    $("#tblReport_header").find("th").eq(i).css("min-width", th_wid);
                    $("#tblReport_header").find("th").eq(i).css("width", th_wid);
                    $("#tblReport").find("th").eq(i).css("min-width", th_wid);
                    $("#tblReport").find("th").eq(i).css("width", th_wid);

                }
                $("#tblReport").css("margin-top", "-" + $("#tblReport_header")[0].offsetHeight + "px");
                $("#dvloader").hide();

            }
            else {
                fnfailed();
            }
        }
    </script>
    <style type="text/css">
       table.clsReport {
            width: 70%;
            margin-left:230px;
        }
        table.clsReport td:first-child {
            width: 90%;
        }
       table.clsReport > tbody > tr > td  {
                font-family: Verdana;
                font-size: 12pt;
            }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
     <%--<h4 class="middle-title">Dashboard</h4>
		<div id="tab-content" class="tab-content">
        <!-- Tab panes 1-->
        <div role="tabpanel" class="tab-pane fade show active" id="CSTab-1">
            <div id="divHeader"></div>
            <div id="divReport"></div>
        </div>
    </div>--%>
	<div class="middle-align">
        <div class="middle-align-cont">
            <img src="../../Images/JaguarLogo_l.png" />
        </div>
    </div>
    <div class="loader_bg" id="dvloader1">
        <div class="loader"></div>
    </div>
    <div class="clear"></div>
    <asp:HiddenField ID="hdnLoginID" runat="server" />
    <asp:HiddenField ID="hdnUserID" runat="server" />
    <asp:HiddenField ID="hdnRoleID" runat="server" />
    <asp:HiddenField ID="hdnNodeID" runat="server" />
    <asp:HiddenField ID="hdnNodeType" runat="server" />
    <asp:HiddenField ID="hdnMainRoleID" runat="server" />

    <asp:HiddenField ID="hdnDashboardData" runat="server" />
</asp:Content>

