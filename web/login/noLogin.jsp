<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/web/inc/WebServer.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<title></title>
<link href="/web/css/style.css" rel="stylesheet" type="text/css">
</head>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<table width="100%" border="0" cellspacing="0" cellpadding="0" height="90" >
	<tr> 
		<td align="center" valign="middle" >
			<table width="100%" border="0" cellspacing="0" cellpadding="3">
				<tr height="35"> 
					<td valign="top" >请您登录，或注册！</td>
				</tr>
				<tr> 
				  <td>
				  <a href="<%=webServerForLogin%>" target="_top"><img src="/web/images/button_login.gif" border="0">
				  </a>&nbsp;&nbsp;&nbsp;<a href="<%=webServerRegist%>" target="_top"><img src="/web/images/button_reg.gif" border="0"></a>
				  </td>
				</tr>
			  </table>
		</td>
	</tr>
</table>

</body>
</html>