<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%
if(!HrmUserVarify.checkUserRight("HrmScheduleMaintanceAdd:Add" , user)) {
    response.sendRedirect("/notice/noright.jsp") ; 
    return ; 
} 
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%

String orgtype = Util.null2String(request.getParameter("type")) ;
String orgid = Util.null2String(request.getParameter("id")) ;
String theyear = Util.null2String(request.getParameter("year")) ;
String themonth = Util.null2String(request.getParameter("month")) ;
String subid=orgid;
String orgname="";
if(orgtype.equals("com"))
   orgname=SubCompanyComInfo.getSubCompanyname(orgid);
else{
   subid=DepartmentComInfo.getSubcompanyid1(orgid);
   orgname=DepartmentComInfo.getDepartmentname(orgid);
}
String supids=SubCompanyComInfo.getAllSupCompany(subid);
String deptids="";
String sql="";
if(supids.endsWith(",")){
    supids=supids.substring(0,supids.length()-1);
    sql="select * from hrmschedulediff where workflowid=5 and (diffscope=0 or (diffscope>0 and subcompanyid="+subid+") or (diffscope=2 and subcompanyid in("+supids+")))";

}
else
    sql="select * from hrmschedulediff where workflowid=5 and (diffscope=0 or (diffscope>0 and subcompanyid="+subid+"))";
    //System.out.println(sql);
    String sql1;
     if(orgtype.equals("com"))
      sql1="select * from hrmschedulemonth a,hrmresource b where a.hrmid=b.id  and b.subcompanyid1="+orgid+"  and a.theyear='"+
            theyear+"' and a.themonth='"+themonth+"'";
    else{
     deptids=SubCompanyComInfo.getDepartmentTreeStr(orgid);
     deptids=orgid+","+deptids;
     deptids=deptids.substring(0,deptids.length()-1);
     sql1="select * from hrmschedulemonth a,hrmresource b where a.hrmid=b.id  and b.departmentid in("+deptids+")  and a.theyear='"+
            theyear+"' and a.themonth='"+themonth+"'";
     }
    RecordSet.executeSql(sql);
    RecordSet1.executeSql(sql1);
Calendar today = Calendar.getInstance();
String currentyear= Util.add0(today.get(Calendar.YEAR), 4);
String currentmonth= Util.add0(today.get(Calendar.MONTH), 2);


String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(19397,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:history.back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmmain id=frmmain method=post action="HrmScheduleMonthOperation.jsp">
<input type=hidden name="operation" value="update">
<input type=hidden name="theyear" value="<%=theyear%>">
<input type=hidden name="themonth" value="<%=themonth%>">
<input type=hidden name="type" value="<%=orgtype%>">
<input type=hidden name="id" value="<%=orgid%>">
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
			<TABLE class=ViewForm>
				<COLGROUP>
                <COL width="20%">
                <COL width="80%">
                <TBODY> 
				<TR class=Title> 
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15880,user.getLanguage())+SystemEnv.getHtmlLabelName(106,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing style="height:2px"> 
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<tr>
				  <td><%if(orgtype.equals("com")){%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%><%}%></td>
				  <td class=Field>
					<%=orgname%>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
                <tr>
				  <td><%=SystemEnv.getHtmlLabelName(15880,user.getLanguage())+SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></td>
				  <td class=Field>
                    <%=theyear+SystemEnv.getHtmlLabelName(445,user.getLanguage())+themonth+SystemEnv.getHtmlLabelName(6076,user.getLanguage()) %>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
               </TBODY>
			  </TABLE>
			  <br>
    <TABLE class=ViewForm>
          <TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6138,user.getLanguage())%></TH>
				</TR>
           <TR class=Spacing style="height:2px">
				  <TD class=Line1 colSpan=2></TD>
				</TR>
           <tr><td>
              <TABLE class=ListStyle cellspacing=1>

  <TBODY>
  <TR class=Header align=left>
    <TH><%=SystemEnv.getHtmlLabelName(15880,user.getLanguage())+SystemEnv.getHtmlLabelName(106,user.getLanguage())%></TH>
    <%while(RecordSet.next()){%>
    <TH><%=RecordSet.getString("diffname")%></TH>
    <%} %>

<%
	if(orgtype.equals("com"))
	RecordSet2.executeSql("select * from hrmresource where status>-1 and status<4 and subcompanyid1="+orgid+" order by dsporder,lastname");
	else{
	RecordSet2.executeSql("select * from hrmresource where status>-1 and status<4 and departmentid in("+deptids+") order by dsporder,lastname");
	}
	int i = 0 ;
	while(RecordSet2.next()){
    String lastname=RecordSet2.getString("lastname");
    String id=RecordSet2.getString("id");

if(i==0) {
		i=1 ;
%>
<TR style="background-color:#e7e7e7">
<%
	}else{
		i=0 ;
%>
<TR style="background-color:#f5f5f5">
<%
}
%>

    <TD class=Field><%=lastname%></TD>
     <%RecordSet.beforFirst();while(RecordSet.next()){
     String type=RecordSet.getString("id");
     RecordSet1.beforFirst();
     String val="";
     while(RecordSet1.next()){
         if(RecordSet1.getString("hrmid").equals(id)&&RecordSet1.getString("difftype").equals(type)){
           val= RecordSet1.getString("hours");
           break;
         }
     }
     %>
    <TD class=Field><input size=10 class=InputStyle name=<%=id+"_"+type%> onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);'  <%if(!val.equals("")){%>value=<%=val%><%}%>></TD>
     <%}%>
</TR>
<%}%>
</TBODY></TABLE>
               </td>
               </tr>
              <br>

</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
</FORM>
<script language="javascript">
function onSubmit(obj) {
   obj.disabled=true;
   document.frmmain.submit();

}


</script>
</BODY>
</HTML>