<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%@ page import="weaver.general.Util" %>

<%@ include file="/systeminfo/init.jsp" %>

<%
 if(!HrmUserVarify.checkUserRight("WorkflowReportManage:All", user)){
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
	String titlename = SystemEnv.getHtmlLabelName(15514,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String id = Util.null2String(request.getParameter("id"));
	RecordSet.executeProc("Workflow_Report_SelectByID",id);
	RecordSet.next();
	
	String reportName = Util.toScreen(RecordSet.getString("reportName"),user.getLanguage()) ;
	String reportType = Util.null2String(RecordSet.getString("reportType"));
	reportType = (Util.getIntValue(reportType,0)<=0)?"":reportType;
	String reportWFID = Util.null2String(RecordSet.getString("reportWFID"));
	String subcompanyid= Util.null2String(RecordSet.getString("subcompanyid"));
	subcompanyid = (Util.getIntValue(subcompanyid,0)<=0)?"":subcompanyid;
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	List reportWFList = new ArrayList();
	
	if(!"".equals(reportWFID) && null != reportWFID)
	{
		reportWFList = Util.TokenizerString(reportWFID, ",");
	}
	
	String formID = Util.null2String(RecordSet.getString("formID"));
	String formName = "";	
	String isBill = Util.null2String(RecordSet.getString("isBill"));
	
	if("0".equals(isBill))
	{
	    formName = formComInfo.getFormname(formID);	    
	}
	else if("1".equals(isBill))
	{
	    formName = SystemEnv.getHtmlLabelName(Util.getIntValue(billComInfo.getBillLabel(formID)), user.getLanguage());
	}
	String isShowOnReportOutput = Util.null2String(RecordSet.getString("isShowOnReportOutput"));
	int operatelevel=0;
	
	if(detachable==1)
	{
		operatelevel = checkSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowReportManage:All", Util.getIntValue(subcompanyid,0));
	}
	else
	{
		operatelevel = 2;
	}
%>

	<BODY>
		<%@ include file="/systeminfo/TopTitle.jsp" %>
		
		<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
		<%
		if(operatelevel>0)
		{
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			if(operatelevel>1)
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",ReportAdd.jsp?reportType="+reportType+"&subcompanyid="+subcompanyid+",_self} " ;
				RCMenuHeight += RCMenuHeightStep;
				RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
			RCMenu += "{"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+",ReportShare.jsp?id="+id+",_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())+",javascript:onAddField(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
		}
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/workflow/report/ReportManage.jsp?subcompanyid="+subcompanyid+"&otype="+reportType+",_self} " ;
			RCMenuHeight += RCMenuHeightStep;
		%>
		
		
		<%
		 // if(HrmUserVarify.checkUserRight("HrmProvinceAdd:Add", user)){
		%>
		
		<%
		// }
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
									        		<%if(operatelevel>0){ %><INPUT type=text class=Inputstyle size=30 name="reportName" onchange='checkinput("reportName","reportnameimage")' value="<%=reportName%>"><%}else{ %><%=reportName%><%} %>
									          		<SPAN id=reportnameimage></SPAN>
									          	</TD>
									        </TR>
									        <TR style="height:1px;">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
									    	<% if(detachable==1){ %>
									    	 <tr>
       											 <td><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
        										 <td  class=field >
           												<%if(operatelevel>0){ %>
           													<INPUT class="wuiBrowser" id=subcompanyid type=hidden name=subcompanyid value="<%=subcompanyid %>"
            												_displayText="<%=SubComanyComInfo.getSubCompanyname(subcompanyid) %>" _required="yes"
            												_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowReportManage:All&isedit=1">
           													<%}else{
           												%>
        												<SPAN id=subcompanyspan>
        												<% if(subcompanyid.equals("")){ %>
        												<IMG src="/images/BacoError.gif" align=absMiddle>
        												<%}else{
        													out.print(SubComanyComInfo.getSubCompanyname(subcompanyid)); 
        												}%>
        												</SPAN>
        												<%} %>
            											
        										 </td>
    										</tr>
    										<TR class="Spacing" style="height:1px;">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
									    	<%} %>
									    	<TR>
									      		<TD><%=SystemEnv.getHtmlLabelName(716,user.getLanguage())%></TD>									          
									      		<TD class=Field>
									      			<%if(operatelevel>0){ %>
									              	<INPUT type=hidden class="wuiBrowser" name=reportType id=reportType value=<%=reportType%> _required="yes" _displayText="<%=Util.toScreen(ReportTypeComInfo.getReportTypename(reportType),user.getLanguage())%>"
									              		_url="/systeminfo/BrowserMain.jsp?url=/workflow/report/ReportTypeBrowser.jsp"
									              	>
									              	 <%}else{ %>
									              	<SPAN id=reporttypeimage><%=Util.toScreen(ReportTypeComInfo.getReportTypename(reportType),user.getLanguage())%></SPAN> 
									              <%} %>
									              	
									            </TD>
									        </TR>									        						        
									        <TR class="Spacing" style="height:1px;">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
									  		<TR>									          
									      		<TD><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></TD>
									      		<TD class=Field>
									      			<%= formName %>
									            	<INPUT type=hidden name=formID id=formID value=<%=formID%>>
									            	<INPUT type=hidden name=isBill id=isBill value=<%=isBill%>>
									            </TD>
									        </TR>
									        
									        <%
									        	if(0 != reportWFList.size())
									        	{
									        	    String outputWorkFlowName = "";	
										      		
									      			for(int i = 0; i < reportWFList.size(); i++)
									      			{
									      			  	outputWorkFlowName += workflowComInfo.getWorkflowname((String)reportWFList.get(i)) + "，";
									      			}
									        %>	
							        		<TR style="height:1px;">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
									    	<TR>
									      		<TD><%=SystemEnv.getHtmlLabelName(15295,user.getLanguage())%></TD>									          
									      		<TD class=Field >
									      		<%= outputWorkFlowName.substring(0, outputWorkFlowName.length() - 1) %>								      		
									            </TD>
									        </TR>								        
									        <%
									        	}
									        %>	
									        <TR class="Spacing" style="height:1px;">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>

									        <TR>          
									            <TD><%=SystemEnv.getHtmlLabelName(20832,user.getLanguage())%></TD>          
									           <TD class=Field>
									        	    <INPUT type=checkbox name="isShowOnReportOutput" value="1" <% if(isShowOnReportOutput.equals("1")) {%> checked <%}%> <%if(operatelevel<=0){ %>disabled<%}%>>
									            </TD>
									        </TR>
            
									        <TR style="height:1px;"><TD class="Line" colSpan=2 ></TD></TR>
											
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
										<!--  xwj for td2974 20051026      B E G I N   -->
										<%
											String theid = "";
											String fieldname = "";
											String dsporder = "";
											String dborder = "";
											String isstat = "";
											int i=0;
											int dbordercount = 0 ;
											RecordSet.executeSql("select * from Workflow_ReportDspField where reportid = " + id + " and fieldid in (-1,-2) order by fieldid desc");
											while(RecordSet.next()) 
											{
												theid = Util.null2String(RecordSet.getString("id")) ;
												if("-1".equals(RecordSet.getString("fieldid")))
												{
													fieldname = SystemEnv.getHtmlLabelName(1334,user.getLanguage());
												}
												else if("-2".equals(RecordSet.getString("fieldid")))
												{
													fieldname = SystemEnv.getHtmlLabelName(15534,user.getLanguage());
												}
												else
												{
												    
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
										    <TD><%if(operatelevel>0){ %><a href="ReportOperation.jsp?operation=deletefield&theid=<%=theid%>&id=<%=id%>" ><img border=0 src="/images/icon_delete.gif"></a><%} %></TD>
										</TR>
										<%
											}
										%>
										<!--    xwj for td2974 20051026      E N D   -->     
										<%
										
											String sql = "";
											if("0".equals(isBill)){					
												StringBuffer sqlSB = new StringBuffer();
												sqlSB.append("select rf.ID,bf.label,rf.dspOrder,rf.isStat, rf.dbOrder  from                                 \n");
												sqlSB.append(" (select workflow_formfield.fieldid      as id,                                               \n");
												sqlSB.append("         fieldname                       as name,                                             \n");
												sqlSB.append("         workflow_fieldlable.fieldlable  as label,                                            \n");
												sqlSB.append("         workflow_formfield.fieldorder as fieldorder,                                         \n");
												sqlSB.append("         workflow_formdict.fielddbtype   as dbtype,                                           \n");
												sqlSB.append("         workflow_formdict.fieldhtmltype as httype,                                           \n");
												sqlSB.append("         workflow_formdict.type as type                                                       \n");
												sqlSB.append("    from workflow_formfield, workflow_formdict, workflow_fieldlable                           \n");
												sqlSB.append("   where workflow_fieldlable.formid = workflow_formfield.formid                               \n");
												sqlSB.append("     and workflow_fieldlable.isdefault = 1                                                    \n");
												sqlSB.append("     and workflow_fieldlable.fieldid = workflow_formfield.fieldid                             \n");
												sqlSB.append("     and workflow_formdict.id = workflow_formfield.fieldid                                    \n");
												sqlSB.append("     and workflow_formfield.formid = " + formID + "                                           \n");
												sqlSB.append("     and (workflow_formfield.isdetail <> '1' or workflow_formfield.isdetail is null)          \n");
												sqlSB.append("  union                                                                                       \n");
												sqlSB.append("  select workflow_formfield.fieldid as id,                                                    \n");
												sqlSB.append("         fieldname as name,                                                                   \n");
												sqlSB.append("         workflow_fieldlable.fieldlable  as label,                                            \n");
												sqlSB.append("         workflow_formfield.fieldorder + 100 as fieldorder,                                   \n");
												sqlSB.append("         workflow_formdictdetail.fielddbtype as dbtype,                                       \n");
												sqlSB.append("         workflow_formdictdetail.fieldhtmltype as httype,                                     \n");
												sqlSB.append("         workflow_formdictdetail.type as type                                                 \n");
												sqlSB.append("    from workflow_formfield, workflow_formdictdetail, workflow_fieldlable                     \n");
												sqlSB.append("   where workflow_fieldlable.formid = workflow_formfield.formid                               \n");
												sqlSB.append("     and workflow_fieldlable.isdefault = 1                                                    \n");
												sqlSB.append("     and workflow_fieldlable.fieldid = workflow_formfield.fieldid                             \n");
												sqlSB.append("     and workflow_formdictdetail.id = workflow_formfield.fieldid                              \n");
												sqlSB.append("     and workflow_formfield.formid =" + formID + "                                            \n");
												sqlSB.append("     and (workflow_formfield.isdetail = '1' or workflow_formfield.isdetail is not null)) bf   \n");
												sqlSB.append(" left join (Select * from Workflow_ReportDspField where reportid = " + id + " ) rf            \n");
												sqlSB.append(" on (bf.id = rf.fieldid) Where rf.fieldid Is not null  order by rf.dsporder                                                \n");
												sql = sqlSB.toString();
											} else if("1".equals(isBill)) {			
												StringBuffer sqlSB = new StringBuffer();
												sqlSB.append(" select rf.ID,bf.label,rf.dspOrder,rf.isStat, rf.dbOrder from                                 \n");
												sqlSB.append("   (select wfbf.id            as id,                                                          \n");
												sqlSB.append("           wfbf.fieldname     as name,                                                        \n");
												sqlSB.append("           wfbf.fieldlabel    as label,                                                       \n");
												sqlSB.append("           wfbf.fielddbtype   as dbtype,                                                      \n");
												sqlSB.append("           wfbf.fieldhtmltype as httype,                                                      \n");
												sqlSB.append("           wfbf.type          as type,                                                        \n");
												sqlSB.append("           wfbf.dsporder      as dsporder,                                                    \n");
												sqlSB.append("           wfbf.viewtype      as viewtype,                                                    \n");
												sqlSB.append("           wfbf.detailtable   as detailtable                                                  \n");
												sqlSB.append("      from workflow_billfield wfbf                                                            \n");
												sqlSB.append("     where wfbf.billid = " + formID + " AND wfbf.viewtype = 0                                 \n");
												sqlSB.append("    Union                                                                                     \n");
												sqlSB.append("    select wfbf.id            as id,                                                          \n");
												sqlSB.append("           wfbf.fieldname     as name,                                                        \n");
												sqlSB.append("           wfbf.fieldlabel    as label,                                                       \n");
												sqlSB.append("           wfbf.fielddbtype   as dbtype,                                                      \n");
												sqlSB.append("           wfbf.fieldhtmltype as httype,                                                      \n");
												sqlSB.append("           wfbf.type          as type,                                                        \n");
												sqlSB.append("		     wfbf.dsporder+100  as dsporder,                                                    \n");
												sqlSB.append("		     wfbf.viewtype      as viewtype,                                                    \n");
												sqlSB.append("           wfbf.detailtable   as detailtable                                                  \n");
												sqlSB.append("		  from workflow_billfield wfbf                                                          \n");
												sqlSB.append("		 where wfbf.billid = " + formID + " AND wfbf.viewtype = 1                               \n");
												sqlSB.append("  ) bf left join (Select * from Workflow_ReportDspField                                       \n");
												sqlSB.append("  where reportid = " + id + ") rf on (bf.id = rf.fieldid)                                     \n");
												sqlSB.append("  Where rf.fieldid Is not null  order by rf.dsporder, bf.dsporder, bf.detailtable             \n");
												sql = sqlSB.toString();
											}
											RecordSet.execute(sql);
											while(RecordSet.next()) 
											{
												theid = Util.null2String(RecordSet.getString("ID")) ;//xwj for td2974 20051026
												if(isBill.equals("1")){
													fieldname = SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString(2)),user.getLanguage());
												} else {
													fieldname = Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;//xwj for td2974 20051026
												}
												dsporder = Util.null2String(RecordSet.getString("dspOrder")) ;//xwj for td2974 20051026
												dborder = Util.null2String(RecordSet.getString("dbOrder")) ;//xwj for td2974 20051026
												isstat = Util.null2String(RecordSet.getString("isStat")) ;//xwj for td2974 20051026
												
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
										    <TD><%if(operatelevel>0){ %><a href="ReportOperation.jsp?operation=deletefield&theid=<%=theid%>&id=<%=id%>" ><img border=0 src="/images/icon_delete.gif"></a><%} %></TD>
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
    location.href="ReportFieldAdd.jsp?id=<%=id%>&isBill=<%= isBill %>&formID=<%= formID %>&dbordercount=<%=dbordercount%>" ;
}

</script>

<script language="javascript">
function submitData()
{
	var checkfields = "";
	<%if(detachable==1){%>
        checkfields = 'reportName,reportType,reportWFID,subcompanyid';
    <%}else{%>
    	checkfields = 'reportName,reportType,reportWFID';
    <%}%>
	if (check_form(frmMain,checkfields))
		frmMain.submit();
}
</script>
</BODY></HTML>
