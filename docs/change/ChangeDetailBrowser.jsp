<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSet"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver.js"></script>

<%
boolean canResend = true;
if(!HrmUserVarify.checkUserRight("DocChange:Resend", user)){
	canResend = false;
}
String requestid = Util.null2String(request.getParameter("requestid"));
%>
<%
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(canResend) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(22408,user.getLanguage())+",javascript:reSend(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:window.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<LINK href="../css/Weaver.css" type=text/css rel=STYLESHEET>
<FORM name="frmmain" action="/docs/change/DocReceiveCompanyBrowser.jsp" method="post" target="_self">
<input type="hidden" name="requestid" value="<%=requestid%>">
<TABLE class="Shadow">
<tr>
<td valign="top">

<!-- 流程中指定 -->
<TABLE class=ListStyle cellspacing=1>
<COLGROUP>
<COL>
<COL width="150">
<COL width="80">
<COL width="60">
<TR class=Title>
  <TH colSpan=4><%=SystemEnv.getHtmlLabelName(23104,user.getLanguage())%></TH>
</TR>
<TR class=Spacing>
  <TD class=Line1 colSpan=4></TD>
</TR>
<TR class=Header>
<TH><%=SystemEnv.getHtmlLabelName(20217,user.getLanguage())%></TH>
<TH><%=SystemEnv.getHtmlLabelName(21662,user.getLanguage())%></TH>
<TH><%=SystemEnv.getHtmlLabelName(23106,user.getLanguage())%></TH>
<TH><%=SystemEnv.getHtmlLabelName(1929,user.getLanguage())%></TH>
</TR>
<TR class=Line>
<TD colSpan=3></TD>
</TR>
<%
int i = 0;
rs.executeSql("select * from DocChangeSendDetail WHERE type='0' and requestid="+requestid);
while(rs.next()) {
%>
<TR class=<%if((i%2)==0){%>DataDark<%}else{%>DataLight<%}%>>
<TD><%=DocReceiveUnitComInfo.getReceiveUnitName(rs.getString("receiver"))%></TD>
<TD><%=rs.getString("detail")%></TD>
<TD><%=rs.getString("receivedate")%></TD>
<TD>
<%
int statusText = -1;
String status = rs.getString("status");
if(status.equals("0")) statusText = 23079;
if(status.equals("1")) statusText = 23078;
if(status.equals("2")) statusText = 22946;
if(status.equals("3")) statusText = 21983;
%>
<%=SystemEnv.getHtmlLabelName(statusText,user.getLanguage())%>
</TD>
</TR>
<%
	i++;
}
%>
</TABLE>

<!-- 重发的单位 -->
<br><br>
<TABLE class=ListStyle cellspacing=1>
<COLGROUP>
<COL>
<COL width="150">
<COL width="80">
<COL width="60">
<TR class=Title>
  <TH colSpan=4><%=SystemEnv.getHtmlLabelName(23105,user.getLanguage())%></TH>
</TR>
<TR class=Spacing>
  <TD class=Line1 colSpan=4></TD>
</TR>
<TR class=Header>
<TH><%=SystemEnv.getHtmlLabelName(20217,user.getLanguage())%></TH>
<TH><%=SystemEnv.getHtmlLabelName(21662,user.getLanguage())%></TH>
<TH><%=SystemEnv.getHtmlLabelName(23106,user.getLanguage())%></TH>
<TH><%=SystemEnv.getHtmlLabelName(1929,user.getLanguage())%></TH>
</TR>
<TR class=Line>
<TD colSpan=3></TD>
</TR>
<%
i = 0;
rs.executeSql("select * from DocChangeSendDetail WHERE type='1' and requestid="+requestid);
while(rs.next()) {
%>
<TR class=<%if((i%2)==0){%>DataDark<%}else{%>DataLight<%}%>>
<TD><%=DocReceiveUnitComInfo.getReceiveUnitName(rs.getString("receiver"))%></TD>
<TD><%=rs.getString("detail")%></TD>
<TD><%=rs.getString("receivedate")%></TD>
<TD>
<%
int statusText = -1;
String status = rs.getString("status");
if(status.equals("0")) statusText = 23079;
if(status.equals("1")) statusText = 23078;
if(status.equals("2")) statusText = 22946;
if(status.equals("3")) statusText = 21983;
%>
<%=SystemEnv.getHtmlLabelName(statusText,user.getLanguage())%>
</TD>
</TR>
<%
	i++;
}
%>
</TABLE>

</td>
</tr>
</TABLE>

</FORM>
</BODY>
</html>
<script>
function selecAll(){
	var flag = document.all('selectAll').checked;
	var ids = document.all('detailId');
	for(i=0; i<ids.length; i++) {
		ids[i].checked = flag;
	}
}
function reSend(mobj) {
	//onReSendCompany();
	document.frmmain.submit();
	mobj.disabled = true;
}
</script>
<script language="vbs">
Sub onReSendCompany()
	window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/change/DocReceiveCompanyBrowser.jsp?requestid=<%=requestid%>")
End Sub
</script>