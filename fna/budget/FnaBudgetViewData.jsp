<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,weaver.general.TimeUtil,java.util.*,java.math.*,java.text.*" %>
<%
request.setCharacterEncoding("UTF-8");
%>
<%@ include file="/page/maint/common/initNoCache.jsp" %> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet4" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="FnaBudgetInfoComInfo" class="weaver.fna.maintenance.FnaBudgetInfoComInfo" scope="page"/>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page"/>
<%
boolean canShowDistributiveBudget = true;//是否显示已分配预算
boolean canLinkTypeView = true;//是否可以链接到科目预算显示

String fnabudgetinfoid = Util.null2String(request.getParameter("fnabudgetinfoid"));//ID
String revision = Util.null2String(request.getParameter("revision"));//版本
String organizationid = Util.null2String(request.getParameter("organizationid"));//组织ID
String organizationtype = Util.null2String(request.getParameter("organizationtype"));//组织类型
String budgetperiods = Util.null2String(request.getParameter("budgetperiods"));//期间ID

String budgetyears = "";//期间年
String status = "";//状态
String budgetstatus = "";//审批状态

String sqlstr = "";
char separator = Util.getSeparator();
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
        Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
        Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) + " " +
        Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
        Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
        Util.add0(today.get(Calendar.SECOND), 2);

