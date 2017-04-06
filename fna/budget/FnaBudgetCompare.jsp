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
<jsp:useBean id="FnaBudgetInfoComInfo" class="weaver.fna.maintenance.FnaBudgetInfoComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
boolean canView = true;//可查看
boolean canLinkTypeView = false;//是否可以链接到科目预算显示

String backfnabudgetinfoid = Util.null2String(request.getParameter("fnabudgetinfoid"));//ID
String[] fnabudgetinfoid = request.getParameterValues("historyRevision");//ID
String revision[] = new String[]{"",""};//版本
String organizationid = "";//组织ID
String organizationtype = "";//组织类型
String budgetperiods = "";//期间ID
String budgetyears = "";//期间年
String status[] = new String[]{"",""};//状态
String budgetstatus[] = new String[]{"",""};//审批状态

String sqlstr = "";
char separator = Util.getSeparator() ;
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);

if(fnabudgetinfoid!=null||fnabudgetinfoid.length==2) {
	sqlstr =" select budgetperiods,budgetorganizationid,organizationtype,budgetstatus,revision,status from FnaBudgetInfo where id = " + fnabudgetinfoid[0];
	RecordSet.executeSql(sqlstr);
	if(RecordSet.next()) {
		budgetperiods = RecordSet.getString("budgetperiods");
		organizationid = RecordSet.getString("budgetorganizationid");
		organizationtype = RecordSet.getString("organizationtype");
		budgetstatus[0] = RecordSet.getString("budgetstatus");
		revision[0] = RecordSet.getString("revision");
		status[0] = RecordSet.getString("status");
	}
	sqlstr =" select budgetperiods,budgetorganizationid,organizationtype,budgetstatus,revision,status from FnaBudgetInfo where id = " + fnabudgetinfoid[1];
	RecordSet.executeSql(sqlstr);
	if(RecordSet.next()) {
		budgetstatus[1] = RecordSet.getString("budgetstatus");
		revision[1] = RecordSet.getString("revision");
		status[1] = RecordSet.getString("status");
	}
} else {
    canView = false;
}

//取当前期间的年份
if("".equals(budgetyears)) {
	sqlstr = " select fnayear from FnaYearsPeriods where id = " + budgetperiods;
	RecordSet.executeSql(sqlstr);
	if(RecordSet.next()) {
		budgetyears = RecordSet.getString("fnayear");
	}
}

