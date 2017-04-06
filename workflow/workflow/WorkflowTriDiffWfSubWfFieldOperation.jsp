<%@ page language="java" contentType="text/html; charset=GBK" %>
 <%@ include file="/systeminfo/init.jsp" %>


<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
 if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	} 

int triDiffWfDiffFieldId = Util.getIntValue(request.getParameter("triDiffWfDiffFieldId"),0);
int triDiffWfSubWfId = Util.getIntValue(request.getParameter("triDiffWfSubWfId"),0);
int fieldValue = Util.getIntValue(request.getParameter("fieldValue"),-1);
int subWorkflowId = Util.getIntValue(request.getParameter("subWorkflowId"),0);
int isRead = Util.getIntValue(request.getParameter("isRead"),0);
String subwfCreatorType = Util.null2String(request.getParameter("subwfCreatorType"));
int subwfCreatorFieldId = Util.getIntValue(request.getParameter("subwfCreatorFieldId"),0);
if(!subwfCreatorType.equals("3")){
	subwfCreatorFieldId=0;
}

String operation = Util.null2String(request.getParameter("operation"));

if(operation.equals("addTriDiffWfSubWfField")){  
	//更新触发不同流程子流程设置表信息
	if(triDiffWfSubWfId>0){
		RecordSet.executeSql("update Workflow_TriDiffWfSubWf set triDiffWfDiffFieldId="+triDiffWfDiffFieldId+",subworkflowId="+subWorkflowId+",subWfCreatorType='"+subwfCreatorType+"',subWfCreatorFieldId="+subwfCreatorFieldId+",isRead="+isRead+",fieldValue="+fieldValue+"  where id="+triDiffWfSubWfId);
	}else{
		RecordSet.executeSql("insert into  Workflow_TriDiffWfSubWf(triDiffWfDiffFieldId,subworkflowId,subWfCreatorType,subWfCreatorFieldId,isRead,fieldValue) values("+triDiffWfDiffFieldId+","+subWorkflowId+","+subwfCreatorType+","+subwfCreatorFieldId+","+isRead+","+fieldValue+")");
		RecordSet.executeSql("select max(id)  from Workflow_TriDiffWfSubWf");
		if(RecordSet.next()){
			triDiffWfSubWfId=Util.getIntValue(RecordSet.getString(1),0);
		}
	}

	String existsTriDiffWfSubWfFieldIds="";
	String noDeleteTriDiffWfSubWfFieldIds="";
    RecordSet.executeSql("select id from Workflow_TriDiffWfSubWfField where triDiffWfSubWfId="+triDiffWfSubWfId);
	while(RecordSet.next()){
		existsTriDiffWfSubWfFieldIds+=","+Util.getIntValue(RecordSet.getString("id"),0);
	}

	//更新触发不同流程子流程字段设置表信息
    String[] triDiffWfSubWfFieldIds = request.getParameterValues("triDiffWfSubWfFieldId"); 
    String[] subWorkflowFieldIds = request.getParameterValues("subWorkflowFieldId"); 
    String[] mainWorkflowFieldIds = request.getParameterValues("mainWorkflowFieldId");


    int triDiffWfSubWfFieldId=0;
    int subWorkflowFieldId=0;
	String mainWorkflowFieldId="";
    String isCreateDocAgain="";
    String ifSplitField="";

	if(subWorkflowFieldIds!=null){


		for(int i=0;i<subWorkflowFieldIds.length;i++){

            triDiffWfSubWfFieldId=Util.getIntValue(triDiffWfSubWfFieldIds[i],0);
			subWorkflowFieldId=Util.getIntValue(subWorkflowFieldIds[i],0);
			mainWorkflowFieldId=mainWorkflowFieldIds[i];
            mainWorkflowFieldId=mainWorkflowFieldId.substring(mainWorkflowFieldId.lastIndexOf("_")+1);

			isCreateDocAgain=Util.null2String(request.getParameter("chkIsCreateDocAgain_"+i));
			if(isCreateDocAgain.equals("")){
				isCreateDocAgain="0";
			}

			ifSplitField=Util.null2String(request.getParameter("chkIfSplitField_"+i));
			if(ifSplitField.equals("")){
				ifSplitField="0";
			}

			if(mainWorkflowFieldId.equals("")){//如果主流程字段未选
			    if(triDiffWfSubWfFieldId>0){//子流程设置明细id不为空，则需要删除已有记录
                    RecordSet.executeSql("delete from Workflow_TriDiffWfSubWfField where id="+triDiffWfSubWfFieldId);
				}
			}else{//否则，主流程字段已选
			    if(triDiffWfSubWfFieldId>0){//子流程设置明细id不为空，则需要修改已有记录
                    RecordSet.executeSql("update Workflow_TriDiffWfSubWfField set mainWorkflowFieldId="+mainWorkflowFieldId+",isCreateDocAgain='"+isCreateDocAgain+"',ifSplitField='"+ifSplitField+"',isdetail=0  where id="+triDiffWfSubWfFieldId);
					noDeleteTriDiffWfSubWfFieldIds+=","+triDiffWfSubWfFieldId;
				}else{//不然得新增记录
                    RecordSet.executeSql("insert into Workflow_TriDiffWfSubWfField(triDiffWfSubWfId,subWorkflowFieldId,mainWorkflowFieldId,isCreateDocAgain,ifSplitField,isdetail)  values("+triDiffWfSubWfId+","+subWorkflowFieldId+","+mainWorkflowFieldId+",'"+isCreateDocAgain+"','"+ifSplitField+"',0)");
				}
			}

		}
	}


    String[] triDiffWfDltSubWfFieldIds = request.getParameterValues("triDiffWfDltSubWfFieldId");
    String[] subWorkflowDltFieldIds = request.getParameterValues("subWorkflowDltFieldId");
    String[] mainWorkflowDltFieldIds = request.getParameterValues("mainWorkflowDltFieldId");

    int triDiffWfDltSubWfFieldId=0;
    int subWorkflowDltFieldId=0;
	String mainWorkflowDltFieldId="";
	String dltIsCreateDocAgain="";

    if(subWorkflowDltFieldIds!=null){

		for(int i=0;i<subWorkflowDltFieldIds.length;i++){
            triDiffWfDltSubWfFieldId=Util.getIntValue(triDiffWfDltSubWfFieldIds[i],0);
			subWorkflowDltFieldId=Util.getIntValue(subWorkflowDltFieldIds[i],0);
			mainWorkflowDltFieldId=mainWorkflowDltFieldIds[i];
            mainWorkflowDltFieldId=mainWorkflowDltFieldId.substring(mainWorkflowDltFieldId.lastIndexOf("_")+1);

			dltIsCreateDocAgain=Util.null2String(request.getParameter("chkDltIsCreateDocAgain_"+i));
			if(dltIsCreateDocAgain.equals("")){
				dltIsCreateDocAgain="0";
			}

			if(mainWorkflowDltFieldId.equals("")){//如果主流程字段未选
			    if(triDiffWfDltSubWfFieldId>0){//子流程设置明细id不为空，则需要删除已有记录
                    RecordSet.executeSql("delete from Workflow_TriDiffWfSubWfField where id="+triDiffWfDltSubWfFieldId);
				}
			}else{//否则，主流程字段已选
			    if(triDiffWfDltSubWfFieldId>0){//子流程设置明细id不为空，则需要修改已有记录
                    RecordSet.executeSql("update Workflow_TriDiffWfSubWfField set mainWorkflowFieldId="+mainWorkflowDltFieldId+",isCreateDocAgain='"+dltIsCreateDocAgain+"',isdetail=1  where id="+triDiffWfDltSubWfFieldId);
					noDeleteTriDiffWfSubWfFieldIds+=","+triDiffWfDltSubWfFieldId;
				}else{//不然得新增记录
                    RecordSet.executeSql("insert into Workflow_TriDiffWfSubWfField(triDiffWfSubWfId,subWorkflowFieldId,mainWorkflowFieldId,isCreateDocAgain,isdetail)  values("+triDiffWfSubWfId+","+subWorkflowDltFieldId+","+mainWorkflowDltFieldId+",'"+dltIsCreateDocAgain+"',1)");
				}
			}
		}
	}

	//删除垃圾数据
	if(!existsTriDiffWfSubWfFieldIds.equals("")){
		existsTriDiffWfSubWfFieldIds=existsTriDiffWfSubWfFieldIds.substring(1);
	}

	if(!noDeleteTriDiffWfSubWfFieldIds.equals("")){
		noDeleteTriDiffWfSubWfFieldIds=noDeleteTriDiffWfSubWfFieldIds.substring(1);
	}

	if((!existsTriDiffWfSubWfFieldIds.equals(""))&&(!noDeleteTriDiffWfSubWfFieldIds.equals(""))){
		RecordSet.executeSql("delete from Workflow_TriDiffWfSubWfField where triDiffWfSubWfId="+triDiffWfSubWfId+" and id in("+existsTriDiffWfSubWfFieldIds+") and id not in("+noDeleteTriDiffWfSubWfFieldIds+")");
	}

    response.sendRedirect("WorkflowTriDiffWfSubWf.jsp?triDiffWfDiffFieldId="+triDiffWfDiffFieldId); 
	return;
}


%>