if (fnabudgetinfoid != null && !"".equals(fnabudgetinfoid)) {
    sqlstr = " select budgetperiods,budgetorganizationid,organizationtype,budgetstatus,revision,status from FnaBudgetInfo where id = " + fnabudgetinfoid;
    RecordSet.executeSql(sqlstr);
    if (RecordSet.next()) {
        budgetperiods = RecordSet.getString("budgetperiods");
        organizationid = RecordSet.getString("budgetorganizationid");
        organizationtype = RecordSet.getString("organizationtype");
        budgetstatus = RecordSet.getString("budgetstatus");
        revision = RecordSet.getString("revision");
        status = RecordSet.getString("status");
        if(status!=null&&("1".equals(status)||"2".equals(status)||"3".equals(status))&&(revision==null||"".equals(revision)))
        	revision = Util.getIntValue(revision,1)+"";
    }
    //System.out.println("not empty id:"+fnabudgetinfoid);
}

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
        if (!HrmUserVarify.checkUserRight("SubBudget:Maint", user))
            canLinkTypeView = false;//总部预算维护不能显示修改分部预算
    } else {
        organizationtype = "1";
        SubCompanyComInfo.setTofirstRow();
        SubCompanyComInfo.next();
        organizationid = SubCompanyComInfo.getSubCompanyid();
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

//如果版本为空
if ("".equals(revision)) {
    //取得当前组织当前期间生效版本
    sqlstr = " select revision,id,budgetstatus,status from FnaBudgetInfo where status in (1,3) and budgetperiods = " + budgetperiods + " and budgetorganizationid = " + organizationid + " and organizationtype = " + organizationtype;
    RecordSet.executeSql(sqlstr);
    if (RecordSet.next()) {
        revision = RecordSet.getString("revision");
        //System.out.println("empty revision:"+revision);
    } else {
        //未取到则为草稿状态
        revision = "0";
        status = "0";
        //System.out.println("default revision:"+revision);
    }
}

if (!"".equals(budgetperiods) && !"".equals(organizationid) && !"".equals(organizationtype) && !"".equals(revision))
{
    sqlstr = " select id,budgetstatus,status,revision from FnaBudgetInfo where revision = " + revision + " and budgetperiods = "
            + budgetperiods + " and budgetorganizationid = " + organizationid + " and organizationtype = "
            + organizationtype;

    //System.out.println(sqlstr);

    RecordSet.executeSql(sqlstr);
    if (RecordSet.next()) {
        fnabudgetinfoid = RecordSet.getString("id");
        budgetstatus = RecordSet.getString("budgetstatus");
        status = RecordSet.getString("status");
        revision = RecordSet.getString("revision");
        //System.out.println("get id:"+fnabudgetinfoid+" by revision:"+revision+",budgetperiods:"+budgetperiods+",budgetorganizationid:"+organizationid+",organizationtype:"+organizationtype);
    }
}

if ("".equals(fnabudgetinfoid) && !"".equals(budgetperiods) && !"".equals(organizationid) && !"".equals(organizationtype))
{
    sqlstr = " select id,budgetstatus,status,revision from FnaBudgetInfo where budgetperiods = "
            + budgetperiods + " and budgetorganizationid = " + organizationid + " and organizationtype = "
            + organizationtype + " and status in (1,3) ";

    RecordSet.executeSql(sqlstr);
    if (RecordSet.next()) {
        fnabudgetinfoid = RecordSet.getString("id");
        budgetstatus = RecordSet.getString("budgetstatus");
        status = RecordSet.getString("status");
        revision = Util.getIntValue(RecordSet.getString("revision"),1)+"";
    }
    
    if("".equals(fnabudgetinfoid)){
    	
        sqlstr = " select id,budgetstatus,status,revision from FnaBudgetInfo where budgetperiods = "
            + budgetperiods + " and budgetorganizationid = " + organizationid + " and organizationtype = "
            + organizationtype + " and status = 2 order by revision desc,id desc ";

        RecordSet.executeSql(sqlstr);
        if (RecordSet.next()) {
            fnabudgetinfoid = RecordSet.getString("id");
            budgetstatus = RecordSet.getString("budgetstatus");
            status = RecordSet.getString("status");
            revision = Util.getIntValue(RecordSet.getString("revision"),1)+"";
        }
    }
    
    if("".equals(fnabudgetinfoid)){
    	
        sqlstr = " select id,budgetstatus,status,revision from FnaBudgetInfo where budgetperiods = "
            + budgetperiods + " and budgetorganizationid = " + organizationid + " and organizationtype = "
            + organizationtype + " order by id desc ";

        RecordSet.executeSql(sqlstr);
        if (RecordSet.next()) {
            fnabudgetinfoid = RecordSet.getString("id");
            budgetstatus = RecordSet.getString("budgetstatus");
            status = RecordSet.getString("status");
            revision = RecordSet.getString("revision");
        }
    }
}

if ("".equals(fnabudgetinfoid)) {
	if(revision==null||"".equals(revision)) revision="0";
	if(status==null||"".equals(status)) revision="0";
    String para = budgetperiods + separator//budgetperiods
            + organizationid + separator//budgetorganizationid
            + organizationtype + separator//organizationtype
            + budgetstatus + separator//budgetstatus
            + user.getUID() + separator//createrid
            + Util.fromScreen(currentdate, user.getLanguage()) + separator//createdate
            + revision + separator//revision
            + status;//status
    RecordSet2.executeProc("FnaBudgetInfo_Insert", para);
    RecordSet2.next();
    fnabudgetinfoid = RecordSet2.getString(1);
    //System.out.println("empty id create new revision:"+revision+",budgetperiods:"+budgetperiods+",budgetorganizationid:"+organizationid+",organizationtype:"+organizationtype);
}


if ("2".equals(status)) canLinkTypeView = false;//历史版本不能链接进入科目预算显示

if ("3".equals(organizationtype)) {
    canShowDistributiveBudget = false;//人员预算无“已分配预算”统计项
    canLinkTypeView = false;//人员预算无科目链接
}


//取当前期间的年份
if ("".equals(budgetyears)) {
    sqlstr = " select fnayear from FnaYearsPeriods where id = " + budgetperiods;
    RecordSet.executeSql(sqlstr);
    if (RecordSet.next()) {
        budgetyears = RecordSet.getString("fnayear");
    }
}

//取状态
if (("".equals(status) || "".equals(budgetstatus))&&(!"".equals(fnabudgetinfoid))) {
    sqlstr = " select status,budgetstatus from FnaBudgetInfo where id = " + fnabudgetinfoid;
    RecordSet.executeSql(sqlstr);
    if (RecordSet.next()) {
        status = RecordSet.getString("status");
        budgetstatus = RecordSet.getString("budgetstatus");
    } else {
        status = "0";
        budgetstatus = "0";
    }
}

//取预算期间年度(预算年度仅显示“生效”和“关闭”状态的预算年度)
List budgetperiodsList = new ArrayList();
List budgetyearsList = new ArrayList();
sqlstr = "select id,fnayear from FnaYearsPeriods where status in (0,1) order by fnayear desc";
RecordSet.executeSql(sqlstr);
while (RecordSet.next()) {
    String tempid = Util.null2String(RecordSet.getString(1));
    String tempfnayear = Util.null2String(RecordSet.getString(2));
    budgetperiodsList.add(tempid);
    budgetyearsList.add(tempfnayear);
}

//取生效版本
String inurerevision = "";
String inurerevisionid = "";
String inurerevisionstatus = "";
sqlstr = " select id,revision,status from FnaBudgetInfo where budgetperiods = " + budgetperiods + " and budgetorganizationid = " + organizationid + " and organizationtype = " + organizationtype + " and status in (1,3) ";
RecordSet.executeSql(sqlstr);
if (RecordSet.next()) {
    inurerevision = Util.null2String(RecordSet.getString("revision"));
    inurerevisionid = Util.null2String(RecordSet.getString("id"));
    inurerevisionstatus = Util.null2String(RecordSet.getString("status"));
}

//取历史版本(右侧历史版本链接，显示倒数4个历史版本)
int alreadyget = 0;
List historyRevisionList = new ArrayList();
List historyRevisionIdList = new ArrayList();
sqlstr = " select id,revision,status from FnaBudgetInfo where budgetperiods = " + budgetperiods + " and budgetorganizationid = " + organizationid + " and organizationtype = " + organizationtype + " and status in (0,2) order by status desc,revision desc ";
RecordSet.executeSql(sqlstr);
for (int i = 0; RecordSet.next() && i < 4; i++) {
    historyRevisionList.add(Util.null2String(RecordSet.getString("revision")));
    historyRevisionIdList.add(Util.null2String(RecordSet.getString("id")));
}

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(386, user.getLanguage());
String needfav = "1";
String needhelp = "";

double tmpnum = 0d;
double tmpnum1 = 0d;
double tmpnum2 = 0d;

Calendar c = Calendar.getInstance();
SimpleDateFormat s = new SimpleDateFormat("yyyy-MM-dd");

boolean isFirst = false;
boolean isSecond = false;
boolean isThird = false;

List subjectid = new ArrayList();
List subjectname = new ArrayList();
List subjectlevel = new ArrayList();
List subjectsup = new ArrayList();
List subjectfeeperiod = new ArrayList();
List subjectalertvalue = new ArrayList();

RecordSet.executeSql(" select id,name,feelevel,supsubject,feeperiod,alertvalue from FnaBudgetfeeType order by feelevel,name ");
while (RecordSet.next()) {
    subjectid.add(Util.null2String(RecordSet.getString("id")));
    subjectname.add(Util.null2String(RecordSet.getString("name")));
    subjectlevel.add(Util.null2String(RecordSet.getString("feelevel")));
    subjectsup.add(Util.null2String(RecordSet.getString("supsubject")));
    subjectfeeperiod.add(Util.null2String(RecordSet.getString("feeperiod")));
    subjectalertvalue.add(Util.null2String(RecordSet.getString("alertvalue")));
}
String iscanceld = "";
String sql = "";
String caceledstate = "";
if ("1".equals(organizationtype))
	sql = "select * from HrmSubCompany where id="+organizationid;
if ("2".equals(organizationtype))
	sql = "select * from hrmdepartment where id="+organizationid;
if(!"".equals(sql))
{
    RecordSet.executeSql(sql);
    while(RecordSet.next())
    {
    	iscanceld = RecordSet.getString("canceled");
    }
    if("1".equals(iscanceld))
    {
    	caceledstate = "<span><font color=\"red\">("+SystemEnv.getHtmlLabelName(22205,user.getLanguage())+")</font></span>";
    }
}
%>
<FORM id="frmMain" name="frmMain" action="FnaBudgetView.jsp" method=post>
<INPUT name="fnabudgetinfoid" type="hidden" value="<%=fnabudgetinfoid%>">

<!--表头 开始-->

<TABLE class="ViewForm">
<TBODY>
<colgroup>
<col width="15%">
<col width="30%">
<col width="10%">
<col width="15%">
<col width="30%">
<TR>
    <TH class=Title colspan=5>
        <%
            String fnatitle = "<font size=\"3\">";
            if ("0".equals(organizationtype))
                fnatitle += (Util.toScreen(CompanyComInfo.getCompanyname(organizationid), user.getLanguage()));
            if ("1".equals(organizationtype))
                fnatitle += (Util.toScreen(SubCompanyComInfo.getSubCompanyname(organizationid), user.getLanguage()));
            if ("2".equals(organizationtype))
                fnatitle += (Util.toScreen(DepartmentComInfo.getDepartmentname(organizationid), user.getLanguage()));
            if ("3".equals(organizationtype))
                fnatitle += (Util.toScreen(ResourceComInfo.getResourcename(organizationid), user.getLanguage()));
            fnatitle += budgetyears;
            fnatitle += SystemEnv.getHtmlLabelName(15375, user.getLanguage());
            fnatitle += "</font><font color=Green>(";
            if (!"0".equals(status)) {
                fnatitle += SystemEnv.getHtmlLabelName(567, user.getLanguage());//版本
                fnatitle += ":";
                fnatitle += revision;
                fnatitle += "&nbsp;";
                if ("1".equals(status)) fnatitle += SystemEnv.getHtmlLabelName(18431, user.getLanguage());//生效
                if ("2".equals(status)) fnatitle += SystemEnv.getHtmlLabelName(1477, user.getLanguage());//历史
                if ("3".equals(status)) fnatitle += SystemEnv.getHtmlLabelName(2242, user.getLanguage());//待审批
            } else fnatitle += SystemEnv.getHtmlLabelName(220, user.getLanguage());//草稿
            fnatitle += ")</font>";
            out.println(fnatitle);
        %>
    </TH>
</TR>

<TR class=Spacing>
    <TD class=Sep1 colSpan=5></TD>
</TR>

<tr>
    <td><%=SystemEnv.getHtmlLabelName(16455, user.getLanguage())%></td>
    <td class=Field>
        <%
            if ("0".equals(organizationtype))
                out.print(Util.toScreen(CompanyComInfo.getCompanyname(organizationid), user.getLanguage())
                        + "<b>(" + SystemEnv.getHtmlLabelName(140, user.getLanguage()) + ")</b>");
            if ("1".equals(organizationtype))
                out.print(Util.toScreen(SubCompanyComInfo.getSubCompanyname(organizationid), user.getLanguage())
                        + "<b>(" + SystemEnv.getHtmlLabelName(141, user.getLanguage()) + ")</b>"+caceledstate);
            if ("2".equals(organizationtype))
                out.print(Util.toScreen(DepartmentComInfo.getDepartmentname(organizationid), user.getLanguage())
                        + "<b>(" + SystemEnv.getHtmlLabelName(124, user.getLanguage()) + ")</b>"+caceledstate);
            if ("3".equals(organizationtype))
                out.print(Util.toScreen(ResourceComInfo.getResourcename(organizationid), user.getLanguage())
                        + "<b>(" + SystemEnv.getHtmlLabelName(1867, user.getLanguage()) + ")</b>");
        %>
        <input name="organizationid" type="hidden" value="<%=organizationid%>">
        <input name="organizationtype" type="hidden" value="<%=organizationtype%>">
    </td>
    <td></td>
    <td><%=SystemEnv.getHtmlLabelName(18496, user.getLanguage())%></td>
    <td class=Field>
        <input name="revision" type="hidden" value="<%=revision%>">
        <%if (!"".equals(inurerevision)) {%>
        <input class=InputStyle type="checkbox" name="historyRevision" value="<%=inurerevisionid%>">
        <%
                if (inurerevisionid.equals(fnabudgetinfoid)) {
                    out.print(SystemEnv.getHtmlLabelName(567, user.getLanguage())//版本
                            + inurerevision
                            + "&nbsp;("
                            + SystemEnv.getHtmlLabelName(("1".equals(inurerevisionstatus) ? 18431 : 2242), user.getLanguage())
                            + ")");
                } else {
                    out.print("<a href=\"FnaBudgetView.jsp?fnabudgetinfoid=" + inurerevisionid + "\">");
                    out.print(SystemEnv.getHtmlLabelName(567, user.getLanguage())//版本
                            + inurerevision
                            + "&nbsp;("
                            + SystemEnv.getHtmlLabelName(("1".equals(inurerevisionstatus) ? 18431 : 2242), user.getLanguage())
                            + ")");
                    out.print("</a>");
                }
            }
        %>
    </td>
</tr>

<TR style="height:1px"><TD class=Line colSpan=5></TD></TR>

<tr>
    <td><%=SystemEnv.getHtmlLabelName(15365, user.getLanguage())%></td>
    <td class=Field>
        <select name="budgetperiods" onChange="onChangeFnaYear(this);">
            <%for (int i = 0; i < budgetyearsList.size(); i++) {%>
            <option value="<%=budgetperiodsList.get(i)%>"<%
                if (budgetperiods.equals((String) budgetperiodsList.get(i)))
                    out.print("selected");
            %>><%=budgetyearsList.get(i)%></option>
            <%}%>
        </select>
    </td>
    <td></td>
    <td><%=SystemEnv.getHtmlLabelName(18500, user.getLanguage())%></td>
    <td class=Field>
        <%if (historyRevisionList.size() > alreadyget) {%>
        <input class=InputStyle type="checkbox" name="historyRevision"
               value="<%=historyRevisionIdList.get(alreadyget)%>">
        <%
                if (!historyRevisionIdList.get(alreadyget).equals(fnabudgetinfoid)) {
                    out.print("<a href=\"FnaBudgetView.jsp?fnabudgetinfoid=" + historyRevisionIdList.get(alreadyget) + "\">");
                }
                if ("0".equals(historyRevisionList.get(alreadyget))) {
                    out.println(SystemEnv.getHtmlLabelName(220, user.getLanguage()));
                } else {
                    out.println(SystemEnv.getHtmlLabelName(567, user.getLanguage())
                            + historyRevisionList.get(alreadyget)
                            + "&nbsp;("
                            + SystemEnv.getHtmlLabelName(1477, user.getLanguage())
                            + ")");
                }
                if (!historyRevisionIdList.get(alreadyget).equals(fnabudgetinfoid)) {
                    out.print("</a>");
                }
                alreadyget++;
            }
        %>
    </td>
</tr>

<TR style="height:1px"><TD class=Line colSpan=5></TD></TR>

<tr>
    <td><%=SystemEnv.getHtmlLabelName(18501, user.getLanguage())%></td>
    <td class=Field>
        <% // Todo 预算总额
            tmpnum1 = FnaBudgetInfoComInfo.getBudgetAmount(fnabudgetinfoid);
            out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum1));
        %>
    </td>
    <td></td>
    <td></td>
    <td class=Field>
        <%if (historyRevisionList.size() > alreadyget) {%>
        <input class=InputStyle type="checkbox" name="historyRevision"
               value="<%=historyRevisionIdList.get(alreadyget)%>">
        <%
                if (!historyRevisionIdList.get(alreadyget).equals(fnabudgetinfoid)) {
                    out.print("<a href=\"FnaBudgetView.jsp?fnabudgetinfoid=" + historyRevisionIdList.get(alreadyget) + "\">");
                }
                if ("0".equals(historyRevisionList.get(alreadyget))) {
                    out.println(SystemEnv.getHtmlLabelName(220, user.getLanguage()));
                } else {
                    out.println(SystemEnv.getHtmlLabelName(567, user.getLanguage())
                            + historyRevisionList.get(alreadyget)
                            + "&nbsp;("
                            + SystemEnv.getHtmlLabelName(1477, user.getLanguage())
                            + ")");
                }
                if (!historyRevisionIdList.get(alreadyget).equals(fnabudgetinfoid)) {
                    out.print("</a>");
                }
                alreadyget++;
            }
        %>
    </td>
