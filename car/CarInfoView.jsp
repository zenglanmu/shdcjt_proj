<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CarTypeComInfo" class="weaver.car.CarTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver.js"></script>

<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(920,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%
String carNo = "";
String carType = "";
String factoryNo = "";
String price = "";
String buyDate = "";
String engineNo = "";
String driver = "";
String remark = "";
String subCompanyId = "";
String usefee = "";
String id = Util.null2String(request.getParameter("id"));
int identifier=0;
int fg=0;
if(!(request.getParameter("flag")==null)){
    identifier=Integer.parseInt(Util.null2String(request.getParameter("flag")));
}
if(!(request.getParameter("fg")==null)){
    fg=Integer.parseInt(Util.null2String(request.getParameter("fg")));
}
if(!id.equals("")){
	String sql = "select * from CarInfo where id="+id;
	RecordSet.executeSql(sql);
	if(RecordSet.next()){
		carNo = RecordSet.getString("carNo");
		carType = RecordSet.getString("carType");
		factoryNo = RecordSet.getString("factoryNo");
		price = RecordSet.getString("price");
		buyDate = RecordSet.getString("buyDate");
		engineNo = RecordSet.getString("engineNo");
		driver = RecordSet.getString("driver");
		remark = RecordSet.getString("remark");
		subCompanyId = RecordSet.getString("subCompanyId");
		usefee = RecordSet.getString("usefee");
	}
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(19018,user.getLanguage())+",CarUseInfoTwo.jsp?fg="+fg+"&&carId="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(identifier==1&&fg==0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",CarSearchResult.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}else if(identifier==1&&fg==1){
 RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",CarInfoMaintenance.jsp,_self} " ;
 RCMenuHeight += RCMenuHeightStep ;   
}
else  if(identifier==2){	
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",CarUseInfoTwo.jsp?fg="+fg+"&carId="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
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
		<FORM id=weaver NAME=frmmain STYLE="margin-bottom:0" action="CarInfoEdit.jsp" method=post>
		<input type="hidden" name="id" value="<%=id%>">
		<table width=100% class=ViewForm>
		<COLGROUP>
		<COL width="20%">
		<COL width="80%">
		<TBODY>
		<TR class=title>
			<TH><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
		</TR>
        <TR class=spacing><TD class=line1 colSpan=2></TD></TR>
        <TR>
			<TD><%=SystemEnv.getHtmlLabelName(20319,user.getLanguage())%></TD>
			<TD class=Field><%=carNo%></TD>
        </TR>
        <TR><TD class=line colspan="2"></TD></TR>
        <TR>
			<TD><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></TD>
			<TD class=Field><%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(subCompanyId),user.getLanguage())%></TD>
        </TR>
        <TR><TD class=line colspan="2"></TD></TR>
        <TR>
        	<TD><%=SystemEnv.getHtmlLabelName(17630,user.getLanguage())%></TD>
        	<TD class=Field><%=CarTypeComInfo.getCarTypename(carType)%></TD>
        </TR>
        <TR><TD class=line colspan="2"></TD></TR>
		<TR>
		    <TD><%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(17647,user.getLanguage())%>)</TD>
		    <TD class=Field>
		    <%=usefee%></TD>
		</TR>
        <TR><TD class=line colspan="2"></TD></TR>
        <TR>
        	<TD><%=SystemEnv.getHtmlLabelName(20318,user.getLanguage())%></TD>
        	<TD class=Field><%=factoryNo%></TD>
        </TR>
        <TR><TD class=line colspan="2"></TD></TR>
        <TR>
        	<TD><%=SystemEnv.getHtmlLabelName(20320,user.getLanguage())%>(RMB£¤)</TD>
        	<TD class=Field><%=price%></TD>
        </TR>
        <TR><TD class=line colspan="2"></TD></TR>
        <TR>
        	<TD><%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%></TD>
        	<TD class=Field><%=buyDate%></TD>
        </TR>
        <TR><TD class=line colspan="2"></TD></TR>
        <TR>
        	<TD><%=SystemEnv.getHtmlLabelName(20322,user.getLanguage())%></TD>
       		<TD class=Field><%=engineNo%></TD>
        </TR>
        <TR><TD class=line colspan="2"></TD></TR>
        <TR>
        	<TD><%=SystemEnv.getHtmlLabelName(17649,user.getLanguage())%></TD>
        	<TD class=Field><%=ResourceComInfo.getResourcename(driver)%></TD>
        </TR>
        <TR><TD class=line colspan="2"></TD></TR>
        <TR>
        	<TD><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TD>
        	<TD class=Field><%=remark%></TD>
        </TR>
        <TR><TD class=line colspan="2"></TD></TR>
		</TABLE>
		</FORM>
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
sub getBuyDate()
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	document.all("buyDateSpan").innerHtml= returndate
	document.all("buyDate").value=returndate
end sub
sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
		if id(0)<> "" then
			driverSpan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
			frmmain.driver.value=id(0)
		else
			driverSpan.innerHtml = ""
			frmmain.driver.value=""
		end if
	end if
end sub
</script>
<script language=javascript>
function doEdit(){
	document.frmmain.submit();
}
</script>
</body>
</html>