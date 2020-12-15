<%@ Page Title="" Language="C#" MasterPageFile="~/Data/MasterPages/site.master" AutoEventWireup="true" CodeFile="frmUserAddEdit.aspx.cs" Inherits="MasterForms_frmUserAddEdit" %>

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

        });
        function Tooltip(container) {
            $(container).hover(function () {
                // Hover over code
                var title = $(this).attr('title');
                if (title != '' && title != undefined) {
                    $(this).data('tipText', title).removeAttr('title');
                    $('<p class="customtooltip"></p>')
                        .appendTo('body')
                        .css("display", "block")
                        .html(title);
                }
            }, function () {
                // Hover out code
                $(this).attr('title', $(this).data('tipText'));
                $('.customtooltip').remove();
            }).mousemove(function (e) {
                var mousex = e.pageX;   //Get X coordinates
                var mousey = ht - (e.pageY + $('.customtooltip').height() + 50) > 0 ? e.pageY : (e.pageY - $('.customtooltip').height() - 40);   //Get Y coordinates
                $('.customtooltip')
                    .css({ top: mousey, left: mousex })
            });
        }
        function fnGetTableData() {
            $("#txtfilter").val('');
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            $("#dvloader").show();
            PageMethods.fnGetTableData(LoginID, fnGetTableData_pass, fnfailed);
        }
        function fnGetTableData_pass(res) {
            // alert(res);
            if (res.split("|^|")[0] == "0") {
                $("#divReport").html(res.split("|^|")[1]);

                var wid = $("#tblReport").width();
                var thead = $("#tblReport").find("thead").eq(0).html();
                $("#divHeader").html("<table id='tblReport_header' class='table table-bordered table-sm' style='margin-top:-4px; margin-bottom:0; width:" + (wid - 1) + "px; min-width:" + (wid - 1) + "px;'><thead>" + thead + "</thead></table>");
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
                Tooltip(".clsInform");
                $("#dvloader").hide();
            }
            else {
                fnfailed();
            }
        }
    </script>

    <script type="text/javascript">
        function fnAddNew() {
            var str = "";
            str += "<tr UserID='0'  Descr='' style='display: table-row;'>";
            str += "<td></td>";
            str += "<td><input type='text' style='width:98%; box-sizing: border-box;' value=''/></td>";
            str += "<td><input type='text' style='width:98%; box-sizing: border-box;' value=''/></td>";
            str += "<td><input id='chkUserActive' type='checkbox' checked='true'/></td>";
            str += "<td><select style='width:90%; box-sizing: border-box; margin-right: 1%;' onchange='fnCheckRole(this);'>" + $("#ConatntMatter_hdnMainRoleID").val() + "</select></td>";
            str += "<td><input id='chkCorpUser' disabled='false'  type='checkbox' onclick='fnSelectCorpUser(this);'/></td>";

            str += "<td><span><input type='checkbox' disabled='false' onclick='fnSelectAll(this,1);'/><input type='text' disabled='false' iden='ProductHier' style='width:90%; box-sizing: border-box;'  ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Product..'/></span></td>";
            str += "<td><span><input type='checkbox' disabled='false' onclick='fnSelectAll(this,2);'/><input type='text' disabled='false' iden='ProductHier' style='width:90%; box-sizing: border-box;' ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 2);' placeholder='Click to select Site..'/></span></td>";
            str += "<td><span><input type='checkbox' disabled='false' onclick='fnSelectAll(this,3);'/><input type='text' disabled='false' iden='ProductHier' style='width:90%; box-sizing: border-box;'  ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 3);' placeholder='Click to select Channel..'/></span></td>";
            str += "<td class='clstdAction'><img src='../../Images/save.png' title='save' onclick='fnSave(this);' style='margin-right: 12px;'/><img src='../../Images/cancel.png' title='cancel' onclick='fnCancel(this);'/></td>";
            str += "</tr>";
            if ($("#tblReport").find("tbody").eq(0).find("tr").length == 0) {
                $("#tblReport").find("tbody").eq(0).html(str);
            }
            else {
                $("#tblReport").find("tbody").eq(0).prepend(str);
            }

        }

        function fnEdit(ctrl) {
            var UserID = $(ctrl).closest("tr").attr("UserID");
            var Name = $(ctrl).closest("tr").attr("Name");
            var EmailID = $(ctrl).closest("tr").attr("EmailID");
            var Active = $(ctrl).closest("tr").attr("Active");
            var Role = $(ctrl).closest("tr").attr("Role");
            var RoleId = $(ctrl).closest("tr").attr("RoleId");
            var CorpUser = $(ctrl).closest("tr").attr("CorpUser");


            var Prodstr = $(ctrl).closest("tr").attr("Prodstr");
            var ProdLvl = $(ctrl).closest("tr").attr("Prodselstr").split('^')[0].split('|');
            //var ProdLvl2 = ProdLvl.split('|');
            var Prodselstr = $(ctrl).closest("tr").attr("Prodselstr");



            var Locstr = $(ctrl).closest("tr").attr("Locationstr");
            var LocLvl = $(ctrl).closest("tr").attr("Locationselstr").split('^')[0].split('|');
            var Locselstr = $(ctrl).closest("tr").attr("Locationselstr");


            var Chanstr = $(ctrl).closest("tr").attr("Channelstr");
            var ChanLvl = $(ctrl).closest("tr").attr("Channelselstr").split('^')[0].split('|');
            var Chanselstr = $(ctrl).closest("tr").attr("Channelselstr");

            // alert(ProdLvl2);
            // alert(ProdLvl2[1]);
            //alert(ProdLvl[0]);
            //alert(ProdLvl[1]);
            //alert(LocLvl[1]);
            //alert(ChanLvl[1]);

            $(ctrl).closest("tr").find("td").eq(1).html("<input type='text' style='width:98%; box-sizing: border-box;' value='" + Name + "' />");
            $(ctrl).closest("tr").find("td").eq(2).html("<input type='text' style='width:98%; box-sizing: border-box;' value='" + EmailID + "' />");
            if (Active == "Yes") {
                $(ctrl).closest("tr").find("td").eq(3).html("<input id='chkUserActive' type='checkbox' checked='true'/>");
            }
            else {
                $(ctrl).closest("tr").find("td").eq(3).html("<input id='chkUserActive' type='checkbox'/>");
            }


            $(ctrl).closest("tr").find("td").eq(4).html("<select style='width:98%; box-sizing: border-box; margin-right: 1%;' onchange='fnCheckRole(this);'>" + $("#ConatntMatter_hdnMainRoleID").val() + "</select>");
            $(ctrl).closest("tr").find("td").eq(4).find("select").eq(0).val(RoleId);

            if (RoleId == "3" || RoleId == "4") {
                // alert("10");
                if (CorpUser == "1") {
                    //  alert("20");
                    $(ctrl).closest("tr").find("td").eq(5).html("<input id='chkCorpUser' type='checkbox' checked='true' onclick='fnSelectCorpUser(this);'/>");

                    $(ctrl).closest("tr").find("td").eq(6).find("span").eq(0).html("<input type='checkbox' onclick='fnSelectAll(this,1);'/><input type='text' disabled='true' iden='ProductHier' style='width:90%; box-sizing: border-box;'  ProdLvl='" + ProdLvl[1] + "' ProdHier='" + Prodselstr + "' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Product..' value='" + Prodstr + "'/>");
                    $(ctrl).closest("tr").find("td").eq(7).find("span").eq(0).html("<input type='checkbox' onclick='fnSelectAll(this,2);'/><input type='text' disabled='true' iden='ProductHier' style='width:90%; box-sizing: border-box;' ProdLvl='" + LocLvl[1] + "' ProdHier='" + Locselstr + "' onclick='fnShowProdHierPopup(this, 2);' placeholder='Click to select Site..' value='" + Locstr + "'/>");
                    $(ctrl).closest("tr").find("td").eq(8).find("span").eq(0).html("<input type='checkbox' onclick='fnSelectAll(this,3);'/><input type='text' disabled='true' iden='ProductHier' style='width:90%; box-sizing: border-box;'  ProdLvl='" + ChanLvl[1] + "' ProdHier='" + Chanselstr + "' onclick='fnShowProdHierPopup(this, 3);' placeholder='Click to select Channel..' value='" + Chanstr + "'/>");

                    $(ctrl).closest("tr").find("td").eq(6).find("input[type='checkbox']").prop("checked", true);
                    $(ctrl).closest("tr").find("td").eq(7).find("input[type='checkbox']").prop("checked", true);
                    $(ctrl).closest("tr").find("td").eq(8).find("input[type='checkbox']").prop("checked", true);

                    $(ctrl).closest("tr").find("td").eq(6).find("input[type='checkbox']").prop("disabled", true);
                    $(ctrl).closest("tr").find("td").eq(7).find("input[type='checkbox']").prop("disabled", true);
                    $(ctrl).closest("tr").find("td").eq(8).find("input[type='checkbox']").prop("disabled", true);
                }
                else {
                    // alert("30");
                    // $(ctrl).closest("tr").find("td").eq(5).html("<input type='checkbox' onclick='fnSelectCorpUser(this);'/>");
                    $(ctrl).closest("tr").find("td").eq(5).html("<input id='chkCorpUser' type='checkbox' onclick='fnSelectCorpUser(this);'/>");


                    $(ctrl).closest("tr").find("td").eq(6).find("span").eq(0).html("<input type='checkbox' onclick='fnSelectAll(this,1);'/><input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;'  ProdLvl='" + ProdLvl[1] + "' ProdHier='" + Prodselstr + "' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Product..' value='" + Prodstr + "'/>");
                    $(ctrl).closest("tr").find("td").eq(7).find("span").eq(0).html("<input type='checkbox' onclick='fnSelectAll(this,2);'/><input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;' ProdLvl='" + LocLvl[1] + "' ProdHier='" + Locselstr + "' onclick='fnShowProdHierPopup(this, 2);' placeholder='Click to select Site..' value='" + Locstr + "'/>");
                    $(ctrl).closest("tr").find("td").eq(8).find("span").eq(0).html("<input type='checkbox' onclick='fnSelectAll(this,3);'/><input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;'  ProdLvl='" + ChanLvl[1] + "' ProdHier='" + Chanselstr + "' onclick='fnShowProdHierPopup(this, 3);' placeholder='Click to select Channel..' value='" + Chanstr + "'/>");

                    $(ctrl).closest("tr").find("td").eq(6).find("input[type='checkbox']").prop("checked", false);
                    $(ctrl).closest("tr").find("td").eq(7).find("input[type='checkbox']").prop("checked", false);
                    $(ctrl).closest("tr").find("td").eq(8).find("input[type='checkbox']").prop("checked", false);

                    $(ctrl).closest("tr").find("td").eq(6).find("input[type='text']").prop("disabled", false);
                    $(ctrl).closest("tr").find("td").eq(7).find("input[type='text']").prop("disabled", false);
                    $(ctrl).closest("tr").find("td").eq(8).find("input[type='text']").prop("disabled", false);
                }
            }
            else {
                // alert("40");
                $(ctrl).closest("tr").find("td").eq(5).html("<input id='chkCorpUser' type='checkbox' onclick='fnSelectCorpUser(this);'/>");


                //$(ctrl).closest("tr").find("td").eq(6).find("span").eq(0).html("<input type='checkbox' onclick='fnSelectAll(this,1);'/><input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;'  ProdLvl='" + ProdLvl[1] + "' ProdHier='" + Prodselstr + "' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Product..' value='" + Prodstr + "'/>");
                //$(ctrl).closest("tr").find("td").eq(7).find("span").eq(0).html("<input type='checkbox' onclick='fnSelectAll(this,2);'/><input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;' ProdLvl='" + LocLvl[1] + "' ProdHier='" + Locselstr + "' onclick='fnShowProdHierPopup(this, 2);' placeholder='Click to select Site..' value='" + Locstr + "'/>");
                //$(ctrl).closest("tr").find("td").eq(8).find("span").eq(0).html("<input type='checkbox' onclick='fnSelectAll(this,3);'/><input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;'  ProdLvl='" + ChanLvl[1] + "' ProdHier='" + Chanselstr + "' onclick='fnShowProdHierPopup(this, 3);' placeholder='Click to select Channel..' value='" + Chanstr + "'/>");





                $(ctrl).closest("tr").find("td").eq(5).find("input[type='checkbox']").prop("checked", false);
                $(ctrl).closest("tr").find("td").eq(5).find("input[type='checkbox']").prop("disabled", true);

                $(ctrl).closest("tr").find("td").eq(6).find("input[type='text']").val("");
                $(ctrl).closest("tr").find("td").eq(7).find("input[type='text']").val("");
                $(ctrl).closest("tr").find("td").eq(8).find("input[type='text']").val("");

                $(ctrl).closest("tr").find("td").eq(6).find("input[type='text']").prop("disabled", true);
                $(ctrl).closest("tr").find("td").eq(7).find("input[type='text']").prop("disabled", true);
                $(ctrl).closest("tr").find("td").eq(8).find("input[type='text']").prop("disabled", true);

                $(ctrl).closest("tr").find("td").eq(6).find("input[type='checkbox']").prop("checked", false);
                $(ctrl).closest("tr").find("td").eq(7).find("input[type='checkbox']").prop("checked", false);
                $(ctrl).closest("tr").find("td").eq(8).find("input[type='checkbox']").prop("checked", false);

                $(ctrl).closest("tr").find("td").eq(6).find("input[type='checkbox']").prop("disabled", true);
                $(ctrl).closest("tr").find("td").eq(7).find("input[type='checkbox']").prop("disabled", true);
                $(ctrl).closest("tr").find("td").eq(8).find("input[type='checkbox']").prop("disabled", true);



                $(ctrl).closest("tr").find("td").eq(6).find("input[type='text']").attr("placeholder", "");
                $(ctrl).closest("tr").find("td").eq(7).find("input[type='text']").attr("placeholder", "");
                $(ctrl).closest("tr").find("td").eq(8).find("input[type='text']").attr("placeholder", "");

            }


            $(ctrl).closest("tr").find("td:last").html("<img src='../../Images/save.png' title='save' onclick='fnSave(this);' style='margin-right: 12px;'/><img src='../../Images/cancel.png' title='cancel' onclick='fnCancel(this);'/>");

        }


        function fnCancel(ctrl) {
            var UserID = $(ctrl).closest("tr").attr("UserID");
            if (UserID == "0") {
                $(ctrl).closest("tr").remove();
            }
            else {
                var Name = $(ctrl).closest("tr").attr("Name");
                var EmailID = $(ctrl).closest("tr").attr("EmailID");
                var Active = $(ctrl).closest("tr").attr("Active");
                var Role = $(ctrl).closest("tr").attr("Role");
                var RoleId = $(ctrl).closest("tr").attr("RoleId");
                var CorpUser = $(ctrl).closest("tr").attr("CorpUser");

                var Prodstr = $(ctrl).closest("tr").attr("Prodstr");
                var ProdLvl = $(ctrl).closest("tr").attr("Prodselstr").split('|');
                var Prodselstr = $(ctrl).closest("tr").attr("Prodselstr");



                var Locstr = $(ctrl).closest("tr").attr("Locationstr");
                var LocLvl = $(ctrl).closest("tr").attr("Locationselstr").split('|');
                var Locselstr = $(ctrl).closest("tr").attr("Locationselstr");


                var Chanstr = $(ctrl).closest("tr").attr("Channelstr");
                var ChanLvl = $(ctrl).closest("tr").attr("Channelselstr").split('|');
                var Chanselstr = $(ctrl).closest("tr").attr("Channelselstr");


                $(ctrl).closest("tr").find("td").eq(1).html("<span>" + Name + "</span>");
                $(ctrl).closest("tr").find("td").eq(2).html("<span>" + EmailID + "</span>");
                $(ctrl).closest("tr").find("td").eq(3).html("<span>" + Active + "</span>");
                $(ctrl).closest("tr").find("td").eq(4).html("<span>" + Role + "</span>");
                if (CorpUser == 1) {
                    $(ctrl).closest("tr").find("td").eq(5).html("<span>Yes</span>");
                }
                else {
                    $(ctrl).closest("tr").find("td").eq(5).html("<span>No</span>");
                }
                $(ctrl).closest("tr").find("td").eq(6).html("<span>" + Prodstr + "</span>");
                $(ctrl).closest("tr").find("td").eq(7).html("<span>" + Locstr + "</span>");
                $(ctrl).closest("tr").find("td").eq(8).html("<span>" + Chanstr + "</span>");
                $(ctrl).closest("tr").find("td").eq(9).html("<img src='../../Images/edit.png' onclick='fnEdit(this);'/>");
            }
        }
        function fnSave(ctrl) {
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $(ctrl).closest("tr").attr("UserID");
            var Name = $(ctrl).closest("tr").find("td").eq(1).find("input[type='text']").eq(0).val();
            var EmailID = $(ctrl).closest("tr").find("td").eq(2).find("input[type='text']").eq(0).val();
            var Status;
            if ($(ctrl).closest("tr").find("td").eq(3).find("input[type='checkbox']").is(':checked')) {
                Status = 1;
            }
            else {
                Status = 0;
            }
            // var RoleId = $(ctrl).closest("tr").attr("RoleId");
            var Role = $(ctrl).closest("tr").find("td").eq(4).find("Select").eq(0).val();
            var CorpUser;
            if ($(ctrl).closest("tr").find("td").eq(5).find("input[type='checkbox']").is(':checked')) {
                CorpUser = 1;
            }
            else {
                CorpUser = 0;
            }

            //alert(CorpUser);
            var ProductString = $(ctrl).closest("tr").find("td").eq(6).find("input[type='text'][iden='ProductHier']").eq(0).attr("ProdHier");
            if (ProductString === undefined || ProductString === null) {
                ProductString = "";
            }
            var SelectAllProduct;



            if ($(ctrl).closest("tr").find("td").eq(6).find("input[type='checkbox']").is(':checked')) {
                SelectAllProduct = 1;
            }
            else {
                SelectAllProduct = 0;
            }

            var LocationString = $(ctrl).closest("tr").find("td").eq(7).find("input[type='text'][iden='ProductHier']").eq(0).attr("ProdHier");
            if (LocationString === undefined || LocationString === null) {
                LocationString = "";
            }
            var SelectAllLocation;
            if ($(ctrl).closest("tr").find("td").eq(7).find("input[type='checkbox']").is(':checked')) {
                SelectAllLocation = 1;
            }
            else {
                SelectAllLocation = 0;
            }

            var ChannelString = $(ctrl).closest("tr").find("td").eq(8).find("input[type='text'][iden='ProductHier']").eq(0).attr("ProdHier");
            if (ChannelString === undefined || ChannelString === null) {
                ChannelString = "";
            }



            var SelectAllChannel;
            if ($(ctrl).closest("tr").find("td").eq(8).find("input[type='checkbox']").is(':checked')) {
                SelectAllChannel = 1;
            }
            else {
                SelectAllChannel = 0;
            }


            var BucketValues = [];

            var ArrTblData = [];
            var TblNodeID = 0;
            var TblNodeType = 0;
            var TblBucketTypeID = 0;

            //alert(LoginID);
            //alert(UserID);
            //alert(Name);
            //alert(EmailID);
            //alert(Status);
            //alert(Role);


            if (Name == "") {
                alert("Please enter the Name !");
                return false;
            }

            else if (EmailID == "") {
                alert("Please enter the EmailID !");
                return false;
            }
            else if (Role == "0") {
                alert("Please select the Role !");
                return false;
            }
            //else if (CorpUser == "0") {
            //    if (ProductString == "") {
            //        alert("Please select the Product/s !");
            //    }
            //    if (LocationString == "") {
            //        alert("Please select the Site/s !");
            //    }
            //    if (ChannelString == "") {
            //        alert("Please select the Channel/s !");
            //    }
            //    return false;
            //}

            //   ArrTblData.push({ NodeID: TblNodeID, NOdeType: TblNodeType, BucketTypeID: TblBucketTypeID });

            if ((Role == "3" || Role == "4") && CorpUser == "1") {
                ProductString = "";
                LocationString = "";
                ChannelString = "";
                if (SelectAllProduct == "0") {
                    for (var i = 0; i < ProductString.split("^").length; i++) {
                        BucketValues.push({
                            "col1": ProductString.split("^")[i].split("|")[0],
                            "col2": ProductString.split("^")[i].split("|")[1],
                            "col3": 1
                        });
                    }
                }

                if (SelectAllProduct == "1") {
                    //for (var i = 0; i < ProductString.split("^").length; i++) {
                    BucketValues.push({
                        "col1": 0,
                        "col2": 0,
                        "col3": 1
                    });
                    //  }
                }

                if (SelectAllLocation == "0") {
                    for (var i = 0; i < LocationString.split("^").length; i++) {
                        BucketValues.push({
                            "col1": LocationString.split("^")[i].split("|")[0],
                            "col2": LocationString.split("^")[i].split("|")[1],
                            "col3": 2
                        });
                    }
                }

                if (SelectAllLocation == "1") {
                    // for (var i = 0; i < LocationString.split("^").length; i++) {
                    BucketValues.push({
                        "col1": 0,
                        "col2": 0,
                        "col3": 2
                    });
                    // }
                }

                if (SelectAllChannel == "0") {
                    for (var i = 0; i < ChannelString.split("^").length; i++) {
                        BucketValues.push({
                            "col1": ChannelString.split("^")[i].split("|")[0],
                            "col2": ChannelString.split("^")[i].split("|")[1],
                            "col3": 3
                        });
                    }
                }
                if (SelectAllChannel == "1") {
                    // for (var i = 0; i < ChannelString.split("^").length; i++) {
                    BucketValues.push({
                        "col1": 0,
                        "col2": 0,
                        "col3": 3
                    });
                    // }
                }
            }
            else if ((Role == "3" || Role == "4") && CorpUser == "0") {
                if (SelectAllProduct == "0") {
                    for (var i = 0; i < ProductString.split("^").length; i++) {
                        if (ProductString == "") {
                            BucketValues.push({
                                "col1": 0,
                                "col2": 0,
                                "col3": 1
                            });
                        }
                        else {
                            BucketValues.push({
                                "col1": ProductString.split("^")[i].split("|")[0],
                                "col2": ProductString.split("^")[i].split("|")[1],
                                "col3": 1
                            });
                        }
                    }
                }

                if (SelectAllProduct == "1") {
                    //for (var i = 0; i < ProductString.split("^").length; i++) {
                    BucketValues.push({
                        "col1": 0,
                        "col2": 0,
                        "col3": 1
                    });
                    //  }
                }

                if (SelectAllLocation == "0") {
                    for (var i = 0; i < LocationString.split("^").length; i++) {

                        if (LocationString == "") {
                            BucketValues.push({
                                "col1": 0,
                                "col2": 0,
                                "col3": 2
                            });
                        }
                        else {
                            BucketValues.push({
                                "col1": LocationString.split("^")[i].split("|")[0],
                                "col2": LocationString.split("^")[i].split("|")[1],
                                "col3": 2
                            });
                        }
                    }
                }

                if (SelectAllLocation == "1") {
                    // for (var i = 0; i < LocationString.split("^").length; i++) {
                    BucketValues.push({
                        "col1": 0,
                        "col2": 0,
                        "col3": 2
                    });
                    // }
                }

                if (SelectAllChannel == "0") {
                    for (var i = 0; i < ChannelString.split("^").length; i++) {
                        if (ChannelString == "") {
                            BucketValues.push({
                                "col1": 0,
                                "col2": 0,
                                "col3": 3
                            });
                        }
                        else {

                            BucketValues.push({
                                "col1": ChannelString.split("^")[i].split("|")[0],
                                "col2": ChannelString.split("^")[i].split("|")[1],
                                "col3": 3
                            });
                        }
                    }
                }
                if (SelectAllChannel == "1") {
                    // for (var i = 0; i < ChannelString.split("^").length; i++) {
                    BucketValues.push({
                        "col1": 0,
                        "col2": 0,
                        "col3": 3
                    });
                    // }
                }
            }

            else {
                BucketValues.push();
                BucketValues.push({ NodeID: TblNodeID, NOdeType: TblNodeType, BucketTypeID: TblBucketTypeID });

            }








            var flg = 0;
            if (UserID != "0")
                flg = 1;

            $("#dvloader").show();
            PageMethods.fnSave(LoginID, UserID, Name, EmailID, Status, Role, BucketValues, CorpUser, ProductString, LocationString, ChannelString, fnSave_pass, fnfailed, flg);
        }

        function fnSave_pass(res, flg) {
            if (res.split("|^|")[0] == "-1") {
                alert("User already exist !");
                $("#dvloader").hide();
                fnGetTableData();
            }
            else if (res.split("|^|")[0] == "-2") {
                alert("Please Contact Administrator");
                $("#dvloader").hide();
                // fnGetTableData();
            }
            else if (res.split("|^|")[0] == "-3") {
                if (flg == 0) {
                    alert("User saved successfully !");
                }
                else {
                    alert("User update successfully !");
                }
                $("#dvloader").hide();
                fnGetTableData();
            }
            else {
                fnfailed();
            }

        }

        function fncopyprod(ctrl) {
            $(ctrl).closest("tbody").find("tr").attr("flgcopyprod", "0");
            $(ctrl).closest("tr").attr("flgcopyprod", "1");
        }

        function fnpasteprod(ctrl, cntr) {
            if ($(ctrl).closest("tbody").find("tr[flgcopyprod='1']").length > 0) {
                var tr = $(ctrl).closest("tbody").find("tr[flgcopyprod='1']").eq(0);

                var InSubD = tr.attr("InSubD");
                var ProdLvl = tr.attr("Prodselstr").split('^')[0].split('|');
                var Prodstr = tr.attr("Prodstr");
                var Prodselstr = tr.attr("Prodselstr");




                if (cntr == "1")
                    //   $(ctrl).closest("tr").find("td").eq(6).find("span").eq(0).html("<input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;'  ProdLvl='" + ProdLvl[1] + "' ProdHier='" + Prodselstr + "' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Product..' value='" + Prodstr + "'/>");
                    $(ctrl).closest("td").find("span").eq(0).html("<input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;' InSubD='" + InSubD + "' ProdLvl='" + ProdLvl[1] + "' ProdHier='" + Prodselstr + "' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Product..' value='" + Prodstr + "'/>");
                else if (cntr == "2")
                    $(ctrl).closest("td").find("span").eq(0).html("<input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;' InSubD='" + InSubD + "' ProdLvl='" + ProdLvl[1] + "' ProdHier='" + Prodselstr + "' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Site..' value='" + Prodstr + "'/>");
                else
                    $(ctrl).closest("td").find("span").eq(0).html("<input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;' InSubD='" + InSubD + "' ProdLvl='" + ProdLvl[1] + "' ProdHier='" + Prodselstr + "' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Channel..' value='" + Prodstr + "'/>");
            }
            else {
                var BucketType = cntr;
                if (BucketType == "1")
                    alert("Please select the Product/s for Mapping !");
                else if (BucketType == "2")
                    alert("Please select the Site/s for Mapping !");
                else if (BucketType == "3")
                    alert("Please select the Channel/s for Mapping !");

            }
        }

        function fnCheckRole(ctrl) {
            var RoleID = $(ctrl).val();
            // alert(RoleID);
            if (RoleID == 3 || RoleID == 4) {
                $(ctrl).closest("tr").find("td").eq(5).find("input[type='checkbox']").prop("disabled", false);

                if ($(ctrl).closest("tr").find("td").eq(5).find("input[type='checkbox']").is(':checked')) {

                    $(ctrl).closest("tr").find("td").eq(6).find("input[type='text']").prop("disabled", true);
                    $(ctrl).closest("tr").find("td").eq(7).find("input[type='text']").prop("disabled", true);
                    $(ctrl).closest("tr").find("td").eq(8).find("input[type='text']").prop("disabled", true);

                    $(ctrl).closest("tr").find("td").eq(6).find("input[type='text']").attr("placeholder", "");
                    $(ctrl).closest("tr").find("td").eq(7).find("input[type='text']").attr("placeholder", "");
                    $(ctrl).closest("tr").find("td").eq(8).find("input[type='text']").attr("placeholder", "");

                    $(ctrl).closest("tr").find("td").eq(6).find("input[type='checkbox']").prop("checked", true);
                    $(ctrl).closest("tr").find("td").eq(7).find("input[type='checkbox']").prop("checked", true);
                    $(ctrl).closest("tr").find("td").eq(8).find("input[type='checkbox']").prop("checked", true);

                    $(ctrl).closest("tr").find("td").eq(6).find("input[type='checkbox']").prop("disabled", true);
                    $(ctrl).closest("tr").find("td").eq(7).find("input[type='checkbox']").prop("disabled", true);
                    $(ctrl).closest("tr").find("td").eq(8).find("input[type='checkbox']").prop("disabled", true);
                }
                else {

                    $(ctrl).closest("tr").find("td").eq(6).html("<input type='checkbox' onclick='fnSelectAll(this,1);'/><input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;'  ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 1);' placeholder='Click to select Product..'/></span></td>");
                    $(ctrl).closest("tr").find("td").eq(7).html("<input type='checkbox' onclick='fnSelectAll(this,2);'/><input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;'  ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 2);' placeholder='Click to select Product..'/></span></td>");
                    $(ctrl).closest("tr").find("td").eq(8).html("<input type='checkbox' onclick='fnSelectAll(this,3);'/><input type='text' iden='ProductHier' style='width:90%; box-sizing: border-box;'  ProdLvl='' ProdHier='' onclick='fnShowProdHierPopup(this, 3);' placeholder='Click to select Product..'/></span></td>");

                }
            }
            else {
                $(ctrl).closest("tr").find("td").eq(5).find("input[type='checkbox']").prop("checked", false);
                $(ctrl).closest("tr").find("td").eq(5).find("input[type='checkbox']").prop("disabled", true);

                $(ctrl).closest("tr").find("td").eq(6).find("input[type='checkbox']").prop("checked", false);
                $(ctrl).closest("tr").find("td").eq(7).find("input[type='checkbox']").prop("checked", false);
                $(ctrl).closest("tr").find("td").eq(8).find("input[type='checkbox']").prop("checked", false);

                $(ctrl).closest("tr").find("td").eq(6).find("input[type='checkbox']").prop("disabled", true);
                $(ctrl).closest("tr").find("td").eq(7).find("input[type='checkbox']").prop("disabled", true);
                $(ctrl).closest("tr").find("td").eq(8).find("input[type='checkbox']").prop("disabled", true);

                $(ctrl).closest("tr").find("td").eq(6).find("input[type='text']").attr("placeholder", "");
                $(ctrl).closest("tr").find("td").eq(7).find("input[type='text']").attr("placeholder", "");
                $(ctrl).closest("tr").find("td").eq(8).find("input[type='text']").attr("placeholder", "");

                $(ctrl).closest("tr").find("td").eq(6).find("input[type='text']").val("");
                $(ctrl).closest("tr").find("td").eq(7).find("input[type='text']").val("");
                $(ctrl).closest("tr").find("td").eq(8).find("input[type='text']").val("");

                $(ctrl).closest("tr").find("td").eq(6).find("input[type='text']").prop("disabled", true);
                $(ctrl).closest("tr").find("td").eq(7).find("input[type='text']").prop("disabled", true);
                $(ctrl).closest("tr").find("td").eq(8).find("input[type='text']").prop("disabled", true);
            }
        }

        function fnSelectCorpUser(ctrl) {
            //var Role = $(ctrl).closest("tr").find("td").eq(4).find("Select").eq(0).val();
            //if (Role == "3") 

            if ($(ctrl).closest("tr").find("td").eq(5).find("input[type='checkbox']").is(':checked')) {

                $(ctrl).closest("tr").find("td").eq(6).find("input[type='text']").val("");
                $(ctrl).closest("tr").find("td").eq(7).find("input[type='text']").val("");
                $(ctrl).closest("tr").find("td").eq(8).find("input[type='text']").val("");

                $(ctrl).closest("tr").find("td").eq(6).find("input[type='text']").prop("disabled", true);
                $(ctrl).closest("tr").find("td").eq(7).find("input[type='text']").prop("disabled", true);
                $(ctrl).closest("tr").find("td").eq(8).find("input[type='text']").prop("disabled", true);

                $(ctrl).closest("tr").find("td").eq(6).find("input[type='text']").attr("placeholder", "");
                $(ctrl).closest("tr").find("td").eq(7).find("input[type='text']").attr("placeholder", "");
                $(ctrl).closest("tr").find("td").eq(8).find("input[type='text']").attr("placeholder", "");

                $(ctrl).closest("tr").find("td").eq(6).find("input[type='checkbox']").prop("checked", true);
                $(ctrl).closest("tr").find("td").eq(7).find("input[type='checkbox']").prop("checked", true);
                $(ctrl).closest("tr").find("td").eq(8).find("input[type='checkbox']").prop("checked", true);

                $(ctrl).closest("tr").find("td").eq(6).find("input[type='checkbox']").prop("disabled", true);
                $(ctrl).closest("tr").find("td").eq(7).find("input[type='checkbox']").prop("disabled", true);
                $(ctrl).closest("tr").find("td").eq(8).find("input[type='checkbox']").prop("disabled", true);
            }
            else {
                $(ctrl).closest("tr").find("td").eq(6).find("input[type='text']").prop("disabled", false);
                $(ctrl).closest("tr").find("td").eq(7).find("input[type='text']").prop("disabled", false);
                $(ctrl).closest("tr").find("td").eq(8).find("input[type='text']").prop("disabled", false);

                $(ctrl).closest("tr").find("td").eq(6).find("input[type='text']").attr("placeholder", "Click to select Product..");
                $(ctrl).closest("tr").find("td").eq(7).find("input[type='text']").attr("placeholder", "Click to select Site..");
                $(ctrl).closest("tr").find("td").eq(8).find("input[type='text']").attr("placeholder", "Click to select Channel..");

                $(ctrl).closest("tr").find("td").eq(6).find("input[type='checkbox']").prop("checked", false);
                $(ctrl).closest("tr").find("td").eq(7).find("input[type='checkbox']").prop("checked", false);
                $(ctrl).closest("tr").find("td").eq(8).find("input[type='checkbox']").prop("checked", false);

                $(ctrl).closest("tr").find("td").eq(6).find("input[type='checkbox']").prop("disabled", false);
                $(ctrl).closest("tr").find("td").eq(7).find("input[type='checkbox']").prop("disabled", false);
                $(ctrl).closest("tr").find("td").eq(8).find("input[type='checkbox']").prop("disabled", false);
            }
        }


        function fnSelectAll(ctrl, cntr) {
            if (cntr == 1) {
                if ($(ctrl).closest("tr").find("td").eq(6).find("input[type='checkbox']").is(':checked')) {
                    $(ctrl).closest("tr").find("td").eq(6).find("input[type='text']").prop("disabled", true);
                    $(ctrl).closest("tr").find("td").eq(6).find("input[type='text']").attr("placeholder", "");
                    $(ctrl).closest("tr").find("td").eq(6).find("input[type='text']").val("");
                }
                else {
                    $(ctrl).closest("tr").find("td").eq(6).find("input[type='text']").prop("disabled", false);
                    $(ctrl).closest("tr").find("td").eq(6).find("input[type='text']").attr("placeholder", "Click to select Product..");
                }
            }
            else if (cntr == 2) {
                if ($(ctrl).closest("tr").find("td").eq(7).find("input[type='checkbox']").is(':checked')) {
                    $(ctrl).closest("tr").find("td").eq(7).find("input[type='text']").prop("disabled", true);
                    $(ctrl).closest("tr").find("td").eq(7).find("input[type='text']").attr("placeholder", "");
                    $(ctrl).closest("tr").find("td").eq(7).find("input[type='text']").val("");

                }
                else {
                    $(ctrl).closest("tr").find("td").eq(7).find("input[type='text']").prop("disabled", false);
                    $(ctrl).closest("tr").find("td").eq(7).find("input[type='text']").attr("placeholder", "Click to select Site..");
                }


            }
            else {
                if ($(ctrl).closest("tr").find("td").eq(8).find("input[type='checkbox']").is(':checked')) {
                    $(ctrl).closest("tr").find("td").eq(8).find("input[type='text']").prop("disabled", true);
                    $(ctrl).closest("tr").find("td").eq(8).find("input[type='text']").attr("placeholder", "");
                    $(ctrl).closest("tr").find("td").eq(8).find("input[type='text']").val("");
                }
                else {
                    $(ctrl).closest("tr").find("td").eq(8).find("input[type='text']").prop("disabled", false);
                    $(ctrl).closest("tr").find("td").eq(8).find("input[type='text']").attr("placeholder", "Click to select Channel..");
                }
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

        function fnProdPopuptypefilter(ctrl) {
            var filter = ($(ctrl).val()).toUpperCase().split(",");
            if ($(ctrl).val().length > 2) {
                $("#chkSelectAllProd").removeAttr("checked");
                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "0");
                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "none");

                var flgValid = 0;
                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                    flgValid = 1;
                    for (var t = 0; t < filter.length; t++) {
                        if ($(this).find("td")[1].innerText.toUpperCase().indexOf(filter[t].toString().trim()) == -1) {
                            flgValid = 0;
                        }
                    }
                    if (flgValid == 1) {
                        $(this).attr("flgVisible", "1");
                        $(this).css("display", "table-row");
                    }
                });
            }
            else {
                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").attr("flgVisible", "1");
                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr").css("display", "table-row");
            }
        }

        function fnShowProdHierPopup(ctrl, cntr) {
            $("#ConatntMatter_hdnSelectedFrmFilter").val(cntr);
            $("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("tr").removeClass("Active");
            $("#divHierPopupTbl").html("<div style='font-size: 0.9rem; font-weight: 600; margin-top: 25%; text-align: center;'>Please Select the Level from Left</div>");
            $("#btnAddNewNode").hide();

            var title = "";
            //if ($("#ConatntMatter_hdnBucketType").val() == "1")
            //    title = "Product/s :";
            //else if ($("#ConatntMatter_hdnBucketType").val() == "2")
            //    title = "Site/s :";
            //else
            //    title = "Channel/s :";



            if (cntr == "1") {
                title = "Product/s :";
                $("#ProdLvl").html($("#ConatntMatter_hdnProductLvl").val());
            }
            else if (cntr == "2") {
                title = "Site/s :";
                $("#ProdLvl").html($("#ConatntMatter_hdnLocationLvl").val());
            }
            else {
                title = "Channel/s :";
                $("#ProdLvl").html($("#ConatntMatter_hdnChannelLvl").val());
            }
            $("#divHierPopup").dialog({
                "modal": true,
                "width": "92%",
                "height": "560",
                "title": title,
                open: function () {
                    var strtable = "";
                    // if ($("#ConatntMatter_hdnBucketType").val() == "1") {
                    if (cntr == "1") {
                        strtable += "<table class='table table-bordered table-sm table-hover'>";
                        strtable += "<thead>";
                        strtable += "<tr>";
                        strtable += "<th style='width:50%;'>Category</th>";
                        strtable += "<th style='width:50%;'>Brand</th>";
                        //strtable += "<th style='width:25%;'>BrandForm</th>";
                        //strtable += "<th style='width:25%;'>SubBrandForm</th>";
                        strtable += "</tr>";
                        strtable += "</thead>";
                        strtable += "<tbody>";
                        strtable += "</tbody>";
                        strtable += "</table>";
                        $("#divHierSelectionTbl").html(strtable);

                        $("#PopupHierlbl").html("Product Hierarchy");
                    }
                        // else if ($("#ConatntMatter_hdnBucketType").val() == "2") {
                    else if (cntr == "2") {
                        strtable += "<table class='table table-bordered table-sm table-hover'>";
                        strtable += "<thead>";
                        strtable += "<tr>";
                        strtable += "<th style='width:50%;'>Distributor</th>";
                        strtable += "<th style='width:50%;'>Branch</th>";
                        //strtable += "<th style='width:25%;'>SubD</th>";
                        strtable += "</tr>";
                        strtable += "</thead>";
                        strtable += "<tbody>";
                        strtable += "</tbody>";
                        strtable += "</table>";
                        $("#divHierSelectionTbl").html(strtable);

                        $("#PopupHierlbl").html("Location Hierarchy");
                        // $(".ui-dialog-buttonset").prepend("<div id='divIncludeSubd' style='text-transform: capitalize; display: inline-block; margin-right: 30px;'><input id='chkIncludeSubd' type='checkbox' checked onclick='fnSubdInclude();'/>&nbsp;SubD Included</div>");

                        if ($(ctrl).attr("InSubD") == "0") {
                            $("#chkIncludeSubd").removeAttr("checked");
                        }
                        fnSubdInclude();
                    }
                    else {
                        strtable += "<table class='table table-bordered table-sm table-hover'>";
                        strtable += "<thead>";
                        strtable += "<tr>";
                        strtable += "<th style='width:50%;'>Class</th>";
                        strtable += "<th style='width:50%;'>Channel</th>";
                        //strtable += "<th style='width:33%;'>Store Type</th>";
                        strtable += "</tr>";
                        strtable += "</thead>";
                        strtable += "<tbody>";
                        strtable += "</tbody>";
                        strtable += "</table>";
                        $("#divHierSelectionTbl").html(strtable);

                        $("#PopupHierlbl").html("Channel Hierarchy");
                    }

                    if ($(ctrl).attr("ProdLvl") != "") {
                        $("#ConatntMatter_hdnSelectedHier").val($(ctrl).attr("ProdHier"));
                        fnProdLvl($("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("td[ntype='" + $(ctrl).attr("ProdLvl") + "']").eq(0), cntr);
                    }

                    else
                        $("#ConatntMatter_hdnSelectedHier").val("");

                },
                close: function () {
                    $("#divIncludeSubd").remove();
                },
                buttons: {
                    "Select": function () {
                        fnProdSelected(ctrl);
                        $("#divHierPopup").dialog('close');
                    },
                    "Reset": function () {
                        fnHierPopupReset();
                    },
                    "Cancel": function () {
                        $("#divHierPopup").dialog('close');
                    }
                }
            });
        }
        function fnProdLvl(ctrl, cntr) {
            //  alert(cntr);
            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var UserNodeID = $("#ConatntMatter_hdnNodeID").val();
            var UserNodeType = $("#ConatntMatter_hdnNodeType").val();
            var ProdLvl = $(ctrl).attr("ntype");

            if (ProdLvl === undefined || ProdLvl === null) {
                ProdLvl = "";
            }

            //alert(LoginID);
            //alert(UserID);
            //alert(RoleID);
            //alert(UserNodeID);
            //alert(UserNodeType);
            //alert(ProdLvl);
            //alert($("#ConatntMatter_hdnSelectedFrmFilter").val());

            $("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("tr").removeClass("Active");
            $(ctrl).closest("tr").addClass("Active");

            if ($("#ConatntMatter_hdnSelectedFrmFilter").val() == "1") {
                if (ProdLvl == "30") {
                    $("#btnAddNewNode").show();
                    $("#btnAddNewNode").html("Add New BrandForm");
                    $("#btnAddNewNode").attr("onclick", "fnAddNewBrandForm(0);");

                    $("#divIncludeSubd").hide();
                }
                else if (ProdLvl == "40") {
                    $("#btnAddNewNode").show();
                    $("#btnAddNewNode").html("Add New SubBrandForm");
                    $("#btnAddNewNode").attr("onclick", "fnAddNewSBF();");

                    $("#divIncludeSubd").hide();
                }
                else if (ProdLvl == "130") {
                    $("#btnAddNewNode").hide();
                    $("#divIncludeSubd").show();
                }
                else if (ProdLvl == "140") {
                    $("#btnAddNewNode").hide();
                    $("#divIncludeSubd").show();
                }
                else {
                    $("#btnAddNewNode").hide();
                    $("#divIncludeSubd").hide();
                }
            }
            else {
                $("#btnAddNewNode").hide();
                $("#divIncludeSubd").hide();

                $("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("td[ntype='145']").eq(0).closest("tr").show();
            }

            $("#divHierPopupTbl").html("<img alt='Loading...' title='Loading...' src='../../Images/loading.gif' style='margin-top: 20%; margin-left: 40%; text-align: center;' />");

            var BucketValues = [];
            if ($("#ConatntMatter_hdnSelectedHier").val() != "") {
                var Selstr = $("#ConatntMatter_hdnSelectedHier").val();
                for (var i = 0; i < Selstr.split("^").length; i++) {
                    BucketValues.push({
                        "col1": Selstr.split("^")[i].split("|")[0],
                        "col2": Selstr.split("^")[i].split("|")[1],
                        // "col3": $("#ConatntMatter_hdnBucketType").val()
                        "col3": cntr
                    });
                }
            }

            // if ($("#ConatntMatter_hdnBucketType").val() == "1") {
            if (cntr == "1") {

                PageMethods.fnProdHier(LoginID, UserID, RoleID, UserNodeID, UserNodeType, ProdLvl, "1", BucketValues, fnProdHier_pass, fnProdHier_failed, cntr);
            }
                // else if ($("#ConatntMatter_hdnBucketType").val() == "2") {
            else if (cntr == "2") {
                var InSubD = 0;
                if ($("#chkIncludeSubd").is(":checked")) {
                    InSubD = 1;
                }

                PageMethods.fnLocationHier(LoginID, UserID, RoleID, UserNodeID, UserNodeType, ProdLvl, "1", BucketValues, InSubD, fnProdHier_pass, fnProdHier_failed, cntr);
            }
            else {

                PageMethods.fnChannelHier(LoginID, UserID, RoleID, UserNodeID, UserNodeType, ProdLvl, "1", BucketValues, fnProdHier_pass, fnProdHier_failed, cntr);
            }
        }
        function fnProdHier_pass(res, cntr) {
            //   alert(cntr);
            if (res.split("|^|")[0] == "0") {
                $("#divHierPopupTbl").html(res.split("|^|")[1]);
                if ($("#ConatntMatter_hdnSelectedHier").val() != "") {
                    $("#divHierSelectionTbl").html(res.split("|^|")[2]);
                    $("#ConatntMatter_hdnSelectedHier").val("");
                }

                if ($("#divHierSelectionTbl").find("tbody").eq(0).find("tr").length > 0) {
                    var PrevSelLvl = $("#divHierSelectionTbl").find("tbody").eq(0).find("tr").eq(0).attr("lvl");
                    var Lvl = $("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("tr.Active").eq(0).find("td").eq(0).attr("ntype");
                    if ((parseInt(PrevSelLvl) > parseInt(Lvl)) && (cntr != "2")) {
                        //   alert("Check Lvl If" + Lvl);
                        $("#divHierSelectionTbl").find("tbody").eq(0).html("");
                    }
                    else {
                        $("#divHierSelectionTbl").find("tbody").eq(0).find("tr").each(function () {
                            if (Lvl == $(this).attr("lvl")) {
                                // alert("Check Lvl else 1" + Lvl);
                                var tr = $("#divHierPopupTbl").find("table").eq(0).find("tr[nid='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']");
                                fnSelectHier(tr.eq(0), cntr);
                                var trHtml = tr[0].outerHTML;
                                tr.eq(0).remove();
                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                            }
                            else {
                                //  alert("Check Lvl Else 2" + Lvl);
                                switch (Lvl) {

                                    case "20":
                                        if ($(this).attr("lvl") == "10") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[cat='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this, cntr);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        break;
                                    case "30":
                                        if ($(this).attr("lvl") == "10") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[cat='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this, cntr);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        else if ($(this).attr("lvl") == "20") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[brand='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this, cntr);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        break;
                                    case "40":
                                        if ($(this).attr("lvl") == "10") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[cat='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this, cntr);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        else if ($(this).attr("lvl") == "20") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[brand='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this, cntr);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        else if ($(this).attr("lvl") == "30") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[bf='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this, cntr);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        break;
                                    case "140":
                                        if ($(this).attr("lvl") == "130") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[dbr='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this, cntr);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        break;
                                    case "145":
                                        if ($("#chkIncludeSubd").is(":checked")) {
                                            if ($(this).attr("lvl") == "130") {
                                                var tr = $(this).eq(0);
                                                $("#divHierPopupTbl").find("table").eq(0).find("tr[dbr='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                    fnSelectHier(this, cntr);
                                                    var trHtml = $(this)[0].outerHTML;
                                                    $(this).eq(0).remove();
                                                    $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                                });
                                                tr.remove();
                                            }
                                            else if ($(this).attr("lvl") == "140") {
                                                var tr = $(this).eq(0);
                                                $("#divHierPopupTbl").find("table").eq(0).find("tr[branch='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                    fnSelectHier(this, cntr);
                                                    var trHtml = $(this)[0].outerHTML;
                                                    $(this).eq(0).remove();
                                                    $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                                });
                                                tr.remove();
                                            }
                                        }
                                        break;
                                    case "210":
                                        if ($(this).attr("lvl") == "200") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[cls='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this, cntr);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        break;
                                    case "220":
                                        if ($(this).attr("lvl") == "200") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[cls='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this, cntr);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        else if ($(this).attr("lvl") == "210") {
                                            var tr = $(this).eq(0);
                                            $("#divHierPopupTbl").find("table").eq(0).find("tr[channel='" + $(this).attr("nid") + "'][ntype='" + Lvl + "']").each(function () {
                                                fnSelectHier(this, cntr);
                                                var trHtml = $(this)[0].outerHTML;
                                                $(this).eq(0).remove();
                                                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).prepend(trHtml);
                                            });
                                            tr.remove();
                                        }
                                        break;
                                }
                            }
                        });
                    }
                }
            }
            else {
                var ProdLvl = 0;
                fnProdHier_failed(ProdLvl, cntr);
            }
        }
        function fnProdHier_failed(ProdLvl, cntr) {
            if (ProdLvl == 0) {
                $("#divHierPopupTbl").html("<div style='font-size: 0.9rem; font-weight: 600; margin-top: 25%; text-align: center;'>Please Select the Level from Left</div>");
            }
            else {
                $("#divHierPopupTbl").html("Due to some technical reasons, we are unable to Process your request !");
            }
        }

        function fnHierPopupReset() {
            $("#divHierSelectionTbl").find("tbody").eq(0).html("");
            $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr[flgVisible='1']").each(function () {
                $(this).attr("flg", "0");
                $(this).removeClass("Active");
                $(this).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");
            });
            $("#chkSelectAllProd").removeAttr("checked");

            if ($("#ConatntMatter_hdnBucketType").val() == "2")
                $("#chkIncludeSubd").prop("checked", true);
        }
        function fnSelectHier(ctrl, cntr) {
            $(ctrl).attr("flg", "1");
            $(ctrl).addClass("Active");
            $(ctrl).find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");

            fnAppendSelection(ctrl, 1, cntr);
        }
        function fnSelectAllProd(ctrl, cntr) {
            if ($(ctrl).is(":checked")) {
                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr[flgVisible='1']").each(function () {
                    $(this).attr("flg", "1");
                    $(this).addClass("Active");
                    $(this).find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");

                    fnAppendSelection(this, 1, cntr);
                });
            }
            else {
                $("#divHierPopupTbl").find("table").eq(0).find("tbody").eq(0).find("tr[flgVisible='1']").each(function () {
                    $(this).attr("flg", "0");
                    $(this).removeClass("Active");
                    $(this).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");

                    fnAppendSelection(this, 0, cntr);
                });
            }
        }
        function fnSelectUnSelectProd(ctrl, cntr) {
            if ($(ctrl).attr("flg") == "1") {
                $(ctrl).attr("flg", "0");
                $(ctrl).removeClass("Active");
                $(ctrl).find("img").eq(0).attr("src", "../../Images/checkbox-unchecked.png");

                fnAppendSelection(ctrl, 0, cntr);
                $("#chkSelectAllProd").removeAttr("checked");
            }
            else {
                $(ctrl).attr("flg", "1");
                $(ctrl).addClass("Active");
                $(ctrl).find("img").eq(0).attr("src", "../../Images/checkbox-checked.png");

                fnAppendSelection(ctrl, 1, cntr);
            }
        }
        function fnAppendSelection(ctrl, flgSelect, cntr) {
            // var BucketType = $("#ConatntMatter_hdnBucketType").val();
            var BucketType = cntr;
            var Lvl = $("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("tr.Active").eq(0).find("td").eq(0).attr("ntype");

            if (flgSelect == 1) {
                if ($("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='" + Lvl + "'][nid='" + $(ctrl).attr("nid") + "']").length == 0) {
                    var strtr = "";
                    if (BucketType == "1") {
                        switch (Lvl) {
                            case "10":
                                strtr += "<tr lvl='" + Lvl + "' cat='" + $(ctrl).attr("cat") + "' brand='" + $(ctrl).attr("brand") + "' bf='" + $(ctrl).attr("bf") + "' sbf='" + $(ctrl).attr("sbf") + "' nid='" + $(ctrl).attr("cat") + "'>";
                                // strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>All</td><td>All</td><td>All</td>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>All</td>";

                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='20'][cat='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='30'][cat='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='40'][cat='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "20":
                                strtr += "<tr lvl='" + Lvl + "' cat='" + $(ctrl).attr("cat") + "' brand='" + $(ctrl).attr("brand") + "' bf='" + $(ctrl).attr("bf") + "' sbf='" + $(ctrl).attr("sbf") + "' nid='" + $(ctrl).attr("brand") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td>";

                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='30'][brand='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='40'][brand='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "30":
                                strtr += "<tr lvl='" + Lvl + "' cat='" + $(ctrl).attr("cat") + "' brand='" + $(ctrl).attr("brand") + "' bf='" + $(ctrl).attr("bf") + "' sbf='" + $(ctrl).attr("sbf") + "' nid='" + $(ctrl).attr("bf") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>" + $(ctrl).find("td").eq(4).html() + "</td>";

                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='40'][bf='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "40":
                                strtr += "<tr lvl='" + Lvl + "' cat='" + $(ctrl).attr("cat") + "' brand='" + $(ctrl).attr("brand") + "' bf='" + $(ctrl).attr("bf") + "' sbf='" + $(ctrl).attr("sbf") + "' nid='" + $(ctrl).attr("sbf") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>" + $(ctrl).find("td").eq(4).html() + "</td><td>" + $(ctrl).find("td").eq(5).html() + "</td>";
                                break;
                        }
                        strtr += "</tr>";
                    }
                    else if (BucketType == "2") {
                        switch (Lvl) {
                            case "130":
                                strtr += "<tr lvl='" + Lvl + "' dbr='" + $(ctrl).attr("dbr") + "' branch='" + $(ctrl).attr("branch") + "' subd='" + $(ctrl).attr("subd") + "' nid='" + $(ctrl).attr("dbr") + "'>";
                                if ($("#chkIncludeSubd").is(":checked"))
                                    //strtr += "<td>" + $(ctrl).find("td").eq(3).html() + "</td><td>All</td><td>All</td>";
                                    strtr += "<td>" + $(ctrl).find("td").eq(3).html() + "</td><td>All</td>";
                                else
                                    //strtr += "<td>" + $(ctrl).find("td").eq(3).html() + "</td><td>All</td><td>Exclude</td>";
                                    strtr += "<td>" + $(ctrl).find("td").eq(3).html() + "</td><td>All</td>";

                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='140'][dbr='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='145'][dbr='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "140":
                                strtr += "<tr lvl='" + Lvl + "' dbr='" + $(ctrl).attr("dbr") + "' branch='" + $(ctrl).attr("branch") + "' subd='" + $(ctrl).attr("subd") + "' nid='" + $(ctrl).attr("branch") + "'>";
                                if ($("#chkIncludeSubd").is(":checked"))
                                    //strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>All</td>";
                                    strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td>";
                                else
                                    //strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>Exclude</td>";
                                    strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td>";

                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='145'][branch='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "145":
                                strtr += "<tr lvl='" + Lvl + "' dbr='" + $(ctrl).attr("dbr") + "' branch='" + $(ctrl).attr("branch") + "' subd='" + $(ctrl).attr("subd") + "' nid='" + $(ctrl).attr("subd") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>" + $(ctrl).find("td").eq(4).html() + "</td>";
                                break;
                        }
                        strtr += "</tr>";
                    }
                    else {
                        switch (Lvl) {
                            case "200":
                                strtr += "<tr lvl='" + Lvl + "' cls='" + $(ctrl).attr("cls") + "' channel='" + $(ctrl).attr("channel") + "' storetype='" + $(ctrl).attr("storetype") + "' nid='" + $(ctrl).attr("cls") + "'>";
                                // strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>All</td><td>All</td>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>All</td>";

                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='210'][cls='" + $(ctrl).attr("nid") + "']").remove();
                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='220'][cls='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "210":
                                strtr += "<tr lvl='" + Lvl + "' cls='" + $(ctrl).attr("cls") + "' channel='" + $(ctrl).attr("channel") + "' storetype='" + $(ctrl).attr("storetype") + "' nid='" + $(ctrl).attr("channel") + "'>";
                                //  strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>All</td>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td>";

                                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='220'][channel='" + $(ctrl).attr("nid") + "']").remove();
                                break;
                            case "220":
                                strtr += "<tr lvl='" + Lvl + "' cls='" + $(ctrl).attr("cls") + "' channel='" + $(ctrl).attr("channel") + "' storetype='" + $(ctrl).attr("storetype") + "' nid='" + $(ctrl).attr("storetype") + "'>";
                                strtr += "<td>" + $(ctrl).find("td").eq(2).html() + "</td><td>" + $(ctrl).find("td").eq(3).html() + "</td><td>" + $(ctrl).find("td").eq(4).html() + "</td>";
                                break;
                        }
                        strtr += "</tr>";
                    }

                    if ($("#divHierSelectionTbl").find("tbody").eq(0).find("tr").length == 0) {
                        $("#divHierSelectionTbl").find("tbody").eq(0).html(strtr);
                    }
                    else {
                        $("#divHierSelectionTbl").find("tbody").eq(0).prepend(strtr);
                    }
                }
            }
            else {
                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='" + Lvl + "'][nid='" + $(ctrl).attr("nid") + "']").eq(0).remove();
            }
        }
        function fnSubdInclude() {
            if ($("#chkIncludeSubd").is(":checked")) {
                $("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("td[ntype='145']").eq(0).closest("tr").show();
                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='130']").each(function () {
                    $(this).find("td:last").eq(0).html("All");
                });
                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='140']").each(function () {
                    $(this).find("td:last").eq(0).html("All");
                });
            }
            else {
                $("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("td[ntype='145']").eq(0).closest("tr").hide();
                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='130']").each(function () {
                    $(this).find("td:last").eq(0).html("Exclude");
                });
                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='140']").each(function () {
                    $(this).find("td:last").eq(0).html("Exclude");
                });
                $("#divHierSelectionTbl").find("tbody").eq(0).find("tr[lvl='145']").remove();
            }
        }

        function fnProdSelected(ctrl) {
            var SelectedLvl = "", SelectedHier = "", descr = "";
            if ($("#divHierSelectionTbl").find("table").eq(0).find("tbody").eq(0).find("tr").length == 0) {
                if ($("#ConatntMatter_hdnBucketType").val() == "1") {
                    SelectedLvl = "10";
                    $(ctrl).attr("InSubD", "0");
                }
                else if ($("#ConatntMatter_hdnBucketType").val() == "2") {
                    SelectedLvl = "130";

                    if ($("#chkIncludeSubd").is(":checked"))
                        $(ctrl).attr("InSubD", "1");
                    else
                        $(ctrl).attr("InSubD", "0");
                }
                else {
                    SelectedLvl = "200";
                    $(ctrl).attr("InSubD", "0");
                }
            }
            else
                SelectedLvl = $("#divHierSelectionTbl").find("table").eq(0).find("tbody").eq(0).find("tr").eq(0).attr("lvl");

            $("#divHierSelectionTbl").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                SelectedHier += "^" + $(this).attr("nid") + "|" + $(this).attr("lvl");
                switch ($(this).attr("lvl")) {
                    case "10":
                        descr += "," + $(this).find("td").eq(0).html();
                        break;
                    case "20":
                        descr += "," + $(this).find("td").eq(1).html();
                        break;
                    case "30":
                        descr += "," + $(this).find("td").eq(2).html();
                        break;
                    case "40":
                        descr += "," + $(this).find("td").eq(3).html();
                        break;
                    case "130":
                        descr += "," + $(this).find("td").eq(0).html();
                        break;
                    case "140":
                        descr += "," + $(this).find("td").eq(1).html();
                        break;
                    case "145":
                        descr += "," + $(this).find("td").eq(2).html();
                        break;
                    case "200":
                        descr += "," + $(this).find("td").eq(0).html();
                        break;
                    case "210":
                        descr += "," + $(this).find("td").eq(1).html();
                        break;
                    case "220":
                        descr += "," + $(this).find("td").eq(2).html();
                        break;
                }
            });
            if (SelectedHier != "") {
                SelectedHier = SelectedHier.substring(1);
                descr = descr.substring(1);
                if (descr.length > 30) {
                    descr = descr.substring(0, 30) + "...";
                }
                $(ctrl).attr("ProdLvl", SelectedLvl);
                $(ctrl).attr("ProdHier", SelectedHier);
                $(ctrl).val(descr);
            }
            else {
                $(ctrl).attr("ProdLvl", SelectedLvl);
                $(ctrl).attr("ProdHier", "");
                $(ctrl).val("");
            }
        }
    </script>

    <script type="text/javascript">
        function fnAddNewSBF() {
            $("#txtBrandForm").attr("sel", "");
            $("#txtBrandForm").val("");
            $("#txtSBFCode").val("");
            $("#txtSBFName").val("");

            fnShowSBFPopup();
        }
        function fnShowSBFPopup() {
            $("#divSBFPopup").dialog({
                "modal": true,
                "width": "50%",
                "height": "460",
                "title": "Add New SubBrandForm :",
                buttons: {
                    "Add New SubBrandForm": function () {
                        fnSaveNewNode(2, 0);
                    },
                    "Cancel": function () {
                        $("#divSBFPopup").dialog('close');
                    }
                },
                close: function () {
                    //
                }
            });
        }

        function fnAddNewBrandForm(cntr) {
            $("#txtBrand").attr("sel", "");
            $("#txtBrand").val("");
            $("#txtBFCode").val("");
            $("#txtBFName").val("");

            fnShowBFPopup(cntr);
        }
        function fnShowBFPopup(cntr) {
            $("#divBFPopup").dialog({
                "modal": true,
                "width": "46%",
                "height": "460",
                "title": "Add New BrandForm :",
                buttons: {
                    "Add New BrandForm": function () {
                        fnSaveNewNode(1, cntr);
                    },
                    "Cancel": function () {
                        $("#divBFPopup").dialog('close');
                    }
                }
            });
        }

        function fnShowPopupforNewNode(ctrl, cntr) {
            $(ctrl).next("div.clsPopup").eq(0).show();

            if (cntr == 1) {
                $(ctrl).next().find("div.clsPopupBody").html($("#ConatntMatter_hdnBrand").val().split("|^|")[1]);
            }
            else {
                $(ctrl).next().find("div.clsPopupBody").html($("#ConatntMatter_hdnBrandForm").val().split("|^|")[1]);
            }

            if ($(ctrl).val() != "")
                fnPopupTypeSearchforNewNode(ctrl);
        }
        function fnPopupTypeSearchforNewNode(ctrl) {
            var filter = $(ctrl).val().toUpperCase().split(",");
            if ($(ctrl).val().length > 2) {
                $(ctrl).next().find("div.clsPopupBody").eq(0).find("tbody").eq(0).find("tr").css("display", "none");
                $(ctrl).next().find("div.clsPopupBody").eq(0).find("tbody").eq(0).find("tr").each(function () {
                    flgValid = 1;
                    for (var t = 0; t < filter.length; t++) {
                        if ($(this).find("td")[1].innerText.toUpperCase().indexOf(filter[t].toString().trim()) == -1) {
                            flgValid = 0;
                        }
                    }
                    if (flgValid == 1) {
                        $(this).css("display", "table-row");
                    }
                });
            }
            else {
                $(ctrl).next().find("div.clsPopupBody").eq(0).find("tbody").eq(0).find("tr").css("display", "table-row");
            }
        }
        function fnSelectProdforNewNode(ctrl) {
            var nid = $(ctrl).attr("nid");
            var ntype = $(ctrl).attr("ntype");
            var str = $(ctrl).find("td:last").html();

            $(ctrl).closest("div.clsPopup").prev().val(str);
            $(ctrl).closest("div.clsPopup").prev().attr("sel", nid + "^" + ntype);
            fnHidePopupforNewNode();
        }
        function fnRemoveSelectionforNewNode(ctrl) {
            $(ctrl).attr("sel", "");
        }
        function fnHidePopupforNewNode() {
            $("div.clsPopup").hide();
        }

        function fnSaveNewNode(flg, cntr) {
            var ParentId = "";
            var ParentType = "";
            var Code = "";
            var Descr = "";

            if (flg == 1) {         //BF
                if ($("#txtBFCode").val() == "") {
                    alert("Please enter the BrandForm code !");
                    return false;
                }
                else if ($("#txtBFName").val() == "") {
                    alert("Please enter the BrandForm name !");
                    return false;
                }
                else if ($("#txtBrand").attr("sel") == "") {
                    alert("Please select the Brand !");
                    return false;
                }

                ParentId = $("#txtBrand").attr("sel").split("^")[0];
                ParentType = $("#txtBrand").attr("sel").split("^")[1];
                Code = $("#txtBFCode").val();
                Descr = $("#txtBFName").val();
            }
            else {                   //SBF
                if ($("#txtSBFCode").val() == "") {
                    alert("Please enter the SubBrandForm code !");
                    return false;
                }
                else if ($("#txtSBFName").val() == "") {
                    alert("Please enter the SubBrandForm name !");
                    return false;
                }
                else if ($("#txtBrandForm").attr("sel") == "") {
                    alert("Please select the BrandForm !");
                    return false;
                }

                ParentId = $("#txtBrandForm").attr("sel").split("^")[0];
                ParentType = $("#txtBrandForm").attr("sel").split("^")[1];
                Code = $("#txtSBFCode").val();
                Descr = $("#txtSBFName").val();
            }

            var LoginID = $("#ConatntMatter_hdnLoginID").val();
            var UserID = $("#ConatntMatter_hdnUserID").val();
            var RoleID = $("#ConatntMatter_hdnRoleID").val();
            var UserNodeID = $("#ConatntMatter_hdnNodeID").val();
            var UserNodeType = $("#ConatntMatter_hdnNodeType").val();

            $("#dvloader").show();
            PageMethods.fnSaveNewNode(ParentId, ParentType, Code, Descr, LoginID, UserID, RoleID, UserNodeID, UserNodeType, fnSaveNewNode_pass, fnfailed, flg + "|" + cntr);
        }
        function fnSaveNewNode_pass(res, flgCntr) {
            if (res.split("|^|")[0] == "0") {
                if (res.split("|^|")[1].split("^")[0] == "-1") {
                    $("#dvloader").hide();
                    alert("Code already exist !");
                }
                else {
                    $("#dvloader").hide();
                    if (flgCntr.split("|")[0] == "1") {
                        alert("BrandForm added successfully !");
                        $("#ConatntMatter_hdnBrandForm").val(res.split("|^|")[3]);
                        $("#divBFPopup").dialog('close');

                        if (flgCntr.split("|")[1] == "1") {
                            $("#txtBrandForm").next().find("div.clsPopupBody").html(res.split("|^|")[3]);
                            $("#txtBrandForm").val(res.split("|^|")[2].toString().substr(0, res.split("|^|")[2].toString().length - 1));
                            $("#txtBrandForm").attr("sel", res.split("|^|")[1]);
                        }
                    }
                    else {
                        alert("SubBrandForm added successfully !");
                        $("#divSBFPopup").dialog('close');
                    }

                    if (flgCntr.split("|")[1] == "0") {
                        var SelectedHier = "";
                        $("#divHierSelectionTbl").find("table").eq(0).find("tbody").eq(0).find("tr").each(function () {
                            SelectedHier += "^" + $(this).attr("nid") + "|" + $(this).attr("lvl");
                        });
                        if (SelectedHier != "") {
                            SelectedHier = SelectedHier.substring(1);
                            $("#ConatntMatter_hdnSelectedHier").val(SelectedHier + "^" + res.split("|^|")[1].split("^")[0] + "|" + res.split("|^|")[1].split("^")[1]);
                        }
                        else {
                            $("#ConatntMatter_hdnSelectedHier").val(res.split("|^|")[1].split("^")[0] + "|" + res.split("|^|")[1].split("^")[1]);
                        }
                        fnProdLvl($("#ProdLvl").find("table").eq(0).find("tbody").eq(0).find("tr[class='Active']").eq(0).find("td").eq(0));
                    }
                }
            }
            else {
                fnfailed();
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
        table.clsReport tr th:nth-child(1) {
            width: 2%;
        }

        table.clsReport tr th:nth-child(2),
        table.clsReport tr th:nth-child(3) {
            width: 15%;
        }

        table.clsReport tr th:nth-child(4),
        table.clsReport tr th:nth-child(6) {
            width: 5%;
        }

        table.clsReport tr th:nth-child(5) {
            width: 12%;
        }


        table.clsReport tr th:nth-child(7),
        table.clsReport tr th:nth-child(8),
        table.clsReport tr th:nth-child(9) {
            width: 15%;
        }

        table.clsReport tr th:nth-child(10) {
            width: 5%;
        }
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
<asp:Content ID="Content3" ContentPlaceHolderID="ConatntMatter" runat="Server">

    <h4 class="middle-title">User Management</h4>
    <div class="fsw">
        <div class="fsw_inner">
            <div class="fsw_inputBox w-25">
                <div class="fsw-title">Search Box</div>
                <div class="d-block">
                    <input id="txtfilter" type="text" class="form-control form-control-sm" onkeyup="fntypefilter();" placeholder="Search" />
                </div>
            </div>
        </div>
    </div>
    <div id="tab-content" class="tab-content">
        <!-- Tab panes 1-->
        <div role="tabpanel" class="tab-pane fade show active" id="CSTab-1">
            <div class="text-right mb-2 mt-1">
                <a class="btn btn-primary btn-sm" href="#" onclick="fnAddNew();">Add New User</a>
            </div>
            <div id="divHeader"></div>
            <div id="divReport"></div>
        </div>
    </div>

    <div id="divHierPopup" style="display: none;">
        <div class="row no-gutters">
            <div class="col-2">
                <div id="ProdLvl" class="prodLvl"></div>
            </div>
            <div class="col-6">
                <div class="pl-2">
                    <div class="d-flex align-items-center justify-content-between producthrchy">
                        <div id="PopupHierlbl" class="d-block"></div>
                        <a id="btnAddNewNode" class="btns-outline" href="#" onclick="fnAddNewSBF();">Add New SubBrandForm</a>
                    </div>
                    <div id="divHierPopupTbl" style="height: 410px; overflow-y: auto; width: 100%;"></div>
                </div>
            </div>
            <div class="col-4">
                <div class="prodLvl" style="margin-left: 1%;">
                    <div class="d-flex align-items-center justify-content-between producthrchy">
                        Your Selection
                    </div>
                    <div id="divHierSelectionTbl" style="height: 410px; overflow-y: auto; width: 100%;"></div>
                </div>
            </div>
        </div>
    </div>

    <div id="divSBFPopup" style="display: none;">
        <div class="form-row">
            <div class="form-group col-md">
                <label>SubBrandForm Code</label>
                <input type="text" class="form-control form-control-sm" id="txtSBFCode" />
            </div>
            <div class="form-group col-md">
                <label>SubBrandForm Name</label>
                <input type="text" class="form-control form-control-sm" id="txtSBFName" />
            </div>
        </div>
        <div class="form-row">
            <div class="form-group col-md">
                <label>BrandForm</label>
                <div class="position-relative">
                    <input id="txtBrandForm" type="text" class="form-control form-control-sm" sel="" autocomplete="off" onclick="fnShowPopupforNewNode(this, 2)" onkeyup="fnPopupTypeSearchforNewNode(this);" onchange="fnRemoveSelectionforNewNode(this);" placeholder="Type atleast 3 character to filter..." />
                    <div class="clsPopup">
                        <div class="clsPopupBody clsPopupSec" style="padding: 0;"></div>
                        <div class="clsPopupFooter clsPopupSec">
                            <a class="btn btn-primary btn-sm" href="#" onclick="fnHidePopupforNewNode();">Close</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="text-right">
            <a href="#" class="btn btn-primary btn-sm" onclick="fnAddNewBrandForm(1);">Add BrandForm</a>
        </div>
    </div>
    <div id="divBFPopup" style="display: none;">
        <div class="form-row">
            <div class="form-group col-md">
                <label>BrandForm Code</label>
                <input type="text" class="form-control form-control-sm" id="txtBFCode" />
            </div>
            <div class="form-group col-md">
                <label>BrandForm Name</label>
                <input type="text" class="form-control form-control-sm" id="txtBFName" />
            </div>
        </div>
        <div class="form-row">
            <div class="form-group col-md">
                <label>Brand</label>
                <div class="position-relative">
                    <input id="txtBrand" type="text" class="form-control form-control-sm" sel="" autocomplete="off" onclick="fnShowPopupforNewNode(this, 1)" onkeyup="fnPopupTypeSearchforNewNode(this);" onchange="fnRemoveSelectionforNewNode(this);" placeholder="Type atleast 3 character to filter..." />
                    <div class="clsPopup">
                        <div class="clsPopupBody clsPopupSec p-0"></div>
                        <div class="clsPopupFooter clsPopupSec">
                            <a class="btn btn-primary btn-sm" href="#" onclick="fnHidePopupforNewNode();">Close</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="loader_bg" id="dvloader">
        <div class="loader"></div>
    </div>
    <div id="divMsg" class="clsMsg"></div>
    <div id="dvUserDetail" style="display: none; font-size: 8.5pt">
    </div>

    <asp:HiddenField ID="hdnLoginID" runat="server" />
    <asp:HiddenField ID="hdnUserID" runat="server" />
    <asp:HiddenField ID="hdnRoleID" runat="server" />
    <asp:HiddenField ID="hdnNodeID" runat="server" />
    <asp:HiddenField ID="hdnNodeType" runat="server" />
    <asp:HiddenField ID="hdnMainRoleID" runat="server" />


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