</tr>

<TR style="height:1px"><TD class=Line colSpan=5></TD></TR>

<tr>
    <td><% if (canShowDistributiveBudget) { %>
        <%=SystemEnv.getHtmlLabelName(18502, user.getLanguage())%>
        <%} else {%>
        <%=SystemEnv.getHtmlLabelName(18503, user.getLanguage())%>
        <%}%>
    </td>
    <td class=Field>
        <% if (canShowDistributiveBudget) { %>
        <% // Todo 已分配预算
            tmpnum2 = FnaBudgetInfoComInfo.getDistributiveBudgetAmount(organizationid, organizationtype, budgetperiods);
            out.print("<font color=" + (tmpnum2 < tmpnum1 ? "GREEN" : "BLACK") + ">");
            out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum2));
            out.print("</font>");
        %>
        <%} else {%>
        <% // Todo 已发生费用
            c.set(new Integer(budgetyears).intValue(), 0, 1);
            String startdate = s.format(c.getTime());
            c.add(Calendar.YEAR, 1);
            c.add(Calendar.DAY_OF_MONTH, -1);
            String enddate = s.format(c.getTime());
            tmpnum = FnaBudgetInfoComInfo.getFeeAmount(organizationid, organizationtype, startdate, enddate);
            out.print("<font color=" + (tmpnum < tmpnum1 ? "BLACK" : "RED") + ">");
            out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum));
            out.print("</font>");
        %>
        <%}%>
    </td>
    <td></td>
    <td></td>
    <td class=Field>
        <%if (historyRevisionList.size() > alreadyget) {%>
        <input class=InputStyle type="checkbox" name="historyRevision"
               value="<%=historyRevisionIdList.get(alreadyget)%>">
        <%
                if (!historyRevisionIdList.get(alreadyget).equals(fnabudgetinfoid)) {
                    out.print("<a href=\"FnaBudgetView.jsp?fnabudgetinfoid=" + historyRevisionIdList.get(alreadyget) + "\">");
                }
                if ("0".equals(historyRevisionList.get(alreadyget))) {
                    out.println(SystemEnv.getHtmlLabelName(220, user.getLanguage()));
                } else {
                    out.println(SystemEnv.getHtmlLabelName(567, user.getLanguage())
                            + historyRevisionList.get(alreadyget)
                            + "&nbsp;("
                            + SystemEnv.getHtmlLabelName(1477, user.getLanguage())
                            + ")");
                }
                if (!historyRevisionIdList.get(alreadyget).equals(fnabudgetinfoid)) {
                    out.print("</a>");
                }
                alreadyget++;
            }
        %>
    </td>
