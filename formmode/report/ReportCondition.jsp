<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.net.*" %>
<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />
<jsp:useBean id="ReportShareInfo" class="weaver.formmode.report.ReportShareInfo" scope="page" />

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
boolean haveright = false;
ReportShareInfo.setUser(user);
haveright = ReportShareInfo.checkUserRight(reportid);
if(!haveright) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String sql = "select a.reportname,b.formid,b.id from mode_Report a,modeinfo b where a.modeid = b.id and a.id = "+reportid;
RecordSet.execute(sql) ;
RecordSet.next() ;
String isbill = "1";
int formid = Util.getIntValue(RecordSet.getString("formid"),0);
titlename = Util.null2String(RecordSet.getString("reportname"));

//获得报表显示项
String strReportDspField=",";
String fieldId="";
RecordSet.execute("select fieldId from mode_ReportDspField where reportId="+reportid) ;
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

RCMenu += "{"+SystemEnv.getHtmlLabelName(527,user.getLanguage())+",javascript:submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(15504,user.getLanguage())+",javascript:SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="ReportResult.jsp" method="post">
<input type="hidden" value="<%=formid%>" name="formid">
<input type=hidden name=isbill value="<%=isbill%>">
<input type=hidden name=reportid value="<%=reportid%>">
<input type=hidden name=reportname value="<%=titlename%>">
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
    <TR style="height:2px">
      <TD class=line colspan=7></TD>
    </TR>
    
    <TR class=title>
      <td>
<%
	if(strReportDspField.indexOf(",-1,")>-1){
%>
	  <input type="checkbox" name="modedatacreatedateIsShow"  value="1" checked>
<%
    }
%>
	  </td>
      <td><input type="checkbox" name="modedatacreatedate_check_con"  value="1"></td>
      <td><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></td>
	  <td colspan=2>
	  	<button type=button  type=button class=calendar id=SelectDate onclick="changeclick1(),gettheDate(fromdate,fromdatespan)"></BUTTON>&nbsp;
	    <SPAN id=fromdatespan ></SPAN>
	    -&nbsp;&nbsp;
	    <button type=button  type=button class=calendar id=SelectDate2 onclick="changeclick1(),gettheDate(todate,todatespan)"></BUTTON>&nbsp;
	    <SPAN id=todatespan ></SPAN>
		<input type="hidden" name="fromdate" class=Inputstyle>
		<input type="hidden" name="todate" class=Inputstyle>
	  </td>
    </tr>    
    <tr style="height:2px"><td colspan=7 class=line1></td></tr>
    
      <TR class=title>
      <td>
<%
	if(strReportDspField.indexOf(",-2,")>-1){
%>
	  <input type="checkbox" name="modedatacreaterIsShow"  value="1" checked>
<%
    }
