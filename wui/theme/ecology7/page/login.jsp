<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="java.io.*" %>
<%@ page import="weaver.general.Util,weaver.general.MathUtil,weaver.general.GCONST,weaver.general.StaticObj,
                 weaver.hrm.settings.RemindSettings"%>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.net.*" %>

<%@ page import="weaver.hrm.settings.BirthdayReminder" %>
<%@page import="java.util.List"%>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="rci" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="suc" class="weaver.system.SysUpgradeCominfo" scope="page" />
<%@page import="weaver.login.VerifyLogin"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<title></title>
<SCRIPT type=text/javascript src="/wui/common/jquery/jquery.js"></SCRIPT>
<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.cycle.all.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client.js"></script>

<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.overlabel.js"></script>

<link href="/css/commom.css" type="text/css" rel="stylesheet">

<link href="/wui/theme/ecology7/page/softkey/softkey.css" type="text/css" rel="stylesheet">

<script type="text/javascript" src="/wui/theme/ecology7/page/softkey/Keyboard.js"></script>


<!-- 字体设置，win7、vista系统使用雅黑字体,其他系统使用宋体 Start -->
<link type='text/css' rel='stylesheet'  href='/wui/common/css/w7OVFont.css' id="FONT2SYSTEMF">
<%String isMobileTest =Util.null2String(request.getParameter("isMobileTest"));%>

<script type="text/javascript">
  //浏览器版本不支持跳转
  var isMobileTest="<%=isMobileTest%>";
  var browserName = $.client.browserVersion.browser;             //浏览器名称
  var browserVersion = parseInt($.client.browserVersion.version);//浏览器版本
  var osVersion=$.client.version;                                //操作系统版本
  var browserOS=$.client.os;
  
  function accessFilter(){
     //禁止iphone、ipad、android访问
	  if(isMobileTest!="1"&&(browserOS=="iPhone/iPod"||browserOS=="iPad"||browserOS=="Android")){
	     window.location.href="/wui/common/page/sysRemind.jsp?labelid=2&browserOS="+browserOS;
	     return ;
	  }   
	  //禁止windows下safari访问   
	  if((browserName == "Safari"&&browserOS=="Windows")){   
	     window.location.href="/wui/common/page/sysRemind.jsp?labelid=3&browserOS="+browserOS+"&browserName="+browserName; 
	     return ;
	  }   
	  if((browserName == "FF"&&browserVersion<9)||(browserName == "Chrome"&&browserVersion<14)||(browserName == "Safari"&&browserVersion<5&&browserOS!="Windows")){
		    window.location.href="/wui/common/page/sysRemind.jsp?labelid=1&browserName="+browserName+"&browserVersion="+$.client.browserVersion.version;
	        return ;
	  }
	  //禁止IE8以下浏览器访问，并提示安装IE8
	  if(browserName == "IE"&&browserVersion<8&&!document.documentMode){
	     window.location.href="/wui/common/page/sysRemind.jsp?labelid=4";
         return ;
     }
	  
  }
  
  accessFilter();
  
</script>
<%


String dlflg = request.getParameter("dlflg");
if (dlflg != null && "true".equals(dlflg)) {
    String fontFileName = "USBkeyTool.rar";
    String fontFilePath = "wui/theme/ecology7/page/resources/";
    
    BufferedInputStream bis = null;
    BufferedOutputStream bos = null;
    try {
    	String projectPath = this.getServletConfig().getServletContext().getRealPath("/");
		if (projectPath.lastIndexOf("/") != (projectPath.length() - 1) && projectPath.lastIndexOf("\\") != (projectPath.length() - 1)) {
			projectPath += "/";
		}
        String filepath = projectPath + fontFilePath + fontFileName;

        response.reset();
        response.setHeader("Pragma", "No-cache");
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expires", 0);
        response.setContentType("application/octet-stream;charset=GBK");
        response.setHeader("Content-disposition", "attachment;filename=\"" + fontFileName + "\"");
        
        bis = new BufferedInputStream(new FileInputStream(filepath));
        bos = new BufferedOutputStream(response.getOutputStream());
        
        byte[] buff = new byte[2048];
        int bytesRead;
        while ((bytesRead = bis.read(buff, 0, buff.length)) != -1) {
            bos.write(buff, 0, bytesRead);
        }
        bos.flush();
        //out.clear();
        out = pageContext.pushBody();
    } catch(IOException e) {
        e.printStackTrace();
    } finally {
        if (bis != null) {
            try {
                bis.close();
                bis = null;
            } catch (IOException e) {
            }
        }
        
        if (bos != null) {
            try {
                bos.close();
                bos = null;
            } catch (IOException e) {
            }
        }
    }
    return;
}

String logintype = Util.null2String(request.getParameter("logintype")) ;
String templateId = Util.null2String(request.getParameter("templateId"));
String templateType = "";
String imageId = "";
String imageId2 = "";
String loginTemplateTitle="";
String backgroundColor = "";
String backgroundUrl="/wui/theme/ecology7/page/images/login/login_cbg"+((logintype != null && logintype.trim().equals("2")) ? "2" : "")+".png";
int extendloginid=0;

String sqlLoginTemplate1 = "SELECT * FROM SystemLoginTemplate WHERE loginTemplateid='" + templateId + "'";  

rs.executeSql(sqlLoginTemplate1);
if(rs.next()){
    templateId=rs.getString("loginTemplateId");
    templateType = rs.getString("templateType");
    imageId = rs.getString("imageId");
    imageId2 = rs.getString("imageId2");
    loginTemplateTitle = rs.getString("loginTemplateTitle");
    backgroundColor = rs.getString("backgroundColor");
    out.println("<script language='javascript'>document.title='"+loginTemplateTitle+"111';</script>");
}
if(!"".equals(imageId))
	backgroundUrl="/LoginTemplateFile/"+imageId;

%>

<%
String formmethod = "post";
if(!"".equals(Util.null2String(BaseBean.getPropValue("ldap", "domain")))){
    formmethod = "get";
}
String host = Util.getRequestHost(request);
GCONST.setHost(host);
String acceptlanguage = request.getHeader("Accept-Language");
if(!"".equals(acceptlanguage))
    acceptlanguage = acceptlanguage.toLowerCase();
