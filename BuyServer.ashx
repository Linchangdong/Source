<%@ WebHandler Language="C#" Class="BuyServer" %>

using System;
using System.Web;
using System.Data;
using System.IO;
using Newtonsoft.Json.Linq;

public class BuyServer : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        string method = context.Request["method"];
        switch (method)
        {
            case "SubmitToCar":
                string productId = context.Request["productId"];
                string auxpropId = context.Request["auxpropId"];
                string name = context.Request["name"];
                string count = context.Request["count"];

                object countObj = DBHelper.ExecuteSqlScalar(string.Format(@"insert into T_YSB_SHOPPINGCART(FPRODUCTID, FSTUDENTID, FAUXPROPID, FCOUNT) output  inserted.FSHOPPINGCARTID values({0}, {1}, {2}, {3}) "
                                , productId, 1, auxpropId, count));
                if (Convert.ToInt64(countObj) > 0)
                {
                        DBHelper.ExecuteSqlScalar(string.Format(@"insert into T_YSB_SHOPPINGCART_L(FLOCALEID, FSHOPPINGCARTID, FNAME) values(2502, {0}, '{1}') "
                                , countObj, name));
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