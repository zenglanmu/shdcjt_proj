<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,weaver.general.TimeUtil,java.util.*,java.math.*" %>
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
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="BudgetApproveWFHandler" class="weaver.fna.budget.BudgetApproveWFHandler" scope="page"/>
<%
    boolean canEdit = true;//可修改
    boolean canSave = true;//可保存草稿
    boolean canProcess = true;//可保存新版本并提交审批
    boolean canApprove = true;//可保存新版本并批准
    boolean canShowDistributiveBudget = true;//是否显示已分配预算
    boolean canShowAvailableBudget = true;//是否显示上级可用预算
    boolean canLinkTypeView = true;//是否可以链接到科目预算显示

    String fnabudgetinfoid = Util.null2String(request.getParameter("fnabudgetinfoid"));//ID
    int msgid = Util.getIntValue(request.getParameter("msgid"), -1);
    String wrapshow = Util.null2String(request.getParameter("wrapshow"));//折行显示

    if ("".equals(fnabudgetinfoid)) {
        canEdit = false;
    }

    String revision = "";//版本
    String organizationid = "";//组织ID
    String organizationtype = "";//组织类型
    String budgetperiods = "";//期间ID
    String budgetyears = "";//期间年
    String status = "";//状态
    String budgetstatus = "";//审批状态

    String sqlstr = "";

//取数据
    if (fnabudgetinfoid != null && !"".equals(fnabudgetinfoid)) {
        sqlstr = " select budgetperiods,budgetorganizationid,organizationtype,revision,status,budgetstatus from FnaBudgetInfo where id = " + fnabudgetinfoid;
        RecordSet.executeSql(sqlstr);
        if (RecordSet.next()) {
            budgetperiods = RecordSet.getString("budgetperiods");
            organizationid = RecordSet.getString("budgetorganizationid");
            organizationtype = RecordSet.getString("organizationtype");
            revision = RecordSet.getString("revision");
            status = RecordSet.getString("status");
            budgetstatus = RecordSet.getString("budgetstatus");
        } else {
            canEdit = false;
        }
    } else {//如果期间为空,则不允许修改
        canEdit = false;
    }