String hostaddr = "";
String mainControlIp ="";
try
{
 InetAddress ia = InetAddress.getLocalHost();
 hostaddr = ia.getHostAddress();
}
catch(Exception e)
{   
}



mainControlIp = BaseBean.getPropValue(GCONST.getConfigFile() , "MainControlIP");
String qstr = Util.null2String(request.getQueryString());
if(qstr.indexOf("<")!=-1 || qstr.indexOf(">")!=-1 || qstr.toLowerCase().indexOf("script")!=-1) {
    response.sendRedirect("/"+request.getContextPath());
    return;
}
if((!"".equals(mainControlIp)&&hostaddr.equals(mainControlIp))||"".equals(mainControlIp))
{
    Thread threadSysUpgrade = null;
    threadSysUpgrade = (Thread)weaver.general.InitServer.getThreadPool().get(0);
    int filePercent = 0;
    int currentFile = 0, fileList = 0;
    if(threadSysUpgrade.isAlive()){
        currentFile = weaver.system.SystemUpgrade.getCurrentFile();
        fileList = weaver.system.SystemUpgrade.getFileList();
    
        if(currentFile!=0 && fileList!=0){
            out.println("<style>.updating{margin:50px 0 0 50px;font-family:MS Shell Dlg,Arial;font-size:14px;font-weight:bold}</style>");
            out.println("<script>document.write('<div class=updating><img src=\"/images/icon_inprogress.gif\"><br/>系统正在更新！请稍候登录。<br/><span id=\"updateratespan\">"+MathUtil.div(currentFile*100,fileList,2)+"</span>%</div>');</script>");
        }
%>
<script>
    function ajaxinit(){
        var ajax=false;
        try{
            ajax = new ActiveXObject("Msxml2.XMLHTTP");
        }catch(e){
            try{
                ajax = new ActiveXObject("Microsoft.XMLHTTP");
            }catch(E){
                ajax = false;
            }
        }
        if(!ajax && typeof XMLHttpRequest!='undefined'){
           ajax = new XMLHttpRequest();
        }
        return ajax;
    }

    var cx = 0;
    setTimeout("checkIsAlive()", 1000);

    function checkIsAlive(){
        var url = 'LoginOperation.jsp';
        var pars = 'method=add&cx='+cx;
        cx++;
        var ajax=ajaxinit();
        $.post("LoginOperation.jsp?method=add&cx="+cx,null,function(data){

        	var mins = data;
            var bx = mins.indexOf(",0,");
            if(bx == -1){
                bx = mins.indexOf(",");
                var dx = mins.lastIndexOf(",");
                $("#updateratespan").html(mins.substring(bx+1, dx));
                setTimeout("checkIsAlive()", 5000);
                ///document.all("updateratespan").innerHTML = mins.substring(bx+1, dx);
                ///setTimeout("checkIsAlive()", 5000);
            }else{
                //alert("cx = " + mins);
                self.location.reload();
            }

        })
        /*
        ajax.open("POST", "LoginOperation.jsp?method=add&cx="+cx, true);
        ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
        ajax.send();
        ajax.onreadystatechange = function(){
            if (ajax.readyState == 4) {
                if(ajax.status == 200){
                    //k("isAlive = " + ajax.responseText);
                    var mins = ajax.responseText;
                    var bx = mins.indexOf(",0,");
                    if(bx == -1){
                        bx = mins.indexOf(",");
                        var dx = mins.lastIndexOf(",");
                        document.all("updateratespan").innerHTML = mins.substring(bx+1, dx);
                        setTimeout("checkIsAlive()", 5000);
                    }else{
                        //alert("cx = " + mins);
                        self.location.reload();
                    }
                }
            }
        }*/
    }
</script>
<%
        return;
    }
}

int upgreadeStatus= suc.getUpgreadStatus();
//升级过程中脚本执行出错
if (upgreadeStatus==1) {
    out.println("<style>.updating{margin:50px 0 0 50px;font-family:MS Shell Dlg,Arial;font-size:14px;font-weight:bold}</style>");
    out.println("<script>document.write('<div class=updating><img src=\"/images/icon_inprogress.gif\"><br/>升级不成功，升级脚本错误，错误日志位于"+suc.getUpgreadLogPath()+"处，请联系供应商！</div>');</script>");
    return;
}
//升级过程中异常中止
if (upgreadeStatus==2) {
    out.println("<style>.updating{margin:50px 0 0 50px;font-family:MS Shell Dlg,Arial;font-size:14px;font-weight:bold}</style>");
    out.println("<script>document.write('<div class=updating><img src=\"/images/icon_inprogress.gif\"><br/>升级不成功，升级过程中服务器异常中止或者重启了Resin服务，请联系供应商！</div>');</script>");
    return;
}
//升级程序执行异常
if (upgreadeStatus==3) {
    out.println("<style>.updating{margin:50px 0 0 50px;font-family:MS Shell Dlg,Arial;font-size:14px;font-weight:bold}</style>");
    out.println("<script>document.write('<div class=updating><img src=\"/images/icon_inprogress.gif\"><br/>升级不成功，升级程序错误，请联系供应商！</div>');</script>");
    return;
}

//String templateId="",templateType="",imageId="",loginTemplateTitle="";
//int extendloginid=0;

String sqlLoginTemplate = "SELECT * FROM SystemLoginTemplate WHERE isCurrent='1'";  

rs.executeSql(sqlLoginTemplate);
if(rs.next()){
    templateId=rs.getString("loginTemplateId");
    templateType = rs.getString("templateType");
    imageId = rs.getString("imageId");
    loginTemplateTitle = rs.getString("loginTemplateTitle");
    extendloginid = rs.getInt("extendloginid");
    out.println("<script language='javascript'>document.title='"+loginTemplateTitle+"';</script>");
}

//modify by mackjoe at 2005-11-28 td3282 邮件提醒登陆后直接到指定流程
String gopage=Util.null2String(request.getParameter("gopage"));
// add by dongping for TD1340 in 2004.11.05
// add a cookie in our system
Cookie ckTest = new Cookie("testBanCookie","test");
ckTest.setMaxAge(-1);
ckTest.setPath("/");
response.addCookie(ckTest);

//xiaofeng, usb硬件加密 

RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
if(settings==null){
    BirthdayReminder birth_reminder = new BirthdayReminder();
    settings=birth_reminder.getRemindSettings();
    if(settings==null){
        out.println("Cann't create connetion to database,please check your database.");
        return;
    }
    application.setAttribute("hrmsettings",settings);
}
String needusb=settings.getNeedusb();
String usbType = settings.getUsbType();
String firmcode=settings.getFirmcode();
String usercode=settings.getUsercode();
String OpenPasswordLock = settings.getOpenPasswordLock();

String needdactylogram = settings.getNeedDactylogram(); 
//String canmodifydactylogram = settings.getCanModifyDactylogram();
String loginid=Util.null2String((String)session.getAttribute("tmploginid1"));
String disLoginId = loginid;
String message0 = Util.null2String(request.getParameter("message")) ;
System.out.println(message0);
int focusflg = 0;
String usbMsgparam = Util.null2String(request.getParameter("usbparammsg")) ;
//处理发过动态密码后   刷新页面 不重新发送的问题  20931
if((message0.equals("57") || message0.equals("101")) && loginid.equals("")){
     loginid = "";
     message0 = "";
     }
String message=message0;
if(message0.equals("nomatch")) message = "";
if(!message.equals("")) message = SystemEnv.getErrorMsgName(Util.getIntValue(message0),7) ;
if("16".equals(message0)){
    if("1".equals(OpenPasswordLock)){
        loginid=Util.null2String((String)session.getAttribute("tmploginid1"));
        String sql = "select sumpasswordwrong from hrmresource where loginid='"+loginid+"'";
        rs1.executeSql(sql);
        rs1.next();
        int sumpasswordwrong = Util.getIntValue(rs1.getString(1));
        int sumPasswordLock = Util.getIntValue(settings.getSumPasswordLock(),3);
        int leftChance = sumPasswordLock-sumpasswordwrong;
        if(leftChance==0){
            sql = "update HrmResource set passwordlock=1,sumpasswordwrong=0 where loginid='"+loginid+"'";
            rs1.executeSql(sql);
            message0 = "110";
        }else{
            message = SystemEnv.getHtmlLabelName(24466,7)+leftChance+SystemEnv.getHtmlLabelName(24467,7);
        }
    }
    focusflg = 1; 
}
session.removeAttribute("tmploginid1");
if(message0.equals("16")) {
    loginid = "";
} 
if(message0.equals("101")) {
    //loginid=Util.null2String((String)session.getAttribute("tmploginid"));
    //session.removeAttribute("tmploginid");
    message=SystemEnv.getHtmlLabelName(20289,7);
    focusflg = 2;
}
if(message0.equals("110")) 
{
    loginid = "";
    int sumPasswordLock = Util.getIntValue(settings.getSumPasswordLock(),3);
    message=SystemEnv.getHtmlLabelName(24593,7)+sumPasswordLock+SystemEnv.getHtmlLabelName(18083,7)+"，"+SystemEnv.getHtmlLabelName(24594,7);
    focusflg = 1;
}
if((message0.equals("101")||message0.equals("57"))&&loginid.equals("")){
    message="";
}

if(logintype.equals("")) logintype="1";

//IE 是否允许使用Cookie
String noAllowIe = Util.null2String(request.getParameter("noAllowIe")) ;
if (noAllowIe.equals("yes")) {
    message = "IE阻止Cookie";
}

//用户并发数错误提示信息
if (message0.equals("26")) { 
    message = SystemEnv.getHtmlLabelName(23656,7);
}

//add by sean.yang 2006-02-09 for TD3609
int needvalidate=settings.getNeedvalidate();//0: 否,1: 是
int validatetype=settings.getValidatetype();//验证码类型，0：数字；1：字母；2：汉字
int islanguid = 0;//7: 中文,9: 繁体中文,8:英文
Cookie[] systemlanid= request.getCookies();
for(int i=0; (systemlanid!=null && i<systemlanid.length); i++){
    //System.out.println("ck:"+systemlanid[i].getName()+":"+systemlanid[i].getValue());
    if(systemlanid[i].getName().equals("Systemlanguid")){
        islanguid = Util.getIntValue(systemlanid[i].getValue(), 0);
        break;
    }
}
boolean ismuitlaguage = false;
StaticObj staticobj = null;
staticobj = StaticObj.getInstance();
String multilanguage = (String)staticobj.getObject("multilanguage") ;
if(multilanguage == null) {
    VerifyLogin.checkLicenseInfo();
    multilanguage = (String)staticobj.getObject("multilanguage") ;
}
if(multilanguage.equals("y")){
    ismuitlaguage = true;
}
%>

<%
if(message0.equals("46")){
%>
<script language="JavaScript">
flag=confirm('您可能还没有为usb令牌安装驱动程序，安装请按确定')
if(flag){
    <%if("1".equals(usbType)){%>
        window.open("/weaverplugin/WkRt.exe")
    <%}else{%>
        window.open("/weaverplugin/HaiKeyRuntime.exe")
    <%}%>
}
</script>
<%}%>

<script language="javascript"> 

function addCssByStyle(cssString){
	var doc=document;
	var style=doc.createElement("style");
	style.setAttribute("type", "text/css");

	if(style.styleSheet){// IE
		style.styleSheet.cssText = cssString;
	} else {// w3c
		var cssText = doc.createTextNode(cssString);
		style.appendChild(cssText);
	}

	var heads = doc.getElementsByTagName("head");
	if(heads.length) {
		heads[0].appendChild(style);
	} else {
		doc.documentElement.appendChild(style);
	}
}

//alert( window.navigator.userAgent+"%%%"+jQuery.client.version +"%%%"+jQuery.client.browser+"%%%"+$.client.os+"&&&&&"+jQuery.client.getOsVersion())
var osV = jQuery.client.version; 
var isIE = jQuery.client.browser=="Explorer"?"true":"false";

if (osV < 6) {
	document.getElementById('FONT2SYSTEMF').href = "/wui/common/css/notW7AVFont.css";
	addCssByStyle("input { Line-height:100%!important;}");
}
</script> 
<!-- 字体设置，win7、vista系统使用雅黑字体,其他系统使用宋体 End -->

<!--[if IE 6]>
	<script type='text/javascript' src='/wui/common/jquery/plugin/8a-min.js'></script>
<![endif]-->

<!--超时跳转,跳出iframe黄宝2011/5/25-->
<script type="text/javascript">
  if(top.location != self.location) top.location=self.location;
</script> 

