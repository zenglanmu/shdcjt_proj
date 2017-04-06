<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<%
 String ajax=Util.null2String(request.getParameter("ajax"));
%>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
String needfav ="";
String needhelp ="";
int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);

int rowsum=0;
String isbill="0";
int formid=0;
String iscust="";
String sql ="select formid,isbill,iscust from workflow_base where id="+wfid ;
RecordSet.executeSql(sql);
if(RecordSet.next()){
    formid=Util.getIntValue(RecordSet.getString("formid"),0);
    isbill=Util.null2String(RecordSet.getString("isbill"));
    iscust=Util.null2String(RecordSet.getString("iscust"));
}
%>
</head>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>

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


<form id="wfurgerform" name="wfurgerform" method=post action="wfurger_operation.jsp" >
<%if(ajax.equals("1")){%>
<input type="hidden" name="ajax" value="1">
<%}%>
<input type="hidden" name="selectindex">
<input type="hidden" name="selectvalue">
<input type="hidden" value="<%=wfid%>" name="wfid">
<input type="hidden" value="editoperatorgroup" name="src">
<input type="hidden" value="0" name="groupnum">
<DIV class=BtnBar>

<%
    if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(this),_self} " ;
    else
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:wfurgersave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<table class="viewform" >
      	<COLGROUP>
  	<COL width="20%">
  	<COL width="40%">
  	<COL width="40%">
        <TR class="Title">
    	  <TH colSpan=3><%=SystemEnv.getHtmlLabelName(21219,user.getLanguage())%></TH></TR>
  	<TR class="Spacing" style="height:1px;">
    	  <TD class="Line1" colSpan=3></TD></TR>
    	  <tr>
    	  <td colSpan=3>
    	  <table width=100%>
    	  <tr>
    	  <td width=11%>
    	  <input type=radio  name=operategroup checked value=1 onclick="onChangetypeByUrger(this.value)"><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>
    	  </td>
    	  <td width=11%>
    	  <input type=radio  name=operategroup value=2 onclick="onChangetypeByUrger(this.value)"><%=SystemEnv.getHtmlLabelName(15549,user.getLanguage())%>
    	  </td><td width=11%>
    	  <input type=radio  name=operategroup value=3 onclick="onChangetypeByUrger(this.value)"><%=SystemEnv.getHtmlLabelName(15550,user.getLanguage())%>
    	  </td><td width=11%>
    	  <input type=radio  name=operategroup value=4 onclick="onChangetypeByUrger(this.value)"><%=SystemEnv.getHtmlLabelName(15551,user.getLanguage())%>
    	  </td><td width=11%>
    	  <input type=radio  name=operategroup value=5 onclick="onChangetypeByUrger(this.value)"><%=SystemEnv.getHtmlLabelName(15552,user.getLanguage())%> </td>
            <td width=11%>
    	  <input type=radio  name=operategroup value=6 onclick="onChangetypeByUrger(this.value)"><%=SystemEnv.getHtmlLabelName(15553,user.getLanguage())%>
    	  </td><td width=11%>
    	  <input type=radio  name=operategroup value=7 onclick="onChangetypeByUrger(this.value)"><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%>
    	  </td>
    	  </tr></table></td>
    	  </tr>
</table>
<div id=odiv_urger_1 style="display:''">
<table class=liststyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">
    <!-- 新增加分部 liuyu-->
     <tr class=datalight >
  	<td><input type=radio onClick="setSelIndexByUrger('0','30')" name=tmptype id='tmptype_0' value=30><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
  	<td>
          <%if(!ajax.equals("1")){%>
      <button type="button"  class=Browser onclick="onShowBrowser('/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp','0',tmptype_0)"></button>
          <%}else{%>
      <button type="button"  class=Browser onclick="onShowBrowserByUrger('/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp','0',tmptype_0,wfurgerform)"></button>
          <%}%>
      <input type=hidden name=wfid_0>
          <span id=wfname_0 name=wfname_0></span>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=wflevel_0 onfocus="changelevelByUrger(tmptype_0)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_0 onfocus="changelevelByUrger(tmptype_0)" style="width:40%" value=100>
    	</td>
    	</tr>
  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndexByUrger('1','1')" name=tmptype id='tmptype_1' value=1><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  	<td>
          <%if(!ajax.equals("1")){%>
      <button type="button"  class=Browser onclick="onShowBrowser('/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp','1',tmptype_1)"></button>
          <%}else{%>
      <button type="button"  class=Browser onclick="onShowBrowserByUrger('/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp','1',tmptype_1,wfurgerform)"></button>
          <%}%>
      <input type=hidden name=wfid_1 value=0>
          <span id=wfname_1 name=wfname_1></span>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=wflevel_1 onfocus="changelevelByUrger(tmptype_1)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_1 onfocus="changelevelByUrger(tmptype_1)" style="width:40%" value=100>
    	</td>
    	</tr>
    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('2','2')" name=tmptype id='tmptype_2' value=2><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></td>
  	<td>
          <%if(!ajax.equals("1")){%>
      <button type="button"  class=Browser onclick="onShowBrowser('/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp','2',tmptype_2)"></button>
          <%}else{%>
      <button type="button"  class=Browser onclick="onShowBrowserByUrger('/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp','2',tmptype_2,wfurgerform)"></button>
          <%}%>
      <input type=hidden name=wfid_2 value=0>
          <span id=wfname_2 name=wfname_2></span>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></td><td>
    	<select class=inputstyle  name=wflevel_2  onfocus="changelevelByUrger(tmptype_2)" style="width:80%">
	    	<option value=0 ><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
	      <option value=1 ><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
	      <option value=2 ><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
      </select>
    	</td>
    	</tr>

    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('3','3')" name=tmptype id='tmptype_3' value=3><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
  	<td>
          <%if(!ajax.equals("1")){%>
      <button type="button"  class=Browser onclick="onShowBrowserM('/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp','3',tmptype_3)"></button>
          <%}else{%>
      <button type="button"  class=Browser onclick="onShowBrowserByUrgerM('/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp','3',tmptype_3,wfurgerform)"></button>
          <%}%>
      <input type=hidden name=wfid_3 value=0>
          <span id=wfname_3 name=wfname_3></span>
    	</td>
    	<td></td><td>
    	<input type=text class=Inputstyle   name=wflevel_3 style="display:none">
    	</td>
    	</tr>
    	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndexByUrger('4','4')" name=tmptype id='tmptype_4' value=4 ><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></td>
  	<td>
  	<input type=text class=Inputstyle   name=wfid_4 style="display:none">
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=wflevel_4  onfocus="changelevelByUrger(tmptype_4)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_4  onfocus="changelevelByUrger(tmptype_4)" style="width:40%" value=100>
    	</td>
    	</tr>

 </table>
