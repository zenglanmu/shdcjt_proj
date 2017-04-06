<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
int companyid = Util.getIntValue(request.getParameter("companyid"),0);
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(141,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";
int supsubcomid=Util.getIntValue(request.getParameter("supsubcomid"),0);
//String url=Util.null2String(request.getParameter("url"));
//int showorder=Util.getIntValue(request.getParameter("showorder"),0);
//String subcompanyname = Util.null2String(request.getParameter("subcompanyname"));
//String subcompanydesc = Util.null2String(request.getParameter("subcompanydesc"));
String url=Util.null2String((String)session.getAttribute("url"));
int showorder=Util.getIntValue((String)session.getAttribute("showorder"),0);
String subcompanyname=Util.null2String((String)session.getAttribute("subcompanyname"));
String subcompanydesc=Util.null2String((String)session.getAttribute("subcompanydesc"));
session.removeAttribute("url");
session.removeAttribute("showorder");
session.removeAttribute("subcompanyname");
session.removeAttribute("subcompanydesc");
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
<td height="0" colspan="3">



</td>
</tr>


<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM id=weaver name=frmMain action="SubCompanyOperation.jsp" method=post  target="_parent">

<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <%
if(msgid!=-1){
%>
<DIV>
<FONT color="red" size="2">
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</FONT>
</DIV>
<%}%>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TH></TR>
  <TR class= Spacing style="height:2px">
    <TD class=Line1 colSpan=2 ></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle name="subcompanyname" type=text maxLength=60 size=50  onblur="checkLength('subcompanyname',60,'','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')"    onchange='checkinput("subcompanyname","subcompanynameimage")' value="<%=subcompanyname%>">
          <SPAN id=subcompanynameimage><%if(subcompanyname.trim().equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></SPAN></TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle name="subcompanydesc" type=text maxLength=60 size=50 onblur="checkLength('subcompanydesc',60,'','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')"   onchange='checkinput("subcompanydesc","subcompanydescimage")' value="<%=subcompanydesc%>">
          <SPAN id=subcompanydescimage><%if(subcompanydesc.trim().equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></SPAN></TD>
        </TR>
		<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())+SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
          <TD class=Field>

      <input class="wuiBrowser" id=supsubcomid type=hidden name=supsubcomid value="<%=supsubcomid%>"
	  _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp"
	  _displayText="<%=SubComanyComInfo.getSubCompanyname(""+supsubcomid)%>">  
          </TD>
        </TR>
		<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(76,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle type=text size=60 name="url" value="<%=url%>">
          </TD>
        </TR>
		<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle type=text size=60 name="showorder" value="<%=showorder%>">
          </TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle type=text size=60 name="subcompanycode" value="">
          </TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <input class=inputstyle type="hidden" name=companyid value="<%=companyid%>">
        <input class=inputstyle type="hidden" name=operation value=addsubcompany>
 </TBODY></TABLE>
 </form>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
</table>

<script language=vbs>
sub onShowSubcompany()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=HrmSubCompanyAdd:Add&isedit=1&selectedids="&frmMain.supsubcomid.value)
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	if id(0) = frmMain.supsubcomid.value then
		issame = true 
	end if
	supsubcomspan.innerHtml = id(1)
	frmMain.supsubcomid.value=id(0)
	else
	supsubcomspan.innerHtml = ""
	frmMain.supsubcomid.value=""
	end if
	end if
end sub
</script>
<script language=javascript>
function submitData() {
 if(check_form(frmMain,'subcompanyname,subcompanydesc')){
 frmMain.submit();
 }
}
</script>
</BODY>
</HTML>