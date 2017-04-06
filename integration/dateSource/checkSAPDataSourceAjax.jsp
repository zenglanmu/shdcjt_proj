<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util, com.weaver.integration.datesource.*,com.weaver.integration.log.*" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="net.sf.json.*" %>
<%
	String hostname = Util.null2String(request.getParameter("hostname"));
	String saprouter = Util.null2String(request.getParameter("saprouter"));
	String systemnum = Util.null2String(request.getParameter("systemnum"));
	String client = Util.null2String(request.getParameter("client"));
	String language = Util.null2String(request.getParameter("language"));
	String username = Util.null2String(request.getParameter("username"));
	String password = Util.null2String(request.getParameter("password"));
	
	SAPInterationBean sb = new SAPInterationBean();
	sb.setClient(client);
	sb.setHostname(hostname);
	sb.setLanguage(language);
	sb.setUsername(username);
	sb.setPassword(password);
	sb.setSystemNum(systemnum);
	sb.setSapRouter(saprouter);
	SAPInterationOutUtil sou = new SAPInterationOutUtil();
	boolean flag = sou.getTestConnection(new LogInfo(), sb);
	//System.out.println("flag="+flag);
	JSONObject jsa = new JSONObject();
	jsa.accumulate("content", flag);
    out.clear();
    out.println(jsa);
	
%>