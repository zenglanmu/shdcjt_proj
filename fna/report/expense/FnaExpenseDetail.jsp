<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,weaver.general.TimeUtil,java.util.*,java.math.*,java.text.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet4" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="FnaBudgetInfoComInfo" class="weaver.fna.maintenance.FnaBudgetInfoComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page"/>
<%
    boolean canView = true;//可查看

    String organizationid = Util.null2String(request.getParameter("organizationid"));//组织ID
    String organizationtype = Util.null2String(request.getParameter("organizationtype"));//组织类型
    String budgetperiods = Util.null2String(request.getParameter("budgetperiods"));//期间ID

    String budgetyears = "";//期间年

    String sqlstr = "";
    char separator = Util.getSeparator();
    Calendar today = Calendar.getInstance();
    String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
            Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
            Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);

//如果期间为空
    if ("".equals(budgetperiods)) {
        //取前一次操作的期间
        budgetperiods = (String) session.getAttribute("budgetperiods");
        //System.out.println("session budgetperiods:"+budgetperiods);
        if (budgetperiods == null || "".equals(budgetperiods)) {
            //如果未取到，取得默认生效期间
            sqlstr = " select id from FnaYearsPeriods where status = 1 ";
            RecordSet.executeSql(sqlstr);
            if (RecordSet.next()) {
                budgetperiods = RecordSet.getString("id");
            } else {
                //如果未取到，取最大年
                RecordSet.executeProc("FnaYearsPeriods_SelectMaxYear", "");
                if (RecordSet.next()) {
                    budgetperiods = RecordSet.getString("id");
                }
            }
            //System.out.println("empty budgetperiods:"+budgetperiods);
        }
    } else {
        session.setAttribute("budgetperiods", budgetperiods);
    }

//如果组织为空，取得当前期间默认总公司
//检查权限
    int right = -1;//-1：禁止、0：只读、1：编辑、2：完全操作
    if ("0".equals(organizationtype) || "".equals(organizationid)) {
        organizationid = "1";
        organizationtype = "0";
        if (HrmUserVarify.checkUserRight("HeadBudget:Maint", user)) {
            right = Util.getIntValue(HrmUserVarify.getRightLevel("HeadBudget:Maint", user), 0);
        } else {
            organizationtype = "1";
            SubCompanyComInfo.setTofirstRow();
            SubCompanyComInfo.next();
            organizationid = SubCompanyComInfo.getSupsubcomid();
        }
    }
    if (!"0".equals(organizationtype)) {
        if (Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0) == 1) {//如果分权
            int subCompanyId = 0;
            if ("1".equals(organizationtype))
                subCompanyId = (new Integer(organizationid)).intValue();
            else if ("2".equals(organizationtype))
                subCompanyId = (new Integer(DepartmentComInfo.getSubcompanyid1(organizationid))).intValue();
            else if ("3".equals(organizationtype))
                subCompanyId = (new Integer(DepartmentComInfo.getSubcompanyid1(ResourceComInfo.getDepartmentID(organizationid)))).intValue();
            right = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "SubBudget:Maint", subCompanyId);
        } else {
            if (HrmUserVarify.checkUserRight("SubBudget:Maint", user))
                right = Util.getIntValue(HrmUserVarify.getRightLevel("SubBudget:Maint", user), 0);
        }
    }

    String fnabudgetinfoid = "";
    String status = "";
    if (!"".equals(budgetperiods) && !"".equals(organizationid) && !"".equals(organizationtype)) {
        sqlstr = " select id,status from FnaBudgetInfo where status in (1,3) and budgetperiods = "
                + budgetperiods + " and budgetorganizationid = " + organizationid + " and organizationtype = "
                + organizationtype;

        //System.out.println(sqlstr);

        RecordSet.executeSql(sqlstr);
        if (RecordSet.next()) {
            fnabudgetinfoid = RecordSet.getString("id");
            status = RecordSet.getString("status");
            //System.out.println("get id:"+fnabudgetinfoid+" by revision:"+revision+",budgetperiods:"+budgetperiods+",budgetorganizationid:"+organizationid+",organizationtype:"+organizationtype);
        }
    } else {
        canView = false;
    }

    if (right < 0) canView = false;//可查看

    if (!canView) {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }

//取当前期间的年份
    if ("".equals(budgetyears)) {
        sqlstr = " select fnayear from FnaYearsPeriods where id = " + budgetperiods;
        RecordSet.executeSql(sqlstr);
        if (RecordSet.next()) {
            budgetyears = RecordSet.getString("fnayear");
        }
    }

//取预算期间年度(预算年度仅显示“生效”和“关闭”状态的预算年度)
    List budgetperiodsList = new ArrayList();
    List budgetyearsList = new ArrayList();
    sqlstr = "select id,fnayear from FnaYearsPeriods order by fnayear desc";
    RecordSet.executeSql(sqlstr);
    while (RecordSet.next()) {
        String tempid = Util.null2String(RecordSet.getString(1));
        String tempfnayear = Util.null2String(RecordSet.getString(2));
        budgetperiodsList.add(tempid);
        budgetyearsList.add(tempfnayear);
    }

    String imagefilename = "/images/hdReport.gif";
    String titlename = SystemEnv.getHtmlLabelName(428, user.getLanguage());
    String needfav = "1";
    String needhelp = "";

    double tmpnum = 0d;
    double tmpnum1 = 0d;
    double tmpnum2 = 0d;

    Calendar c = Calendar.getInstance();
    SimpleDateFormat s = new SimpleDateFormat("yyyy-MM-dd");
%>
<HTML><HEAD>
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
    <style>
        #tabPane tr td {
            padding-top: 2px
        }

        #monthHtmlTbl td, #seasonHtmlTbl td {
            cursor: hand;
            text-align: center;
            padding: 0 2px 0 2px;
            color: #333;
            text-decoration: underline
        }

        .cycleTD {
            font-family: MS Shell Dlg, Arial;
            background-image: url( /images/tab2.png );
            cursor: hand;
            font-weight: bold;
            text-align: center;
            color: #666;
            border-bottom: 1px solid #879293;
        }

        .cycleTDCurrent {
            font-family: MS Shell Dlg, Arial;
            padding-top: 2px;
            background-image: url( /images/tab.active2.png );
            cursor: hand;
            font-weight: bold;
            text-align: center;
            color: #666
        }

        .seasonTDCurrent, .monthTDCurrent {
            color: black;
            font-weight: bold;
            background-color: #CCC
        }

        #subTab {
            border-bottom: 1px solid #879293;
            padding: 0
        }

        #goalGroupStatus {
            text-align: center;
            color: black;
            font-weight: bold
        }
    </style>
    <SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    RCMenu += "{" + SystemEnv.getHtmlLabelName(1290, user.getLanguage()) + ",javascript:history.back();,_self} ";
    RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>


<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM id="frmMain" name="frmMain" action="FnaExpenseDetail.jsp" method=post>

    <!--表头 开始-->

    <TABLE class="ViewForm">
        <TBODY>
            <colgroup>
                <col width="40%">
                <col width="20%">
                <col width="40%">
                <tr>
                    <td><%=SystemEnv.getHtmlLabelName(16455, user.getLanguage())%>:
                        <%
                            if ("0".equals(organizationtype))
                                out.print(Util.toScreen(CompanyComInfo.getCompanyname(organizationid), user.getLanguage())
                                        + "<b>(" + SystemEnv.getHtmlLabelName(140, user.getLanguage()) + ")</b>");
                            if ("1".equals(organizationtype))
                                out.print(Util.toScreen(SubCompanyComInfo.getSubCompanyname(organizationid), user.getLanguage())
                                        + "<b>(" + SystemEnv.getHtmlLabelName(141, user.getLanguage()) + ")</b>");
                            if ("2".equals(organizationtype))
                                out.print(Util.toScreen(DepartmentComInfo.getDepartmentname(organizationid), user.getLanguage())
                                        + "<b>(" + SystemEnv.getHtmlLabelName(124, user.getLanguage()) + ")</b>");
                            if ("3".equals(organizationtype))
                                out.print(Util.toScreen(ResourceComInfo.getResourcename(organizationid), user.getLanguage())
                                        + "<b>(" + SystemEnv.getHtmlLabelName(1867, user.getLanguage()) + ")</b>");
                        %>
                        <input name="organizationid" type="hidden" value="<%=organizationid%>">
                        <input name="organizationtype" type="hidden" value="<%=organizationtype%>">
                    </td>

                    <td></td>

                    <td align=right><%=SystemEnv.getHtmlLabelName(386, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602, user.getLanguage())%>
                        : <% if (status.equals("1")) {%><%=SystemEnv.getHtmlLabelName(18431, user.getLanguage())%><%} else if (status.equals("3")) { %><%=SystemEnv.getHtmlLabelName(2242, user.getLanguage())%><%}%>
                    </td>
                </tr>

                <TR style="height:1px"><TD class=Line colSpan=3></TD></TR>

                <TR>
                    <td colSpan=3><%=SystemEnv.getHtmlLabelName(15365, user.getLanguage())%>:
                        <select name="budgetperiods" onChange="onChangeFnaYear(this);">
                            <%for (int i = 0; i < budgetyearsList.size(); i++) {%>
                            <option value="<%=budgetperiodsList.get(i)%>"<%
                                if (budgetperiods.equals((String) budgetperiodsList.get(i)))
                                    out.print("selected");
                            %>><%=budgetyearsList.get(i)%></option>
                            <%}%>
                        </select>
                    </td>
                </TR>


                <TR style="height:1px"><TD class=Line colSpan=3></TD></TR>

            </TBODY>
    </TABLE>
