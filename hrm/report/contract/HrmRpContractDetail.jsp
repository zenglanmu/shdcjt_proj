<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ContractTypeComInfo" class="weaver.hrm.contract.ContractTypeComInfo" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String rightStr = "";
if(HrmUserVarify.checkUserRight("HrmContractTypeAdd:Add", user)){
	rightStr="HrmContractTypeAdd:Add";
}
if(HrmUserVarify.checkUserRight("HrmContractAdd:Add", user)){
	rightStr="HrmContractAdd:Add";
}
session.setAttribute("HrmRpContract_left_"+user.getUID(),"HrmRpContractDetail.jsp");
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15948,user.getLanguage());
String needfav ="1";
String needhelp ="";

float resultpercent=0;
int total = 0;
int linecolor=0;
String filename = SystemEnv.getHtmlLabelName(15949,user.getLanguage());
String subcompanyid1=Util.null2String(request.getParameter("subcompanyid1"));
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String fromTodate=Util.fromScreen(request.getParameter("fromTodate"),user.getLanguage());
String endTodate=Util.fromScreen(request.getParameter("endTodate"),user.getLanguage());
String typeid=Util.fromScreen(request.getParameter("typeid"),user.getLanguage());
String department=Util.fromScreen(request.getParameter("department"),user.getLanguage());
String jobtitle=Util.fromScreen(request.getParameter("jobtitle"),user.getLanguage());
String typepar=Util.null2String(request.getParameter("typepar"));
String from = Util.null2String(request.getParameter("from"));
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String sqlwhere = "";

if(!fromdate.equals("")){
	sqlwhere+=" and t1.contractstartdate>='"+fromdate+"'";
	filename += fromdate;
}
if(!enddate.equals("")){
	sqlwhere+=" and (t1.contractstartdate<='"+enddate+"' or t1.contractstartdate is null)";
	filename += "--"+enddate;
}
if(!fromTodate.equals("")){
	sqlwhere+=" and t1.contractenddate>='"+fromTodate+"'";
}
if(!endTodate.equals("")){
  if(rs.getDBType().equals("oracle")){
	sqlwhere+=" and (t1.contractenddate<='"+endTodate+"' and t1.contractenddate is not null)";
  }else{
    sqlwhere+=" and (t1.contractenddate<='"+endTodate+"' and t1.contractenddate is not null and t1.contractenddate <> '')";
  }
}
if(!typepar.equals("")){
	sqlwhere+=" and t2.jobtitle in (select id from HrmJobTitles where jobtitlename like '%" + typepar +"%')";
}
if(!department.equals("")){
	sqlwhere+="  and t2.departmentid = "+department+" ";
}
if(!typeid.equals("")){
	sqlwhere+=" and t1.contracttypeid="+typeid+" ";
}
if(detachable==1){
	if(!subcompanyid1.equals("") && !from.equals("detail")){
		sqlwhere+=" and t2.id in (select id from HrmResource where subcompanyid1 =  "+subcompanyid1+")";
	}else if(subcompanyid1.equals("") && !from.equals("detail")){
		subcompanyid1 = String.valueOf(user.getUserSubCompany1()); 
		sqlwhere+=" and t2.id in (select id from HrmResource where subcompanyid1 =  "+subcompanyid1+")";
	}
	if(from.equals("detail")){
	    //subcompanyid1 = String.valueOf(user.getUserSubCompany1()); 
		sqlwhere+=" and t2.id in (select id from HrmResource where subcompanyid1 =  "+subcompanyid1+")";
	}
}
String sql = "";
sql = "select count(t1.id) from HrmContract t1,HrmResource t2 where (t2.accounttype is null or t2.accounttype=0) and t1.contractman=t2.id "+sqlwhere;

rs.executeSql(sql);
rs.next();
total = rs.getInt(1);

