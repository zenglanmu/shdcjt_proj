<%@ page language="java" contentType="text/html; charset=GBK" %>


<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="WorkflowKeywordComInfo" class="weaver.docs.senddoc.WorkflowKeywordComInfo" scope="page" />
<jsp:useBean id="WorkflowKeywordManager" class="weaver.docs.senddoc.WorkflowKeywordManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />


<%

String operation=Util.null2String(request.getParameter("operation"));

int id=Util.getIntValue(request.getParameter("id"),0);
String keywordName = Util.fromScreen(request.getParameter("keywordName"),user.getLanguage());
String keywordDesc = Util.fromScreen(request.getParameter("keywordDesc"),user.getLanguage());
int parentId=Util.getIntValue(request.getParameter("parentId"),0);
String isKeyword = Util.null2String(request.getParameter("isKeyword"));
double showOrder=Util.getDoubleValue(request.getParameter("showOrder"),0);

if(keywordName!=null){
	keywordName=keywordName.trim();
}

if(operation.equals("AddSave")){
    //将上级的是否末级改为否
	WorkflowKeywordManager.updateDataOfNewParent(""+parentId);

    //插入数据
	RecordSet.executeSql("insert into  Workflow_Keyword(keywordName,keywordDesc,parentId,isLast,isKeyword,showOrder) values('"+keywordName+"','"+keywordDesc+"',"+parentId+",'1','"+isKeyword+"',"+showOrder+")");

    //获得记录的id
	RecordSet.executeSql(" select max(id) from Workflow_Keyword ");

	if(RecordSet.next()){
		id=Util.getIntValue(RecordSet.getString(1),0);
	}

    //清除缓存中的内容
    WorkflowKeywordComInfo.removeWorkflowKeywordCache();
    response.sendRedirect("WorkflowKeyword_frm.jsp?keywordId="+id);
	return;
 }
 else if(operation.equals("EditSave")){

    String hisParentId=WorkflowKeywordComInfo.getParentId(""+id);
    //在上级改变的情况下,更新原来的上级的值,
    if(!(""+parentId).equals(hisParentId)){
		WorkflowKeywordManager.updateDataOfNewParent(""+parentId);//将上级的是否末级改为否
		WorkflowKeywordManager.updateDataOfHisParent(""+id,hisParentId);
	}

	RecordSet.executeSql("update Workflow_Keyword set keywordName='"+keywordName+"',keywordDesc='"+keywordDesc+"',parentId="+parentId+",isKeyword='"+isKeyword+"',showOrder="+showOrder+" where id="+id);

    //清除缓存中的内容
    WorkflowKeywordComInfo.removeWorkflowKeywordCache();

    response.sendRedirect("WorkflowKeyword_frm.jsp?keywordId="+id);

	return;
 } else if(operation.equals("Delete")){  
    String hisParentId=WorkflowKeywordComInfo.getParentId(""+id);
	WorkflowKeywordManager.updateDataOfHisParent(""+id,hisParentId);

	RecordSet.executeSql("delete from Workflow_Keyword where id="+id);
	
    //清除缓存中的内容
    WorkflowKeywordComInfo.removeWorkflowKeywordCache();
    response.sendRedirect("WorkflowKeyword_frm.jsp?keywordId="+hisParentId);
	return;
 }
%>
