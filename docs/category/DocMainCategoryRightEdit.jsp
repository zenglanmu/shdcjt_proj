<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.docs.category.security.*" %>

<jsp:useBean id="MainCategoryManager" class="weaver.docs.category.MainCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryManager" class="weaver.docs.category.SubCategoryManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(65,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BASE TARGET="_parent">
<BODY>
<%--<%@ include file="/systeminfo/TopTitle.jsp" %>--%>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
MainCategoryManager.setCategoryid(id);
MainCategoryManager.getCategoryInfoById();
String categoryname=MainCategoryManager.getCategoryname();
String coder = MainCategoryManager.getCoder();
float categoryorder=MainCategoryManager.getCategoryorder();
String categoryimageid=MainCategoryManager.getCategoryiamgeid();
int messageid = Util.getIntValue(request.getParameter("message"),0);
int errorcode = Util.getIntValue(request.getParameter("errorcode"),0);
boolean canEdit = false;
%>


<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
if(messageid !=0) {
%>
<DIV><font color="#FF0000"><%=SystemEnv.getHtmlNoteName(messageid,user.getLanguage())%></font></DIV>
<%}%>
            <%if(errorcode == 10){%>
            	<div><font color="red"><%=SystemEnv.getHtmlLabelName(21999,user.getLanguage()) %></font></div>
            <%}%>
<FORM id=weaver name=frmMain action="UploadFile.jsp" method=post enctype="multipart/form-data">
<DIV>
<%
if(HrmUserVarify.checkUserRight("DocMainCategoryEdit:Edit", user)){
	canEdit = true;
}
%>
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="49%">
  <COL width=10>
  <COL width="49%">
  <TBODY>
  <TR>
    <TD vAlign=top colSpan=3>
		<!--目录管理权限设置-->
		<%
		   int[] labels = {92,633,385};
		   int operationcode = AclManager.OPERATION_CREATEDIR;
		   int categorytype = AclManager.CATEGORYTYPE_MAIN;
		   AclManager am = new AclManager();
		%>
		<%@ include file="/docs/category/PermissionList.jsp" %>
	</TD>
  </TR>
<TR>
<TD vAlign=top></TD>
<TD></TD>
<TD vAlign=top></TD>
</TR>
</TBODY></TABLE>

<input type=hidden name="operation">

</DIV>

<script>
function onSave(){
	window.parent.location = "DocMainCategoryEdit.jsp?id=<%=id%>";
}
</script>
</FORM>


<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</BODY></HTML>