</div>

<div id=odiv_urger_2 style="display:none">
<table class=liststyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndexByUrger('5','5')" name=tmptype id='tmptype_5' value=5><%=SystemEnv.getHtmlLabelName(15555,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=wfid_5 onfocus="changelevelByUrger(tmptype_5)" style="width:50%">
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
    	<td></td>
    	<td></td>
    	</tr>
    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('6','6')" name=tmptype id='tmptype_6' value=6 ><%=SystemEnv.getHtmlLabelName(15559,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=wfid_6 onfocus="changelevelByUrger(tmptype_6)" style="width:50%">
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
    	<input type=text class=Inputstyle   name=wflevel_6 style="display:none">

    	</td>
    	</tr>

        <tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('7','31')" name=tmptype id='tmptype_7' value=31><%=SystemEnv.getHtmlLabelName(15560,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=wfid_7 onfocus="changelevelByUrger(tmptype_7)" style="width:50%">
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
    	<input type=text class=Inputstyle   name=wflevel_7  onfocus="changelevelByUrger(tmptype_7)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_7  onfocus="changelevelByUrger(tmptype_7)" style="width:40%" value=100>
    	</td>
    	</tr>


          <tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('8','32')" name=tmptype id='tmptype_8' value=32><%=SystemEnv.getHtmlLabelName(15561,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=wfid_8 onfocus="changelevelByUrger(tmptype_8)" style="width:50%">
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
    	<input type=text class=Inputstyle   name=wflevel_8  onfocus="changelevelByUrger(tmptype_8)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_8  onfocus="changelevelByUrger(tmptype_8)" style="width:40%" value=100>
    	</td>
    	</tr>

    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('9','7')" name=tmptype id='tmptype_9' value=7><%=SystemEnv.getHtmlLabelName(15562,user.getLanguage())%></td>
        <td><select class=inputstyle  name=wfid_9 onfocus="changelevelByUrger(tmptype_9)" style="width:50%">
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
    	<input type=text class=Inputstyle   name=wflevel_9  onfocus="changelevelByUrger(tmptype_9)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_9  onfocus="changelevelByUrger(tmptype_9)" style="width:40%" value=100>
    	</td>
    	</tr>

        <tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('38','38')" name=tmptype id='tmptype_38' value=38><%=SystemEnv.getHtmlLabelName(15563,user.getLanguage())%></td>
  	    <td><select class=inputstyle  name=wfid_38 onfocus="changelevelByUrger(tmptype_38)" style="width:50%">
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
    	<input type=text class=Inputstyle   name=wflevel_38  onfocus="changelevelByUrger(tmptype_38)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_38  onfocus="changelevelByUrger(tmptype_38)" style="width:40%" value=100>
    	</td>
    	</tr>

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndexByUrger('42','42')" name=tmptype id='tmptype_42' value=42><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=wfid_42 onfocus="changelevelByUrger(tmptype_42)" style="width:50%">
  	<%
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
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td><input type=text class=Inputstyle name=wflevel_42  onfocus="changelevelByUrger(tmptype_42)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=wflevel2_42  onfocus="changelevelByUrger(tmptype_42)" style="width:40%" value=100>
    	</td>
    	</tr>


  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndexByUrger('43','43')" name=tmptype id='tmptype_43' value=43><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=wfid_43 onfocus="changelevelByUrger(tmptype_43)" style="width:50%">
  	<%
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
    	<td></td>
    	<td></td>
    	</tr>

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndexByUrger('49','49')" name=tmptype id='tmptype_49' value=49><%=SystemEnv.getHtmlLabelName(19309,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=wfid_49 onfocus="changelevelByUrger(tmptype_49)" style="width:50%">
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
    	<td></td>
    	<td></td>
    	</tr>
 </table>
</div>