//检查权限
    int right = -1;//-1：禁止、0：只读、1：编辑、2：完全操作
    if ("0".equals(organizationtype)) {
        if (HrmUserVarify.checkUserRight("HeadBudget:Maint", user)) right = Util.getIntValue(HrmUserVarify.getRightLevel("HeadBudget:Maint", user),0);
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

    if (right < 0) canView = false;//可查看

    if ("2".equals(status)) canLinkTypeView = false;//历史版本不能链接进入科目预算显示

    if ("3".equals(organizationtype)) {
        canLinkTypeView = false;//人员预算无科目链接
    }

    if (!canView) {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(18553,user.getLanguage());
String needfav ="1";
String needhelp ="";

double tmpnum = 0d;
double tmpnum1 = 0d;
double tmpnum2 = 0d;
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<style>
#tabPane tr td{padding-top:2px}
#monthHtmlTbl td,#seasonHtmlTbl td{cursor:hand;text-align:center;padding:0 2px 0 2px;color:#333;text-decoration:underline}
.cycleTD{font-family:MS Shell Dlg,Arial;background-image:url(/images/tab2.png);cursor:hand;font-weight:bold;text-align:center;color:#666;border-bottom:1px solid #879293;}
.cycleTDCurrent{font-family:MS Shell Dlg,Arial;padding-top:2px;background-image:url(/images/tab.active2.png);cursor:hand;font-weight:bold;text-align:center;color:#666}
.seasonTDCurrent,.monthTDCurrent{color:black;font-weight:bold;background-color:#CCC}
#subTab{border-bottom:1px solid #879293;padding:0}
#goalGroupStatus{text-align:center;color:black;font-weight: bold}
</style>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<FORM id="frmMain" name="frmMain" action="FnaBudgetView.jsp" method=post>
<INPUT name="fnabudgetinfoid" type="hidden" value="<%=backfnabudgetinfoid%>">

<!--表头 开始-->

<TABLE class ="ViewForm">
	<TBODY>
	<colgroup>
    <col width="16%">
    <col width="*">
    <TR>
	    <TH class=Title colspan=2>
	    <%
	    String fnatitle = "<font size=\"3\">";
	    if("0".equals(organizationtype))
		fnatitle+=(Util.toScreen(CompanyComInfo.getCompanyname(organizationid),user.getLanguage()));
	    if("1".equals(organizationtype)) fnatitle+=(Util.toScreen(SubCompanyComInfo.getSubCompanyname(organizationid),user.getLanguage()));
	    if("2".equals(organizationtype)) fnatitle+=(Util.toScreen(DepartmentComInfo.getDepartmentname(organizationid),user.getLanguage()));
	    if("3".equals(organizationtype)) fnatitle+=(Util.toScreen(ResourceComInfo.getResourcename(organizationid),user.getLanguage()));
		fnatitle+=budgetyears;
		fnatitle+=SystemEnv.getHtmlLabelName(15375,user.getLanguage());
	    fnatitle+="</font><font color=Green>(";
            fnatitle+=SystemEnv.getHtmlLabelName(18553,user.getLanguage());
	    fnatitle+=")</font>";
	    out.println(fnatitle);
	    %>
		</TH>
  	</TR>
  	
    <TR class=Spacing> 
      <TD class=Sep1 colSpan=2></TD>
    </TR>
    
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(16455,user.getLanguage())%></td>
      <td class=Field>
      <%
	    if("0".equals(organizationtype))
	    out.print(Util.toScreen(CompanyComInfo.getCompanyname(organizationid),user.getLanguage())
	    +"<b>("+SystemEnv.getHtmlLabelName(140,user.getLanguage())+")</b>");
	    if("1".equals(organizationtype))
		out.print(Util.toScreen(SubCompanyComInfo.getSubCompanyname(organizationid),user.getLanguage())
	    +"<b>("+SystemEnv.getHtmlLabelName(141,user.getLanguage())+")</b>");
	    if("2".equals(organizationtype))
		out.print(Util.toScreen(DepartmentComInfo.getDepartmentname(organizationid),user.getLanguage())
	    +"<b>("+SystemEnv.getHtmlLabelName(124,user.getLanguage())+")</b>");
	    if("3".equals(organizationtype))
		out.print(Util.toScreen(ResourceComInfo.getResourcename(organizationid),user.getLanguage())
	    +"<b>("+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+")</b>");
      %>
      </td>
    </tr>
    
	<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    
    <tr>
		<td><%=SystemEnv.getHtmlLabelName(15365,user.getLanguage())%></td>
		<td class=Field><%=budgetyears%>
		</td>
    </tr>
    
	<TR style="height:1px"><TD class=Line colSpan=5></TD></TR>
    
    <tr>
		<td><%if(!"0".equals(revision[0])){%><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%><%=revision[0]//版本%><%}else{%><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%><%}%>
                <%=SystemEnv.getHtmlLabelName(18501,user.getLanguage())%></td>
		<td class=Field>
		<% // Todo 版本1预算总额
		tmpnum1 = FnaBudgetInfoComInfo.getBudgetAmount(fnabudgetinfoid[0]);
		%>
                <%=FnaBudgetInfoComInfo.getStrFromDouble(tmpnum1)%>
		</td>
    </tr>
    
 	<TR style="height:1px"><TD class=Line colSpan=5></TD></TR>
    
    <tr>
		<td><%if(!"0".equals(revision[1])){%><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%><%=revision[1]//版本%><%}else{%><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%><%}%>
                <%=SystemEnv.getHtmlLabelName(18501,user.getLanguage())%></td>
		<td class=Field>
		<% // Todo 版本2预算额
		tmpnum2 = FnaBudgetInfoComInfo.getBudgetAmount(fnabudgetinfoid[1]);
		%>
		<%=FnaBudgetInfoComInfo.getStrFromDouble(tmpnum2)%>
		</td>
    </tr>
    
    
 	<TR style="height:1px"><TD class=Line colSpan=5></TD></TR>

    <tr>
		<td><%=SystemEnv.getHtmlLabelName(18571,user.getLanguage())%></td>
		<td class=Field>
		<% // Todo 预算增额
		tmpnum = tmpnum1 - tmpnum2;
		%>
		<font color="<%=(tmpnum>=0?"GREEN":"RED")%>"><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpnum)%></font>
		</td>
    </tr>
    
 	<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
 	<TR><TD colSpan=5 height=2></TD></TR>
    
    </TBODY> 
  </TABLE>

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
	<td class="cycleTD" onclick="setGoal(this,monthbudgetlisttable);"><%=SystemEnv.getHtmlLabelName(15370,user.getLanguage())%></td>
	<td class="cycleTD" onclick="setGoal(this,quarterbudgetlisttable);"><%=SystemEnv.getHtmlLabelName(15373,user.getLanguage())%></td>
	<td class="cycleTD" onclick="setGoal(this,halfyearbudgetlisttable);"><%=SystemEnv.getHtmlLabelName(15374,user.getLanguage())%></td>
	<td class="cycleTD" onclick="setGoal(this,yearbudgetlisttable);"><%=SystemEnv.getHtmlLabelName(15375,user.getLanguage())%></td>
	<td id="subTab" style="text-align:right;">&nbsp;</td>
</tr>
</table>

<table width=100% style="border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding:10px;padding-right:0">
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
  <th><%=SystemEnv.getHtmlLabelName(18424,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18425,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18426,user.getLanguage())%></th>
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

  </THEAD>
<%
	boolean isFirest = false;
	boolean isSecond = false;
	boolean isThird = false;
	
	//取得月度一级科目
    RecordSet.executeSql(" select id,name from FnaBudgetfeeType where feeperiod = 1 and feelevel = 1 order by name");
	while(RecordSet.next()) {
        String firestlevelid = Util.null2String(RecordSet.getString("id")) ;
        String firestlevelname = Util.toScreen(RecordSet.getString("name"),user.getLanguage()) ;
        isFirest = true;
        
        //取得该一级科目下的二级科目
	    RecordSet2.executeSql(" select id,name from FnaBudgetfeeType where feelevel = 2 and supsubject = " + firestlevelid);
		while(RecordSet2.next()) {
	        String secondlevelid = Util.null2String(RecordSet2.getString("id")) ;
	        String secondlevelname = Util.toScreen(RecordSet2.getString("name"),user.getLanguage()) ;
	        isSecond = true;
        
	        //取得该二级科目下的三级科目
		    RecordSet3.executeSql(" select a.id,a.name from FnaBudgetfeeType"
		    +" a,FnaBudgetInfoDetail b where "
		    +" a.id = b.budgettypeid and b.budgetperiods =" + budgetperiods
		    +" and b.budgetinfoid in (" + fnabudgetinfoid[0] + "," + fnabudgetinfoid[1] + ")"
		    +" and a.feelevel = 3 and a.supsubject = " + secondlevelid
		    +" group by a.id,a.name,b.budgettypeid,b.budgetperiods "
		    );
			while(RecordSet3.next()) {
		        String thirdlevelid = Util.null2String(RecordSet3.getString("id"));
		        String thirdlevelname = Util.toScreen(RecordSet3.getString("name"),user.getLanguage());
		        isThird = !isThird;
%>
	<TR>
<%
				if(isFirest) {
					isFirest = false;
%>
        <TD bgcolor="#EFEFEF" rowspan="<%=RecordSet3.getCounts()*RecordSet2.getCounts()%>"><%=firestlevelname%></TD>
<%
				}
				if(isSecond) {
					isSecond = false;
%>
        <TD bgcolor="#EFEFEF" rowspan="<%=RecordSet3.getCounts()%>"><%=secondlevelname%></TD>
<%
				}
%>        
        <TD bgcolor="#EFEFEF"><%if(canLinkTypeView){%><a href="FnaBudgetTypeView.jsp?fnabudgetinfoid=<%=fnabudgetinfoid%>&fnabudgettypeid=<%=thirdlevelid%>"><%}%><%=thirdlevelname%><%if(canLinkTypeView){%></a><%}%></TD>
        <TD>
        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
        	<tr height=20 class=datadark><td nowrap><%if(!"0".equals(revision[0])){%><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%><%=revision[0]//版本%><%}else{%><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%><%}%></td></tr>
                <tr height=20 class=datalight><td nowrap><%if(!"0".equals(revision[1])){%><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%><%=revision[1]//版本%><%}else{%><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%><%}%></td></tr>
        	<tr height=20 class=datadark><td nowrap><%=SystemEnv.getHtmlLabelName(18571,user.getLanguage())//增额%></td></tr>
        	</table>
        </TD>
<%				
				double tmpSum=0d,tmpSum1=0d,tmpSum2=0d,tmpSum3=0d;
				
				for(int j=1;j<13;j++){
					tmpnum = 0d;tmpnum1 = 0d;tmpnum2=0d;
%>
		<TD>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr height=20 class=datadark><td nowrap align=right>
<%					
					tmpnum1 = FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid[0],(new Integer(j)).toString(),thirdlevelid);
					tmpSum1 += tmpnum1;
					out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum1));
%>
				</td></tr>
				<tr height=20 class=datalight><td nowrap align=right>
<%					
					tmpnum2 = FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid[1],(new Integer(j)).toString(),thirdlevelid);
					tmpSum2 += tmpnum2;
					out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum2));
%>
				</td></tr>
				<tr height=20 class=datadark><td nowrap align=right>
<%					
					tmpnum = tmpnum1 - tmpnum2;
					tmpSum3 += tmpnum;
					out.print("<font color=\""+(tmpnum>=0?"GREEN":"RED")+"\">");
                                        out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum));
                                        out.print("</font>");
%>
				</td></tr>
			</table>
		</TD>
<%
				}
%>
		<TD>
        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	        	<tr height=20 class=datadark><td nowrap align=right><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpSum1)%></td></tr>
	        	<tr height=20 class=datalight><td nowrap align=right><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpSum2)%></td></tr>
	        	<tr height=20 class=datadark><td nowrap align=right><font color="<%=(tmpSum3>=0?"GREEN":"RED")%>"><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpSum3)%></font></td></tr>
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
  <th><%=SystemEnv.getHtmlLabelName(18424,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18425,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18426,user.getLanguage())%></th>
  <th>&nbsp;</th>
  <th>1<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>2<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>3<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>4<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>        
  </tr>
 
  </THEAD>
