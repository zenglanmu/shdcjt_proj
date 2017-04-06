<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/systeminfo/init.jsp"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.workflow.action.WSActionManager"%>

<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String operate = Util.null2String(request.getParameter("operate"));
int actionid = Util.getIntValue(request.getParameter("actionid"), 0);
int workflowid = Util.getIntValue(request.getParameter("workflowid"),0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
//是否节点后附加操作
int ispreoperator = Util.getIntValue(request.getParameter("ispreoperator"), 0);
//出口id
int nodelinkid = Util.getIntValue(request.getParameter("nodelinkid"), 0);
String actionname = Util.null2String(request.getParameter("actionname"));
int actionorder = Util.getIntValue(request.getParameter("actionorder"), 0);
String wsurl = Util.null2String(request.getParameter("wsurl"));//web service地址
String wsoperation = Util.null2String(request.getParameter("wsoperation"));//调用的web service的方法
String xmltext = Util.null2String(request.getParameter("xmltext"));
String retstr = Util.null2String(request.getParameter("retstr"));
int rettype = Util.getIntValue(request.getParameter("rettype"), 0);
String inpara = Util.null2String(request.getParameter("inpara"));
//out.println("operate = " + operate + "<br>");
//out.println("actionid = " + actionid + "<br>");
WSActionManager wsActionManager = new WSActionManager();
wsActionManager.setActionid(actionid);
wsActionManager.setWorkflowid(workflowid);
wsActionManager.setNodeid(nodeid);
wsActionManager.setActionorder(actionorder);
wsActionManager.setNodelinkid(nodelinkid);
wsActionManager.setIspreoperator(ispreoperator);
wsActionManager.setActionname(actionname);
wsActionManager.setWsurl(wsurl);
wsActionManager.setWsoperation(wsoperation);
wsActionManager.setXmltext(xmltext);
wsActionManager.setRetstr(retstr);
wsActionManager.setRettype(rettype);
wsActionManager.setInpara(inpara);
if("delete".equals(operate)){
	wsActionManager.doDeleteWsAction();
}else if("save".equals(operate)){
	actionid = wsActionManager.doSaveWsAction();
	//out.println("actionid 222 = " + actionid + "<br>");
}
out.println("<script language=\"javascript\">window.parent.close();dialogArguments.reloadDMLAtion();</script>");

%>