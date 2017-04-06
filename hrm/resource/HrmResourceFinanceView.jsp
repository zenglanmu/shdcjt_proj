<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BankComInfo" class="weaver.hrm.finance.BankComInfo" scope= "page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page" />
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<HTML>
<%
//added by hubo,20060113
 String id = Util.null2String(request.getParameter("id"));
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
if(id.equals("")) id=String.valueOf(user.getUID());
Calendar thedate = Calendar.getInstance ();
String yearmonth = Util.add0(thedate.get(thedate.YEAR), 4) +"-"+Util.add0(thedate.get(thedate.MONTH) + 1, 2) ;
 int hrmid = user.getUID();
 int isView = Util.getIntValue(request.getParameter("isView"));
 int departmentid = user.getUserDepartment();

 boolean ism = ResourceComInfo.isManager(hrmid,id);
 boolean iss = ResourceComInfo.isSysInfoView(hrmid,id);
 boolean isf = ResourceComInfo.isFinInfoView(hrmid,id);
 boolean isc = ResourceComInfo.isCapInfoView(hrmid,id);
 //boolean iscre = ResourceComInfo.isCreaterOfResource(hrmid,id);
 boolean ishe = (hrmid == Util.getIntValue(id));
 boolean ishr = (HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user,departmentid));
 if(!ishe&&!ishr ){
    response.sendRedirect("/notice/noright.jsp") ;
    return;
}
 String sqlstatus = "select status from HrmResource where id = "+id;
