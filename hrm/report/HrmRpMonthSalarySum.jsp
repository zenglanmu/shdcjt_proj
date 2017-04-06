<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.text.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BankComInfo" class="weaver.hrm.finance.BankComInfo" scope= "page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page" />
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>

<HTML>
<%
DecimalFormat format = new DecimalFormat("0.00");
String userid =""+user.getUID();
/*权限判断,人力资产管理员以及其所有上级*/
boolean canView = false;
ArrayList allCanView = new ArrayList();
String tempsql = "select resourceid from HrmRoleMembers where roleid = 4 ";
rs.executeSql(tempsql);
while(rs.next()){
	String tempid = rs.getString("resourceid");
	allCanView.add(tempid);
	AllManagers.getAll(tempid);
	while(AllManagers.next()){
		allCanView.add(AllManagers.getManagerID());
	}
}// end while
for (int i=0;i<allCanView.size();i++){
	if(userid.equals((String)allCanView.get(i))){
		canView = true;
	}
}
if(!canView) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限判断结束*/

    String startdatefrom = Util.null2String(request.getParameter("startdatefrom"));
    String startdateto = Util.null2String(request.getParameter("startdateto"));

    String sqlwhere = "";
    if(!startdatefrom.equals("")){
        sqlwhere += " and t2.paydate >='" + startdatefrom +"' ";
    }
    if(!startdateto.equals("")){
        if(rs.getDBType().equals("oracle")){
            sqlwhere += " and (t2.paydate is not null and t2.paydate <='" + startdateto +"') ";
        }else{
            sqlwhere += " and (t2.paydate<>'' and t2.paydate <='" + startdateto +"') ";
        }
    }

