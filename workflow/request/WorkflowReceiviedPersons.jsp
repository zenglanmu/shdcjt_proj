<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.io.Writer"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="wfLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<%
String requestid=Util.null2String(request.getParameter("requestid"));
String viewnodeIds=Util.null2String(request.getParameter("viewnodeIds"));
String operator=Util.null2String(request.getParameter("operator"));
String operatedate=Util.null2String(request.getParameter("operatedate"));
String operatetime=Util.null2String(request.getParameter("operatetime"));
String returntdid=Util.null2String(request.getParameter("returntdid"));
String logtype=Util.null2String(request.getParameter("logtype"));
String returnvalue="";
int destnodeid=Util.getIntValue(request.getParameter("destnodeid"));
int workflowid = 0;
rs.execute("select workflowid from workflow_requestbase where requestid="+Util.getIntValue(requestid));
if(rs.next()){
	workflowid = Util.getIntValue(rs.getString(1), 0);
}
String allNodeids4Request = wfLinkInfo.getAllNodeids4Request(Util.getIntValue(requestid), workflowid);
viewnodeIds = wfLinkInfo.checkNodeids(allNodeids4Request, viewnodeIds);
%>
<script language="javascript">
function window.onload(){
<%
if(!requestid.trim().equals("") && !viewnodeIds.trim().equals("") && !operator.trim().equals("") && !operatedate.trim().equals("") && !operatetime.trim().equals("") && !returntdid.trim().equals("") && !logtype.trim().equals("")){
String viewNodeIdSQL = "select receivedPersons from workflow_requestlog "+
" where requestid="+requestid+" and logtype = '"+logtype+"' and nodeid in ("+ viewnodeIds +") "+
"and operator="+operator+" and operatedate='"+operatedate+"' and operatetime='"+operatetime+"' and destnodeid="+destnodeid;
rs.executeSql(viewNodeIdSQL);
if(rs.next()){
   //String receivedman=rs.getString("receivedman");
   String receivedPersons=rs.getString("receivedPersons");
   //if(receivedman!=null && !receivedman.trim().equals("")){
   //     returnvalue=receivedman.trim();
   //}
   if(receivedPersons!=null && !receivedPersons.trim().equals("")){
        //if(returnvalue.length()>0){
        //    returnvalue+=","+receivedPersons.substring(0,receivedPersons.length()-1);
        //}else{
            returnvalue=receivedPersons.substring(0,receivedPersons.length()-1);
        //}
   }
}
}%>
}
</script>
<%=returnvalue%>