//检查权限
    int right = -1;//-1：禁止、0：只读、1：编辑、2：完全操作
    if ("0".equals(organizationtype)) {
        if (HrmUserVarify.checkUserRight("HeadBudget:Maint", user))
        	right = Util.getIntValue(HrmUserVarify.getRightLevel("HeadBudget:Maint", user),0);
    } else {
        if (Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0) == 1) {//如果分权
            int subCompanyId = 0;
            if("1".equals(organizationtype))
                subCompanyId = (new Integer(organizationid)).intValue();
            else if("2".equals(organizationtype))
                subCompanyId = (new Integer(DepartmentComInfo.getSubcompanyid1(organizationid))).intValue();
            else if("3".equals(organizationtype))
                 subCompanyId = (new Integer(DepartmentComInfo.getSubcompanyid1(ResourceComInfo.getDepartmentID(organizationid)))).intValue();
            right = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "SubBudget:Maint",subCompanyId);
        } else {
            if (HrmUserVarify.checkUserRight("SubBudget:Maint", user))
                right = Util.getIntValue(HrmUserVarify.getRightLevel("SubBudget:Maint", user),0);
        }
    }

    if (right < 1) canEdit = false;//不可编辑

    if (right > 1) {
        canSave = true;//可保存草稿
        canProcess = false;//可保存新版本并提交审批
        canApprove = true;//可保存新版本并批准
        canShowDistributiveBudget = true;//是否显示已分配预算
        canShowAvailableBudget = true;//是否显示上级可用预算
        canLinkTypeView = true;//是否可以链接到科目预算显示
    } else {
        canSave = true;//可保存草稿
        canProcess = true;//可保存新版本并提交审批
        canApprove = false;//可保存新版本并批准
        canShowDistributiveBudget = true;//是否显示已分配预算
        canShowAvailableBudget = true;//是否显示上级可用预算
        canLinkTypeView = false;//是否可以链接到科目预算显示
    }

    if (!"0".equals(status)&&!"1".equals(status)) canEdit = false;
    if (!"0".equals(status)&&!"1".equals(status)) canLinkTypeView = false;

    if ("3".equals(organizationtype)) {
        canShowDistributiveBudget = false;
        canLinkTypeView = false;
    }

    if ("0".equals(organizationtype)) canShowAvailableBudget = false;

    ///for TD 4181
    if(BudgetApproveWFHandler.getApproveWFId(Util.getIntValue(organizationid))==0) canProcess = false;

    if (!canEdit) {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
    
    //TD15588编辑非草稿版本时，自动存为草稿后再编辑
	if (fnabudgetinfoid != null && !"".equals(fnabudgetinfoid) && !"".equals(revision) && !"0".equals(revision)) {
        response.sendRedirect("/fna/budget/FnaBudgetOperation.jsp?fnabudgetinfoid="+fnabudgetinfoid+"&operation=savetodraft");
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

    String imagefilename = "/images/hdReport.gif";
    String titlename = SystemEnv.getHtmlLabelName(386, user.getLanguage());
    String needfav = "1";
    String needhelp = "";

    double tmpnum = 0d,tmpnum1 = 0d,tmpnum2 = 0d;

    double tmpSum1 = 0d, tmpSum2 = 0d, tmpSum3 = 0d, tmpSum4 = 0d, tmpSum5 = 0d;

    boolean isFirst = false;
    boolean isSecond = false;
    boolean isThird = false;

	List subjectid = new ArrayList();
	List subjectname = new ArrayList();
	List subjectlevel = new ArrayList();
	List subjectsup = new ArrayList();
	List subjectfeeperiod = new ArrayList();

	int showtab = Util.getIntValue(Util.null2String(request.getParameter("showtab")),1);
	int topage = Util.getIntValue(Util.null2String(request.getParameter("page")),1);
	int pagesize = 10;
	int pagecount = 0;
	int recordcount = 0;
	
	RecordSet.executeSql(" select a.id aid,a.name aname,a.feelevel afeelevel,a.feeperiod afeeperiod,b.id bid,b.name bname,b.feelevel bfeelevel,b.supsubject bsupsubject,c.id cid,c.name cname,c.feelevel cfeelevel,c.supsubject csupsubject from FnaBudgetfeeType a,FnaBudgetfeeType b ,FnaBudgetfeeType c where b.supsubject = a.id and c.supsubject = b.id order by a.name,b.supsubject,b.name,c.supsubject,c.name ");
    while (RecordSet.next()) {
		String aid = Util.null2String(RecordSet.getString("aid"));
		String aname = Util.null2String(RecordSet.getString("aname"));
		String afeelevel = Util.null2String(RecordSet.getString("afeelevel"));
		String afeeperiod = Util.null2String(RecordSet.getString("afeeperiod"));
		String bid = Util.null2String(RecordSet.getString("bid"));
		String bname = Util.null2String(RecordSet.getString("bname"));
		String bfeelevel = Util.null2String(RecordSet.getString("bfeelevel"));
		String bsupsubject = Util.null2String(RecordSet.getString("bsupsubject"));
		String cid = Util.null2String(RecordSet.getString("cid"));
		String cname = Util.null2String(RecordSet.getString("cname"));
		String cfeelevel = Util.null2String(RecordSet.getString("cfeelevel"));
		String csupsubject = Util.null2String(RecordSet.getString("csupsubject"));
		
		if(subjectid.indexOf(aid)<0){//添加 1级
			subjectid.add(aid);
	        subjectname.add(aname);
	        subjectlevel.add(afeelevel);
	        subjectsup.add("");
	        subjectfeeperiod.add(afeeperiod);			
		}

		if(subjectid.indexOf(bid)<0){//添加 2级
			subjectid.add(bid);
	        subjectname.add(bname);
	        subjectlevel.add(bfeelevel);
	        subjectsup.add(bsupsubject);
	        subjectfeeperiod.add(afeeperiod);			
		}
		
		//添加 3级
		subjectid.add(cid);
        subjectname.add(cname);
        subjectlevel.add(cfeelevel);
        subjectsup.add(csupsubject);
        subjectfeeperiod.add(afeeperiod);
    }

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
            background-image: url( /images/tab2.png );
            cursor: hand;
            font-weight: bold;
            text-align: center;
            color: #666;
            border-bottom: 1px solid #879293;
        }

        .cycleTDCurrent {
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
    if (canSave) {//保存
        RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:onSave(this),_self} ";
        RCMenuHeight += RCMenuHeightStep;
    }
    if (canProcess) {//提交审批
        RCMenu += "{" + SystemEnv.getHtmlLabelName(15143, user.getLanguage()) + ",javascript:onProcess(this),_self} ";
        RCMenuHeight += RCMenuHeightStep;
    }
    if (canApprove) {//批准生效
        RCMenu += "{" + SystemEnv.getHtmlLabelName(142, user.getLanguage()) + SystemEnv.getHtmlLabelName(18431, user.getLanguage()) + ",javascript:onApprove(this),_self} ";
        RCMenuHeight += RCMenuHeightStep;
    }
%>
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
<td></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
     
<span id="errormsg" style="color:red"></span>

<FORM id="frmMain" name="frmMain" action="FnaBudgetOperation.jsp" method=post>
<input type="hidden" name="operation">
<INPUT name="fnabudgetinfoid" type="hidden" value="<%=fnabudgetinfoid%>">
<INPUT name="wrapshow" type="hidden" value="<%=wrapshow%>">
<INPUT name="topage" type="hidden" value="<%=topage%>">
<INPUT name="page" type="hidden" value="<%=topage%>">
<INPUT name="showtab" type="hidden" value="<%=showtab%>">

<!--表头 开始-->

<TABLE class="ViewForm">
<TBODY>
<colgroup>
<col width="16%">
<col width="*">
<TR>
    <TH class=Title colspan=2>
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
            if (!"".equals(revision) && !"0".equals(revision)) {
                fnatitle += SystemEnv.getHtmlLabelName(567, user.getLanguage());
                fnatitle += ":";
                fnatitle += revision;
                fnatitle += "&nbsp;";
                if ("1".equals(status)) fnatitle += SystemEnv.getHtmlLabelName(18431, user.getLanguage());
                else fnatitle += SystemEnv.getHtmlLabelName(1477, user.getLanguage());
            } else fnatitle += SystemEnv.getHtmlLabelName(220, user.getLanguage());
            fnatitle += ")</font>";
            out.println(fnatitle);
        %>
    </TH>
</TR>

<TR class=Spacing>
    <TD class=Sep1 colSpan=2></TD>
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
                        + "<b>(" + SystemEnv.getHtmlLabelName(141, user.getLanguage()) + ")</b>");
            if ("2".equals(organizationtype))
                out.print(Util.toScreen(DepartmentComInfo.getDepartmentname(organizationid), user.getLanguage())
                        + "<b>(" + SystemEnv.getHtmlLabelName(124, user.getLanguage()) + ")</b>");
            if ("3".equals(organizationtype))
                out.print(Util.toScreen(ResourceComInfo.getResourcename(organizationid), user.getLanguage())
                        + "<b>(" + SystemEnv.getHtmlLabelName(1867, user.getLanguage()) + ")</b>");
        %>
        <input type="hidden" name="organizationid" value="<%=organizationid%>">
        <input type="hidden" name="organizationtype" value="<%=organizationtype%>">
    </td>
