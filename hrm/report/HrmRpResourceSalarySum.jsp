<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
 <%@ page import="java.math.*,java.text.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BankComInfo" class="weaver.hrm.finance.BankComInfo" scope= "page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page" />
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>

<HTML>
<%

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

    String departmentid = Util.null2String(request.getParameter("departmentid"));   // 部门
    String status = Util.null2String(request.getParameter("status"));       // 人力资源状态

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
    if( !status.equals("9") && !status.equals("") ) {
        if( status.equals("8") )
            sqlwhere+=" and (t4.status = 0 or t4.status = 1 or t4.status = 2 or t4.status = 3) " ;
        else
            sqlwhere+=" and t4.status = " + status ;
    }

%>
<HEAD>
  <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(17536,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17538,user.getLanguage());
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

<form name=frmmain method=post action="HrmRpResourceSalarySum.jsp">

<table class=Viewform>
  <COLGROUP><COL width="10%"><COL width="39%"><COL width="2%"><COL width="10%"><COL width="39%">
      <TBODY>
      <TR>
        <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
        <TD class=field>
		  <input  class=wuiBrowser class=inputstyle id=departmentid type=hidden name=departmentid value="<%=departmentid%>"
		  _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
		  _displayText="<%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%>"
		  >
		  
        </TD>


        <TD>&nbsp;</TD>
        <TD><%=SystemEnv.getHtmlLabelName(15842,user.getLanguage())%></TD>
         <TD class=Field>
          <SELECT class=inputStyle id=status name=status>
           <OPTION value="9" <% if(status.equals("9")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
           <OPTION value="0" <% if(status.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></OPTION>
           <OPTION value="1" <% if(status.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></OPTION>
           <OPTION value="2" <% if(status.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></OPTION>
           <OPTION value="3" <% if(status.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></OPTION>
           <OPTION value="4" <% if(status.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></OPTION>
           <OPTION value="5" <% if(status.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></OPTION>
           <OPTION value="6" <% if(status.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></OPTION>
           <OPTION value="7" <% if(status.equals("7")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></OPTION>
           <OPTION value="8" <% if(status.equals("8")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></OPTION>
         </SELECT>
         </TD>
      </TR>
      <TR style="height:2px"><TD class=Line colSpan=6></TD></TR>
      <TR>
        <td><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></td>
        <td class=field>
           <BUTTON type="button" class=Calendar id=selectstartdatefrom onclick="getSdDate(startdatefromspan,startdatefrom)"></BUTTON>
           <SPAN id=startdatefromspan ><%=startdatefrom%></SPAN> -
           <BUTTON type="button" class=Calendar id=selectstartdateto onclick="getSdDate(startdatetospan,startdateto)"></BUTTON>
           <SPAN id=startdatetospan ><%=startdateto%></SPAN>
           <input class=inputStyle type="hidden" name="startdatefrom" value="<%=startdatefrom%>">
           <input class=inputStyle type="hidden" name="startdateto" value="<%=startdateto%>">
        </td>
        <TD>&nbsp;</TD>

      </TR>
      <TR style="height:2px"><TD class=Line colSpan=6></TD></TR>

     </TBODY>
</table>
<%
	if(!"".equals(startdatefrom)||!"".equals(startdateto)||!"".equals(departmentid)){
%>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP><COL width="100%">
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(17538,user.getLanguage())%></TH>
  </TR>
  </TABLE>
<TABLE class=ListStyle cellspacing=1 >
  <TBODY>
  <tr class=Header>
  <TH width="10%" rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
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
    String depSql = "select id from HrmDepartment ";
    if(!departmentid.equals("")){
        depSql += " where id="+departmentid;
    }
    depSql += " order by id";
    //System.out.println("==================");
    //System.out.println(depSql);
    rs1.executeSql(depSql);

    ArrayList colSumList2 = new ArrayList();
    boolean isBegin2 = true;
    int curColIndex2 = 0;
    double temD2 = 0.0;

    while(rs1.next()){
%>

   <%
    ArrayList resourceitems = new ArrayList() ;
    ArrayList salarys = new ArrayList() ;

    String sql = "SELECT t1.hrmid, t1.itemid, SUM(salary) AS allsalary " +
            "FROM HrmSalaryPaydetail t1, HrmSalaryPay t2, HrmDepartment t3, HrmResource t4 " +
            "WHERE (t4.accounttype is null or t4.accounttype=0) and t1.payid = t2.id and t1.hrmid=t4.id and t4.departmentid=t3.id and t4.departmentid="+rs1.getString("id")+ sqlwhere +
            " GROUP BY t1.hrmid, t1.itemid";
        //System.out.println(sql);
    rs.executeSql(sql);
    while( rs.next() ) {
        String hrmid = Util.null2String( rs.getString("hrmid") ) ;
        String itemid = Util.null2String( rs.getString("itemid") ) ;
        String salary = "" + Util.getDoubleValue( rs.getString("allsalary") , 0 ) ;
        resourceitems.add( hrmid + "_" + itemid ) ;
        salarys.add( salary ) ;
    }

    sql = "SELECT distinct t1.hrmid " +
            "FROM HrmSalaryPaydetail t1, HrmSalaryPay t2, HrmDepartment t3, HrmResource t4 " +
            "WHERE (t4.accounttype is null or t4.accounttype=0) and t1.payid = t2.id and t1.hrmid=t4.id and t4.departmentid=t3.id and t4.departmentid="+rs1.getString("id")+sqlwhere;
        //System.out.println(sql);
       rs.executeSql(sql);
       boolean isLight = false;

       ArrayList colSumList = new ArrayList();
       boolean isBegin = true;
       int curColIndex = 0;
       double temD1 = 0.0;

    while( rs.next() ) {
        String hrmid = Util.null2String( rs.getString("hrmid") ) ;
        isLight = !isLight ;
  %>
  <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
  <td><nobr><%=ResourceComInfo.getResourcename(""+hrmid)%></td>
  <%
        SalaryComInfo.setTofirstRow() ;
        curColIndex = 0;
        while(SalaryComInfo.next()) {
            String itemid = Util.null2String(SalaryComInfo.getSalaryItemid()) ;
            String itemtype = Util.null2String(SalaryComInfo.getSalaryItemtype()) ;
            String salary = "" ;
            String personsalary = "" ;
            String companysalary = "" ;

            if( !itemtype.equals("2") ) {
                int salaryindex = resourceitems.indexOf( hrmid + "_" + itemid ) ;
                if( salaryindex != -1) {
                    salary = (String) salarys.get(salaryindex) ;
                    if( salary.equals("0") ) salary = "" ;
                }
                if(isBegin){
                    colSumList.add(new Double(salary+"0"));
                }else{
                    colSumList.set(curColIndex,new Double(((Double)(colSumList.get(curColIndex))).doubleValue() + Double.parseDouble(salary+"0")));
                    curColIndex ++;
                }
   %>
       <td><nobr><%=salary%></td>
<%           } else {
                int salaryindex = resourceitems.indexOf( hrmid + "_" + itemid+"_1" ) ;
                if( salaryindex != -1) {
                    personsalary = (String) salarys.get(salaryindex) ;
                    if( personsalary.equals("0") ) personsalary = "" ;
                }
                salaryindex = resourceitems.indexOf( hrmid + "_" + itemid+"_2" ) ;
                if( salaryindex != -1) {
                    companysalary = (String) salarys.get(salaryindex) ;
                    if( companysalary.equals("0") ) companysalary = "" ;
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
       <td><nobr><%=personsalary%></td>
       <td><nobr><%=companysalary%></td>
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
  <TH width="10%" style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr><%=DepartmentComInfo.getDepartmentname(rs1.getString("id"))%></TH>
   <%
   		DecimalFormat dFormat = new DecimalFormat("#0.00");
        curColIndex = 0;
        curColIndex2 = 0;
        String viewName = "";
    while(SalaryComInfo.next()) {
        String itemtype = Util.null2String(SalaryComInfo.getSalaryItemtype()) ;
        if(colSumList != null && colSumList.size()>0){
            temD1 = ((Double)colSumList.get(curColIndex++)).doubleValue();
        }else{
            temD1 = 0;
        }

        if(isBegin2){
            colSumList2.add(new Double(temD1+"0"));
        }else{
            colSumList2.set(curColIndex2,new Double(((Double)(colSumList2.get(curColIndex2))).doubleValue() + Double.parseDouble(temD1+"0")));
            curColIndex2 ++;
        }

        if(temD1 != 0){
            //viewName = String.valueOf(temD1);
            viewName = dFormat.format(temD1);
        }else{
            viewName = "";
        }
        if( !itemtype.equals("2") ) {
   %>
   <TH width="10%"><nobr><%=viewName%></TH>
   <%   } else { %>
   <TH ><nobr><%=viewName%></TH>
   <%
            if(colSumList != null && colSumList.size()>0){
                temD1 = ((Double)colSumList.get(curColIndex++)).doubleValue();
            }else{
                temD1 = 0;
            }

            if(isBegin2){
                colSumList2.add(new Double(temD1+"0"));
            }else{
                colSumList2.set(curColIndex2,new Double(((Double)(colSumList2.get(curColIndex2))).doubleValue() + Double.parseDouble(temD1+"0")));
                curColIndex2 ++;
            }

            if(temD1 != 0){
                //viewName = String.valueOf(temD1);
                viewName = dFormat.format(temD1);
            }else{
                viewName = "";
            }

   %>
   <TH ><nobr><%=viewName%></TH>
   <%   }
    }
   %>
  </tr>
   <%
        if(isBegin2){
            isBegin2 = false;
        }
    }
   %>
<tr class=Header>
  <TH width="10%" style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr>总计</TH>
   <%
        DecimalFormat dFormat = new DecimalFormat("#0.00");
        curColIndex2 = 0;
        String viewName = "";
    while(SalaryComInfo.next()) {
        String itemtype = Util.null2String(SalaryComInfo.getSalaryItemtype()) ;
        if(colSumList2 != null && colSumList2.size()>0){
            temD2 = ((Double)colSumList2.get(curColIndex2++)).doubleValue();
        }else{
            temD2 = 0;
        }
        if(temD2 != 0){
          //viewName = String.valueOf(temD2);
            viewName = dFormat.format(temD2);
        }else{
            viewName = "";
        }
        if( !itemtype.equals("2") ) {
   %>
   <TH width="10%"><nobr><%=viewName%></TH>
   <%   } else { %>
   <TH ><nobr><%=viewName%></TH>
   <%
            if(colSumList2 != null && colSumList2.size()>0){
            	temD2 = ((Double)colSumList2.get(curColIndex2++)).doubleValue();
            }else{
                temD2 = 0;
            }
            if(temD2 != 0){
                //viewName = String.valueOf(temD2);
                viewName = dFormat.format(temD2);
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
 <%} %>
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

<script language=vbscript>
sub onShowResource(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
        if id(0)<> "" then
            spanname.innerHtml = id(1)
            inputname.value=id(0)
        else
            spanname.innerHtml = ""
            inputname.value=""
        end if
	end if
end sub

sub onShowDepartment(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&inputname.value)
	if (Not IsEmpty(id)) then
        if id(0)<> 0 then
            spanname.innerHtml = id(1)
            inputname.value=id(0)
        else
            spanname.innerHtml = ""
            inputname.value=""
        end if
	end if
end sub

</script>
<script language=javascript>
function submitData() {
 frmmain.submit();
}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>