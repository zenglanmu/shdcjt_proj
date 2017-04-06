<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFNodeOperatorManager" class="weaver.workflow.workflow.WFNodeOperatorManager" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<%
 String ajax=Util.null2String(request.getParameter("ajax"));
%>
<%WFNodeOperatorManager.resetParameter();%>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
<%
int design = Util.getIntValue(request.getParameter("design"),0);
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
String needfav ="";
String needhelp ="";
request.getSession(true).setAttribute("por0_con","");
request.getSession(true).setAttribute("por0_con_cn","");
int isview = Util.getIntValue(Util.null2String(request.getParameter("isview")),0);
int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
String isbill=Util.null2String(request.getParameter("isbill"));
String iscust=Util.null2String(request.getParameter("iscust"));
int id=Util.getIntValue(Util.null2String(request.getParameter("id")),0);
String nodetype="";
char flag=2;
String sql ="" ;
if(wfid<=0 && id>0){
	sql = "select nodeid from workflow_nodegroup where id="+id;
	RecordSet.execute(sql);
	if(RecordSet.next()){
		nodeid = Util.getIntValue(RecordSet.getString("nodeid"), 0);
		sql = "select workflowid from workflow_flownode where nodeid="+nodeid;
		RecordSet.execute(sql);
		if(RecordSet.next()){
			wfid = Util.getIntValue(RecordSet.getString("workflowid"), 0);
		}
	}
}
RecordSet.executeProc("workflow_NodeType_Select",""+wfid+flag+nodeid);
if(RecordSet.next()){
	nodetype = RecordSet.getString("nodetype");
}
int iscreate = 0;
if(nodetype.equals("0")){
	iscreate = 1;
}
WFNodeOperatorManager.resetParameter();
WFNodeOperatorManager.setId(id);
WFNodeOperatorManager.selectOperatorbyID();
String groupname = Util.null2String(WFNodeOperatorManager.getName());
//已删除的跳转
if(design==1 && groupname.equals("")) response.sendRedirect("addoperatorgroup.jsp?design="+design+"&wfid="+wfid+"&nodeid="+nodeid+"&formid="+formid+"&isbill="+isbill+"&iscust="+iscust);
int canview = WFNodeOperatorManager.getCanview();

int rowsum=0;

ArrayList nodeids = new ArrayList() ;
ArrayList nodenames = new ArrayList() ;
WFNodeMainManager.setWfid(wfid);
WFNodeMainManager.selectWfNode();
while(WFNodeMainManager.next()){
	int tmpid = WFNodeMainManager.getNodeid();
	String tmpname = WFNodeMainManager.getNodename();
	nodeids.add(""+tmpid) ;
	nodenames.add(tmpname) ;
}
WFNodeMainManager.closeStatement();
sql ="" ;
%>
</head>
<body>
<%
if(design==0) {
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%
}
%>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
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


<form id="addopform" name="addopform" method=post action="wf_operation.jsp" >
<input type="hidden" value="<%=design%>" name="design">
<%if(ajax.equals("1")){%>
<input type="hidden" name="ajax" value="1">
<%}%>
<input type="hidden" name="selectindex">
<input type="hidden" name="selectvalue">
<input type="hidden" name="nodetype_operatorgroup" value="<%=nodetype%>" >
<input type="hidden" value="<%=nodeid%>" name="nodeid">
<input type="hidden" value="<%=wfid%>" name="wfid">
<input type="hidden" value="<%=formid%>" name="formid">
<input type=hidden name=isbill value="<%=isbill%>">
<input type=hidden name=iscust value="<%=iscust%>">
<input type="hidden" value="<%=id%>" name="id">
<input type="hidden" value="editoperatorgroup" name="src">
<input type="hidden" value="0" name="groupnum">
<%if(ajax.equals("1") || design==1){%>
<input type="hidden"  name="delete_wf_id" value="<%=WFNodeOperatorManager.getId()%>" >
<%}%>
<% if(isview!=1){%>
<DIV class=BtnBar>

<%
    if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(),_self} " ;
    else
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:nodeopaddsave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
if(!ajax.equals("1") && design==1) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:nodeopdelete(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
    if(!ajax.equals("1")) {
    	if(design==1) {
    		RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:designOnClose(),_self} " ;
    	}
    	else {
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(-1),_self} " ;
    	}
    }
    else
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:nodeopdelete(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
    if(ajax.equals("1")){
    	if(design==1) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:designOnClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
    }else{
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:cancelEditNode(),_self} " ;
    	RCMenuHeight += RCMenuHeightStep;
    }
    }
%>



 <table class="viewform" >
      	<COLGROUP>
  	<COL width="20%">
  	<COL width="60%">
  	<COL width="20%">
        <TR class="Title">
    	  <TH colSpan=3><b><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></b></TH></TR>
  	<TR class="Spacing">
    	  <TD class="Line1" colSpan=3></TD></TR>
    	<tr>
    	<td><%=SystemEnv.getHtmlLabelName(15545,user.getLanguage())%></td>
    	<td class=field colSpan=2>
    	<input type=text class=Inputstyle   name="groupname" value="<%=groupname%>" size=40 maxlength="60" onchange='checkinput("groupname","groupnameimage")'>
    	<SPAN id=groupnameimage>
        <%if(groupname.equals("")){%>
    	<IMG src="/images/BacoError.gif" align=absMiddle>
        <%}%>
    	</SPAN></TD>
    <!-- <td class=field><input type=checkbox name="canview" value="1" <%if(canview==1){%> checked <%}%>><%=SystemEnv.getHtmlLabelName(15547,user.getLanguage())%></td> -->
    <input type=hidden name="canview" value="<%=canview %>">
    <input type=hidden name="iscreate" value="<%=iscreate%>">
    
    	</tr>  	<TR class="Spacing">
    	  <TD class="Line1" colSpan=3></TD></TR>
</table>
<table class="viewform" >
      	<COLGROUP>
  	<COL width="20%">
  	<COL width="40%">
  	<COL width="40%">
        <TR class="Title">
    	  <TH colSpan=3><b><%=SystemEnv.getHtmlLabelName(15548,user.getLanguage())%></b></TH></TR>
  	<TR class="Spacing">
    	  <TD class="Line1" colSpan=3></TD></TR>
    	  <tr>
    	  <td colSpan=3>
    	  <table width=100%>
    	  <tr>
    	  <td width=11%><nobr> <%-- 一般  --%>
    	  <input type=radio  name=operategroup checked value=1 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>
    	  </nobr></td>
          <%if(!nodetype.equals("0")){%>
    	  <td width=11%><nobr> <%-- 人力资源字段 --%>
    	  <input type=radio  name=operategroup value=2 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15549,user.getLanguage())%>
    	  </nobr></td>
    	  <td width=11%><nobr> <%-- 文档字段 --%>
    	  <input type=radio  name=operategroup value=3 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15550,user.getLanguage())%>
    	  </nobr></td>
    	  <td width=11%><nobr> <%-- 项目字段 --%>
    	  <input type=radio  name=operategroup value=4 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15551,user.getLanguage())%>
    	  </nobr></td>
    	  <td width=11%><nobr> <%-- 资产字段  --%>
    	  <input type=radio  name=operategroup value=5 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15552,user.getLanguage())%> 
    	  </nobr></td>
        <td width=11%><nobr> <%-- 客户字段 --%>
    	  <input type=radio  name=operategroup value=6 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15553,user.getLanguage())%>
    	  </nobr></td>
    	  <td width=11%><nobr> <%-- 创建人 --%>
    	  <input type=radio  name=operategroup value=7 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%>
    	  </nobr></td>
        <td width=11%><nobr> <%-- 节点操作者 --%>
    	  <input type=radio  name=operategroup value=9 onclick="onChangetype(this.value)">节点操作者
    	  </nobr></td>
          <%}%>
    	  <td width=11%><nobr>
    	  <%if(iscust.equals("1")){%>  <%-- 门户相关 --%>
    	  <input type=radio  name=operategroup value=8 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15554,user.getLanguage())%>
    	  <%}%>
    	  </nobr></td>
    	  </tr></table></td>
    	  </tr>
</table>

