<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>

<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryManager" class="weaver.docs.category.SubCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
</head>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
String categoryname=SubCategoryComInfo.getSubCategoryname(""+id);
String coder = SubCategoryComInfo.getCoder(""+id);
int mainid=Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+id),0);
int fathersubid = Util.getIntValue(SubCategoryComInfo.getFatherSubCategoryid(""+id),-1);
int messageid = Util.getIntValue(request.getParameter("message"),0);
int errorcode = Util.getIntValue(request.getParameter("errorcode"),0);
boolean canEdit = false;
boolean canAdd = false;
boolean canDelete = false;
boolean canLog = false;
boolean hasSubManageRight = false;
AclManager am = new AclManager();

/* 以下通过结合旧类型的edit权限和新类型的CREATEDIR权限来设定是否可以编辑 */
//hasSubManageRight = am.hasPermission(id, AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR);
hasSubManageRight = am.hasPermission(mainid, AclManager.CATEGORYTYPE_MAIN, user, AclManager.OPERATION_CREATEDIR);
if (HrmUserVarify.checkUserRight("DocSubCategoryEdit:edit", user) || hasSubManageRight) {
    canEdit = true;
}

//if (HrmUserVarify.checkUserRight("DocSubCategoryAdd:add", user)) {
//    canAdd = true;
//} else {
//    if (fathersubid < 0) {
//        canAdd = am.hasPermission(mainid, AclManager.CATEGORYTYPE_MAIN, user, AclManager.OPERATION_CREATEDIR);
//    } else {
//        canAdd = am.hasPermission(fathersubid, AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR);
//    }
//}

if (HrmUserVarify.checkUserRight("DocSubCategoryAdd:add", user) || hasSubManageRight) {
    canAdd = true;
}

if (HrmUserVarify.checkUserRight("DocSubCategoryEdit:Delete", user) || hasSubManageRight) {
    canDelete = true;
}
if (HrmUserVarify.checkUserRight("DocSubCategory:log", user) || hasSubManageRight) {
    canLog = true;
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(66,user.getLanguage())+":"+categoryname;
String needfav ="1";
String needhelp ="";
CategoryManager cm = new CategoryManager();
%>
<BASE TARGET="_parent">
<BODY>
<%--<%@ include file="/systeminfo/TopTitle.jsp" %>--%>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%--
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
--%>
<%
if(messageid !=0) {
%>
<DIV><font color="#FF0000"><%=SystemEnv.getHtmlNoteName(messageid,user.getLanguage())%></font></DIV>
<%}%>
<%
if(errorcode == 10) {
%>
<div><font color="red"><%=SystemEnv.getHtmlLabelName(21999,user.getLanguage()) %></font></div>
<%}%>
<FORM id=weaver name=frmMain action="SubCategoryOperation.jsp" method=post>
<DIV>
<%
//if(HrmUserVarify.checkUserRight("DocSubCategoryEdit:Edit", user)){
if (canEdit) {
%>
<%--
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
<%
}if(canAdd){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='DocSubCategoryAdd.jsp?id="+mainid+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(canDelete){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(canLog){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?secid=66&sqlwhere=where operateitem=2 and relatedid="+id+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
--%>
<%
}
%>
<TABLE class=ViewForm>
  
  <TBODY>
  <TR>
<%--
    <TD vAlign=top>
      <TABLE class=ViewForm>
	  <COLGROUP>
	  <COL width="20%">
	  <COL width="80%">
        <TBODY>
        <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
            <td align=right>
                <A href="DocMainCategory.jsp"><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></A> >
            	<A href="DocMainCategoryEdit.jsp?id=<%=mainid%>"><%=MainCategoryComInfo.getMainCategoryname(""+mainid)%></A>
<%              RecordSet rs = cm.getSuperiorSubCategoryList(id, AclManager.CATEGORYTYPE_SUB);
                while (rs.next()) {         %>
                     >
                    <A href="DocSubCategoryEdit.jsp?id=<%=rs.getInt("subcategoryid")%>"><%=Util.toScreen(rs.getString("subcategoryname"), user.getLanguage())%></A>
<%              }                           %>
            </td>

          </TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=hidden name="id" value="<%=id%>"><%=MainCategoryComInfo.getMainCategoryname(""+mainid)%></TD>
        </TR>
<TR><TD class=Line colSpan=2></TD></TR>
<%      if (fathersubid >= 0) {   %>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())+SystemEnv.getHtmlLabelName(66,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=hidden name="subid" value="<%=fathersubid%>"><%=SubCategoryComInfo.getSubCategoryname(""+fathersubid)%></TD>
        </TR>
<TR><TD class=Line colSpan=2></TD></TR>
<%      }                   %>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=hidden name="mainid" value="<%=mainid%>"><%=id%></TD>
        </TR>
<TR><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><INPUT class=InputStyle maxLength=60 size=50 name="categoryname" value="<%=categoryname%>"
          onChange="checkinput('categoryname','categorynamespan')"><%}else{%><%=categoryname%><%}%>
          <span id=categorynamespan><%if(categoryname.equals("")){%><IMG src="../../images/BacoError.gif" align=absMiddle><%}%></span>
          <INPUT type=hidden maxLength=60 size=50 name="srccategoryname" value="<%=categoryname%>">
          </TD>
        </TR>
