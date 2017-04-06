<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.teechart.*" %>
<jsp:useBean id="DocRpManage" class="weaver.docs.report.DocRpManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(124,user.getLanguage());
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

<%


String fromdate = Util.null2String(request.getParameter("fromdate")) ;
String todate = Util.null2String(request.getParameter("todate")) ;
String needreply = Util.null2String(request.getParameter("needreply")) ;
String publish = Util.null2String(request.getParameter("publish")) ;
String isreply = "" ;
if(!needreply.equals("1")) isreply = "0" ;


DocSearchComInfo.resetSearchInfo();
DocSearchComInfo.addDocstatus("1");
DocSearchComInfo.addDocstatus("2");
DocSearchComInfo.addDocstatus("5");
DocSearchComInfo.setDoccreatedateFrom(fromdate);
DocSearchComInfo.setDoccreatedateTo(todate);
DocSearchComInfo.setIsreply(isreply) ;

if(!publish.equals("")){
	DocSearchComInfo.setDocpublishtype(publish);
}


String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) +"  and (ishistory is null or ishistory = 0)  and t1.maincategory in (select id from DocMainCategory) and usertype=1 and doccreaterid!=1 ";
DocRpManage.setOptional("department") ;
DocRpManage.getRpResult(whereclause,"",""+user.getUID()) ;

%>

<FORM id=report name=report action=DocRpRelative.jsp method=post>
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="15%">
  <COL width="25%">
  <COL width="15%">
  <COL width="45%">
  <TBODY>
  <TR class=Spacing>
    <TD class=Line1 colSpan=5></TD></TR>
  <TR>

      <TD><%=SystemEnv.getHtmlLabelName(114,user.getLanguage())%></TD>
    <TD class=field><SELECT class=InputStyle    name=publish>
	<OPTION value=""></OPTION>
	<OPTION value=1 <%if(publish.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1984,user.getLanguage())%></OPTION>
	<OPTION value=2 <%if(publish.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(227,user.getLanguage())%></OPTION>
	<OPTION value=3 <%if(publish.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></OPTION></SELECT></TD>
  <TR style="height:1px" >
  <TR  style="height:2px"  ><TD class=Line colSpan=4></TD></TR>
      <TD><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></TD>
    <TD class=field>
        <input id=needreply type=checkbox name=needreply value="1" <%if(needreply.equals("1")) {%>checked<%}%>>
      </TD>
      <TD><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></TD>
    <TD class=field><input type="hidden" class=wuiDate name="fromdate" value="<%=fromdate%>">
      -&nbsp;&nbsp; <input type="hidden" class=wuiDate name="todate" value="<%=todate%>">
       </TD></TR>
<TR  style="height:2px"  ><TD class=Line colSpan=4></TD></TR>
       </TBODY></TABLE>
<TABLE class=ListStyle width="100%" border=0 cellspacing=1>
  <COLGROUP>
  <COL width="70%">
  <COL width="30%">
  <TBODY>
  <TR class=header>
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(356,user.getLanguage())%></TH>
  <TR class=Header>
      <TH><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TH>
      <TH><%=SystemEnv.getHtmlLabelName(355,user.getLanguage())%></TH>
    </TR>
<TR class=Line><TD  colSpan=4></TD></TR> 
	<%  int alldoccount=0;
        boolean tdclasslight = false;
/************************************************/
	BarTeeChart bar=TeeChartFactory.createBarChart(SystemEnv.getHtmlLabelName(16601,user.getLanguage()));
	//bar.isDebug();
	bar.setMarksStyle(BarTeeChart.SMS_Value);
	List list1=new ArrayList();
/******************************************************/
		while(DocRpManage.next())  {
          tdclasslight = tdclasslight?false:true;
		  int docgroupbyid = DocRpManage.getDocGroupByID();
		  int doccount = DocRpManage.getResultCount() ;
		  alldoccount += doccount ;
/**********************************************/
  		BarChartModel bc=new BarChartModel();
		bc.setCategoryName(Util.toScreen(DepartmentComInfo.getDepartmentname(""+docgroupbyid),user.getLanguage()));
		bc.setValue(doccount);
		list1.add(bc);
		if(Util.toScreen(DepartmentComInfo.getDepartmentname(""+docgroupbyid),user.getLanguage()) != null && 
		!Util.toScreen(DepartmentComInfo.getDepartmentname(""+docgroupbyid),user.getLanguage()).equals("")){
/*******************************************/
	%>
  <TR class='<%=( tdclasslight ? "datalight" : "datadark" )%>'>
      <TD>
	  <a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=docgroupbyid%>">
	  <%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+docgroupbyid),user.getLanguage()) %></a>
	  </TD>
    <TD align=right><A
      href="/docs/search/DocSearchTemp.jsp?frompage=1&doccreatedatefrom=<%=fromdate%>&doccreatedateto=<%=todate%>&departmentid=<%=docgroupbyid==0?-1:docgroupbyid%>&isreply=<%=isreply%>&docpublishtype=<%=publish%>&usertype=1"><%=doccount%></A></TD></TR>	  <%
	  }
		}
	  DocRpManage.closeStatement();
	  bar.addSeries("XXX",list1,"");

	  %>
  <TR class=header>
      <TD align=left ><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%></TD>
    <TD align=right><%=alldoccount%></TD></TR></TBODY></TABLE>
</FORM>
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

	</BODY>
	<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
	</HTML>
