<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%@ page import="weaver.general.Util" %>

<%@ include file="/systeminfo/init.jsp" %>

<%
 if(!HrmUserVarify.checkUserRight("WorkflowCustomManage:All", user)){
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
    String titlename = SystemEnv.getHtmlLabelName(20773,user.getLanguage())+SystemEnv.getHtmlLabelName(19653,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String id = Util.null2String(request.getParameter("id"));
	RecordSet.execute("select a.*,b.typename from workflow_custom a left join workflow_customQuerytype b on a.Querytypeid=b.id where a.id="+id);
	RecordSet.next();
	String formID = Util.null2String(RecordSet.getString("formID"));	
	String isBill = Util.null2String(RecordSet.getString("isBill"));
    String Customname = Util.toScreen(RecordSet.getString("Customname"),user.getLanguage()) ;
	String Querytypeid = Util.null2String(RecordSet.getString("Querytypeid"));
	Querytypeid = (Util.getIntValue(Querytypeid,0)<=0)?"":Querytypeid;
    String Querytypename = Util.null2String(RecordSet.getString("typename"));
	String workflowids = Util.null2String(RecordSet.getString("workflowids"));
    String Customdesc = Util.toScreenToEdit(RecordSet.getString("Customdesc"),user.getLanguage());
    String subcompanyid=Util.null2String(RecordSet.getString("subcompanyid"));
    subcompanyid = (Util.getIntValue(subcompanyid,0)<=0)?"":subcompanyid;
    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	List reportWFList = new ArrayList();
	if(!"".equals(workflowids) && null != workflowids)
	{
		reportWFList = Util.TokenizerString(workflowids, ",");
	}
	String formName="";
	if("0".equals(isBill))
	{
	    formName = formComInfo.getFormname(formID);	    
	}
	else if("1".equals(isBill))
	{
	    formName = SystemEnv.getHtmlLabelName(Util.getIntValue(billComInfo.getBillLabel(formID)), user.getLanguage());
	}
	int operatelevel=0;
	
	if(detachable==1)
	{
		operatelevel = checkSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowCustomManage:All", Util.getIntValue(subcompanyid,0));
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
					RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:doAdd(),_self} " ;
					RCMenuHeight += RCMenuHeightStep;
					RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
					RCMenuHeight += RCMenuHeightStep;
				}
				RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(20773,user.getLanguage())+",javascript:onAddField(),_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doback(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
		%>

		<FORM id=weaver name=frmMain action="CustomOperation.jsp" method=post>
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
			        						        
									        <TR class="Spacing" style="height:1px;">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
                                            <TR>
									      		<TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
									          	<TD class=Field>
									        		<INPUT type=text class=Inputstyle size=30 name="Customname" onchange='checkinput("Customname","Customnameimage")' value="<%=Customname%>">
									          		<SPAN id=Customnameimage></SPAN>
									          	</TD>
									        </TR>
									        <TR style="height:1px;">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
									    	<TR>
									      		<TD><%=SystemEnv.getHtmlLabelName(716,user.getLanguage())%></TD>
									      		<TD class=Field>
									      			<%if(operatelevel>0){ %>
									              
									              	<INPUT type=hidden name=Querytypeid id=Querytypeid class="wuiBrowser" value="<%=Querytypeid%>"  _displayText="<%=Querytypename %>"
									              		_url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/QueryTypeBrowser.jsp" _required="yes">
									              		<%}else{ %>
									              		<span><%=Querytypename %></span>
									              		<%} %>
									            </TD>
									        </TR>
									        <TR class="Spacing"  style="height:1px;">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
									    	<% if(detachable==1){ %>
									    	 <tr>
       											 <td><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
        										 <td  class=field >
           												<%if(operatelevel>0){ %>
           													<INPUT class="wuiBrowser" id=subcompanyid type=hidden name=subcompanyid value="<%=subcompanyid %>"
            												_required="yes" 
            												_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowCustomManage:All&isedit=1"
            												_displayText="<%="".equals(subcompanyid)?"":SubComanyComInfo.getSubCompanyname(subcompanyid) %>">
           												<%}else{ %>
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
    										<TR class="Spacing"  style="height:1px;">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
									    	<%} %>
									  		<TR>									          
									      		<TD><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></TD>
									      		<TD class=Field>
									      			<%= formName %>
									            	<INPUT type=hidden name=formID id=formID value=<%=formID%>>
									            	<INPUT type=hidden name=isBill id=isBill value=<%=isBill%>>
									            </TD>
									        </TR>
									        
									        <TR class="Spacing"  style="height:1px;">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
									        <%
									        	    String outputWorkFlowName = "";
									      			for(int i = 0; i < reportWFList.size(); i++)
									      			{
									      			    outputWorkFlowName += workflowComInfo.getWorkflowname((String)reportWFList.get(i))+"，";
									      			}
                                                if(outputWorkFlowName.equals("")){
                                                    outputWorkFlowName="<font color=red>"+SystemEnv.getHtmlLabelName(23801,user.getLanguage())+"</font>";
                                                }else{
                                                    outputWorkFlowName=outputWorkFlowName.substring(0,outputWorkFlowName.length()-1);
                                                }
									        %>
									    	<TR>
									      		<TD><%=SystemEnv.getHtmlLabelName(15295,user.getLanguage())%></TD>
									      		<TD class=Field >
                                                 <%if(operatelevel>0){ %><BUTTON type=button class=Browser onclick="onShowWorkFlow(workflowids, workflowIDSpan)"></BUTTON><%} %>
                                                    <SPAN id=workflowIDSpan><%= outputWorkFlowName%></SPAN>
                                                    <INPUT type=hidden name=workflowids id=workflowids value="<%=workflowids%>">
									            </TD>
									        </TR>
									        <TR class="Spacing"  style="height:1px;">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
                                            <TR>
                                              <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
                                              <TD class=Field>
                                                  <%if(operatelevel>0){ %><textarea rows="4" cols="80" name="Customdesc" class=Inputstyle><%=Customdesc%></textarea><%}else{ %><%=Customdesc%><%} %>
                                              </TD>
                                            </TR>  
                                            <TR class="Spacing"  style="height:1px;">
									    		<TD class="Line1" colSpan=2 ></TD>
									    	</TR>
									        <input type="hidden" name=operation value=customedit>
											<input type="hidden" name=id value=<%=id%>>
									 
									 	</TBODY>
									</TABLE>
	
  							</FORM>						
  									<BR>
  		
  									<!--================== 自定义字段显示项 ==================-->
									<TABLE>  
										<TR > 
										    <TD width="80%" colspan=2><%=SystemEnv.getHtmlLabelName(20773,user.getLanguage())%>、<%=SystemEnv.getHtmlLabelName(19495,user.getLanguage())%></TD>
										   
											</TD>
										</TR>
										    <TR class="Spacing"  style="height:1px;">
									    		<TD class="Line1" colSpan=2 ></TD>
									    	</TR>  
									</TABLE>

									<TABLE class=liststyle cellspacing=1  >
										<COLGROUP> 
											<COL width="20%"> 
											<COL width="20%"> 
											<COL width="10%">
                                            <COL width="20%">
											<COL width="10%">
											<COL width="20%">
									  	<TBODY> 																		
									  	<TR class=Header> 
										    <TD><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></TD>
										    <TD><%=SystemEnv.getHtmlLabelName(20779,user.getLanguage())%></TD>
                                            <TD><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>
										    <TD><%=SystemEnv.getHtmlLabelName(20778,user.getLanguage())%></TD>
                                            <TD><%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>
											 <TD><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></TD>
									  	</TR>
									    <TR  class="Line"  style="height:1px;"> 
									    	<TD colspan=6 style="padding:0;"></TD>
									  	</TR>
									
										<%
											String theid = "";
											String fieldname = "";
											String dsporder = "";
											String ifquery = "";
											String ifshow = "";
                                            String queryorder="";
											int i=0;
											int dbordercount = 0 ;
											RecordSet.executeSql("select * from Workflow_CustomDspField where customid = " + id + "  and fieldid>-10 and fieldid<0 order by showorder ");
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
												else if("-9".equals(RecordSet.getString("fieldid")))
												{
													fieldname = SystemEnv.getHtmlLabelName(16354,user.getLanguage());
												}
												else if("-8".equals(RecordSet.getString("fieldid")))
												{
													fieldname = SystemEnv.getHtmlLabelName(1335,user.getLanguage());
												}
												else if("-7".equals(RecordSet.getString("fieldid")))
												{
													fieldname = SystemEnv.getHtmlLabelName(17994,user.getLanguage());
												}
												else if("-6".equals(RecordSet.getString("fieldid")))
												{
													fieldname = SystemEnv.getHtmlLabelName(18564,user.getLanguage());
												}
												else if("-5".equals(RecordSet.getString("fieldid")))
												{
													fieldname = SystemEnv.getHtmlLabelName(259,user.getLanguage());
												}
												else if("-4".equals(RecordSet.getString("fieldid")))
												{
													fieldname = SystemEnv.getHtmlLabelName(882,user.getLanguage());
												}
												else if("-3".equals(RecordSet.getString("fieldid")))
												{
													fieldname = SystemEnv.getHtmlLabelName(722,user.getLanguage());
												}
												
											
												dsporder = Util.null2String(RecordSet.getString("showorder")) ;
												ifquery = Util.null2String(RecordSet.getString("ifquery")) ;
												ifshow = Util.null2String(RecordSet.getString("ifshow")) ;
												queryorder = Util.null2String(RecordSet.getString("queryorder")) ;
										
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
											<TD ><%if(ifshow.equals("1")) {%><img src="/images/BacoCheck.gif"><%} %></TD>
                                            <TD><%=dsporder%></TD>
										    <TD ><%if(ifquery.equals("1")) {%><img src="/images/BacoCheck.gif"><%} %></TD>

										    <TD><%=queryorder%></TD>
										    <TD><%if(operatelevel>0){ %><a href="#" onclick="javascript:ondeletefield('CustomOperation.jsp?operation=deletefield&theid=<%=theid%>&id=<%=id%>')" ><img border=0 src="/images/icon_delete.gif"></a><%} %></TD>
										</TR>
										<%
											}
										%>
										
										<%
										
											if("0".equals(isBill))
											{												
												RecordSet.execute("SELECT reportDspField.ID, fieldLable.fieldLable, reportDspField.showorder,reportDspField.ifshow, reportDspField.ifquery,reportDspField.queryorder  FROM Workflow_Custom report, WorkFlow_CustomDspField reportDspField, WorkFlow_FieldLable fieldLable WHERE report.ID = reportDspField.customid AND report.formID = fieldLable.formID AND reportDspField.fieldID = fieldLable.fieldID AND report.ID = " + id + " AND fieldLable.langurageID = " + user.getLanguage() + " ORDER BY reportDspField.showorder ,reportDspField.id");
												//out.println("SELECT reportDspField.ID, fieldLable.fieldLable, reportDspField.showorder,reportDspField.ifshow, reportDspField.ifquery,  FROM Workflow_Custom report, WorkFlow_CustomDspField reportDspField, WorkFlow_FieldLable fieldLable WHERE report.ID = reportDspField.reportID AND report.formID = fieldLable.formID AND reportDspField.fieldID = fieldLable.fieldID AND report.ID = " + id + " AND fieldLable.langurageID = " + user.getLanguage() + " ORDER BY reportDspField.showorder ");
											}
											else if("1".equals(isBill))
											{												
												RecordSet.execute("SELECT reportDspField.ID, htmlLabelInfo.labelName, reportDspField.showorder,reportDspField.ifshow, reportDspField.ifquery,reportDspField.queryorder FROM WorkFlow_CustomDspField reportDspField, workflow_billfield billField, Workflow_Custom report, HtmlLabelInfo htmlLabelInfo WHERE report.ID = reportDspField.customid AND reportDspField.fieldID= billField.ID AND billField.fieldLabel = htmlLabelInfo.indexID AND report.ID = " + id + " AND htmlLabelInfo.languageID = " + user.getLanguage() + " ORDER BY reportDspField.showorder,reportDspField.id");
												//out.println("SELECT reportDspField.ID, htmlLabelInfo.labelName, reportDspField.dspOrder, reportDspField.isStat, reportDspField.dbOrder FROM Workflow_ReportDspField reportDspField, workflow_billfield billField, Workflow_Report report, HtmlLabelInfo htmlLabelInfo WHERE report.ID = reportDspField.reportID AND reportDspField.fieldID= billField.ID AND billField.fieldLabel = htmlLabelInfo.indexID AND report.ID = " + id + " AND htmlLabelInfo.languageID = " + user.getLanguage() + " ORDER BY reportDspField.showorder");
											}

											
											while(RecordSet.next()) 
											{
												theid = Util.null2String(RecordSet.getString("ID")) ;
												fieldname = Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
												dsporder = Util.null2String(RecordSet.getString("showorder")) ;
												ifquery = Util.null2String(RecordSet.getString("ifquery")) ;
												ifshow = Util.null2String(RecordSet.getString("ifshow")) ;
												queryorder = Util.null2String(RecordSet.getString("queryorder")) ;
											
											
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
										    <TD ><%if(ifshow.equals("1")) {%><img src="/images/BacoCheck.gif"><%} %></TD>
                                            <TD><%=dsporder%></TD>
											<TD ><%if(ifquery.equals("1")) {%><img src="/images/BacoCheck.gif"><%} %></TD>
										    <TD><%=queryorder%></TD>
										    <TD><a href="#" onclick="javascript:ondeletefield('CustomOperation.jsp?operation=deletefield&theid=<%=theid%>&id=<%=id%>')" ><img border=0 src="/images/icon_delete.gif"></a></TD>
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
		if(isdel()) {
            enableAllmenu();
            document.frmMain.action="CustomOperation.jsp";
			document.frmMain.operation.value="customdelete";
			document.frmMain.submit();
		}
}
function ondeletefield(src){
    if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
        enableAllmenu();
        document.frmMain.action=src;
		document.frmMain.submit();
    }
}
function onAddField(){
    enableAllmenu();
    location.href="CustomFieldAdd.jsp?id=<%=id%>&isBill=<%= isBill %>&formID=<%= formID %>&dbordercount=<%=dbordercount%>" ;
}

