<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<%
boolean canmaint = HrmUserVarify.checkUserRight("Voting:Maint",user);
if (!canmaint) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String name = "";
String approver = "";
String id = Util.null2String(request.getParameter("id"));
if (!id.equals("")) {
	RecordSet.executeSql("select * from voting_type where id ="+id);
	if (RecordSet.next()) {
		name = Util.null2String(RecordSet.getString("typename"));
		approver = Util.null2String(RecordSet.getString("approver"));
	}
}
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(24111, user.getLanguage());
String needfav = "1";
String needhelp = "";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp"%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
<%
if (canmaint) {
	RCMenu += "{"+ SystemEnv.getHtmlLabelName(86, user.getLanguage())+ ",javascript:submitData(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp"%>
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
						<%
						if (canmaint) {
						%>
						<FORM id=weaverA name=weaverA action="VotingTypeOperation.jsp" method=post>
							<%
							if (id.equals("")) {
							%>
							<input class=inputstyle type="hidden" name="method" value="add">
							<%
							} else {
							%>
							<input class=inputstyle type="hidden" name="method" value="edit">
							<input class=inputstyle type="hidden" name="id" value="<%=id%>">
							<%
							}
							%>
							<TABLE class=Viewform>
								<COLGROUP>
									<COL width="15%">
									<COL width=85%>
								<TBODY>
									<TR class=Spacing>
										<TD class=Sep1 colSpan=4></TD>
									</TR>
                                    <TR>
	                                    <TD>
											<%=SystemEnv.getHtmlLabelName(24111, user.getLanguage())%>
										</TD>
										<TD class=Field>
											<input name=name class=inputstyle style="width=80%" value="<%=name%>" onchange='checkinput("name","nameimage")'>
											<SPAN id=nameimage><%if (name.equals("")) {%><IMG src="/images/BacoError.gif" align=absMiddle><%}%>
											</SPAN>
										</TD>
									</TR>
									<TR style="height: 1px!important;">
										<TD class=Line colSpan=2></TD>
									</TR>
									<TR>
										<TD>
											<%=SystemEnv.getHtmlLabelName(15057, user.getLanguage())%>
										</TD>
										<TD class=Field>


											
											<input class="wuiBrowser" _displayText="<%=WorkflowComInfo.getWorkflowname(approver)%>" _url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere= where isbill=1 and formid=241" type=hidden name="approver" value="<%=approver%>">
										</TD>
									</TR>
									<TR style="height: 1px!important;">
										<TD class=Line colSpan=2></TD>
									</TR>
								</TBODY>
							</TABLE>
						</FORM>
						<FORM id=weaverD action="VotingTypeOperation.jsp" method=post>
							<input class=inputstyle type="hidden" name="method" value="delete">
							<TABLE class=form>
								<COLGROUP>
									<COL width="20%">
									<COL width=80%>
								<TBODY>
									<TR class=separator>
										<TD class=Sep1 colSpan=2></TD>
									</TR>
									<TR>
										<TD colSpan=2>
											<BUTTON class=btnDelete accessKey=D type=submit onclick="return isdel()">
												<U>D</U>-
												<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>
											</BUTTON>
										</TD>
									</TR>
								</TBODY>
							</TABLE>
							<%
							}
							%>
							<TABLE class=ListStyle cellspacing=1>
								<TBODY>
									<TR class=Header>
										<th width=10>
											&nbsp;
										</th>
										<th>
											<%=SystemEnv.getHtmlLabelName(24111, user.getLanguage())%>
										</th>
										<th>
											<%=SystemEnv.getHtmlLabelName(15057, user.getLanguage())%>
										</th>
									</TR>
									<TR class=Line style="height: 1px!important;">
										<TD colspan="4" style="padding: 0!important;"></TD>
									</TR>

									<%
										boolean isLight = false;
										RecordSet.executeSql("select * from voting_type");
										while (RecordSet.next()) {
											if (isLight) {
									%>
									<TR CLASS=DataDark>
										<%
										} else {
										%>
									
									<TR CLASS=DataLight>
										<%
										}
										%>
										<th width=10>
											<%
											if (canmaint) {
											%>
											<input class=inputstyle type=checkbox name=votingTypeIDs value="<%=RecordSet.getString("id")%>">
											<%
											}
											%>
										</th>
										<td>
											<a
												href="VotingType.jsp?id=<%=RecordSet.getString("id")%>"><%=RecordSet.getString("typename")%>
											</a>
										</td>
										<td>
											<%=WorkflowComInfo.getWorkflowname(RecordSet.getString("approver"))%>
										</td>
									</tr>
									<%
										isLight = !isLight;
										}
									%>
								</TBODY>
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
<%
String noDelMeetTypes =  (String)session.getAttribute("noDelMeetTypes");
if (noDelMeetTypes != null && noDelMeetTypes!="") {
%>
<script language="javaScript">
    alert('<%=SystemEnv.getHtmlLabelName(24111, user.getLanguage())%> <%=noDelMeetTypes%> <%=SystemEnv.getHtmlLabelName(24112, user.getLanguage())%>');
</script>
<%
session.setAttribute("noDelMeetTypes","");
}%>
</BODY>
<script language=javascript>
function submitData() {
  if(check_form(weaverA,"name")){
    weaverA.submit();
  }
}
</script>
<script language="vbs">
	sub onShowWorkflow()
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere= where isbill=1 and formid=241")
		if NOT isempty(id) then
		   if id(0)<> 0 then
			approvewfspan.innerHtml = id(1)
			weaverA.approver.value=id(0)
		   else
			approvewfspan.innerHtml = ""
			weaverA.approver.value = ""
			end if
		end if
	end sub
</script>
	