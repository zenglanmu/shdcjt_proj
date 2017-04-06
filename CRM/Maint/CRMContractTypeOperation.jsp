<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ContractTypeComInfo" class="weaver.crm.Maint.ContractTypeComInfo" scope="page" />
<%
//added by XWJ on 2005-03-16 for td:1549
String propertyOfApproveWorkFlow = Util.null2String(request.getParameter("propertyOfApproveWorkFlow"));

String method = Util.null2String(request.getParameter("method"));
String id = Util.null2String(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String contractdesc = Util.fromScreen(request.getParameter("contractdesc"),user.getLanguage());
String workflowid = "" + Util.getIntValue(request.getParameter("workflowid"),0);
String para = "";
if (method.equals("add"))
{
	char flag=2;
	para = name;
	para += flag + contractdesc;
	para += flag + workflowid;
	RecordSet.executeProc("CRM_ContractType_Insert",para);

	ContractTypeComInfo.removeContractTypeCache();
}
else if (method.equals("edit"))
{
	char flag=2;
	para = id;
	para += flag + name;
	para += flag + contractdesc;
	para += flag + workflowid;
	RecordSet.executeProc("CRM_ContractType_Update",para);

	ContractTypeComInfo.removeContractTypeCache();
}
else if (method.equals("delete"))
{	String CRM_ContractIDs[]=request.getParameterValues("CRM_ContractIDs");
	String ProcPara = "";
	boolean myFlag = false;
	if (CRM_ContractIDs != null) {
		for(int i=0;i<CRM_ContractIDs.length;i++) {
			ProcPara = CRM_ContractIDs[i];
            RecordSet.executeProc("CRM_ContractType_Delete",ProcPara);
			
			if (!myFlag && (RecordSet.next() && RecordSet.getInt(1) == -1))
				myFlag = true;
		}

	}
	
	ContractTypeComInfo.removeContractTypeCache();	

	// added by lupeng 2004-08-08 for TD795.
	//System.out.println(myFlag);
	if (myFlag) {
	// Modifued by XWJ on 2005-03-16 for td:1549
		response.sendRedirect("/CRM/Maint/CRMContractTypeList.jsp?msgid=20&propertyOfApproveWorkFlow=" + propertyOfApproveWorkFlow);
		return;
	}		
	// end.	
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
	// Modifued by XWJ on 2005-03-16 for td:1549
response.sendRedirect("/CRM/Maint/CRMContractTypeList.jsp?propertyOfApproveWorkFlow=" + propertyOfApproveWorkFlow);
%>