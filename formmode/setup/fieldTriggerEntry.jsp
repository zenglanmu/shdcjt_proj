<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<%@ include file="/systeminfo/init.jsp"%>
<%@ page import="weaver.system.code.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs4" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />

<jsp:useBean id="modeLinkageInfo" class="weaver.formmode.setup.ModeLinkageInfo" scope="page" />
<jsp:useBean id="ModeLayoutUtil" class="weaver.formmode.setup.ModeLayoutUtil" scope="page" />
<html>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
	int modeId=Util.getIntValue(Util.null2String(request.getParameter("modeId")),0); 
	int entryID=Util.getIntValue(Util.null2String(request.getParameter("entryID")),0); 
	//System.out.println("modeId="+modeId+"  entryID="+entryID);
	String message=Util.null2String(request.getParameter("message"));
	if(message.equals("reset")) message = SystemEnv.getHtmlLabelName(22428,user.getLanguage());
	
	modeLinkageInfo.setModeId(modeId);
	modeLinkageInfo.init();
	int fromId = modeLinkageInfo.getFormId();
	List pointArrayList = DataSourceXML.getPointArrayList();
	String sql="";
	String MainFieldsOptions = "";//主字段
	//String wfDetailFieldsOptions = "";//明细字段
	String FieldsOptions = "";//全部字段
	
	sql = "select id,fieldlabel,viewtype,dsporder from workflow_billfield where viewtype=0 and billid="+fromId+
		  " order by viewtype,dsporder";
	
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		String fieldname = "";
		fieldname = SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldlabel"), user.getLanguage());
		MainFieldsOptions += "<option value="+RecordSet.getString(1)+">"+fieldname+"</option>";
	}
	Hashtable detailFiledHST = new Hashtable();
	//明细字段
	ArrayList detailtablelist = new ArrayList();
	sql = "select distinct detailtable from workflow_billfield where billid="+fromId;
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
	    String tempdetailtable = RecordSet.getString("detailtable");
	    detailtablelist.add(tempdetailtable);
	}
	for(int i=0;i<detailtablelist.size();i++){
	    String tempdetailtable = Util.null2String((String)detailtablelist.get(i));
	    if(tempdetailtable.equals("")) continue;
	    sql = "select id,fieldlabel,viewtype,dsporder from workflow_billfield where viewtype=1 and billid="+fromId+" and detailtable='"+tempdetailtable+"'";
	    sql += " order by viewtype,dsporder";
	    RecordSet.executeSql(sql);
	    String wfDetailFieldsOptions = "";
	    while(RecordSet.next()){
	        String fieldname = SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldlabel"), user.getLanguage());
	        wfDetailFieldsOptions += "<option value="+RecordSet.getString(1)+">"+fieldname+"</option>";
	    }
	    detailFiledHST.put(tempdetailtable,wfDetailFieldsOptions);
	}
	
	String imagefilename = "/images/hdMaintenance.gif";
	String titlename = SystemEnv.getHtmlLabelName(21683,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage());
	String needfav ="";
	String needhelp ="";
	if(entryID>0){
		titlename = SystemEnv.getHtmlLabelName(21683,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());
	}
