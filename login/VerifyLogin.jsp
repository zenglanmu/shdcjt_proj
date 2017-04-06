<%@ page import="weaver.general.Util,
                 java.util.Map,
                 java.util.HashMap,weaver.general.StaticObj,
                 weaver.hrm.settings.RemindSettings,
                 weaver.general.GCONST" %>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.OnLineMonitor"%>
<%@ page import="weaver.systeminfo.template.UserTemplate"%>
<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocCheckInOutUtil" class="weaver.docs.docs.DocCheckInOutUtil" scope="page"/>
	
<jsp:useBean id="dactylogramCompare" class="weaver.login.dactylogramCompare" scope="page" /> 
<jsp:useBean id="VerifyLogin" class="weaver.login.VerifyLogin" scope="page" /> 
<jsp:useBean id="VerifyPasswdCheck" class="weaver.login.VerifyPasswdCheck" scope="page" />
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%

String loginfile = Util.null2String(request.getParameter("loginfile")) ;
String logintype = Util.null2String(request.getParameter("logintype")) ;
String loginid = Util.null2String(request.getParameter("loginid")) ;
String forwardpage = Util.null2String(request.getParameter("forwardpage")) ;
String userpassword = Util.null2String(request.getParameter("userpassword"));
String message = Util.null2String(request.getParameter("message"));
String isIE = Util.null2String(request.getParameter("isie"));
if(!isIE.equals("false")){
	isIE = "true";
}
session.setAttribute("browser_isie",isIE);
//xiaofeng
int  islanguid = 7;//系统使用语言,未使用多语言的用户默认为中文。
String languid= "7";
boolean ismutilangua = false;
StaticObj staticobj = null;
staticobj = StaticObj.getInstance();
String multilanguage = (String)staticobj.getObject("multilanguage") ;
if(multilanguage == null) {
	VerifyLogin.checkLicenseInfo();
	multilanguage = (String)staticobj.getObject("multilanguage") ;
}else if(multilanguage.equals("y")){
	ismutilangua = true;
}
boolean isSyadmin=true;
//判断分权管理员
String Sysmanager = "select loginid from hrmresourcemanager where loginid = '"+loginid+"'";
RecordSet1.executeSql(Sysmanager);
if(RecordSet1.next()){
	isSyadmin = false;
}
if(loginid.equalsIgnoreCase("sysadmin")){
	isSyadmin = false;
}
if(isSyadmin){
	if(ismutilangua){
			islanguid = Util.getIntValue(request.getParameter("islanguid"),0);
				if(islanguid == 0){//如何未选择，则默认系统使用语言为简体中文
					islanguid = 7;
				}
		languid = String.valueOf(islanguid); 
		Cookie syslanid = new Cookie("Systemlanguid",languid);
		syslanid.setMaxAge(-1);
		syslanid.setPath("/");
		response.addCookie(syslanid);
	}
}/*else{
	Cookie syslanid = new Cookie("Systemlanguid",languid);
	syslanid.setMaxAge(-1);
	syslanid.setPath("/");
	response.addCookie(syslanid);
}*/
String serial=Util.null2String(request.getParameter("serial"));
String username = Util.null2String(request.getParameter("username"));
String rnd=Util.null2String(request.getParameter("rnd"));
String loginPDA=Util.null2String(request.getParameter("loginPDA"));
session.setAttribute("loginPAD",loginPDA);
String RedirectFile="/main.jsp"; 
if(!"".equals(forwardpage))
{
	RedirectFile = forwardpage;
}
if (loginPDA.equals("1"))
{
RedirectFile= "/mainPDA.jsp";
}
//add by sean.yang 2006-02-09 for TD3609
String validatecode=Util.null2String(request.getParameter("validatecode"));