<%
	isFirest = false;
	isSecond = false;
	isThird = false;

	//取得季度一级科目
    RecordSet.executeSql(" select id,name from FnaBudgetfeeType where feeperiod = 2 and feelevel = 1 order by name");
	while(RecordSet.next()) {
        String firestlevelid = Util.null2String(RecordSet.getString("id")) ;
        String firestlevelname = Util.toScreen(RecordSet.getString("name"),user.getLanguage()) ;
        isFirest = true;
        
        //取得该一级科目下的二级科目
	    RecordSet2.executeSql(" select id,name from FnaBudgetfeeType where feelevel = 2 and supsubject = " + firestlevelid);
		while(RecordSet2.next()) {
	        String secondlevelid = Util.null2String(RecordSet2.getString("id")) ;
	        String secondlevelname = Util.toScreen(RecordSet2.getString("name"),user.getLanguage()) ;
	        isSecond = true;
        
	        //取得该二级科目下的三级科目
		    RecordSet3.executeSql(" select a.id,a.name from FnaBudgetfeeType"
		    +" a,FnaBudgetInfoDetail b where "
		    +" a.id = b.budgettypeid and b.budgetperiods =" + budgetperiods
		    +" and b.budgetinfoid in (" + fnabudgetinfoid[0] + "," + fnabudgetinfoid[1] + ")"
		    +" and a.feelevel = 3 and a.supsubject = " + secondlevelid
		    +" group by a.id,a.name,b.budgettypeid,b.budgetperiods "
		    );
			while(RecordSet3.next()) {
		        String thirdlevelid = Util.null2String(RecordSet3.getString("id"));
		        String thirdlevelname = Util.toScreen(RecordSet3.getString("name"),user.getLanguage());
		        isThird = !isThird;
%>
	<TR>
<%
				if(isFirest) {
					isFirest = false;
%>
        <TD bgcolor="#EFEFEF" rowspan="<%=RecordSet3.getCounts()*RecordSet2.getCounts()%>"><%=firestlevelname%></TD>
<%
				}
				if(isSecond) {
					isSecond = false;
%>
        <TD bgcolor="#EFEFEF" rowspan="<%=RecordSet3.getCounts()%>"><%=secondlevelname%></TD>
<%
				}
%>        
        <TD bgcolor="#EFEFEF"><%if(canLinkTypeView){%><a href="FnaBudgetTypeView.jsp?fnabudgetinfoid=<%=fnabudgetinfoid%>&fnabudgettypeid=<%=thirdlevelid%>"><%}%><%=thirdlevelname%><%if(canLinkTypeView){%></a><%}%></TD>
        <TD>
        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
        	<tr height=20 class=datadark><td nowrap><%if(!"0".equals(revision[0])){%><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%><%=revision[0]//版本%><%}else{%><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%><%}%></td></tr>
        	<tr height=20 class=datalight><td nowrap><%if(!"0".equals(revision[1])){%><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%><%=revision[1]//版本%><%}else{%><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%><%}%></td></tr>
        	<tr height=20 class=datadark><td nowrap><%=SystemEnv.getHtmlLabelName(18571,user.getLanguage())//增额%></td></tr>
        	</table>
        </TD>
<%				
				double tmpSum=0d,tmpSum1=0d,tmpSum2=0d,tmpSum3=0d;
				
				for(int j=1;j<5;j++){
					tmpnum = 0d;tmpnum1 = 0d;tmpnum2=0d;
%>
		<TD>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr height=20 class=datadark><td nowrap align=right>
<%					
					tmpnum1 = FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid[0],(new Integer(j)).toString(),thirdlevelid);
					tmpSum1 += tmpnum1;
					out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum1));
%>
				</td></tr>
				<tr height=20 class=datalight><td nowrap align=right>
<%					
					tmpnum2 = FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid[1],(new Integer(j)).toString(),thirdlevelid);
					tmpSum2 += tmpnum2;
					out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum2));
