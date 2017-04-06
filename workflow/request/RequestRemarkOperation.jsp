<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,java.net.*"%>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="Requestlog" class="weaver.workflow.request.RequestLog" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="basebean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<%
FileUpload fu = new FileUpload(request);

String src = Util.null2String(fu.getParameter("src"));
String iscreate = Util.null2String(fu.getParameter("iscreate"));
int requestid = Util.getIntValue(fu.getParameter("requestid"),-1);
int workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);
String workflowtype = Util.null2String(fu.getParameter("workflowtype"));
int nodeid = Util.getIntValue(fu.getParameter("nodeid"),-1);
String nodetype = Util.null2String(fu.getParameter("nodetype"));
String needwfback = Util.null2String(fu.getParameter("needwfback"));
String remark = Util.null2String(fu.getParameter("remark"));
int formid = Util.getIntValue(fu.getParameter("formid"),-1);
int isbill = Util.getIntValue(fu.getParameter("isbill"),-1);
int billid = Util.getIntValue(fu.getParameter("billid"),-1);
String requestname = Util.fromScreen3(fu.getParameter("requestname"),user.getLanguage());
String requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
String messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
String isFromEditDocument = Util.null2String(fu.getParameter("isFromEditDocument"));
String submitNodeId=Util.null2String(fu.getParameter("submitNodeId"));
String Intervenorid=Util.null2String(fu.getParameter("Intervenorid"));    
int isremark = Util.getIntValue(fu.getParameter("isremark"),-1);
boolean IsCanModify="true".equals(session.getAttribute(user.getUID()+"_"+requestid+"IsCanModify"))?true:false;
String ifchangstatus=Util.null2String(basebean.getPropValue(GCONST.getConfigFile() , "ecology.changestatus"));
if( src.equals("") || workflowid == -1 ||  nodeid == -1 || nodetype.equals("") ) {
    //response.sendRedirect("/notice/RequestError.jsp");
    out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
    return ;
}
    RequestManager.setSrc(src) ;
    RequestManager.setIscreate(iscreate) ;
    RequestManager.setRequestid(requestid) ;
    RequestManager.setWorkflowid(workflowid) ;
    RequestManager.setWorkflowtype(workflowtype) ;
    RequestManager.setIsremark(isremark) ;
    RequestManager.setFormid(formid) ;
    RequestManager.setIsbill(isbill) ;
    RequestManager.setBillid(billid) ;
    RequestManager.setNodeid(nodeid) ;
    RequestManager.setNodetype(nodetype) ;
    RequestManager.setRequestname(requestname) ;
    RequestManager.setRequestlevel(requestlevel) ;
    RequestManager.setRemark(remark) ;
    RequestManager.setRequest(fu) ;
    RequestManager.setSubmitNodeId(submitNodeId);
    RequestManager.setIntervenorid(Intervenorid);
    //add by xhheng @ 2005/01/24 for 消息提醒 Request06
    RequestManager.setMessageType(messageType) ;
    //System.out.println("messageType===="+messageType);
    RequestManager.setIsFromEditDocument(isFromEditDocument) ;
    RequestManager.setUser(user) ;
    RequestManager.setCanModify(IsCanModify);
    boolean savestatus = RequestManager.saveRequestInfo() ;
    requestid = RequestManager.getRequestid() ;
    if( !savestatus ) {
        if( requestid != 0 ) {
            String message=RequestManager.getMessage();
            if(!"".equals(message)){
				out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&message="+message+"');</script>");
                return ;
            }
			out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1');</script>");
            return ;
        }
        else {
			out.print("<script>wfforward('/workflow/request/RequestView.jsp?message=1');</script>");
            return ;
        }
    }
