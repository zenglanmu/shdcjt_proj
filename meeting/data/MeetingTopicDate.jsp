<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />

<%
String userid = ""+user.getUID();
String logintype = ""+user.getLogintype();

char flag=Util.getSeparator() ;
String ProcPara = "";

String recorderid = Util.null2String(request.getParameter("recorderid"));
String meetingid = Util.null2String(request.getParameter("meetingid"));
    
RecordSet.executeSql("select * from meeting_topic where id="+recorderid) ;
if(RecordSet.next())
    meetingid=RecordSet.getString("meetingid") ;

String meetingdate="" ;
RecordSet.executeSql("select * from meeting where id="+meetingid) ;
if(RecordSet.next())
    meetingdate=RecordSet.getString("begindate") ;
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(2108,user.getLanguage());
String needfav ="1";
String needhelp ="";

String needcheck="";
int decisionrows=0;

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:submitData(),_self} " ;
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

<FORM id=weaver name=weaver action="/meeting/data/MeetingTopicDateOperation.jsp" method=post >
<input class=inputstyle type="hidden" name="method" value="edit">
<input class=inputstyle type="hidden" name="meetingid" value="<%=meetingid%>">
<input class=inputstyle type="hidden" name="recorderid" value="<%=recorderid%>">
<input class=inputstyle type="hidden" name="decisionrows" value="0">
	  <TABLE class=viewForm>
        <TBODY>
        <TR class=title>
            <TH><%=SystemEnv.getHtmlLabelName(2192,user.getLanguage())%></TH>
            <Td align=right>
				<A href="#" onclick=javascript:addRow();><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></A>
				<A href="#" onclick=javascript:if(isdel()){deleteRow1();}><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A>	
			</Td>
          </TR>
        <TR class=spacing>
          <TD class=Sep1 colspan=2></TD></TR>
        <TR>
          <TD colspan=2> 
		  
	  <TABLE class=ListStyle cellspacing=1 cellpadding=1  cols=5 id="oTable">

        <TBODY>
		<tr class=Header>
			<th width=4%>&nbsp</th>
			<th width=24%><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></th>
			<th width=24%><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></th>
			<th width=24%><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></th>
			<th width=24%><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></th>
		</tr>
		<TR style="height: 1px;"><TD class=Line colspan=5 style="margin: 0px;padding: 0px;"></TD></TR> 
<%
RecordSet.executeProc("Meeting_TopicDate_SelectAll",meetingid+flag+recorderid);
while(RecordSet.next()){
%>
		<tr>
			<td class=Field><input class=inputstyle type='checkbox' name='check_node' value='0'></td>
			<td class=Field>
				<button class=Clock onclick="getDate(begindate_<%=decisionrows%>span,begindate_<%=decisionrows%>)"></button><span id="begindate_<%=decisionrows%>span"><%=RecordSet.getString("begindate")%></span><input class=inputstyle type=hidden name="begindate_<%=decisionrows%>" value="<%=RecordSet.getString("begindate")%>">
			</td>
			<td class=Field>
				<button class=Clock onclick="onShowTime(BeginTime_<%=decisionrows%>span,begintime_<%=decisionrows%>)"></button><span id="BeginTime_<%=decisionrows%>span"><%=RecordSet.getString("begintime")%></span><input class=inputstyle type=hidden name="begintime_<%=decisionrows%>" value="<%=RecordSet.getString("begintime")%>">
			</td>
			<td class=Field>
				<button class=Clock onclick="getDate(enddate_<%=decisionrows%>span,enddate_<%=decisionrows%>)"></button><span id="enddate_<%=decisionrows%>span"><%=RecordSet.getString("enddate")%></span><input class=inputstyle type=hidden name="enddate_<%=decisionrows%>" value="<%=RecordSet.getString("enddate")%>">
			</td>
			<td class=Field>
				<button class=Clock onclick="onShowTime(EndTime_<%=decisionrows%>span,endtime_<%=decisionrows%>)"></button><span id="EndTime_<%=decisionrows%>span"><%=RecordSet.getString("endtime")%></span><input class=inputstyle type=hidden name="endtime_<%=decisionrows%>" value="<%=RecordSet.getString("endtime")%>">
			</td>
		</tr>
<%
decisionrows = decisionrows +1;
}
%>
        </TBODY>
	  </TABLE>		  