</tr>

<TR style="height:1px"><TD class=Line colSpan=5></TD></TR>

<tr>
    <td>
        <% if (canShowDistributiveBudget) { %>
        <%=SystemEnv.getHtmlLabelName(18503, user.getLanguage())%>
        <%}%>&nbsp;</td>
    <td class=Field>
        <% if (canShowDistributiveBudget) { %>
        <% // Todo 已发生费用
            c.set(new Integer(budgetyears).intValue(), 0, 1);
            String startdate = s.format(c.getTime());
            c.add(Calendar.YEAR, 1);
            c.add(Calendar.DAY_OF_MONTH, -1);
            String enddate = s.format(c.getTime());
            tmpnum = FnaBudgetInfoComInfo.getFeeAmount(organizationid, organizationtype, startdate, enddate);
            out.print("<font color=" + (tmpnum < tmpnum1 ? "BLACK" : "RED") + ">");
            out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum));
            out.print("</font>");
        %>
        <%}%>&nbsp;
    </td>
    <td></td>
    <td></td>
    <td class=Field>
        <%if (historyRevisionList.size() > alreadyget) {%>
        <input class=InputStyle type="checkbox" name="historyRevision"
               value="<%=historyRevisionIdList.get(alreadyget)%>">
        <%
                if (!historyRevisionIdList.get(alreadyget).equals(fnabudgetinfoid)) {
                    out.print("<a href=\"FnaBudgetView.jsp?fnabudgetinfoid=" + historyRevisionIdList.get(alreadyget) + "\">");
                }
                if ("0".equals(historyRevisionList.get(alreadyget))) {
                    out.println(SystemEnv.getHtmlLabelName(220, user.getLanguage()));
                } else {
                    out.println(SystemEnv.getHtmlLabelName(567, user.getLanguage())
                            + historyRevisionList.get(alreadyget)
                            + "&nbsp;("
                            + SystemEnv.getHtmlLabelName(1477, user.getLanguage())
                            + ")");
                }
                if (!historyRevisionIdList.get(alreadyget).equals(fnabudgetinfoid)) {
                    out.print("</a>");
                }
                alreadyget++;
            }
        %>
    </td>
</tr>

<TR style="height:1px"><TD class=Line colSpan=5></TD></TR>
<TR><TD colSpan=5 height=5></TD></TR>

</TBODY>
</TABLE>
</FORM>

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
            onclick="setGoal(this,monthbudgetlisttable);"><%=SystemEnv.getHtmlLabelName(15370, user.getLanguage())%></td>
        <td class="cycleTD"
            onclick="setGoal(this,quarterbudgetlisttable);"><%=SystemEnv.getHtmlLabelName(15373, user.getLanguage())%></td>
        <td class="cycleTD"
            onclick="setGoal(this,halfyearbudgetlisttable);"><%=SystemEnv.getHtmlLabelName(15374, user.getLanguage())%></td>
        <td class="cycleTD"
            onclick="setGoal(this,yearbudgetlisttable);"><%=SystemEnv.getHtmlLabelName(15375, user.getLanguage())%></td>
        <td id="subTab" style="text-align:right;">&nbsp;</td>
    </tr>
</table>

<table width=100%
       style="border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding:10px;padding-right:0">
<tr><td align=center valign=top>

<!--月度预算 开始-->

<%
isFirst = false;
isSecond = false;
isThird = false;

List subject1id = new ArrayList();
List subject1name = new ArrayList();
List subject1rowcount = new ArrayList();

List subject2id = new ArrayList();
List subject2name = new ArrayList();
List subject2sup = new ArrayList();
List subject2rowcount = new ArrayList();

List subject3id = new ArrayList();
List subject3name = new ArrayList();
List subject3sup = new ArrayList();
List subject3alertvalue = new ArrayList();

String sup1idstr = "";
for(int i=0;i<subjectid.size();i++) {
    String tid = subjectid.get(i).toString();
    String tname = subjectname.get(i).toString();
    String tlevel = subjectlevel.get(i).toString();
    String tsup = subjectsup.get(i).toString();
    String tfeeperiod = subjectfeeperiod.get(i).toString();
	if(tlevel.equals("1")){
        if(tfeeperiod.equals("1")){
    	    subject1id.add(tid);
		    subject1name.add(tname);
		    subject1rowcount.add("0");
		    sup1idstr += ","+tid;
        }
	}
}
sup1idstr += ",";

String sup2idstr = "";
for(int i=0;i<subjectid.size();i++) {
    String tid = subjectid.get(i).toString();
    String tname = subjectname.get(i).toString();
    String tlevel = subjectlevel.get(i).toString();
    String tsup = subjectsup.get(i).toString();
    String tfeeperiod = subjectfeeperiod.get(i).toString();
	if(tlevel.equals("2")){
        if(sup1idstr.indexOf(","+tsup+",")>-1){
    	    subject2id.add(tid);
    		subject2name.add(tname);
    		subject2sup.add(tsup);
    	    subject2rowcount.add("0");
    		sup2idstr += ","+tid;
        }
	}
}
sup2idstr += ",";
	
for(int i=0;i<subjectid.size();i++) {
    String tid = subjectid.get(i).toString();
    String tname = subjectname.get(i).toString();
    String tlevel = subjectlevel.get(i).toString();
    String tsup = subjectsup.get(i).toString();
    String tfeeperiod = subjectfeeperiod.get(i).toString();
    String talertvalue = subjectalertvalue.get(i).toString();
	if(tlevel.equals("3")){
        if(sup2idstr.indexOf(","+tsup+",")>-1){
            RecordSet4.executeSql(
	            " select count(0) from FnaBudgetInfoDetail "
	            + " where budgettypeid = " + tid
	            + " and budgetperiods =" + budgetperiods
	            + " and budgetinfoid = " + fnabudgetinfoid
            );
            if(RecordSet4.next()&&Util.getIntValue(Util.null2String(RecordSet4.getString(1)),0)>0){
	    	    subject3id.add(tid);
	    		subject3name.add(tname);
	    		subject3sup.add(tsup);
	    		subject3alertvalue.add(talertvalue);
            }
        }
	}
}

for(int l1=0;l1<subject1id.size();l1++) {
    int count1 = 0;
    for(int l2=0;l2<subject2id.size();l2++) {
        int count2 = 0;
        if(subject2sup.get(l2).toString().equals(subject1id.get(l1).toString())){
            for(int l3=0;l3<subject3id.size();l3++) {
                if(subject3sup.get(l3).toString().equals(subject2id.get(l2).toString()))
                    count2++;
            }
            subject2rowcount.set(l2,count2+"");
            count1+=count2;
        }
    }
    subject1rowcount.set(l1,count1+"");
}

ArrayList budgetperiodsstartdateList = new ArrayList();
ArrayList budgetperiodsenddateList = new ArrayList();
RecordSet4.executeSql("select startdate, enddate from FnaYearsPeriodslist where isactive='1' and fnayearid="+budgetperiods+" order by Periodsid");
while(RecordSet4.next()){
	budgetperiodsstartdateList.add(Util.null2String(RecordSet4.getString(1)));
	budgetperiodsenddateList.add(Util.null2String(RecordSet4.getString(2)));
}

