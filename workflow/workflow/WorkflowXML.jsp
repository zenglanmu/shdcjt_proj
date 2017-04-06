<%@ page language="java" contentType="text/xml; charset=GBK" %><%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="java.util.*" %><%@ page import="weaver.hrm.*" %><%@ page import="weaver.hrm.city.CityComInfo"%><%@ page import="weaver.systeminfo.SystemEnv"%><jsp:useBean id="WorkFlowTree" class="weaver.workflow.workflow.WorkFlowTree" scope="page" /><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
String init=Util.null2String(request.getParameter("init"));
String isTemplate=Util.null2String(request.getParameter("isTemplate"));
String subCompanyId=Util.null2String(request.getParameter("subCompanyId"));
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel=Util.getIntValue(request.getParameter("operatelevel"));
TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

if(!init.equals("")&&id.equals("")){
    TreeNode root=new TreeNode();
    String companyname ="";
    if(isTemplate.equals("1")){
        companyname=SystemEnv.getHtmlLabelName(18334,user.getLanguage());
    }else{
        companyname= SystemEnv.getHtmlLabelName(16483,user.getLanguage());
    }
    root.setTitle(companyname);
    root.setNodeId("workflowtype_0");
    root.setTarget("_self");
    root.setIcon("/images/treeimages/global.gif");
    root.setHref("javascript:setSubCompany('"+subCompanyId+"')");
    envelope.addTreeNode(root);
    if(operatelevel<0){
        TreeNode root1=new TreeNode();
        root1.setTitle(SystemEnv.getHtmlLabelName(557,user.getLanguage()));
        root1.setNodeId("workflowtype_0");
        root1.setTarget("_self");
        root1.setHref("javascript:setSubCompany('"+subCompanyId+"')");
        root.addTreeNode(root1);
    }else{
        WorkFlowTree.getWorkflowTypeTreeList(root, type,subCompanyId,isTemplate,nodeid,detachable);
    }
}else{
    WorkFlowTree.getWorkflowTreeList(envelope,type,subCompanyId,isTemplate,id,detachable);
}

envelope.marshal(out);
%>