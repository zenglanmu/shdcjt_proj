<%@ page language="java" contentType="text/html; charset=GBK" %>
 <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<%
int wfid = Util.getIntValue(request.getParameter("wfid"),-1);
int nodeid = -1;
rs.executeSql("delete workflow_function_manage where workflowid = " + wfid);


String watch_sv = Util.null2String(request.getParameter("watch_sv"));
  String watch_dv = Util.null2String(request.getParameter("watch_dv"));
  String watch_zc = Util.null2String(request.getParameter("watch_zc"));
  String watch_mc = Util.null2String(request.getParameter("watch_mc"));
  String watch_fw = Util.null2String(request.getParameter("watch_fw"));
  String watch_rb = Util.null2String(request.getParameter("watch_rb"));
  String watch_ov = Util.null2String(request.getParameter("watch_ov"));
  rs.executeSql("insert into workflow_function_manage (workflowid,typeview,dataview,automatism ,manual,transmit,retract,pigeonhole,operatortype) values ("+wfid+",'"+watch_sv+"','"+watch_dv+"','"+watch_zc+"','"+watch_mc+"','"+watch_fw+"','"+watch_rb+"','"+watch_ov+"',-1)");

/*
  String carete_sv = Util.null2String(request.getParameter("carete_sv"));
  String carete_dv = Util.null2String(request.getParameter("carete_dv"));
  String carete_zc = Util.null2String(request.getParameter("carete_zc"));
  String carete_mc = Util.null2String(request.getParameter("carete_mc"));
  String carete_fw = Util.null2String(request.getParameter("carete_fw"));
  String carete_rb = Util.null2String(request.getParameter("carete_rb"));
  String carete_ov = Util.null2String(request.getParameter("carete_ov"));
  rs.executeSql("insert workflow_function_manage values ("+wfid+",'"+carete_sv+"','"+carete_dv+"','"+carete_zc+"','"+carete_mc+"','"+carete_fw+"','"+carete_rb+"','"+carete_ov+"',-2)");
*/
  
   
 
  
  WFNodeMainManager.setWfid(wfid);
	WFNodeMainManager.selectWfNode();
  while(WFNodeMainManager.next()){
  nodeid = WFNodeMainManager.getNodeid();
  String temp_sv = Util.null2String(request.getParameter("node"+nodeid+"_sv"));
  String temp_dv = Util.null2String(request.getParameter("node"+nodeid+"_dv"));
  String temp_zc = Util.null2String(request.getParameter("node"+nodeid+"_zc"));
  String temp_mc = Util.null2String(request.getParameter("node"+nodeid+"_mc"));
  String temp_fw = Util.null2String(request.getParameter("node"+nodeid+"_fw"));
  String temp_rb = Util.null2String(request.getParameter("node"+nodeid+"_rb"));
  String temp_ov = Util.null2String(request.getParameter("node"+nodeid+"_ov"));
  rs.executeSql("insert into workflow_function_manage (workflowid,typeview,dataview,automatism ,manual,transmit,retract,pigeonhole,operatortype)  values ("+wfid+",'"+temp_sv+"','"+temp_dv+"','"+temp_zc+"','"+temp_mc+"','"+temp_fw+"','"+temp_rb+"','"+temp_ov+"',"+nodeid+")");
  
}
  
  response.sendRedirect("wfFunctionManage.jsp?ajax=1&wfid="+wfid);
  
%>