<div id=odiv_urger_3 style="display:none">
<table class=liststyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndexByUrger('10','8')" name=tmptype id='tmptype_10' value=8><%=SystemEnv.getHtmlLabelName(15564,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=wfid_10 style="width:50%" onfocus="changelevelByUrger(tmptype_10)">
  	<%
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
    	<td></td><td><input type=text class=Inputstyle   name=wflevel_10 style="display:none">
    	</td>
    	</tr>
        <tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('11','33')" name=tmptype id='tmptype_11' value=33><%=SystemEnv.getHtmlLabelName(15565,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=wfid_11 onfocus="changelevelByUrger(tmptype_11)" style="width:50%">
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
    	<input type=text class=Inputstyle   name=wflevel_11  onfocus="changelevelByUrger(tmptype_11)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_11  onfocus="changelevelByUrger(tmptype_11)" style="width:40%" value=100>
    	</td>
    	</tr>
    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('12','9')" name=tmptype id='tmptype_12' value=9><%=SystemEnv.getHtmlLabelName(15566,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=wfid_12 onfocus="changelevelByUrger(tmptype_12)" style="width:50%">
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
    	<input type=text class=Inputstyle   name=wflevel_12  onfocus="changelevelByUrger(tmptype_12)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_12  onfocus="changelevelByUrger(tmptype_12)" style="width:40%" value=100>
    	</td>
    	</tr>
 </table>
</div>


<div id=odiv_urger_4 style="display:none">
<table class=liststyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndexByUrger('13','10')" name=tmptype id='tmptype_13' value=10><%=SystemEnv.getHtmlLabelName(15567,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=wfid_13 style="width:50%" onfocus="changelevelByUrger(tmptype_13)">
  	<%
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
    	<td></td><td><input type=text class=Inputstyle   name=wflevel_13 style="display:none">

    	</td>
    	</tr>


        <tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('47','47')" name=tmptype id='tmptype_47' value=47>项目字段经理的经理</td>
  	<td><select class=inputstyle  name=wfid_47 onfocus="changelevelByUrger(tmptype_47)" style="width:50%">
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
    	<input type=text class=Inputstyle name=wflevel_47 style="display:none">

    	</td>
    	</tr>


        <tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('14','34')" name=tmptype id='tmptype_14' value=34><%=SystemEnv.getHtmlLabelName(15568,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=wfid_14 onfocus="changelevelByUrger(tmptype_14)" style="width:50%">
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
    	<input type=text class=Inputstyle   name=wflevel_14  onfocus="changelevelByUrger(tmptype_14)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_14  onfocus="changelevelByUrger(tmptype_14)" style="width:40%" value=100>
    	</td>
    	</tr>
    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('15','11')" name=tmptype id='tmptype_15' value=11><%=SystemEnv.getHtmlLabelName(15569,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=wfid_15 onfocus="changelevelByUrger(tmptype_15)" style="width:50%">
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
    	<input type=text class=Inputstyle   name=wflevel_15  onfocus="changelevelByUrger(tmptype_15)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_15  onfocus="changelevelByUrger(tmptype_15)" style="width:40%" value=100>
    	</td>
    	</tr>
    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('16','12')" name=tmptype id='tmptype_16' value=12><%=SystemEnv.getHtmlLabelName(15570,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=wfid_16 onfocus="changelevelByUrger(tmptype_16)" style="width:50%">
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
    	<input type=text class=Inputstyle   name=wflevel_16  onfocus="changelevelByUrger(tmptype_16)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_16  onfocus="changelevelByUrger(tmptype_16)" style="width:40%" value=100>
    	</td>
    	</tr>


        <tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('48','48')" name=tmptype id='tmptype_48' value=48>会议室的管理员</td>
  	<td><select class=inputstyle  name=wfid_48 onfocus="changelevelByUrger(tmptype_48)" style="width:50%">
  	<%
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
    	<input type=text class=Inputstyle name=wflevel_48 style="display:none">

    	</td>
    	</tr>


 </table>
</div>

<div id=odiv_urger_5 style="display:none">
<table class=liststyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndexByUrger('17','13')" name=tmptype id='tmptype_17' value=13><%=SystemEnv.getHtmlLabelName(15571,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=wfid_17 style="width:50%" onfocus="changelevelByUrger(tmptype_17)">
  	<%
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
    	<input type=text class=Inputstyle   name=wflevel_17 style="display:none">
    	</td>
    	</tr>
        <tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('18','35')" name=tmptype id='tmptype_18' value=35><%=SystemEnv.getHtmlLabelName(15572,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=wfid_18 onfocus="changelevelByUrger(tmptype_18)" style="width:50%">
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
    	<input type=text class=Inputstyle   name=wflevel_18  onfocus="changelevelByUrger(tmptype_18)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_18  onfocus="changelevelByUrger(tmptype_18)" style="width:40%" value=100>
    	</td>
    	</tr>
    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('19','14')" name=tmptype id='tmptype_19' value=14><%=SystemEnv.getHtmlLabelName(15573,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=wfid_19 onfocus="changelevelByUrger(tmptype_19)" style="width:50%">
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
    	<input type=text class=Inputstyle   name=wflevel_19  onfocus="changelevelByUrger(tmptype_19)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_19  onfocus="changelevelByUrger(tmptype_19)" style="width:40%" value=100>
    	</td>
    	</tr>
 </table>
</div>