</FORM>
<br/>
<!--表头 结束-->

<table width="100%" border=0 cellspacing=0 cellpadding=0 id="tabPane">
    <colgroup>
        <col width="79"></col>
        <col width="79"></col>
        <col width="79"></col>
        <col width="79"></col>
        <col width="*"></col>
    </colgroup>
    <tr height="20">
        <td class="cycleTD"
            onclick="setGoal(this,monthbudgetlisttable);"><%=SystemEnv.getHtmlLabelName(15428, user.getLanguage())%></td>
        <td class="cycleTD"
            onclick="setGoal(this,quarterbudgetlisttable);"><%=SystemEnv.getHtmlLabelName(15429, user.getLanguage())%></td>
        <td class="cycleTD"
            onclick="setGoal(this,halfyearbudgetlisttable);"><%=SystemEnv.getHtmlLabelName(15430, user.getLanguage())%></td>
        <td class="cycleTD"
            onclick="setGoal(this,yearbudgetlisttable);"><%=SystemEnv.getHtmlLabelName(15431, user.getLanguage())%></td>
        <td id="subTab" style="text-align:right;">&nbsp;</td>
    </tr>
</table>

<table width=100%
       style="border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding:10px;padding-right:0">
<tr><td align=center valign=top>

<!--月度预算 开始-->

<TABLE width=100% class=ListStyle cellspacing=1 id="monthbudgetlisttable" style="display:block">
<COLGROUP>
<col width="70">
<col width="70">
<col width="70">
<col width="80">
<col width="6%">
<col width="6%">
<col width="6%">
<col width="6%">
<col width="6%">
<col width="6%">
<col width="6%">
<col width="6%">
<col width="6%">
<col width="6%">
<col width="6%">
<col width="6%">
<col width="6%">
<THEAD>
    <TR class=Header>
        <th><%=SystemEnv.getHtmlLabelName(18424, user.getLanguage())%></th>
        <th><%=SystemEnv.getHtmlLabelName(18425, user.getLanguage())%></th>
        <th><%=SystemEnv.getHtmlLabelName(18426, user.getLanguage())%></th>
        <th>&nbsp;</th>
        <th>1<%=SystemEnv.getHtmlLabelName(15372, user.getLanguage())%></th>
        <th>2<%=SystemEnv.getHtmlLabelName(15372, user.getLanguage())%></th>
        <th>3<%=SystemEnv.getHtmlLabelName(15372, user.getLanguage())%></th>
        <th>4<%=SystemEnv.getHtmlLabelName(15372, user.getLanguage())%></th>
        <th>5<%=SystemEnv.getHtmlLabelName(15372, user.getLanguage())%></th>
        <th>6<%=SystemEnv.getHtmlLabelName(15372, user.getLanguage())%></th>
        <th>7<%=SystemEnv.getHtmlLabelName(15372, user.getLanguage())%></th>
        <th>8<%=SystemEnv.getHtmlLabelName(15372, user.getLanguage())%></th>
        <th>9<%=SystemEnv.getHtmlLabelName(15372, user.getLanguage())%></th>
        <th>10<%=SystemEnv.getHtmlLabelName(15372, user.getLanguage())%></th>
        <th>11<%=SystemEnv.getHtmlLabelName(15372, user.getLanguage())%></th>
        <th>12<%=SystemEnv.getHtmlLabelName(15372, user.getLanguage())%></th>
        <th><%=SystemEnv.getHtmlLabelName(1013, user.getLanguage())%></th>
    </tr>

</THEAD>
<%
    boolean isFirest = false;
    boolean isSecond = false;
    boolean isThird = false;

    //取得月度一级科目
    RecordSet.executeSql(" select id,name from FnaBudgetfeeType where feeperiod = 1 and feelevel = 1 order by name");
    while (RecordSet.next()) {
        String firestlevelid = Util.null2String(RecordSet.getString("id"));
        String firestlevelname = Util.toScreen(RecordSet.getString("name"), user.getLanguage());
        isFirest = true;
        
         RecordSet4.executeSql("select count(*) as counts from FnaBudgetfeeType where  supsubject in (select id from FnaBudgetfeeType where supsubject = "+firestlevelid+")");
         RecordSet4.next();

        //取得该一级科目下的二级科目
        RecordSet2.executeSql(" select id,name from FnaBudgetfeeType where feelevel = 2 and supsubject = " + firestlevelid);
        while (RecordSet2.next()) {
            String secondlevelid = Util.null2String(RecordSet2.getString("id"));
            String secondlevelname = Util.toScreen(RecordSet2.getString("name"), user.getLanguage());
            isSecond = true;

            //取得该二级科目下的三级科目
            RecordSet3.executeSql(" select id,name,alertvalue from FnaBudgetfeeType"
                    + " where feelevel = 3 and supsubject = " + secondlevelid
            );
            while (RecordSet3.next()) {
                String thirdlevelid = Util.null2String(RecordSet3.getString("id"));
                String thirdlevelname = Util.toScreen(RecordSet3.getString("name"), user.getLanguage());
                double alertvalue = (new Double(Util.null2o(RecordSet3.getString("alertvalue")))).doubleValue() / 100;
                isThird = !isThird;
%>
<TR>
<%
    if (isFirest) {
        isFirest = false;
%>
<TD bgcolor="#EFEFEF" rowspan=<%=RecordSet4.getString("counts")%>><%=firestlevelname%></TD>
<%
    }
    if (isSecond) {
        isSecond = false;
%>
<TD bgcolor="#EFEFEF" rowspan="<%=RecordSet3.getCounts()%>"><%=secondlevelname%></TD>
<%
    }
%>
<TD bgcolor="#EFEFEF"><%=thirdlevelname%></TD>
<TD>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr height=20 class=datadark><td nowrap><%=SystemEnv.getHtmlLabelName(386, user.getLanguage())%></td></tr>
        <tr height=20 class=datalight><td nowrap><%=SystemEnv.getHtmlLabelName(628, user.getLanguage())%></td>
        </tr>
        <tr height=20 class=datadark><td nowrap><%=SystemEnv.getHtmlLabelName(24785, user.getLanguage())%></td><!-- 审批中的费用 -->
        </tr>        
        <tr height=20 CLASS=Total STYLE="COLOR:RED;FONT-WEIGHT:BOLD"><td
                nowrap><%=SystemEnv.getHtmlLabelName(15368, user.getLanguage())%></td></tr>
    </table>
</TD>
<%
    double tmpSum = 0d, tmpSum1 = 0d, tmpSum2 = 0d, tmpSum3 = 0d, tmpSum4 = 0d;
    Map budgetTypeAmount = FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid,thirdlevelid);
    
    for (int j = 1; j < 13; j++) {
        tmpnum = 0d;
        tmpnum1 = 0d;
        tmpnum2 = 0d;
%>
<TD>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr height=20 class=datadark><td nowrap align=right>
            <%
                tmpnum1 = Util.getDoubleValue(Util.null2o((String)budgetTypeAmount.get(""+j)));//FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid, (new Integer(j)).toString(), thirdlevelid);
                tmpSum1 += tmpnum1;
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum1));
            %>
        </td></tr>
        <tr height=20 class=datalight><td nowrap align=right>
            <%
                c.set(new Integer(budgetyears).intValue(), j - 1, 1);
                String startdate = s.format(c.getTime());
                c.add(Calendar.MONTH, 1);
                c.add(Calendar.DAY_OF_MONTH, -1);
                String enddate = s.format(c.getTime());

                tmpnum = FnaBudgetInfoComInfo.getInComeAmount(organizationid, organizationtype, startdate, enddate, thirdlevelid)
                        - FnaBudgetInfoComInfo.getFeeAmount(organizationid, organizationtype, startdate, enddate, thirdlevelid);

                tmpSum3 += tmpnum;

                out.print("<font color=");
                if ((tmpnum > (tmpnum1 * alertvalue)) && (tmpnum < tmpnum1)) out.print("ORANGE");
                else if (tmpnum > tmpnum1) out.print("RED");
                else out.print("BLACK");
                out.print(">");
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum));
                out.print("</font>");
            %>
        </td></tr>
        <tr height=20 class=datadark><td nowrap align=right>
            <%
               //审批中的费用
              tmpnum2 = FnaBudgetInfoComInfo.getApprovingAmount(organizationid, organizationtype, startdate, enddate, thirdlevelid); 
              tmpSum4 += tmpnum2;

                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum2));
            %>
        </td></tr>
        <tr height=20 class=datalight><td nowrap align=right>
            <%
                if((tmpnum - tmpnum1)==0||tmpnum1==0) tmpSum2 = 0;
                else tmpSum2 = (tmpnum - tmpnum1) * 100 / tmpnum1;

                int tmptgapint = (new Double(tmpSum2)).intValue();
                if (tmptgapint != 0)
                    out.print(tmptgapint + "%");
            %>
        </td></tr>
    </table>
