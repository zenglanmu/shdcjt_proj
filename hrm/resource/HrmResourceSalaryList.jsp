<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
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
if(id.equals("")) id=String.valueOf(user.getUID());
Calendar thedate = Calendar.getInstance ();
String yearmonth = Util.add0(thedate.get(thedate.YEAR), 4) +"-"+Util.add0(thedate.get(thedate.MONTH) + 1, 2) ;
 int hrmid = user.getUID();
 int isView = Util.getIntValue(request.getParameter("isView"));
 int departmentid = user.getUserDepartment();
 boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
 boolean ishe = (hrmid == Util.getIntValue(id));
 boolean ishr = (HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user,departmentid));
 if(!ishe&&!ishr ){
    response.sendRedirect("/notice/noright.jsp") ;
    return;
}
%>
<HEAD>
  <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(19576,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
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

<FORM name=resourcefinanceinfo id=resource action="HrmResourceOperation.jsp" method=post enctype="multipart/form-data">
<%if(HrmListValidate.isValidate(6)){%>
<% if(ishe||ishr){ // 薪酬调整信息, 工资信息本人和人力资源管理员,本人的所有经理看到 %>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP><COL width="100%">
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(19576,user.getLanguage())%></TH>
  </TR>
  </TABLE>
<TABLE class=ListStyle cellspacing=1 >
  <TBODY>
  <tr class=Header>
  <TH rowspan=2 style="TEXT-ALIGN:center;TEXT-VALIGN:middle"><nobr><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TH>
   <%
    boolean isLight = false;
    ArrayList itemlist=new ArrayList();
    ArrayList paydatelist=new ArrayList();
    ArrayList payidlist=new ArrayList();
	String sql="select a.id,a.paydate,b.itemid,b.salary from HrmSalaryPay a,HrmSalaryPaydetail b,hrmsalaryitem c where a.id=b.payid and REPLACE(REPLACE(b.itemid,'_1',''),'_2','')=convert(varchar,c.id) and c.isshow='1' and b.sent=1 and b.hrmid = " + id +" order by a.paydate desc,c.showorder,b.itemid";
    if("oracle".equalsIgnoreCase(rs.getDBType())){
        sql="select a.id,a.paydate,b.itemid,b.salary from HrmSalaryPay a,HrmSalaryPaydetail b,hrmsalaryitem c where a.id=b.payid and to_number(REPLACE(REPLACE(b.itemid,'_1',''),'_2',''))=c.id and c.isshow='1' and b.sent=1 and b.hrmid = " + id +" order by a.paydate desc,c.showorder,b.itemid";
    }
    rs.executeSql(sql);
    while( rs.next() ) {
        String payid = rs.getString("id") ;
        String paydate = rs.getString("paydate") ;
        String tmpitemid = rs.getString("itemid") ;
        if(paydatelist.indexOf(paydate)<0){
            paydatelist.add(paydate);
            payidlist.add(payid);
        }
        if(itemlist.indexOf(tmpitemid)==-1){
            itemlist.add(tmpitemid);
        }
    } 
	sql="select a.id,a.paydate,b.itemid,b.salary from HrmSalaryPay a,HrmSalaryPaydetail b where a.id=b.payid and b.sent=1 and b.hrmid = " + id +" and REPLACE(REPLACE(b.itemid,'_1',''),'_2','') not in(select convert(varchar,id) from hrmsalaryitem) order by a.paydate desc,b.itemid";
    if("oracle".equalsIgnoreCase(rs.getDBType())){
        sql="select a.id,a.paydate,b.itemid,b.salary from HrmSalaryPay a,HrmSalaryPaydetail b where a.id=b.payid and b.sent=1 and b.hrmid = " + id +" and to_number(REPLACE(REPLACE(b.itemid,'_1',''),'_2','')) not in(select id from hrmsalaryitem) order by a.paydate desc,b.itemid";
    }  
    rs1.executeSql(sql);
    while( rs1.next() ) {
        String payid = rs1.getString("id") ;
        String paydate = rs1.getString("paydate") ;
        String tmpitemid = rs1.getString("itemid") ;
        if(paydatelist.indexOf(paydate)<0){
            paydatelist.add(paydate);
            payidlist.add(payid);
        }
        if(itemlist.indexOf(tmpitemid)==-1){
            itemlist.add(tmpitemid);
        }
    }
    if(itemlist.size()<1){
        itemlist=SalaryComInfo.getSubCompanySalary(Util.getIntValue(DepartmentComInfo.getSubcompanyid1(ResourceComInfo.getDepartmentID(id))));
    }
    int itemnums=itemlist.size();
    ArrayList[] itemsalarylist=new ArrayList[itemnums];
    for(int i=0;i<itemnums;i++){
        itemsalarylist[i]=new ArrayList();
        for(int j=0;j<paydatelist.size();j++){
            itemsalarylist[i].add(j,"");
        }
    }
    rs.beforFirst();
    while( rs.next() ) {
        String paydate = rs.getString("paydate") ;
        String tmpitemid = rs.getString("itemid") ;
        String salary = rs.getString("salary") ;
        int paydateindx=paydatelist.indexOf(paydate);
        if(paydateindx>-1){
        if(itemlist.indexOf(tmpitemid)>-1){
            itemsalarylist[itemlist.indexOf(tmpitemid)].set(paydateindx,salary);
        }
        }
    }
	rs1.beforFirst();
    while( rs1.next() ) {
        String paydate = rs1.getString("paydate") ;
        String tmpitemid = rs1.getString("itemid") ;
        String salary = rs1.getString("salary") ;
        int paydateindx=paydatelist.indexOf(paydate);
        if(paydateindx>-1){
        if(itemlist.indexOf(tmpitemid)>-1){
            itemsalarylist[itemlist.indexOf(tmpitemid)].set(paydateindx,salary);
        }
        }
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
    for(int i=0;i<paydatelist.size();i++){
        isLight = !isLight ;
  %>
  <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
  <td><nobr><%=paydatelist.get(i)%></td>
  <%
        for(int j=0;j<itemlist.size();j++){
            String itemid = (String)itemlist.get(j) ;
            String titles="";
            boolean iscaltype=false;
            String salary =(String)itemsalarylist[j].get(i);
            if(itemid.indexOf("_")<0){
                if(SalaryComInfo.getSalaryItemtype(itemid).equals("4")){
                    iscaltype=true;
                }
            }else{
                iscaltype=true;
            }
            if(iscaltype){
                titles=SalaryComInfo.getTitles(Util.getIntValue(id),itemid,Util.getIntValue((String)payidlist.get(i)),user.getLanguage(),(String)paydatelist.get(i));
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
function goBack(){
      location = "/hrm/resource/HrmResourceFinanceView.jsp?isfromtab=<%=isfromtab%>&id=<%=id%>&isView=<%=isView%>";
  }
</script>
</BODY>
</HTML>