</tr>

<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>

<tr>
    <td><%=SystemEnv.getHtmlLabelName(15365, user.getLanguage())%></td>
    <td class=Field><%=budgetyears%>
        <input type="hidden" name="budgetperiods" value="<%=budgetperiods%>">
    </td>
</tr>

<TR style="height:1px"><TD class=Line colSpan=5></TD></TR>

<%if (canShowAvailableBudget) {%>
<tr>
    <td><%=SystemEnv.getHtmlLabelName(18604, user.getLanguage())%></td>
    <td class=Field>
        <% // Todo 上级可用预算
            tmpnum = FnaBudgetInfoComInfo.getAvailableBudgetAmount(organizationid, organizationtype, budgetperiods);
        %>
        <span id="canusedbudget"
              style="color:<%=(tmpnum==0?"RED":"BLACK")%>"><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpnum)%></span>
        <input type="hidden" name="canusedbudget" value="<%=FnaBudgetInfoComInfo.getStrFromDouble(tmpnum)%>">
    </td>
</tr>

<TR style="height:1px"><TD class=Line colSpan=5></TD></TR>
<%}%>

<%if (canShowDistributiveBudget) {%>
<tr>
    <td><%=SystemEnv.getHtmlLabelName(18568, user.getLanguage())%></td>
    <td class=Field>
        <% // Todo 已分配下级预算
            tmpnum = FnaBudgetInfoComInfo.getDistributiveBudgetAmount(organizationid, organizationtype, budgetperiods);
        %>
        <span id="allottedbudget"><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpnum)%></span>
        <input type="hidden" name="allottedbudget" value="<%=FnaBudgetInfoComInfo.getStrFromDouble(tmpnum)%>">
    </td>
</tr>

<TR style="height:1px"><TD class=Line colSpan=5></TD></TR>
<%}%>

<tr>
    <td><%=SystemEnv.getHtmlLabelName(18569, user.getLanguage())%></td>
    <td class=Field>
        <% // Todo 原预算额
            tmpnum = FnaBudgetInfoComInfo.getBudgetAmount(organizationid, organizationtype, budgetperiods);
            tmpnum1 = tmpnum;
        %>
        <span id="originalbudget"><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpnum)%></span>
        <input type="hidden" name="originalbudget" value="<%=FnaBudgetInfoComInfo.getStrFromDouble(tmpnum)%>">
    </td>
</tr>

<TR style="height:1px"><TD class=Line colSpan=5></TD></TR>

<tr>
    <td><%=SystemEnv.getHtmlLabelName(18570, user.getLanguage())%></td>
    <td class=Field>
        <% // Todo 新预算额
            tmpnum = FnaBudgetInfoComInfo.getBudgetAmount(fnabudgetinfoid);
            tmpnum2 = tmpnum;
        %>
        <span id="newbudget"><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpnum)%></span>
        <input type="hidden" name="newbudget" value="<%=FnaBudgetInfoComInfo.getStrFromDouble(tmpnum)%>">
        <input type="hidden" name="newbudgetpage" value="<%=FnaBudgetInfoComInfo.getStrFromDouble(tmpnum)%>">
    </td>
