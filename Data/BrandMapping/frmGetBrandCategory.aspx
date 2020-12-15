<%@ Page Title="" Language="VB" MasterPageFile="~/Data/MasterPages/Site.master" AutoEventWireup="false" CodeFile="frmGetBrandCategory.aspx.vb" Inherits="Data_EntryForms_frmGetBrandCategory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
        function fnSave()
        {
            var ArrDataSaving = [];
            $("#ConatntMatter_dvBrandName").find("#tblMain tbody tr").each(function () {
                if ($(this).find("#ddlBrandForm").val() > 0) {

                    var ddlBrandForm = $(this).find("#ddlBrandForm option:selected").text();
                    var PrdType = "BF";
                    var BFNodeId = $(this).attr("BFNodeId")
                    var BFNodeType = $(this).attr("BFNodeType")

                    ArrDataSaving.push({ PrdName: ddlBrandForm, PrdType: PrdType, NodeID: BFNodeId, NodeType: BFNodeType });
                }
            });

            if (ArrDataSaving.length == 0) {
                alert("Kindly Select the data from the drop down")
                return false;
            }

            $("#dvloader").show();
            
            PageMethods.fnSave(ArrDataSaving, fnSave_Success, fnFailed);
        }

        function fnSave_Success(result) {
            $("#dvloader").hide();
            if (result.split("^")[0] == "1") {
                alert("Saved successfully");
               
            }
            else {
                alert("Some techical error. " + result.split("^")[1]);
            }
           
        }
        function fnFailed(result) {
            alert("Oops! Something went wrong. Please try again.");
            $("#dvloader").hide();
        }

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" Runat="Server">
  
      <div id="dvBrandName" runat="server">
    </div>
    <div style="text-align:center">
         <input type="button" id="btnSave" onclick="fnSave()" value="Save" class="btn btn-primary btn-sm" />
    </div>
   
    <div id="dvloader" class="loader_bg">
        <div class="loader"></div>
    </div>
</asp:Content>

