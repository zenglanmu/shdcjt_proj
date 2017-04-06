<%@ page import="weaver.general.Util,java.util.*,java.math.*,java.text.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%
    boolean canview = HrmUserVarify.checkUserRight("FnaTransaction:All", user);

    if (!canview) {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="FnaBudgetInfoComInfo" class="weaver.fna.maintenance.FnaBudgetInfoComInfo" scope="page" />


<HTML><HEAD>
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%

    String fnayear = Util.null2String(request.getParameter("fnayear"));
    String budgetperiods = "";

    if (!fnayear.equals("")) {
        String sqlstr = " select id from FnaYearsPeriods where status <> -1 and fnayear = " + fnayear;
        RecordSet.executeSql(sqlstr);
        if (RecordSet.next()) {
            budgetperiods = RecordSet.getString("id");
        } else {
            fnayear = "";
            budgetperiods = "";
        }
    }

    if (fnayear.equals("")) {
        //如果未取到，取得默认生效期间
        String sqlstr = " select id,fnayear from FnaYearsPeriods where status = 1 ";
        RecordSet.executeSql(sqlstr);
        if (RecordSet.next()) {
            budgetperiods = RecordSet.getString("id");
            fnayear = RecordSet.getString("fnayear");
        } else {
            //如果未取到，取最大年
            RecordSet.executeProc("FnaYearsPeriods_SelectMaxYear", "");
            if (RecordSet.next()) {
                budgetperiods = RecordSet.getString("id");
                fnayear = RecordSet.getString("fnayear");
            }
        }
    }

    String fnayearstartdate = "";
    String fnayearenddate = "";

    RecordSet.executeSql("select startdate, enddate , Periodsid from FnaYearsPeriodsList where fnayear= '" + fnayear + "' and ( Periodsid = 1 or Periodsid = 12 ) ");
    while (RecordSet.next()) {
        String Periodsid = Util.null2String(RecordSet.getString("Periodsid"));
        if (Periodsid.equals("1")) fnayearstartdate = Util.null2String(RecordSet.getString("startdate"));
        if (Periodsid.equals("12")) fnayearenddate = Util.null2String(RecordSet.getString("enddate"));
    }


    String departmentidsql = "";
    String departmentidsql2 = "";
    String rightlevel = HrmUserVarify.getRightLevel("FnaTransaction:All", user);

//预算

    if (rightlevel.equals("2")) departmentidsql = "";
    else if (rightlevel.equals("1")) {
        departmentidsql = " and budgetorganizationid in ( select id from HrmDepartment where subcompanyid1 = " + user.getUserSubCompany1() + ")";
        departmentidsql2 = " where subcompanyid1 = " + user.getUserSubCompany1();
    } else {
        departmentidsql = " and budgetorganizationid = " + user.getUserDepartment();
        departmentidsql2 = " where id = " + user.getUserDepartment();
    }

    String sqlstr = " select a.budgetorganizationid, max(a.status) as status, sum(b.budgetaccount) as budgetaccount , c.feetype " +
            " from FnaBudgetInfo a ,FnaBudgetInfoDetail b , FnaBudgetfeeType c " +
            " where a.id = b.budgetinfoid and b.budgettypeid = c.id and a.organizationtype = 2 " +
            " and a.status = 1 and a.budgetperiods = " + budgetperiods;

    if (!departmentidsql.equals("")) sqlstr += departmentidsql;

    sqlstr += " group by budgetorganizationid, feetype ";

    ArrayList departmentidfeetypes = new ArrayList();
    ArrayList budgetstatuss = new ArrayList();
    ArrayList budgetaccounts = new ArrayList();

    RecordSet.executeSql(sqlstr);
    NumberFormat formatter = new DecimalFormat("0.00");
    while (RecordSet.next()) {
        String tempdepartmentid = Util.null2String(RecordSet.getString(1));
        String tempbudgetstatus = Util.null2String(RecordSet.getString(2));
        String tempaccount = formatter.format(Util.getDoubleValue(RecordSet.getString(3), 0));
        String tempfeetype = Util.null2String(RecordSet.getString(4));

        if (tempaccount.equals("0.00")) continue;

        departmentidfeetypes.add(tempdepartmentid + "_" + tempfeetype);
        budgetstatuss.add(tempbudgetstatus);
        budgetaccounts.add(tempaccount);
    }

//收入
    if (rightlevel.equals("2")) departmentidsql = "";
    else if (rightlevel.equals("1")) {
        departmentidsql = " and departmentid in ( select id from HrmDepartment where subcompanyid1 = " + user.getUserSubCompany1() + ")";
    } else {
        departmentidsql = " and departmentid = " + user.getUserDepartment();
    }

    sqlstr = " select a.departmentid, sum(a.amount) as budgetaccount , c.feetype" +
            " from FnaAccountLog a ,FnaBudgetfeeType c" +
            " where a.feetypeid = c.id " +
            " and a.iscontractid = 1 and a.occurdate >= '" + fnayearstartdate + "' and a.occurdate <= '" + fnayearenddate + "' ";

    if (!departmentidsql.equals("")) sqlstr += departmentidsql;

    sqlstr += " group by departmentid, feetype ";

    ArrayList edepartmentidfeetypes = new ArrayList();
    ArrayList expenseaccounts = new ArrayList();

    RecordSet.executeSql(sqlstr);
    while (RecordSet.next()) {
        String tempdepartmentid = Util.null2String(RecordSet.getString(1));
        String tempaccount = formatter.format(Util.getDoubleValue(RecordSet.getString(2), 0));
        String tempfeetype = Util.null2String(RecordSet.getString(3));

        if (tempaccount.equals("0.00")) continue;

        edepartmentidfeetypes.add(tempdepartmentid + "_" + tempfeetype);
        expenseaccounts.add(tempaccount);
    }

//费用
    String hrmresourcesql = "";
    if (rightlevel.equals("2")) departmentidsql = "";
    else if (rightlevel.equals("1")) {
        departmentidsql = " and organizationid in ( select id from HrmDepartment where subcompanyid1 = " + user.getUserSubCompany1() + ")";
    	hrmresourcesql = " and b.subcompanyid1 = " + user.getUserSubCompany1();
    } else {
        departmentidsql = " and organizationid = " + user.getUserDepartment();
    	hrmresourcesql = " and b.departmentid = " + user.getUserDepartment();
    }

    sqlstr = " select a.organizationid, c.feetype" +
            " from FnaExpenseInfo a ,FnaBudgetfeeType c " +
            " where a.subject = c.id " +
            " and a.organizationtype = 2 " +
            " and a.occurdate >= '" + fnayearstartdate + "' and a.occurdate <= '" + fnayearenddate + "' ";

    if (!departmentidsql.equals("")) sqlstr += departmentidsql;

	sqlstr +=" union select b.departmentid as organizationid, c.feetype from FnaExpenseInfo a ,FnaBudgetfeeType c ,hrmresource b where a.subject = c.id and b.id=a.organizationid and a.organizationtype = 3 and a.occurdate >= '" + fnayearstartdate + "' and a.occurdate <= '" + fnayearenddate + "' ";
	
    if (!hrmresourcesql.equals("")) sqlstr += hrmresourcesql;

    //sqlstr += " group by organizationid, feetype ";

    ArrayList edepartmentidfeetypes1 = new ArrayList();
    ArrayList expenseaccounts1 = new ArrayList();

    RecordSet.executeSql(sqlstr);
    while (RecordSet.next()) {
        String tempdepartmentid = Util.null2String(RecordSet.getString(1));
        String tempfeetype = Util.null2String(RecordSet.getString(2));
        String tempaccount = formatter.format(FnaBudgetInfoComInfo.getFeeAmount(tempdepartmentid,"2",fnayearstartdate,fnayearenddate));

        if (tempaccount.equals("0.00")) continue;

        edepartmentidfeetypes1.add(tempdepartmentid + "_" + tempfeetype);
        expenseaccounts1.add(tempaccount);
    }

    String imagefilename = "/images/hdReport.gif";
    String titlename = SystemEnv.getHtmlLabelName(428, user.getLanguage());
    String needfav = "1";
    String needhelp = "";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:submitData(),_TOP} ";
    RCMenuHeight += RCMenuHeightStep;
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
<td></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=frmMain name=frmMain action=FnaExpenseDepartment.jsp method=post>
    <TABLE class=viewForm>
        <COLGROUP><COL width="15%"><COL width="85%"> <THEAD>
            <TR class=Title>
                <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15364, user.getLanguage())%></TH>
            </TR>
            <!--added by lupeng 2004.05.13 for TD453.-->
            <TR style="height:2px" ><TD class=Line1 colSpan=5></TD></TR>
            <!--end-->
        </THEAD> <TBODY>
            <tr>
                <td><%=SystemEnv.getHtmlLabelName(15426, user.getLanguage())%></td>
                <td class=Field>
                    <select class=inputstyle name="fnayear" onchange="document.frmMain.submit();">
                        <%
                            sqlstr = "select id,fnayear from FnaYearsPeriods order by fnayear desc";
                            RecordSet.executeSql(sqlstr);
                            while (RecordSet.next()) {
                                String thefnayear = RecordSet.getString("fnayear");
                        %>
                        <option value="<%=thefnayear%>" <% if (thefnayear.equals(fnayear)) {%>
                                selected<%}%>><%=thefnayear%></option>
                        <%}%>
                    </select>
                </td>
            </tr>
            <!--added by lupeng 2004.05.13 for TD453.-->
            <TR style="height:2px" ><TD class=Line colSpan=5></TD></TR>
            <!--end-->
        </TBODY>
        </TABLE>