</tr>


<TR style="height:1px"><TD class=Line colSpan=5></TD></TR>

<tr>
    <td><%=SystemEnv.getHtmlLabelName(18571, user.getLanguage())%></td>
    <td class=Field>
        <% // Todo 预算增额
            tmpnum = tmpnum2 - tmpnum1;
        %>
        <span id="addedbudget"
              style="color:<%=(tmpnum<0?"RED":"GREEN")%>"><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpnum)%></span>
        <input type="hidden" name="addedbudget" value="<%=FnaBudgetInfoComInfo.getStrFromDouble(tmpnum)%>">
        <input type="hidden" name="addedbudgethid" value="<%=FnaBudgetInfoComInfo.getStrFromDouble(tmpnum)%>">
    </td>
</tr>

<%--
<tr>
    <td><%=SystemEnv.getHtmlLabelName(18577, user.getLanguage())%></td>
    <td class=Field>
        <% // Todo Excel文件导入
        %>
        <input class=InputStyle type=file size=50 name="importExcel"/>
    </td>
</tr>
--%>

<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
<TR><TD colSpan=5 height=2></TD></TR>
</TBODY>
</TABLE>

<!--表头 结束-->

<table width="100%" border=0 cellspacing=0 cellpadding=0 id="tabPane">
    <colgroup>
        <col width="79" height="18"></col>
        <col width="79" height="18"></col>
        <col width="79" height="18"></col>
        <col width="79" height="18"></col>
        <col width="*" height="18"></col>
        <col width="120" height="18"></col>
        <col width="120" height="18"></col>
    </colgroup>
    <tr>
        <td id="monthbudgetlisttd" class="<%if(showtab==1){%>cycleTDCurrent<%}else{%>cycleTD<%}%>"
            onclick="setGoal(this,monthbudgetlisttable);"><%=SystemEnv.getHtmlLabelName(15370, user.getLanguage())%></td>
        <td id="quarterbudgetlisttd" class="<%if(showtab==2){%>cycleTDCurrent<%}else{%>cycleTD<%}%>"
            onclick="setGoal(this,quarterbudgetlisttable);"><%=SystemEnv.getHtmlLabelName(15373, user.getLanguage())%></td>
        <td id="halfyearbudgetlisttd" class="<%if(showtab==3){%>cycleTDCurrent<%}else{%>cycleTD<%}%>"
            onclick="setGoal(this,halfyearbudgetlisttable);"><%=SystemEnv.getHtmlLabelName(15374, user.getLanguage())%></td>
        <td id="yearbudgetlisttd" class="<%if(showtab==4){%>cycleTDCurrent<%}else{%>cycleTD<%}%>"
            onclick="setGoal(this,yearbudgetlisttable);"><%=SystemEnv.getHtmlLabelName(15375, user.getLanguage())%></td>
        <td id="subTab">&nbsp;</td>
        <td id="subTab" align="right" valign=top height=18 nowrap>
            <BUTTON id="btnwrapshow" type="button" name="btnwrapshow" style="height:19px;display:block" class=btnRefresh onclick="onWrapShow()"><%=("yes".equals(wrapshow)?SystemEnv.getHtmlLabelName(233, user.getLanguage()):"")+SystemEnv.getHtmlLabelName(18872, user.getLanguage())%></BUTTON>
        </td>
        <td id="subTab" align="right" valign=top height=18 nowrap>
            <BUTTON style="height:19px" type="button" class=btnEdit onclick="onAverage()"><%=SystemEnv.getHtmlLabelName(18579, user.getLanguage())%></BUTTON>
        </td>
    </tr>
</table>

<table width=100% style="border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding:10px;padding-right:0">
<tr><td align=center valign=top>
<%@ include file="/fna/budget/FnaBudgetEditMonthly.jsp" %>
<%@ include file="/fna/budget/FnaBudgetEditQuarterly.jsp" %>
<%@ include file="/fna/budget/FnaBudgetEditHalfyearly.jsp" %>
<%@ include file="/fna/budget/FnaBudgetEditYearly.jsp" %>
</td></tr>
</table>

</FORM>
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
var isChanged = false;

function formatNum(num,toFix) {
    if(isNaN(num)) return (toFix?"0.00":"0");
    if(toFix) return num.toFixed(2);
    else
        if(num-Math.floor(num)==0) return Math.floor(num);
        else return num.toFixed(2);
}

