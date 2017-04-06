<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.file.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<jsp:useBean id="EducationLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>	
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String year = Util.null2String(request.getParameter("year"));
String month = Util.null2String(request.getParameter("month"));
if(year.equals("")){
Calendar todaycal = Calendar.getInstance ();
year = Util.add0(todaycal.get(Calendar.YEAR), 4);
month = Util.add0(todaycal.get(Calendar.MONTH)+1, 2);
}
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(16060,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15729,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String fromTodate=Util.fromScreen(request.getParameter("fromTodate"),user.getLanguage());
String endTodate=Util.fromScreen(request.getParameter("endTodate"),user.getLanguage());

String jobtitleid=Util.fromScreen(request.getParameter("jobtitleid"),user.getLanguage());
String departmentid=Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());
System.out.println("departmentid========================"+departmentid);
String numfrom=Util.fromScreen(request.getParameter("numfrom"),user.getLanguage());
String numto=Util.fromScreen(request.getParameter("numto"),user.getLanguage());
String usekind=Util.fromScreen(request.getParameter("usekind"),user.getLanguage());
int statuses=Util.getIntValue(request.getParameter("statuses"),9);
String edulevel=Util.fromScreen(request.getParameter("edulevel"),user.getLanguage());

int content=Util.getIntValue(request.getParameter("content"),1);

String sqlwhere = "";
if(fromdate.equals("")&&enddate.equals("")){
  fromdate = year+"-"+month+"-01";
  enddate = year+"-"+month+"-31";
}
if(!fromdate.equals("")){
	sqlwhere+=" and demandregdate>='"+fromdate+"'";
}
if(!enddate.equals("")){
  if(rs.getDBType().equals("oracle")){
	sqlwhere+=" and (demandregdate<='"+enddate+"' and demandregdate is not null)";
  }else{
    sqlwhere+=" and (demandregdate<='"+enddate+"' and demandregdate is not null and demandregdate <> '')";
  }
}

if(!fromTodate.equals("")){
	sqlwhere+=" and referdate>='"+fromTodate+"'";
}
if(!endTodate.equals("")){
  if(rs.getDBType().equals("oracle")){
	sqlwhere+=" and (referdate<='"+endTodate+"' and referdate is not null)";
  }else{
    sqlwhere+=" and (referdate<='"+endTodate+"' and referdate is not null and referdate <> '')";
  }
}
if(!jobtitleid.equals("")){
  sqlwhere +=" and demandjobtitle="+jobtitleid;
}
if(!departmentid.equals("")){
  sqlwhere +=" and demanddep="+departmentid;
}
if(!usekind.equals("")){
  sqlwhere +=" and demandkind="+usekind;
}
if(!edulevel.equals("")){
  sqlwhere +=" and leastedulevel="+edulevel;
}
if(statuses != 9){
  sqlwhere +=" and status ="+statuses;
}
if(!numfrom.equals("")){
  sqlwhere +=" and demandnum >="+Util.getIntValue(request.getParameter("numfrom"),0);
}
if(!numto.equals("")){
  sqlwhere +=" and demandnum <="+Util.getIntValue(request.getParameter("numto"),0);
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(352,user.getLanguage())+",/hrm/report/usedemand/HrmRpUseDemand.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15101,user.getLanguage())+",/hrm/report/usedemand/HrmUseDemandReport.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,ExcelOut} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
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
<form name=frmmain method=post action="HrmRpUseDemandDetail.jsp">
<table class=ViewForm>
<colgroup>
<col width="15%">
<col width="25%">
<col width="15%">
<col width="25%">
<col width="5%">
<col width="15%">
<tbody>
<TR class= Spacing>
  <TD colspan=8 class=sep2></TD>
</TR>
<tr>    
    <td width=10%><%=SystemEnv.getHtmlLabelName(15934,user.getLanguage())%></td>
    <td class=field>
    <BUTTON  type="button" class=calendar id=SelectDate onclick=getDate(fromdatespan,fromdate)></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input class=inputstyle type="hidden" name="fromdate" value=<%=fromdate%>>
    －<BUTTON  type="button" class=calendar id=SelectDate onclick=getDate(enddatespan,enddate)></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input class=inputstyle type="hidden" name="enddate" value=<%=enddate%>>  
    </td>
     <td width=10%><%=SystemEnv.getHtmlLabelName(15175,user.getLanguage())%></td>
    <td class=field>
    <BUTTON  type="button" class=calendar id=SelectDate onclick=getDate(fromTodatespan,fromTodate)></BUTTON>&nbsp;
    <SPAN id=fromTodatespan ><%=Util.toScreen(fromTodate,user.getLanguage())%></SPAN>
    <input class=inputstyle type="hidden" name="fromTodate" value=<%=fromTodate%>>
    －<BUTTON  type="button" class=calendar id=SelectDate onclick=getDate(endTodatespan,endTodate)></BUTTON>&nbsp;
    <SPAN id=endTodatespan ><%=Util.toScreen(endTodate,user.getLanguage())%></SPAN>
    <input class=inputstyle type="hidden" name="endTodate" value=<%=endTodate%>>  
    </td>          
