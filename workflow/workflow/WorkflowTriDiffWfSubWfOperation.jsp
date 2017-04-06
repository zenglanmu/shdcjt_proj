<%@ page language="java" contentType="text/html; charset=GBK" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>


<%

	int triDiffWfDiffFieldId = Util.getIntValue(request.getParameter("triDiffWfDiffFieldId"),-1);
	int mainWorkflowId=0;

    RecordSet.executeSql("select * from Workflow_TriDiffWfDiffField where id=" + triDiffWfDiffFieldId);
    if(RecordSet.next()){
		mainWorkflowId=Util.getIntValue(RecordSet.getString("mainWorkflowId"),0);
	}

	int triDiffWfSubWfIdDefault = Util.getIntValue(request.getParameter("triDiffWfSubWfIdDefault"),-1);
	int subWorkflowIdDefault = Util.getIntValue(request.getParameter("subWorkflowIdDefault"),-1);
	int isReadDefault = Util.getIntValue(request.getParameter("isReadDefault"),-1);
	int fieldValueDefault =-1;

    if(triDiffWfSubWfIdDefault>0){
		if(subWorkflowIdDefault>0){
		    RecordSet.executeSql("update Workflow_TriDiffWfSubWf set triDiffWfDiffFieldId="+triDiffWfDiffFieldId+",subWorkflowId="+subWorkflowIdDefault+",isRead="+isReadDefault+",fieldValue="+fieldValueDefault+" where id="+triDiffWfSubWfIdDefault);
		}else{
		    RecordSet.executeSql("delete from Workflow_TriDiffWfSubWfField where triDiffWfSubWfId="+triDiffWfSubWfIdDefault);
		    RecordSet.executeSql("delete from Workflow_TriDiffWfSubWf where id="+triDiffWfSubWfIdDefault);
		}

	}else{
		if(subWorkflowIdDefault>0){
		    RecordSet.executeSql("insert into Workflow_TriDiffWfSubWf(triDiffWfDiffFieldId,subWorkflowId,isRead,fieldValue) values("+triDiffWfDiffFieldId+","+subWorkflowIdDefault+","+isReadDefault+","+fieldValueDefault+")");
		}
	}

	int triDiffWfSubWfId = 0;
	int subWorkflowId = 0;
	int isRead = 0;
	int fieldValue =0;    
	int rowNum = Util.getIntValue(request.getParameter("rowNumTriDiffWfSubWf"),0);
	
	for(int i=0;i<rowNum;i++){
		triDiffWfSubWfId=Util.getIntValue(request.getParameter("triDiffWfSubWfId_"+i),-1);
		subWorkflowId=Util.getIntValue(request.getParameter("subWorkflowId_"+i),-1);
		isRead=Util.getIntValue(request.getParameter("isRead_"+i),-1);
		fieldValue=Util.getIntValue(request.getParameter("fieldValue_"+i),0);

        if(triDiffWfSubWfId>0){
			if(subWorkflowId>0){
		        RecordSet.executeSql("update Workflow_TriDiffWfSubWf set triDiffWfDiffFieldId="+triDiffWfDiffFieldId+",subWorkflowId="+subWorkflowId+",isRead="+isRead+",fieldValue="+fieldValue+" where id="+triDiffWfSubWfId);
			}else{
		        RecordSet.executeSql("delete from Workflow_TriDiffWfSubWfField where triDiffWfSubWfId="+triDiffWfSubWfId);
		        RecordSet.executeSql("delete from Workflow_TriDiffWfSubWf where id="+triDiffWfSubWfId);
			}

		}else{
			if(subWorkflowId>0){
		        RecordSet.executeSql("insert into Workflow_TriDiffWfSubWf(triDiffWfDiffFieldId,subWorkflowId,isRead,fieldValue) values("+triDiffWfDiffFieldId+","+subWorkflowId+","+isRead+","+fieldValue+")");
			}
		}
	}

    response.sendRedirect("WorkflowSubwfSet.jsp?wfid="+mainWorkflowId);
%>


