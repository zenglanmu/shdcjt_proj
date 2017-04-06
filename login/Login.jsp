<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,weaver.general.MathUtil,weaver.general.GCONST,weaver.general.StaticObj,
                 weaver.hrm.settings.RemindSettings"%>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.net.*" %>

<%
//-------------------------
// forward到新的登陆页
//-------------------------
if (true) {
    //request.getRequestDispatcher("/wui/theme/ecology7/page/login.jsp").forward(request, response);
    //return;
}
%>

<%@ page import="weaver.hrm.settings.BirthdayReminder" %>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="rci" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="suc" class="weaver.system.SysUpgradeCominfo" scope="page" />
<link rel="stylesheet" type="text/css" href="/css/Weaver.css">
<script type="text/javascript" src="/js/jquery/jquery.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client.js"></script>
<script type="text/javascript">
  //浏览器版本不支持跳转
  var browserName = $.client.browserVersion.browser;             //浏览器名称
  var browserVersion = parseInt($.client.browserVersion.version);//浏览器版本
  var osVersion=$.client.version;                                //操作系统版本
  var browserOS=$.client.os;
  if((browserName == "FF"&&browserVersion<9)||(browserName == "Chrome"&&browserVersion<14)||(browserName == "Safari"&&browserVersion<5&&browserOS!="Windows")){
	  window.location.href="/wui/common/page/sysRemind.jsp?labelid=1&browserName="+browserName+"&browserVersion="+$.client.browserVersion.version;
  }
  
  if(browserName == "IE"&&browserVersion<8&&!document.documentMode){
      window.location.href="/wui/common/page/sysRemind.jsp?labelid=4";
  }
  
  //禁止iphone、ipad访问
  if(browserOS=="iPhone/iPod"||browserOS=="iPad")
     window.location.href="/wui/common/page/sysRemind.jsp?labelid=2&browserOS="+browserOS;
  //禁止windows下safari访问   
  if((browserName == "Safari"&&browserOS=="Windows"))   
     window.location.href="/wui/common/page/sysRemind.jsp?labelid=3&browserOS="+browserOS+"&browserName="+browserName; 