<SCRIPT language=javascript1.1>
//<!--
<!--
function checkall()
{ 
    var dactylogram = "";
    if(document.all("dactylogram")) dactylogram = document.all("dactylogram").value;
    if(dactylogram == ""){
    var i=0;
    var j=0;
    var errMessage="";
if (form1.loginid.value=="") {errMessage=errMessage+"请输入用户名！\n";i=i+1;}
if (form1.userpassword.value=="") {errMessage=errMessage+"请输入密码！\n";j=j+1;}
if (i>0){
    alert(errMessage);form1.loginid.focus(); return false ;
}else if(j>0){
    alert(errMessage);form1.userpassword.focus(); return false ;
}

<%if(needusb!=null&&needusb.equals("1")){%>
if(userUsbType=="1")
   checkusb1();
else if(userUsbType=="2")
   checkusb2();
else if(userUsbType=="3")
   return checkusb3();       
<%}%>
//  else { form1.submit() ; }
}}

var dactylogramStr = "";
var intervalID = 0;
//--------------------------------------------------------------//
// 采集指纹特征
//--------------------------------------------------------------//
function FingerSample(){
    init();
    if(dactylogramStr==""){
        OpenDevice();
        if(openStatus==1){
            iRet = dtm.GetExtractMBSimple();
            if(iRet != 0){
                      if(intervalID!=0) window.clearInterval(intervalID);
                intervalID = setTimeout("FingerSample()", 2000);
            }else{
                if(intervalID!=0) window.clearInterval(intervalID);
                if(intervalID2!=0) window.clearInterval(intervalID2);
                dactylogramStr = dtm.strInfo;
                document.all("dactylogram").value=dactylogramStr;
                form1.submit();
            }
            CloseDevice();
        }
    }
    if(intervalID!=0) window.clearInterval(intervalID);
    intervalID = setTimeout("FingerSample()", 2000);    
}

var openStatus = 0;
function OpenDevice()
{
    openStatus = 0;
    dtm.DataType = 0;
    iRet = dtm.EnumerateDevicesSimple();
    if(iRet == 0){
        devInfo = dtm.strInfo;
        devNum = devInfo.split(",")[1];
        iRet = dtm.OpenDevice(devNum);
        if(iRet == 0){
            openStatus = 1;
        }
    }
}
function CloseDevice()
{
    iRet = dtm.CloseDevice();
}
function init(){
    try{
        OpenDevice();
        if(openStatus != 1){
            document.all("dactylogramLoginImgId").src="/images/loginmode/3.gif";
            if(intervalID2!=0) window.clearInterval(intervalID2);
            intervalID2=setTimeout("init()", 100);
        }else{
            if("<%=message0%>"=="nomatch") document.all("dactylogramLoginImgId").src="/images/loginmode/2.gif";
            else document.all("dactylogramLoginImgId").src="/images/loginmode/1.gif";
            if(intervalID2!=0) window.clearInterval(intervalID2);
            if(document.getElementById("onDactylogramOrPassword").value==0){
                if(intervalID!=0) window.clearInterval(intervalID);
                intervalID=setTimeout("FingerSample()", 2000);
            }
        }
        CloseDevice();
    }catch(e){}
}
if("<%=needdactylogram%>"=="1"||"<%=message0%>"=="nomatch"){
    if(intervalID!=0) window.clearInterval(intervalID);
    if(intervalID2!=0) window.clearInterval(intervalID2);
        intervalID2=setTimeout("init()", 100);
    intervalID=setTimeout("FingerSample()", 2000);
}
var intervalID2=0;
if(<%=GCONST.getONDACTYLOGRAM()%>&&"<%=needdactylogram%>"=="1") intervalID2=setTimeout("init()", 100);
function changeLoginMode(modeid){
    if(modeid==0){
        document.all("dactylogramLogin").style.display = "";
        document.all("passwordLogin").style.display = "none";
        document.all("loginModeTable").style.margin = "100px 0 0 475px";
        if(intervalID2!=0) window.clearInterval(intervalID2);
        init();
        if(openStatus==1) intervalID=setTimeout("FingerSample()", 2000);
    }
    if(modeid==1){
        document.all("dactylogramLogin").style.display = "none";
        document.all("passwordLogin").style.display = "";
        if("<%=message0%>"=="nomatch"){
            document.all("loginModeTable").style.margin = "150px 0 0 475px";
            document.all("loginPasswordTable").style.margin = "0 0 0 570px";
        }else{
            document.all("loginModeTable").style.margin = "0 0 35px 475px";
        }
        if(intervalID!=0) window.clearInterval(intervalID);
        if(intervalID2!=0) window.clearInterval(intervalID2);
    }
}
function VchangeLoginMode(modeid){
    if(modeid==0){
        document.all("dactylogramLoginV").style.display = "";
        document.all("passwordLoginV").style.display = "none";
        setTimeout("FingerSample()", 500);
    }
    if(modeid==1){
        document.all("dactylogramLoginV").style.display = "none";
        document.all("passwordLoginV").style.display = "";
        if(intervalID!=0) window.clearInterval(intervalID);
    }
}
function changeLoginMethod(methodtype){
    alert(methodtype);
    document.getElementById("loginid").disabled = true;
}

//add by sean.yang 2006-02-09 for TD3609
function changeMsg(msg, ele)
{
    if(msg==0){
    	<%if(ismuitlaguage){%>
		$("#validatecodeDiv").css("left", ($(ele).offset().left + $(ele).width() + 10) + "px");
		$("#validatecodeDiv").css("top", $(ele).offset().top + "px");
		$("#validatecodeDiv").show();
		<%}%>
        if(document.all.validatecode.value=='请点击输入验证码') { 
            document.all.validatecode.value='';
        }
    }else if(msg==1){
    	<%if(ismuitlaguage){%>
    	$("#validatecodeDiv").hide();
    	<%}%>
        if(document.all.validatecode.value=='') { 
            document.all.validatecode.value='请点击输入验证码';
        }
    }
}
// -->
</SCRIPT>


