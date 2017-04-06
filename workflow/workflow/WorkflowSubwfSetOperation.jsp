<%@ page language="java" contentType="text/html; charset=GBK" %>
 <%@ include file="/systeminfo/init.jsp" %>


<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
 if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	} 


String operation = Util.null2String(request.getParameter("operation"));

String mainWorkflowId = Util.null2String(request.getParameter("mainWorkflowId"));
String subWorkflowId = Util.null2String(request.getParameter("subWorkflowId"));
String workflowSubwfSetId = Util.null2String(request.getParameter("workflowSubwfSetId"));

String subwfCreatorType = Util.null2String(request.getParameter("subwfCreatorType"));
String subwfCreatorFieldId = Util.null2String(request.getParameter("subwfCreatorFieldId"));

if(!subwfCreatorType.equals("3")){
	subwfCreatorFieldId="0";
}

if(operation.equals("addSubwfSetDetail")){  
    //更新子流程配置表信息
    RecordSet.executeSql("update Workflow_SubwfSet set subwfCreatorType='"+subwfCreatorType+"',subwfCreatorFieldId="+subwfCreatorFieldId+" where id="+workflowSubwfSetId);

	String existsSubwfSetDetailIds="";
	String noDeleteSubwfSetDetailIds="";
    RecordSet.executeSql("select id from Workflow_SubwfSetDetail where subwfSetId="+workflowSubwfSetId);
	while(RecordSet.next()){
		existsSubwfSetDetailIds+=","+Util.getIntValue(RecordSet.getString("id"),0);
	}

    //更新子流程配置明细表信息
    String[] subwfSetDetailIds = request.getParameterValues("subwfSetDetailId"); 
    String[] subWorkflowFieldIds = request.getParameterValues("subWorkflowFieldId"); 
    String[] mainWorkflowFieldIds = request.getParameterValues("mainWorkflowFieldId");
    String[] subwfDltSetDetailIds = request.getParameterValues("subwfDltSetDetailId");
    String[] subWorkflowDltFieldIds = request.getParameterValues("subWorkflowDltFieldId");
    String[] dltWorkflowFieldIds = request.getParameterValues("dltWorkflowFieldId");

    String subwfSetDetailId="";
    String subWorkflowFieldId="";
	String mainWorkflowFieldId="";
    String ifSplitField="";
	if(subWorkflowFieldIds!=null){

		for(int i=0;i<subWorkflowFieldIds.length;i++){
            subwfSetDetailId=subwfSetDetailIds[i];
			subWorkflowFieldId=subWorkflowFieldIds[i];
			mainWorkflowFieldId=mainWorkflowFieldIds[i];
            mainWorkflowFieldId=mainWorkflowFieldId.substring(mainWorkflowFieldId.lastIndexOf("_")+1);

			ifSplitField=Util.null2String(request.getParameter("chkIfSplitField_"+i));
			if(ifSplitField.equals("")){
				ifSplitField="0";
			}

			if(mainWorkflowFieldId.equals("")){//如果主流程字段未选
			    if(!subwfSetDetailId.equals("")){//子流程设置明细id不为空，则需要删除已有记录
                    RecordSet.executeSql("delete from Workflow_SubwfSetDetail where id="+subwfSetDetailId);
				}
			}else{//否则，主流程字段已选
			    if(!subwfSetDetailId.equals("")){//子流程设置明细id不为空，则需要修改已有记录
                    RecordSet.executeSql("update Workflow_SubwfSetDetail set mainWorkflowFieldId="+mainWorkflowFieldId+",ifSplitField='"+ifSplitField+"',isdetail=0  where id="+subwfSetDetailId);
					noDeleteSubwfSetDetailIds+=","+subwfSetDetailId;
				}else{//不然得新增记录
                    RecordSet.executeSql("insert into Workflow_SubwfSetDetail(subwfSetId,subWorkflowFieldId,mainWorkflowFieldId,ifSplitField,isdetail)  values("+workflowSubwfSetId+","+subWorkflowFieldId+","+mainWorkflowFieldId+",'"+ifSplitField+"',0)");
				}
			}

		}
		
	}
    String subwfDltSetDetailId="";
    String subWorkflowDltFieldId="";
	String dltWorkflowFieldId="";
    if(subWorkflowDltFieldIds!=null){

		for(int i=0;i<subWorkflowDltFieldIds.length;i++){
            subwfDltSetDetailId=subwfDltSetDetailIds[i];
			subWorkflowDltFieldId=subWorkflowDltFieldIds[i];
			dltWorkflowFieldId=dltWorkflowFieldIds[i];
            dltWorkflowFieldId=dltWorkflowFieldId.substring(dltWorkflowFieldId.lastIndexOf("_")+1);

			if(dltWorkflowFieldId.equals("")){//如果主流程字段未选
			    if(!subwfDltSetDetailId.equals("")){//子流程设置明细id不为空，则需要删除已有记录
                    RecordSet.executeSql("delete from Workflow_SubwfSetDetail where id="+subwfDltSetDetailId);
				}
			}else{//否则，主流程字段已选
			    if(!subwfDltSetDetailId.equals("")){//子流程设置明细id不为空，则需要修改已有记录
                    RecordSet.executeSql("update Workflow_SubwfSetDetail set mainWorkflowFieldId="+dltWorkflowFieldId+",ifSplitField='0',isdetail=1  where id="+subwfDltSetDetailId);
					noDeleteSubwfSetDetailIds+=","+subwfDltSetDetailId;
				}else{//不然得新增记录
                    RecordSet.executeSql("insert into Workflow_SubwfSetDetail(subwfSetId,subWorkflowFieldId,mainWorkflowFieldId,ifSplitField,isdetail)  values("+workflowSubwfSetId+","+subWorkflowDltFieldId+","+dltWorkflowFieldId+",'0',1)");
				}
			}

		}

	}
    
	//删除垃圾数据
	if(!existsSubwfSetDetailIds.equals("")){
		existsSubwfSetDetailIds=existsSubwfSetDetailIds.substring(1);
	}

	if(!noDeleteSubwfSetDetailIds.equals("")){
		noDeleteSubwfSetDetailIds=noDeleteSubwfSetDetailIds.substring(1);
	}

	if((!existsSubwfSetDetailIds.equals(""))&&(!noDeleteSubwfSetDetailIds.equals(""))){
		RecordSet.executeSql("delete from Workflow_SubwfSetDetail where subwfSetId="+workflowSubwfSetId+" and id in("+existsSubwfSetDetailIds+") and id not in("+noDeleteSubwfSetDetailIds+")");
	}

    response.sendRedirect("WorkflowSubwfSet.jsp?ajax=1&wfid="+mainWorkflowId); 
	return;
}


%>
