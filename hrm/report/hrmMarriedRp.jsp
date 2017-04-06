<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.teechart.*" %>
<%@ page import="weaver.file.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page"/>
<jsp:useBean id="GraphFile" class="weaver.file.GraphFile" scope="session"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename =SystemEnv.getHtmlLabelName(179,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(469,user.getLanguage());
String needfav ="1";
String needhelp ="";

int linecolor=0;
int total=0;
float resultpercent=0;

String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String department=Util.fromScreen(request.getParameter("department"),user.getLanguage());
String location=Util.fromScreen(request.getParameter("location"),user.getLanguage());
String status=Util.fromScreen(request.getParameter("status"),user.getLanguage());
String sqlwhere="";
String sqlwhere_0="";
if(status.equals("")){
      status = "8";
    }

if(!fromdate.equals("")){
	sqlwhere+=" and startdate>='"+fromdate+"'";
    if(sqlwhere_0.equals("")){
        sqlwhere_0 =" where startdate>='"+fromdate+"'";
    }
    else{
        sqlwhere_0 +=" and startdate>='"+fromdate+"'";
    }
}
if(!enddate.equals("")){
	sqlwhere+=" and (startdate<='"+enddate+"' or startdate is null)";
    if(sqlwhere_0.equals("")){
        sqlwhere_0 =" where (startdate<='"+enddate+"' or startdate is null)";
    }
    else{
        sqlwhere_0 +=" and (startdate<='"+enddate+"' or startdate is null)";
    }
}

if(!location.equals("")){
	sqlwhere+=" and locationid ="+location;
    if(sqlwhere_0.equals("")){
        sqlwhere_0 =" where locationid ="+location;
    }
    else{
        sqlwhere_0 +=" and locationid ="+location;
    }
}
if(!department.equals("")){
	sqlwhere+=" and departmentid ="+department;
    if(sqlwhere_0.equals("")){
        sqlwhere_0 =" where departmentid ="+department;
    }
    else{
        sqlwhere_0 +=" and departmentid ="+department;
    }
}

if(!(status.equals("")||status.equals("9"))){
    if(status.equals("8")){
        sqlwhere+=" and status <= 3";
        if(sqlwhere_0.equals("")){
            sqlwhere_0 =" where status <= 3";
        }else{
            sqlwhere_0 +=" and status <= 3";
        }
    }else{        
	    sqlwhere+=" and status ="+status;

        if(sqlwhere_0.equals("")){
            sqlwhere_0 =" where status ="+status;
        }else{
            sqlwhere_0 +=" and status ="+status;
        }
    }
}

String sqlstr="";
String sql="";
String tempLevel = ""; 
if(sqlwhere_0.equals("")){
    sql = "select count(*)  from HrmResource where accounttype is null or accounttype=0 ";
}else{
    sql = "select count(*)  from HrmResource "+sqlwhere_0+" and (accounttype is null or accounttype=0)";
}    
rs.executeSql(sql);
rs.next();
total = rs.getInt(1);
ExcelFile.init();
ExcelSheet es = new ExcelSheet();
ExcelStyle excelStyle = ExcelFile.newExcelStyle("Border");
excelStyle.setCellBorder(ExcelStyle.WeaverBorderThin);
ExcelStyle excelStyle1 = ExcelFile.newExcelStyle("Header");
excelStyle1.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor);
excelStyle1.setFontcolor(ExcelStyle.WeaverHeaderFontcolor);
excelStyle1.setFontbold(ExcelStyle.WeaverHeaderFontbold);
excelStyle1.setAlign(ExcelStyle.WeaverHeaderAlign);
excelStyle1.setCellBorder(ExcelStyle.WeaverBorderThin);
ExcelStyle excelStyle2 = ExcelFile.newExcelStyle("total");
excelStyle2.setFontcolor(ExcelStyle.WeaverHeaderFontcolor);
excelStyle2.setFontbold(ExcelStyle.WeaverHeaderFontbold);
excelStyle2.setCellBorder(ExcelStyle.WeaverBorderThin);
ExcelRow er = es.newExcelRow();
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+"-Excel,javascript:exportExcel(),_self} ";
RCMenuHeight += RCMenuHeightStep;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<iframe name="ExcelOut" id="ExcelOut" src="" style="display:none" ></iframe>
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
<form name=frmmain id="frmmain" method=post action="hrmMarriedRp.jsp">
<table class=ViewForm>
<tbody>
<tr>
    <TD width=10%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD class=Field>
   <input class=wuiBrowser id=department type=hidden name=department value="<%=department%>" 
	_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
	displayText="<%=Util.toScreen(DepartmentComInfo.getDepartmentname(department),user.getLanguage())%>"
	>
    </TD>

    <TD width=10%><%=SystemEnv.getHtmlLabelName(15712,user.getLanguage())%></TD>
    <TD class=Field>
   <input class=wuiBrowser id=location type=hidden name=location value="<%=location%>"
    _url="/systeminfo/BrowserMain.jsp?url=/hrm/location/LocationBrowser.jsp"
    _displayText="<%=Util.toScreen(LocationComInfo.getLocationname(location),user.getLanguage())%>"
    >
    </TD>

    <td width=10%><%=SystemEnv.getHtmlLabelName(1908,user.getLanguage())%></td>
    <td class=field>
    <BUTTON type=button class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input type="hidden" name="fromdate" value=<%=fromdate%>>
    －<BUTTON type=button class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input type="hidden" name="enddate" value=<%=enddate%>>  
    </td>

     <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
     <TD class=Field> 
      <SELECT class=inputStyle id=status name=status value="<%=status%>"  >
