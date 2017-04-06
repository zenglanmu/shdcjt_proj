<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="GraphFile" class="weaver.file.GraphFile" scope="session"/>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String year = Util.null2String(request.getParameter("year"));
if(year.equals("")){
Calendar todaycal = Calendar.getInstance ();
year = Util.add0(todaycal.get(Calendar.YEAR), 4);
}

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15992,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

float resultpercent=0;
int total = 0;
int linecolor=0;

String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());

String sqlwhereyear = "";
String sqlwhere = "";

	sqlwhereyear+=" and t1.changedate>='"+year+"-01-01'";
	sqlwhereyear+=" and (t1.changedate<='"+year+"-12-31' or t1.changedate is null)";


String sql = "select count(id) from HrmStatusHistory t1 where type_n = 4 "+sqlwhereyear;
rs.executeSql(sql);
rs.next();
total = rs.getInt(1);
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/report/redeploy/HrmRpRedeploy.jsp,_self} " ;
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
<form name=frmmain method=post action="HrmRpRedeployTime.jsp">
<%
   GraphFile.init ();
   GraphFile.setPicwidth ( 500 ); 
   GraphFile.setPichight ( 350 );
   GraphFile.setLeftstartpos ( 30 );
   GraphFile.setHistogramwidth ( 15 );
   GraphFile.setPicquality( (new Float("10.0")).floatValue() ) ;
   GraphFile.setPiclable (SystemEnv.getHtmlLabelName(15992,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(1329,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6076,user.getLanguage())+")" );
   GraphFile.newLine ();
   GraphFile.addPiclinecolor(GraphFile.red) ;
   GraphFile.addPiclinelable(""+year) ;   
   for(int month = 1;month<13;month++){
	   String firstday = ""+year+"-"+Util.add0(month,2)+"-01";
	   String lastday = ""+year+"-"+Util.add0(month,2)+"-31";
	   sqlwhere =" and (changedate >='"+firstday +"' and changedate <= '"+lastday+"')";
	   sql = "select count(t1.id) resultcount from HrmStatusHistory t1 where type_n = 4 "+sqlwhere;		     
	   rs.executeSql(sql);
	   rs.next();
	   String number = ""+rs.getInt(1);
	   String title = ""+month;
	   GraphFile.addConditionlable(title) ;		
	   GraphFile.addPiclinevalues ( ""+number , title , "" , null  );    		
   }
   int colcount = GraphFile.getConditionlableCount() + 1 ;
%>
<br>
<TABLE class=ViewForm>
  <TBODY> 
  <tr>
    <td width=10%><%=SystemEnv.getHtmlLabelName(15933,user.getLanguage())%></td>
    <td class=field>
      <INPUT class=inputStyle maxLength=4 size=4 name="year"    onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("year")' value="<%=year%>">
    </td>     
   </tr>
  <TR> 
    <TD align=center colspan =2>
        <img src='/weaver/weaver.file.GraphOut?pictype=2'>
    </TD>
  </TR>  
  <TR> 
    <TD align=center colspan =2>
        <img src='/weaver/weaver.file.GraphOut?pictype=1'>
    </TD>
  </TR>    
  </TBODY> 
</TABLE>
<TABLE class=ListStyle cellspacing=1 >
  <TBODY> 
    <TR class=Header>
    <TD>&nbsp;</TD>
  <%
    while(GraphFile.nextCondition()) {
        String condition = GraphFile.getConditionlable() ;
  %>
    <TD><%=condition%></TD>
  <%}%>
  </TR>
<TR class=Line><TD colspan=<%=colcount%>></TD></TR> 
  <%
    boolean isLight = false;
    while(GraphFile.nextLine()) {
        isLight = !isLight ;
        String linelable = GraphFile.getPiclinelable() ;
  %>
  <TR class='<%=( isLight ? "datalight" : "datadark" )%>'> 
    <TD><%=linelable%></TD>
  <%
        while(GraphFile.nextCondition()) {
            String linevalue = GraphFile.getPiclineValue() ;
  %>
    <TD><%=linevalue%></TD>
  <%    } %>
  </TR>
  <%}%>
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
<script language=vbs>
sub onShowOldJobtitle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	oldjobtitlespan.innerHtml = id(1)
	frmmain.oldjobtitle.value=id(0)
	else 
	oldjobtitlespan.innerHtml = ""
	frmmain.oldjobtitle.value=""
	end if
	end if
end sub
sub onShowNewJobtitle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	newjobtitlespan.innerHtml = id(1)
	frmmain.newjobtitle.value=id(0)
	else 
	newjobtitlespan.innerHtml = ""
	frmmain.newjobtitle.value=""
	end if
	end if
end sub
sub onShowOldDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmmain.olddepartment.value)	
	if id(0)<> 0 then	
	olddepartmentspan.innerHtml = id(1)
	frmmain.olddepartment.value=id(0)
	else
	olddepartmentspan.innerHtml = ""
	frmmain.olddepartment.value=""	
	end if
end sub
sub onShowNewDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmmain.newdepartment.value)	
	if id(0)<> 0 then	
	newdepartmentspan.innerHtml = id(1)
	frmmain.newdepartment.value=id(0)
	else
	newdepartmentspan.innerHtml = ""
	frmmain.newdepartment.value=""	
	end if
end sub
</script>
<script language=javascript>  
function submitData() {
 frmmain.submit();
}
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>