<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="AutomaticCols" class="weaver.workflow.automatic.automaticcols" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<% 
if(!HrmUserVarify.checkUserRight("OutDataInterface:Setting",user)) {
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
%>
<%
String dbtype = RecordSet.getDBType();
String requestnamedbtype = "varchar(400)";
String createrdbtype = "int";
if(dbtype.equals("oracle")){
    requestnamedbtype = "varchar2(400)";
    createrdbtype = "integer";
}

String viewid=Util.null2String(request.getParameter("viewid"));
String setname = "";
String workFlowId = "";
String datasourceid = "";
String workFlowName = "";
String isbill = "";
String formID = "";
String outermaintable = "";
String outerdetailtables = "";
RecordSet.executeSql("select * from outerdatawfset where id="+viewid);
if(RecordSet.next()){
    setname = Util.null2String(RecordSet.getString("setname"));
    workFlowId = Util.null2String(RecordSet.getString("workflowid"));
    datasourceid = Util.null2String(RecordSet.getString("datasourceid"));
    workFlowName=Util.null2String(WorkflowComInfo.getWorkflowname(workFlowId));
    isbill=Util.null2String(WorkflowComInfo.getIsBill(workFlowId));
    formID=Util.null2String(WorkflowComInfo.getFormId(workFlowId));
    outermaintable = Util.null2String(RecordSet.getString("outermaintable"));
    outerdetailtables = Util.null2String(RecordSet.getString("outerdetailtables"));
}
ArrayList maintablecolsList = AutomaticCols.getAllColumns(datasourceid,outermaintable);
ArrayList outerdetailtablesArr = Util.TokenizerString(outerdetailtables,",");
String maintableoptions = "";
String temptableoptions = "";
String temprulesoptvalue = "0";
String tempiswriteback = "0";
for(int i=0;i<maintablecolsList.size();i++){
    String columnname = outermaintable+"."+(String)maintablecolsList.get(i);
    maintableoptions += "<option value='"+columnname+"'>"+columnname+"</option>";
}

int fieldscount = 2;

Hashtable outerfieldname_ht = new Hashtable();
Hashtable changetype_ht = new Hashtable();
Hashtable iswriteback_ht = new Hashtable();
RecordSet.executeSql("select * from outerdatawfsetdetail where mainid="+viewid+" order by id");
while(RecordSet.next()){
    String wffieldid = Util.null2String(RecordSet.getString("wffieldid"));
    String outerfieldname = Util.null2String(RecordSet.getString("outerfieldname"));
    String changetype = Util.null2String(RecordSet.getString("changetype"));
    String iswriteback = Util.null2String(RecordSet.getString("iswriteback"));
    outerfieldname_ht.put(wffieldid,outerfieldname);
    changetype_ht.put(wffieldid,changetype);
    iswriteback_ht.put(wffieldid,iswriteback);
}
%>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(23076,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(19342,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",automaticsettingView.jsp?viewid="+viewid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form name="frmmain" method="post" action="automaticOperation.jsp">
<input type="hidden" id="operate" name="operate" value="adddetail">
<input type="hidden" id="viewid" name="viewid" value="<%=viewid%>">
<input type="hidden" id="fieldscount" name="fieldscount" value="<%=fieldscount%>">
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
	<table class=viewform cellspacing=1>
		<colgroup>
		<col width="10%">
		<col width="90%">
		<tbody>
		<tr class=spacing>
			<td class=Sep1 colSpan=2 ></td>
		</tr>	
	  <tr style="height:1px;"><td class=line colspan=2><td></tr>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
			<td class=field><span><%=setname%></span></td>
	  </tr>
	  <tr style="height:1px;"><td class=line colspan=2><td></tr>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(18104,user.getLanguage())%></td>
			<td class=field>
				<span id="workflowspan"><%=workFlowName%></span>
			</td>
		</tr>
		<tr style="height:1px;"><td class=line1 colspan=2><td></tr>
		<%if(!workFlowId.equals("")){%>
		<tr class=spacing>
			<td class=Sep1 colSpan=2 ></td>
		</tr>
		<tr>
			<td colspan=2>
				<table class=ListStyle cellspacing=1>
					<colgroup>
					<col width="30%">
					<col width="30%">
					<col width="20%">
					<col width="20%">
					<tr class=Header>
						<td><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18549,user.getLanguage())%></td>
						<td><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></td>
						<td><%=SystemEnv.getHtmlLabelName(23128,user.getLanguage())%></td>
						<td><%=SystemEnv.getHtmlLabelName(23135,user.getLanguage())%></td>
					</tr>
					<tr class=datalight>
						<td>
							<%=SystemEnv.getHtmlLabelName(22244,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>
							<input type="hidden" id="fieldid_index_1" name="fieldid_index_1" value="-1">
							<input type="hidden" id="fieldname_index_1" name="fieldname_index_1" value="requestname">
							<input type="hidden" id="fieldhtmltype_index_1" name="fieldhtmltype_index_1" value="1">
							<input type="hidden" id="fieldtype_index_1" name="fieldtype_index_1" value="1">
							<input type="hidden" id="fielddbtype_index_1" name="fielddbtype_index_1" value="<%=requestnamedbtype%>">
						</td>
						<%
						temptableoptions = maintableoptions;
						String tempfieldname = Util.null2String((String)outerfieldname_ht.get("-1"));
						if(!tempfieldname.equals("")){
						    String replaceedStr = "<option value='"+tempfieldname+"'>"+tempfieldname+"</option>";
						    String replaceStr = "<option value='"+tempfieldname+"' selected>"+tempfieldname+"</option>";
						    temptableoptions = Util.replace(temptableoptions,replaceedStr,replaceStr,0);
						}
						%>
						<td>
							<select id="outerfieldname_index_1" name="outerfieldname_index_1">
								<option></option>
								<%=temptableoptions%>
							</select>
						</td>
						<td></td>
						<td></td>
					</tr>
					<tr class=datadark>
						<td>
							<%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%>
							<input type="hidden" id="fieldid_index_2" name="fieldid_index_2" value="-2">
							<input type="hidden" id="fieldname_index_2" name="fieldname_index_2" value="creater">
							<input type="hidden" id="fieldhtmltype_index_2" name="fieldhtmltype_index_2" value="3">
							<input type="hidden" id="fieldtype_index_2" name="fieldtype_index_2" value="1">
							<input type="hidden" id="fielddbtype_index_2" name="fielddbtype_index_2" value="<%=createrdbtype%>">
						</td>
						<%
						temptableoptions = maintableoptions;
						tempfieldname = Util.null2String((String)outerfieldname_ht.get("-2"));
						temprulesoptvalue = Util.null2String((String)changetype_ht.get("-2"));
						String hrmname = "";
						String hrmid = "";
						if(temprulesoptvalue.equals("5")&&!temprulesoptvalue.equals("")){//选择了固定的创建人
						   hrmid = tempfieldname;
					     hrmname = ResourceComInfo.getLastname(hrmid);
						}else{
						    if(!tempfieldname.equals("")){
						        String replaceedStr = "<option value='"+tempfieldname+"'>"+tempfieldname+"</option>";
						        String replaceStr = "<option value='"+tempfieldname+"' selected>"+tempfieldname+"</option>";
						        temptableoptions = Util.replace(temptableoptions,replaceedStr,replaceStr,0);
						    }
						}
						%>
						<td>
							<div id="outerfieldnamediv" name="outerfieldnamediv" <%if(temprulesoptvalue.equals("5")){%>style="display='none'"<%}else{%>style="display=''"<%}%> >
							<select id="outerfieldname_index_2" name="outerfieldname_index_2">
								<option></option>
								<%=temptableoptions%>
							</select>
							</div>
							<div id="fixhrmresource" name="fixhrmresource" <%if(temprulesoptvalue.equals("5")){%>style="display=''"<%}else{%>style="display='none'"<%}%> >
							<button type=Button  class=Browser  onclick="onShowHrmResource('hrmid','hrmidspan')" title="<%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%>"></button>
							<span id="hrmidspan"><%=hrmname%></span>
							<input type="hidden" id="hrmid" name="hrmid" value="<%=hrmid%>">
							</div>
						</td>
						<td>
							<select id="rulesopt_2" name="rulesopt_2" onchange="changeRules(this.value)">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></option>
								<option value="2" <%if(temprulesoptvalue.equals("2")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%></option>
								<option value="3" <%if(temprulesoptvalue.equals("3")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(22482,user.getLanguage())%></option>
								<option value="4" <%if(temprulesoptvalue.equals("4")){%>selected<%}%> >Email</option>
								<option value="5" <%if(temprulesoptvalue.equals("5")){%>selected<%}%> >--<%=SystemEnv.getHtmlLabelName(23155,user.getLanguage())%>--</option>
							</select>
						</td>
						<td></td>
					</tr>
					<%
					ArrayList fieldids = new ArrayList();             //字段队列
					ArrayList fieldlabels = new ArrayList();          //字段的label队列
					ArrayList fieldhtmltypes = new ArrayList();       //字段的html type队列
					ArrayList fieldtypes = new ArrayList();           //字段的type队列
					ArrayList fieldnames = new ArrayList();           //字段名队列
					ArrayList fielddbtypes = new ArrayList();         //字段数据类型
					if(!formID.equals("")){
					    if(isbill.equals("0")){//表单
					        RecordSet.executeSql("select t2.fieldid,t2.fieldorder,t1.fieldlable,t1.langurageid from workflow_fieldlable t1,workflow_formfield t2 where t1.formid=t2.formid and t1.fieldid=t2.fieldid and (t2.isdetail<>'1' or t2.isdetail is null)  and t2.formid="+formID+"  and t1.langurageid="+user.getLanguage()+" order by t2.fieldorder");
					        while(RecordSet.next()){
					            fieldids.add(Util.null2String(RecordSet.getString("fieldid")));
					            fieldlabels.add(Util.null2String(RecordSet.getString("fieldlable")));
					        }
					    }else if(isbill.equals("1")){//单据
					        RecordSet.executeSql("select * from workflow_billfield where viewtype=0 and billid="+formID);
					        while(RecordSet.next()){
					            fieldids.add(Util.null2String(RecordSet.getString("id")));
					            fieldlabels.add(Util.null2String(RecordSet.getString("fieldlabel")));
					            fieldhtmltypes.add(Util.null2String(RecordSet.getString("fieldhtmltype")));
					            fieldtypes.add(Util.null2String(RecordSet.getString("type")));
					            fieldnames.add(Util.null2String(RecordSet.getString("fieldname")));
					            fielddbtypes.add(Util.null2String(RecordSet.getString("fielddbtype")));
					        }
					    }
					}
					for(int i=0;i<fieldids.size();i++){// 主字段循环开始
					    fieldscount++;
					    String fieldid = (String)fieldids.get(i);
					    String fieldlable = (String)fieldlabels.get(i);
					    String fieldhtmltype = "";
					    String fieldtype = "";
					    String fieldname = "";
					    String fielddbtype = "";
					    if(isbill.equals("0")){
					        fieldhtmltype = FieldComInfo.getFieldhtmltype(fieldid);
					        fieldtype = FieldComInfo.getFieldType(fieldid);
					        fieldname = FieldComInfo.getFieldname(fieldid);
					        fielddbtype = FieldComInfo.getFielddbtype(fieldid);
					    }else if(isbill.equals("1")){
					        fieldhtmltype = (String)fieldhtmltypes.get(i);
					        fieldtype = (String)fieldtypes.get(i);
					        fieldname = (String)fieldnames.get(i);
					        fieldlable = SystemEnv.getHtmlLabelName( Util.getIntValue(fieldlable,0),user.getLanguage() );
					        fielddbtype = (String)fielddbtypes.get(i);
					    }
					%>  
					<%if(i%2==1){%><tr class=datadark><%}%>
					<%if(i%2==0){%><tr class=datalight><%}%>
						<td>
							<%=fieldlable%>
							<input type="hidden" id="fieldid_index_<%=fieldscount%>" name="fieldid_index_<%=fieldscount%>" value="<%=fieldid%>">
							<input type="hidden" id="fieldname_index_<%=fieldscount%>" name="fieldname_index_<%=fieldscount%>" value="<%=fieldname%>">
							<input type="hidden" id="fieldhtmltype_index_<%=fieldscount%>" name="fieldhtmltype_index_<%=fieldscount%>" value="<%=fieldhtmltype%>">
							<input type="hidden" id="fieldtype_index_<%=fieldscount%>" name="fieldtype_index_<%=fieldscount%>" value="<%=fieldtype%>">
							<input type="hidden" id="fielddbtype_index_<%=fieldscount%>" name="fielddbtype_index_<%=fieldscount%>" value="<%=fielddbtype%>">
						</td>
						<%
						temptableoptions = maintableoptions;
						tempfieldname = Util.null2String((String)outerfieldname_ht.get(fieldid));
						if(!tempfieldname.equals("")){
						    String replaceedStr = "<option value='"+tempfieldname+"'>"+tempfieldname+"</option>";
						    String replaceStr = "<option value='"+tempfieldname+"' selected>"+tempfieldname+"</option>";
						    temptableoptions = Util.replace(temptableoptions,replaceedStr,replaceStr,0);
						}
						%>
						<td>
							<select id="outerfieldname_index_<%=fieldscount%>" name="outerfieldname_index_<%=fieldscount%>">
								<option></option>
								<%=temptableoptions%>
							</select>
						</td>
						<td>
							<%
							if(fieldhtmltype.equals("3")){
							    temprulesoptvalue = Util.null2String((String)changetype_ht.get(fieldid));
							    if(fieldtype.equals("1")){//单人力资源浏览框
							%>
							<select id="rulesopt_<%=fieldscount%>" name="rulesopt_<%=fieldscount%>">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></option>
								<option value="2" <%if(temprulesoptvalue.equals("2")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%></option>
								<option value="3" <%if(temprulesoptvalue.equals("3")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(22482,user.getLanguage())%></option>
								<option value="4" <%if(temprulesoptvalue.equals("4")){%>selected<%}%> >Email</option>
							</select>    
							<%  }else if(fieldtype.equals("4")){//单部门流程框
							%>
							<select id="rulesopt_<%=fieldscount%>" name="rulesopt_<%=fieldscount%>">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(15391,user.getLanguage())%></option>
							</select>
							<%  }else if(fieldtype.equals("164")){//单分部流程框
							%>
							<select id="rulesopt_<%=fieldscount%>" name="rulesopt_<%=fieldscount%>">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></option>
							</select>
							<%  }
							%>
							<%}%>
						</td>
						<%
						tempiswriteback = Util.null2String((String)iswriteback_ht.get(fieldid));
						%>
						<td>
							<input type="checkbox" id="iswriteback_<%=fieldscount%>" name="iswriteback_<%=fieldscount%>" value="<%=tempiswriteback%>" onclick="if(this.checked){this.value=1;}else{this.value=0;}" <%if(tempiswriteback.equals("1")){%>checked<%}%> >
						</td>
					</tr>  
					<%}%>
				</table>
			</td>
		</tr>
		<tr class=spacing>
			<td class=Sep1 colSpan=2></td>
		</tr>
		<%
		int detailindex = 0;
		String detailsSQL = "";
		if(isbill.equals("0")){//表单明细
		    detailindex = 0;
		    detailsSQL = "select distinct groupId from Workflow_formfield where formid="+formID+" and isdetail='1' order by groupid";
				RecordSet.executeSql(detailsSQL);
	  		while(RecordSet.next()){
	  		    String outdetailtable = (String)outerdetailtablesArr.get(detailindex);//流程明细对应外部数据表
	      		detailindex++;
	         	String tempGroupId = RecordSet.getString(1);
	          String fieldsSearchSql = "select t2.fieldid,t2.fieldorder,t1.fieldlable,t1.langurageid,t3.fieldname,t3.fielddbtype,t3.fieldhtmltype,t3.type from workflow_fieldlable t1,workflow_formfield t2,workflow_formdictdetail t3 where t1.formid=t2.formid and t1.fieldid=t2.fieldid and t2.isdetail='1' and t2.groupId="+tempGroupId+" and t2.formid="+formID+"  and t1.langurageid="+user.getLanguage()+" and t3.id=t2.fieldid order by t2.fieldorder";
	          String outerdetailoptions = "";
	          ArrayList outdetailtablecolsList = AutomaticCols.getAllColumns(datasourceid,outdetailtable);
	          for(int j=0;j<outdetailtablecolsList.size();j++){
	              String detailcolname = outdetailtable+"."+(String)outdetailtablecolsList.get(j);
	              outerdetailoptions += "<option value='"+detailcolname+"'>"+detailcolname+"</option>";
	          }
		%>
		<tr>
			<td colspan=2>
				<table class=ListStyle cellspacing=1>
					<colgroup>
					<col width="30%">
					<col width="30%">
					<col width="40%">
					<tr class=Header>
						<td><%=SystemEnv.getHtmlLabelName(18550,user.getLanguage())%><%=detailindex%></td>
						<td><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></td>
						<td><%=SystemEnv.getHtmlLabelName(23128,user.getLanguage())%></td>
					</tr>
					<%
					int colorindex = 0;
					rs1.executeSql(fieldsSearchSql);
				  while(rs1.next()){//表单明细字段
				      fieldscount++;
				      String detailfieldid = Util.null2String(rs1.getString("fieldid"));//字段id
				      String detailfieldname = Util.null2String(rs1.getString("fieldname"));//字段名称
				      String detailfieldhtmltype = Util.null2String(rs1.getString("fieldhtmltype"));//字段html类型
				      String detailfieldtype = Util.null2String(rs1.getString("type"));//字段类型
				      String detailfielddbtype = Util.null2String(rs1.getString("fielddbtype"));//字段数据库类型
				      String detailfieldlable = Util.null2String(rs1.getString("fieldlable"));//字段显示名
					%>
					<%if(colorindex==1){
					    colorindex = 0;
					%>
					<tr class=datadark>
					<%}else{
					    colorindex = 1;
					 %>
					<tr class=datalight>
					<%}%>
						<td>
							<%=detailfieldlable%>
							<input type="hidden" id="fieldid_index_<%=fieldscount%>" name="fieldid_index_<%=fieldscount%>" value="<%=detailfieldid%>">
							<input type="hidden" id="fieldname_index_<%=fieldscount%>" name="fieldname_index_<%=fieldscount%>" value="<%=detailfieldname%>">
							<input type="hidden" id="fieldhtmltype_index_<%=fieldscount%>" name="fieldhtmltype_index_<%=fieldscount%>" value="<%=detailfieldhtmltype%>">
							<input type="hidden" id="fieldtype_index_<%=fieldscount%>" name="fieldtype_index_<%=fieldscount%>" value="<%=detailfieldtype%>">
							<input type="hidden" id="fielddbtype_index_<%=fieldscount%>" name="fielddbtype_index_<%=fieldscount%>" value="<%=detailfielddbtype%>">
						</td>
						<%
						temptableoptions = outerdetailoptions;
						tempfieldname = Util.null2String((String)outerfieldname_ht.get(detailfieldid));
						if(!tempfieldname.equals("")){
						    String replaceedStr = "<option value='"+tempfieldname+"'>"+tempfieldname+"</option>";
						    String replaceStr = "<option value='"+tempfieldname+"' selected>"+tempfieldname+"</option>";
						    temptableoptions = Util.replace(temptableoptions,replaceedStr,replaceStr,0);
						}
						%>
						<td>
							<select id="outerfieldname_index_<%=fieldscount%>" name="outerfieldname_index_<%=fieldscount%>">
								<option></option>
								<%=temptableoptions%>
							</select>
						</td>
						<td>
							<%
							if(detailfieldhtmltype.equals("3")){
							    temprulesoptvalue = Util.null2String((String)changetype_ht.get(detailfieldid));
							    if(detailfieldtype.equals("1")){//单人力资源浏览框
							%>
							<select id="rulesopt_<%=fieldscount%>" name="rulesopt_<%=fieldscount%>">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></option>
								<option value="2" <%if(temprulesoptvalue.equals("2")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%></option>
								<option value="3" <%if(temprulesoptvalue.equals("3")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(22482,user.getLanguage())%></option>
								<option value="4" <%if(temprulesoptvalue.equals("4")){%>selected<%}%> >Email</option>
							</select>    
							<%  }else if(detailfieldtype.equals("4")){//单部门流程框
							%>
							<select id="rulesopt_<%=fieldscount%>" name="rulesopt_<%=fieldscount%>">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(15391,user.getLanguage())%></option>
							</select>
							<%  }else if(detailfieldtype.equals("164")){//单分部流程框
							%>
							<select id="rulesopt_<%=fieldscount%>" name="rulesopt_<%=fieldscount%>">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></option>
							</select>
							<%  }
							%>
							<%}%>
						</td>
					</tr>
					<%}%>
				</table>
			</td>
		</tr>
		<tr class=spacing>
			<td class=Sep1 colSpan=2 ></td>
		</tr>
		<%}
		}else if(isbill.equals("1")){//单据明细
		    detailindex = 0;
		    detailsSQL = "select tablename from Workflow_billdetailtable where billid="+formID+" order by orderid";
		    boolean isonlyone = false;
		    RecordSet.executeSql(detailsSQL);
		    if(RecordSet.getCounts()==0){
		        //没有记录不代表没有明细,单据对应的明细表可能没有写进Workflow_billdetailtable中
		        //但此时可以确定该单据即使有明细，也只有一个明细。
		        isonlyone = true;
		        detailsSQL = "select distinct viewtype from workflow_billfield where viewtype=1 and billid="+formID;
		    }
		    RecordSet.executeSql(detailsSQL);
		    while(RecordSet.next()){//单据明细字段
		        String outdetailtable = "";//流程明细对应外部数据表
		        if(outerdetailtablesArr.size()>detailindex) outdetailtable = (String)outerdetailtablesArr.get(detailindex);
		        detailindex++;
		        String outerdetailoptions = "";
	          ArrayList outdetailtablecolsList = AutomaticCols.getAllColumns(datasourceid,outdetailtable);
	          for(int j=0;j<outdetailtablecolsList.size();j++){
	              String detailcolname = outdetailtable+"."+(String)outdetailtablecolsList.get(j);
	              outerdetailoptions += "<option value='"+detailcolname+"'>"+detailcolname+"</option>";
	          }
		        String fieldsSearchSql = "select * from workflow_billfield where viewtype=1 and billid="+formID+" order by dsporder";
		        if(isonlyone)
		            fieldsSearchSql = "select * from workflow_billfield where viewtype=1 and billid="+formID+" order by dsporder";
		        else
		            fieldsSearchSql = "select * from workflow_billfield where detailtable='"+RecordSet.getString("tablename")+"' and viewtype=1 and billid="+formID+" order by dsporder";
		%>
		<tr>
			<td colspan=2>
				<table class=ListStyle cellspacing=1>
					<colgroup>
					<col width="30%">
					<col width="30%">
					<col width="40%">
					<tr class=Header>
						<td><%=SystemEnv.getHtmlLabelName(18550,user.getLanguage())%><%=detailindex%></td>
						<td><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></td>
						<td><%=SystemEnv.getHtmlLabelName(23128,user.getLanguage())%></td>
					</tr>
					<%
					int colorindex = 0;
					rs1.executeSql(fieldsSearchSql);
				  while(rs1.next()){
				      fieldscount++;
				      String detailfieldid = Util.null2String(rs1.getString("id"));
				      String detailfieldname = Util.null2String(rs1.getString("fieldname"));
				      String detailfieldhtmltype = Util.null2String(rs1.getString("fieldhtmltype"));
				      String detailfieldtype = Util.null2String(rs1.getString("type"));
				      String detailfielddbtype = Util.null2String(rs1.getString("fielddbtype"));
				      String detailfieldlable = Util.null2String(rs1.getString("fieldlabel"));
				      detailfieldlable = SystemEnv.getHtmlLabelName(Util.getIntValue(detailfieldlable),user.getLanguage());
					%>
					<%if(colorindex==0){
					    colorindex = 1;
					%>
					<tr class=datadark>
					<%}else{
					    colorindex = 0;
					 %>
					<tr class=datalight>
					<%}%>
						<td>
							<%=detailfieldlable%>
							<input type="hidden" id="fieldid_index_<%=fieldscount%>" name="fieldid_index_<%=fieldscount%>" value="<%=detailfieldid%>">
							<input type="hidden" id="fieldname_index_<%=fieldscount%>" name="fieldname_index_<%=fieldscount%>" value="<%=detailfieldname%>">
							<input type="hidden" id="fieldhtmltype_index_<%=fieldscount%>" name="fieldhtmltype_index_<%=fieldscount%>" value="<%=detailfieldhtmltype%>">
							<input type="hidden" id="fieldtype_index_<%=fieldscount%>" name="fieldtype_index_<%=fieldscount%>" value="<%=detailfieldtype%>">
							<input type="hidden" id="fielddbtype_index_<%=fieldscount%>" name="fielddbtype_index_<%=fieldscount%>" value="<%=detailfielddbtype%>">
						</td>
						<%
						temptableoptions = outerdetailoptions;
						tempfieldname = Util.null2String((String)outerfieldname_ht.get(detailfieldid));
						if(!tempfieldname.equals("")){
						    String replaceedStr = "<option value='"+tempfieldname+"'>"+tempfieldname+"</option>";
						    String replaceStr = "<option value='"+tempfieldname+"' selected>"+tempfieldname+"</option>";
						    temptableoptions = Util.replace(temptableoptions,replaceedStr,replaceStr,0);
						}
						%>
						<td>
							<select id="outerfieldname_index_<%=fieldscount%>" name="outerfieldname_index_<%=fieldscount%>">
								<option></option>
								<%=temptableoptions%>
							</select>
						</td>
						<td>
							<%
							if(detailfieldhtmltype.equals("3")){
							    temprulesoptvalue = Util.null2String((String)changetype_ht.get(detailfieldid));
							    if(detailfieldtype.equals("1")){//单人力资源浏览框
							%>
							<select id="rulesopt_<%=fieldscount%>" name="rulesopt_<%=fieldscount%>">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></option>
								<option value="2" <%if(temprulesoptvalue.equals("2")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%></option>
								<option value="3" <%if(temprulesoptvalue.equals("3")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(22482,user.getLanguage())%></option>
								<option value="4" <%if(temprulesoptvalue.equals("4")){%>selected<%}%> >Email</option>
							</select>    
							<%  }else if(detailfieldtype.equals("4")){//单部门流程框
							%>
							<select id="rulesopt_<%=fieldscount%>" name="rulesopt_<%=fieldscount%>">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(15391,user.getLanguage())%></option>
							</select>
							<%  }else if(detailfieldtype.equals("164")){//单分部流程框
							%>
							<select id="rulesopt_<%=fieldscount%>" name="rulesopt_<%=fieldscount%>">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></option>
							</select>
							<%  }
							%>
							<%}%>
						</td>
					</tr>
					<%}%>
				</table>
			</td>
		</tr>
		<tr class=spacing>
			<td class=Sep1 colSpan=2 ></td>
		</tr>
		<%}
		}%>
		<%}%>
		<tr style="height:1px;"><td class=line1 colspan=2><td></tr>
		<tr>
			<td class=field colspan=2>
			<font color=red>
				<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>:<BR>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1:<%=SystemEnv.getHtmlLabelName(23127,user.getLanguage())%><br>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2:<%=SystemEnv.getHtmlLabelName(23126,user.getLanguage())%><br>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp[<%=SystemEnv.getHtmlLabelName(23157,user.getLanguage())%>]<br>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3:<%=SystemEnv.getHtmlLabelName(23123,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(23124,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(23125,user.getLanguage())%>				
			</font>
			<td>
		</tr>
		</tbody>
	</table>
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
</body>
</html>
<script language="javascript">
function doSubmit(){
    document.getElementById("fieldscount").value = "<%=fieldscount%>";
    document.frmmain.submit();
}

function changeRules(rulevalue){
    if(rulevalue==5){
        document.getElementById("outerfieldnamediv").style.display = "none";
        document.getElementById("fixhrmresource").style.display = "";
    }else{
        document.getElementById("outerfieldnamediv").style.display = "";
        document.getElementById("fixhrmresource").style.display = "none";
    }
}
function onShowHrmResource(inputename,tdname){
	var ids = jQuery("#"+inputename).val();            
	var datas=null;
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置; 
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?resourceids="+ids);
    
    if (datas){
	    if (datas.id!= "" ){
	    	var strs="<a href=javaScript:openhrm("+datas.id+"); onclick='pointerXY(event);'>"+datas.name+"</a>&nbsp";
            
			jQuery("#"+tdname).html(strs);
			jQuery("#"+inputename).val(datas.id);
		}
		else{
			jQuery("#"+tdname).html("");
			jQuery("#"+inputename).val("");
		}
	}
}
</script>
<script language="vbs">
Sub onShowWorkFlowSerach(inputname, spanname)
    retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp")
    temp=document.all(inputname).value
    If (Not IsEmpty(retValue)) Then
        If retValue(0) <> "0" Then
            document.all(spanname).innerHtml = retValue(1)
            document.all(inputname).value = retValue(0)
        end if
    Else 
        document.all(inputname).value = ""
        document.all(spanname).innerHtml = ""			
    End If
    document.frmmain.action="automaticsettingAdd.jsp"
    document.frmmain.submit()
End Sub
</script>
