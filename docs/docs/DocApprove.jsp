<%@ page language="java" contentType="text/html; charset=GBK" %>


<%@ page import="java.sql.Timestamp" %>

<%--
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="log" class="weaver.docs.DocDetailLog" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
--%>

<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>

<%
//char flag=2;
//String para="";
String userid=""+user.getUID();
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
//String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
//String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
String CurrentDate = Util.null2String(request.getParameter("currentDate"));
String CurrentTime = Util.null2String(request.getParameter("currentTime"));
if(CurrentDate.equals("")){
	CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
}

if(CurrentTime.equals("")){
	CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
}


String docid=Util.fromScreen(request.getParameter("id"),user.getLanguage());
String type=Util.fromScreen(request.getParameter("type"),user.getLanguage());
int requestid = Util.getIntValue(request.getParameter("requestid"),-1);
int isfromdoc = Util.getIntValue(request.getParameter("isfromdoc"),-1);         //是否从文档显示页面提交审批过来的

//if(type.equals("approve"))
//    para=userid+flag+"2"+flag+CurrentDate+flag+CurrentTime+flag+docid;
//if(type.equals("reject"))
//    para=userid+flag+"4"+flag+CurrentDate+flag+CurrentTime+flag+docid;
//RecordSet.executeProc("DocDetail_Approve",para);

DocManager.setUserid(user.getUID());
DocManager.setUsertype(""+user.getLogintype());	 
DocManager.setClientAddress(request.getRemoteAddr());
DocManager.approveDocFromWF(type,docid,CurrentDate,CurrentTime,userid);

//String docsubject=DocComInfo.getDocname(docid);
//String doccreaterid=DocComInfo.getDocCreaterid(docid);
//String clientip=request.getRemoteAddr();
//log.resetParameter();
//log.setDocId(Util.getIntValue(docid,0));
//log.setDocSubject(docsubject);
//if(type.equals("approve")) log.setOperateType("4");
//else log.setOperateType("5");
//log.setOperateUserid(user.getUID());
//log.setClientAddress(clientip);
//log.setDocCreater(Util.getIntValue(doccreaterid,0));
//log.setDocLogInfo();

//response.sendRedirect("/workflow/request/RequestView.jsp");
if(isfromdoc==1){
	response.sendRedirect("/docs/docs/DocDsp.jsp?id="+docid+"&isrequest=1&requestid="+requestid);
}else{
	response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&fromoperation=1");
}
%>