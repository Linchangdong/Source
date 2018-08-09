<%@ WebHandler Language="C#" Class="CategoryServer" %>
using System;
using System.Web;
using Newtonsoft.Json.Linq;
using System.IO;

public class CategoryServer : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        string method = context.Request["method"];
        string curStr = context.Request["page"];
        switch (method)
        {
            case "GetStudent":
                
                GetStudent(context);
                break;
        }
    }

    private void GetStudent(HttpContext context)
    {
        JObject jObject = new JObject();
        jObject.Add("result", true);
        WebHelper.ResponseWeb(context, jObject.ToString());
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}