%>
				</td></tr>
				<tr height=20 class=datadark><td nowrap align=right>
<%					
					tmpnum = tmpnum1 - tmpnum2;
					tmpSum3 += tmpnum;
					out.print("<font color=\""+(tmpnum>=0?"GREEN":"RED")+"\">");
                                        out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum));
                                        out.print("</font>");
%>
				</td></tr>
			</table>
		</TD>
<%
				}
%>
		<TD>
        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	        	<tr height=20 class=datadark><td nowrap align=right><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpSum1)%></td></tr>
	        	<tr height=20 class=datalight><td nowrap align=right><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpSum2)%></td></tr>
	        	<tr height=20 class=datadark><td nowrap align=right><font color="<%=(tmpSum3>=0?"GREEN":"RED")%>"><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpSum3)%></font></td></tr>
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
  <th><%=SystemEnv.getHtmlLabelName(18424,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18425,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18426,user.getLanguage())%></th>
  <th>&nbsp;</th>
  <th>1<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th>2<%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>        
  </tr>

  </THEAD>
<%
	isFirest = false;
	isSecond = false;
	isThird = false;

	//取得月度一级科目
    RecordSet.executeSql(" select id,name from FnaBudgetfeeType where feeperiod = 3 and feelevel = 1 order by name");
	while(RecordSet.next()) {
        String firestlevelid = Util.null2String(RecordSet.getString("id")) ;
        String firestlevelname = Util.toScreen(RecordSet.getString("name"),user.getLanguage()) ;
        isFirest = true;
        
        //取得该一级科目下的二级科目
	    RecordSet2.executeSql(" select id,name from FnaBudgetfeeType where feelevel = 2 and supsubject = " + firestlevelid);
		while(RecordSet2.next()) {
	        String secondlevelid = Util.null2String(RecordSet2.getString("id")) ;
	        String secondlevelname = Util.toScreen(RecordSet2.getString("name"),user.getLanguage()) ;
	        isSecond = true;
        
	        //取得该二级科目下的三级科目
		    RecordSet3.executeSql(" select a.id,a.name from FnaBudgetfeeType"
		    +" a,FnaBudgetInfoDetail b where "
		    +" a.id = b.budgettypeid and b.budgetperiods =" + budgetperiods
		    +" and b.budgetinfoid in (" + fnabudgetinfoid[0] + "," + fnabudgetinfoid[1] + ")"
		    +" and a.feelevel = 3 and a.supsubject = " + secondlevelid
		    +" group by a.id,a.name,b.budgettypeid,b.budgetperiods "
		    );
			while(RecordSet3.next()) {
		        String thirdlevelid = Util.null2String(RecordSet3.getString("id"));
		        String thirdlevelname = Util.toScreen(RecordSet3.getString("name"),user.getLanguage());
		        isThird = !isThird;
%>
	<TR>
<%
				if(isFirest) {
					isFirest = false;
%>
        <TD bgcolor="#EFEFEF" rowspan="<%=RecordSet3.getCounts()*RecordSet2.getCounts()%>"><%=firestlevelname%></TD>
<%
				}
				if(isSecond) {
					isSecond = false;
%>
        <TD bgcolor="#EFEFEF" rowspan="<%=RecordSet3.getCounts()%>"><%=secondlevelname%></TD>
<%
				}
%>        
        <TD bgcolor="#EFEFEF"><%if(canLinkTypeView){%><a href="FnaBudgetTypeView.jsp?fnabudgetinfoid=<%=fnabudgetinfoid%>&fnabudgettypeid=<%=thirdlevelid%>"><%}%><%=thirdlevelname%><%if(canLinkTypeView){%></a><%}%></TD>
        <TD>
        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
        	<tr height=20 class=datadark><td nowrap><%if(!"0".equals(revision[0])){%><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%><%=revision[0]//版本%><%}else{%><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%><%}%></td></tr>
        	<tr height=20 class=datalight><td nowrap><%if(!"0".equals(revision[1])){%><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%><%=revision[1]//版本%><%}else{%><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%><%}%></td></tr>
        	<tr height=20 class=datadark><td nowrap><%=SystemEnv.getHtmlLabelName(18571,user.getLanguage())//增额%></td></tr>
        	</table>
        </TD>
<%				
				double tmpSum=0d,tmpSum1=0d,tmpSum2=0d,tmpSum3=0d;
				
				for(int j=1;j<3;j++){
					tmpnum = 0d;tmpnum1 = 0d;tmpnum2=0d;
%>
		<TD>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr height=20 class=datadark><td nowrap align=right>
<%					
					tmpnum1 = FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid[0],(new Integer(j)).toString(),thirdlevelid);
					tmpSum1 += tmpnum1;
					out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum1));
%>
				</td></tr>
				<tr height=20 class=datalight><td nowrap align=right>
<%					
					tmpnum2 = FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid[1],(new Integer(j)).toString(),thirdlevelid);
					tmpSum2 += tmpnum2;
					out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum2));