String sqlstr = "";
sqlstr = "select t1.*,departmentid,jobtitle from HrmContract t1,HrmResource t2 where (t2.accounttype is null or t2.accounttype=0) and t1.contractman=t2.id "+sqlwhere+" order by contractstartdate desc";
rs.executeSql(sqlstr);
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/report/contract/HrmRpContract.jsp?isFirst=detail&subcompanyid1="+subcompanyid1+",_self} " ;
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
<form name=frmmain method=post action="HrmRpContractDetail.jsp">
<input type="hidden" name="from">
<input type="hidden" name="subcompanyid1" value="<%=subcompanyid1%>">
<table class=ViewForm>
<colgroup>
<col width="15%">
<col width="35%">
<col width="15%">
<col width="35%">
<tbody>
<TR class= Spacing>
  <TD colspan=8 class=sep2></TD>
</TR>
<tr>
    <TD ><%=SystemEnv.getHtmlLabelName(15950,user.getLanguage())%></TD>
    <TD class=Field>
    <button class=Browser onClick="onShowdepartment()"></button> 
    <span class=inputStyle id=departmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(department),user.getLanguage())%></span> 
    <input type=hidden name=department value="<%=department%>">
    </TD>
    <TD ><%=SystemEnv.getHtmlLabelName(15951,user.getLanguage())%></TD>
    <!-- TD class=Field>
    <button class=Browser onClick="onShowjobtitle()"></button> 
    <span class=inputStyle id=jobtitlespan><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle),user.getLanguage())%></span> 
    <input type=hidden name=jobtitle  value="<%=jobtitle%>">
    </TD-->  
    <td class=field>
      <input  class=inputstyle type=text name=typepar value=<%=typepar%>>
    </td>  
</tr>
<TR><TD class=Line colSpan=6></TD></TR> 
<tr>    
    <td ><%=SystemEnv.getHtmlLabelName(15952,user.getLanguage())%></td>
    <td class=field >
    <BUTTON class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input type="hidden" name="fromdate" value=<%=fromdate%>>
    －<BUTTON class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input type="hidden" name="enddate" value=<%=enddate%>>  
    </td>   
    <td width=10%><%=SystemEnv.getHtmlLabelName(15944,user.getLanguage())%></td>
    <td class=field>
    <BUTTON class=calendar id=SelectDate onclick=getfromToDate()></BUTTON>&nbsp;
    <SPAN id=fromTodatespan ><%=Util.toScreen(fromTodate,user.getLanguage())%></SPAN>
    <input type="hidden" name="fromTodate" value=<%=fromTodate%>>
    －<BUTTON class=calendar id=SelectDate onclick=getendToDate()></BUTTON>&nbsp;
    <SPAN id=endTodatespan ><%=Util.toScreen(endTodate,user.getLanguage())%></SPAN>
    <input type="hidden" name="endTodate" value=<%=endTodate%>>  
    </td>   
