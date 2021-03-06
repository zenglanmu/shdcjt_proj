<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
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

int userId = user.getUID();
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1),_self} " ;
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
		<FORM id=weaver NAME=frmmain STYLE="margin-bottom:0" action="CarInfoOperation.jsp" method=post>
		<input type="hidden" name="operation" value="edit">
		<input  id='tempSubCompanyId' type="hidden" name="subCompanyId" value="<%=subCompanyId%>">
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
			<TD class=Field><INPUT class=inputstyle maxLength=30 size=20 name="carNo" onchange='checkinput("carNo","carNoimage")' value="<%=carNo%>"><SPAN id=carNoimage><%if(carNo.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></SPAN></TD>
        </TR>
        <TR style="height:2px"><TD class=line colspan="2"></TD></TR>
        <TR>
			<TD><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></TD>
			<TD class=Field >
            	
                <input class=wuiBrowser  value=<%=subCompanyId%> _displayText="<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(subCompanyId),user.getLanguage())%>"  _callBack="showit();"  type=hidden name=subCompanyId _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser4.jsp?rightStr=Car:Maintenance">
				
        	</TD>
        </TR>
        <TR style="height:2px"><TD class=line colspan="2"></TD></TR>
        <TR>
        	<TD><%=SystemEnv.getHtmlLabelName(17630,user.getLanguage())%></TD>
        	<TD class=Field>
          		<select name="carType" onchange='checkinput("carType","carTypeimage")'>
          			<option value="">
          			<%
          			RecordSet.executeProc("CarType_Select","");
          			while(RecordSet.next()){
          			%>
          			<option value="<%=RecordSet.getString("id")%>" <%if(carType.equals(RecordSet.getString("id"))){%>selected<%}%>><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%>
          			<%}%>
          		</select>
          		<SPAN id=carTypeimage><%if(carType.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></SPAN>
        	</TD>
        </TR>
        <TR style="height:2px"><TD class=line colspan="2"></TD></TR>
		<TR>
		    <TD><%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())%></TD>
		    <TD class=Field><INPUT class=inputstyle type=text size=20 name="usefee" onKeyPress="ItemNum_KeyPress()" 
		    onBlur="checknumber1(this);checkinput('usefee','usefeespan')" value="<%=usefee%>">
		    <SPAN id=usefeespan><%if("".equals(usefee)){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></SPAN><%=SystemEnv.getHtmlLabelName(17647,user.getLanguage())%></TD>
		</TR>
        <TR style="height:2px"><TD class=line colspan="2"></TD></TR>
        <TR>
        	<TD><%=SystemEnv.getHtmlLabelName(20318,user.getLanguage())%></TD>
        	<TD class=Field><INPUT class=inputstyle maxLength=30 size=20 name="factoryNo" onchange='checkinput("factoryNo","factoryNoimage")' value="<%=factoryNo%>"><SPAN id=factoryNoimage><%if(factoryNo.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></SPAN></TD>
        </TR>
        <TR style="height:2px"><TD class=line colspan="2"></TD></TR>
        <TR>
        	<TD><%=SystemEnv.getHtmlLabelName(20320,user.getLanguage())%></TD>
        	<TD class=Field>
        		<INPUT class=inputstyle maxLength=18 size=20 name="price" value="<%=price%>" onKeyPress="ItemCount_KeyPress()" onchange="checkcount('price')">(RMB����<%=SystemEnv.getHtmlLabelName(20321,user.getLanguage())%>)
        	</TD>
        </TR>
        <TR style="height:2px"><TD class=line colspan="2"></TD></TR>
        <TR>
        	<TD><%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%></TD>
        	<TD class=Field>
				<input name="buyDate" type="hidden" class=wuiDate value="<%=buyDate%>" ></input> 
        	</TD>
        </TR>
        <TR style="height:2px"><TD class=line colspan="2"></TD></TR>
        <TR>
        	<TD><%=SystemEnv.getHtmlLabelName(20322,user.getLanguage())%></TD>
       		<TD class=Field><INPUT class=inputstyle maxLength=30 size=20 name="engineNo" value="<%=engineNo%>"></TD>
        </TR>
        <TR style="height:2px"><TD class=line colspan="2"></TD></TR>
        <TR>
        	<TD><%=SystemEnv.getHtmlLabelName(17649,user.getLanguage())%></TD>
        	<TD class=Field>
			
				<input class=wuiBrowser  _displayText="<%=ResourceComInfo.getResourcename(driver)%>"  type=hidden name=driver _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" value=<%=driver%>>
				
			</TD>
        </TR>
        <TR style="height:2px"><TD class=line colspan="2"></TD></TR>
        <TR>
        	<TD><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TD>
        	<TD class=Field><INPUT class=inputstyle maxLength=300 size=60 name="remark" value="<%=remark%>"></TD>
        </TR>
        <TR style="height:2px"><TD class=line colspan="2"></TD></TR>
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
sub onShowSubcompany()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser4.jsp?selectedids="&weaver.subCompanyId.value&"&rightStr=Car:Maintenance")
	issame = false
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = weaver.subCompanyId.value then
		issame = true
	end if
	subcompanyspan.innerHtml = id(1)
	weaver.subCompanyId.value=id(0)
	else
	subcompanyspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	weaver.subCompanyId.value=""
	end if
	end if
end sub
</script>
<script language=javascript>
function showit(){
	document.getElementById("tempSubCompanyId").name='temps';
};

function doSave(obj){
	if(check_form(document.frmmain,'carNo,carType,usefee,factoryNo,subCompanyId')){
		obj.disabled = true;
		document.frmmain.submit();
	}
}
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
</html>