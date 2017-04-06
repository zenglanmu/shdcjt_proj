<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo1" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DocComInfo1" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="crmComInfo1" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="FormModeBrowserClause" class="weaver.formmode.browser.FormModeBrowserClause" scope="session" />
<jsp:useBean id="FormModeTransMethod" class="weaver.formmode.search.FormModeTransMethod" scope="page"/>
<jsp:useBean id="ModeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>

</head>
<%
String userid = Util.null2String((String)session.getAttribute("RequestViewResource")) ;
String logintype = ""+user.getLogintype();    
int usertype = 0;
if(userid.equals("")) {
	userid = ""+user.getUID();
	if(logintype.equals("2")) usertype= 1;
}
String browsertype=Util.null2String(request.getParameter("browsertype"));
Browser browser=(Browser)StaticObj.getServiceByFullname(browsertype, Browser.class);
String href = Util.null2String(browser.getHref());

String createrid=Util.null2String(request.getParameter("createrid"));
String docids=Util.null2String(request.getParameter("docids"));
String crmids=Util.null2String(request.getParameter("crmids"));
String hrmids=Util.null2String(request.getParameter("hrmids"));
String prjids=Util.null2String(request.getParameter("prjids"));
String creatertype=Util.null2String(request.getParameter("creatertype"));
String workflowid=""+Util.getIntValue(request.getParameter("workflowid"));
String nodetype=Util.null2String(request.getParameter("nodetype"));
String fromdate=Util.null2String(request.getParameter("fromdate"));
String todate=Util.null2String(request.getParameter("todate"));
String lastfromdate=Util.null2String(request.getParameter("lastfromdate"));
String lasttodate=Util.null2String(request.getParameter("lasttodate"));
String requestmark=Util.null2String(request.getParameter("requestmark"));
String branchid=Util.null2String(request.getParameter("branchid"));
int during=Util.getIntValue(request.getParameter("during"),0);
int order=Util.getIntValue(request.getParameter("order"),0);
int isdeleted=Util.getIntValue(request.getParameter("isdeleted"));
String requestname=Util.fromScreen2(request.getParameter("requestname"),user.getLanguage());
requestname=requestname.trim();
int subday1=Util.getIntValue(request.getParameter("subday1"),0);
int subday2=Util.getIntValue(request.getParameter("subday2"),0);
int maxday=Util.getIntValue(request.getParameter("maxday"),0);
int state=Util.getIntValue(request.getParameter("state"),0);
String requestlevel=Util.fromScreen(request.getParameter("requestlevel"),user.getLanguage());
String customid=Util.null2String(request.getParameter("customid"));
boolean issimple=Util.null2String(request.getParameter("issimple")).equals("true")?true:false;
issimple = true;
String searchtype=Util.null2String(request.getParameter("searchtype"));
int isresearch=Util.getIntValue(request.getParameter("isresearch"),0);
Hashtable conht=new Hashtable();    
if(isresearch==1){
	conht=(Hashtable)session.getAttribute("conhashtable_"+userid);    
}else{
	FormModeBrowserClause.resetFormModeSearchClause();
}
String isbill="1";
String formID="0";
String customname="";
String workflowname="";
String titlename ="";
rs.execute("select a.modeid,a.customname,a.customdesc,b.modename,b.formid from mode_custombrowser a,modeinfo b where a.modeid = b.id and a.id="+customid);
if(rs.next()){
    formID=Util.null2String(rs.getString("formid"));
    customname=Util.null2String(rs.getString("customname"));
    titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+customname;
}
String imagefilename = "/images/hdDOC.gif";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;

//RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.frmmain.reset(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<form name="frmmain" method="post" action="/formmode/browser/CustomBrowserTemp.jsp">
<input name=customid type=hidden value="<%=customid%>">
<input name=issimple type=hidden value="<%=issimple%>">
<input name=searchtype type=hidden value="<%=searchtype%>">
<input name=browsertype type=hidden value="<%=browsertype%>">

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


<table class="viewform">
  <colgroup>
  <col width="10%">
  <col width="39%">
  <col width="8">
  <col width="10%">
  <col width="39%">
  <tbody>
  <%if(!issimple){
	  
  }else{%>
  <TR style="height:1px;" class=Separartor><TD class="Line1" COLSPAN=5></TD></TR>
  <%}%>
   <input type='checkbox' name='check_con' style="display:none">
<%//以下开始列出自定义查询条件
String sql="";
if(RecordSet.getDBType().equals("oracle")){
    sql = "select * from (select mode_CustombrowserDspField.queryorder ,mode_CustombrowserDspField.showorder ,workflow_billfield.id as id,workflow_billfield.fieldname as name,to_char(workflow_billfield.fieldlabel) as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.fieldhtmltype as httype, workflow_billfield.type as type from workflow_billfield,mode_CustombrowserDspField,mode_custombrowser where mode_CustombrowserDspField.customid=mode_custombrowser.id and mode_custombrowser.id="+customid+" and mode_CustombrowserDspField.isquery='1' and workflow_billfield.billid='"+formID+"' and workflow_billfield.id=mode_CustombrowserDspField.fieldid ";
}else{
    sql = "select * from (select mode_CustombrowserDspField.queryorder ,mode_CustombrowserDspField.showorder ,workflow_billfield.id as id,workflow_billfield.fieldname as name,convert(varchar,workflow_billfield.fieldlabel) as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.fieldhtmltype as httype, workflow_billfield.type as type from workflow_billfield,mode_CustombrowserDspField,mode_custombrowser where mode_CustombrowserDspField.customid=mode_custombrowser.id and mode_custombrowser.id="+customid+" and mode_CustombrowserDspField.isquery='1' and workflow_billfield.billid='"+formID+"' and workflow_billfield.id=mode_CustombrowserDspField.fieldid ";
}
    sql+=" union select queryorder,showorder,fieldid as id,'' as name,'' as label,'' as dbtype,'' as httype,0 as type from mode_CustombrowserDspField where isquery='1' and fieldid in(-1,-2,-3,-4,-5,-6,-7,-8,-9) and customid="+customid;
    sql+=") a order by a.queryorder,a.showorder,a.id";
