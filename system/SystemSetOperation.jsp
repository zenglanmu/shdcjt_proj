<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util,weaver.sms.SMSManager,weaver.rtx.RTXConfig" %>
<jsp:useBean id="SystemComInfo" class="weaver.system.SystemComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="EmailEncoder" class="weaver.email.EmailEncoder" scope="page" />
<%
boolean canedit = HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user) ;
if(!canedit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
char separator = Util.getSeparator() ;

String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());

String pop3server = Util.fromScreen(request.getParameter("pop3server"),user.getLanguage());
String emailserver = Util.fromScreen(request.getParameter("emailserver"),user.getLanguage());
String debugmode = Util.null2String(request.getParameter("debugmode"));
String logleaveday = ""+Util.getIntValue(request.getParameter("logleaveday"),0);
String defmailuser = Util.null2String(request.getParameter("defmailuser"));
String defmailpassword = Util.null2String(request.getParameter("defmailpassword"));
defmailpassword = EmailEncoder.EncoderPassword(defmailpassword);

String picPath = Util.fromScreen(request.getParameter("picPath"),user.getLanguage());
String filesystem = Util.fromScreen(request.getParameter("filesystem"),user.getLanguage());
String filesystembackup = Util.fromScreen(request.getParameter("filesystembackup"),user.getLanguage());
String filesystembackuptime = Util.null2String(request.getParameter("filesystembackuptime"));
String needzip = Util.null2String(request.getParameter("needzip"));
String needzipencrypt = Util.null2String(request.getParameter("needzipencrypt"));
String defmailserver = Util.null2String(request.getParameter("defmailserver"));
String defneedauth = Util.null2String(request.getParameter("defneedauth"));
String defmailfrom = Util.null2String(request.getParameter("defmailfrom"));
String smsserver = Util.null2String(request.getParameter("smsserver"));
String rtxServer = Util.null2String(request.getParameter("rtxServer"));
String rtxServerOut = Util.null2String(request.getParameter("rtxServerOut"));
String serverType = Util.null2String(request.getParameter("serverType"));
String isDownLineNotify = Util.null2String(request.getParameter("isDownLineNotify"));
String detachable = Util.null2String(request.getParameter("detachable"));
if(detachable.equals("")) detachable="0";
//String appdetachable = Util.null2String(request.getParameter("appdetachable"));
//if(appdetachable.equals("")) appdetachable="0";
String dftsubcomid = Util.null2String(request.getParameter("dftsubcomid"));
String receiveProtocolType = String.valueOf(Util.getIntValue(request.getParameter("receiveProtocolType"),0));

String licenseRemind = Util.null2String(request.getParameter("licenseRemind"));
String remindUsers = Util.null2String(request.getParameter("remindUsers"));
String remindDays = Util.null2String(request.getParameter("remindDays"));
String defUseNewHomepage= Util.null2String(request.getParameter("defUseNewHomepage"));
String mailAutoCloseLeft= Util.null2String(request.getParameter("mailAutoCloseLeft"));
String rtxAlert= Util.null2String(request.getParameter("rtxAlert"));
String emlsavedays = String.valueOf(Util.getIntValue(request.getParameter("emlsavedays"),0));
String emlpath = Util.null2String(request.getParameter("emlpath"));

String refreshTime = Util.null2String(request.getParameter("refreshTime"));
String needRefresh = Util.null2String(request.getParameter("needRefresh"));
String scan = Util.null2String(request.getParameter("scan"));
String rsstype = Util.null2String(request.getParameter("rsstype"));
String isUseOldWfMode = Util.null2o(request.getParameter("isUseOldWfMode"));
String oaaddress = Util.null2String(request.getParameter("oaaddress"));
String messageprefix = Util.null2String(request.getParameter("messageprefix"));
int emailfilesize = Util.getIntValue(request.getParameter("emailfilesize"),0);


String needSSL = Util.null2String(request.getParameter("needssl"));
String smtpServerPort = Util.null2String(request.getParameter("smtpServerPort"));



if(!(needRefresh != null && "1".equals(needRefresh))){
	needRefresh = "0";
}
if(licenseRemind.equals("")){
	remindUsers="";
	remindDays="";
}
    SMSManager smsManager = new SMSManager();
    RTXConfig rtxConfig = new RTXConfig();
    boolean isValid = true;
    if(!operation.equals("detachmanagement")){
    rtxConfig.setProp(RTXConfig.RTX_SERVER_IP,rtxServer);
    rtxConfig.setProp(RTXConfig.RTX_SERVER_OUT_IP,rtxServerOut);
    rtxConfig.setProp(RTXConfig.IS_DOWN_LINE_NOTIFY,isDownLineNotify);

    String smsServerMsg = "";
    isValid = smsManager.changeServerType(serverType);
    }else{}