<TR><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(19388,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><INPUT maxLength=20 size=20 class=InputStyle name="coder" value="<%=coder%>"><%}else{%><%=coder%><%}%></TD>
         </TR>
<TR><TD class=Line colSpan=2></TD></TR>
        </TBODY></TABLE></TD>
--%>        
        <TD vAlign=top>
<%
   int[] labels = {92,633,385};
   int operationcode = AclManager.OPERATION_CREATEDIR;
   int categorytype = AclManager.CATEGORYTYPE_SUB;
%>
<%@ include file="/docs/category/PermissionList.jsp" %>
        </TD>
        </TR></TBODY></TABLE>

<input type=hidden name="operation">
<%--
<!-- 分目录列表 -->
<!-- 因多级目录还未做完, 这里将分目录列表和在分目录下创建分目录屏蔽, 谭小鹏 2003-06-17
<TABLE class=ListStyle>
  <COLGROUP>
	<COL width="30%">
	<COL width="70%">
  <TBODY>
  <TR class=Title>
    <TD><B><%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%></B></TD>
    <TD align=right><A
      href="DocSubCategoryAdd.jsp?id=<%=mainid%>&subid=<%=id%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></A></TD></TR>
  <TR class=Spacing>
    <TD class=Sep2 colSpan=2></TD></TR>
  <TR class=Header>
      <TD colSpan=2><%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%></TD>
    </TR>
    <%
  SubCategoryManager.selectCategoryInfo(id);
  int i=0;
  while(SubCategoryManager.next()){
  	int subid = SubCategoryManager.getCategoryid();
  	String name = SubCategoryManager.getCategoryname();
  	if(i==0){
  		i=1;
  %>
  <TR class=datalight>
  <%}else{
  		i=0;
  %>
  <TR class=datadark>
  <% }%>
  <td><%=subid%></td>
  <td> <a href="DocSubCategoryEdit.jsp?id=<%=subid%>"><%=name%></a></td></tr>
  <%
  }
  SubCategoryManager.closeStatement();
  %>
</TBODY></TABLE>
-->
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
	<COL width="30%">
	<COL width="70%">
  <TBODY>
  <TR class=header>
    <TD><B><%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%></B></TD>
    <TD align=right><A
      href="DocSecCategoryAdd.jsp?id=<%=id%>&mainid=<%=mainid%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></A></TD></TR>
  <TR class=Header>
      <TD colSpan=2><%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%></TD>
    </TR>
<TR class=Line><TD colSpan=2></TD></TR>
    <%
SecCategoryManager.setSubcategoryid(id);
SecCategoryManager.selectCategoryInfo();
  i=0;
  while(SecCategoryManager.next()){
  	int secid = SecCategoryManager.getId();
  	String name = SecCategoryManager.getCategoryname();
  	if(i==0){
  		i=1;
  %>
  <TR class=datalight>
  <%}else{
  		i=0;
  %>
  <TR class=datadark>
  <% }%>
  <td><%=secid%></td>
  <td> <a href="DocSecCategoryEdit.jsp?id=<%=secid%>"><%=name%></a></td></tr>
  <%
  }
  SecCategoryManager.closeStatement();
  %>
</TBODY></TABLE>

<script>
function onSave(){
	if(check_form(document.frmMain,'categoryname')){
		document.frmMain.operation.value="edit";
		document.frmMain.submit();
	}
}
function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {

		document.frmMain.operation.value="delete";
		document.frmMain.submit();
	}
}
</script>
--%>
<script>
function onSave(){
	window.parent.location = "DocSubCategoryEdit.jsp?id=<%=id%>";
}
</script>
</FORM>
<%--
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
--%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</BODY></HTML>
