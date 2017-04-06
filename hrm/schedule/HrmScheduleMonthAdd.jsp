<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.*,weaver.file.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
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
String msg = Util.null2String(request.getParameter("msg")) ;
String subid=orgid;
String orgname="";
if(orgtype.equals("com"))
   orgname=SubCompanyComInfo.getSubCompanyname(orgid);
else{
   subid=DepartmentComInfo.getSubcompanyid1(orgid);
   orgname=DepartmentComInfo.getDepartmentname(orgid);
}
String supids=SubCompanyComInfo.getAllSupCompany(subid);

String sql="";
if(supids.endsWith(",")){
    supids=supids.substring(0,supids.length()-1);
    sql="select * from hrmschedulediff where workflowid=5 and (diffscope=0 or (diffscope>0 and subcompanyid="+subid+") or (diffscope=2 and subcompanyid in("+supids+")))";

}
else
    sql="select * from hrmschedulediff where workflowid=5 and (diffscope=0 or (diffscope>0 and subcompanyid="+subid+"))";
    //System.out.println(sql);
RecordSet.executeSql(sql);
Calendar today = Calendar.getInstance();
String currentyear= Util.add0(today.get(Calendar.YEAR), 4);
String currentmonth= Util.add0(today.get(Calendar.MONTH), 2);


String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(19397,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(82,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+"Excel"+SystemEnv.getHtmlLabelName(64,user.getLanguage())+" , /weaver/weaver.file.ExcelOut,ExcelOut} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
<FORM style="MARGIN-TOP: 0px" name=frmmain id=frmmain method=post enctype="multipart/form-data" action="HrmScheduleMonthOperation.jsp">
<input type=hidden id="operation" name="operation" value="add">
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
                <%if(!msg.equals("")){out.print("<font color=red><b>!"+SystemEnv.getHtmlLabelName(Integer.parseInt(msg),user.getLanguage())+"</b></font>");}%>    
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
                    <select name="theyear">
                        <%for(int y=1909;y<2100;y++){%>
                        <option value="<%=y%>" <%if(currentyear.equals(""+y)){%>selected<%}%>><%=y%></option>
                        <%}%>
                    </select> <%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>
                    <select name="themonth">
                        <option value="01" <%if(currentmonth.equals("01")){%>selected<%}%>>01</option>
                        <option value="02" <%if(currentmonth.equals("02")){%>selected<%}%>>02</option>
                        <option value="03" <%if(currentmonth.equals("03")){%>selected<%}%>>03</option>
                        <option value="04" <%if(currentmonth.equals("04")){%>selected<%}%>>04</option>
                        <option value="05" <%if(currentmonth.equals("05")){%>selected<%}%>>05</option>
                        <option value="06" <%if(currentmonth.equals("06")){%>selected<%}%>>06</option>
                        <option value="07" <%if(currentmonth.equals("07")){%>selected<%}%>>07</option>
                        <option value="08" <%if(currentmonth.equals("08")){%>selected<%}%>>08</option>
                        <option value="09" <%if(currentmonth.equals("09")){%>selected<%}%>>09</option>
                        <option value="10" <%if(currentmonth.equals("10")){%>selected<%}%>>10</option>
                        <option value="11" <%if(currentmonth.equals("11")){%>selected<%}%>>11</option>
                        <option value="12" <%if(currentmonth.equals("12")){%>selected<%}%>>12</option>
                    </select> <%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
				  </td>
				</tr>
                <TR class= Spacing style="height:1px"><TD class=Line colSpan=2></TD></TR>
               <%if(orgtype.equals("com")){%>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(16699,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=file  name="excelfile" size=40>&nbsp;&nbsp;<button Class=AddDoc type=button onclick="loadexcel(this)"><%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%></button></TD>
   </TR>
                <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
                    <%}%>
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
    <%
     ExcelFile.init() ;
 ExcelFile.setFilename(orgname+currentmonth+SystemEnv.getHtmlLabelName(6076,user.getLanguage())+SystemEnv.getHtmlLabelName(15880,user.getLanguage())+SystemEnv.getHtmlLabelName(563,user.getLanguage())) ;

    ExcelStyle est = ExcelFile.newExcelStyle("Header") ;
    est.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   est.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   est.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   est.setAlign(ExcelStyle.WeaverHeaderAlign) ;
   ExcelSheet es = ExcelFile.newExcelSheet(orgname+currentmonth+SystemEnv.getHtmlLabelName(6076,user.getLanguage())+SystemEnv.getHtmlLabelName(15880,user.getLanguage())+SystemEnv.getHtmlLabelName(563,user.getLanguage())) ;
   ExcelRow er = es.newExcelRow() ;
    er.addStringValue("id","Header") ;
    er.addStringValue("name","Header") ;
    while(RecordSet.next()){

er.addStringValue(RecordSet.getString("diffname"),"Header") ;

%>
    <TH><%=RecordSet.getString("diffname")%></TH>
    <%} es.addExcelRow(er) ; %>
	
<%
	if(orgtype.equals("com"))
	RecordSet1.executeSql("select * from hrmresource where status>-1 and status<4 and subcompanyid1="+orgid+" order by dsporder,lastname");
	else{
	String deptids=SubCompanyComInfo.getDepartmentTreeStr(orgid);
     deptids=orgid+","+deptids;
     deptids=deptids.substring(0,deptids.length()-1);
	RecordSet1.executeSql("select * from hrmresource where status>-1 and status<4 and departmentid in("+deptids+") order by dsporder,lastname");
	}
	int i = 0 ;
	while(RecordSet1.next()){
	ExcelRow er1 = es.newExcelRow () ;
    String lastname=RecordSet1.getString("lastname");
    String id=RecordSet1.getString("id");
    er1.addStringValue(id) ;
    er1.addStringValue(lastname) ;
    es.addExcelRow(er1) ;
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
     String type=RecordSet.getString("id");%>
    <TD class=Field><input size=10 class=InputStyle name=<%=id+"_"+type%> onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);' ></TD>
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
<td height="	0" colspan="3"></td>
</tr>
</table>
</FORM>

<script language="javascript">
function onSubmit(obj) {
   obj.disabled = true;
   document.frmmain.submit();

}

function loadexcel() {
  frmmain.operation.value="importnew";
  document.frmmain.submit();

}
</script>
</BODY>
</HTML>