</FORM>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="5"></td>
</tr>
</table>
<script language="JavaScript" src="/js/addRowBg.js" >   
</script>  
<script language=javascript>  
function submitData() {
window.parent.close();
}
var rowindex = "<%=decisionrows%>";
var rowColor="" ;
function addRow()
{
    //var oTable=document.getElementById("oTable");
    //alert(oTable);
	//var ncol = oTable.cols;
	//var oRow = oTable.insertRow();
	//alert(12);
	rowColor = getRowBg();
	
	var htmlstr="";
	htmlstr=htmlstr+"<tr>";
	htmlstr=htmlstr+"<td style='background:"+rowColor+"'><input class=inputstyle type='checkbox' name='check_node' value='0'></td>";
	htmlstr=htmlstr+"<td style='background:"+rowColor+"'><button type='button' class=Clock onclick=getDate(begindate_"+rowindex+"span,begindate_"+rowindex+")></button><span id='begindate_"+rowindex+"span'></span><input class=inputstyle type=hidden name='begindate_"+rowindex+"'></td>";
	htmlstr=htmlstr+"<td style='background:"+rowColor+"'><button type='button' class=Clock onclick=onShowTime(BeginTime_"+rowindex+"span,begintime_"+rowindex+")></button><span id='BeginTime_"+rowindex+"span'></span><input class=inputstyle type=hidden name='begintime_"+rowindex+"'></td>";
	htmlstr=htmlstr+"<td style='background:"+rowColor+"'><button type='button' class=Clock onclick=getDate(enddate_"+rowindex+"span,enddate_"+rowindex+")></button><span id='enddate_"+rowindex+"span'></span><input class=inputstyle type=hidden name='enddate_"+rowindex+"'></td>";
	htmlstr=htmlstr+"<td style='background:"+rowColor+"'><button type='button' class=Clock onclick=onShowTime(EndTime_"+rowindex+"span,endtime_"+rowindex+")></button><span id='EndTime_"+rowindex+"span'></span><input class=inputstyle type=hidden name='endtime_"+rowindex+"'></td>";
	htmlstr=htmlstr+"</tr>";
	
	jQuery("#oTable tbody").append(htmlstr);
	rowindex = rowindex*1 +1;
	
	/*
	alert(rowColor);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell();
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox' name='check_node' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<button class=Clock onclick=getDate(begindate_"+rowindex+"span,begindate_"+rowindex+")></button><span id='begindate_"+rowindex+"span'></span><input class=inputstyle type=hidden name='begindate_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<button class=Clock onclick=onShowTime(BeginTime_"+rowindex+"span,begintime_"+rowindex+")></button><span id='BeginTime_"+rowindex+"span'></span><input class=inputstyle type=hidden name='begintime_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<button class=Clock onclick=getDate(enddate_"+rowindex+"span,enddate_"+rowindex+")></button><span id='enddate_"+rowindex+"span'></span><input class=inputstyle type=hidden name='enddate_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 4:
				var oDiv = document.createElement("div");
				var sHtml = "<button class=Clock onclick=onShowTime(EndTime_"+rowindex+"span,endtime_"+rowindex+")></button><span id='EndTime_"+rowindex+"span'></span><input class=inputstyle type=hidden name='endtime_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;

		}
	}
	rowindex = rowindex*1 +1;
    */
}

function deleteRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 1;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				oTable.deleteRow(rowsum1);
			}
			rowsum1 -=1;
		}

	}
}

function doSave(savemethod){
    if(savemethod==1) savemethod="edit";
	if(check_form(document.weaver,'<%=needcheck%>')){
		document.weaver.method.value=savemethod;
		document.weaver.decisionrows.value=rowindex;
		document.weaver.submit();
	}
}
</script>
<script language=vbs>

sub onShowHrm(spanname,inputename,needinput)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	document.all(spanname).innerHtml= "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	document.all(inputename).value=id(0)
	else 
	if needinput = "1" then
	document.all(spanname).innerHtml= "<IMG src='/images/BacoError.gif' align=absMiddle>"
	else
	document.all(spanname).innerHtml= ""
	end if
	document.all(inputename).value=""
	end if
	end if
end sub


sub onShowMHrm(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&tmpids)
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all(inputename).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&resourceids&">"&resourcename&"</a>&nbsp"
					document.all(spanname).innerHtml = sHtml
					
				else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
				end if
end sub

sub onShowMCrm(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="&tmpids)
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all(inputename).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href=/CRM/data/ViewCustomer.jsp?CustomerID="&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href=/CRM/data/ViewCustomer.jsp?CustomerID="&resourceids&">"&resourcename&"</a>&nbsp"
					document.all(spanname).innerHtml = sHtml
					
				else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
				end if
end sub
sub onShowDoc(spanname,inputename)
	id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if Not isempty(id) then
		document.all(spanname).innerHtml = "<a href='/docs/docs/DocDsp.jsp?id="&id(0)&"'>"&id(1)&"</a>"
		document.all(inputename).value=id(0)&""
	end if	
end sub
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
</html>

