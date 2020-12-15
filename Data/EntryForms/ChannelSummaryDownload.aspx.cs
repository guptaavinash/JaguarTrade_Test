using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using Newtonsoft.Json;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.IO;
using ClosedXML.Excel;


public partial class Data_EntryForms_ChannelSummaryDownload : System.Web.UI.Page
{
    [DllImport("user32.dll")]
    static extern int GetWindowThreadProcessId(int hWnd, out int lpdwProcessId);
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["LoginID"] == null)
        {
            Response.Redirect("~/frmLogin.aspx");
        }

        if (!IsPostBack)
        {
            fnBindSiteList();
        }
    }


    private void fnBindSiteList()
    {

        SqlConnection Scon = new SqlConnection(ConfigurationManager.ConnectionStrings["strConn"].ConnectionString);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "spGetMonthswithCM";
        Scmd.Parameters.AddWithValue("@LoginId", Session["LoginId"].ToString());
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        DataTable dt = new DataTable();
        Sdap.Fill(dt);

        ListItem itm = new ListItem();
        //if (dt.Rows.Count > 1)
        //{
        //    itm.Text = "--------";
        //    itm.Value = "0^0";
        //    ddlMonth.Items.Add(itm);
        //}
        foreach (DataRow dr in dt.Rows)
        {
            itm = new ListItem();
            itm.Text = dr["Month"].ToString();
            itm.Value = dr["MonthVal"].ToString() + "^" + dr["YEarVal"].ToString();
            itm.Attributes.Add("startdt", dr["startdt"].ToString());
            ddlMonth.Items.Add(itm);
            if (dr["flgSelect"].ToString() == "1")
            {
                itm.Selected = true;
            }
        }
    }
    
    protected void btnDownload_Click(object sender, EventArgs e)
    {
        DataTable tblLoc = new DataTable();
        tblLoc.Columns.Add("INITID", typeof(String));

        DataSet ds = new DataSet();
        SqlConnection Scon = new SqlConnection(ConfigurationManager.AppSettings["strConn"]);
        SqlCommand Scmd = new SqlCommand();
        Scmd.Connection = Scon;
        Scmd.CommandText = "[spGenerateChannelSummary]";
        Scmd.CommandType = CommandType.StoredProcedure;
        Scmd.CommandTimeout = 0;
        Scmd.Parameters.AddWithValue("@MonthVal", ddlMonth.SelectedValue.ToString().Split('^')[0]);
        Scmd.Parameters.AddWithValue("@YearVal",  ddlMonth.SelectedValue.ToString().Split('^')[1]);
        Scmd.Parameters.AddWithValue("@LoginID", Session["LoginID"].ToString());
        Scmd.Parameters.AddWithValue("@UserID", Session["UserID"].ToString());
        Scmd.Parameters.AddWithValue("@RoleID", Session["RoleId"].ToString());
        Scmd.Parameters.AddWithValue("@INITID", tblLoc);
        

        SqlDataAdapter Sdap = new SqlDataAdapter(Scmd);
        Sdap.Fill(ds);

        /* 
        string folderwithfileName = "";
        string folderPath = HttpContext.Current.Server.MapPath("~/Uploads/New/");

        folderwithfileName = folderPath + ds.Tables[0].Rows[0][0].ToString();

        
        //ConvertToExcel(ds,"");

        HttpContext.Current.Response.Clear();
        HttpContext.Current.Response.Buffer = true;
        HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=" + Path.GetFileName(folderwithfileName));

        Response.WriteFile(folderwithfileName);
        HttpContext.Current.Response.End();
       */
        if (!File.Exists(Server.MapPath("~/Uploads/") + ds.Tables[0].Rows[0][0].ToString()))
        {
            divMsg.InnerHtml = "<span style='color:red;font-size:12px;'>File not available.</span>";
        }
        else
        {
            clsExcelDownload.ConvertToExcelNew(ds, "existing", ddlMonth.SelectedItem.Text);
        }
                
        
        // ConvertToExcelNew(ds);
    }


    public void ConvertToExcel(DataSet ds, string strFilenamewithpath)
    {
        FnWriteLogFile_Log("", "ConvertToExcel1");

        //Instance reference for Excel Application

        Microsoft.Office.Interop.Excel.Application objXL = null;
        //Workbook refrence

        Microsoft.Office.Interop.Excel.Workbook objWB = null;


        objXL = new Microsoft.Office.Interop.Excel.Application();
        // Find the Excel Process Id (ath the end, you kill him
        int id;
        GetWindowThreadProcessId(objXL.Hwnd, out id);
        Process excelProcess = Process.GetProcessById(id);
        FnWriteLogFile_Log("", "ConvertToExcel3");
        objWB = objXL.Workbooks.Open(Server.MapPath("~/Uploads/") +ds.Tables[0].Rows[0][0].ToString());// Server.MapPath("\Log\Feet on Street Report.xlsx");

        try

        {

            //Instancing Excel using COM services




            //Adding WorkBook
            //FnWriteLogFile_Log("", "objXL.Workbooks.Add(1)");
            //objWB = objXL.Workbooks.Add(1);//ds.Tables.Count  //  Server.MapPath("~/ExcelFile/Log/myexcel.xlsx") + ""

            //Variable to keep sheet count

            int sheetcount = 1;

            //Do I need to explain this ??? If yes please close my website and learn abc of .net .
            //oSheet = oWorkBook.Sheets.Item(1)
            FnWriteLogFile_Log("", "add sheet");
            Microsoft.Office.Interop.Excel.Worksheet objSHT = null;

            //foreach (System.Data.DataTable dt in ds.Tables)

            objSHT = (Microsoft.Office.Interop.Excel.Worksheet)objWB.Sheets[4];

            DataTable dt = ds.Tables[2];

                //Adding sheet to workbook for each datatable



                //Naming sheet as SheetData1.SheetData2 etc....
                FnWriteLogFile_Log("", "Naming sheet");
            objSHT.Name = ds.Tables[1].Rows[0][0].ToString();







            for (int i = 0; i < dt.Columns.Count; i++)
            {
                objSHT.Cells[1, i + 1] = dt.Columns[i].ColumnName.ToString();                
                objSHT.Range[objSHT.Cells[1, i + 1], objSHT.Cells[1, i + 1]].Interior.Color = System.Drawing.ColorTranslator.ToOle(System.Drawing.Color.LightSteelBlue); //# d9d9d9
                //objSHT.Cells[2, i + 1].Interior.Color = System.Drawing.ColorTranslator.FromHtml("#d9d9d9"); //# d9d9d9
                //objSHT.Cells[1, i + 1].Interior.Color = System.Drawing.ColorTranslator.ToOle(System.Drawing.Color.Silver);
            }

                Int32 rows;
                Int32 columns;
                rows = dt.Rows.Count;
                columns = dt.Columns.Count;

                var Data = new object[rows - 1 + 1, columns - 1 + 1];

                for (var i = 0; i <= dt.Rows.Count - 1; i += 1)
                {
                    for (var j = 0; j <= dt.Columns.Count - 1; j += 1)
                        Data[i, j] = dt.Rows[i][j];
                }

                var startCell = objSHT.Cells[2, 1];
                var endCell = objSHT.Cells[1 + dt.Rows.Count, dt.Columns.Count];
                var writeRange = objSHT.Range[startCell, endCell];
                writeRange.Value = Data;

            //Incrementing sheet count



            //Saving the work book

            objSHT = (Microsoft.Office.Interop.Excel.Worksheet)objWB.Sheets[1];

            objSHT.Activate();
            //objSHT.Select(Type.Missing);
            objWB.Saved = true;
            
            objWB.SaveCopyAs(Server.MapPath("~/Uploads/New/") + ds.Tables[0].Rows[0][0].ToString());

            //Closing work book
            FnWriteLogFile_Log("", "objWB.Close()");
            objWB.Close();

            //Closing excel application

            objXL.Quit();



            //Marshal.ReleaseComObject(objSHT);



            FnWriteLogFile_Log("", "set null");
            objSHT = null;
            objWB = null;
            objXL = null;

            GC.Collect();
            GC.WaitForPendingFinalizers();

            if (objSHT != null)
            {
                Marshal.ReleaseComObject(objSHT);
            }

            if (objWB != null)
            {
                Marshal.ReleaseComObject(objWB);
            }

            if (objXL != null)
            {
                Marshal.ReleaseComObject(objXL);
            }

            FnWriteLogFile_Log("", "complete");

            //HttpContext.Current.Response.End();



        }

        catch (Exception ex)
        {
            FnWriteLogFile_Log("", "Error:" + ex.StackTrace.ToString());
            if (objWB != null)
            {
                objWB.Close();

                //Closing excel application

                objXL.Quit();

                //Marshal.ReleaseComObject(objSHT);


                // objSHT = null;
                objWB = null;
                objXL = null;

                GC.Collect();
                GC.WaitForPendingFinalizers();

                //if (objSHT != null)
                //{
                //    Marshal.ReleaseComObject(objSHT);
                //}

                if (objWB != null)
                {
                    Marshal.ReleaseComObject(objWB);
                }

                if (objXL != null)
                {
                    Marshal.ReleaseComObject(objXL);
                }

                //Response.Write("Illegal permission");
            }

        }
        finally
        {
            FnWriteLogFile_Log("", "Check HasExited");
            if (!excelProcess.HasExited)
            {
                FnWriteLogFile_Log("", "kill process");
                excelProcess.Kill();
                FnWriteLogFile_Log("", "end kill process");
            }
        }

    }




    private void FnWriteLogFile_Log(string FileName, string message)
    {
        string LogPath_Log = Server.MapPath("~/Uploads/Log/") + Session["LoginID"].ToString() + "_" + DateTime.Now.ToString("yyyy_MM_dd") + "_log.txt"; // This is Log File Path Where we Generate Log File

        if (!File.Exists(LogPath_Log)) // Check Here File Exists Or Not
        {
            using (StreamWriter sw = File.CreateText(LogPath_Log)) // Now We Here Create Log Text File
            {
                // Now We write all required log data in created file...
                sw.WriteLine();
                sw.WriteLine("Date Time :" + DateTime.Now);
                sw.WriteLine(message);


            }
        }
        else
        {
            using (StreamWriter sw = File.AppendText(LogPath_Log)) // Now We Here Create Log Text File
            {
                // Now We write all required log data in created file...
                sw.WriteLine();
                sw.WriteLine("Date Time :" + DateTime.Now);
                sw.WriteLine(message);


            }
        }



    }



    void ConvertToExcelNew(DataSet Ds)
    {
       

        string[] SkipColumn = new string[3];

        SkipColumn[0] = "CovAreaId";
        SkipColumn[1] = "CovAreaNodeType";
        SkipColumn[2] = "EntryPersonNodeID";

       
        try
        {
            
            

            foreach (string col in SkipColumn)
            {
                if (Ds.Tables[0].Columns.Contains(col.ToLower()))
                {
                    Ds.Tables[0].Columns.Remove(col);
                }
            }


            //XLWorkbook Workbook = new XLWorkbook(@"C:\existing_excel_file.xlsx");
            //IXLWorksheet Worksheet = Workbook.Worksheet("Name or index of the sheet to use");

            using (XLWorkbook wb = new XLWorkbook(Server.MapPath("~/Uploads/") + Ds.Tables[0].Rows[0][0].ToString()))
            {
                ////Start Chassiss
                int k = 1; int j = 0; int colFreeze = 2; int colLeft = 3;
                string strold = ""; int cntc = 0; int colst = 2; bool flgb = true;
                int resulsetcnt = 2;
                //foreach (DataRow drowchasiss in Ds.Tables[0].Rows)//For SheetName
                //{
                //string strSheetName = filename.Length > 31 ? filename.Substring(0, 28) + "..." : filename;//drowchasiss["SheetName"].ToString();
                DataTable dt = Ds.Tables[resulsetcnt];
                resulsetcnt++;
                var ws = wb.Worksheets.Add(Ds.Tables[1].Rows[0][0].ToString());
               
                k = 1; j = 0; colFreeze = 2; colLeft = 3;
                strold = ""; cntc = 0; colst = 2; flgb = true; bool flgm = false;
                //int rowstart = 0; // for data part insertion
                int noofsplit = 1; //Convert.ToInt16(drowchasiss["NoOfSplit"]);
                int noofcolfreeze = 0;// Convert.ToInt16(drowchasiss["Noofcolfreeze"]);
                for (int c = 0; c < dt.Columns.Count; c++)
                {
                    if (!SkipColumn.Contains(dt.Columns[c].ColumnName.ToString().Trim()))
                    {
                        string[] ColSpliter = dt.Columns[c].ColumnName.ToString().Split('^');


                        flgm = true;

                        for (var i = 0; i < ColSpliter.Length; i++)
                        {
                            string sVal = dt.Columns[c].ColumnName.ToString().Split('^')[i];
                            ws.Cell(k + i, j + 1).Value = sVal.Split('^')[0];
                        }
                        for (var i = 0; i < noofsplit; i++)
                        {
                            ws.Cell(k + i, j + 1).Style.Fill.BackgroundColor = XLColor.FromHtml("#337ab7");
                            ws.Cell(k + i, j + 1).Style.Font.FontColor = XLColor.FromHtml("#ffffff");
                            ws.Cell(k + i, j + 1).Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);
                            ws.Cell(k + i, j + 1).Style.Alignment.SetVertical(XLAlignmentVerticalValues.Center);
                        }


                        j++;
                    }
                }

                for (var i = 0; i < noofsplit - 1; i++)
                {
                    j = 0; colst = 1; k = 1; strold = "";
                    for (int c = 0; c < dt.Columns.Count; c++)
                    {
                        //if (strold != "")
                        //{
                        if (strold != dt.Columns[c].ColumnName.ToString().Split('^')[i])
                        {
                            flgb = true;
                            if (strold != "")
                            {
                                ws.Range(ws.Cell(k + i, colst), ws.Cell(k + i, j)).Merge();
                            }
                            cntc = 0;
                        }
                        //}
                        if (flgb == true)
                        {
                            colst = j + 1;
                        }
                        flgb = false;
                        strold = dt.Columns[c].ColumnName.ToString().Split('^')[i];
                        cntc++;
                        if (c == dt.Columns.Count - 1)
                        {
                            ws.Range(ws.Cell(k + i, colst), ws.Cell(k + i, j + 1)).Merge();
                            cntc = 0;
                        }

                        j++;
                    }
                }


                int rowst = 0;
                for (int c = 0; c < dt.Columns.Count; c++)
                {
                    strold = dt.Columns[c].ColumnName.ToString().Split('^')[0];
                    colst = 1; k = 1; flgb = false; rowst = 1;


                    for (var i = 0; i < noofsplit; i++)
                    {
                        //strold = "";                                                   
                        if (dt.Columns[c].ColumnName.ToString().Split('^')[i] != "" && flgb == true)
                        {
                            ws.Range(ws.Cell(rowst, c + 1), ws.Cell(i, c + 1)).Merge();
                            flgb = false;
                            rowst++;
                        }

                        if (dt.Columns[c].ColumnName.ToString().Split('^')[i] == "")
                        {
                            flgb = true;
                        }

                        if (dt.Columns[c].ColumnName.ToString().Split('^')[i] != "" && flgb == false && i > 0)
                        {
                            rowst++;
                        }

                        if (i == noofsplit - 1 && flgb == true)
                        {
                            ws.Range(ws.Cell(rowst, c + 1), ws.Cell(i + 1, c + 1)).Merge();
                        }
                    }
                }
                /**/


                var rangeWithData = ws.Cell(noofsplit + 1, 1).InsertData(dt.AsEnumerable());

                //ws.Columns().AdjustToContents();//noofsplit + 1,  dt.Columns.Count

                IXLCell cell3 = ws.Cell(1, 1);
                IXLCell cell4 = ws.Cell(dt.Rows.Count + noofsplit, dt.Columns.Count);

                ws.Range(ws.Cell(k, 5), cell4).Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);
                ws.Range(cell3, cell4).Style.Border.SetInsideBorder(XLBorderStyleValues.Thin);
                ws.Range(cell3, cell4).Style.Border.SetOutsideBorder(XLBorderStyleValues.Medium);
                ws.SheetView.FreezeRows(noofsplit);
                ws.SheetView.FreezeColumns(noofcolfreeze);
                //}
                ws.Columns().AdjustToContents();
                ws.Rows().AdjustToContents();

                ws.Columns(1, 3).Width = 25;
               



                ws.Range(1, 1, 1, dt.Columns.Count).Style.Alignment.WrapText = true;

                ws.Rows().AdjustToContents();

                //Export the Excel file.
                HttpContext.Current.Response.Clear();
                HttpContext.Current.Response.Buffer = true;
                HttpContext.Current.Response.Charset = "";
                HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

                //Response.ContentType = "application/vnd.ms-excel";
                HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=" + Ds.Tables[0].Rows[0][0].ToString() + ".xlsx");
                using (MemoryStream MyMemoryStream = new MemoryStream())
                {
                    wb.SaveAs(MyMemoryStream);
                    MyMemoryStream.WriteTo(HttpContext.Current.Response.OutputStream);
                    HttpContext.Current.Response.Flush();
                    HttpContext.Current.Response.End();
                }
            }
        }
        catch (Exception ex)
        {
            // string ProjectTitle = ConfigurationManager.AppSettings["Title"];
            //clsSendLogMail.fnSendLogMail(ex.Message, ex.ToString(), "FrmDownload Page", "Download Page", "Error in FrmDownload Page in " + ProjectTitle);
        }
        finally
        {
         
        }

    }



}