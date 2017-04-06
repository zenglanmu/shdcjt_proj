<jsp:useBean id="TestWorkflowCheckInitWui" class="weaver.workflow.workflow.TestWorkflowCheck" scope="page"/>
<LINK href="/js/jquery/jquery_dialog.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" language="javascript" src="/js/jquery/jquery_dialog.js"></script>
<script type="text/javascript" language="javascript">
function ReloadOpenerByDialogClose() {
    <%out.println(TestWorkflowCheckInitWui.ReloadByDialogClose(request));%>
}
</script>
<%
    if(TestWorkflowCheckInitWui.checkURI(session,request.getRequestURI(),request.getQueryString())){
        response.sendRedirect("/login/Login.jsp");
        return;
    }
%>
<%@page import="java.util.Map"%><%!
private String getCurrWuiConfig(HttpSession session, User user, String keyword) throws Exception {
	
	if (keyword == null || "".equals(keyword)) {
		return "";
	}
	
	String curTheme = "";
	String curskin = "";

	curTheme = (String)session.getAttribute("SESSION_CURRENT_THEME");
	if (curTheme == null || curTheme.equals("")) {
		String[] rtnValue = getHrmUserSetting(user);
		
		curTheme = rtnValue[0];
		curskin = rtnValue[1];
		
		session.setAttribute("SESSION_CURRENT_THEME", curTheme);
		session.setAttribute("SESSION_CURRENT_SKIN", curskin);
	} else {
		curskin = (String)session.getAttribute("SESSION_CURRENT_SKIN");
		if (curskin == null || curskin.equals("")) {
			curskin = getCurrSkinFolder(user);
			session.setAttribute("SESSION_CURRENT_SKIN", curskin);
		}
	}
	
	if ("THEME".equals(keyword.toUpperCase())) {
		return curTheme;
	}
	
	if ("SKIN".equals(keyword.toUpperCase())) {
		return curskin;
	}
	return "";
}



private String getCurrSkinFolder(User user) throws Exception {
	String pslSkinfolder = "";
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();

	int userid = user.getUID();

	rs.executeSql("select skin from HrmUserSetting where resourceId=" + userid);
	
	if (rs.next()) {
		pslSkinfolder = rs.getString("skin");
	}

	if (pslSkinfolder == null || "".equals(pslSkinfolder)) {
	    pslSkinfolder = "default";
	}
	return pslSkinfolder;
}


private String[] getHrmUserSetting(User user) throws Exception {
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	weaver.systeminfo.template.UserTemplate  userTemplate = new weaver.systeminfo.template.UserTemplate();
	userTemplate.getTemplateByUID(user.getUID(),user.getUserSubCompany1());
	
	int extendtempletvalueid = userTemplate.getExtendtempletvalueid();
	String sqltemplateid1 = ""+extendtempletvalueid;
	if(userTemplate.getTemplateId()==1){
		sqltemplateid1 = "(select id from extandHpTheme where templateId=1 and subcompanyid = "+user.getUserSubCompany1()+")";
	}

	String[] result = new String[2];
	rs.executeSql("select * from extandHpThemeItem where extandHpThemeId=" + sqltemplateid1 + " and islock=1");
	if (rs.next()) {
		result[0] = rs.getString("theme");
		result[1] = rs.getString("skin");
		return result;
	} 

	int userid = user.getUID();

	rs.executeSql("select theme, skin from HrmUserSetting where resourceId=" + userid);
	String theme = "";
	String skin = "";
	if (rs.next()) {
		theme = rs.getString("theme");
		skin = rs.getString("skin");
	}
	
	rs.executeSql("select * from extandHpThemeItem where extandHpThemeId=" + sqltemplateid1 + " and isopen=1 and theme='" + theme + "' and skin='" + skin + "'");
	
	if (rs.next()) {
		result[0] = theme;
		result[1] = skin;
	}else{
		rs.executeSql("select theme,skin from extandHpThemeItem where extandHpThemeId=" + sqltemplateid1 + " and isopen=1");
		while (rs.next()) {
			theme = rs.getString("theme");
			skin = rs.getString("skin");
			if("ecology7".equals(theme)&&"default".equals(skin)){
				result[0] = theme;
				result[1] = skin;
				break;
			}
			result[0] = theme;
			result[1] = skin;
		}		
	}
	
	if ((result[0] == null || "".equals(result[0])) && !theme.equalsIgnoreCase("ecology6") ) {
		result[0] = "ecology7";
	} else if (theme.equalsIgnoreCase("ecology6")){
		result[0] = "ecology6";
	}
	
	if (result[1] == null || "".equals(result[1])) {
		result[1] = "default";
	}
	return result;
}

private java.util.Map getPageConfigInfo(HttpSession session, User user) throws Exception{
	
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	java.util.Map pageConfigkv = new java.util.HashMap();
	
	weaver.systeminfo.template.UserTemplate  userTemplate = new weaver.systeminfo.template.UserTemplate();
	userTemplate.getTemplateByUID(user.getUID(),user.getUserSubCompany1());
	
	
	
	int extendtempletvalueid = userTemplate.getExtendtempletvalueid();
	rs.executeSql("select * from extandHpThemeItem where extandHpThemeId=" + extendtempletvalueid + " and isopen=1 and theme='" + getCurrWuiConfig(session, user, "THEME") + "' and skin='" + getCurrWuiConfig(session, user, "SKIN") + "'");
	
	if (rs.next()) {
		pageConfigkv.put("logoTop", rs.getString("logoTop"));
		pageConfigkv.put("logoBottom", rs.getString("logoBottom"));
		pageConfigkv.put("isopen", rs.getString("isopen"));
		pageConfigkv.put("islock", rs.getString("islock"));
		
		/**
		 * ecologybasic主题用设置项
		 */
		pageConfigkv.put("bodyBg", rs.getString("bodyBg"));
		pageConfigkv.put("topBgImage", rs.getString("topBgImage"));
		pageConfigkv.put("toolbarBgColor", rs.getString("toolbarBgColor"));
		pageConfigkv.put("menuborderColor", rs.getString("menuborderColor"));

		pageConfigkv.put("leftbarBgImage", rs.getString("leftbarBgImage"));
		pageConfigkv.put("leftbarBgImageH", rs.getString("leftbarBgImageH"));

		pageConfigkv.put("leftbarborderColor", rs.getString("leftbarborderColor"));
		pageConfigkv.put("leftbarFontColor", rs.getString("leftbarFontColor"));

		pageConfigkv.put("topleftbarBgImage_left", rs.getString("topleftbarBgImage_left"));
		pageConfigkv.put("topleftbarBgImage_center", rs.getString("topleftbarBgImage_center"));
		pageConfigkv.put("topleftbarBgImage_right", rs.getString("topleftbarBgImage_right"));

		pageConfigkv.put("bottomleftbarBgImage_left", rs.getString("bottomleftbarBgImage_left"));
		pageConfigkv.put("bottomleftbarBgImage_center", rs.getString("bottomleftbarBgImage_center"));
		pageConfigkv.put("bottomleftbarBgImage_right", rs.getString("bottomleftbarBgImage_right"));

	}
	
	return pageConfigkv;
	
}
%>