<div id=odiv_urger_6 style="display:none">
<table class=liststyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndexByUrger('20','15')" name=tmptype id='tmptype_20' value=15><%=SystemEnv.getHtmlLabelName(15574,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=wfid_20 style="width:50%" onfocus="changelevelByUrger(tmptype_20)">
  	<%
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
    	<input type=text class=Inputstyle   name=wflevel_20 style="display:none">
    	</td>
    	</tr>


  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndexByUrger('44','44')" name=tmptype id='tmptype_44' value=44><%=SystemEnv.getHtmlLabelName(17204,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=wfid_44 style="width:50%" onfocus="changelevelByUrger(tmptype_44)">
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
    	<input type=text class=Inputstyle name=wflevel_44 style="display:none">
    	</td>
    	</tr>

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndexByUrger('45','45')" name=tmptype id='tmptype_45' value=45>客户字段分部</td>
  	<td>
  	<select class=inputstyle  name=wfid_45 style="width:50%" onfocus="changelevelByUrger(tmptype_45)">
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
    	<input type=text class=Inputstyle name=wflevel_45  onfocus="changelevelByUrger(tmptype_45)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=wflevel2_45  onfocus="changelevelByUrger(tmptype_45)" style="width:40%" value=100>
    	</td>
    	</tr>

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndexByUrger('46','46')" name=tmptype id='tmptype_46' value=46>客户字段部门</td>
  	<td>
  	<select class=inputstyle  name=wfid_46 style="width:50%" onfocus="changelevelByUrger(tmptype_46)">
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
    	<input type=text class=Inputstyle name=wflevel_46  onfocus="changelevelByUrger(tmptype_46)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=wflevel2_46  onfocus="changelevelByUrger(tmptype_46)" style="width:40%" value=100>
    	</td>
    	</tr>





    	<!--tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('21','16')" name=tmptype id='tmptype_21' value=16><%=SystemEnv.getHtmlLabelName(15575,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=wfid_21 onfocus="changelevelByUrger(tmptype_21)" style="width:50%">
  	<%

		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td><input type=text class=Inputstyle   name=wflevel_21 style="display:none">
    	</td>
    	</tr-->
 </table>
</div>

<div id=odiv_urger_7 style="display:none">
<table class=liststyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
        <COL width="35%">
        <COL width="10%">
        <COL width="35%">

        <tr class=datalight >
        <td><input type=radio onClick="setSelIndexByUrger('22','17')" name=tmptype id='tmptype_22' value=17><%=SystemEnv.getHtmlLabelName(15079,user.getLanguage())%></td>
        <td>
    	<input type=text class=Inputstyle   name=wfid_22 style="display:none">
    	</td>
    	<td></td><td>
    	<input type=text class=Inputstyle   name=wflevel_22 style="display:none">
    	</td>
    	</tr>
    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('23','18')" name=tmptype id='tmptype_23' value=18><%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%></td>
  	    <td>
    	<input type=text class=Inputstyle   name=wfid_23 style="display:none">
    	</td>
    	<td></td><td>
    	<input type=text class=Inputstyle   name=wflevel_23 style="display:none">
    	</td>
    	</tr>
        <tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('24','36')" name=tmptype id='tmptype_24' value=36><%=SystemEnv.getHtmlLabelName(15576,user.getLanguage())%></td>
  	    <td>
    	<input type=text class=Inputstyle   name=wfid_24 style="display:none">
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=wflevel_24  onfocus="changelevelByUrger(tmptype_24)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_24  onfocus="changelevelByUrger(tmptype_24)" style="width:40%" value=100>
    	</td>
    	</tr>

        <tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('25','37')" name=tmptype id='tmptype_25' value=37><%=SystemEnv.getHtmlLabelName(15577,user.getLanguage())%></td>
  	    <td>
    	<input type=text class=Inputstyle   name=wfid_25 style="display:none">
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=wflevel_25  onfocus="changelevelByUrger(tmptype_25)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_25  onfocus="changelevelByUrger(tmptype_25)" style="width:40%" value=100>
    	</td>
    	</tr>

    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('26','19')" name=tmptype id='tmptype_26' value=19><%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%></td>
  	    <td>
    	<input type=text class=Inputstyle   name=wfid_26 style="display:none">
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=wflevel_26  onfocus="changelevelByUrger(tmptype_26)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_26  onfocus="changelevelByUrger(tmptype_26)" style="width:40%" value=100>
    	</td>
    	</tr>
        <tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('39','39')" name=tmptype id='tmptype_39' value=39><%=SystemEnv.getHtmlLabelName(15578,user.getLanguage())%></td>
  	    <td>
    	<input type=text class=Inputstyle   name=wfid_39 style="display:none">
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=wflevel_39  onfocus="changelevelByUrger(tmptype_39)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_39  onfocus="changelevelByUrger(tmptype_39)" style="width:40%" value=100>
    	</td>
    	</tr>
 </table>
</div>


