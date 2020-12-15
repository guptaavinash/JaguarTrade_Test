using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Data_Other_frmDashboard : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["LoginID"] == null)
        {
            Response.Redirect("~/frmLogin.aspx");
        }
        else
        {
            if (!IsPostBack)
            {
                hdnLoginID.Value = Session["LoginID"].ToString();
                hdnUserID.Value = Session["UserID"].ToString();
                hdnRoleID.Value = Session["RoleId"].ToString();
                hdnNodeID.Value = Session["NodeId"].ToString();
                hdnNodeType.Value = Session["NodeType"].ToString();
            }
        }
    }



    [System.Web.Services.WebMethod()]
    public static string fnGetTableData(string LoginID, string UserID, string RoleID)
    {
        try
        {
            SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
            SqlCommand Scmd = new SqlCommand();
            Scmd = new SqlCommand();
            Scmd.Connection = Scon;

            Scmd.CommandText = "spDashboardGetDahsboardData";
            Scmd.Parameters.AddWithValue("@LoginID", LoginID);
            Scmd.Parameters.AddWithValue("@UserID", UserID);
            Scmd.Parameters.AddWithValue("@RoleID", RoleID);


            Scmd.CommandType = CommandType.StoredProcedure;
            Scmd.CommandTimeout = 0;
            SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
            DataSet Ds = new DataSet();
            Sdap.Fill(Ds);
            Scmd.Dispose();
            Sdap.Dispose();

            string[] SkipColumn = new string[6];
            SkipColumn[0] = "RoleId";
            SkipColumn[1] = "LoginIDIns";
            SkipColumn[2] = "TimestampIns";
            SkipColumn[3] = "LoginIDUpd";
            SkipColumn[4] = "TimestampUpd";
            SkipColumn[5] = "users";
            return "0|^|" + CreateMstrTbl(Ds.Tables[0], SkipColumn, "tblReport", "clsReport");

        }
        catch (Exception ex)
        {
            return "1|^|" + ex.Message;
        }
    }

    private static string CreateMstrTbl(DataTable dt, string[] SkipColumn, string tblname, string cls)
    {

        StringBuilder sb = new StringBuilder();
        StringBuilder sbDescr = new StringBuilder();
        if (dt.Rows.Count > 0)
        {
            sb.Append("<table id='" + tblname + "' class='table table-striped table-bordered table-sm " + cls + "'>");
            sb.Append("<thead>");
            //sb.Append("<tr>");
            //sb.Append("<th>#</th>");
            //for (int j = 0; j < dt.Columns.Count; j++)
            //{
            //    if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString().Trim()))
            //    {
            //        sb.Append("<th>" + dt.Columns[j].ColumnName.ToString() + "</th>");
            //    }
            //}
            //sb.Append("</tr>");
            sb.Append("</thead>");
            sb.Append("<tbody>");
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                sbDescr.Clear();
                sb.Append("<tr>");
                // sb.Append("<td>" + (i + 1).ToString() + "</td>");

                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    if (!SkipColumn.Contains(dt.Columns[j].ColumnName.ToString()))
                    {
                        sb.Append("<td>" + dt.Rows[i][j] + "</td>");
                    }
                }
                sb.Append("</tr>");
            }
            sb.Append("</tbody>");
            sb.Append("</table>");
        }
        else
        {
            sb.Append("<table id='" + tblname + "' class='table table-striped table-bordered table-sm " + cls + "'>");
            sb.Append("<thead>");
            sb.Append("</thead>");
            sb.Append("<tbody>");
            sb.Append("No Dashboard details found for this user.");
            sb.Append("</tbody>");
            sb.Append("</table>");
        }
        return sb.ToString();
    }

}