</tr>
<TR style="height: 1px;"><TD class=Line colSpan=6></TD></TR> 
<tr>    
    <TD><%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%></TD>
    <TD class=Field> 
      <input type="hidden" class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
       _displayText="<%=DepartmentComInfo.getDepartmentname(departmentid)%>" id=departmentid
       name=departmentid value="<%=departmentid%>"
      >
    </TD> 
    <TD><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
    <TD class=Field>
       <input type="hidden" class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
       _displayText="<%=JobTitlesComInfo.getJobTitlesname(jobtitleid)%>"
       id=jobtitleid name=jobtitleid value="<%=jobtitleid%>"
       >
    </td>  
</tr>
<TR style="height: 1px;"><TD class=Line colSpan=6></TD></TR> 
<tr>          
    <td><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></td>
    <td class=Field >
      <input type="hidden" class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/usekind/UseKindBrowser.jsp"
       _displayText="<%=UseKindComInfo.getUseKindname(usekind)%>"
       id=usekind name=usekind value="<%=usekind%>"
       > 
    </td>   
    <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
    <TD class=Field>
      <select class=inputstyle name=statuses value="<%=statuses %>">
        <option value=9 <%if(statuses  == 9){%>selected <%}%>></option>
        <option value=0 <%if(statuses  == 0){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15746,user.getLanguage())%></option>
        <option value=1 <%if(statuses  == 1){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15747,user.getLanguage())%></option>
        <option value=2 <%if(statuses  == 2){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15748,user.getLanguage())%></option>
        <option value=3 <%if(statuses  == 3){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15749,user.getLanguage())%></option>
        <option value=4 <%if(statuses  == 4){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15750,user.getLanguage())%></option> </select>
    </TD>             
</tr>
<TR style="height: 1px;"><TD class=Line colSpan=6></TD></TR> 
<tr>    
    <TD><%=SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></TD>
    <TD class=Field>
      <input class=inputstyle type=text size=5 name="numfrom" value="<%=numfrom%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("numfrom")' >--<input class=inputstyle type=text size=5 name="numto" value="<%=numto%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("numto")' >             
    </td>   
    <TD><%=SystemEnv.getHtmlLabelName(1860,user.getLanguage())%></TD>
    <TD class=Field>   
      <input type="hidden" class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/educationlevel/EduLevelBrowser.jsp"
       _displayText="<%=EducationLevelComInfo.getEducationLevelname(edulevel)%>"
       id=edulevel name=edulevel value="<%=edulevel%>"
       > 
    </TD>    
</tr>
<TR style="height: 1px;"><TD class=Line colSpan=6></TD></TR> 
<tr>
</tr>
</tbody>
</table>

<br>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>  
  <COL width="15%">
  <COL width="15%">  
  <COL width="5%">
  <COL width="10%">
  <COL width="15%">
  <COL width="10%">
  <COL width="15%">
  <COL width="15%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=8><%=SystemEnv.getHtmlLabelName(6131,user.getLanguage())%></TH></TR>
    <TR class=Header>    
    <TD><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(6153,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15175,user.getLanguage())%></TD>
  </TR>
  <TR class=Line style="height: 1px;"><TD colspan="8" ></TD></TR> 