%>
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
for(int l1=0;l1<subject1id.size();l1++) {
    String firestlevelid = subject1id.get(l1).toString();
    String firestlevelname = subject1name.get(l1).toString();
    String firestlevelrowcount = subject1rowcount.get(l1).toString();
    isFirst = true;

    for(int l2=0;l2<subject2id.size();l2++) {
        String secondlevelid = subject2id.get(l2).toString();
        String secondlevelname = subject2name.get(l2).toString();
        String secondlevelsup = subject2sup.get(l2).toString();
        String secondlevelrowcount = subject2rowcount.get(l2).toString();
        if(!secondlevelsup.equals(firestlevelid)) continue;
        isSecond = true;

        for(int l3=0;l3<subject3id.size();l3++) {
            String thirdlevelid = subject3id.get(l3).toString();
            String thirdlevelname = subject3name.get(l3).toString();
            String thirdlevelsup = subject3sup.get(l3).toString();
            if(!thirdlevelsup.equals(secondlevelid)) continue;
            double alertvalue = Util.getDoubleValue(subject3alertvalue.get(l3).toString()) / 100;
                isThird = !isThird;
%>
<TR>
<%
    if (isFirst) {
        isFirst = false;
%>
<TD bgcolor="#EFEFEF" rowspan="<%=firestlevelrowcount%>"><%=firestlevelname%></TD>
<%
    }
    if (isSecond) {
        isSecond = false;
%>
<TD bgcolor="#EFEFEF" rowspan="<%=secondlevelrowcount%>"><%=secondlevelname%></TD>
<%
    }
%>
<TD bgcolor="#EFEFEF"><%if (canLinkTypeView) {%><a
        href="FnaBudgetTypeView.jsp?fnabudgetinfoid=<%=fnabudgetinfoid%>&fnabudgettypeid=<%=thirdlevelid%>"><%}%><%=thirdlevelname%><%if (canLinkTypeView) {%></a><%}%>
</TD>
<TD>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr height=20 class=datadark><td nowrap><%=SystemEnv.getHtmlLabelName(18501, user.getLanguage())%></td>
        </tr>
        <%if (canShowDistributiveBudget) {%>
        <tr height=20 class=datalight><td nowrap><%=SystemEnv.getHtmlLabelName(18502, user.getLanguage())%></td>
        </tr>
        <%}%>
        <tr height=20 class=datadark><td nowrap><%=SystemEnv.getHtmlLabelName(18503, user.getLanguage())%></td>
        </tr>
        <tr height=20 class=datalight><td nowrap><%=SystemEnv.getHtmlLabelName(24785, user.getLanguage())%></td><!-- 审批中的费用 -->
        </tr>
    </table>
</TD>
<%
    double tmpSum = 0d, tmpSum1 = 0d, tmpSum2 = 0d, tmpSum3 = 0d,tmpSum4=0d;
    Map budgetTypeAmount = FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid,thirdlevelid);
    Map distributiveBudgetAmount = FnaBudgetInfoComInfo.getDistributiveBudgetAmount(organizationid, organizationtype, budgetperiods, thirdlevelid);
    
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
        <%if (canShowDistributiveBudget) {%>
        <tr height=20 class=datalight><td nowrap align=right>
            <%
                tmpnum2 = Util.getDoubleValue(Util.null2o((String)distributiveBudgetAmount.get(""+j)));//FnaBudgetInfoComInfo.getDistributiveBudgetAmount(organizationid, organizationtype, budgetperiods, (new Integer(j)).toString(), thirdlevelid);
                tmpSum2 += tmpnum2;

                out.print("<font color=" + (tmpnum2 < tmpnum1 ? "GREEN" : "BLACK") + ">");
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum2));
                out.print("</font>");
            %>
        </td></tr>
        <%}%>
        <tr height=20 class=datadark><td nowrap align=right>
            <%
                c.set(new Integer(budgetyears).intValue(), j - 1, 1);
                String startdate = s.format(c.getTime());
                c.add(Calendar.MONTH, 1);
                c.add(Calendar.DAY_OF_MONTH, -1);
                String enddate = s.format(c.getTime());
                if(budgetperiodsstartdateList.size() >= j){
					String startdate_tmp = Util.null2String((String)budgetperiodsstartdateList.get(j-1));
					String enddate_tmp = Util.null2String((String)budgetperiodsenddateList.get(j-1));
					if(!"".equals(startdate_tmp)){
						startdate = startdate_tmp;
					}
					if(!"".equals(enddate_tmp)){
						enddate = enddate_tmp;
					}
				}
                tmpnum = FnaBudgetInfoComInfo.getFeeAmount(organizationid, organizationtype, startdate, enddate, thirdlevelid);
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
        <tr height=20 class=datalight><td nowrap align=right>
            <%
               //审批中的费用
               tmpnum2 = FnaBudgetInfoComInfo.getApprovingAmount(organizationid, organizationtype, startdate, enddate, thirdlevelid); 
               tmpSum4 += tmpnum2;

                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum2));
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
        <%if (canShowDistributiveBudget) {%>
        <tr height=20 class=datalight><td nowrap align=right>
            <%
                out.print("<font color=" + (tmpSum2 < tmpSum1 ? "GREEN" : "BLACK") + ">");
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpSum2));
                out.print("</font>");
            %>
        </td></tr>
        <%}%>
        <tr height=20 class=datadark><td nowrap align=right>
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
        <tr height=20 class=datalight><td nowrap align=right>
            <%
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpSum4));
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

<%
isFirst = false;
isSecond = false;
isThird = false;

subject1id = new ArrayList();
subject1name = new ArrayList();
subject1rowcount = new ArrayList();

subject2id = new ArrayList();
subject2name = new ArrayList();
subject2sup = new ArrayList();
subject2rowcount = new ArrayList();

subject3id = new ArrayList();
subject3name = new ArrayList();
subject3sup = new ArrayList();
subject3alertvalue = new ArrayList();

sup1idstr = "";
for(int i=0;i<subjectid.size();i++) {
    String tid = subjectid.get(i).toString();
    String tname = subjectname.get(i).toString();
    String tlevel = subjectlevel.get(i).toString();
    String tsup = subjectsup.get(i).toString();
    String tfeeperiod = subjectfeeperiod.get(i).toString();
	if(tlevel.equals("1")){
        if(tfeeperiod.equals("2")){
    	    subject1id.add(tid);
		    subject1name.add(tname);
		    subject1rowcount.add("0");
		    sup1idstr += ","+tid;
        }
	}
}
sup1idstr += ",";

sup2idstr = "";
for(int i=0;i<subjectid.size();i++) {
    String tid = subjectid.get(i).toString();
    String tname = subjectname.get(i).toString();
    String tlevel = subjectlevel.get(i).toString();
    String tsup = subjectsup.get(i).toString();
    String tfeeperiod = subjectfeeperiod.get(i).toString();
	if(tlevel.equals("2")){
        if(sup1idstr.indexOf(","+tsup+",")>-1){
    	    subject2id.add(tid);
    		subject2name.add(tname);
    		subject2sup.add(tsup);
    	    subject2rowcount.add("0");
    		sup2idstr += ","+tid;
        }
	}
}
sup2idstr += ",";
	
for(int i=0;i<subjectid.size();i++) {
    String tid = subjectid.get(i).toString();
    String tname = subjectname.get(i).toString();
    String tlevel = subjectlevel.get(i).toString();
    String tsup = subjectsup.get(i).toString();
    String tfeeperiod = subjectfeeperiod.get(i).toString();
    String talertvalue = subjectalertvalue.get(i).toString();
	if(tlevel.equals("3")){
        if(sup2idstr.indexOf(","+tsup+",")>-1){
            RecordSet4.executeSql(
	            " select count(0) from FnaBudgetInfoDetail "
	            + " where budgettypeid = " + tid
	            + " and budgetperiods =" + budgetperiods
	            + " and budgetinfoid = " + fnabudgetinfoid
            );
            if(RecordSet4.next()&&Util.getIntValue(Util.null2String(RecordSet4.getString(1)),0)>0){
	    	    subject3id.add(tid);
	    		subject3name.add(tname);
	    		subject3sup.add(tsup);
	    		subject3alertvalue.add(talertvalue);
            }
        }
	}
}