</TD>
<%
    }
%>
<TD>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr height=20 class=datadark><td nowrap align=right>
            <%
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpSum1));
            %>
        </td></tr>
        <tr height=20 class=datalight><td nowrap align=right>
            <%
                out.print("<font color=");
                if ((tmpSum3 > (tmpSum1 * alertvalue)) && (tmpnum < tmpnum1)) out.print("ORANGE");
                else if (tmpSum3 > tmpSum1) out.print("RED");
                else out.print("BLACK");
                out.print(">");
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpSum3));
                out.print("</font>");
            %>
        </td></tr>
        <tr height=20 class=datadark><td nowrap align=right>
            <%
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpSum4));
            %>
        </td></tr>
        <tr height=20 class=datalight><td nowrap align=right>
            <%
                if((tmpSum3 - tmpSum1)==0||tmpSum1==0) tmpnum2 = 0;
                else tmpnum2 = (tmpSum3 - tmpSum1) * 100 / tmpSum1;
                int tmptgapint = (new Double(tmpnum2)).intValue();
                if (tmptgapint != 0)
                    out.print(tmptgapint + "%");
            %>
        </td></tr>
    </table>
</TD>
</TR>
<%
            }
        }
    }
%>

</TBODY>
</TABLE>


<!--月度预算 结束-->
<!--季度预算 开始-->

<TABLE width=100% class=ListStyle cellspacing=1 id="quarterbudgetlisttable" style="display:none">
<COLGROUP>
<col width="70">
<col width="70">
<col width="70">
<col width="80">
<col width="16%">
<col width="16%">
<col width="16%">
<col width="16%">
<col width="16%">
<THEAD>
    <TR class=Header>
        <th><%=SystemEnv.getHtmlLabelName(18424, user.getLanguage())%></th>
        <th><%=SystemEnv.getHtmlLabelName(18425, user.getLanguage())%></th>
        <th><%=SystemEnv.getHtmlLabelName(18426, user.getLanguage())%></th>
        <th>&nbsp;</th>
        <th>1<%=SystemEnv.getHtmlLabelName(15372, user.getLanguage())%></th>
        <th>2<%=SystemEnv.getHtmlLabelName(15372, user.getLanguage())%></th>
        <th>3<%=SystemEnv.getHtmlLabelName(15372, user.getLanguage())%></th>
        <th>4<%=SystemEnv.getHtmlLabelName(15372, user.getLanguage())%></th>
        <th><%=SystemEnv.getHtmlLabelName(1013, user.getLanguage())%></th>
    </tr>

</THEAD>
<%
    isFirest = false;
    isSecond = false;
    isThird = false;

    //取得月度一级科目
    RecordSet.executeSql(" select id,name from FnaBudgetfeeType where feeperiod = 2 and feelevel = 1 order by name");
    while (RecordSet.next()) {
        String firestlevelid = Util.null2String(RecordSet.getString("id"));
        String firestlevelname = Util.toScreen(RecordSet.getString("name"), user.getLanguage());
        isFirest = true;

        //取得该一级科目下的二级科目
        RecordSet2.executeSql(" select id,name from FnaBudgetfeeType where feelevel = 2 and supsubject = " + firestlevelid);
        while (RecordSet2.next()) {
            String secondlevelid = Util.null2String(RecordSet2.getString("id"));
            String secondlevelname = Util.toScreen(RecordSet2.getString("name"), user.getLanguage());
            isSecond = true;

            //取得该二级科目下的三级科目
            RecordSet3.executeSql(" select id,name,alertvalue from FnaBudgetfeeType"
                    + " where feelevel = 3 and supsubject = " + secondlevelid
            );
            while (RecordSet3.next()) {
                String thirdlevelid = Util.null2String(RecordSet3.getString("id"));
                String thirdlevelname = Util.toScreen(RecordSet3.getString("name"), user.getLanguage());
                double alertvalue = (new Double(Util.null2o(RecordSet3.getString("alertvalue")))).doubleValue() / 100;
                isThird = !isThird;
%>
<TR>
<%
    if (isFirest) {
        isFirest = false;
%>
<TD bgcolor="#EFEFEF" rowspan="<%=RecordSet3.getCounts()*RecordSet2.getCounts()%>"><%=firestlevelname%></TD>
<%
    }
    if (isSecond) {
        isSecond = false;
%>
<TD bgcolor="#EFEFEF" rowspan="<%=RecordSet3.getCounts()%>"><%=secondlevelname%></TD>
<%
    }
%>
<TD bgcolor="#EFEFEF"><%=thirdlevelname%></TD>
<TD>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr height=20 class=datadark><td nowrap><%=SystemEnv.getHtmlLabelName(386, user.getLanguage())%></td></tr>
        <tr height=20 class=datalight><td nowrap><%=SystemEnv.getHtmlLabelName(628, user.getLanguage())%></td>
        </tr>
        <tr height=20 class=datadark><td nowrap><%=SystemEnv.getHtmlLabelName(24785, user.getLanguage())%></td><!-- 审批中的费用 -->
        </tr>        
        <tr height=20 CLASS=Total STYLE="COLOR:RED;FONT-WEIGHT:BOLD"><td
                nowrap><%=SystemEnv.getHtmlLabelName(15368, user.getLanguage())%></td></tr>
    </table>
</TD>
<%
    double tmpSum = 0d, tmpSum1 = 0d, tmpSum2 = 0d, tmpSum3 = 0d, tmpSum4 = 0d;
    Map budgetTypeAmount = FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid,thirdlevelid);
    
    for (int j = 1; j < 5; j++) {
        tmpnum = 0d;
        tmpnum1 = 0d;
        tmpnum2 = 0d;
%>
<TD>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr height=20 class=datadark><td nowrap align=right>
            <%
                tmpnum1 = Util.getDoubleValue(Util.null2o((String)budgetTypeAmount.get(""+j)));//FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid, (new Integer(j)).toString(), thirdlevelid);
                tmpSum1 += tmpnum1;
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum1));
            %>
        </td></tr>
        <tr height=20 class=datalight><td nowrap align=right>
            <%
                c.set(new Integer(budgetyears).intValue(), (j - 1) * 3, 1);
                String startdate = s.format(c.getTime());
                c.add(Calendar.MONTH, 3);
                c.add(Calendar.DAY_OF_MONTH, -1);
                String enddate = s.format(c.getTime());

                tmpnum = FnaBudgetInfoComInfo.getInComeAmount(organizationid, organizationtype, startdate, enddate, thirdlevelid)
                        - FnaBudgetInfoComInfo.getFeeAmount(organizationid, organizationtype, startdate, enddate, thirdlevelid);

                tmpSum3 += tmpnum;

                out.print("<font color=");
                if ((tmpnum > (tmpnum1 * alertvalue)) && (tmpnum < tmpnum1)) out.print("ORANGE");
                else if (tmpnum > tmpnum1) out.print("RED");
                else out.print("BLACK");
                out.print(">");
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum));
                out.print("</font>");
            %>
        </td></tr>
        <tr height=20 class=datadark><td nowrap align=right>
            <%
               //审批中的费用
               tmpnum2 = FnaBudgetInfoComInfo.getApprovingAmount(organizationid, organizationtype, startdate, enddate, thirdlevelid); 
               tmpSum4 += tmpnum2;
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum2));
            %>
        </td></tr>
        <tr height=20 class=datalight><td nowrap align=right>
            <%
                if((tmpnum - tmpnum1)==0||tmpnum1==0) tmpSum2 = 0;
                else tmpSum2 = (tmpnum - tmpnum1) * 100 / tmpnum1;

                int tmptgapint = (new Double(tmpSum2)).intValue();
                if (tmptgapint != 0)
                    out.print(tmptgapint + "%");
            %>
        </td></tr>
    </table>
