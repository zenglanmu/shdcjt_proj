<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(18822,user.getLanguage());
String needfav ="1";
String needhelp ="";

int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage = 10;

String userid = ""+user.getUID();
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
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
				<%
					String backfields = "t1.id,t1.name,t1.creater,t1.createdate,t1.createtime,t2.typename ";
					//out.print(RecordSet.getDBType());
					String sqlWhere = "";
					if(RecordSet.getDBType().equals("oracle")){
						sqlWhere = "where t1.status=1 and t1.typeid=t2.id and (dbms_lob.instr(t1.coworkers,',"+userid+",',1,1)>0 or t1.creater="+userid+") and dbms_lob.instr(t1.isnew,',"+userid+",',1,1)<=0";
					}else{
						sqlWhere = "where t1.status=1 and t1.typeid=t2.id and (t1.coworkers like '%,"+userid+",%' or t1.creater="+userid+") and t1.isnew not like '%,"+userid+",%'";
					}
					
					sqlWhere+=" and   t1.typeid=t2.id and t1.id in (select requestid from syspoppupremindinfonew where userid="+userid+" and type=9) ";
					String fromSql  = "from cowork_items t1,cowork_types t2 ";
					String orderby = "t1.id " ;
					String tableString = "";
					//out.print("select "+backfields +sqlWhere + fromSql);
					tableString = " <table instanceid=\"coworkRemindTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
												"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"desc\" sqlisdistinct=\"true\"/>"+
												"			<head>"+
												"				<col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelName(18831,user.getLanguage())+"\" column=\"name\" orderkey=\"t1.name\" linkvaluecolumn=\"id\" linkkey=\"id\" href=\"/cowork/coworkview.jsp\" target=\"_self\"/>"+
												"				<col width=\"25%\"   text=\""+SystemEnv.getHtmlLabelName(271,user.getLanguage())+"\" column=\"creater\" orderkey=\"t1.creater\" linkkey=\"id\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" href=\"/hrm/resource/HrmResource.jsp\" target=\"_fullwindow\" />"+
												"				<col width=\"25%\"   text=\""+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"\" column=\"createdate\" orderkey=\"t1.createdate,t1.createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />"+
												"				<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(178,user.getLanguage())+"\" column=\"typename\" orderkey=\"t2.typename\" />"+
												"			</head>"+
												"</table>";
				%>
				<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
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

</BODY>
</HTML>