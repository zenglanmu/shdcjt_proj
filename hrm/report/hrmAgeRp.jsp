<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
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

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage()) +":" + SystemEnv.getHtmlLabelName(671,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

String optional="projecttype";
int linecolor=0;
int total=0;
float resultpercent=0;

String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String department=Util.fromScreen(request.getParameter("department"),user.getLanguage());
String location=Util.fromScreen(request.getParameter("location"),user.getLanguage());
String status=Util.fromScreen(request.getParameter("status"),user.getLanguage());
String agearea=Util.fromScreen(request.getParameter("agearea"),user.getLanguage());
String sqlwhere="";
String sqlwhere_0="";

if(agearea.equals(""))agearea="10";

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
int resultcount=0;
if(sqlwhere_0.equals("")){
    sql = "select count(*)  from HrmResource where accounttype is null or accounttype=0 ";
}else{
    sql = "select count(*)  from HrmResource "+sqlwhere_0+" and (accounttype is null or accounttype=0)";
}    
rs.executeSql(sql);
rs.next();
total = rs.getInt(1);/*总人数*/

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
<form name=frmmain method=post action="hrmAgeRp.jsp">
<table class=ViewForm>
<tbody>
<TR class=Spacing><TD colspan=9 class=Line1></TD></TR>
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
    <input class=inputStyle type="hidden" name="fromdate" value=<%=fromdate%>>
    －<BUTTON type=button class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input class=inputStyle type="hidden" name="enddate" value=<%=enddate%>>  
    </td>
    <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
     <TD class=Field> 
      <SELECT class=inputStyle id=status name=status value="<%=status%>"  >              
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
    <TD><%=SystemEnv.getHtmlLabelName(15860,user.getLanguage())%>:</TD>
    <TD class=Field><INPUT class=inputStyle maxLength=20 size=6 id="agearea" name="agearea"    onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("agearea")' value="<%=agearea%>"><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>    
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
    <TH><%=SystemEnv.getHtmlLabelName(671,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></TH>
    <TH>%</TH>
    </TR>
    <TR class=Line><TD colspan="4" ></TD></TR> 
<%
er.addStringValue(SystemEnv.getHtmlLabelName(15861,user.getLanguage()) + "：" + total, "total", 3);
er = es.newExcelRow();
er.addStringValue(SystemEnv.getHtmlLabelName(671,user.getLanguage()), "Header");
er.addStringValue(SystemEnv.getHtmlLabelName(1859,user.getLanguage()), "Header");
er.addStringValue("%", "Header");
PieTeeChart pie=null;

/*   GraphFile.init ();
   GraphFile.setPicwidth ( 500 ); 
   GraphFile.setPichight ( 350 );
   GraphFile.setLeftstartpos ( 30 );
   GraphFile.setHistogramwidth ( 15 );
   GraphFile.setPicquality( (new Float("10.0")).floatValue() ) ;
   GraphFile.setPiclable (SystemEnv.getHtmlLabelName(15862,user.getLanguage()));
   GraphFile.newLine ();
   GraphFile.addPiclinecolor("#660033") ;
   GraphFile.addPiclinelable("Line") ;
*/   String labelname = "";

    /*先算出年龄记录为空的人数*/
    if(sqlwhere.equals("")){
        sqlstr="select count(*) resultcount from HrmResource where (accounttype is null or accounttype=0) and birthday is null or birthday =''";
    }else{
        sqlstr="select count(*) resultcount from HrmResource where (accounttype is null or accounttype=0) and (birthday is null or birthday ='')"+sqlwhere;
    }
    rs.executeSql(sqlstr);
    rs.next();   
    resultcount = rs.getInt(1);
    resultpercent=(float)resultcount*100/(float)total;
    resultpercent=(float)((int)(resultpercent*100))/(float)100;	
    						float resultpercentOfwidth=0;
						resultpercentOfwidth = resultpercent;
						if(resultpercentOfwidth<1&&resultpercentOfwidth>0) resultpercentOfwidth=1;

    %>
<%if(!(resultpercent==0)){%>
    <tr class=datalight>
        <TD><%=SystemEnv.getHtmlLabelName(15863,user.getLanguage())%> </TD>
        <TD height="100%">
		<%String className=(resultpercent==100)?"redgraph":"greengraph";%>
            <TABLE height="100%" cellSpacing=0  class="<%=className%>" width="<%=resultpercentOfwidth%>%">
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
<% 	pie=TeeChartFactory.createPieChart(SystemEnv.getHtmlLabelName(15862,user.getLanguage()),550,400,PieTeeChart.SMS_LabelPercent);
	//pie.isDebug();

 	labelname = Util.toScreen("空",user.getLanguage(),"0");
//    GraphFile.addConditionlable(labelname) ;		
//    GraphFile.addPiclinevalues ( ""+resultcount , labelname , GraphFile.random , null  );
	
	pie.addSeries(labelname,resultcount);
	er = es.newExcelRow();
	er.addStringValue(SystemEnv.getHtmlLabelName(15863,user.getLanguage()), "Border");
	er.addStringValue("" + resultcount, "Border");
	er.addStringValue("" + resultpercent + "%", "Border");
    }%>    

<%
    Calendar today = Calendar.getInstance();
    String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
    

    int tempyear = Util.getIntValue(Util.add0(today.get(Calendar.YEAR), 4));//当前年份

	if(RecordSet.getDBType().equals("oracle")){
		sqlstr="select min(birthday) from HrmResource where (accounttype is null or accounttype=0) and  birthday is not null ";
	}else if(RecordSet.getDBType().equals("db2")){
        sqlstr="select min(birthday) from HrmResource where birthday !=''";
	}else{
		sqlstr="select min(birthday) from HrmResource where (accounttype is null or accounttype=0) and birthday is not null and birthday !=''";
	}
    
    rs.executeSql(sqlstr);
    rs.next();  
    String minworday=rs.getString(1);//年龄最大    
	
	if(!minworday.equals("")){
		int minyear = Util.getIntValue(minworday.substring(0,4));
		int yearcount = tempyear-minyear+1;//年龄

		int agenum = Util.getIntValue(agearea);
		int cyc = yearcount/agenum +1;//循环次数

		String agefrom ="";
		String ageto = "";
		linecolor=1;

		for(int i=0;i<cyc;i++){//循环列出
			int from_Y= i*agenum;
			int to_Y = (i+1)* agenum-1;
			agefrom   =(tempyear -agenum)+"-"+
						 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
						 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;		
			ageto =(tempyear)+"-"+
						 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
						 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

			if(RecordSet.getDBType().equals("oracle")){
				if(sqlwhere.equals("")){
				sqlstr="select count(*) resultcount from HrmResource  where (accounttype is null or accounttype=0) and birthday >='"+agefrom+"'  and birthday <='"+ageto+"' and birthday is not null ";		
				}else{
				sqlstr="select count(*) resultcount from HrmResource  where (accounttype is null or accounttype=0) and birthday >='"+agefrom+"'  and birthday <='"+ageto+"'  and birthday is not null "+sqlwhere;
				}
			}else if(RecordSet.getDBType().equals("db2")){
				if(sqlwhere.equals("")){
				sqlstr="select count(*) resultcount from HrmResource where birthday >='"+agefrom+"'  and birthday <='"+ageto+"' and birthday<>''  ";		
				}else{
				sqlstr="select count(*) resultcount from HrmResource where birthday >='"+agefrom+"'  and birthday <='"+ageto+"' and birthday<>''  "+sqlwhere;
				}
			}else{
				if(sqlwhere.equals("")){
				sqlstr="select count(*) resultcount from HrmResource  where (accounttype is null or accounttype=0) and birthday >='"+agefrom+"'  and birthday <='"+ageto+"' and birthday<>'' and birthday is not null ";		
				}else{
				sqlstr="select count(*) resultcount from HrmResource  where (accounttype is null or accounttype=0) and birthday >='"+agefrom+"'  and birthday <='"+ageto+"' and birthday<>'' and birthday is not null "+sqlwhere;
				}
			}
			rs.executeSql(sqlstr);
			rs.next();   
			resultcount = rs.getInt(1);
			resultpercent=(float)resultcount*100/(float)total;
			resultpercent=(float)((int)(resultpercent*100))/(float)100;
   						float resultpercentOfwidth2=0;
						resultpercentOfwidth2 = resultpercent;
						if(resultpercentOfwidth2<1&&resultpercentOfwidth2>0) resultpercentOfwidth2=1;
			%>
		<%if(!(resultpercent==0)){%> 
			<tr <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%> >
				<TD><%=from_Y%>-<%=to_Y%> <%=SystemEnv.getHtmlLabelName(15864,user.getLanguage())%> </TD>
				<TD height="100%"> 
					<%if(!(resultpercent==0)){
					String className=(resultpercent==100)?"redgraph":"greengraph";
					%>
					<TABLE height="100%" cellSpacing=0 class="<%=className%>"
					width="<%=resultpercentOfwidth2%>%">                       
					<TBODY>
					<TR>
					<TD width="100%" height="100%"><img src="/images/ArrowUpGreen.gif" width=1 height=1></td>
					</TR>
					</TBODY>
					</TABLE>   
					<%}%>
				</TD>
				<TD><%=resultcount%></TD>
				<TD><%=resultpercent%>%</TD>
			</tr>
		<%
		er = es.newExcelRow();
		er.addStringValue(from_Y + "-" + to_Y + " " + SystemEnv.getHtmlLabelName(15864,user.getLanguage()), "Border");
		er.addStringValue("" + resultcount, "Border");
		er.addStringValue("" + resultpercent + "%", "Border");
	//pie.print(out);

		if(pie==null){
			pie=TeeChartFactory.createPieChart(SystemEnv.getHtmlLabelName(15862,user.getLanguage()),550,400,PieTeeChart.SMS_LabelPercent);
		}
		labelname = Util.toScreen(from_Y+"-"+to_Y+SystemEnv.getHtmlLabelName(15864,user.getLanguage()),user.getLanguage());
//    		GraphFile.addConditionlable(labelname) ;		
//    		GraphFile.addPiclinevalues ( ""+resultcount , labelname , GraphFile.random , null  );
			pie.addSeries(labelname,resultcount);
		}
		%>
		<%		
		tempyear -= agenum;
		if(linecolor==0) linecolor=1;
		else	linecolor=0;
	}%>

<%}
   ExcelFile.setFilename(SystemEnv.getHtmlLabelName(15862,user.getLanguage()));
   ExcelFile.addSheet(SystemEnv.getHtmlLabelName(15862,user.getLanguage()), es);
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
<br>
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
 frmmain.submit();
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