<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="DocChangeManager" class="weaver.docs.change.DocChangeManager" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("DocChange:Setting", user)){
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(23098,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
DocChangeManager.setSettingCache();

String autoSend = (String) staticobj.getObject("DocChangeSetting.autoSend");
String autoSendTime = (String) staticobj.getObject("DocChangeSetting.autoSendTime");
String autoReceive = (String) staticobj.getObject("DocChangeSetting.autoReceive");
String autoReceiveTime = (String) staticobj.getObject("DocChangeSetting.autoReceiveTime");
String serverURL = (String) staticobj.getObject("DocChangeSetting.serverURL");
int serverPort = Util.getIntValue((String) staticobj.getObject("DocChangeSetting.serverPort"), 21);
String serverUser = (String) staticobj.getObject("DocChangeSetting.serverUser");
String serverPwd = (String) staticobj.getObject("DocChangeSetting.serverPwd");
String changeMode = (String) staticobj.getObject("DocChangeSetting.changeMode");
int maincategory = Util.getIntValue((String) staticobj.getObject("DocChangeSetting.maincategory"), 0);
int subcategory = Util.getIntValue((String) staticobj.getObject("DocChangeSetting.subcategory"), 0);
int seccategory = Util.getIntValue((String) staticobj.getObject("DocChangeSetting.seccategory"), 0);
String pathcategory = Util.null2String((String) staticobj.getObject("DocChangeSetting.pathcategory"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="DocChangeSystemSetOpterator.jsp">
<input type=hidden id='pathcategory' name='pathcategory' value="<%=pathcategory%>">
<input type=hidden id='maincategory' name='maincategory' value="<%=maincategory%>">
<INPUT type=hidden id='subcategory' name='subcategory' value="<%=subcategory%>">
<INPUT type=hidden id='seccategory' name='seccategory' value="<%=seccategory%>">
    
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

			  <TABLE class=ViewForm>
				<COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>
				<TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(23098,user.getLanguage())%>£¨<%=SystemEnv.getHtmlLabelName(21760,user.getLanguage())%>£©</TH>
				</TR>
				<TR class=Spacing style="height:1px;">
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(23100,user.getLanguage())%></td>
				  <td class=Field>
					<input type="checkbox" name="autoSend"  value="1" <%if(autoSend.equals("1")){%>checked<%}%>>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(23102,user.getLanguage())%></td>
				  <td class=Field>
					<input type="text" name="autoSendTime"  value="<%=autoSendTime%>" maxlength="50" onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)' style="width :60" class="InputStyle">
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(23099,user.getLanguage())%></td>
				  <td class=Field>
					<input type="checkbox" name="autoReceive"  value="1" <%if(autoReceive.equals("1")){%>checked<%}%>>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(23101,user.getLanguage())%></td>
				  <td class=Field>
					<input type="text" name="autoReceiveTime"  value="<%=autoReceiveTime%>" maxlength="50" onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)' style="width :60" class="InputStyle">
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(18526,user.getLanguage()) + SystemEnv.getHtmlLabelName(15046,user.getLanguage())%></td>
				  <td class=Field>
				  <button type=button  class=Browser id=selectCategoryid onClick="onShowCatalog(mypath)" name=selectCategory></BUTTON>
    			  <span id=mypath><%=pathcategory%></span>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(23758,user.getLanguage())%></td>
				  <td class=Field>
					<input type="checkbox" name="changeMode"  value="1" <%if(changeMode.equals("1")){%>checked<%}%>>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(20518,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing style="height:1px;">
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%></td>
				  <td class=Field>
					<input type="text" name="serverURL" onChange="checkinput('serverURL','serverURLspan')" value="<%=serverURL%>" maxlength="50" style="width :50%" class="InputStyle">
					<span id="serverURLspan"></span>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(18782,user.getLanguage())%></td>
				  <td class=Field>
					<input type="text" name="serverPort" maxlength="50" size=5 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)' onChange="checkinput('serverPort','serverPortspan')" value="<%=serverPort%>" maxlength="50" style="width :50%" class="InputStyle">
					<span id="serverPortspan"></span>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(2072,user.getLanguage())%></td>
				  <td class=Field>
					<input type="text" name="serverUser" onChange="checkinput('serverUser','serverUserspan')" value="<%=serverUser%>" maxlength="50" style="width :50%" class="InputStyle">
					<span id="serverUserspan"></span>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></td>
				  <td class=Field>
					<input type="password" name="serverPwd" onChange="checkinput('serverPwd','serverPwdspan')" value="<%=serverPwd%>" maxlength="50" style="width :50%" class="InputStyle">
					<span id="serverPwdspan"></span>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				</TBODY>
				</TABLE>
			</td>
		</tr>
		<tr>
			<td height="10" colspan="3"></td>
		</tr>
</table>

  </FORM>
</BODY>
</HTML>
<script>
function doSave() {
	if(check_form($GetEle("frmMain"), 'serverURL,serverPort,serverUser,serverPwd')) {
		$GetEle("frmMain").submit();
		enableAllmenu();
	}
}

function onShowCatalog(spanName) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
    if (result != null) {
        if (result != null)  {
            spanName.innerHTML=wuiUtil.getJsonValueByIndex(result, 2);
            $GetEle("pathcategory").value = wuiUtil.getJsonValueByIndex(result, 2);
            $GetEle("maincategory").value=wuiUtil.getJsonValueByIndex(result, 3);
            $GetEle("subcategory").value=wuiUtil.getJsonValueByIndex(result, 4);
            $GetEle("seccategory").value=wuiUtil.getJsonValueByIndex(result, 1);
        }
        else{
            spanName.innerHTML="";
            $GetEle("pathcategory").value="";
            $GetEle("maincategory").value="";
            $GetEle("subcategory").value="";
            $GetEle("seccategory").value="";
        }
    }
}
</script>