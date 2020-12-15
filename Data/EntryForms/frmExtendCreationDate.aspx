<%@ Page Title="" Language="C#" MasterPageFile="~/Data/MasterPages/Site.master" AutoEventWireup="true" CodeFile="frmExtendCreationDate.aspx.cs" Inherits="Data_EntryForms_frmExtendCreationDate" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        var ht = 0;
        var MonthArr = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];


        function GetCurrentDate() {
            var d = new Date();
            var dat = d.getDate();
            var MonthArr = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
            if (dat < 10) {
                dat = "0" + dat.toString();
            }
            return (dat + "-" + MonthArr[d.getMonth()] + "-" + d.getFullYear());
        }

        function fnfailed() {
            alert("Due to some technical reasons, we are unable to process your request !");
            $("#dvloader").hide();
        }

        $(document).ready(function () {
            ht = $(window).height();

            $(".clsDate").datepicker({
                dateFormat: 'dd-M-yy'
            });

            $("#ddlMonth").html($("#ConatntMatter_hdnMonths").val().split("^")[0]);
            $("#ddlMonth").val($("#ConatntMatter_hdnMonths").val().split("^")[1]);

            fnGetTableData();

        });

        function fnGetTableData() {
            $("#txtfilter").val('');
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var MonthVal = $("#ddlMonth").val().split("|")[0]; //$("#txtFromDate").val();
            var YearVal = $("#ddlMonth").val().split("|")[1]; //$("#txtToDate").val();
            $("#dvloader").show();
            PageMethods.fnGetTableData(MonthVal, YearVal, fnGetTableData_pass, fnfailed);
        }
        function fnGetTableData_pass(res) {
            // alert(res);
            if (res.split("|^|")[0] == "0") {
                $("#divReport").html(res.split("|^|")[1]);

                var wid = $("#tblReport").width();
                var thead = $("#tblReport").find("thead").eq(0).html();

                $(".clsDate").datepicker({
                    dateFormat: 'dd-M-yy'
                });

                $("#divHeader").html("<table id='tblReport_header' class='table table-bordered table-sm' style='margin-top:-4px; margin-bottom:0; width:" + (wid - 1) + "px; min-width:" + (wid - 1) + "px;'><thead>" + thead + "</thead></table>");
                $("#tblReport").css("width", wid);
     
                $("#tblReport").css("min-width", wid);
                for (i = 0; i < $("#tblReport").find("th").length; i++) {
                    var th_wid = $("#tblReport").find("th")[i].clientWidth;
                    $("#tblReport_header").find("th").eq(i).css("min-width", th_wid);
                    $("#tblReport_header").find("th").eq(i).css("width", th_wid);
                    $("#tblReport").find("th").eq(i).css("min-width", th_wid);
                    $("#tblReport").find("th").eq(i).css("width", th_wid);
                    //$("#tblReport_header").find("th").eq(i).css("text-align", "center");
                }
                $("#tblReport").css("margin-top", "-" + $("#tblReport_header")[0].offsetHeight + "px");
                $("#dvloader").hide();
            }
            else {
                fnfailed();
            }
        }


        function fnSave(ctrl) {
            
            var useridextend = $(ctrl).closest("tr").attr("userid");
            var NodeID = $(ctrl).closest("tr").attr("NodeID");
            var date = $(ctrl).closest("tr").find("input[type='text']").eq(0).val();
            var month = $("#ddlMonth").val().split("|")[0];
            var year = $("#ddlMonth").val().split("|")[1];

            $("#dvloader").show();

            PageMethods.fnSave(NodeID,date, month,year,useridextend, fnSave_pass, fnfailed);
        }


        function fnSave_pass(res) {
            if (res.split("|^|")[0] == "0") {
                alert("Saved Successfully !");
                $("#dvloader").hide();
            }

        }

    </script>



    <script type="text/javascript">
        function fntypefilter() {
            var flgtr = 0;
            var filter = ($("#txtfilter").val()).toUpperCase();

            $("#tblReport").find("tbody").eq(0).find("tr").css("display", "none");
            $("#tblReport").find("tbody").eq(0).find("tr").each(function () {
                if ($(this)[0].innerText.toUpperCase().indexOf(filter) > -1) {
                    $(this).css("display", "table-row");
                    flgtr = 1;
                }
            });

            if (flgtr == 0) {
                $("#divHeader").hide();
                $("#divReport").hide();
                $("#divMsg").html("No Records found for selected Filters !");
            }
            else {
                $("#divHeader").show();
                $("#divReport").show();
                $("#divMsg").html('');
            }
        }
    </script>


    <style type="text/css">
        #divReport {
            overflow-y: auto;
        }

            #divReport td.clstdAction {
                text-align: center;
            }

            #divReport img {
                cursor: pointer;
            }

        #divHierPopupTbl table tr.Active {
            background: #C0C0C0;
        }

        .fixed-top {
            z-index: 99 !important;
        }

        #divHierSelectionTbl td,
        #divHierPopupTbl td {
            font-size: 0.7rem !important;
        }
    </style>
    <style type="text/css">
        .clsPopup {
            position: absolute;
            display: none;
            z-index: 11;
            left: 0;
            width: 400px;
            background: #fff;
            border-radius: 2px;
            border: 1px solid #ddd;
        }

        .clsPopupSec {
            padding: 5px 10px;
            border-bottom: 2px solid #aaa;
        }

        .clsPopupFilter {
            background: #ccc;
        }

        .clsPopupTypeSearch {
            background: #eee;
        }

        .clsPopupBody {
            padding: 0 10px;
            height: 180px;
            overflow-y: auto;
            border-bottom: 3px solid #eee;
        }

            .clsPopupBody table th {
                font-size: 0.7rem;
                padding: 0.4rem;
            }

            .clsPopupBody table td {
                font-size: 0.6rem;
                padding: 0.2rem;
            }

            .clsPopupBody table tbody tr {
                cursor: pointer;
            }

                .clsPopupBody table tbody tr:hover {
                    background-color: #ccc;
                }

        .clsPopupFooter {
            text-align: right;
        }

            .clsPopupFooter .button1 {
                border-radius: 4px;
                font-weight: 700;
                float: none;
                color: #fff;
            }
    </style>
    <style type="text/css">
        #tblReport tr th {
            text-align:center;
        }

        #tblReport tr td:nth-child(1) {
            width: 2%;
            text-align:center;
        }

          #tblReport tr td:nth-child(2) {
            width: 15%;
        }

        #tblReport tr td:nth-child(3) {
            width: 15%;
        }

        #tblReport tr td:nth-child(4){
            width: 15%;
        }
        
        #tblReport tr td:nth-child(5) {
            width: 5%;
        }

        #tblReport tr td:nth-child(6) {
            width: 5%;
            text-align:center;
        }

         /*table.clsReport tr th:nth-child(1) {
            width: 1%;
            min-width: 1%;
        }
           table.clsReport tr td:nth-child(1) {
            width: 1%;
            min-width: 1%;
        }

             table.clsReport tr th:nth-child(2) {
            width: 5%;
            min-width: 5%;
        }
        table.clsReport tr td:nth-child(2) {
            width: 5%;
            min-width: 5%;
        }
           table.clsReport tr th:nth-child(3) {
            width: 10%;
            min-width: 10%;
        }

        table.clsReport tr td:nth-child(3) {
            width: 10%;
            min-width: 10%;
        }

        table.clsReport tr th:nth-child(4) {
            width: 10%;
            min-width: 10%;
        }

        table.clsReport tr td:nth-child(4) {
            width: 10%;
            min-width: 10%;
        }

        

        table.clsReport tr td:nth-child(5) {
            width: 10%;
            min-width: 10%;
        }



        table.clsReport tr td:nth-child(6) {
            width: 4%;
            min-width: 4%;
        }*/
    </style>
    <style type="text/css">
        .customtooltip table {
            border-collapse: collapse;
            border-spacing: 0;
            width: 100%;
        }

            .customtooltip table > thead {
                background: #EDEEEE;
                /*color: #003DA7;*/
                text-align: left;
                border-bottom: 2px solid #003DA7 !important;
            }

                .customtooltip table > thead > tr > th,
                .customtooltip table > tbody > tr > td {
                    padding: .3rem;
                    border: 1px solid #dee2e6;
                }

            .customtooltip table > tbody > tr:nth-of-type(2n+1) {
                background-color: rgba(0,61,167,.10);
            }

            .customtooltip table > thead > tr > th:nth-of-type(2n-1),
            .customtooltip table > tbody > tr > td:nth-of-type(2n-1) {
                border-left: 3px solid #4289FF;
            }

            .customtooltip table > tbody > tr > td:nth-of-type(2n-1) {
                color: #003DA7;
            }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" runat="Server">
    <h4 class="middle-title">Extend Creation Date</h4>
    <div class="row no-gutters" style="margin-top: -10px;">
        <div class="fsw col-12" id="Filter">
            <div class="fsw_inner">
                <div class="fsw_inputBox" style="width: 13%;">
                    <div class="fsw-title">Month</div>
                    <div class="d-block">
                        <select id="ddlMonth" class="form-control form-control-sm" onchange="fnGetTableData();"></select>
                    </div>
                </div>

                <div class="fsw_inputBox" style="width: 47%;">
                    <div class="fsw-title">Search Box</div>
                    <div class="d-block">
                        <input id="txtfilter" type="text" class="form-control form-control-sm" onkeyup="fntypefilter();" placeholder="Search" />
                    </div>
                </div>
            </div>
        </div>

    </div>


    <div id="tab-content" class="tab-content">
        <!-- Tab panes 1-->
        <div role="tabpanel" class="tab-pane fade show active" style="width:70%; margin:0 auto;" id="CSTab-1">
            <%--  <div class="text-right mb-2 mt-1">
                <a class="btn btn-primary btn-sm" href="#" onclick="fnAddNew();">Add New User</a>
            </div>--%>
            <div id="divHeader"></div>
            <div id="divReport"></div>
        </div>
    </div>



    <div class="loader_bg" id="dvloader">
        <div class="loader"></div>
    </div>
    <div id="divMsg" class="clsMsg"></div>


    <asp:HiddenField ID="hdnLoginID" runat="server" />
    <asp:HiddenField ID="hdnUserID" runat="server" />
    <asp:HiddenField ID="hdnRoleID" runat="server" />
    <asp:HiddenField ID="hdnNodeID" runat="server" />
    <asp:HiddenField ID="hdnNodeType" runat="server" />
    <asp:HiddenField ID="hdnMainRoleID" runat="server" />

    <asp:HiddenField ID="hdnMonths" runat="server" />
    <asp:HiddenField ID="hdnBucketID" runat="server" />
    <asp:HiddenField ID="hdnBucketName" runat="server" />
    <asp:HiddenField ID="hdnBucketType" runat="server" />
    <asp:HiddenField ID="hdnProductLvl" runat="server" />
    <asp:HiddenField ID="hdnLocationLvl" runat="server" />
    <asp:HiddenField ID="hdnChannelLvl" runat="server" />
    <asp:HiddenField ID="hdnSelectedHier" runat="server" />
    <asp:HiddenField ID="hdnSelectedFrmFilter" runat="server" />
    <asp:HiddenField ID="hdnBrand" runat="server" />
    <asp:HiddenField ID="hdnBrandForm" runat="server" />
</asp:Content>

