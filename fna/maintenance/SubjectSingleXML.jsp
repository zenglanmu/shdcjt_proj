<%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="weaver.hrm.*" %><%@ page language="java" contentType="text/xml; charset=GBK" %><%
int filterlevel = Util.getIntValue(request.getParameter("level"),0);
int filterfeetype = Util.getIntValue(request.getParameter("feetype"),0);%><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%><jsp:useBean id="subjectComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page" /><%
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
String init=Util.null2String(request.getParameter("init"));

//System.out.print("nodeid"+nodeid);
TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

if(!init.equals("")&&id.equals("")){
//TreeNode root=new TreeNode();

/*root.setTitle(" ");
root.setNodeId("glob_0");
root.setTarget("_self");
root.setIcon("/images/treeimages/global.gif");
envelope.addTreeNode(root);*/
subjectComInfo.getSubjectTreeList(envelope, type,"0",2,filterlevel,filterfeetype);

}else{
    subjectComInfo.getSubjectTreeList(envelope,type,id,1,filterlevel,filterfeetype);
}

envelope.marshal(out);
%>