<%-- 一般      start  --%>
<div id=odiv_1 style="">
<table class=liststyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="40%">
  	<COL width="10%">
  	<COL width="30%">
    <!-- 新增加分部 liuyu-->
     <tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('0','30')" name=tmptype id='tmptype_0' value=30><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
  	<td>
	<%if(nodetype.equals("0")){%>
		<select id="signorder_0" name="signorder_0" onfocus="changelevel(tmptype_0)">
			<option value="1"><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option>
			<option value="2"><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option>
		</select>
	<%}else{%>
		<input type="hidden" id="signorder_0" name="signorder_0" value="-1">
	<%}%>
          <%if(!ajax.equals("1")){%>
      <button type=button  class=Browser onclick="onShowBrowser('/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp','0',tmptype_0)"></button>
          <%}else if(!nodetype.equals("0")){%>
      <button type=button  class=Browser onclick="onShowBrowser4op('/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp','0',tmptype_0)"></button>
          <%}else{%>
          <button type=button  class=Browser onclick="onShowBrowser4opM1('/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp','0',tmptype_0)"></button>
          <%}%>
      <input type=hidden name=id_0 id=id_0>
          <span id=name_0 name=name_0></span>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=level_0 onfocus="changelevel(tmptype_0)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=level2_0 onfocus="changelevel(tmptype_0)" style="width:40%" value=100>
    	</td>
    	</tr>
  	<tr class=dataDark >
  	<td><input type=radio onClick="setSelIndex('1','1')" name=tmptype id='tmptype_1' value=1><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  	<td>
	<%if(nodetype.equals("0")){%>
		<select id="signorder_1" name="signorder_1" onfocus="changelevel(tmptype_1)">
			<option value="1"><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option>
			<option value="2"><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option>
		</select>
	<%}else{%>
		<input type="hidden" id="signorder_1" name="signorder_1" value="-1">
	<%}%>
          <%if(!ajax.equals("1")){%>
      <button type=button  class=Browser onclick="onShowBrowser('/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp','1',tmptype_1)"></button>
          <%}else if(!nodetype.equals("0")){%>
      <button type=button  class=Browser onclick="onShowBrowser4op('/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp','1',tmptype_1)"></button>
          <%}else{%>
      <button type=button  class=Browser onclick="onShowBrowser4opM1('/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp','1',tmptype_1)"></button>
          <%}%>
      <input type=hidden name=id_1 value=0>
          <span id=name_1 name=name_1></span>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=level_1 onfocus="changelevel(tmptype_1)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=level2_1 onfocus="changelevel(tmptype_1)" style="width:40%" value=100>
    	</td>
    	</tr>
    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('2','2')" name=tmptype id='tmptype_2' value=2><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></td>
  	<td>
	<%if(nodetype.equals("0")){%>
		<select id="signorder_2" name="" onfocus="changelevel(tmptype_2)">
			<option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
			<option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
		</select>
	<%}else{%>
		<input type="hidden" id="signorder_2" name="signorder_2" value="-1">
	<%}%>
          <%if(!ajax.equals("1")){%>
      <button type=button  class=Browser onclick="onShowBrowser('/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp','2',tmptype_2)"></button>
          <%}else{%>
      <button type=button  class=Browser onclick="onShowBrowser4op('/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp','2',tmptype_2)"></button>
          <%}%>
      <input type=hidden name=id_2 value=0>
          <span id=name_2 name=name_2></span>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></td><td>
    	<select class=inputstyle  name=level_2  onfocus="changelevel(tmptype_2)" style="width:80%">
	    	<option value=0 ><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
	      <option value=1 ><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
		<%if(!nodetype.equals("0")){%><option value=3 ><%=SystemEnv.getHtmlLabelName(22753,user.getLanguage())%></option><%}%>
	      <option value=2 ><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
      </select>
    	</td>
    	</tr>

    	<tr class=dataDark >
    	<td><input type=radio onClick="setSelIndex('3','3')" name=tmptype id='tmptype_3' value=3><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
  	<td>
          <%if(!ajax.equals("1")){%>
      <button type=button  class=Browser onclick="onShowBrowserM('/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp','3',tmptype_3)"></button>
          <%}else{%>
      <button type=button  class=Browser onclick="onShowBrowser4opM('/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp','3',tmptype_3)"></button>
          <%}%>
      <input type=hidden name=id_3 value=0>
          <span id=name_3 name=name_3></span>
    	</td>
    	<td></td><td>
    	<input type=text class=Inputstyle   name=level_3 style="display:none">
    	</td>
    	</tr>
    	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('4','4')" name=tmptype id='tmptype_4' value=4 ><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></td>
  	<td>
  	<input type=text class=Inputstyle   name=id_4 style="display:none">
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=level_4  onfocus="changelevel(tmptype_4)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=level2_4  onfocus="changelevel(tmptype_4)" style="width:40%" value=100>
    	</td>
    	</tr>

 </table>
</div>
<%-- 一般      end  --%>