String userid=""+user.getUID();
int usertype = (user.getLogintype()).equals("1") ? 0 : 1;
char flag = Util.getSeparator();
//提交
if (isremark==1){
	if(!"0".equals(needwfback)){
		RecordSet.executeProc("workflow_CurOpe_UbyForward", "" + requestid + flag + userid + flag + usertype);
	}else{
		RecordSet.executeProc("workflow_CurOpe_UbyForwardNB", "" + requestid + flag + userid + flag + usertype);
	}
}else{
	if(!"0".equals(needwfback)){
		RecordSet.executeProc("workflow_CurOpe_UbySend", "" + requestid + flag + userid + flag + usertype+flag+isremark);
	}else{
		RecordSet.executeProc("workflow_CurOpe_UbySendNB", "" + requestid + flag + userid + flag + usertype+flag+isremark);
	}
}
String isfeedback="";
String isnullnotfeedback="";    
RecordSet.executeSql("select isfeedback,isnullnotfeedback from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
	isfeedback=Util.null2String(RecordSet.getString("isfeedback"));
    isnullnotfeedback=Util.null2String(RecordSet.getString("isnullnotfeedback"));
}
if (!ifchangstatus.equals("")&&isfeedback.equals("1")&&((isnullnotfeedback.equals("1")&&!Util.replace(remark, "\\<script\\>initFlashVideo\\(\\)\\;\\<\\/script\\>", "", 0, false).equals(""))||!isnullnotfeedback.equals("1"))){
    RecordSet.executeSql("update workflow_currentoperator set viewtype =-1  where needwfback='1' and requestid=" + requestid + " and userid<>" + userid + " and viewtype=-2");

}
String curnodetype = "";
RecordSet.executeSql("select currentnodetype from workflow_Requestbase where requestid="+requestid);
if(RecordSet.next()) curnodetype = Util.null2String(RecordSet.getString(1));
if(curnodetype.equals("3"))//归档流程转发后，转发人或抄送人提交后到办结事宜。
	RecordSet.executeSql("update workflow_currentoperator set iscomplete=1 where userid="+userid+" and usertype="+usertype+" and requestid="+requestid);        

Requestlog.setRequest(fu) ;

Requestlog.saveLog(workflowid,requestid,nodeid,"9",remark,user) ;

/*
被转发人和被抄送人均不是流程中的实际操作者，不用更新流程的最后操作人和操作时间；
在检查流程数据是否已更改时（两个流程操作者同时打开流程，并对流程做修改，先提交的修改会被覆盖，该功能是判断如果已经有修改提交，会提醒流程数据已更改，请核对后再处理），
在提交流程时用最后操作人和操作时间与打开流程时的最后操作人和操作时间作比较，
对于被转发人和被抄送人提交，如果也更改流程的最后操作人和操作时间，则真正的流程操作者提交时被检查出流程数据已更改。
Calendar today = Calendar.getInstance();
String CurrentDate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                      Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                      Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String CurrentTime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                      Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                      Util.add0(today.get(Calendar.SECOND), 2) ;
//RecordSet.executeSql("update workflow_requestbase set lastoperator="+userid+",lastoperatortype="+usertype+",lastoperatedate='"+CurrentDate+"',lastoperatetime='"+CurrentTime+"' where requestid="+requestid);     
if(curnodetype.equals("3"))
    RecordSet.executeSql("update workflow_requestbase set lastoperator="+userid+",lastoperatortype="+usertype+" where requestid="+requestid);     
else
    RecordSet.executeSql("update workflow_requestbase set lastoperator="+userid+",lastoperatortype="+usertype+",lastoperatedate='"+CurrentDate+"',lastoperatetime='"+CurrentTime+"' where requestid="+requestid);     
*/

String isShowPrompt="true";
String docFlags=(String)session.getAttribute("requestAdd"+requestid);
if(docFlags ==null || docFlags.equals("")) docFlags = "-1";
if (docFlags.equals("1"))
			{%>
			<SCRIPT LANGUAGE="JavaScript">
             parent.document.location.href="/workflow/request/ViewRequest.jsp?nodetypedoc=<%=nodetype%>&requestid=<%=requestid%>&fromoperation=1&updatePoppupFlag=1&isShowPrompt=<%=isShowPrompt%>&src=<%=src%>";
            </SCRIPT>
			<%}else{
//response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&fromoperation=1&updatePoppupFlag=1&isShowPrompt="+isShowPrompt+"&src="+src);
out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&fromoperation=1&updatePoppupFlag=1&isShowPrompt="+isShowPrompt+"&src="+src+"');</script>");
}

%>