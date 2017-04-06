<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String resourceid = Util.null2String(request.getParameter("resourceid"));
String fnayear = Util.null2String(request.getParameter("fnayear"));
String departmentid = Util.null2String(ResourceComInfo.getDepartmentID(resourceid)) ;

//added by lupeng 2004.2.3
    //if the user is himself                                                 ok
    //if the resourceid is the user's follower                  ok
    //if the user have the right of viewing budget          ok
    boolean isManager = false;
    String managerStr = "";
    RecordSet.executeSql(" select managerstr from hrmresource where id = " + resourceid ) ;
    if ( RecordSet.next() ) managerStr = Util.null2String(RecordSet.getString(1)) ;
    if (managerStr.indexOf(String.valueOf(user.getUID())) != -1)
        isManager = true;

    boolean isSameDept = false;
    RecordSet.executeSql(" select departmentid from hrmresource where id = " + resourceid ) ;
    if ( RecordSet.next() && (user.getUserDepartment() == RecordSet.getInt(1)) )
        isSameDept = true;

    if (String.valueOf(user.getUID()).equals(resourceid)) {
        //it's ok.
    } else if (isManager) {
        //it's ok.
    } else if (HrmUserVarify.checkUserRight("FnaBudget:All" , user) && isSameDept) {
        //it's ok.
    } else {
        response.sendRedirect("/notice/noright.jsp") ;
	    return ;
    }
//end

String budgetinfoid = "" ;
String budgetstatus = "" ;
String sqlstr = "" ;

if(fnayear.equals("")) {
	//RecordSet.executeProc("FnaYearsPeriods_SelectMaxYear","");
	//if(RecordSet.next()) fnayear = RecordSet.getString("fnayear") ;
	//else {
		Calendar today = Calendar.getInstance();
		fnayear = Util.add0(today.get(Calendar.YEAR), 4) ;
	//}
}


if( budgetinfoid.equals("") ) {
   // sqlstr =" select id , budgetstatus from FnaBudgetInfo where  budgetyears= '"+ fnayear + "'  and budgetdepartmentid = "+ departmentid ;

	sqlstr="select id , budgetstatus from FnaBudgetInfo where budgetperiods = (select id from FnaYearsPeriods where fnayear= '" + fnayear + "')";
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
    //added by lupeng 2004.2.11
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
    String ystypesqlstr = "select a.id,b.budgettypeid from  FnaBudgetInfo a,FnaBudgetInfoDetail b where a.id = b.budgetinfoid and a.budgetorganizationid = "+resourceid;		  
    RecordSet.execute(ystypesqlstr);    
    String typefeeid = "";
    if(RecordSet.next()){
    	 typefeeid = Util.null2String(RecordSet.getString(2));
    }

    String yssqlstr = "select supsubject from FnaBudgetfeeType where id = (select supsubject from FnaBudgetfeeType where id ="+typefeeid+ ")";
    RecordSet.executeSql(yssqlstr); 
    String tempbudgetperiods = "";
    if(RecordSet.next()){
     tempbudgetperiods = Util.null2String(RecordSet.getString(1));
    }

    sqlstr =" select a.budgetperiodslist,sum(a.budgetaccount) budgetaccount,b.id"+
              " from FnaBudgetInfoDetail a,FnaBudgetInfo b"+
			  " where b.budgetorganizationid =" + resourceid + " and a.budgetinfoid = b.id"+ 
		      " and a.budgetperiods = (select id from FnaYearsPeriods where fnayear= '" + fnayear + "')"+ 
			  " group by a.budgetperiodslist,b.id";
    RecordSet.executeSql(sqlstr);
    while(RecordSet.next()){
        String tempbudgettypeid = Util.null2String(RecordSet.getString(1)) ;
        String tempaccount = "" + Util.getDoubleValue(RecordSet.getString(2),0) ;

        if(tempaccount.equals("0")) continue ;

        budgettypeperiods.add(tempbudgettypeid + "_" + tempbudgetperiods ) ;
        budgetaccounts.add( tempaccount ) ;
    }
}

sqlstr =" select feetypeid , amount , occurdate from FnaAccountLog where occurdate >= '"+ fnayearstartdate + "' and occurdate <= '"+ fnayearenddate +"' and resourceid = " + resourceid ;
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(2121,user.getLanguage())+",javascript:submitBudget(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/fna/report/expense/FnaExpenseResource.jsp,_self} " ;
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
<FORM class=inputstyle id=frmMain name=frmMain action=FnaExpenseResourceDetail.jsp method=post>
<input class=inputstyle type=hidden name="operation" value="approve">
<input class=inputstyle id=resourceid type=hidden name=resourceid value="<%=resourceid%>">
<input class=inputstyle id=departmentid type=hidden name=resourceid value="<%=departmentid%>">
<input class=inputstyle id=budgetstatus type=hidden name=budgetstatus value="<%=budgetstatus%>">
<input class=inputstyle id=budgetinfoid type=hidden name=budgetinfoid value="<%=budgetinfoid%>">

 <TABLE class=viewForm>
    <COLGROUP> <COL width="15%"></COL> <COL width="40%"></COL><COL width="5%"></COL>
    <COL width="15%"></COL> <COL width="25%"></COL> <THEAD>
    <TR class=Title>
    <TH colspan="2">
      <P align=left><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>: <%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></P>
    </TH>
    <TH colSpan=3 style="TEXT-ALIGN: right"><nobr>
    <%=SystemEnv.getHtmlLabelName(15427,user.getLanguage())%>: <% if( budgetstatus.equals("1") ) {%><%=SystemEnv.getHtmlLabelName(1423,user.getLanguage())%><%} else if( budgetstatus.equals("0") ) { %><%=SystemEnv.getHtmlLabelName(1422,user.getLanguage())%><%}%>
    </TH>
  </TR>
    </THEAD> <TBODY>

    <tr>
      <td><%=SystemEnv.getHtmlLabelName(15365,user.getLanguage())%></td>
      <td class=Field colSpan=4>
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
    </TBODY>
  </TABLE>
</FORM>
<br>
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
  <TR class=Header>
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
  <TR class=Header>
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

<form name="detail" action=FnaExpenseTypeResourceDetail.jsp method=post>
  <input id=feetypeid type=hidden name=feetypeid >
  <input id=fnayear type=hidden name=fnayear value="<%=fnayear%>">
  <input id=resourceid type=hidden name=resourceid value="<%=resourceid%>">
  <input id=departmentid type=hidden name=resourceid value="<%=departmentid%>">
  <input id=budgetstatus type=hidden name=budgetstatus value="<%=budgetstatus%>">
  <input id=budgetinfoid type=hidden name=budgetinfoid value="<%=budgetinfoid%>">
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