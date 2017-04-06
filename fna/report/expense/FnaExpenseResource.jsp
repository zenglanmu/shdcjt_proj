<%@ page import="weaver.general.Util,java.util.*,java.math.*,java.text.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>


<HTML><HEAD>
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
    boolean canview = HrmUserVarify.checkUserRight("FnaTransaction:All", user);

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

    String resourceidsql = "";
    String resourceidsql2 = "";

    String managerstr = "";
    RecordSet.executeSql(" select managerstr from hrmresource where id = " + user.getUID());
    if (RecordSet.next()) managerstr = Util.null2String(RecordSet.getString(1));

    //预算
    if (canview) {
        String rightlevel = HrmUserVarify.getRightLevel("FnaTransaction:All", user);
        if (rightlevel.equals("2")) resourceidsql = "";
        else if (rightlevel.equals("1")) {
            resourceidsql = " and budgetorganizationid in ( select id from HrmResource where id = " + user.getUID() + " or subcompanyid1 = " + user.getUserSubCompany1() + " or managerstr like '" + managerstr + user.getUID() + ",%' )";
            resourceidsql2 = " where ( id = " + user.getUID() + " or subcompanyid1 = " + user.getUserSubCompany1() + " or managerstr like '" + managerstr + user.getUID() + ",%' ) ";
        } else {
            resourceidsql = " and budgetorganizationid in ( select id from HrmResource where id = " + user.getUID() + " or departmentid = " + user.getUserDepartment() + " or managerstr like '" + managerstr + user.getUID() + ",%' ) ";
            resourceidsql2 = " where ( id = " + user.getUID() + " or departmentid = " + user.getUserDepartment() + " or managerstr like '" + managerstr + user.getUID() + ",%' ) ";
        }
    } else {
        resourceidsql = " and budgetorganizationid in ( select id from HrmResource where id = " + user.getUID() + " or managerstr like '" + managerstr + user.getUID() + ",%') ";
        resourceidsql2 = " where ( id = " + user.getUID() + " or managerstr like '" + managerstr + user.getUID() + ",%' ) ";
    }

    String sqlstr = " select a.budgetorganizationid, max(a.status) as status, sum(b.budgetaccount) as budgetaccount , c.feetype " +
            " from FnaBudgetInfo a ,FnaBudgetInfoDetail b , FnaBudgetfeeType c " +
            " where a.id = b.budgetinfoid and b.budgettypeid = c.id and a.organizationtype = 3 " +
            " and a.status =1 and a.budgetperiods = " + budgetperiods;

    if (!resourceidsql.equals("")) sqlstr += resourceidsql;

    sqlstr += " group by budgetorganizationid, feetype ";

    ArrayList resourceidfeetypes = new ArrayList();
    ArrayList budgetstatuss = new ArrayList();
    ArrayList budgetaccounts = new ArrayList();

    RecordSet.executeSql(sqlstr);
    NumberFormat formatter = new DecimalFormat("0.00");
    while (RecordSet.next()) {
        String tempresourceid = Util.null2String(RecordSet.getString(1));
        String tempbudgetstatus = Util.null2String(RecordSet.getString(2));
        String tempaccount = formatter.format(Util.getDoubleValue(RecordSet.getString(3), 0));
        String tempfeetype = Util.null2String(RecordSet.getString(4));

        if (tempaccount.equals("0.00")) continue;

        resourceidfeetypes.add(tempresourceid + "_" + tempfeetype);
        budgetstatuss.add(tempbudgetstatus);
        budgetaccounts.add(tempaccount);
    }

    //收入
    if (canview) {
        String rightlevel = HrmUserVarify.getRightLevel("FnaTransaction:All", user);
        if (rightlevel.equals("2")) resourceidsql = "";
        else if (rightlevel.equals("1")) {
            resourceidsql = " and resourceid in ( select id from HrmResource where id = " + user.getUID() + " or subcompanyid1 = " + user.getUserSubCompany1() + " or managerstr like '" + managerstr + user.getUID() + ",%' )";
        } else {
            resourceidsql = " and resourceid in ( select id from HrmResource where id = " + user.getUID() + " or departmentid = " + user.getUserDepartment() + " or managerstr like '" + managerstr + user.getUID() + ",%' ) ";
        }
    } else {
        resourceidsql = " and resourceid in ( select id from HrmResource where id = " + user.getUID() + " or managerstr like '" + managerstr + user.getUID() + ",%') ";
    }

    sqlstr = " select a.resourceid, sum(a.amount) as budgetaccount , c.feetype from FnaAccountLog a ,FnaBudgetfeeType c where a.feetypeid = c.id and a.iscontractid = 1 and a.occurdate >= '" + fnayearstartdate + "' and a.occurdate <= '" + fnayearenddate + "' ";

    if (!resourceidsql.equals("")) sqlstr += resourceidsql;

    sqlstr += " group by resourceid, feetype ";

    ArrayList eresourceidfeetypes = new ArrayList();
    ArrayList expenseaccounts = new ArrayList();

    RecordSet.executeSql(sqlstr);
    while (RecordSet.next()) {
        String tempresourceid = Util.null2String(RecordSet.getString(1));
        String tempaccount = formatter.format(Util.getDoubleValue(RecordSet.getString(2), 0));
        String tempfeetype = Util.null2String(RecordSet.getString(3));

        if (tempaccount.equals("0.00")) continue;

        eresourceidfeetypes.add(tempresourceid + "_" + tempfeetype);
        expenseaccounts.add(tempaccount);
    }

    //费用
    if (canview) {
        String rightlevel = HrmUserVarify.getRightLevel("FnaTransaction:All", user);
        if (rightlevel.equals("2")) resourceidsql = "";
        else if (rightlevel.equals("1")) {
            resourceidsql = " and a.organizationid in ( select id from HrmResource where id = " + user.getUID() + " or subcompanyid1 = " + user.getUserSubCompany1() + " or managerstr like '" + managerstr + user.getUID() + ",%' )";
        } else {
            resourceidsql = " and a.organizationid in ( select id from HrmResource where id = " + user.getUID() + " or departmentid = " + user.getUserDepartment() + " or managerstr like '" + managerstr + user.getUID() + ",%' ) ";
        }
    } else {
        resourceidsql = " and a.organizationid in ( select id from HrmResource where id = " + user.getUID() + " or managerstr like '" + managerstr + user.getUID() + ",%') ";
    }

    sqlstr = " select a.organizationid, sum(a.amount) as budgetaccount , c.feetype" +
            " from FnaExpenseInfo a ,FnaBudgetfeeType c " +
            " where a.subject = c.id " +
            " and a.organizationtype = 3 " +
            " and a.occurdate >= '" + fnayearstartdate + "' and a.occurdate <= '" + fnayearenddate + "' ";

    if (!resourceidsql.equals("")) sqlstr += resourceidsql;

    sqlstr += " group by organizationid, feetype ";

    ArrayList eresourceidfeetypes1 = new ArrayList();
    ArrayList expenseaccounts1 = new ArrayList();

    RecordSet.executeSql(sqlstr);
    while (RecordSet.next()) {
        String tempresourceid = Util.null2String(RecordSet.getString(1));
        String tempaccount = formatter.format(Util.getDoubleValue(RecordSet.getString(2), 0));
        String tempfeetype = Util.null2String(RecordSet.getString(3));

        if (tempaccount.equals("0.00")) continue;

        eresourceidfeetypes1.add(tempresourceid + "_" + tempfeetype);
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


<FORM id=frmMain name=frmMain action="FnaExpenseResource.jsp" method=post>
    <TABLE class=viewForm>
        <COLGROUP><COL width="15%"><COL width="85%"> <THEAD>
            <TR class=Title>
                <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15364, user.getLanguage())%></TH>
            </TR>
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
        </TBODY>
        </TABLE>