<%-- 人力资源字段      start  --%>
<div id=odiv_2 style="display:none">
<table class=liststyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('5','5')" name=tmptype id='tmptype_5' value=5><%=SystemEnv.getHtmlLabelName(15555,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_5 onfocus="changelevel(tmptype_5)" style="width:50%">
  	<%
		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and (workflow_formdict.type = 1 or workflow_formdict.type=17 or workflow_formdict.type=165 or workflow_formdict.type=166) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 包括多人力资源字段
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=1 or type=17 or type=165 or type=166) and viewtype = 0 " ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td>
    	
        <nobr><input type=radio name=signorder_5 value="0" onfocus="changelevel(tmptype_5)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp</nobr>
    		<nobr><input type=radio name=signorder_5 value="1" checked  onfocus="changelevel(tmptype_5)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp</nobr>
        <nobr><input type=radio name=signorder_5 value="2" onfocus="changelevel(tmptype_5)"><%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>&nbsp;&nbsp</nobr>
    		<nobr><input type=radio name=signorder_5 value="3" onfocus="changelevel(tmptype_5)"><%=SystemEnv.getHtmlLabelName(21227,user.getLanguage())%>&nbsp;&nbsp</nobr>
        <nobr><input type=radio name=signorder_5 value="4" onfocus="changelevel(tmptype_5)"><%=SystemEnv.getHtmlLabelName(21228,user.getLanguage())%></nobr>
    	
    	</td>
    	</tr>
    	<tr class=dataDark >
    	<td><input type=radio onClick="setSelIndex('6','6')" name=tmptype id='tmptype_6' value=6 ><%=SystemEnv.getHtmlLabelName(15559,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_6 onfocus="changelevel(tmptype_6)" style="width:50%">
  	<%
  	  	  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and (workflow_formdict.type = 1 or workflow_formdict.type=165) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid; // 不包括多人力资源字段
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=1 or type=165) and viewtype = 0  " ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td>
    	<input type=text class=Inputstyle   name=level_6 style="display:none">

    	</td>
    	</tr>

        <tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('7','31')" name=tmptype id='tmptype_7' value=31><%=SystemEnv.getHtmlLabelName(15560,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_7 onfocus="changelevel(tmptype_7)" style="width:50%">
  	<%

		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=level_7  onfocus="changelevel(tmptype_7)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=level2_7  onfocus="changelevel(tmptype_7)" style="width:40%" value=100>
    	</td>
    	</tr>


          <tr class=dataDark >
    	<td><input type=radio onClick="setSelIndex('8','32')" name=tmptype id='tmptype_8' value=32><%=SystemEnv.getHtmlLabelName(15561,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_8 onfocus="changelevel(tmptype_8)" style="width:50%">
  	<%

		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=level_8  onfocus="changelevel(tmptype_8)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=level2_8  onfocus="changelevel(tmptype_8)" style="width:40%" value=100>
    	</td>
    	</tr>

    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('9','7')" name=tmptype id='tmptype_9' value=7><%=SystemEnv.getHtmlLabelName(15562,user.getLanguage())%></td>
        <td><select class=inputstyle  name=id_9 onfocus="changelevel(tmptype_9)" style="width:50%">
        <%
		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=level_9  onfocus="changelevel(tmptype_9)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=level2_9  onfocus="changelevel(tmptype_9)" style="width:40%" value=100>
    	</td>
    	</tr>

        <tr class=dataDark >
    	<td><input type=radio onClick="setSelIndex('38','38')" name=tmptype id='tmptype_38' value=38><%=SystemEnv.getHtmlLabelName(15563,user.getLanguage())%></td>
  	    <td><select class=inputstyle  name=id_38 onfocus="changelevel(tmptype_38)" style="width:50%">
  	    <%
		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=level_38  onfocus="changelevel(tmptype_38)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=level2_38  onfocus="changelevel(tmptype_38)" style="width:40%" value=100>
    	</td>
    	</tr>

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('42','42')" name=tmptype id='tmptype_42' value=42><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_42 onfocus="changelevel(tmptype_42)" style="width:50%">
  	<%
  	       sql ="" ;

		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and (workflow_formdict.type = 4 or workflow_formdict.type=57 or workflow_formdict.type=167 or workflow_formdict.type=168) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 多部门
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=4 or type=57 or type=167 or type=168) and viewtype = 0" ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td><input type=text class=Inputstyle name=level_42  onfocus="changelevel(tmptype_42)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_42  onfocus="changelevel(tmptype_42)" style="width:40%" value=100><br>
    	<input type=radio name=signorder_42 value="0" onfocus="changelevel(tmptype_42)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp
    	<input type=radio name=signorder_42 value="1" checked  onfocus="changelevel(tmptype_42)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp
        <input type=radio name=signorder_42 value="2" onfocus="changelevel(tmptype_42)"><%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>&nbsp;&nbsp
    	</td>
    	</tr>
    	
    	<!-- 组织架构部门负责人 -->
	  	<tr class=dataDark style="display:none">
		  	<td><input type=radio onClick="setSelIndex('52','52')" name=tmptype id='tmptype_52' value=52><%=SystemEnv.getHtmlLabelName(27107,user.getLanguage())%></td>
		  	<td>
			  	<select class=inputstyle  name=id_52 onfocus="changelevel(tmptype_52)" style="width:50%">
		  		<%
					sql ="" ;
					if(isbill.equals("0")){
						sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and (workflow_formdict.type = 4 or workflow_formdict.type=57 or workflow_formdict.type=167 or workflow_formdict.type=168) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 多部门
					}else{
						sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=4 or type=57 or type=167 or type=168) and viewtype = 0" ;
					}
					RecordSet.executeSql(sql);
					while(RecordSet.next()){
				%>
						<option value=<%=RecordSet.getString("id")%>>
							<% if(isbill.equals("0")) {%> 
								<%=RecordSet.getString("name")%>
							<%} else {%> 
								<%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> 
							<%}%>
						</option>
				<%}%>
				</select>
	    	</td>
	    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td>
	    	<td>
	    		<input type=hidden class=Inputstyle name=level_52  onfocus="changelevel(tmptype_52)" style="width:40%" value=0>
		    	<input type=hidden class=Inputstyle name=level2_52  onfocus="changelevel(tmptype_52)" style="width:40%" value=100>
		    	<input type=radio name=signorder_52 value="0" onfocus="changelevel(tmptype_52)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp
		    	<input type=radio name=signorder_52 value="1" checked  onfocus="changelevel(tmptype_52)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp
		        <input type=radio name=signorder_52 value="2" onfocus="changelevel(tmptype_52)"><%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>&nbsp;&nbsp
				<input type=radio name=signorder_52 value="3" onfocus="changelevel(tmptype_52)"><%=SystemEnv.getHtmlLabelName(21227,user.getLanguage())%>&nbsp;&nbsp
				<input type=radio name=signorder_52 value="4" onfocus="changelevel(tmptype_52)"><%=SystemEnv.getHtmlLabelName(21228,user.getLanguage())%>
	    	</td>
    	</tr>
    	
    	<!-- 组织架构部门分管领导 -->
	  	<tr class=datalight style="display:none">
		  	<td><input type=radio onClick="setSelIndex('53','53')" name=tmptype id='tmptype_53' value=53><%=SystemEnv.getHtmlLabelName(27108,user.getLanguage())%></td>
		  	<td>
			  	<select class=inputstyle  name=id_53 onfocus="changelevel(tmptype_53)" style="width:50%">
		  		<%
					sql ="" ;
					if(isbill.equals("0")){
						sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and (workflow_formdict.type = 4 or workflow_formdict.type=57 or workflow_formdict.type=167 or workflow_formdict.type=168) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 多部门
					}else{
						sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=4 or type=57 or type=167 or type=168) and viewtype = 0" ;
					}
					RecordSet.executeSql(sql);
					while(RecordSet.next()){
				%>
						<option value=<%=RecordSet.getString("id")%>>
							<% if(isbill.equals("0")) {%> 
								<%=RecordSet.getString("name")%>
							<%} else {%> 
								<%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> 
							<%}%>
						</option>
				<%}%>
				</select>
	    	</td>
	    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td>
	    	<td>
	    		<input type=hidden class=Inputstyle name=level_53  onfocus="changelevel(tmptype_53)" style="width:40%" value=0>
		    	<input type=hidden class=Inputstyle name=level2_53  onfocus="changelevel(tmptype_53)" style="width:40%" value=100>
		    	<input type=radio name=signorder_53 value="0" onfocus="changelevel(tmptype_53)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp
		    	<input type=radio name=signorder_53 value="1" checked  onfocus="changelevel(tmptype_53)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp
		        <input type=radio name=signorder_53 value="2" onfocus="changelevel(tmptype_53)"><%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>&nbsp;&nbsp
				<input type=radio name=signorder_53 value="3" onfocus="changelevel(tmptype_53)"><%=SystemEnv.getHtmlLabelName(21227,user.getLanguage())%>&nbsp;&nbsp
				<input type=radio name=signorder_53 value="4" onfocus="changelevel(tmptype_53)"><%=SystemEnv.getHtmlLabelName(21228,user.getLanguage())%>
	    	</td>
    	</tr>
    	
    	<!-- 矩阵管理部门负责人 -->
	  	<tr class=dataDark style="display:none">
		  	<td><input type=radio onClick="setSelIndex('54','54')" name=tmptype id='tmptype_54' value=54><%=SystemEnv.getHtmlLabelName(27109,user.getLanguage())%></td>
		  	<td>
			  	<select class=inputstyle  name=id_54 onfocus="changelevel(tmptype_54)" style="width:50%">
		  		<%
					sql ="" ;
					if(isbill.equals("0")){
						sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and (workflow_formdict.type = 4 or workflow_formdict.type=57 or workflow_formdict.type=167 or workflow_formdict.type=168) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 多部门
					}else{
						sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=4 or type=57 or type=167 or type=168) and viewtype = 0" ;
					}
					RecordSet.executeSql(sql);
					while(RecordSet.next()){
				%>
						<option value=<%=RecordSet.getString("id")%>>
							<% if(isbill.equals("0")) {%> 
								<%=RecordSet.getString("name")%>
							<%} else {%> 
								<%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> 
							<%}%>
						</option>
				<%}%>
				</select>
	    	</td>
	    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td>
	    	<td>
	    		<input type=hidden class=Inputstyle name=level_54  onfocus="changelevel(tmptype_54)" style="width:40%" value=0>
		    	<input type=hidden class=Inputstyle name=level2_54  onfocus="changelevel(tmptype_54)" style="width:40%" value=100>
		    	<input type=radio name=signorder_54 value="0" onfocus="changelevel(tmptype_54)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp
		    	<input type=radio name=signorder_54 value="1" checked  onfocus="changelevel(tmptype_54)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp
		        <input type=radio name=signorder_54 value="2" onfocus="changelevel(tmptype_54)"><%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>&nbsp;&nbsp
				<input type=radio name=signorder_54 value="3" onfocus="changelevel(tmptype_54)"><%=SystemEnv.getHtmlLabelName(21227,user.getLanguage())%>&nbsp;&nbsp
				<input type=radio name=signorder_54 value="4" onfocus="changelevel(tmptype_54)"><%=SystemEnv.getHtmlLabelName(21228,user.getLanguage())%>
	    	</td>
    	</tr>
    	
    	<!-- 矩阵管理部门分管领导 -->
	  	<tr class=datalight style="display:none">
		  	<td><input type=radio onClick="setSelIndex('55','55')" name=tmptype id='tmptype_55' value=55><%=SystemEnv.getHtmlLabelName(27110,user.getLanguage())%></td>
		  	<td>
			  	<select class=inputstyle  name=id_55 onfocus="changelevel(tmptype_55)" style="width:50%">
		  		<%
					sql ="" ;
					if(isbill.equals("0")){
						sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and (workflow_formdict.type = 4 or workflow_formdict.type=57 or workflow_formdict.type=167 or workflow_formdict.type=168) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 多部门
					}else{
						sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=4 or type=57 or type=167 or type=168) and viewtype = 0" ;
					}
					RecordSet.executeSql(sql);
					while(RecordSet.next()){
				%>
						<option value=<%=RecordSet.getString("id")%>>
							<% if(isbill.equals("0")) {%> 
								<%=RecordSet.getString("name")%>
							<%} else {%> 
								<%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> 
							<%}%>
						</option>
				<%}%>
				</select>
	    	</td>
	    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td>
	    	<td>
	    		<input type=hidden class=Inputstyle name=level_55  onfocus="changelevel(tmptype_55)" style="width:40%" value=0>
		    	<input type=hidden class=Inputstyle name=level2_55  onfocus="changelevel(tmptype_55)" style="width:40%" value=100>
		    	<input type=radio name=signorder_55 value="0" onfocus="changelevel(tmptype_55)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp
		    	<input type=radio name=signorder_55 value="1" checked  onfocus="changelevel(tmptype_55)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp
		        <input type=radio name=signorder_55 value="2" onfocus="changelevel(tmptype_55)"><%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>&nbsp;&nbsp
				<input type=radio name=signorder_55 value="3" onfocus="changelevel(tmptype_55)"><%=SystemEnv.getHtmlLabelName(21227,user.getLanguage())%>&nbsp;&nbsp
				<input type=radio name=signorder_55 value="4" onfocus="changelevel(tmptype_55)"><%=SystemEnv.getHtmlLabelName(21228,user.getLanguage())%>
	    	</td>
    	</tr>
    	

  	<tr class=dataDark >
  	<td><input type=radio onClick="setSelIndex('51','51')" name=tmptype id='tmptype_51' value=51><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_51 onfocus="changelevel(tmptype_51)" style="width:50%">
  	<%
  	       sql ="" ;

		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and (workflow_formdict.type=164 or workflow_formdict.type=169 or workflow_formdict.type=170) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 分部
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=164 or type=169 or type=170) and viewtype = 0" ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td>
    	<td><input type=text class=Inputstyle name=level_51  onfocus="changelevel(tmptype_51)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_51  onfocus="changelevel(tmptype_51)" style="width:40%" value=100><br>
    	<input type=radio name=signorder_51 value="0" onfocus="changelevel(tmptype_51)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp
    	<input type=radio name=signorder_51 value="1" checked  onfocus="changelevel(tmptype_51)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp
        <input type=radio name=signorder_51 value="2" onfocus="changelevel(tmptype_51)"><%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>&nbsp;&nbsp
    	</td>
    	</tr>


  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('43','43')" name=tmptype id='tmptype_43' value=43><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_43 onfocus="changelevel(tmptype_43)" style="width:50%">
  	<%
  	       sql ="" ;

		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 65 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 多角色
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=65 and viewtype = 0" ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td>
    	<input type=radio name=signorder_43 value="0" onfocus="changelevel(tmptype_43)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp
    	<input type=radio name=signorder_43 value="1" checked  onfocus="changelevel(tmptype_43)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp
    	</td>
    	</tr>

  	<tr class=dataDark >
  	<td><input type=radio onClick="setSelIndex('49','49')" name=tmptype id='tmptype_49' value=49><%=SystemEnv.getHtmlLabelName(19309,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_49 onfocus="changelevel(tmptype_49)" style="width:50%">
  	<%
		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 142  and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 收发文单位字段
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=142 and viewtype = 0" ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td>
        <input type=radio name=signorder_49 value="0" onfocus="changelevel(tmptype_49)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp
    	<input type=radio name=signorder_49 value="1" checked  onfocus="changelevel(tmptype_49)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp
    	</td>
    	</tr>
<tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('50','50')" name=tmptype id='tmptype_50' value=50><%=SystemEnv.getHtmlLabelName(20570,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_50 onfocus="changelevel(tmptype_50)" style="width:50%">
  	<%
  	       sql ="" ;

		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and ( workflow_formdict.type=160) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 角色人员
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=160) and viewtype = 0" ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
          <%if(!ajax.equals("1")){%>
      <button type=button  class=Browser onclick="onShowBrowserLevel('/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp','50',tmptype_50)"></button>
          <%}else{%>
      <button type=button  class=Browser onclick="onShowBrowser4opLevel('/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp','50',tmptype_50)"></button>
          <%}%>
      <input type="hidden" id="level_50" name="level_50" value="0">
          <span id="templevel_50" name="templevel_50"></span>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(22691,user.getLanguage())%>
			<select id="level2_50" name="level2_50" class="inputstyle" onfocus="changelevel(tmptype_50)">
				<option value="0"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
				<option value="1"><%=SystemEnv.getHtmlLabelName(22689,user.getLanguage())%></option>
				<option value="2"><%=SystemEnv.getHtmlLabelName(22690,user.getLanguage())%></option>
				<option value="3"><%=SystemEnv.getHtmlLabelName(22667,user.getLanguage())%></option>
			</select>
		</td>
		<td>
        <input type=radio name=signorder_50 value="0" onfocus="changelevel(tmptype_50)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp
    	<input type=radio name=signorder_50 value="1" checked  onfocus="changelevel(tmptype_50)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp
        <input type=radio name=signorder_50 value="2" onfocus="changelevel(tmptype_50)"><%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>&nbsp;&nbsp
    	</td>
    	</tr>
 </table>
