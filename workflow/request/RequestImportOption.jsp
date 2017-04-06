<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,java.net.*"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RequestImport" class="weaver.workflow.request.RequestImport" scope="session"/>
<%
    FileUpload fu = new FileUpload(request);
    String src = Util.null2String(fu.getParameter("src"));
    int imprequestid = Util.getIntValue(fu.getParameter("imprequestid"),-1);
    int workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);
    String workflowtype = Util.null2String(fu.getParameter("workflowtype"));
    int formid = Util.getIntValue(fu.getParameter("formid"),-1);
    int isbill = Util.getIntValue(fu.getParameter("isbill"),1);
    int newmodeid = Util.getIntValue(fu.getParameter("newmodeid"),-1);
    int ismode = Util.getIntValue(fu.getParameter("ismode"),-1);
    int nodeid = Util.getIntValue(fu.getParameter("nodeid"),-1);
    String nodetype = Util.null2String(fu.getParameter("nodetype"));
    String requestname = Util.fromScreen3(fu.getParameter("requestname"),user.getLanguage());
    String requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
    String messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
    int isagentCreater = Util.getIntValue((String)session.getAttribute(workflowid+"isagent"+user.getUID()));
    int beagenter = Util.getIntValue((String)session.getAttribute(workflowid+"beagenter"+user.getUID()),0);
    if( !src.equals("import") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
        out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
        return ;
    }
    RequestImport.setImprequestid(imprequestid);
    RequestImport.setNewworkflowid(workflowid);
    RequestImport.setNewworkflowtype(workflowtype);
    RequestImport.setNewformid(formid);
    RequestImport.setNewisbill(isbill);
    RequestImport.setNewnodeid(nodeid);
    RequestImport.setNewnodetype(nodetype);
    RequestImport.setNewrequestname(requestname);
    RequestImport.setNewrequestlevel(requestlevel);
    RequestImport.setNewmessageType(messageType);
    RequestImport.setNewisagent(isagentCreater);
    RequestImport.setNewbeagenter(beagenter);
    RequestImport.setNewuserid(user.getUID());
    RequestImport.setNewusertype((user.getLogintype()).equals("1") ? 0 : 1);
    RequestImport.setNewmodeid(newmodeid);
    RequestImport.setIsmode(ismode);
    int newrequestid=RequestImport.Import();
    if(newrequestid>0){
        out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+newrequestid+"');</script>");
        return ;
    }else{
        out.print("<script>alert('流程导入失败，请联系系统管理员！');wfforward('/workflow/request/AddRequest.jsp?workflowid="+workflowid+"&isagent="+isagentCreater+"&beagenter="+beagenter+"');</script>");
        return ;
    }
%>