int i=0;
int tmpcount = 0;
RecordSet.execute(sql);
//out.print(sql);
while (RecordSet.next())
{tmpcount++;
i++;
String name = RecordSet.getString("name");
String label = RecordSet.getString("label");
String htmltype = RecordSet.getString("httype");
String type = RecordSet.getString("type");
String id = RecordSet.getString("id");
String dbtype = Util.null2String(RecordSet.getString("dbtype"));
label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
/*
 初始化创建日期   -1
 创建人           -2
*/
if(id.equals("-1")){
    id="_3";
    name="modedatacreatedate";
    label=SystemEnv.getHtmlLabelName(722,user.getLanguage());
    htmltype="3";
    type="2";
}else if(id.equals("-2")){
    id="_4";
    name="modedatacreater";
    label=SystemEnv.getHtmlLabelName(882,user.getLanguage());
    htmltype="3";
    type="17";
}
String display="display:'';";
if(issimple) display="display:none;";
String checkstr="";
if("1".equals(conht.get("con_"+id))) checkstr="checked";
String tmpvalue="";
String tmpvalue1="";
String tmpname="";
if(isresearch==1){
    tmpvalue=Util.null2String((String)conht.get("con_"+id+"_value"));
    tmpvalue1=Util.null2String((String)conht.get("con_"+id+"_value1"));
    tmpname=Util.null2String((String)conht.get("con_"+id+"_name"));
}
%>
<input type=hidden name="con<%=id%>_htmltype" value="<%=htmltype%>">
<input type=hidden name="con<%=id%>_type" value="<%=type%>">
<input type=hidden name="con<%=id%>_colname" value="<%=name%>">

<%if (i%2 !=0) {%><tr><%}%>
<td><input type='checkbox' name='check_con' title="<%=SystemEnv.getHtmlLabelName(20778,user.getLanguage())%>" value="<%=id%>" style="display:none" <%=checkstr%>> <%=label%></td>
<%
if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){  //文本框
    int tmpopt=3;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),3);
%>
<td class=field>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<%if(!htmltype.equals("2")){//TD9319 屏蔽掉多行文本框的“等于”和“不等于”操作，text数据库类型不支持该判断%>
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>     <!--等于-->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>   <!--不等于-->
<%}%>
<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>   <!--包含-->
<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>   <!--不包含-->

</select>
<input type=text class=InputStyle style="width:50%" name="con<%=id%>_value"   onblur="changelevel(this,'<%=tmpcount%>')" value="<%=tmpvalue%>">
<SPAN id=remind style='cursor:hand' title='搜索提示&#10;1.输入"上海泛微"表示查询符合"上海泛微"的记录&#10;2.输入"上海 泛微"表示查询符合"上海"或者符合"泛微"的记录&#10;3.输入"上海+泛微"表示查询符合"上海"并且符合"泛微"的记录'>
<IMG src='/images/remind.png' align=absMiddle>
</SPAN>    
</td>
<%}
else if(htmltype.equals("1")&& !type.equals("1")){  //数字   <!--大于,大于或等于,小于,小于或等于,等于,不等于-->
    int tmpopt=2;
    int tmpopt1=4;
    if(isresearch==1) {
        tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),2);
        tmpopt1=Util.getIntValue((String)conht.get("con_"+id+"_opt1"),4);
    }
