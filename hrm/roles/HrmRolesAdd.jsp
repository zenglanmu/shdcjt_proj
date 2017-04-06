<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(365,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(122,user.getLanguage());
String needfav ="1";
String needhelp ="";
String structureid ="";
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
if(request.getParameter("subCompanyId")==null){
    structureid=String.valueOf(session.getAttribute("role_subCompanyId"));
}else{
    structureid=Util.null2String(request.getParameter("subCompanyId"));
}
int errorcode = Util.getIntValue(request.getParameter("errorcode"),0);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmRolesAdd:Add",user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/roles/HrmRoles.jsp,_self} " ;
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
<%
if(errorcode == 10) {
%>
	<div><font color="red"><%=SystemEnv.getHtmlLabelName(21999,user.getLanguage())%></font></div>
<%}%>
<form method=post name=hrmrolesadd action="HrmRolesOperation.jsp">
<input class=inputStyle type=hidden name=operationType value="Add"> 
  <TABLE class=ViewForm>
<col width='20%'>
<col width='80%'>
<TR class=Title><TD COLSPAN=2><B><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></B></TD></TR>
<TR class=Title style="height: 1px;"><TD COLSPAN=2 class=Line1></TD></TR>
<TR>
	<TD><%=SystemEnv.getHtmlLabelName(15068,user.getLanguage())%></TD><TD CLASS=FIELD>
        <INPUT TYPE=TEXT class=inputStyle NAME=idname SIZE=50 MAXLENGTH=60 VALUE="" onChange="checkinput('idname','idnamespan')" onblur='javascript:checkMaxLength(this)' alt='<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>60(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)'>
        <span id=idnamespan><IMG src='/images/BacoError.gif' align=absMiddle></span></td>
</TR>
<TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR> 

<TR><TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD><TD CLASS=FIELD >
<INPUT TYPE=TEXT class=inputStyle NAME=description SIZE=60 MAXLENGTH=100 VALUE=""  onChange="checkinput('description','descspan')">
<span id=descspan><IMG src='/images/BacoError.gif' align=absMiddle></span>
</TD></TR>
<TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR> 

<%if(detachable==1){%>
    <TR>	<TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD> <TD class=Field >
         <select name=roletype >
         <option value="0" selected><%=SystemEnv.getHtmlLabelName(17866,user.getLanguage())%></OPTION>
        <option value="1"><%=SystemEnv.getHtmlLabelName(17867,user.getLanguage())%></OPTION>
         </select>
    </TD></TR>
    <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR> 

    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></TD> 
        <TD class=Field >
            <BUTTON class=Browser id=SelectSubCompany onclick="onShowSubcompany()"></BUTTON>
            <SPAN id=subcompanyspan>
                <%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(structureid),user.getLanguage())%>
                <%if(String.valueOf(structureid).equals("")){%>
                    <IMG src="/images/BacoError.gif" align=absMiddle>
                <%}%>
            </SPAN>
            <input type=hidden id=structureid name=structureid value="<%=structureid%>">
        </TD>
    </TR>
    <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR> 
<%}%>

<TR>	
	 <TD><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD> 
	 <TD class=Field >
	      <INPUT class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp" 
	       _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>" type=hidden name=docid value="">
	</TD>
</TR>
<TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR> 

<%if(detachable==1){%>
    <TR>	<TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD> <TD class=Field >
    	<%=SystemEnv.getHtmlLabelName(23265,user.getLanguage())%>
    </TD></TR>
    <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR> 
    <TR>	<TD></TD> <TD class=Field >
    	<%=SystemEnv.getHtmlLabelName(23266,user.getLanguage())%>
           
    </TD></TR>
    <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR> 
<%}%>

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
<script language=javascript>
function submitData() {
 if(check_form(hrmrolesadd,'idname,description,structureid')){
 hrmrolesadd.submit();
 enableAllmenu();
 }
}
</script>
<script language=vbs>
sub showHeaderDoc()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if NOT isempty(id) then
	   if id(0)<> 0 then
		hrmrolesadd.docid.value=id(0)&""
		relativedocid.innerHtml = "<a href='/docs/docs/DocDsp.jsp?id="&id(0)&"'>"&id(1)&"</a>"
	   else
	   	hrmrolesadd.docid.value=""
		relativedocid.innerHtml = empty
	   end if
	end if
	
end sub
sub onShowSubcompany()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=HrmRolesAdd:Add&isedit=1&selectedids="&hrmrolesadd.structureid.value)
	issame = false
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = hrmrolesadd.structureid.value then
		issame = true
	end if
	subcompanyspan.innerHtml = id(1)
	hrmrolesadd.structureid.value=id(0)
	else
	subcompanyspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	hrmrolesadd.structureid.value=""
	end if
	end if
end sub
</script>
</BODY>
</HTML>
