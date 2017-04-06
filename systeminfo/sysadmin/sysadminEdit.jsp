<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.systeminfo.sysadmin.*"%>
<%
	String id = Util.null2String(request.getParameter("id"));
	String result = Util.null2String(request.getParameter("result"));
	HrmResourceManagerDAO dao = new HrmResourceManagerDAO();
	HrmResourceManagerVO vo = dao.getHrmResourceManagerByID(id);
%>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></SCRIPT>
</head>
<% 
if(!HrmUserVarify.checkUserRight("SysadminRight:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(17870,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
if(!id.equals("1")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;

//update by fanggsh 20060510 TD3889 begin

//RCMenu += "{"+SystemEnv.getHtmlLabelName(18355,user.getLanguage())+",javascript:doDel(this),_self} " ;
//RCMenuHeight += RCMenuHeightStep;
//}

}
RCMenu += "{"+SystemEnv.getHtmlLabelName(18355,user.getLanguage())+",javascript:changePwd(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
//update by fanggsh 20060510 TD3889 end
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM name="frmmain" action="/systeminfo/sysadmin/sysadminOperation.jsp" method="post">
<INPUT type="hidden" name="method" value="edit">
<INPUT type="hidden" name="id" value="<%=vo.getId()%>">
<INPUT type="hidden" name="password" value="<%=vo.getPassword()%>">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td></td>
<td valign="top">
	<TABLE class=Shadow>
	<tr>
	<td valign="top">
	<table class="viewform">
		<colgroup>
		<col width="20%">
		<col width="80%">
		<tbody>
        <TR class="Title">
			<TH><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TH>
		</TR>
		<TR class="Spacing" style="height:1px;"><TD class="Line1" colSpan=2></TD></TR>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(17870,user.getLanguage())%></td>
			<td class=Field>
<!--update by fanggsh 20060510 TD3889 begin-->
<!--
			  <INPUT class=Inputstyle maxLength=60 size=20 name="loginid" value="<%=vo.getLoginid()%>" onchange='checkinput("loginid","loginidimage")' <%if(vo.getLoginid().equals("sysadmin")){%>disabled<%}%>>
-->		
<%
    if(vo.getLoginid().equals("sysadmin")){
%>
			  <INPUT type="hidden" maxLength=60 size=20 name="loginid" value="<%=vo.getLoginid()%>" onchange='checkinput("loginid","loginidimage")'>sysadmin
<%
    }else{
%>
			  <INPUT class=Inputstyle maxLength=60 size=20 name="loginid" value="<%=vo.getLoginid()%>" onchange='checkinput("loginid","loginidimage")'>
<%
    }
%>
<!--update by fanggsh 20060510 TD3889 end-->         
			  <SPAN id="loginidimage"><%if(vo.getLoginid().equals("")){%><IMG src="/images/BacoError.gif" align="absMiddle"><%}%><%if(result.equals("false")){%><div style="color:#FF0000 "><%=SystemEnv.getHtmlNoteName(64,user.getLanguage())%></div><%}%></SPAN></td>
		</tr>
		<TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(17888,user.getLanguage())%></td>
			<td class=Field>
			<INPUT class=Inputstyle maxLength=20 size=20 name="lastname" value="<%=vo.getLastname()%>" onchange='checkinput("lastname","lastnameimage")'><SPAN id="lastnameimage"><%if(vo.getLastname().equals("")){%><IMG src="/images/BacoError.gif" align="absMiddle"><%}%></SPAN></td>
		</tr>
		<TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>
        <tr>
			<td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
			<td class=Field>
<!--update by fanggsh 20060510 TD3889 begin-->
<!--
			  <INPUT class=Inputstyle maxLength=255 size=60 name="description" value="<%=vo.getDescription()%>" onchange='checkinput("description","descriptionimage")' <%if(vo.getLoginid().equals("sysadmin")){%>disabled<%}%>>
-->
<%
    if(vo.getLoginid().equals("sysadmin")){
%>
			  <INPUT type="hidden" maxLength=255 size=60 name="description" value="<%=vo.getDescription()%>" onchange='checkinput("description","descriptionimage")'><%=vo.getDescription()%>
<%
    }else{
%>
			  <INPUT class=Inputstyle maxLength=255 size=60 name="description" value="<%=vo.getDescription()%>" onchange='checkinput("description","descriptionimage")'>
<%
    }
%>
<!--update by fanggsh 20060510 TD3889 end-->

			  <SPAN id="descriptionimage"><%if(vo.getDescription().equals("")){%><IMG src="/images/BacoError.gif" align="absMiddle"><%}%></SPAN>
			</td>
		</tr>
		<TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>
		
		</tbody>
	</table>
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
</body>
<SCRIPT language="JavaScript">
function doSave(obj){
//update by fanggsh 2060510 TD3889 begin 
	//if (check_form(frmmain,"loginid,description")) {
	if (check_form(frmmain,"loginid,lastname,description")) {
//update by fanggsh 2060510 TD3889 end   
		document.frmmain.submit();
	}
}
function doDel(obj){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")){
		document.frmmain.method.value="del";
		document.frmmain.submit();
	}
}

//update by fanggsh 20060510 TD3889 begin
//function doDel(obj){
//    document.location.href="changePwd.jsp?id=<%=id%>"
//}

function changePwd(obj){
    document.location.href="changePwd.jsp?id=<%=id%>"
}
//update by fanggsh 20060510 TD3889 end
</SCRIPT>
</html>