%>
	<head>
		<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver.js"></script>
	    <script language="JavaScript" src="/js/addRowBg.js" ></script>
	</head>
	<body <%if(entryID==0){%>onload="addRowOfFieldTrigger();addTriggerSetting(0);"<%} %>>
		<%@ include file="/systeminfo/TopTitle.jsp"%>
		<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
		<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:modeTriggerSave(this),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu.jsp"%>
		<form id="frmTrigger" name="frmTrigger" method=post action="triggerOperation.jsp">
			<input type="hidden" id="txtUserUse" name="txtUserUse" value="1">
			<input type="hidden" id="triggerNum" name="triggerNum" value="1">
			<input type="hidden" id="srcfrom" name="srcfrom" value="entry">
			<input type="hidden" id="modeId" name="modeId" value="<%=modeId%>">
			<input type="hidden" id="entryID" name="entryID" value="<%=entryID%>">
			<div style="display: none">
				<table id="hidden_tab" cellpadding='0' width=0 cellspacing='0'>
				</table>
			</div>
			<table width=100% height=90% border="0" cellspacing="0"
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
									<table id=LinkageTable class="viewform" cols=2>
										<COLGROUP>
											<COL width="2%">
											<COL width="98%">
											<%
											int index = 0;
											RecordSet.executeSql("select * from modeDataInputentry where modeid="+modeId+" and id="+entryID);
											while(RecordSet.next()){
												String TriggerName = RecordSet.getString("TriggerName");
												String TriggerFieldName = RecordSet.getString("TriggerFieldName");
												String fieldid = TriggerFieldName.substring(5,TriggerFieldName.length());
												String fieldname = "";
												int fieldtype = -1;
												String formid = "";
												rs1.executeSql("select formid from modeinfo where id="+modeId);
												if(rs1.next()){
													formid = rs1.getString("formid");
												}
												rs1.executeSql("select fieldlabel,viewtype from workflow_billfield where id="+fieldid+" and billid="+formid);
												if(rs1.next()){
													fieldname = SystemEnv.getHtmlLabelName(rs1.getInt("fieldlabel"), user.getLanguage());
													fieldtype = Util.getIntValue(rs1.getString("viewtype"),-1);
												}
												TriggerName = "".equals(TriggerName)?("".equals(fieldname)?TriggerFieldName:fieldname):TriggerName;
												//System.out.println("TriggerName="+TriggerName);
											%>
											<tr>
												<td class=field><input type="checkbox" name="checkbox_TriggerField" value="<%=index%>"></td>
												<td>
													<table width="100%" cols=2>
														<COLGROUP>
														<COL width="30%">
														<COL width="70%">
														<tr>
															<td><%=SystemEnv.getHtmlLabelName(21805,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22009,user.getLanguage())%></td>
															<td class=field>
																<input type=text class=Inputstyle size=20 maxLength=50 id="triggerName<%=index%>" name="triggerName<%=index%>" value="<%=TriggerName %>">
															</td>
														</tr><TR><TD class=Line colSpan=2></TD></TR>
														<tr>
															<td><%=SystemEnv.getHtmlLabelName(21805,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></td>
															<td class=field>
																<BUTTON class=Browser onClick="onShowTriggerField(triggerField<%=index%>,triggerFieldSpan<%=index%>,triggerFieldType<%=index%>,<%=index%>)"></BUTTON>
																<span id="triggerFieldSpan<%=index%>"><%if(fieldname.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}else{%><%=fieldname%><%}%></span>
																<input type="hidden" value="<%=fieldtype%>" name="triggerFieldType<%=index%>" id="triggerFieldType<%=index%>">
																<input type="hidden" value="<%=fieldid%>" name="triggerField<%=index%>" id="triggerField<%=index%>">
															</td>
														</tr><TR><TD class=Line colSpan=2></TD></TR>
														<tr>
															<td><b><%=SystemEnv.getHtmlLabelName(21805,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19653,user.getLanguage())%></b></td>
															<td align=right>
																<a style="color:#262626;cursor:hand; TEXT-DECORATION:none" onclick='addTriggerSetting(<%=index%>)'><img src='/js/swfupload/add.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21805,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19653,user.getLanguage())%></a>
																<a style="color:#262626;cursor:hand; TEXT-DECORATION:none" onclick='deleteTriggerSetting(<%=index%>)'><img src='/js/swfupload/delete.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21805,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19653,user.getLanguage())%></a>
															</td>
														</tr><TR><TD class=Line1 colSpan=2></TD></TR>
														<tr><td colSpan=2>
															<table id="table_<%=index%>" width="100%" class="viewform" cols=2>
																<COLGROUP>
																<COL width="2%">
																<COL width="98%">
																<%
																int secIndex = 0;
																rs1.executeSql("select * from modeDataInputmain where entryID="+entryID+" order by OrderID");
																while(rs1.next()){
																int DateInputID = rs1.getInt("id");
																int IsCycle = rs1.getInt("IsCycle");
																String WhereClause = rs1.getString("WhereClause");
																String datasourcename=Util.null2String(rs1.getString("datasourcename"));
																%>
																<tr>
																	<td class=field><input type='checkbox' name='checkbox_TriggerSetting' value=''></td>
																	<td>
																		<table width=100%><COLGROUP><COL width='30%'><COL width='70%'>
																			<tr>
																				<td><%=SystemEnv.getHtmlLabelName(21840,user.getLanguage())%></td>
																				<td class=field colSpan=2>
																					<select id="tabletype<%=index%><%=secIndex%>" name="tabletype<%=index%><%=secIndex%>">
																						<%if(fieldtype==0){%><option value=0><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></option><%}%>
																						<%if(fieldtype==1){%><option value=1><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%></option><%}%>
																					</select>
																					<%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%>：
																					<select id="datasource<%=index%><%=secIndex%>" name="datasource<%=index%><%=secIndex%>" onchange="changedatasource(this,'<%=index%>','<%=secIndex%>')">
																					<option value=""></option>
																					<% for(int l=0;l<pointArrayList.size();l++){
																					%>
																					<option value="<%=pointArrayList.get(l)%>" <%if(datasourcename.equals((String)pointArrayList.get(l))){%>selected<%}%>><%=pointArrayList.get(l)%></option>
																					<%}%>
																					</select>
																				</td>
																			</tr>
																			<TR><TD class=Line colSpan=3></TD></TR>
																			<tr>
																				<td valign=top><%=SystemEnv.getHtmlLabelName(19422,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15190,user.getLanguage())%></td>
																				<td>
																					<table id="tableTable<%=index%><%=secIndex%>" width=100% cols=4>
																						<COLGROUP><COL width='25%'><COL width='25%'><COL width='10%'><COL width='10%'><COL width='30%'>
																						<%
																						int thIndex = 1;
																						rs2.executeSql("select * from modeDataInputtable where DataInputID="+DateInputID+" order by id");
																						while(rs2.next()){
																							String TableName = rs2.getString("TableName");
																							String Alias = rs2.getString("Alias");
																							String FormId = Util.null2String(rs2.getString("FormId"));
																							String tablenamespan = "";
																						if(datasourcename.trim().equals("")){
																						if(!FormId.equals("")){
																							if(FormId.indexOf("_") < 0){
																								rs3.executeSql("select formname from workflow_formbase where id="+FormId);
																								if(rs3.next()) tablenamespan = rs3.getString("formname");
																								tablenamespan += "("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")";
																							}else{
																								String tempFormId = FormId.substring(0,FormId.indexOf("_"));
																								String tempGroupId = FormId.substring(FormId.indexOf("_")+1,FormId.length());
																								rs3.executeSql("select formname from workflow_formbase where id="+tempFormId);
																								if(rs3.next()) tablenamespan = rs3.getString("formname");
																								rs3.executeSql("select distinct groupId from workflow_formfield where formid="+tempFormId+" and isdetail=1 order by groupId");
																								int detailIndex = 0;
																								while(rs3.next()){
																									detailIndex++;
																									if(rs3.getString("groupId").equals(tempGroupId)) break;
																								}
																								tablenamespan += "("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+detailIndex+")";
																							}
																						}else{//System.out.println("2222");
																							rs3.executeSql("select namelabel from workflow_bill where tablename='"+TableName+"'");
																							if(rs3.next()){
																								tablenamespan = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
																								tablenamespan += "("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")";
																							}else{//System.out.println("TableName="+TableName);
																								rs3.executeSql("select tabledesc,tabledescen from Sys_tabledict where tablename='"+TableName+"'");
																								//System.out.println("select tabledesc,tabledescen from Sys_tabledict where tablename='"+TableName+"'");
																								if(rs3.next()){
																									if(user.getLanguage()==7) tablenamespan = rs3.getString("tabledesc");
																									if(user.getLanguage()==8) tablenamespan = rs3.getString("tabledescen");
																									tablenamespan += "("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")";
																								}else{
																									rs3.executeSql("select billid from Workflow_billdetailtable where tablename='"+TableName+"'");
																									if(rs3.next()){
																										String tempBillId = rs3.getString("billid");
																										rs3.executeSql("select namelabel from workflow_bill where id="+tempBillId);
																										if(rs3.next()){
																											tablenamespan = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
																										}
																										rs3.executeSql("select tablename from Workflow_billdetailtable where billid="+tempBillId);
																										int detailIndex = 0;
																										while(rs3.next()){
																											detailIndex++;
																											String tempTableName = rs3.getString("tablename");
																											if(tempTableName.equals(TableName)) break;
																										}
																										tablenamespan += "("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+detailIndex+")";
																									}else{
																										rs3.executeSql("select namelabel from workflow_bill where detailtablename='"+TableName+"'");
																										if(rs3.next()){
																											tablenamespan = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
																											tablenamespan += "("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+"1)";
																										}
																									}
																								}
																							}
																						}
																						}
																						%>
																						<tr>
																							<td class=field style="display:<%if(!datasourcename.trim().equals("")){%>none<%}%>"><BUTTON class=Browser onClick="onShowTable(tablename<%=index%><%=secIndex%><%=thIndex%>,tablenamespan<%=index%><%=secIndex%><%=thIndex%>,formid<%=index%><%=secIndex%><%=thIndex%>)"></BUTTON><span id="tablenamespan<%=index%><%=secIndex%><%=thIndex%>"><%=tablenamespan%></span>
																							<input type=hidden id="formid<%=index%><%=secIndex%><%=thIndex%>" name="formid<%=index%><%=secIndex%><%=thIndex%>" value="<%=FormId%>"></td>
																							<td class=field><input type=text class=Inputstyle size=10 id="tablename<%=index%><%=secIndex%><%=thIndex%>" name="tablename<%=index%><%=secIndex%><%=thIndex%>" value="<%=TableName%>"></td>
																							<td class=field><%=SystemEnv.getHtmlLabelName(475,user.getLanguage())%></td>
																							<td class=field><input type=text class=Inputstyle size=6 id='tablebyname<%=index%><%=secIndex%><%=thIndex%>' name='tablebyname<%=index%><%=secIndex%><%=thIndex%>' value="<%=Alias%>"></td>
																						</tr>
																						<%
																						thIndex++;
																						}%>
																						<input type="hidden" id="tableTableRowsNum_<%=index%>_<%=secIndex%>" name="tableTableRowsNum_<%=index%>_<%=secIndex%>" value="<%=thIndex%>">
																					</table>
																				</td>
																				<td class=field valign=top nowrap>
																				    <a style="color:#262626;cursor:hand; TEXT-DECORATION:none" onclick="addtable(tableTable<%=index%><%=secIndex%>,<%=index%>,<%=secIndex%>)"><img src='/js/swfupload/add.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>
																				</td>
																			</tr>
																			<TR><TD class=Line colSpan=3></TD></TR>
																			<tr>
																				<td valign=top><%=SystemEnv.getHtmlLabelName(21841,user.getLanguage())%></td>
																				<td class=field colSpan=2><textarea class=Inputstyle id="tableralations<%=index%><%=secIndex%>" name="tableralations<%=index%><%=secIndex%>" cols=68 rows=4><%=WhereClause%></textarea><br><font color=red><%=SystemEnv.getHtmlLabelName(21842,user.getLanguage())%>a.id=b.id and a.wfid=b.wfid</font></td>
																			</tr><TR><TD class=Line colSpan=3></TD></TR>
																			<tr>
																				<td><b><%=SystemEnv.getHtmlLabelName(21843,user.getLanguage())%></b></td>
																				<td align=right colSpan=4>
																					<a style="color:#262626;cursor:hand; TEXT-DECORATION:none" onclick="addParameterTable(parameterTable<%=index%><%=secIndex%>,<%=index%>,<%=secIndex%>)"><img src='/js/swfupload/add.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21843,user.getLanguage())%></a>
																					<a style="color:#262626;cursor:hand; TEXT-DECORATION:none" onclick="deleteParameterTable(parameterTable<%=index%><%=secIndex%>)"><img src='/js/swfupload/delete.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21843,user.getLanguage())%></a>
																				</td>
																			</tr><TR><TD class=Line1 colSpan=5></TD></TR>
																			<tr><td colSpan=5>
																				<table id='parameterTable<%=index%><%=secIndex%>' width=100% class='liststyle' cols=3><COLGROUP><COL width='2%'><COL width='49%'><COL width='49%'>
																					<tr class=Header>
																						<td></td>
																						<td><%=SystemEnv.getHtmlLabelName(21844,user.getLanguage())%></td>
																						<td><%=SystemEnv.getHtmlLabelName(28605,user.getLanguage())%></td>
																					</tr>
																					<%
																					int forthIndex = 1;
																					rs3.executeSql("select * from modeDataInputfield where Type=1 and DataInputID="+DateInputID+" order by id");
																					while(rs3.next()){
																						String TableID = rs3.getString("TableID");
																						String DBFieldName = rs3.getString("DBFieldName");
																						String PageFieldName = rs3.getString("PageFieldName");
																						String PageFieldId = PageFieldName.substring(5,PageFieldName.length());
																						String FieldTableName = "";
																						String FieldTableFormId = "";
																						String parafieldnamespan = DBFieldName;
																						if(parafieldnamespan.equals("requestid")) parafieldnamespan = SystemEnv.getHtmlLabelName(648,user.getLanguage())+"ID";
																						if(parafieldnamespan.equals("id")) parafieldnamespan = SystemEnv.getHtmlLabelName(563,user.getLanguage())+"ID";
																						rs4.executeSql("select TableName,FormId from modeDataInputtable where id="+TableID);
																						if(rs4.next()){
																							FieldTableName = rs4.getString("TableName");
																							FieldTableFormId = Util.null2String(rs4.getString("FormId"));
																							if(!FieldTableFormId.equals("")&&FieldTableFormId.indexOf("_")>0) FieldTableFormId = FieldTableFormId.substring(0,FieldTableFormId.indexOf("_"));
																						}
																						if(datasourcename.trim().equals("")&&!parafieldnamespan.equals("requestid")&&!parafieldnamespan.equals("id")){
																						if(FieldTableName.equals("workflow_form")||FieldTableName.equals("workflow_formdetail")){
																							  if(FieldTableName.equals("workflow_form"))
																						        rs4.executeSql("select a.fieldlable from workflow_fieldlable a,workflow_formdict b where a.langurageid="+user.getLanguage()+" and a.fieldid=b.id and a.formid="+FieldTableFormId+" and b.fieldname='"+DBFieldName+"' and a.langurageid = "+user.getLanguage());
																						    else
																						        rs4.executeSql("select a.fieldlable from workflow_fieldlable a,workflow_formdictdetail b where a.langurageid="+user.getLanguage()+" and a.fieldid=b.id and a.formid="+FieldTableFormId+" and b.fieldname='"+DBFieldName+"' and a.langurageid = "+user.getLanguage());
																						    if(rs4.next()) parafieldnamespan = Util.null2String(rs4.getString("fieldlable"));
																						}else{
																							rs4.executeSql("select id from workflow_bill where tablename='"+FieldTableName+"' or detailtablename='"+FieldTableName+"' union select billid as id from workflow_billdetailtable where tablename='"+FieldTableName+"'");
																							if(rs4.next()){
																								rs4.executeSql("select fieldlabel from workflow_billfield where billid="+rs4.getInt("id")+" and fieldname='"+DBFieldName+"'");
																								if(rs4.next()) parafieldnamespan = SystemEnv.getHtmlLabelName(rs4.getInt("fieldlabel"),user.getLanguage());
																							}else{
																								rs4.executeSql("select id from Sys_tabledict where tablename='"+FieldTableName+"'");
																								if(rs4.next()){
																									rs4.executeSql("select fielddesc,fielddescen from Sys_fielddict where fieldname='"+DBFieldName+"' and tabledictid="+rs4.getInt("id"));
																									if(rs4.next()){
																										if(user.getLanguage()==7) parafieldnamespan = rs4.getString("fielddesc");
																										if(user.getLanguage()==8) parafieldnamespan = rs4.getString("fielddescen");
																									}
																								}
																							}
																							}
																						}																			
																					%>
																					<tr>
																						<td class=field><input type='checkbox' name='checkbox_ParameterSetting' value="<%=forthIndex%>"></td>
																						<td class=field><button class=Browser onClick="showParaTableFiled(tableTable<%=index%><%=secIndex%>,<%=index%>,<%=secIndex%>,<%=forthIndex%>)"></button><span id='parafieldnamespan<%=index%><%=secIndex%><%=forthIndex%>'><%=parafieldnamespan%></span>
																							<input type=hidden id='parafieldname<%=index%><%=secIndex%><%=forthIndex%>' name='parafieldname<%=index%><%=secIndex%><%=forthIndex%>' value='<%=DBFieldName%>'>
																							<input type=hidden id='parafieldtablename<%=index%><%=secIndex%><%=forthIndex%>' name='parafieldtablename<%=index%><%=secIndex%><%=forthIndex%>' value='<%=FieldTableName%>'>
																						</td>
																						<td class=field>
																							<select id='parawfField<%=index%><%=secIndex%><%=forthIndex%>' name='parawfField<%=index%><%=secIndex%><%=forthIndex%>'>
																							<%
																							if(fieldtype==0){
																								String tempMainFieldsOptions = Util.StringReplace(MainFieldsOptions,"<option value="+PageFieldId+">","<option value="+PageFieldId+" selected>");
																							%>
																							<%=tempMainFieldsOptions%>
																							<%
																							}else{
																								String tempFieldsOptions = "";
																							    rs4.executeSql("select detailtable from workflow_billfield where id="+fieldid);
																							    if(rs4.next()) tempFieldsOptions = Util.null2String((String)detailFiledHST.get(rs4.getString("detailtable")));
																								tempFieldsOptions = Util.StringReplace(tempFieldsOptions,"<option value="+PageFieldId+">","<option value="+PageFieldId+" selected>");
																							%>
																							<%=tempFieldsOptions%>
																							<%}%>
																							</select>
																						</td>
																					</tr>
																					<%
																					forthIndex++;
																					}%>
																					<input type="hidden" id="parameterTableRowsNum_<%=index%>_<%=secIndex%>" name="parameterTableRowsNum_<%=index%>_<%=secIndex%>" value="<%=forthIndex%>">
																				</table>
																			</td></tr>
																			<tr>
																				<td><b><%=SystemEnv.getHtmlLabelName(21845,user.getLanguage())%></b></td>
																				<td align=right colSpan=4>
																					<a style="color:#262626;cursor:hand; TEXT-DECORATION:none" onclick='addEvaluateTable(evaluateTable<%=index%><%=secIndex%>,<%=index%>,<%=secIndex%>)'><img src='/js/swfupload/add.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21846,user.getLanguage())%></a>
																					<a style="color:#262626;cursor:hand; TEXT-DECORATION:none" onclick='deleteEvaluateTable(evaluateTable<%=index%><%=secIndex%>)'><img src='/js/swfupload/delete.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21846,user.getLanguage())%></a>
																				</td>
																			</tr><TR><TD class=Line1 colSpan=5></TD></TR>
																			<tr><td colSpan=5>
																				<table id='evaluateTable<%=index%><%=secIndex%>' width=100% class='liststyle' cols=3><COLGROUP><COL width='2%'><COL width='49%'><COL width='49%'>
																					<tr class=Header>
																						<td></td>
																						<td><%=SystemEnv.getHtmlLabelName(21847,user.getLanguage())%></td>
																						<td><%=SystemEnv.getHtmlLabelName(28605,user.getLanguage())%></td>
																					</tr>
																					<%
																					int fivethIndex = 1;
																					rs3.executeSql("select * from modeDataInputfield where Type=2 and DataInputID="+DateInputID+" order by id");
																					while(rs3.next()){
																						String TableID = rs3.getString("TableID");
																						String DBFieldName = rs3.getString("DBFieldName");
																						String PageFieldName = rs3.getString("PageFieldName");
																						String PageFieldId = PageFieldName.substring(5,PageFieldName.length());
																						String FieldTableName = "";
																						String FieldTableFormId = "";
																						String evaluatefieldnamespan = DBFieldName;
																						if(evaluatefieldnamespan.equals("requestid")) evaluatefieldnamespan = SystemEnv.getHtmlLabelName(648,user.getLanguage())+"ID";
																						if(evaluatefieldnamespan.equals("id")) evaluatefieldnamespan = SystemEnv.getHtmlLabelName(563,user.getLanguage())+"ID";
																						rs4.executeSql("select TableName,FormId from modeDataInputtable where id="+TableID);
																						if(rs4.next()){
																							FieldTableName = rs4.getString("TableName");
																							FieldTableFormId = Util.null2String(rs4.getString("FormId"));
																							if(!FieldTableFormId.equals("")&&FieldTableFormId.indexOf("_")>0) FieldTableFormId = FieldTableFormId.substring(0,FieldTableFormId.indexOf("_"));
																						}
																						if(datasourcename.trim().equals("")&&!evaluatefieldnamespan.equals("requestid")&&!evaluatefieldnamespan.equals("id")){
																						if(FieldTableName.equals("workflow_form")||FieldTableName.equals("workflow_formdetail")){
																							  if(FieldTableName.equals("workflow_form"))
																						        rs4.executeSql("select a.fieldlable from workflow_fieldlable a,workflow_formdict b where a.langurageid="+user.getLanguage()+" and a.fieldid=b.id and a.formid="+FieldTableFormId+" and b.fieldname='"+DBFieldName+"' and a.langurageid = "+user.getLanguage());
																						    else
																						        rs4.executeSql("select a.fieldlable from workflow_fieldlable a,workflow_formdictdetail b where a.langurageid="+user.getLanguage()+" and a.fieldid=b.id and a.formid="+FieldTableFormId+" and b.fieldname='"+DBFieldName+"' and a.langurageid = "+user.getLanguage());
																						    if(rs4.next()) evaluatefieldnamespan = Util.null2String(rs4.getString("fieldlable"));
																						}else{
																							rs4.executeSql("select id from workflow_bill where tablename='"+FieldTableName+"' or detailtablename='"+FieldTableName+"' union select billid as id from workflow_billdetailtable where tablename='"+FieldTableName+"'");
																							if(rs4.next()){
																								rs4.executeSql("select fieldlabel from workflow_billfield where billid="+rs4.getInt("id")+" and fieldname='"+DBFieldName+"'");
																								if(rs4.next()) evaluatefieldnamespan = SystemEnv.getHtmlLabelName(rs4.getInt("fieldlabel"),user.getLanguage());
																							}else{
																								rs4.executeSql("select id from Sys_tabledict where tablename='"+FieldTableName+"'");
																								if(rs4.next()){
																									rs4.executeSql("select fielddesc,fielddescen from Sys_fielddict where fieldname='"+DBFieldName+"' and tabledictid="+rs4.getInt("id"));
																									if(rs4.next()){
																										if(user.getLanguage()==7) evaluatefieldnamespan = rs4.getString("fielddesc");
																										if(user.getLanguage()==8) evaluatefieldnamespan = rs4.getString("fielddescen");
																									}
																								}
																							}
																							}
																						}
																					%>
																					<tr>
																						<td class=field><input type='checkbox' name='checkbox_EvaluateSetting' value='<%=fivethIndex%>'></td>
																						<td class=field><button class=Browser onClick='showEvaluateTableFiled(tableTable<%=index%><%=secIndex%>,<%=index%>,<%=secIndex%>,<%=fivethIndex%>)'></button><span id='evaluatefieldnamespan<%=index%><%=secIndex%><%=fivethIndex%>'><%=evaluatefieldnamespan%></span>
																							<input type=hidden id='evaluatefieldname<%=index%><%=secIndex%><%=fivethIndex%>' name='evaluatefieldname<%=index%><%=secIndex%><%=fivethIndex%>' value='<%=DBFieldName%>'>
																							<input type=hidden id='evaluatefieldtablename<%=index%><%=secIndex%><%=fivethIndex%>' name='evaluatefieldtablename<%=index%><%=secIndex%><%=fivethIndex%>' value='<%=FieldTableName%>'>
																						</td>
																						<td class=field>
																							<select id='evaluatewfField<%=index%><%=secIndex%><%=fivethIndex%>' name='evaluatewfField<%=index%><%=secIndex%><%=fivethIndex%>'>
																							<%
																							if(fieldtype==1){
																								String tempWfDetailFieldsOptions = "";
																							    rs4.executeSql("select detailtable from workflow_billfield where id="+fieldid);
																							    if(rs4.next()) tempWfDetailFieldsOptions = Util.null2String((String)detailFiledHST.get(rs4.getString("detailtable")));
																								tempWfDetailFieldsOptions = Util.StringReplace(tempWfDetailFieldsOptions,"<option value="+PageFieldId+">","<option value="+PageFieldId+" selected>");
																							%>
																							<%=tempWfDetailFieldsOptions%>
																							<%
																							}else{
																								String tempWfFieldsOptions = Util.StringReplace(MainFieldsOptions,"<option value="+PageFieldId+">","<option value="+PageFieldId+" selected>");
																							%>
																							<%=tempWfFieldsOptions%>
																							<%}%>
																							</select>
																						</td>
																					</tr>
																					<%
																					fivethIndex++;
																					}%>
																					<input type="hidden" id="evaluateTableRowsNum_<%=index%>_<%=secIndex%>" name="evaluateTableRowsNum_<%=index%>_<%=secIndex%>" value="<%=fivethIndex%>">
																				</table>
																			</td></tr>
																			</table>
																	<td>
																</tr>
																<%
																	secIndex++;
																}
																%>
																</table>
															<input type="hidden" id="triggerSettingRows_<%=index%>" name="triggerSettingRows_<%=index%>" value="<%=secIndex%>">
														<td></tr>
													</table>
												<td>
											</tr>
											<%
												index++;
											}
											%>
									</table>
								</td>
							</tr>
						</TABLE>
					</td>
				</tr>
			</table>
		</form>
	</body>
	<script type="text/javascript">
	var triggerFieldOfRowIndex = 0;
	function addRowOfFieldTrigger(){
		rowColor = getRowBg();
		ncol = LinkageTable.cols;
		oRow = LinkageTable.insertRow();
		oRow.style.height=24;
		for(j=0; j<ncol; j++){
			oCell = oRow.insertCell();
			oCell.noWrap=true;
			switch(j){
				case 0:
					oCell.style.background=rowColor;
					var oDiv = document.createElement("div");
					var sHtml = "<input type='checkbox' name='checkbox_TriggerField' value='"+triggerFieldOfRowIndex+"'>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
				case 1:
					var oDiv = document.createElement("div");
					var sHtml = "<table width=100%><COLGROUP><COL width='30%'><COL width='70%'>"+
								"<tr>"+
								"	<td><%=SystemEnv.getHtmlLabelName(21805,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22009,user.getLanguage())%></td>"+
								"	<td class=field>"+
								"		<input type=text class=Inputstyle size=20 maxLength=50 id='triggerName"+triggerFieldOfRowIndex+"' name='triggerName"+triggerFieldOfRowIndex+"' value=''>"+
								"	</td>"+
								"</tr><TR><TD class=Line colSpan=2></TD></TR>"+
								"<tr>"+
									"<td><%=SystemEnv.getHtmlLabelName(21805,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></td>"+
									"<td class=field><BUTTON class=Browser onClick='onShowTriggerField(triggerField"+triggerFieldOfRowIndex+",triggerFieldSpan"+triggerFieldOfRowIndex+",triggerFieldType"+triggerFieldOfRowIndex+","+triggerFieldOfRowIndex+")'></BUTTON><input type='hidden' value=-1 name='triggerFieldType"+triggerFieldOfRowIndex+"' id='triggerFieldType"+triggerFieldOfRowIndex+"'>"+
									"<input type='hidden' name='triggerField"+triggerFieldOfRowIndex+"' id='triggerField"+triggerFieldOfRowIndex+"'><span id='triggerFieldSpan"+triggerFieldOfRowIndex+"'><IMG src='/images/BacoError.gif' align=absMiddle><span></td>"+
								"</tr><TR><TD class=Line colSpan=2></TD></TR>"+
								"<tr>"+
									"<td><b><%=SystemEnv.getHtmlLabelName(21805,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19653,user.getLanguage())%></b></td>"+
									"<td align=right>"+
										"<a style=\"color:#262626;cursor:hand; TEXT-DECORATION:none\" onclick='addTriggerSetting("+triggerFieldOfRowIndex+")'><img src='/js/swfupload/add.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21805,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19653,user.getLanguage())%></a>"+
										"<a style=\"color:#262626;cursor:hand; TEXT-DECORATION:none\" onclick='deleteTriggerSetting("+triggerFieldOfRowIndex+")'><img src='/js/swfupload/delete.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21805,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19653,user.getLanguage())%></a>"+
									"</td>"+
								"</tr><TR><TD class=Line1 colSpan=2></TD></TR>"+
								"<tr><td colSpan=2><table id='table_"+triggerFieldOfRowIndex+"' width=100% class='viewform' cols=2><COLGROUP><COL width='2%'><COL width='98%'></table><input type='hidden' id='triggerSettingRows_"+triggerFieldOfRowIndex+"' name='triggerSettingRows_"+triggerFieldOfRowIndex+"' value='0'><td></tr>"+
								"</table>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;	
			}
		}
	}
	function deleteTriggerSetting(index){
	    var oTable=$G('table_'+index);
	    curindex=0;
	    len = oTable.rows.length;
	    var i=0;
	    //var rowsum1 = 0;
	    var delsum=0;
	    for(i=0;i <len;i++) { 
	        if(oTable.rows[i].cells[0].all[0].checked){
	            //rowsum1 += 1;
	            delsum += 1;
	        }
	    }
	    if(delsum<1){
	    	alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>");
	    }else{
	        if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
	            for(i=len-1; i >= 0;i--) {
	                if (oTable.rows[i].cells[0].all[0].name=='checkbox_TriggerSetting'){
	                    if(oTable.rows[i].cells[0].all[0].checked==true) 
	                    {
	                    	oTable.deleteRow(i);
	                        curindex--;
	                    }
	                }
	
	            }
	            //$G("rownum").value=curindex;
	        }
	
	    }
	}
	var rowindex = 0;
	function addTriggerSetting(index){
		triggerFieldType = $G("triggerFieldType"+index).value;
		triggerFieldId = $G("triggerField"+index).value;
		optionS = "";
		paraFieldsOptions = "";
		evaluateFieldsOptions = "";
		var oTable=$G('table_'+index);
		triggerSettingOfRowIndex = document.getElementById("triggerSettingRows_"+index).value;
		document.getElementById("triggerSettingRows_"+index).value = triggerSettingOfRowIndex*1 + 1;
		rowColor = getRowBg();
		ncol = oTable.cols;
		if(triggerFieldType==1){
			optionS = "<option value=0><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%></option>";
			paraFieldsOptions = "";
			evaluateFieldsOptions  = "";
			
			var ajax=ajaxinit();
			ajax.open("POST", "triggerdetailoption.jsp", true);
			ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
			ajax.send("modeId=<%=modeId%>&fieldid="+triggerFieldId);
			//获取执行状态
			ajax.onreadystatechange = function() {
			    //如果执行状态成功，那么就把返回信息写到指定的层里
			    if (ajax.readyState == 4 && ajax.status == 200) {
			        try{
			            paraFieldsOptions=ajax.responseText;
			            paraFieldsOptions=paraFieldsOptions.substring(paraFieldsOptions.indexOf("<"),paraFieldsOptions.length);
			            evaluateFieldsOptions=paraFieldsOptions;
			            
			
			            oRow = oTable.insertRow();
			            oRow.style.height=24;
			            for(j=0; j<ncol; j++){
			            	oCell = oRow.insertCell();
			            	oCell.noWrap=true;
			            	switch(j){
			            		case 0:
			            			oCell.style.background=rowColor;
			            			var oDiv = document.createElement("div");
			            			var sHtml = "<input type='checkbox' name='checkbox_TriggerSetting' value='"+triggerSettingOfRowIndex+"'>";
			            			oCell.innerHTML = sHtml;
			            			//oCell.appendChild(oDiv);
			            			break;
			            		case 1:
			            			var oDiv = document.createElement("div");
			            			var sHtml = "<table width=100%><COLGROUP><COL width='30%'><COL width='70%'>"+
			            									"<tr>"+
			            									"<td><%=SystemEnv.getHtmlLabelName(21840,user.getLanguage())%></td>"+
			            									"<td class=field colSpan=2><select id='tabletype"+index+triggerSettingOfRowIndex+"' name='tabletype"+index+triggerSettingOfRowIndex+"'>"+
			            									optionS+
			            									"</select><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%>：<select id='datasource"+index+triggerSettingOfRowIndex+"' name='datasource"+index+triggerSettingOfRowIndex+"' onchange='changedatasource(this,"+index+","+triggerSettingOfRowIndex+")'>"+
											                "<option value=''></option><% for(int l=0;l<pointArrayList.size();l++){%><option value='<%=pointArrayList.get(l)%>'><%=pointArrayList.get(l)%></option><%}%></select>"+
											                "</td></tr><TR><TD class=Line colSpan=3></TD></TR>"+
			            									"<tr>"+
			            									"<td valign=top><%=SystemEnv.getHtmlLabelName(19422,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15190,user.getLanguage())%></td>"+
			            									"<td><table id='tableTable"+index+triggerSettingOfRowIndex+"' width=100% cols=4><COL width='25%'><COL width='25%'><COL width='10%'><COL width='10%'><COL width='30%'><tr>"+
			            									"<td class=field style='display:'><BUTTON class=Browser onClick='onShowTable(tablename"+index+triggerSettingOfRowIndex+"1,tablenamespan"+index+triggerSettingOfRowIndex+"1,formid"+index+triggerSettingOfRowIndex+"1)'></BUTTON>"+
			            									"<span id='tablenamespan"+index+triggerSettingOfRowIndex+"1'></span><input type=hidden id='formid"+index+triggerSettingOfRowIndex+"1' name='formid"+index+triggerSettingOfRowIndex+"1'></td>"+
			            									"<td class=field><input type=text class=Inputstyle size=10 id='tablename"+index+triggerSettingOfRowIndex+"1' name='tablename"+index+triggerSettingOfRowIndex+"1'></td>"+
			            									"<td><%=SystemEnv.getHtmlLabelName(475,user.getLanguage())%></td>"+
			            									"<td class=field><input type=text class=Inputstyle size=6 id='tablebyname"+index+triggerSettingOfRowIndex+"1' name='tablebyname"+index+triggerSettingOfRowIndex+"1'></td>"+
			            									"</tr><input type='hidden' id='tableTableRowsNum_"+index+"_"+triggerSettingOfRowIndex+"' name='tableTableRowsNum_"+index+"_"+triggerSettingOfRowIndex+"' value='2'></table></td>"+
			            									"<td class=field valign=top nowrap>"+
			            									"<a style=\"color:#262626;cursor:hand; TEXT-DECORATION:none\" onclick='addtable(tableTable"+index+triggerSettingOfRowIndex+","+index+","+triggerSettingOfRowIndex+")'><img src='/js/swfupload/add.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>"+
			            									"</td>"+
			            									"</tr><TR><TD class=Line colSpan=3></TD></TR>"+
			            									"<tr>"+
			            									"<td valign=top><%=SystemEnv.getHtmlLabelName(21841,user.getLanguage())%></td>"+
			            									"<td class=field colSpan=2><textarea class=Inputstyle id='tableralations"+index+triggerSettingOfRowIndex+"' name='tableralations"+index+triggerSettingOfRowIndex+"' cols=68 rows=4></textarea><br><font color=red><%=SystemEnv.getHtmlLabelName(21842,user.getLanguage())%>a.id=b.id and a.wfid=b.wfid</font></td>"+
			            									"</tr><TR><TD class=Line colSpan=3></TD></TR>"+
			            									"<tr>"+
			            									"<td><b><%=SystemEnv.getHtmlLabelName(21843,user.getLanguage())%></b></td>"+
			            									"<td align=right colSpan=4>"+
			            									"<a style=\"color:#262626;cursor:hand; TEXT-DECORATION:none\" onclick='addParameterTable(parameterTable"+index+triggerSettingOfRowIndex+","+index+","+triggerSettingOfRowIndex+")'><img src='/js/swfupload/add.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21843,user.getLanguage())%></a>"+
			            									"<a style=\"color:#262626;cursor:hand; TEXT-DECORATION:none\" onclick='deleteParameterTable(parameterTable"+index+triggerSettingOfRowIndex+")'><img src='/js/swfupload/delete.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21843,user.getLanguage())%></a>"+
			            									"</td>"+
			            									"</tr><TR><TD class=Line1 colSpan=5></TD></TR>"+
			            									"<tr><td colSpan=5>"+
			            									"<table id='parameterTable"+index+triggerSettingOfRowIndex+"' width=100% class='liststyle' cols=3><COLGROUP><COL width='2%'><COL width='49%'><COL width='49%'>"+
			            									"<tr class=Header>"+
			            									"<td></td>"+
			            									"<td><%=SystemEnv.getHtmlLabelName(21844,user.getLanguage())%></td>"+
			            									"<td><%=SystemEnv.getHtmlLabelName(28605,user.getLanguage())%></td>"+
			            									"</tr>"+
			            									"<tr>"+
			            									"<td class=field><input type='checkbox' name='checkbox_ParameterSetting' value=1></td>"+
			            									"<td class=field><button class=Browser onClick='showParaTableFiled(tableTable"+index+triggerSettingOfRowIndex+","+index+","+triggerSettingOfRowIndex+",1)'></button><span id='parafieldnamespan"+index+triggerSettingOfRowIndex+"1'></span><input type=hidden id='parafieldname"+index+triggerSettingOfRowIndex+"1' name='parafieldname"+index+triggerSettingOfRowIndex+"1'><input type=hidden id='parafieldtablename"+index+triggerSettingOfRowIndex+"1' name='parafieldtablename"+index+triggerSettingOfRowIndex+"1'></td>"+
			            									"<td class=field><select id='parawfField"+index+triggerSettingOfRowIndex+"1' name='parawfField"+index+triggerSettingOfRowIndex+"1'>"+paraFieldsOptions+"</select></td>"+
			            									"</tr><input type='hidden' id='parameterTableRowsNum_"+index+"_"+triggerSettingOfRowIndex+"' name='parameterTableRowsNum_"+index+"_"+triggerSettingOfRowIndex+"' value='2'>"+
			            									"</table>"+
			            									"</td></tr>"+
			            									"<tr>"+
			            									"<td><b><%=SystemEnv.getHtmlLabelName(21845,user.getLanguage())%></b></td>"+
			            									"<td align=right colSpan=4>"+
			            									"<a style=\"color:#262626;cursor:hand; TEXT-DECORATION:none\" onclick='addEvaluateTable(evaluateTable"+index+triggerSettingOfRowIndex+","+index+","+triggerSettingOfRowIndex+")'><img src='/js/swfupload/add.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21846,user.getLanguage())%></a>"+
			            									"<a style=\"color:#262626;cursor:hand; TEXT-DECORATION:none\" onclick='deleteEvaluateTable(evaluateTable"+index+triggerSettingOfRowIndex+")'><img src='/js/swfupload/delete.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21846,user.getLanguage())%></a>"+
			            									"</td>"+
			            									"</tr><TR><TD class=Line1 colSpan=5></TD></TR>"+
			            									"<tr><td colSpan=5>"+
			            									"<table id='evaluateTable"+index+triggerSettingOfRowIndex+"' width=100% class='liststyle' cols=3><COLGROUP><COL width='2%'><COL width='49%'><COL width='49%'>"+
			            									"<tr class=Header>"+
			            									"<td></td>"+
			            									"<td><%=SystemEnv.getHtmlLabelName(21847,user.getLanguage())%></td>"+
			            									"<td><%=SystemEnv.getHtmlLabelName(28605,user.getLanguage())%></td>"+
			            									"</tr>"+
			            									"<tr>"+
			            									"<td class=field><input type='checkbox' name='checkbox_EvaluateSetting' value=1></td>"+
			            									"<td class=field><button class=Browser onClick='showEvaluateTableFiled(tableTable"+index+triggerSettingOfRowIndex+","+index+","+triggerSettingOfRowIndex+",1)'></button><span id='evaluatefieldnamespan"+index+triggerSettingOfRowIndex+"1'></span><input type=hidden id='evaluatefieldname"+index+triggerSettingOfRowIndex+"1' name='evaluatefieldname"+index+triggerSettingOfRowIndex+"1'><input type=hidden id='evaluatefieldtablename"+index+triggerSettingOfRowIndex+"1' name='evaluatefieldtablename"+index+triggerSettingOfRowIndex+"1'></td>"+
			            									"<td class=field><select id='evaluatewfField"+index+triggerSettingOfRowIndex+"1' name='evaluatewfField"+index+triggerSettingOfRowIndex+"1'>"+evaluateFieldsOptions+"</select></td>"+
			            									"</tr><input type='hidden' id='evaluateTableRowsNum_"+index+"_"+triggerSettingOfRowIndex+"' name='evaluateTableRowsNum_"+index+"_"+triggerSettingOfRowIndex+"' value='2'>"+
			            									"</table>"+
			            									"</td></tr>"+
			            									"</table>";
			            			oDiv.innerHTML = sHtml;
			            			oCell.appendChild(oDiv);
			            			break;	
			            		}
			            	}
			            }catch(e){
			        }
			    }
			}
		}
		else {
		if(triggerFieldType==0){
			optionS = "<option value=1><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></option>";
			paraFieldsOptions = "<%=MainFieldsOptions%>";
			evaluateFieldsOptions = "<%=MainFieldsOptions%>";
		}else{
			optionS = "<option value=1><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></option><option value=0><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%></option>";
			paraFieldsOptions = "<%=FieldsOptions%>";
			evaluateFieldsOptions = "<%=FieldsOptions%>";
		}
		oRow = oTable.insertRow();
		oRow.style.height=24;
		for(j=0; j<ncol; j++){
			oCell = oRow.insertCell();
			oCell.noWrap=true;
			switch(j){
				case 0:
					oCell.style.background=rowColor;
					var oDiv = document.createElement("div");
					var sHtml = "<input type='checkbox' name='checkbox_TriggerSetting' value='"+triggerSettingOfRowIndex+"'>";
					oCell.innerHTML = sHtml;
					//oCell.appendChild(oDiv);
					break;
				case 1:
					var oDiv = document.createElement("div");
					var sHtml = "<table width=100%><COLGROUP><COL width='30%'><COL width='70%'>"+
											"<tr>"+
												"<td><%=SystemEnv.getHtmlLabelName(21840,user.getLanguage())%></td>"+
												"<td class=field colSpan=2><select id='tabletype"+index+triggerSettingOfRowIndex+"' name='tabletype"+index+triggerSettingOfRowIndex+"'>"+
													optionS+
											"</select><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%>：<select id='datasource"+index+triggerSettingOfRowIndex+"' name='datasource"+index+triggerSettingOfRowIndex+"' onchange='changedatasource(this,"+index+","+triggerSettingOfRowIndex+")'>"+
											"<option value=''></option><% for(int l=0;l<pointArrayList.size();l++){%><option value='<%=pointArrayList.get(l)%>'><%=pointArrayList.get(l)%></option><%}%></select>"+
											"</td></tr><TR><TD class=Line colSpan=3></TD></TR>"+
											"<tr>"+
												"<td valign=top><%=SystemEnv.getHtmlLabelName(19422,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15190,user.getLanguage())%></td>"+
												"<td><table id='tableTable"+index+triggerSettingOfRowIndex+"' width=100% cols=4><COL width='25%'><COL width='25%'><COL width='10%'><COL width='10%'><COL width='30%'><tr>"+
												"<td class=field style='display:'><BUTTON class=Browser onClick='onShowTable(tablename"+index+triggerSettingOfRowIndex+"1,tablenamespan"+index+triggerSettingOfRowIndex+"1,formid"+index+triggerSettingOfRowIndex+"1)'></BUTTON>"+
												"<span id='tablenamespan"+index+triggerSettingOfRowIndex+"1'></span><input type=hidden id='formid"+index+triggerSettingOfRowIndex+"1' name='formid"+index+triggerSettingOfRowIndex+"1'></td>"+
												"<td class=field><input type=text class=Inputstyle size=10 id='tablename"+index+triggerSettingOfRowIndex+"1' name='tablename"+index+triggerSettingOfRowIndex+"1'></td>"+
												"<td><%=SystemEnv.getHtmlLabelName(475,user.getLanguage())%></td>"+
												"<td class=field><input type=text class=Inputstyle size=6 id='tablebyname"+index+triggerSettingOfRowIndex+"1' name='tablebyname"+index+triggerSettingOfRowIndex+"1'></td>"+
												"</tr><input type='hidden' id='tableTableRowsNum_"+index+"_"+triggerSettingOfRowIndex+"' name='tableTableRowsNum_"+index+"_"+triggerSettingOfRowIndex+"' value='2'></table></td>"+
												"<td class=field valign=top nowrap>"+
													"<a style=\"color:#262626;cursor:hand; TEXT-DECORATION:none\" onclick='addtable(tableTable"+index+triggerSettingOfRowIndex+","+index+","+triggerSettingOfRowIndex+")'><img src='/js/swfupload/add.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>"+
												"</td>"+
											"</tr><TR><TD class=Line colSpan=3></TD></TR>"+
											"<tr>"+
												"<td valign=top><%=SystemEnv.getHtmlLabelName(21841,user.getLanguage())%></td>"+
												"<td class=field colSpan=2><textarea class=Inputstyle id='tableralations"+index+triggerSettingOfRowIndex+"' name='tableralations"+index+triggerSettingOfRowIndex+"' cols=68 rows=4></textarea><br><font color=red><%=SystemEnv.getHtmlLabelName(21842,user.getLanguage())%>a.id=b.id and a.wfid=b.wfid</font></td>"+
											"</tr><TR><TD class=Line colSpan=3></TD></TR>"+
											"<tr>"+
												"<td><b><%=SystemEnv.getHtmlLabelName(21843,user.getLanguage())%></b></td>"+
												"<td align=right colSpan=4>"+
													"<a style=\"color:#262626;cursor:hand; TEXT-DECORATION:none\" onclick='addParameterTable(parameterTable"+index+triggerSettingOfRowIndex+","+index+","+triggerSettingOfRowIndex+")'><img src='/js/swfupload/add.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21843,user.getLanguage())%></a>"+
													"<a style=\"color:#262626;cursor:hand; TEXT-DECORATION:none\" onclick='deleteParameterTable(parameterTable"+index+triggerSettingOfRowIndex+")'><img src='/js/swfupload/delete.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21843,user.getLanguage())%></a>"+
												"</td>"+
											"</tr><TR><TD class=Line1 colSpan=5></TD></TR>"+
											"<tr><td colSpan=5>"+
												"<table id='parameterTable"+index+triggerSettingOfRowIndex+"' width=100% class='liststyle' cols=3><COLGROUP><COL width='2%'><COL width='49%'><COL width='49%'>"+
													"<tr class=Header>"+
														"<td></td>"+
														"<td><%=SystemEnv.getHtmlLabelName(21844,user.getLanguage())%></td>"+
														"<td><%=SystemEnv.getHtmlLabelName(28605,user.getLanguage())%></td>"+
													"</tr>"+
													"<tr>"+
														"<td class=field><input type='checkbox' name='checkbox_ParameterSetting' value=1></td>"+
														"<td class=field><button class=Browser onClick='showParaTableFiled(tableTable"+index+triggerSettingOfRowIndex+","+index+","+triggerSettingOfRowIndex+",1)'></button><span id='parafieldnamespan"+index+triggerSettingOfRowIndex+"1'></span><input type=hidden id='parafieldname"+index+triggerSettingOfRowIndex+"1' name='parafieldname"+index+triggerSettingOfRowIndex+"1'><input type=hidden id='parafieldtablename"+index+triggerSettingOfRowIndex+"1' name='parafieldtablename"+index+triggerSettingOfRowIndex+"1'></td>"+
														"<td class=field><select id='parawfField"+index+triggerSettingOfRowIndex+"1' name='parawfField"+index+triggerSettingOfRowIndex+"1'>"+paraFieldsOptions+"</select></td>"+
													"</tr><input type='hidden' id='parameterTableRowsNum_"+index+"_"+triggerSettingOfRowIndex+"' name='parameterTableRowsNum_"+index+"_"+triggerSettingOfRowIndex+"' value='2'>"+
												"</table>"+
											"</td></tr>"+
											"<tr>"+
												"<td><b><%=SystemEnv.getHtmlLabelName(21845,user.getLanguage())%></b></td>"+
												"<td align=right colSpan=4>"+
													"<a style=\"color:#262626;cursor:hand; TEXT-DECORATION:none\" onclick='addEvaluateTable(evaluateTable"+index+triggerSettingOfRowIndex+","+index+","+triggerSettingOfRowIndex+")'><img src='/js/swfupload/add.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21846,user.getLanguage())%></a>"+
													"<a style=\"color:#262626;cursor:hand; TEXT-DECORATION:none\" onclick='deleteEvaluateTable(evaluateTable"+index+triggerSettingOfRowIndex+")'><img src='/js/swfupload/delete.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21846,user.getLanguage())%></a>"+
												"</td>"+
											"</tr><TR><TD class=Line1 colSpan=5></TD></TR>"+
											"<tr><td colSpan=5>"+
												"<table id='evaluateTable"+index+triggerSettingOfRowIndex+"' width=100% class='liststyle' cols=3><COLGROUP><COL width='2%'><COL width='49%'><COL width='49%'>"+
													"<tr class=Header>"+
														"<td></td>"+
														"<td><%=SystemEnv.getHtmlLabelName(21847,user.getLanguage())%></td>"+
														"<td><%=SystemEnv.getHtmlLabelName(28605,user.getLanguage())%></td>"+
													"</tr>"+
													"<tr>"+
														"<td class=field><input type='checkbox' name='checkbox_EvaluateSetting' value=1></td>"+
														"<td class=field><button class=Browser onClick='showEvaluateTableFiled(tableTable"+index+triggerSettingOfRowIndex+","+index+","+triggerSettingOfRowIndex+",1)'></button><span id='evaluatefieldnamespan"+index+triggerSettingOfRowIndex+"1'></span><input type=hidden id='evaluatefieldname"+index+triggerSettingOfRowIndex+"1' name='evaluatefieldname"+index+triggerSettingOfRowIndex+"1'><input type=hidden id='evaluatefieldtablename"+index+triggerSettingOfRowIndex+"1' name='evaluatefieldtablename"+index+triggerSettingOfRowIndex+"1'></td>"+
														"<td class=field><select id='evaluatewfField"+index+triggerSettingOfRowIndex+"1' name='evaluatewfField"+index+triggerSettingOfRowIndex+"1'>"+evaluateFieldsOptions+"</select></td>"+
													"</tr><input type='hidden' id='evaluateTableRowsNum_"+index+"_"+triggerSettingOfRowIndex+"' name='evaluateTableRowsNum_"+index+"_"+triggerSettingOfRowIndex+"' value='2'>"+
												"</table>"+
											"</td></tr>"+
											"</table>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;	
			}
		}
		}
		rowindex = rowindex*1 +1;
	}
	function changedatasource(obj,tindex,tindex1){
	    var oTable=document.getElementById("tableTable"+tindex+tindex1);
	    var rows = oTable.rows.length ;
        for(i=0; i < rows;i++){
	        if(obj.value==""){
	        	oTable.rows(i).cells(0).style.display='';
	        }else{
	        	oTable.rows(i).cells(0).style.display='none';
	        }
        }
	}
	function addtable(oTable,firstindex,secindex){
		rowindex = document.getElementById("tableTableRowsNum_"+firstindex+"_"+secindex).value*1;
		document.getElementById("tableTableRowsNum_"+firstindex+"_"+secindex).value = rowindex*1 + 1;
		datasource=document.getElementById("datasource"+firstindex+secindex).value;
    	rowColor = getRowBg();
		ncol = oTable.cols;
		oRow = oTable.insertRow();
		oRow.style.height=24;
		for(j=0; j<ncol; j++){
			oCell = oRow.insertCell();
			oCell.noWrap=true;
			oCell.style.background=rowColor;
			switch(j){
				case 0:
				    if(datasource==""){
                    	oCell.style.display='';
                    }else{
                    	oCell.style.display='none';
                    }
					var oDiv = document.createElement("div");
					var sHtml = "<BUTTON class=Browser onClick='onShowTable(tablename"+firstindex+secindex+rowindex+",tablenamespan"+firstindex+secindex+rowindex+",formid"+firstindex+secindex+rowindex+")'></BUTTON>"+
											"<span id=tablenamespan"+firstindex+secindex+rowindex+"></span><input type=hidden id='formid"+firstindex+secindex+rowindex+"' name='formid"+firstindex+secindex+rowindex+"'>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
				case 1:
					var oDiv = document.createElement("div");
					var sHtml = "<input type=text class=Inputstyle size=10 id=tablename"+firstindex+secindex+rowindex+" name=tablename"+firstindex+secindex+rowindex+">";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
				case 2:
					var oDiv = document.createElement("div");
					var sHtml = "<%=SystemEnv.getHtmlLabelName(475,user.getLanguage())%>";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
				case 3:
					var oDiv = document.createElement("div");
					var sHtml = "<input type=text class=Inputstyle size=6 id=tablebyname"+firstindex+secindex+rowindex+" name=tablebyname"+firstindex+secindex+rowindex+">";
					oDiv.innerHTML = sHtml;
					oCell.appendChild(oDiv);
					break;
			}
		}
	}
	function deleteParameterTable(oTable){
	    curindex=0;
	    len = oTable.rows.length;
	    var i=0;
	    var rowsum1 = 0;
	    var delsum=0;
	    for(i=len-1; i >= 1;i--) {
	        if (oTable.rows[i].cells[0].all[0].checked){
	            //rowsum1 += 1;
	            delsum += 1;
	        }
	    }
	    if(delsum<1){
	    	alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>");
	    }else{
	        if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
	            for(i=len-1; i >= 1;i--) {
	                if (oTable.rows[i].cells[0].all[0].name=='checkbox_ParameterSetting'){
	                    if(oTable.rows[i].cells[0].all[0].checked==true) {
	                        //$G('checkfield').value = ($G('checkfield').value).replace("nodeid_"+document.frmlinkageviewattr.elements[i].value+",","");
	                        //$G('checkfield').value = ($G('checkfield').value).replace("selectfieldid_"+document.frmlinkageviewattr.elements[i].value+",","");
	                        //$G('checkfield').value = ($G('checkfield').value).replace("selectfieldvalue_"+document.frmlinkageviewattr.elements[i].value+",","");
	                        //$G('checkfield').value = ($G('checkfield').value).replace("changefieldids_"+document.frmlinkageviewattr.elements[i].value+",","");
	                        oTable.deleteRow(i);
	                        curindex--;
	                    }
	                    //rowsum1 -=1;
	                }
	
	            }
	            //$G("rownum").value=curindex;
	        }
	
	    }
	}
	function addParameterTable(oTable,firstindex,secindex){
		triggerFieldType = $G("triggerFieldType"+firstindex).value;
		triggerFieldId = $G("triggerField"+firstindex).value;
		
		obj = "tableTable"+firstindex+secindex;
		
		rowindex = $G("parameterTableRowsNum_"+firstindex+"_"+secindex).value*1;
		$G("parameterTableRowsNum_"+firstindex+"_"+secindex).value = rowindex*1 + 1;
		rowColor = getRowBg();
		ncol = oTable.cols;
			
		paraFieldsOptions = "";
		if(triggerFieldType==0){
			paraFieldsOptions = "<%=MainFieldsOptions%>";
		
			oRow = oTable.insertRow();
			oRow.style.height=24;
			for(j=0; j<ncol; j++){
				oCell = oRow.insertCell();
				oCell.noWrap=true;
				oCell.style.background=rowColor;
				switch(j){
					case 0:
						var oDiv = document.createElement("div");
						var sHtml = "<input type='checkbox' name='checkbox_ParameterSetting' value='"+rowindex+"'>";
						oCell.innerHTML = sHtml;
						//oCell.appendChild(oDiv);
						break;
					case 1:
						var oDiv = document.createElement("div");
						var sHtml = "<button class=Browser onClick='showParaTableFiled("+obj+","+firstindex+","+secindex+","+rowindex+")'></button>"+
												"<span id='parafieldnamespan"+firstindex+secindex+rowindex+"'></span><input type=hidden id='parafieldname"+firstindex+secindex+rowindex+"' name='parafieldname"+firstindex+secindex+rowindex+"'><input type=hidden id='parafieldtablename"+firstindex+secindex+rowindex+"' name='parafieldtablename"+firstindex+secindex+rowindex+"'>";
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
					case 2:
						var oDiv = document.createElement("div");
						var sHtml = "<select id='parawfField"+firstindex+secindex+rowindex+"' name='parawfField"+firstindex+secindex+rowindex+"'>"+
												paraFieldsOptions+
												"</select>";
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
				}
			}
		}else{
			var ajax=ajaxinit();
			ajax.open("POST", "triggerdetailoption.jsp", true);
			ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
			ajax.send("modeId=<%=modeId%>&fieldid="+triggerFieldId);
			//获取执行状态
			ajax.onreadystatechange = function() {
			    //如果执行状态成功，那么就把返回信息写到指定的层里
			    if (ajax.readyState == 4 && ajax.status == 200) {
			        try{
			            paraFieldsOptions=ajax.responseText;
			            paraFieldsOptions=paraFieldsOptions.substring(paraFieldsOptions.indexOf("<"),paraFieldsOptions.length);
			            
			            oRow = oTable.insertRow();
			            oRow.style.height=24;
			            for(j=0; j<ncol; j++){
			            	oCell = oRow.insertCell();
			            	oCell.noWrap=true;
			            	oCell.style.background=rowColor;
			            	switch(j){
			            		case 0:
			            			var oDiv = document.createElement("div");
			            			var sHtml = "<input type='checkbox' name='checkbox_ParameterSetting' value='"+rowindex+"'>";
			            			oCell.innerHTML = sHtml;
			            			//oCell.appendChild(oDiv);
			            			break;
			            		case 1:
			            			var oDiv = document.createElement("div");
			            			var sHtml = "<button class=Browser onClick='showParaTableFiled("+obj+","+firstindex+","+secindex+","+rowindex+")'></button>"+
			            									"<span id='parafieldnamespan"+firstindex+secindex+rowindex+"'></span><input type=hidden id='parafieldname"+firstindex+secindex+rowindex+"' name='parafieldname"+firstindex+secindex+rowindex+"'><input type=hidden id='parafieldtablename"+firstindex+secindex+rowindex+"' name='parafieldtablename"+firstindex+secindex+rowindex+"'>";
			            			oDiv.innerHTML = sHtml;
			            			oCell.appendChild(oDiv);
			            			break;
			            		case 2:
			            			var oDiv = document.createElement("div");
			            			var sHtml = "<select id='parawfField"+firstindex+secindex+rowindex+"' name='parawfField"+firstindex+secindex+rowindex+"'>"+
			            									paraFieldsOptions+
			            									"</select>";
			            			oDiv.innerHTML = sHtml;
			            			oCell.appendChild(oDiv);
			            			break;
			            	}
			            }
			        }catch(e){
			        }
			    }
			}
		}
	}
	function deleteEvaluateTable(oTable){
	    curindex=0;
	    len = oTable.rows.length;
	    var i=0;
	    var rowsum1 = 0;
	    var delsum=0;
	    for(i=len-1; i >= 1;i--) {
	        if (oTable.rows[i].cells[0].all[0].checked){
	            //rowsum1 += 1;
	            delsum+=1;
	        }
	    }
	    if(delsum<1){
	    	alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>");
	    }else{
	        if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
	            for(i=len-1; i >= 1;i--) {
	                if (oTable.rows[i].cells[0].all[0].name=='checkbox_EvaluateSetting'){
	                    if(oTable.rows[i].cells[0].all[0].checked==true) {
	                        //$G('checkfield').value = ($G('checkfield').value).replace("nodeid_"+document.frmlinkageviewattr.elements[i].value+",","");
	                        //$G('checkfield').value = ($G('checkfield').value).replace("selectfieldid_"+document.frmlinkageviewattr.elements[i].value+",","");
	                        //$G('checkfield').value = ($G('checkfield').value).replace("selectfieldvalue_"+document.frmlinkageviewattr.elements[i].value+",","");
	                        //$G('checkfield').value = ($G('checkfield').value).replace("changefieldids_"+document.frmlinkageviewattr.elements[i].value+",","");
	                        oTable.deleteRow(i);
	                        curindex--;
	                    }
	                    //rowsum1 -=1;
	                }
	
	            }
	            //$G("rownum").value=curindex;
	        }
	
	    }
	}
	function addEvaluateTable(oTable,firstindex,secindex){	
		triggerFieldType = $G("triggerFieldType"+firstindex).value;
		triggerFieldId = $G("triggerField"+firstindex).value;
		optionS = "";
		paraFieldsOptions = "";
		evaluateFieldsOptions = "";
		
		obj = "tableTable"+firstindex+secindex;
		
		rowindex = $G("evaluateTableRowsNum_"+firstindex+"_"+secindex).value*1;
		$G("evaluateTableRowsNum_"+firstindex+"_"+secindex).value = rowindex*1 + 1;
    	rowColor = getRowBg();
		ncol = oTable.cols;
		if(triggerFieldType==0){
			evaluateFieldsOptions  = "<%=MainFieldsOptions%>";
		
			oRow = oTable.insertRow();
			oRow.style.height=24;
			for(j=0; j<ncol; j++){
				oCell = oRow.insertCell();
				oCell.noWrap=true;
				oCell.style.background=rowColor;
				switch(j){
					case 0:
						var oDiv = document.createElement("div");
						var sHtml = "<input type='checkbox' name='checkbox_EvaluateSetting' value='"+rowindex+"'>";
						oCell.innerHTML = sHtml;
						//oCell.appendChild(oDiv);
						break;
					case 1:
						var oDiv = document.createElement("div");
						var sHtml = "<button class=Browser onClick='showEvaluateTableFiled("+obj+","+firstindex+","+secindex+","+rowindex+")'></button>"+
												"<span id='evaluatefieldnamespan"+firstindex+secindex+rowindex+"'></span><input type=hidden id='evaluatefieldname"+firstindex+secindex+rowindex+"' name='evaluatefieldname"+firstindex+secindex+rowindex+"'><input type=hidden id='evaluatefieldtablename"+firstindex+secindex+rowindex+"' name='evaluatefieldtablename"+firstindex+secindex+rowindex+"'>";
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
					case 2:
						var oDiv = document.createElement("div");
						var sHtml = "<select id='evaluatewfField"+firstindex+secindex+rowindex+"' name='evaluatewfField"+firstindex+secindex+rowindex+"'>"+
												evaluateFieldsOptions+
												"</select>";
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
				}
			}
		}else{
			var ajax=ajaxinit();
			ajax.open("POST", "triggerdetailoption.jsp", true);
			ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
			ajax.send("modeId=<%=modeId%>&fieldid="+triggerFieldId);
			//获取执行状态
			ajax.onreadystatechange = function() {
			    //如果执行状态成功，那么就把返回信息写到指定的层里
			    if (ajax.readyState == 4 && ajax.status == 200) {
			        try{
			            evaluateFieldsOptions=ajax.responseText;
			            evaluateFieldsOptions=evaluateFieldsOptions.substring(evaluateFieldsOptions.indexOf("<"),evaluateFieldsOptions.length);
			            
			            oRow = oTable.insertRow();
			            oRow.style.height=24;
			            for(j=0; j<ncol; j++){
			            	oCell = oRow.insertCell();
			            	oCell.noWrap=true;
			            	oCell.style.background=rowColor;
			            	switch(j){
			            		case 0:
			            			var oDiv = document.createElement("div");
			            			var sHtml = "<input type='checkbox' name='checkbox_EvaluateSetting' value='"+rowindex+"'>";
			            			oCell.innerHTML = sHtml;
			            			//oCell.appendChild(oDiv);
			            			break;
			            		case 1:
			            			var oDiv = document.createElement("div");
			            			var sHtml = "<button class=Browser onClick='showEvaluateTableFiled("+obj+","+firstindex+","+secindex+","+rowindex+")'></button>"+
			            									"<span id='evaluatefieldnamespan"+firstindex+secindex+rowindex+"'></span><input type=hidden id='evaluatefieldname"+firstindex+secindex+rowindex+"' name='evaluatefieldname"+firstindex+secindex+rowindex+"'><input type=hidden id='evaluatefieldtablename"+firstindex+secindex+rowindex+"' name='evaluatefieldtablename"+firstindex+secindex+rowindex+"'>";
			            			oDiv.innerHTML = sHtml;
			            			oCell.appendChild(oDiv);
			            			break;
			            		case 2:
			            			var oDiv = document.createElement("div");
			            			var sHtml = "<select id='evaluatewfField"+firstindex+secindex+rowindex+"' name='evaluatewfField"+firstindex+secindex+rowindex+"'>"+
			            									evaluateFieldsOptions+
			            									"</select>";
			            			oDiv.innerHTML = sHtml;
			            			oCell.appendChild(oDiv);
			            			break;
			            	}
			            }
			    		}catch(e){}
			    }
			}
		}
	}
	function encode(str){
	    return escape(str);
	}
	
	function onShowTriggerField(inputname,spanname,fieldtype,rowindex){
		datas = showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/setup/fieldBrowser.jsp?modeId=<%=modeId%>");
		if (datas != undefined && datas != null) {
			if(datas.id != ''){
				temprows = $G("table_"+rowindex).rows.length;
				for(var i = 0;i < temprows; i++){
					temprows1 = $G("tabletype"+rowindex+i).options.length;
					for(var j=0;j<temprows1;j++){
						$G("tabletype"+rowindex+i).options.remove(0);
					}
					temprows3 = $G("parameterTable"+rowindex+i).rows.length;
					for(var k=1;k<temprows3;k++){
						temprows4 = $G("parawfField"+rowindex+i+k).options.length;
						for(var h=0 ;h<temprows4 ;h++){
							$G("parawfField"+rowindex+i+k).options.remove(0)
						}
					}
					temprows5 = $G("evaluateTable"+rowindex+i).rows.length;
					for(var l=1;l<temprows5;l++){
						temprows6 = $G("evaluatewfField"+rowindex+i+l).options.length;
						for(var m=0;m<temprows6;m++){
							$G("evaluatewfField"+rowindex+i+l).options.remove(0);
						}
					}
				}
				inputname.value = datas.id;
				spanname.innerHTML = datas.name;
				fieldtype.value = datas.fieldtype;
				options = datas.options;
				options = options.replaceAll(",","");
				for(var m=0 ;m< temprows;m++){
					var sel = $G("tabletype"+rowindex+m);
					var newOption = document.createElement("option");
					if(datas.fieldtype == 0){
						newOption.setAttribute("value", 0);
						newOption.appendChild(document.createTextNode("<%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%>"));
						sel.appendChild(newOption);
					}else{
						newOption.setAttribute("value", 1);
						newOption.appendChild(document.createTextNode("<%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%>"));
						sel.appendChild(newOption);
					}
					temprows7 = $G("parameterTable"+rowindex+m).rows.length;
					for(var n=1;n<temprows7;n++){
						$G("parawfField"+rowindex+m+n).outerHTML = "<select id='parawfField"+rowindex+m+n+"' name='parawfField"+rowindex+m+n+"'>"+options+"</select>"
					}
					temprows8 = $G("evaluateTable"+rowindex+m).rows.length;
					for(var n=1;n<temprows8;n++){
						$G("evaluatewfField"+rowindex+m+n).outerHTML = "<select id='evaluatewfField"+rowindex+m+n+"' name='evaluatewfField"+rowindex+m+n+"'>"+options+"</select>"
					}
				}
			}else{
				inputname.value = "";
				spanname.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>";
				fieldtype.value = "";
			}
		}
	}
	String.prototype.replaceAll = function(s1,s2) { 
	    return this.replace(new RegExp(s1,"gm"),s2); 
	}

	function onShowTable(inputname,spanname,hiddenname){
		datas = showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/setup/triggerTableBrowser.jsp?modeId=<%=modeId%>")
		if (datas != undefined && datas != null) {
			if(datas.id != ''){
				inputname.value = datas.id;
				spanname.innerHTML = datas.name;
				hiddenname.value = datas.other1;
			}else{
				inputname.value = "";
				spanname.innerHTML = "";
				hiddenname.value = "";
			}
		}
	}
	
	function showParaTableFiled(obj,firstindex,secindex,rowindex){
		rows = obj.rows.length;
		tablenames = "";
		for(var s=1;s<=rows;s++){
			tablename = "tablename"+firstindex+secindex+s;
			formid = "formid"+firstindex+secindex+s;
			tablenames = tablenames + $G(formid).value + ":"+ $G(tablename).value + ","
		}
		datasourcename="datasource"+firstindex+secindex;
		urls="/formmode/setup/triggerTableFieldsBrowser.jsp?datasourceid="+$G(datasourcename).value+"&tablenames="+tablenames;
		urls="/systeminfo/BrowserMain.jsp?url="+encode(urls);
		datas = window.showModalDialog(urls);
		if (datas != undefined && datas != null) {
			if(datas.id != ''){
				$G("parafieldname"+firstindex+secindex+rowindex).value = wuiUtil.getJsonValueByIndex(datas, 0);
				$G("parafieldnamespan"+firstindex+secindex+rowindex).innerHTML = wuiUtil.getJsonValueByIndex(datas, 1);
				$G("parafieldtablename"+firstindex+secindex+rowindex).value = wuiUtil.getJsonValueByIndex(datas, 2);
			}else{
				$G("parafieldname"+firstindex+secindex+rowindex).value = "";
				$G("parafieldnamespan"+firstindex+secindex+rowindex).innerHTML = "";
				$G("parafieldtablename"+firstindex+secindex+rowindex).value = "";
			}
		}
	}
	
	function showEvaluateTableFiled(obj,firstindex,secindex,rowindex){
		rows = obj.rows.length;
		tablenames = "";
		for(var s=1;s<=rows;s++){
			tablename = "tablename"+firstindex+secindex+s;
			formid = "formid"+firstindex+secindex+s;
			tablenames = tablenames + $G(formid).value + ":"+ $G(tablename).value + ","
		}
		datasourcename="datasource"+firstindex+secindex;
		urls="/formmode/setup/triggerTableFieldsBrowser.jsp?datasourceid="+$G(datasourcename).value+"&tablenames="+tablenames;
		urls="/systeminfo/BrowserMain.jsp?url="+encode(urls);
		datas = window.showModalDialog(urls);
		if (datas != undefined && datas != null) {
			if(datas.id != ''){
				$G("evaluatefieldname"+firstindex+secindex+rowindex).value = wuiUtil.getJsonValueByIndex(datas, 0);
				$G("evaluatefieldnamespan"+firstindex+secindex+rowindex).innerHTML = wuiUtil.getJsonValueByIndex(datas, 1);
				$G("evaluatefieldtablename"+firstindex+secindex+rowindex).value = wuiUtil.getJsonValueByIndex(datas, 2);
			}else{
				$G("evaluatefieldname"+firstindex+secindex+rowindex).value = "";
				$G("evaluatefieldnamespan"+firstindex+secindex+rowindex).innerHTML = "";
				$G("evaluatefieldtablename"+firstindex+secindex+rowindex).value = "";
			}
		}
	}
		
	function modeTriggerSave(obj){
		for(var tempTriggerIndex=0;tempTriggerIndex<1;tempTriggerIndex++){
			if($G("triggerField"+tempTriggerIndex)){
				var triggerfield = $G("triggerField"+tempTriggerIndex).value;
				if(triggerfield==""){
					alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
					return;
				}
			}
		}
		obj.disabled=true;
		document.frmTrigger.submit();
		parentReload();
	}
	
	function parentReload(){
		window.parent.location.reload();
	}
</script>
</html>