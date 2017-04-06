<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.teechart.*" %>
<jsp:useBean id="DocRpManage" class="weaver.docs.report.DocRpManage" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="page" />

<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(79,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.report.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<%
String department = Util.null2String(request.getParameter("department")) ;
String fromdate = Util.null2String(request.getParameter("fromdate")) ;
String todate = Util.null2String(request.getParameter("todate")) ;
String needreply = Util.null2String(request.getParameter("needreply")) ;
String orderby = Util.null2String(request.getParameter("orderby")) ;
String isreply = "" ;
if(!needreply.equals("1")) isreply = "0" ;


DocSearchComInfo.resetSearchInfo();
DocSearchComInfo.addDocstatus("1");
DocSearchComInfo.addDocstatus("2");
DocSearchComInfo.addDocstatus("5");
DocSearchComInfo.setDocdepartmentid(department);
DocSearchComInfo.setDoccreatedateFrom(fromdate);
DocSearchComInfo.setDoccreatedateTo(todate);
DocSearchComInfo.setIsreply(isreply) ;




String whereclause = " where  (ishistory is null or ishistory = 0) and usertype>0 and t1.maincategory in (select id from DocMainCategory) and " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
String orderbyclause ="" ;


if(orderby.equals("1") || orderby.equals("")) orderbyclause +="order by ownerid ";
if(orderby.equals("2")) orderbyclause +="order by docdepartmentid ";
if(orderby.equals("3")) orderbyclause +="order by resultcount desc ";

DocRpManage.setOptional("creater") ;
DocRpManage.getRpResult(whereclause,orderbyclause,""+user.getUID()) ;

%>

<FORM id=report name=report action=DocRpCreater.jsp method=post>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>

<tr>
	<td height="5" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<TABLE class=ViewForm>
				
				<TBODY  width="100%"  >
				<TR>
				  <TD vAlign=top>

<TABLE class=ViewForm border=0>
  <COLGROUP> <COL width="15%"> <COL width="30%"> <COL width="15%"> <COL width="40%"></COLGROUP>
  <TBODY>
  

  <TR  class=Spacing>
    <TD class=Line1 colSpan=4></TD>
  </TR>
  <TR>
      <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD class=Field>
	<INPUT    class=wuiBrowser   id=department type=hidden name=department 
	  _displayText="<%=Util.toScreen(DepartmentComInfo.getDepartmentmark(department),user.getLanguage())%> - <%=Util.toScreen(DepartmentComInfo.getDepartmentname(department),user.getLanguage())%>"
	 _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=<%=department%>"   value="<%=department%>" >
    </TD>
    <TD><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></TD>
    <TD class=field><input class=wuiDate  type="hidden" name="fromdate" value="<%=fromdate%>">
      -&nbsp;&nbsp; <input class=wuiDate  type="hidden" name="todate" value="<%=todate%>">
    </TD>
  </TR>
<TR style="height:2px"><TD class=Line colSpan=4></TD></TR>
  <TR>
      <TD><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%>:&nbsp;<%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></TD>
    <TD class=Field>
      <input id=needreply type=checkbox name=needreply value="1" <%if(needreply.equals("1")) {%>checked<%}%>>

    </TD>
      <TD><%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%></TD>
    <TD class=Field>
      <SELECT class=InputStyle  id=orderby style="WIDTH: 150px" name=orderby>
        <OPTION value=1 <%if(orderby.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(79,user.getLanguage())%>
        <OPTION value=2 <%if(orderby.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
        <OPTION value=3 <%if(orderby.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(355,user.getLanguage())%>
      </SELECT>
    </TD>
  </TR>
<TR style="height:2px" ><TD class=Line colSpan=4></TD></TR>
  </TBODY>
</TABLE>
</FORM>

<TABLE class=ListStyle border=0 cellspacing=1>
  <TBODY>
  <TR class=header>
    <TH colspan=5><%=SystemEnv.getHtmlLabelName(356,user.getLanguage())%></TH>
  </TR>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(79,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(355,user.getLanguage())%></TH></TR>
<TR class=Line><TD colSpan=5></TD></TR>
	<%  int alldoccount=0;
        boolean tdclasslight = false;
		/****柱状图**********************/
		BarTeeChart bar=TeeChartFactory.createBarChart(SystemEnv.getHtmlLabelName(16600,user.getLanguage()),700,500);
		//bar.isDebug();
		bar.setMarksStyle(BarTeeChart.SMS_Value);
		List list1=new ArrayList();
		/****柱状图**********************/
		while(DocRpManage.next())  {
          tdclasslight = tdclasslight?false:true;
		  int ownerid = DocRpManage.getDocCreaterID();
		  int docdepartmentid = DocRpManage.getDocDepartmentID();
		  String jobtitle=ResourceComInfo.getJobTitle(""+ownerid);
		  int doccount = DocRpManage.getResultCount() ;
		  alldoccount += doccount ;
		  /******柱状图***************************/
			BarChartModel bc=new BarChartModel();
			bc.setCategoryName(Util.toScreen(ResourceComInfo.getResourcename(""+ownerid),user.getLanguage()));
			bc.setValue(doccount);
			list1.add(bc);

		  /*************************************/
	%>
  <TR class='<%=( tdclasslight ? "datalight" : "datadark" )%>'>
    <TD><%=ownerid%></TD>
    <TD><A href="javaScript:openhrm(<%=ownerid%>);" onclick='pointerXY(event);'>
    <%=Util.toScreen(ResourceComInfo.getResourcename(""+ownerid),user.getLanguage())%></A></TD>
    <TD><%--<A href="/hrm/jobtitles/HrmJobTitlesEdit.jsp?id=<%=jobtitle%>">--%>
	<%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle),user.getLanguage())%><%--</A>--%></TD>
    <TD><A href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=docdepartmentid%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+docdepartmentid),user.getLanguage())%></A></TD>
    <TD align=right><A
      href="/docs/search/DocSearchTemp.jsp?frompage=1&ownerid=<%=ownerid%>&usertype=1&isreply=<%=isreply%>&doccreatedatefrom=<%=fromdate%>&doccreatedateto=<%=todate%>"><%=doccount%></A>
    </TD></TR>
	<%}  DocRpManage.closeStatement();
	/*********************************/
	bar.addSeries("XXX",list1,"");
	%>
  <TR class=header>
    <TD align=left colSpan=4><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%></TD>
    <TD align=right><%=alldoccount%></TD></TR>
     </TBODY></TABLE>
<div class="chart">
<%
if ("true".equals(isIE)){
bar.print(out);
}else{   %>
<p height="100%" width="100%" align="center" style="color:red;font-size:14px;">
			您当前使用的浏览器不支持【报表视图】，如需使用该功能，请使用IE浏览器！
</p>
<%} %>	





<br>
</div>

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



<script language=vbs>
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&report.department.value)
	if NOT isempty(id) then
	        if id(0)<> 0 then
		departmentdesc.innerHtml = id(1)
		report.department.value=id(0)
		else
		departmentdesc.innerHtml = empty
		report.department.value=""
		end if
	end if
end sub
</script>

	</BODY>
	<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
	</HTML>
