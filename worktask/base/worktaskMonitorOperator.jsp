<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String sql = "";
String method = Util.null2String(request.getParameter("method"));
int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
if(method.equals("savemonitor")){   
	String delids = Util.null2String(request.getParameter("delids"));
	if(!"".equals(delids)){
		delids = delids.substring(0, delids.length()-1);
		sql = "delete from worktask_monitor where id in ("+delids+")";
		//System.out.println("sql = " + sql);
		rs.execute(sql);
	}
	String[] shareValues = request.getParameterValues("txtShareDetail"); 
	if(shareValues!=null){
		for(int i=0; i<shareValues.length; i++){
			String[] paras = Util.TokenizerString2(shareValues[i],"_");
			int monitortype = Util.getIntValue(paras[1], 0);
			String tempStrs[] = Util.TokenizerString2(paras[0],",");
			for(int j=0; j<tempStrs.length; j++){
				int monitor = Util.getIntValue(tempStrs[j], 0);
				if(monitor != 0){
					sql = "select * from worktask_monitor where taskid="+wtid+" and monitor="+monitor;
					rs.execute(sql);
					if(rs.next()){
						sql = "update worktask_monitor set monitortype="+monitortype+" where taskid="+wtid+" and monitor="+monitor;
					}else{
						sql = "insert into worktask_monitor (taskid, monitor, monitortype) values ("+wtid+", "+monitor+", "+monitortype+")";
					}
					//System.out.println("sql = " + sql);
					rs.execute(sql);
				}
			}
		}
	}
	response.sendRedirect("worktaskMonitorSet.jsp?wtid="+wtid);
	return;
}
%>