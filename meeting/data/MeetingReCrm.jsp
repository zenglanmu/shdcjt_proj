<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>

<%
String userid = ""+user.getUID();
String logintype = ""+user.getLogintype();

char flag=Util.getSeparator() ;
String ProcPara = "";

String meetingid = Util.null2String(request.getParameter("meetingid"));
String recorderid = Util.null2String(request.getParameter("recorderid"));

RecordSet.executeProc("Meeting_Member2_SelectByID",recorderid);
RecordSet.next();
String isattend=Util.null2String(RecordSet.getString("isattend"));
String bookroom=Util.null2String(RecordSet.getString("bookroom"));
String roomstander=Util.null2String(RecordSet.getString("roomstander"));
String bookticket=Util.null2String(RecordSet.getString("bookticket"));

String ticketstander=Util.null2String(RecordSet.getString("ticketstander"));
String othermember=Util.null2String(RecordSet.getString("othermember"));
String begindate=Util.null2String(RecordSet.getString("begindate"));
String begintime=Util.null2String(RecordSet.getString("begintime"));

String enddate=Util.null2String(RecordSet.getString("enddate"));
String endtime=Util.null2String(RecordSet.getString("endtime"));
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
int membercrmrows=0;
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSave(),_self} " ;
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

<FORM id=weaver name=weaver action="/meeting/data/MeetingReCrmOperation.jsp" method=post >
<input class=inputstyle type="hidden" name="method" value="edit">
<input class=inputstyle type="hidden" name="meetingid" value="<%=meetingid%>">
<input class=inputstyle type="hidden" name="recorderid" value="<%=recorderid%>">
<input class=inputstyle type="hidden" name="membercrmrows" value="0">
	  <TABLE class=viewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></TH>
          </TR>
        <TR class=spacing>
          <TD class=line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2187,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=radio name="isattend" value="1" <%if(isattend.equals("1") || isattend.equals("") ){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><input class=inputstyle type=radio name="isattend" value="2" <%if(isattend.equals("2")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><input class=inputstyle type=radio name="isattend" value="3" <%if(isattend.equals("3")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2188,user.getLanguage())%></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2186,user.getLanguage())%></TD>
          <TD class=Field> <BUTTON class=Calendar onclick="getDate(BeginDatespan,begindate)"></BUTTON> <SPAN id=BeginDatespan ><%=begindate%></SPAN> <input class=inputstyle type="hidden" name="begindate" value="<%=begindate%>">-<button class=Clock onclick="onShowTime(BeginTimespan,begintime)"></button><span id="BeginTimespan"><%=begintime%></span><input class=inputstyle type=hidden name="begintime" value="<%=begintime%>"></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2185,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=radio name="bookroom" value="1" <%if(bookroom.equals("1")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><input class=inputstyle type=radio name="bookroom" value="2" <%if(bookroom.equals("2") || bookroom.equals("")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>&nbsp<input class=inputstyle  size=10 name="roomstander" value="<%=roomstander%>"></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2184,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=radio name="bookticket" value="1" <%if(bookticket.equals("1")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><input class=inputstyle type=radio name="bookticket" value="2" <%if(bookticket.equals("2") || bookticket.equals("")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2183,user.getLanguage())%></TD>
          <TD class=Field> <BUTTON class=Calendar onclick="getDate(EndDatespan,enddate)"></BUTTON> <SPAN id=EndDatespan ><%=enddate%></SPAN> <input class=inputstyle type="hidden" name="enddate" value="<%=enddate%>">-<button class=Clock onclick="onShowTime(EndTimespan,endtime)"></button><span id="EndTimespan"><%=endtime%></span><input class=inputstyle type=hidden name="endtime" value="<%=endtime%>"></TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2182,user.getLanguage())%></TD>
          <TD class=Field>
		  <%=SystemEnv.getHtmlLabelName(2180,user.getLanguage())%><input class=inputstyle type=radio name="ticketstander" value="1" <%if(ticketstander.equals("1")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2174,user.getLanguage())%><input class=inputstyle type=radio name="ticketstander" value="2" <%if(ticketstander.equals("2")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2175,user.getLanguage())%><input class=inputstyle type=radio name="ticketstander" value="3" <%if(ticketstander.equals("3")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2176,user.getLanguage())%>
		  <br>
		  <%=SystemEnv.getHtmlLabelName(2181,user.getLanguage())%><input class=inputstyle type=radio name="ticketstander" value="4" <%if(ticketstander.equals("4")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2177,user.getLanguage())%><input class=inputstyle type=radio name="ticketstander" value="5" <%if(ticketstander.equals("5")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2178,user.getLanguage())%><input class=inputstyle type=radio name="ticketstander" value="6" <%if(ticketstander.equals("6")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2179,user.getLanguage())%>
		  </TD>
        </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        </TBODY>
	  </TABLE>

	  <TABLE class=viewForm>
        <TBODY>
        <TR class=title>
            <TH><%=SystemEnv.getHtmlLabelName(2106,user.getLanguage())%></TH>
            <Td align=right>
				<A href="#" onclick=javascript:addRow();><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></A>
				<A href="#" onclick=javascript:if(isdel()){deleteRow1();}><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A>	
			</Td>
          </TR>
        <TR class=spacing>
          <TD class=line1 colspan=2></TD></TR>
        <TR>
          <TD colspan=2> 
		  
	  <TABLE class=ListStyle cellspacing=1 cellpadding=1  cols=7 id="oTable">

        <TBODY>
		<tr class=Header>
			<th width=4%>&nbsp</th>
			<th><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></th>
			<th><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></th>
			<th><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></th>
			<th><%=SystemEnv.getHtmlLabelName(1916,user.getLanguage())%></th>
			<th><%=SystemEnv.getHtmlLabelName(422,user.getLanguage())%></th>
			<th><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></th>
		</tr>
        <TR class=Line><TD colspan="87" ></TD></TR> 
<%
RecordSet.executeProc("Meeting_MemberCrm_SelectAll",recorderid);
while(RecordSet.next()){
%>
		<tr>
			<td class=Field><input class=inputstyle type='checkbox' name='check_node' value='0'></td>
			<td class=Field>
				<input class=inputstyle type='input' style=width:99%  name='name_<%=membercrmrows%>' value="<%=RecordSet.getString("name")%>">
			</td>
			<td class=Field>
				<select class=inputstyle name='sex_<%=membercrmrows%>'>
				  <option value="1" <%if(RecordSet.getString("sex").equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%>
				  <option value="2" <%if(RecordSet.getString("sex").equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%>
				</SELECT>
			</td>
			<td class=Field>
				<input class=inputstyle type='input' style=width:99%  name='occupation_<%=membercrmrows%>' value="<%=RecordSet.getString("occupation")%>">
			</td>
			<td class=Field>
				<input class=inputstyle type='input' style=width:99%  name='tel_<%=membercrmrows%>' value="<%=RecordSet.getString("tel")%>">
			</td>
			<td class=Field>
				<input class=inputstyle type='input' style=width:99%  name='handset_<%=membercrmrows%>' value="<%=RecordSet.getString("handset")%>">
			</td>
			<td class=Field>
				<input class=inputstyle type='input' style=width:99%  name='desc_<%=membercrmrows%>' value="<%=RecordSet.getString("desc_n")%>">
			</td>
		</tr>
<%
membercrmrows = membercrmrows +1;
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
<td height="10" colspan="3"></td>
</tr>
</table>
<script language="JavaScript" src="/js/addRowBg.js" >   
</script>  
<script language=javascript>  
function submitData() {
 window.parent.close();
}
rowindex = "<%=membercrmrows%>";
var rowColor="" ;
function addRow()
{
	ncol = oTable.cols;
	rowColor = getRowBg();
	oRow = oTable.insertRow();
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
				var sHtml = "<input class=inputstyle type='input' style=width:99%  name='name_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<select class=inputstyle name='sex_<%=membercrmrows%>'><option value='1'>ÄÐ				  <option value='2'>Å®	</SELECT>";
				//ÎÄ×Ö

				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle type='input' style=width:99%  name='occupation_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;	
			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle type='input' style=width:99%  name='tel_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;	
			case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle type='input' style=width:99%  name='handset_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;	
			case 6: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle type='input' style=width:99%  name='desc_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;	
	
		}
	}
	rowindex = rowindex*1 +1;
	
}

function deleteRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
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

function doSave(){
	if(check_form(document.weaver,'<%=needcheck%>')){
		document.weaver.membercrmrows.value=rowindex;
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

</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
</html>