</div>
<%-- 人力资源字段      end  --%>

<%-- 文档字段     start  --%>
<div id=odiv_3 style="display:none">
<table class=liststyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('10','8')" name=tmptype id='tmptype_10' value=8><%=SystemEnv.getHtmlLabelName(15564,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_10 style="width:50%" onfocus="changelevel(tmptype_10)">
  	<%
  	  sql ="" ;

		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 9 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=9 and viewtype = 0" ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td><input type=text class=Inputstyle   name=level_10 style="display:none">
    	</td>
    	</tr>
        <tr class=dataDark >
    	<td><input type=radio onClick="setSelIndex('11','33')" name=tmptype id='tmptype_11' value=33><%=SystemEnv.getHtmlLabelName(15565,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_11 onfocus="changelevel(tmptype_11)" style="width:50%">
  	<%

		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=level_11  onfocus="changelevel(tmptype_11)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=level2_11  onfocus="changelevel(tmptype_11)" style="width:40%" value=100>
    	</td>
    	</tr>
    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('12','9')" name=tmptype id='tmptype_12' value=9><%=SystemEnv.getHtmlLabelName(15566,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_12 onfocus="changelevel(tmptype_12)" style="width:50%">
  	<%

		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=level_12  onfocus="changelevel(tmptype_12)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=level2_12  onfocus="changelevel(tmptype_12)" style="width:40%" value=100>
    	</td>
    	</tr>
 </table>
</div>
<%-- 文档字段     end  --%>

<%-- 项目字段     start  --%>
<div id=odiv_4 style="display:none">
<table class=liststyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('13','10')" name=tmptype id='tmptype_13' value=10><%=SystemEnv.getHtmlLabelName(15567,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_13 style="width:50%" onfocus="changelevel(tmptype_13)">
  	<%
  	  sql ="" ;

		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 8 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=8 and viewtype = 0" ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td><input type=text class=Inputstyle   name=level_13 style="display:none">

    	</td>
    	</tr>


        <tr class=dataDark >
    	<td><input type=radio onClick="setSelIndex('47','47')" name=tmptype id='tmptype_47' value=47>项目字段经理的经理</td>
  	<td><select class=inputstyle  name=id_47 onfocus="changelevel(tmptype_47)" style="width:50%">
  	<%

		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td>
    	<input type=text class=Inputstyle name=level_47 style="display:none">

    	</td>
    	</tr>


        <tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('14','34')" name=tmptype id='tmptype_14' value=34><%=SystemEnv.getHtmlLabelName(15568,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_14 onfocus="changelevel(tmptype_14)" style="width:50%">
  	<%

		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=level_14  onfocus="changelevel(tmptype_14)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=level2_14  onfocus="changelevel(tmptype_14)" style="width:40%" value=100>
    	</td>
    	</tr>
    	<tr class=dataDark >
    	<td><input type=radio onClick="setSelIndex('15','11')" name=tmptype id='tmptype_15' value=11><%=SystemEnv.getHtmlLabelName(15569,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_15 onfocus="changelevel(tmptype_15)" style="width:50%">
  	<%

		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=level_15  onfocus="changelevel(tmptype_15)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=level2_15  onfocus="changelevel(tmptype_15)" style="width:40%" value=100>
    	</td>
    	</tr>
    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('16','12')" name=tmptype id='tmptype_16' value=12><%=SystemEnv.getHtmlLabelName(15570,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_16 onfocus="changelevel(tmptype_16)" style="width:50%">
  	<%

		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=level_16  onfocus="changelevel(tmptype_16)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=level2_16  onfocus="changelevel(tmptype_16)" style="width:40%" value=100>
    	</td>
    	</tr>


        <tr class=dataDark >
    	<td><input type=radio onClick="setSelIndex('48','48')" name=tmptype id='tmptype_48' value=48>会议室的管理员</td>
  	<td><select class=inputstyle  name=id_48 onfocus="changelevel(tmptype_48)" style="width:50%">
  	<%

          sql="";
		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 87 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=87 and viewtype = 0" ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><%=(isbill.equals("0"))?RecordSet.getString("name"):SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name"),0),user.getLanguage())%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td>
    	<input type=text class=Inputstyle name=level_48 style="display:none">

    	</td>
    	</tr>


 </table>
</div>
<%-- 项目字段     end  --%>

