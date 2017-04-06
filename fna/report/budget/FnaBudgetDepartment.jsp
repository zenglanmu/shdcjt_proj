<%@ page import="weaver.general.Util,java.util.*,java.math.*,java.text.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<jsp:useBean id="FnaBudgetInfoComInfo" class="weaver.fna.maintenance.FnaBudgetInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%@ include file="/systeminfo/init.jsp" %>
<% 
boolean canview = HrmUserVarify.checkUserRight("SubBudget:Maint",user) ;

if(!canview) {
	response.sendRedirect("/notice/noright.jsp") ; 
	return ; 
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String fnayear = Util.null2String(request.getParameter("fnayear")) ; 
String budgetperiods = "";

    if(!fnayear.equals("")){
        String sqlstr =" select id from FnaYearsPeriods where status <> -1 and fnayear = " + fnayear;
        RecordSet.executeSql(sqlstr);
        if(RecordSet.next()) {
            budgetperiods = RecordSet.getString("id");
        } else {
            fnayear = "";
            budgetperiods = "";
        }
    }

if(fnayear.equals("")) {
    //如果未取到，取得默认生效期间
    String sqlstr =" select id,fnayear from FnaYearsPeriods where status = 1 ";
    RecordSet.executeSql(sqlstr);
    if(RecordSet.next()) {
        budgetperiods = RecordSet.getString("id");
        fnayear = RecordSet.getString("fnayear");
    } else {
        //如果未取到，取最大年
        RecordSet.executeProc("FnaYearsPeriods_SelectMaxYear","");
        if(RecordSet.next()){
            budgetperiods = RecordSet.getString("id");
            fnayear = RecordSet.getString("fnayear");
        }
    }
}

String departmentidsql = "" ; 
String departmentidsql2 = "" ; 

if(canview) {
    String rightlevel = HrmUserVarify.getRightLevel("SubBudget:Maint",user) ;
    if( rightlevel.equals("2") ) departmentidsql = "" ;
    else if( rightlevel.equals("1") ) {
        departmentidsql = " and budgetorganizationid in ( select id from HrmDepartment where subcompanyid1 = "+ user.getUserSubCompany1() + ")" ;
        departmentidsql2 = " where subcompanyid1 = "+ user.getUserSubCompany1() ;
    } else {
        departmentidsql = " and budgetorganizationid = "+ user.getUserDepartment() ;
        departmentidsql2 = " where id = "+ user.getUserDepartment() ;
    }
}

String sqlstr =" select a.budgetorganizationid, max(a.status) as status, sum(b.budgetaccount) as budgetaccount , c.feetype " +
        " from FnaBudgetInfo a ,FnaBudgetInfoDetail b , FnaBudgetfeeType c " +
        " where a.id = b.budgetinfoid and b.budgettypeid = c.id and a.organizationtype = 2 " +
        " and a.status =1 and a.budgetperiods = " + budgetperiods;

if(!departmentidsql.equals("")) sqlstr += departmentidsql ; 

sqlstr += " group by budgetorganizationid, feetype " ;
ArrayList departmentidfeetypes = new ArrayList() ; 
ArrayList budgetstatuss = new ArrayList() ;
ArrayList budgetaccounts = new ArrayList() ;

RecordSet.executeSql(sqlstr) ;
NumberFormat formatter = new DecimalFormat("0.00");
while(RecordSet.next()) { 
	String tempdepartmentid = Util.null2String(RecordSet.getString(1)) ; 
	String tempbudgetstatus = Util.null2String(RecordSet.getString(2)) ; 
	String tempaccount = formatter.format(Util.getDoubleValue(RecordSet.getString(3) , 0));
	String tempfeetype = Util.null2String(RecordSet.getString(4)) ;

    if(tempaccount.equals("0.00")) continue ;

    departmentidfeetypes.add(tempdepartmentid + "_" + tempfeetype ) ;
    budgetstatuss.add( tempbudgetstatus ) ; 
    budgetaccounts.add( tempaccount ) ; 
}

String imagefilename = "/images/hdReport.gif" ;
String titlename = SystemEnv.getHtmlLabelName(386 , user.getLanguage()) ; 
String needfav = "1" ;
String needhelp = "" ; 
%>
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
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=frmMain name=frmMain action=FnaBudgetDepartment.jsp method=post>
<br>
  <TABLE class=ViewForm>  
    <COLGROUP> <COL width="15%"><COL width="85%"> <THEAD> 
    <TR class=Title> 
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></TH>
    </TR>
    </THEAD> <TBODY> 
    <TR class=Spacing> 
      <TD class=Line1 colSpan=2></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(15365,user.getLanguage())%></td>
      <td class=Field> 
        <select class=inputstyle name="fnayear" onchange="document.frmMain.submit();">
        <%
         sqlstr ="select id,fnayear from FnaYearsPeriods order by fnayear desc" ;
         RecordSet.executeSql(sqlstr);
         while(RecordSet.next()) {
        	 String thefnayear = RecordSet.getString("fnayear") ;
		%>
          <option value="<%=thefnayear%>" <% if(thefnayear.equals(fnayear)) {%>selected<%}%>><%=thefnayear%></option>
        <%}%>
        </select>
      </td>
    </tr>
    </TBODY> 
  </TABLE>
</FORM>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <col width="30%">
  <col width="25%">
  <col width="25%">
  <col align=right width="20%">
  <TR class=Header> 
    <TH colspan="4">
      <P align=left><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></P>
    </TH>
  </TR>
  <TR class=Header align=left> 
    <TD <%--for meeting requirement discussion on 2006.04.24rowspan="2"--%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD style="TEXT-ALIGN: center"<%--for meeting requirement discussion on 2006.04.24colspan="3"--%>><%=SystemEnv.getHtmlLabelName(566,user.getLanguage())%></TD>
    <TD style="TEXT-ALIGN: center"<%--for meeting requirement discussion on 2006.04.24colspan="3"--%>><%=SystemEnv.getHtmlLabelName(629,user.getLanguage())%></TD>
    <TD style="TEXT-ALIGN: center"<%--for meeting requirement discussion on 2006.04.24rowspan="2"--%>><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
  </TR>
  <%--for meeting requirement discussion on 2006.04.24
  <TR class=Header align=left> 
    <TD><%=SystemEnv.getHtmlLabelName(15366,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15367,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15368,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15366,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15367,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15368,user.getLanguage())%></TD>
    <!-- TD style="TEXT-ALIGN: right">&nbsp;</TD -->
  </TR>
  --%>
  <TR class=Line><TD colspan="4" ></TD></TR>
  <TBODY> 
  <%
    boolean isLight = false ; 
    sqlstr = " select id from HrmDepartment " ; 

    if(!departmentidsql2.equals("")) sqlstr += departmentidsql2 ; 

    RecordSet.executeSql(sqlstr) ; 
    while(RecordSet.next()) {
    	String departmentidrs = Util.null2String(RecordSet.getString(1)) ; 
        String cancelstr = DepartmentComInfo.getDeparmentcanceled(departmentidrs);
        String tempbudgetaccount = "" ; 
        String ctempbudgetaccount = "" ; 
        isLight = !isLight ; 
        if("1".equals(cancelstr)) continue;
%>
 <TR class='<%=( isLight ? "datalight" : "datadark" )%>'> 
    <TD><a href='#' onclick="return submitDepartment(<%=departmentidrs%>)"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentidrs),user.getLanguage())%><a></TD>
    <TD style="TEXT-ALIGN: right">
    <%  int accountindex = departmentidfeetypes.indexOf(departmentidrs+"_2") ;
        if( accountindex!=-1) {
            tempbudgetaccount = (String) budgetaccounts.get(accountindex) ;
            ctempbudgetaccount = (String) budgetaccounts.get(accountindex) ;
    %>
    <%=tempbudgetaccount%>
    <%  } %>
    </TD>
    <%--for meeting requirement discussion on 2006.04.24
    <TD style="TEXT-ALIGN: right">
    <%
        if( accountindex!=-1) {
    %>
    <%=ctempbudgetaccount%>
    <%  } %>
    </TD>
    <TD style="TEXT-ALIGN: right">
    <%  if( !tempbudgetaccount.equals("") && !ctempbudgetaccount.equals("") ) {
            double accountgapdouble =  ( Util.getDoubleValue(tempbudgetaccount)  - Util.getDoubleValue(ctempbudgetaccount) ) * 100 / Util.getDoubleValue(ctempbudgetaccount) ;
            int accountgapint = (new Double( accountgapdouble )).intValue() ;
            if( accountgapint < 0 ) accountgapint = accountgapint * (-1) ;
            String tempaccountgap = "" ; 
            if( accountgapint != 0 ) tempaccountgap = "" + accountgapint ;
    %>
    <%=tempaccountgap%>%
    <%  } %>
    </TD>
    --%>
    <TD style="TEXT-ALIGN: right">
    <%  accountindex = departmentidfeetypes.indexOf(departmentidrs+"_1") ;
        if( accountindex!=-1) {
            tempbudgetaccount = (String) budgetaccounts.get(accountindex) ;
            ctempbudgetaccount = (String) budgetaccounts.get(accountindex) ;
    %>
    <%=tempbudgetaccount%>
    <%  } %>
    </TD>
    <%--for meeting requirement discussion on 2006.04.24
    <TD style="TEXT-ALIGN: right">
    <%
        if( accountindex!=-1) {
    %>
    <%=ctempbudgetaccount%>
    <%  } %>
    </TD>
    <TD style="TEXT-ALIGN: right">
    <%  if( !tempbudgetaccount.equals("") && !ctempbudgetaccount.equals("") ) {
            double accountgapdouble =  ( Util.getDoubleValue(tempbudgetaccount)  - Util.getDoubleValue(ctempbudgetaccount) ) * 100 / Util.getDoubleValue(ctempbudgetaccount) ;
            int accountgapint = (new Double( accountgapdouble )).intValue() ;
            if( accountgapint < 0 ) accountgapint = accountgapint * (-1) ;
            String tempaccountgap = "" ;
            if( accountgapint != 0 ) tempaccountgap = "" + accountgapint ;
    %>
    <%=tempaccountgap%>%
    <%  } %>
    </TD>
    --%>
    <TD>
    <%  accountindex = departmentidfeetypes.indexOf(departmentidrs+"_1") ;
        if( accountindex ==-1) accountindex = departmentidfeetypes.indexOf(departmentidrs+"_2") ;
        String tempbudgetstatus = "" ;
        if( accountindex!=-1) {
            tempbudgetstatus = (String) budgetstatuss.get(accountindex) ;
            if( tempbudgetstatus.equals("1") ) {
    %>
        <%=SystemEnv.getHtmlLabelName(18431,user.getLanguage())%>
    <%      } else if( tempbudgetstatus.equals("3")){ %>
        <%=SystemEnv.getHtmlLabelName(2242,user.getLanguage())%>
    <%      } 
        } %>
    </TD>
  </TR>
