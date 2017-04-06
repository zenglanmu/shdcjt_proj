<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="RightComInfo" class="weaver.systeminfo.systemright.RightComInfo" scope="page" />
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(122,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(385,user.getLanguage());
String needfav ="1";
String needhelp ="1";

String id = Util.null2String(request.getParameter("id")) ;
String roleId = Util.null2String(request.getParameter("roleId"));
String rightId = Util.null2String(request.getParameter("rightId")) ;
String roleLevel = Util.null2String(request.getParameter("roleLevel")) ;
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <link href="/css/Weaver.css" type=text/css rel=stylesheet>
    <SCRIPT language="javascript" src="../../js/weaver.js"></script>
  </head>
  
  <body>
  <%@ include file="/systeminfo/TopTitle.jsp" %>
  <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
  
  <%
  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;
  RCMenuHeight += RCMenuHeightStep ;

  RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
  RCMenuHeight += RCMenuHeightStep ;

  RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/roles/HrmRolesFucRightSet.jsp?id="+roleId+",_self} " ;
  RCMenuHeight += RCMenuHeightStep ;
  %>
  
  <%@ include file="/systeminfo/RightClickMenu.jsp" %>
  <br>
  
<FORM id="editRoleRight" action="HrmRoleRightOperation.jsp" name="editRoleRight" method=post >

	<input type=hidden name="id" value="<%=id%>">
	<input type=hidden name="roleId" value="<%=roleId%>">
	<input type=hidden name="rightId" value="<%=rightId%>">
	<input type=hidden name=operationType value="editRoleRight">

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
		
		<TABLE class="Shadow">
			<tr>
				<td valign="top">
				
				<TABLE class=ViewForm style="width:50%">
					<COLGROUP>
					<COL width="30%">
					<COL width="70%">
					
					<TBODY>
					
						<TR>
							<TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
							<TD class=Field><%=Util.toScreen(RolesComInfo.getRolesname(roleId),user.getLanguage())%></TD>
						</TR>
						<TR style="height:1px;">
							<TD class=Line colspan=2></TD>
						</TR>
					
						<TR>
							<TD><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%></TD>
							<TD class=Field ><%=Util.toScreen(RightComInfo.getRightname(rightId,""+user.getLanguage()),user.getLanguage())%></TD>
						</TR>
						<TR style="height:1px;">
							<TD class=Line colspan=2></TD>
						</TR>

						<TR>
							<TD><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TD>
							<TD class="field">
								<SELECT ID=roleLevel CLASS=saveHistory NAME=roleLevel>
									<OPTION VALUE="2" <% if(roleLevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></OPTION>
									<OPTION VALUE="1" <% if(roleLevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></OPTION>
									<OPTION VALUE="0" <% if(roleLevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></OPTION>
								</SELECT>
							</TD>
						</TR>
						<TR style="height:1px;">
							<TD class=Line colspan=2></TD>
						</TR>
					</TBODY>
				</TABLE>

				
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

</FORM>
<script language="javascript">
  
  function doSubmit(){
	  document.editRoleRight.operationType.value="editRoleRight";
	  document.editRoleRight.submit();
	  enableAllmenu();
	  
  }
  function onDelete(){
	  if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")){
		  document.editRoleRight.operationType.value="deleteRoleRight";
		  document.editRoleRight.submit();
		  enableAllmenu();
	  }
  }
</script>   
  </body>
</html>