<%-- 资产字段     start  --%>
<div id=odiv_5 style="display:none">
<table class=liststyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('17','13')" name=tmptype id='tmptype_17' value=13><%=SystemEnv.getHtmlLabelName(15571,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_17 style="width:50%" onfocus="changelevel(tmptype_17)">
  	<%
  	  sql ="" ;

		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 23 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=23 and viewtype = 0" ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td>
    	<input type=text class=Inputstyle   name=level_17 style="display:none">
    	</td>
    	</tr>
        <tr class=dataDark >
    	<td><input type=radio onClick="setSelIndex('18','35')" name=tmptype id='tmptype_18' value=35><%=SystemEnv.getHtmlLabelName(15572,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_18 onfocus="changelevel(tmptype_18)" style="width:50%">
  	<%

		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=level_18  onfocus="changelevel(tmptype_18)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=level2_18  onfocus="changelevel(tmptype_18)" style="width:40%" value=100>
    	</td>
    	</tr>
    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('19','14')" name=tmptype id='tmptype_19' value=14><%=SystemEnv.getHtmlLabelName(15573,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_19 onfocus="changelevel(tmptype_19)" style="width:50%">
  	<%

		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=level_19  onfocus="changelevel(tmptype_19)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=level2_19  onfocus="changelevel(tmptype_19)" style="width:40%" value=100>
    	</td>
    	</tr>
 </table>
</div>
<%-- 资产字段     end  --%>

<%-- 客户字段     start  --%>
<div id=odiv_6 style="display:none">
<table class=liststyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('20','15')" name=tmptype id='tmptype_20' value=15><%=SystemEnv.getHtmlLabelName(15574,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_20 style="width:50%" onfocus="changelevel(tmptype_20)">
  	<%
  	  sql ="" ;

		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 7 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=7 and viewtype = 0" ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td>
    	<input type=text class=Inputstyle   name=level_20 style="display:none">
    	</td>
    	</tr>


  	<tr class=dataDark >
  	<td><input type=radio onClick="setSelIndex('44','44')" name=tmptype id='tmptype_44' value=44><%=SystemEnv.getHtmlLabelName(17204,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_44 style="width:50%" onfocus="changelevel(tmptype_44)">
  	<%
		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td>
    	<input type=text class=Inputstyle name=level_44 style="display:none">
    	</td>
    	</tr>

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('45','45')" name=tmptype id='tmptype_45' value=45>客户字段分部</td>
  	<td>
  	<select class=inputstyle  name=id_45 style="width:50%" onfocus="changelevel(tmptype_45)">
  	<%
		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_45  onfocus="changelevel(tmptype_45)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_45  onfocus="changelevel(tmptype_45)" style="width:40%" value=100>
    	</td>
    	</tr>

  	<tr class=dataDark >
  	<td><input type=radio onClick="setSelIndex('46','46')" name=tmptype id='tmptype_46' value=46>客户字段部门</td>
  	<td>
  	<select class=inputstyle  name=id_46 style="width:50%" onfocus="changelevel(tmptype_46)">
  	<%
		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_46  onfocus="changelevel(tmptype_46)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_46  onfocus="changelevel(tmptype_46)" style="width:40%" value=100>
    	</td>
    	</tr>





    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('21','16')" name=tmptype id='tmptype_21' value=16><%=SystemEnv.getHtmlLabelName(15575,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_21 onfocus="changelevel(tmptype_21)" style="width:50%">
  	<%

		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td><input type=text class=Inputstyle   name=level_21 style="display:none">
    	</td>
    	</tr>
 </table>
</div>
<%-- 客户字段     end  --%>

<%-- 创建人     start  --%>
<div id=odiv_7 style="display:none">
<table class=liststyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
        <COL width="35%">
        <COL width="10%">
        <COL width="35%">

        <tr class=datalight >   <%-- 创建人本人 --%>
        <td><input type=radio onClick="setSelIndex('22','17')" name=tmptype id='tmptype_22' value=17><%=SystemEnv.getHtmlLabelName(15079,user.getLanguage())%></td>
        <td>
    	<input type=text class=Inputstyle   name=id_22 style="display:none">
    	</td>
    	<td></td><td>
    	<input type=text class=Inputstyle   name=level_22 style="display:none">
    	</td>
    	</tr>
    	<tr class=dataDark >   <%-- 创建人经理 --%>
    	<td><input type=radio onClick="setSelIndex('23','18')" name=tmptype id='tmptype_23' value=18><%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%></td>
  	    <td>
    	<input type=text class=Inputstyle   name=id_23 style="display:none">
    	</td>
    	<td></td><td>
    	<input type=text class=Inputstyle   name=level_23 style="display:none">
    	</td>
    	</tr>
        <tr class=datalight >  <%-- 创建人下属  --%>
    	<td><input type=radio onClick="setSelIndex('24','36')" name=tmptype id='tmptype_24' value=36><%=SystemEnv.getHtmlLabelName(15576,user.getLanguage())%></td>
  	    <td>
    	<input type=text class=Inputstyle   name=id_24 style="display:none">
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=level_24  onfocus="changelevel(tmptype_24)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=level2_24  onfocus="changelevel(tmptype_24)" style="width:40%" value=100>
    	</td>
    	</tr>

        <tr class=dataDark >   <%-- 创建人本分部  --%>
    	<td><input type=radio onClick="setSelIndex('25','37')" name=tmptype id='tmptype_25' value=37><%=SystemEnv.getHtmlLabelName(15577,user.getLanguage())%></td>
  	    <td>
    	<input type=text class=Inputstyle   name=id_25 style="display:none">
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=level_25  onfocus="changelevel(tmptype_25)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=level2_25  onfocus="changelevel(tmptype_25)" style="width:40%" value=100>
    	</td>
    	</tr>

    	<tr class=datalight >   <%-- 创建人本部门  --%>
    	<td><input type=radio onClick="setSelIndex('26','19')" name=tmptype id='tmptype_26' value=19><%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%></td>
  	    <td>
    	<input type=text class=Inputstyle   name=id_26 style="display:none">
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=level_26  onfocus="changelevel(tmptype_26)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=level2_26  onfocus="changelevel(tmptype_26)" style="width:40%" value=100>
    	</td>
    	</tr>
        <tr class=dataDark >   <%-- 创建人上级部门  --%>
    	<td><input type=radio onClick="setSelIndex('39','39')" name=tmptype id='tmptype_39' value=39><%=SystemEnv.getHtmlLabelName(15578,user.getLanguage())%></td>
  	    <td>
    	<input type=text class=Inputstyle   name=id_39 style="display:none">
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=level_39  onfocus="changelevel(tmptype_39)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=level2_39  onfocus="changelevel(tmptype_39)" style="width:40%" value=100>
    	</td>
    	</tr>
 </table>
</div>
<%-- 创建人     end  --%>

<%-- 门户相关     start  --%>
<div id=odiv_8 style="display:none">
<table class=liststyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('27','20')" name=tmptype id='tmptype_27' value=20><%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_27 onfocus="changelevel(tmptype_27)" style="width:50%">
  	<%

		  RecordSet.executeProc("CRM_CustomerType_SelectAll","");
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><%=Util.toScreen(RecordSet.getString("fullname"),user.getLanguage())%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=level_27  onfocus="changelevel(tmptype_27)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=level2_27  onfocus="changelevel(tmptype_27)" style="width:40%" value=100>
    	</td>
    	</tr>
    	<tr class=dataDark >
    	<td><input type=radio onClick="setSelIndex('28','21')" name=tmptype id='tmptype_28' value=21><%=SystemEnv.getHtmlLabelName(15078,user.getLanguage())%></td>
           <%if(!ajax.equals("1")){%>
      <td><button type=button  class=Browser onclick="onShowBrowser('/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp','28',tmptype_28)"></button>
           <%}else{%>
      <td><button type=button  class=Browser onclick="onShowBrowser4op('/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp','28',tmptype_28)"></button>
           <%}%>
      <input type=hidden name=id_28 value=0>
          <span id=name_28 name=name_28></span>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=level_28  onfocus="changelevel(tmptype_28)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=level2_28  onfocus="changelevel(tmptype_28)" style="width:40%" value=100>
    	</td>
    	</tr>

    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('29','22')" name=tmptype id='tmptype_29' value=22><%=SystemEnv.getHtmlLabelName(15579,user.getLanguage())%></td>
  	<td>
          <%if(!ajax.equals("1")){%>
      <button type=button  class=Browser onclick="onShowBrowser('/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp','29',tmptype_29)"></button>
          <%}else{%>
      <button type=button  class=Browser onclick="onShowBrowser4op('/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp','29',tmptype_29)"></button>
          <%}%>
      <input type=hidden name=id_29 value=0>
          <span id=name_29 name=name_29></span>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=level_29  onfocus="changelevel(tmptype_29)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=level2_29  onfocus="changelevel(tmptype_29)" style="width:40%" value=100>
    	</td>
    	</tr>
    	<tr class=dataDark <%if(nodetype.equals("0")){%> style="display:none" <%}%>>
    	<td><input type=radio onClick="setSelIndex('30','23')" name=tmptype id='tmptype_30' value=23><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></td>
    	<td><select class=inputstyle  name=id_30 style="width:50%" onfocus="changelevel(tmptype_30)">
  	<%
  	 sql ="" ;
  	 if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and (workflow_formdict.type = 1 or workflow_formdict.type=17 or workflow_formdict.type=165 or workflow_formdict.type=166) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=1 or type=17 or type=165 or type=166) and viewtype = 0" ;

		  RecordSet.executeSql(sql);
		   while(RecordSet.next()){
		 %>
  	<option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=level_30  onfocus="changelevel(tmptype_30)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=level2_30  onfocus="changelevel(tmptype_30)" style="width:40%" value=100>
    	</td>
    	</tr>
    	<tr class=datalight <%if(nodetype.equals("0")){%> style="display:none" <%}%>>
    	<td><input type=radio onClick="setSelIndex('31','24')" name=tmptype id='tmptype_31' value=24><%=SystemEnv.getHtmlLabelName(15580,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_31 style="width:50%" onfocus="changelevel(tmptype_31)">
  	<%
  	  sql ="" ;

		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and (workflow_formdict.type = 7 or workflow_formdict.type = 18 ) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=7 or type=18) and viewtype = 0" ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><input type=text name=level_31 style="display:none"></td>
    <td>
    	<input type=radio name=signorder_31 value="0" onfocus="changelevel(tmptype_31)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp;
    	<input type=radio name=signorder_31 value="1" checked  onfocus="changelevel(tmptype_31)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp;
	</td>
    	</tr>

    	 <tr class=dataDark>
    	<td><input type=radio onClick="setSelIndex('32','25')" name=tmptype id='tmptype_32' value=25><%=SystemEnv.getHtmlLabelName(15581,user.getLanguage())%></td>
  	<td><input type=text class=Inputstyle   name=id_32 style="display:none">
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=level_32  onfocus="changelevel(tmptype_32)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=level2_32  onfocus="changelevel(tmptype_32)" style="width:40%" value=100>
    	</td>
    	</tr>
 </table>
</div>
<%-- 门户相关     end  --%>

<%-- 节点操作者     start  --%>
<div id=odiv_9 style="display:none">
<table class=liststyle cellspacing=1>
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">
  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('40','40')" name=tmptype id='tmptype_40' value=40><%=SystemEnv.getHtmlLabelName(18676,user.getLanguage())%></td>
  	<td>
  	<select name=id_40 onfocus="changelevel(tmptype_40)" style="width:50%">
        <%
        for(int i=0 ; i< nodeids.size() ; i++ ) {
            String tmpid = (String) nodeids.get(i);
            String tmpname = (String) nodenames.get(i);
            if(tmpid.equals(""+nodeid))
            {
            	continue;
            }
        %>
            <option value="<%=tmpid%>"><strong><%=tmpname%></strong>
        <%}%>
    </select>
    </td>
    <td><input type=text name=level_40 style="display:none"></td>
    <td>
    	<input type=radio name=signorder_40 value="0" onfocus="changelevel(tmptype_40)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp
    	<input type=radio name=signorder_40 value="1" checked  onfocus="changelevel(tmptype_40)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp
	</td>
    </tr>
    <tr class=dataDark >
    <td><input type=radio onClick="setSelIndex('41','41')" name=tmptype id='tmptype_41' value=41 ><%=SystemEnv.getHtmlLabelName(18677,user.getLanguage())%></td>
  	<td>
  	<select name=id_41 onfocus="changelevel(tmptype_41)" style="width:50%">
        <%
        for(int i=0 ; i< nodeids.size() ; i++ ) {
            String tmpid = (String) nodeids.get(i);
            String tmpname = (String) nodenames.get(i);
            if(tmpid.equals(""+nodeid))
            {
            	continue;
            }
        %>
            <option value="<%=tmpid%>"><strong><%=tmpname%></strong>
        <%}%>
    </select>
    </td>
    <td><input type=text name=level_41 style="display:none"></td>
    <td>
    	<input type=radio name=signorder_41 value="0" onfocus="changelevel(tmptype_41)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp
    	<input type=radio name=signorder_41 value="1" checked  onfocus="changelevel(tmptype_41)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp
	</td>
    </tr>
 </table>
</div>
<%-- 节点操作者    end  --%>

<%if (!nodetype.equals("0")){  %>
<table class="viewform" >
      	<COLGROUP>
  	<COL width="20%">
  	<COL width="40%">
  	<COL width="40%">
	 <TR class="Spacing">
    	  <TD class="Line1" colSpan=3></TD>
     </TR>
     <TR class="Title">
    	  <TH colSpan=3><b><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></b></TH></TR>
  	 <TR class="Spacing">
    	  <TD class="Line1" colSpan=3></TD></TR>
    	  <tr>
    	  <td colSpan=3>
    	  <table width=100%>
    	  <tr>
    	  <td width="80%"><%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>
           <%if(!ajax.equals("1")){%>
    	  <button type=button  class=Browser onclick="onShowBrowser4s('<%=wfid%>','<%=formid%>','<%=isbill%>')"></button>
    	  <%}else {%>
    	  <button type=button  class=Browser onclick="onShowBrowsers('<%=wfid%>','<%=formid%>','<%=isbill%>')"></button>
    	  <%}%>
    	  <input type=hidden name=conditionss id=conditionss>
    	  <input type=hidden name=conditioncn id=conditioncn>
    	  <input type=hidden name=fromsrc id=fromsrc value="2">
		  <span id="conditions">
		  
		   </span>
		   
    	  </td>
          <td width="20%"><%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())%>
              	<input type=text class=Inputstyle name=orders  onchange="check_number('orders');checkDigit(this,5,2)"  maxlength="5" style="width:40%"></td>
              	
    	  </tr></table></td>
    	  
    	  </tr>
    <tr>
        <td colspan="3">
            <table class="viewform" id="Tab_Coadjutant" name="Tab_Coadjutant" style="display:none">
                <input type=hidden name=IsCoadjutant id=IsCoadjutant>
              <input type=hidden name=signtype id=signtype>
              <input type=hidden name=issyscoadjutant id=issyscoadjutant>
              <input type=hidden name=coadjutants id=coadjutants>
              <input type=hidden name=coadjutantnames id=coadjutantnames>
              <input type=hidden name=issubmitdesc id=issubmitdesc>
              <input type=hidden name=ispending id=ispending>
              <input type=hidden name=isforward id=isforward>
              <input type=hidden name=ismodify id=ismodify>
              <input type=hidden name=Coadjutantconditions id=Coadjutantconditions>
      	<COLGROUP>
  	<COL width="20%">
  	<COL width="40%">
  	<COL width="40%">
          <TR class="Spacing">
    	  <TD class="Line" colSpan=3></TD></TR>
    	  <tr>
    	  <td colSpan=3><%=SystemEnv.getHtmlLabelName(22675,user.getLanguage())%>
              <button type=button  class=Browser onclick="onShowCoadjutantBrowser()"></button>
              <span id="Coadjutantconditionspan"></span>
    	  </td>

    	  </tr>
</table>
        </td>
    </tr>

</table>
<%}  else {  %>
<input type=hidden name=fromsrc id=fromsrc value="2">
<input type=hidden name=conditionss id=conditionss>
<input type=hidden name=conditioncn id=conditioncn>
<span id="conditions">
</span>
<input type=hidden name=orders  value=0>
<table class="viewform" id="Tab_Coadjutant" name="Tab_Coadjutant" style="display:none">
    <input type=hidden name=IsCoadjutant id=IsCoadjutant>
    <input type=hidden name=signtype id=signtype>
    <input type=hidden name=issyscoadjutant id=issyscoadjutant>
    <input type=hidden name=coadjutants id=coadjutants>
    <input type=hidden name=coadjutantnames id=coadjutantnames>
    <input type=hidden name=issubmitdesc id=issubmitdesc>
    <input type=hidden name=ispending id=ispending>
    <input type=hidden name=isforward id=isforward>
    <input type=hidden name=ismodify id=ismodify>
    <input type=hidden name=Coadjutantconditions id=Coadjutantconditions>
    <COLGROUP>
        <COL width="20%">
        <COL width="40%">
        <COL width="40%">
        <TR class="Spacing">
            <TD class="Line" colSpan=3></TD>
        </TR>
        <tr>
            <td colSpan=3><%=SystemEnv.getHtmlLabelName(22675, user.getLanguage())%>
                <button type=button  class=Browser onclick="onShowCoadjutantBrowser()"></button>
                <span id="Coadjutantconditionspan"></span>
            </td>

        </tr>
</table>
<%}  %>
<table class="viewform" >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">
  	<TR class="Spacing">
    	  <TD class="Line1" colSpan=4></TD></TR>
</table>
<%if(!ajax.equals("1")){%>
<button type=button  Class=Btn type=button accessKey=A onclick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(15582,user.getLanguage())%></BUTTON>
<button type=button  Class=Btn type=button accessKey=D onclick="if(isdel()){deleteRow();}"><U>D</U>-<%=SystemEnv.getHtmlLabelName(15583,user.getLanguage())%></BUTTON></div>
<%}else{%>
<button type=button  Class=Btn type=button accessKey=A onclick="addRow4op();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(15582,user.getLanguage())%></BUTTON>
<button type=button  Class=Btn type=button accessKey=D onclick="if(isdel()){deleteRow4op();}"><U>D</U>-<%=SystemEnv.getHtmlLabelName(15583,user.getLanguage())%></BUTTON></div>
<%}%>
<%}   %>
<table class="viewform" >
      	<COLGROUP>
  	<COL width="20%">
  	<COL width="80%">

