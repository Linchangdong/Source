<%@ WebHandler Language="C#" Class="BuyCarServer" %>

using System;
using System.Web;
using System.Data;
using System.IO;
using Newtonsoft.Json.Linq;

public class BuyCarServer : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        //context.Response.Clear();
        //context.Response.ContentType = "application/json;charset=utf-8";
        //DataTable dt = DBHelper.query("select * from sc_personinfo");
        //string jsonString = WebHelper.DataTableToJson(dt);
        //context.Response.Write(jsonString);

        string method = context.Request["method"];
        string curStr = context.Request["page"];
        string openid = context.Request["openid"];
        switch (method)
        {
            case "GetPersonInfo":
                DataTable dt = DBHelper.query(@"select a.FOPENID,a.FPHONENO,a.FBANKNO,b.FNAME,b.FADDRESS,b.FBANKNAME from T_YSB_SHOPPINGCART a
                                                    join T_YSB_SHOPPINGCART_L b on a.FUSERID=b.FUSERID
                                                    where a.FOPENID='" + openid + "'");
                if (dt.Rows.Count > 0)
                {
                    string jsonString = WebHelper.DataTableToJson(dt);
                    context.Response.Write(jsonString);
                }
                else 
                {
                    context.Response.Write(null);
                }                              
                break;
        }
    }
    private void GetStudent(HttpContext context)
    {
        JObject jObject = new JObject();
        jObject.Add("result", true);
        WebHelper.ResponseWeb(context, jObject.ToString());
    }
    
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }


}