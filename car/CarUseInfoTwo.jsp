<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(19018,user.getLanguage());
String needfav ="1";
String needhelp ="";
int fg=0;
if(!(request.getParameter("fg")==null)){
    fg=Integer.parseInt(Util.null2String(request.getParameter("fg")));
}
String carId =  Util.null2String(request.getParameter("carId"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(fg==1){

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/car/CarInfoView.jsp?fg="+fg+"&&flag=1&&id="+carId+",_self} " ;
 RCMenuHeight += RCMenuHeightStep ;
}
if(fg==0){

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/car/CarInfoView.jsp?fg="+fg+"&&flag=1&&id="+carId+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(fg==2){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/car/CarUseInfo.jsp,_self} " ;
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
		<%
		int perpage = 10;
		String backFields = "t1.*";
		String sqlFrom = " from CarUseApprove t1,workflow_requestbase t2";
		String SqlWhere = "where t1.carId = "+carId+" and t1.requestid=t2.requestid and t2.currentnodetype<>0 ";
		String tableString=""+
			  "<table  pagesize=\""+perpage+"\" tabletype=\"none\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
			  "<head>"+                             
					  "<col width=\"15%\"  text=\"³µÅÆ\" column=\"carId\"   target=\"_self\" linkkey=\"id\" linkvaluecolumn=\"carId\"   href=\"/car/CarInfoView.jsp?flag=2&amp;fg="+fg+"\" transmethod=\"weaver.car.CarInfoComInfo.getCarNo\" />"+
					  "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(648,user.getLanguage())+"\" column=\"requestid\" orderkey=\"t1.requestid\" transmethod=\"weaver.workflow.request.RequestComInfo.getRequestname\"/>"+
					  "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"requestid\" orderkey=\"t2.requestid\" transmethod=\"weaver.workflow.request.RequestComInfo.getRequestStatus\"/>"+
					  "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(742,user.getLanguage())+"\"  column=\"startDate\" orderkey=\"startDate\" />"+ 
					  "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(743,user.getLanguage())+"\"  column=\"endDate\" orderkey=\"endDate\" />"+ 
			  "</head>"+
			  "</table>";
		%>
		<TABLE class=Shadow>
		<tr>
			<td valign="top"><wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" isShowTopInfo="true"/></td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
</body>
</html>
<script language="javascript">
function goback(){
 window.location.href="/car/CarInfoView.jsp?flag=1&&id=2";
}
</script>