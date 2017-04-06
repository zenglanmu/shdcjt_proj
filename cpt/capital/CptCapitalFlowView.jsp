<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String capitalid = request.getParameter("capitalid");


if(!HrmUserVarify.checkUserRight("CptCapital:FlowView", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}

String sql="";
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String resourceid = Util.null2String(request.getParameter("resourceid"));
String stateid = Util.null2String(request.getParameter("stateid"));
String fromdate = Util.null2String(request.getParameter("fromdate"));
String todate = Util.null2String(request.getParameter("todate"));

int ishead = 0 ;

if(! sqlwhere1.equals("")) {
	sql = sqlwhere1 ;
	ishead = 1 ;
}

if(! departmentid.equals("")) {
	if(ishead == 0) {
		sql += " where usedeptid = " + departmentid ;
		ishead = 1;
	}
	else sql += " and usedeptid = " + departmentid ;
}

if(! resourceid.equals("")) {
	if(ishead == 0) {
		sql += " where useresourceid = " + resourceid ;
		ishead = 1;
	}
	else sql += " and useresourceid = " + resourceid ;
}

if(! stateid.equals("")) {
	if(ishead == 0) {
		sql += " where usestatus = " + stateid ;
		ishead = 1;
	}
	else sql += " and usestatus = " + stateid ;
}

if(! fromdate.equals("")) {
	if(ishead == 0) {
		sql += " where usedate >= '" + fromdate + "' " ;
		ishead = 1;
	}
	else sql += " and usedate >= '" + fromdate + "' " ;
}

if(! todate.equals("")) {
	if(ishead == 0) {
		sql += " where usedate <= '" + todate + "' " ;
		ishead = 1;
	}
	else sql += " and usedate <= '" + todate + "' " ;
}

if(! capitalid.equals("")) {
	if(ishead == 0) {
		sql += " where capitalid = " + capitalid ;
		ishead = 1;
	}
	else sql += " and capitalid = " + capitalid ;
}

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(1501,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=frmain name=frmain action="CptCapitalFlowView.jsp" method=post>
<input type="hidden" id=sqlwhere1 name="sqlwhere1" value="<%=sqlwhere1%>">
<input type="hidden" id=capitalid name="capitalid" value="<%=capitalid%>">

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
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

			<table class=ViewForm>
			  <colgroup> 
			  <col width="7%"> <col width="20%"> <col width="7%"> <col width="10%"> 
			  <col width="7%">  <col width="10%"> <col width="10%"> <col width="29%"> 
			  <tbody> 
			   <tr> 
				  <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
				<td class=Field><BUTTON class=Browser type="button" id=SelectDepartmentID onClick="onShowDepartmentID()"></BUTTON> 
				  <span id=departmentidspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></span> 
				<INPUT class=saveHistory id=departmentid type=hidden name=departmentid value="<%=departmentid%>"></td>
				<td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
				<td class=Field><BUTTON class=Browser type="button" id=SelectResourceID onClick="onShowResourceID()"></BUTTON> 
				  <span id=resourceidspan><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></span> 
				  <INPUT class=saveHistory id=resourceid type=hidden name=resourceid value="<%=resourceid%>"></td>
				<td><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
				<td class=Field><BUTTON class=Browser type="button" id=SelectStateID onClick="onShowStateID()"></BUTTON> 
				  <span id=stateidspan><%=Util.toScreen(CapitalStateComInfo.getCapitalStatename(stateid),user.getLanguage())%></span> 
				  <INPUT class=saveHistory id=stateid type=hidden name=stateid value="<%=stateid%>"></td>
			   <td><%=SystemEnv.getHtmlLabelName(1394,user.getLanguage())%></td>
				<td class=Field><button class=calendar type="button" id=SelectDate onClick=gettheDate(fromdate,fromdatespan)></button>&nbsp; 
				  <span id=fromdatespan ><%=fromdate%></span> -&nbsp;&nbsp;<button class=calendar type="button" 
				  id=SelectDate2 onClick="gettheDate(todate,todatespan)"></button>&nbsp; <SPAN id=todatespan><%=todate%></span> 
				  <input type="hidden" id=fromdate name="fromdate" value="<%=fromdate%>">
				  <input type="hidden" id=todate name="todate" value="<%=todate%>">
				</td>
			  </tr>
			  <TR style="height:1px"><TD class=Line colSpan=8></TD></TR> 
			  </tbody> 
			</table>

			<TABLE class=ListStyle cellspacing="1">
			  <COLGROUP>
			  <COL width="12%">
			  <COL width="12%">
			  <COL width="12%">
			  <COL width="8%">
			  <COL width="8%">
			  <COL width="8%">
			  <COL width="20%">
              <COL width="20%">
			  <TBODY>
			<BR>  
			<TR class=Header>
				<TH colSpan=8><A HREF="CptCapital.jsp?id=<%=capitalid%>"><%=Util.toScreen(CapitalComInfo.getCapitalname(capitalid),user.getLanguage())%></A></TH>
			</TR>
			  <TR class=Header>
				<TD><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TD>
				<TD><%=SystemEnv.getHtmlLabelName(1394,user.getLanguage())%></TD>
				<TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
				<TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
				<TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
				<TD><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></TD>
				<TD><%=SystemEnv.getHtmlLabelName(1395,user.getLanguage())%></TD>
                <TD><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TD>
			  </TR>
			 
			<%
			sql = "select * from CptUseLog "+sql +" order by id desc";
			rs.execute(sql);   
			int needchange = 0;
				  while(rs.next()){
					int  id = rs.getInt("id");
					//增加编号项
					//其它项都有可能为空,编号项提供链接
					String  tempid = Util.add0(id,10);
					String	usedate=Util.toScreen(rs.getString("usedate"),user.getLanguage());
					String	usedeptid=rs.getString("usedeptid");
					String  useresourceid = rs.getString("useresourceid");
					String  usestatus = rs.getString("usestatus");
					String  usecount = Util.toScreen(rs.getString("usecount"),user.getLanguage());
					String  useaddress = Util.toScreen(rs.getString("useaddress"),user.getLanguage());
                    String  remark = Util.toScreen(rs.getString("remark"),user.getLanguage());
				   try{
					if(needchange ==0){
						needchange = 1;
			%>
			  <TR class=datalight>
			  <%
				}else{
					needchange=0;
			  %><TR class=datadark>
			  <%  	}
			  %>
				  <TD><A HREF="CptCapitalFlowViewDetail.jsp?id=<%=""+id%>"><%=tempid%></A></TD>
				  <TD><%=usedate%></TD>
				   <TD><%=Util.toScreen(DepartmentComInfo.getDepartmentname(usedeptid),user.getLanguage())%> </TD>
				   <TD><%=Util.toScreen(ResourceComInfo.getResourcename(useresourceid),user.getLanguage())%></TD>
				   <TD>
						<% if(usestatus.equals("-7")) {%>
						<%=SystemEnv.getHtmlLabelName(1385,user.getLanguage())%>
						<%} else if(usestatus.equals("-6")) {%>
						<%=SystemEnv.getHtmlLabelName(1381,user.getLanguage())%>
						<%} else if(usestatus.equals("-5")) {%>
						<%=SystemEnv.getHtmlLabelName(1377,user.getLanguage())%>
						<%} else if(usestatus.equals("-4")) {%>
						<%=SystemEnv.getHtmlLabelName(1376,user.getLanguage())%>
						<%} else if(usestatus.equals("-3")) {%>
						<%=SystemEnv.getHtmlLabelName(1396,user.getLanguage())%>
						<%} else if(usestatus.equals("-2")) {%>
						<%=SystemEnv.getHtmlLabelName(1397,user.getLanguage())%>
						<%} else if(usestatus.equals("-1")) {%>
						<%=SystemEnv.getHtmlLabelName(1398,user.getLanguage())%>
						<%} else if(usestatus.equals("0")) {%>
						<%=SystemEnv.getHtmlLabelName(1384,user.getLanguage())%>
						<%} else if(usestatus.equals("1")) {%>
						<%=SystemEnv.getHtmlLabelName(1375,user.getLanguage())%> 
						<%} else if(usestatus.equals("2")) {%>
						<%=SystemEnv.getHtmlLabelName(160,user.getLanguage())%> 
						<%} else if(usestatus.equals("3")) {%>
						<%=SystemEnv.getHtmlLabelName(1379,user.getLanguage())%> 
						<%} else if(usestatus.equals("4")) {%>
						<%=SystemEnv.getHtmlLabelName(1382,user.getLanguage())%> 
						<%} else if(usestatus.equals("5")) {%>
						<%=SystemEnv.getHtmlLabelName(1386,user.getLanguage())%> 
						<%} else{%>
						<%=Util.toScreen(CapitalStateComInfo.getCapitalStatename(usestatus),user.getLanguage())%>
						<%}%>
				   </TD>
				   <TD><%=usecount%></TD>
				   <TD><%=useaddress%></TD>
                   <TD><%=remark%></TD>
				
			  </TR>
			<%
				  }catch(Exception e){
					System.out.println(e.toString());
				  }
				}
			%>  
			 </TBODY>
			 </TABLE>

		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
</table>

</FORM>
<script language="javascript">
function onShowResourceID(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (data!=null){
		if (data.id != ""){
			jQuery("#resourceidspan").html("<A href='HrmResource.jsp?id="+data.id+"'>"+data.name+"</A>");
			jQuery("input[name=resourceid]").val(data.id);
		}else {
			jQuery("#resourceidspan").html("");
			jQuery("input[name=resourceid]").val("");
		}
	}
}

 function onShowDepartmentID(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+jQuery("input[name=departmentid").val());
	issame = false; 
	if (data!=null){
		if (data.id != ""){
			if (data.id  == jQuery("input[name=departmentid]").val()){
				issame = true; 
			}
			jQuery("#departmentidspan").html(data.name);
			jQuery("input[name=departmentid]").val(data.id);
		}else{
			jQuery("#departmentidspan").html("");
			jQuery("input[name=departmentid]").val("");
		}
	}
 }

function onShowStateID(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalStateBrowser.jsp?from=flowview");
	if (data!=null){
		if (data.id != ""){
			jQuery("#stateidspan").html(data.name);
			jQuery("input[name=stateid]").val(data.id);
		}else {
			jQuery("#stateidspan").html("");
			jQuery("input[name=stateid]").val("");
		}
	}
}

 function onSubmit()
{
	frmain.submit();
}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
