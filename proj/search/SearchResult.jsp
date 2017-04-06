<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SearchComInfo1" class="weaver.proj.search.SearchComInfo" scope="session" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />

<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+SystemEnv.getHtmlLabelName(356,user.getLanguage());
String needfav ="1";
String needhelp ="";

//TD3968
//added by hubo,2006-03-23
int perpage=Util.getIntValue(request.getParameter("perpage"),10);

String SqlWhere = "";
if(!SearchComInfo1.FormatSQLSearch(user.getLanguage()).equals("")){
	SqlWhere = SearchComInfo1.FormatSQLSearch(user.getLanguage()) +" and t1.id = t2.prjid and t2.usertype="+user.getLogintype()+" and t2.userid="+user.getUID();
}else{
	SqlWhere = " where t1.id = t2.prjid and t2.usertype="+user.getLogintype()+" and t2.userid="+user.getUID();
}
SearchComInfo1.resetSearchInfo();
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



String backFields = "t1.id,t1.name,t1.procode,t1.prjtype,t1.worktype,t1.manager,t1.department,t1.status";
String sqlFrom = " from Prj_ProjectInfo  t1,PrjShareDetail  t2";
String popedomOtherpara = user.getLogintype()+"_"+user.getUID();
String tableString=""+
			  "<table  pagesize=\""+perpage+"\" tabletype=\"none\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
			  "<head>"+                             
					  "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\"   target=\"_blank\" linkkey=\"ProjID\" linkvaluecolumn=\"id\" href=\"/proj/data/ViewProject.jsp\" orderkey=\"name\"/>"+
					  "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(17852,user.getLanguage())+"\" column=\"procode\"   target=\"_blank\"  linkkey=\"ProjID\" linkvaluecolumn=\"id\" href=\"/proj/data/ViewProject.jsp\" orderkey=\"procode\"/>"+
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(586,user.getLanguage())+"\" column=\"prjtype\" orderkey=\"prjtype\" transmethod=\"weaver.splitepage.transform.SptmForProj.getProjTypeName\"/>"+
					  "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(432,user.getLanguage())+"\" column=\"worktype\" orderkey=\"worktype\" transmethod=\"weaver.splitepage.transform.SptmForProj.getWorkTypeName\"/>"+
					  "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(144,user.getLanguage())+"\" column=\"manager\" orderkey=\"manager\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"/>"+
					  "<col width=\"12%\"  text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"department\" orderkey=\"department\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\"/>"+
					  "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(587,user.getLanguage())+"\"  column=\"status\" orderkey=\"status\" transmethod=\"weaver.splitepage.transform.SptmForProj.getProjStatusName\" otherpara=\""+user.getLanguage()+"\"/>"+ 
			  "</head>"+
			  "<operates width=\"12%\">"+
			  "<popedom transmethod=\"weaver.splitepage.operate.SpopForProj.getProjListPope\"  otherpara=\""+popedomOtherpara+"\"></popedom>"+
			  "    <operate href=\"javascript:doProjEdit()\"  text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\"  index=\"0\"/>"+
			  "    <operate href=\"javascript:doProjShare()\"  text=\""+SystemEnv.getHtmlLabelName(119,user.getLanguage())+"\"  index=\"1\"/>"+	
			  "</operates>"+
			  "</table>";


%>
<html>
<head>
<link href="/css/Weaver.css" type="text/css" rel="stylesheet">
<script type="text/javascript">
function onReSearch(){
	location.href="/proj/search/Search.jsp";
}
function doProjEdit(id){
   //location.href = "/proj/data/EditProject.jsp?ProjID="+id+"&from=viewProject&isManager=true";
   window.open("/proj/data/EditProject.jsp?ProjID="+id+"&from=viewProject&isManager=true", "", "toolbar,resizable,scrollbars,dependent,height=600,width=800,top=0,left=100") ; 
}
function doProjShare(id){
	location.href = "/proj/data/AddShare.jsp?prjid="+id;
}
function exportXLS(){
	//window.status = "Loading...";
	var o = document.forms[0];
	o.action = "SearchResultXLS.jsp";
	o.submit();
}
</script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:onReSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(16699,user.getLanguage())+",javascript:exportXLS(),_top} " ;
RCMenuHeight += RCMenuHeightStep;

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
	<td height="10" colspan="3"></td>
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
	<td height="10" colspan="3"></td>
</tr>
</table>
<form><input type="hidden" name="s" value="<%=SqlWhere%>"/></form>
</body>
</html>
