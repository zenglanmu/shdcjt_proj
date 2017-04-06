<%@ page import="weaver.general.Util,java.util.*,java.math.*,java.text.*" %>
<%@ page import="weaver.fna.budget.BudgetHandler"%>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="AllSubordinate" class="weaver.hrm.resource.AllSubordinate" scope="page"/>


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
boolean canview = HrmUserVarify.checkUserRight("FnaBudget:All",user) ;

String budgetperiods = Util.null2String(request.getParameter("budgetperiods"));//期间ID

String fnayear = "";//期间年

String sqlstr = "";
char separator = Util.getSeparator() ;
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);

//如果期间为空
if("".equals(budgetperiods)) {
	//取前一次操作的期间
	budgetperiods = (String)session.getAttribute("budgetperiods");
	//System.out.println("session budgetperiods:"+budgetperiods);
	if(budgetperiods==null||"".equals(budgetperiods)){
		//如果未取到，取得默认生效期间
		sqlstr =" select id from FnaYearsPeriods where status = 1 ";
		RecordSet.executeSql(sqlstr);
		if(RecordSet.next()) {
			budgetperiods = RecordSet.getString("id");
		} else {
			//如果未取到，取最大年
			RecordSet.executeProc("FnaYearsPeriods_SelectMaxYear","");
			if(RecordSet.next()){
				budgetperiods = RecordSet.getString("id");
			}
		}
		//System.out.println("empty budgetperiods:"+budgetperiods);
	}
} else {
	session.setAttribute("budgetperiods",budgetperiods);
}
//取当前期间的年份
if("".equals(fnayear)) {
	sqlstr = " select fnayear from FnaYearsPeriods where id = " + budgetperiods;
	RecordSet.executeSql(sqlstr);
	if(RecordSet.next()) {
		fnayear = RecordSet.getString("fnayear");
	}
}

//取预算期间年度(预算年度仅显示“生效”和“关闭”状态的预算年度)
List budgetperiodsList = new ArrayList();
List budgetyearsList = new ArrayList();
sqlstr ="select id,fnayear from FnaYearsPeriods where status in (0,1) order by fnayear desc" ;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()) {
	String tempid = Util.null2String(RecordSet.getString(1));
	String tempfnayear = Util.null2String(RecordSet.getString(2));
	budgetperiodsList.add(tempid);
	budgetyearsList.add(tempfnayear);
}
String fnayearstartdate = "" ;
String fnayearenddate = "" ;

RecordSet.executeSql("select startdate, enddate , Periodsid from FnaYearsPeriodsList where fnayear= '"+fnayear+"' and ( Periodsid = 1 or Periodsid = 12 ) ");
while( RecordSet.next() ) {
    String Periodsid = Util.null2String(RecordSet.getString( "Periodsid" ) ) ;
    if( Periodsid.equals("1") ) fnayearstartdate = Util.null2String(RecordSet.getString( "startdate" ) ) ;
    if( Periodsid.equals("12") ) fnayearenddate = Util.null2String(RecordSet.getString( "enddate" ) ) ;
}

String projectidsql = "" ;
String projectidsql2 = "" ;
String subresource = "0" ;
AllSubordinate.getAll( "" +  user.getUID() ) ;
while( AllSubordinate.next() ) {
    subresource += "," + AllSubordinate.getSubordinateID() ;
}

if( !canview ) {
    //projectidsql = " and budgetprojectid in ( select id from Prj_ProjectInfo where manager = " + user.getUID() + " or manager in ( "+ subresource + " ) ) " ;
    projectidsql2 = " where manager = " + user.getUID() + " or manager in ( "+ subresource + " )" ;
}


ArrayList projectidfeetypes = new ArrayList() ;
ArrayList budgetstatuss = new ArrayList() ;
ArrayList budgetaccounts = new ArrayList() ;
//todo:
/*RecordSet.executeSql("select id from Prj_ProjectInfo "+ projectidsql2);
while(RecordSet.next()){
	String tempprojectid = Util.null2String(RecordSet.getString(1)) ;
	String tempbudgetstatus = Util.null2String(RecordSet.getString(2)) ;
	String tempaccount = "" + Util.getDoubleValue(RecordSet.getString(3),0) ;
	String tempfeetype = Util.null2String(RecordSet.getString(4)) ;

	if(tempaccount.equals("0")) continue ;
		
	projectidfeetypes.add(tempprojectid + "_" + tempfeetype ) ;
    budgetstatuss.add( tempbudgetstatus ) ;
    budgetaccounts.add( tempaccount ) ;
}*/

if( !canview ) {
    projectidsql = " and projectid in ( select id from Prj_ProjectInfo where manager = " + user.getUID() + " or manager in ( "+ subresource + " ) ) " ;
}




ArrayList eprojectidfeetypes = new ArrayList() ;
ArrayList expenseaccounts = new ArrayList() ;