function setGoal(o, b) {
    if(o.id=="monthbudgetlisttd") document.frmMain.showtab.value="1";
    if(o.id=="quarterbudgetlisttd") document.frmMain.showtab.value="2";
    if(o.id=="halfyearbudgetlisttd") document.frmMain.showtab.value="3";
    if(o.id=="yearbudgetlisttd") document.frmMain.showtab.value="4";
		onPage(1);
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
    if(document.getElementById("monthbudgetlisttable").style.display == "none") document.getElementById("btnwrapshow").style.display = "none";
    else document.getElementById("btnwrapshow").style.display = "block";
    if(o.id=="monthbudgetlisttd") document.frmMain.showtab.value="1";
    if(o.id=="quarterbudgetlisttd") document.frmMain.showtab.value="2";
    if(o.id=="halfyearbudgetlisttd") document.frmMain.showtab.value="3";
    if(o.id=="yearbudgetlisttd") document.frmMain.showtab.value="4";
}

function onSelectAll(o) {
    if (document.getElementById("tabPane").rows[0].cells[0].className == "cycleTDCurrent") {//月
        var t = eval("document.frmMain." + "month" + "_FnaBudgetfeeTypeIDs");
        if (t != null && t.length > 0) {
            for (i = 1; i < t.length; i++) t[i].checked = t[0].checked;
        }
    } else if (document.getElementById("tabPane").rows[0].cells[1].className == "cycleTDCurrent") {//季
        var t = eval("document.frmMain." + "quarter" + "_FnaBudgetfeeTypeIDs");
        if (t != null && t.length > 0) {
            for (i = 1; i < t.length; i++) t[i].checked = t[0].checked;
        }
    } else if (document.getElementById("tabPane").rows[0].cells[2].className == "cycleTDCurrent") {//半年
        var t = eval("document.frmMain." + "halfyear" + "_FnaBudgetfeeTypeIDs");
        if (t != null && t.length > 0) {
            for (i = 1; i < t.length; i++) t[i].checked = t[0].checked;
        }
    } else if (document.getElementById("tabPane").rows[0].cells[3].className = "cycleTDCurrent") {//年
        var t = eval("document.frmMain." + "year" + "_FnaBudgetfeeTypeIDs");
        if (t != null && t.length > 0) {
            for (i = 1; i < t.length; i++) t[i].checked = t[0].checked;
        }
    }
}

function onWrapShow(){
    if (!isChanged||confirm("<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>")) {
        location.href="/fna/budget/FnaBudgetEdit.jsp?fnabudgetinfoid=<%=fnabudgetinfoid%>&wrapshow=<%=("yes".equals(wrapshow)?"no":"yes")%>";
    }
}

