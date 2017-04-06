<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="poppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
<%
int isfinish = Util.getIntValue(request.getParameter("isfinish"),-1);

String hrmid=request.getParameter("hrmid");

String Sql=("select lastname from HrmResource where id="+hrmid);
RecordSet.executeSql(Sql);
RecordSet.next();
String name = RecordSet.getString("lastname");
String CurrentUser = ""+user.getUID();
//update popup message table                   //当前用户id
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
RecordSet.executeSql("SELECT id FROM HrmRemindMsg where remindtype=5 and resourceid=" + hrmid);
        while (RecordSet.next()) {
            String remindid = RecordSet.getString("id");
            poppupRemindInfoUtil.updatePoppupRemindInfo(user.getUID(), 8, logintype.equals("1") ? "0" : "1", Util.getIntValue(remindid, 0));
        }
//判断登陆者－－－－//
String sql_10="select hrmid from HrmInfoMaintenance where id =10 ";
RecordSet.executeSql(sql_10);
RecordSet.next();
String hrmid_10= RecordSet.getString("hrmid");
boolean canedit_10=false;
if(CurrentUser.equals(hrmid_10)){
    canedit_10=true;
}
String sql_1="select hrmid from HrmInfoMaintenance where id =1 ";
RecordSet.executeSql(sql_1);
RecordSet.next();
String hrmid_1= RecordSet.getString("hrmid");
boolean canedit_1=false;
if(CurrentUser.equals(hrmid_1)){
    canedit_1=true;
}
String sql_2="select hrmid from HrmInfoMaintenance where id =2 ";
RecordSet.executeSql(sql_2);
RecordSet.next();
String hrmid_2= RecordSet.getString("hrmid");
boolean canedit_2=false;
if(CurrentUser.equals(hrmid_2)){
    canedit_2=true;
}
String sql_3="select hrmid from HrmInfoMaintenance where id =3 ";
RecordSet.executeSql(sql_3);
RecordSet.next();
String hrmid_3= RecordSet.getString("hrmid");
boolean canedit_3=false;
if(CurrentUser.equals(hrmid_3)){
    canedit_3=true;
}
String sql_4="select hrmid from HrmInfoMaintenance where id =4 ";
RecordSet.executeSql(sql_4);
RecordSet.next();
String hrmid_4= RecordSet.getString("hrmid");
boolean canedit_4=false;
if(CurrentUser.equals(hrmid_4)){
    canedit_4=true;
}
String sql_5="select hrmid from HrmInfoMaintenance where id =5 ";
RecordSet.executeSql(sql_5);
RecordSet.next();
String hrmid_5= RecordSet.getString("hrmid");
boolean canedit_5=false;
if(CurrentUser.equals(hrmid_5)){
    canedit_5=true;
}
String sql_6="select hrmid from HrmInfoMaintenance where id =6 ";
RecordSet.executeSql(sql_6);
RecordSet.next();
String hrmid_6= RecordSet.getString("hrmid");
boolean canedit_6=false;
if(CurrentUser.equals(hrmid_6)){
    canedit_6=true;
}
String sql_7="select hrmid from HrmInfoMaintenance where id =7 ";
RecordSet.executeSql(sql_7);
RecordSet.next();
String hrmid_7= RecordSet.getString("hrmid");
boolean canedit_7=false;
if(CurrentUser.equals(hrmid_7)){
    canedit_7=true;
}
String sql_8="select hrmid from HrmInfoMaintenance where id =8 ";
RecordSet.executeSql(sql_8);
RecordSet.next();
String hrmid_8= RecordSet.getString("hrmid");
boolean canedit_8=false;
if(CurrentUser.equals(hrmid_8)){
    canedit_8=true;
}
String sql_9="select hrmid from HrmInfoMaintenance where id =9 ";
RecordSet.executeSql(sql_9);
RecordSet.next();
String hrmid_9= RecordSet.getString("hrmid");
boolean canedit_9=false;
if(CurrentUser.equals(hrmid_9)){
    canedit_9=true;
}
if((HrmUserVarify.checkUserRight("HrmResourceAdd:Add",user))||canedit_1||canedit_2||canedit_3||canedit_4||canedit_5||canedit_6||canedit_7||canedit_8||canedit_9||canedit_10){//权限判断
    		


String sql_check="select status from HrmInfoStatus where itemid=1 and hrmid= "+hrmid;
RecordSet.executeSql(sql_check);
RecordSet.next();
String check=RecordSet.getString("status");
//判断是否已经设了系统帐户，若没有设，其它各项任务都不能进行
/*Modified START : BY Charoes Huang On May 28,2004; For bug 119*/
check = "1"; //不用设置 系统账户，也可设置其他各项信息 BY Charoes Huang For Bug 119
/*Modifed END FOR bug 119*/
//out.print(sql_check);

RecordSet.executeProc("Employee_SelectByHrmid",hrmid);

boolean isfin = ResourceComInfo.isFinish(hrmid); //判断是否已经完成
boolean issup = ResourceComInfo.isSuperviser(user.getUID(),"0");//判断是否为任务监控人员

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdReport.gif";
String titlename =SystemEnv.getHtmlLabelName(2226,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(issup && !isfin){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(555,user.getLanguage())+",javascript:finish(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/employee/EmployeeView.jsp,_self} " ;
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
<%
/*总监误点击完成*/
if(isfinish!=-1){
%>
<!--
<DIV>
<font color=red size=2>
对不起，该员工还有其它项未完成设置！
</font>
</DIV>
-->
<%}%>
<form name=liststatus action="EmployeeOperation.jsp" method=post>
<input type=hidden name=operation>
<input type=hidden name=id value="<%=hrmid%>">
<table class=ViewForm>
  <colgroup>
  <col width="10%">
  <col width="30%">
  <col width="70%">
<TR>
      <TD>姓名</TD>
      <td class=field>
       <%=name%>
      <input type=hidden name=hrmid value="<%=hrmid%>">
       </td>
       <td>&nbsp</td>
</TR>

<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="40%">
  <COL width="60%">
  <TBODY>
  <TR class=Header>
  <th>项目名称</th>
  <th>状态</th>
  </tr>
  <TR class=Line><TD colspan="2" ></TD></TR> 
  <TR>
  <TD>
  </TR>
<%
boolean isLight = false;
	while(RecordSet.next())
	{
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
		<TD>
            <%if((RecordSet.getString("itemid")).equals("1")){
                        if(canedit_10){%>
            <a href="/hrm/resource/HrmResourceSystemView.jsp?id=<%=hrmid%>&isView=0">                    
                     <%}%>
                   <%  if(canedit_1){%>            
            <a href="/hrm/resource/HrmResourceSystemEdit.jsp?id=<%=hrmid%>&isView=0">
                    <%}%>
                系统信息
                <%}%>
            </a>
            <%if((RecordSet.getString("itemid")).equals("2")){
                   if(canedit_10){%>
            <a href="/hrm/resource/HrmResourceFinanceView.jsp?id=<%=hrmid%>&isView=0">                    
                <%}%>        
                   <%  if((check.equals("1"))&&(canedit_2)){%>            
             <a href="/hrm/resource/HrmResourceFinanceEdit.jsp?id=<%=hrmid%>&isView=0">
               <%}%>

            财务信息
           <%}%>
           </a>
            <%if((RecordSet.getString("itemid")).equals("3")){
                    if(canedit_10){%>
            <a href="/cpt/search/CptMyCapital.jsp?id=<%=hrmid%>">
                    
                <%}%>
                   <% if((check.equals("1"))&&canedit_3){%>            
            <a href="/cpt/search/CptMyCapital.jsp?id=<%=hrmid%>">
                <%}%>

            资产信息
            <%}%>
            </a>
<!--
            <%if((RecordSet.getString("itemid")).equals("4")){
                   if(canedit_10){%>
            <a href="/hrm/employee/EmployeeWatch.jsp?id=<%=RecordSet.getString("itemid")%>&hrmid=<%=hrmid%>&sign=1">
                    
                <%}%>
                    <% if((check.equals("1"))&&canedit_4){%>            
            <a href="/hrm/employee/EmployeeEdit.jsp?id=<%=RecordSet.getString("itemid")%>&hrmid=<%=hrmid%>">
                    <%}%>

                座位号
            <%}%>

            <%if((RecordSet.getString("itemid")).equals("5")){
                        if(canedit_10){%>
            <a href="/hrm/employee/EmployeeCptEdit.jsp?id=<%=RecordSet.getString("itemid")%>&hrmid=<%=hrmid%>&edit=0">

                    <%}%>
                       <% if((check.equals("1"))&&canedit_5){%> 
            <a href="/hrm/employee/EmployeeCptEdit.jsp?id=<%=RecordSet.getString("itemid")%>&hrmid=<%=hrmid%>&edit=1">
                        <%}%>
                    非it资产
            <%}%>
            <%if((RecordSet.getString("itemid")).equals("6")){
                         if(canedit_10){%>
            <a href="/hrm/employee/EmployeeCptEdit.jsp?id=<%=RecordSet.getString("itemid")%>&hrmid=<%=hrmid%>&edit=0">

                    <%}%>
                       <%   if((check.equals("1"))&&canedit_6){%> 
            <a href="/hrm/employee/EmployeeCptEdit.jsp?id=<%=RecordSet.getString("itemid")%>&hrmid=<%=hrmid%>&edit=1">
                            <%}%>
                    It资产
            <%}%>
            <%if((RecordSet.getString("itemid")).equals("7")){

                    if(canedit_10){%>
            <a href="/hrm/employee/EmployeeWatch.jsp?id=<%=RecordSet.getString("itemid")%>&hrmid=<%=hrmid%>&sign=1">
                <%}%>
                  <%  if((check.equals("1"))&&canedit_7){%>            
            <a href="/hrm/employee/EmployeeEdit.jsp?id=<%=RecordSet.getString("itemid")%>&hrmid=<%=hrmid%>">
                    <%}%>

                    分机直线
            <%}%>
            <%if((RecordSet.getString("itemid")).equals("8")){
                         if(canedit_10){%>
            <a href="/hrm/employee/EmployeeCptEdit.jsp?id=<%=RecordSet.getString("itemid")%>&hrmid=<%=hrmid%>&edit=0">

                    <%}%>
                       <%   if((check.equals("1"))&&canedit_8){%> 
            <a href="/hrm/employee/EmployeeCptEdit.jsp?id=<%=RecordSet.getString("itemid")%>&hrmid=<%=hrmid%>&edit=1">
                         <%}%>
            办公用品<%}%>
            <%if((RecordSet.getString("itemid")).equals("9")){
                                             if(canedit_10){%>
            <a href="/hrm/employee/EmployeeWatch.jsp?id=<%=RecordSet.getString("itemid")%>&hrmid=<%=hrmid%>&sign=1">
                <%}%>
                  <%   if((check.equals("1"))&&canedit_9){%>            
           <a href="/hrm/employee/EmployeeEdit.jsp?id=<%=RecordSet.getString("itemid")%>&hrmid=<%=hrmid%>">
                    <%}%>

            名片印制<%}%>
            </a></TD>
-->
            
		<TD> 
        <%if((RecordSet.getString("status")).equals("0")){%><%=SystemEnv.getHtmlLabelName(15808,user.getLanguage())%><%}%>
        <%if((RecordSet.getString("status")).equals("1")){%><%=SystemEnv.getHtmlLabelName(15809,user.getLanguage())%><%}%>
        </TD>		
	</TR>
<%
	}
%>
 </TABLE>
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
function finish(){
   	if(confirm("<%=SystemEnv.getHtmlLabelName(15810,user.getLanguage())%>")){
   	  if(<%=isfin%>){
        document.liststatus.operation.value="finish";
        document.liststatus.submit();
      }else{
        if(confirm("<%=SystemEnv.getHtmlLabelName(15811,user.getLanguage())%>")){
          document.liststatus.action="/hrm/resource/HrmResourceOperation.jsp";
          document.liststatus.operation.value="finish";
          document.liststatus.submit();
        }
      }  
    }
  }
</script>
</BODY>
</HTML>

<%}
else{
response.sendRedirect("/notice/noright.jsp");
    		return;
	}%>