</table>
<%if(!ajax.equals("1")){%>
<table class=liststyle cellspacing=1   cols=7 id="oTable">
<%}else{%>
<table class=liststyle cellspacing=1   cols=7 id="oTable4op">
<%}%>
      	<COLGROUP>
  	<COL width="4%">
  	<COL width="20%">
  	<COL width="10%">
  	<COL width="13%">
	<COL width="10%">
  	<COL width="36%">
  	<COL width="7%">
  	<tr class=header>
            <td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></td>
			<td><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(22671,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())%></td>
</tr>

<%

sql ="" ;

ArrayList ids = new ArrayList();
ArrayList names = new ArrayList();
ids.clear();
names.clear();

if(isbill.equals("0"))
  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
else
  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " " ;

RecordSet.executeSql(sql);
while(RecordSet.next()){
	ids.add(RecordSet.getString("id"));
    if(isbill.equals("0")) names.add(Util.null2String(RecordSet.getString("name")));
	else names.add(SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage()));
}


//the record in db
int colorcount=0;
RecordSet.executeProc("workflow_groupdetail_SByGroup",""+id);
String oldids="-1";
//System.out.println("id " + id);
int singerorder_flag=0;
String singerorder_type = "";
while(RecordSet.next()){
	int detailid = RecordSet.getInt("id");
	int type = RecordSet.getInt("type");
	int objid = RecordSet.getInt("objid");
	int level = RecordSet.getInt("level_n");
	int level2 = RecordSet.getInt("level2_n");
	String signorder = RecordSet.getString("signorder");

	String subcompanyids = Util.null2String(RecordSet.getString("subcompanyids"));
	ArrayList subcompanyidlist=Util.TokenizerString(subcompanyids,",");
	String showname="";
	if(signorder.equals("2")){
	    singerorder_flag++;
	    if("".equals(singerorder_type)){
	    	singerorder_type = ""+type;
	    }
	    for(int i=0;i<subcompanyidlist.size();i++){
	        if(showname.equals("")){
	            if(type==1) showname=DepartmentComInfo.getDepartmentname((String)subcompanyidlist.get(i));
	            if(type==30) showname=SubCompanyComInfo.getSubCompanyname((String)subcompanyidlist.get(i));
            }else{
                if(type==1) showname+=","+DepartmentComInfo.getDepartmentname((String)subcompanyidlist.get(i));
	            if(type==30) showname+=","+SubCompanyComInfo.getSubCompanyname((String)subcompanyidlist.get(i));
            }
        }
    }else{
       if(type==1) showname=DepartmentComInfo.getDepartmentname(""+objid);
	   if(type==30) showname=SubCompanyComInfo.getSubCompanyname(""+objid);
    }

    String showcondition="";
    String conditions=RecordSet.getString("conditions");
    String conditioncn=Util.null2String(RecordSet.getString("conditioncn"));
    String orders=RecordSet.getString("orders");
    if(!conditioncn.trim().equals("")){
        showcondition=SystemEnv.getHtmlLabelName(17892,user.getLanguage())+SystemEnv.getHtmlLabelName(15364,user.getLanguage())+":"+conditioncn;
    }
    String IsCoadjutant=Util.null2String(RecordSet.getString("IsCoadjutant"));
        String signtype=Util.null2String(RecordSet.getString("signtype"));
		String issyscoadjutant=Util.null2String(RecordSet.getString("issyscoadjutant"));
        String coadjutants=Util.null2String(RecordSet.getString("coadjutants"));
        String issubmitdesc=Util.null2String(RecordSet.getString("issubmitdesc"));
		String ispending=Util.null2String(RecordSet.getString("ispending"));
        String isforward=Util.null2String(RecordSet.getString("isforward"));
        String ismodify=Util.null2String(RecordSet.getString("ismodify"));
		String Coadjutantconditions=Util.null2String(RecordSet.getString("coadjutantcn"));
		if(!Coadjutantconditions.trim().equals("")){
		    if(!showcondition.trim().equals("")){
		        showcondition+="<br>";
            }
            showcondition+=SystemEnv.getHtmlLabelName(22675,user.getLanguage())+":"+Coadjutantconditions;
        }
	//System.out.println("detailid = " + detailid + " orders = " + orders);
    if(signorder.equals("3")||signorder.equals("4")) orders="";
	oldids=oldids+","+detailid;
if(colorcount==0){
		colorcount=1;
%>
<TR class=DataLight>
<%
	}else{
		colorcount=0;
%>
<TR class=DataDark>
	<%
	}
	%>
    <%if(!ajax.equals("1")){%>
<td height="23"><input type='checkbox' name='check_node' value="<%=detailid%>"  belongtype="<%=signorder%>">
    <%}else{%>
<td height="23"><input type='checkbox' name='check_node' value="<%=detailid%>" rowindex="<%=rowsum%>" belongtype="<%=signorder%>">
    <%}%>
<input type="hidden" name="group_<%=rowsum%>_type" size=25 value="<%=type%>">
<input type="hidden" name="group_<%=rowsum%>_id" size=25 value="<%=objid%>">
<input type="hidden" name="group_<%=rowsum%>_subcompanyids" size=25 value="<%=subcompanyids%>">        
<input type="hidden" name="group_<%=rowsum%>_level" size=25 value="<%=level%>">
<input type="hidden" name="group_<%=rowsum%>_level2" size=25 value="<%=level2%>">
<input type="hidden" name="group_<%=rowsum%>_signorder" size=25 value="<%=signorder%>">
<input type="hidden" name="group_<%=rowsum%>_condition" size=25 value="<%=conditions%>">
<input type="hidden" name="group_<%=rowsum%>_conditioncn" size=25 value="<%=conditioncn%>">
<%if (!nodetype.equals("0")){%>
<input type="hidden" name="group_<%=rowsum%>_orderold" size=25 value="<%=orders%>">
<%}else{%>
<input type="hidden" name="group_<%=rowsum%>_orderold" size=25 value="0">
<%}%>
<input type="hidden" name="group_<%=rowsum%>_oldid" size=25 value="<%=detailid%>">
<input type='hidden' name='group_<%=rowsum%>_Coadjutantconditions' value='<%=Coadjutantconditions%>'>
<input type='hidden' name='group_<%=rowsum%>_IsCoadjutant' value='<%=IsCoadjutant%>'>
<input type='hidden' name='group_<%=rowsum%>_signtype' value='<%=signtype%>'>
<input type='hidden' name='group_<%=rowsum%>_issyscoadjutant' value='<%=issyscoadjutant%>'>
<input type='hidden' name='group_<%=rowsum%>_coadjutants' value='<%=coadjutants%>'>
<input type='hidden' name='group_<%=rowsum%>_issubmitdesc' value='<%=issubmitdesc%>'>
<input type='hidden' name='group_<%=rowsum%>_ispending' value='<%=ispending%>'>
<input type='hidden' name='group_<%=rowsum%>_isforward' value='<%=isforward%>'>
<input type='hidden' name='group_<%=rowsum%>_ismodify' value='<%=ismodify%>'>        
</td>
<td height="23">
<%
String belongtypeStr = "";
if(nodetype.equals("0") && !signorder.equals("-1")){
	if(type==30 || type==1){//分部、部门
		if(signorder.equals("1")){
			belongtypeStr = " (" + SystemEnv.getHtmlLabelName(353,user.getLanguage()) + ")";
		}else if(signorder.equals("2")){
			belongtypeStr = " (" + SystemEnv.getHtmlLabelName(21473,user.getLanguage()) + ")";
		}
	}else if(type==2){//角色
		if(signorder.equals("1")){
			belongtypeStr = " (" + SystemEnv.getHtmlLabelName(346,user.getLanguage()) + ")";
		}else if(signorder.equals("2")){
			belongtypeStr = " (" + SystemEnv.getHtmlLabelName(15507,user.getLanguage()) + ")";
		}
	}
}
if(type==1)
{%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())+belongtypeStr%><%}
if(type==2)
	{%><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())+belongtypeStr%> <%}
