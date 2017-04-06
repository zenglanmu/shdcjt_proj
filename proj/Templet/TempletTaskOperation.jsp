<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />

<%
String method = Util.null2String(request.getParameter("method"));
int taskTempletID = Util.getIntValue(Util.null2String(request.getParameter("taskTempletID")), -1);
int projID = Util.getIntValue(Util.null2String(request.getParameter("ProjID")), -1);

/* Task BaseInfo */
String taskName = Util.null2String(request.getParameter("subject"));
int taskManager = Util.getIntValue(Util.null2String(request.getParameter("hrmid")), -1);
String beginDate = Util.null2String(request.getParameter("begindate"));
String endDate = Util.null2String(request.getParameter("enddate"));
int workday = Util.getIntValue(Util.null2String(request.getParameter("workday")), -1);
String budget = Util.null2String(request.getParameter("fixedcost"));
String befTaskId = Util.null2String(request.getParameter("taskids02"));
String taskDesc = Util.null2String(request.getParameter("content"));

/* Task RelatedInfo */
String[] docRequired_mainid = request.getParameterValues("requireddocs_mainid");
String[] docRequired_subid = request.getParameterValues("requireddocs_subid");
String[] docRequired_secid = request.getParameterValues("requireddocs_secid");
String[] docRefer = request.getParameterValues("referdocs");
String[] wfRequired = request.getParameterValues("requiredWFIDs");
String isNecessary = "";
String isNecessaryWF = "";


/* Action */
String sql = "";
if(method.equals("edit")){
	sql = "UPDATE Prj_TemplateTask SET taskName='"+taskName+"',taskManager="+taskManager+",begindate='"+beginDate+"',enddate='"+endDate+"',workday="+workday+",budget='"+budget+"',befTaskId='"+befTaskId+"',taskDesc='"+taskDesc+"' WHERE id="+taskTempletID;
	RecordSet.executeSql(sql);

	sql = "DELETE FROM Prj_TempletTask_needdoc WHERE templetTaskId="+taskTempletID;
	RecordSet.executeSql(sql);
	if(docRequired_secid!=null){
		for(int i=0;i<docRequired_secid.length;i++){
			isNecessary = request.getParameter("necessary"+docRequired_secid[i])==null ? "0" : "1";
			sql = "INSERT INTO Prj_TempletTask_needdoc (templetTaskId,docMainCategory,docSubCategory,docSecCategory,isNecessary) VALUES ("+taskTempletID+","+docRequired_mainid[i]+","+docRequired_subid[i]+","+docRequired_secid[i]+",'"+isNecessary+"')";
			RecordSet.executeSql(sql);
		}
	}

	sql = "DELETE FROM Prj_TempletTask_referdoc WHERE templetTaskId="+taskTempletID;
	RecordSet.executeSql(sql);
	if(docRefer!=null){
		for(int i=0;i<docRefer.length;i++){
			sql = "INSERT INTO Prj_TempletTask_referdoc (templetTaskId,docid) VALUES ("+taskTempletID+","+docRefer[i]+")";
			RecordSet.executeSql(sql);
		}
	}

	sql = "DELETE FROM Prj_TempletTask_needwf WHERE templetTaskId="+taskTempletID;
	RecordSet.executeSql(sql);
	if(wfRequired!=null){
		for(int i=0;i<wfRequired.length;i++){
			isNecessaryWF = request.getParameter("necessaryWF"+wfRequired[i])==null ? "0" : "1";
			sql = "INSERT INTO Prj_TempletTask_needwf (templetTaskId,workflowId,isNecessary) VALUES ("+taskTempletID+","+wfRequired[i]+",'"+isNecessaryWF+"')";
			RecordSet.executeSql(sql);
		}
	}
}

response.sendRedirect("TempletTaskView.jsp?id="+taskTempletID+"&templetid="+projID);
%>