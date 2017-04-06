<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSets" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
 
int id = Util.getIntValue(request.getParameter("id"), 0);
int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
String method = Util.null2String(request.getParameter("method"));
String relatedshareid = Util.null2String(request.getParameter("relatedshareid"));//共享对象
String sharetype = Util.null2String(request.getParameter("sharetype")); 
String rolelevel = Util.null2o(request.getParameter("rolelevel")); 
String seclevel = Util.null2o(request.getParameter("seclevel"));
String sharelevel = Util.null2String(request.getParameter("sharelevel")); //共享级别 0：查看 1：反馈
String taskstatus= Util.null2String(request.getParameter("taskstatus")); //共享任务类型
String sql = "";
String foralluser = "0" ;
if(sharetype.equals("5")){
	foralluser = "1";
	relatedshareid = "0";
}
if("6".equals(sharetype) || "7".equals(sharetype) || "8".equals(sharetype)){
	relatedshareid = "0";
}
if(method.equals("delete")){
	RecordSet.execute("delete from requestshareset where id="+id);
}else if(method.equals("add")){
	if(!"".equals(relatedshareid)){
		String[] objids = Util.TokenizerString2(relatedshareid, ",");
		for(int i=0; i<objids.length; i++){
			String objid = Util.null2o(objids[i]);
			String[] taskstatus_sz = null;
			if("-1".equals(taskstatus)){
				taskstatus_sz = new String[2];
				taskstatus_sz[0] = "1";
				taskstatus_sz[1] = "2";
			}else{
				taskstatus_sz = new String[1];
				taskstatus_sz[0] = taskstatus;
			}
			for(int cx=0; cx<taskstatus_sz.length; cx++){
				sql = "insert into requestshareset(taskid, requestid, taskstatus, sharelevel, sharetype, seclevel, rolelevel, foralluser, objid, isdefault) values ("+wtid+", "+requestid+", "+taskstatus_sz[cx]+", "+sharelevel+", "+sharetype+", "+seclevel+", "+rolelevel+", "+foralluser+", "+objid+", 0)";
				//System.out.println(sql);
				RecordSet.execute(sql);
			}
		}
	}
}

response.sendRedirect("RequestShareSet.jsp?requestid="+requestid+"&wtid="+wtid);

%>
