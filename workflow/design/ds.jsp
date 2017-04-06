<%@ page import="weaver.general.Util"%><%@ page language="java" contentType="text/html; charset=GBK"%><jsp:useBean id="WFNodeOperatorManager" class="weaver.workflow.workflow.WFNodeOperatorManager" scope="page" /><jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />{"options":[{"name":"ÐÂ½¨×é", "type":""}<%
	WFNodeOperatorManager.resetParameter();
	int groupnum = 0;
	String nodetype = "";
	String wfid = "" + Util.getIntValue(request.getParameter("wfid"), 0);
	int formid = Util.getIntValue(request.getParameter("formid"), 0);
	int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
	String isbill = Util.null2String(request.getParameter("isbill"));
	String iscust = Util.null2String(request.getParameter("iscust"));

	char flag = 2;
	RecordSet.executeProc("workflow_NodeType_Select", "" + wfid + flag + nodeid);

	if (RecordSet.next())
		nodetype = RecordSet.getString("nodetype");

	int linecolor = 0;
	WFNodeOperatorManager.setNodeid(nodeid);
	WFNodeOperatorManager.selectNodeOperator();
	while (WFNodeOperatorManager.next()) {
		groupnum++;
%>,{"name":"<%=WFNodeOperatorManager.getName()%>", "type":"<%=WFNodeOperatorManager.getId()%>"}<%
	}
	WFNodeOperatorManager.closeStatement();
	System.out.println("["+new java.util.Date()+"] nodeid="+nodeid+" groupnum="+groupnum);
%>]}