%>
<td class=field>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%><%}%>
<input type=text class=InputStyle size=10 name="con<%=id%>_value" onblur="checknumber('con<%=id%>_value');changelevel1(this,$G('con<%=id%>_value1'),'<%=tmpcount%>')" value="<%=tmpvalue%>">
<select class=inputstyle  name="con<%=id%>_opt1" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt1==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if(tmpopt1==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if(tmpopt1==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if(tmpopt1==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if(tmpopt1==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if(tmpopt1==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%><%}%>
<input type=text class=InputStyle size=10 name="con<%=id%>_value1"  onblur="checknumber('con<%=id%>_value1');changelevel1(this,$G('con<%=id%>_value'),'<%=tmpcount%>')" value="<%=tmpvalue1%>">
</td>
<%
}
else if(htmltype.equals("4")){   //check类型
%>
<td class=field >
<input type=checkbox value=1 name="con<%=id%>_value"  onchange="changelevel(this,'<%=tmpcount%>')" <%if(tmpvalue.equals("1")){%>checked<%}%>>

</td>
<%}
else if(htmltype.equals("5")){  //选择框
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>

<td class=field>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>

<select class=inputstyle  name="con<%=id%>_value"  onchange="changelevel(this,'<%=tmpcount%>')" >
<option value="" ></option>
<%
char flag=2;
if(id.equals("_6")){
%>
    <option value="0" <%if (nodetype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></option>
    <option value="1" <%if (nodetype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option>
    <option value="2" <%if (nodetype.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%></option>
    <option value="3" <%if (nodetype.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
<%
}else if(id.equals("_2")){
%>
    <option value="0" <%if (requestlevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
	<option value="1" <%if (requestlevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
	<option value="2" <%if (requestlevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>
<%
}else if(id.equals("_8")){
%>
    <option value="0" <%if (isdeleted==0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage())%></option>
    <option value="1" <%if (isdeleted==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
    <option value="2" <%if (isdeleted==2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
<%
}else{
rs.executeProc("workflow_SelectItemSelectByid",""+id+flag+isbill);
while(rs.next()){
	int tmpselectvalue = rs.getInt("selectvalue");
	String tmpselectname = rs.getString("selectname");
%>
<option value="<%=tmpselectvalue%>" <%if (tmpvalue.equals(""+tmpselectvalue)) {%>selected<%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
<%}
}%>
</select>
</td>

<%} else if(htmltype.equals("3") && type.equals("1")){//浏览框单人力资源  条件为多人力 (like not lik)
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90">
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp','<%=type%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>

</td>
<%} else if(htmltype.equals("3") && type.equals("9")){//浏览框单文挡  条件为多文挡 (like not lik)
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp','<%=type%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>

</td>
<%} else if(htmltype.equals("3") && type.equals("4")){//浏览框单部门  条件为多部门 (like not lik)
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp','<%=type%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>

</td>
	<%} else if(htmltype.equals("3") && type.equals("7")){//浏览框单客户  条件为多客户 (like not lik)
        int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp','<%=type%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>

</td>
<%} else if(htmltype.equals("3") && type.equals("8")){//浏览框单项目  条件为多项目 (like not lik)
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp','<%=type%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>

</td>
<%} else if(htmltype.equals("3") && type.equals("16")){//浏览框单请求  条件为多请求 (like not lik)
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option>
</select>

<button type=button  class=Browser onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp','<%=type%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>

</td>
<%}else if(htmltype.equals("3") && type.equals("24")){//职位的安全级别
    int tmpopt=1;
    int tmpopt1=3;
    if(isresearch==1) {
        tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
        tmpopt1=Util.getIntValue((String)conht.get("con_"+id+"_opt1"),3);
    }
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%><%}%>
<input type=text class=InputStyle size=10 name="con<%=id%>_value"  onblur="changelevel1(this,$G('con<%=id%>_value1'),'<%=tmpcount%>')"  value="<%=tmpvalue%>">
<select class=inputstyle  name="con<%=id%>_opt1" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt1==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if(tmpopt1==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if(tmpopt1==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if(tmpopt1==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if(tmpopt1==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if(tmpopt1==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%><%}%>
<input type=text class=InputStyle size=10 name="con<%=id%>_value1"  onblur="changelevel1(this,$G('con<%=id%>_value'),'<%=tmpcount%>')"  value="<%=tmpvalue1%>" >
</td>
<%}//职位安全级别end

else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){    //日期
    int tmpopt=2;
    int tmpopt1=4;
    if(isresearch==1) {
        tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),2);
        tmpopt1=Util.getIntValue((String)conht.get("con_"+id+"_opt1"),4);
    }
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90">
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%><%}%>
<button type=button  class=calendar
<%if(type.equals("2")){%>
 onclick="onSearchWFQTDate(con<%=id%>_valuespan,con<%=id%>_value,con<%=id%>_value1,'<%=tmpcount%>')"
<%}else{%>
 onclick ="onSearchWFQTTime(con<%=id%>_valuespan,con<%=id%>_value,con<%=id%>_value1,'<%=tmpcount%>')"
<%}%>
 ></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpvalue%></span>
<select class=inputstyle  name="con<%=id%>_opt1" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt1==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
<option value="2" <%if(tmpopt1==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
<option value="3" <%if(tmpopt1==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
<option value="4" <%if(tmpopt1==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
<option value="5" <%if(tmpopt1==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="6" <%if(tmpopt1==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%><%}%>
<button type=button  class=calendar
<%if(type.equals("2")){%>
 onclick="onSearchWFQTDate(con<%=id%>_value1span,con<%=id%>_value1,con<%=id%>_value,'<%=tmpcount%>')"
<%}else{%>
 onclick ="onSearchWFQTTime(con<%=id%>_value1span,con<%=id%>_value1,con<%=id%>_value,'<%=tmpcount%>')"
<%}%>
 ></button>
<input type=hidden name="con<%=id%>_value1" value="<%=tmpvalue1%>">
<span name="con<%=id%>_value1span" id="con<%=id%>_value1span"><%=tmpvalue1%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("17")){
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("37")){//浏览框  多选筐条件为单选筐(多文挡)
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("57")){//浏览框  多选筐条件为单选筐（多部门）
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("135")){//浏览框  多选筐条件为单选筐（多项目 ）
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("152")){//浏览框  多选筐条件为单选筐（多请求 ）
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("18")){//浏览框  多选筐条件为单选筐
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%}
else if(htmltype.equals("3") && type.equals("160")){//浏览框  多选筐条件为单选筐
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if(htmltype.equals("3") && type.equals("142")){//浏览框多收发文单位
String urls = "/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/DocReceiveUnitBrowserSingle.jsp";
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>
<button type=button  class=Browser onclick="onShowBrowser('<%=id%>','<%=urls%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%}
else if(htmltype.equals("3") && (type.equals("141")||type.equals("56")||type.equals("27")||type.equals("118")||type.equals("65")||type.equals("64")||type.equals("137"))){//浏览框
String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser onclick="onShowBrowser('<%=id%>','<%=urls%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%}
else if(htmltype.equals("3") && id.equals("_5")){//工作流浏览框
    tmpname="";
    ArrayList tempvalues=Util.TokenizerString(tmpvalue,",");
    for(int k=0;k<tempvalues.size();k++){
        if(tmpname.equals("")){
            tmpname=WorkflowComInfo.getWorkflowname((String)tempvalues.get(k));
        }else{
            tmpname+=","+WorkflowComInfo.getWorkflowname((String)tempvalues.get(k));
        }
    }
%>
<td class=field >
<input type=hidden  name="con<%=id%>_opt" value="1">
<%if(customid.equals("")){%>
<button type=button  class=browser onClick="onShowWorkFlowSerach('workflowid','workflowspan')"></button>
<span id=workflowspan>
	<%=workflowname%>
</span>
<%}else{%>
<button type=button  class=Browser onclick="onShowCQWorkFlow('con<%=id%>_value','con<%=id%>_valuespan','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
<%}%>
</td>
<%} else if (htmltype.equals("3") && (type.equals("161") || type.equals("162"))){
	String urls=BrowserComInfo.getBrowserurl(type)+"?type="+dbtype;     // 浏览按钮弹出页面的url
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>

<button type=button  class=Browser onclick="onShowBrowserCustom('<%=id%>','<%=urls%>','<%=tmpcount%>','<%=type%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if (htmltype.equals("3")){
	String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
</select>

<button type=button  class=Browser onclick="onShowBrowser('<%=id%>','<%=urls%>','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%} else if (htmltype.equals("6")){   //附件上传同多文挡
	String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<td class=field >
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"   >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
</select>

<button type=button  class=Browser  onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1','<%=tmpcount%>')"></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpname%></span>
</td>
<%}else{
%>
  <td class=field>&nbsp;</td>
<%
}
%>
<%if (i%2 !=0) {%><td>&nbsp;</td><%}%>
<%if (i%2 ==0) {%></tr>
<TR class=Separartor style="height:1px;"><td class="Line" COLSPAN=5></TD></TR><%}%>
<%
}%>
<%if (i%2 !=0) {%></tr>
<TR class=Separartor style="height:1px;"><td class="Line" COLSPAN=5></TD></TR><%}%>  
  </tbody>
</table>
<br/>
		<!-- 显示查询结果 start -->
		<%
			//查询参数
			String querys=Util.null2String(request.getParameter("query"));
			String fromself =Util.null2String(request.getParameter("fromself"));
			String fromselfSql =Util.null2String(request.getParameter("fromselfSql"));
			String isfirst =Util.null2String(request.getParameter("isfirst"));
			String formmodeid="0";
			RecordSet.execute("select a.modeid,a.customname,a.customdesc,b.modename,b.formid from mode_custombrowser a,modeinfo b where a.modeid = b.id and a.id="+customid);
			if(RecordSet.next()){
			    formID=Util.null2String(RecordSet.getString("formid"));
			    formmodeid=Util.null2String(RecordSet.getString("modeid"));
			}
			String tablename=Util.null2String(request.getParameter("tablename"));
			rs.executeSql("select tablename from workflow_bill where id = " + formID);
			if (rs.next()){
				tablename = rs.getString("tablename"); 
			}
			
			String userID = String.valueOf(user.getUID());
			String sqlwhere=FormModeBrowserClause.getWhereclause();
			String orderby = "t1.id";
			int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
			int totalcounts = Util.getIntValue(Util.null2String(request.getParameter("totalcounts")),0);
			int perpage=10;
			String tableString = "";
			if(perpage <2) perpage=10;                                 
			String backfields = " t1.id,t1.formmodeid,t1.modedatacreater,t1.modedatacreatertype,t1.modedatacreatedate,t1.modedatacreatetime ";
			//加上自定以字段
			String showfield="";
			sql = "select workflow_billfield.id as id,workflow_billfield.fieldname as name,workflow_billfield.fieldlabel as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.fieldhtmltype as httype, workflow_billfield.type as type,mode_custombrowserdspfield.showorder,mode_custombrowserdspfield.istitle" +
               " from workflow_billfield,mode_custombrowserdspfield,Mode_CustomBrowser where mode_custombrowserdspfield.customid=Mode_CustomBrowser.id and Mode_CustomBrowser.id="+customid+
               " and mode_custombrowserdspfield.isshow='1' and workflow_billfield.billid="+formID+"  and   workflow_billfield.id=mode_custombrowserdspfield.fieldid" +
               " union select mode_custombrowserdspfield.fieldid as id,'1' as name,2 as label,'3' as dbtype, '4' as httype,5 as type ,mode_custombrowserdspfield.showorder,mode_custombrowserdspfield.istitle" +
               " from mode_custombrowserdspfield ,Mode_CustomBrowser where mode_custombrowserdspfield.customid=Mode_CustomBrowser.id and Mode_CustomBrowser.id="+customid+
               " and mode_custombrowserdspfield.isshow='1'  and mode_custombrowserdspfield.fieldid<0" +
               " order by istitle desc,showorder asc";
			//out.print(sql);
			RecordSet.executeSql(sql);
			while (RecordSet.next()){
				if (RecordSet.getInt(1)>0){
					String tempname=Util.null2String(RecordSet.getString("name"));
					String dbtype=Util.null2String(RecordSet.getString("dbtype"));
					if((","+tempname+",").toLowerCase().indexOf(",t1."+tempname.toLowerCase()+",")>-1){
						continue;
					}
					if(dbtype.toLowerCase().equals("text")){
						if(RecordSet.getDBType().equals("oracle")){
							showfield=showfield+","+"to_char(t1."+tempname+") as "+tempname;
						}else{
							showfield=showfield+","+"convert(varchar(4000),t1."+tempname+") as "+tempname;
						}
					}else{
							showfield=showfield+","+"t1."+tempname;
						}
					}
				}
				backfields=backfields+showfield;
				//String fromSql  = " from "+tablename+" t1 ";
				
				ModeShareManager.setModeId(Util.getIntValue(formmodeid,0));
				String rightsql = ModeShareManager.getShareDetailTableByUser("formmode",user);
                String fromSql  = " from "+tablename+" t1,"+rightsql+" t2 " ;
				if(sqlwhere.equals("")){
					sqlwhere = " where t1.id = t2.sourceid";
				}else{
					sqlwhere += " and t1.id = t2.sourceid";
				}
				//out.println("select "+backfields+fromSql+sqlwhere);
				
				ArrayList fieldnames = new ArrayList();
				ArrayList fieldids = new ArrayList();
				HashMap paraMap = new HashMap();
				fieldids.add("0");
				fieldnames.add("id");
				String titlestr = "";
				int cols = 0;
				titlestr += "<tr class=\"DataHeader\">";
				titlestr += "<th style=\"display:none\"></th>";
				RecordSet.beforFirst();
				while (RecordSet.next()) {
					//System.out.println(RecordSet.getString("id")+"	"+RecordSet.getString("name"));
					if(RecordSet.getString("id").equals("-1")){
						//tableString+="				<col   text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"modedatacreatedate\" orderkey=\"t1.modedatacreatedate,t1.modedatacreatetime\" otherpara=\"column:modedatacreatetime\" transmethod=\"weaver.formmode.search.FormModeTransMethod.getSearchResultCreateTime\" />";
						titlestr += "<th>"+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"</th>";
						fieldids.add("-1");
						fieldnames.add("modedatacreatedate");
					}else if(RecordSet.getString("id").equals("-2")){
						//tableString+="				<col  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"modedatacreater\" orderkey=\"t1.modedatacreater\"  otherpara=\"column:modedatacreatertype\" transmethod=\"weaver.formmode.search.FormModeTransMethod.getSearchResultName\" />";
						titlestr += "<th>"+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"</th>";
						fieldids.add("-2");
						fieldnames.add("modedatacreater");
					}else{
						String name = RecordSet.getString("name");
						String label = RecordSet.getString("label");
						String htmltype = RecordSet.getString("httype");
						String type = RecordSet.getString("type");
						String id = RecordSet.getString("id");
						String dbtype=RecordSet.getString("dbtype");
						String istitle = RecordSet.getString("istitle");
						String viewtype = "0";
						fieldids.add(id);
						fieldnames.add(name);
						//http://localhost:8080/formmode/view/addformmode.jsp?type=1&modeId=1&formId=-50
						//type=1&modeId=1&formId=-50
						//type
						//0、查看
						//1、新建
						//2、编辑
						//3、监控
						//String para3="column:id+"+id+"+"+htmltype+"+"+type+"+"+user.getLanguage()+"+"+isbill+"+"+dbtype+"+"+istitle+"+"+formmodeid+"+"+formID+"+"+viewtype;
						String para3=id+"+"+htmltype+"+"+type+"+"+user.getLanguage()+"+"+isbill+"+"+dbtype+"+"+istitle+"+"+formmodeid+"+"+formID+"+"+viewtype;
						label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
			 			//tableString+="			    <col  text=\""+label+"\"  column=\""+name+"\"  otherpara=\""+para3+"\"  transmethod=\"weaver.formmode.search.FormModeTransMethod.getOthers\"/>";
			 			titlestr += "<th>"+label+"</th>";
			 			paraMap.put(name, para3);
					}
					cols++;
				}
				titlestr += "</tr>";
				//out.println(cols);
				double width = 100/cols;
				String colsstr = "<colgroup>";
				colsstr += "<col width=\"0%\">";
				for(int k=0;k<cols;k++){
					colsstr += "<col width=\""+width+"%\">";
				}
				colsstr +="</colgroup>";
				//System.out.println(titlestr);
				//System.out.println(colsstr);
				
				String sqltemp="select "+backfields+fromSql+sqlwhere;
				sql = "select count(*) RecordSetCounts from ("+sqltemp+") temp";
				//out.println(sql);
               	RecordSet.executeSql(sql);
               	boolean hasNextPage=false;
               	int RecordSetCounts = 0;
               	if(RecordSet.next()){
               		RecordSetCounts = RecordSet.getInt("RecordSetCounts");
               	}

               	int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
               	//out.println(pagenum);
               	if(RecordSetCounts>pagenum*perpage){
               		hasNextPage=true;
               	}
               	
               	int iTotal =RecordSetCounts;
               	int iNextNum = pagenum * perpage;
               	int ipageset = perpage;
               	if(iTotal - iNextNum + perpage < perpage) ipageset = iTotal - iNextNum + perpage;
               	if(iTotal < perpage) ipageset = iTotal;

               	if(RecordSet.getDBType().equals("oracle")){
               		sqltemp = "select t12.*,rownum rn from (" + sqltemp + ") t12 where rownum <= " + iNextNum;
               		sqltemp = "select t13.* from (" + sqltemp + ") t13 where rn > " + (iNextNum - perpage);
               	}else{
               		sqltemp = "select top " + iNextNum +" t12.* from (" + sqltemp + ") t12 order by t12.id asc";
               		sqltemp = "select top " + ipageset +" t13.* from (" + sqltemp + ") t13 order by t13.id desc";
               	}
               	RecordSet.executeSql(sqltemp);
               	//out.println(sqltemp);
			%>
			<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 width="100%">
			<%=colsstr%><!-- 列宽 -->
			<%=titlestr%><!-- 列名 -->
			<TR class=Line style="height:1px;"><TH colSpan="<%=cols%>"></TH></TR>
			<%
			i=0;
			int totalline=1;
			while(RecordSet.next()){
				if(i==0){
					i=1;
			%>
					<TR class=DataLight>
			<%
				}else{
					i=0;
			%>
					<TR class=DataDark>
			<%
				}
			%>
				<%
					for(int k=0;k<fieldids.size();k++){
						String id = Util.null2String((String)fieldids.get(k));
						String name = Util.null2String((String)fieldnames.get(k));
						String value = Util.null2String(RecordSet.getString(name));
						if(id.equals("0")){
							
						}else if(id.equals("-1")){
							//tableString+="column=\"modedatacreatedate\" orderkey=\"t1.modedatacreatedate,t1.modedatacreatetime\" otherpara=\"column:modedatacreatetime\" transmethod=\"weaver.formmode.search.FormModeTransMethod.getSearchResultCreateTime\" />";
							value = FormModeTransMethod.getSearchResultCreateTime(Util.null2String(RecordSet.getString("modedatacreatedate")), Util.null2String(RecordSet.getString("modedatacreatetime")));
						}else if(id.equals("-2")){
							//tableString+="column=\"modedatacreater\" orderkey=\"t1.modedatacreater\"  otherpara=\"column:modedatacreatertype\" transmethod=\"weaver.formmode.search.FormModeTransMethod.getSearchResultName\" />";
							value = FormModeTransMethod.getSearchResultName(Util.null2String(RecordSet.getString("modedatacreater")), Util.null2String(RecordSet.getString("modedatacreatertype")));
						}else{
							//tableString+="  transmethod=\"weaver.formmode.search.FormModeTransMethod.getOthers\"/>";
							String otherpara = Util.null2String((String)paraMap.get(name));
							String key = Util.null2String(RecordSet.getString("id"));
							value = FormModeTransMethod.getOthers(value, key+"+"+otherpara);
						}
						value = FormModeTransMethod.Html2Text(value);
						if(id.equals("0")){
				%>
							<TD style="display:none"><A HREF=#><%=value%></A></TD>			
				<%
						}else{
				%>
							<TD><%=value%></TD>			
				<%			
						}
					}
				%>
			</TR>
			<%
				if(hasNextPage){
					totalline+=1;
					if(totalline>perpage)	break;
				}
			}
			%>
			</TABLE>
			<%
				if(pagenum>1){
					RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:page("+(pagenum-1)+"),_top} " ;
					RCMenuHeight += RCMenuHeightStep ;
				}
				if(hasNextPage){
					RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:page("+(pagenum+1)+"),_top} " ;
					RCMenuHeight += RCMenuHeightStep ;
				}
			%>
			
			<!-- 显示查询结果  end -->
			<input type="hidden" value="" name="pagenum">
		</td>
		</tr>
		</TABLE>
	</td>
	<td class=field></td>
</tr>
<tr>
	<td class=field height="10" colspan="3"></td>
</tr>
</table>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

</form>
<script language="javascript" src="/js/browser/WorkFlowBrowser.js"></script>
<script language="javaScript">
function doReturnSpanHtml(obj){
	var t_x = obj.substring(0, 1);
	if(t_x == ','){
		t_x = obj.substring(1, obj.length);
	}else{
		t_x = obj;
	}
	return t_x;
}

function page(pagenum){
	$G("pagenum").value = pagenum;
	//alert(pagenum);
	submitData();
}

function onShowFormWorkFlow(inputname, spanname) {
	var tmpids = $G(inputname).value;
	var url = uescape("?customid=<%=customid%>&value=<%=isbill%>_<%=formID%>_"
			+ tmpids);
	url = "/systeminfo/BrowserMain.jsp?url=/workflow/report/WorkFlowofFormBrowser.jsp"
			+ url;

	disModalDialogRtnM(url, inputname, spanname);
}
function onShowCQWorkFlow(inputname, spanname, tmpindex) {
	var tmpids = $G(inputname).value;
	var url = uescape("?customid=<%=customid%>&value=<%=isbill%>_<%=formID%>_"
			+ tmpids);
	url = "/systeminfo/BrowserMain.jsp?url=/workflow/report/WorkFlowofFormBrowser.jsp"
			+ url;

	disModalDialogRtnM(url, inputname, spanname);
	if ($G(inputname).value == "") {
		document.getElementsByName("check_con")[tmpindex * 1].checked = false;
	} else {
		document.getElementsByName("check_con")[tmpindex * 1].checked = true;
	}
}

function submitData()
{
	if (check_form(frmmain,''))
		frmmain.submit();
}

function submitClear()
{
	btnclear_onclick();
}
function enablemenuall()
{
for (a=0;a<window.frames["rightMenuIframe"].document.all.length;a++)
		{
		window.frames["rightMenuIframe"].document.all.item(a).disabled=true;
}
//window.frames["rightMenuIframe"].event.srcElement.disabled = true;
}
function changelevel(obj,tmpindex){
    if(obj.value!=""){
 		document.frmmain.check_con[tmpindex*1].checked = true;
    }else{
        document.frmmain.check_con[tmpindex*1].checked = false;
    }
}
function changelevel1(obj1,obj,tmpindex){
    if(obj.value!=""||obj1.value!=""){
 		document.frmmain.check_con[tmpindex*1].checked = true;
    }else{
        document.frmmain.check_con[tmpindex*1].checked = false;
    }
}
function onSearchWFQTDate(spanname,inputname,inputname1,tmpindex){
	var oncleaingFun = function(){
		  $(spanname).innerHTML = '';
		  $(inputname).value = '';
          if($(inputname).value==""&&$(inputname1).value==""){
              document.frmmain.check_con[tmpindex*1].checked = false;
          }
		}
		WdatePicker({el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;document.frmmain.check_con[tmpindex*1].checked = true;},oncleared:oncleaingFun});
}
function onSearchWFQTTime(spanname,inputname,inputname1,tmpindex){
    var dads  = document.all.meizzDateLayer2.style;
    setLastSelectTime(inputname);
	var th = spanname;
	var ttop  = spanname.offsetTop;
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft;
	var ttyp  = spanname.type;
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop;
		tleft += spanname.offsetLeft;
	}
	dads.top  = (ttyp == "image") ? ttop + thei : ttop + thei + 22;
	dads.left = tleft;
	outObject = th;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
    CustomQuery=1;
    outValue1 = inputname1;
    outValue2=tmpindex;
}
function uescape(url){
    return escape(url);
}
function mouseover(){
	this.focus();
}
//window.frames["rightMenuIframe"].document.body.attachEvent("onmouseover",mouseover);    
if (window.addEventListener){
	window.frames["rightMenuIframe"].document.body.addEventListener("mouseover", mouseover, false);
}else if (window.attachEvent){
	window.frames["rightMenuIframe"].document.body.attachEvent("onmouseover", mouseover);
}else{
	window.frames["rightMenuIframe"].document.body.onmouseover=mouseover;
}	
</script>



<script type="text/javascript">

function disModalDialog(url, spanobj, inputobj, need, curl) {
	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}


</script>

<script type="text/javascript">
function onShowResource() {
	var url = "";
	var tmpval = $G("creatertype").value;
	
	if (tmpval == "0") {
		url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	} else {
		url = "/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp";
	}
	disModalDialog(url, $G("resourcespan"), $G("createrid"), false);
}

function onShowBranch() {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" + $G("branchid").value;
	
	disModalDialog(url, $G("branchspan"), $G("createrid"), false);
}

function onShowDocids() {
	var url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1";
	disModalDialog(url, $G("docidsspan"), $G("docids"), false);
}

function onShowCrmids() {
	var url = "/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp";
	disModalDialog(url, $G("crmidsspan"), $G("crmids"), false);
}

function onShowHrmids() {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	disModalDialog(url, $G("hrmidsspan"), $G("hrmids"), false);
}

function onShowPrjids() {
	var url = "/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp";
	disModalDialog(url, $G("prjidsspan"), $G("prjids"), false);
}

function onShowBrowser(id,url,tmpindex) {
	var url = url + "?selectedids=" + $G("con" + id + "_value").value;
	disModalDialog(url, $G("con" + id + "_valuespan"), $G("con" + id + "_value"), false);
	$G("con" + id + "_name").value = $G("con" + id + "_valuespan").innerHTML;

	if ($G("con" + id + "_value").value == ""){
	    document.getElementsByName("check_con")[tmpindex * 1].checked = false;
	} else {
	    document.frmmain.check_con[tmpindex*1].checked = true
	    document.getElementsByName("check_con")[tmpindex * 1].checked = true;
	}
}

function onShowBrowserCustom(id, url, tmpindex, type1) {
	var id1 = window.showModalDialog(url, "", 
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			var ids = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
			var names = wuiUtil.getJsonValueByIndex(id1, 1);
			var descs = wuiUtil.getJsonValueByIndex(id1, 2);
			if (type1 == 161) {
				$G("con" + id + "_valuespan").innerHTML = "<a title='" + ids + "'>" + names + "</a>&nbsp";
				$G("con" + id + "_value").value = ids;
				$G("con" + id + "_name").value = names;
			}
			if (type1 == 162) {
				var sHtml = "";

				var idArray = ids.split(",");
				var curnameArray = names.split(",");
				var curdescArray = descs.split(",");

				for ( var i = 0; i < idArray.length; i++) {
					var curid = idArray[i];
					var curname = curnameArray[i];
					var curdesc = curdescArray[i];

					sHtml = sHtml + "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
				}

				$G("con" + id + "_valuespan").innerHTML = sHtml;
				$G("con" + id + "_value").value = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
				$G("con" + id + "_name").value = wuiUtil.getJsonValueByIndex(id1, 1);
			}
		} else {
			$G("con" + id + "_valuespan").innerHTML = "";
			$G("con" + id + "_value").value = "";
			$G("con" + id + "_name").value = "";
		}
	}
	if ($G("con" + id + "_value").value == "") {
		document.getElementsByName("check_con")[tmpindex * 1].checked = false;
	} else {
		document.getElementsByName("check_con")[tmpindex * 1].checked = true;
	}
}

function onShowBrowser1(id,url,type1) {
	//var url = "/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp";
	if (type1 == 1) {
		id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px")
		$G("con" + id + "_valuespan").innerHTML = id1;
		$G("con" + id + "_value").value=id1
	} else if (type1 == 1) {
		id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px")
		$G("con"+id+"_value1span").innerHTML = id1;
		$G("con"+id+"_value1").value=id1;
	}
}



function onShowBrowser2(id, url, type1, tmpindex) {
	var tmpids = "";
	var id1 = null;
	if (type1 == 8) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?projectids=" + tmpids);
	} else if (type1 == 9) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?documentids=" + tmpids);
	} else if (type1 == 1) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if (type1 == 4) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?selectedids=" + tmpids
				+ "&resourceids=" + tmpids);
	} else if (type1 == 16) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if (type1 == 7) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if (type1 == 142) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids);
	}
	//id1 = window.showModalDialog(url)
	if (id1 != null) {
		resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
		resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			resourceids = resourceids.substr(1);
			resourcename = resourcename.substr(1);
			$G("con" + id + "_valuespan").innerHTML = resourcename;
			jQuery("input[name=con" + id + "_value]").val(resourceids);
			jQuery("input[name=con" + id + "_name]").val(resourcename);
		} else {
			$G("con" + id + "_valuespan").innerHTML = "";
			$G("con" + id + "_value").value = "";
			$G("con" + id + "_name").value = "";
		}
	}
	if ($G("con" + id + "_value").value == "") {
		document.getElementsByName("check_con")[tmpindex * 1].checked = false;
	} else {
		document.getElementsByName("check_con")[tmpindex * 1].checked = true;
	}
}

function onShowMutiHrm(spanname, inputename) {
	tmpids = $G(inputename).value;
	id1 = window
			.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
					+ tmpids);
	if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
			resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
			var sHtml = "";
			resourceids = resourceids.substr(1);
			resourcename = resourcename.substr(1);
			$G(inputename).value = resourceids;

			var resourceidArray = resourceids.split(",");
			var resourcenameArray = resourcename.split(",");
			for ( var i = 0; i < resourceidArray.length(); i++) {
				var curid = resourceidArray[i];
				var curname = resourcenameArray[i];
				sHtml = sHtml + curname + "&nbsp";
			}

			$G(spanname).innerHTML = sHtml;
			if (spanname.indexOf("remindobjectidspan") != -1) {
				$G("isother").checked = true;
			} else {
				$G("flownextoperator")[0].checked = false;
				$G("flownextoperator")[1].checked = true;
			}
		} else {
			$G(spanname).innerHTML = "";
			$G(inputename).value = "";
			if (spanname.indexOf("remindobjectidspan") != -1) {
				$G("isother").checked = false;
			} else {
				$G("flownextoperator")[0].checked = true;
				$G("flownextoperator")[1].checked = false;
			}
		}
	}
}

function onShowWorkFlowSerach(inputname, spanname) {

	retValue = window
			.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp");
	temp = $G(inputname).value;
	if(retValue != null) {
		if (wuiUtil.getJsonValueByIndex(retValue, 0) != "0" && wuiUtil.getJsonValueByIndex(retValue, 0) != "") {
			$G(spanname).innerHTML = wuiUtil.getJsonValueByIndex(retValue, 1);
			$G(inputname).value = wuiUtil.getJsonValueByIndex(retValue, 0);
			
			if (temp != wuiUtil.getJsonValueByIndex(retValue, 0)) {
				$G("frmmain").action = "WFCustomSearchBySimple.jsp";
				$G("frmmain").submit();
				enablemenuall();
			}
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
			$G("frmmain").action = "WFSearch.jsp";
			$G("frmmain").submit();

		}
	}
}

function disModalDialogRtnM(url, inputname, spanname) {
	var id = window.showModalDialog(url);
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			var ids = wuiUtil.getJsonValueByIndex(id, 0);
			var names = wuiUtil.getJsonValueByIndex(id, 1);
			
			if (ids.indexOf(",") == 0) {
				ids = ids.substr(1);
				names = names.substr(1);
			}
			$G(inputname).value = ids;
			var sHtml = "";
			
			var ridArray = ids.split(",");
			var rNameArray = names.split(",");
			
			for ( var i = 0; i < ridArray.length; i++) {
				var curid = ridArray[i];
				var curname = rNameArray[i];
				if (i != ridArray.length - 1) sHtml += curname + "，"; 
				else sHtml += curname;
			}
			
			$G(spanname).innerHTML = sHtml;
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
		}
	}
}

function BrowseTable_onmouseover(e){
	e=e||event;
	var target=e.srcElement||e.target;
	if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
	}else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
	}
}
function BrowseTable_onmouseout(e){
	var e=e||event;
	var target=e.srcElement||e.target;
	var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
		p=jQuery(target).parents("tr")[0];
		if( p.rowIndex % 2 ==0){
		   p.className = "DataDark"
		}else{
		   p.className = "DataLight"
		}
	}
}

function BrowseTable_onclick(e){
   var e=e||event;
   var target=e.srcElement||e.target;

	if( target.nodeName =="TD"||target.nodeName =="A"  ){
		window.parent.parent.returnValue = {id:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[1]).text(),desc:'',href:'<%=href%>'};
		window.parent.parent.close();
	}
}

function btnclear_onclick(){
	window.parent.parent.returnValue={id:"",name:""};
	window.parent.parent.close();
}

$(function(){
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
});

</script>

</body>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</html>