<%@ WebHandler Language="C#" Class="StudentInfoServer" %>

using System;
using System.Web;
using System.Data;
using System.IO;
using Newtonsoft.Json.Linq;

public class StudentInfoServer : IHttpHandler
{
    public static string openid = "aaggdd";
    public void ProcessRequest(HttpContext context)
    {
        string method = context.Request["method"];
        string curStr = context.Request["page"];
        switch (method)
        {
            case "GetStudentInfo":
                //string openid = "aaggdd";
                string FUSERID = "1";
                DataTable dt = DBHelper.query(@"select FCLASS,CONVERT(varchar(100), FBIRTHDAY, 23) FBIRTHDAY,case FSEX when 0 then '男' else '女' end FSEX, FHEIGHT, FWEIGHT,FNAME from T_YSB_WEIXINSTUDENT a
                                                join T_YSB_WEIXINSTUDENT_L b on a.FSTUDENTID=b.FSTUDENTID
                                                where a.FUSERID=" + FUSERID);
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
            case "SetStudentInfo":
                string FNAME = context.Request["FNAME"];  //学生姓名
                string FBIRTHDAY = context.Request["FBIRTHDAY"];  //证件出生日期
                string FCLASS = context.Request["FCLASS"];  //班级
                string FSEX = context.Request["FSEX"];  //性别
                string FHEIGHT = context.Request["FHEIGHT"];  //身高
                string FWEIGHT = context.Request["FWEIGHT"];  //体重
                return;
//                try
//                {
                    
//                    DataTable dtGetStudentId = DBHelper.query("select FSTUDENTID from T_YSB_WEIXINSTUDENT_L where FNAME='" + FNAME + "'");
//                    if (dtGetStudentId.Rows.Count > 0)
//                    {
//                        string FSTUDENTID = dtGetStudentId.Rows[0][0].ToString();
//                        string updateSql = string.Format("update T_YSB_WEIXINUSER set FPHONENO = '{0}',FBANKNO='{1}' where FUSERID={2} ;", FPHONENO, FBANKNO, FUSERID);
//                        string updateSql_L = string.Format("update T_YSB_WEIXINUSER_L set FNAME='{0}',FADDRESS='{1}',FBANKNAME='{2}' where FUSERID={3} ;", FNAME, FADDRESS, FBANKNAME, FUSERID);
//                        if (DBHelper.ExecuteSql(updateSql + updateSql_L) != 0)
//                        {
//                            WebHelper.ResponseWeb(context, "{\"msg\":\"保存成功!\"}");
//                        }
//                    }
//                    else
//                    {
//                        //openid 不存在，则注册
//                        string sql1 = string.Format(@" insert into T_YSB_WEIXINUSER(FWEIXINPUBLICNO, FOPENID, FPHONENO, FBANKNO) 
//                                                values('ysb', '{0}', '{1}', '{2}')", openid, FPHONENO, FBANKNO);

//                        if (DBHelper.ExecuteSql(sql1) != 0)
//                        {
//                            string getId = "select FUserid from T_YSB_WEIXINUSER where FOPENID='" + openid + "'";
//                            string FUserid = DBHelper.query(getId).Rows[0][0].ToString();

//                            string sql2 = string.Format(@"insert into  T_YSB_WEIXINUSER_L(FLOCALEID,FUSERID, FNAME ,FADDRESS , FBANKNAME) 
//                                              values(2025, {3},'{0}','{1}','{2}')", FNAME, FADDRESS, FBANKNAME, FUserid);
//                            if (DBHelper.ExecuteSql(sql2) != 0)
//                            {
//                                WebHelper.ResponseWeb(context, "{\"msg\":\"保存成功!\"}");
//                            }
//                        }
//                        else
//                        {
//                            WebHelper.ResponseWeb(context, "{\"msg\":\"保存失败!\"}");
//                        }
//                    }

//                }
//                catch (Exception e)
//                {
//                    throw e;
//                }

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