function onCalculete(obj) {
    isChanged = true;
    var needcalculetetypearray = new Array("canusedbudget", "allottedbudget", "originalbudget", "newbudget", "addedbudget");
    var needcalculetetimearray = new Array("month", "quarter", "halfyear", "year");
    var tmpn = 0;
    var tmpnum = 0;
    var tmpyearnum = 0;
    var tmpallnum = 0;
    var splitstrarray = obj.name.split("_");
    //如果是全年，将选择框选中
    var t = eval("document.frmMain." + splitstrarray[0] + "_FnaBudgetfeeTypeIDs");
    if (t != null && t.length > 0) {
        for (i = 1; i < t.length; i++) {
            if(t[i].value==splitstrarray[1]){
                t[i].checked = true;
                break;
            }
        }
    }
    //当前期间原预算
    tmpn = document.getElementById(splitstrarray[0] + "_" + splitstrarray[1] + "_" + needcalculetetypearray[2] + "_" + splitstrarray[3]).innerHTML;
    var currentoriginal = parseFloat(tmpn == ""?0:tmpn);
    //当前期间新预算
    tmpn = obj.value;
    var currentnew = parseFloat(tmpn == ""?0:tmpn);
    //当前期间增额
    tmpnum = formatNum(currentnew - currentoriginal,false);
    document.getElementById(splitstrarray[0] + "_" + splitstrarray[1] + "_" + needcalculetetypearray[4] + "_" + splitstrarray[3]).innerHTML = tmpnum;
    document.getElementById(splitstrarray[0] + "_" + splitstrarray[1] + "_" + needcalculetetypearray[4] + "_" + splitstrarray[3]).style.color = (tmpnum >= 0?"GREEN":"RED");
    //年原预算
    tmpn = document.getElementById(splitstrarray[0] + "_" + splitstrarray[1] + "_" + needcalculetetypearray[2] + "_sum").innerHTML;
    var yearoriginal = parseFloat(tmpn == ""?0:tmpn);
    //年新预算
    tmpn = eval("document.frmMain." + splitstrarray[0] + "_" + splitstrarray[1] + "_" + needcalculetetypearray[3] + "_sum").value;
    var yearnew_input = parseFloat(tmpn == ""?0:tmpn);
    //汇总年新预算
    var yearnew = 0;
    if (splitstrarray[0] == needcalculetetimearray[0]) {
        for (i = 1; i < 13; i++) {
            tmpn = eval("document.frmMain." + needcalculetetimearray[0] + "_" + splitstrarray[1] + "_" + needcalculetetypearray[3] + "_" + i).value;
            yearnew = yearnew + parseFloat(tmpn == ""?0:tmpn);
        }
    } else if (splitstrarray[0] == needcalculetetimearray[1]) {
        for (i = 1; i < 5; i++) {
            tmpn = eval("document.frmMain." + needcalculetetimearray[1] + "_" + splitstrarray[1] + "_" + needcalculetetypearray[3] + "_" + i).value;
            yearnew = yearnew + parseFloat(tmpn == ""?0:tmpn);
        }
    } else if (splitstrarray[0] == needcalculetetimearray[2]) {
        for (i = 1; i < 3; i++) {
            tmpn = eval("document.frmMain." + needcalculetetimearray[2] + "_" + splitstrarray[1] + "_" + needcalculetetypearray[3] + "_" + i).value;
            yearnew = yearnew + parseFloat(tmpn == ""?0:tmpn);
        }
    } else if (splitstrarray[0] == needcalculetetimearray[3]) {
        tmpn = eval("document.frmMain." + needcalculetetimearray[3] + "_" + splitstrarray[1] + "_" + needcalculetetypearray[3] + "_" + "sum").value;
        yearnew = parseFloat(tmpn == ""?0:tmpn);
    }
    yearnew = formatNum(yearnew,false);
    if (yearnew_input > yearnew) {
        yearnew = formatNum(yearnew_input,false);
    }
    eval("document.frmMain." + splitstrarray[0] + "_" + splitstrarray[1] + "_" + needcalculetetypearray[3] + "_sum").value = yearnew;

    //年增额
    tmpyearnum = formatNum(yearnew - yearoriginal,false);
    document.getElementById(splitstrarray[0] + "_" + splitstrarray[1] + "_" + needcalculetetypearray[4] + "_sum").innerHTML = tmpyearnum;
    document.getElementById(splitstrarray[0] + "_" + splitstrarray[1] + "_" + needcalculetetypearray[4] + "_sum").style.color = (tmpyearnum >= 0?"GREEN":"RED");

    //表头
    //所有原预算
    tmpn = eval("document.frmMain." + needcalculetetypearray[2]).value;
    var alloriginal = parseFloat(tmpn == ""?0:tmpn);
    
    //所有预算增额
    tmpn = eval("document.frmMain.addedbudgethid").value;
    tmpallnum = parseFloat(tmpn == ""?0:tmpn);

    var tempadd = 0;
    var tempaddhid = 0;
    for (i = 0; i < needcalculetetimearray.length; i++) {
        var t = eval("document.frmMain." + needcalculetetimearray[i] + "_FnaBudgetfeeTypeIDs");
        if (t != null) {
            for (j = 1; j < t.length; j++) {
                var id = t[j].value;
                tmpn = document.getElementById(needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[4] + "_sum").innerHTML;
                tempadd += parseFloat(tmpn == ""?0:tmpn);
                tmpn = eval("document.frmMain." + needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[4] + "_sumhid").value;
                tempaddhid += parseFloat(tmpn == ""?0:tmpn);
            }
        }
    }
 	tmpallnum = formatNum(tmpallnum + tempadd - tempaddhid,false);
 	
    //汇总所有新预算
    var allnew = 0;
    tmpn = eval("document.frmMain.originalbudget").value;
    allnew = parseFloat(tmpn == ""?0:tmpn);
    allnew = formatNum(allnew + tmpallnum,false);
    eval("document.frmMain." + needcalculetetypearray[3]).value = allnew;
    document.getElementById(needcalculetetypearray[3]).innerHTML = allnew;
    //所有增额
    eval("document.frmMain." + needcalculetetypearray[4]).value = tmpallnum;
    document.getElementById(needcalculetetypearray[4]).innerHTML = tmpallnum;
    document.getElementById(needcalculetetypearray[4]).style.color = (tmpallnum >= 0?"GREEN":"RED");
}

