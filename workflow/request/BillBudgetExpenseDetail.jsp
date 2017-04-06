<%@ page import="weaver.fna.maintenance.*"%>

<jsp:useBean id="tmpRs" class="weaver.conn.RecordSet" scope="page"/>

<%
    RecordSet.executeSql(" select occurdate from bill_HrmFinance where id = " + billid);
    RecordSet.next();
    String thecurrentdate = Util.null2String(RecordSet.getString(1));

    //if(thecurrentdate.length() < 10 ) return ;
if(thecurrentdate.length()>=10){
    //RecordSet.executeProc("bill_HrmFinance_SelectLoan",""+creater);
    //RecordSet.next();
    //String loanamount = RecordSet.getString(1);
    RecordSet.executeSql("select sum(amount) from fnaloaninfo where organizationtype=3 and organizationid="+creater);
    RecordSet.next();
    double loanamount=Util.getDoubleValue(RecordSet.getString(1),0);

    FnaExpenseManage fem = new FnaExpenseManage(thecurrentdate) ;
    fem.setResourceid ( ""+creater ) ;
    fem.setDepartmentid ( ""+ResourceComInfo.getDepartmentID(""+creater) ) ;
    String budgethasapprove = fem.budgetHasApprove() ;

    ArrayList feetypeids = new ArrayList() ;
    ArrayList feetypenames = new ArrayList() ;
    ArrayList expenseamounts = new ArrayList() ;

    /*commented by lupeng
    RecordSet.executeSql (" select feetypeid , sum(feesum) from Bill_ExpenseDetail where expenseid = " + billid + " group by feetypeid ") ;
    while( RecordSet.next() ) {
        String tempfeetypeid = Util.null2String( RecordSet.getString(1) ) ;
        String tempexpenseamount = Util.null2String( RecordSet.getString(2) ) ;
        feetypeids.add( tempfeetypeid ) ;
        feetypenames.add( Util.toScreen( BudgetfeeTypeComInfo.getBudgetfeeTypename(tempfeetypeid),user.getLanguage() ) ) ;
        expenseamounts.add( tempexpenseamount ) ;
    }
    */
    //added by lupeng 2004.2.20
    RecordSet.executeSql (" select feetypeid , sum(feesum) from Bill_ExpenseDetail where expenseid = " + billid + " group by feetypeid ") ;
    while( RecordSet.next() ) {
        String tempfeetypeid = Util.null2String( RecordSet.getString(1) ) ;
        String tempexpenseamount = Util.null2String( RecordSet.getString(2) ) ;

        String tempAmount = "";
        String tmpSql = "select a.amount from FnaAccountLog a, bill_HrmFinance b where a.releatedid=b.requestid and a.feetypeid=" + tempfeetypeid + " and b.billid="+ billid;
        tmpRs.executeSql(tmpSql);
        if (tmpRs.next())
            tempAmount = Util.null2String(tmpRs.getString(1));

        if (!tempAmount.equals(""))
            tempexpenseamount = "";

        feetypeids.add( tempfeetypeid ) ;
        feetypenames.add( Util.toScreen( BudgetfeeTypeComInfo.getBudgetfeeTypename(tempfeetypeid),user.getLanguage() ) ) ;
        expenseamounts.add( tempexpenseamount ) ;
    }
    //end
%>
<a name='this'></a>
<table  class="viewform">
  <tbody>
  <TR class="Title">
      <TH id='distd'><a href='#this' onclick='dspfna(1);'><%=SystemEnv.getHtmlLabelName(16285,user.getLanguage())%></a></TH>
  </TR>
</table>
<div id='alldetail' style="display:none">
<table  class="viewform" border=1 bordercolor='black'>
  <tbody>
  <TR class="Title">
      <TH><%=SystemEnv.getHtmlLabelName(15805,user.getLanguage())%> (
          <% if( budgethasapprove.equals("1") ) {%><%=SystemEnv.getHtmlLabelName(16286,user.getLanguage())%>
          <% } else if( budgethasapprove.equals("0") ) {%><%=SystemEnv.getHtmlLabelName(16287,user.getLanguage())%>
          <% } else {%><%=SystemEnv.getHtmlLabelName(16288,user.getLanguage())%><%}%> )
      </TH>
  </TR>
  <tr>
    <td>
    <table class="viewform" >
   
      <tr>
      <td width=25%>
      <input type=radio name=operategroup checked value=1 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15687,user.getLanguage())%>
      </td>
      <td width=25%>
      <input type=radio name=operategroup value=2 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(16289,user.getLanguage())%>
      </td><td width=25%>
      <input type=radio name=operategroup value=3 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(16290,user.getLanguage())%>
      </td><td width=25%>
      <input type=radio name=operategroup value=4 onclick="onChangetype(this.value)">CRM<%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%>
      </td>
      </tr>
    </table>

    <div id=odiv_1>
    <table class=liststyle cellspacing=1  >

        <TR class="Spacing" style="height:1px;">
            <TD class="Line1" colSpan=4></TD>
        </TR>
        <tr class=datalight >
            <td><b><%=SystemEnv.getHtmlLabelName(16271,user.getLanguage())%></b></td>
            <td colspan=3><%=loanamount%></td>
        </tr>
        <%

            for( int i=0 ; i< feetypeids.size() ; i++ ) {
                String tempfeetypeid = (String)feetypeids.get(i) ;
                String tempfeetypename = (String)feetypenames.get(i) ;
                double expenseamount = Util.getDoubleValue((String)expenseamounts.get(i),0) ;
                fem.setFeetypeid( tempfeetypeid ) ;
                fem.getResourceInfo() ;

                String currentperiod = fem.getCurrentperiod() ;
                /*commented by lupeng 2004.2.20
                String resourcecurrentbudgetstr = "&nbsp;" ;
                String resourcebeforebudgetstr = "&nbsp;" ;
                String resourceyearbudgetstr = "&nbsp;" ;
                String resourcecurrentexpensestr = "&nbsp;" ;
                String resourcebeforeexpensestr = "&nbsp;" ;
                String resourceyearexpensestr = "&nbsp;" ;
                */

                //added by lupeng2004.2.20
                String resourcecurrentbudgetstr = "0" ;
                String resourcebeforebudgetstr = "0" ;
                String resourceyearbudgetstr = "0" ;
                String resourcecurrentexpensestr = "0" ;
                String resourcebeforeexpensestr = "0" ;
                String resourceyearexpensestr = "0" ;
                //end

                double resourcecurrentbudget = fem.getResourcecurrentbudget() ;
                double resourcebeforebudget = fem.getResourcebeforebudget() ;
                double resourceyearbudget = fem.getResourceyearbudget() ;

                double resourcecurrentexpense = fem.getSumValue(fem.getResourcecurrentexpense(),expenseamount,3) ;
                double resourcebeforeexpense = fem.getSumValue(fem.getResourcebeforeexpense(),expenseamount,3) ;
                double resourceyearexpense = fem.getSumValue(fem.getResourceyearexpense(),expenseamount,3) ;

                if( resourcecurrentbudget != 0 ) resourcecurrentbudgetstr = ""+resourcecurrentbudget ;
                if( resourcebeforebudget != 0 ) resourcebeforebudgetstr = ""+resourcebeforebudget ;
                if( resourceyearbudget != 0 ) resourceyearbudgetstr = ""+resourceyearbudget ;
                if( resourcecurrentexpense != 0) resourcecurrentexpensestr =""+resourcecurrentexpense ;
                if( resourcebeforeexpense != 0 ) resourcebeforeexpensestr = ""+resourcebeforeexpense ;
                if( resourceyearexpense != 0 ) resourceyearexpensestr = ""+resourceyearexpense ;
        %>
        <!--
        <TR class="Title">
    	  <TH colSpan=4></TH>
        </TR>
        -->
        <tr class=header >
            <th class="Title"><%=tempfeetypename%></th>
            <th><%=SystemEnv.getHtmlLabelName(16291,user.getLanguage())%></th>
            <th>1~<%=currentperiod%><%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></td>
            <td><%=resourcecurrentbudgetstr%></td>
            <td><%=resourcebeforebudgetstr%></td>
            <td><%=resourceyearbudgetstr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16292,user.getLanguage())%></td>
            <td><%=resourcecurrentexpensestr%></td>
            <td><%=resourcebeforeexpensestr%></td>
            <td><%=resourceyearexpensestr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16293,user.getLanguage())%></td>
            <td><%if(fem.hasOverSpend(resourcecurrentbudget,resourcecurrentexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(resourcebeforebudget,resourcebeforeexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(resourceyearbudget,resourceyearexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
        </tr>
        <%  }   %>
      </table>
    </div>

    <div id=odiv_2 style="display:none">
    <table class=liststyle cellspacing=1  >
        <TR class="Spacing" style="height:1px;">
            <TD class="Line1" colSpan=4></TD>
        </TR>
        <%

            for( int i=0 ; i< feetypeids.size() ; i++ ) {
                String tempfeetypeid = (String)feetypeids.get(i) ;
                String tempfeetypename = (String)feetypenames.get(i) ;
                double expenseamount = Util.getDoubleValue((String)expenseamounts.get(i),0) ;
                fem.setFeetypeid( tempfeetypeid ) ;
                fem.getDepartmentInfo() ;

                String currentperiod = fem.getCurrentperiod() ;
                /*commented by lupeng 2004.2.20
                String departmentcurrentbudgetstr = "&nbsp;" ;
                String departmentbeforebudgetstr = "&nbsp;" ;
                String departmentyearbudgetstr = "&nbsp;" ;
                String departmentcurrentexpensestr = "&nbsp;" ;
                String departmentbeforeexpensestr = "&nbsp;" ;
                String departmentyearexpensestr = "&nbsp;" ;
                */

                //added by lupeng 2004.2.20
                String departmentcurrentbudgetstr = "0" ;
                String departmentbeforebudgetstr = "0" ;
                String departmentyearbudgetstr = "0" ;
                String departmentcurrentexpensestr = "0" ;
                String departmentbeforeexpensestr = "0" ;
                String departmentyearexpensestr = "0" ;
                //end

                double departmentcurrentbudget = fem.getDepartmentcurrentbudget() ;
                double departmentbeforebudget = fem.getDepartmentbeforebudget() ;
                double departmentyearbudget = fem.getDepartmentyearbudget() ;

                double departmentcurrentexpense = fem.getSumValue(fem.getDepartmentcurrentexpense(),expenseamount,3) ;
                double departmentbeforeexpense = fem.getSumValue(fem.getDepartmentbeforeexpense(),expenseamount,3) ;
                double departmentyearexpense = fem.getSumValue(fem.getDepartmentyearexpense(),expenseamount,3) ;

                if( departmentcurrentbudget != 0 ) departmentcurrentbudgetstr = ""+departmentcurrentbudget ;
                if( departmentbeforebudget != 0 ) departmentbeforebudgetstr = ""+departmentbeforebudget ;
                if( departmentyearbudget != 0 ) departmentyearbudgetstr = ""+departmentyearbudget ;
                if( departmentcurrentexpense != 0) departmentcurrentexpensestr =""+departmentcurrentexpense ;
                if( departmentbeforeexpense != 0 ) departmentbeforeexpensestr = ""+departmentbeforeexpense ;
                if( departmentyearexpense != 0 ) departmentyearexpensestr = ""+departmentyearexpense ;
        %>
        <!--
        <TR class="Title">
    	  <TH colSpan=4></TH>
        </TR>
        -->
        <tr class=header >
            <th class="Title"><%=tempfeetypename%></th>
            <th><%=SystemEnv.getHtmlLabelName(16291,user.getLanguage())%></th>
            <th>1~<%=currentperiod%><%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></td>
            <td><%=departmentcurrentbudgetstr%></td>
            <td><%=departmentbeforebudgetstr%></td>
            <td><%=departmentyearbudgetstr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16292,user.getLanguage())%></td>
            <td><%=departmentcurrentexpensestr%></td>
            <td><%=departmentbeforeexpensestr%></td>
            <td><%=departmentyearexpensestr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16293,user.getLanguage())%></td>
            <td><%if(fem.hasOverSpend(departmentcurrentbudget,departmentcurrentexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(departmentbeforebudget,departmentbeforeexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(departmentyearbudget,departmentyearexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
        </tr>
        <%  }   %>
      </table>
    </div>

    <div id=odiv_3 style="display:none">
      <table class=liststyle cellspacing=1  >
        <COLGROUP>
        <TR class="Spacing" style="height:1px;">
            <TD class="Line1" colSpan=4></TD>
        </TR>
        <%

        String theprojectid = "" ;
        ArrayList projectids = new ArrayList() ;
        expenseamounts.clear() ;

        RecordSet.executeSql (" select relatedproject , sum(feesum) from Bill_ExpenseDetail where expenseid = " + billid + " group by relatedproject ") ;

        while( RecordSet.next() ) {
            String tempprojectid = Util.null2String( RecordSet.getString(1) ) ;
            String tempexpenseamount = Util.null2String( RecordSet.getString(2) ) ;
            if( tempprojectid.equals("") || tempprojectid.equals("0") ) continue ;
            projectids.add( tempprojectid ) ;
            expenseamounts.add( tempexpenseamount ) ;
        }

        RecordSet.executeSql (" select relatedproject , feetypeid , sum(feesum) from Bill_ExpenseDetail where expenseid = " + billid + " group by relatedproject, feetypeid ") ;
        while( RecordSet.next() ) {
            String tempprojectid = Util.null2String( RecordSet.getString(1) ) ;
            if( tempprojectid.equals("") || tempprojectid.equals("0") ) continue ;

            String tempfeetypeid = Util.null2String( RecordSet.getString(2) ) ;
            String tempfeetypename = Util.toScreen( BudgetfeeTypeComInfo.getBudgetfeeTypename(tempfeetypeid),user.getLanguage() ) ;
            double expenseamount = Util.getDoubleValue( RecordSet.getString(3), 0 ) ;

		    if( !theprojectid.equals( tempprojectid ) ) fem.setProjectid( tempprojectid ) ;

            fem.setFeetypeid( tempfeetypeid ) ;
            fem.getProjectInfo() ;

            String currentperiod = fem.getCurrentperiod() ;
            /*commented by lupeng 2004.2.20
		    String project_res_currentbudgetstr = "&nbsp;" ;
		    String project_dep_currentbudgetstr = "&nbsp;" ;
		    String project_all_currentbudgetstr = "&nbsp;" ;
		    String project_res_beforebudgetstr = "&nbsp;" ;
		    String project_dep_beforebudgetstr = "&nbsp;" ;
		    String project_all_beforebudgetstr = "&nbsp;" ;
		    String project_res_yearbudgetstr = "&nbsp;" ;
		    String project_dep_yearbudgetstr = "&nbsp;" ;
		    String project_all_yearbudgetstr = "&nbsp;" ;
		    String projectcountbudgetstr = "&nbsp;" ;

		    String project_res_currentexpensestr = "&nbsp;" ;
		    String project_dep_currentexpensestr = "&nbsp;" ;
		    String project_all_currentexpensestr = "&nbsp;" ;
		    String project_res_beforeexpensestr = "&nbsp;" ;
		    String project_dep_beforeexpensestr = "&nbsp;" ;
		    String project_all_beforeexpensestr = "&nbsp;" ;
		    String project_res_yearexpensestr = "&nbsp;" ;
		    String project_dep_yearexpensestr = "&nbsp;" ;
		    String project_all_yearexpensestr = "&nbsp;" ;
		    String projectcountexpensestr = "&nbsp;" ;
            */

            //added by lupeng 2004.2.20
            String project_res_currentbudgetstr = "0" ;
		    String project_dep_currentbudgetstr = "0" ;
		    String project_all_currentbudgetstr = "0" ;
		    String project_res_beforebudgetstr = "0" ;
		    String project_dep_beforebudgetstr = "0" ;
		    String project_all_beforebudgetstr = "0" ;
		    String project_res_yearbudgetstr = "0" ;
		    String project_dep_yearbudgetstr = "0" ;
		    String project_all_yearbudgetstr = "0" ;
		    String projectcountbudgetstr = "0" ;

		    String project_res_currentexpensestr = "0" ;
		    String project_dep_currentexpensestr = "0" ;
		    String project_all_currentexpensestr = "0" ;
		    String project_res_beforeexpensestr = "0;" ;
		    String project_dep_beforeexpensestr = "0" ;
		    String project_all_beforeexpensestr = "0" ;
		    String project_res_yearexpensestr = "0" ;
		    String project_dep_yearexpensestr = "0" ;
		    String project_all_yearexpensestr = "0" ;
		    String projectcountexpensestr = "0" ;
            //end

            double project_res_currentbudget = fem.getProject_res_currentbudget() ;
            double project_dep_currentbudget = fem.getProject_dep_currentbudget() ;
            double project_all_currentbudget = fem.getProject_all_currentbudget() ;
            double project_res_beforebudget = fem.getProject_res_beforebudget() ;
            double project_dep_beforebudget = fem.getProject_dep_beforebudget() ;
            double project_all_beforebudget = fem.getProject_all_beforebudget() ;
            double project_res_yearbudget = fem.getProject_res_yearbudget() ;
            double project_dep_yearbudget = fem.getProject_dep_yearbudget() ;
            double project_all_yearbudget = fem.getProject_all_yearbudget() ;
            double projectcountbudget = fem.getProjectcountbudget() ;

            double project_res_currentexpense = fem.getSumValue(fem.getProject_res_currentexpense(),expenseamount,3) ;
            double project_dep_currentexpense = fem.getSumValue(fem.getProject_dep_currentexpense(),expenseamount,3) ;
            double project_all_currentexpense = fem.getSumValue(fem.getProject_all_currentexpense(),expenseamount,3) ;
            double project_res_beforeexpense = fem.getSumValue(fem.getProject_res_beforeexpense(),expenseamount,3) ;
            double project_dep_beforeexpense = fem.getSumValue(fem.getProject_dep_beforeexpense(),expenseamount,3) ;
            double project_all_beforeexpense = fem.getSumValue(fem.getProject_all_beforeexpense(),expenseamount,3) ;
            double project_res_yearexpense = fem.getSumValue(fem.getProject_res_yearexpense(),expenseamount,3) ;
            double project_dep_yearexpense = fem.getSumValue(fem.getProject_dep_yearexpense(),expenseamount,3) ;
            double project_all_yearexpense = fem.getSumValue(fem.getProject_all_yearexpense(),expenseamount,3) ;

            if( project_res_currentbudget != 0 ) project_res_currentbudgetstr = "" + project_res_currentbudget ;
            if( project_dep_currentbudget != 0 ) project_dep_currentbudgetstr = "" + project_dep_currentbudget ;
            if( project_all_currentbudget != 0 ) project_all_currentbudgetstr = "" + project_all_currentbudget ;
            if( project_res_beforebudget != 0) project_res_beforebudgetstr ="" + project_res_beforebudget ;
            if( project_dep_beforebudget != 0 ) project_dep_beforebudgetstr = "" + project_dep_beforebudget ;
            if( project_all_beforebudget != 0 ) project_all_beforebudgetstr = "" + project_all_beforebudget ;
            if( project_res_yearbudget != 0 ) project_res_yearbudgetstr = "" + project_res_yearbudget ;
            if( project_dep_yearbudget != 0 ) project_dep_yearbudgetstr = "" + project_dep_yearbudget ;
            if( project_all_yearbudget != 0 ) project_all_yearbudgetstr = "" + project_all_yearbudget ;
            if( projectcountbudget != 0) projectcountbudgetstr ="" + projectcountbudget ;

            if( project_res_currentexpense != 0 ) project_res_currentexpensestr = "" + project_res_currentexpense ;
            if( project_dep_currentexpense != 0 ) project_dep_currentexpensestr = "" + project_dep_currentexpense ;
            if( project_all_currentexpense != 0 ) project_all_currentexpensestr = "" + project_all_currentexpense ;
            if( project_res_beforeexpense != 0) project_res_beforeexpensestr ="" + project_res_beforeexpense ;
            if( project_dep_beforeexpense != 0 ) project_dep_beforeexpensestr = "" + project_dep_beforeexpense ;
            if( project_all_beforeexpense != 0 ) project_all_beforeexpensestr = "" + project_all_beforeexpense ;
            if( project_res_yearexpense != 0 ) project_res_yearexpensestr = "" + project_res_yearexpense ;
            if( project_dep_yearexpense != 0 ) project_dep_yearexpensestr = "" + project_dep_yearexpense ;
            if( project_all_yearexpense != 0 ) project_all_yearexpensestr = "" + project_all_yearexpense ;

            if( !theprojectid.equals( tempprojectid ) ) {
                theprojectid = tempprojectid ;
                int projectindex = projectids.indexOf( theprojectid ) ;
                double tempexpenseamount = Util.getDoubleValue((String)expenseamounts.get( projectindex ), 0 ) ;
                double projectcountexpense = fem.getSumValue(fem.getProjectcountexpense(),tempexpenseamount,3) ;
                if( projectcountexpense != 0) projectcountexpensestr ="" + projectcountexpense ;
        %>
        <TR class="Title">
    	  <TH colSpan=4 height=8></TH>
        </TR>
	    <TR class="Title">
    	  <TH colSpan=4><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%>£º<%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(theprojectid),user.getLanguage())%></TH>
        </TR>
        <tr class=datalight >
            <td><b><%=SystemEnv.getHtmlLabelName(16294,user.getLanguage())%></b></td>
            <td colspan=3><%=projectcountbudgetstr%></td>
        </tr>
        <tr class=datalight >
            <td><b><%=SystemEnv.getHtmlLabelName(16295,user.getLanguage())%></b></td>
            <td colspan=3><%=projectcountexpensestr%></td>
        </tr>
        <%      }   %>
        <!---
        <TR class="Title">

        </TR>
        -->
        <tr class=header >
            <th class="Title"><%=tempfeetypename%></th>
            <th><%=SystemEnv.getHtmlLabelName(16291,user.getLanguage())%></th>
            <th>1~<%=currentperiod%><%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16296,user.getLanguage())%></td>
            <td><%=project_res_currentbudgetstr%></td>
            <td><%=project_res_beforebudgetstr%></td>
            <td><%=project_res_yearbudgetstr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16297,user.getLanguage())%></td>
            <td><%=project_res_currentexpensestr%></td>
            <td><%=project_res_beforeexpensestr%></td>
            <td><%=project_res_yearexpensestr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16293,user.getLanguage())%></td>
            <td><%if(fem.hasOverSpend(project_res_currentbudget,project_res_currentexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(project_res_beforebudget,project_res_beforeexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(project_res_yearbudget,project_res_yearexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16298,user.getLanguage())%></td>
            <td><%=project_dep_currentbudgetstr%></td>
            <td><%=project_dep_beforebudgetstr%></td>
            <td><%=project_dep_yearbudgetstr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16299,user.getLanguage())%></td>
            <td><%=project_dep_currentexpensestr%></td>
            <td><%=project_dep_beforeexpensestr%></td>
            <td><%=project_dep_yearexpensestr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16293,user.getLanguage())%></td>
            <td><%if(fem.hasOverSpend(project_dep_currentbudget,project_dep_currentexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(project_dep_beforebudget,project_dep_beforeexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(project_dep_yearbudget,project_dep_yearexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16300,user.getLanguage())%></td>
            <td><%=project_all_currentbudgetstr%></td>
            <td><%=project_all_beforebudgetstr%></td>
            <td><%=project_all_yearbudgetstr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16301,user.getLanguage())%></td>
            <td><%=project_all_currentexpensestr%></td>
            <td><%=project_all_beforeexpensestr%></td>
            <td><%=project_all_yearexpensestr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16293,user.getLanguage())%></td>
            <td><%if(fem.hasOverSpend(project_all_currentbudget,project_all_currentexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(project_all_beforebudget,project_all_beforeexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(project_all_yearbudget,project_all_yearexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
        </tr>
        <%  }   %>
      </table>
    </div>

    <div id=odiv_4 style="display:none">
      <table class=liststyle cellspacing=1  >
        <COLGROUP>
        <COL width="25%">
        <COL width="25%">
        <COL width="25%">
        <COL width="25%">
        <TR class="Spacing" style="height:1px;">
            <TD class="Line1" colSpan=4></TD>
        </TR>
        <%

        String thecrmid = "" ;
        ArrayList crmids = new ArrayList() ;
        expenseamounts.clear() ;

        RecordSet.executeSql (" select relatedcrm , sum(feesum) from Bill_ExpenseDetail where expenseid = " + billid + " group by relatedcrm ") ;

        while( RecordSet.next() ) {
            String tempcrmid = Util.null2String( RecordSet.getString(1) ) ;
            String tempexpenseamount = Util.null2String( RecordSet.getString(2) ) ;
            if( tempcrmid.equals("") || tempcrmid.equals("0") ) continue ;
            crmids.add( tempcrmid ) ;
            expenseamounts.add( tempexpenseamount ) ;
        }

        RecordSet.executeSql (" select relatedcrm , feetypeid , sum(feesum) from Bill_ExpenseDetail where expenseid = " + billid + " group by relatedcrm, feetypeid ") ;
        while( RecordSet.next() ) {
            String tempcrmid = Util.null2String( RecordSet.getString(1) ) ;
            if( tempcrmid.equals("") || tempcrmid.equals("0") ) continue ;

            String tempfeetypeid = Util.null2String( RecordSet.getString(2) ) ;
            String tempfeetypename = Util.toScreen( BudgetfeeTypeComInfo.getBudgetfeeTypename(tempfeetypeid),user.getLanguage() ) ;
            double expenseamount = Util.getDoubleValue( RecordSet.getString(3), 0 ) ;

		    if( !thecrmid.equals( tempcrmid ) ) fem.setCrmid( tempcrmid ) ;

            fem.setFeetypeid( tempfeetypeid ) ;
            fem.getCrmInfo() ;

            String currentperiod = fem.getCurrentperiod() ;
            /*commented by lupeng 2004.2.20
		    String crm_res_currentbudgetstr = "&nbsp;" ;
		    String crm_dep_currentbudgetstr = "&nbsp;" ;
		    String crm_all_currentbudgetstr = "&nbsp;" ;
		    String crm_res_beforebudgetstr = "&nbsp;" ;
		    String crm_dep_beforebudgetstr = "&nbsp;" ;
		    String crm_all_beforebudgetstr = "&nbsp;" ;
		    String crm_res_yearbudgetstr = "&nbsp;" ;
		    String crm_dep_yearbudgetstr = "&nbsp;" ;
		    String crm_all_yearbudgetstr = "&nbsp;" ;

		    String crm_res_currentexpensestr = "&nbsp;" ;
		    String crm_dep_currentexpensestr = "&nbsp;" ;
		    String crm_all_currentexpensestr = "&nbsp;" ;
		    String crm_res_beforeexpensestr = "&nbsp;" ;
		    String crm_dep_beforeexpensestr = "&nbsp;" ;
		    String crm_all_beforeexpensestr = "&nbsp;" ;
		    String crm_res_yearexpensestr = "&nbsp;" ;
		    String crm_dep_yearexpensestr = "&nbsp;" ;
		    String crm_all_yearexpensestr = "&nbsp;" ;
		    String crmcountexpensestr = "&nbsp;" ;
            */

            //added by lupeng 2004.2.20
            String crm_res_currentbudgetstr = "0" ;
		    String crm_dep_currentbudgetstr = "0" ;
		    String crm_all_currentbudgetstr = "0" ;
		    String crm_res_beforebudgetstr = "0" ;
		    String crm_dep_beforebudgetstr = "0" ;
		    String crm_all_beforebudgetstr = "0" ;
		    String crm_res_yearbudgetstr = "0" ;
		    String crm_dep_yearbudgetstr = "0" ;
		    String crm_all_yearbudgetstr = "0" ;

		    String crm_res_currentexpensestr = "0" ;
		    String crm_dep_currentexpensestr = "0" ;
		    String crm_all_currentexpensestr = "0" ;
		    String crm_res_beforeexpensestr = "0" ;
		    String crm_dep_beforeexpensestr = "0" ;
		    String crm_all_beforeexpensestr = "0" ;
		    String crm_res_yearexpensestr = "0" ;
		    String crm_dep_yearexpensestr = "0" ;
		    String crm_all_yearexpensestr = "0" ;
		    String crmcountexpensestr = "0" ;
            //end

            double crm_res_currentbudget = fem.getCrm_res_currentbudget() ;
            double crm_dep_currentbudget = fem.getCrm_dep_currentbudget() ;
            double crm_all_currentbudget = fem.getCrm_all_currentbudget() ;
            double crm_res_beforebudget = fem.getCrm_res_beforebudget() ;
            double crm_dep_beforebudget = fem.getCrm_dep_beforebudget() ;
            double crm_all_beforebudget = fem.getCrm_all_beforebudget() ;
            double crm_res_yearbudget = fem.getCrm_res_yearbudget() ;
            double crm_dep_yearbudget = fem.getCrm_dep_yearbudget() ;
            double crm_all_yearbudget = fem.getCrm_all_yearbudget() ;

            double crm_res_currentexpense = fem.getSumValue(fem.getCrm_res_currentexpense(),expenseamount,3) ;
            double crm_dep_currentexpense = fem.getSumValue(fem.getCrm_dep_currentexpense(),expenseamount,3) ;
            double crm_all_currentexpense = fem.getSumValue(fem.getCrm_all_currentexpense(),expenseamount,3) ;
            double crm_res_beforeexpense = fem.getSumValue(fem.getCrm_res_beforeexpense(),expenseamount,3) ;
            double crm_dep_beforeexpense = fem.getSumValue(fem.getCrm_dep_beforeexpense(),expenseamount,3) ;
            double crm_all_beforeexpense = fem.getSumValue(fem.getCrm_all_beforeexpense(),expenseamount,3) ;
            double crm_res_yearexpense = fem.getSumValue(fem.getCrm_res_yearexpense(),expenseamount,3) ;
            double crm_dep_yearexpense = fem.getSumValue(fem.getCrm_dep_yearexpense(),expenseamount,3) ;
            double crm_all_yearexpense = fem.getSumValue(fem.getCrm_all_yearexpense(),expenseamount,3) ;


            if( crm_res_currentbudget != 0 ) crm_res_currentbudgetstr = "" + crm_res_currentbudget ;
            if( crm_dep_currentbudget != 0 ) crm_dep_currentbudgetstr = "" + crm_dep_currentbudget ;
            if( crm_all_currentbudget != 0 ) crm_all_currentbudgetstr = "" + crm_all_currentbudget ;
            if( crm_res_beforebudget != 0) crm_res_beforebudgetstr ="" + crm_res_beforebudget ;
            if( crm_dep_beforebudget != 0 ) crm_dep_beforebudgetstr = "" + crm_dep_beforebudget ;
            if( crm_all_beforebudget != 0 ) crm_all_beforebudgetstr = "" + crm_all_beforebudget ;
            if( crm_res_yearbudget != 0 ) crm_res_yearbudgetstr = "" + crm_res_yearbudget ;
            if( crm_dep_yearbudget != 0 ) crm_dep_yearbudgetstr = "" + crm_dep_yearbudget ;
            if( crm_all_yearbudget != 0 ) crm_all_yearbudgetstr = "" + crm_all_yearbudget ;

            if( crm_res_currentexpense != 0 ) crm_res_currentexpensestr = "" + crm_res_currentexpense ;
            if( crm_dep_currentexpense != 0 ) crm_dep_currentexpensestr = "" + crm_dep_currentexpense ;
            if( crm_all_currentexpense != 0 ) crm_all_currentexpensestr = "" + crm_all_currentexpense ;
            if( crm_res_beforeexpense != 0) crm_res_beforeexpensestr ="" + crm_res_beforeexpense ;
            if( crm_dep_beforeexpense != 0 ) crm_dep_beforeexpensestr = "" + crm_dep_beforeexpense ;
            if( crm_all_beforeexpense != 0 ) crm_all_beforeexpensestr = "" + crm_all_beforeexpense ;
            if( crm_res_yearexpense != 0 ) crm_res_yearexpensestr = "" + crm_res_yearexpense ;
            if( crm_dep_yearexpense != 0 ) crm_dep_yearexpensestr = "" + crm_dep_yearexpense ;
            if( crm_all_yearexpense != 0 ) crm_all_yearexpensestr = "" + crm_all_yearexpense ;

            if( !thecrmid.equals( tempcrmid ) ) {
                thecrmid = tempcrmid ;
                int projectindex = crmids.indexOf( thecrmid ) ;
                double tempexpenseamount = Util.getDoubleValue((String)expenseamounts.get( projectindex ), 0 ) ;
                double crmcountexpense = fem.getSumValue(fem.getCrmcountexpense(),tempexpenseamount,3) ;
                if( crmcountexpense != 0) crmcountexpensestr ="" + crmcountexpense ;
        %>
        <TR class="Title">
    	  <TH colSpan=4 height=8></TH>
        </TR>
	    <TR class="Title">
    	  <TH colSpan=4>CRM£º<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(thecrmid),user.getLanguage())%></TH>
        </TR>
        <tr class=datalight >
            <td><b>CRM<%=SystemEnv.getHtmlLabelName(16302,user.getLanguage())%>)</b></td>
            <td colspan=3><%=crmcountexpensestr%></td>
        </tr>
        <%      }   %>
        <!--
        <TR class="Title">
    	  <TH colSpan=4></TH>
        </TR>
        -->
        <tr class=header >
            <th class="Title"><%=tempfeetypename%></th>
            <th><%=SystemEnv.getHtmlLabelName(16291,user.getLanguage())%></th>
            <th>1~<%=currentperiod%><%=SystemEnv.getHtmlLabelName(15372,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(1013,user.getLanguage())%></th>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16303,user.getLanguage())%></td>
            <td><%=crm_res_currentbudgetstr%></td>
            <td><%=crm_res_beforebudgetstr%></td>
            <td><%=crm_res_yearbudgetstr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16304,user.getLanguage())%></td>
            <td><%=crm_res_currentexpensestr%></td>
            <td><%=crm_res_beforeexpensestr%></td>
            <td><%=crm_res_yearexpensestr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16293,user.getLanguage())%></td>
            <td><%if(fem.hasOverSpend(crm_res_currentbudget,crm_res_currentexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(crm_res_beforebudget,crm_res_beforeexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(crm_res_yearbudget,crm_res_yearexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16305,user.getLanguage())%></td>
            <td><%=crm_dep_currentbudgetstr%></td>
            <td><%=crm_dep_beforebudgetstr%></td>
            <td><%=crm_dep_yearbudgetstr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16306,user.getLanguage())%></td>
            <td><%=crm_dep_currentexpensestr%></td>
            <td><%=crm_dep_beforeexpensestr%></td>
            <td><%=crm_dep_yearexpensestr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16293,user.getLanguage())%></td>
            <td><%if(fem.hasOverSpend(crm_dep_currentbudget,crm_dep_currentexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(crm_dep_beforebudget,crm_dep_beforeexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(crm_dep_yearbudget,crm_dep_yearexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16307,user.getLanguage())%></td>
            <td><%=crm_all_currentbudgetstr%></td>
            <td><%=crm_all_beforebudgetstr%></td>
            <td><%=crm_all_yearbudgetstr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16308,user.getLanguage())%></td>
            <td><%=crm_all_currentexpensestr%></td>
            <td><%=crm_all_beforeexpensestr%></td>
            <td><%=crm_all_yearexpensestr%></td>
        </tr>
        <tr class=datalight >
            <td><%=SystemEnv.getHtmlLabelName(16293,user.getLanguage())%></td>
            <td><%if(fem.hasOverSpend(crm_all_currentbudget,crm_all_currentexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(crm_all_beforebudget,crm_all_beforeexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
            <td><%if(fem.hasOverSpend(crm_all_yearbudget,crm_all_yearexpense)) { %><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><% } else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%></td>
        </tr>
        <%  }   %>
      </table>
    </div>

    </td>
  </tr>
  </tbody>
</table>
<br>
</div>

<script type="text/javascript">
function dspfna(objval) {
	if (objval == 1) {
	    $GetEle("alldetail").style.display="";
	    $GetEle("distd").innerHTML = "<a href='#' onclick='dspfna(0);'><%=SystemEnv.getHtmlLabelName(16309,user.getLanguage())%></a>";
	} else {
		$GetEle("alldetail").style.display="none";
		$GetEle("distd").innerHTML = "<a href='#this' onclick='dspfna(1);'><%=SystemEnv.getHtmlLabelName(16285,user.getLanguage())%></a>";
	}
}

function onChangetype(objval) {
	if (objval == 1) {
		$GetEle("odiv_1").style.display="";
		$GetEle("odiv_2").style.display="none";
		$GetEle("odiv_3").style.display="none";
		$GetEle("odiv_4").style.display="none";
	}
	if (objval == 2) {
		$GetEle("odiv_1").style.display="none";
		$GetEle("odiv_2").style.display="";
		$GetEle("odiv_3").style.display="none";
		$GetEle("odiv_4").style.display="none";
	}
	if (objval == 3) {
		$GetEle("odiv_1").style.display="none";
		$GetEle("odiv_2").style.display="none";
		$GetEle("odiv_3").style.display="";
		$GetEle("odiv_4").style.display="none";
	}
	if (objval == 4) {
		$GetEle("odiv_1").style.display="none";
		$GetEle("odiv_2").style.display="none";
		$GetEle("odiv_3").style.display="none";
		$GetEle("odiv_4").style.display="";
	}
}
</script>
<%
}
%>