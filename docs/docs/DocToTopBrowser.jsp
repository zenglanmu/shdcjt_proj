<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.general.Util"%>

<%@ page import="java.util.*"%>
<%@ include file="/systeminfo/init.jsp"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
int docid = Util.getIntValue(request.getParameter("docid"),0);
String istop = "";
String topstartdate = "";
String topenddate = "";

RecordSet.executeSql("select istop,topstartdate,topenddate from docdetail where id="+docid);
RecordSet.next();
istop = Util.null2String(RecordSet.getString("istop"));
topstartdate = Util.null2String(RecordSet.getString("topstartdate"));
topenddate = Util.null2String(RecordSet.getString("topenddate"));

String istopcheck = istop.equals("1")?"checked":"";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
	</HEAD>
	<BODY style="background-color: #ffffff">
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
								<form name="frmCenter"  id="frmCenter" action="javascript:void(0);" method="post">
									<TABLE class=viewform>
										<TBODY>
											<TR>
												<TD vAlign=top>
													<TABLE class=viewForm>
														<COLGROUP>
															<COL width="20%">
															<COL width="80%">
														<TBODY>
															<TR class=Title>
																<TH colSpan=2><%=SystemEnv.getHtmlLabelName(68, user.getLanguage())%></TH>
															</TR>
															<TR class=Spacing style="height: 1px!important;">
																<TD class=Line1 colSpan=2></TD>
															</TR>
															<TR>
																<TD><%=SystemEnv.getHtmlLabelName(23784, user.getLanguage())%></TD>
																<TD class=Field>
																	<input class=inputstyle type='checkbox' id='istop' name='istop' value="<%=istop %>" <%=istopcheck %> onclick="if(this.checked){this.value='1';}else{this.value='0';}">
																</TD>
															</TR>
															<TR style="height: 1px!important;">
																<TD class=Line colSpan=2></TD>
															</TR>
															<TR>
																<TD><%=SystemEnv.getHtmlLabelName(15030, user.getLanguage())%></TD><!-- ÓÐÐ§ÆÚ -->
																<TD class=Field>
																	<BUTTON type="button" class=calendar id=SelectDate onclick="getLimitStartDate('topstartdatespan','topstartdate','topenddatespan','topenddate')"></BUTTON>
																	<SPAN id=topstartdatespan><%=topstartdate %></SPAN>
																	<input class=inputstyle type="hidden" id="topstartdate" name="topstartdate" value="<%=topstartdate %>">
																	£­&nbsp;
																	<BUTTON type="button" class=calendar id=SelectDate onclick="getLimitEndDate('topstartdatespan','topstartdate','topenddatespan','topenddate')"></BUTTON>
																	<SPAN id=topenddatespan><%=topenddate %></SPAN>
																	<input class=inputstyle type="hidden" id="topenddate" name="topenddate" value="<%=topenddate %>">

																</TD>
															</TR>
															<TR style="height: 1px!important;">
																<TD class=Line colSpan=2></TD>
															</TR>														
														</TBODY>
													</TABLE>
												</TD>
											</TR>
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
	</BODY>
	<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
	<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>