<%}%>
</TBODY> 
</TABLE>
<form name="detail" action="/fna/budget/FnaBudgetView.jsp" method=post>
  <input class=inputstyle id=organizationid type=hidden name=organizationid >
  <input class=inputstyle id=organizationtype type=hidden name=organizationtype>
  <input class=inputstyle id=budgetperiods type=hidden name=budgetperiods value="<%=budgetperiods%>">
</form>

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
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmMain.departmentid.value)
	issame = false 
	if (Not IsEmpty(id)) then
		if id(0)<> 0 then
			if id(0) = frmMain.departmentid.value then
				issame = true 
			end if
			departmentspan.innerHtml = id(1)
			frmMain.departmentid.value = id(0)
		else
			departmentspan.innerHtml = ""
			frmMain.departmentid.value = ""
		end if
		
		if issame = false then
			budgetcostercenteridspan.innerHtml = ""
			frmMain.budgetcostercenterid.value = ""
			budgetresourceidspan.innerHtml = ""
			frmMain.budgetresourceid.value = ""
		end if
	end if
end sub
</script>

<script language=javascript>
function submitDepartment(thevalue) { 
    detail.organizationid.value=thevalue ;
    detail.organizationtype.value="2";
    detail.submit() ; 
    return false ; 
}

</script>
</BODY></HTML>