</FORM>
<TABLE class=ListStyle cellspacing=1>
<COLGROUP><col width="30%"> <col width="10%"> <col width="10%">
<col width="10%"> <col width="10%"> <col width="10%"> <col width="10%">
<col align=right width="10%">
<TR class=header>
    <TH colspan="8">
        <P align=left><%=SystemEnv.getHtmlLabelName(386, user.getLanguage())%></P>
    </TH>
</TR>

<TR class=Header align=left>
    <TD rowspan="2"><%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%></TD>
    <TD style="TEXT-ALIGN: center" colspan="3"><%=SystemEnv.getHtmlLabelName(566, user.getLanguage())%></TD>
    <TD style="TEXT-ALIGN: center" colspan="3"><%=SystemEnv.getHtmlLabelName(629, user.getLanguage())%></TD>
    <TD style="TEXT-ALIGN: center" rowspan="2"><%=SystemEnv.getHtmlLabelName(15427, user.getLanguage())%></TD>
</TR>
<TR class=Header align=left>
    <TD><%=SystemEnv.getHtmlLabelName(386, user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(628, user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15368, user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(386, user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(628, user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15368, user.getLanguage())%></TD>
    <!-- TD style="TEXT-ALIGN: right">&nbsp;</TD -->
</TR>
<TR class=Line><TD colspan="8"></TD></TR>
<TBODY>
    <%
        boolean isLight = false;
        sqlstr = " select id from HrmDepartment ";

        if (!departmentidsql2.equals("")) sqlstr += departmentidsql2;

        RecordSet.executeSql(sqlstr);
        while (RecordSet.next()) {
            double tmpnum1=0d;
            double tmpnum2=0d;
            String departmentidrs = Util.null2String(RecordSet.getString(1));
            String cancelstr = DepartmentComInfo.getDeparmentcanceled(departmentidrs);
            String tempbudgetaccount = "";
            String tempexpenseaccount = "";
            isLight = !isLight;
            if("1".equals(cancelstr)) continue;
    %>
    <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
        <TD><a href='#'
               onclick="return submitDepartment(<%=departmentidrs%>)"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentidrs),user.getLanguage())%><a>
        </TD>
        <TD style="TEXT-ALIGN: right">
            <% int accountindex = departmentidfeetypes.indexOf(departmentidrs + "_2");
                if (accountindex != -1) {
                    tempbudgetaccount = (String) budgetaccounts.get(accountindex);
            %>
            <%=tempbudgetaccount%>
            <% } %>
        </TD>
        <TD style="TEXT-ALIGN: right">
            <% accountindex = edepartmentidfeetypes.indexOf(departmentidrs + "_2");
                int accountindex1 = edepartmentidfeetypes1.indexOf(departmentidrs + "_2");
                if (accountindex != -1) tmpnum1 = Util.getDoubleValue((String) expenseaccounts.get(accountindex));
                if (accountindex1!=-1) tmpnum2 = Util.getDoubleValue((String) expenseaccounts1.get(accountindex1));
                if(tmpnum1!=0||tmpnum2!=0) {
                    tempexpenseaccount = formatter.format((tmpnum2-tmpnum1));
            %>
            <%=tempexpenseaccount%>
            <% } %>
        </TD>
        <TD style="TEXT-ALIGN: right">
            <% if (!tempbudgetaccount.equals("") && !tempexpenseaccount.equals("")) {
                double accountgapdouble = ( Util.getDoubleValue(tempbudgetaccount)-Util.getDoubleValue(tempexpenseaccount)) * 100 / Util.getDoubleValue(tempbudgetaccount);
                int accountgapint = (new Double(accountgapdouble)).intValue();
                //          if( accountgapint < 0 ) accountgapint = accountgapint * (-1) ;
                String tempaccountgap = "";
                if (accountgapint != 0) tempaccountgap = "" + accountgapint;
            %>
            <%=tempaccountgap%>%
            <% 
            }
            tmpnum1=0d;
            tmpnum2=0d;
            accountindex=-1;
            tempbudgetaccount = "";
            tempexpenseaccount = "";
            %>
        </TD>
        <TD style="TEXT-ALIGN: right">
            <% accountindex = departmentidfeetypes.indexOf(departmentidrs + "_1");
                if (accountindex != -1) {
                    tempbudgetaccount = (String) budgetaccounts.get(accountindex);
            %>
            <%=tempbudgetaccount%>
            <% } %>
        </TD>
        <TD style="TEXT-ALIGN: right">
            <%  accountindex = edepartmentidfeetypes.indexOf(departmentidrs + "_1");
                accountindex1 = edepartmentidfeetypes1.indexOf(departmentidrs + "_1");
                if (accountindex != -1) tmpnum1 = Util.getDoubleValue((String) expenseaccounts.get(accountindex));
                if (accountindex1!=-1) tmpnum2 = Util.getDoubleValue((String) expenseaccounts1.get(accountindex1));
                if(tmpnum1!=0||tmpnum2!=0) {
                    tempexpenseaccount = formatter.format((tmpnum2-tmpnum1));
            %>
            <%=tempexpenseaccount%>
            <% } %>
        </TD>
        <TD style="TEXT-ALIGN: right">
            <% if (!tempbudgetaccount.equals("") && !tempexpenseaccount.equals("")) {
                double accountgapdouble = (Util.getDoubleValue(tempbudgetaccount)-Util.getDoubleValue(tempexpenseaccount)) * 100 / Util.getDoubleValue(tempbudgetaccount);
                int accountgapint = (new Double(accountgapdouble)).intValue();
                //           if( accountgapint < 0 ) accountgapint = accountgapint * (-1) ;
                String tempaccountgap = "";
                if (accountgapint != 0) tempaccountgap = "" + accountgapint;
            %>
            <%=tempaccountgap%>%
            <% } %>
        </TD>
        <TD>
            <% accountindex = departmentidfeetypes.indexOf(departmentidrs + "_1");
                if (accountindex == -1) accountindex = departmentidfeetypes.indexOf(departmentidrs + "_2");
                String tempbudgetstatus = "";
                if (accountindex != -1) {
                    tempbudgetstatus = (String) budgetstatuss.get(accountindex);
                    if (tempbudgetstatus.equals("1")) {
            %>
            <%=SystemEnv.getHtmlLabelName(18431, user.getLanguage())%>
            <% } else { %>
            <%=SystemEnv.getHtmlLabelName(2242, user.getLanguage())%>
            <% }
            } %>
        </TD>
    </TR>
    <%}%>
</TBODY>
</TABLE>
<form name="detail" action="FnaExpenseDetail.jsp" method=post>
    <input id=organizationid type=hidden name=organizationid>
    <input id=organizationtype type=hidden name=organizationtype>
    <input id=budgetperiods type=hidden name=budgetperiods value="<%=budgetperiods%>">
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
<%--
<script language=vbs>
    sub onShowDepartment()
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp")
    issame = false
    if (Not IsEmpty(id)) then
    if id(0) < > 0 then
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
--%>
<script language=javascript>
    function submitDepartment(thevalue) {
        detail.organizationid.value = thevalue;
        detail.organizationtype.value = "2";
        detail.submit();
        return false;
    }

    function submitData() {
        frmMain.submit();
    }
</script>
</BODY></HTML>