</TD>
<%
    }
%>
<TD>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr height=20 class=datadark><td nowrap align=right>
            <%
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpSum1));
            %>
        </td></tr>
        <tr height=20 class=datalight><td nowrap align=right>
            <%
                out.print("<font color=");
                if ((tmpSum3 > (tmpSum1 * alertvalue)) && (tmpnum < tmpnum1)) out.print("ORANGE");
                else if (tmpSum3 > tmpSum1) out.print("RED");
                else out.print("BLACK");
                out.print(">");
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpSum3));
                out.print("</font>");
            %>
        </td></tr>
        <tr height=20 class=datadark><td nowrap align=right>
            <%
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpSum4));
            %>
        </td></tr>
        <tr height=20 class=datadark><td nowrap align=right>
            <%
                if((tmpSum3 - tmpSum1)==0||tmpSum1==0) tmpnum2 = 0;
                else tmpnum2 = (tmpSum3 - tmpSum1) * 100 / tmpSum1;

                int tmptgapint = (new Double(tmpnum2)).intValue();
                if (tmptgapint != 0)
                    out.print(tmptgapint + "%");
            %>
        </td></tr>
    </table>
</TD>
</TR>
<%
            }
        }
    }
%>

</TBODY>
</TABLE>

<!--季度预算 结束-->
<!--半年预算 开始-->


<TABLE width=100% class=ListStyle cellspacing=1 id="halfyearbudgetlisttable" style="display:none">
<COLGROUP>
<col width="70">
<col width="70">
<col width="70">
<col width="80">
<col width="26%">
<col width="26%">
<col width="26%">
<THEAD>
    <TR class=Header>
        <th><%=SystemEnv.getHtmlLabelName(18424, user.getLanguage())%></th>
        <th><%=SystemEnv.getHtmlLabelName(18425, user.getLanguage())%></th>
        <th><%=SystemEnv.getHtmlLabelName(18426, user.getLanguage())%></th>
        <th>&nbsp;</th>
        <th>1<%=SystemEnv.getHtmlLabelName(15372, user.getLanguage())%></th>
        <th>2<%=SystemEnv.getHtmlLabelName(15372, user.getLanguage())%></th>
        <th><%=SystemEnv.getHtmlLabelName(1013, user.getLanguage())%></th>
    </tr>

</THEAD>
<%
    isFirest = false;
    isSecond = false;
    isThird = false;

    //取得月度一级科目
    RecordSet.executeSql(" select id,name from FnaBudgetfeeType where feeperiod = 3 and feelevel = 1 order by name");
    while (RecordSet.next()) {
        String firestlevelid = Util.null2String(RecordSet.getString("id"));
        String firestlevelname = Util.toScreen(RecordSet.getString("name"), user.getLanguage());
        isFirest = true;

        //取得该一级科目下的二级科目
        RecordSet2.executeSql(" select id,name from FnaBudgetfeeType where feelevel = 2 and supsubject = " + firestlevelid);
        while (RecordSet2.next()) {
            String secondlevelid = Util.null2String(RecordSet2.getString("id"));
            String secondlevelname = Util.toScreen(RecordSet2.getString("name"), user.getLanguage());
            isSecond = true;

            //取得该二级科目下的三级科目
            RecordSet3.executeSql(" select id,name,alertvalue from FnaBudgetfeeType"
                    + " where feelevel = 3 and supsubject = " + secondlevelid
            );
            while (RecordSet3.next()) {
                String thirdlevelid = Util.null2String(RecordSet3.getString("id"));
                String thirdlevelname = Util.toScreen(RecordSet3.getString("name"), user.getLanguage());
                double alertvalue = (new Double(Util.null2o(RecordSet3.getString("alertvalue")))).doubleValue() / 100;
                isThird = !isThird;
%>
<TR>
<%
    if (isFirest) {
        isFirest = false;
%>
<TD bgcolor="#EFEFEF" rowspan="<%=RecordSet3.getCounts()*RecordSet2.getCounts()%>"><%=firestlevelname%></TD>
<%
    }
    if (isSecond) {
        isSecond = false;
%>
<TD bgcolor="#EFEFEF" rowspan="<%=RecordSet3.getCounts()%>"><%=secondlevelname%></TD>
<%
    }
%>
<TD bgcolor="#EFEFEF"><%=thirdlevelname%></TD>
<TD>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr height=20 class=datadark><td nowrap><%=SystemEnv.getHtmlLabelName(386, user.getLanguage())%></td></tr>
        <tr height=20 class=datalight><td nowrap><%=SystemEnv.getHtmlLabelName(628, user.getLanguage())%></td>
        </tr>
        <tr height=20 class=datadark><td nowrap><%=SystemEnv.getHtmlLabelName(24785, user.getLanguage())%></td><!-- 审批中的费用 -->
        </tr>        
        <tr height=20 CLASS=Total STYLE="COLOR:RED;FONT-WEIGHT:BOLD"><td
                nowrap><%=SystemEnv.getHtmlLabelName(15368, user.getLanguage())%></td></tr>
    </table>
</TD>
<%
    double tmpSum = 0d, tmpSum1 = 0d, tmpSum2 = 0d, tmpSum3 = 0d, tmpSum4 = 0d;
    Map budgetTypeAmount = FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid,thirdlevelid);
    
    for (int j = 1; j < 3; j++) {
        tmpnum = 0d;
        tmpnum1 = 0d;
        tmpnum2 = 0d;
%>
<TD>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr height=20 class=datadark><td nowrap align=right>
            <%
                tmpnum1 = Util.getDoubleValue(Util.null2o((String)budgetTypeAmount.get(""+j)));//FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid, (new Integer(j)).toString(), thirdlevelid);
                tmpSum1 += tmpnum1;
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum1));
            %>
        </td></tr>
        <tr height=20 class=datalight><td nowrap align=right>
            <%
                c.set(new Integer(budgetyears).intValue(), (j - 1) * 6, 1);
                String startdate = s.format(c.getTime());
                c.add(Calendar.MONTH, 6);
                c.add(Calendar.DAY_OF_MONTH, -1);
                String enddate = s.format(c.getTime());


                tmpnum = FnaBudgetInfoComInfo.getInComeAmount(organizationid, organizationtype, startdate, enddate, thirdlevelid)
                        - FnaBudgetInfoComInfo.getFeeAmount(organizationid, organizationtype, startdate, enddate, thirdlevelid);

                tmpSum3 += tmpnum;

                out.print("<font color=");
                if ((tmpnum > (tmpnum1 * alertvalue)) && (tmpnum < tmpnum1)) out.print("ORANGE");
                else if (tmpnum > tmpnum1) out.print("RED");
                else out.print("BLACK");
                out.print(">");
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum));
                out.print("</font>");
            %>
        </td></tr>
        <tr height=20 class=datadark><td nowrap align=right>
            <%
               //审批中的费用
              tmpnum2 = FnaBudgetInfoComInfo.getApprovingAmount(organizationid, organizationtype, startdate, enddate, thirdlevelid); 
              tmpSum4 += tmpnum2;

                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum2));
            %>
        </td></tr>
        <tr height=20 class=datalight><td nowrap align=right>
            <%
                if((tmpnum - tmpnum1)==0||tmpnum1==0) tmpSum2 = 0;
                else tmpSum2 = (tmpnum - tmpnum1) * 100 / tmpnum1;

                int tmptgapint = (new Double(tmpSum2)).intValue();
                if (tmptgapint != 0)
                    out.print(tmptgapint + "%");
            %>
        </td></tr>
    </table>
</TD>
<%
    }
