<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<html>
<head>
<script type="text/javascript" src="/js/weaver.js"></script>
<link rel="stylesheet" type="text/css" href="/css/Weaver.css">
</head>

<%
if(!HrmUserVarify.checkUserRight("EditProject:Delete",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String name = Util.null2String(request.getParameter("name"));
String procode = Util.null2String(request.getParameter("procode"));
String prjtype = Util.null2String(request.getParameter("prjtype"));
String worktype = Util.null2String(request.getParameter("worktype"));
String manager = Util.null2String(request.getParameter("manager"));
String department = Util.null2String(request.getParameter("dept"));
String status = Util.null2String(request.getParameter("status"));

int pagenum = Util.getIntValue(request.getParameter("pagenum"),1);
int	perpage = 20;

String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(19870,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteCrm(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=95,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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

<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="" method="post">
<input type=hidden name=operation>


<table width=100% class=ViewForm>
<colgroup>
<col width="8%"/>
<col width="12%"/><col width="1%"/>
<col width="8%"/>
<col width="12%"/><col width="1%"/>
<col width="8%"/>
<col width="12%"/><col width="1%"/>
<col width="8%"/>
<col width="12%"/>
</colgroup>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(1353,user.getLanguage())%></td>
	<td class="field"><input type="text" name="name" class="inputstyle" value="<%=name%>" /></td>
	<td></td>
	<td><%=SystemEnv.getHtmlLabelName(17852,user.getLanguage())%></td>
	<td class="field"><input type="text" name="procode" class="inputstyle" value="<%=procode%>" /></td>
	<td></td>
	<td><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></td>
	<td class="field">
        <INPUT type="hidden" id="prjtype" name="prjtype" class="wuiBrowser" value="<%=prjtype%>"
        	_displayText="<%=ProjectTypeComInfo.getProjectTypename(prjtype)%>"
        	_url="/systeminfo/BrowserMain.jsp?url=/proj/Maint/ProjectTypeBrowser.jsp">
	</td>
	<td></td>
	<td><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></td>
	<td class="field">
        <INPUT type="hidden" id="worktype" class="wuiBrowser" name="worktype" value="<%=worktype%>" 
        	_displayText="<%=WorkTypeComInfo.getWorkTypename(worktype)%>"
        	_url="/systeminfo/BrowserMain.jsp?url=/proj/Maint/WorkTypeBrowser.jsp">
	</td>
</tr>
<tr style="height:1px;"><td class=Line colspan=11></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(16573,user.getLanguage())%></td>
	<td class="field">
        <INPUT type="hidden" id="manager" name="manager" class="wuiBrowser" value="<%=manager%>" 
        	_displayText="<%=ResourceComInfo.getResourcename(manager)%>"
        	_displayTemplate="<a href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</a>"
        	_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp">
	</td>
	<td></td>
	<td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
	<td class="field">
		
        <INPUT type="hidden"  id="dept" name="dept" class="wuiBrowser" value="<%=department%>" 
        	_displayText="<%=DepartmentComInfo.getDepartmentname(department)%>"
        	_displayTemplate="<a href='/hrm/company/HrmDepartmentDsp.jsp?id=#b{id}'>#b{name}</a>"
        	_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp">
	</td>
	<td></td>
	<td><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
	<td class="field">
		<SELECT name="status" id="status">
		<OPTION></OPTION>
		<OPTION value="1" <%if(status.equals("1")) out.print("selected");%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></OPTION>
		<OPTION value="2" <%if(status.equals("2")) out.print("selected");%>><%=SystemEnv.getHtmlLabelName(2244,user.getLanguage())%></OPTION>
		<OPTION value="3" <%if(status.equals("3")) out.print("selected");%>><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></OPTION>
		<OPTION value="4" <%if(status.equals("4")) out.print("selected");%>><%=SystemEnv.getHtmlLabelName(1232,user.getLanguage())%></OPTION>
		<OPTION value="5" <%if(status.equals("5")) out.print("selected");%>><%=SystemEnv.getHtmlLabelName(2243,user.getLanguage())%></OPTION>
		<OPTION value="6" <%if(status.equals("6")) out.print("selected");%>><%=SystemEnv.getHtmlLabelName(2242,user.getLanguage())%></OPTION>
		<OPTION value="7" <%if(status.equals("7")) out.print("selected");%>><%=SystemEnv.getHtmlLabelName(1010,user.getLanguage())%></OPTION>
		<OPTION value="0" <%if(status.equals("0")) out.print("selected");%>><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%></OPTION>
		</SELECT>
	</td>
	<td></td>
	<td></td>
	<td></td>
</tr>
<tr style="height:1px;"><td class=Line colspan=11></td></tr>
</table>

<TABLE width="100%">
	<tr>
		<td valign="top">
            <%
            String backfields = "id, name, procode, prjtype, worktype, manager, (select departmentid from hrmresource t2 where t2.id =t1.manager) as department, status";
            String fromSql  = " FROM Prj_ProjectInfo t1";
            String sqlWhere = " 1=1 ";
			if(!name.equals("")){
				sqlWhere += " AND name LIKE '%"+name+"%' ";
			}
			if(!procode.equals("")){
				sqlWhere += " AND procode LIKE '%"+procode+"%' ";
			}
			if(!prjtype.equals("")){
				sqlWhere += " AND prjtype='"+prjtype+"' ";
			}
			if(!worktype.equals("")){
				sqlWhere += " AND worktype='"+worktype+"' ";
			}
			if(!manager.equals("")){
				sqlWhere += " AND manager="+manager+" ";
			}
			if(!department.equals("")){
				sqlWhere += " AND department='"+department+"' ";
			}
			if(!status.equals("")){
				sqlWhere += " AND status='"+status+"' ";
			}
			//System.out.println(sqlWhere);
            String orderby = "id" ;
            String tableString = "";
            tableString =" <table tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
                                     "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\""+orderby+"\" sqlprimarykey=\"id\" sqlsortway=\"desc\" />"+
                                     "			<head>"+
                                     "				<col width=\"3%\" text=\"ID\" column=\"id\" orderkey=\"id\" />"+
                                     "				<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(1353,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" />"+
									 "				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(17852,user.getLanguage())+"\" column=\"procode\" orderkey=\"procode\" />"+
                                   	 "				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"prjtype\" orderkey=\"prjtype\"  transmethod=\"weaver.splitepage.transform.SptmForProj.getProjTypeName\" />"+
                                   	 "				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(432,user.getLanguage())+"\" column=\"worktype\" orderkey=\"worktype\" transmethod=\"weaver.splitepage.transform.SptmForProj.getWorkTypeName\" />"+
									 "				<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(144,user.getLanguage())+"\" column=\"manager\" orderkey=\"manager\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" />"+
                      				 "				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"department\" orderkey=\"department\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" />"+
									 "				<col width=\"6%\" text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" transmethod=\"weaver.splitepage.transform.SptmForProj.getProjStatusName\" otherpara=\""+user.getLanguage()+"\" />"+
                                     "			</head>"+
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


<script type="text/javascript">
function deleteCrm(obj){
	//alert(_xtable_CheckedCheckboxId());
	//return false;
	if(_xtable_CheckedCheckboxId()==""){
		alert("<%=SystemEnv.getHtmlLabelName(19689,user.getLanguage())%>");
		return false;
	}
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		callAjax(obj);
	}
}
function callAjax(obj){
	obj.disabled=true;
	/**
	new Ajax.Request("/system/systemmonitor/MonitorOperation.jsp", {
		onSuccess : function(){},
		onFailure : function(){},
		parameters : 
	});	
	*/
	$.ajax(
			{
				url:"/system/systemmonitor/MonitorOperation.jsp?"+"deleteprojid="+_xtable_CheckedCheckboxId()+"&operation=deleteproj",
				async:false,
				success:function(){
					_table.reLoad();obj.disabled=false;_xtable_CleanCheckedCheckbox();
				},
				error:function(){
					alert("Error!");obj.disabled=false;
				}
			}
			);
}
</script>
</BODY>
</HTML>
