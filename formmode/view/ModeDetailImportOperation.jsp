<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,java.net.*"%>
<%@ page import="weaver.file.FileUploadToPath" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="ModeDetailImport" class="weaver.formmode.view.ModeDetailImport" scope="page"/>
<%
    FileUploadToPath fu = new FileUploadToPath(request) ;
    String src = Util.null2String(fu.getParameter("src"));
    int modeId = Util.getIntValue(fu.getParameter("modeId"));
    int formId = Util.getIntValue(fu.getParameter("formId"));
    int billid = Util.getIntValue(fu.getParameter("billid"));
    out.print("<script>try{");
    String errmsg=ModeDetailImport.ImportDetail(fu,user);
    String topUrl = "AddFormMode.jsp?modeId="+modeId+"&formId="+formId+"&type=2&billid="+billid+"&fromSave=1";
    out.print("parent.close();");
    if(!errmsg.equals("")){
        out.print("top.window.dialogArguments.alert('"+errmsg+"');");
    }else{
        out.print("top.window.dialogArguments.alert('"+SystemEnv.getHtmlLabelName(25750, user.getLanguage())+"');");
    }
    out.print("}catch(e){}");
    out.print("</script>");
%>