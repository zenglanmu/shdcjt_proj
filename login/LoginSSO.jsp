<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,java.util.Map,java.util.HashMap,weaver.general.StaticObj,weaver.hrm.settings.RemindSettings" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.OnLineMonitor"%>
<%@ page import="weaver.systeminfo.template.UserTemplate"%>
<jsp:useBean id="verifylogin" class="weaver.login.VerifyLogin" scope="page" /> 
<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocCheckInOutUtil" class="weaver.docs.docs.DocCheckInOutUtil" scope="page"/>
	
<jsp:useBean id="dactylogramCompare" class="weaver.login.dactylogramCompare" scope="page" /> 
<jsp:useBean id="verifyLogin" class="weaver.login.VerifyLogin" scope="page" />
<jsp:useBean id="verifyLoginDomain" class="weaver.login.VerifyLoginDomain" scope="page" />
<%
try{
	String[] names = new String[2];

	String auth = request.getHeader("Authorization");
	out.println("auth:"+auth+"<BR>");
	if (auth == null){
		response.setStatus(response.SC_UNAUTHORIZED);
		response.setHeader("WWW-Authenticate", "NTLM");
		response.flushBuffer();
		return;
	}
	if (auth.startsWith("NTLM ")){
		byte[] msg = new sun.misc.BASE64Decoder().decodeBuffer(auth.substring(5));
		int off = 0, length, offset;
		if (msg[8] == 1){
			byte z = 0;
			byte[] msg1 = {(byte)'N', (byte)'T', (byte)'L', (byte)'M', (byte)'S', (byte)'S', (byte)'P', 
						z,(byte)2, z, z, z, z, z, z, z,(byte)40, z, z, z, 
						(byte)1, (byte)130, z, z,z, (byte)2, (byte)2,
						(byte)2, z, z, z, z, z, z, z, z, z, z, z, z
					};
			response.setHeader("WWW-Authenticate", "NTLM " + 
			new sun.misc.BASE64Encoder().encodeBuffer(msg1));
			response.sendError(response.SC_UNAUTHORIZED);
			return;
		}else if (msg[8] == 3){
			off = 30;
			length = msg[off+17]*256 + msg[off+16];
			offset = msg[off+19]*256 + msg[off+18];
			String remoteHost = new String(msg, offset, length);
			length = msg[off+1]*256 + msg[off];
			offset = msg[off+3]*256 + msg[off+2];
			String domain = new String(msg, offset, length);
			names[0] = domain;
			length = msg[off+9]*256 + msg[off+8];
			offset = msg[off+11]*256 + msg[off+10];
			String username = new String(msg, offset, length);
			names[1] = username;
			out.println("Username:"+username+"<BR>");
			out.println("RemoteHost:"+remoteHost+"<BR>");
			out.println("Domain:"+domain+"<BR>");
			//return;
		}
	}


	String loginfile = Util.null2String(request.getParameter("loginfile"));
	String logintype = "1";//该值只能是员工，不能是客户
	String forwardpage = Util.null2String(request.getParameter("forwardpage"));
	String message = Util.null2String(request.getParameter("message"));
	String gopage=Util.null2String(request.getParameter("gopage"));
	String RedirectFile ="/main.jsp";
	int  islanguid = 7;//系统使用语言,未使用多语言的用户默认为中文。
	String languid= "7";
	boolean ismutilangua = false;
	StaticObj staticobj = null;
	staticobj = StaticObj.getInstance();
	String multilanguage = (String)staticobj.getObject("multilanguage") ;
	if(multilanguage == null) {
		verifyLogin.checkLicenseInfo();
		multilanguage = (String)staticobj.getObject("multilanguage") ;
	}
	if(multilanguage.equals("y")){
		ismutilangua = true;
	}
	boolean isSyadmin=true;
	//判断分权管理员
	String Sysmanager = "select loginid from hrmresourcemanager where loginid = '"+names[1]+"'";
	RecordSet1.executeSql(Sysmanager);
	if(RecordSet1.next()){
		isSyadmin = false;
	}
	if(names[1].equalsIgnoreCase("sysadmin")){
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
	}
	if(!"".equals(forwardpage)){
		RedirectFile = forwardpage;
	}
	if(gopage.length()>0){
		RedirectFile = "/main.jsp?gopage="+gopage ;
	}
	if (loginfile.equals("")){
		loginfile="/login/Login.jsp?logintype="+logintype+"&gopage="+gopage;
	}
	Cookie[] ck = request.getCookies();
	int ckLength = 0 ;
	try {
		ckLength = ck.length;
	} catch (NullPointerException ex) {
		response.sendRedirect("/login/Login.jsp?logintype="+logintype+"&noAllowIe=yes&formmethod=get") ;
		return ;
	}

	String usercheck = verifyLoginDomain.getUserCheck(request, response, names[0], names[1], logintype, loginfile, message, languid, ismutilangua);
	out.println("usercheck = " + usercheck);
	if(usercheck.equals("15") || usercheck.equals("16")|| usercheck.equals("57") || usercheck.equals("17")|| usercheck.equals("45")|| usercheck.equals("46")|| usercheck.equals("47")|| usercheck.equals("52")|| usercheck.equals("55") || usercheck.equals("60") || usercheck.equals("61")){
		String tmploginid = (String)session.getAttribute("tmploginid");
		if(tmploginid!=null&&names[0].equals(tmploginid)){
			session.setAttribute("tmploginid1",names[0]);
		}else{
			session.removeAttribute("tmploginid");
		}

		response.sendRedirect(loginfile + "&message="+usercheck+"&formmethod=get");
		return;
	}else if(usercheck.equals("19")){
		response.sendRedirect("/system/InLicense.jsp");
		return;
	} else if (usercheck.equals("26")) {
	   response.sendRedirect("/login/Login.jsp?logintype=1&formmethod=get&message="+usercheck);
	   return;
	}else {
        User user = HrmUserVarify.getUser (request , response) ;
        if(user == null) { response.sendRedirect(loginfile ) ; return;}

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
			String tourl = "";
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
					response.sendRedirect(tourl) ;
					return;				  
				}
			} else {
				//tourl = RedirectFile;
				tourl = "/login/RemindLogin.jsp?RedirectFile="+RedirectFile;
				response.sendRedirect(tourl) ;
				return;
			}
		}
	}
}

}catch(Exception e){
	out.println("yanzhongcuowu");
	//e.printStackTrace();
	response.sendRedirect("/login/Login.jsp?logintype=1&message=60&formmethod=get");
	return;
}
%>