</tr>
<TR><TD class=Line colSpan=2></TD></TR> 
</tbody>
</table>
<table class=ListStyle cellspacing=1 >
<tbody>
  <TR class=Header>
    <TH colspan=6><%=SystemEnv.getHtmlLabelName(15945,user.getLanguage())%>: <%=total%></TH>
  </TR>
  <tr class=header>
    <td><%=SystemEnv.getHtmlLabelName(15776,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(6158,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(15950,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(15951,user.getLanguage())%></td>    
    <td><%=SystemEnv.getHtmlLabelName(15953,user.getLanguage())%></td>    
    <td><%=SystemEnv.getHtmlLabelName(15236,user.getLanguage())%></td>    
  </tr>
  <TR class=Line><TD colspan="6" ></TD></TR> 
  <%
   ExcelFile.init ();   
   ExcelFile.setFilename(""+filename) ;

   // 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
   ExcelStyle es = ExcelFile.newExcelStyle("Header") ;
   es.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   es.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   es.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   es.setAlign(ExcelStyle.WeaverHeaderAlign) ;
   
   ExcelSheet et = ExcelFile.newExcelSheet( SystemEnv.getHtmlLabelName(15949,user.getLanguage()) ) ;

   // 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度  
   et.addColumnwidth(4000) ;
   et.addColumnwidth(4000) ;
   et.addColumnwidth(6000) ;   
   et.addColumnwidth(4000) ;
   et.addColumnwidth(4000) ;
   et.addColumnwidth(4000) ;
   
   ExcelRow er = null ;

   er = et.newExcelRow() ;
   er.addStringValue( SystemEnv.getHtmlLabelName(15776,user.getLanguage()) , "Header" ) ;  
   er.addStringValue( SystemEnv.getHtmlLabelName(6158,user.getLanguage()) , "Header" ) ;  
   er.addStringValue( SystemEnv.getHtmlLabelName(15950,user.getLanguage()) , "Header" ) ;  
   er.addStringValue( SystemEnv.getHtmlLabelName(15951,user.getLanguage()) , "Header" ) ;     
   er.addStringValue( SystemEnv.getHtmlLabelName(15953,user.getLanguage()) , "Header" ) ;     
   er.addStringValue( SystemEnv.getHtmlLabelName(15236,user.getLanguage()) , "Header" ) ;     
     
   if(total!=0){
     while(rs.next()){
     String departmentid = Util.null2String(rs.getString("departmentid"));     	     
     String resourcename = Util.toScreen(ResourceComInfo.getResourcename(rs.getString("contractman")),user.getLanguage());	
     String contracttypename = Util.toScreen(ContractTypeComInfo.getContractTypename(rs.getString("contracttypeid")),user.getLanguage());	
     String departnemtname = Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage());
     String jobtitlename = Util.toScreen(JobTitlesComInfo.getJobTitlesname(rs.getString("jobtitle")),user.getLanguage());     
     String contractstartdate = Util.toScreen(rs.getString("contractstartdate"),user.getLanguage());
     String contractenddate = Util.toScreen(rs.getString("contractenddate"),user.getLanguage());
     
     er = et.newExcelRow() ;
     er.addStringValue(resourcename) ;
     er.addStringValue(contracttypename) ;
     er.addStringValue(departnemtname) ;
     er.addStringValue(jobtitlename) ;     
     er.addStringValue(contractstartdate) ;    
     er.addStringValue(contractenddate) ;     
   %>
  <TR <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%>>
    <TD><a href="/hrm/resource/HrmResource.jsp?id=<%=rs.getString("contractman")%>"> <%=resourcename%></a></TD>
    <TD><a href="/hrm/contract/contracttype/HrmContractTypeEdit.jsp?id=<%=rs.getString("contracttypeid")%>"> <%=contracttypename%></a></TD>
    <TD><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=departmentid%>"> <%=departnemtname%></a></TD>
    <TD><a href="/hrm/jobtitles/HrmJobTitlesEdit.jsp?id=<%=rs.getString("jobtitleid")%>"> <%=jobtitlename%></a></TD>    
    <TD><%=contractstartdate%></TD>        
    <TD><%=contractenddate%></TD>        
    </TR>
    <%		if(linecolor==0) linecolor=1;
    		else	linecolor=0;
    		}
	} %>  
</table>
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
function submitData() {
document.frmmain.from.value = "detail";
 frmmain.submit();
}
</script>


<script language=vbs>
sub onShowjobtitle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")	
	if id(0)<> 0 then
	jobtitlespan.innerHtml = id(1)
	frmmain.jobtitle.value=id(0)
	else 
	jobtitlespan.innerHtml = ""
	frmmain.jobtitle.value=""
	end if	
end sub

sub onShowdepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser2.jsp?rightStr=<%=rightStr%>&selectedids="&frmmain.department.value)	
	if id(0)<> 0 then	
	departmentspan.innerHtml = id(1)
	frmmain.department.value=id(0)
	else
	departmentspan.innerHtml = ""
	frmmain.department.value=""	
	end if
end sub
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>
