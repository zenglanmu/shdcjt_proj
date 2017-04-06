<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DocNewsComInfo" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(70,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(68,user.getLanguage());
String needfav ="1";
String needhelp ="";

String depid = Util.null2String(request.getParameter("depid"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("DocFrontpageAdd:add", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='DocNewsAdd.jsp',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("DocFrontpage:log", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =6',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<TABLE class=ListStyle cellspacing=1 >
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></th>
  </tr>
  <TR class=Line><TD colSpan=3></TD></TR>
  <%
  int i=0; 

while(DocNewsComInfo.next()) {
	String id=DocNewsComInfo.getDocNewsid();
	String name = DocNewsComInfo.getDocNewsname();
	String status = DocNewsComInfo.getDocNewsstatus();
	String depart = DocNewsComInfo.getDocNewsDepart();
	String publishtype = DocNewsComInfo.getPublishtype();
	if(!depid.equals("") && !depart.equals(depid)) continue;
	//if(!status.equals("1")) continue;
	if(i==0){	
	i=1;
%> <TR class=datadark>
<%}
else{
	i=0;
%> <TR class=datalight>
<%}
%>
  <td><%if(HrmUserVarify.checkUserRight("DocFrontpageEdit:Edit", user)){
%><A href="DocNewsEdit.jsp?id=<%=id%>"><%}%><%=name%><%if(HrmUserVarify.checkUserRight("DocFrontpageEdit:Edit", user)){
%></A><%}%> </td>
  <td><%if(status.equals("1")){%><%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(415,user.getLanguage())%><%}%></td>
  <td>
	<%if(status.equals("1")){%>
		<%if(!publishtype.equals("0")){%>
			<a href="/docs/news/NewsDsp.jsp?id=<%=id%>" target=_blank><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></a>
		<%}else{%>
			<a href="/pweb/index.jsp?id=<%=id %>" target=_blank><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></a>
		<%}%>
	<%}%>
  
  </td>
  </tr>
<%
}
%>
 
 </table>
 
 		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
 
 </BODY></HTML>
