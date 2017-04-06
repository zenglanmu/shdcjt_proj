<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,java.net.*"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="flowDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>

<%

    FileUpload fu = new FileUpload(request);
    String requestid=Util.null2String(fu.getParameter("requestid"));
    int desrequestid = Util.getIntValue(request.getParameter("desrequestid"),0);
    //新建流程的时候创建文档要返回流程页面，所以此处要设置SESSION
    String userid=""+user.getUID();
    String workflowid=(String)session.getAttribute(userid+"_"+requestid+"workflowid");
    String docId=Util.null2String(fu.getParameter("docValue"));
    String isintervenor=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"isintervenor"));
      ArrayList flowDocs=flowDoc.getDocFiled(""+workflowid);
      String mainid="";
      String secid="";
      String subid="";
      if (flowDocs!=null&&flowDocs.size()>0)
      {    ArrayList   TempAyyay=Util.TokenizerString(""+flowDocs.get(2),"||");
           if (TempAyyay!=null&&TempAyyay.size()>0)
              {
                 mainid=""+TempAyyay.get(0);
                 secid=""+TempAyyay.get(1);
                 subid=""+TempAyyay.get(2);
              }
      }
     //response.sendRedirect("/docs/docs/DocDspExt.jsp?fromFlowDoc=1&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&id="+docId+"&requestid="+requestid);
	 session.setAttribute(requestid+"_wfdoc","/docs/docs/DocDspExt.jsp?fromFlowDoc=1&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&id="+docId+"&requestid="+requestid+"&isintervenor="+isintervenor+"&desrequestid="+desrequestid);
	 //response.sendRedirect("ViewRequest.jsp?seeflowdoc=1&requestid="+requestid+"&isintervenor="+isintervenor);
     
//  showsubmit 为0的时候新建文档将不显示提交按钮  response.sendRedirect("/docs/docs/DocList.jsp?topage="+topage+"&showsubmit=0");



%>