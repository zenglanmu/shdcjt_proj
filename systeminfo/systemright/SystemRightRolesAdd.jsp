<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<%
if(!HrmUserVarify.checkUserRight("SystemRightRolesAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<jsp:useBean id="RightComInfo" class="weaver.systeminfo.systemright.RightComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head><%
String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(385,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(122,user.getLanguage());
String needfav ="1";
String needhelp ="1";
String rightid = Util.null2String(request.getParameter("id")) ;
String groupID = Util.null2String(request.getParameter("groupID")) ;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM ID=addroles  name=addroles ACTION=SystemRightGroupOperation.jsp METHOD=POST >
<DIV> 
<input type=hidden name="rightid" value="<%=rightid%>">
<input type=hidden name="groupID" value="<%=groupID%>">
<input type=hidden name=operationType value="addrightroles">
</DIV>
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

			<TABLE class="ViewForm" style="width:50%">
				<TR>
					
				  <TD><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%></TD>
					
				  <TD class="field"><%=Util.toScreen(RightComInfo.getRightname(rightid,""+user.getLanguage()),user.getLanguage())%></TD>
				</TR>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
				<TR>
					
				  <TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
					<TD class="field"><BUTTON type=button  class=Browser 
						id=SelectRolesID onClick="onShowRolesID()"></BUTTON> <SPAN class=saveHistory 
						id=rolesidspan><IMG src='/images/BacoError.gif' align=absMiddle></SPAN>
						  <INPUT id=roleid type=hidden name=roleid></TD>
				</TR>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
				<TR>
					
				  <TD><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TD>
					<TD class="field"><SELECT ID=rolelevel CLASS=saveHistory NAME=rolelevel>
					<OPTION VALUE="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></OPTION>
					<OPTION VALUE="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></OPTION>
					<OPTION VALUE="0" SELECTED><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></OPTION></SELECT></TD>
				</TR>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
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
<script type="text/javascript">

function onShowRolesID(spanname, inputname) {
    
    var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
    try {
    	jsid = new Array();jsid[0] = wuiUtil.getJsonValueByIndex(id, 0); jsid[1] = wuiUtil.getJsonValueByIndex(id, 1);
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0" && jsid[1]!="") {
             $GetEle("rolesidspan").innerHTML = jsid[1];
             $GetEle("roleid").value = jsid[0];
        }else {
             $GetEle("rolesidspan").innerHTML = "";
             $GetEle("roleid").value = "";
        }
    }
}
</script>

<script language="javascript">
function doSubmit()
{
	if (check_form(addroles,"roleid"))
		addroles.submit();
}
</script>
</BODY>
</HTML>