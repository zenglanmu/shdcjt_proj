<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String departmentid = Util.null2String(request.getParameter("id"));
String groupby = Util.null2String(request.getParameter("GroupBy"));
if(groupby.equals("")) groupby ="1";

String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(122,user.getLanguage())+" : "+ Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
//改搜索为重新设置,xiaofeng
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
/* 去掉新建菜单，td1518,xiaofeng
if(HrmUserVarify.checkUserRight("HrmRoleMembersAdd:Add",user)){

RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/hrm/roles/HrmRolesMembersAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
*/
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
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
<td valign="top">


<!-- FORM id=weaver name=weaver action="HrmDepartmentRoles.jsp" method=post>
<TABLE>
  <TBODY>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TD>
    <TD><INPUT id=GroupBy type=radio value=0 name=GroupBy onClick="weaver.submit()" <% if(groupby.equals("0")) {%>checked<%}%>>
      <%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>
<INPUT id=GroupBy type=radio  value=1 name=GroupBy onClick="weaver.submit()" <% if(groupby.equals("1")) {%>checked<%}%>>
      <%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>
       </TD></TR></TBODY></TABLE>
<INPUT id=id type=hidden value=<%=departmentid%> name=id>
</FORM -->

<FORM id=frmMain name=frmMain action=HrmDepartmentRoles.jsp method=post>
<table class=viewForm>
  <colgroup> 
  <col width="15%"></col> 
  <col width="85%"></col>
  <thead> 
  <tr class=Title> 
    <th colspan=2><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></th>
  </tr>
  </thead> <tbody> 
  <tr class= Spacing style="height:2px"> 
    <td class=line1 colspan=2></td>
  </tr>
  <tr> 
    <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
      <td class=Field><button class=Browser type="button" id=SelectDeparment onClick="onShowDepartment()"></button> 
        <span class=inputStyle id=departmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%>
        </span> <input class=inputstyle id=departmentid type=hidden name=departmentid value="<%=departmentid%>"></td>
    
  </tr>
  <tr class= Spacing> 
    <td class=Sep1 colspan=4></td>
  </tr>
  </tbody> 
</table>
</form>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="30%">
  <COL width="30%">
  <COL width="10%">
  <COL width="15%">
  <COL width="15%">
  <TBODY>
  <TR class=Header>
    <TH align=left colSpan=5><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TH>
  </TR>
 
  <TR class=header>
    <TH align=left><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TH> 
    <TH align=left><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></TH>
    <TH align=left><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TH>
    <TH align=left><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TH>
    <TH align=left><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TH>
  </TR>

<%
String tempresourceid = "-1" ;
boolean writeable = false ;
int i = 0;
if(!"".equals(departmentid)){
RecordSet.executeProc("HrmRoleMembers_SByDepartmentID",departmentid);
while(RecordSet.next()) {
writeable = false ;
String resourceid = RecordSet.getString("resourceid") ;
String roleid = RecordSet.getString("roleid") ;
String rolelevel = RecordSet.getString("rolelevel") ;
String jobtitle = ResourceComInfo.getJobTitle(resourceid);
String resourcetype = ResourceComInfo.getResourcetype(resourceid);
if(i==0){
			i=1;
		%>
		<TR class=DataLight>
		<%
		}else{
			i=0;
		%>
		<TR class=DataDark>
		<%
		}
		%>
    <TD>
	<% if(!resourceid.equals(tempresourceid)) {  tempresourceid = resourceid ; writeable = true ; %>
	<A href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></A>
	<%}%>
	</TD>
    <TD>
	<% if(writeable) { %>
	<A href="/hrm/jobtitles/HrmJobTitlesEdit.jsp?id=<%=jobtitle%>"><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle),user.getLanguage())%></A>
	<%}%>
	</TD>
    <TD>
	<% if(writeable) { if(resourcetype.equalsIgnoreCase("f")) {%>
            <%=SystemEnv.getHtmlLabelName(130,user.getLanguage())%> 
            <%} if(resourcetype.equalsIgnoreCase("h")) {%>
            <%=SystemEnv.getHtmlLabelName(131,user.getLanguage())%> 
            <%} if(resourcetype.equalsIgnoreCase("d")) {%>
            <%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%> 
			<%} if(resourcetype.equalsIgnoreCase("t")) {%>
            <%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%> 
            <%}}%>
	</TD>
    <TD><A href="/hrm/roles/HrmRolesEdit.jsp?id=<%=roleid%>"><%=Util.toScreen(RolesComInfo.getRolesname(roleid),user.getLanguage())%></A></TD>
    <TD>
	<% if(rolelevel.equals("2")) {%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%><%}%>
	<% if(rolelevel.equals("1")) {%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><%}%>
	<% if(rolelevel.equals("0")) {%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><%}%>
	</TD></tr>
<% }}%>
 </TBODY></TABLE>
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

<script language=javascript>
function onShowDepartment(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp");
	if (data!=null){
		if (data.id!="0"){
			if (data.id != jQuery("#departmentid").val()){
				location.href="HrmDepartmentRoles.jsp?id="+data.id;
			}
		}
	}
}

function submitData() {
 frmMain.submit();
}
</script>
 </BODY>
 </HTML>