<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,java.net.*"%>
<%@ page import="weaver.file.FileUploadToPath" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RequestDetailImport" class="weaver.workflow.request.RequestDetailImport" scope="page"/>
<%
    FileUploadToPath fu = new FileUploadToPath(request) ;
    String src = Util.null2String(fu.getParameter("src"));
    int requestid = Util.getIntValue(fu.getParameter("requestid"));
    if( !src.equals("save") || requestid == -1 ) {
        out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
    }else{
        out.print("<script>try{");
        String errmsg=RequestDetailImport.ImportDetail(fu,user);
        out.print("parent.close();top.window.dialogArguments.parent.location.href='ViewRequest.jsp?requestid="+requestid+"';");
        if(!errmsg.equals("")){
            out.print("top.window.dialogArguments.alert('"+errmsg+"');");
        }else{
            out.print("top.window.dialogArguments.alert('"+SystemEnv.getHtmlLabelName(25750, user.getLanguage())+"');");
        }
         out.print("}catch(e){}");
        out.print("</script>");
    }
%>