<div id=odiv_urger_8 style="display:none">
<table class=liststyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndexByUrger('27','20')" name=tmptype id='tmptype_27' value=20><%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=wfid_27 onfocus="changelevelByUrger(tmptype_27)" style="width:50%">
  	<%

		  RecordSet.executeProc("CRM_CustomerType_SelectAll","");
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><%=Util.toScreen(RecordSet.getString("fullname"),user.getLanguage())%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=wflevel_27  onfocus="changelevelByUrger(tmptype_27)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_27  onfocus="changelevelByUrger(tmptype_27)" style="width:40%" value=100>
    	</td>
    	</tr>
    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('28','21')" name=tmptype id='tmptype_28' value=21><%=SystemEnv.getHtmlLabelName(15078,user.getLanguage())%></td>
           <%if(!ajax.equals("1")){%>
      <td><button type="button"  class=Browser onclick="onShowBrowser('/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp','28',tmptype_28)"></button>
           <%}else{%>
      <td><button type="button"  class=Browser onclick="onShowBrowserByUrger('/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp','28',tmptype_28,wfurgerform)"></button>
           <%}%>
      <input type=hidden name=wfid_28 value=0>
          <span id=wfname_28 name=wfname_28></span>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=wflevel_28  onfocus="changelevelByUrger(tmptype_28)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_28  onfocus="changelevelByUrger(tmptype_28)" style="width:40%" value=100>
    	</td>
    	</tr>

    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('29','22')" name=tmptype id='tmptype_29' value=22><%=SystemEnv.getHtmlLabelName(15579,user.getLanguage())%></td>
  	<td>
          <%if(!ajax.equals("1")){%>
      <button type="button"  class=Browser onclick="onShowBrowser('/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp','29',tmptype_29)"></button>
          <%}else{%>
      <button type="button"  class=Browser onclick="onShowBrowserByUrger('/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp','29',tmptype_29,wfurgerform)"></button>
          <%}%>
      <input type=hidden name=wfid_29 value=0>
          <span id=wfname_29 name=wfname_29></span>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=wflevel_29  onfocus="changelevelByUrger(tmptype_29)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_29  onfocus="changelevelByUrger(tmptype_29)" style="width:40%" value=100>
    	</td>
    	</tr>
    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('30','23')" name=tmptype id='tmptype_30' value=23><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></td>
    	<td><select class=inputstyle  name=wfid_30 style="width:50%" onfocus="changelevelByUrger(tmptype_30)">
  	<%
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
    	<input type=text class=Inputstyle   name=wflevel_30  onfocus="changelevelByUrger(tmptype_30)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_30  onfocus="changelevelByUrger(tmptype_30)" style="width:40%" value=100>
    	</td>
    	</tr>
    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndexByUrger('31','24')" name=tmptype id='tmptype_31' value=24><%=SystemEnv.getHtmlLabelName(15580,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=wfid_31 style="width:50%" onfocus="changelevelByUrger(tmptype_31)">
  	<%
		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and (workflow_formdict.type = 7 or workflow_formdict.type = 18 ) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
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
    	<input type=hidden name=wflevel_31 style="width:80%" value=0>
    	</td>
    	</tr>

    	 <tr class=datalight>
    	<td><input type=radio onClick="setSelIndexByUrger('32','25')" name=tmptype id='tmptype_32' value=25><%=SystemEnv.getHtmlLabelName(15581,user.getLanguage())%></td>
  	<td><input type=text class=Inputstyle   name=wfid_32 style="display:none">
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle   name=wflevel_32  onfocus="changelevelByUrger(tmptype_32)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle   name=wflevel2_32  onfocus="changelevelByUrger(tmptype_32)" style="width:40%" value=100>
    	</td>
    	</tr>
 </table>
</div>
<table class="viewform" >
      	<COLGROUP>
  	<COL width="20%">
  	<COL width="40%">
  	<COL width="40%">
  	<TR class="Spacing" style="height:1px;">
    	  <TD class="Line1" colSpan=3></TD></TR>
        <TR class="Title">
    	  <TH colSpan=3><%=SystemEnv.getHtmlLabelName(21219,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></TH></TR>
  	<TR class="Spacing" style="height:1px;">
    	  <TD class="Line1" colSpan=3></TD></TR>
    	  <tr>
    	  <td colSpan=3>
    	  <table width=100%>
    	  <tr>
    	  <td width="80%"><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>
           <%if(!ajax.equals("1")){%>
    	  <button type="button"  class=Browser onclick="onShowBrowser4s('<%=wfid%>','<%=formid%>','<%=isbill%>')"></button>
    	  <%}else {%>
    	  <button type="button"  class=Browser onclick="onShowBrowsersByWFU('<%=wfid%>','<%=formid%>','<%=isbill%>')"></button>
    	  <%}%>
    	  <input type=hidden name=wfconditionss id=wfconditionss>
    	  <input type=hidden name=wfconditioncn id=wfconditioncn>
    	  <input type=hidden name=wffromsrc id=wffromsrc value="2">
		  <span id="wfconditions">
		  
		   </span>
		   
    	  </td>
              	
    	  </tr></table></td>
    	  
    	  </tr>
</table>

<table class="viewform" >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">
  	<TR class="Spacing" style="height:1px;">
    	  <TD class="Line1" colSpan=4></TD></TR>
</table>
<%if(!ajax.equals("1")){%>
<BUTTON Class=Btn type=button accessKey=A onclick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(15582,user.getLanguage())%></BUTTON>
<BUTTON Class=Btn type=button accessKey=D onclick="if(isdel()){deleteRow();}"><U>D</U>-<%=SystemEnv.getHtmlLabelName(15583,user.getLanguage())%></BUTTON></div>
<%}else{%>
<BUTTON Class=Btn type=button accessKey=A onclick="addRowByUrger();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(15582,user.getLanguage())%></BUTTON>
<BUTTON Class=Btn type=button accessKey=D onclick="if(isdel()){deleteRowByUrger();}"><U>D</U>-<%=SystemEnv.getHtmlLabelName(15583,user.getLanguage())%></BUTTON></div>
<%}%>
<table class="viewform" >
      	<COLGROUP>
  	<COL width="20%">
  	<COL width="80%">

</table>
<%if(!ajax.equals("1")){%>
<table class=liststyle cellspacing=1   cols=5 id="oTable">
<%}else{%>
<table class=liststyle cellspacing=1   cols=5 id="oTableByUrger">
<%}%>
      	<COLGROUP>
  	<COL width="10%">
  	<COL width="20%">
  	<COL width="10%">
  	<COL width="15%">
  	<COL width="30%">
  	<tr class=header>
            <td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></td>
</tr><tr class="line" style="height:1px;"><td colspan="6"></td></tr>

<%
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
RecordSet.executeSql("select * from workflow_urgerdetail where workflowid="+wfid+" order by id");
String oldids="-1";
while(RecordSet.next()){
	int detailid = RecordSet.getInt("id");
	int type = RecordSet.getInt("utype");
	int objid = RecordSet.getInt("objid");
	int level = RecordSet.getInt("level_n");
	int level2 = RecordSet.getInt("level2_n");

    String conditions=RecordSet.getString("conditions");
    String conditioncn=RecordSet.getString("conditioncn");
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
<td height="23"><input type='checkbox' name='wfcheck_node' value="<%=detailid%>" >
    <%}else{%>
<td height="23"><input type='checkbox' name='wfcheck_node' value="<%=detailid%>" rowindex=<%=rowsum%>>
    <%}%>
<input type="hidden" name="group_<%=rowsum%>_type" size=25 value="<%=type%>">
<input type="hidden" name="group_<%=rowsum%>_id" size=25 value="<%=objid%>">
<input type="hidden" name="group_<%=rowsum%>_level" size=25 value="<%=level%>">
<input type="hidden" name="group_<%=rowsum%>_level2" size=25 value="<%=level2%>">
<input type="hidden" name="group_<%=rowsum%>_condition" size=25 value="<%=conditions%>">
<input type="hidden" name="group_<%=rowsum%>_conditioncn" size=25 value="<%=conditioncn%>">
<input type="hidden" name="group_<%=rowsum%>_oldid" size=25 value="<%=detailid%>">
</td>
<td height="23">
<%
if(type==1)
{%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><%}
if(type==2)
	{%><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%> <%}
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
    {%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%> <%}
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
case 43:
case 44:
case 45:
case 46:
case 47:
case 48:
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
case 50:
int indexs=ids.indexOf(""+objid);
//System.out.print(indexs);
if(indexs!=-1){
%>
<%=names.get(indexs)%>/
<%	}%>
<%=RolesComInfo.getRolesname(""+level)%>
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
<%}
break;

}%>
</td>
<td><%=conditioncn%></td>
</tr>

