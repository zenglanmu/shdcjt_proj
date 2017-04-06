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
    RecordSet.executeSql("select id from FnaYearsPeriods");//如果未设置期间，则提示用户设置期间
    if(!RecordSet.next()){
       response.sendRedirect("FnaBudgetHelp.jsp");
       return;
    }

    
    boolean canView = true;//可查看
    boolean canCompare = true;//可版本对比
    boolean canEdit = true;//可编辑
    boolean canShowPeople = true;//显示人员预算菜单
    boolean canShowDistributiveBudget = true;//是否显示已分配预算
    boolean canLinkTypeView = true;//是否可以链接到科目预算显示

    String fnabudgetinfoid = Util.null2String(request.getParameter("fnabudgetinfoid"));//ID
    String revision = Util.null2String(request.getParameter("revision"));//版本
    String organizationid = Util.null2String(request.getParameter("organizationid"));//组织ID
    String organizationtype = Util.null2String(request.getParameter("organizationtype"));//组织类型
    String budgetperiods = Util.null2String(request.getParameter("budgetperiods"));//期间ID
    
    String fnabudgetinfoidtmp = fnabudgetinfoid;//ID
    String revisiontmp = revision;//版本
    String organizationidtmp = organizationid;//组织ID
    String organizationtypetmp = organizationtype;//组织类型
    String budgetperiodstmp = budgetperiods;//期间ID

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

    if (right < 0) canView = false;//可查看
    if (right < 1) canEdit = false;//不可编辑

    if ("2".equals(status)) canLinkTypeView = false;//历史版本不能链接进入科目预算显示
    if (!"0".equals(status) && !"1".equals(status)) canEdit = false;//历史和待审批状态，不能修改

    if ("3".equals(organizationtype)) {
        canShowDistributiveBudget = false;//人员预算无“已分配预算”统计项
        canLinkTypeView = false;//人员预算无科目链接
    }
    if (!"2".equals(organizationtype)) canShowPeople = false;//如果是部门，显示人员预算菜单

	//从流程中过了的链接，如果没有权限也要改可以查看该预算
	sqlstr = "select * from bill_FnaBudget a,workflow_currentoperator b where a.requestid = b.requestid and budgetdetail = "+fnabudgetinfoid+" and b.userid = "+user.getUID()+" and b.usertype = 0";
    RecordSet.executeSql(sqlstr);
    if (RecordSet.next()) {
    	canView = true;
    }    
    
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

<BODY onload="showdata()">
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    if (canEdit&&!"1".equals(iscanceld)) {
        RCMenu += "{" + SystemEnv.getHtmlLabelName(103, user.getLanguage()) + ",javascript:onEdit(),_self} ";
        RCMenuHeight += RCMenuHeightStep;
        
        RCMenu += "{" + SystemEnv.getHtmlLabelName(20209, user.getLanguage()) + ",javascript:onImport(),_self} ";
        RCMenuHeight += RCMenuHeightStep;
    }
    if (canShowPeople) {
        RCMenu += "{" + SystemEnv.getHtmlLabelName(18554, user.getLanguage()) + ",javascript:onShowResource(),_self} ";
        RCMenuHeight += RCMenuHeightStep;
    }
    if (canCompare) {
        RCMenu += "{" + SystemEnv.getHtmlLabelName(18553, user.getLanguage()) + ",javascript:onCompare(),_self} ";
        RCMenuHeight += RCMenuHeightStep;
        RCMenu += "{" + SystemEnv.getHtmlLabelName(18552, user.getLanguage()) + ",javascript:onShowHistory(),_self} ";
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
<td></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<script language=javascript>
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showdata(){
    var ajax=ajaxinit();
    ajax.open("POST", "FnaBudgetViewData.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("fnabudgetinfoid=<%=fnabudgetinfoidtmp%>&revision=<%=revisiontmp%>&organizationid=<%=organizationidtmp%>&organizationtype=<%=organizationtypetmp%>&budgetperiods=<%=budgetperiodstmp%>");
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                jQuery("#showdatadiv").html(ajax.responseText);
                document.getElementById("tabPane").rows[0].cells[0].className = "cycleTDCurrent";
            }catch(e){
                return false;
            }
        }
    }
}
</script>
<div id="showdatadiv">
	<table id="scrollarea" name="scrollarea" width="100%" height="100%" style="display:inline;zIndex:-1" >
	<tr>
			<td align="center" valign="center">
				<fieldset style="width:30%">
					<img src="/images/loading2.gif"><%=SystemEnv.getHtmlLabelName(20204,user.getLanguage())%></fieldset>
			</td>
	</tr>
	</table>
</div>

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
        document.frmMain.fnabudgetinfoid.value = "";
        document.frmMain.revision.value = "";
        document.frmMain.submit();
    }

    function onEdit() {
        location.href = "FnaBudgetEdit.jsp?fnabudgetinfoid=<%=fnabudgetinfoid%>";
        //document.frmMain.action="FnaBudgetEdit.jsp";
        //document.frmMain.submit();
    }

    function onShowResource() {
        location.href = "FnaBudgetResourceView.jsp?fnabudgetinfoid=<%=fnabudgetinfoid%>";
        //document.frmMain.action="FnaBudgetResourceView.jsp";
        //document.frmMain.submit();
    }

    function onCompare() {
        var o = document.frmMain.historyRevision;
        var chknum = 0;
        if (o != null && o.length > 0) {
            for (i = 0; i < o.length; i++) {
                if (o[i].checked) chknum++;
            }
            if (chknum == 2) {
                document.frmMain.action = "FnaBudgetCompare.jsp";
                document.frmMain.submit();
            } else {
                alert("<%=SystemEnv.getHtmlLabelName(18687,user.getLanguage())%>");
            }
        } else {
            alert("<%=SystemEnv.getHtmlLabelName(18687,user.getLanguage())%>");
        }
    }

    function onShowHistory() {
        location.href = "FnaBudgetHistoryView.jsp?fnabudgetinfoid=<%=fnabudgetinfoid%>";
        //document.frmMain.action="FnaBudgetHistoryView.jsp";
        //document.frmMain.submit();
    }
	
	function onImport() {
        location.href = "FnaBudgetImport.jsp?fnabudgetinfoid=<%=fnabudgetinfoid%>";
	}
	
</script>
</BODY>
</HTML>