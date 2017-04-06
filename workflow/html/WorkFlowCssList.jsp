<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="cssFileManager" class="weaver.workflow.html.CssFileManager" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String imagefilename = "/images/hdDOC.gif";
String titlename = "CSS"+SystemEnv.getHtmlLabelName(633,user.getLanguage());
String needfav ="1";
String needhelp ="";

String cssname = Util.null2String(request.getParameter("cssname"));
int csstype = Util.getIntValue(request.getParameter("csstype"));
String sqlwhere = "";

String backFields = "id, cssname, type";
String sqlFrom = "workflow_crmcssfile";
String orderBy = "id";
String sqlWhere = " 1=1 ";
if(!cssname.equals("")) {
	sqlWhere += " and cssname like '%"+cssname+"%' ";
}
if(csstype > 0){
	sqlWhere += " and type="+csstype+" ";
}
String opttype = Util.null2String(request.getParameter("opttype"));
if("delete".equals(opttype)){
	String multicssid = Util.null2String(request.getParameter("multicssid"));
	int retInt = cssFileManager.deleteCssFiles(multicssid);
	if(retInt == 1){
%>
	<script language="javascript">
	alert("<%=SystemEnv.getHtmlLabelName(20461,user.getLanguage())%>");
	</script>
<%
	
	}
}

String colString = "";
colString +="<col width=\"50%\" orderkey=\"cssname\" text=\"CSS"+SystemEnv.getHtmlLabelName(17517,user.getLanguage())+"\" column=\"cssname\" otherpara=\"column:type+column:id\" transmethod=\"weaver.workflow.html.CssFileManager.getCssName4Link\" />";
colString +="<col width=\"45%\" orderkey=\"type\" text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"type\"  otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.workflow.html.CssFileManager.getTypeStr\"/>";
String tableString="<table  pagesize=\"10\" tabletype=\"checkbox\">";
		tableString+="	<checkboxpopedom popedompara=\"column:id+column:type\" showmethod=\"weaver.workflow.html.CssFileManager.getCanDeleteCheckBox\" />";
		tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\" sqlsortway=\"Desc\" sqlprimarykey=\"id\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlisdistinct=\"false\" />";
		tableString+="<head>"+colString+"</head>";
		tableString+="</table>";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197, user.getLanguage())+",javascript:onSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(82, user.getLanguage())+",javascript:onCreate(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91, user.getLanguage())+",javascript:onDelete(),_top} " ;
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
		<td height="10" colspan="3"></td>
	</tr>
	<tr>
		<td ></td>
		<td valign="top">
			<TABLE class=Shadow>
			<tr>
			<td valign="top">
			<form id="frmmain" name="frmmain" action="WorkFlowCssList.jsp" method="post">
			<input type="hidden" id="multicssid" name="multicssid" value="">
			<input type="hidden" id="opttype" name="opttype" value="">


			<table class="viewform">
			<colgroup>
				<col width="10%">
				<col width="40%">
				<col width="10%">
				<col width="40%">
			<tbody>
				<tr>
					<td>CSS<%=SystemEnv.getHtmlLabelName(17517,user.getLanguage())%></td>
					<td class=field><input type="text" class="inputstyle" id="cssname" name="cssname" style="width:80%" value="<%=cssname%>">
					</td>
					<td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
					<td class=field>
						<select id="csstype" name="csstype">
							<option value="0"></option>
							<option value="1" <%if(csstype==1){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(28120,user.getLanguage())%></option>
							<option value="2" <%if(csstype==2){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(28119,user.getLanguage())%></option>
							<option value="3" <%if(csstype==3){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(28121,user.getLanguage())%></option>
					</td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan="4"></TD></TR>
				<tr>
					<td colspan="4">
					<TABLE width="100%">
					<tr>
						<td valign="top">
							<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
						</td>
					</tr>
					</table>
					</td>
				</tr>
			</tbody>
			</table>
			</form>
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
</body>
</html>
<script language="javascript">
function onSearch(){
	document.getElementById("opttype").value = "search";
	frmmain.submit();
	enableAllmenu();
}
function onCreate(){
	location.href = "/workflow/html/WorkFlowCssEdit.jsp?opttype=add";
}
function onDelete(){
	document.getElementById("multicssid").value = _xtable_CheckedCheckboxId();
	if(document.getElementById("multicssid").value==null || document.getElementById("multicssid").value==""){
		alert("<%=SystemEnv.getHtmlLabelName(24244,user.getLanguage())%>");
		return;
	}
	if(isdel()){
		document.getElementById("opttype").value = "delete";
		frmmain.submit();
		enableAllmenu();
	}
}
</script>