<%    if(status.equals("")){
      status = "9";
    }
%>                                    
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
</tr>
<TR style="height:2px"><TD class=Line colSpan=8></TD></TR> 
</tbody>
</table>

<TABLE class=viewForm width="100%">
  <TBODY>
  <TR class=Title>
    <TH><%=SystemEnv.getHtmlLabelName(15861,user.getLanguage())%>：<%=total%></TH>
  </TR>
  </TBODY></TABLE>
<TABLE class=ListStyle cellspacing=1  width="100%">
  <COLGROUP>
  <COL align=left width="30%">
  <COL align=left width="40%">
  <COL align=left width="15%">
  <COL align=left width="15%">
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></TH>
    <TH>%</TH>
    </TR>
<TR class=Line><TD colspan="4" ></TD></TR> 
<%
	er.addStringValue(SystemEnv.getHtmlLabelName(15861,user.getLanguage()) + "：" + total, "total", 3);
	er = es.newExcelRow();
	er.addStringValue(SystemEnv.getHtmlLabelName(469,user.getLanguage()), "Header");
	er.addStringValue(SystemEnv.getHtmlLabelName(1859,user.getLanguage()), "Header");
	er.addStringValue("%", "Header");
	PieTeeChart pie=TeeChartFactory.createPieChart(SystemEnv.getHtmlLabelName(15875,user.getLanguage()),650,500,PieTeeChart.SMS_LabelPercent);
	//pie.isDebug();

/*   GraphFile.init ();
   GraphFile.setPicwidth ( 500 ); 
   GraphFile.setPichight ( 350 );
   GraphFile.setLeftstartpos ( 30 );
   GraphFile.setHistogramwidth ( 15 );
   GraphFile.setPicquality( (new Float("10.0")).floatValue() ) ;
   GraphFile.setPiclable ( SystemEnv.getHtmlLabelName(15875,user.getLanguage()));
   GraphFile.newLine ();
   GraphFile.addPiclinecolor("#660033") ;
   GraphFile.addPiclinelable("Line") ;
*/   String labelname = "";
    /*先算出记录为空的人数*/
    if(sqlwhere.equals("")){
        sqlstr="select count(*) resultcount from HrmResource where (accounttype is null or accounttype=0) and maritalstatus is null or maritalstatus =''";
    }else{
        sqlstr="select count(*) resultcount from HrmResource where (accounttype is null or accounttype=0) and (maritalstatus is null or maritalstatus ='')"+sqlwhere;
    }
    rs.executeSql(sqlstr);
    rs.next();   
    int resultcount = rs.getInt(1);
    resultpercent=(float)resultcount*100/(float)total;
    resultpercent=(float)((int)(resultpercent*100))/(float)100;	
						float resultpercentOfwidth=0;
						resultpercentOfwidth = resultpercent;
						if(resultpercentOfwidth<1&&resultpercentOfwidth>0) resultpercentOfwidth=1;

    %>
<%if(!(resultpercent==0)){%>
    <tr class=datalight>
        <TD>空 </TD>
        <TD height="100%">    
			<% String className=(resultpercent==100)?"redgraph":"greengraph";%> 
            <TABLE height="100%" cellSpacing=0 class="<%=className%>" width="<%=resultpercentOfwidth%>%">                       
            <TBODY>
            <TR>
            <TD width="100%" height="100%"><img src="/images/ArrowUpGreen.gif" width=1 height=1></td>
            </TR>
            </TBODY>
            </TABLE>        
        </TD>
        <TD><%=resultcount%></TD>
        <TD><%=resultpercent%>%</TD>
    </tr>
<%
	er = es.newExcelRow();
	er.addStringValue("空 ", "Border");
	er.addStringValue("" + resultcount, "Border");
	er.addStringValue("" + resultpercent + "%", "Border");
linecolor=1;
    labelname = SystemEnv.getHtmlLabelName(15863,user.getLanguage());
//    GraphFile.addConditionlable(labelname) ;		
//    GraphFile.addPiclinevalues ( ""+resultcount , labelname , GraphFile.random , null  );
	pie.addSeries(labelname,resultcount);
}%>    

