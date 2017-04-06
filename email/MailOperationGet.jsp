<%@ page language="java" contentType="text/html; charset=gbk" %> 
<%@ page import="java.util.*, javax.mail.*"%>
<%@ page import="javax.mail.internet.*"%>
<%@ page import="javax.activation.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.security.Security"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.email.*" %>
<jsp:useBean id="Weavermail" class="weaver.email.Weavermail" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_date" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="EmailEncoder" class="weaver.email.EmailEncoder" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<style>*{font:11px Tahoma}</style>

<%
int mailAccountId = Util.getIntValue(request.getParameter("mailAccountId"));
String accountName="", accountId="", accountPassword="", serverType="", popServer="", smtpServer="", needSave="", protocol="";
boolean folderExpunge = false;
String sql = "";
String mailReceivedDateTime = "";
long secondInterval = 0;
String sendfrom = "";
String senddate = "";
String encryption="";
String needSSL = "";
String popServerPort = "";
String smtpServerPort = "";
HashMap displayname = new HashMap();
BaseBean b=new BaseBean();
sql = "select * from MailUserAddress where userid = '"+user.getUID()+"'";
rs.executeSql(sql);
while(rs.next()){
	displayname.put(rs.getString("mailaddress"),rs.getString("mailusername"));
}

String accountReceivedInfo = buildAccountReceivedInfo(mailAccountId).toString();

sql = "SELECT * FROM MailAccount WHERE id="+mailAccountId+"";
rs.executeSql(sql);
if(rs.next()){
	accountName = rs.getString("accountName");
	accountId = rs.getString("accountId");
	accountPassword = rs.getString("accountPassword");
	serverType = rs.getString("serverType");
	popServer = rs.getString("popServer");
	smtpServer = rs.getString("smtpServer");
	
	popServerPort = rs.getString("popServerPort");
	smtpServerPort = rs.getString("smtpServerPort");
	needSSL = rs.getString("getneedSSL");
	needSave = rs.getString("needSave");
	protocol = rs.getString("serverType").equals("1") ? "pop3" : "imap";
	encryption = rs.getString("encryption");
}
if(encryption.equals("1")) accountPassword = EmailEncoder.DecoderPassword(accountPassword);

//MailAccountThreadNew accountThread = new MailAccountThreadNew(mailAccountId);
//System.out.print(popServerPort+"=============="+needSSL+"=================="+smtpServer+"==="+popServer+"===="+accountId+"==="+accountPassword+"====="+protocol);

if(!needSave.equals("1")){folderExpunge = true;}

Store store = null;
Folder folder = null;
Properties props = new Properties() ;
javax.mail.Session s = null;
int messageNumber = 0;
int receivedMailNumber = 0;
int receivedMailId = 0;
String receivedMailIds = "";
String ruledMailIds = "";

Hashtable hashTbl = new Hashtable();
//查找以前该帐户收取过的发件人
sql = "SELECT * FROM MailAccountReceivedInfo WHERE accountId="+mailAccountId+"";
rs.executeSql(sql);
while(rs.next()){
	hashTbl.put(rs.getString("sendfrom"), rs.getString("receivedDateTime"));
}


