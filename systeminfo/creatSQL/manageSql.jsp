<html>
<head>
<meta http-equiv="Content-Language" content="zh-cn">
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>所要生成的SQL语句的表名</title>
<style type="text/css">
<!--
.unnamed1 {  font-family: "宋体"; font-size: 14px; font-style: normal}
-->
</style>
</head>

<body>

<form method="POST" action="creatSql.jsp">
  
  <div align="center" class="unnamed1">生成SQL语句: </div>
  <div align="left"></div>
  <table border="0" width="83%" height="59" align="center">
    <tr> 
      <td width="50%" align="center" height="17" bgcolor="#3399FF"> 
        <div align="right" class="unnamed1">所要生成的SQL语句的表名:</div>
      </td>
      <td width="50%" align="center" height="17" bgcolor="#3399FF"> 
        <div align="left"> <span class="unnamed1"> 
          <input type="text" name="TB_name" size="20">
          </span></div>
      </td>
    </tr>
    <tr> 
      <td width="50%" align="center" height="12" bgcolor="#3399FF"> 
        <div align="right" class="unnamed1">是否是自增长</div>
      </td>
      <td width="50%" align="center" height="12" bgcolor="#3399FF"> 
        <div align="left"> <span class="unnamed1"> 
          <select name="isAutoAdd">
            <option selected value="1">是自增长</option>
            <option value="0">不是自增长</option>
          </select>
          </span></div>
      </td>
    </tr>
    <tr> 
      <td width="50%" align="center" height="18" bgcolor="#3399FF"></td>
      <td width="50%" align="center" height="18" bgcolor="#3399FF"> 
        <div align="left"> <span class="unnamed1"> 
          <input type="submit" value="提交" name="B1">
          <input type="reset" value="重置" name="B2">
          </span></div>
      </td>
    </tr>
  </table>
</form>
</body>

</html>