%>
<TD>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr height=20 class=datadark><td nowrap align=right>
            <%
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpSum1));
            %>
        </td></tr>
        <tr height=20 class=datalight><td nowrap align=right>
            <%
                out.print("<font color=");
                if ((tmpSum3 > (tmpSum1 * alertvalue)) && (tmpnum < tmpnum1)) out.print("ORANGE");
                else if (tmpSum3 > tmpSum1) out.print("RED");
                else out.print("BLACK");
                out.print(">");
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpSum3));
                out.print("</font>");
            %>
        </td></tr>
        <tr height=20 class=datadark><td nowrap align=right>
            <%
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpSum4));
            %>
        </td></tr>
        <tr height=20 class=datalight><td nowrap align=right>
            <%
                if((tmpSum3 - tmpSum1)==0||tmpSum1==0) tmpnum2 = 0;
                else tmpnum2 = (tmpSum3 - tmpSum1) * 100 / tmpSum1;

                int tmptgapint = (new Double(tmpnum2)).intValue();
                if (tmptgapint != 0)
                    out.print(tmptgapint + "%");
            %>
        </td></tr>
    </table>
</TD>
</TR>
<%
            }
        }
    }
%>

</TBODY>
</TABLE>


<!--半年预算 结束-->
<!--年度预算 开始-->


<TABLE width=100% class=ListStyle cellspacing=1 id="yearbudgetlisttable" style="display:none">
<COLGROUP>
<col width="70">
<col width="70">
<col width="70">
<col width="80">
<col width="77%">
<THEAD>
    <TR class=Header>
        <th><%=SystemEnv.getHtmlLabelName(18424, user.getLanguage())%></th>
        <th><%=SystemEnv.getHtmlLabelName(18425, user.getLanguage())%></th>
        <th><%=SystemEnv.getHtmlLabelName(18426, user.getLanguage())%></th>
        <th>&nbsp;</th>
        <th><%=SystemEnv.getHtmlLabelName(1013, user.getLanguage())%></th>
    </tr>

</THEAD>
<%
    isFirest = false;
    isSecond = false;
    isThird = false;

    //取得月度一级科目
    RecordSet.executeSql(" select id,name from FnaBudgetfeeType where feeperiod = 4 and feelevel = 1 order by name");
    while (RecordSet.next()) {
        String firestlevelid = Util.null2String(RecordSet.getString("id"));
        String firestlevelname = Util.toScreen(RecordSet.getString("name"), user.getLanguage());
        isFirest = true;

        //取得该一级科目下的二级科目
        RecordSet2.executeSql(" select id,name from FnaBudgetfeeType where feelevel = 2 and supsubject = " + firestlevelid);
        while (RecordSet2.next()) {
            String secondlevelid = Util.null2String(RecordSet2.getString("id"));
            String secondlevelname = Util.toScreen(RecordSet2.getString("name"), user.getLanguage());
            isSecond = true;

            //取得该二级科目下的三级科目
            RecordSet3.executeSql(" select id,name,alertvalue from FnaBudgetfeeType"
                    + " where feelevel = 3 and supsubject = " + secondlevelid
            );
            while (RecordSet3.next()) {
                String thirdlevelid = Util.null2String(RecordSet3.getString("id"));
                String thirdlevelname = Util.toScreen(RecordSet3.getString("name"), user.getLanguage());
                double alertvalue = (new Double(Util.null2o(RecordSet3.getString("alertvalue")))).doubleValue() / 100;
                isThird = !isThird;
%>
<TR>
    <%
        if (isFirest) {
            isFirest = false;
    %>
    <TD bgcolor="#EFEFEF" rowspan="<%=RecordSet3.getCounts()*RecordSet2.getCounts()%>"><%=firestlevelname%></TD>
    <%
        }
        if (isSecond) {
            isSecond = false;
    %>
    <TD bgcolor="#EFEFEF" rowspan="<%=RecordSet3.getCounts()%>"><%=secondlevelname%></TD>
    <%
        }
    %>
    <TD bgcolor="#EFEFEF"><%=thirdlevelname%></TD>
    <TD>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr height=20 class=datadark><td nowrap><%=SystemEnv.getHtmlLabelName(386, user.getLanguage())%></td>
            </tr>
            <tr height=20 class=datalight><td
                    nowrap><%=SystemEnv.getHtmlLabelName(628, user.getLanguage())%></td></tr>
            <tr height=20 class=datadark><td nowrap><%=SystemEnv.getHtmlLabelName(24785, user.getLanguage())%></td><!-- 审批中的费用 -->
            </tr>                
            <tr height=20 CLASS=Total STYLE="COLOR:RED;FONT-WEIGHT:BOLD"><td
                    nowrap><%=SystemEnv.getHtmlLabelName(15368, user.getLanguage())%></td></tr>
        </table>
    </TD>
    <%
        double tmpSum = 0d, tmpSum1 = 0d, tmpSum2 = 0d, tmpSum3 = 0d, tmpSum4 = 0d;
        Map budgetTypeAmount = FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid,thirdlevelid);
        
        for (int j = 1; j <= 1; j++) {
            tmpnum = 0d;

            tmpnum = Util.getDoubleValue(Util.null2o((String)budgetTypeAmount.get(""+j)));//FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid, (new Integer(j)).toString(), thirdlevelid);
            tmpSum1 += tmpnum;

            c.set(new Integer(budgetyears).intValue(), (j - 1) * 12, 1);
            String startdate = s.format(c.getTime());
            c.add(Calendar.MONTH, 12);
            c.add(Calendar.DAY_OF_MONTH, -1);
            String enddate = s.format(c.getTime());

            tmpnum = FnaBudgetInfoComInfo.getInComeAmount(organizationid, organizationtype, startdate, enddate, thirdlevelid)
                    - FnaBudgetInfoComInfo.getFeeAmount(organizationid, organizationtype, startdate, enddate, thirdlevelid);

            tmpSum3 += tmpnum;
            
          //审批中的费用
            tmpnum2 = FnaBudgetInfoComInfo.getApprovingAmount(organizationid, organizationtype, startdate, enddate, thirdlevelid); 
            tmpSum4 += tmpnum2;
            
            tmpSum4 += tmpnum2;

        }
    %>
    <TD>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr height=20 class=datadark><td nowrap align=right>
                <%
                    out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpSum1));
                %>
            </td></tr>
            <tr height=20 class=datalight><td nowrap align=right>
                <%
                    out.print("<font color=");
                    if ((tmpSum3 > (tmpSum1 * alertvalue)) && (tmpnum < tmpnum1)) out.print("ORANGE");
                    else if (tmpSum3 > tmpSum1) out.print("RED");
                    else out.print("BLACK");
                    out.print(">");
                    out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpSum3));
                    out.print("</font>");
                %>
            </td></tr>
            <tr height=20 class=datadark><td nowrap align=right>
            <%
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpSum4));
            %>
        </td></tr>
            <tr height=20 class=datalight><td nowrap align=right>
                <%
                    if((tmpSum3 - tmpSum1)==0||tmpSum1==0) tmpnum2 = 0;
                    else tmpnum2 = (tmpSum3 - tmpSum1) * 100 / tmpSum1;

                    int tmptgapint = (new Double(tmpnum2)).intValue();
                    if (tmptgapint != 0)
                        out.print(tmptgapint + "%");
                %>
            </td></tr>
        </table>
    </TD>
</TR>
<%
            }
        }
    }
%>

</TBODY>
</TABLE>

<!--年度预算 结束-->


</td></tr>
<tr><td colspan="5">&nbsp;</td></tr>
<tr><td colspan="5">&nbsp;</td></tr>
</table>

</td>
</tr>
</TABLE>

</td>
<td></td>
</tr>
<tr>
    <td height="5" colspan="3"></td>
</tr>
</table>

<script language=javascript>
    document.getElementById("tabPane").rows[0].cells[0].className = "cycleTDCurrent";

    function setGoal(o, b) {
        document.getElementById("tabPane").rows[0].cells[0].className = "cycleTD";
        document.getElementById("tabPane").rows[0].cells[1].className = "cycleTD";
        document.getElementById("tabPane").rows[0].cells[2].className = "cycleTD";
        document.getElementById("tabPane").rows[0].cells[3].className = "cycleTD";
        document.getElementById("yearbudgetlisttable").style.display = "none";
        document.getElementById("halfyearbudgetlisttable").style.display = "none";
        document.getElementById("quarterbudgetlisttable").style.display = "none";
        document.getElementById("monthbudgetlisttable").style.display = "none";
        o.className = "cycleTDCurrent";
        b.style.display = "block";
    }

    function onChangeFnaYear(o) {
        document.frmMain.submit();
    }
</script>


</BODY>
</HTML>


<%--


<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String departmentid = Util.null2String(request.getParameter("departmentid"));
String fnayear = Util.null2String(request.getParameter("fnayear"));

