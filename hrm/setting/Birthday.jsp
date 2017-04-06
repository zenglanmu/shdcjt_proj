<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.util.ArrayList,
                 java.util.Iterator,
                 weaver.general.TimeUtil" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

String today = TimeUtil.getCurrentDateString();
ArrayList birthEmployers=(ArrayList)application.getAttribute("birthEmployers");
String themeType=request.getParameter("theme"); //主题类型，用户区分弹出生日提醒是否自动关闭
%>
<script>
<%if(!"ecology7".equals(themeType)){%>
    setTimeout('window.close();',10000);
<%}%>
</script>                 
<html>
<head>
<title>生日提醒</title>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
<table width="499" cellspacing="0" cellpadding="0" align="center" height="100%">
  <tr>
    <td align="left" valign="top" height="247"><img src="/images_face/ecologyFace_1/BirthdayBg_1.jpg"></td>
  </tr>
  <tr> 
    <td align="left" valign="top" background="/images_face/ecologyFace_1/BirthdayBg_2.jpg"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="30"><br>
          </td>
          <td width="220" align="left" valign="top"><font color="#FFFFFF"><br>
            添一份快乐,发张贺卡吧! <br>
            任何人都需要真诚的祝福,<br>
            你的亲人、你的友人,你的爱人……<br>
            送出你的心意吧!<br>
            <br>
            <br>
            <%=today%> </font></td>
          <td width="120">&nbsp;</td>
          <td align="left" valign="top"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td width="55" height="18"><font color="#FFFFFF">生日名单:</font></td>
                <td>&nbsp;</td>
              </tr>
              <% Iterator iter=birthEmployers.iterator();
              while(iter.hasNext()){
              %>
              <tr> 
                <td height="18">&nbsp;</td>
                <td><font color="#FFFFFF"><%=iter.next()%></font></td>
              </tr>
              <%}%>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>