function onAverage() {
    var needcalculetetypearray = new Array("canusedbudget", "allottedbudget", "originalbudget", "newbudget", "addedbudget");
    var needcalculetetimearray = new Array("month", "quarter", "halfyear", "year");
    var tmpn = 0;
    for (i = 0; i < needcalculetetimearray.length; i++) {
        var t = eval("document.frmMain." + needcalculetetimearray[i] + "_FnaBudgetfeeTypeIDs");
        if (t != null) {
            for (j = 1; j < t.length; j++) {
                if (t[j].checked == true) {
                    var id = t[j].value;
                    tmpn = eval("document.frmMain." + needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[3] + "_sum").value;
                    var yearnew = parseFloat(tmpn == ""?0:tmpn);
                    var avaragenum = 0;
                    var tmpk = 0;
                    if (i == 0) tmpk = 13;
                    else if (i == 1) tmpk = 5;
                    else if (i == 2) tmpk = 3;
                    else if (i == 3) tmpk = 1;
                    for (k = 1; k < tmpk; k++) {
                        tmpn = eval("document.frmMain." + needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[3] + "_" + k).value;
                        if (tmpn == "") avaragenum++;
                        else yearnew = formatNum(yearnew - parseFloat(tmpn),false);
                    }
                    if (avaragenum > 0 && yearnew > 0) {
                        var avaragevalue = formatNum(parseFloat(yearnew / avaragenum),false);
                        var avaragelastvalue = formatNum(parseFloat(yearnew - (avaragevalue * (avaragenum - 1))),false);
                        for (k = 1,p = 1; k < tmpk; k++) {
                            tmpn = eval("document.frmMain." + needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[3] + "_" + k).value;
                            if (tmpn == "") {
                                var currentnew = ((p == avaragenum)?avaragelastvalue:avaragevalue);
                                eval("document.frmMain." + needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[3] + "_" + k).value = currentnew;
                                var tmpn = document.getElementById(needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[2] + "_" + k).innerHTML;
                                var currentoriginal = parseFloat(tmpn == ""?0:tmpn);
                                var tmpnum = formatNum(parseFloat(currentnew - currentoriginal),false);
                                document.getElementById(needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[4] + "_" + k).innerHTML = tmpnum;
                                document.getElementById(needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[4] + "_" + k).style.color = (tmpnum >= 0?"GREEN":"RED");
                                p++;
                            }
                        }
                    }
                }
            }
        }
    }
}

