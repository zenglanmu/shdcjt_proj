<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<% 
if(!HrmUserVarify.checkUserRight("DocChange:Setting", user)){
	response.sendRedirect("/notice/noright.jsp");
		return;
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

boolean isView = Util.null2String(request.getParameter("isView")).equals("true");
String viewid="5";//Util.null2String(request.getParameter("viewid"));
String setname = "";
String workFlowId = "";
String workFlowName = "";
String isbill = "";
String formID = "";
String outermaintable = "";
String outerdetailtables = "";
String chageFlag = Util.null2String(request.getParameter("chageFlag"));
String companyid = Util.null2String(request.getParameter("companyid"));
int version = Util.getIntValue(request.getParameter("version"), 0);
int sn = Util.getIntValue(request.getParameter("sn"), 0);
int newsn = sn;
String newversionid = Util.null2String(request.getParameter("newversionid"));
if(!newversionid.equals("")) version = Util.getIntValue(newversionid,0);
workFlowId = Util.null2String(request.getParameter("wfid"));//工作流ID
//out.println("workFlowId1:"+workFlowId+"	sn:"+sn);

//如果编辑过就把已经存在的数据带出来
String sql = "";
if(workFlowId.equals("")){
	sql = "select * from DocChangeFieldConfig where sn = '"+sn+"' and version = " + version;
	rs.executeSql(sql);
	//out.println(sql);
	while(rs.next()){
		workFlowId = rs.getString("workflowid");
	}
	//如果当前流程没有设置过对应关系，那么取同一个chageFlag设置过的流程来作为默认值
	if(workFlowId.equals("")){
		sql = "select * from DocChangeFieldConfig where companyid='"+companyid+"' and chageFlag='"+chageFlag+"' and version = " + version + " order by id asc";
		rs.executeSql(sql);
		//out.println(sql);
		while(rs.next()){
			workFlowId = rs.getString("workflowid");
			newsn = Util.getIntValue(rs.getString("sn"), 0);
		}
	}
	//out.println("workFlowId2:"+workFlowId+"	newsn:"+newsn);
}

isbill = Util.null2String(WorkflowComInfo.getIsBill(workFlowId));//取得Formid
formID=Util.null2String(WorkflowComInfo.getFormId(workFlowId));//取得Formid
workFlowName=Util.null2String(WorkflowComInfo.getWorkflowname(workFlowId));//工作流名称
ArrayList maintablecolsList = new ArrayList();
//maintablecolsList.add("t1");
//maintablecolsList.add("t2");
ArrayList outerdetailtablesArr = Util.TokenizerString(outerdetailtables,",");
String maintableoptions = "";
String temptableoptions = "";
String temprulesoptvalue = "0";
String tempiswriteback = "0";
int fieldscount = 2;

//取得配置字段信息
RecordSet.executeSql("SELECT * FROM DocChangeReceiveField WHERE chageFlag='"+chageFlag+"' AND companyid='"+companyid+"' AND version="+version + " and sn = " + sn);
//out.println("SELECT * FROM DocChangeReceiveField WHERE chageFlag='"+chageFlag+"' AND companyid='"+companyid+"' AND version="+version + " and sn = " + sn);
while(RecordSet.next()){
    maintableoptions += "<option value='"+RecordSet.getString("fieldid")+"'>"+RecordSet.getString("fieldname")+"&lt;"+RecordSet.getString("fieldid")+"&gt;"+"</option>";
}
Hashtable outerfieldid_ht = new Hashtable();
Hashtable outerfieldname_ht = new Hashtable();
Hashtable changetype_ht = new Hashtable();

//取得已配置字段信息
sql = "SELECT t1.fieldname fn, t1.rulesopt, t2.fieldname,t2.fieldid FROM DocChangeFieldConfig t1, DocChangeReceiveField t2 WHERE "+
			 "t1.chageFlag=t2.chageFlag AND t1.companyid=t2.companyid AND t1.version=t2.version AND t1.outerfieldname=t2.fieldid ";
if(!chageFlag.equals("")) sql += " AND t1.chageFlag='"+chageFlag+"' ";
if(!companyid.equals("")) sql += " AND t1.companyid='"+companyid+"' ";
if(version!=0) sql += " AND t1.version="+version;
sql += " AND t1.workflowid='"+workFlowId+"'";
if(newsn>0) sql += " AND t1.sn="+newsn+" ";
RecordSet.executeSql(sql);
//out.println(sql);
while(RecordSet.next()){
	outerfieldid_ht.put(RecordSet.getString("fn"), RecordSet.getString("fieldid"));
	outerfieldname_ht.put(RecordSet.getString("fn"), RecordSet.getString("fieldname")+"&lt;"+RecordSet.getString("fieldid")+"&gt;");
	changetype_ht.put(RecordSet.getString("fn"), RecordSet.getString("rulesopt"));
}
ArrayList wfList = new ArrayList();
sql = "SELECT workflowid FROM DocChangeFieldConfig WHERE 1=1 ";
if(!chageFlag.equals("")) sql += " AND chageFlag='"+chageFlag+"' ";
if(!companyid.equals("")) sql += " AND companyid='"+companyid+"' ";
if(version>0) sql += " AND version="+version+" ";
if(newsn>0) sql += " AND sn="+newsn+" ";
sql += " group by workflowid ";
RecordSet.executeSql(sql);
//out.println(sql);
while(RecordSet.next()){
	wfList.add(RecordSet.getString("workflowid"));
}
%>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(23083,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(19342,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(!workFlowId.equals("")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form name="frmmain" method="post" action="WorkflowFieldConfigOperation.jsp">
<input type="hidden" id="operate" name="operate" value="adddetail">
<input type="hidden" id="viewid" name="viewid" value="<%=viewid%>">
<input type="hidden" id="sn" name="sn" value="<%=sn%>">
<input type="hidden" id="companyid" name="companyid" value="<%=companyid%>">
<input type="hidden" id="chageFlag" name="chageFlag" value="<%=chageFlag%>">
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
	  <tr><td class=line colspan=2><td></tr>
	  <tr>
			<td><%=SystemEnv.getHtmlLabelName(18104,user.getLanguage())%></td>
			<td class=field>
				<span id="workflowspan">
					<%=Util.null2String(WorkflowComInfo.getWorkflowname(workFlowId))%><input type="hidden" value="<%=workFlowId%>" name="wfid">
				</span>
			</td>
		</tr>
	  <tr><td class=line colspan=2><td></tr>
		<tr style="display:none">
			<td><%=SystemEnv.getHtmlLabelName(19587,user.getLanguage())%></td>
			<td class=field><span>
				V<%=version%><input type="hidden" value="<%=version%>" name="version">
			</td>
	  </tr>
		<tr style="display:none"><td class=line1 colspan=2><td></tr>
		<%if(!workFlowId.equals("")){%>
		<tr class=spacing>
			<td class=Sep1 colSpan=2 ></td>
		</tr>
		<tr>
			<td colspan=2>
				<table class=ListStyle cellspacing=1>
					<colgroup>
					<col width="40%">
					<col width="40%">
					<col width="20%">
					<tr class=Header>
						<td><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18549,user.getLanguage())%></td>
						<td><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></td>
						<td><%=SystemEnv.getHtmlLabelName(23128,user.getLanguage())%></td>
					</tr>
					<tr class=datalight style="display: none">
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
					<tr class=datadark style="display: none">
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
							<button type="button" class=Browser  onclick="onShowHrmResource()" title="<%=SystemEnv.getHtmlLabelName(22734,user.getLanguage())%>"></button>
							<span id="hrmidspan"><%=hrmname%></span>
							<input type="hidden" id="hrmid" name="hrmid" value="<%=hrmid%>">
							</div>
						</td>
						<td>
							<select id="rulesopt_2" name="rulesopt_2" onchange="changeRules(this.value)">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<!--
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></option>
								-->
								<option value="2" <%if(temprulesoptvalue.equals("2")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%></option>
								<!--
								<option value="3" <%if(temprulesoptvalue.equals("3")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(22482,user.getLanguage())%></option>
								<option value="4" <%if(temprulesoptvalue.equals("4")){%>selected<%}%> >Email</option>
								<option value="5" <%if(temprulesoptvalue.equals("5")){%>selected<%}%> >--<%=SystemEnv.getHtmlLabelName(23155,user.getLanguage())%>--</option>
								 -->
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
					    	//out.println("select t2.fieldid,t2.fieldorder,t1.fieldlable,t1.langurageid from workflow_fieldlable t1,workflow_formfield t2 where t1.formid=t2.formid and t1.fieldid=t2.fieldid and (t2.isdetail<>'1' or t2.isdetail is null)  and t2.formid="+formID+"  and t1.langurageid="+user.getLanguage()+" order by t2.fieldorder");
					        while(RecordSet.next()){
					            fieldids.add(Util.null2String(RecordSet.getString("fieldid")));
					            fieldlabels.add(Util.null2String(RecordSet.getString("fieldlable")));
					        }
					    }else if(isbill.equals("1")){//单据
					        RecordSet.executeSql("select * from workflow_billfield where viewtype=0 and billid="+formID);
					        //out.println("select * from workflow_billfield where viewtype=0 and billid="+formID);
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
						tempfieldname = Util.null2String((String)outerfieldid_ht.get(fieldid));
						if(!tempfieldname.equals("")){
							String tmpname = Util.null2String((String)outerfieldname_ht.get(fieldid));
						    String replaceedStr = "<option value='"+tempfieldname+"'>"+tmpname+"</option>";
						    String replaceStr = "<option value='"+tempfieldname+"' selected>"+tmpname+"</option>";
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
								<!--
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></option>
								-->
								<option value="2" <%if(temprulesoptvalue.equals("2")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%></option>
								<!--
								<option value="3" <%if(temprulesoptvalue.equals("3")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(22482,user.getLanguage())%></option>
								<option value="4" <%if(temprulesoptvalue.equals("4")){%>selected<%}%> >Email</option>
								-->
							</select>    
							<%  }else if(false && fieldtype.equals("4")){//单部门流程框
							%>
							<select id="rulesopt_<%=fieldscount%>" name="rulesopt_<%=fieldscount%>">
								<option value="0" <%if(temprulesoptvalue.equals("0")){%>selected<%}%> ></option>
								<option value="1" <%if(temprulesoptvalue.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(15391,user.getLanguage())%></option>
							</select>
							<%  }else if(false && fieldtype.equals("164")){//单分部流程框
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
			<td class=Sep1 colSpan=2></td>
		</tr>
		<%}%>
		<tr><td class=line1 colspan=2><td></tr>
		<tr>
			<td class=field colspan=2>
			<font color=red>
				<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>:<BR>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(24540,user.getLanguage())%><br>
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
<input type="hidden" id="fieldscount" name="fieldscount" value="<%=fieldscount%>">
</form>
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
//更改条件
function changeParam() {
	document.frmmain.action = 'WorkflowFieldConfig.jsp';
	document.frmmain.submit();
}
//处理提示信息
if(document.frmmain.wfid.value!='') {
	//document.getElementById('wffont').style.display = 'none';
}
if(document.frmmain.version.value!='') {
	//document.getElementById('versionfont').style.display = 'none';
}
function doBack() {
	<%if(isView){%>
		location.href = 'DocChangeSetting.jsp';
	<%}else{%>
		location.href = 'ReceiveDoc.jsp?status=1';
	<%}%>
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

sub onShowHrmResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
		if id(0)<> "" then 
			document.getElementById("hrmidspan").innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
			document.getElementById("hrmid").value = id(0)
		else 
			document.getElementById("hrmidspan").innerHtml = ""
			document.getElementById("hrmid").value = ""
		end if
	end if
end sub
</script>