<%
   ExcelFile.init ();
   String filename = SystemEnv.getHtmlLabelName(16062,user.getLanguage()) ; 
   filename += fromdate+"--"+  enddate;
   ExcelFile.setFilename(filename+year+"-"+month) ;
   
   // 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
   ExcelStyle es = ExcelFile.newExcelStyle("Header") ;
   es.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   es.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   es.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   es.setAlign(ExcelStyle.WeaverHeaderAlign) ;
   
   ExcelSheet et = ExcelFile.newExcelSheet(""+year+filename) ;
   // 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度  
   et.addColumnwidth(6000) ;
   et.addColumnwidth(6000) ;
   et.addColumnwidth(2000) ;
   et.addColumnwidth(4000) ;
   et.addColumnwidth(4000) ;
   et.addColumnwidth(4000) ;
   et.addColumnwidth(4000) ;
   et.addColumnwidth(4000) ;
   
   ExcelRow erdepType = null ;
   erdepType = et.newExcelRow();
   erdepType.addStringValue(SystemEnv.getHtmlLabelName(6086,user.getLanguage()), "Header" ) ; 
   erdepType.addStringValue(SystemEnv.getHtmlLabelName(124,user.getLanguage()), "Header" ) ; 
   erdepType.addStringValue(SystemEnv.getHtmlLabelName(1859,user.getLanguage()), "Header" ) ; 
   erdepType.addStringValue(SystemEnv.getHtmlLabelName(6152,user.getLanguage()), "Header" ) ; 
   erdepType.addStringValue(SystemEnv.getHtmlLabelName(6153,user.getLanguage()), "Header" ) ; 
   erdepType.addStringValue(SystemEnv.getHtmlLabelName(602,user.getLanguage()), "Header" ) ; 
   erdepType.addStringValue(SystemEnv.getHtmlLabelName(616,user.getLanguage()), "Header" ) ; 
   erdepType.addStringValue(SystemEnv.getHtmlLabelName(15175,user.getLanguage()), "Header" ) ; 
    
String sql = "select * from HrmUseDemand where 1 = 1 "+ sqlwhere +" order by referdate desc"; 
rs.executeSql(sql); 
int needchange = 0; 
while(rs.next()){ 
ExcelRow erdep = et.newExcelRow() ;

String	jobtitle=Util.null2String(rs.getString("demandjobtitle")); 
String  department = Util.null2String(rs.getString("demanddep")); 
String	num= Util.null2String(rs.getString("demandnum")); 
String  kind = Util.null2String(rs.getString("demandkind"));
String  date = Util.null2String(rs.getString("demandregdate"));
String  referman = Util.null2String(rs.getString("refermandid"));
String  referdate = Util.null2String(rs.getString("referdate"));
int  status = Util.getIntValue(rs.getString("status"));
String statusname = "";
if(status == 0){statusname = SystemEnv.getHtmlLabelName(15746,user.getLanguage());}
if(status == 1){statusname = SystemEnv.getHtmlLabelName(15747,user.getLanguage());}
if(status == 2){statusname = SystemEnv.getHtmlLabelName(15748,user.getLanguage());}
if(status == 3){statusname = SystemEnv.getHtmlLabelName(15749,user.getLanguage());}
if(status == 4){statusname = SystemEnv.getHtmlLabelName(15750,user.getLanguage());}
erdep.addStringValue(Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle),user.getLanguage()));
erdep.addStringValue(Util.toScreen(DepartmentComInfo.getDepartmentname(department),user.getLanguage()));
erdep.addStringValue(Util.toScreen(num,user.getLanguage()));
erdep.addStringValue(Util.toScreen(UseKindComInfo.getUseKindname(kind),user.getLanguage()));
erdep.addStringValue(Util.toScreen(date,user.getLanguage()));
erdep.addStringValue(Util.toScreen(statusname,user.getLanguage()));
erdep.addStringValue(Util.toScreen(ResourceComInfo.getResourcename(referman) ,user.getLanguage()));
erdep.addStringValue(Util.toScreen(referdate,user.getLanguage()));
try{ 
  if(needchange ==0){ 
  needchange = 1; 
%> 
  <TR class=datalight> 
<% 
}else{ needchange=0; 
%>
  <TR class=datadark> 
<%
} 
%>    
   <TD><%=JobTitlesComInfo.getJobTitlesname(jobtitle)%>
   </TD>
   <td><%=DepartmentComInfo.getDepartmentname(department) %>
   </td>
   <TD><%=num%>
   </TD> 
   <TD><%=UseKindComInfo.getUseKindname(kind)%>
   </TD> 
   <TD><%=date%>
   </TD> 
   <td> <%=statusname%>
   </td>
   <td><%=ResourceComInfo.getResourcename(referman) %>
   </td>
   <td><%=referdate %>
   </td>
  </TR>
<% 
  }catch(Exception e){ 
  System.out.println(e.toString()); } } 
%>
</TBODY>
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
function submitData() {
 frmmain.submit();
}
</script>

</BODY>
  <SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>

