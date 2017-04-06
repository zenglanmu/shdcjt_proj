<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%@ page import="weaver.general.Util" %>

<%@ include file="/systeminfo/init.jsp" %>

<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ReportTypeComInfo" class="weaver.workflow.report.ReportTypeComInfo" scope="page" />
<jsp:useBean id="formComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="billComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="workflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />

<HTML>
	<HEAD>
		<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="../../js/weaver.js"></SCRIPT>
	</HEAD>
<%
	String imagefilename = "/images/hdHRMCard.gif";
	String titlename = SystemEnv.getHtmlLabelName(15101,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String sql = "";
	String id = Util.null2String(request.getParameter("id"));
	sql = "select a.*,b.modename,b.formid from mode_Report a,modeinfo b where a.modeid = b.id and a.id = " + id;
	RecordSet.executeSql(sql);
	RecordSet.next();
	String reportname = Util.toScreen(RecordSet.getString("reportname"),user.getLanguage()) ;
	String reportdesc = Util.toScreen(RecordSet.getString("reportdesc"),user.getLanguage()) ;
	String formID = Util.null2String(RecordSet.getString("formID"));
	String modename = Util.null2String(RecordSet.getString("modename"));
	String modeid = Util.null2String(RecordSet.getString("modeid"));
	int reportnumperpage = Util.getIntValue(RecordSet.getString("reportnumperpage"),0);
	
%>

	<BODY>
		<%@ include file="/systeminfo/TopTitle.jsp" %>
		
		<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+",ReportShare.jsp?id="+id+",_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())+",javascript:onAddField(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/formmode/report/ReportManage.jsp?modeid="+modeid+",_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(28493,user.getLanguage())+",javascript:createmenu(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(28624,user.getLanguage())+",javascript:viewmenu(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
		%>

		<FORM id=weaver name=frmMain action="ReportOperation.jsp" method=post onsubmit="return false">
			<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
				<COLGROUP>
					<COL width="10">
					<COL width="">
					<COL width="10">
				<TR>
					<TD height="10" colspan="3"></TD>
				</TR>
				<TR>
					<TD ></TD>
					<TD valign="top">
						<TABLE class=Shadow>
							<TR>
								<TD valign="top">
									<TABLE class="viewform">
										<COLGROUP>
											<COL width="20%">
											<COL width="80%">
									  	<TBODY>
									  		<TR class="Title">
									      		<TH colSpan=2><%=SystemEnv.getHtmlLabelName(15101,user.getLanguage())%></TH>
									    	</TR>
									  		<TR class="Spacing" style="height:1px;">
									    		<TD class="Line1" colSpan=2 ></TD>
									    	</TR>
									  		<TR>									          
									      		<TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
									          	<TD class=Field>
									        		<INPUT type=text class=Inputstyle size=30 name="reportname" maxlength="50" onchange='checkinput("reportName","reportnameimage")' value="<%=reportname%>">
									          		<SPAN id=reportnameimage></SPAN>
									          	</TD>
									        </TR>
									        <TR style="height:1px;">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
									    	<TR>
									      		<TD><%=SystemEnv.getHtmlLabelName(28485,user.getLanguage())%></TD>
									      		<TD class=Field >
                                                 <!-- 
                                                 <BUTTON type=button class=Browser onclick="onShowModeSelect(modeid, modeidspan)"></BUTTON>
                                                  -->
                                                    <SPAN id=modeidspan><%=modename%></SPAN>
                                                    <INPUT type=hidden name=modeid id=modeid value="<%=modeid%>">
									            </TD>
									        </TR>
									        <TR style="height:1px;">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
											<TR>
									      		<TD><%=SystemEnv.getHtmlLabelName(17491,user.getLanguage())%></TD>
												<td class="Field">
											  		 <input type="text" onKeyPress="ItemPlusCount_KeyPress()" maxlength="9" onblur='checkPlusnumber1(reportnumperpage),checkinput("reportnumperpage","reportnumperpageimage")' value="<%=reportnumperpage%>" name="reportnumperpage" id="reportnumperpage">
											  		 <SPAN id=reportnumperpageimage></SPAN>
												</td>
									        </TR>
									        <TR class="Spacing" style="height: 1px">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
                                            <TR>
                                              <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
                                              <TD class=Field>
                                                  <textarea rows="4" cols="80" name="reportdesc"  onkeyup="this.value = this.value.substring(0, 2000)" class=Inputstyle><%=reportdesc%></textarea>
                                              </TD>
                                            </TR>  
                                            <TR class="Spacing"  style="height:1px;">
									    		<TD class="Line1" colSpan=2 ></TD>
									    	</TR>
										
									        <input type="hidden" name=operation value=reportedit>
											<input type="hidden" name=id value=<%=id%>>
									 
									 	</TBODY>
									</TABLE>
	
  									</FORM>						
  									<BR>
  		
  									<!--================== 报表显示项 ==================-->
									<TABLE style="width:100%;">  
										<TR > 
										    <TD width="40%"><%=SystemEnv.getHtmlLabelName(15510,user.getLanguage())%></TD>
										    <TD align=right colspan=4 width="60%">    
											<!--modify by xhheng @20050218 for TD 1540 -->
											 
											</TD>
										</TR>
									</TABLE>

									<TABLE class=liststyle cellspacing=1  >
										<COLGROUP> 
											<COL width="40%"> 
											<COL width="15%"> 
											<COL width="15%"> 
											<COL width="15%">
											<COL width="15%">
									  	<TBODY> 																		
									  	<TR class=Header> 
										    <TD><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></TD>
										    <TD><%=SystemEnv.getHtmlLabelName(15511,user.getLanguage())%></TD>
										    <TD><%=SystemEnv.getHtmlLabelName(15512,user.getLanguage())%></TD>
										    <TD><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>
										    <TD><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></TD>
									  	</TR>
									    <TR  class="Line" style="height:1px;"> 
									    	<TD colspan=5></TD>
									  	</TR>
										<%
											String theid = "";
											String fieldname = "";
											String dsporder = "";
											String dborder = "";
											String isstat = "";
											int viewtype = 0;
											int i=0;
											int dbordercount = 0 ;
											sql = "select * from Mode_ReportDspField where reportid = " + id + " and fieldid in(-1,-2) order by fieldid desc";
											//out.println(sql);
											RecordSet.executeSql(sql);
											while(RecordSet.next()) 
											{
												theid = Util.null2String(RecordSet.getString("id")) ;
												if("-1".equals(RecordSet.getString("fieldid")))
												{
													fieldname = SystemEnv.getHtmlLabelName(722,user.getLanguage());
												}
												else if("-2".equals(RecordSet.getString("fieldid")))
												{
													fieldname = SystemEnv.getHtmlLabelName(882,user.getLanguage());
												}
												dsporder = Util.null2String(RecordSet.getString("dsporder")) ;
												dborder = Util.null2String(RecordSet.getString("dborder")) ;
												isstat = Util.null2String(RecordSet.getString("isstat")) ;
											
												if(dborder.equals("1")) 
												{
												    dbordercount ++ ;
												}
										
												if(i==0)
												{
													i=1;
										%>
										<TR class=DataLight> 
										    
										<%
												}
												else
												{
													i=0;
										%>
										<TR class=DataDark> 
										<%
												}
										%>
										    <TD><%=fieldname%></TD>
										    <TD align=center><%if(isstat.equals("1")) {%><img src="/images/BacoCheck.gif"><%} %></TD>
										    <TD align=center><%if(dborder.equals("1")) {%><img src="/images/BacoCheck.gif"><%} %></TD>
										    <TD><%=dsporder%></TD>
										    <TD><a href="ReportOperation.jsp?operation=deletefield&theid=<%=theid%>&id=<%=id%>" ><img border=0 src="/images/icon_delete.gif"></a></TD>
										</TR>
										<%
											}
										%>
										<%
											sql = "SELECT reportDspField.ID, htmlLabelInfo.labelName, reportDspField.dspOrder, reportDspField.isStat, reportDspField.dbOrder,viewtype FROM mode_ReportDspField reportDspField, workflow_billfield billField, mode_Report report, HtmlLabelInfo htmlLabelInfo WHERE report.ID = reportDspField.reportID AND reportDspField.fieldID= billField.ID AND billField.fieldLabel = htmlLabelInfo.indexID AND report.ID = " + id + " AND htmlLabelInfo.languageID = " + user.getLanguage() + " ORDER BY reportDspField.dspOrder";
											//out.println(sql);
											RecordSet.executeSql(sql);
											while(RecordSet.next()) 
											{
												theid = Util.null2String(RecordSet.getString("ID")) ;//xwj for td2974 20051026
												fieldname = Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;//xwj for td2974 20051026
												dsporder = Util.null2String(RecordSet.getString("dspOrder")) ;//xwj for td2974 20051026
												dborder = Util.null2String(RecordSet.getString("dbOrder")) ;//xwj for td2974 20051026
												isstat = Util.null2String(RecordSet.getString("isStat")) ;//xwj for td2974 20051026
												viewtype = Util.getIntValue(RecordSet.getString("viewtype"),0);
												if(viewtype == 1) fieldname += "("+SystemEnv.getHtmlLabelName(17463,user.getLanguage())+")";
												if(dborder.equals("1")) 
												{
												    dbordercount ++ ;
												}
											
												if(i==0)
												{
													i=1;
										%>
										<TR class=DataLight> 
										<%
												}
												else
												{
													i=0;
										%>
										<TR class=DataDark> 
										<%
												}
										%>
											<TD><%=fieldname%></TD>
										    <TD align=center><%if(isstat.equals("1")) {%><img src="/images/BacoCheck.gif"><%} %></TD>
										    <TD align=center><%if(dborder.equals("1")) {%><img src="/images/BacoCheck.gif"><%} %></TD>
										    <TD><%=dsporder%></TD>
										    <TD><a href="ReportOperation.jsp?operation=deletefield&theid=<%=theid%>&id=<%=id%>" ><img border=0 src="/images/icon_delete.gif"></a></TD>
										</TR>
										<%
											}
										%>
										</TBODY>
									</TABLE>
								</TD>
							</TR>
						</TABLE>
					</TD>
					<TD></TD>
				</TR>
				<TR>
					<TD height="10" colspan="3"></TD>
				</TR>
			</TABLE>
			<%@ include file="/systeminfo/RightClickMenu.jsp" %>
		<BR>

<script>
function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		document.frmMain.operation.value="reportdelete";
		document.frmMain.submit();
	}
}

function onAddField(){
    location.href="/formmode/report/ReportFieldAdd.jsp?id=<%=id%>" ;
}

function onShowModeSelect(inputName, spanName){
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp");
	if (datas){
	    if(datas.id!=""){
		    $(inputName).val(datas.id);
			if ($(inputName).val()==datas.id){
		    	$(spanName).html(datas.name);
			}
	    }else{
		    $(inputName).val("");
			$(spanName).html("<img src=\"/images/BacoError.gif\">");
		}
	} 
}

function submitData()
{
	var checkfields = "reportname,modeid,reportnumperpage";
	if (check_form(frmMain,checkfields))
		frmMain.submit();
}
function createmenu(){
	var url = "/formmode/report/ReportCondition.jsp?id=<%=id%>";
	window.open("/formmode/menu/CreateMenu.jsp?menuaddress="+escape(url));
}
function viewmenu(){
	var url = "/formmode/report/ReportCondition.jsp?id=<%=id%>";
	prompt("<%=SystemEnv.getHtmlLabelName(28624,user.getLanguage())%>",url);
}
</script>
</BODY></HTML>
