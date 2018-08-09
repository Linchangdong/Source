using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;

/// <summary>
/// WebHelper 的摘要说明
/// </summary>
public static class WebHelper
{
    public static void ResponseWeb(HttpContext context, string strJson)
    {
        context.Response.Clear();
        context.Response.ContentEncoding = Encoding.UTF8;
        context.Response.ContentType = "text/json";
        context.Response.Write(strJson);
        context.Response.Flush();
        context.Response.End();
    }

    /// <summary>
    /// DataTable转化为Json格式数据
    /// </summary>
    /// <param name="table"></param>
    /// <returns></returns>
    public static string DataTableToJson(DataTable table)
    {
        List<Dictionary<string, object>> list = new List<Dictionary<string, object>>();

        foreach (DataRow row in table.Rows)
        {
            Dictionary<string, object> dict = new Dictionary<string, object>();
            foreach (DataColumn col in table.Columns)
            {
                dict[col.ColumnName] = row[col];
            }
            list.Add(dict);
        }
        JavaScriptSerializer jss = new JavaScriptSerializer();
        return jss.Serialize(list);
    }

    /// <summary>
    /// DataTable转化为Json格式数据
    /// </summary>
    /// <param name="table"></param>
    /// <returns></returns>
    public static string DataTableToJsonWithJsonNet(DataTable table)
    {
        string JsonString = string.Empty;
        JsonString = JsonConvert.SerializeObject(table);
        return JsonString;
    }

}