<script language="JavaScript">
function click(e) {
	if($.browser.msie){
		if (event.button == 2 || event.button == 3){
			alert('高效源于协同')
			return false;
		}
	}else{
		if (e.which == 2 || e.which == 3){
			alert('高效源于协同')
			return false;
		}
	} 
   
}
document.onmousedown=click
</script>
<%if(needusb!=null&&needusb.equals("1")){%>
    <script language="JavaScript">
        function checkusb1(){ 
          //验证威步key
          try{
            rnd=Math.round(Math.random()*1000000000)
            form1.rnd.value=rnd
            wk = new ActiveXObject("WIBUKEY.WIBUKEY")
            MyAuthLib=new ActiveXObject("WkAuthLib.WkAuth")
            wk.FirmCode = <%=firmcode%>
            wk.UserCode = <%=usercode%>
            wk.UsedSubsystems = 1
            wk.AccessSubSystem() 
            if(wk.LastErrorCode==17){      
              form1.serial.value='0'
              return      
              }      
           if(wk.LastErrorCode>0){
              throw new Error(wk.LastErrorCode)
              }    
            wk.UsedWibuBox.MoveFirst()
            MyAuthLib.Data=wk.UsedWibuBox.SerialText     
            MyAuthLib.FirmCode = <%=firmcode%>
            MyAuthLib.UserCode = <%=usercode%>
            MyAuthLib.SelectionCode= rnd
            MyAuthLib.EncryptWk()
            form1.serial.value= MyAuthLib.Data   
            }catch(err){
              form1.serial.value= '1'      
              return      
            }        
         }
         </script>
         <script language="JavaScript">
             function checkusb3(){
               //需要输入动态口令
			   if(jQuery("#tokenAuthKey").val()==""||jQuery("#tokenAuthKey").val()=="请输入动态口令"){
			      alert("请输入动态口令！");
			      jQuery("#tokenAuthKey").focus();
			      return false;
			   }else if(!isdigit(jQuery("#tokenAuthKey").val())){
			      alert("口令必须为数字");
			      jQuery("#tokenAuthKey").focus();
			      return false;
			   }else if(jQuery("#tokenAuthKey").val().length!=6){
			      alert("口令必须为6位数字");   
			      jQuery("#tokenAuthKey").focus();
			      return false; 
			   }    
             }
             
             function isdigit(s){
				var r,re;
				re = /\d*/i; //\d表示数字,*表示匹配多个数字
				r = s.match(re);
				return (r==s)?true:false;
              }
         </script>
         <script language="JavaScript">
            function checkusb2(){
                //验证海泰key
                try{
                    rnd = Math.round(Math.random()*1000000000);
                    //alert(rnd);
                    form1.rnd.value=rnd;
                    var returnstr = getUserPIN();
                    if(returnstr != undefined){
                        form1.username.value= returnstr;
                        var randomKey = getRandomKey(rnd)
                        form1.serial.value= randomKey;
                        //alert(randomKey);
                    }else{
                        form1.serial.value= '0';
                    }
                }catch(err){
                    form1.serial.value= '0';
                    form1.username.value= '';
                    return;
                }
            }
        </script>
        <OBJECT id="htactx" name="htactx" 
classid=clsid:FB4EE423-43A4-4AA9-BDE9-4335A6D3C74E codebase="HTActX.cab#version=1,0,0,1" style="HEIGHT: 0px; WIDTH: 0px"></OBJECT>
        <script language=VBScript>
            function getUserPIN()
                Dim vbsserial
                dim hCard
                hCard = 0
                on   error   resume   next
                hCard = htactx.OpenDevice(1)'打开设备
                If Err.number<>0 or hCard = 0 then
                    'alert("请确认您已经正确地安装了驱动程序并插入了usb令牌")
                    Exit function
                End if
                dim UserName
                on   error   resume   next
                UserName = htactx.GetUserName(hCard)'获取用户名
                If Err.number<>0 Then
                    'alert("请确认您已经正确地安装了驱动程序并插入了usb令牌2")
                    htactx.CloseDevice hCard
                    Exit function
                End if

                vbsserial = UserName
                htactx.CloseDevice hCard
                getUserPIN = vbsserial
            End function

            function getRandomKey(randnum)
                dim hCard
                hCard = 0   
                hCard = htactx.OpenDevice(1)'打开设备
                If Err.number<>0 or hCard = 0 then
                    'alert("请确认您已经正确地安装了驱动程序并插入了usb令牌4")
                    Exit function
                End if
                dim Digest
                Digest = 0
                on error resume next
                    Digest = htactx.HTSHA1(randnum, len(randnum))
                if err.number<>0 then
                        htactx.CloseDevice hCard
                        Exit function
                end if

                on error resume next
                    Digest = Digest&"04040404"'对SHA1数据进行补码
                if err.number<>0 then
                        htactx.CloseDevice hCard
                        Exit function
                end if

                htactx.VerifyUserPin hCard, CStr(form1.userpassword.value) '校验口令
                'alert HRESULT
                If Err.number<>0 Then
                    'alert("HashToken compute")
                    htactx.CloseDevice hCard
                    Exit function
                End if
                dim EnData
                EnData = 0
                EnData = htactx.HTCrypt(hCard, 0, 0, Digest, len(Digest))'DES3加密SHA1后的数据
                If Err.number<>0 Then 
                    'alert("HashToken compute")
                    htactx.CloseDevice hCard
                    Exit function
                End if
                htactx.CloseDevice hCard
                getRandomKey = EnData
                'alert "EnData = "&EnData
            End function

        </script>
 <%}%>
</script>



