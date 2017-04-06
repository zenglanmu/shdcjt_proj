<%@ page import="weaver.general.Util,weaver.general.BaseBean"%>
<%@ page import="java.net.*"%>
<%
	isIncludeToptitle = 1;
	String gopage = "";
	String hostname = request.getServerName();
	String uri = request.getRequestURI();
	String querystring = "";
	titlename = Util.null2String(titlename);
	String ajaxs = "";
	for (Enumeration En = request.getParameterNames(); En.hasMoreElements();)
	{
		String tmpname = (String) En.nextElement();

		if (tmpname.equals("ajax"))
		{
			ajaxs = tmpname;
			continue;
		}
		String tmpvalue = Util.toScreen(request.getParameter(tmpname), user.getLanguage(), "0");
		querystring += "^" + tmpname + "=" + tmpvalue;
	}
	if (!querystring.equals(""))
		querystring = querystring.substring(1);

    querystring=Util.StringReplace(querystring,"\"", "&quot;");
	
	session.setAttribute("fav_pagename", titlename);
	session.setAttribute("fav_uri", uri);
	session.setAttribute("fav_querystring", querystring);
	int addFavSuccess = Util.getIntValue(session.getAttribute("fav_addfavsuccess") + "");
	session.setAttribute("fav_addfavsuccess", "");
%>
<SPAN id=BacoTitle style="display:none;"><%=titlename%></SPAN>
<script type="text/javascript">
	function setFavPageName()
	{
		var BacoTitle = document.getElementById("BacoTitle");
		var pagename = "";
		if(BacoTitle)
		{
			pagename = BacoTitle.innerText;
		}
		var favpagename = pagename;
		return favpagename;
	}
	function setFavUri()
	{
		var favuri = "<%=uri %>";
		return favuri;
	}
	function setFavQueryString()
	{
		var favquerystring = "<%=querystring %>";
		return favquerystring;
	}
</script>
