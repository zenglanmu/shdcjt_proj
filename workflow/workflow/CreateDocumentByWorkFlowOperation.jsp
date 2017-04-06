<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="WFDocumentManager" class="weaver.workflow.workflow.WFDocumentManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />


<%
    String workFlowID = request.getParameter("workFlowID");

    String show = request.getParameter("show");  //是否通过流程创建文档    0:启用
    String workFlowCoding = request.getParameter("workFlowCoding");  //流程编码字段
    String createDocument = request.getParameter("createDocument");  //创建文档字段
    String documentTitleField = request.getParameter("documentTitleField");  //文档标题字段
    String documentLocation = request.getParameter("documentLocation"); //文件存放目录

    String mainCategoryDocument = request.getParameter("mainCategoryDocument");  //一级子目录
    String subCategoryDocument = request.getParameter("subCategoryDocument");  //二级子目录
    String secCategoryDocument = request.getParameter("secCategoryDocument");  //三级子目录

    String useTempletNode = Util.null2String(request.getParameter("useTempletNode"));  //套红节点
    String printNodes = request.getParameter("printNodes");  //打印节点
    String signatureNodes = request.getParameter("signatureNodes");//签章节点
	String newTextNodes = Util.null2String(request.getParameter("newTextNodes"));//是否只能新建正文
	String isCompellentMark = Util.null2String(request.getParameter("isCompellentMark"));//是否必须保留痕迹
	String isCancelCheck = Util.null2String(request.getParameter("isCancelCheckInput"));//是否取消审阅
	String isWorkflowDraft = Util.null2String(request.getParameter("isWorkflowDraft"));//是否存为流程草稿

	String ifVersion = Util.null2String(request.getParameter("ifVersion"));//是否保留正文版本
    int titleFieldId = Util.getIntValue(request.getParameter("titleFieldId"),0);
    int keywordFieldId = Util.getIntValue(request.getParameter("keywordFieldId"),0);
	int extfile2doc = Util.getIntValue(request.getParameter("extfile2doc"),0);//流程附件是否存为正文附件
	String defaultDocType = Util.null2String(request.getParameter("defaultDocType"));//默认文档类型，1：Office Word   2：WPS文字
	String isHideTheTraces = Util.null2String(request.getParameter("isHideTheTraces"));//编辑正文时默认隐藏痕迹

	if("".equals(useTempletNode.trim())){
		useTempletNode = "-1";
	}

	if("".equals(isCompellentMark)){
		isCompellentMark = "0";
	}
	if("".equals(isCancelCheck)){
		isCancelCheck = "0";
	}
    if(!"".equals(show) && null != show)
    {

		WFDocumentManager.saveCreateDocByWorkFlow(workFlowID, "1", workFlowCoding, createDocument, documentLocation, mainCategoryDocument, subCategoryDocument, secCategoryDocument, useTempletNode, documentTitleField,printNodes,  newTextNodes, isCompellentMark, isCancelCheck,signatureNodes,isWorkflowDraft,defaultDocType,extfile2doc,isHideTheTraces);

		//RecordSet.executeSql("update workflow_base set ifVersion='"+ifVersion+"' where id=" +workFlowID);
		RecordSet.executeSql("update workflow_base set ifVersion='"+ifVersion+"',titleFieldId="+titleFieldId+",keywordFieldId="+keywordFieldId+" where id=" +workFlowID);
    }
    else
    {
		WFDocumentManager.saveCreateDocByWorkFlow(workFlowID, "0", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "-1", "","", "0", "0","","","",0,"0");
		//RecordSet.executeSql("update workflow_base set ifVersion='0' where id=" +workFlowID);
		RecordSet.executeSql("update workflow_base set ifVersion='0',titleFieldId="+titleFieldId+",keywordFieldId="+keywordFieldId+" where id=" +workFlowID);

    }
    
    response.sendRedirect("/workflow/workflow/CreateDocumentByWorkFlow.jsp?ajax=1&wfid=" + request.getParameter("workFlowID") + "&formid=" + request.getParameter("formID") + "&isbill=" + request.getParameter("isbill"));
%>