%>
	  </td>
		<td><input type="checkbox" name="modedatacreater_check_con"  value="1" ></td>
		<td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
		<td colspan=4>
         <%
            String tempbrowserurl = UrlComInfo.getUrlbrowserurl("1") ;
         %>
     	<button type=button  class=Browser  onfocus="changeclick2()" onclick="onShowBrowserHrm('modedatacreater','<%=tempbrowserurl%>')"></button>
	      <input type=hidden name="modedatacreater" >
	      <span id="modedatacreaterspan">
	      </span>
      </td>
      
    </tr>   
    <tr style="height:2px"><td colspan=7 class=line1></td></tr>

    <%
	int linecolor=0;
	sql = "select id as id,fieldname as name,fieldlabel as label,fieldhtmltype as htmltype,type as type,fielddbtype as dbtype,viewtype from workflow_billfield where billid = "+formid + " order by dsporder,viewtype ";
	RecordSet.executeSql(sql);
	int tmpcount = 0;
	while(RecordSet.next()){
		tmpcount += 1;
		String id = RecordSet.getString("id");
	%>
	<tr class=title >
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
			label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
		    int viewtypeint=Util.getIntValue(RecordSet.getString("viewtype"));
		    if(viewtypeint==1){
		        label="("+SystemEnv.getHtmlLabelName(17463,user.getLanguage())+")"+label;
		        ismain=0;
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
    </td>
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
     	<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=browserurl%>')"></button>
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
    <td><button type=button  class=calendar  onfocus="changelevel('<%=tmpcount%>')"  
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
    <td ><button type=button class=calendar  onfocus="changelevel('<%=tmpcount%>')"  
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
	<tr style="height:2px"><td colspan=7 class=line1></td></tr>

    <%
 if(linecolor==0) linecolor=1;
          else linecolor=0;}%>

<%--因为当报表是单据的时候，上面的代码本身就可以显示明细字段了。--%>
<%--而如果是表单，则因为表单的明细自动在不同的表里，所以上面的--%>
<%--sql语句查不出明细字段，必须补上下面的代码才行--%>
<%if(isbill.equals("0")){%>

    <%
linecolor=0;
sql="";

/* workflow_fieldlable b 
and  b.langurageid = @language_2
and a.fieldid= b.fieldid
and d.formid = b.formid
用子查询代替上述内容，能限制主表和明细id相同时重复出现的情况，但是无法保证显示名唯一
by ben 2006-03-27 for td3595
*/
	sql = "select t1.fieldid as id,(select distinct fieldname  from workflow_fieldlable t3 where t3.formid = t1.formid and t3.langurageid = "+user.getLanguage() + " and t3.fieldid =t1.fieldid) as name,(select distinct t3.fieldlable  from workflow_fieldlable t3 where t3.formid = t1.formid and t3.langurageid = "+user.getLanguage() + " and t3.fieldid =t1.fieldid) as label,t2.fieldhtmltype as htmltype,t2.type as type,t2.fielddbtype as dbtype from workflow_formfield t1,workflow_formdictdetail t2 where  t2.id = t1.fieldid and t1.formid="+formid + " and (t1.isdetail = '1' or t1.isdetail is not null)";

RecordSet.executeSql(sql);
//tmpcount = 0;
while(RecordSet.next()){
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
      <input type=hidden name="con<%=id%>_ismain" value="0">
      <%
String name = RecordSet.getString("name");
String label = RecordSet.getString("label");

%>
      <%=Util.toScreen("("+SystemEnv.getHtmlLabelName(17463,user.getLanguage())+")"+label,user.getLanguage())%>
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
if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){
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
        <option value="<%=tmpselectvalue%>" ><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
        <%}%>
      </select>
    </td>
    <%} else if(htmltype.equals("3") && !type.equals("165") && !type.equals("166")&& !type.equals("167")&& !type.equals("168")&& !type.equals("169")&& !type.equals("170")&& !type.equals("2")&& !type.equals("4")&& !type.equals("18")&& !type.equals("19")&& !type.equals("17") && !type.equals("37") && !type.equals("65")&& !type.equals("57")&& !type.equals("162")){
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
		<button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=browserurl%>')"></button>
      	<%--end--%>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
	  	<%} else if(htmltype.equals("3") && ( type.equals("165") || type.equals("167") || type.equals("169"))){ // 增加分权单选字段，人，部门，分部
		String url_tmp = "";
		if(type.equals("165")){
			url_tmp = "/systeminfo/BrowserMain.jsp?url=";
			url_tmp += URLEncoder.encode("/hrm/resource/MultiResourceBrowserByDec.jsp?isdetail=1&isbill="+isbill+"&fieldid="+id);
		}else if(type.equals("167")){
			url_tmp = "/systeminfo/BrowserMain.jsp?url=";
			url_tmp += URLEncoder.encode("/hrm/company/MultiDepartmentBrowserByDec.jsp?isdetail=1&isbill="+isbill+"&fieldid="+id);
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
			url_tmp += URLEncoder.encode("/hrm/resource/ResourceBrowserByDec.jsp?isdetail=1&isbill="+isbill+"&fieldid="+id);
		}else if(type.equals("168")){
			url_tmp = "/systeminfo/BrowserMain.jsp?url=";
			url_tmp += URLEncoder.encode("/hrm/company/DepartmentBrowserByDec.jsp?isdetail=1&isbill="+isbill+"&fieldid="+id);
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
    <%}else if(htmltype.equals("3") && type.equals("4")){ // 增加部门的处理（可选择多个部门）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser2('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value" >
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%}else if(htmltype.equals("3") && type.equals("57")){ // 增加多部门的处理（包含，不包含）
%>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp')"></button>
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
        <option value="1" ><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" ><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp')"></button>
      <input type=hidden name="con<%=id%>_value"  value="">
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%} else if(htmltype.equals("3") && type.equals("162")){ // 增加多自定义浏览框的处理（包含，不包含） %>
    <td >
      <select class=inputstyle name="con<%=id%>_opt" style="width:100%" onfocus="changelevel('<%=tmpcount%>')" >
        <option value="1" ><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        <option value="2" ><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      </select>
    </td>
    <%
		String browserurl = UrlComInfo.getUrlbrowserurl(type) ;
		browserurl = browserurl.trim() + "?type="+dbtype;
    %>
    <td colspan=3> <button type=button  class=Browser  onfocus="changelevel('<%=tmpcount%>')" onclick="onShowBrowser('<%=id%>','<%=browserurl%>')"></button>
      <input type=hidden name="con<%=id%>_value"  value="">
      <input type=hidden name="con<%=id%>_name" >
      <span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan">
      </span> </td>
    <%}%>
    </tr>
	<tr style="height:2px"><td colspan=7 class=line1></td></tr>

    <%
 if(linecolor==0) linecolor=1;
          else linecolor=0;}%>


<%}%>
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

<script language="javascript">
function changeclick1(){
	document.SearchForm.modedatacreatedate_check_con.checked = true;
}
function changeclick2(){
	document.SearchForm.modedatacreater_check_con.checked = true;
}
function submit(){
	document.SearchForm.submit();
}

function changevalue(){
/**
	var tempvalue = document.getElementById("neworganizationid").value;
	document.getElementById("con"+tempvalue+"_value").value = "";
	document.getElementById("con"+tempvalue+"_name").value = "";
	document.getElementById("con"+tempvalue+"_valuespan").value = "";
	document.getElementById("con"+tempvalue+"_valuespan").innerText="";
**/
}

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

function onShowBrowserHrm(id,url) {
	var id1 = window.showModalDialog(url + "&selectedids=" + $G(id).value);
	if (id1 != null) {
		var rid = wuiUtil.getJsonValueByIndex(id1, 0);
		var rname = wuiUtil.getJsonValueByIndex(id1, 1);
	    if (rid != "" && rid != "0") {
			if (rname.indexOf(",") == 0) {
				rname = rname.substr(1);
			}
			$G(id+"span").innerHTML = rname
			$G(id).value=rid
	    } else {
	    	$G(id+"span").innerHTML = "";
	    	$G(id).value="";
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