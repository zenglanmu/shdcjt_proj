<%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="java.util.*" %><%@ page import="weaver.hrm.*" %><%@ page language="java" contentType="text/xml; charset=GBK" %><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%><jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" /><jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" /><jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" /><%
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
String init=Util.null2String(request.getParameter("init"));
String subid=Util.null2String(request.getParameter("subid"));

String rightStr=Util.null2String(request.getParameter("rightStr"));

TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

if(id.equals("")){
    TreeNode root=new TreeNode();
    String companyname =CompanyComInfo.getCompanyname("1");
    root.setTitle(companyname);
    root.setNodeId("com_0");
    //for TD.4375 ���û���ܲ��˵�ά��Ȩ������ʾ��Ȩ��ҳ��
    //if(HrmUserVarify.checkUserRight("HeadMenu:Maint", user))
    root.setHref("javascript:setCompany('" + root.getNodeId() + "')");
    root.setTarget("_self"); 
    root.setIcon("/images/treeimages/global.gif");
    envelope.addTreeNode(root);
    SubCompanyComInfo.getSubCompanyTreeListByRight(user.getUID(),rightStr);
    SubCompanyComInfo.getSubCompanyTreeListByRight(root,"0",0,10,false,"subSingle",null,null);
}

envelope.marshal(out);
%>