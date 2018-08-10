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
                    WebHelper.ResponseWeb(context, jsonString);
                }
                else
                {
                    WebHelper.ResponseWeb(context, null);
                }
                break;
            //注册 、修改
            case "SetPersonInfo":
                string FNAME = context.Request["FNAME"];  //家长姓名
                string FPHONENO = context.Request["FPHONENO"];  //手机号
                string FBANKNO = context.Request["FBANKNO"];  //银行账号
                string FADDRESS = context.Request["FADDRESS"];  //开户支行
                string FBANKNAME = context.Request["FBANKNAME"];  //户名

                try
                {
                    DataTable dtGetFuserID = DBHelper.query("select FUserid from T_YSB_WEIXINUSER where FOPENID='" + openid + "'");
                    if (dtGetFuserID.Rows.Count > 0)
                    {
                        //openid 存在，则修改数据
                        string FUSERID = dtGetFuserID.Rows[0][0].ToString();
                        string updateSql = string.Format("update T_YSB_WEIXINUSER set FPHONENO = '{0}',FBANKNO='{1}' where FUSERID={2} ;", FPHONENO, FBANKNO, FUSERID);
                        string updateSql_L = string.Format("update T_YSB_WEIXINUSER_L set FNAME='{0}',FADDRESS='{1}',FBANKNAME='{2}' where FUSERID={3} ;", FNAME, FADDRESS, FBANKNAME, FUSERID);
                        if (DBHelper.ExecuteSql(updateSql + updateSql_L) != 0)
                        {
                            WebHelper.ResponseWeb(context, "{\"msg\":\"保存成功!\"}");
                        }
                    }
                    else
                    {
                        //openid 不存在，则注册
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