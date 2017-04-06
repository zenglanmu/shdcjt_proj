<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.system.code.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs4" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<html>
<%
	String ajax=Util.null2String(request.getParameter("ajax"));
	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0); 
	String message=Util.null2String(request.getParameter("message"));
	if(message.equals("reset")) message = SystemEnv.getHtmlLabelName(22428,user.getLanguage());
	
	String wfid_isbill = "";
	int wfid_formid=0;
	if(wfid!=0){
    WFManager.setWfid(wfid);
		WFManager.getWfInfo();
    wfid_isbill = WFManager.getIsBill();
    wfid_formid=WFManager.getFormid();
	}
	ArrayList pointArrayList = DataSourceXML.getPointArrayList();
	String sql="";
	String wfMainFieldsOptions = "";//主字段
	//String wfDetailFieldsOptions = "";//明细字段
	String wfFieldsOptions = "";//全部字段
	if(wfid_isbill.equals("0")){//表单主字段
		sql = "select a.fieldid, b.fieldlable, a.isdetail, a.fieldorder from workflow_formfield a, workflow_fieldlable b "+
					" where a.isdetail is null and a.formid=b.formid and a.fieldid=b.fieldid and a.formid="+wfid_formid+" and b.langurageid = "+user.getLanguage();
		if(RecordSet.getDBType().equals("oracle")){
			sql += " order by a.isdetail desc,a.fieldorder asc ";
		}else{    
			sql += " order by a.isdetail,a.fieldorder ";
		}
	}else if(wfid_isbill.equals("1")){//单据主字段
		sql = "select id,fieldlabel,viewtype,dsporder from workflow_billfield where viewtype=0 and billid="+wfid_formid;
		sql += " order by viewtype,dsporder";
	}
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		String fieldname = "";
		if(wfid_isbill.equals("0")) fieldname = RecordSet.getString("fieldlable");
		if(wfid_isbill.equals("1")) fieldname = SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldlabel"), user.getLanguage());
		wfMainFieldsOptions += "<option value="+RecordSet.getString(1)+">"+fieldname+"</option>";
	}
	Hashtable detailFiledHST = new Hashtable();
	if(wfid_isbill.equals("0")){//表单明细字段
		sql = "select distinct groupid from workflow_formfield where formid="+wfid_formid;
		ArrayList detaigroupidlist = new ArrayList();
		RecordSet.executeSql(sql);
		while(RecordSet.next()){
		    String tempgroupid = RecordSet.getString("groupid");
		    detaigroupidlist.add(tempgroupid);
		}
		for(int i=0;i<detaigroupidlist.size();i++){
		    String tempgroupid = Util.null2String((String)detaigroupidlist.get(i));
		    if(tempgroupid.equals("")) continue;
		    sql = "select a.fieldid, b.fieldlable, a.isdetail, a.fieldorder from workflow_formfield a, workflow_fieldlable b "+
				    	" where a.isdetail=1 and a.formid=b.formid and a.fieldid=b.fieldid and a.formid="+wfid_formid+" and b.langurageid = "+user.getLanguage()+" and groupid="+tempgroupid;
		    if(RecordSet.getDBType().equals("oracle")){
			    sql += " order by a.isdetail desc,a.fieldorder asc ";
		    }else{    
		    	sql += " order by a.isdetail,a.fieldorder ";
		    }
		    RecordSet.executeSql(sql);
		    String wfDetailFieldsOptions = "";
		    while(RecordSet.next()){
		        String fieldname = RecordSet.getString("fieldlable");
		        wfDetailFieldsOptions += "<option value="+RecordSet.getString(1)+">"+fieldname+"</option>";
		    }
		    detailFiledHST.put(tempgroupid,wfDetailFieldsOptions);
		}
	}else if(wfid_isbill.equals("1")){//单据明细字段
		ArrayList detailtablelist = new ArrayList();
		sql = "select distinct detailtable from workflow_billfield where billid="+wfid_formid;
		RecordSet.executeSql(sql);
		while(RecordSet.next()){
		    String tempdetailtable = RecordSet.getString("detailtable");
		    detailtablelist.add(tempdetailtable);
		}
		for(int i=0;i<detailtablelist.size();i++){
		    String tempdetailtable = Util.null2String((String)detailtablelist.get(i));
		    if(tempdetailtable.equals("")) continue;
		    sql = "select id,fieldlabel,viewtype,dsporder from workflow_billfield where viewtype=1 and billid="+wfid_formid+" and detailtable='"+tempdetailtable+"'";
		    sql += " order by viewtype,dsporder";
		    RecordSet.executeSql(sql);
		    String wfDetailFieldsOptions = "";
		    while(RecordSet.next()){
		        String fieldname = SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldlabel"), user.getLanguage());
		        wfDetailFieldsOptions += "<option value="+RecordSet.getString(1)+">"+fieldname+"</option>";
		    }
		    detailFiledHST.put(tempdetailtable,wfDetailFieldsOptions);
		}
	}
	/*
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		String fieldname = "";
		if(wfid_isbill.equals("0")) fieldname = RecordSet.getString("fieldlable");
		if(wfid_isbill.equals("1")) fieldname = SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldlabel"), user.getLanguage());
		wfDetailFieldsOptions += "<option value="+RecordSet.getString(1)+">"+fieldname+"</option>";
	}
	*/
			
	//wfFieldsOptions = wfMainFieldsOptions+wfDetailFieldsOptions;
	
	String ischecked = "";
	int triggerNum = 0;
	RecordSet.executeSql("select * from Workflow_DataInput_entry where WorkFlowID="+wfid);
	while(RecordSet.next()){
		triggerNum++;
		ischecked = " checked ";
	}