function check(chkitem1, chkitem2, chkitem3) {
    var needcalculetetypearray = new Array("canusedbudget", "allottedbudget", "originalbudget", "newbudget", "addedbudget");
    var needcalculetetimearray = new Array("month", "quarter", "halfyear", "year");
    var rtnvalue = true;
    var t1 = eval("document.frmMain.FnaBudgetfeeTypeIDs");
    var t2 = eval("document.frmMain.FnaBudgetfeeTypeSaveValueNum");
    //检查年汇总是否相等
    if (t1 != null && t2 != null && chkitem1) {
        for (j = 0; j < t1.length; j++) {
            var tmpsum1 = 0;
            var tmpsum2 = 0;
            var tmpnum = 0;
            var tk = 0;
            var i = 0;
            var id = t1[j].value;
            tk = parseInt(t2[j].value);
            if (tk > 1) {
                if (tk == 12) i = 0;
                if (tk == 4) i = 1;
                if (tk == 2) i = 2;
                tmpnum = eval("document.frmMain." + needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[3] + "_sum").value;
                tmpsum1 = parseFloat(tmpnum == ""?0:tmpnum);
                for (k = 1; k < tk + 1; k++) {
                    tmpnum = eval("document.frmMain." + needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[3] + "_" + k).value;
                    tmpsum2 += parseFloat(tmpnum == ""?0:tmpnum)
                }
                if (tmpsum1.toFixed(2) != tmpsum2.toFixed(2)) {
                    eval("document.frmMain." + needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[3] + "_sum").style.backgroundColor="#ff6666";
                    rtnvalue = false;
                } else {
                    eval("document.frmMain." + needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[3] + "_sum").style.backgroundColor="";
                }
            }
        }
        if(!rtnvalue) {
            if(confirm("<%=SystemEnv.getHtmlLabelName(18755,user.getLanguage())%>,<%=SystemEnv.getHtmlLabelName(18878,user.getLanguage())%>")){
                for (j = 0; j < t1.length; j++) {
                    var tmpsum1 = 0;
                    var tmpsum2 = 0;
                    var tmpnum = 0;
                    var tk = 0;
                    var i = 0;
                    var id = t1[j].value;
                    tk = parseInt(t2[j].value);
                    if (tk > 1) {
                        if (tk == 12) i = 0;
                        if (tk == 4) i = 1;
                        if (tk == 2) i = 2;
                        tmpnum = eval("document.frmMain." + needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[3] + "_sum").value;
                        tmpsum1 = parseFloat(tmpnum == ""?0:tmpnum);
                        for (k = 1; k < tk + 1; k++) {
                            tmpnum = eval("document.frmMain." + needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[3] + "_" + k).value;
                            tmpsum2 += parseFloat(tmpnum == ""?0:tmpnum)
                        }
                        if (tmpsum1.toFixed(2) != tmpsum2.toFixed(2)) {
                            eval("document.frmMain." + needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[3] + "_sum").style.backgroundColor="";
                            eval("document.frmMain." + needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[3] + "_sum").value=formatNum(tmpsum2,false);
                        }
                    }
                }
                rtnvalue = true;
            } else {
                //alert("<%=SystemEnv.getHtmlLabelName(18755,user.getLanguage())%>");
                //rtnvalue = false;
                return false;
            }
        }
    }
    //检查是否预算额大于已分配下级预算
    <%if(canShowDistributiveBudget){%>
    if (t1 != null && t2 != null && chkitem2) {
        for (j = 0; j < t1.length; j++) {
            var tmpsum1 = 0;
            var tmpsum2 = 0;
            var tmpnum = 0;
            var tk = 0;
            var i = 0;
            var id = t1[j].value;
            tk = parseInt(t2[j].value);

            if (tk == 12) i = 0;
            if (tk == 4) i = 1;
            if (tk == 2) i = 2;
            if (tk == 1) i = 3;

            for (k = 1; k < tk + 1; k++) {
                var tmptk = "";
                if (tk == 1) tmptk = "sum";
                else tmptk = k;

                tmpnum = document.getElementById(needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[1] + "_" + tmptk).innerHTML;
                tmpsum1 = parseFloat(tmpnum == ""?0:tmpnum);

                tmpnum = eval("document.frmMain." + needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[3] + "_" + tmptk).value;
                tmpsum2 = parseFloat(tmpnum == ""?0:tmpnum);

                if (tmpsum1 > tmpsum2) {
                    eval("document.frmMain." + needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[3] + "_" + tmptk).style.backgroundColor="#ff6666";
                    rtnvalue = false;
                } else {
                    eval("document.frmMain." + needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[3] + "_" + tmptk).style.backgroundColor="";
                }
            }
            if (!rtnvalue) {
                eval("document.frmMain." + needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[3] + "_" + "sum").style.backgroundColor="#ff6666";
                break;
            } else {
                eval("document.frmMain." + needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[3] + "_" + "sum").style.backgroundColor="";
            }
        }
        if(!rtnvalue) {
            alert("<%=SystemEnv.getHtmlLabelName(18756,user.getLanguage())%>");
            return false;
        }
    }
    <%}%>
    //预算增额要小于上级可用预算
<%if(canShowAvailableBudget){%>
    if (t1 != null && t2 != null && chkitem3) {
        for (j = 0; j < t1.length; j++) {
            var tmpsum1 = 0;
            var tmpsum2 = 0;
            var tmpnum = 0;
            var tk = 0;
            var i = 0;
            var id = t1[j].value;
            tk = parseInt(t2[j].value);

            if (tk == 12) i = 0;
            if (tk == 4) i = 1;
            if (tk == 2) i = 2;
            if (tk == 1) i = 3;

            for (k = 1; k < tk + 1; k++) {
                var tmptk = "";
                if (tk == 1) tmptk = "sum";
                else tmptk = k;

                tmpnum = document.getElementById(needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[0] + "_" + tmptk).innerHTML;
                tmpsum1 = parseFloat(tmpnum == ""?0:tmpnum);

                tmpnum = document.getElementById(needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[4] + "_" + tmptk).innerHTML;
                tmpsum2 = parseFloat(tmpnum == ""?0:tmpnum);

                if (tmpsum1 < tmpsum2) {
                    eval("document.frmMain." + needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[3] + "_" + tmptk).style.backgroundColor="#ff6666";
                    rtnvalue = false;
                } else {
                    eval("document.frmMain." + needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[3] + "_" + tmptk).style.backgroundColor="";
                }
            }
            if(!rtnvalue){
                eval("document.frmMain." + needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[3] + "_" + "sum").style.backgroundColor="#ff6666";
                break;
            } else {
                eval("document.frmMain." + needcalculetetimearray[i] + "_" + id + "_" + needcalculetetypearray[3] + "_" + "sum").style.backgroundColor="";
            }
        }
        if(!rtnvalue){
            alert("<%=SystemEnv.getHtmlLabelName(18757,user.getLanguage())%>");
            return false;
        }
    }
<%}%>
    return rtnvalue;
}

function onSave(obj) {
    if (check(true, false, false)) {
        document.frmMain.action = "FnaBudgetOperation.jsp";
        document.frmMain.operation.value = "editbudget";
        document.frmMain.submit();
        obj.disabled=true;
    }
}

function onProcess(obj) {
    if (check(true, true, false)) {
        document.frmMain.action = "FnaBudgetOperation.jsp";
        document.frmMain.operation.value = "processfnabudget";
        document.frmMain.submit();
        obj.disabled=true;
    }
}

function onApprove(obj) {
    if (check(true, true, true)) {
        document.frmMain.action = "FnaBudgetOperation.jsp";
        document.frmMain.operation.value = "approvefnabudget";
        document.frmMain.submit();
        obj.disabled=true;
    }
}

function onPage(page){
    if (check(true, false, false)) {
	    document.frmMain.action = "FnaBudgetOperation.jsp";
	    document.frmMain.operation.value = "savepage";
	    document.frmMain.topage.value = page;
	    document.frmMain.submit();
	}
}
<% if (msgid != -1) { %>
check(true, true, true);
<%}%>
</script>

</BODY>
</HTML>