sqlstr="select id from Prj_ProjectInfo "+ projectidsql2 ;

RecordSet.executeSql(sqlstr);
    while(RecordSet.next()){
        String tempprojectid = Util.null2String(RecordSet.getString(1)) ;
        //String tempaccount = "" + Util.getDoubleValue(RecordSet.getString(2),0) ;
        //String tempfeetype = Util.null2String(RecordSet.getString(3)) ;
        eprojectidfeetypes.add(tempprojectid + "_1" ) ;
        expenseaccounts.add( ""+BudgetHandler.getExpenseRecursion(fnayearstartdate,fnayearenddate,0,0,0,Util.getIntValue(tempprojectid),0,0).getRealExpense() ) ;
    }
 sqlstr= "select projectid,sum(amount) as total from fnaaccountlog t1,FnaBudgetfeeType t2 where t1.feetypeid = t2.id and feetype = 2 and occurdate>='"+fnayearstartdate+"' and occurdate<='"+fnayearenddate+"' and iscontractid='1' "+projectidsql+" group by projectid";
 //System.out.println(sqlstr);
RecordSet.executeSql(sqlstr);
NumberFormat formatter = new DecimalFormat("0.00");
while(RecordSet.next()){
	String tempprojectid = Util.null2String(RecordSet.getString(1)) ;
	String tempaccount = formatter.format(Util.getDoubleValue(RecordSet.getString(2),0)) ;
    eprojectidfeetypes.add(tempprojectid + "_2" ) ;
    expenseaccounts.add(tempaccount);
}

 sqlstr= "select projectid,sum(amount) as total from fnaaccountlog t1,FnaBudgetfeeType t2 where t1.feetypeid = t2.id and feetype = 1 and occurdate>='"+fnayearstartdate+"' and occurdate<='"+fnayearenddate+"' and iscontractid='1' "+projectidsql+" group by projectid";
 //System.out.println(sqlstr);
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String tempprojectid = Util.null2String(RecordSet.getString(1)) ;
	String tempaccount = formatter.format(Util.getDoubleValue(RecordSet.getString(2),0) );
    eprojectidfeetypes.add(tempprojectid + "_3" ) ;
    expenseaccounts.add(tempaccount);
}

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(428,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<!--<col width="10">-->
</colgroup>
<tr>
<td height="10" colspan="2"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=frmMain name=frmMain action=FnaExpenseProject.jsp method=post>
  <TABLE class=viewForm>
    <COLGROUP> <COL width="15%"><COL width="85%"></colgroup> <THEAD>
    <TR class=Title> 
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></TH>
    </TR>
    </THEAD> <TBODY> 
  
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(15426,user.getLanguage())%></td>
      <td class=Field> 
        <select class=inputstyle class=inputstle name="budgetperiods" onchange="document.frmMain.submit();">
         <%for(int i=0;i<budgetyearsList.size();i++){%>
			<option value="<%=budgetperiodsList.get(i)%>"<%if(budgetperiods.equals((String)budgetperiodsList.get(i))) out.print("selected");%>><%=budgetyearsList.get(i)%></option>
		<%}%>
        </select>
      </td>
    </tr>
    </TBODY> 
  </TABLE>
</FORM>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP> <col width="50%"> <col width="25%"> <col width="25%">
  <%--<col width="10%"> <col width="10%"> <col width="10%"> <col width="10%">
  <col align=right width="10%">--%>
  </colgroup>
  <TR class=Header> 
    <TH colspan="3">
      <P align=left><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></P>
    </TH>
  </TR>
  
  <TR class=Header align=left> 
    <TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TD>
    <TD style="TEXT-ALIGN: center" ><%=SystemEnv.getHtmlLabelName(566,user.getLanguage())%></TD>
    <TD style="TEXT-ALIGN: center" ><%=SystemEnv.getHtmlLabelName(629,user.getLanguage())%></TD>
    <%--<TD style="TEXT-ALIGN: center" rowspan="2"><%=SystemEnv.getHtmlLabelName(15427,user.getLanguage())%></TD>--%>
  </TR>
 <%-- <TR class=Header align=left>
    <TD><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(628,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15368,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(628,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15368,user.getLanguage())%></TD>
    <!-- TD style="TEXT-ALIGN: right">&nbsp;</TD -->
  </TR>--%>
<TR class=Line><TD colspan="3" ></TD></TR>
  <TBODY> 
  <%
    boolean isLight = false;
    sqlstr = " select id from Prj_ProjectInfo " ;
    if(!projectidsql2.equals("")) sqlstr += projectidsql2 ;
    sqlstr += " order by id desc " ;
     // System.out.println(sqlstr);
    RecordSet.executeSql(sqlstr);
    while(RecordSet.next()){
        String projectidrs = Util.null2String(RecordSet.getString(1)) ;
        String tempbudgetaccount = "" ;
        String tempexpenseaccount = "0.0" ;
        isLight = !isLight ;
%>
 <TR class='<%=( isLight ? "datalight" : "datadark" )%>'> 
    <TD><a href='#' onclick="return submitResource(<%=projectidrs%>)"><%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(projectidrs),user.getLanguage())%></a></TD>
    <%--<TD style="TEXT-ALIGN: right">
    <%  int accountindex = projectidfeetypes.indexOf(projectidrs+"_2") ;
        //System.out.println(accountindex);
        if( accountindex!=-1) {
            tempbudgetaccount = (String) budgetaccounts.get(accountindex) ;
    %>
    <%=tempbudgetaccount%>
    <%  } %>
    </TD>--%>
    <TD style="TEXT-ALIGN: right">
    <%  int accountindex = eprojectidfeetypes.indexOf(projectidrs+"_2") ;
        //System.out.println(accountindex);
        if( accountindex!=-1) {
            tempexpenseaccount = (String) expenseaccounts.get(accountindex) ;
    } %>
    <%=tempexpenseaccount%>
    </TD>
    <%--<TD style="TEXT-ALIGN: right">
    <%  if( !tempbudgetaccount.equals("") && !tempexpenseaccount.equals("") ) {
            double accountgapdouble =  ( Util.getDoubleValue(tempexpenseaccount) - Util.getDoubleValue(tempbudgetaccount) ) * 100 / Util.getDoubleValue(tempbudgetaccount) ;
            int accountgapint = (new Double( accountgapdouble )).intValue() ;
  //          if( accountgapint < 0 ) accountgapint = accountgapint * (-1) ;
            String tempaccountgap = "" ;
            if( accountgapint != 0 ) tempaccountgap =formatter.format(accountgapint) ;
    %>
    <%=tempaccountgap%>%
    <%  } %>
    </TD>--%>
    <%--<TD style="TEXT-ALIGN: right">
    <%  accountindex = projectidfeetypes.indexOf(projectidrs+"_1") ;
        //System.out.println(accountindex);
        if( accountindex!=-1) {
            tempbudgetaccount = (String) budgetaccounts.get(accountindex) ;
    %>
    <%=tempbudgetaccount%>
    <%  } %>
    </TD>--%>
    <TD style="TEXT-ALIGN: right">
    <%  accountindex = eprojectidfeetypes.indexOf(projectidrs+"_1") ;
        int accountindex1 = eprojectidfeetypes.indexOf(projectidrs+"_3") ;
        if( accountindex!=-1) {
            tempexpenseaccount = (String) expenseaccounts.get(accountindex) ;
        } 
        if(accountindex1 != -1){
            tempexpenseaccount = formatter.format(Util.getDoubleValue(tempexpenseaccount,0)+Util.getDoubleValue((String)expenseaccounts.get(accountindex1),0));
        }
    %>
    <%=tempexpenseaccount%>
    </TD>
    <%--<TD style="TEXT-ALIGN: right">
    <%  if( !tempbudgetaccount.equals("") && !tempexpenseaccount.equals("") ) {
            double accountgapdouble =  ( Util.getDoubleValue(tempexpenseaccount) - Util.getDoubleValue(tempbudgetaccount) ) * 100 / Util.getDoubleValue(tempbudgetaccount) ;
            int accountgapint = (new Double( accountgapdouble )).intValue() ;
 //           if( accountgapint < 0 ) accountgapint = accountgapint * (-1) ;
            String tempaccountgap = "" ;
            if( accountgapint != 0 ) tempaccountgap =formatter.format(accountgapint );
    %>
    <%=tempaccountgap%>%
    <%  } %>
    </TD>--%>
  <%--  <TD>

    </TD>--%>
  </TR> 
<%}%>
</TBODY> 
</TABLE>
<form name="detail" action="FnaExpenseProjectDetail.jsp" method=post>
  <input class=inputstle id=projectid type=hidden name=projectid >
  <input class=inputstle id=fnayear type=hidden name=fnayear value="<%=fnayear%>">
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
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmMain.resourceid.value)
	issame = false 
	if (Not IsEmpty(id)) then
		if id(0)<> 0 then
			if id(0) = frmMain.resourceid.value then
				issame = true 
			end if
			departmentspan.innerHtml = id(1)
			frmMain.resourceid.value=id(0)
		else
			departmentspan.innerHtml = ""
			frmMain.resourceid.value=""
		end if
		
		if issame = false then
			budgetcostercenteridspan.innerHtml = ""
			frmMain.budgetcostercenterid.value=""
			budgetresourceidspan.innerHtml = ""
			frmMain.budgetresourceid.value=""
		end if
	end if
end sub
</script>

<script language=javascript>
function submitResource(thevalue) {
    detail.projectid.value=thevalue ;
    detail.submit() ;
    return false;
}

</script>
</BODY>
</HTML>