<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.net.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />
<HTML><HEAD>
<link rel=stylesheet type="text/css" href="/css/Browser.css">
<link rel=stylesheet type="text/css" href="/css/Weaver.css">
<script language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(15101,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(16532,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(15505,user.getLanguage());
String needfav ="1";
String needhelp ="";

int reportid = Util.getIntValue(request.getParameter("id"),0);
int sharelevel = 0 ;
RecordSet.executeSql("select sharelevel from WorkflowReportShareDetail where userid="+user.getUID()+" and usertype=1 and reportid="+reportid);
if(RecordSet.next()) {
    sharelevel = Util.getIntValue(RecordSet.getString("sharelevel"),0) ;
}
else {
    response.sendRedirect("/notice/noright.jsp");
    return;
}


String sql = " select a.formid , a.isbill from Workflow_Report a " + " where  a.id="+reportid ;
RecordSet.execute(sql) ;
RecordSet.next() ;
String isbill = Util.null2String(RecordSet.getString("isbill"));
int formid = Util.getIntValue(RecordSet.getString("formid"),0);
boolean fna = false;//单据号，156、157、158 明细的报销单位和报销类型是相关联的
String organizationtype = "";
String organizationid = "";
if(isbill.equals("1")){
	if(formid==156||formid==157||formid==158){
		fna = true;
	}
}


//获得报表显示项
String strReportDspField=",";
String fieldId="";
RecordSet.execute("select fieldId from Workflow_ReportDspField where reportId="+reportid) ;
while(RecordSet.next()){
	fieldId=RecordSet.getString(1);
	if(fieldId!=null&&!fieldId.equals("")){
		strReportDspField+=fieldId+",";
	}
}
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(527,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15504,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(350,user.getLanguage())+",javascript:onSaveAsTemplate(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>


<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="ReportResult.jsp" method="post">
<input type="hidden" value="<%=formid%>" name="formid">
<input type=hidden name=isbill value="<%=isbill%>">
<input type=hidden name=reportid value="<%=reportid%>">
<input type=hidden name=operation>


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

<table class=ViewForm>
  <tr>
    <td width="80%">

  <table width=100% class=viewform>
    <COLGROUP> <COL width="4%"><COL width="4%"> <COL width="20%"> <COL width="18%"> <COL width="18%">
    <COL width="18%"> <COL width="18%">
    <TR class=title>
      <TH colSpan=7><%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%></TH>
    </TR>
    <TR style="height:2px">
      <TD class=line1 colspan=7></TD>
    </TR>
    <TR class=title>
      <td><%=SystemEnv.getHtmlLabelName(19664,user.getLanguage())%></td>
      <td><%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%></td>
      <td><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></td>
      <td colspan=4><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></td>
    </tr>   
    <!-- 2012-08-16 ypc 修改 -->
    <TR style="height:2px">
      <TD class=line colspan=7></TD>
    </TR>
    
    
    <!--xwj for td2974 20051026   B E G I N-->
    <TR class=title>
      <td>
<%
	if(strReportDspField.indexOf(",-1,")>-1){
%>
	  <input type="checkbox" name="requestNameIsShow"  value="1" checked>
<%
    }
%>
	  </td>
      <td><input type="checkbox" name="requestname_check_con"  value="1" ></td>
      <td><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></td>
      <td>
      <select class="inputstyle" name="requestname"  style="width:100%" onfocus="changeclick1()">
        <option value="1" ><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2" ><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
        <option value="3" ><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="4" ><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
      </td>
      <td colspan=3>
      <input type=text class=inputstyle size=12 name="requestnamevalue" onfocus="changeclick1()"> 
      </td>
    </tr>    
    <!-- 2012-08-16 ypc 修改 -->
    <tr style="height:2px"><td colspan=7 class=line1></td></tr>
      <TR class=title>
      <td>
<%
	if(strReportDspField.indexOf(",-2,")>-1){
%>
	  <input type="checkbox" name="requestLevelIsShow"  value="1" checked>
<%
    }
%>
	  </td>
      <td><input type="checkbox" name="requestlevel_check_con"  value="1" ></td>
      <td><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></td>
      <td>
      <select class="inputstyle" name="requestlevelvalue"  style="width:100%" onfocus="changeclick2()">
        <option value="0" ><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
        <option value="1" ><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
        <option value="2" ><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>
      </select>
      </td>
      <td colspan=3>
      </td>
    </tr>  
    <!-- 2012-08-16 ypc 修改 --> 
    <tr style="height:2px"><td colspan=7 class=line1></td></tr>
    <!--xwj for td2974 20051026  E N D-->
    
    <!--xwj for td451 20051105   B E G I N-->
      <TR class=title>
      <td>
<%
	if(strReportDspField.indexOf(",-3,")>-1){
%>
	  <input type="checkbox" name="requestStatusIsShow"  value="1" checked>
<%
    }
%>	  
	  </td>
      <td><input type="checkbox" name="requeststatus_check_con"  value="1" ></td>
      <td><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
      <td>
      <select class="inputstyle" name="requeststatusvalue"  style="width:100%" onfocus="changeclick3()">
        <option value="1" ><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
        <option value="2" ><%=SystemEnv.getHtmlLabelName(17999,user.getLanguage())%></option>
      </select>
      </td>
      <td colspan=3>
      </td>
    </tr>   
    <!-- 2012-08-16 ypc 修改 -->
    <tr style="height:2px"><td colspan=7 class=line1></td></tr>

<tr>
	<td></td>
	<td><input type='checkbox' name='archiveTime' value="1" >
	</td>
	<td><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19736,user.getLanguage())%></td>
  <td colspan=2><button type=button  type=button class=calendar id=SelectDate onfocus="changeclick4()" onclick="gettheDate(fromdate,fromdatespan)"></BUTTON>&nbsp;
    <SPAN id=fromdatespan ></SPAN>
    -&nbsp;&nbsp;<button type=button  type=button class=calendar id=SelectDate2 onfocus="changeclick4()" onclick="gettheDate(todate,todatespan)"></BUTTON>&nbsp;
    <SPAN id=todatespan ></SPAN>
	<input type="hidden" name="fromdate" class=Inputstyle>
	<input type="hidden" name="todate" class=Inputstyle>
  </td>
</tr>
<!-- 2012-08-16 ypc 修改 -->
<tr style="height:2px"><td colspan=7 class=line1></td></tr>

    <!--xwj for td451 20051105   E N D--->
    <%
int linecolor=0;
sql="";
//获取用户语言，默认为7
int userLanguage = user.getLanguage();
userLanguage = (userLanguage == 0) ? 7 : userLanguage;
if(isbill.equals("0")){
	StringBuffer sqlSB = new StringBuffer();
	sqlSB.append("   Select bf.* from                                               \n");
	sqlSB.append("     (select t1.fieldid as id,                                    \n");
	sqlSB.append("             (select distinct fieldname                           \n");
	sqlSB.append("                from workflow_fieldlable t3                       \n");
	sqlSB.append("               where t3.formid = t1.formid                        \n");
	sqlSB.append("                 and t3.langurageid = " + userLanguage + "        \n");
	sqlSB.append("                 and t3.fieldid = t1.fieldid) as name,            \n");
	sqlSB.append("             (select distinct t3.fieldlable as label              \n");
	sqlSB.append("                from workflow_fieldlable t3                       \n");
	sqlSB.append("               where t3.formid = t1.formid                        \n");
	sqlSB.append("                 and t3.langurageid = " + userLanguage + "        \n");
	sqlSB.append("                 and t3.fieldid = t1.fieldid) as label,           \n");
	sqlSB.append("             t2.fieldhtmltype as htmltype,                        \n");
	sqlSB.append("             t2.type as type,                                     \n");
	sqlSB.append("             t2.fielddbtype as dbtype,                            \n");
	sqlSB.append("             NULL as groupid                                      \n");
	sqlSB.append("        from workflow_formfield t1, workflow_formdict t2          \n");
	sqlSB.append("       where t2.id = t1.fieldid                                   \n");
	sqlSB.append("         and t1.formid = " + formid + "                           \n");
	sqlSB.append("         and (t1.isdetail <> '1' or t1.isdetail is null)          \n");
	sqlSB.append("      UNION                                                       \n");
	sqlSB.append("      select t1.fieldid as id,                                    \n");
	sqlSB.append("             (select distinct fieldname                           \n");
	sqlSB.append("                from workflow_fieldlable t3                       \n");
	sqlSB.append("               where t3.formid = t1.formid                        \n");
	sqlSB.append("                 and t3.langurageid = " + userLanguage + "        \n");
	sqlSB.append("                 and t3.fieldid = t1.fieldid) as name,            \n");
	sqlSB.append("             (select distinct t3.fieldlable                       \n");
	sqlSB.append("                from workflow_fieldlable t3                       \n");
	sqlSB.append("               where t3.formid = t1.formid                        \n");
	sqlSB.append("                 and t3.langurageid = " + userLanguage + "        \n");
	sqlSB.append("                 and t3.fieldid = t1.fieldid) as label,           \n");
	sqlSB.append("             t2.fieldhtmltype as htmltype,                        \n");
	sqlSB.append("             t2.type as type,                                     \n");
	sqlSB.append("             t2.fielddbtype as dbtype,                            \n");
	sqlSB.append("             t1.groupid                                           \n");
	sqlSB.append("        from workflow_formfield t1, workflow_formdictdetail t2    \n");
	sqlSB.append("       where t2.id = t1.fieldid                                   \n");
	sqlSB.append("         and t1.formid = " + formid + "                           \n");
	sqlSB.append("         and (t1.isdetail = '1' or t1.isdetail is not null)) bf   \n");
	sqlSB.append("   left join (Select * from Workflow_ReportDspField               \n");
	sqlSB.append("                    where reportid = " + reportid + " ) rf        \n");
	sqlSB.append("   on (bf.id = rf.fieldid OR bf.id = rf.fieldidbak)               \n");
	sqlSB.append("   order by rf.dsporder                                           \n");
	sql = sqlSB.toString();
} else if(isbill.equals("1")){
	StringBuffer sqlSB = new StringBuffer();
	sqlSB.append("  select bf.* from (                              \n");
	sqlSB.append("    select wfbf.id            as id,              \n");
	sqlSB.append("           wfbf.fieldname     as name,            \n");
	sqlSB.append("           wfbf.fieldlabel    as label,           \n");
	sqlSB.append("           wfbf.fieldhtmltype as htmltype,        \n");
	sqlSB.append("           wfbf.type          as type,            \n");
	sqlSB.append("           wfbf.fielddbtype   as dbtype,          \n");
	sqlSB.append("           wfbf.viewtype      as viewtype,        \n");
	sqlSB.append("           wfbf.dsporder      as dsporder,        \n");
	sqlSB.append("           wfbf.detailtable   as detailtable      \n");
	sqlSB.append("      from workflow_billfield wfbf                \n");
	sqlSB.append("     where wfbf.billid = " + formid + " AND wfbf.viewtype = 0               \n");
	sqlSB.append("    Union                                         \n");
	sqlSB.append("    select wfbf.id            as id,              \n");
	sqlSB.append("           wfbf.fieldname     as name,            \n");
	sqlSB.append("           wfbf.fieldlabel    as label,           \n");
	sqlSB.append("           wfbf.fieldhtmltype as htmltype,        \n");
	sqlSB.append("           wfbf.type          as type,            \n");
	sqlSB.append("           wfbf.fielddbtype   as dbtype,          \n");
	sqlSB.append("		     wfbf.viewtype      as viewtype,        \n");
	sqlSB.append("		     wfbf.dsporder+100  as dsporder,        \n");
	sqlSB.append("           wfbf.detailtable   as detailtable      \n");
	sqlSB.append("		from workflow_billfield wfbf                \n");
	sqlSB.append("	   where wfbf.billid = " + formid + " AND wfbf.viewtype = 1               \n");
	sqlSB.append("  ) bf left join (Select fieldid,dsporder,fieldidbak                        \n");
	sqlSB.append("      from Workflow_ReportDspField  where reportid = " + reportid + ") rf   \n");
	sqlSB.append("      on (bf.id = rf.fieldid OR bf.id = rf.fieldidbak)                      \n");
	sqlSB.append("   order by rf.dsporder, bf.dsporder,   bf.detailtable                      \n");
	sql = sqlSB.toString();
}
RecordSet.executeSql(sql);
int tmpcount = 0;
while(RecordSet.next()){
    //屏蔽集成浏览按钮-zzl
	if(RecordSet.getString("type").equals("226")||RecordSet.getString("type").equals("227")||RecordSet.getString("type").equals("224")||RecordSet.getString("type").equals("225")){
		continue;
	}
tmpcount += 1;
String id = RecordSet.getString("id");
%><tr class=title >
    <td>
<%
	if(strReportDspField.indexOf(","+id+",")>-1){
%>
      <input type='checkbox' name='isShow'  value="<%=id%>" checked>
<%
    }
%>
    </td>
    <td>
      <input type='checkbox' name='check_con'  value="<%=id%>">
    </td>
    <td>
      <input type=hidden name="con<%=id%>_id" value="<%=id%>">

      <%
String name = RecordSet.getString("name");
String label = RecordSet.getString("label");
int ismain=1;
if(isbill.equals("1")){
	label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
    int viewtypeint=Util.getIntValue(RecordSet.getString("viewtype"));
    if(viewtypeint==1){
        label="("+SystemEnv.getHtmlLabelName(17463,user.getLanguage())+")"+label;
        ismain=0;
    }
}
%>
      <input type=hidden name="con<%=id%>_ismain" value="<%=ismain%>">
      <%=Util.toScreen(label,user.getLanguage())%>
      <input type=hidden name="con<%=id%>_colname" value="<%=name%>">
    </td>
    <%
String htmltype = RecordSet.getString("htmltype");
String type = RecordSet.getString("type");
String dbtype = RecordSet.getString("dbtype");
%>
    <input type=hidden name="con<%=id%>_htmltype" value="<%=htmltype%>">
    <input type=hidden name="con<%=id%>_type" value="<%=type%>">
    <%
if(htmltype.equals("1") && type.equals("1")){//单行文本框的文本类型
%>
    <td>
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
        <option value="3"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="4"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3>
      <input type=text class=inputstyle size=12 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')"  >
    </td>
    <%}else if(htmltype.equals("2")){//多行文本框
    	%>
        <td>
          <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
            <option value="3"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
            <option value="4"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
          </select>
        </td>
        <td colspan=3>
          <input type=text class=inputstyle size=12 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')"  >
        </td>
        <%}
else if(htmltype.equals("1")&& !type.equals("1")){
%>
    <td>
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
    </td>
    <td >
      <input type=text class=inputstyle size=12 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')" >
    </td>
    <td>
      <select class=inputstyle name="con<%=id%>_opt1" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
    </td>
    <td>
      <input type=text class=inputstyle size=12 name="con<%=id%>_value1"  onfocus="changelevel('<%=tmpcount%>')"  >
    </td>
    <%
}
else if(htmltype.equals("4")){
%>
    <td colspan=4>
      <input type=checkbox value=1 name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')">
    </td>
    <%}
else if(htmltype.equals("5")){
%>
    <td>
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3>
      <select class=inputstyle name="con<%=id%>_value"  onfocus="changelevel('<%=tmpcount%>')" onchange="changevalue()">
      	<option value='' ></option>
        <%
char flag=2;
rs.executeProc("workflow_SelectItemSelectByid",""+id+flag+isbill);
while(rs.next()){
	int tmpselectvalue = rs.getInt("selectvalue");
	String tmpselectname = rs.getString("selectname");
%>
        <option value="<%=tmpselectvalue%>"><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
        <%}%>
      </select>
      <%--add by zhaolg for td17048--%>
      <%if(fna && name.equals("organizationtype")) {%>
      <%organizationid = id;%>
      		 <input type=hidden name="organizationtype" id="organizationtype" value="con<%=id%>_value">
      <%}%>
      <%--end--%>
    </td>
    <%} else if(htmltype.equals("3") && (type.equals("1") || !type.equals("4") || !type.equals("164")) && fna && name.equals("organizationid")){
		String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
		organizationtype = type;
    %>
        <td>
          <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
            <option value="1"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
            <option value="2"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
          </select>
        </td>
        <td colspan=3>
           	<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser3('<%=id%>','<%=browserurl%>')"></button>
   			<input type=hidden name="neworganizationid" id="neworganizationid" value="<%=id%>">
          <input type=hidden name="con<%=id%>_value" >
          <input type=hidden name="con<%=id%>_name" >
          <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
          </span> </td>
    <%} else if(htmltype.equals("3") && !type.equals("165") && !type.equals("166")&& !type.equals("167")&& !type.equals("168")&& !type.equals("169")&& !type.equals("170")&& !type.equals("2") && !type.equals("4")&& !type.equals("18")&& !type.equals("19")&& !type.equals("17") && !type.equals("37") && !type.equals("65")&& !type.equals("57")&& !type.equals("162")&& !type.equals("135")){
%>
    <td>
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3>
         <%
            String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
            if(type.equals("4") && sharelevel <2) {
                if(sharelevel == 1) browserurl = browserurl.trim() + "?sqlwhere=where subcompanyid1 = " + user.getUserSubCompany1() ;
                else browserurl = browserurl.trim() + "?sqlwhere=where id = " + user.getUserDepartment() ;
            }else if("161".equals(type)){
		browserurl = browserurl.trim() + "?type="+dbtype;
	    }
         %>
        <%--add by zhaolg for td17048--%>
         <%if(isbill.equals("1")&& formid == 158 && name.equals("organizationid")) {%>
        	<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser3('<%=id%>','<%=browserurl%>')"></button>
<input type=hidden name="neworganizationid" id="neworganizationid" value="<%=id%>">
      	<%}else{ %>
        	<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=browserurl%>')"></button>
      	<%} %>
      	<%--end--%>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%} else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){ // 增加日期和时间的处理（之间）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
    </td>
    <td><button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')"  
<%if(type.equals("2")){%>
   onclick="onSearchWFDate(con<%=id%>_valuespan,con<%=id%>_value)"
<%}else{%>
 onclick ="onSearchWFTime(con<%=id%>_valuespan,con<%=id%>_value)"
<%}%>
 ></button>
      <input type=hidden name="con<%=id%>_value" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <td >
      <select class=inputstyle name="con<%=id%>_opt1" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>
        <option value="3"><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>
        <option value="4"><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>
        <option value="5"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="6"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
    </td>
    <td ><button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')"  
<%if(type.equals("2")){%>
   onclick="onSearchWFDate(con<%=id%>_value1span,con<%=id%>_value1)"
<%}else{%>
 onclick ="onSearchWFTime(con<%=id%>_value1span,con<%=id%>_value1)"
<%}%>
 ></button>
      <input type=hidden name="con<%=id%>_value1" >
      <span name="con<%=id%>_value1span" id="con<%=id%>_value1span">
      </span> </td>
     <%} else if(htmltype.equals("3") && type.equals("4")){ // 增加部门的处理（可选择多个部门）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
	<%} else if(htmltype.equals("3") && ( type.equals("165") || type.equals("167") || type.equals("169"))){ // 增加分权单选字段，人，部门，分部
		String url_tmp = "";
		if(type.equals("165")){
			url_tmp = "/systeminfo/BrowserMain.jsp?url=";
			if(ismain == 1){
				url_tmp += URLEncoder.encode("/hrm/resource/MultiResourceBrowserByDec.jsp?isbill="+isbill+"&fieldid="+id);
			}else{
				url_tmp += URLEncoder.encode("/hrm/resource/MultiResourceBrowserByDec.jsp?isdetail=1&isbill="+isbill+"&fieldid="+id);
			}
		}else if(type.equals("167")){
			url_tmp = "/systeminfo/BrowserMain.jsp?url=";
			if(ismain == 1){
				url_tmp += URLEncoder.encode("/hrm/company/MultiDepartmentBrowserByDec.jsp?isbill="+isbill+"&fieldid="+id);
			}else{
				url_tmp += URLEncoder.encode("/hrm/company/MultiDepartmentBrowserByDec.jsp?isdetail=1&isbill="+isbill+"&fieldid="+id);
			}
		}else{
			url_tmp = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiSubcompanyBrowserByDec.jsp";
		}
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=url_tmp%>')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
<%} else if(htmltype.equals("3") && ( type.equals("166") || type.equals("168") || type.equals("170"))){ // 增加分权多选字段，人，部门，分部
		String url_tmp = "";
		if(type.equals("166")){
			url_tmp = "/systeminfo/BrowserMain.jsp?url=";
			if(ismain == 1){
				url_tmp += URLEncoder.encode("/hrm/resource/ResourceBrowserByDec.jsp?isbill="+isbill+"&fieldid="+id);
			}else{
				url_tmp += URLEncoder.encode("/hrm/resource/ResourceBrowserByDec.jsp?isdetail=1&isbill="+isbill+"&fieldid="+id);
			}
		}else if(type.equals("168")){
			url_tmp = "/systeminfo/BrowserMain.jsp?url=";
			if(ismain == 1){
				url_tmp += URLEncoder.encode("/hrm/company/DepartmentBrowserByDec.jsp?isbill="+isbill+"&fieldid="+id);
			}else{
				url_tmp += URLEncoder.encode("/hrm/company/DepartmentBrowserByDec.jsp?isdetail=1&isbill="+isbill+"&fieldid="+id);
			}
		}else{
			url_tmp = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowserByDec.jsp";
		}
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=url_tmp%>')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>

    <%} else if(htmltype.equals("3") && type.equals("57")){ // 增加多部门的处理（包含，不包含）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("17")){ // 增加多人力资源的处理（包含，不包含）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("65")){ 
        // modify by mackjoe at 2005-11-24 td2862 增加多角色的处理（包含，不包含）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("18")){ // 增加多客户的处理（包含，不包含）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("37")){ // 增加多文档的处理（包含，不包含） %>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%} else if(htmltype.equals("3")&&type.equals("162")){ // 增加多自定义浏览框的处理（包含，不包含）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <%
	String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
	browserurl = browserurl.trim() + "?type="+dbtype;
    %>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=browserurl%>')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("135")){ // 增加多项目处理（包含，不包含） %>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
        <%}%>
    </tr>
    <!-- 2012-08-16 ypc 修改 -->
	<tr style="height:2px"><td colspan=7 class=line1></td></tr>

    <%
 if(linecolor==0) linecolor=1;
          else linecolor=0;}   %>
  </table>

</td>
<td  width="20%"   vAlign=top >
      <TABLE class=ListStyle cellspacing=1>
        <COLGROUP> 
		  <COL width="40%">
		  <COL width="40%">
		  <COL width="20%">
        <TBODY>
        <TR class=header>
          <TH    colSpan=3><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></TH>
        </TR>
        <TR class=Line style="height:1px;"><TD colSpan=3></TD></TR>
        <TR class=DataLight>
          <TD  colSpan=3><a href="ReportCondition.jsp?id=<%=reportid%>"><%=SystemEnv.getHtmlLabelName(149,user.getLanguage())%></a></TD>
		 </TR>
<%
    String trClass="DataDark";
	int tempMouldId=-1;
	String tempMouldName="";

    RecordSet.executeSql("select id,mouldName from WorkflowRptCondMould where userId="+user.getUID()+" and reportId="+reportid+" order by id asc");
	
	while(RecordSet.next()){
		tempMouldId=Util.getIntValue(RecordSet.getString(1),0);
		tempMouldName=Util.null2String(RecordSet.getString(2));

%>
        <TR class=<%=trClass%>>
          <TD><a href="ReportResult.jsp?reportid=<%=reportid%>&mouldId=<%=tempMouldId%>&searchByMould=1"><%=tempMouldName%></a></TD>
          <TD><a href="ReportConditionMould.jsp?id=<%=reportid%>&mouldId=<%=tempMouldId%>"><%=SystemEnv.getHtmlLabelName(364,user.getLanguage())%></a></TD>
          <TD><a href="ReportConditionEdit.jsp?id=<%=reportid%>&mouldId=<%=tempMouldId%>"><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%></a></TD>
		 </TR>
<%
	    if(trClass.equals("DataDark")){
	        trClass="DataLight";
        }else{
            trClass="DataDark";
		}
	}

%>

        <TR class=<%=trClass%>>
          <TD     colSpan=3><input class=InputStyle type="text"  name="newMouldName" value="" size=15 onChange="checkinput('newMouldName','newMouldNameSpan')">
          <span id=newMouldNameSpan><IMG src="/images/BacoError.gif" align=absMiddle></span></TD>
        </TR>
        </TBODY>
      </TABLE>
</td>
</tr>
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

</FORM>

<!--xwj for td2974 20051026   B E G I N-->
<script language="javascript">
function changeclick1(){
document.SearchForm.requestname_check_con.checked = true;
}
function changeclick2(){
document.SearchForm.requestlevel_check_con.checked = true;
}
function changeclick3(){<!--xwj for td2451 20051104 -->
document.SearchForm.requeststatus_check_con.checked = true;
}
function changeclick4(){
document.SearchForm.archiveTime.checked = true;
}
function onSaveAsTemplate(){
	if(check_form(document.SearchForm,'newMouldName')){
		if(document.all("todate").value != "" && document.all("fromdate").value > document.all("todate").value){
			alert("<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>");
			return;
			}
	document.SearchForm.operation.value="saveAsTemplate";
	document.SearchForm.action="ReportConditionOperation.jsp";
	document.SearchForm.submit();
	}
}
function submit(){
	if(document.all("todate").value != "" && document.all("fromdate").value > document.all("todate").value){
		alert("<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>");
		return;
	}else{
  document.SearchForm.submit();
	}
}
function onShowBrowser3(id,url){
	var tempvalue = document.getElementById("organizationtype").value;
	if(tempvalue!=null && tempvalue !=""){
	   if(document.getElementById("con<%=organizationid%>_value")){
		   if(document.getElementById("con<%=organizationid%>_value").value==""){
			   initFna();
		   }
	   }
	   var value = document.getElementById(tempvalue).value;
	   if(value==null || value =="" || value==3){
	  		onShowBrowser(id,"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	   		
	   }else if(value==2){
	   		var url2 = "/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp";
	   		onShowBrowser2(id,url2);
	   		
	   }else if(value==1){
	   		var url1="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp";
	   		onShowBrowser2(id,url1);
	   }
	}
}
function changevalue(){
var tempvalue = document.getElementById("neworganizationid").value;
document.getElementById("con"+tempvalue+"_value").value = "";
document.getElementById("con"+tempvalue+"_name").value = "";
document.getElementById("con"+tempvalue+"_valuespan").value = "";
document.getElementById("con"+tempvalue+"_valuespan").innerText="";
}

function initFna(){
	try{
		var check_con = document.getElementsByName("check_con");
		if("<%=organizationtype%>"=="1"){
			for(var i=0;i<check_con.length;i++){
				var cc = check_con[i];
				if(cc.value=="<%=organizationid%>"){
					cc.checked=true;
				}
			}
			document.getElementById("con<%=organizationid%>_value").value = 3;
		}else if("<%=organizationtype%>"=="4"){
			for(var i=0;i<check_con.length;i++){
				var cc = check_con[i];
				if(cc.value=="<%=organizationid%>"){
					cc.checked=true;
				}
			}		
			document.getElementById("con<%=organizationid%>_value").value = 2;
		}else if("<%=organizationtype%>"=="164"){
			for(var i=0;i<check_con.length;i++){
				var cc = check_con[i];
				if(cc.value=="<%=organizationid%>"){
					cc.checked=true;
				}
			}		
			document.getElementById("con<%=organizationid%>_value").value = 1;
		}	
	}catch(e){}
}
//window.attachEvent("onload", initFna);

</script>
<!--xwj for td2974 20051026   E N D-->
<script language="javascript">
function onShowBrowser2(id,url) {
	var url = url + "?selectedids=" + $G("con"+id+"_value").value;
	var id1 = window.showModalDialog(url);
	if (id1 != null && id1 != undefined) {
	    if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
	    	var rid = wuiUtil.getJsonValueByIndex(id1, 0);
	    	var rname = wuiUtil.getJsonValueByIndex(id1, 1);
			if (rname.indexOf(",") == 0) {
				rname = rname.substr(1);
			}
			$G("con"+id+"_valuespan").innerHTML = rname;
			$G("con"+id+"_value").value = rid;
	        $G("con"+id+"_name").value = rname;
	    } else {
	    	$G("con"+id+"_valuespan").innerHTML = "";
	    	$G("con"+id+"_value").value="";
	    	$G("con"+id+"_name").value="";
	    }
	}
}

function onShowBrowser(id,url) {
	var id1 = window.showModalDialog(url + "&selectedids=" + $G("con"+id+"_value").value);

	if (id1 != null) {
		var rid = wuiUtil.getJsonValueByIndex(id1, 0);
		var rname = wuiUtil.getJsonValueByIndex(id1, 1);
	    if (rid != "" && rid != "0") {
			if (rname.indexOf(",") == 0) {
				rname = rname.substr(1);
			}
			$G("con"+id+"_valuespan").innerHTML = rname
			$G("con"+id+"_value").value=rid
	        $G("con"+id+"_name").value=rname
	    } else {
	    	$G("con"+id+"_valuespan").innerHTML = "";
	    	$G("con"+id+"_value").value="";
	    	$G("con"+id+"_name").value="";
	    }
	}
}

function onShowBrowser1(id,url,type1) {
	if (type1 == 1) {
		var id1 = window.showModalDialog(url, "", "dialogHeight:320px;dialogwidth:275px");
		$G("con"+id+"_valuespan").innerHTML = id1;
		$G("con"+id+"_value").value=id1;
	} else if( type1 == 2) {
		var id1 = window.showModalDialog(url, "","dialogHeight:320px;dialogwidth:275px");
		$G("con"+id+"_value1span").innerHTML = id1;
		$G("con"+id+"_value1").value=id1;
	}
}
function changelevel(tmpindex) {
	document.getElementsByName("check_con")[tmpindex - 1].checked = true;
}
</script>

<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</BODY></HTML>