%>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%

	if(!ajax.equals("1"))
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(),_self} " ;
	else
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:flowTriggerSave(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep;

%>
<%if(!ajax.equals("1")){%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>
<form id="frmTrigger" name="frmTrigger" method=post action="triggerOperation.jsp" >
	<input type="hidden" id="triggerNum" name="triggerNum" value="<%=triggerNum%>">
	<input type="hidden" id="wfid" name="wfid" value="<%=wfid%>">
	<div style="display:none">
	<table id="hidden_tab" cellpadding='0' width=0 cellspacing='0'>
	</table>
	</div>
<%
if(ajax.equals("1")){
%>
<input type="hidden" name="ajax" value="1">
<%}%>
<table width=100% height=90% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	<tr>
		<td ></td>
		<td valign="top">
			<TABLE class=Shadow>
				<tr>
					<td valign="top">
						<table class="viewform">
	   					<COLGROUP>
	   					<COL width="30%">
							<COL width="70%">
							<TR class="Title">
								<TH colspan=2><%=SystemEnv.getHtmlLabelName(21804,user.getLanguage())%>&nbsp;&nbsp;<font color="red"><%=message%></font></TH>
		   				</TR>
	       			<TR class="Spacing" style="height: 1px"><TD class="Line1" colSpan=2></TD></TR>
	       			<TR>
								<TD><%=SystemEnv.getHtmlLabelName(21804,user.getLanguage())%></TD>
								<TD class="Field"> 
								<input class="inputStyle" type="checkbox" name="txtUserUse" <%=ischecked%> value="1" onclick="if(this.checked){setting.style.display='';}else{setting.style.display='none';}">
								</TD>
	       			</TR>
	       			<TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
						</table>
						<div id=setting <%if(ischecked.equals("")){%>style="display:none"<%}else{%>style="display:''"<%}%>>
							<table class="viewform" >
	   					<COLGROUP>
	   					<COL width="30%">
							<COL width="70%">
								<TR>
									<td><b><%=SystemEnv.getHtmlLabelName(21683,user.getLanguage())%></b></td>
									<td align=right>
										<a style="color:#262626;cursor:pointer; TEXT-DECORATION:none" onclick="addRowOfFieldTrigger()"><img src="/js/swfupload/add.gif" align="absmiddle" border="0">&nbsp;<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21805,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></a>
										<a style="color:#262626;cursor:pointer; TEXT-DECORATION:none" onclick="deleteRowOfFieldTrigger()"><img src="/js/swfupload/delete.gif" align="absmiddle" border="0">&nbsp;<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21805,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></a>
									</td>
			   				</TR>
			   				<TR style="height: 1px"><TD class=Line1 colSpan=2></TD></TR>
							</table>
							<table id="LinkageTable" name="LinkageTable" class="viewform" cols=2>
		   					<COLGROUP>
		   					<COL width="2%">
								<COL width="98%">
								<%
								int index = 0;
								RecordSet.executeSql("select * from Workflow_DataInput_entry where WorkFlowID="+wfid);
								while(RecordSet.next()){
									int entryID = RecordSet.getInt("id");
									String TriggerFieldName = RecordSet.getString("TriggerFieldName");
									String fieldid = TriggerFieldName.substring(5,TriggerFieldName.length());
									String fieldname = "";
									int fieldtype = -1;
									String isbill = "";
									String formid = "";
									rs1.executeSql("select formid,isbill from workflow_base where id="+wfid);
									if(rs1.next()){
										formid = rs1.getString("formid");
										isbill = rs1.getString("isbill");
									}
									if(isbill.equals("0")){//表单
										rs1.executeSql("select fieldlable from workflow_fieldlable where fieldid="+fieldid+" and formid="+formid+" and langurageid = "+user.getLanguage());
										if(rs1.next()) fieldname = rs1.getString("fieldlable");
										rs1.executeSql("select isdetail from workflow_formfield where fieldid="+fieldid+" and formid="+formid);
										if(rs1.next()) fieldtype = Util.getIntValue(rs1.getString("isdetail"),0);
									}else{
										rs1.executeSql("select fieldlabel,viewtype from workflow_billfield where id="+fieldid+" and billid="+formid);
										if(rs1.next()){
											fieldname = SystemEnv.getHtmlLabelName(rs1.getInt("fieldlabel"), user.getLanguage());
											fieldtype = Util.getIntValue(rs1.getString("viewtype"),-1);
										}
									}
									
								%>
								<tr>
									<td class=field><input type="checkbox" name="checkbox_TriggerField" value="<%=index%>"></td>
									<td>
										<table width="100%" cols=2>
											<COLGROUP>
											<COL width="30%">
											<COL width="70%">
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(21805,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></td>
												<td class=field>
													<BUTTON class=Browser type="button" onClick="onShowTriggerField('triggerField<%=index%>','triggerFieldSpan<%=index%>','triggerFieldType<%=index%>','<%=index%>')"></BUTTON>
													<span id="triggerFieldSpan<%=index%>"><%if(fieldname.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}else{%><%=fieldname%><%}%></span>
													<input type="hidden" value="<%=fieldtype%>" name="triggerFieldType<%=index%>" id="triggerFieldType<%=index%>">
													<input type="hidden" value="<%=fieldid%>" name="triggerField<%=index%>" id="triggerField<%=index%>">
												</td>
											</tr><TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
											<tr>
												<td><b><%=SystemEnv.getHtmlLabelName(21805,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19653,user.getLanguage())%></b></td>
												<td align=right>
													<a style="color:#262626;cursor:pointer; TEXT-DECORATION:none" onclick='addTriggerSetting(<%=index%>)'><img src='/js/swfupload/add.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21805,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19653,user.getLanguage())%></a>
													<a style="color:#262626;cursor:pointer; TEXT-DECORATION:none" onclick='deleteTriggerSetting(<%=index%>)'><img src='/js/swfupload/delete.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21805,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19653,user.getLanguage())%></a>
												</td>
											</tr><TR style="height: 1px"><TD class=Line1 colSpan=2></TD></TR>
											<tr><td colSpan=2>
												<table id="table_<%=index%>" width="100%" class="viewform" cols=2>
													<COLGROUP>
													<COL width="2%">
													<COL width="98%">
													<%
													int secIndex = 0;
													rs1.executeSql("select * from Workflow_DataInput_main where entryID="+entryID+" order by OrderID");
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
																<TR style="height: 1px"><TD class=Line colSpan=3></TD></TR>
																<tr>
																	<td valign=top><%=SystemEnv.getHtmlLabelName(19422,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15190,user.getLanguage())%></td>
																	<td>
																		<table id="tableTable<%=index%><%=secIndex%>" width=100% cols=4>
																			<COLGROUP><COL width='25%'><COL width='25%'><COL width='10%'><COL width='10%'><COL width='30%'>
																			<%
																			int thIndex = 1;
																			rs2.executeSql("select * from Workflow_DataInput_table where DataInputID="+DateInputID+" order by id");
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
																				}else{
																					rs3.executeSql("select namelabel from workflow_bill where tablename='"+TableName+"'");
																					if(rs3.next()){
																						tablenamespan = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
																						tablenamespan += "("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")";
																					}else{
																						rs3.executeSql("select tabledesc,tabledescen from Sys_tabledict where tablename='"+TableName+"'");
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
																				<td class=field style="display:<%if(!datasourcename.trim().equals("")){%>none<%}%>"><BUTTON type="button" class=Browser onClick="onShowTable(tablename<%=index%><%=secIndex%><%=thIndex%>,tablenamespan<%=index%><%=secIndex%><%=thIndex%>,formid<%=index%><%=secIndex%><%=thIndex%>)"></BUTTON><span id="tablenamespan<%=index%><%=secIndex%><%=thIndex%>"><%=tablenamespan%></span>
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
																	    <a style="color:#262626;cursor:pointer; TEXT-DECORATION:none" onclick="addtable(tableTable<%=index%><%=secIndex%>,<%=index%>,<%=secIndex%>)"><img src='/js/swfupload/add.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>
																	</td>
																</tr>
																<TR style="height: 1px"><TD class=Line colSpan=3></TD></TR>
																<tr>
																	<td valign=top><%=SystemEnv.getHtmlLabelName(21841,user.getLanguage())%></td>
																	<td class=field colSpan=2><textarea class=Inputstyle id="tableralations<%=index%><%=secIndex%>" name="tableralations<%=index%><%=secIndex%>" cols=68 rows=4><%=WhereClause%></textarea><br><font color=red><%=SystemEnv.getHtmlLabelName(21842,user.getLanguage())%>a.id=b.id and a.wfid=b.wfid</font></td>
																</tr><TR style="height: 1px"><TD class=Line colSpan=3></TD></TR>
																<tr>
																	<td><b><%=SystemEnv.getHtmlLabelName(21843,user.getLanguage())%></b></td>
																	<td align=right colSpan=4>
																		<a style="color:#262626;cursor:pointer; TEXT-DECORATION:none" onclick="addParameterTable(parameterTable<%=index%><%=secIndex%>,<%=index%>,<%=secIndex%>)"><img src='/js/swfupload/add.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21843,user.getLanguage())%></a>
																		<a style="color:#262626;cursor:pointer; TEXT-DECORATION:none" onclick="deleteParameterTable(parameterTable<%=index%><%=secIndex%>)"><img src='/js/swfupload/delete.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21843,user.getLanguage())%></a>
																	</td>
																</tr><TR style="height: 1px"><TD class=Line1 colSpan=5></TD></TR>
																<tr><td colSpan=5>
																	<table id='parameterTable<%=index%><%=secIndex%>' width=100% class='liststyle' cols=3><COLGROUP><COL width='2%'><COL width='49%'><COL width='49%'>
																		<tr class=Header>
																			<td></td>
																			<td><%=SystemEnv.getHtmlLabelName(21844,user.getLanguage())%></td>
																			<td><%=SystemEnv.getHtmlLabelName(19372,user.getLanguage())%></td>
																		</tr>
																		<%
																		int forthIndex = 1;
																		rs3.executeSql("select * from Workflow_DataInput_field where Type=1 and DataInputID="+DateInputID+" order by id");
																		while(rs3.next()){
																			String TableID = rs3.getString("TableID");
																			String DBFieldName = rs3.getString("DBFieldName");
																			String PageFieldName = rs3.getString("PageFieldName");
																			String PageFieldId = PageFieldName.substring(5,PageFieldName.length());
																			String FieldTableName = "";
																			String FieldTableFormId = "";
																			String parafieldnamespan = DBFieldName;
																			if(parafieldnamespan.equals("requestid")) parafieldnamespan = SystemEnv.getHtmlLabelName(648,user.getLanguage())+"ID";
																			rs4.executeSql("select TableName,FormId from Workflow_DataInput_table where id="+TableID);
																			if(rs4.next()){
																				FieldTableName = rs4.getString("TableName");
																				FieldTableFormId = Util.null2String(rs4.getString("FormId"));
																				if(!FieldTableFormId.equals("")&&FieldTableFormId.indexOf("_")>0) FieldTableFormId = FieldTableFormId.substring(0,FieldTableFormId.indexOf("_"));
																			}
																			if(datasourcename.trim().equals("")&&!parafieldnamespan.equals("requestid")){
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
																			<td class=field><button type="button" class=Browser onClick="showParaTableFiled(tableTable<%=index%><%=secIndex%>,<%=index%>,<%=secIndex%>,<%=forthIndex%>)"></button><span id='parafieldnamespan<%=index%><%=secIndex%><%=forthIndex%>'><%=parafieldnamespan%></span>
																				<input type=hidden id='parafieldname<%=index%><%=secIndex%><%=forthIndex%>' name='parafieldname<%=index%><%=secIndex%><%=forthIndex%>' value='<%=DBFieldName%>'>
																				<input type=hidden id='parafieldtablename<%=index%><%=secIndex%><%=forthIndex%>' name='parafieldtablename<%=index%><%=secIndex%><%=forthIndex%>' value='<%=FieldTableName%>'>
																			</td>
																			<td class=field>
																				<select id='parawfField<%=index%><%=secIndex%><%=forthIndex%>' name='parawfField<%=index%><%=secIndex%><%=forthIndex%>'>
																				<%
																				if(fieldtype==0){
																					String tempWfMainFieldsOptions = Util.StringReplace(wfMainFieldsOptions,"<option value="+PageFieldId+">","<option value="+PageFieldId+" selected>");
																				%>
																				<%=tempWfMainFieldsOptions%>
																				<%
																				}else{
																					String tempWfFieldsOptions = "";
																					if(isbill.equals("1")){
																					    rs4.executeSql("select detailtable from workflow_billfield where id="+fieldid);
																					    if(rs4.next()) tempWfFieldsOptions = Util.null2String((String)detailFiledHST.get(rs4.getString("detailtable")));
																					}else{
																					    rs4.executeSql("select groupid from workflow_formfield where formid="+wfid_formid+" and fieldid="+fieldid);
																					    if(rs4.next()) tempWfFieldsOptions = Util.null2String((String)detailFiledHST.get(rs4.getString("groupid")));
																					}
																					tempWfFieldsOptions = Util.StringReplace(tempWfFieldsOptions,"<option value="+PageFieldId+">","<option value="+PageFieldId+" selected>");
																				%>
																				<%=tempWfFieldsOptions%>
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
																		<a style="color:#262626;cursor:pointer; TEXT-DECORATION:none" onclick='addEvaluateTable(evaluateTable<%=index%><%=secIndex%>,<%=index%>,<%=secIndex%>)'><img src='/js/swfupload/add.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21846,user.getLanguage())%></a>
																		<a style="color:#262626;cursor:pointer; TEXT-DECORATION:none" onclick='deleteEvaluateTable(evaluateTable<%=index%><%=secIndex%>)'><img src='/js/swfupload/delete.gif' align='absmiddle' border='0'>&nbsp;<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21846,user.getLanguage())%></a>
																	</td>
																</tr><TR style="height: 1px"><TD class=Line1 colSpan=5></TD></TR>
																<tr><td colSpan=5>
																	<table id='evaluateTable<%=index%><%=secIndex%>' width=100% class='liststyle' cols=3><COLGROUP><COL width='2%'><COL width='49%'><COL width='49%'>
																		<tr class=Header>
																			<td></td>
																			<td><%=SystemEnv.getHtmlLabelName(21847,user.getLanguage())%></td>
																			<td><%=SystemEnv.getHtmlLabelName(19372,user.getLanguage())%></td>
																		</tr>
																		<%
																		int fivethIndex = 1;
																		rs3.executeSql("select * from Workflow_DataInput_field where Type=2 and DataInputID="+DateInputID+" order by id");
																		while(rs3.next()){
																			String TableID = rs3.getString("TableID");
																			String DBFieldName = rs3.getString("DBFieldName");
																			String PageFieldName = rs3.getString("PageFieldName");
																			String PageFieldId = PageFieldName.substring(5,PageFieldName.length());
																			String FieldTableName = "";
																			String FieldTableFormId = "";
																			String evaluatefieldnamespan = DBFieldName;
																			if(evaluatefieldnamespan.equals("requestid")) evaluatefieldnamespan = SystemEnv.getHtmlLabelName(648,user.getLanguage())+"ID";
																			rs4.executeSql("select TableName,FormId from Workflow_DataInput_table where id="+TableID);
																			if(rs4.next()){
																				FieldTableName = rs4.getString("TableName");
																				FieldTableFormId = Util.null2String(rs4.getString("FormId"));
																				if(!FieldTableFormId.equals("")&&FieldTableFormId.indexOf("_")>0) FieldTableFormId = FieldTableFormId.substring(0,FieldTableFormId.indexOf("_"));
																			}
																			if(datasourcename.trim().equals("")&&!evaluatefieldnamespan.equals("requestid")){
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
																			<td class=field><button type="button" class=Browser onClick='showEvaluateTableFiled(tableTable<%=index%><%=secIndex%>,<%=index%>,<%=secIndex%>,<%=fivethIndex%>)'></button><span id='evaluatefieldnamespan<%=index%><%=secIndex%><%=fivethIndex%>'><%=evaluatefieldnamespan%></span>
																				<input type=hidden id='evaluatefieldname<%=index%><%=secIndex%><%=fivethIndex%>' name='evaluatefieldname<%=index%><%=secIndex%><%=fivethIndex%>' value='<%=DBFieldName%>'>
																				<input type=hidden id='evaluatefieldtablename<%=index%><%=secIndex%><%=fivethIndex%>' name='evaluatefieldtablename<%=index%><%=secIndex%><%=fivethIndex%>' value='<%=FieldTableName%>'>
																			</td>
																			<td class=field>
																				<select id='evaluatewfField<%=index%><%=secIndex%><%=fivethIndex%>' name='evaluatewfField<%=index%><%=secIndex%><%=fivethIndex%>'>
																				<%
																				if(fieldtype==1){
																					String tempWfDetailFieldsOptions = "";
																					if(isbill.equals("1")){
																					    rs4.executeSql("select detailtable from workflow_billfield where id="+fieldid);
																					    if(rs4.next()) tempWfDetailFieldsOptions = Util.null2String((String)detailFiledHST.get(rs4.getString("detailtable")));
																					}else{
																					    rs4.executeSql("select groupid from workflow_formfield where formid="+wfid_formid+" and fieldid="+fieldid);
																					    if(rs4.next()) tempWfDetailFieldsOptions = Util.null2String((String)detailFiledHST.get(rs4.getString("groupid")));
																					}
																					tempWfDetailFieldsOptions = Util.StringReplace(tempWfDetailFieldsOptions,"<option value="+PageFieldId+">","<option value="+PageFieldId+" selected>");
																				%>
																				<%=tempWfDetailFieldsOptions%>
																				<%
																				}else{
																					String tempWfFieldsOptions = Util.StringReplace(wfMainFieldsOptions,"<option value="+PageFieldId+">","<option value="+PageFieldId+" selected>");
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
													}%>	
													<input type="hidden" id="triggerSettingRows_<%=index%>" name="triggerSettingRows_<%=index%>" value="<%=secIndex%>">
												</table>
											<td></tr>
										</table>
									<td>
								</tr>
								<%
									index++;
								}
								%>
							</table>
						</div>
					</td>
				</tr>
			</TABLE>
		</td>
	</tr>
</table>
</form>
</body>
</html>