<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util,weaver.rtx.RTXConfig" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rtxConfig" class="weaver.rtx.RTXConfig" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="EmailEncoder" class="weaver.email.EmailEncoder" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
RecordSet.executeProc("SystemSet_Select","");
RecordSet.next();
String pop3server = RecordSet.getString("pop3server");
String emailserver = RecordSet.getString("emailserver");
String debugmode = Util.null2String(RecordSet.getString("debugmode"));
String logleaveday = Util.null2String(RecordSet.getString("logleaveday"));
String defmailuser = Util.null2String(RecordSet.getString("defmailuser"));
String defmailpassword = Util.null2String(RecordSet.getString("defmailpassword"));

String picPath = RecordSet.getString("picturePath");
String filesystem = RecordSet.getString("filesystem");
String filesystembackup = RecordSet.getString("filesystembackup");
String filesystembackuptime = Util.null2String(RecordSet.getString("filesystembackuptime"));
String needzip = Util.null2String(RecordSet.getString("needzip"));
String needzipencrypt = Util.null2String(RecordSet.getString("needzipencrypt"));
String defmailserver = Util.null2String(RecordSet.getString("defmailserver"));
String defneedauth = Util.null2String(RecordSet.getString("defneedauth"));
String defmailfrom = Util.null2String(RecordSet.getString("defmailfrom"));
String smsserver = Util.null2String(RecordSet.getString("smsserver"));
String detachable= Util.null2String(RecordSet.getString("detachable"));
int dftsubcomid=Util.getIntValue(RecordSet.getString("dftsubcomid"),0);
int emailfilesize=Util.getIntValue(RecordSet.getString("emailfilesize"),0);
//add by  haofeng for MAILSSL_SUPPENT
String needSSL = Util.null2String(RecordSet.getString("needSSL"));
String smtpServerPort = Util.null2String(RecordSet.getString("smtpServerPort"));

//add by yinshun.xu for licenseRemind
String licenseRemind = Util.null2String(RecordSet.getString("licenseRemind"));
String remindUsers = Util.null2String(RecordSet.getString("remindUsers"));
String remindDays= Util.null2String(RecordSet.getString("remindDays"));
String defUseNewHomepage= Util.null2String(RecordSet.getString("defUseNewHomepage"));

String refreshTime = Util.null2String(RecordSet.getString("refreshMins"));
String needRefresh = Util.null2String(RecordSet.getString("needRefresh"));

String rtxServer = rtxConfig.getPorp(RTXConfig.RTX_SERVER_IP);
rtxServer = rtxServer == null?"":rtxServer;
String rtxServerOut = rtxConfig.getPorp(RTXConfig.RTX_SERVER_OUT_IP);
rtxServerOut = rtxServerOut == null?"":rtxServerOut;
String serverType = rtxConfig.getPorp(RTXConfig.CUR_SMS_SERVER);
serverType = serverType == null?"":serverType;
String isDownLineNotify = rtxConfig.getPorp(RTXConfig.IS_DOWN_LINE_NOTIFY);
isDownLineNotify = isDownLineNotify == null?"":isDownLineNotify;
String receiveProtocolType = RecordSet.getString("receiveProtocolType");

String mailAutoCloseLeft= Util.null2String(RecordSet.getString("mailAutoCloseLeft"));
String rtxAlert= Util.null2String(RecordSet.getString("rtxAlert"));
String emlsavedays = Util.null2String(RecordSet.getString("emlsavedays"));
String emlpath = Util.null2String(RecordSet.getString("emlpath"));
String scan = Util.null2String(RecordSet.getString("scan"));

String rsstype = Util.null2String(RecordSet.getString("rsstype"));
String isUseOldWfMode = Util.null2String(RecordSet.getString("isUseOldWfMode"));

String messageprefix = Util.null2String(RecordSet.getString("messageprefix"));//短信提醒前缀