try{
if(needSSL.equals("1")){
	  Security.addProvider(new com.sun.net.ssl.internal.ssl.Provider()); 
	  final String SSL_FACTORY = "javax.net.ssl.SSLSocketFactory"; 

	  // Get a Properties object 
	  props.setProperty("mail."+protocol+".socketFactory.class", SSL_FACTORY); 
	  props.setProperty("mail."+protocol+".socketFactory.fallback", "false"); 
	  props.setProperty("mail."+protocol+".port", popServerPort); 
	  props.setProperty("mail."+protocol+".socketFactory.port", popServerPort); 

	  //以下步骤跟一般的JavaMail操作相同 
	   s = Session.getDefaultInstance(props,null);
	   System.out.println(props);

	  //请将红色部分对应替换成你的邮箱帐号和密码 
	  URLName urln = new URLName(protocol,popServer,Integer.parseInt(popServerPort),null, 
			  accountId, accountPassword); 
	  store = s.getStore(urln); 
	  store.connect();
}else{
	props.put("mail.smtp.smtphost", smtpServer);
	props.put("mail.transport.protocol", "smtp");
	s = javax.mail.Session.getInstance(props, null);
	store = s.getStore(protocol);
	store.connect(popServer, accountId, accountPassword);
}

	
	folder = store.getDefaultFolder();
	folder = folder.getFolder("INBOX");
	if(folderExpunge){
		folder.open(Folder.READ_WRITE);
	}else{
		folder.open(Folder.READ_ONLY);
	}
	
	Message message[] = folder.getMessages();
	String messageReceivedDateTime = "";
	//System.out.println("=================="+message.length);
	for(int i=message.length-1; i>=0; i--){
		WeavermailComInfo wmc = Weavermail.parseMail(message[i], false);
		if(wmc==null) continue;
		Weavermail.setUserid(user.getUID()+"");
		Weavermail.setDisplayname(displayname);
		sendfrom = Util.toScreen(wmc.getRealeSendfrom(),user.getLanguage(),wmc.getFromencode());
		senddate = wmc.getSendDate();
		mailReceivedDateTime = getReceivedDateTimeBySendfrom(sendfrom,mailAccountId);
		//if(hashTbl.containsKey(sendfrom)){
		if(!mailReceivedDateTime.equals("")){
			//mailReceivedDateTime = (String)hashTbl.get(sendfrom);
			secondInterval = TimeUtil.timeInterval(senddate, mailReceivedDateTime);
			if(secondInterval<0){
				//TODO Refactor
				if(accountReceivedInfo.indexOf(sendfrom+senddate)!=-1) continue;
				wmc = Weavermail.parseMail(message[i], true);
				if(wmc==null) continue;
				receivedMailId = Weavermail.saveMail(message[i], wmc, user, wmc.getContenttype(), mailAccountId);
				receivedMailNumber++;
				receivedMailIds += String.valueOf(receivedMailId) + ",";
			}else{
				if(popServer.toLowerCase().indexOf("sohu")!=-1||popServer.toLowerCase().indexOf("126.com")!=-1||popServer.toLowerCase().indexOf("163.com")!=-1){continue;}else{break;}
			}
		}else{

			if(accountReceivedInfo.indexOf(sendfrom+senddate)!=-1) continue;
			wmc = Weavermail.parseMail(message[i], true);
			if(wmc==null) continue;
			receivedMailId = Weavermail.saveMail(message[i], wmc, user, wmc.getContenttype(), mailAccountId);
			receivedMailNumber++;
			receivedMailIds += String.valueOf(receivedMailId) + ",";
		}
		if(folderExpunge) message[i].setFlag(Flags.Flag.DELETED, true);

		out.print("<script>parent.a('"+accountName+"', "+receivedMailNumber+");</script>");
		out.flush();
	}

	//Update MailAccountReceivedInfo
	WeavermailUtil mailUtil = new WeavermailUtil();
	mailUtil.updateMailAccountReceivedInfo(mailAccountId);

	//Apply MailRule
	if(!receivedMailIds.equals("")){
		MailRule rule = new MailRule();
		rule.apply(receivedMailIds, user, mailAccountId, request, "0");
	}
	
}catch(AuthenticationFailedException e){
	out.println("<script>parent.document.getElementById('msgBox').innerHTML += '<span style=\"color:red\">"+accountName+":Unable to log on;&nbsp;</span>';parent.removeMailAccountId("+mailAccountId+");</script>");
	b.writeLog("邮件接收错误:"+e.toString()+":"+e.getMessage());
    return;
}catch(MessagingException e){
	out.println("<script>parent.document.getElementById('msgBox').innerHTML += '<span style=\"color:red\">"+accountName+":Operation timed out;&nbsp;</span>';parent.removeMailAccountId("+mailAccountId+");</script>");
	b.writeLog("邮件接收错误:"+e.toString()+":"+e.getMessage());
    return;
}finally{
	if(folder!=null){folder.close(folderExpunge);}
	if(store!=null){store.close();}
}

out.println("<script type='text/javascript'>");
if(receivedMailNumber==0){//未发现新邮件
	out.println("parent.document.getElementById('msgBox').innerHTML += '"+accountName+":"+SystemEnv.getHtmlLabelName(19854,user.getLanguage())+";&nbsp;';");
}else{//新邮件
	out.println("parent.document.getElementById('msgBox').innerHTML += '<span style=\"color:green\">"+accountName+":"+SystemEnv.getHtmlLabelName(19855,user.getLanguage())+"("+receivedMailNumber+");&nbsp;</span>';");
}
out.println("parent.removeMailAccountId("+mailAccountId+");");
out.println("</script>");
%>


<%!
StringBuffer buildAccountReceivedInfo(int accountId){
	StringBuffer str = new StringBuffer();
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	rs.executeSql("SELECT sendfrom,senddate FROM MailResource WHERE size_n>0 and mailAccountId="+accountId+"");
	while(rs.next()){
		str.append(rs.getString("sendfrom")+rs.getString("senddate")+",");
	}
	return str;
}
//Debug
/*
Enumeration headers = message[i].getAllHeaders() ;
while(headers.hasMoreElements()) {
	 Header h = (Header) headers.nextElement() ;
	 out.println("<div style='background-color:skyblue'>"+h.getName()+"</div>");
	 out.println("<div style='background-color:'>"+h.getValue()+"</div>");
}
Object body = message[i].getContent();
ByteArrayOutputStream out2 = new ByteArrayOutputStream();
((Multipart)body).writeTo(out2);
out.println("<div style='background-color:#DDD'>"+out2.toString()+"</div>");
*/
%>

<%!
	public String getReceivedDateTimeBySendfrom(String sendfrom,int mailAccountId){
		RecordSet  rs = new RecordSet();
		String receivedDateTime="";
		String sql = "SELECT * FROM MailAccountReceivedInfo WHERE accountId="+mailAccountId+" and sendfrom = '"+sendfrom+"'";
		rs.executeSql(sql);
		if(rs.next()){
			receivedDateTime= rs.getString("receivedDateTime");
		}
		
		return receivedDateTime;
	}
%>