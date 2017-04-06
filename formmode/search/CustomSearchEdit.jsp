<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%@ page import="weaver.general.Util" %>

<%@ include file="/systeminfo/init.jsp" %>

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

	if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdHRMCard.gif";
    String titlename = SystemEnv.getHtmlLabelName(20773,user.getLanguage())+ ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

	
	String formID = "";	
	String isBill = "1";
    String Customname = "";
	String modeid = "";
	String modename = "";
    String Customdesc = "";
	String formName = "";
	String defaultsql = "";
	String disQuickSearch = "";
	String norightlist = "";
	int opentype = 0;//打开方式
	
	String id = Util.null2String(request.getParameter("id"));
	String sql = "select a.modeid,a.customname,a.customdesc,b.modename,b.formid,a.defaultsql,a.disQuickSearch,a.norightlist,a.opentype from mode_customsearch a,modeinfo b where a.modeid = b.id and a.id="+id;
	RecordSet.executeSql(sql);
	if(RecordSet.next()){
		formID = Util.null2String(RecordSet.getString("formid"));	
		isBill = "1";
	    Customname = Util.toScreen(RecordSet.getString("Customname"),user.getLanguage()) ;
		modeid = Util.null2String(RecordSet.getString("modeid"));
		modename = Util.null2String(RecordSet.getString("modename"));
	    Customdesc = Util.toScreenToEdit(RecordSet.getString("Customdesc"),user.getLanguage());
	    defaultsql = Util.toScreenToEdit(RecordSet.getString("defaultsql"),user.getLanguage());
	    disQuickSearch = Util.toScreenToEdit(RecordSet.getString("disQuickSearch"),user.getLanguage());
		formName = SystemEnv.getHtmlLabelName(Util.getIntValue(billComInfo.getBillLabel(formID)), user.getLanguage());
		norightlist = Util.null2String(RecordSet.getString("norightlist"));
		opentype = Util.getIntValue(RecordSet.getString("opentype"),0);
	}

