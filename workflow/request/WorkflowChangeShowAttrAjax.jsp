<%
    String returnvalues="";
    int wfid=weaver.general.Util.getIntValue(request.getParameter("workflowid"));
    int nodeid=weaver.general.Util.getIntValue(request.getParameter("nodeid"));
    String fieldid=weaver.general.Util.null2String(request.getParameter("fieldid"));
    String fieldvalue=weaver.general.Util.null2String(request.getParameter("fieldvalue"));
    if(fieldvalue.equals("")) fieldvalue=" ";
    weaver.workflow.workflow.WfLinkageInfo wfli=new weaver.workflow.workflow.WfLinkageInfo();
    returnvalues=wfli.getChangeFieldByselectvalue(wfid,nodeid,fieldid,fieldvalue);
    response.setContentType("text/text;charset=UTF-8");//返回的是txt文本文件
    out.print(returnvalues);
%>