for(int l1=0;l1<subject1id.size();l1++) {
    int count1 = 0;
    for(int l2=0;l2<subject2id.size();l2++) {
        int count2 = 0;
        if(subject2sup.get(l2).toString().equals(subject1id.get(l1).toString())){
            for(int l3=0;l3<subject3id.size();l3++) {
                if(subject3sup.get(l3).toString().equals(subject2id.get(l2).toString()))
                    count2++;
            }
            subject2rowcount.set(l2,count2+"");
            count1+=count2;
        }
    }
    subject1rowcount.set(l1,count1+"");
}
%>
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
for(int l1=0;l1<subject1id.size();l1++) {
    String firestlevelid = subject1id.get(l1).toString();
    String firestlevelname = subject1name.get(l1).toString();
    String firestlevelrowcount = subject1rowcount.get(l1).toString();
    isFirst = true;

    for(int l2=0;l2<subject2id.size();l2++) {
        String secondlevelid = subject2id.get(l2).toString();
        String secondlevelname = subject2name.get(l2).toString();
        String secondlevelsup = subject2sup.get(l2).toString();
        String secondlevelrowcount = subject2rowcount.get(l2).toString();
        if(!secondlevelsup.equals(firestlevelid)) continue;
        isSecond = true;

        for(int l3=0;l3<subject3id.size();l3++) {
            String thirdlevelid = subject3id.get(l3).toString();
            String thirdlevelname = subject3name.get(l3).toString();
            String thirdlevelsup = subject3sup.get(l3).toString();
            if(!thirdlevelsup.equals(secondlevelid)) continue;
            double alertvalue = Util.getDoubleValue(subject3alertvalue.get(l3).toString()) / 100;
                isThird = !isThird;
%>
<TR>
<%
    if (isFirst) {
        isFirst = false;
%>
<TD bgcolor="#EFEFEF" rowspan="<%=firestlevelrowcount%>"><%=firestlevelname%></TD>
<%
    }
    if (isSecond) {
        isSecond = false;
%>
<TD bgcolor="#EFEFEF" rowspan="<%=secondlevelrowcount%>"><%=secondlevelname%></TD>
<%
    }
%>
<TD bgcolor="#EFEFEF"><%if (canLinkTypeView) {%><a
        href="FnaBudgetTypeView.jsp?fnabudgetinfoid=<%=fnabudgetinfoid%>&fnabudgettypeid=<%=thirdlevelid%>"><%}%><%=thirdlevelname%><%if (canLinkTypeView) {%></a><%}%>
</TD>
<TD>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr height=20 class=datadark><td nowrap><%=SystemEnv.getHtmlLabelName(18501, user.getLanguage())%></td>
        </tr>
        <%if (canShowDistributiveBudget) {%>
        <tr height=20 class=datalight><td nowrap><%=SystemEnv.getHtmlLabelName(18502, user.getLanguage())%></td>
        </tr>
        <%}%>
        <tr height=20 class=datadark><td nowrap><%=SystemEnv.getHtmlLabelName(18503, user.getLanguage())%></td>
        </tr>
        <tr height=20 class=datalight><td nowrap><%=SystemEnv.getHtmlLabelName(24785, user.getLanguage())%></td><!-- 审批中的费用 -->
        </tr>
    </table>
</TD>
<%
    double tmpSum = 0d, tmpSum1 = 0d, tmpSum2 = 0d, tmpSum3 = 0d,tmpSum4=0d;
    Map budgetTypeAmount = FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid,thirdlevelid);
    Map distributiveBudgetAmount = FnaBudgetInfoComInfo.getDistributiveBudgetAmount(organizationid, organizationtype, budgetperiods, thirdlevelid);
    
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
        <%if (canShowDistributiveBudget) {%>
        <tr height=20 class=datalight><td nowrap align=right>
            <%
                tmpnum2 = Util.getDoubleValue(Util.null2o((String)distributiveBudgetAmount.get(""+j)));//FnaBudgetInfoComInfo.getDistributiveBudgetAmount(organizationid, organizationtype, budgetperiods, (new Integer(j)).toString(), thirdlevelid);
                tmpSum2 += tmpnum2;

                out.print("<font color=" + (tmpnum2 < tmpnum1 ? "GREEN" : "BLACK") + ">");
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum2));
                out.print("</font>");
            %>
        </td></tr>
        <%}%>
        <tr height=20 class=datadark><td nowrap align=right>
            <%
                c.set(new Integer(budgetyears).intValue(), (j - 1) * 3, 1);
                String startdate = s.format(c.getTime());
                c.add(Calendar.MONTH, 3);
                c.add(Calendar.DAY_OF_MONTH, -1);
                String enddate = s.format(c.getTime());

                tmpnum = FnaBudgetInfoComInfo.getFeeAmount(organizationid, organizationtype, startdate, enddate, thirdlevelid);
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
        <tr height=20 class=datalight><td nowrap align=right>
            <%
               //审批中的费用
               tmpnum2 = FnaBudgetInfoComInfo.getApprovingAmount(organizationid, organizationtype, startdate, enddate, thirdlevelid);
               tmpSum4 += tmpnum2;

                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum2));
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
        <%if (canShowDistributiveBudget) {%>
        <tr height=20 class=datalight><td nowrap align=right>
            <%
                out.print("<font color=" + (tmpSum2 < tmpSum1 ? "GREEN" : "BLACK") + ">");
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpSum2));
                out.print("</font>");
            %>
        </td></tr>
        <%}%>
        <tr height=20 class=datadark><td nowrap align=right>
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
         <tr height=20 class=datalight><td nowrap align=right>
            <%
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpSum4));
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

<%
isFirst = false;
isSecond = false;
isThird = false;

subject1id = new ArrayList();
subject1name = new ArrayList();
subject1rowcount = new ArrayList();

subject2id = new ArrayList();
subject2name = new ArrayList();
subject2sup = new ArrayList();
subject2rowcount = new ArrayList();

subject3id = new ArrayList();
subject3name = new ArrayList();
subject3sup = new ArrayList();
subject3alertvalue = new ArrayList();

sup1idstr = "";
for(int i=0;i<subjectid.size();i++) {
    String tid = subjectid.get(i).toString();
    String tname = subjectname.get(i).toString();
    String tlevel = subjectlevel.get(i).toString();
    String tsup = subjectsup.get(i).toString();
    String tfeeperiod = subjectfeeperiod.get(i).toString();
	if(tlevel.equals("1")){
        if(tfeeperiod.equals("3")){
    	    subject1id.add(tid);
		    subject1name.add(tname);
		    subject1rowcount.add("0");
		    sup1idstr += ","+tid;
        }
	}
}
sup1idstr += ",";

sup2idstr = "";
for(int i=0;i<subjectid.size();i++) {
    String tid = subjectid.get(i).toString();
    String tname = subjectname.get(i).toString();
    String tlevel = subjectlevel.get(i).toString();
    String tsup = subjectsup.get(i).toString();
    String tfeeperiod = subjectfeeperiod.get(i).toString();
	if(tlevel.equals("2")){
        if(sup1idstr.indexOf(","+tsup+",")>-1){
    	    subject2id.add(tid);
    		subject2name.add(tname);
    		subject2sup.add(tsup);
    	    subject2rowcount.add("0");
    		sup2idstr += ","+tid;
        }
	}
}
sup2idstr += ",";
	
