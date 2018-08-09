<%@ WebHandler Language="C#" Class="PersonInfoServer" %>

using System;
using System.Web;
using System.Data;
using System.IO;
using Newtonsoft.Json.Linq;

public class PersonInfoServer : IHttpHandler
{
    public static string openid = "aaggdd";
    public void ProcessRequest(HttpContext context)
    {

        string method = context.Request["method"];
        string curStr = context.Request["page"];
        switch (method)
        {
            case "GetPersonInfo":
                //string openid = "aaggdd";
                DataTable dt = DBHelper.query(@"select a.FOPENID,a.FPHONENO,a.FBANKNO,b.FNAME,b.FADDRESS,b.FBANKNAME from T_YSB_WEIXINUSER a
                                                    join T_YSB_WEIXINUSER_L b on a.FUSERID=b.FUSERID
                                                    where a.FOPENID='" + openid + "'");
                if (dt.Rows.Count > 0)
                {
                    string jsonString = WebHelper.DataTableToJson(dt);
                    //context.Response.Write(jsonString);

                    WebHelper.ResponseWeb(context, jsonString);
                }
                else
                {
                    WebHelper.ResponseWeb(context, null);
                }
                break;
            //注册
            case "SetPersonInfo":
                string FNAME = context.Request["FNAME"];  //家长姓名
                string FPHONENO = context.Request["FPHONENO"];  //手机号
                string FBANKNO = context.Request["FBANKNO"];  //银行账号
                string FADDRESS = context.Request["FADDRESS"];  //开户支行
                string FBANKNAME = context.Request["FBANKNAME"];  //户名
                openid = "00002";

                try
                {
                    //保存入数据库
                    string sql1 = string.Format(@" insert into T_YSB_WEIXINUSER(FWEIXINPUBLICNO, FOPENID, FPHONENO, FBANKNO) 
                                                values('ysb', '{0}', '{1}', '{2}')", openid, FPHONENO, FBANKNO);

                    if (DBHelper.ExecuteSql(sql1) != 0)
                    {
                        string getId = "select FUserid from T_YSB_WEIXINUSER where FOPENID='" + openid + "'";
                        string FUserid = DBHelper.query(getId).Rows[0][0].ToString();

                        string sql2 = string.Format(@"insert into  T_YSB_WEIXINUSER_L(FLOCALEID,FUSERID, FNAME ,FADDRESS , FBANKNAME) 
                                              values(2025, {3},'{0}','{1}','{2}')", FNAME, FADDRESS, FBANKNAME, FUserid);
                        if (DBHelper.ExecuteSql(sql2) != 0)
                        {
                            WebHelper.ResponseWeb(context, "{\"msg\":\"保存成功!\"}");
                        }
                    }
                    else
                    {
                        WebHelper.ResponseWeb(context, "{\"msg\":\"保存失败!\"}");
                    }
                }
                catch (Exception e)
                {
                    throw e;
                }

                break;
        }
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }


}