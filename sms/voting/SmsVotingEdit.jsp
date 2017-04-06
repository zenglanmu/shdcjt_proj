<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,java.text.SimpleDateFormat" %>
<jsp:useBean id="rs_smsvotingdetail" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_smsvoting" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="sptmForSmsVoting" class="weaver.splitepage.transform.SptmForSmsVoting" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
<SCRIPT language="javascript" src="../../js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="../../js/JSDateTime/WdatePicker.js"></script>
<script type="text/javascript" src="../../js/selectDateTime.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("SmsVoting:Manager", user)){
	response.sendRedirect("/notice/noright.jsp");
	return ;
}
int smsvotingid = Util.getIntValue(request.getParameter("id"), 0);
if(smsvotingid == 0){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
int isreopen = Util.getIntValue(request.getParameter("isreopen"), 0);
String subject = "";
String senddate = "";
String sendtime = "";
String enddate = "";
String endtime = "";
int isseeresult = 0;//0，投票人可查看；1，不可查看
String smscontent = "";
String remark = "";
String hrmids = "";
String hrmidsStr = "";
int status = -1;
int creater = 0;
String sql = "select * from smsvoting where id="+smsvotingid;
rs_smsvoting.execute(sql);
if(!rs_smsvoting.next()){
	response.sendRedirect("/notice/noright.jsp");
	return;
}else{
	creater = Util.getIntValue(rs_smsvoting.getString("creater"), 0);
	status = Util.getIntValue(rs_smsvoting.getString("status"), -1);
	if((status!=0 && isreopen==0) || creater!=user.getUID()){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	subject = Util.null2String(rs_smsvoting.getString("subject"));
	senddate = Util.null2String(rs_smsvoting.getString("senddate"));
	sendtime = Util.null2String(rs_smsvoting.getString("sendtime"));
	enddate = Util.null2String(rs_smsvoting.getString("enddate"));
	endtime = Util.null2String(rs_smsvoting.getString("endtime"));
	isseeresult = Util.getIntValue(rs_smsvoting.getString("isseeresult"), 0);
	smscontent = Util.null2String(rs_smsvoting.getString("smscontent"));
	remark = Util.null2String(rs_smsvoting.getString("remark"));
	hrmids = Util.null2String(rs_smsvoting.getString("hrmids"));
	String[] hrmid_sz = Util.TokenizerString2(hrmids, ",");
	if(hrmid_sz!=null && hrmid_sz.length>0){
		for(int i=0; i<hrmid_sz.length; i++){
			int hrmid = Util.getIntValue(hrmid_sz[i], 0);
			if(hrmid == 0){
				continue;
			}
			hrmidsStr += ("<a href=\"/hrm/resource/HrmResource.jsp?id="+hrmid+"\">"+resourceComInfo.getLastname(""+hrmid)+"</a>&nbsp;");
		}
	}
}
int wordsCount = smscontent.length();
String disabledStr = "";
if(isreopen == 1){
	disabledStr = " disabled ";
}

String statusStr = sptmForSmsVoting.getSmsVotingStatus(""+status, ""+user.getLanguage());
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(22304, user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93, user.getLanguage())+"&nbsp;";
titlename += "<B>" + SystemEnv.getHtmlLabelName(602, user.getLanguage()) + ":&nbsp;</B>" + statusStr;
String needfav = "1";
String needhelp = "";

Calendar today = Calendar.getInstance();
String currentDate = Util.add0(today.get(Calendar.YEAR), 4) + "-" + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
String currentTime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":00";

String smscontentspanStr = "";
if("".equals(smscontent.trim())){
	SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	boolean hasBefore = false;//已经过了发送时间，直接发送
	hasBefore = inputFormat.parse(currentDate+" "+currentTime+":00").after(inputFormat.parse(senddate+" "+sendtime));
	if("".equals(senddate) || hasBefore==true){
		smscontentspanStr = "<IMG src=\"/images/BacoError.gif\" align=absMiddle>";
	}
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(isreopen == 0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86, user.getLanguage())+",javascript:onFrmSubmit(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}else if(isreopen == 1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(244, user.getLanguage())+",javascript:onReopen(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;	
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290, user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<TABLE width=100% height=95% border="0" cellspacing="0">
	<colgroup>
	<col width="10">
	<col width="">
	<col width="10">
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	<tr>
		<td></td>
		<td valign="top">  
		<TABLE class=Shadow>
			<tr>
			<td valign="top">
			<form name=frmmain action="SmsVotingOperation.jsp" method=post >
			<input type=hidden name=method value="edit">
			<input type=hidden name=id value="<%=smsvotingid%>">
			<input type=hidden name=status value="<%=status%>">
			<table class="ViewForm">
			<colgroup>
			<col width=15%>
			<col width=35%>
			<col width=15%>
			<col width=35%>
			<TR class=Section>
				<TH colSpan=4><div align="left"><%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%></div></TH>
			</TR>
			<TR style="height:2px"><TD class=line1 colSpan=4></TD></TR>  
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></td>
				<td class=field>
					<input type="text" id="subject" name="subject" temptitle="<%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%>" value="<%=subject%>" class="inputStyle" onchange=checkinput('subject','subjectspan') style="width:80%" <%=disabledStr%>>
					<span id="subjectspan"><%if("".equals(subject.trim())){out.print("<IMG src=\"/images/BacoError.gif\" align=absMiddle>");}%></span>
				</td>
				<td><%=SystemEnv.getHtmlLabelName(21723, user.getLanguage())%></td>
				<td class=field>
					<input type=checkbox class="inputStyle" name="isseeresult" value="1" <%if(isseeresult==1){out.print("checked");}%> <%=disabledStr%>>
				</td>
			</tr>
			<TR style="height:1px"><TD class=line colSpan=4></TD></TR>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(18961, user.getLanguage())%></td>
				<td class=field colspan="3">
					<input type="hidden" class=wuiDate id="senddate" name="senddate" value="<%=senddate%>" >
					<%if(isreopen == 1){
						try{
							sendtime = sendtime.substring(0, 5);
						}catch(Exception e){}
					%>
					<input id="sendtime" name="sendtime" type="hidden" value="<%=sendtime%>">
					<SELECT id="sendtimeselect" name="sendtimeselect" <%=disabledStr%>>
					<%}else{%>
					<SELECT name="sendtime" onChange="changeSendtime()" <%=disabledStr%>>
					<%}%>
					<%
					String selectStr = "";
					int sendtime_int = 9;
					try{
						sendtime_int = Util.getIntValue(sendtime.substring(0, 2), 9);
					}catch(Exception e){}
					for(int i = 0; i < 24; i++){
						if(i == sendtime_int){
							selectStr = " selected ";
						}else{
							selectStr = "";
						}
						out.println("<OPTION value=\""+Util.add0(i, 2)+":00\" "+selectStr+">"+Util.add0(i, 2)+":00</OPTION>");
					}
					%>
					</SELECT>
				<font color="red"><%=SystemEnv.getHtmlLabelName(22354, user.getLanguage())%></font>
				</td>
			</tr>
			<TR style="height:1px"><TD class=line colSpan=4></TD></TR>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(743, user.getLanguage())%></td>
				<td class=field colspan="3">
					<input type="hidden" class=wuiDate name="enddate" value="<%=enddate%>">
					<SELECT name="endtime">
					<%
					int endtime_int = 18;
					try{
						endtime_int = Util.getIntValue(endtime.substring(0, 2), 18);
					}catch(Exception e){}
					for(int i = 0; i < 24; i++){
						if(i == endtime_int){
							selectStr = " selected ";
						}else{
							selectStr = "";
						}
						out.println("<OPTION value=\""+Util.add0(i, 2)+":00\" "+selectStr+">"+Util.add0(i, 2)+":00</OPTION>");
					}
					%>
					</SELECT>
				<font color="red"><%=SystemEnv.getHtmlLabelName(22355, user.getLanguage())%></font>
				</td>
			</tr>
			<TR style="height:1px"><TD class=line colSpan=4></TD></TR>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(16284, user.getLanguage())%></td>
				<td class=field colspan="3"><textarea name="remark" class="inputStyle" rows=3 style="width:70%" <%=disabledStr%>><%=remark%></textarea></td>
			</tr>
			<TR style="height:1px"><TD class=line colSpan=4></TD></TR>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(15525, user.getLanguage())%></td>
				<td class=field colspan="3">
					<input type="hidden" class=wuiBrowser name="hrmids" id="hrmids" value="<%=hrmids%>" <%=disabledStr%>
					_url="/systeminfo/BrowserMain.jsp?url=/sms/MutiResourceMobilBrowser.jsp" _param="resourceids"
					_displayTemplate="<a href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</a>&nbsp;">
					<span id="hrmidsspan"><%=hrmidsStr%></span>
				</td>
			</tr>
			<TR style="height:1px"><TD class=line colSpan=4></TD></TR>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(18529, user.getLanguage())%></td>
				<td class=field colspan="3">
					<textarea id="smscontent" name="smscontent" class="inputStyle" rows=4 style="width:70%" onchange="checkinput_self(smscontent, smscontentspan)" onkeydown=printStatistic(this) onkeypress=printStatistic(this) onpaste=printStatistic(this) <%=disabledStr%>><%=smscontent%></textarea>
					<span id="smscontentspan" name="smscontentspan"><%=smscontentspanStr%></span>
					<FONT color=#ff0000><%=SystemEnv.getHtmlLabelName(20074,user.getLanguage())%><B><SPAN id="wordsCount" name="wordsCount"><%=wordsCount%></SPAN></B><%=SystemEnv.getHtmlLabelName(20075,user.getLanguage())%></FONT>
				</td>
			</tr>
			<TR style="height:1px"><TD class=line colSpan=4></TD></TR>
			</table>
<br>
			<table class="listStyle" id="oTable" name="oTable">
			<col width="3%">
			<col width="12%">
			<col width="80%">
			<TR class=Header>
				<td colspan="3">
				<table class=listStyle cellspacing="0">
				<col width="80%">
				<col width="20%">
				<TR class=Header>
					<TH><div align="left"><%=SystemEnv.getHtmlLabelName(345, user.getLanguage())%></div></TH>
					<td align=right>
					<%if(isreopen == 0){%>
						<a href="javascript:addChoose()"><%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%></a>
						&nbsp;
						<a href="javascript:delChoose()"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></a>
					<%}%>
					</td>
				</TR>
				</table>
				</td>
			</TR>
			<tr class=header>
				<td><input type="checkbox" class="inputStyle" name="checkids" id="checkids" onclick="onCheckAll(this)" <%=disabledStr%>></td>
				<td><%=SystemEnv.getHtmlLabelName(1025, user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(85, user.getLanguage())%></td>
			</tr>
			<%
				int rowindex = 1;
				String classStr = " class=\"DataLight\" ";
				boolean isLight = true;
				sql = "select * from smsvotingdetail where smsvotingid="+smsvotingid+" order by id asc";
				rs_smsvotingdetail.execute(sql);
				while(rs_smsvotingdetail.next()){
					String regcontent_tmp = Util.null2String(rs_smsvotingdetail.getString("regcontent"));
					String remark_tmp = Util.null2String(rs_smsvotingdetail.getString("remark"));
					//int count_tmp = Util.getIntValue(rs_smsvotingdetail.getString("count"), 0);
					out.println("<tr "+classStr+">");
					out.println("<td><input type=\"checkbox\" class=\"inputStyle\" id=\"checkid\" name=\"checkid\" value=\""+rowindex+"\" "+disabledStr+"><input type=\"hidden\" id=\"rowid\" name=\"rowid\" value=\""+rowindex+"\"></td>");
					out.println("<td><select id=\"regcontent_"+rowindex+"\" name=\"regcontent_"+rowindex+"\" style=\"width:80%\" "+disabledStr+">");
					for(int i=0; i<26; i++){
						char c = (char)(i+97);
						String mark_tmp = ""+c;
						if(regcontent_tmp.equalsIgnoreCase(mark_tmp)){
							selectStr = " selected ";
						}else{
							selectStr = "";
						}
						out.println("<option value=\""+c+"\""+selectStr+">"+c+"</option>");
					}
					out.println("</select></td>");
					out.println("<td><input class=\"inputStyle\" id=\"remark_"+rowindex+"\" name=\"remark_"+rowindex+"\" value=\""+remark_tmp+"\" style=\"width:80%\" "+disabledStr+"></td>");
					out.println("</tr>");
					rowindex++;
					if(isLight == true){
						isLight = false;
						classStr = " class=\"DataDark\" ";
					}else{
						isLight = true;
						classStr = " class=\"DataLight\" ";
					}
				}
			%>
			</table>

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
sub showHrmMultiBrowserOld(spanname, inputename)
	tmpids = document.all(inputename).value
	url=escape("/hrm/resource/MutiResourceBrowser.jsp?resourceids="&tmpids)
	id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="&url)
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

sub showHrmMultiBrowser(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/sms/MutiResourceMobilBrowser.jsp?resourceids="&tmpids)
		    if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
                    recievenumber1 = id1(1)

                    retresourceids = ""
                    retresourcename = ""
                    retrecievenumber1 = ""

					sHtml = ""
                    'msgbox resourceids&"|"&resourcename&"|"&recievenumber1

					resourceids = Mid(resourceids,2,len(resourceids))
					resourcename = Mid(resourcename,2,len(resourcename))
                    recievenumber1 = Mid(recievenumber1,2,len(recievenumber1))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = getName(Mid(resourcename,1,InStr(resourcename,",")-1))
                        curnumber1 = getNumber(Mid(recievenumber1,1,InStr(recievenumber1,",")-1))

                        if curnumber1<>"" then
                            retresourceids =retresourceids& ","&curid
                            retresourcename = retresourcename&","&curname
                            retrecievenumber1 = retrecievenumber1&","&curnumber1
                            sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&curid&">"&trim(curname)&"</a>&nbsp"
                        end if

						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
                        recievenumber1 = Mid(recievenumber1,InStr(recievenumber1,",")+1,Len(recievenumber1))

                        'msgbox curid&"|"&curname&"|"&curnumber1
					wend
                    if getNumber(recievenumber1)<>"" then
    					sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&resourceids&">"&trim(getName(resourcename))&"</a>&nbsp"
                        retresourceids =retresourceids& ","&resourceids
                        retresourcename = retresourcename&","&trim(getName(resourcename))
                        retrecievenumber1 = retrecievenumber1&","&getNumber(recievenumber1)
                    end if
                    //msgbox sHtml
					document.all(spanname).innerHtml = sHtml
                    document.all(inputename).value= retresourceids

				else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
				end if
			end if
end sub

</script>
</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
function getName(str){
    re=new RegExp("<.*>","g")
    str1= str.replace(re,"")
    return str1
}
function getNumber(str){
    if(str.indexOf("<")<0)
    return ""
    re=new RegExp(".*<","g")
    str1=str.replace(re,"")
    re=new RegExp(">","g")
    str2=str1.replace(re,"")
    return str2
}

var rowindex = <%=rowindex%>;
var selectStr = "";
for(var i=0; i<26; i++){
	var chooseStr = String.fromCharCode(i+97);
	selectStr += "<option value=\""+chooseStr+"\">"+chooseStr+"</option>";
}

function addChoose(){
	var oRow = jQuery("#oTable")[0].insertRow(-1);
	var oRowIndex = oRow.rowIndex;
	if(oRowIndex%2 == 0){
		oRow.className="DataLight";
	}else{
		oRow.className="DataDark";
	}
	var oDiv;
	var oCell;
	oDiv = document.createElement("div");
	oDiv.innerHTML = "<input type=\"checkbox\" class=\"inputStyle\" id=\"checkid\" name=\"checkid\" value=\""+rowindex+"\"><input type=\"hidden\" id=\"rowid\" name=\"rowid\" value=\""+rowindex+"\">";
	oCell = oRow.insertCell(-1);
	oCell.appendChild(oDiv);

	oDiv = document.createElement("div");
	var htmlStr = "<select id=\"regcontent_"+rowindex+"\" name=\"regcontent_"+rowindex+"\" style=\"width:80%\">";
	htmlStr += selectStr;
	htmlStr += "</select>";
	oDiv.innerHTML = htmlStr;
	oCell = oRow.insertCell(-1);
	oCell.appendChild(oDiv);

	oDiv = document.createElement("div");
	oDiv.innerHTML = "<input class=\"inputStyle\" id=\"remark_"+rowindex+"\" name=\"remark_"+rowindex+"\" value=\"\" style=\"width:80%\">";
	oCell = oRow.insertCell(-1);
	oCell.appendChild(oDiv);

	rowindex = rowindex + 1;
}

function delChoose(){
	if(isdel()){
		var chks = document.getElementsByName("checkid");
		try{
			//alert(oTable.rows.length);
			//alert(chks.length);
			for(var i=chks.length-1; i>=0; i--){
				if(chks[i].checked == true){
					var row = chks[i];
					while(row.tagName != "TR"){
						row = row.parentNode;
					}
					//alert(i);
					//alert(row.rowIndex);
					jQuery("#oTable")[0].deleteRow(row.rowIndex);
				}
			}
		}catch(e){}
	}
}

function onFrmSubmit(){
	if(check_form(document.frmmain, "subject") && check_self() && checkTime() && check_sendNow()){
		document.frmmain.method.value = "edit";
		document.frmmain.submit();
		enableAllmenu();
	}
}

function onReopen(){
	if(checkTime()){
		document.frmmain.method.value = "reopen";
		document.frmmain.submit();
		enableAllmenu();
	}
}

function checkTime(){
	var senddate = document.all("senddate").value;
	var sendtime = document.all("sendtime").value;
	var enddate = document.all("enddate").value;
	var endtime = document.all("endtime").value;

	if(enddate==null || enddate==""){
		return true;
	}
	if(senddate!=null && senddate!=""){
		if(enddate < senddate){
			alert("<%=SystemEnv.getHtmlLabelName(22374, user.getLanguage())%>");
			return false;
		}else{
			if(enddate==senddate && endtime<=sendtime){
				alert("<%=SystemEnv.getHtmlLabelName(22374, user.getLanguage())%>");
				return false;
			}
		}
	}
	if(enddate < "<%=currentDate%>"){
		alert("<%=SystemEnv.getHtmlLabelName(22373, user.getLanguage())%>");
		return false;
	}else{
		if(enddate=="<%=currentDate%>" && endtime<="<%=currentTime%>"){
			alert("<%=SystemEnv.getHtmlLabelName(22373, user.getLanguage())%>");
			return false;
		}
	}
	return true;	
}

function check_sendNow(){
	try{
		if(senddate==null || senddate=="" || senddate<"<%=currentDate%>" || (senddate=="<%=currentDate%>" && sendtime<="<%=currentTime%>")){
			return confirm("\"<%=SystemEnv.getHtmlLabelName(18961, user.getLanguage())%>\"<%=SystemEnv.getHtmlLabelName(21423, user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(22369, user.getLanguage())%>。\n<%=SystemEnv.getHtmlLabelName(22370, user.getLanguage())%>？");
		}else{
			return true;
		}
	}catch(e){}
	return true;
}

function check_self(){
	var senddate = document.getElementById("senddate").value;
	try{
		var smscontent = document.getElementById("smscontent").value;
		if(senddate==null || senddate==""){
			if(smscontent==null || smscontent==""){
				alert("\"<%=SystemEnv.getHtmlLabelName(18529, user.getLanguage())%>\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
				return false;
			}
		}
	}catch(e){}
	var rowids = document.getElementsByName("rowid");
	var chooseStr = ",";
	try{
		for(var i=0; i<rowids.length; i++){
			try{
				var rowid = rowids[i].value;
				var chooseValue = document.getElementById("regcontent_"+rowid).value;
				if(chooseStr.indexOf(","+chooseValue+",")>-1){
					alert("<%=SystemEnv.getHtmlLabelName(22356, user.getLanguage())%>");
					return false;
				}else{
					chooseStr += (chooseValue+",");
				}
			}catch(e){}
		}
	}catch(e){}
	return true;
}

function onShowVotingDate(spanname, inputname){	
	WdatePicker_send(spanname, inputname);
}

function onShowEndDate(spanname, inputname){	
	WdatePicker_end(spanname, inputname);
}

function WdatePicker_send(spanname, inputname){
	WdatePicker(
			{
				onpicked:function(dp){
					returnvalue = dp.cal.getDateStr();	
					$dp.$(spanname).innerHTML = returnvalue;
					$dp.$(inputname).value = returnvalue;
					$dp.$("smscontentspan").innerHTML = "";
					if($dp.$(inputname).value<"<%=currentDate%>" || ($dp.$(inputname).value=="<%=currentDate%>" && $dp.$("sendtime").value<="<%=currentTime%>")){
						if($dp.$("smscontent").value==null || $dp.$("smscontent").value==""){
							$dp.$("smscontentspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
						}else{
							$dp.$("smscontentspan").innerHTML = "";
						}
					}else{
						$dp.$("smscontentspan").innerHTML = "";
					}
				},
				oncleared:function(){
					$(spanname).innerHTML = ""; 
					$(inputname).value = "";
					if($dp.$("smscontent").value==null || $dp.$("smscontent").value==""){
						$dp.$("smscontentspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
					}else{
						$dp.$("smscontentspan").innerHTML = "";
					}
				}
			}
		);
}

function WdatePicker_end(spanname, inputname){
	WdatePicker(
			{
				onpicked:function(dp){
					returnvalue = dp.cal.getDateStr();	
					$dp.$(spanname).innerHTML = returnvalue;
					$dp.$(inputname).value = returnvalue;
				},
				oncleared:function(){
					$(spanname).innerHTML = ""; 
					$(inputname).value = "";
				}
			}
		);
}

function onCheckAll(obj){
	var check = obj.checked;
	var chks = document.getElementsByName("checkid");
	try{
		for(var i=0; i<chks.length; i++){
			chks[i].checked = check;
		}
	}catch(e){}
}

function changeSendtime(){
	var senddate = document.all("senddate").value;
	var sendtime = document.all("sendtime").value;
	if(senddate==null || senddate=="" || senddate<"<%=currentDate%>" || (senddate=="<%=currentDate%>" && sendtime<="<%=currentTime%>")){
		if(document.all("smscontent").value==null || document.all("smscontent").value==""){
			document.all("smscontentspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		}
	}else{
		document.all("smscontentspan").innerHTML = "";
	}
}

function checkinput_self(elementname, spanid){
	var senddate = frmmain.senddate.value;
	var sendtime = frmmain.sendtime.value;
	var viewtype = 0;
	if(senddate==null || senddate==""){
		viewtype = 1;
	}else if(senddate=="<%=currentDate%>" && sendtime<="<%=currentTime%>"){
		viewtype = 1;
	}
	if(viewtype==1){
		var tmpvalue = elementname.value;

		while(tmpvalue.indexOf(" ") == 0){
			tmpvalue = tmpvalue.substring(1, tmpvalue.length);
		}
		if(tmpvalue!=""){
			spanid.innerHTML = "";
		}else{
			spanid.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			elementname.value = "";
		}
	}
}
function printStatistic(o){
	setTimeout(function()
	{
		var inputLength = o.value.length;
		document.all("wordsCount").innerHTML = inputLength;
	}
	,1)
}
</SCRIPT>