for(int i=0;i<subjectid.size();i++) {
    String tid = subjectid.get(i).toString();
    String tname = subjectname.get(i).toString();
    String tlevel = subjectlevel.get(i).toString();
    String tsup = subjectsup.get(i).toString();
    String tfeeperiod = subjectfeeperiod.get(i).toString();
    String talertvalue = subjectalertvalue.get(i).toString();
	if(tlevel.equals("3")){
        if(sup2idstr.indexOf(","+tsup+",")>-1){
            RecordSet4.executeSql(
	            " select count(0) from FnaBudgetInfoDetail "
	            + " where budgettypeid = " + tid
	            + " and budgetperiods =" + budgetperiods
	            + " and budgetinfoid = " + fnabudgetinfoid
            );
            if(RecordSet4.next()&&Util.getIntValue(Util.null2String(RecordSet4.getString(1)),0)>0){
	    	    subject3id.add(tid);
	    		subject3name.add(tname);
	    		subject3sup.add(tsup);
	    		subject3alertvalue.add(talertvalue);
            }
        }
	}
}

for(int l1=0;l1<subject1id.size();l1++) {
    int count1 = 0;
    for(int l2=0;l2<subject2id.size();l2++) {
        int count2 = 0;
        if(subject2sup.get(l2).toString().equals(subject1id.get(l1).toString())){
            for(int l3=0;l3<subject3id.size();l3++) {
                if(subject3sup.get(l3).toString().equals(subject2id.get(l2).toString()))
                    count2++;
            }
            subject2rowcount.set(l2,count2+"");
            count1+=count2;
        }
    }
    subject1rowcount.set(l1,count1+"");
}
%>
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
for(int l1=0;l1<subject1id.size();l1++) {
    String firestlevelid = subject1id.get(l1).toString();
    String firestlevelname = subject1name.get(l1).toString();
    String firestlevelrowcount = subject1rowcount.get(l1).toString();
    isFirst = true;

    for(int l2=0;l2<subject2id.size();l2++) {
        String secondlevelid = subject2id.get(l2).toString();
        String secondlevelname = subject2name.get(l2).toString();
        String secondlevelsup = subject2sup.get(l2).toString();
        String secondlevelrowcount = subject2rowcount.get(l2).toString();
        if(!secondlevelsup.equals(firestlevelid)) continue;
        isSecond = true;

        for(int l3=0;l3<subject3id.size();l3++) {
            String thirdlevelid = subject3id.get(l3).toString();
            String thirdlevelname = subject3name.get(l3).toString();
            String thirdlevelsup = subject3sup.get(l3).toString();
            if(!thirdlevelsup.equals(secondlevelid)) continue;
            double alertvalue = Util.getDoubleValue(subject3alertvalue.get(l3).toString()) / 100;
                isThird = !isThird;
%>
<TR>
<%
    if (isFirst) {
        isFirst = false;
%>
<TD bgcolor="#EFEFEF" rowspan="<%=firestlevelrowcount%>"><%=firestlevelname%></TD>
<%
    }
    if (isSecond) {
        isSecond = false;
%>
<TD bgcolor="#EFEFEF" rowspan="<%=secondlevelrowcount%>"><%=secondlevelname%></TD>
<%
    }
%>
<TD bgcolor="#EFEFEF"><%if (canLinkTypeView) {%><a
        href="FnaBudgetTypeView.jsp?fnabudgetinfoid=<%=fnabudgetinfoid%>&fnabudgettypeid=<%=thirdlevelid%>"><%}%><%=thirdlevelname%><%if (canLinkTypeView) {%></a><%}%>
</TD>
<TD>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr height=20 class=datadark><td nowrap><%=SystemEnv.getHtmlLabelName(18501, user.getLanguage())%></td>
        </tr>
        <%if (canShowDistributiveBudget) {%>
        <tr height=20 class=datalight><td nowrap><%=SystemEnv.getHtmlLabelName(18502, user.getLanguage())%></td>
        </tr>
        <%}%>
        <tr height=20 class=datadark><td nowrap><%=SystemEnv.getHtmlLabelName(18503, user.getLanguage())%></td>
        </tr>
        <tr height=20 class=datalight><td nowrap><%=SystemEnv.getHtmlLabelName(24785, user.getLanguage())%></td><!-- 审批中的费用 -->
        </tr>
    </table>
</TD>
<%
    double tmpSum = 0d, tmpSum1 = 0d, tmpSum2 = 0d, tmpSum3 = 0d,tmpSum4=0d;
    Map budgetTypeAmount = FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid,thirdlevelid);
    Map distributiveBudgetAmount = FnaBudgetInfoComInfo.getDistributiveBudgetAmount(organizationid, organizationtype, budgetperiods, thirdlevelid);
   
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
        <%if (canShowDistributiveBudget) {%>
        <tr height=20 class=datalight><td nowrap align=right>
            <%
                tmpnum2 = Util.getDoubleValue(Util.null2o((String)distributiveBudgetAmount.get(""+j)));//FnaBudgetInfoComInfo.getDistributiveBudgetAmount(organizationid, organizationtype, budgetperiods, (new Integer(j)).toString(), thirdlevelid);
                tmpSum2 += tmpnum2;

                out.print("<font color=" + (tmpnum2 < tmpnum1 ? "GREEN" : "BLACK") + ">");
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum2));
                out.print("</font>");
            %>
        </td></tr>
        <%}%>
        <tr height=20 class=datadark><td nowrap align=right>
            <%
                c.set(new Integer(budgetyears).intValue(), (j - 1) * 6, 1);
                String startdate = s.format(c.getTime());
                c.add(Calendar.MONTH, 6);
                c.add(Calendar.DAY_OF_MONTH, -1);
                String enddate = s.format(c.getTime());

                tmpnum = FnaBudgetInfoComInfo.getFeeAmount(organizationid, organizationtype, startdate, enddate, thirdlevelid);
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
        <tr height=20 class=datalight><td nowrap align=right>
            <%
               //审批中的费用
               tmpnum2 = FnaBudgetInfoComInfo.getApprovingAmount(organizationid, organizationtype, startdate, enddate, thirdlevelid);
               tmpSum4 += tmpnum2;

                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum2));
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
        <%if (canShowDistributiveBudget) {%>
        <tr height=20 class=datalight><td nowrap align=right>
            <%
                out.print("<font color=" + (tmpSum2 < tmpSum1 ? "GREEN" : "BLACK") + ">");
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpSum2));
                out.print("</font>");
            %>
        </td></tr>
        <%}%>
        <tr height=20 class=datadark><td nowrap align=right>
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
        <tr height=20 class=datalight><td nowrap align=right>
            <%
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpSum4));
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

<%
isFirst = false;
isSecond = false;
isThird = false;

subject1id = new ArrayList();
subject1name = new ArrayList();
subject1rowcount = new ArrayList();

subject2id = new ArrayList();
subject2name = new ArrayList();
subject2sup = new ArrayList();
subject2rowcount = new ArrayList();

subject3id = new ArrayList();
subject3name = new ArrayList();
subject3sup = new ArrayList();
subject3alertvalue = new ArrayList();