String oaaddress = Util.null2String(RecordSet.getString("oaaddress"));
String encryption = Util.null2String(RecordSet.getString("encryption"));
if(encryption.equals("1")) defmailpassword = EmailEncoder.DecoderPassword(defmailpassword);

boolean canedit = HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user) ;

String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(774,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(canedit) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="SystemSetOperation.jsp">
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
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15037,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing style="height:1px;">
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				
				<!-- td25435
				<tr>
				  <td>
				  <select name="receiveProtocolType" <% if(!canedit){%>disabled<%}%>>
				  <option value="0" <%if(receiveProtocolType.equals("0")){%>selected<%}%>>POP3 <%=SystemEnv.getHtmlLabelName(15038,user.getLanguage())%></option>
				  <option value="1" <%if(receiveProtocolType.equals("1")){%>selected<%}%>>IMAP <%=SystemEnv.getHtmlLabelName(15038,user.getLanguage())%></option>
				  </select>
				  </td>
				  <td class=Field>
					<% if(canedit) { %>
					<input accesskey=Z name=pop3server  value="<%=Util.toScreenToEdit(pop3server,user.getLanguage())%>" maxlength="50" style="width :50%" class="InputStyle">
					<% } else {%>
					<%=Util.toScreen(pop3server,user.getLanguage())%>
					<%}%>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td>SMTP <%=SystemEnv.getHtmlLabelName(15038,user.getLanguage())%></td>
				  <td class=Field>
					<% if(canedit) { %>
					<input accesskey=Z name=emailserver  value="<%=Util.toScreenToEdit(emailserver,user.getLanguage())%>" maxlength="50" style="width :50%" class="InputStyle">
					<% } else {%>
					<%=Util.toScreen(emailserver,user.getLanguage())%>
					<%}%>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(15039,user.getLanguage())%></td>
				  <td class=Field>
					<input type="checkbox" name=debugmode  value="1" <% if(debugmode.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
				  </td>
				</tr>
				 -->
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(15040,user.getLanguage())%></td>
				  <td class=Field>
					<% if(canedit) { %>
					<input accesskey=Z name=defmailserver  value="<%=Util.toScreenToEdit(defmailserver,user.getLanguage())%>" maxlength="50" style="width :50%" class="InputStyle">
					<%=SystemEnv.getHtmlLabelName(24724,user.getLanguage())%>：<input type="text" size="4" name="smtpServerPort" class="inputstyle" value="<%=smtpServerPort %>"  />
					<%=SystemEnv.getHtmlLabelName(24726,user.getLanguage())%>：<input type="checkbox" name="needssl" value="1" class="inputstyle" <%if(needSSL.equals("1"))out.println("checked=checked");%>/>
					<% } else {%>
						<%=Util.toScreen(defmailserver,user.getLanguage())%>
						<%=SystemEnv.getHtmlLabelName(24723,user.getLanguage())%>：<%=Util.toScreen(smtpServerPort,user.getLanguage())%>
						<%=SystemEnv.getHtmlLabelName(24726,user.getLanguage())%>：<input type="checkbox" name="needssl" value="1" class="inputstyle" disabled <%if(needSSL.equals("1"))out.println("checked=checked");%>/>
					<%}%>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(15044,user.getLanguage())%></td>
				  <td class=Field>
					<input type="checkbox" name=defneedauth  value="1" <% if(defneedauth.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(15041,user.getLanguage())%></td>
				  <td class=Field>
					<% if(canedit) { %>
					<input accesskey=Z name=defmailfrom  value="<%=Util.toScreenToEdit(defmailfrom,user.getLanguage())%>" maxlength="50" style="width :50%" class="InputStyle">
					<% } else {%>
					<%=Util.toScreen(defmailfrom,user.getLanguage())%>
					<%}%>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(15042,user.getLanguage())%></td>
				  <td class=Field>
					<% if(canedit) { %>
					<input type="text" name=defmailuser  value="<%=Util.toScreenToEdit(defmailuser,user.getLanguage())%>" maxlength="50" style="width :50%" class="InputStyle">
					<% } else {%>
					<%=Util.toScreen(defmailuser,user.getLanguage())%>
					<%}%>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>


				
				


				<% if(canedit) { %>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(15043,user.getLanguage())%></td>
				  <td class=Field>
					<input type="password" name=defmailpassword  value="<%=Util.toScreenToEdit(defmailpassword,user.getLanguage())%>" maxlength="50" style="width :50%" class="InputStyle">
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<%}%>
				
				
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(22546,user.getLanguage())%></td>
				  <td class=Field>
					<% if(canedit) { %>
					<input accesskey=Z name=emailfilesize  value="<%=emailfilesize%>" maxlength="50" size=5 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)' class="InputStyle">
					<%}else{ %>
					<%=emailfilesize%>
					<%} %>
					M&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(22547,user.getLanguage())%>
				  </td>
				</tr>


                <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

				<!--使用邮件功能时是否自动关闭系统左菜单-->
				<!--
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(21411,user.getLanguage())%></td>

				   <td class=Field>
					<% if(canedit) { %>						
						<input type="radio" name="mailAutoCloseLeft" <%if("1".equals(mailAutoCloseLeft))out.println(" checked ");%> value="1"><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%>

						<input type="radio" name="mailAutoCloseLeft"   <%if("0".equals(mailAutoCloseLeft))out.println(" checked ");%>  value="0"><%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%>
					<% } else {%>
						<%if("1".equals(mailAutoCloseLeft)){%>
					        <%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%>
                        <%} else if("0".equals(mailAutoCloseLeft)){%>
					        <%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%>
                        <%}%>
					<%}%>
				  </td>
				</tr>
                <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

				-->

				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(16953,user.getLanguage())%></td>
				  <td class=Field>
					<% if(canedit) { %>
					<input type="text" name=smsserver  value="<%=Util.toScreenToEdit(smsserver,user.getLanguage())%>" maxlength="50" style="width :50%" class="InputStyle">
					<% } else {%>
					<%=Util.toScreen(smsserver,user.getLanguage())%>
					<%}%>
				  </td>
				</tr>
                <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

                <tr>
				  <td>RTX&nbsp;<%=SystemEnv.getHtmlLabelName(16953,user.getLanguage())%></td>
				  <td class=Field>
					<% if(canedit) { %>
					<input type="text" name=rtxServer  value="<%=Util.toScreenToEdit(rtxServer,user.getLanguage())%>" maxlength="50" style="width :50%" class="InputStyle">
					<% } else {%>
					<%=Util.toScreen(rtxServer,user.getLanguage())%>
					<%}%>
				  </td>
				</tr>
                <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

                <tr>
				  <td>RTX&nbsp;<%=SystemEnv.getHtmlLabelName(18634,user.getLanguage())%></td>
				  <td class=Field>
					<% if(canedit) { %>
					<input type="text" name=rtxServerOut  value="<%=Util.toScreenToEdit(rtxServerOut,user.getLanguage())%>" maxlength="50" style="width :50%" class="InputStyle">
					<% } else {%>
					<%=Util.toScreen(rtxServerOut,user.getLanguage())%>
					<%}%>
				  </td>
				</tr>
                <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>


				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(21410,user.getLanguage())%><!--是否启用RTX流程到达提醒--></td>
				  <td class=Field>
					<% if(canedit) { %>						
						<input type="radio" name="rtxAlert" <%if("1".equals(rtxAlert))out.println(" checked ");%> value="1"><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%><!--启用-->

						<input type="radio" name="rtxAlert" <%if("0".equals(rtxAlert))out.println(" checked ");%>  value="0"><%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%><!--禁用-->
					<% } else {%>
						<%if("1".equals(rtxAlert)){%>
					        <%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%>
                        <%} else if("0".equals(rtxAlert)){%>
					        <%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%>
                        <%}%>
                     <%}%>
				  </td>
				</tr>
                <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

				
                <tr id=oaaddresstr>
                  <td><%=SystemEnv.getHtmlLabelName(21870,user.getLanguage())%></td>
                  <td class=Field>
                    <input type="text" class=inputstyle style="width :50%" name=oaaddress  value="<%=oaaddress%>" <% if(!canedit) { %>disabled<%}%>>
                  </td>
                </tr>
				<tr id=oaaddresstr style="height:1px;"><td class=Line colspan=2></td></tr>			
					

                <tr>
				  <td><%=SystemEnv.getHtmlLabelName(18635,user.getLanguage())%></td>
				  <td class=Field>
					<% if(canedit) { %>
					<input type="radio" name=serverType  value="<%=RTXConfig.CUR_SMS_SERVER_RTX%>" <%=serverType.equals(RTXConfig.CUR_SMS_SERVER_RTX)?"checked":""%> >RTX&nbsp;<%=SystemEnv.getHtmlLabelName(18635,user.getLanguage())%>
					<input type="radio" name=serverType  value="<%=RTXConfig.CUR_SMS_SERVER_MODEN%>" <%=serverType.equals(RTXConfig.CUR_SMS_SERVER_MODEN)?"checked":""%>>Modem&nbsp;<%=SystemEnv.getHtmlLabelName(18635,user.getLanguage())%>
					<input type="radio" name=serverType  value="<%=RTXConfig.CUR_SMS_SERVER_CUS%>" <%=serverType.equals(RTXConfig.CUR_SMS_SERVER_CUS)?"checked":""%>><%=SystemEnv.getHtmlLabelName(22752,user.getLanguage())%>
					<input type="radio" name=serverType  value="<%=RTXConfig.CUR_SMS_SERVER_NO%>" <%=serverType.equals(RTXConfig.CUR_SMS_SERVER_NO)?"checked":""%>><%=SystemEnv.getHtmlLabelName(18636,user.getLanguage())%>
					<% } else {%>
                        <%if(RTXConfig.CUR_SMS_SERVER_RTX.equals(serverType)){%>
					        RTX&nbsp;<%=SystemEnv.getHtmlLabelName(18635,user.getLanguage())%>
                        <%} else if(RTXConfig.CUR_SMS_SERVER_MODEN.equals(serverType)){%>
					        Modem&nbsp;<%=SystemEnv.getHtmlLabelName(18635,user.getLanguage())%>
                        <%} else if(RTXConfig.CUR_SMS_SERVER_CUS.equals(serverType)){%>
					        <%=SystemEnv.getHtmlLabelName(22752,user.getLanguage())%>
                        <%} else if(RTXConfig.CUR_SMS_SERVER_NO.equals(serverType)){%>
					        <%=SystemEnv.getHtmlLabelName(18636,user.getLanguage())%>
                        <%}%>
					<%}%>
				  </td>
				</tr>
                <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
 
               <tr>
	             <td><%=SystemEnv.getHtmlLabelName(21421,user.getLanguage())%></td>
	             <td class="Field">
		             <input type="text" size = 5 maxlength = 4 name="emlsavedays" class="inputstyle" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("emlsavedays")' value="<%=emlsavedays%>" <% if(!canedit){%>disabled<%}%> /><%=(" "+SystemEnv.getHtmlLabelName(1925,user.getLanguage()))%>
	             </td>
               </tr>
               <tr style="height:1px;"><td class="Line" colspan="2"></td></tr>
			   <% if(canedit) { %>
				   <tr>
				       <td><%=SystemEnv.getHtmlLabelName(21937,user.getLanguage())%></td>
					   <td class=Field>					
						   <input accesskey=Z name=emlpath  value="<%=Util.toScreenToEdit(emlpath,user.getLanguage())%>" maxlength="50" style="width :50%" class="InputStyle"><span>（<%=SystemEnv.getHtmlLabelName(21835,user.getLanguage())%>）</span>					
					   </td>
				   </tr>
	               <tr  style="height:1px;"><td class="Line" colspan="2"></td></tr>
          	   <%}%>
          <!-- delete by xhheng @ 2005/01/25 for 消息提醒 Request06 -->
          <!--     <tr>
				  <td>RTX客户端离线是否短信提醒</td>
				  <td class=Field>
					<% if(canedit) { %>
					<input type="radio" name=isDownLineNotify  value="true" <%=isDownLineNotify.equals("true")?"checked":""%> >提醒
					<input type="radio" name=isDownLineNotify  value="false" <%=isDownLineNotify.equals("false")?"checked":""%>>不提醒
					<% }  else {%>
                        <%if("true".equals(isDownLineNotify)){%>
					        提醒
                        <%} else {%>
					        不提醒
                        <%}%>
					<%}%>
				  </td>
				</tr>
                <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
        -->

				<input type=hidden name=logleaveday  value="<%=logleaveday%>">
				</TBODY>
			  </TABLE>
			  <br>
			  <% if(canedit) { %>
			  <TABLE class=ViewForm>
				<COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>
				<TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15045,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing style="height:1px;">
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(20231,user.getLanguage())%></td>
				  <td class=Field>
					<% if(canedit) { %>
					<input accesskey=Z name=picPath  value="<%=Util.toScreenToEdit(picPath,user.getLanguage())%>" maxlength="50" style="width :50%" class="InputStyle"><span>（<%=SystemEnv.getHtmlLabelName(21835,user.getLanguage())%>）</span>
					<% } else {%>
					<%=Util.toScreen(picPath,user.getLanguage())%>
					<%}%>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(15046,user.getLanguage())%></td>
				  <td class=Field>
					<% if(canedit) { %>
					<input accesskey=Z name=filesystem  value="<%=Util.toScreenToEdit(filesystem,user.getLanguage())%>" maxlength="50" style="width :50%" class="InputStyle"><span>（<%=SystemEnv.getHtmlLabelName(21835,user.getLanguage())%>）</span>
					<% } else {%>
					<%=Util.toScreen(filesystem,user.getLanguage())%>
					<%}%>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(15047,user.getLanguage())%></td>
				  <td class=Field>
					<% if(canedit) { %>
					<input accesskey=Z name=filesystembackup  value="<%=Util.toScreenToEdit(filesystembackup,user.getLanguage())%>" maxlength="50" style="width :50%" class="InputStyle"><span>（<%=SystemEnv.getHtmlLabelName(21835,user.getLanguage())%>）</span>
					<% } else {%>
					<%=Util.toScreen(filesystembackup,user.getLanguage())%>
					<%}%>
				  </td>
				</tr>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(15048,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>)</td>
				  <td class=Field>
					<% if(canedit) { %>
					<input accesskey=Z name=filesystembackuptime  value="<%=filesystembackuptime%>" maxlength="50" style="width :50%" onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)' class="InputStyle"><span>（<%=SystemEnv.getHtmlLabelName(25482,user.getLanguage())%>）</span>
					<% } else {%>
					<%=filesystembackuptime%>
					<%}%>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(15050,user.getLanguage())%></td>
				  <td class=Field>
					<input type="checkbox" name=needzip  value="1" <% if(needzip.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
				  </td>
				</tr>
				<!--tr>
				  <td>是否设置压缩密码</td>
				  <td class=Field>
					<input type="checkbox" name=needzipencrypt  value="1" <% if(needzipencrypt.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
				  </td>
				</tr-->
				<input type=hidden name=logleaveday  value="<%=logleaveday%>">
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				</TBODY>
			  </TABLE>
			  <%}%>
        <br>
			  <% if(canedit) { %>
			  <TABLE class=ViewForm>
				<COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>
				<TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(18012,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing style="height:1px;">
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(6078,user.getLanguage())%></td>
				  <td class=Field>
					<input type="checkbox" name=licenseRemind  value="1" <% if(licenseRemind.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%> onclick="changeDiv()">
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>			
				<TR>
					<TD colspan=2>
					<div id=beforeDiv style="display:<%if (licenseRemind.equals("1")) {%>''<%} else {%>none<%}%>">
						<TABLE class=ViewForm>
				      <COLGROUP>
							<COL width="20%">
				  		<COL width="80%">
				      <TBODY>
							<TR>
								<TD><%=SystemEnv.getHtmlLabelName(18013,user.getLanguage())%></TD>
								<TD class=Field><BUTTON type=button  class=Browser onClick="onShowResource('remindUsers','remindUsersSpan')"></BUTTON>
								<span id=remindUsersSpan>
								<%
									ArrayList remindUsersArray=Util.TokenizerString(remindUsers,",");
									for(int m=0; m < remindUsersArray.size(); m++){
									String remindUser=(String) remindUsersArray.get(m);
									%>
									<a href="/hrm/resource/HrmResource.jsp?id=<%=remindUser%>"><%=Util.toScreen(ResourceComInfo.getResourcename(remindUser),user.getLanguage())%></a>
									<%}%>
								</span> 
              	<INPUT class=InputStyle type=hidden name="remindUsers" value="<%=remindUsers%>"></TD>
					    </TR>
					    
					    <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
					    
							<TR>
								<TD><%=SystemEnv.getHtmlLabelName(6077,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>)</TD>
								<TD class=Field><INPUT class=InputStyle maxLength=2 size=10 name="remindDays" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("remindDays")' value = "<%=remindDays%>"></TD>
					    </TR>
					    
					  	<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
						</TBODY>
						</TABLE>
					</div>
					</TD>
				</TR>		   
				</TBODY>
			  </TABLE>   
			  <%}%>
              
              <TABLE class=ViewForm>
                <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>
                <TR class=Title>
                  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(19405,user.getLanguage())%></TH>
                </TR>
                <TR class=Spacing style="height:1px;">
                  <TD class=Line1 colSpan=2></TD>
                </TR>
                <tr>
                  <td><%=SystemEnv.getHtmlLabelName(19406,user.getLanguage())%></td>
                  <td class=Field>
                    <input type="checkbox" name=defUseNewHomepage  value="1" <% if(defUseNewHomepage.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
                  </td>
                </tr>
                <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>  
              </TABLE>   
		<br>
			  <TABLE class=ViewForm>
                <COLGROUP> <COL width="20%"> <COL width="80%">
				<TBODY>
                <TR class=Title>
                  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(21413,user.getLanguage())%></TH>
                </TR>
                <TR class=Spacing style="height:1px;">
                  <TD class=Line1 colSpan=2></TD>
                </TR>
                <tr>
                  <td><%=SystemEnv.getHtmlLabelName(21004,user.getLanguage())%></td>
                  <td class=Field>
                    <input type="checkbox" name=needRefresh  value="1" <% if(needRefresh.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>
					onclick="changeDiv2()" >
                  </td>
                </tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>			
				<TR>
					<TD colspan=2>
					<div id=beforeDiv2 style="display:<%if (needRefresh.equals("1")) {%>''<%} else {%>none<%}%>">
						<TABLE class=ViewForm>
				      <COLGROUP>
							<COL width="20%">
				  		<COL width="80%">
				      <TBODY>
							<TR>
								<td><%=SystemEnv.getHtmlLabelName(21005,user.getLanguage())%></td>
								<td class=Field>
								<% if(canedit) { %>
									<INPUT class=InputStyle maxLength=2 size=10 name="refreshTime" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("refreshTime")' value = "<%=refreshTime%>">
								<% } else {%>
								<%=Util.toScreen(refreshTime,user.getLanguage())%>
								<%}%>

								
								</td>
							</TR>
					  	<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
						</TBODY>
						</TABLE>
					</div>
					</TD>
				</TR>
				</TBODY>
              </TABLE>   
		<br>
			  <TABLE class=ViewForm>
                <COLGROUP> <COL width="20%"> <COL width="80%">
				<TBODY>
                <TR class=Title>
                  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(18812,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21758,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></TH>
                </TR>
                <TR class=Spacing style="height:1px;">
                  <TD class=Line1 colSpan=2></TD>
                </TR>
                <tr>
                  <td><%=SystemEnv.getHtmlLabelName(21758,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>)</td>
                  <td class=Field>
                  <%if(canedit){%>
                    <input type="text" class="InputStyle" size=10 maxlength=8 name=scan  value="<%=scan%>" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("scan")'><SPAN>　（<%=SystemEnv.getHtmlLabelName(21760,user.getLanguage())%>）</SPAN>					 
                  <%}else{out.println(scan);}%>
                  </td>
                </tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>			
				<TR>
					<TD colspan=2></TD>
				</TR>
				</TBODY>
		</td>
		</tr>
		</TABLE>
	<br>
		<TABLE class=ViewForm>
                <COLGROUP> <COL width="20%"> <COL width="80%">
				<TBODY>
                <TR class=Title>
                  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(21823,user.getLanguage())%></TH>
                </TR>
                <TR class=Spacing style="height:1px;">
                  <TD class=Line1 colSpan=2></TD>
                </TR>
                <tr>
                  <td><%=SystemEnv.getHtmlLabelName(21822,user.getLanguage())%></td>
                  <td class=Field>
                    <select name="rsstype" <% if(!canedit){%>disabled<%}%>>
				  	<option value="1" <%if(rsstype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(108,user.getLanguage())%></option>
				  	<option value="2" <%if(rsstype.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15038,user.getLanguage())%></option>
				  </select>
             
                  </td>
                </tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>			
				<TR>
					<TD colspan=2></TD>
				</TR>
				</TBODY>
		</td>
		</tr>
		</TABLE>

        <br>
		<TABLE class=ViewForm>
            <COLGROUP> <COL width="20%"> <COL width="80%">
               <TR class=Title>
                 <TH colSpan=2><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></TH>
               </TR>
               <TR class=Spacing style="height:1px;">
                 <TD class=Line1 colSpan=2></TD>
               </TR>
               <tr>
                 <td><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(583,user.getLanguage())%></td>
                 <td class=Field>
				  <input type="text" class="InputStyle" maxlength="50" style="width:50%" name="messageprefix" value="<%=messageprefix%>" <% if(!canedit) { %>disabled<%}%>></input>
                 </td>
               </tr>
			<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>			
			<TR>
				<TD colspan=2></TD>
			</TR>
		 </TABLE>

	<!-- <br>
		<TABLE class=ViewForm>
	                <COLGROUP> <COL width="20%"> <COL width="80%">
					<TBODY>
	                <TR class=Title>
	                  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(21833,user.getLanguage())%></TH>
	                </TR>
	                <TR class=Spacing style="height:1px;">
	                  <TD class=Line1 colSpan=2></TD>
	                </TR>
	                <tr>
	                  <td><%=SystemEnv.getHtmlLabelName(21834,user.getLanguage())%></td>
	                  <td class=Field>
						<input type="checkbox" name=isUseOldWfMode  value="1" <% if(isUseOldWfMode.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
					  </select>
	             
	                  </td>
	                </tr>
					<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>			
					<TR>
						<TD colspan=2></TD>
					</TR>
					</TBODY>

			</td>
			</tr>
			</TABLE>
			 -->
	</td>
	

	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

  </FORM>
</BODY>

<script type="text/javascript">
function disModalDialog(url, spanobj, inputobj, need, curl) {

	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}



function onShowSubcompany() {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" + $GetEle("dftsubcomid").value
			, $GetEle("supsubcomspan")
			, $GetEle("dftsubcomid")
			, true
			, "/docs/docs/DocDsp.jsp?id=");
}
function onShowResource(inputname, spanname) {
	var temp = $GetEle(inputname).value;
	id = window
			.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
					+ temp, "", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0).length > 500) { // '500为表结构提醒对象字段的长度
			alert("您选择的提醒对象数量太多，数据库将无法保存所有的提醒对象，请重新选择！");
			$GetEle(spanname).innerHTML = "";
			$GetEle(inputname).value = "";
		} else if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			var resourceids = wuiUtil.getJsonValueByIndex(id, 0).substr(1);
			var resourcename = wuiUtil.getJsonValueByIndex(id, 1).substr(1);
			var sHtml = "";
			$GetEle(inputname).value = resourceids;

			var resourceidArray = resourceids.split(",");
			var resourcenameArray = resourcename.split(",");

			for ( var _i = 0; _i < resourceidArray.length; _i++) {
				var curid = resourceidArray[_i];
				var curname = resourcenameArray[_i];

				sHtml = sHtml + "<A href='/hrm/resource/HrmResource.jsp?id="
						+ curid + "'>" + curname + "</a>&nbsp";
			}

			$GetEle(spanname).innerHTML = sHtml;
		} else {
			$GetEle(spanname).innerHTML = "";
			$GetEle(inputname).value = "";
		}
	}
}
</script>

<script language="javascript">
function onSubmit()
{
	if(document.frmMain.needRefresh.checked == true){
		var refreshTime = document.frmMain.refreshTime.value;
		if(refreshTime == null || refreshTime == '' || refreshTime == '0'){
			alert('<%=SystemEnv.getHtmlLabelName(21414,user.getLanguage())%>');
			return;
		}
	}
	if(document.frmMain.scan.value=="" || document.frmMain.scan.value<1){
	   alert("<%=SystemEnv.getHtmlLabelName(21759,user.getLanguage())%>");
	   document.frmMain.scan.focus();
	   return false;
	}

    if($GetEle("filesystem")!=null&&$GetEle("filesystembackup")!=null){
		if(trim($GetEle("filesystem").value)!=''&&trim($GetEle("filesystem").value)==trim($GetEle("filesystembackup").value)){
			alert('<%=SystemEnv.getHtmlLabelName(22603,user.getLanguage())%>');
			return;
		}
	}
	
	var _defmailfrom = document.getElementById("defmailfrom");
	if(_defmailfrom!=null && trim(_defmailfrom.value).length>0){
		var pattern =  /^(?:[a-z\d]+[_\-\+\.]?)*[a-z\d]+@(?:([a-z\d]+\-?)*[a-z\d]+\.)+([a-z]{2,})+$/i;
		chkFlag = pattern.test(trim(_defmailfrom.value));
		if(!chkFlag){
			alert("<%=SystemEnv.getHtmlLabelName(24570,user.getLanguage())%>");
			_defmailfrom.focus();
			return false;
		}
	}
	
	frmMain.submit();
}
function changeDiv(){
	if ($GetEle("beforeDiv").style.display == "")
	$GetEle("beforeDiv").style.display = 'none' ;
	else 
	$GetEle("beforeDiv").style.display = ''	;
}
function changeDiv2(){
	if ($GetEle("beforeDiv2").style.display == "")
	$GetEle("beforeDiv2").style.display = 'none' ;
	else 
	$GetEle("beforeDiv2").style.display = ''	;
}
function displayoaddress(obj){	
	if(obj.value==1){
		$GetEle("oaaddresstr")[0].style.display="";
		$GetEle("oaaddresstr")[1].style.display="";
	}else{
		$GetEle("oaaddresstr")[0].style.display="none";
		$GetEle("oaaddresstr")[1].style.display="none";	
	}
}
</script>
</HTML>