</script>
<%
String formmethod = "post";
if(!"".equals(Util.null2String(BaseBean.getPropValue("ldap", "domain")))){
	formmethod = "get";
}
String host = Util.getRequestHost(request);
GCONST.setHost(host);
String acceptlanguage = Util.null2String(request.getHeader("Accept-Language"));
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
		ajax.open("POST", "LoginOperation.jsp?method=add&cx="+cx, true);
		ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		ajax.send();
		ajax.onreadystatechange = function(){
			if (ajax.readyState == 4) {
				if(ajax.status == 200){
					//alert("isAlive = " + ajax.responseText);
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
		}
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

String templateId="",templateType="",imageId="",loginTemplateTitle="";
int extendloginid=0;

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
//是否使用默认登录页，如果是(logindefault ：1)则不做页面跳转
String loginDefault =Util.null2String(request.getParameter("logindefault"));
if(templateType.equals("site")&&!loginDefault.equals("1")){ //如果是扩展页面需要做跳转
	response.sendRedirect("/page/maint/login/Page.jsp?templateId="+templateId+"&"+request.getQueryString());
	return;
} else if(templateType.equals("H2")){ //如果是扩展页面需要做跳转
    //response.sendRedirect("/wui/page/login.jsp?templateId="+templateId+"&"+request.getQueryString());
	request.getRequestDispatcher("/wui/theme/ecology7/page/login.jsp?templateId=" + templateId + "&" + request.getQueryString()).forward(request, response);
    return;
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
String message0 = Util.null2String(request.getParameter("message")) ;
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
}
session.removeAttribute("tmploginid1");
if(message0.equals("16")) {
	loginid = "";
} 
if(message0.equals("101")) {
    //loginid=Util.null2String((String)session.getAttribute("tmploginid"));
    //session.removeAttribute("tmploginid");
    message=SystemEnv.getHtmlLabelName(20289,7);
}
if(message0.equals("110")) 
{
	loginid = "";
	int sumPasswordLock = Util.getIntValue(settings.getSumPasswordLock(),3);
    message=SystemEnv.getHtmlLabelName(24593,7)+sumPasswordLock+SystemEnv.getHtmlLabelName(18083,7)+"，"+SystemEnv.getHtmlLabelName(24594,7);
}
if((message0.equals("101")||message0.equals("57"))&&loginid.equals("")){
    message="";
}
String logintype = Util.null2String(request.getParameter("logintype")) ;
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
}else if(multilanguage.equals("y")){
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

<%
if(message0.equals("122"))
	message ="动态口令输入错误或与上一次验证成功口令重复，如果多次<br>错误请<a href='/login/syncTokenKey.jsp'>同步口令</a>";
%>


<%@page import="weaver.login.VerifyLogin"%><html>
<head>
<title>泛微协同商务系统</title>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<script language="JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
// -->
</script>

</head>
<SCRIPT language=javascript1.1>
//<!--
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
function changeMsg(msg)
{
    if(msg==0){
        if(document.all.validatecode.value=='请输入以下验证码') 
            document.all.validatecode.value='';
    }else if(msg==1){
        if(document.all.validatecode.value=='') 
            document.all.validatecode.value='请输入以下验证码';
    }
}
// -->
</SCRIPT>


<script language="JavaScript">
function click() {
	if (event.button==2){
		alert('高效源于协同')
	}
}
document.onmousedown=click
</script>
<%if(needusb!=null&&needusb.equals("1")){%>
	<script language="JavaScript">
		function checkusb1(){ 
		 
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
				try{
					rnd = Math.round(Math.random()*1000000000);
					//alert(rnd);
					form1.rnd.value=rnd
					var returnstr = getUserPIN();
					if(returnstr != undefined){
						form1.username.value= returnstr;
						//alert(tusername);
						//alert(tserial);
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
		<OBJECT id=htactx name=htactx 
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

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" margin=0 onload="<%if(!needdactylogram.equals("1")&&!message0.equals("nomatch")){%>javascripts:form1.<%if(!loginid.equals("")){%>userpassword<%}else{%>loginid<%}%>.focus()<%}%>">
<!--********************************************
超时窗口登录界面 (TD 2227)
hubo,050707-->
<%if(request.getSession(true).getAttribute("layoutStyle")!=null && request.getSession(true).getAttribute("layoutStyle").equals("1")){%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="217" background="/images_face/login/tablebg.jpg">
        <form name=form1 action= "VerifyLogin.jsp"  method="<%=formmethod%>" onSubmit="return checkall();">
		  <INPUT type=hidden name="loginfile" value= "/login/Login.jsp?logintype=<%=logintype%>&gopage=<%=gopage%>" >
		  <INPUT type=hidden name="logintype" value="<%=logintype%>">
		  <INPUT type=hidden name="rnd" > 
          <input type=hidden name="gopage" value="<%=gopage%>">
          <input type=hidden name="message" value="<%=message0%>">
          <input type=hidden name="formmethod" value="<%=formmethod%>">
          
		  <INPUT type=hidden name="serial">
		  <INPUT type=hidden name="username">
		  <input type="hidden" name="isie" id="isie">
                  <tr> 
                    <td height="75">&nbsp;</td>
					<td height="75" valign="bottom" style="color:#FF0000;font-size:9pt">
					<%
					if(message.equals("")){
						int languageidweaver = Util.getIntValue(Util.getCookie(request,"languageidweaver"),7);
						out.println(SystemEnv.getErrorMsgName(19,languageidweaver));
					}else
						out.println(message);
					%></td>
                  </tr>
                  <tr> 
                    <td height="20" width="150">
                    </td>
                    <td height="20"> 
                      <input type="text" id="loginid" name="loginid" class="stedit" size="10" value="<%=rci.getLoginID(Util.null2String(Util.getCookie(request,"loginidweaver")))%>" readonly>
                    </td>
                  </tr>
                  <tr> 
                    <td colspan="2" height="12"></td>
                  </tr>
                  <tr> 
                    <td height="20" width="150"></td>
                    <td height="20"> 
                      
                    <%
                    if(("101".equals(message0)||"57".equals(message0)) && !"".equals(loginid))
                    {
                    %>
                      <input type="text" name="userpassword" class="stedit" size="10" >
                    <%
                    } 
                    else
                    {
                    %>
                    <input type="password" name="userpassword" class="stedit" size="10" >
                    <%
                    }
                    %>
                    </td>
                  </tr>
                  <%if(needvalidate==1){%>
                  <tr> 
                    <td height="18" width="150"></td>
                    <td height="18"> 
                 <input id="validatecode" name="validatecode" type="text" size="15" value="请输入以下验证码" onfocus="changeMsg(0)" onblur="changeMsg(1)"></td>
                     </tr>
                  <tr> 
                  <td height="18" width="150"></td>
                  <td height="18"> 
                 <img border=0 align='absmiddle'  src='/weaver/weaver.file.MakeValidateCode'>
                   </td>
                  </tr>
                  <tr> 
                    <td colspan="2" height="5"></td>
                  </tr>
                <%}else{%>
                  <tr> 
                    <td colspan="2" height="18">&nbsp; </td>
                  </tr>
                  <%}%>

                  <tr> 
                    <td width=150 height="20">&nbsp;</td>
                    <td height="20"> 
                      <input type="submit" class="submit" name="Submit" value="&gt;&gt; 登 录">
                    </td>
                  </tr>
                  <tr> 
                    <td>&nbsp;</td>
                  </tr>
                </form>
              </table>
<!--********************************************-->
<%}else{%>
	<%
	
	
	if(templateType.equals("V")){
	%>
<table width="100%" height=100% border="0" cellspacing="0" cellpadding="0"  bgcolor="#FFFFFF">
  <tr> 
    <td width="489" rowspan="2" valign="top" style="<%if(imageId.equals("")){out.println("background-image:url(/images_face/login/left.jpg)");}else{out.println("background-image:url(/LoginTemplateFile/"+imageId+")");}%>;background-repeat:no-repeat"></td>
    <td valign="top"> 

      <div align="left">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="260">&nbsp;</td>
          </tr>
          <tr>
            <td height="217">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" height="217" background="/images_face/login/tablebg.jpg">
        <form name=form1 action= "VerifyLogin.jsp"  method="<%=formmethod%>" onSubmit="return checkall();">
		  <INPUT type=hidden name="loginfile" value= "/login/Login.jsp?logintype=<%=logintype%>&gopage=<%=gopage%>" >
		  <INPUT type=hidden name="logintype" value="<%=logintype%>">
		  <INPUT type=hidden name="rnd" > 
          <input type=hidden name="gopage" value="<%=gopage%>">
          <input type=hidden name="message" value="<%=message0%>">
		  <INPUT type=hidden name="serial">
		  <INPUT type=hidden name="username">
		  <input type="hidden" name="isie" id="isie">
		  <input type=hidden name="formmethod" value="<%=formmethod%>">
                  
                  <%if(GCONST.getONDACTYLOGRAM()){%>
                  <tr> 
                    <td height="25" colspan=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <font size=2 color="black"><B>登录方式 ：</B></font>
                    <input type="radio" id="onDactylogramOrPassword" name="onDactylogramOrPassword" value="0" onclick="VchangeLoginMode(0)" <%if(needdactylogram.equals("1")||message0.equals("nomatch")){%>checked<%}%>><font color="black">指纹登录</font>
                    <input type="radio" id="onDactylogramOrPassword" name="onDactylogramOrPassword" value="1" onclick="VchangeLoginMode(1)" <%if(!needdactylogram.equals("1")){if(!message0.equals("nomatch")){%>checked<%}}else{%>disabled<%}%>><font color="black">密码登录</font>
                    </td>
                  </tr>
                  
                  <tr> 
                    <td height="30" colspan=2>&nbsp;</td>
                  </tr>
                  <%}else{%>
                  <tr> 
                    <td height="42" colspan=2>&nbsp;</td>
                  </tr>
                  <%}%>

                	<tr><td height="126" colspan=2>
                		<div id="dactylogramLoginV" name="dactylogramLoginV" <%if(needdactylogram.equals("1")||message0.equals("nomatch")){%>style="display:''"<%}else{%>style="display:none"<%}%>>
                	<table width="100%">
                		<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                	<img id="dactylogramLoginImgId" src="/images/loginmode/3.gif">
                	<input type="hidden" id="dactylogram" name="dactylogram" value="">
                		</td></tr>
                	</table>
                	</div>                	
                	
                	<div id="passwordLoginV" name="passwordLoginV" <%if(needdactylogram.equals("1")||message0.equals("nomatch")){%>style="display:none"<%}else{%>style="display:''"<%}%>>
                	<table width="100%">
                  
                  <tr> 
                    <td height="28">&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td height="28" valign="bottom" style="color:#FF0000;font-size:9pt"><%=message%></td>
                  </tr>
                	
                  <tr> 
                    <td height="20" width="150">&nbsp;</td>
                    <td height="20"> 
                      <input type="text" id="loginid" name="loginid" value="<%=loginid%>"  class="stedit"  <%if(!loginid.equals("")){%>readonly style="background-color:GrayText;"<%}%> size="15">
                    </td>
                  </tr>

                  <tr> 
                    <td colspan="2" height="12"></td>
                  </tr>


                  <tr> 
                    <td height="20" width="150">&nbsp;</td>
                    <td height="20"> 
                    <%
                    if(("101".equals(message0)||"57".equals(message0)) && !"".equals(loginid))
                    {
                    %>
                      <input type="text" name="userpassword" class="stedit" size="15" >
                    <%
                    } 
                    else
                    {
                    %>
                    <input type="password" name="userpassword" class="stedit" size="15" >
                    <%
                    }
                    %>
                    </td>
                  </tr>


                  <%if(needvalidate==1){%>
                  <tr> 
                    <td height="18" width="150">&nbsp;</td>
                    <td style="padding:3 0"> 
                		 <input id="validatecode" name="validatecode" type="text" size="15" value="请输入以下验证码" onfocus="changeMsg(0)" onblur="changeMsg(1)">
					</td>
                  </tr>

 
                  <tr> 
	                  <td height="18" width="150">&nbsp;</td>
	                  <td style="padding:3 0"> 
	                 	<img border=0 align='absmiddle'  src='/weaver/weaver.file.MakeValidateCode'>
	                   </td>
                  </tr>
					 
              
                <%}%>
					<tr> 
							<td height="18" width="150">&nbsp;</td>
							<td style="padding:3 0">
							  <div style="display: none;" id="trTokenAuthKey">
		                          <input type="text" id="tokenAuthKey"  name="tokenAuthKey" value="请输入动态口令" style="width:115px"/>
			                  </div>
								<%if(ismuitlaguage){%>    
									<select id=islanguid name=islanguid> 	
										<option value=0>选择系统语言</option>
										<%=LanguageComInfo.getSelectLan(islanguid) %>   
								    </select>
								<%}%>
							</td>
					</tr>

                  <tr> 
                    <td width=150 height="20">&nbsp;</td>
                    <td height="20"> 
                      <input type="submit" class="submit" name="Submit" value="&gt;&gt; 登 录">
                    </td>
                  </tr>
                  
                </table></div></td></tr>

                  <tr> 
                    <td>&nbsp;</td>
                  </tr>
                </form>
              </table>
            </td>
          </tr>
          <tr>
            <td height="19" background="/images_face/login/url.jpg">&nbsp;</td>
          </tr>
		  <tr>          
			  <td>	
				 <table width="100%" height=100% border="0" cellspacing="20" cellpadding="0"  bgcolor="#FFFFFF">
				 <tr> 
				 <td><span style="line-height: 20px"> <font style="color:#990000;font-weight: bold">提示：</font>本系统需要运行在<font style="color:#5F7DD0;font-weight: bold">IE6.0</font>以及使用<font style="color:#5F7DD0;font-weight: bold">Microsoft 的虚拟机(VM)</font>；如果您是首次登录系统请确认您的浏览器是否是IE6.0；Microsoft 的虚拟机(VM)下载请直接点击<a href="/weaverplugin/msjavx86.exe"><font style="color:#5F7DD0;font-weight: bold;TEXT-DECORATION: underline">这里</font></a>下载安装，该插件只需在首次下载安装后即可，不需要重复安装。e-cology系统的插件包可到<%if(acceptlanguage.indexOf("zh-tw")>-1||acceptlanguage.indexOf("zh-hk")>-1){%><a href="/weaverplugin/Ecologyplugin_tw.exe"><%}else{ %><a href="/weaverplugin/Ecologyplugin.exe"><%} %><font style="color:#5F7DD0;font-weight: bold;TEXT-DECORATION: underline">这里</font></a>下载安装，安装后，必须关闭掉所有的IE页面，该插件包可以重复安装。</span>
				 </td>
				 </tr>
				 </table>
			  </td>
          </tr>
        </table>
      </div>
    </td>
  </tr>
</table>
<%
	}else{
%>	
	<form name=form1 action= "VerifyLogin.jsp"  method="<%=formmethod%>" onSubmit="return checkall();">
		  <INPUT type=hidden name="loginfile" value= "/login/Login.jsp?logintype=<%=logintype%>&gopage=<%=gopage%>" >
		  <INPUT type=hidden name="logintype" value="<%=logintype%>">
		  <INPUT type=hidden name="rnd" > 
          <input type=hidden name="gopage" value="<%=gopage%>">
          <input type=hidden name="message" value="<%=message0%>">
		  <INPUT type=hidden name="serial">
		  <INPUT type=hidden name="username">
		  <input type="hidden" name="isie" id="isie">
		  <input type=hidden name="formmethod" value="<%=formmethod%>">

<table width="100%" cellspacing="0" cellpadding="0">
  <tr>
    <td align="right"><img src="/images_face/login/weaverlogo.gif" width="325" height="50"></td>
  </tr>
  <tr>
    <td style="height:370px;<%if(imageId.equals("")){out.println("background-image:url(/images_face/login/loginLanguage.jpg)");}else{out.println("background-image:url(/LoginTemplateFile/"+imageId+")");}%>;background-repeat:no-repeat">
   <%if(GCONST.getONDACTYLOGRAM()){%> 	
	 <table id="loginModeTable" <%if(message0.equals("nomatch")||needdactylogram.equals("1")){%>style="margin:100px 0 0 475px;border-collapse:collapse;color:white"<%}else{%>style="margin:0 0 35px 475px;border-collapse:collapse;color:white"<%}%>>
	 	<tr><td>
			<font size=2 color="black"><B>登录方式 </B></font>
	 		<input type="radio" id="onDactylogramOrPassword" name="onDactylogramOrPassword" value="0" onclick="changeLoginMode(0)" <%if(needdactylogram.equals("1")||message0.equals("nomatch")){%>checked<%}%>><font color="black">指纹登录</font>
	 		<input type="radio" id="onDactylogramOrPassword" name="onDactylogramOrPassword" value="1" onclick="changeLoginMode(1)" <%if(!needdactylogram.equals("1")){if(!message0.equals("nomatch")){%>checked<%}}else{%>disabled<%}%>><font color="black">密码登录</font>
	 	</td></tr>
	 </table>
	 
	<div id="dactylogramLogin" name="dactylogramLogin" <%if(needdactylogram.equals("1")||message0.equals("nomatch")){%>style="display:''"<%}else{%>style="display:none"<%}%>>
		<img id="dactylogramLoginImgId" src="/images/loginmode/3.gif" style="margin:1 0 0 475px">
		<input type="hidden" id="dactylogram" name="dactylogram" value="">
	</div>
	<%}%>
	 <div id="passwordLogin" name="passwordLogin" <%if(needdactylogram.equals("1")||message0.equals("nomatch")){%>style="display:none"<%}else{%>style="display:'';position:absolute;posTop:100px;top:78px;margin-top:0px"<%}%>>
	 <table id="loginPasswordTable" style="margin:135px 0 0 560px;border-collapse:collapse;color:white;height: 28px;"><tr><td><%=message%>&nbsp;</td></tr></table>
	 
	 <input id="loginid" name="loginid" type="text" size="15" value="<%=loginid%>" <%if(!loginid.equals("")){%>readonly<%}%> style="<%if(!loginid.equals("")){%>background-color:GrayText;<%}%>margin:0px 0 0 560px;height:22px;width:115px"><br/>
	 <%
	 if(("101".equals(message0)||"57".equals(message0)) && !"".equals(loginid))
	 {
	 %>
	 <input name="userpassword" type="text" size="15" style="margin:6px 0 0 560px;height:22px;width:115px"><br/>
	 <%
	 }
	 else
	 {
	 %>
	 <input name="userpassword" type="password" size="15" style="margin:6px 0 0 560px;height:22px;width:115px"><br/>
	 <%
	 } 
	 %>
	     <%if(needvalidate==1){%>
	     <input id="validatecode" name="validatecode" type="text" size="15" style="margin:6px 0 0 560px" value="请输入以下验证码" onfocus="changeMsg(0)" onblur="changeMsg(1)"><br/>
		 <img border=0 align='absmiddle'  src='/weaver/weaver.file.MakeValidateCode' style="margin:6px 0 0 560px"><br/>
		 <div style="display: none;" id="trTokenAuthKey">
		        <input type="text" id="tokenAuthKey"  name="tokenAuthKey" value="请输入动态口令" style="width:115px;margin:6px 0 0 560px;"/>
		 </div>
			<%if(ismuitlaguage){%>
			<select class=InputStyle id=islanguid name=islanguid style="width:100px;margin:6px 0 0 560px">
			<option value=0>选择系统语言</option>
			<%=LanguageComInfo.getSelectLan(islanguid) %>
	       </select></br>
			<%}%>
			<button type="submit" style="border:1px #FF0000 solid;BORDER-RIGHT: medium none; BORDER-TOP: medium none; BACKGROUND-IMAGE: url(/images_face/login/dengru.gif); OVERFLOW: hidden; BORDER-LEFT: medium none; WIDTH: 78px; CURSOR: hand; BORDER-BOTTOM: medium none; BACKGROUND-REPEAT: no-repeat; HEIGHT: 28px;margin:10px 0 0 608px">
		 <%}else{%>
		    <div style="display: none;" id="trTokenAuthKey">
		        <input type="text" id="tokenAuthKey"  name="tokenAuthKey" value="请输入动态口令" style="width:115px;margin:6px 0 0 560px;"/>
			</div>
			<%if(ismuitlaguage){%>
			<select class=InputStyle id=islanguid name=islanguid style="width:100px;margin:6px 0 0 560px">
			<option value="0">选择系统语言</option>
			<%=LanguageComInfo.getSelectLan(islanguid) %>
	       </select></br>
			<%}%>
			<button type="submit" style="border:1px #FF0000 solid;BORDER-RIGHT: medium none; BORDER-TOP: medium none; BACKGROUND-IMAGE: url(/images_face/login/dengru.gif); OVERFLOW: hidden; BORDER-LEFT: medium none; WIDTH: 78px; CURSOR: hand; BORDER-BOTTOM: medium none; BACKGROUND-REPEAT: no-repeat; HEIGHT: 28px;margin:7px 0 0 608px">
		
	<%} %> 
	</div>
	
	 </td>
  </tr>
</table>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="2%" valign="top"><img src="/images_face/login/copyright.gif" width="449" height="80"></td>
    <td width="98%">
    <table width="97.5%"  border="0" cellspacing="0" cellpadding="0">
      <tr><td>
            <span style="line-height: 20px; font-size:9pt" cellspacing="50" cellpadding="50"><font style="color:#990000;font-weight: bold">提示：</font>本系统需要运行在<font style="color:#5F7DD0;font-weight: bold">IE6.0</font>以及使用<font style="color:#5F7DD0;font-weight: bold">Microsoft 的虚拟机(VM)</font>；如果您是首次登录系统请确认您的浏览器是否是IE6.0；Microsoft 的虚拟机(VM)下载请直接点击<a href="/weaverplugin/msjavx86.exe"><font style="color:#5F7DD0;font-weight: bold;TEXT-DECORATION: underline">这里</font></a>下载安装，该插件只需在首次下载安装后即可，不需要重复安装。e-cology系统的插件包可到<%if(acceptlanguage.indexOf("zh-tw")>-1||acceptlanguage.indexOf("zh-hk")>-1){%><a href="/weaverplugin/Ecologyplugin_tw.exe"><%}else{ %><a href="/weaverplugin/Ecologyplugin.exe"><%} %><font style="color:#5F7DD0;font-weight: bold;TEXT-DECORATION: underline">这里</font></a>下载安装，安装后，必须关闭掉所有的IE页面，该插件包可以重复安装。</span>
      </td></tr>
    </table>
    </td>
  </tr>
</table>

</form>
<%}}%>

<script type="text/javascript">
var userUsbType="0";
jQuery(document).ready(function(){
	var isIE = jQuery.client.browser=="Explorer"?"true":"false";
	$("#isie").val(isIE);
	//需要usb验证，且采用的是动态口令
	if("<%=needusb%>"=="1"){
	    //alert(jQuery("#loginid").length);
		jQuery("#loginid").bind("blur",function(){
		    var loginid=jQuery(this).val();
		    if(jQuery(this).val()!=""){ 
		        loginid=encodeURIComponent(loginid);
		        //根据填写的用户名检查是否启用动态口令 
			    jQuery.post("/login/LoginOperation.jsp?method=checkTokenKey",{"loginid":loginid},function(data){
			       userUsbType=jQuery.trim(data);
			       if(userUsbType=="3"){
			          $("#trTokenAuthKey").show(); 
			          jQuery("#tokenAuthKey").bind("focus",function(){
			              if(jQuery(this).val()=="请输入动态令牌口令")
			                 jQuery(this).val("");
			          }).bind("blur",function(){
			              if(jQuery(this).val()=="")
			                 jQuery(this).val("请输入动态令牌口令");
			          });
			       }else{
			          $("#trTokenAuthKey").hide();
			       }        
			    });
		    }
		});
	}
})
</script>
</body>
<%
if(GCONST.getONDACTYLOGRAM())
{
%>
<object classid="clsid:1E6F2249-59F1-456B-B7E2-DD9F5AE75140" width="1" height="1" id="dtm" codebase="WellcomJZT998.ocx"></object>
<%
}
%>
</html>