%>

	<BODY>
		<%@ include file="/systeminfo/TopTitle.jsp" %>
		
		<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
		
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(20773,user.getLanguage())+",javascript:onAddField(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			//批量
			RCMenu += "{"+SystemEnv.getHtmlLabelName(27244,user.getLanguage())+",javascript:doBatchSet(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			
			
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doback(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(30247,user.getLanguage())+",javascript:createmenu(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(30248,user.getLanguage())+",javascript:viewmenu(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			
			RCMenu += "{"+SystemEnv.getHtmlLabelName(30245,user.getLanguage())+",javascript:createmenu1(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(30246,user.getLanguage())+",javascript:viewmenu1(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
		%>

		<FORM id=weaver name=frmMain action="/formmode/search/CustomSearchOperation.jsp" method=post>
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
									        		<INPUT type=text class=Inputstyle size=30 name="Customname" maxlength="50" onchange='checkinput("Customname","Customnameimage")' value="<%=Customname%>">
									          		<SPAN id=Customnameimage></SPAN>
									          	</TD>
									        </TR>
									        <TR style="height:1px;">
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
									        
									        <TR class="Spacing"  style="height:1px;">
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
									        <TR class="Spacing"  style="height:1px;">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
                                            <TR>
                                              <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
                                              <TD class=Field>
                                                  <textarea rows="4" style="width:80%" name="Customdesc" onchange="this.value = this.value.substring(0, 2000)" maxlength="2000" class=Inputstyle><%=Customdesc%></textarea>
                                              </TD>
                                            </TR>  
                                            <TR class="Spacing"  style="height:1px;">
									    		<TD class="Line1" colSpan=2 ></TD>
									    	</TR>
                                            <TR>
                                              <TD><%=SystemEnv.getHtmlLabelName(81366,user.getLanguage())%></TD>
                                              <TD class=Field>
                                                  <textarea rows="4" style="width:80%" name="defaultsql" onchange="this.value = this.value.substring(0, 2000)" maxlength="2000" class=Inputstyle><%=defaultsql%></textarea>
                                                  <br>
                                                  <%=SystemEnv.getHtmlLabelName(81388,user.getLanguage())%>
                                              </TD>
                                            </TR>  
                                            <TR class="Spacing"  style="height:1px;">
									    		<TD class="Line1" colSpan=2 ></TD>
									    	</TR>
                                            <TR>
                                              <TD><%=SystemEnv.getHtmlLabelName(81367,user.getLanguage())%></TD>
                                              <TD class=Field>
                                                  <INPUT type="checkbox" class=Inputstyle size=30 name="disQuickSearch" value="1" <%if(disQuickSearch.equals("1")){out.println("checked");} %>>
                                              </TD>
                                            </TR>  
                                            <TR class="Spacing"  style="height:1px;">
									    		<TD class="Line1" colSpan=2 ></TD>
									    	</TR>
                                            <TR>
                                              <TD><%=SystemEnv.getHtmlLabelName(81476,user.getLanguage())%></TD>
                                              <TD class=Field>
                                                  <INPUT type="checkbox" class=Inputstyle size=30 name="norightlist" value="1" <%if(norightlist.equals("1")){out.println("checked");} %>>
                                              </TD>
                                            </TR>  
                                            <TR class="Spacing"  style="height:1px;">
									    		<TD class="Line1" colSpan=2 ></TD>
									    	</TR>
									    	
                                            <TR>
                                              <TD><%=SystemEnv.getHtmlLabelName(30847,user.getLanguage())%></TD>
                                              <TD class=Field>
                                              	<select id="opentype" name="opentype">
													<option value="0" <%if(opentype==0)out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(18717,user.getLanguage())%></option>
													<option value="1" <%if(opentype==1)out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(20597,user.getLanguage())%></option>                                              	
                                              	</select>
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
										</TR>
										    <TR class="Spacing"  style="height:1px;">
									    		<TD class="Line1" colSpan=2 ></TD>
									    	</TR>  
									</TABLE>

									<TABLE class=liststyle cellspacing=1  >
										<COLGROUP> 
											<COL width="20%"> 
											<COL width="15%"> 
											<COL width="15%">
											<COL width="10%">
                                            <COL width="20%">
											<COL width="10%">
											<COL width="10%">
									  	<TBODY> 																		
									  	<TR class=Header> 
										    <TD><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></TD>
										    <TD><%=SystemEnv.getHtmlLabelName(20779,user.getLanguage())%></TD>
										    <TD><%=SystemEnv.getHtmlLabelName(19501,user.getLanguage())%></TD>
                                            <TD><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>
										    <TD><%=SystemEnv.getHtmlLabelName(20778,user.getLanguage())%></TD>
                                            <TD><%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>
											 <TD><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></TD>
									  	</TR>
									    <TR  class="Line"  style="height:1px;"> 
									    	<TD colspan=7 style="padding:0;"></TD>
									  	</TR>
									
										<%
											String theid = "";
											String fieldname = "";
											String dsporder = "";
											String isquery = "";
											String isshow = "";
                                            String queryorder="";
                                            String istitle="";
											int i=0;
											int dbordercount = 0 ;
											RecordSet.executeSql("select * from mode_CustomDspField where customid = " + id + "  and fieldid>-10 and fieldid<0 order by showorder ");
											while(RecordSet.next()) 
											{
												theid = Util.null2String(RecordSet.getString("id")) ;
												if("-2".equals(RecordSet.getString("fieldid")))
												{
													fieldname = SystemEnv.getHtmlLabelName(882,user.getLanguage());
												}
												else if("-1".equals(RecordSet.getString("fieldid")))
												{
													fieldname = SystemEnv.getHtmlLabelName(722,user.getLanguage());
												}
												
											
												dsporder = Util.null2String(RecordSet.getString("showorder")) ;
												isquery = Util.null2String(RecordSet.getString("isquery")) ;
												isshow = Util.null2String(RecordSet.getString("isshow")) ;
												queryorder = Util.null2String(RecordSet.getString("queryorder")) ;
												istitle = Util.null2String(RecordSet.getString("istitle")) ;
										
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
											<TD ><%if(isshow.equals("1")) {%><img src="/images/BacoCheck.gif"><%} %></TD>
											<TD ><%if(istitle.equals("1")) {%><img src="/images/BacoCheck.gif"><%} %></TD>
                                            <TD><%=dsporder%></TD>
										    <TD ><%if(isquery.equals("1")) {%><img src="/images/BacoCheck.gif"><%} %></TD>

										    <TD><%=queryorder%></TD>
										    <TD><a href="#" onclick="javascript:ondeletefield('/formmode/search/CustomSearchOperation.jsp?operation=deletefield&theid=<%=theid%>&id=<%=id%>')" ><img border=0 src="/images/icon_delete.gif"></a></TD>
										</TR>
										<%
											}
										%>
										
										<%
											sql = "SELECT reportDspField.ID, htmlLabelInfo.labelName, reportDspField.showorder,reportDspField.isshow, reportDspField.isquery,reportDspField.queryorder,reportDspField.istitle FROM mode_CustomDspField reportDspField, workflow_billfield billField, mode_customsearch report, HtmlLabelInfo htmlLabelInfo WHERE report.ID = reportDspField.customid AND reportDspField.fieldID= billField.ID AND billField.fieldLabel = htmlLabelInfo.indexID AND report.ID = " + id + " AND htmlLabelInfo.languageID = " + user.getLanguage() + " ORDER BY reportDspField.showorder,reportDspField.id"; 
											//out.println(sql);
											RecordSet.execute(sql);
											while(RecordSet.next()) 
											{
												theid = Util.null2String(RecordSet.getString("ID")) ;
												fieldname = Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
												dsporder = Util.null2String(RecordSet.getString("showorder")) ;
												isquery = Util.null2String(RecordSet.getString("isquery")) ;
												isshow = Util.null2String(RecordSet.getString("isshow")) ;
												queryorder = Util.null2String(RecordSet.getString("queryorder")) ;
												istitle = Util.null2String(RecordSet.getString("istitle")) ;
											
											
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
										    <TD ><%if(isshow.equals("1")) {%><img src="/images/BacoCheck.gif"><%} %></TD>
										    <TD ><%if(istitle.equals("1")) {%><img src="/images/BacoCheck.gif"><%} %></TD>
                                            <TD><%=dsporder%></TD>
											<TD ><%if(isquery.equals("1")) {%><img src="/images/BacoCheck.gif"><%} %></TD>
										    <TD><%=queryorder%></TD>
										    <TD><a href="#" onclick="javascript:ondeletefield('/formmode/search/CustomSearchOperation.jsp?operation=deletefield&theid=<%=theid%>&id=<%=id%>')" ><img border=0 src="/images/icon_delete.gif"></a></TD>
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
		document.frmMain.action="/formmode/search/CustomSearchOperation.jsp";
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
    location.href="/formmode/search/CustomSearchFieldAdd.jsp?id=<%=id%>&isBill=<%=isBill %>&formID=<%= formID %>&dbordercount=<%=dbordercount%>" ;
}
function createmenu(){
	var url = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=id%>";
	window.open("/formmode/menu/CreateMenu.jsp?menuaddress="+escape(url));
}
function viewmenu(){
	var url = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=id%>";
	prompt("<%=SystemEnv.getHtmlLabelName(28624,user.getLanguage())%>",url);
}

function createmenu1(){
	var url = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=id%>&viewtype=3";
	window.open("/formmode/menu/CreateMenu.jsp?menuaddress="+escape(url));
}
function viewmenu1(){
	var url = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=id%>&viewtype=3";
	prompt("<%=SystemEnv.getHtmlLabelName(28624,user.getLanguage())%>",url);
}

</script>

<script language="javascript">
function submitData()
{
	var checkfields = "";
    	checkfields = 'Customname,formID';
	if (check_form(frmMain,checkfields)){
        enableAllmenu();
		frmMain.submit();
    }
}
function doback(){
	enableAllmenu();
	location.href="/formmode/search/CustomSearch.jsp?modeid=<%=modeid%>";
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
			$(spanName).html("");
		}
	} 
}

function doBatchSet(){
    enableAllmenu();
    location.href="/formmode/batchoperate/ModeBatchSet.jsp?id=<%=id%>";
}
</script>
</BODY></HTML>
