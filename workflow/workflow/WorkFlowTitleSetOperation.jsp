<%@ page language="java" contentType="text/html; charset=GBK" %>
 <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%

if(!HrmUserVarify.checkUserRight("WorkFlowTitleSet:All", user) && !HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}

%>
<%
  int wfid = Util.getIntValue(request.getParameter("wfid"),-1);
  String postvalues = request.getParameter("postvalues");
  rs.executeSql("delete workflow_TitleSet where flowId = " + wfid);
  if(postvalues!=null && !postvalues.equals("")){
  		ArrayList values = Util.TokenizerString(postvalues,",");
  		if(values!=null && values.size()>0){
  			for(int i=0;i<values.size();i++){
  				rs.executeSql("insert into workflow_TitleSet (flowId,fieldId,gradation) values ("+wfid+","+values.get(i).toString()+","+i+")");
  			}
  		}
  }
  response.sendRedirect("WFTitleSet.jsp?ajax=1&wfid="+wfid);
%>




