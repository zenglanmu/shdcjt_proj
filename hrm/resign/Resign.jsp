<%@ page import="weaver.general.Util,
                 weaver.hrm.resign.ResignProcess" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetT" class="weaver.conn.RecordSet" scope="page"/>

<% if(!HrmUserVarify.checkUserRight("Resign:Main",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language=javascript src="/js/weaver.js"></SCRIPT>
</HEAD>

<%
    Date newdate = new Date() ;
    long datetime = newdate.getTime() ;
    Timestamp timestamp = new Timestamp(datetime) ;
    String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
    String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

	String imagefilename = "/images/hdMaintenance.gif";
	String titlename = SystemEnv.getHtmlLabelName(16469,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=weaver name=frmmain method=get action="Resign.jsp" >

<%
String resourceid=Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());
%>
<TABLE class=ViewForm>
    <COL width=15%><COL width=35%><COL width=15%><COL width=35%>
    <TR class=Title><TH colspan=4><%=SystemEnv.getHtmlLabelName(17576,user.getLanguage())%></TH></TR>
    <TR class=Spacing style="height:2px"><TD class=Line1 colSpan=4></TD></TR>
    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(897,user.getLanguage())%></TD>
        <TD class=field>

            <INPUT class="wuiBrowser" type=hidden name="resourceid" value="<%=resourceid%>"
			_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/browser/dismiss/ResourceBrowser.jsp" _required="yes"
			_displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>"
			_callback="frmmain.submit()";
			_displayText="<A href='/hrm/resource/HrmResource.jsp?id=<%=resourceid%>'><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></A>">
        </TD>
        
    
    
    </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
</TABLE>

<table class=ListStyle cellspacing=1 >

    <col width=30%>
    <col width=30%>
    <col width=40%>
    <tr class=Header><th colspan=4><%=SystemEnv.getHtmlLabelName(17568,user.getLanguage())%></th></tr>

    <tr class=header>
        <td><%=SystemEnv.getHtmlLabelName(17568,user.getLanguage())%></td>
        <td><%=SystemEnv.getHtmlLabelName(16851,user.getLanguage())%></td>
        <td><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></td>
       
    </tr>
 
<%
    if( ! resourceid.equals("") ) {
    int wf_count=ResignProcess.countWorkFlows(resourceid);
    int doc_count=ResignProcess.countDocuments(resourceid);
    int cus_count=ResignProcess.countCustoms(resourceid);
    RecordSet.executeSql("select count(*) from Prj_ProjectInfo t1 where t1.manager ="+resourceid);
    int task_count=0;
    if(RecordSet.next()){
       task_count=RecordSet.getInt(1);
    }
	String sqlStr1 = "Select count(*) From Prj_TaskProcess t1, Prj_ProjectInfo t2 Where t1.isdelete =0 and t1.hrmid="+resourceid+" and (t1.begindate<='"+CurrentDate+"' or t1.begindate='x') and ( t1.enddate>='"+CurrentDate+"' or t1.enddate='-' ) and t2.id = t1.prjid and t2.status not in (0,6,7)";
	RecordSetM.executeSql(sqlStr1);
	//out.println("=====sqlStr1:"+sqlStr1);
	int count1 = 0;
	if(RecordSetM.next()){
	count1 = RecordSetM.getInt(1);
	}
	String sqlStr2 = "Select count(*) From Prj_TaskProcess t1, Prj_ProjectInfo t2 Where t1.isdelete =0 and t1.hrmid="+resourceid+" and (t1.enddate<'"+CurrentDate+"' and t1.enddate <>'-') and (t1.Finish < 100 or (t1.Finish = 100 and t1.Status <> 0 )) and t2.id = t1.prjid and t2.status not in (0,6,7)";
	RecordSetT.executeSql(sqlStr2);
	//out.println("=====sqlStr2:"+sqlStr2);
	int count2 = 0;
	if(RecordSetT.next()){
	count2 = RecordSetT.getInt(1);
	}
	int duty_count =count1+count2;
    double debt_count=ResignProcess.countDebts(resourceid);
    int cap_count=ResignProcess.countCapitals(resourceid);
    int role_count=ResignProcess.countRoles(resourceid);
    int cowork_count=ResignProcess.countCoworks(resourceid);
    	
%>
    <tr  class=datalight >
        <td><%=SystemEnv.getHtmlLabelName(17569,user.getLanguage())%></td>
        <td><%=wf_count%></td>
        <td><A href="Workflows.jsp?id=<%=resourceid%>&total=<%=wf_count%>&start=1&perpage=10"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></A></td>
    </tr>
    <tr  class=datadark>
        <td><%=SystemEnv.getHtmlLabelName(17570,user.getLanguage())%></td>
        <td><%=doc_count%></td>
        <td><A href="Documents.jsp?id=<%=resourceid%>&total=<%=doc_count%>&start=1&perpage=10"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></A></td>
    </tr>
    <tr  class=datalight>
        <td><%=SystemEnv.getHtmlLabelName(17571,user.getLanguage())%></td>
        <td><%=cus_count%></td>
        <td><A href="Customers.jsp?id=<%=resourceid%>&total=<%=cus_count%>&start=1&perpage=10"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></A></td>
    </tr>
    <tr  class=datadark>
        <td><%=SystemEnv.getHtmlLabelName(17572,user.getLanguage())%></td>
        <td><%=task_count%></td>
        <td><A href="Tasks.jsp?id=<%=resourceid%>&total=<%=task_count%>"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></A></td>
    </tr>
	    <tr  class=datadark>
        <td><%=SystemEnv.getHtmlLabelName(21699,user.getLanguage())%></td>
        <td><%=duty_count%></td>
        <td><A href="Duty.jsp?id=<%=resourceid%>&total=<%=duty_count%>"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></A></td>
    </tr>
    <tr  class=datalight>
        <td><%=SystemEnv.getHtmlLabelName(17573,user.getLanguage())%></td>
        <td><%=debt_count%></td>
        <td><A href="Debts.jsp?id=<%=resourceid%>&total=<%=debt_count%>&start=1&perpage=10"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></A></td>
    </tr>
    <tr  class=datadark>
        <td><%=SystemEnv.getHtmlLabelName(17574,user.getLanguage())%></td>
        <td><%=cap_count%></td>
        <td><A href="Capitals.jsp?id=<%=resourceid%>&total=<%=cap_count%>&start=1&perpage=10"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></A></td>
    </tr>
    <tr  class=datalight>
        <td><%=SystemEnv.getHtmlLabelName(17575,user.getLanguage())%></td>
        <td><%=role_count%></td>
        <td><A href="Roles.jsp?id=<%=resourceid%>&total=<%=role_count%>&start=1&perpage=10"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></A></td>
    </tr>
    <tr  class=datadark>
        <td><%=SystemEnv.getHtmlLabelName(15746,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(17855,user.getLanguage())%></td>
        <td><%=cowork_count%></td>
        <td><A href="Coworks.jsp?id=<%=resourceid%>&perpage=10"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></A></td>
    </tr>
<%}%>
</TABLE>
</FORM>
</TD>
</TR>
</TABLE>
</TD>
<TD></TD>
</TR>
<TR>
<TD height="0" colspan="3"></TD>
</TR>
</TABLE>
<script language=vbs>
sub onShowResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/browser/dismiss/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourcespan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmmain.resourceid.value=id(0)
	frmmain.action="Resign.jsp"
    frmmain.submit()
	else 
	resourcespan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	frmmain.resourceid.value=""
	end if
	end if
end sub
</script>

</body>
</html>