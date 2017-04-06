<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
int templateId = Util.getIntValue(request.getParameter("loginTemplateId"));
String templateType="",loginTemplateTitle="",imageId="";
loginTemplateTitle = Util.null2String(request.getParameter("loginTemplateTitle"));
templateType = Util.null2String(request.getParameter("templateType"));
String sqlLoginTemplate = "SELECT * FROM SystemLoginTemplate WHERE loginTemplateId="+templateId+"";	
rs.executeSql(sqlLoginTemplate);
if(rs.next()){
	if(templateType.equals(""))	templateType = rs.getString("templateType");
	if(loginTemplateTitle.equals(""))	loginTemplateTitle = rs.getString("loginTemplateTitle");
	imageId = rs.getString("imageId");
}
if("site".equals(templateType)){
	response.sendRedirect("/page/maint/login/Page.jsp?templateId="+templateId);
	return;
} else if("H2".equals(templateType)) {
	response.sendRedirect("/wui/theme/ecology7/page/login.jsp?templateId="+templateId);
    return;
}
%>

<html>
<head>
<title><%=loginTemplateTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link rel="stylesheet" type="text/css" href="/css/Weaver.css">
</head>


<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" margin=0 oncontextmenu="return false;">


<%
if(templateType.equals("V")){
%>
<table width="100%" height=100% border="0" cellspacing="0" cellpadding="0"  bgcolor="#FFFFFF">
<tr> 
<td width="489" rowspan="2" valign="top" style="<%if(imageId.equals("")){out.println("background-image:url(/images_face/login/left.jpg)");}else{out.println("background-image:url(/LoginTemplateFile/"+imageId+")");}%>"></td>
<td valign="top"> 
  <div align="left">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td height="260">&nbsp;</td>
	  </tr>
	  <tr>
		<td height="217">
		  <table width="100%" border="0" cellspacing="0" cellpadding="0" height="217" background="/images_face/login/tablebg.jpg">
	<form name=form1 action= "VerifyLogin.jsp"  method=post onSubmit="return checkall();">
			  <tr> 
				<td height="85">&nbsp;</td>
				<td height="85" valign="bottom" style="color:#FF0000;font-size:9pt">提示信息...</td>
			  </tr>
			  <tr> 
				<td height="20" width="150">
				  <table width="150" border="0" cellspacing="0" cellpadding="0">
					<tr>
					  <td></td>
					</tr>
				  </table>
				</td>
				<td height="20"> 
				  <input type="text" name="loginid" class="stedit" size="10">
				</td>
			  </tr>
			  <tr> 
				<td colspan="2" height="18">&nbsp; </td>
			  </tr>
			  <tr> 
				<td height="20" width="150"></td>
				<td height="20"> 
				  <input type="password" name="userpassword" class="stedit" size="10" >
				</td>
			  </tr>
			  <tr> 
				<td colspan="2" height="18">&nbsp; </td>
			  </tr>
			  <tr> 
				<td width=150 height="20">&nbsp;</td>
				<td height="20"> 
				  <input type="button" class="submit" name="Submit" value="&gt;&gt; 登 录">
				</td>
			  </tr>
			  <tr> 
				<td>&nbsp;</td>
			  </tr>
			</form>
		  </table>
		</td>
	  </tr>
	  <tr>
		<td height="19" background="/images_face/login/url.jpg">&nbsp;</td>
	  </tr>
	  <tr>          
		  <td>	
			 <table width="100%" height=100% border="0" cellspacing="20" cellpadding="0"  bgcolor="#FFFFFF">
			 <tr> 
			 <td><span style="line-height: 20px"> <font style="color:#990000;font-weight: bold">提示：</font>泛微协同商务系统需要运行在<font style="color:#5F7DD0;font-weight: bold">IE5.0以上</font> 以及使用 <font style="color:#5F7DD0;font-weight: bold">Microsoft 的虚拟机(VM)</font>；如果您是首次登录系统请确认您的浏览器是否是IE5.0以上；Microsoft 的虚拟机(VM)下载请直接点击<a href="/weaverplugin/msjavx86.exe"><font style="color:#5F7DD0;font-weight: bold;TEXT-DECORATION: underline">这里</font></a>下载安装，该插件只需在首次下载安装后即可，不需要重复安装。</span>
			 </td>
			 </tr>
			 </table>
		  </td>
	  </tr>
	</table>
  </div>
</td>
</tr>
</table>
<%
}else{
%>	
<form name=form1 action= "VerifyLogin.jsp"  method=post onSubmit="return checkall();">


<table width="100%" cellspacing="0" cellpadding="0">
<tr>
<td align="right"><img src="/images_face/login/weaverlogo.gif" width="325" height="50"></td>
</tr>
<tr>
<td style="height:370px;<%if(imageId.equals("")){out.println("background-image:url(/images_face/login/loginLanguage.jpg)");}else{out.println("background-image:url(/LoginTemplateFile/"+imageId+")");}%>">
 <table style="margin:100px 0 0 570px;border-collapse:collapse;color:white"><tr><td>&nbsp;提示信息...</td></tr></table>
 <input name="loginid" type="text" size="15" style="margin:0px 0 0 570px"><br/>
 <input name="userpassword" type="password" size="15" style="margin:10px 0 0 570px"><br/>
 <button type="" style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; BACKGROUND-IMAGE: url(/images_face/login/dengru.gif); OVERFLOW: hidden; BORDER-LEFT: medium none; WIDTH: 78px; CURSOR: hand; BORDER-BOTTOM: medium none; BACKGROUND-REPEAT: no-repeat; HEIGHT: 28px;margin:25px 0 0 608px">
 </td>
</tr>
</table>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
<tr>
<td width="2%" valign="top"><img src="/images_face/login/copyright.gif" width="449" height="80"></td>
<td width="98%">
<table width="97.5%"  border="0" cellspacing="0" cellpadding="0">
  <tr><td>
		<span style="line-height: 20px; font-size:9pt" cellspacing="50" cellpadding="50"> <font style="color:#990000;font-weight: bold">提示：</font>本系统需要运行在<font style="color:#5F7DD0;font-weight: bold">IE6.0</font> 以及使用 <font style="color:#5F7DD0;font-weight: bold">Microsoft 的虚拟机(VM)</font>；如果您是首次登录系统请确认您的浏览器是否是IE6.0；Microsoft 的虚拟机(VM)下载请直接点击<a href="/weaverplugin/msjavx86.exe"><font style="color:#5F7DD0;font-weight: bold;TEXT-DECORATION: underline">这里</font></a>下载安装，该插件只需在首次下载安装后即可，不需要重复安装。</span>
  <br> 
</td></tr>
</table>
</td>
</tr>
</table>

</form>
<%}%>
</body>
</html>
