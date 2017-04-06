<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head><%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(122,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(431,user.getLanguage());
String needfav ="1";
String needhelp ="";
/*本页面使用变量*/
String id=Util.null2String(request.getParameter("id"));
RecordSet.execute("HrmRoleMembers_SelectByID",id);
RecordSet.next();
String roleID=RecordSet.getString("roleid");
String resourceID=RecordSet.getString("resourceid");
String rolelevel=RecordSet.getString("rolelevel");
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmRoleMembersEdit:Edit",user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onEdit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmRoleMembersEdit:Delete",user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(HrmUserVarify.checkUserRight("HrmRoleMembers:Log",user)){
    if(RecordSet.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)="+32+" and relatedid="+id+",_self} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+32+" and relatedid="+id+",_self} " ;
    }
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
<TABLE class=Shadow>
<tr>
<td valign="top">
<form name=rolesmember method="post" action="HrmRolesMembersOperation.jsp" onSubmit='return check_form(this,"employeeID")'>
<input type=hidden id=employeeID name=employeeID value=<%=resourceID%>>
<input type=hidden id=roleID name=roleID value="<%=roleID%>">
<input type=hidden id=id name=id value="<%=id%>">
<input type=hidden id=id name=rolelevel2 value="<%=rolelevel%>">
<input type=hidden id=operationType name=operationType>
<br>

<TABLE CLASS=viewFORM WIDTH=100%>
<COL WIDTH=20%
      ><COL WIDTH=80%>
<TR><TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD><TD CLASS=FIELD>
	<%=RolesComInfo.getRolesname(roleID)%>
</TD></TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<TR>
	<TD><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></TD>
	  <TD CLASS=FIELD><%=Util.toScreen(ResourceComInfo.getResourcename(resourceID),user.getLanguage())%>
      </TD>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<TR>
	<TD><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TD>
	<TD CLASS=FIELD>
	<SELECT class=inputstyle ID=level Name=level>
			<OPTION VALUE=2 <% if(rolelevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></OPTION>
			<OPTION VALUE=1 <% if(rolelevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></OPTION>
			<OPTION VALUE=0 <% if(rolelevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></OPTION>						
	</SELECT>	
	</TD>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
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
<script language="javascript">
function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		document.rolesmember.operationType.value="Delete";
		document.rolesmember.submit();
		enableAllmenu();
	}
}	
function onEdit(){
		document.rolesmember.operationType.value="Edit";
		document.rolesmember.submit();
		enableAllmenu();
}
</script>
</BODY>
</HTML>