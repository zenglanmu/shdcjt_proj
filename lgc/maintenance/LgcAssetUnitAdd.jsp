<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<% if(!HrmUserVarify.checkUserRight("LgcAssetUnitAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage()) + ":&nbsp;" 
					+ SystemEnv.getHtmlLabelName(705,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("LgcAssetUnitAdd:Add",user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doBack(),_self} " ;
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

			<FORM style="MARGIN-TOP: 0px" id=right name=right method=post action="LgcAssetUnitOperation.jsp" onSubmit='return check_form(this,"unitname")'>
			  <input type="hidden" name="operation" value="addunit">			
			  <TABLE class=ViewForm>
				<COLGROUP> <COL width="15%"> <COL width="85%"><TBODY> 
				<TR class=Title> 
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing style="height:1px;"> 
				  <TD class=Line1 colSpan=2></TD>
				</TR>
			<!--
				<tr> 
				  <td>ฑ๊สถ</td>
				  <td class=Field> 
					<input accesskey=Z name=unitmark onChange='checkinput("unitmark","unitmarkimage")' maxlength="20">
					<span id=unitmarkimage><img 
						src="/images/BacoError.gif" align=absMiddle></span> </td>
				</tr>
			-->
				<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
				  <td class=Field> 
					<input accesskey=Z name=unitname size="30" onchange='checkinput("unitname","unitnameimage")' maxlength="30" class="InputStyle">
					<SPAN id=unitnameimage><IMG 
						src="/images/BacoError.gif" align=absMiddle></SPAN> </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
				<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td>
				  <td class=Field> 
					<textarea accesskey="Z" name="unitdesc" cols="60" class="InputStyle"></textarea>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
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
<script language=javascript>
 function onSave(){
 	if(check_form(document.getElementById("right"),'unitname')){
 		document.getElementById("right").submit();
	}
 }
 function doBack(){
   location = "LgcAssetUnit.jsp";
 }
</script>
</FORM>
</BODY>
</HTML>

