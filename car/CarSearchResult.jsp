<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<%
int userId = user.getUID();
int subCompanyId = user.getUserSubCompany1();
RecordSet.executeSql("select detachable from SystemSet");
int detachable=0;
if(RecordSet.next()){
    detachable=RecordSet.getInt("detachable");
   
}
if(detachable!=1){
subCompanyId=-1;
}
String carNo = Util.null2String(request.getParameter("carNo"));
String[] carType = request.getParameterValues("carType");
String factoryNo = Util.null2String(request.getParameter("factoryNo"));
String driver = Util.null2String(request.getParameter("driver"));
String startdate = Util.null2String(request.getParameter("startdate"));
String enddate = Util.null2String(request.getParameter("enddate"));

String sqlwhere = " where 1=1";
if(!carNo.equals("")){
	sqlwhere += " and carNo like '%"+carNo+"%'";
}
if(carType!=null&&carType.length>0){
	String carTypeTemp = "";
	for(int i=0;i<carType.length;i++){
		carTypeTemp +=","+carType[i];
	}
	carTypeTemp = carTypeTemp.substring(1);
	sqlwhere += " and carType in ("+carTypeTemp+")";
}
if(!factoryNo.equals("")){
	sqlwhere += " and factoryNo like '%"+factoryNo+"%'";
}
if(!startdate.equals("")){
	sqlwhere += " and buyDate >= '"+startdate+"'";
}
if(!enddate.equals("")){
	sqlwhere += " and buyDate <= '"+enddate+"'";
}
if(subCompanyId!=-1){
	sqlwhere += " and subCompanyId="+subCompanyId+"";
}
if(!driver.equals("")){
	sqlwhere += " and driver ='"+driver+"'";
}
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int	perpage=10;
%>

<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(20316,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
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
		<FORM id=weaver NAME=frmmain STYLE="margin-bottom:0" action="CarInfoOperation.jsp" method=post>
		<input type="hidden" name="operation" value="del">
		<TABLE width="100%">
			<tr>
				<td valign="top">
		        	<%
		            String backfields = "id, factoryNo, carNo, carType, driver, buyDate";
		            String fromSql  = "from CarInfo";
		            String sqlWhere = sqlwhere;
		            String orderby = "id" ;
		            String tableString = "";
		            tableString =" <table instanceid=\"CarTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
		                                     "		<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"desc\" sqlisdistinct=\"true\"/>"+
		                                     "		<head>"+
		                                     "			<col width=\"17%\"  text=\""+SystemEnv.getHtmlLabelName(20318,user.getLanguage())+"\" column=\"factoryNo\" orderkey=\"factoryNo\" />"+
		                                     "			<col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(20319,user.getLanguage())+"\" column=\"carNo\"  orderkey=\"carNo\" linkvaluecolumn=\"id\" linkkey=\"id\" href=\"/car/CarInfoView.jsp?flag=1&amp;fg=0\" target=\"_self\"/>"+
		                                   	 "			<col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"carType\" orderkey=\"carType\" transmethod=\"weaver.car.CarTypeComInfo.getCarTypename\" />"+
		                                   	 "			<col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(17649,user.getLanguage())+"\" column=\"driver\"  orderkey=\"driver\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" />"+
		                      				 "			<col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(16914,user.getLanguage())+"\" column=\"buyDate\"  orderkey=\"buyDate\" />"+
		                                     "		</head>"+
		                                     "</table>";
		         %>
		         <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
				</td>
			</tr>
		</TABLE>
		</FORM>
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

<script language=vbs>
sub getStartDate()
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	document.all("startdatespan").innerHtml= returndate
	document.all("startdate").value=returndate
end sub

sub getEndDate()
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	document.all("enddatespan").innerHtml= returndate
	document.all("enddate").value=returndate
end sub
</script>
<script language=javascript>
function doSearch(){
	//document.frmmain.action="CarInfoMaintenance.jsp";
	document.frmmain.action="CarSearchResult.jsp";
	document.frmmain.submit();
}
function doDel(){
	if(isdel()){
		document.frmmain.submit();
	}
}
</script>
</body>
</html>