</FORM>

<TABLE class=ListStyle cellspacing=1>
<COLGROUP>
<col width="30%">
<col width="10%">
<col width="10%">
<col width="10%">
<col width="10%">
<col width="10%">
<col width="10%">
<col align=right width="10%">
<TR class=Header>
    <TH colspan="8">
        <P align=left><%=SystemEnv.getHtmlLabelName(386, user.getLanguage())%></P>
    </TH>
</TR>

<TR class=Header align=left>
    <TD rowspan="2"><%=SystemEnv.getHtmlLabelName(179, user.getLanguage())%></TD>
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
        sqlstr = " select id from HrmResource ";

        if (!resourceidsql2.equals("")) sqlstr += resourceidsql2;

        RecordSet.executeSql(sqlstr);
        while (RecordSet.next()) {
            double tmpnum1=0d;
            double tmpnum2=0d;
            String resourceidrs = Util.null2String(RecordSet.getString(1));
            String tempbudgetaccount = "";
            String tempexpenseaccount = "";
            isLight = !isLight;
    %>
    <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>

        <TD><a href='#'
               onclick="return submitResource(<%=resourceidrs%>)"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceidrs),user.getLanguage())%><a>
        </TD>

        <TD style="TEXT-ALIGN: right">
            <% int accountindex = resourceidfeetypes.indexOf(resourceidrs + "_2");
                if (accountindex != -1) {
                    tempbudgetaccount = (String) budgetaccounts.get(accountindex);
            %>
            <%=tempbudgetaccount%>
            <% } %>
        </TD>
        <TD style="TEXT-ALIGN: right">
            <%  accountindex = eresourceidfeetypes.indexOf(resourceidrs + "_2");
                int accountindex1 = eresourceidfeetypes1.indexOf(resourceidrs + "_2");
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
                String tempaccountgap = "";
                if (accountgapint != 0) tempaccountgap = formatter.format(accountgapint);
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
            <% accountindex = resourceidfeetypes.indexOf(resourceidrs + "_1");
                if (accountindex != -1) {
                    tempbudgetaccount = (String) budgetaccounts.get(accountindex);
            %>
            <%=tempbudgetaccount%>
            <% } %>
        </TD>
        <TD style="TEXT-ALIGN: right">
            <%  accountindex = eresourceidfeetypes.indexOf(resourceidrs + "_1");
                accountindex1 = eresourceidfeetypes1.indexOf(resourceidrs + "_1");
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
                if (accountgapint != 0) tempaccountgap = formatter.format(accountgapint);
            %>
            <%=tempaccountgap%>%
            <% } %>
        </TD>
        <TD>
            <% accountindex = resourceidfeetypes.indexOf(resourceidrs + "_1");
                if (accountindex == -1) accountindex = resourceidfeetypes.indexOf(resourceidrs + "_2");
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
    if id(0) = frmMain.resourceid.value then
    issame = true
    end if
            departmentspan.innerHtml = id(1)
        frmMain.resourceid.value = id(0)
    else
        departmentspan.innerHtml = ""
    frmMain.resourceid.value = ""
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
    function submitResource(thevalue) {
        detail.organizationid.value = thevalue;
        detail.organizationtype.value = "3";
        detail.submit();
        return false;
    }
    function submitData() {
        frmMain.submit();
    }
</script>
</BODY></HTML>