//modify by mackjoe at 2005-11-28 td3282 邮件提醒登陆后直接到指定流程
String gopage=Util.null2String(request.getParameter("gopage"));
if(!"".equals(gopage) && !gopage.contains("main.jsp")){
	session.setAttribute("gopageOrientation",gopage);
}
if(gopage.trim().equals("")&&session.getAttribute("gopages")!=null)
{
	try{
		gopage = (String)session.getAttribute("gopages");
		session.removeAttribute("gopages");
	}catch(Exception e){}
}
if(gopage.length()>0){
    RedirectFile = "/main.jsp?gopage="+gopage ;
}
if (loginfile.equals("")) loginfile="/login/Login.jsp?logintype="+logintype+"&gopage="+gopage;
//end by mackjoe
// modify by dongping for TD1340 in 2004.11.05
// 用户登陆时要对cookies是否开放作判断，如果没有，则会给出提示!
String logincookid = Util.getEncrypt(loginid);
String testcookie = "";
if (!loginPDA.equals("1")){//手机登陆不要阻止cookie
	testcookie = new java.util.Date().getTime()+"+"+logincookid;
%>
<script>
document.cookie='logincookiecheck=<%=testcookie%>';
</script>
<%
}
String dactylogram = Util.null2String(request.getParameter("dactylogram"));//指纹特征
boolean compareFlag = false;
if(!dactylogram.equals("")){

	//String dactylogramOfCookie = Util.null2String(Util.getCookie(request,"dactylogram"));
	//String assistantDactylogramOfCookie = Util.null2String(Util.getCookie(request,"assistantdactylogram"));
	//if(!dactylogramOfCookie.equals("")) dactylogramCompare.setCookieDactylogram(dactylogramOfCookie);
	//if(!assistantDactylogramOfCookie.equals("")) dactylogramCompare.setCookieAssistantDactylogram(assistantDactylogramOfCookie);
	
	compareFlag = dactylogramCompare.executeCompare(dactylogram);
	if(compareFlag){
		loginid = dactylogramCompare.getLoginId();
		userpassword = dactylogramCompare.getPassword();
		logintype = "1";
	}else{
		response.sendRedirect("/login/Login.jsp?&message=nomatch") ;
		return;
	}
}

if (logintype.equals("2")){
	if(!gopage.equals("")){
 		RedirectFile = "/portal/main.jsp?gopage="+gopage ;
	}else{
		RedirectFile = "/portal/main.jsp" ;
	}
}