%>
<HEAD>
  <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(17536,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17537,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
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

<form name=frmmain method=post action="HrmRpMonthSalarySum.jsp">

   <table class=ViewForm>
  <colgroup>
    <col width=10%>
    <col width=90%>
  <tbody>
  <tr>
    <td class=field><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></td>
    <td class=field colspan=3>
       <BUTTON class=Calendar type=button id=selectstartdatefrom onclick="getSdDate(startdatefromspan,startdatefrom)"></BUTTON>
       <SPAN id=startdatefromspan ><%=startdatefrom%></SPAN> -
       <BUTTON class=Calendar type=button id=selectstartdateto onclick="getSdDate(startdatetospan,startdateto)"></BUTTON>
       <SPAN id=startdatetospan ><%=startdateto%></SPAN>
       <input class=inputStyle type="hidden" name="startdatefrom" value="<%=startdatefrom%>">
       <input class=inputStyle type="hidden" name="startdateto" value="<%=startdateto%>">
    </td>
  </tr>
  <TR style="height:2px" ><TD class=Line colSpan=2></TD></TR>

  </tbody>
  </table>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP><COL width="100%">
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(17537,user.getLanguage())%></TH>
  </TR>
  </TABLE>
<TABLE class=ListStyle cellspacing=1 >
  <TBODY>
  <tr class=Header>
  <TH width="10%" rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TH>
   <%
    while(SalaryComInfo.next()) {
        String itemname = Util.toScreen(SalaryComInfo.getSalaryname(),user.getLanguage()) ;
        String itemtype = Util.null2String(SalaryComInfo.getSalaryItemtype()) ;
        if( !itemtype.equals("2") ) {
   %>
   <TH width="10%" rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr><%=itemname%></TH>
   <%   } else { %>
   <TH colspan=2 style="TEXT-ALIGN:center"><nobr><%=itemname%></TH>
   <%   }
    }
   %>
  </tr>
  <tr class=Header>
   <%
    SalaryComInfo.setTofirstRow() ;
    while(SalaryComInfo.next()) {
        String itemtype = Util.null2String(SalaryComInfo.getSalaryItemtype()) ;
        if( !itemtype.equals("2") ) continue ;
   %>
   <TH width="5%" style="TEXT-ALIGN:center"><nobr><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></TH>
   <TH width="5%" style="TEXT-ALIGN:center"><nobr><%=SystemEnv.getHtmlLabelName(1851,user.getLanguage())%></TH>
   <%
    }
   %>
   </tr>
   <%
    ArrayList resourceitems = new ArrayList() ;
    ArrayList salarys = new ArrayList() ;

    String sql = "SELECT t1.payid, t1.itemid, SUM(salary) AS allsalary " +
            "FROM HrmSalaryPaydetail t1, HrmSalaryPay t2 " +
            "WHERE t1.payid = t2.id " +
            "GROUP BY t1.payid, t1.itemid ";
    rs.executeSql(sql);
    while( rs.next() ) {
        String payid = Util.null2String( rs.getString("payid") ) ;
        String itemid = Util.null2String( rs.getString("itemid") ) ;
        String salary = "" + Util.getDoubleValue( rs.getString("allsalary") , 0 ) ;
        resourceitems.add( payid + "_" + itemid ) ;
        salarys.add( salary ) ;
    }

       sql =  " select distinct t2.id , t2.paydate from HrmSalaryPay t2, HrmSalaryPaydetail t1 "
                 + " where t2.id = t1.payid " + sqlwhere
                 + " order by paydate ";
       rs.executeSql(sql);
       boolean isLight = false;

       ArrayList colSumList = new ArrayList();
       boolean isBegin = true;
       int curColIndex = 0;
       double temD1 = 0.0;

    while( rs.next() ) {
        String payid = Util.null2String( rs.getString("id") ) ;
        String paydate = Util.null2String( rs.getString("paydate") ) ;
        isLight = !isLight ;
  %>
  <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
  <td><nobr><%=paydate%></td>
  <%
        SalaryComInfo.setTofirstRow() ;
        curColIndex = 0;
        while(SalaryComInfo.next()) {
            String itemid = Util.null2String(SalaryComInfo.getSalaryItemid()) ;
            String itemtype = Util.null2String(SalaryComInfo.getSalaryItemtype()) ;
            String salary = "" ;
            String personsalary = "" ;
            String companysalary = "" ;
            String salaryview = "" ;
            String personsalaryview = "" ;
            String companysalaryview = "" ;
			
            if( !itemtype.equals("2") ) {
                int salaryindex = resourceitems.indexOf( payid + "_" + itemid ) ;
                if( salaryindex != -1) {
                    salary = (String) salarys.get(salaryindex) ;
                    if(!salary.equals("0") ){
                    	salaryview = format.format(Double.parseDouble(salary));
                    }else{
                    	salaryview = "" ;
                    }
                }
                if(isBegin){
                    colSumList.add(new Double(salary+"0"));
                }else{
                    colSumList.set(curColIndex,new Double(((Double)(colSumList.get(curColIndex))).doubleValue() + Double.parseDouble(salary+"0")));
                    curColIndex ++;
                }
   %>
       <td><nobr><%=salaryview%></td>
<%           } else {
                int salaryindex = resourceitems.indexOf( payid + "_" + itemid+"_1" ) ;
                if( salaryindex != -1) {
                    personsalary = (String) salarys.get(salaryindex) ;
                    if( !personsalary.equals("0") ){
                    	personsalaryview = format.format(Double.parseDouble(personsalary));
                    }else{
                     	personsalaryview = "" ;
                    }
                }
                salaryindex = resourceitems.indexOf( payid + "_" + itemid+"_2" ) ;
                if( salaryindex != -1) {
                    companysalary = (String) salarys.get(salaryindex) ;
                    if(!companysalary.equals("0") ){
                    	companysalaryview = format.format(Double.parseDouble(companysalary));
                    }else{
                    	companysalaryview = "";
                    }
                }
                if(isBegin){
                    colSumList.add(new Double(personsalary+"0"));
                    colSumList.add(new Double(companysalary+"0"));
                }else{
                    colSumList.set(curColIndex, new Double(((Double)(colSumList.get(curColIndex))).doubleValue() + Double.parseDouble(personsalary+"0")));
                    curColIndex ++;
                    colSumList.set(curColIndex, new Double(((Double)(colSumList.get(curColIndex))).doubleValue() + Double.parseDouble(companysalary+"0")));
                    curColIndex ++;
                }

   %>
       <td><nobr><%=personsalaryview%></td>
       <td><nobr><%=companysalaryview%></td>
<%           }
        }
        if(isBegin){
            isBegin = false;
        }
   %>
   </tr>
   <%
    }
   %>
<tr class=Header>
  <TH width="10%" rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr>合计</TH>
   <%
        curColIndex = 0;
        String viewName = "";
    while(SalaryComInfo.next()) {
        String itemtype = Util.null2String(SalaryComInfo.getSalaryItemtype()) ;
        if(colSumList != null && colSumList.size()>0){
            temD1 = ((Double)colSumList.get(curColIndex++)).doubleValue()*100.0/100;
        }else{
            temD1 = 0;
        }
        if(temD1 != 0){
            viewName = format.format(temD1);
        }else{
            viewName = "";
        }
        if( !itemtype.equals("2") ) {
   %>
   <TH width="10%"><nobr><%=viewName%></TH>
   <%   } else {  %>
   <TH ><nobr><%=viewName%></TH>
   <%
            if(colSumList != null && colSumList.size()>0){
                temD1 = ((Double)colSumList.get(curColIndex++)).doubleValue()*100.0/100;
            }else{
                temD1 = 0;
            }
            if(temD1 != 0){
                viewName = format.format(temD1);
            }else{
                viewName = "";
            }

   %>
   <TH ><nobr><%=viewName%></TH>
   <%   }
    }
   %>
  </tr>
  </TBODY>
 </TABLE>
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
function submitData() {
 frmmain.submit();
}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>