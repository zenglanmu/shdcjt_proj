<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.workflow.request.RequestManager" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RequestSubwfTriggerManager" class="weaver.workflow.request.RequestSubwfTriggerManager" scope="page"/>

<%

User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

String operation=Util.null2String(request.getParameter("operation"));

String returnString="";

if(operation.equals("triSubwf")){

    int requestId=Util.getIntValue(request.getParameter("requestId"),0);
    int nodeId=Util.getIntValue(request.getParameter("nodeId"),0);
	String triggerTime="1";
	String hasTriggeredSubwf="";
	String triggerType="2";
	int paramSubwfSetId=Util.getIntValue(request.getParameter("paramSubwfSetId"),0);

	try {
		RequestManager mainRequest=new RequestManager();
        RecordSet.executeSql("select * from workflow_requestbase where requestid=" + requestId);
		if (RecordSet.next()) {
			mainRequest.setWorkflowid(Util.getIntValue(RecordSet.getString("workflowid"),0));
			mainRequest.setCreater(Util.getIntValue(RecordSet.getString("creater"),0));
			mainRequest.setCreatertype(Util.getIntValue(RecordSet.getString("createrType"),0));
			mainRequest.setRequestid(requestId);
			mainRequest.setRequestname(RecordSet.getString("requestname"));
			mainRequest.setRequestlevel(RecordSet.getString("requestlevel"));
			mainRequest.setMessageType(RecordSet.getString("messagetype"));
			mainRequest.setSrc("submit");
        }
		returnString=RequestSubwfTriggerManager.TriggerSubwf(mainRequest,nodeId,triggerTime, hasTriggeredSubwf,user,triggerType,paramSubwfSetId);               
    } catch (Exception e) {

    }
}

%>
<script language="javascript">

<%if(operation.equals("triSubwf")){%>

window.parent.returnTriSubwf("<%=returnString%>");

<%}%>

</script>