if(type==3)
	{%><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%> <%}
if(type==4)
	{%><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%> <%}
if(type==5)
	{%><%=SystemEnv.getHtmlLabelName(15555,user.getLanguage())%> <%}
if(type==6)
	{%><%=SystemEnv.getHtmlLabelName(15559,user.getLanguage())%> <%}
if(type==7)
	{%><%=SystemEnv.getHtmlLabelName(15562,user.getLanguage())%> <%}
if(type==8)
	{%><%=SystemEnv.getHtmlLabelName(15564,user.getLanguage())%> <%}
if(type==9)
	{%><%=SystemEnv.getHtmlLabelName(15566,user.getLanguage())%> <%}
if(type==10)
	{%><%=SystemEnv.getHtmlLabelName(15567,user.getLanguage())%> <%}
if(type==11)
	{%><%=SystemEnv.getHtmlLabelName(15569,user.getLanguage())%> <%}
if(type==12)
	{%><%=SystemEnv.getHtmlLabelName(15570,user.getLanguage())%> <%}
if(type==13)
	{%><%=SystemEnv.getHtmlLabelName(15571,user.getLanguage())%> <%}
if(type==14)
	{%><%=SystemEnv.getHtmlLabelName(15573,user.getLanguage())%> <%}
if(type==15)
	{%><%=SystemEnv.getHtmlLabelName(15574,user.getLanguage())%> <%}
if(type==16)
	{%><%=SystemEnv.getHtmlLabelName(15575,user.getLanguage())%> <%}
if(type==17)
	{%><%=SystemEnv.getHtmlLabelName(15079,user.getLanguage())%> <%}
if(type==18)
	{%><%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%> <%}
if(type==19)
	{%><%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%> <%}
if(type==20)
	{%><%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%> <%}
if(type==21)
	{%><%=SystemEnv.getHtmlLabelName(15078,user.getLanguage())%> <%}
if(type==22)
	{%><%=SystemEnv.getHtmlLabelName(15579,user.getLanguage())%> <%}
