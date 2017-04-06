<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/systeminfo/init.jsp"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	if (!HrmUserVarify.checkUserRight("WorkflowMonitor:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>


<HTML>
	<HEAD>
		<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="../../js/weaver.js"></script>
	</head>
	<%
		int msgid = Util.getIntValue(request.getParameter("msgid"), -1);

		String imagefilename = "/images/hdHRMCard.gif";
		String titlename = SystemEnv.getHtmlLabelName(2239, user.getLanguage());
		String needfav = "1";
		String needhelp = "";

		String id = Util.null2String(request.getParameter("id"));
		RecordSet.executeSql("select * from Workflow_MonitorType where id = " + id);
		RecordSet.next();

		String typename = Util.toScreen(RecordSet.getString("typename"), user.getLanguage());
		String typedesc = Util.toScreen(RecordSet.getString("typedesc"), user.getLanguage());
		String typeorder = Util.null2String(RecordSet.getString("typeorder"));

		RecordSet.executeSql("SELECT count(*) FROM workflow_monitor_bound where monitortype=" + id);
		int typecount = 0;
		if (RecordSet.next())
		{
			typecount = RecordSet.getInt(1);
		}
		boolean isedit = false;
	%>
	<BODY>
		<%@ include file="/systeminfo/TopTitle.jsp"%>

		<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
		<%
		if(user.getUID()==1)
		{
			RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:submitData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
			
			RCMenu += "{" + SystemEnv.getHtmlLabelName(82, user.getLanguage()) + ",MonitorTypeAdd.jsp,_self} ";
			RCMenuHeight += RCMenuHeightStep;
			
			if (typecount == 0)
			{
				RCMenu += "{" + SystemEnv.getHtmlLabelName(91, user.getLanguage()) + ",javascript:onDelete(),_self} ";
				RCMenuHeight += RCMenuHeightStep;
			}
			isedit = true;
		}
		RCMenu += "{" + SystemEnv.getHtmlLabelName(1290, user.getLanguage()) + ",/workflow/monitor/CustomMonitorType.jsp,_self} ";
		RCMenuHeight += RCMenuHeightStep;
		%>

		<%@ include file="/systeminfo/RightClickMenu.jsp"%>
		<FORM id=weaver name=frmMain action="MonitorTypeOperation.jsp" method=post>
			<%
				if (msgid != -1)
				{
			%>
			<DIV>
				<font color=red size=2> <%=SystemEnv.getErrorMsgName(msgid, user.getLanguage())%>
				</font>
			</DIV>
			<%
				}
			%>

			<table width=100% height=100% border="0" cellspacing="0"
				cellpadding="0">
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

									<TABLE class="viewform">
										<COLGROUP>
											<COL width="20%">
											<COL width="80%">
										<TBODY>
											<TR class="Title">
												<TH colSpan=2><%=SystemEnv.getHtmlLabelName(2239, user.getLanguage())%></TH>
											</TR>
											<TR class="Spacing" style="height:1px;">
												<TD class="Line1" colSpan=2 ></TD>
											</TR>
											<TR>

												<TD><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></TD>
												<TD class=Field>
													<%if(isedit){ %><INPUT type=text class=Inputstyle size=30 name="typename" onchange='checkinput("typename","typenameimage")' value="<%=typename%>"><%}else{ %><%=typename%><%} %>
													<SPAN id=typenameimage></SPAN>
												</TD>
											</TR>
											<TR class="Spacing" style="height:1px;">
												<TD class="Line" colSpan=2></TD>
											</TR>
											<TR>
											<TR>

												<TD><%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%></TD>
												<TD class=Field>
													<%if(isedit){ %><INPUT type=text class=Inputstyle size=60 name="typedesc" value="<%=typedesc%>"><%}else{ %><%=typedesc%><%} %>
													<SPAN id=provincedescimage></SPAN>
												</TD>
											</TR>
											<TR class="Spacing" style="height:1px;">
												<TD class="Line" colSpan=2></TD>
											</TR>
											<TR>
											<TR>

												<TD><%=SystemEnv.getHtmlLabelName(15513, user.getLanguage())%></TD>

												<TD class=Field>
													<%if(isedit){ %><input type=text size=35 class=inputstyle id="typeorder" name="typeorder" maxlength=10 value="<%=typeorder%>" onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);"><%}else{ %><%=typeorder%><%} %>
												</TD>
											</TR>
											<TR class="Spacing"  style="height:1px;">
												<TD class="Line1" colSpan=2></TD>
											</TR>
											<TR>
												<input type="hidden" name=operation value=edit>
												<input type="hidden" name=id value=<%=id%>>
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

		</form>
		<script>
		function onDelete()
		{
			if(confirm("<%=SystemEnv.getHtmlNoteName(7, user.getLanguage())%>")) 
			{
				document.frmMain.operation.value="delete";
				document.frmMain.submit();
			}
		}
		function submitData()
		{
			if (check_form(weaver,'typename'))
				weaver.submit();
		}
		</script>
	</BODY>
</HTML>
