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
String method=Util.null2String(request.getParameter("method"));
if(method.equals("empty"))
{
	 isattend="";
	 bookroom = "";
	 roomstander = "";
	 bookticket = "";
	 ticketstander = "";
	 othermember = "";
	 begindate = "";
	 begintime = "";
	 enddate = "";
	 endtime = "";
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(2108,user.getLanguage());
String needfav ="1";
String needhelp ="";

int topicrows=0;
%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:weaver.submit(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:onClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.parent.close(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=weaver name=weaver action="/meeting/data/MeetingReHrmOperation.jsp" method=post >
<input type="hidden" name="method" value="edit">
<input type="hidden" name="meetingid" value="<%=meetingid%>">
<input type="hidden" name="recorderid" value="<%=recorderid%>">
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

	
	
	  <TABLE class=viewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></TH>
          </TR>
        <TR style="height: 1px;">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2187,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=radio name="isattend" value="1" <%if(isattend.equals("1") || isattend.equals("") ){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><INPUT type=radio name="isattend" value="2" <%if(isattend.equals("2")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><INPUT type=radio name="isattend" value="3" <%if(isattend.equals("3")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2188,user.getLanguage())%></TD>
        </TR>   
        <TR style="height: 1px;">
          <TD class=Line colSpan=2></TD></TR>
        <TR style="height: 1px;">
          <TD><%=SystemEnv.getHtmlLabelName(2186,user.getLanguage())%></TD><TD class=Field> <button type='button' class=Calendar onclick="getDate(BeginDatespan,begindate)"></BUTTON> <SPAN id=BeginDatespan ><%=begindate%></SPAN> <input type="hidden" name="begindate" value="<%=begindate%>">-<button type='button' class=Clock onclick="onShowTime(BeginTimespan,begintime)"></button><span id="BeginTimespan"><%=begintime%></span><INPUT type=hidden name="begintime" value="<%=begintime%>"></TD></TR>
        <TR style="height: 1px;">
          <TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2185,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=radio name="bookroom" value="1" <%if(bookroom.equals("1")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><INPUT type=radio name="bookroom" value="2" <%if(bookroom.equals("2") || bookroom.equals("")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>&nbsp<INPUT class=Inputstyle size=10 name="roomstander" value="<%=roomstander%>"></TD>
        </TR>
        <TR style="height: 1px;">
          <TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2184,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=radio name="bookticket" value="1" <%if(bookticket.equals("1")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><INPUT type=radio name="bookticket" value="2" <%if(bookticket.equals("2") || bookticket.equals("")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></TD>
        </TR>
        <TR style="height: 1px;">
          <TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2183,user.getLanguage())%></TD>
          <TD class=Field> <button type='button' class=Calendar onclick="getDate(EndDatespan,enddate)"></BUTTON> <SPAN id=EndDatespan ><%=enddate%></SPAN> <input type="hidden" name="enddate" value="<%=enddate%>">-<button type='button' class=Clock onclick="onShowTime(EndTimespan,endtime)"></button><span id="EndTimespan"><%=endtime%></span><INPUT type=hidden name="endtime" value="<%=endtime%>"></TD>
        </TR>
        <TR style="height: 1px;">
          <TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2182,user.getLanguage())%></TD>
          <TD class=Field>
		  <%=SystemEnv.getHtmlLabelName(2180,user.getLanguage())%><INPUT type=radio name="ticketstander" value="1" <%if(ticketstander.equals("1")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2174,user.getLanguage())%><INPUT type=radio name="ticketstander" value="2" <%if(ticketstander.equals("2")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2175,user.getLanguage())%><INPUT type=radio name="ticketstander" value="3" <%if(ticketstander.equals("3")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2176,user.getLanguage())%>
		  <br>
		  <%=SystemEnv.getHtmlLabelName(2181,user.getLanguage())%><INPUT type=radio name="ticketstander" value="4" <%if(ticketstander.equals("4")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2177,user.getLanguage())%><INPUT type=radio name="ticketstander" value="5" <%if(ticketstander.equals("5")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2178,user.getLanguage())%><INPUT type=radio name="ticketstander" value="6" <%if(ticketstander.equals("6")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2179,user.getLanguage())%>
		  </TD>
        </TR>
        <TR style="height: 1px;">
          <TD class=Line colSpan=2></TD></TR>
        </TBODY>
	  </TABLE>

	  <TABLE class=viewForm>
        <TBODY>
        <TR class=Title>
            <Td><%=SystemEnv.getHtmlLabelName(2189,user.getLanguage())%></Td>
          </TR>
        <TR style="height: 1px;">
          <Td class=line></Td></TR>

        <TR>
          <TD class=header>
            <%
	            ArrayList arrayothermember = Util.TokenizerString(othermember,",");
	            String othermemberNames="";
	        	for(int i=0;i<arrayothermember.size();i++){
	        		othermemberNames=othermemberNames+","+ResourceComInfo.getResourcename(""+arrayothermember.get(i));
	        	}
                if(othermemberNames.length()>0)
                	othermemberNames=othermemberNames.substring(1);
            %>
            <input class="wuiBrowser" type="hidden"  name="othermember" value="<%=othermember%>"
             _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
             _displayTemplate="<a href=/hrm/resource/HrmResource.jsp?id=#b{id}>#b{name}</a>&nbsp"
             _displayText="<%=othermemberNames%>"
            >
            <!--
			<button type='button' class=Browser onclick="onShowMHrm('othermemberspan','othermember')"></button>
			<input type=hidden name="othermember" value="<%=othermember%>">
			<span id="othermemberspan">
			</span> 
			 -->
		  </TD>
        </TR>
        <TR style="height: 1px;">
          <TD class=Line ></TD></TR>
        </TBODY>
	  </TABLE>
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

</FORM>

<script language=javascript>
rowindex = "<%=topicrows%>";
function addRow()
{
	ncol = oTable.cols;
	
	oRow = oTable.insertRow();
	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type='input' style=width:99%  name='topicsubject_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<button type='button' class=Browser onClick=onShowHrm('topichrm_"+rowindex+"span','topichrm_"+rowindex+"','0')></button> " + 
        					"<span class=inputstyle id=topichrm_"+rowindex+"span></span> "+
        					"<input type='hidden' name='topichrm_"+rowindex+"' id='topichrm_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;

			case 3: 
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='topicopen_"+rowindex+"' value='1'>¹«¿ª"; 
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
				oTable.deleteRow(rowsum1-1);	
			}
			rowsum1 -=1;
		}
	
	}	
}	

function onClear(){
	document.weaver.method.value="empty";
	weaver.action="MeetingReHrm.jsp"
	weaver.submit();
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
			if (Not IsEmpty(id1)) then	
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
			end if
end sub

sub onShowMCrm(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="&tmpids)
			if (Not IsEmpty(id1)) then	
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
			end if
end sub


</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
</html>
