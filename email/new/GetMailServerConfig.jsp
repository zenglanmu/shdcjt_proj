<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
	String email = Util.null2String(request.getParameter("accountMailAddress")).trim();
	String domain ="";
	int index = email.indexOf("@");
	if(index!=-1){
		domain =email.substring(index+1); 
	}
	rs.execute("select * from webmail_domain where domain='"+domain.toLowerCase()+"'");
	out.clear();
	if(rs.next()){
		
		%>
		<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr class="Title">
	<th colspan=2  style="text-align:left"><%=SystemEnv.getHtmlLabelName(19806,user.getLanguage())//服务器信息%></th>
</tr>
<tr class="Spacing" style="height:2px"><td class="Line1" colspan="2"></td></tr>
<tr>
	<td><select name="serverType" onchange="setPortMsg()"><option value="1" <% if(rs.getString("IS_POP").equals("1")){out.print("selected");} %>>POP3</option><option value="2"  <% if(!rs.getString("IS_POP").equals("1")){out.print("selected");} %>>IMAP</option></select></td>
	<td class="Field">
		<input type="text" name="popServer" value="<%=rs.getString("POP_SERVER") %>" class="inputstyle" style="width:90%" maxlength="100" onchange="checkinput('popServer','popServerSpan')" />
		<SPAN id="popServerSpan"></SPAN>
	</td>
</tr>

<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(24723,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" size="4" name="popServerPort" class="inputstyle" value="<%=rs.getString("POP_PORT") %>"  onchange="checkinput('popServerPort','popServerPortSpan')" />
		<SPAN id="popServerPortSpan"></SPAN>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(24725,user.getLanguage())%></td>
	<td class="Field">
		<input type="checkbox" name="getneedSSL" value="1" <%if(rs.getString("IS_SSL_AUTH").equals("1")){out.print("checked");} %> class="inputstyle" />
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td>SMTP<%=SystemEnv.getHtmlLabelName(15038,user.getLanguage())//服务器%></td>
	<td class="Field">
		<input type="text" name="smtpServer" class="inputstyle" value="<%=rs.getString("SMTP_SERVER") %>" style="width:90%" maxlength="100" onchange="checkinput('smtpServer','smtpServerSpan')" />
		<SPAN id="smtpServerSpan"></SPAN>
	</td>
</tr>

<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(24724,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" size="4" name="smtpServerPort" class="inputstyle" value="<%=rs.getString("SMTP_PORT") %>"  onchange="checkinput('smtpServerPort','smtpServerPortSpan')" />
		<SPAN id="smtpServerPortSpan"></SPAN>
	</td>
</tr>

<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(24726,user.getLanguage())%></td>
	<td class="Field">
		<input type="checkbox" name="sendneedSSL" value="1" <%if(rs.getString("IS_SSL_AUTH").equals("1")){out.print("checked");} %> class="inputstyle" />
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(15039,user.getLanguage())//是否需要发件认证%></td>
	<td class="Field">
		<input type="checkbox" name="needCheck" value="1" class="inputstyle" />
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(19807,user.getLanguage())//是否保留服务器上的邮件%></td>
	<td class="Field">
		<input type="checkbox" name="needSave" value="1" class="inputstyle" />
	</td>
</tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(24310 ,user.getLanguage())%></td>
	<td class="Field">
		<input type="checkbox" name="autoreceive" value="1" class="inputstyle" />
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
		<%
	}else{
		%>
		<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
		<tr class="Title">
			<th colspan=2><%=SystemEnv.getHtmlLabelName(19806,user.getLanguage())//服务器信息%></th>
		</tr>
		<tr class="Spacing" style="height:2px"><td class="Line1" colspan="2"></td></tr>
		<tr>
			<td><select name="serverType" onchange="setPortMsg()"><option value="1">POP3</option><option value="2">IMAP</option></select></td>
			<td class="Field">
				<input type="text" name="popServer" class="inputstyle" style="width:90%" maxlength="100" onchange="checkinput('popServer','popServerSpan')" />
				<SPAN id="popServerSpan"><IMG src='/images/BacoError.gif' align="absMiddle"></SPAN>
			</td>
		</tr>

		<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(24723,user.getLanguage())%></td>
			<td class="Field">
				<input type="text" size="4" name="popServerPort" class="inputstyle" value="110"  onchange="checkinput('popServerPort','popServerPortSpan')" />
				<SPAN id="popServerPortSpan"></SPAN>
			</td>
		</tr>
		<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(24725,user.getLanguage())%></td>
			<td class="Field">
				<input type="checkbox" name="getneedSSL" value="1" class="inputstyle" />
			</td>
		</tr>
		<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
		<tr>
			<td>SMTP<%=SystemEnv.getHtmlLabelName(15038,user.getLanguage())//服务器%></td>
			<td class="Field">
				<input type="text" name="smtpServer" class="inputstyle" style="width:90%" maxlength="100" onchange="checkinput('smtpServer','smtpServerSpan')" />
				<SPAN id="smtpServerSpan"><IMG src='/images/BacoError.gif' align="absMiddle"></SPAN>
			</td>
		</tr>

		<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(24724,user.getLanguage())%></td>
			<td class="Field">
				<input type="text" size="4" name="smtpServerPort" class="inputstyle" value="25"  onchange="checkinput('smtpServerPort','smtpServerPortSpan')" />
				<SPAN id="smtpServerPortSpan"></SPAN>
			</td>
		</tr>

		<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(24726,user.getLanguage())%></td>
			<td class="Field">
				<input type="checkbox" name="sendneedSSL" value="1" class="inputstyle" />
			</td>
		</tr>
		<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(15039,user.getLanguage())//是否需要发件认证%></td>
			<td class="Field">
				<input type="checkbox" name="needCheck" value="1" class="inputstyle" />
			</td>
		</tr>
		<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(19807,user.getLanguage())//是否保留服务器上的邮件%></td>
			<td class="Field">
				<input type="checkbox" name="needSave" value="1" class="inputstyle" />
			</td>
		</tr>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(24310 ,user.getLanguage())%></td>
			<td class="Field">
				<input type="checkbox" name="autoreceive" value="1" class="inputstyle" />
			</td>
		</tr>
		<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
		<%
	}
	
%>