<%
if(total!=0){
  for(int i=0;i<2;i++){
      String maritalstatus="";
        if(i==0)maritalstatus="0";
        else maritalstatus="1";

        if(sqlwhere.equals("")){            
            sqlstr = "select  COUNT(*)   resultcount from HrmResource   where (accounttype is null or accounttype=0) and maritalstatus = '"+maritalstatus+"'" ;           
        }else{            
            sqlstr = "select  COUNT(*)   resultcount from HrmResource   where (accounttype is null or accounttype=0) and maritalstatus = '"+maritalstatus+"'"+sqlwhere ;   
        }
        RecordSet.executeSql(sqlstr);
        RecordSet.next();
       
        resultcount = RecordSet.getInt(1);
        resultpercent=(float)resultcount*100/(float)total;
        resultpercent=(float)((int)(resultpercent*100))/(float)100;	
						float resultpercentOfwidth2=0;
						resultpercentOfwidth2 = resultpercent;
						if(resultpercentOfwidth2<1&&resultpercentOfwidth2>0) resultpercentOfwidth2=1;

      %> 
<%if(resultpercent!=0){%>
       <TR <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%>>
        <TD>        
        <%if(maritalstatus.equals("0")){
              labelname = SystemEnv.getHtmlLabelName(470,user.getLanguage()) ;
          }
          else if(maritalstatus.equals("1")){
            labelname = SystemEnv.getHtmlLabelName(471,user.getLanguage()) ;
          }
		  out.print(labelname);
        %>        
        </TD>
        <TD height="100%"> 
			<%String className=(resultpercent==100)?"redgraph":"greengraph";%>
			<TABLE height="100%" cellSpacing=0 class="<%=className%>" width="<%=resultpercentOfwidth2%>%">
            <TBODY>
            <TR>
            <TD width="100%" height="100%"><img src="/images/ArrowUpGreen.gif" width=1 height=1></td>
            </TR>
            </TBODY>
            </TABLE>  
         
        </TD>
        <TD><%=resultcount%></TD>
        <TD><%=resultpercent%>%</TD>
        </TR> 
  <%     
		er = es.newExcelRow();
		er.addStringValue(labelname, "Border");
		er.addStringValue("" + resultcount, "Border");
		er.addStringValue("" + resultpercent + "%", "Border");
//    		GraphFile.addConditionlable(labelname) ;		
//    		GraphFile.addPiclinevalues ( ""+resultcount , labelname , GraphFile.random , null  );
		pie.addSeries(labelname,resultcount);
    		}%>
  
  <%
      if(linecolor==0) linecolor=1;
      else	linecolor=0;
  }    
  }
   ExcelFile.setFilename(SystemEnv.getHtmlLabelName(15875,user.getLanguage()));
   ExcelFile.addSheet(SystemEnv.getHtmlLabelName(15875,user.getLanguage()), es);
  %>
 </TBODY></TABLE>
  <br>
<!--<TABLE class=ViewForm>
  <TBODY>     
  <TR> 
    <TD align=center>
        <img src='/weaver/weaver.file.GraphOut?pictype=3'>
    </TD>
  </TR> 
  <TR> 
    <TD align=center>
        <img src='/weaver/weaver.file.GraphOut?pictype=4'>
    </TD>
  </TR>    
  </TBODY> 
</TABLE> -->
</form>
<div class="chart">
<%
if ("true".equals(isIE)){
	if(pie!=null)pie.print(out);
}else{   %>
<p height="100%" width="100%" align="center" style="color:red;font-size:14px;">
			您当前使用的浏览器不支持【报表视图】，如需使用该功能，请使用IE浏览器！
</p>
<%} %>	
</div>
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
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmmain.department.value)
	if Not isempty(id) then
	if id(0)<> 0 then
	departmentspan.innerHtml = id(1)
	frmmain.department.value=id(0)
	else
	departmentspan.innerHtml = ""
	frmmain.department.value=""
	end if
	end if
end sub

sub onShowLocation()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/location/LocationBrowser.jsp")
	if Not isempty(id) then 
	if id(0)<> 0 then
	locationspan.innerHtml = id(1)
	frmmain.location.value=id(0)
	else
	locationspan.innerHtml = ""
	frmmain.location.value=""
	end if
	end if
end sub
</script>
<script language=javascript>  
function submitData() {
 jQuery("#frmmain").submit();
}
function exportExcel()
{
	document.getElementById("ExcelOut").src = "/weaver/weaver.file.ExcelOut";
}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>