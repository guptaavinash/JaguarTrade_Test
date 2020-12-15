<%@ Page Title="" Language="C#" MasterPageFile="~/Data/MasterPages/Site.master" AutoEventWireup="true" CodeFile="ChannelSummaryDownload.aspx.cs" Inherits="Data_EntryForms_ChannelSummaryDownload" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
      <script type="text/javascript">
          function fnDownload() {
              $("#ConatntMatter_btnDownload").click();
          }
      </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ConatntMatter" Runat="Server">
    <h4 class="middle-title" id="Heading">Channel Summary Download</h4>
    <div class="fsw" id="Filter">
        <div class="fsw_inner">
            <div class="fsw_inputBox w-100">
                 <div class="row">
                      <div class="col-5">
                     <div class="form-row">
                            <label class="col-form-label col-form-label-sm">Month Year </label>
                            <div class="col-5">                               
                                 <asp:DropDownList runat="server" ID="ddlMonth" style="width:200px"  class="form-control form-control-sm"></asp:DropDownList>      
                                 
                            </div>
                          <div class="col-5">   
                         <a href='#' id="Downloadexcel" onclick="fnDownload();" class="btn btn-primary btn-sm">Download</a>
                                 <asp:Button ID="btnDownload" runat="server" Text="." OnClick="btnDownload_Click" style="visibility:hidden;"/>
                              </div>  
                        </div>
                          </div>
                       </div>
            </div>
            </div>
    </div>
    <div  id="divMsg" runat="server"></div>
</asp:Content>