String budgetinfoid = "" ;
String budgetstatus = "" ;
String sqlstr = "" ;

if(fnayear.equals("")) {
    RecordSet.executeProc("FnaYearsPeriods_SelectMaxYear","");
    if(RecordSet.next()) fnayear = RecordSet.getString("fnayear") ;
    else {
        Calendar today = Calendar.getInstance();
        fnayear = Util.add0(today.get(Calendar.YEAR), 4) ;
    }
}


if( budgetinfoid.equals("") ) {
    sqlstr =" select id , budgetstatus from FnaBudgetInfo where  budgetyears= '"+ fnayear + "'  and budgetdepartmentid = "+ departmentid ;
    RecordSet.executeSql(sqlstr);
    if( RecordSet.next() ) {
        budgetinfoid = Util.null2String( RecordSet.getString(1) ) ;
        budgetstatus = Util.null2String(RecordSet.getString(2)) ;
    }
}

ArrayList startdates = new ArrayList() ;
ArrayList enddates = new ArrayList() ;
ArrayList feetypeperiods = new ArrayList() ;
ArrayList periodstartdates = new ArrayList() ;
ArrayList periodenddates = new ArrayList() ;

ArrayList budgettypeperiods = new ArrayList() ;
ArrayList budgetaccounts = new ArrayList() ;
ArrayList expensetypeperiods = new ArrayList() ;
ArrayList expenseaccounts = new ArrayList() ;


RecordSet.executeSql("select startdate, enddate from FnaYearsPeriodsList where fnayear= '"+fnayear+"' order by Periodsid ");
while( RecordSet.next() ) {
    startdates.add( Util.null2String(RecordSet.getString( "startdate" ) ) ) ;
    enddates.add( Util.null2String(RecordSet.getString( "enddate" ) ) ) ;
}

//added by lupeng 2004.06.22
    if (startdates.isEmpty() || enddates.isEmpty() || enddates.size()<12)
        response.sendRedirect("/notice/MissingInfo.jsp") ;
//end

String fnayearstartdate = (String) startdates.get(0) ;
String fnayearenddate = (String) enddates.get(11) ;

RecordSet.executeSql("select id, feeperiod , agreegap from FnaBudgetfeeType ");
while( RecordSet.next() ) {
    String tempfeetypeid = Util.null2String(RecordSet.getString( "id" ) ) ;
    int tempfeeperiod = Util.getIntValue(RecordSet.getString( "feeperiod" ) , 1 ) ;

    switch( tempfeeperiod ) {
        case 1 :
            for(int i=1 ; i<13; i++) {
                String tempperiodstartdate = (String) startdates.get(i-1) ;
                String tempperiodenddate = (String) enddates.get(i-1) ;
                feetypeperiods.add(tempfeetypeid+"_"+i) ;
                periodstartdates.add(tempperiodstartdate) ;
                periodenddates.add(tempperiodenddate) ;
            }
            break ;
        case 2 :
            for(int i=1 ; i<5; i++) {
                String tempperiodstartdate = (String) startdates.get((i-1)*3) ;
                String tempperiodenddate = (String) enddates.get(i*3-1) ;
                feetypeperiods.add(tempfeetypeid+"_"+i) ;
                periodstartdates.add(tempperiodstartdate) ;
                periodenddates.add(tempperiodenddate) ;
            }
            break ;
        case 3 :
            for(int i=1 ; i<3; i++) {
                String tempperiodstartdate = (String) startdates.get((i-1)*6) ;
                String tempperiodenddate = (String) enddates.get(i*6-1) ;
                feetypeperiods.add(tempfeetypeid+"_"+i) ;
                periodstartdates.add(tempperiodstartdate) ;
                periodenddates.add(tempperiodenddate) ;
            }
            break ;
        case 4 :
            String tempperiodstartdate = (String) startdates.get(0) ;
            String tempperiodenddate = (String) enddates.get(11) ;
            feetypeperiods.add(tempfeetypeid+"_1") ;
            periodstartdates.add(tempperiodstartdate) ;
            periodenddates.add(tempperiodenddate) ;
            break ;
    }
}

if( !budgetinfoid.equals("") ) {
    sqlstr =" select budgettypeid, budgetperiods , sum(budgetaccount) as budgetaccount from FnaBudgetCheckDetail where budgetinfoid="+ budgetinfoid + " group by budgettypeid, budgetperiods " ;

    RecordSet.executeSql(sqlstr);
    while(RecordSet.next()){
        String tempbudgettypeid = Util.null2String(RecordSet.getString(1)) ;
        String tempbudgetperiods = Util.null2String(RecordSet.getString(2)) ;
        String tempaccount = "" + Util.getDoubleValue(RecordSet.getString(3),0) ;

        if(tempaccount.equals("0")) continue ;

        budgettypeperiods.add(tempbudgettypeid + "_" + tempbudgetperiods ) ;
        budgetaccounts.add( tempaccount ) ;
    }
}

sqlstr =" select feetypeid , amount , occurdate from FnaAccountLog where occurdate >= '"+ fnayearstartdate + "' and occurdate <= '"+ fnayearenddate +"' and departmentid = " + departmentid ;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
    String tempfeetypeid = Util.null2String(RecordSet.getString(1)) ;
    double tempaccount = Util.getDoubleValue(RecordSet.getString(2),0) ;
    String tempoccurdate = Util.null2String(RecordSet.getString(3)) ;

    if( tempaccount == 0 ) continue ;

    for( int i= 0 ; i < periodstartdates.size() ; i++ ) {
        String tempperiodstartdate = (String) periodstartdates.get(i) ;
        String tempperiodenddate = (String) periodenddates.get(i) ;

        if ( tempoccurdate.compareTo(tempperiodstartdate) >=0 && tempoccurdate.compareTo(tempperiodenddate) <=0 ) {
            String feetypeperiod = (String)feetypeperiods.get(i) ;
            if( feetypeperiod.indexOf( tempfeetypeid + "_" ) != 0 ) continue ;

            String currentperiod = Util.StringReplace(feetypeperiod,tempfeetypeid + "_", "") ;
            int expensetypeperiodindex = expensetypeperiods.indexOf(tempfeetypeid + "_" + currentperiod ) ;
            if( expensetypeperiodindex == -1 ) {
                expensetypeperiods.add( tempfeetypeid + "_" + currentperiod ) ;
                expenseaccounts.add( "" + tempaccount ) ;
            }
            else {
                double tempperaccount = Util.getDoubleValue( (String)expenseaccounts.get(expensetypeperiodindex) , 0 ) ;
                tempaccount += tempperaccount ;
                expenseaccounts.set( expensetypeperiodindex , "" + tempaccount ) ;
            }
            break ;
        }
    }
}


String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(428,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
/*
RCMenu += "{"+SystemEnv.getHtmlLabelName(2121,user.getLanguage())+",javascript:submitBudget(''),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
*/
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/fna/report/expense/FnaExpenseDepartment.jsp,_self} " ;
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
<FORM id=frmMain name=frmMain action=FnaExpenseDetail.jsp method=post>
<input id=departmentid type=hidden name=departmentid value="<%=departmentid%>">
<input id=budgetstatus type=hidden name=budgetstatus value="<%=budgetstatus%>">
<input id=budgetinfoid type=hidden name=budgetinfoid value="<%=budgetinfoid%>">
 <TABLE class=ViewForm>
    <COLGROUP> <COL width="15%"></COL> <COL width="40%"></COL><COL width="5%"></COL>
    <COL width="15%"></COL> <COL width="25%"></COL> <THEAD>
    <TR class=Title>
    <TH colspan="2">
      <P align=left><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>: <%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></P>
    </TH>
    <TH colSpan=3 style="TEXT-ALIGN: right"><nobr>
    <%=SystemEnv.getHtmlLabelName(15427,user.getLanguage())%>: <% if( budgetstatus.equals("1") ) {%><%=SystemEnv.getHtmlLabelName(1423,user.getLanguage())%><%} else if( budgetstatus.equals("0") ) { %><%=SystemEnv.getHtmlLabelName(1422,user.getLanguage())%><%}%>
    </TH>
  </TR>
    </THEAD> <TBODY>
    <!--added by lupeng 2004.05.13 for TD453.-->
    <TR><TD class=Line1 colSpan=5></TD></TR>
    <!--end-->
    <tr>
      <td width="15%"><%=SystemEnv.getHtmlLabelName(15426,user.getLanguage())%></td>
      <td width="85%" class=Field colSpan=4>
        <select class=inputstyle name="fnayear" onchange="frmMain.submit()">
          <%
        RecordSet.executeProc("FnaYearsPeriods_Select","");
        while(RecordSet.next()) {
            String thefnayear = RecordSet.getString("fnayear") ;
        %>
          <option value="<%=thefnayear%>" <% if(thefnayear.equals(fnayear)) {%>selected<%}%>><%=thefnayear%></option>
          <%}%>
        </select>
      </td>
    </tr>
    <!--added by lupeng 2004.05.13 for TD453.-->
    <TR style="height:1px"><TD class=Line colSpan=5></TD></TR>
    <!--end-->
    </TBODY>
  </TABLE>