</script>

 <script language=vbs>

</script>
<script language="javascript">
function onShowSubcompany(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowCustomManage:All&isedit=1&selectedids="+weaver.subcompanyid.value)
	var issame = false
	if (data){
		if (data.id!="0"){
			if (data.id == weaver.subcompanyid.value){
				issame = true
			}
			subcompanyspan.innerHTML = data.name
			weaver.subcompanyid.value=data.id
		}else{
			subcompanyspan.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			weaver.subcompanyid.value=""
		}
	}
}
function WorkFlowBeforeShow(opts,e){
	isBill = document.all("isBill").value
	formID = document.all("formID").value
	workflowids = document.all("workflowids").value
	opts._url=opts._url+"?value="+isBill+"_"+formID+"_"+workflowids;
	}
function submitData()
{
	var checkfields = "";
	<%if(detachable==1){%>
        checkfields = 'Customname,Querytypeid,formID,subcompanyid';
    <%}else{%>
    	checkfields = 'Customname,Querytypeid,formID';
    <%}%>
	if (check_form(frmMain,checkfields)){
        enableAllmenu();
		frmMain.submit();
    }
}
function doAdd(){
        enableAllmenu();
       	<%if(detachable==1){%>
        location.href="/workflow/workflow/CustomQueryAdd.jsp?Querytypeid=<%=Querytypeid%>&subcompanyid=<%=subcompanyid%>";
        <%}else{%>
        location.href="/workflow/workflow/CustomQueryAdd.jsp?Querytypeid=<%=Querytypeid%>";
        <%}%>
    }
