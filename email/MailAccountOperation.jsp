<%@ page language="java" contentType="text/html; charset=gbk" %> 
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="EmailEncoder" class="weaver.email.EmailEncoder" scope="page" />
<%
String sql = "";
int mailAccountId = Util.getIntValue(request.getParameter("id"));
String showTop = Util.null2String(request.getParameter("showTop"));
String operation = Util.null2String(request.getParameter("operation"));
String accountName = Util.null2String(request.getParameter("accountName"));
String accountMailAddress = Util.null2String(request.getParameter("accountMailAddress"));
String accountId = Util.null2String(request.getParameter("accountId"));
String accountPassword = Util.null2String(request.getParameter("accountPassword"));
int serverType = Util.getIntValue(request.getParameter("serverType"));
String popServer = Util.null2String(request.getParameter("popServer"));
int popServerPort = Util.getIntValue(request.getParameter("popServerPort"));
String smtpServer = Util.null2String(request.getParameter("smtpServer"));
int smtpServerPort = Util.getIntValue(request.getParameter("smtpServerPort"));
String needCheck = Util.null2String(request.getParameter("needCheck"));
String needSave = Util.null2String(request.getParameter("needSave"));
String getneedSSL = Util.null2String(request.getParameter("getneedSSL"));
String sendneedSSL = Util.null2String(request.getParameter("sendneedSSL"));
int defaultMailAccountId = Util.getIntValue(request.getParameter("isDefault"));
int autoreceive = Util.getIntValue(request.getParameter("autoreceive"),0);
accountPassword = EmailEncoder.EncoderPassword(accountPassword);
System.out.println(accountPassword);
if(operation.equals("add")){
	sql = "INSERT INTO MailAccount (userId, accountName, accountMailAddress, accountId, accountPassword, serverType, popServer, popServerPort, smtpServer, smtpServerPort, needCheck, needSave,autoreceive,encryption,sendneedSSL,getneedSSL) VALUES ("+user.getUID()+", '"+accountName+"', '"+accountMailAddress+"', '"+accountId+"', '"+accountPassword+"', "+serverType+", '"+popServer+"', "+popServerPort+", '"+smtpServer+"', "+smtpServerPort+", '"+needCheck+"', '"+needSave+"','"+autoreceive+"',1,'"+sendneedSSL+"','"+getneedSSL+"')";
}else if(operation.equals("update")){
	sql = "UPDATE MailAccount SET accountName='"+accountName+"', accountMailAddress='"+accountMailAddress+"', accountId='"+accountId+"', accountPassword='"+accountPassword+"', serverType="+serverType+", popServer='"+popServer+"', popServerPort="+popServerPort+", smtpServer='"+smtpServer+"', smtpServerPort="+smtpServerPort+", needCheck='"+needCheck+"', needSave='"+needSave+"',autoreceive='"+autoreceive+"',encryption=1,sendneedSSL = '"+sendneedSSL+"',getneedSSL = '"+getneedSSL+"' WHERE id="+mailAccountId+"";
}else if(operation.equals("default")){
	sql = "UPDATE MailAccount SET isDefault='0' WHERE userId="+user.getUID()+"";
	rs.executeSql(sql);
	sql = "UPDATE MailAccount SET isDefault='1' WHERE id="+defaultMailAccountId+"";
}else{
	sql = "SELECT id FROM MailRule WHERE mailAccountId="+mailAccountId+"";
	rs.executeSql(sql);
	if(rs.next()){
		if(showTop.equals("")) {
			response.sendRedirect("MailAccount.jsp?msgLabelId=20245");
			return;
		} else if(showTop.equals("show800")) {
			response.sendRedirect("MailAccount.jsp?showTop=show800&msgLabelId=20245");
			return;
		}
	}else{
		sql = "DELETE FROM MailAccount WHERE id="+mailAccountId+"";
	}
}

rs.executeSql(sql);
if(showTop.equals("")) {
	response.sendRedirect("MailAccount.jsp");
} else if(showTop.equals("show800")) {
	response.sendRedirect("MailAccount.jsp?showTop=show800");
}
%>
