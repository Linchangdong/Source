using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// WeixinContext 的摘要说明
/// </summary>
public class WeixinContext
{
    public WeixinContext()
    {
        //
        // TODO: 在此处添加构造函数逻辑
        //
    }

    /// <summary>
    /// 微信信息
    /// </summary>
    public WeixinInfo WeixinInfo { get; set; }

    /// <summary>
    /// 家长信息
    /// </summary>
    public Householder Householder { get; set; }

    /// <summary>
    /// 选择的学生
    /// </summary>
    public StudentInfo SelectedStudentInfo { get; set; }

    /// <summary>
    /// 配置信息
    /// </summary>
    public ConfigInfo ConfigInfo { get; set; }

}