<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,java.net.*"%>
<%@ page import="weaver.file.FileUploadToPath" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="ModeDataBatchImport" class="weaver.formmode.interfaces.ModeDataBatchImport" scope="page"/>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

    FileUploadToPath fu = new FileUploadToPath(request) ;
    int modeid = Util.getIntValue(fu.getParameter("modeid"));
    String msg=ModeDataBatchImport.ImportData(fu,user);
    String flag = System.currentTimeMillis() + "_DataBatchImport";
    session.setAttribute(flag,msg);
	response.sendRedirect("/formmode/interfaces/ModeDataBatchImport.jsp?modeid="+modeid+"&flag="+flag);
%>