rs.executeSql(sqlstatus);
rs.next();
int status = rs.getInt("status");
%>
<HEAD>
  <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(189,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
String needfav ="1";
String needhelp ="";


int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel=0;
if(detachable==1){
    String deptid=ResourceComInfo.getDepartmentID(id);
    String subcompanyid=DepartmentComInfo.getSubcompanyid1(deptid)  ;
	if(subcompanyid == null || subcompanyid.equals("")){
		subcompanyid = "0";
	}
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceEdit:Edit",Integer.parseInt(subcompanyid));
}else{
    if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user))
        operatelevel=2;
}
%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(isf&& status!= 10&&operatelevel>0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:edit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(ishe||ishr){
RCMenu += "{"+SystemEnv.getHtmlLabelName(19599,user.getLanguage())+",javascript:onChangLog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(19576,user.getLanguage())+",javascript:onHistory(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(!isfromtab){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:viewBasicInfo(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<%if(!isfromtab){ %>
<TABLE class=Shadow>
<%}else{ %>
<TABLE width='100%'>
<%} %>
<tr>
<td valign="top">

<FORM name=resourcefinanceinfo id=resource action="HrmResourceOperation.jsp" method=post enctype="multipart/form-data">
<% if(ishe||ishr ){ // 财务信息只能本人和人力资源管理员看到 %>
<TABLE class=viewForm>
  <COLGROUP>
    <COL width=20%>
    <COL width=80%>
  <TBODY>
  <TR class=title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15805,user.getLanguage())%></TH>
  </TR>
  <TR class=spacing style="height:2px">
    <TD class=line1 colSpan=2></TD>
  </TR>

<%
  String sql = "";
  sql = "select * from HrmResource where id = "+id;
  rs.executeSql(sql);
  while(rs.next()){
    String bankid1 = Util.null2String(rs.getString("bankid1"));
    String accountid1 = Util.null2String(rs.getString("accountid1"));
    String accumfundaccount = Util.null2String(rs.getString("accumfundaccount"));
%>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(15812,user.getLanguage())%></TD>
    <TD class=Field>
      <%=BankComInfo.getBankname(bankid1)%>
    </TD>
  </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(16016,user.getLanguage())%></TD>
    <TD class=Field>
      <%=accountid1%>
    </TD>
  </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(16085,user.getLanguage())%></TD>
    <TD class=Field>
      <%=accumfundaccount%>
    </TD>
  </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
<%  }%>
  </tbody>
</table>
<%}%>

<%if(HrmListValidate.isValidate(6)){%>
<% if(ishe||ishr){ // 薪酬调整信息, 工资信息本人和人力资源管理员,本人的所有经理看到 %>
<br>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP><COL width="100%">
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(503,user.getLanguage())%></TH>
  </TR>
  </TABLE>
<TABLE class=ListStyle cellspacing=1 >
  <TBODY>
  <tr class=Header>
  <TH rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TH>
   <%
    boolean isLight = false;
    ArrayList itemlist=new ArrayList();
    ArrayList salaryitems = new ArrayList() ;
    ArrayList salarys = new ArrayList() ;
    int payid=0;
	String sql="select a.id,b.itemid ,b.salary from HrmSalaryPay a,HrmSalaryPaydetail b,hrmsalaryitem c where a.id=b.payid and REPLACE(REPLACE(b.itemid,'_1',''),'_2','')=convert(varchar,c.id) and c.isshow='1' and b.sent=1 and a.paydate='"+yearmonth+"' and b.hrmid = " + id +" order by c.showorder,b.itemid";
	if("oracle".equalsIgnoreCase(rs.getDBType())){
        sql="select a.id,b.itemid ,b.salary from HrmSalaryPay a,HrmSalaryPaydetail b,hrmsalaryitem c where a.id=b.payid and to_number(REPLACE(REPLACE(b.itemid,'_1',''),'_2',''))=c.id and c.isshow='1' and b.sent=1 and a.paydate='"+yearmonth+"' and b.hrmid = " + id +" order by c.showorder,b.itemid";
    }  
    rs.executeSql(sql);
    while( rs.next() ) {
        if(payid==0) payid=rs.getInt("id");
        String itemid = rs.getString("itemid") ;
        String salary = rs.getString("salary") ;
        if(salaryitems.indexOf(itemid)<0){
            salaryitems.add(itemid) ;
            salarys.add(salary) ;
        }
    }
	sql="select a.id,b.itemid ,b.salary from HrmSalaryPay a,HrmSalaryPaydetail b where a.id=b.payid and b.sent=1 and a.paydate='"+yearmonth+"'and b.hrmid = " + id +" and REPLACE(REPLACE(b.itemid,'_1',''),'_2','') not in(select convert(varchar,id) from hrmsalaryitem) order by b.itemid";
    if("oracle".equalsIgnoreCase(rs.getDBType())){
        sql="select a.id,b.itemid ,b.salary from HrmSalaryPay a,HrmSalaryPaydetail b where a.id=b.payid and b.sent=1 and a.paydate='"+yearmonth+"'and b.hrmid = " + id +" and to_number(REPLACE(REPLACE(b.itemid,'_1',''),'_2','')) not in(select id from hrmsalaryitem) order by b.itemid";
    }
    rs.executeSql(sql);
    while( rs.next() ) {
        if(payid==0) payid=rs.getInt("id");
        String itemid = rs.getString("itemid") ;
        String salary = rs.getString("salary") ;
        if(salaryitems.indexOf(itemid)<0){
            salaryitems.add(itemid) ;
            salarys.add(salary) ;
        }
    }
    if(salaryitems.size()<1){
        itemlist=SalaryComInfo.getSubCompanySalary(Util.getIntValue(DepartmentComInfo.getSubcompanyid1(ResourceComInfo.getDepartmentID(id))));
    }else{
        itemlist=salaryitems;
    }
    for(int i=0;i<itemlist.size();i++) {
        String itemid=(String)itemlist.get(i);
        if(itemid.indexOf("_")>-1) itemid=itemid.substring(0,itemid.indexOf("_"));
        String itemname = SalaryComInfo.getSalaryname(itemid);
        String itemtype = SalaryComInfo.getSalaryItemtype(itemid);
        if( !itemtype.equals("9") ) {
   %>
   <TH  rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr><%=itemname%></TH>
   <%   } else { i++;%>
   <TH colspan=2 style="TEXT-ALIGN:center"><nobr><%=itemname%></TH>
   <%   }
    }
   %>
  </tr>
  <tr class=Header>
   <%
    for(int i=0;i<itemlist.size();i++) {
        String itemid=(String)itemlist.get(i);
        if(itemid.indexOf("_")>-1) itemid=itemid.substring(0,itemid.indexOf("_"));
        String itemtype = SalaryComInfo.getSalaryItemtype(itemid);
        if( !itemtype.equals("9") ) continue ;
        i++;
   %>
   <TH  style="TEXT-ALIGN:center"><nobr><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></TH>
   <TH  style="TEXT-ALIGN:center"><nobr><%=SystemEnv.getHtmlLabelName(1851,user.getLanguage())%></TH>
   <%
    }
   %>
   </tr>
   
   <%
    if(salaryitems.size()>0){
        isLight = !isLight ;
  %>
  <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
  <td><nobr><%=yearmonth%></td>
  <%
        for(int j=0;j<itemlist.size();j++){
            String itemid = (String)itemlist.get(j) ;
            String titles="";
            boolean iscaltype=false;

            int salaryindex=salaryitems.indexOf(itemid);
            String salary = "0.00" ;
            if(salaryindex>-1){
                salary=(String)salarys.get(salaryindex);
            }
            if(itemid.indexOf("_")<0){
                if(SalaryComInfo.getSalaryItemtype(itemid).equals("4")){
                    iscaltype=true;
                }
            }else{
                iscaltype=true;
            }
            if(iscaltype){
                titles=SalaryComInfo.getTitles(Util.getIntValue(id),itemid,payid,user.getLanguage(),yearmonth);
            }
   %>
       <td title="<%=titles%>" <%if(!titles.equals("")){%>style="cursor:hand"<%}%>><nobr><%=salary%></td>
<%
        }
   %>
   </tr>
   <%
    }
   %>
  </TBODY>
 </TABLE>
<%}%>
<%}%>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>

<script language=javascript>
  function edit(){
    location = "/hrm/resource/HrmResourceFinanceEdit.jsp?isfromtab=<%=isfromtab%>&id=<%=id%>&isView=<%=isView%>";
  }
  function viewBasicInfo(){
    if(<%=isView%> == 0){
      location = "/hrm/employee/EmployeeManage.jsp?hrmid=<%=id%>";
    }else{
      location = "/hrm/resource/HrmResource.jsp?id=<%=id%>";
    }
  }
  function onChangLog(){
    location = "/hrm/resource/HrmResourceChangeLog.jsp?isfromtab=<%=isfromtab%>&id=<%=id%>&isView=<%=isView%>";
  }
  function onHistory(){
    location = "/hrm/resource/HrmResourceSalaryList.jsp?isfromtab=<%=isfromtab%>&id=<%=id%>&isView=<%=isView%>";
  }
  function viewPersonalInfo(){
    location = "/hrm/resource/HrmResourcePersonalView.jsp?id=<%=id%>&isView=<%=isView%>";
  }
  function viewWorkInfo(){
    location = "/hrm/resource/HrmResourceWorkView.jsp?id=<%=id%>&isView=<%=isView%>";
  }
  function viewSystemInfo(){
    location = "/hrm/resource/HrmResourceSystemView.jsp?id=<%=id%>&isView=<%=isView%>";
  }
  function viewCapitalInfo(){
    location = "/cpt/search/CptMyCapital.jsp?id=<%=id%>";
  }
</script>
</BODY>
</HTML>