<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ include file="/systeminfo/init.jsp" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<HTML>
	<HEAD>
		<LINK href="/css/Weaver.css" type="text/css" rel="STYLESHEET">
		<SCRIPT language="javascript" src="/js/weaver.js"></SCRIPT>
	</HEAD>

<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
	String imagefilename = "/images/hdReport.gif";
	String titlename = SystemEnv.getHtmlLabelName(527, user.getLanguage()) + ":&nbsp;" + SystemEnv.getHtmlLabelName(2211,user.getLanguage());
	String needfav = "1";
	String needhelp = "";
%>

<BODY>

<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:doReset(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<TABLE width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<COLGROUP>
		<COL width="10">
		<COL width="">
		<COL width="10">
	<TR>
		<TD height="10" colspan="3"></TD>
	</TR>
	<TR>
		<TD></TD>
		<TD valign="top">
			<TABLE class="Shadow">
				<TR>
					<TD valign="top">
						<FORM id="frmmain" name="frmmain" method="post" action="WorkPlanSearchResult.jsp">			  
							<TABLE class="ViewForm">
								<COLGROUP>
					                <COL width="15%">
					                <COL width="85%">
			                	<TBODY>
			                	<!--================== 标题 ==================-->			                	
								<TR>
									<TD><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
									<TD class="Field">
								  		<INPUT class="InputStyle" maxlength="100" size="30" name="planname">
								  	</TD>
								</TR>
								<TR style="height:1px;">
									<TD class="Line" colSpan="2"></TD>
								</TR>

								<!--================== 紧急程度 ==================-->
								<TR>
									<TD><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></TD>
									<TD class="Field">
							    		<SELECT name="urgentlevel">
											<OPTION value="" selected><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
											<OPTION value="1"><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></OPTION>
											<OPTION value="2"><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></OPTION>
											<OPTION value="3"><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></OPTION>
										</SELECT>
									</TD>
								</TR>
								<TR style="height:1px;">
									<TD class="Line" colSpan="2"></TD>
								</TR>
    
    							<!--================== 日程类型 ==================-->
								<TR>
									<TD><%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%></TD>
									<TD class="Field">
										<SELECT name="plantype">
											<OPTION value="" selected><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>											
											<%
									  			rs.executeSql("SELECT * FROM WorkPlanType ORDER BY displayOrder ASC");
									  			while(rs.next())
									  			{
									  		%>
									  			<OPTION value="<%= rs.getInt("workPlanTypeID") %>"><%= rs.getString("workPlanTypeName") %></OPTION>
									  		<%
									  			}
									  		%>
										</SELECT>
									</TD>
								</TR>
								<TR style="height:1px;">
									<TD class="Line" colSpan="2"></TD>
								</TR>

								<!--================== 状态 ==================-->
								<TR>
									<TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
									<TD class="Field">
										<SELECT name="planstatus">
											<OPTION value="" selected><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
											<OPTION value="0"><%=SystemEnv.getHtmlLabelName(16658,user.getLanguage())%></OPTION>
											<OPTION value="1"><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></OPTION>
											<OPTION value="2"><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></OPTION>		
										</SELECT>
									</TD>
								</TR>
								<TR style="height:1px;">
									<TD class="Line" colSpan="2"></TD>
								</TR>

								<!--================== 提交人 ==================-->
								<TR>
									<TD><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></TD>
								 	<TD class="Field">								 										 									 	
									  	<INPUT type="hidden" name="createrid" class="wuiBrowser"
									  		_displayTemplate="<A href=/hrm/resource/HrmResource.jsp?id=#b{id}>#b{name}</A>"
									  		_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp">
									</TD>
								</TR>
								<TR style="height:1px;">
									<TD class="Line" colSpan="2"></TD>
								</TR>	

								<!--================== 接收人 ==================-->
								<TR>
									<TD><%=SystemEnv.getHtmlLabelName(896,user.getLanguage())%></TD>
									<TD class="Field">
										<INPUT type=hidden name=receiveType value="1" />
										<!-- SELECT name=receiveType onchange="onChangeReceiveType()" class=InputStyle>
											<OPTION value="1" selected><%//=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></OPTION> 
											<OPTION value="5"><%//=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></OPTION> 
											<OPTION value="2" ><%//=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></OPTION> 
										</SELECT>&nbsp&nbsp-->
				 						  	<INPUT type="hidden" name="receiveID" class="wuiBrowser"
									  		_displayTemplate="<A href=/hrm/resource/HrmResource.jsp?id=#b{id}>#b{name}</A>"
									  		_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp">									
									</TD>
								</TR>
								<TR style="height:1px;">
									<TD class="Line" colSpan="2"></TD>
								</TR>

								<!--================== 开始日期  ==================-->
								<TR>
									<TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TD>
								  	<TD class="Field">
										<button type="button" class="Calendar" id="SelectBeginDate" onclick="getDate(begindatespan,begindate)"></BUTTON> 
									  	<SPAN id="begindatespan"></SPAN> 
								  		<INPUT type="hidden" name="begindate">  
								  		&nbsp;-&nbsp;&nbsp;
								  		<button type="button" class="Calendar" id="SelectEndDate" onclick="getDate(enddatespan,enddate)"></BUTTON> 
								  		<SPAN id="enddatespan"></SPAN> 
									    <INPUT type="hidden" name="enddate">
									</TD>
								</TR>
								<TR style="height:1px;">
									<TD class="Line" colSpan="2"></TD>
								</TR>	
								<!--==================  结束日期 ==================-->
								<TR>
									<TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
								  	<TD class="Field">
										<button type="button" class="Calendar" id="SelectBeginDate2" onclick="getDate(begindatespan2,begindate2)"></BUTTON> 
									  	<SPAN id="begindatespan2"></SPAN> 
								  		<INPUT type="hidden" name="begindate2">  
								  		&nbsp;-&nbsp;&nbsp;
								  		<button type="button" class="Calendar" id="SelectEndDate2" onclick="getDate(enddatespan2,enddate2)"></BUTTON> 
								  		<SPAN id="enddatespan2"></SPAN> 
									    <INPUT type="hidden" name="enddate2">
									</TD>
								</TR>
								<TR style="height:1px;">
									<TD class="Line" colSpan="2"></TD>
								</TR>	
								<%if(isgoveproj==0){%>
								<!--================== 相关客户 ==================-->
								<TR>
									<TD><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></TD>
								  	<TD class="Field">
									  	<INPUT type="hidden" name="crmids" class="wuiBrowser" _param="resourceids"
									  		_displayTemplate="<A href=/CRM/data/ViewCustomer.jsp?CustomerID=#b{id} target='_blank'>#b{name}</A>&nbsp;"
									  		_url="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp">
									</TD>		  
								</TR>
								<TR style="height:1px;">
									<TD class="Line" colSpan="2"></TD>
								</TR>
								<%}%>
								<!--================== 相关文档 ==================-->
								<TR>
									<TD><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></TD>
								  	<TD class="Field">
									  	<INPUT type="hidden" name="docids" class="wuiBrowser" _param="documentids"
									  		_displayTemplate="<A href=/docs/docs/DocDsp.jsp?id=#b{id} target='_blank'>#b{name}</A>&nbsp;"
									  		_url="/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp">
									</TD>
								</TR>
								<TR style="height:1px;">
									<TD class="Line" colSpan="2"></TD>
								</TR>
								<%if(isgoveproj==0){%>
								<!--================== 相关项目 ==================-->
								<TR>
									<TD><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></TD>
								  	<TD class="Field">
									  	<INPUT type="hidden" name="prjids" class="wuiBrowser"  _trimLeftComma="yes" _param="projectids"
									  		_displayTemplate="<A href=/proj/data/ViewProject.jsp?ProjID=#b{id} target='_blank'>#b{name}</A>&nbsp;"
									  		_url="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp">
									</TD>  		  	
								</TR>
								<TR style="height:1px;">
									<TD class="Line" colSpan="2"></TD>
								</TR>
								<%}%>
								<!--================== 相关流程 ==================-->
								<TR>
									<TD><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></TD>
								 	<TD class="Field">
									  	<INPUT type="hidden" name="requestids" class="wuiBrowser"   _param="resourceids"
									  		_displayTemplate="<A href=/workflow/request/ViewRequest.jsp?requestid=#b{id} target='_blank'>#b{name}</A>&nbsp;"
									  		_url="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp">
									</TD>
								</TR>
								<TR style="height:1px;">
									<TD class="Line" colSpan="2"></TD>
								</TR>
							</TBODY>
			  			</TABLE>
			  			</FORM>
					</TD>
				</TR>
			</TABLE>
		</TD>
		<TD></TD>
	</TR>
	<TR>
		<TD height="10" colspan="3"></TD>
	</TR>
</TABLE>

<SCRIPT language="JavaScript">

function test(option){
	
}
function doSearch() {
	if (!checkDateValid("begindate", "enddate")) {
		alert("<%=SystemEnv.getHtmlNoteName(54,user.getLanguage())%>");
		return;
	}
	document.frmmain.submit();
}

function doReset() {
    document.frmmain.reset();

	document.all("createrspan").innerHTML = "";
	document.all("createrid").value = "";

	document.all("receiveNameSpan").innerHTML = "";
	document.all("receiveID").value = "";

	document.all("begindatespan").innerHTML = "";
	document.all("begindate").value = "";

	document.all("enddatespan").innerHTML = "";
	document.all("enddate").value = "";
	
	document.all("begindatespan2").innerHTML = "";
	document.all("begindate2").value = "";

	document.all("enddatespan2").innerHTML = "";
	document.all("enddate2").value = "";

	document.all("crmspan").innerHTML = "";
	document.all("crmids").value = "";

	document.all("docspan").innerHTML = "";
	document.all("docids").value = "";

	   
	document.all("projectspan").innerHTML = "";
	document.all("prjids").value = "";

	document.all("requestspan").innerHTML = "";
	document.all("requestids").value = "";
	
}

function checkDateValid(objStartName, objEndName) {
	var dateStart = document.all(objStartName).value;
	var dateEnd = document.all(objEndName).value;

	if ((dateStart == null || dateStart == "") || (dateEnd == null || dateEnd == ""))
		return true;

	var yearStart = dateStart.substring(0,4);
	var monthStart = dateStart.substring(5,7);
	var dayStart = dateStart.substring(8,10);
	var yearEnd = dateEnd.substring(0,4);
	var monthEnd = dateEnd.substring(5,7);
	var dayEnd = dateEnd.substring(8,10);
		
	if (yearStart > yearEnd)		
		return false;
	
	if (yearStart == yearEnd) {
		if (monthStart > monthEnd)
			return false;
		
		if (monthStart == monthEnd)
			if (dayStart > dayEnd)
				return false;
	}

	return true;
}


function onChangeReceiveType()
{
	var thisValue = document.frmmain.receiveType.value;

	document.frmmain.receiveID.value = "";
	document.all("receiveNameSpan").innerText = "";

	//人力资源
	if(1 == thisValue)
	{
 		document.all("showResource").style.display = '';
 		document.all("showResource").style.visibility='visible';
	}
	else
	{
		document.all("showResource").style.display = 'none';
		document.all("showResource").style.visibility='hidden';
	}
	
	//分部
	if(5 == thisValue)
	{
 		document.all("showSubCompany").style.display = '';
 		document.all("showSubCompany").style.visibility='visible';
	}
	else
	{
		document.all("showSubCompany").style.display = 'none';
		document.all("showSubCompany").style.visibility='hidden';
	}
	
	//部门
	if(2 == thisValue)
	{
 		document.all("showDepartment").style.display = '';
 		document.all("showDepartment").style.visibility='visible';
	}
	else
	{
		document.all("showDepartment").style.display = 'none';
		document.all("showDepartment").style.visibility='hidden';
	}
}
</SCRIPT>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>