sup1idstr = "";
for(int i=0;i<subjectid.size();i++) {
    String tid = subjectid.get(i).toString();
    String tname = subjectname.get(i).toString();
    String tlevel = subjectlevel.get(i).toString();
    String tsup = subjectsup.get(i).toString();
    String tfeeperiod = subjectfeeperiod.get(i).toString();
	if(tlevel.equals("1")){
        if(tfeeperiod.equals("4")){
    	    subject1id.add(tid);
		    subject1name.add(tname);
		    subject1rowcount.add("0");
		    sup1idstr += ","+tid;
        }
	}
}
sup1idstr += ",";

sup2idstr = "";
for(int i=0;i<subjectid.size();i++) {
    String tid = subjectid.get(i).toString();
    String tname = subjectname.get(i).toString();
    String tlevel = subjectlevel.get(i).toString();
    String tsup = subjectsup.get(i).toString();
    String tfeeperiod = subjectfeeperiod.get(i).toString();
	if(tlevel.equals("2")){
        if(sup1idstr.indexOf(","+tsup+",")>-1){
    	    subject2id.add(tid);
    		subject2name.add(tname);
    		subject2sup.add(tsup);
    	    subject2rowcount.add("0");
    		sup2idstr += ","+tid;
        }
	}
}
sup2idstr += ",";
	
for(int i=0;i<subjectid.size();i++) {
    String tid = subjectid.get(i).toString();
    String tname = subjectname.get(i).toString();
    String tlevel = subjectlevel.get(i).toString();
    String tsup = subjectsup.get(i).toString();
    String tfeeperiod = subjectfeeperiod.get(i).toString();
    String talertvalue = subjectalertvalue.get(i).toString();
	if(tlevel.equals("3")){
        if(sup2idstr.indexOf(","+tsup+",")>-1){
            RecordSet4.executeSql(
	            " select count(0) from FnaBudgetInfoDetail "
	            + " where budgettypeid = " + tid
	            + " and budgetperiods =" + budgetperiods
	            + " and budgetinfoid = " + fnabudgetinfoid
            );
            if(RecordSet4.next()&&Util.getIntValue(Util.null2String(RecordSet4.getString(1)),0)>0){
	    	    subject3id.add(tid);
	    		subject3name.add(tname);
	    		subject3sup.add(tsup);
	    		subject3alertvalue.add(talertvalue);
            }
        }
	}
}

for(int l1=0;l1<subject1id.size();l1++) {
    int count1 = 0;
    for(int l2=0;l2<subject2id.size();l2++) {
        int count2 = 0;
        if(subject2sup.get(l2).toString().equals(subject1id.get(l1).toString())){
            for(int l3=0;l3<subject3id.size();l3++) {
                if(subject3sup.get(l3).toString().equals(subject2id.get(l2).toString()))
                    count2++;
            }
            subject2rowcount.set(l2,count2+"");
            count1+=count2;
        }
    }
    subject1rowcount.set(l1,count1+"");
}
%>
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
for(int l1=0;l1<subject1id.size();l1++) {
    String firestlevelid = subject1id.get(l1).toString();
    String firestlevelname = subject1name.get(l1).toString();
    String firestlevelrowcount = subject1rowcount.get(l1).toString();
    isFirst = true;

    for(int l2=0;l2<subject2id.size();l2++) {
        String secondlevelid = subject2id.get(l2).toString();
        String secondlevelname = subject2name.get(l2).toString();
        String secondlevelsup = subject2sup.get(l2).toString();
        String secondlevelrowcount = subject2rowcount.get(l2).toString();
        if(!secondlevelsup.equals(firestlevelid)) continue;
        isSecond = true;

        for(int l3=0;l3<subject3id.size();l3++) {
            String thirdlevelid = subject3id.get(l3).toString();
            String thirdlevelname = subject3name.get(l3).toString();
            String thirdlevelsup = subject3sup.get(l3).toString();
            if(!thirdlevelsup.equals(secondlevelid)) continue;
            double alertvalue = Util.getDoubleValue(subject3alertvalue.get(l3).toString()) / 100;
                isThird = !isThird;
%>
<TR>
    <%
        if (isFirst) {
            isFirst = false;
    %>
    <TD bgcolor="#EFEFEF" rowspan="<%=firestlevelrowcount%>"><%=firestlevelname%></TD>
    <%
        }
        if (isSecond) {
            isSecond = false;
    %>
    <TD bgcolor="#EFEFEF" rowspan="<%=secondlevelrowcount%>"><%=secondlevelname%></TD>
    <%
        }
    %>
    <TD bgcolor="#EFEFEF"><%if (canLinkTypeView) {%><a
            href="FnaBudgetTypeView.jsp?fnabudgetinfoid=<%=fnabudgetinfoid%>&fnabudgettypeid=<%=thirdlevelid%>"><%}%><%=thirdlevelname%><%if (canLinkTypeView) {%></a><%}%>
    </TD>
    <TD>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr height=20 class=datadark><td
                    nowrap><%=SystemEnv.getHtmlLabelName(18501, user.getLanguage())%></td></tr>
            <%if (canShowDistributiveBudget) {%>
            <tr height=20 class=datalight><td
                    nowrap><%=SystemEnv.getHtmlLabelName(18502, user.getLanguage())%></td></tr>
            <%}%>
            <tr height=20 class=datadark><td
                    nowrap><%=SystemEnv.getHtmlLabelName(18503, user.getLanguage())%></td></tr>
            <tr height=20 class=datalight><td nowrap><%=SystemEnv.getHtmlLabelName(24785, user.getLanguage())%></td><!-- 审批中的费用 -->
            </tr>        
        </table>
    </TD>
    <%
        double tmpSum = 0d, tmpSum1 = 0d, tmpSum2 = 0d, tmpSum3 = 0d,tmpSum4=0d;
        Map budgetTypeAmount = FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid,thirdlevelid);
        Map distributiveBudgetAmount = FnaBudgetInfoComInfo.getDistributiveBudgetAmount(organizationid, organizationtype, budgetperiods, thirdlevelid);
        
        for (int j = 1; j <= 1; j++) {
            tmpnum = 0d;

            tmpnum = Util.getDoubleValue(Util.null2o((String)budgetTypeAmount.get(""+j)));//FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid, (new Integer(j)).toString(), thirdlevelid);
            tmpSum1 += tmpnum;

            tmpnum = Util.getDoubleValue(Util.null2o((String)distributiveBudgetAmount.get(""+j)));//FnaBudgetInfoComInfo.getDistributiveBudgetAmount(organizationid, organizationtype, budgetperiods, (new Integer(j)).toString(), thirdlevelid);
            tmpSum2 += tmpnum;

            c.set(new Integer(budgetyears).intValue(), (j - 1) * 12, 1);
            String startdate = s.format(c.getTime());
            c.add(Calendar.MONTH, 12);
            c.add(Calendar.DAY_OF_MONTH, -1);
            String enddate = s.format(c.getTime());

            tmpnum = FnaBudgetInfoComInfo.getFeeAmount(organizationid, organizationtype, startdate, enddate, thirdlevelid);
            tmpSum3 += tmpnum;
            
          //审批中的费用
            tmpnum2 = FnaBudgetInfoComInfo.getApprovingAmount(organizationid, organizationtype, startdate, enddate, thirdlevelid);
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
            <%if (canShowDistributiveBudget) {%>
            <tr height=20 class=datalight><td nowrap align=right>
                <%
                    out.print("<font color=" + (tmpSum2 < tmpSum1 ? "GREEN" : "BLACK") + ">");
                    out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpSum2));
                    out.print("</font>");
                %>
            </td></tr>
            <%}%>
            <tr height=20 class=datadark><td nowrap align=right>
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
            <tr height=20 class=datalight><td nowrap align=right>
            <%
                out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpSum4));
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