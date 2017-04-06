<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SystemComInfo" class="weaver.system.SystemComInfo" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput.js"></script>
<SCRIPT language="javascript" src="/js/weaver.js"></script>

</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(71,user.getLanguage());
String needfav ="1";
String needhelp ="";
int id= Util.getIntValue(request.getParameter("id"));
int applyid=Util.getIntValue(request.getParameter("applyid"),0);
String issearch = Util.null2String(request.getParameter("issearch"));

int pagenum=Util.getIntValue(request.getParameter("pagenum"),0);

String nothrmids = Util.null2String(request.getParameter("nothrmids"));  //经过选择排除的邮件发送人
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String fromPage = Util.null2String(request.getParameter("fromPage"));

String defmailserver = SystemComInfo.getDefmailserver() ;
String defmailfrom = SystemComInfo.getDefmailfrom() ;
String defneedauth = SystemComInfo.getDefneedauth() ;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1226,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">

<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

			<% if( defmailserver.equals("") ) {%>
			<font color=red>默认的群发服务器没有设置，请系统管理员在系统设置中设置默认的群发服务器！</font><br>
			<%}%>
			<% if( defneedauth.equals("1") && defmailfrom.equals("") ) {%>
			<font color=red>默认的群发服务器需要认证，请系统管理员在系统设置中设置默认的发件人和认证用户！</font>
			<%}%>

			<FORM ID=weaver NAME=weaver action="/sendmail/HrmSendMail.jsp?issearch=1">
            <input class=inputstyle type=hidden name=sqlwhere value="<%=sqlwhere%>" >
            <input class=inputstyle type=hidden name=nothrmids value="<%=nothrmids%>" >
			<INPUT TYPE="hidden" NAME="Action" VALUE="1">

			<INPUT TYPE=Hidden ID=Type NAME=Type VALUE=1></INPUT>
			
			<input class=inputstyle type=hidden name=fromPage value="<%=fromPage%>" >
			
			<TABLE CLASS="ViewForm">
			<COL WIDTH="25%"><COL WIDTH="75%">
			  <TR class=Title><TH COLSPAN="2"><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH></TR>
			  <TR style="height:2px"><TD COLSPAN="2" class=Line1></TD></TR>

			<TR>
				<TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
				<TD Class=Field><INPUT TYPE=TEXT ID=subject NAME=subject class="InputStyle" SIZE=100 MAXLENGTH=255 onchange='checkinput("subject","subjectimage")'><SPAN id=subjectimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
			  </TR>
			  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
              <TR>
				<TD>发送日期，时间</TD>
                <TD Class=Field>
                    <BUTTON class=calendar type="button" id=SelectDate onclick="getDate(fromdatespan,fromdate)"></BUTTON>&nbsp;
                    <SPAN id=fromdatespan ></SPAN>
                    <input type="hidden" name="fromdate" value="">--&nbsp;
                    <BUTTON class=calendar type="button" id=SelectTime onclick="onShowTime(fromtimespan,fromtime)"></BUTTON>&nbsp;
                    <SPAN id=fromtimespan ></SPAN>
                    <input type="hidden" name="fromtime" value="">
                </TD>
              </tr>
              <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>



			 <% if( defneedauth.equals("1")) { %>
				<INPUT TYPE=hidden ID=from NAME=from class="InputStyle" value="<%=defmailfrom%>" >
			  <% } else { %>
			  <tr>
				<TD><%=SystemEnv.getHtmlLabelName(1260,user.getLanguage())%></TD>
				<TD Class=Field>
				<INPUT TYPE=TEXT ID=from NAME=from class="InputStyle" SIZE=80 MAXLENGTH=255 value=<%=user.getEmail()%>>
				</TD>
			  </TR>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
			  <%}%>

			 <TR id="mailidtr">
				<TD>按模板发送</TD>
				<TD Class=Field>

					<INPUT TYPE=HIDDEN ID=mailid NAME="mailid" class="wuiBrowser"
					_url="/systeminfo/BrowserMain.jsp?url=/docs/mail/DocMouldBrowser.jsp"
					displayTemplate="<A target='_blank' href='/docs/mail/DocMouldDsp.jsp?id=#b{id}'>#b{name}</A>"></INPUT>
				</TD>
			</TR>
			<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
			<tr id="selfcommenttr"><td>自定义内容</td>
				<td  class=Field >
				<textarea style="WIDTH: 100%" id=selfComment name=selfComment size=80 rows=15 class="InputStyle"></textarea>
				</td>
			</tr>
			<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>

			<input type=hidden name=id value="<%=id%>">
			<input type=hidden name=issearch value="<%=issearch%>">
			<input type=hidden name=applyid value="<%=applyid%>">
			<input type=hidden name=pagenum value="<%=pagenum%>">

			</TABLE>
			</FORM>

		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>

</table>

</BODY>
</HTML>
<script language=vbs>
sub showMailMould()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/mail/DocMouldBrowser.jsp")
	if (Not IsEmpty(id)) then
		if id(0)<> "0" then
			DisplayLayout.innerHtml = "<A href='/docs/mail/DocMouldDsp.jsp?id="&id(0)&"'>"&id(1)&"</A>"
			weaver.mailid.value=id(0)
			selfcommenttr.style.display="none"
		else
			DisplayLayout.innerHtml =""
			weaver.mailid.value=""
			selfcommenttr.style.display=""
		end if
	end if
end sub
</script>
<script language="javascript">
 function onSubmit(){
    if(check_form(weaver,'subject')){
	    document.weaver.submit();
    }
 }
</script>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
