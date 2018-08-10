using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

public static class DBHelper
{
    //初始化数据
    public static string ConnStr = "data source=weixin.lingqingkeji.com;initial catalog=bolansi;user id=sa;pwd=Kingdee$2015";
    public static string path = AppDomain.CurrentDomain.BaseDirectory;    //获取当前目录
    //读取Config里的配置

    /// <summary>
    /// 执行查询语句，返回一个DataTable
    /// </summary>
    public static DataTable query(string SQLString)
    {
        using (SqlConnection connection = new SqlConnection(ConnStr))
        {
            try
            {
                connection.Open();
                SqlCommand cmd = connection.CreateCommand();
                cmd.CommandText = SQLString;
                cmd.CommandTimeout = 0;
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();

                    da.Fill(dt);
                    connection.Close();
                    return dt;
                }
            }
            catch (SqlException ex)
            {
                connection.Close();
                throw new Exception(ex.Message);
            }

        }
    }

    /// <summary>
    /// 执行SQL语句，返回影响的记录数
    /// </summary>
    /// <param name="SQLString">SQL语句</param>
    /// <returns>影响的记录数</returns>
    public static int ExecuteSql(string SQLString)
    {
        using (SqlConnection connection = new SqlConnection(ConnStr))
        {
            using (SqlCommand cmd = new SqlCommand(SQLString, connection))
            {
                int rows;
                try
                {
                    cmd.CommandTimeout = 0;
                    connection.Open();
                    rows = cmd.ExecuteNonQuery();
                    connection.Close();
                    return rows;
                }
                catch (SqlException E)
                {
                    connection.Close();
                    throw new Exception(E.Message);

                }

            }
        }
    }

    /// <summary>
    /// 执行SQL语句，返回影响的记录数
    /// </summary>
    /// <param name="SQLString">SQL语句</param>
    /// <returns>影响的记录数</returns>
    public static object ExecuteSqlScalar(string SQLString)
    {
        using (SqlConnection connection = new SqlConnection(ConnStr))
        {
            using (SqlCommand cmd = new SqlCommand(SQLString, connection))
            {
                object firstObj;
                try
                {
                    cmd.CommandTimeout = 0;
                    connection.Open();
                    firstObj = cmd.ExecuteScalar();
                    connection.Close();
                    return firstObj;
                }
                catch (SqlException E)
                {
                    connection.Close();
                    throw new Exception(E.Message);

                }

            }
        }
    }

    /// <summary>
    /// 执行多条SQL语句，实现数据库事务。
    /// </summary>
    /// <param name="SQLStringList">SQL语句的哈希表（key为sql语句，value是该语句的SqlParameter[]）</param>
    public static void ExecuteSqlTran(Hashtable SQLStringList)
    {
        using (SqlConnection conn = new SqlConnection(ConnStr))
        {
            conn.Open();
            using (SqlTransaction trans = conn.BeginTransaction())
            {
                SqlCommand cmd = new SqlCommand();
                try
                {
                    //循环
                    foreach (DictionaryEntry myDE in SQLStringList)
                    {
                        string cmdText = myDE.Key.ToString();
                        SqlParameter[] cmdParms = (SqlParameter[])myDE.Value;
                        PrepareCommand(cmd, conn, trans, cmdText, cmdParms);
                        int val = cmd.ExecuteNonQuery();
                        cmd.Parameters.Clear();

                        trans.Commit();
                    }
                }
                catch
                {
                    trans.Rollback();
                    throw;
                }
            }
        }
    }

    private static void PrepareCommand(SqlCommand cmd, SqlConnection conn, SqlTransaction trans, string cmdText, SqlParameter[] cmdParms)
    {
        if (conn.State != ConnectionState.Open)
            conn.Open();
        cmd.Connection = conn;
        cmd.CommandText = cmdText;
        if (trans != null)
            cmd.Transaction = trans;
        cmd.CommandType = CommandType.Text;//cmdType;
        if (cmdParms != null)
        {
            foreach (SqlParameter parm in cmdParms)
                cmd.Parameters.Add(parm);
        }
    }

    /// <summary>
    /// 向数据库里插入图像格式的字段(和上面情况类似的另一种实例)
    /// </summary>
    /// <param name="strSQL">SQL语句</param>
    /// <param name="fs">图像字节,数据库的字段类型为image的情况</param>
    /// <returns>影响的记录数</returns>
    public static int ExecuteSqlInsertImg(string strSQL, byte[] bt, string ConnStr, string para)
    {
        using (SqlConnection connection = new SqlConnection(ConnStr))
        {
            SqlCommand cmd = new SqlCommand(strSQL, connection);
            System.Data.SqlClient.SqlParameter myParameter = new System.Data.SqlClient.SqlParameter(para, SqlDbType.Image);
            myParameter.Value = bt;
            cmd.Parameters.Add(myParameter);
            try
            {
                connection.Open();
                int rows = cmd.ExecuteNonQuery();
                return rows;
            }
            catch (System.Data.SqlClient.SqlException E)
            {
                throw new Exception(E.Message);
            }
            finally
            {
                cmd.Dispose();
                connection.Close();
            }
        }
    }

    /// <summary>
    /// 将日志写入日志档
    /// </summary>
    public static void write(string fileName, string str)
    {
        using (FileStream fs = File.Open(fileName, FileMode.Append))
        {
            StreamWriter sw = new StreamWriter(fs);
            sw.WriteLine(str);
            sw.Flush();
            sw.Close();
        }
    }
}

