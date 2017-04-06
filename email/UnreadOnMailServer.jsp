<%@ page language="java" contentType="text/html; charset=gbk" %> 
<%@ page import="java.util.*, javax.mail.*"%>
<%@ page import="javax.mail.internet.*"%>
<%@ page import="javax.activation.*"%>
<%@ page import="java.net.*"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.email.*" %>
<jsp:useBean id="Weavermail" class="weaver.email.Weavermail" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<%
int mailAccountId = Util.getIntValue(request.getParameter("mailAccountId"));
int userId = user.getUID();

String accountName="", accountId="", accountPassword="", serverType="", popServer="", smtpServer="", needSave="", protocol="";
String sql = "";
String mailReceivedDateTime = "";
long secondInterval = 0;
String sendfrom = "";
String senddate = "";
String encryption="";


sql = "SELECT * FROM MailAccount WHERE id="+mailAccountId+"";
rs.executeSql(sql);
if(rs.next()){
	mailAccountId = rs.getInt("id");
	accountName = rs.getString("accountName");
	accountId = rs.getString("accountId");
	accountPassword = rs.getString("accountPassword");
	serverType = rs.getString("serverType");
	popServer = rs.getString("popServer");
	smtpServer = rs.getString("smtpServer");
	needSave = rs.getString("needSave");
	protocol = rs.getString("serverType").equals("1") ? "pop3" : "imap";
	encryption = rs.getString("encryption");
	if(encryption.equals("1")) accountPassword = EmailEncoder.DecoderPassword(accountPassword);

	String accountReceivedInfo = buildAccountReceivedInfo(mailAccountId).toString();
	Store store = null;
	Folder folder = null;
	int receivedMailNumber = 0;
	Hashtable hashTbl = new Hashtable();

	//====================================================================================================
	//查找以前该帐户收取过的发件人
	sql = "SELECT * FROM MailAccountReceivedInfo WHERE accountId="+mailAccountId+"";
	rs2.executeSql(sql);
	while(rs2.next()){
		hashTbl.put(rs2.getString("sendfrom"), rs2.getString("receivedDateTime"));
	}
	//====================================================================================================

	try{
		Properties props = new Properties() ;
		props.put("mail.smtp.smtphost", smtpServer);
		props.put("mail.transport.protocol", "smtp");
		javax.mail.Session s = javax.mail.Session.getInstance(props, null);
		store = s.getStore(protocol);
		store.connect(popServer, accountId, accountPassword);
		folder = store.getDefaultFolder();
		folder = folder.getFolder("INBOX");
		folder.open(Folder.READ_ONLY);

		Message message[] = folder.getMessages();
		String messageReceivedDateTime = "";

		for(int i=message.length-1; i>=0; i--){
			WeavermailComInfo wmc = Weavermail.parseMail(message[i], false);
			sendfrom = Util.toScreen(wmc.getRealeSendfrom(),user.getLanguage(),wmc.getFromencode());
			senddate = wmc.getSendDate();
			if(hashTbl.containsKey(sendfrom)){
				mailReceivedDateTime = (String)hashTbl.get(sendfrom);
				secondInterval = TimeUtil.timeInterval(senddate, mailReceivedDateTime);
				if(secondInterval<0){
					//TODO Refactor
					if(accountReceivedInfo.indexOf(sendfrom+senddate)!=-1) continue;
					receivedMailNumber++;
				}else{
					if(popServer.toLowerCase().indexOf("sohu")!=-1||popServer.toLowerCase().indexOf("126.com")!=-1||popServer.toLowerCase().indexOf("163.com")!=-1){continue;}else{break;}
				}
			}else{
				if(accountReceivedInfo.indexOf(sendfrom+senddate)!=-1) continue;
				receivedMailNumber++;
			}
		}
		
	}catch(AuthenticationFailedException e){
		System.out.println(e);
		receivedMailNumber = -1;
	}catch(MessagingException e){
		System.out.println(e);
		receivedMailNumber = -1;
	}catch(Exception e){
		System.out.println(e);
		receivedMailNumber = -1;
	}finally{
		if(folder!=null){folder.close(false);}
		if(store!=null){store.close();}
	}
	
	int tempcount = 0;
	sql = "select count(*) from mailresource where status=0 and mailAccountId = " + mailAccountId;
	rs2.executeSql(sql);
	rs2.next();
	tempcount = rs2.getInt(1);
	if(tempcount < 0 ) tempcount = 0;	
	if(receivedMailNumber!=-1){
		out.print(receivedMailNumber+tempcount);
	}else{
		out.print(tempcount);
	}
	
}
%>

<%!
StringBuffer buildAccountReceivedInfo(int accountId){
	StringBuffer str = new StringBuffer();
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	rs.executeSql("SELECT sendfrom,senddate FROM MailResource WHERE mailAccountId="+accountId+"");
	while(rs.next()){
		str.append(rs.getString("sendfrom")+rs.getString("senddate")+",");
	}
	return str;
}
%>