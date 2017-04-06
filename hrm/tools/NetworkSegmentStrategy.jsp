<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SearchComInfo1" class="weaver.proj.search.SearchComInfo" scope="session" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />

<%
 if(!HrmUserVarify.checkUserRight("NetworkSegmentStrategy:All",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }

String id = Util.null2String(request.getParameter("id"));
//System.out.println("============================");
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(21384,user.getLanguage());
String needfav ="1";
String needhelp ="";

//TD3968
//added by hubo,2006-03-23
int perpage=Util.getIntValue(request.getParameter("perpage"),10);

String SqlWhere = "";
/*È¨ÏÞ£­begin*/
boolean canview=false;
boolean canedit=false;
boolean iscreater=false;
boolean ismanager=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
boolean isshare=false;
String iscustomer="0";



String backFields = "id,inceptipaddress,endipaddress,createrid,createdate,createtime,segmentdesc";
String sqlFrom = " from HrmnetworkSegStr";
String tableString=""+
			  "<table  pagesize=\""+perpage+"\" tabletype=\"none\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
			  "<head>"+                             
					  "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(21385,user.getLanguage())+"\" column=\"inceptipaddress\" otherpara=\"column:endipaddress\" target=\"_self\"  href=\"/hrm/tools/NetworkSegmentStrategyEdit.jsp\" linkkey=\"id\" linkvaluecolumn=\"id\" transmethod=\"weaver.hrm.tools.IpTransMethod.getIpAddress\" />"+
					  "<col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelName(21386,user.getLanguage())+"\" column=\"segmentdesc\"   target=\"_self\" linkvaluecolumn=\"id\" />"+
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"createrid\" orderkey=\"createrid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"/>"+
					  "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"\" column=\"createdate\" otherpara=\"column:createtime\" transmethod=\"weaver.hrm.tools.IpTransMethod.getDateTime\" orderkey=\"createdate\"/>"+
			  "</head>"+
			  "<operates width=\"5%\">"+
			  "    <operate href=\"javascript:onDelete()\"  text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\"  index=\"0\"/>"+
			  "</operates>"+
			  "</table>";


%>
<html>
<head>
<link href="/css/Weaver.css" type="text/css" rel="stylesheet">
<script type="text/javascript">
function onAdd(){
	location.href="/hrm/tools/NetworkSegmentStrategyAdd.jsp";
}
function onDelete(id){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
   location.href = "/hrm/tools/NetworkSegmentStrategyOperation.jsp?id="+id+"&operation=delete";
	}
}
</script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javascript:onAdd(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
//RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+101+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=96% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="0" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
			<td valign="top"><wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" isShowTopInfo="true"/></td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="0" colspan="3"></td>
</tr>
</table>
<form><input type="hidden" name="s" value="<%=SqlWhere%>"/></form>
</body>
</html>