if(debugmode.equals("")) debugmode = "0" ;

if(operation.equals("detachmanagement")){
    String para = ""+detachable + separator + dftsubcomid;

    RecordSet.executeProc("SystemDMSet_Update",para);

    if(detachable.equals("1") && !dftsubcomid.equals("0")){
        RecordSet.executeProc("SystemSet_DftSCUpdate",""+dftsubcomid);
        if(!dftsubcomid.equals("")){
            RecordSet.executeSql("update workflow_bill set subcompanyid="+dftsubcomid+" where subcompanyid = '' or subcompanyid is null");
            RecordSet.executeSql("update workflow_monitor_bound set subcompanyid=(select subcompanyid from workflow_base where id = workflow_monitor_bound.workflowid)");
            if(RecordSet.getDBType().equals("oracle"))
            	RecordSet.executeSql("update workflow_custom set subcompanyid="+dftsubcomid+" where nvl(subcompanyid,0) = 0");
            else
            	RecordSet.executeSql("update workflow_custom set subcompanyid="+dftsubcomid+" where isnull(subcompanyid,0) = 0");
            
            if(RecordSet.getDBType().equals("oracle"))
            	RecordSet.executeSql("update Workflow_Report set subcompanyid="+dftsubcomid+" where nvl(subcompanyid,0) = 0");
            else
            	RecordSet.executeSql("update Workflow_Report set subcompanyid="+dftsubcomid+" where isnull(subcompanyid,0) = 0");
        }
    }
    
    //RecordSet.executeSql("update SystemSet set appdetachable = "+appdetachable);
    
}else{
    String para = emailserver + separator + debugmode + separator + logleaveday + separator + defmailuser + separator + defmailpassword + separator + pop3server + separator + filesystem + separator + filesystembackup + separator + filesystembackuptime + separator + needzip + separator + needzipencrypt + separator + defmailserver + separator + defmailfrom + separator + defneedauth + separator + smsserver + separator + licenseRemind + separator + remindUsers + separator + remindDays + separator+ emailfilesize;

    RecordSet.executeProc("SystemSet_Update",para);
    RecordSet.executeSql("update SystemSet set receiveProtocolType='" + receiveProtocolType + "'");    
    RecordSet.executeSql("update SystemSet set defUseNewHomepage='" + defUseNewHomepage + "'");    
	RecordSet.executeSql("update SystemSet set picturePath='" + picPath + "'");
	RecordSet.executeSql("update SystemSet set mailAutoCloseLeft='" + mailAutoCloseLeft + "',rtxAlert='"+rtxAlert+"'");
	RecordSet.executeSql("update SystemSet set needRefresh='" + needRefresh + "'");
	RecordSet.executeSql("update SystemSet set refreshMins='" + refreshTime + "'");
    RecordSet.executeSql("update SystemSet set emlsavedays='" + emlsavedays + "'");
    RecordSet.executeSql("update SystemSet set scan='" + scan + "'"); 
    RecordSet.executeSql("update SystemSet set rsstype=" + rsstype + ""); 
    //RecordSet.executeSql("update SystemSet set isUseOldWfMode='" + isUseOldWfMode + "'"); 
	RecordSet.executeSql("update SystemSet set oaaddress = '" + oaaddress + "'"); 
	RecordSet.executeSql("update SystemSet set emlpath = '" + emlpath + "'");
	RecordSet.executeSql("update SystemSet set emailfilesize = '" + emailfilesize + "'"); 
	RecordSet.executeSql("update SystemSet set encryption = 1");
	RecordSet.executeSql("update SystemSet set messageprefix = '" + messageprefix + "'");

	RecordSet.executeSql("update SystemSet set needssl = '" + needSSL + "'"); 
	RecordSet.executeSql("update SystemSet set smtpServerPort = '" + smtpServerPort + "'"); 
}

SystemComInfo.removeSystemCache() ;
//System.out.println("SystemComInfo = " + SystemComInfo.getSmsserver());
%>
<script>
    alert("<%=SystemEnv.getHtmlLabelName(16746,user.getLanguage())%>");
    <%if(operation.equals("detachmanagement")){%>
        window.location = "DetachMSetEdit.jsp";
    <%}else{%>
        <%if(!isValid){%>
        	alert("<%=SystemEnv.getHtmlLabelName(23270,user.getLanguage())%>!");
        <%}%>
        window.location = "SystemSetEdit.jsp";
    <%}%>
</script>