%>
				</td></tr>
				<tr height=20 class=datadark><td nowrap align=right>
<%					
					tmpnum = tmpnum1 - tmpnum2;
					tmpSum3 += tmpnum;
					out.print("<font color=\""+(tmpnum>=0?"GREEN":"RED")+"\">");
                                        out.print(FnaBudgetInfoComInfo.getStrFromDouble(tmpnum));
                                        out.print("</font>");
%>
				</td></tr>
			</table>
		</TD>
<%
				}
%>
		<TD>
        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	        	<tr height=20 class=datadark><td nowrap align=right><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpSum1)%></td></tr>
	        	<tr height=20 class=datalight><td nowrap align=right><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpSum2)%></td></tr>
	        	<tr height=20 class=datadark><td nowrap align=right><font color="<%=(tmpSum3>=0?"GREEN":"RED")%>"><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpSum3)%></font></td></tr>
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
  <th><%=SystemEnv.getHtmlLabelName(18424,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18425,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(18426,user.getLanguage())%></th>
  <th>&nbsp;</th>
  <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>        
  </tr>

  </THEAD>
<%
	isFirest = false;
	isSecond = false;
	isThird = false;

	//取得月度一级科目
    RecordSet.executeSql(" select id,name from FnaBudgetfeeType where feeperiod = 4 and feelevel = 1 order by name");
	while(RecordSet.next()) {
        String firestlevelid = Util.null2String(RecordSet.getString("id")) ;
        String firestlevelname = Util.toScreen(RecordSet.getString("name"),user.getLanguage()) ;
        isFirest = true;
        
        //取得该一级科目下的二级科目
	    RecordSet2.executeSql(" select id,name from FnaBudgetfeeType where feelevel = 2 and supsubject = " + firestlevelid);
		while(RecordSet2.next()) {
	        String secondlevelid = Util.null2String(RecordSet2.getString("id")) ;
	        String secondlevelname = Util.toScreen(RecordSet2.getString("name"),user.getLanguage()) ;
	        isSecond = true;
        
	        //取得该二级科目下的三级科目
		    RecordSet3.executeSql(" select a.id,a.name from FnaBudgetfeeType"
		    +" a,FnaBudgetInfoDetail b where "
		    +" a.id = b.budgettypeid and b.budgetperiods =" + budgetperiods
		    +" and b.budgetinfoid in (" + fnabudgetinfoid[0] + "," + fnabudgetinfoid[1] + ")"
		    +" and a.feelevel = 3 and a.supsubject = " + secondlevelid
		    +" group by a.id,a.name,b.budgettypeid,b.budgetperiods "
		    );
			while(RecordSet3.next()) {
		        String thirdlevelid = Util.null2String(RecordSet3.getString("id"));
		        String thirdlevelname = Util.toScreen(RecordSet3.getString("name"),user.getLanguage());
		        isThird = !isThird;
%>
	<TR>
<%
				if(isFirest) {
					isFirest = false;
%>
        <TD bgcolor="#EFEFEF" rowspan="<%=RecordSet3.getCounts()*RecordSet2.getCounts()%>"><%=firestlevelname%></TD>
<%
				}
				if(isSecond) {
					isSecond = false;
%>
        <TD bgcolor="#EFEFEF" rowspan="<%=RecordSet3.getCounts()%>"><%=secondlevelname%></TD>
<%
				}
%>        
        <TD bgcolor="#EFEFEF"><%if(canLinkTypeView){%><a href="FnaBudgetTypeView.jsp?fnabudgetinfoid=<%=fnabudgetinfoid%>&fnabudgettypeid=<%=thirdlevelid%>"><%}%><%=thirdlevelname%><%if(canLinkTypeView){%></a><%}%></TD>
        <TD>
        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
        	<tr height=20 class=datadark><td nowrap><%if(!"0".equals(revision[0])){%><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%><%=revision[0]//版本%><%}else{%><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%><%}%></td></tr>
        	<tr height=20 class=datalight><td nowrap><%if(!"0".equals(revision[1])){%><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%><%=revision[1]//版本%><%}else{%><%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%><%}%></td></tr>
        	<tr height=20 class=datadark><td nowrap><%=SystemEnv.getHtmlLabelName(18571,user.getLanguage())//增额%></td></tr>
        	</table>
        </TD>
<%				
				double tmpSum=0d,tmpSum1=0d,tmpSum2=0d,tmpSum3=0d;
				
				for(int j=1;j<=1;j++){
					tmpnum = 0d;tmpnum1 = 0d;tmpnum2=0d;

                                        tmpnum1 = FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid[0],(new Integer(j)).toString(),thirdlevelid);
					tmpSum1 += tmpnum1;

                                        tmpnum2 = FnaBudgetInfoComInfo.getBudgetTypeAmount(fnabudgetinfoid[1],(new Integer(j)).toString(),thirdlevelid);
					tmpSum2 += tmpnum2;

                                        tmpnum = tmpnum1 - tmpnum2;
					tmpSum3 += tmpnum;
				}
%>
		<TD>
        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	        	<tr height=20 class=datadark><td nowrap align=right><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpSum1)%></td></tr>
	        	<tr height=20 class=datalight><td nowrap align=right><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpSum2)%></td></tr>
	        	<tr height=20 class=datadark><td nowrap align=right><font color="<%=(tmpSum3>=0?"GREEN":"RED")%>"><%=FnaBudgetInfoComInfo.getStrFromDouble(tmpSum3)%></font></td></tr>
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

function setGoal(o,b){
	document.getElementById("tabPane").rows[0].cells[0].className = "cycleTD";
	document.getElementById("tabPane").rows[0].cells[1].className = "cycleTD";
	document.getElementById("tabPane").rows[0].cells[2].className = "cycleTD";
	document.getElementById("tabPane").rows[0].cells[3].className = "cycleTD";
	document.getElementById("yearbudgetlisttable").style.display="none";
	document.getElementById("halfyearbudgetlisttable").style.display="none";
	document.getElementById("quarterbudgetlisttable").style.display="none";
	document.getElementById("monthbudgetlisttable").style.display="none";
	o.className = "cycleTDCurrent";
	b.style.display="block";
}    
function onBack(){
    location.href="<%=(request.getHeader("referer").indexOf("FnaBudgetHistoryView")==-1?"FnaBudgetView.jsp":"FnaBudgetHistoryView.jsp")%>?fnabudgetinfoid=<%=backfnabudgetinfoid%>";
    //document.frmMain.action="<%=(request.getHeader("referer").indexOf("FnaBudgetHistoryView")==-1?"FnaBudgetView.jsp":"FnaBudgetHistoryView.jsp")%>";
    //document.frmMain.submit();
}
</script>



</BODY>
</HTML>