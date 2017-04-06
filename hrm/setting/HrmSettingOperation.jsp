<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.hrm.settings.ChgPasswdReminder,
                 weaver.hrm.settings.RemindSettings,
                 weaver.login.AuthenticUtil,java.io.*" %>
<%@ page import="weaver.file.Prop"%>
<%@ page import="weaver.general.GCONST"%>
<%@ page import="weaver.usb.UsbKeyProxy"%>
<jsp:useBean id="VerifyPasswdCheck" class="weaver.login.VerifyPasswdCheck" scope="page" />
<jsp:useBean id="SystemComInfo" class="weaver.system.SystemComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

char separator = Util.getSeparator() ;

String remindperiod = Util.fromScreen(request.getParameter("remindperiod"),user.getLanguage());
String valid = Util.fromScreen(request.getParameter("valid"),user.getLanguage());
String birthremindperiod = Util.fromScreen(request.getParameter("birthremindperiod"),user.getLanguage());
String birthvalid = Util.fromScreen(request.getParameter("birthvalid"),user.getLanguage());
String congratulation = Util.fromScreen(request.getParameter("congratulation"),user.getLanguage());
String remindmode = Util.fromScreen(request.getParameter("remindmode"),user.getLanguage());
String needusb = Util.fromScreen(request.getParameter("needusb"),user.getLanguage());
String needusbnetwork = Util.fromScreen(request.getParameter("needusbnetwork"),user.getLanguage());//是否启用usb网段策略
String usbType = Util.fromScreen(request.getParameter("usbType"),user.getLanguage());
String firmcode = Util.fromScreen(request.getParameter("firmcode"),user.getLanguage());
String usercode = Util.fromScreen(request.getParameter("usercode"),user.getLanguage());
String relogin = Util.fromScreen(request.getParameter("relogin"),user.getLanguage());
//System.out.println("o usbType = " + usbType);
//add by sean.yang 2006-02-09 for TD3609
int needvalidate=Util.getIntValue(request.getParameter("needvalidate"),0);
int validatetype=Util.getIntValue(request.getParameter("validatetype"),0);
int validatenum=Util.getIntValue(request.getParameter("validatenum"),0);
//td5709,xiaofeng
int minpasslen=Util.getIntValue(request.getParameter("minpasslen"),0);
int needdynapass=Util.getIntValue(request.getParameter("needdynapass"),0);
int dynapasslen=Util.getIntValue(request.getParameter("dynapasslen"),0);
String dypadcon=Util.fromScreen(request.getParameter("dypadcon"),user.getLanguage());//动态密码内容

String needdactylogram=Util.fromScreen(request.getParameter("needdactylogram"),user.getLanguage());//是否需要使用维尔指纹验证设备登录认证功能
String canmodifydactylogram=Util.fromScreen(request.getParameter("canmodifydactylogram"),user.getLanguage());//是否允许客户端修改指纹

int ChangePasswordDays=Util.getIntValue(request.getParameter("ChangePasswordDays"),7);
int DaysToRemind=Util.getIntValue(request.getParameter("DaysToRemind"),3);
int PasswordChangeReminder=Util.getIntValue(request.getParameter("PasswordChangeReminder"),0);
//密码锁定
int openPasswordLock = Util.getIntValue(Util.null2String(request.getParameter("openPasswordLock")),0);
//锁定密码错误次数
int sumPasswordLock = Util.getIntValue(Util.null2String(request.getParameter("sumPasswordLock")),3);
//密码复杂度
int passwordComplexity = Util.getIntValue(Util.null2String(request.getParameter("passwordComplexity")),0);

RemindSettings settings=new RemindSettings();
settings.setChangePasswordDays(ChangePasswordDays+"");
settings.setDaysToRemind(DaysToRemind+"");
settings.setPasswordChangeReminder(PasswordChangeReminder+"");
settings.setOpenPasswordLock(openPasswordLock+"");
settings.setSumPasswordLock(sumPasswordLock+"");
settings.setPasswordComplexity(passwordComplexity+"");

settings.setRemindperiod(remindperiod);
settings.setValid(valid);
settings.setBirthremindperiod(birthremindperiod);
settings.setBirthvalid(birthvalid);
settings.setCongratulation(congratulation);
settings.setBirthremindmode(remindmode);
settings.setRelogin(relogin);

//add by sean.yang 2006-02-09 for TD3609
settings.setNeedvalidate(needvalidate);
settings.setValidatetype(validatetype);
settings.setValidatenum(validatenum);
//td5709,xiaofeng
settings.setMinPasslen(minpasslen);
settings.setNeeddynapass(needdynapass);
settings.setDynapasslen(dynapasslen);
settings.setDypadcon(dypadcon);    
ChgPasswdReminder reminder=new ChgPasswdReminder();
if(needusb==null||!needusb.equals("1")){
RemindSettings old_settings=(RemindSettings)application.getAttribute("hrmsettings");
settings.setNeedusb(needusb);
settings.setUsbType(old_settings.getUsbType());
settings.setFirmcode(old_settings.getFirmcode());
settings.setUsercode(old_settings.getUsercode());
settings.setNeedusbnetwork(old_settings.getNeedusbnetwork());
}else{
settings.setNeedusb(needusb);
settings.setUsbType(usbType);
settings.setFirmcode(firmcode);
settings.setUsercode(usercode);
settings.setNeedusbnetwork(needusbnetwork);
}

settings.setNeedDactylogram(needdactylogram);
settings.setCanModifyDactylogram(canmodifydactylogram);

long l_firmcode=0;
long l_usercode=0;

if(needusb!=null&&needusb.equals("1") && usbType!=null && "1".equals(usbType)){
try{
l_firmcode=Long.parseLong(firmcode);
l_usercode=Long.parseLong(usercode);
}catch(Exception e){%>
<script>
	alert("<%=SystemEnv.getHtmlLabelName(23267,user.getLanguage())%>!");
    window.location = "Settings.jsp";
</script>
<%return;}
boolean usbinstalled;
    try {
        String usbserver = Prop.getPropValue(GCONST.getConfigFile(), "usbserver.ip");
        if(usbserver!=null&&!usbserver.equals("")) {
                          UsbKeyProxy proxy=new UsbKeyProxy(usbserver);
                          usbinstalled=proxy.checkusb(l_firmcode,l_usercode);
                         }else
                          usbinstalled= AuthenticUtil.checkusb(l_firmcode,l_usercode);
    } catch (Throwable e) {
        usbinstalled=false;
    }
    if(usbinstalled){
    	//在更新前清空所有数据
    	//VerifyPasswdCheck.initPasswordLock(openPasswordLock,sumPasswordLock,passwordComplexity);
		reminder.setRemindSettings(settings);
%>
<script>
    alert("<%=SystemEnv.getHtmlLabelName(16746,user.getLanguage())%>");
    window.location = "Settings.jsp";
</script>
<%
application.setAttribute("hrmsettings",settings);
return;}else{%>
<script>
	alert("<%=SystemEnv.getHtmlLabelName(23268,user.getLanguage())%>!");
    window.location = "Settings.jsp";
</script>
<%}}else{
	//在更新前清空所有数据
	//VerifyPasswdCheck.initPasswordLock(openPasswordLock,sumPasswordLock,passwordComplexity);
	reminder.setRemindSettings(settings);
	application.setAttribute("hrmsettings",settings);%>
<script>
    alert("<%=SystemEnv.getHtmlLabelName(16746,user.getLanguage())%>");
    
    window.location = "Settings.jsp";
</script>
<%}%>