if(type==23)
	{%><%=SystemEnv.getHtmlLabelName(2113,user.getLanguage())%> <%}
if(type==24)
	{%><%=SystemEnv.getHtmlLabelName(15580,user.getLanguage())%> <%}
if(type==25)
	{%><%=SystemEnv.getHtmlLabelName(15581,user.getLanguage())%> <%}
if(type==30)
{%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())+belongtypeStr%> <%}
if(type==31)
	{%><%=SystemEnv.getHtmlLabelName(15560,user.getLanguage())%> <%}
if(type==32)
	{%><%=SystemEnv.getHtmlLabelName(15561,user.getLanguage())%> <%}
if(type==33)
	{%><%=SystemEnv.getHtmlLabelName(15565,user.getLanguage())%> <%}
if(type==34)
	{%><%=SystemEnv.getHtmlLabelName(15568,user.getLanguage())%> <%}
if(type==35)
	{%><%=SystemEnv.getHtmlLabelName(15572,user.getLanguage())%> <%}
if(type==36)
	{%><%=SystemEnv.getHtmlLabelName(15576,user.getLanguage())%> <%}
if(type==37)
	{%><%=SystemEnv.getHtmlLabelName(15577,user.getLanguage())%> <%}
if(type==38)
	{%><%=SystemEnv.getHtmlLabelName(15563,user.getLanguage())%> <%}
if(type==39)
	{%><%=SystemEnv.getHtmlLabelName(15578,user.getLanguage())%> <%}
if(type==40)
	{%><%=SystemEnv.getHtmlLabelName(18676,user.getLanguage())%> <%}
if(type==41)
	{%><%=SystemEnv.getHtmlLabelName(18677,user.getLanguage())%> <%}
if(type==42)
	{%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%> <%}
if(type==43)
	{%><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%> <%}
if(type==44)
	{%><%=SystemEnv.getHtmlLabelName(17204,user.getLanguage())%> <%}
if(type==45)
	{%><%=SystemEnv.getHtmlLabelName(18678,user.getLanguage())%> <%}
if(type==46)
	{%><%=SystemEnv.getHtmlLabelName(18679,user.getLanguage())%><%}
if(type==47)
	{%><%=SystemEnv.getHtmlLabelName(18680,user.getLanguage())%> <%}
if(type==48)
	{%><%=SystemEnv.getHtmlLabelName(18681,user.getLanguage())%> <%}
if(type==49)
	{%><%=SystemEnv.getHtmlLabelName(19309,user.getLanguage())%> <%}
if(type==50)
	{%><%=SystemEnv.getHtmlLabelName(20570,user.getLanguage())%> <%}
if(type==51)
	{%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%> <%}
if(type==52)
	{%><%=SystemEnv.getHtmlLabelName(27107,user.getLanguage())%> <%}
if(type==53)
	{%><%=SystemEnv.getHtmlLabelName(27108,user.getLanguage())%> <%}
if(type==54)
	{%><%=SystemEnv.getHtmlLabelName(27109,user.getLanguage())%> <%}
if(type==55)
	{%><%=SystemEnv.getHtmlLabelName(27110,user.getLanguage())%> <%}
%>
</td>
<td  height="23">
<%
switch (type){
case 1:
case 22:
%>
<%="<a href='/hrm/company/HrmDepartmentDsp.jsp?id="+objid+"' target='_blank'>"+DepartmentComInfo.getDepartmentname(""+objid)+"</a>"%>
<%
break;
case 2:
RecordSet1.executeSql("select rolesmark from hrmroles where id = "+objid);
RecordSet1.next();
%>
<%=RecordSet1.getString(1)%>
<%
break;
case 3:

%>
<%="<a href='/hrm/resource/HrmResource.jsp?id="+objid+"' target='_blank'>"+ResourceComInfo.getResourcename(""+objid)+"</a>"%>
<%
break;
case 5:
case 49:
case 6:
case 7:
case 8:
case 9:
case 10:
case 11:
case 12:
case 13:
case 14:
case 15:
case 16:
case 23:
case 24:
case 31:
case 32:
case 33:
case 34:
case 35:
case 38:
case 42:
case 52:
case 53:
case 54:
case 55:
case 43:
case 44:
case 45:
case 46:
case 47:
case 48:
case 51:
	int index=ids.indexOf(""+objid);
	if(index!=-1){
%>
<%=names.get(index)%>
<%	}
break;
case 20:
%>
<%=Util.toScreen(CustomerTypeComInfo.getCustomerTypename(""+objid),user.getLanguage())%>
<%
break;
case 21:
%>
<%=Util.toScreen(CustomerStatusComInfo.getCustomerStatusname(""+objid),user.getLanguage())%>
<%
break;
case 30:
%>
<%="<a href='/hrm/company/HrmSubCompanyDsp.jsp?id="+objid+"' target='_blank'>"+SubCompanyComInfo.getSubCompanyname(""+objid)+"</a>"%>
<%
break;
case 40:
case 41:

    String nodename = "" ;
    int nodeidindex = nodeids.indexOf(""+objid) ;
    if( nodeidindex != -1 ) nodename = (String) nodenames.get(nodeidindex) ;
%>
<%=nodename%>
<%
break;
case 50:
int indexs=ids.indexOf(""+objid);
//System.out.print(indexs);
if(indexs!=-1){
%>
<%=names.get(indexs)%>/
<%	}%>
<%=RolesComInfo.getRolesRemark(""+level)%>
	<%
break;
}
%>

</td>
<td height="23">
<%
switch (type){
case 1:
case 4:
case 7:
case 9:
case 11:
case 12:
case 14:
case 19:
case 20:
case 21:
case 22:
case 23:
case 25:
case 30:
case 31:
case 32:
case 33:
case 34:
case 35:
case 36:
case 37:
case 38:
case 39:
case 45:
case 46:
case 42:
case 51:
%>
<%if(level2!=-1){%>
<%=level%>-<%=level2%>
<%}else{%>
>=<%=level%>
<%}%>
<%
break;
case 2:
 if(level==0){%>
<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
<%}else if(level==1){%>
<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
<%}else if(level==2){%>
<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
<%}else if(level==3){%>
<%=SystemEnv.getHtmlLabelName(22753,user.getLanguage())%>
<%}
break;
case 50:
{
	if(level2==1){
		out.print(SystemEnv.getHtmlLabelName(22689,user.getLanguage()));
	}else if(level2==2){
		out.print(SystemEnv.getHtmlLabelName(22690,user.getLanguage()));
	}else if(level2==3){
		out.print(SystemEnv.getHtmlLabelName(22667,user.getLanguage()));
	}else{
		out.print(SystemEnv.getHtmlLabelName(140,user.getLanguage()));
	}
	break;
}
}%>
</td>
<td><%
switch (type){	
case 5:
case 6:
case 31:
case 32:
case 7:
case 38:
case 42:
case 52:
case 53:
case 54:
case 55:
case 51:
case 43:
case 49:
case 50:
case 17:
case 18:
case 36:
case 37:
case 19:
case 39:
case 40:
case 41:


if(signorder.equals("0")){%>
 <%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>
 <% } else if(signorder.equals("1")){%>
 <%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>
 <%}else if(signorder.equals("2")){%>
 <%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>
 <%}else if(signorder.equals("3")){%>
 <%=SystemEnv.getHtmlLabelName(21227,user.getLanguage())%>
 <%}else if(signorder.equals("4")){%>
 <%=SystemEnv.getHtmlLabelName(21228,user.getLanguage())%>
 <%}
break;
}
%></td>
<td><%=showcondition%></td>
<td>
<%if(orders == null || "".equals(orders)){%>
<%=orders%>
<%}else{%>
	<%if (!nodetype.equals("0")){%>
		<input type='text' class='Inputstyle' name='group_<%=rowsum%>_order' value='<%=orders%>' onchange="check_number('group_<%=rowsum%>_order');checkDigit(this,5,2)"  maxlength="5" style='width:80%'>
	<%}else{%>
		0
	<%}%>
<%}%>
</td>
</tr>
<%
rowsum += 1;
}
oldids=oldids+",";
%>
<input type="hidden" name="oldids" size=25 value="<%=oldids%>">
<input type="hidden" name="singerorder_flag" id="singerorder_flag" value="<%=singerorder_flag%>">
<input type="hidden" name="singerorder_type" id="singerorder_type" value="<%=singerorder_type%>">
</table>
<BR>
<BR>
<BR>
<table class=ReportStyle>
<TBODY>
<TR><TD>
<B><%=SystemEnv.getHtmlLabelName(19010,user.getLanguage())%></B>:<BR>
<B><%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(19013,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(19012,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(19011,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(2084,user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(27761,user.getLanguage())%>
<BR>
</TD>
</TR>
</TBODY>
</table>
<%if(!ajax.equals("1")||design==1){%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>
<%
	if(design==1){
%>
		<jsp:include page="/workflow/workflow/editoperatorgroupScript.jsp" flush="true">
			<jsp:param name="nodetype" value="<%=nodetype%>" />
		</jsp:include>
<%		
	}
%>
</form>
</body>