<script type="text/javascript">
$(document).ready(function() {
    $(function() {
        
		//alert($("label.overlabel").length)
		$("label.overlabel").overlabel();

        var iconImg="/wui/theme/ecology7/page/images/login/graypoint.png"
        var iconImg_over="/wui/theme/ecology7/page/images/login/redpoint1.png"
    
        $('#slideshow').cycle({
            fx:      'scrollHorz',
            timeout:  7000,
            prev:    '#crossPrev',
            next:    '#crossNext', 
            pager:   '#nav',
            pagerAnchorBuilder: pagerFactory,
            before:  function(currSlideElement, nextSlideElement, options, forwardFlag) {  
			        	if($.browser.msie){
							if($.browser.version=="6.0") {
								DD_belatedPNG.fix('a,div,img,background,span');
							}
						}
			

                        var curIndex=$(currSlideElement).attr("index");
                        var curSlidnavtitle=$($("#slideDemo .slidnavtitle")[curIndex]);
                        if(curSlidnavtitle!=null){
                            curSlidnavtitle.css("background","url('"+iconImg+"') center center no-repeat");
                           // curSlidnavtitle.css("zindex",9999999);
                        }
    
                        var nextIndex=$(nextSlideElement).attr("index");
    
                        var nextSlidnavtitle=$($("#slideDemo .slidnavtitle")[nextIndex]);
                        if(nextSlidnavtitle!=null){
                            var tesy = "url('"+iconImg_over+"') no-repeat";
                            var tempInt = parseInt(nextIndex)  + 1;
                            nextSlidnavtitle.css("background","url('/wui/theme/ecology7/page/images/login/redpoint" + tempInt + ".png') center center  no-repeat");
                            //nextSlidnavtitle.css("zindex",999);
                        }
                    }                       
        }); 
        function pagerFactory(idx, slide) {
            var s = idx > 20 ? ' style="display:none"' : '';
            //alert((idx==0?iconImg_over:iconImg)
            return ' <span class="m-t-5  slidnavtitle hand"  style="background:url('+(idx==0?iconImg_over:iconImg)+') center center no-repeat;position:relative;height:32px;width:32px;z-index:99999">&nbsp;</span>';
        };
        
        $("#login").bind("mouseover", function() {
            $(this).removeClass("lgsm");
            $(this).addClass("lgsmMouseOver");
        });
        $("#login").bind("mouseout", function() {
            $(this).removeClass("lgsmMouseOver");
            $(this).addClass("lgsm");
        });
        
        $(".crossNav a").hover(function() {
            $(this).css("background-position", "0 -29px");
        }, function() {
            $(this).css("background-position", "0 0px");
        });
        
        //检测微软雅黑字体在客户端是否安装
        //fontDetection("sfclsid", $("input[name='fontName']").val());
        //检测用户当前浏览器及其版本
        ieVersionDetection();
        setRandomBg();
    });
    //焦点设置
    //$("input[name='loginid']").focus();
    //----------------------------------
    // form表单提交时check
    //----------------------------------
    
});


function setRandomBg() {
    var imgArray=new Array();
    var imgPath="";
    <%
    List imageId2List=Util.TokenizerString(imageId2,",");
    for(int i=0;i<imageId2List.size();i++){
    	String imgId2Temp=(String)imageId2List.get(i);
    %>
    imgArray[<%=i%>]="<%=imgId2Temp%>";	 
    <%}%>
    var discnt = <%=imageId2List.size()%>;
    
    if(discnt==0){ //系统默认图片
       imgArray=new Array("lg_bg1.jpg","lg_bg2.jpg","lg_bg3.jpg","lg_bg4.jpg","lg_bg5.jpg","lg_bg6.jpg");
       discnt=6;
       imgPath="/wui/theme/ecology7/page/images/login/"
    }else          //用户自定义图片
       imgPath="/LoginTemplateFile/";
        
    var i = Math.floor(Math.random()*discnt);
    var j = Math.floor(Math.random()*discnt);
    var k = Math.floor(Math.random()*discnt);
    
    var img1="",img2="",img3="";
    if(discnt>3){
	    while (i >= discnt ) {
	        i = Math.floor(Math.random()*discnt);
	    }
	    while (j >= discnt || j == i) {
	        j = Math.floor(Math.random()*discnt);
	    }
	    while (k >= discnt || k == i || k == j) {
	        k = Math.floor(Math.random()*discnt);
	    }
	    img1=imgArray[i];
        img2=imgArray[j];
        img3=imgArray[k];
    }else if(discnt==3){
        img1=imgArray[0];
        img2=imgArray[1];
        img3=imgArray[2];
    }else if(discnt==2){
        img1=imgArray[0];
        img2=imgArray[1];
    }else if(discnt==1){
        img1=imgArray[0];
    }
    
    if(discnt>=3){
	    $("#disimg0").css("background", "url(" +imgPath+img1+ ") no-repeat");
	    $("#disimg1").css("background", "url(" +imgPath+img2+ ") no-repeat");
	    $("#disimg2").css("background", "url(" +imgPath+img3+ ") no-repeat");
    }else if(discnt==2){
        $("#disimg0").css("background", "url(" +imgPath+img1+ ") no-repeat");
	    $("#disimg1").css("background", "url(" +imgPath+img2+ ") no-repeat");
    }else if(discnt==1){
        $("#disimg0").css("background", "url(" +imgPath+img1+ ") no-repeat");
    }
}

function ieVersionDetection() {
    if(navigator.userAgent.indexOf("MSIE")>0){ //是否是IE浏览器 
        if(navigator.userAgent.indexOf("MSIE 6.0") > 0){ //6.0
            $("#ieverTips").show();
            return;
        } 
    }
    $("#ieverTips").hide();
}

function fontDetection(objectId, fontName) {
    //加载系统字体
    getSFOfStr(objectId);

    if(!isExistOTF(fontName)) {
        $("#fontTips").show();
    } else {
        $("#fontTips").hide();
    }
}

//---------------------------------------------
// System font detection.  START
//---------------------------------------------
/**
 * detection system font exists.
 * @param fontName font name
 * @return true  :Exist.
 *         false :Does not Exist
 */
function isExistOTF(fontName) {
    if (fontName == undefined 
            || fontName == null 
            || fontName.trim() == '') {
        return false;
    }
    
    if (sysfonts.indexOf(";" + fontName + ";") != -1) {
        return true;
    }
    return false;
};

/**
 * getting to the system font string.
 * @param objectId object's id
 * @return system font string.
 */
function getSFOfStr(objectId) {
    var sysFontsArray = new Array();
    sysFontsArray = getSystemFonts(objectId);
    for(var i=0; i<sysFontsArray.length; i++) {
        sysfonts += sysFontsArray[i];
        sysfonts += ';'
    }
}
//-------------------------------------------
// Save the system font string, 
// used for multiple testing.
//-------------------------------------------
var sysfonts = ';';

/**
 * getting to the system font list
 *
 * @param objectId The id of components of the system font.
 * @return fonts list
 */
function getSystemFonts(objectId) {
    var a = document.all(objectId).fonts.count;
    var fArray = new Array();
    for (var i = 1; i <= document.all(objectId).fonts.count; i++) {
        fArray[i] = document.all(objectId).fonts(i)
    }
    return fArray
}

/**
 * Returns a string, with leading and trailing whitespace
 * omitted.
 * @return  A this string with leading and trailing white
 *          space removed, or this string if it has no leading or
 *          trailing white space.
 */