</FORM>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
    <col width="10%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="6%">
    <col width="8%">
  <THEAD>
  <TR class=Header>
    <TH colspan="15"><%=SystemEnv.getHtmlLabelName(15428,user.getLanguage())%></TH>
  </TR>

  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(15385,user.getLanguage())%></th>
  <th>&nbsp;</th>
  <th>1<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>2<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>3<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>4<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>5<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>6<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>7<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>8<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>9<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>10<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>11<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>12<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>
  </tr>
 <TR class=Line><TD colspan="15" ></TD></TR>
<%
    ArrayList thebudgetaccounts = new ArrayList() ;
    ArrayList theexpenseaccounts = new ArrayList() ;
    double budgetyearcount = 0 ;

    boolean isLight = false;
    RecordSet.executeSql(" select id ,name , feetype from FnaBudgetfeeType where feeperiod = 1 ");
    while(RecordSet.next())
    {
        thebudgetaccounts.clear() ;
        theexpenseaccounts.clear() ;
        String id = Util.null2String(RecordSet.getString("id")) ;
        String name = Util.toScreen(RecordSet.getString("name"),user.getLanguage()) ;
        String feetype = Util.toScreen(RecordSet.getString("feetype"),user.getLanguage()) ;
        isLight = !isLight ;
%>
    <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
        <TD rowspan=3><a href="#" onclick="return submitBudget(<%=id%>)"><%=name%></a></TD>
        <TD><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TD>
<%
        double yearcount = 0 ;
        for( int i=1 ; i<13 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = budgettypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                tempbudgetaccount = (String) budgetaccounts.get(accountindex) ;
                yearcount += Util.getDoubleValue( tempbudgetaccount ,0 ) ;
            }
            thebudgetaccounts.add(tempbudgetaccount) ;
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      }

        budgetyearcount = yearcount ;
        String yearcountstr = "" ;
        if(yearcount != 0 ){
            yearcount = (new BigDecimal(yearcount)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
            yearcountstr = "" + yearcount ;
        }
        thebudgetaccounts.add( yearcountstr ) ;
%>
           <TD style="TEXT-ALIGN: right"><%=yearcountstr%></TD>
    </TR>
    <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
        <TD><%=SystemEnv.getHtmlLabelName(628,user.getLanguage())%></TD>
<%
        yearcount = 0 ;
        for( int i=1 ; i<13 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = expensetypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                double tempexpense = Util.getDoubleValue((String) expenseaccounts.get(accountindex),0) ;
                tempexpense = (new BigDecimal(tempexpense)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
                if(tempexpense != 0 ) tempbudgetaccount = ""+tempexpense ;
                yearcount += tempexpense ;
            }
            theexpenseaccounts.add(tempbudgetaccount) ;
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      }

        yearcountstr = "" ;
        if(yearcount != 0 ){
            yearcount = (new BigDecimal(yearcount)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
            yearcountstr = "" + yearcount ;
        }
        theexpenseaccounts.add( yearcountstr ) ;
%>
           <TD style="TEXT-ALIGN: right"><%=yearcountstr%></TD>
    </TR>
    <TR CLASS=Total STYLE="COLOR:RED;FONT-WEIGHT:BOLD">
        <TD><%=SystemEnv.getHtmlLabelName(15368,user.getLanguage())%></TD>
<%
        for( int i=0 ; i<13 ; i++ ) {
            String tempbudgetaccount = (String) thebudgetaccounts.get(i) ;
            String tempexpenseaccount = (String) theexpenseaccounts.get(i) ;
            String tempaccountgap = "" ;

            if( !tempbudgetaccount.equals("") && !tempexpenseaccount.equals("") ) {
                double accountgapdouble =  ( Util.getDoubleValue(tempexpenseaccount) - Util.getDoubleValue(tempbudgetaccount) ) * 100 / Util.getDoubleValue(tempbudgetaccount) ;
                int accountgapint = (new Double( accountgapdouble )).intValue() ;
 //               if( accountgapint < 0 ) accountgapint = accountgapint * (-1) ;
                if( accountgapint != 0 ) tempaccountgap = "" + accountgapint + "%" ;
            }
%>
        <TD style="TEXT-ALIGN: right"><%=tempaccountgap%></TD>
<%      } %>
    </TR>
<%
    }
%>
  </TBODY>
</TABLE>


<br>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
    <col width="10%">
    <col width="6%">
    <col width="16%">
    <col width="16%">
    <col width="16%">
    <col width="16%">
    <col width="20%">
  <THEAD>
  <TR class=header>
    <TH colspan="7"><%=SystemEnv.getHtmlLabelName(15429,user.getLanguage())%></TH>
  </TR>

  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(15385,user.getLanguage())%></th>
  <th>&nbsp;</th>
  <th>1<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>2<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>3<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>4<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>
  </tr>
  <TR class=Line><TD colspan="7" ></TD></TR>
<%
    isLight = false;

    RecordSet.executeSql(" select id ,name , feetype from FnaBudgetfeeType where feeperiod = 2 ");
    while(RecordSet.next())
    {
        thebudgetaccounts.clear() ;
        theexpenseaccounts.clear() ;
        String id = Util.null2String(RecordSet.getString("id")) ;
        String name = Util.toScreen(RecordSet.getString("name"),user.getLanguage()) ;
        String feetype = Util.toScreen(RecordSet.getString("feetype"),user.getLanguage()) ;
        isLight = !isLight ;
%>
    <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
        <TD rowspan=3><a href="#" onclick="return submitBudget(<%=id%>)"><%=name%></a></TD>
        <TD><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TD>
<%
        double yearcount = 0 ;
        for( int i=1 ; i<5 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = budgettypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                tempbudgetaccount = (String) budgetaccounts.get(accountindex) ;
                yearcount += Util.getDoubleValue( tempbudgetaccount ,0 ) ;
            }
            thebudgetaccounts.add(tempbudgetaccount) ;
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      }

        budgetyearcount = yearcount ;
        String yearcountstr = "" ;
        if(yearcount != 0 ){
            yearcount = (new BigDecimal(yearcount)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
            yearcountstr = "" + yearcount ;
        }
        thebudgetaccounts.add( yearcountstr ) ;
%>
           <TD style="TEXT-ALIGN: right"><%=yearcountstr%></TD>
    </TR>
    <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
        <TD><%=SystemEnv.getHtmlLabelName(628,user.getLanguage())%></TD>
<%
        yearcount = 0 ;
        for( int i=1 ; i<5 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = expensetypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                double tempexpense = Util.getDoubleValue((String) expenseaccounts.get(accountindex),0) ;
                tempexpense = (new BigDecimal(tempexpense)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
                if(tempexpense != 0 ) tempbudgetaccount = ""+tempexpense ;
                yearcount += tempexpense ;
            }
            theexpenseaccounts.add(tempbudgetaccount) ;
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      }

        yearcountstr = "" ;
        if(yearcount != 0 ){
            yearcount = (new BigDecimal(yearcount)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
            yearcountstr = "" + yearcount ;
        }
        theexpenseaccounts.add( yearcountstr ) ;
%>
           <TD style="TEXT-ALIGN: right"><%=yearcountstr%></TD>
    </TR>
    <TR CLASS=Total STYLE="COLOR:RED;FONT-WEIGHT:BOLD">
        <TD><%=SystemEnv.getHtmlLabelName(15368,user.getLanguage())%></TD>
<%
        for( int i=0 ; i<5 ; i++ ) {
            String tempbudgetaccount = (String) thebudgetaccounts.get(i) ;
            String tempexpenseaccount = (String) theexpenseaccounts.get(i) ;
            String tempaccountgap = "" ;

            if( !tempbudgetaccount.equals("") && !tempexpenseaccount.equals("") ) {
                double accountgapdouble =  ( Util.getDoubleValue(tempexpenseaccount) - Util.getDoubleValue(tempbudgetaccount) ) * 100 / Util.getDoubleValue(tempbudgetaccount) ;
                int accountgapint = (new Double( accountgapdouble )).intValue() ;
 //               if( accountgapint < 0 ) accountgapint = accountgapint * (-1) ;
                if( accountgapint != 0 ) tempaccountgap = "" + accountgapint + "%" ;
            }
%>
        <TD style="TEXT-ALIGN: right"><%=tempaccountgap%></TD>
<%      } %>
    </TR>
<%
    }
%>
  </TBODY>
</TABLE>


<br>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
    <col width="10%">
    <col width="6%">
    <col width="25%">
    <col width="25%">
    <col width="34%">
  <THEAD>
  <TR class=header>
    <TH colspan="5"><%=SystemEnv.getHtmlLabelName(15430,user.getLanguage())%></TH>
  </TR>

  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(15385,user.getLanguage())%></th>
  <th>&nbsp;</th>
  <th>1<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>2<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>
  </tr>
  <TR class=Line><TD colspan="5" ></TD></TR>
<%
    isLight = false;

    RecordSet.executeSql(" select id ,name , feetype from FnaBudgetfeeType where feeperiod = 3 ");
    while(RecordSet.next())
    {
        thebudgetaccounts.clear() ;
        theexpenseaccounts.clear() ;
        String id = Util.null2String(RecordSet.getString("id")) ;
        String name = Util.toScreen(RecordSet.getString("name"),user.getLanguage()) ;
        String feetype = Util.toScreen(RecordSet.getString("feetype"),user.getLanguage()) ;
        isLight = !isLight ;
%>
    <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
        <TD rowspan=3><a href="#" onclick="return submitBudget(<%=id%>)"><%=name%></a></TD>
        <TD><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TD>
<%
        double yearcount = 0 ;
        for( int i=1 ; i<3 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = budgettypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                tempbudgetaccount = (String) budgetaccounts.get(accountindex) ;
                yearcount += Util.getDoubleValue( tempbudgetaccount ,0 ) ;
            }
            thebudgetaccounts.add(tempbudgetaccount) ;
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      }

        budgetyearcount = yearcount ;
        String yearcountstr = "" ;
        if(yearcount != 0 ){
            yearcount = (new BigDecimal(yearcount)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
            yearcountstr = "" + yearcount ;
        }
        thebudgetaccounts.add( yearcountstr ) ;
%>
           <TD style="TEXT-ALIGN: right"><%=yearcountstr%></TD>
    </TR>
    <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
        <TD><%=SystemEnv.getHtmlLabelName(628,user.getLanguage())%></TD>
<%
        yearcount = 0 ;
        for( int i=1 ; i<3 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = expensetypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                double tempexpense = Util.getDoubleValue((String) expenseaccounts.get(accountindex),0) ;
                tempexpense = (new BigDecimal(tempexpense)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
                if(tempexpense != 0 ) tempbudgetaccount = ""+tempexpense ;
                yearcount += tempexpense ;
            }
            theexpenseaccounts.add(tempbudgetaccount) ;
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      }

        yearcountstr = "" ;
        if(yearcount != 0 ){
            yearcount = (new BigDecimal(yearcount)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
            yearcountstr = "" + yearcount ;
        }
        theexpenseaccounts.add( yearcountstr ) ;
%>
           <TD style="TEXT-ALIGN: right"><%=yearcountstr%></TD>
    </TR>
    <TR CLASS=Total STYLE="COLOR:RED;FONT-WEIGHT:BOLD">
        <TD><%=SystemEnv.getHtmlLabelName(15368,user.getLanguage())%></TD>
<%
        for( int i=0 ; i<3 ; i++ ) {
            String tempbudgetaccount = (String) thebudgetaccounts.get(i) ;
            String tempexpenseaccount = (String) theexpenseaccounts.get(i) ;
            String tempaccountgap = "" ;

            if( !tempbudgetaccount.equals("") && !tempexpenseaccount.equals("") ) {
                double accountgapdouble =  ( Util.getDoubleValue(tempexpenseaccount) - Util.getDoubleValue(tempbudgetaccount) ) * 100 / Util.getDoubleValue(tempbudgetaccount) ;
                int accountgapint = (new Double( accountgapdouble )).intValue() ;
 //               if( accountgapint < 0 ) accountgapint = accountgapint * (-1) ;
                if( accountgapint != 0 ) tempaccountgap = "" + accountgapint + "%" ;
            }
%>
        <TD style="TEXT-ALIGN: right"><%=tempaccountgap%></TD>
<%      } %>
    </TR>
<%
    }
%>
  </TBODY>
</TABLE>


<br>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
    <col width="10%">
    <col width="6%">
    <col width="84%">
  <THEAD>
  <TR class=header>
    <TH colspan="3"><%=SystemEnv.getHtmlLabelName(15431,user.getLanguage())%></TH>
  </TR>

  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(15385,user.getLanguage())%></th>
  <th>&nbsp;</th>
  <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>
  </tr>
  <TR class=Line><TD colspan="3" ></TD></TR>
<%
    isLight = false;

    RecordSet.executeSql(" select id ,name , feetype from FnaBudgetfeeType where feeperiod = 4 ");
    while(RecordSet.next())
    {
        thebudgetaccounts.clear() ;
        theexpenseaccounts.clear() ;
        String id = Util.null2String(RecordSet.getString("id")) ;
        String name = Util.toScreen(RecordSet.getString("name"),user.getLanguage()) ;
        String feetype = Util.toScreen(RecordSet.getString("feetype"),user.getLanguage()) ;
        isLight = !isLight ;
%>
    <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
        <TD rowspan=3><a href="#" onclick="return submitBudget(<%=id%>)"><%=name%></a></TD>
        <TD><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TD>
<%
        for( int i=1 ; i<2 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = budgettypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                tempbudgetaccount = (String) budgetaccounts.get(accountindex) ;
                budgetyearcount = Util.getDoubleValue(tempbudgetaccount,0) ;
            }
            thebudgetaccounts.add(tempbudgetaccount) ;
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      }%>
    </TR>
    <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
        <TD><%=SystemEnv.getHtmlLabelName(628,user.getLanguage())%></TD>
<%
        for( int i=1 ; i<2 ; i++ ) {
            String tempbudgetaccount = "" ;
            int accountindex = expensetypeperiods.indexOf(id+"_"+i) ;
            if( accountindex!=-1) {
                double tempexpense = Util.getDoubleValue((String) expenseaccounts.get(accountindex),0) ;
                tempexpense = (new BigDecimal(tempexpense)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
                if(tempexpense != 0 ) tempbudgetaccount = ""+tempexpense ;
            }

            theexpenseaccounts.add(tempbudgetaccount) ;
%>
        <TD style="TEXT-ALIGN: right"><%=tempbudgetaccount%></TD>
<%      } %>
    </TR>
    <TR CLASS=Total STYLE="COLOR:RED;FONT-WEIGHT:BOLD">
        <TD><%=SystemEnv.getHtmlLabelName(15368,user.getLanguage())%></TD>
<%
        for( int i=0 ; i<1 ; i++ ) {
            String tempbudgetaccount = (String) thebudgetaccounts.get(i) ;
            String tempexpenseaccount = (String) theexpenseaccounts.get(i) ;
            String tempaccountgap = "" ;

            if( !tempbudgetaccount.equals("") && !tempexpenseaccount.equals("") ) {
                double accountgapdouble =  ( Util.getDoubleValue(tempexpenseaccount) - Util.getDoubleValue(tempbudgetaccount) ) * 100 / Util.getDoubleValue(tempbudgetaccount) ;
                int accountgapint = (new Double( accountgapdouble )).intValue() ;
 //               if( accountgapint < 0 ) accountgapint = accountgapint * (-1) ;
                if( accountgapint != 0 ) tempaccountgap = "" + accountgapint + "%" ;
            }
%>
        <TD style="TEXT-ALIGN: right"><%=tempaccountgap%></TD>
<%      } %>
    </TR>
<%
    }
%>
  </TBODY>
</TABLE>

<form name="detail" action=FnaExpenseTypeDetail.jsp method=post>
  <input id=feetypeid type=hidden name=feetypeid >
  <input id=fnayear type=hidden name=fnayear value="<%=fnayear%>">
  <input id=departmentid type=hidden name=departmentid value="<%=departmentid%>">
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
<script language=javascript>
function submitBudget(thevalue) {
    detail.feetypeid.value=thevalue ;
    detail.submit() ;
    return false;
}
</script>
</BODY>
</HTML>
--%>