String tourl = "";
if(loginid.equals("") || userpassword.equals("") ) response.sendRedirect(loginfile + "&message=18") ;
else  { RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
    String needusb=settings.getNeedusb();
	String usercheck ;
	String notusbusercheck = "";
	if(compareFlag){
		usercheck= VerifyLogin.getUserCheckByDactylogram(request,response,loginid,userpassword,logintype,loginfile,validatecode,message,languid,ismutilangua);
	}else{
		boolean canpass = VerifyPasswdCheck.getUserCheck(loginid,"",1);
		if(!canpass){
			if(needusb!=null&&needusb.equals("1")){
				notusbusercheck= VerifyLogin.getUserCheck(request,response,loginid,userpassword,logintype,loginfile,validatecode,message,languid,ismutilangua);
				request.getSession(true).removeAttribute("weaver_user@bean");
				
				usercheck= VerifyLogin.getUserCheck(request,response,loginid,userpassword,serial,username,rnd,logintype,loginfile,validatecode,message,languid,ismutilangua);
			
			}else{
				usercheck= VerifyLogin.getUserCheck(request,response,loginid,userpassword,logintype,loginfile,validatecode,message,languid,ismutilangua);
			}
		}else{
			usercheck = "110";
		}
	}
	VerifyPasswdCheck.getUserCheck(loginid,usercheck,2);
	if(usercheck.equals("15")|| usercheck.equals("57") || usercheck.equals("17")|| usercheck.equals("45")|| usercheck.equals("46")|| usercheck.equals("47")|| usercheck.equals("52")|| usercheck.equals("55"))
    {
        String tmploginid=(String)session.getAttribute("tmploginid");
        if(tmploginid!=null&&loginid.equals(tmploginid))
           session.setAttribute("tmploginid1",loginid);
        else
           session.removeAttribute("tmploginid");
        response.sendRedirect(loginfile + "&message="+usercheck) ;
	}else if(usercheck.equals("16")){
		String usbMsgparam = "";
		if(needusb!=null&&needusb.equals("1") && !"16".equals(notusbusercheck)){
			if (!"0".equals(serial)) {
				usbMsgparam = "&usbparammsg=1";
			}
		}
		request.getSession(true).removeAttribute("weaver_user@bean");
		session.setAttribute("tmploginid1",loginid);
		response.sendRedirect(loginfile + "&message="+usercheck + usbMsgparam) ;
	}else if(usercheck.equals("19")){
		response.sendRedirect("/system/InLicense.jsp") ;
	} else if (usercheck.equals("26")) {
		if (!loginPDA.equals("1")) {
			response.sendRedirect("/login/Login.jsp?logintype=1&message="+usercheck);
		} else {
			response.sendRedirect("/login/LoginPDA.jsp?logintype=1&message="+usercheck);
		}
	}else if(usercheck.equals("101")){
        session.setAttribute("tmploginid",loginid);
        session.setAttribute("tmploginid1",loginid);
        if (!loginPDA.equals("1")) {
        response.sendRedirect("/login/Login.jsp?logintype=1&message="+usercheck) ;
		}
		else
		{
		response.sendRedirect("/login/LoginPDA.jsp?logintype=1&message="+usercheck) ;
		}
    }
    else if(usercheck.equals("110"))
	{
		if (!loginPDA.equals("1"))
		{
			response.sendRedirect("/login/Login.jsp?logintype=1&message=" + usercheck);
		}
		else
		{
			response.sendRedirect("/login/LoginPDA.jsp?logintype=1&message=" + usercheck);
		}
	}else if(usercheck.equals("122")){   //动态密码错误
		response.sendRedirect("/login/Login.jsp?logintype=1&message=" + usercheck);
	}
	else if(usercheck.equals("120")){    //未绑定动态令牌
		response.sendRedirect("/login/bindTokenKey.jsp");
	}
	else {
            if("1".equals(session.getAttribute("istest"))){
                session.removeAttribute("istest");
            }
            User user = HrmUserVarify.getUser (request , response) ;
            if(user == null) { response.sendRedirect(loginfile ) ; return;}

            session.setAttribute("password",userpassword);
            if("1".equals(logintype)){
            session.setAttribute("moniter", new OnLineMonitor("" + user.getUID(),user.getLoginip(),application));
            }
            Map logmessages=(Map)application.getAttribute("logmessages");
                if(logmessages==null){
                logmessages=new HashMap();
                logmessages.put(""+user.getUID(),"");
                application.setAttribute("logmessages",logmessages);
                }
	        session.setAttribute("logmessage",usercheck);
	        session.setAttribute("fromlogin","yes");
            session.removeAttribute("tmploginid");

            DocCheckInOutUtil.docCheckInWhenVerifyLogin(user,request);

		//小窗口登录 (TD 2227)
		//hubo,050707
		if(request.getSession(true).getAttribute("layoutStyle")!=null && request.getSession(true).getAttribute("layoutStyle").equals("1")){
			session.setAttribute("istimeout","no");
%>
			<SCRIPT LANGUAGE=VBS>
				window.parent.returnvalue = "1"
				window.parent.close
			</script>
<%
		}else{
			if (loginPDA.equals("1")){
				response.sendRedirect(RedirectFile) ;
				return;
			}
			if("2".equals(logintype)){
				response.sendRedirect(RedirectFile) ;
				return;
			} else {
				
				
				UserTemplate  ut=new UserTemplate();
				
				ut.getTemplateByUID(user.getUID(),user.getUserSubCompany1());
				int templateId=ut.getTemplateId();
				int extendTempletid=ut.getExtendtempletid();
				int extendtempletvalueid=ut.getExtendtempletvalueid();
				String defaultHp = ut.getDefaultHp();
				session.setAttribute("defaultHp",defaultHp);
				
				if(extendTempletid!=0){
					rsExtend.executeSql("select id,extendname,extendurl from extendHomepage  where id="+extendTempletid);
					if(rsExtend.next()){
						int id=Util.getIntValue(rsExtend.getString("id"));
						//String extendname=Util.null2String(rsExtend.getString("extendname"));	
						String extendurl=Util.null2String(rsExtend.getString("extendurl"));	
						rs.executeSql("select * from extendHpWebCustom where templateid="+templateId);
						String defaultshow ="";
						if(rs.next()){
							defaultshow = Util.null2String(rs.getString("defaultshow"));
						}
						String param = "";
						if(!defaultshow.equals("")){
							param ="&"+defaultshow.substring(defaultshow.indexOf("?")+1);
						}
						if(gopage.length()>0){
							tourl = "/login/RemindLogin.jsp?RedirectFile="+extendurl+"/index.jsp?templateId="+templateId+param+"&gopage="+gopage;
						}else{			
							tourl = "/login/RemindLogin.jsp?RedirectFile="+extendurl+"/index.jsp?templateId="+templateId+param;
						}
						//tourl = extendurl+"/index.jsp?templateId="+templateId+param;
						//response.sendRedirect(extendurl+"/index.jsp?templateId="+templateId+param) ;
						//return;		
					}
				} else {
					//tourl = RedirectFile;
					tourl = "/login/RemindLogin.jsp?RedirectFile="+RedirectFile;
					//response.sendRedirect(RedirectFile) ;
					//return;
				}
			}
		}
	}
}
//手机不检测
if (!loginPDA.equals("1")){
%>
<script>
try {
	if(document.cookie.indexOf('logincookiecheck=<%=testcookie%>')==-1) {
		document.location.href = '/login/Login.jsp?logintype=<%=logintype%>&noAllowIe=yes';
	}
	else {
		document.location.href = '<%=tourl%>';
	}
}
catch(e){
	document.location.href = '/login/Login.jsp?logintype=<%=logintype%>&noAllowIe=yes';
}
</script>
<%
}
else {
	response.sendRedirect(tourl) ;
	return;
}
%>