<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="EvaluationLevelComInfo" class="weaver.crm.Maint.EvaluationLevelComInfo" scope="page" />
<%
String method = Util.null2String(request.getParameter("method"));
String id = Util.null2String(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String levelvalue = Util.fromScreen(request.getParameter("levelvalue"),user.getLanguage());

if (method.equals("add"))
{
	char flag=2;
	RecordSet.executeProc("CRM_Evaluation_L_Insert",name+flag+levelvalue);

	EvaluationLevelComInfo.removeEvaluationLevelCache();
}
else if (method.equals("edit"))
{
	char flag=2;
	RecordSet.executeProc("CRM_Evaluation_L_Update",id+flag+name+flag+levelvalue);

	EvaluationLevelComInfo.removeEvaluationLevelCache();
}
else if (method.equals("delete")) {
    String CRM_EvaluationIDs[]=request.getParameterValues("CRM_EvaluationIDs");
	String ProcPara = "";
     boolean myFlag = false;

	if(CRM_EvaluationIDs != null) {
		for (int i=0;i<CRM_EvaluationIDs.length;i++) {
			ProcPara = CRM_EvaluationIDs[i];
            RecordSet.executeProc("CRM_Evaluation_L_Delete",ProcPara);

            if (!myFlag && (RecordSet.next() && RecordSet.getInt(1) == -1))
				myFlag = true;
		}
	}

	EvaluationLevelComInfo.removeEvaluationLevelCache();

    // added by lupeng 2004-08-17 for TD780.
	if (myFlag) {
		response.sendRedirect("/CRM/Maint/EvaluationLevelList.jsp?msgid=20");
		return;
	}
	// end.
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
response.sendRedirect("/CRM/Maint/EvaluationLevelList.jsp");
%>