<%
rowsum += 1;
}
oldids=oldids+",";
%>
<input type="hidden" name="oldids" size=25 value="<%=oldids%>">

</table>

<%if(!ajax.equals("1")){%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>
<%if(!ajax.equals("1")){%>

<script type="text/javascript">
<!--

function onChangetypeByUrger(objval){
	if (objval==1){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if (objval==2 ){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if (objval==3) {
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if (objval==4 ){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if(objval==5){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if (objval==6){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if (objval==7){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
	if (objval==8){
		$("#odiv_urger_1").css("display","none");
		$("#odiv_urger_2").css("display","none");
		$("#odiv_urger_3").css("display","none");
		$("#odiv_urger_4").css("display","none");
		$("#odiv_urger_5").css("display","none");
		$("#odiv_urger_6").css("display","none");
		$("#odiv_urger_7").css("display","none");
		$("#odiv_urger_8").css("display","none");
	}
}
//-->
</script>
<script language=vbs>


sub onShowBrowser(url,index,tmpindex)
	tmpid = "wfid_"&index
	tmpname = "wfname_"&index
	id = window.showModalDialog(url)
	if NOT isempty(id) then
	        if id(0)<> "" then
			document.all(tmpname).innerHtml = id(1)
			document.all(tmpid).value=id(0)
			tmpindex.checked = true
            tmpid = tmpindex.id
            document.wfurgerform.selectindex.value = Mid(tmpid,9,len(tmpid))
            document.wfurgerform.selectvalue.value = tmpindex.value
		else
			document.all(tmpname).innerHtml = empty
			document.all(tmpid).value="0"
		end if
	end if
end sub
sub onShowBrowserLevel(url,index,tmpindex)
	tmpid = "wflevel_"&index
	tmpname = "tempwflevel_"&index
	id = window.showModalDialog(url)
	if NOT isempty(id) then
	        if id(0)<> "" then
			document.all(tmpname).innerHtml = id(1)
			document.all(tmpid).value=id(0)
			tmpindex.checked = true
            tmpid = tmpindex.id
            document.wfurgerform.selectindex.value = Mid(tmpid,9,len(tmpid))
            document.wfurgerform.selectvalue.value = tmpindex.value
		else
			document.all(tmpname).innerHtml = empty
			document.all(tmpid).value="0"
		end if
	end if
end sub
sub onShowBrowserM(url,index,tmpindex)
	tmpid = "wfid_"&index
	tmpname = "wfname_"&index
	id = window.showModalDialog(url)
	if NOT isempty(id) then
	        if id(0)<> "" then
			document.all(tmpname).innerHtml = mid(id(1),2,len(id(1)))
			document.all(tmpid).value=mid(id(0),2,len(id(0)))
			tmpindex.checked = true
            tmpid = tmpindex.id
            document.wfurgerform.selectindex.value = Mid(tmpid,9,len(tmpid))
            document.wfurgerform.selectvalue.value = tmpindex.value
		else
			document.all(tmpname).innerHtml = empty
			document.all(tmpid).value="0"
		end if
	end if
end sub
sub onShowBrowser4s(wfid,formid,isbill)
    
	src=document.all("wffromsrc").value
	url = "BrowserMain.jsp?url=OperatorCondition.jsp?fromsrc="+src+"&formid="+formid+"&isbill="+isbill
	id = window.showModalDialog(url)
	if NOT isempty(id) then
	        if id(0)<> "" then
            'document.all("wfconditions").innerHTML="<img src=\"/images/BacoCheck.gif\" width=\"16\" height=\"16\" border=\"0\">"
			document.all("wfconditionss").value=id(0)
			document.all("wfconditions").innerHTML=id(1)
			document.all("wfconditioncn").value=id(1)
			document.all("wffromsrc").value="2"
		    else
			document.all("wfconditionss").value=""
			document.all("wfconditioncn").value=""
		   end if
	end if
    
end sub
sub changelevelByUrger(tmpindex)
		tmpindex.checked = true
        tmpid = tmpindex.id
        document.wfurgerform.selectindex.value = Mid(tmpid,9,len(tmpid))
        document.wfurgerform.selectvalue.value = tmpindex.value
end sub
</script>
<script language="JavaScript" src="/js/addRowBg.js" >
</script>
<script language=javascript>
var rowColor="" ;
rowindex = <%=rowsum%>;

function setSelIndexByUrger(selindex, selectvalue) {
    document.wfurgerform.selectindex.value = selindex ;
    document.wfurgerform.selectvalue.value = selectvalue ;
}

function addRow()
{		
	for(i=0;i<50;i++){
		if(document.wfurgerform.selectindex.value == i){
			switch (i) {
            case 0:
			case 1:
			case 2:
			case 7:
			case 8:
			case 9:
			case 11:
			case 12:
			case 14:
			case 15:
			case 16:
			case 18:
			case 19:
			case 27:
			case 28:
			case 29:
			case 30:
            case 38:
            case 45:
            case 46:
				if(document.all("wfid_"+i).value ==0 || document.all("wflevel_"+i).value ==''){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 3:
			case 5:
			case 49:
			case 6:
			case 10:
			case 13:
			case 17:
			case 20:
			case 21:
			case 31:
			case 40:
			case 41:
			case 42:
			case 43:
			case 44:
			case 47:
			case 48:
				if(document.all("wfid_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 4:
            case 24:
			case 25:
			case 26:
			case 32:

				if(document.all("wflevel_"+i).value ==''){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			}
            var hrmids,hrmnames; 
			var k=1;
            if (i==3)  //多人力资源
			{
			var stmps = document.all("wfid_"+i).value;
			hrmids=stmps.split(",");
			var sHtmls = document.all("wfname_"+i).innerHTML;
			hrmnames=sHtmls.split(",");
			k=hrmids.length;
			}
			for (m=0;m<k;m++)
			{
			rowColor = getRowBg();
			ncol = oTable.cols;
			oRow = oTable.insertRow();
			for(j=0; j<ncol; j++) {
				oCell = oRow.insertCell();
				oCell.style.height=24;
				oCell.style.background= rowColor;
				switch(j) {
					case 0:
						var oDiv = document.createElement("div");
						var sHtml = "<input type='checkbox' name='wfcheck_node' value='0'>";
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
					case 1:
						var oDiv = document.createElement("div");
						var sHtml="";

						if(i==0)
							sHtml="<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>";
						if(i== 1 )
							sHtml="<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>";
						if(i== 2 )
							sHtml="<%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>";
						if(i== 3 )
							sHtml="<%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>";
						if(i== 4 )
							sHtml="<%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%>";
						if(i== 5 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15555,user.getLanguage())%>";
						if(i== 6 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15559,user.getLanguage())%>";
						if(i== 7 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15560,user.getLanguage())%>";
						if(i== 8 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15561,user.getLanguage())%>";
						if(i== 9 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15562,user.getLanguage())%>";
						if(i== 10 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15564,user.getLanguage())%>";
						if(i== 11 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15565,user.getLanguage())%>";
						if(i== 12 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15566,user.getLanguage())%>";
						if(i== 13 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15567,user.getLanguage())%>";
						if(i== 14 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15568,user.getLanguage())%>";
						if(i== 15 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15569,user.getLanguage())%>";
						if(i== 16 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15570,user.getLanguage())%>";
						if(i== 17 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15571,user.getLanguage())%>";
						if(i== 18 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15572,user.getLanguage())%>";
						if(i== 19 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15573,user.getLanguage())%>";
						if(i== 20 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15574,user.getLanguage())%>";
						if(i== 21 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15575,user.getLanguage())%>";
						if(i== 22 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15079,user.getLanguage())%>";
						if(i== 23 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%>";
						if(i== 24 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15576,user.getLanguage())%>";
						if(i== 25 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15577,user.getLanguage())%>";
						if(i== 26 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%>";
						if(i== 27 )
							sHtml="<%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%>";
						if(i== 28 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15078,user.getLanguage())%>";
						if(i== 29 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15579,user.getLanguage())%>";
						if(i== 30 )
							sHtml="<%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%>";
						if(i== 31 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15580,user.getLanguage())%>";
						if(i== 32 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15581,user.getLanguage())%>";
						if(i== 38 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15563,user.getLanguage())%>";
                        if(i== 39 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15578,user.getLanguage())%>";
                        if(i== 40 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18676,user.getLanguage())%>";
                        if(i== 41 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18677,user.getLanguage())%>";
                        if(i== 42 )
							sHtml="<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>";
                        if(i== 43 )
							sHtml="<%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>";
                        if(i== 44 )
							sHtml="<%=SystemEnv.getHtmlLabelName(17204,user.getLanguage())%>";
                        if(i== 45 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18678,user.getLanguage())%>";
                        if(i== 46 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18679,user.getLanguage())%>";
                        if(i== 47 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18680,user.getLanguage())%>";
                        if(i== 48 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18681,user.getLanguage())%>";
                        if(i== 49 )
							sHtml="<%=SystemEnv.getHtmlLabelName(19309,user.getLanguage())%>";

						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);

                        var rowtypevalue = document.wfurgerform.selectvalue.value ;
						var oDiv1 = document.createElement("div");
						var sHtml1 = "<input type='hidden' name='group_"+rowindex+"_type'  value='"+rowtypevalue+"'>";
						oDiv1.innerHTML = sHtml1;
						oCell.appendChild(oDiv1);
						break;
					case 2:
						if (i==3)
						var stmp=""+hrmids[m];
					    else
						var stmp = document.all("wfid_"+i).value;

						var oDiv = document.createElement("div");
						var sHtml = "";
						if(i>= 5 && i <= 21 || i == 27 || i == 31 || i == 30 || i==38 || i== 40 || i == 41|| i == 42|| i == 43|| i == 44|| i == 45|| i == 46|| i == 47|| i == 48|| i == 49){
							var srcList = document.all("wfid_"+i);
							for (var count = srcList.options.length - 1; count >= 0; count--) {
								if(srcList.options[count].value==stmp)
									sHtml = srcList.options[count].text;
							}
						}
						else if(i== 4 || i== 22 || i== 23 || i==24 || i== 25 || i== 26  || i== 32 || i == 39){
							sHtml = stmp;
						}
						else
							{
							if (i==3)
							sHtml=hrmnames[m];
							else
							sHtml = document.all("wfname_"+i).innerHTML;
						  }
                        
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);

						var oDiv2= document.createElement("div");
                         var stemp=stmp;
						var sHtml1 = "<input type='hidden'  name='group_"+rowindex+"_id' value='"+stmp+"'>";
						oDiv2.innerHTML = sHtml1;
						oCell.appendChild(oDiv2);
						break;
					case 3:
						var oDiv = document.createElement("div");

						var sval = "";
						var sval2 = "";
						var sHtml="";
						if(i == 0 || i == 1 || i == 4 || i == 7 || i == 8 || i == 9 || i == 11 || i == 12 || i== 14 || i == 15 || i == 16 || i == 18 || i == 19 || i == 24 || i == 25 || i == 26 || i == 27 || i == 28 || i == 29 || i == 30 || i == 32 || i == 38 || i == 39 || i == 45 || i == 46){
							sval=document.all("wflevel_"+i).value;
							sval2 = document.all("wflevel2_"+i).value;
                            if(sval2!=""){
							    sHtml = sval+" - " + sval2;
                            }else{
                                sHtml = ">= "+sval;
                            }
						}
						if(i == 2 ){
							sval=document.all("wflevel_"+i).value;
							if(sval==0)
								sHtml="<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>";
							if(sval==1)
								sHtml="<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>";
							if(sval==2)
								sHtml="<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>";
						}

						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);

						var oDiv3= document.createElement("div");
                        var sHtml1 = "<input type='hidden' size='32' name='group_"+rowindex+"_level'  value='"+sval+"'>";
                        if(sval2!=""){
                            sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex+"_level2'  value='"+sval2+"'>";
                        }else{
                            sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex+"_level2'  value='-1'>";
                        }
						oDiv3.innerHTML = sHtml1;
						oCell.appendChild(oDiv3);
                        break;
                    case 4:
						var oDiv = document.createElement("div");
						var sval = document.all("wfconditionss").value;
						var sval1 = document.all("wfconditioncn").value;
						while (sval.indexOf("'")>0)
						{
						sval=sval.replace("'","’");
						}
						while (sval1.indexOf("'")>0)
						{
						sval1=sval1.replace("'","’");
						}
						var sHtml="<input type='hidden' name='group_"+rowindex+"_condition' value='"+sval+"'>";
						sHtml+=document.all("wfconditioncn").value;
						sHtml+="<input type='hidden' name='group_"+rowindex+"_conditioncn' value='"+sval1+"'>";
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
				}
			}
			rowindex = rowindex*1 +1;
			}
			document.all("wffromsrc").value="1";
			document.all("wfconditionss").value="";
			document.all("wfconditioncn").value="";
			document.all("wfconditions").innerHTML="";
			
			return;
		}
	}
	alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");

}

function deleteRow()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='wfcheck_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='wfcheck_node'){
			if(document.forms[0].elements[i].checked==true) {
				oTable.deleteRow(rowsum1+1);
			}
			rowsum1 -=1;
		}

	}
}

function selectall(this){
    for(var i=0; i<=rowindex; i++){
        if(document.all("group_"+i+"level")){
            alert(document.all("group_"+i+"level").value);
        }
    }
	document.forms[0].groupnum.value=rowindex;
	window.document.forms[0].submit();
    obj.disabled=true;
}

function ondelete(obj){
    if (isdel()) {
    obj.disabled=true;
    document.forms[0].src.value="delgroups";
    window.document.forms[0].submit();
  }
}
</script>
<%}%>


</form>
</body>