function doback(){
    enableAllmenu();
    <%if(detachable==1){%>
    location.href="/workflow/workflow/CustomQuerySet.jsp?otype=<%=Querytypeid%>&subcompanyid=<%=subcompanyid%>";
    <%}else{%>
    location.href="/workflow/workflow/CustomQuerySet.jsp?otype=<%=Querytypeid%>";
    <%}%>
}



function onShowWorkFlow(workflowIDHidden, workflowIDSpan){
var isBill = $G("isBill").value
var formID = $G("formID").value
var workflowids = $G("workflowids").value
	url = "/systeminfo/BrowserMain.jsp?url=/workflow/report/WorkFlowofFormBrowser.jsp?value=" + isBill + "_" + formID + "_" + workflowids;
	data = window.showModalDialog(url)
	if (data){
		if (data.id!=""){
			resourceids = data.id
			resourcename = data.name
			var sHtml = ""
			
			if (resourceids.indexOf(",") == 0) {
				resourceids = resourceids.substr(1);
				resourcename = resourcename.substr(1);
			}
			workflowIDHidden.value= resourceids
			ids = resourceids.split(",");
			names =resourcename.split(",");
			for( var i=0;i<ids.length;i++){
				if(ids[i]!=""){
					sHtml = sHtml+names[i]+"&nbsp;";
				}
			}
		
			workflowIDSpan.innerHTML = sHtml
		}else{
			workflowIDHidden.value = ""
			workflowIDSpan.innerHTML = "<font color=red><%=SystemEnv.getHtmlLabelName(23801,user.getLanguage())%></font>"
		}
	}
}
</script>
</BODY></HTML>