String.prototype.trim = function(){
    return this.replace(/(^\s*)|(\s*$)/g, "");
}

//---------------------------------------------
// System font detection.  END
//---------------------------------------------
</script>

<STYLE TYPE="text/css">
body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,code,form,fieldset,legend,input,textarea,p,blockquote,th,td,select{        
    font-size:12px;
}


body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,code,form,fieldset,legend,input,textarea,p,blockquote,th,td,select{        
    font-size:11px;
    /*font-family:"微软雅黑","宋体"!important;*/ 
}

/*For slide*/
.slideDivContinar { height: 260px; width: 920px; padding:0; margin:0; overflow: hidden }
.slideDiv {height:260px; width: 920px;top:0; left:0;margin:0;padding:0;}


/*For Input*/
.inputforloginbg{ width:172px;height:21px;border:none;}
.inputforloginbg input{border:none;height:15px;background:none;}

.lgsm {width:76px;height:35px;background:url(/wui/theme/ecology7/page/images/login/lg_login_sbmt.png) 0px 0px no-repeat; border:none;}
.lgsmMouseOver {width:76px;height:35px;background:url(/wui/theme/ecology7/page/images/login/lg_login_sbmt_hover.png) 0px 0px no-repeat; border:none;}

.crossNav{width:100%;height:30px;position:absolute;margin-top:105px;padding-left:30px;padding-right:30px;}
</STYLE>
</head>
<body style="padding:0;margin:0;background:<%="".equals(backgroundColor) ? "#e8ebef" :  backgroundColor%>;margin:0;padding:0;" scroll="auto">
<TABLE width="100%" height="100%" cellpadding="0px" cellspacing="0px">
    <TR>
        <TD align="center">
            <TABLE width="100%" height="510px"   cellpadding="0px"  cellspacing="0px">
                <TR>
                    <TD width="*">&nbsp;</TD>
                    <TD height="610px" valign="top" id="lgcontenttbl" style="width:990px">
                        <form name="form1" action="/login/VerifyLogin.jsp" name="loginForm" method="post" onSubmit="return checkall();">
                            <INPUT type="hidden" value="/wui/theme/ecology7/page/login.jsp?templateId=<%=templateId %>&logintype=<%=logintype%>&gopage=<%=gopage%>" name="loginfile">
                            <INPUT type="hidden" name="logintype" value="<%=logintype %>">
                            <input type="hidden" name="fontName" value="微软雅黑">
                            <input type=hidden name="message" value="<%=message0 %>">
                            <input type=hidden name="gopage" value="<%=gopage%>">
				            <input type=hidden name="formmethod" value="<%=formmethod%>">
				            <INPUT type=hidden name="rnd" >
                            <INPUT type=hidden name="serial"> 
                            <INPUT type=hidden name="username">
                            <input type="hidden" name="isie" id="isie">
                            <table border="0" width="990px" height="610px" align="center" cellpadding="0px" cellspacing="0px" style="background:url(<%=backgroundUrl%>) no-repeat;">
                                <tr>
                                    <td colspan="2" height="65px">
                                        <!--<div style="border:none;margin:0;padding:0;height:75px;overflow:hidden;">
                                             <img alt="ecology" src="/wui/theme/ecology7/page/images/login/logo.png"> 
                                            
                                        </div>-->
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" valign="top" style="padding-top:58px">
                                    <!-- 
                                        <div class="crossNav">
                                            <a id="crossPrev" href="#" style="width:26px;height:30px;float:left;display:block;margin:0;padding:0;background:url('/wui/theme/ecology7/page/images/login/slide-previous.png') 0 0 no-repeat;"></a>
                                            <a id="crossNext" href="#" style="width:26px;height:30px;float:right;display:block;margin:0;padding:0;background:url('/wui/theme/ecology7/page/images/login/slide-next.png') 0 0 no-repeat;" ></a>
                                        </div>
                                     -->
                                        <div id="slideDemo" style="overflow:hidden;width:990px;height:260px;">
                                            <div id="slideshow" class="slideDivContinar" style="margin-left:34;clear:left;top:0px;">
                                            <%
                                             int imgSize=imageId2List.size()>=3||imageId2List.size()==0?3:imageId2List.size();
                                             for(int i=0;i<imgSize&&i<3;i++){
                                            %>
                                             <div id="disimg<%=i%>" class='slideDiv' index='<%=i%>'  style='cursor: pointer;'></div>
                                            <%} %>
                                            </div>
                                            <DIV style="position:relative;height:32px;top:-38;margin-left:34;width:920px;margin-top:0;overflow:hidden;">
                                                <table border="0" width="920px" align="center" cellpadding="0px" cellspacing="0px">
                                                    <tr>
                                                        <td align="center">
                                                            <DIV style="position:relative" align="center" id="nav"></DIV>
                                                        </td>
                                                    </tr>
                                                </table>
                                                
                                            </DIV>
                                        </div>
                                       <div style="width:100%;height:100%;">
                                       		<div style="width:710px;height:100%;float:left;">
                                       			<table  style="margin-top:100px;margin-left:30px;">
														<tr width="100%">
                                                            <td style="width:10px">
                                                            </td>

                                                            <td style="font-size:11px;position:relative;z-index:1000">
																<style>
																	a{color:#123885;}
																</style>
                                                            </td>
                                                        </tr>
                                                        <tr width="100%">
                                                            <td style="width:10px">
                                                            </td>
                                                            <td style="font-size:11px;">
                                                                <span id="ieverTips" style="display:none;color:red;">当前IE为IE6,为了使您有更好的使用效果和浏览速度，强烈建议您<a href="http://windows.microsoft.com/zh-CN/internet-explorer/downloads/ie-8" style="color:red;">升级</a></span>
                                                            </td>
                                                        </tr>
                                                        <tr width="100%">
                                                            <td style="width:10px">
                                                            </td>
                                                            <td style="font-size:11px;">
                                                                <span id="fontTips" style="display:none">电脑中没有安装【微软雅黑】字体，为了使您有更好的使用效果，建议您<a href="/wui/theme/ecology7/page/login.jsp?dlflg=true" style="color:red;">下载</a></span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                       		</div>
                                       		<div style="width:275px;height:100%;float:right;">
                                       			<div style="margin-left:4px;height:40px;margin-top:6px;width:226px;overflow:hidden;">
                                       				<table height="100%" width="100%" cellpadding="0px" cellspacing="0px">
                                       					<tr>
                                       						<td height="100%" valign="bottom" style="color:red;height:14px;padding-left:24px;">
		                                                        <%
		                                                        if(message0.equals("45")){
																%>
																	usb令牌未插入或令牌驱动未安装！请插入或<a href="/wui/theme/ecology7/page/login.jsp?dlflg=true" target="_blank">点此</a>下载驱动安装
																<%} else if(message0.equals("16") && usbMsgparam.equals("1")){
																	focusflg = 1;
																%>
																	usb令牌密码错误！请<a href="/wui/theme/ecology7/page/login.jsp?dlflg=true" target="_blank">点此</a>下载修复usb令牌
																<%} else if(message0.equals("122")){ //
																	focusflg = 1;
																%>
																    动态口令输入错误或与上一次验证成功口令重复，如果多次错误请&nbsp;<a href='/login/syncTokenKey.jsp'>同步令牌</a> 
																<%}else {%>
																	<%=message %>
																<%} %>
                                       						</td>
                                       					</tr>
                                       				</table>
                                                     
                                                </div>
                                                <div  style="padding-left:30px;">
                                                	<style>
														label.overlabel {
															position:absolute;
															top:3px;
															left:5px;
															z-index:1;
															color:#999;
														  }

														  .input_out{
															height:21px;
															width:172px;
															background:url('/wui/theme/ecology7/page/images/login/input_bg_login.gif') no-repeat;position:relative;
														  }

														  .input_inner{
															height:19px;
															width:166px;
															margin-left:3px;
															margin-top:1px;
															border:0px solid red;
															font-size:12px;
														  }

													</style>
                                                	<table width="172px" height="130px">
														<!-- 用户名 -->
														<tr style='height:26px'><td> 	
															<div class="input_out">
																<label for="loginid" class="overlabel">用户名:</label>
																<input  type="text" name="loginid"  id="loginid" class="input_inner"  value="<%=disLoginId %>" >
															</div>												
														</td></tr>

																												
														<!-- 密码 -->
														<tr style='height:26px'><td> 	
															<div class="input_out">
																<label for="userpassword" class="overlabel">密码:</label>
																<input  type="password" name="userpassword"  id="userpassword"   class="input_inner">
															</div>												
														</td></tr>


														<!-- 验证码 -->
														
														<tr style='height:26px;<%if(needvalidate!=1){ %>display:none<%} %>'><td> 	
														<%if(needvalidate==1){%>
															<table width="100%" height="100%" cellspacing="0" cellpadding="0" ><tr>
																<td>
																   <div class="input_out" style="width: 100px;height:19px;"> 
																	<label for="validatecode" class="overlabel">请输入验证码</label>
																	<input type="text" id="validatecode" name="validatecode"  style="width:100px;height:19px;">	
																   </div>
																</td>
																<td>
																	<img border=0 align='absmiddle' style="width:65px;height:19px;" src='/weaver/weaver.file.MakeValidateCode'>
																</td>
															</tr></table>
																<%}%>											
														</td></tr>
														
														<tr style='height:26px;display:none' id="trTokenAuthKey">
														  <td> 	
																<table width="100%" height="100%" cellspacing="0" cellpadding="0" >
																	<tr>
																		<td style="position:relative;">
																			<label for="tokenAuthKey" class="overlabel">请输入动态令牌口令</label>
																			<input type="text" id="tokenAuthKey" name="tokenAuthKey"   class="input_inner">	
																		</td>
																	</tr>
																</table>	
															</td>
														</tr>
                                                        

														<!-- 语言 -->
														
														<tr style='height:26px;<%if(!ismuitlaguage){%>  display:none<%} %>'><td> 
														  	<%if(ismuitlaguage){%>  
																<select id=islanguid name=islanguid style="width:170px;height:19px;">
																	<option value=0>选择系统语言</option>
																	<%=LanguageComInfo.getSelectLan(islanguid) %>  
																</select>	
																<%}%>						
														</td></tr>
														


														<!-- 提交 -->
														<tr><td> 	
															<input type="submit" name="submit" id="login" value="" class="lgsm" tabindex="3" style="margin-left:0px;cursor:pointer;">										
														</td></tr>
													                  	
													</table>
                                                </div>
                                       		</div>
                                       </div>  
                                    </td>
                                </tr>
                         
                                <tr>
                                    <td width="100%">
                                        <div style="border-style:none none none none;border-color:#c6c6c6;border-width:1px 0 0 0;"></divs>
                                    </td>
                                </tr>
                                
                            </table>
                        </form>
                    </TD>
                    <TD width="*">&nbsp;</TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
</TABLE>

<!--detection the system font start -->
<DIV style="LEFT: 0px; POSITION: absolute; TOP: 0px;"><OBJECT ID="sfclsid" CLASSID="clsid:3050f819-98b5-11cf-bb82-00aa00bdce0b" WIDTH="0px" HEIGHT="0px"></OBJECT></DIV>
<script type="text/javascript">

jQuery(document).ready(function () {
	var fflg = <%=focusflg %>;
	if (fflg == 0) {
    	$("input[name='loginid']").focus();
	} else if (fflg == 1) {
    	$("input[name='userpassword']").focus();
	} else if (fflg == 2) {
    	$("input[name='tokenAuthKey']").focus();
	}
});

var userUsbType="0";
jQuery(document).ready(function(){
	$("#isie").val(isIE);
	//需要usb验证，且采用的是动态口令
	if("<%=needusb%>"=="1"){
		jQuery("#loginid").bind("blur",function(){
		    var loginid=jQuery(this).val();
		    if(jQuery(this).val()!=""){ 
		        loginid=encodeURIComponent(loginid);
		        //根据填写的用户名检查是否启用动态口令 
			    jQuery.post("/login/LoginOperation.jsp?method=checkTokenKey",{"loginid":loginid},function(data){
			       userUsbType=jQuery.trim(data);
			       if(userUsbType=="3"){
			          $("#trTokenAuthKey").show();
			       }else{
			          $("#trTokenAuthKey").hide();
			       }        
			    });
		    }
		});
	}
})

jQuery(window).bind("resize",function(){
	jQuery(".overlabel-wrapper").css("position","relative");
})
</script>

</body>
</html>



