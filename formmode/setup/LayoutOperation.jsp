<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%@ page import="weaver.file.FileUpload,java.io.File"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="modeLayoutUtil" class="weaver.formmode.setup.ModeLayoutUtil" scope="page" />
<jsp:useBean id="modeSetUtil" class="weaver.formmode.setup.ModeSetUtil" scope="page" />
<%
FileUpload fu = new FileUpload(request, false, "filesystem/htmllayoutimages");
int flag = 0;

int Id = Util.getIntValue(fu.getParameter("Id"), 0);
int formId = Util.getIntValue(fu.getParameter("formId"), 0);
int modeId = Util.getIntValue(fu.getParameter("modeId"), 0);
int type = Util.getIntValue(fu.getParameter("type"), -1);
String operation = Util.null2String(fu.getParameter("operation"));

modeLayoutUtil.setFu(fu);
if("saveHtmlMode".equalsIgnoreCase(operation)){//保存模板
	Id = modeLayoutUtil.doSaveLayoutInfo();
	if(Id > 0){
		flag = 1;
	}
	%>
	<script language="javascript">
		try{
			window.opener.location.reload();
		}catch(e){}
		location.href = "/formmode/setup/LayoutEdit.jsp?ajax=1&modeId=<%=modeId%>&formId=<%=formId%>&Id=<%=Id%>&type=<%=type%>&flag=<%=flag%>";
	</script>
	<%
}else if("EditModesHtml".equalsIgnoreCase(operation)){//页面布局-模板设置（保存）
	modeSetUtil.setRequest(request);
	modeSetUtil.setUser(user);
	modeSetUtil.saveModesHtml();
	response.sendRedirect("/formmode/setup/ModeHtmlSet.jsp?ajax=1&modeId="+modeId+"&formId="+formId);
}else if("batchHtmlField".equalsIgnoreCase(operation)){//批量处理字段
	modeLayoutUtil.setRequest(request);
	modeLayoutUtil.setUser(user);
	Id = modeLayoutUtil.batchHtmlField();
	out.println("<script>try{window.opener.location.href=\"/formmode/setup/LayoutEdit.jsp?ajax=1&modeId="+modeId+"&formId="+formId+"&Id="+Id+"&type="+type+"\";}catch(e){}");
	out.println("window.close();");
	out.println("</script>");
}else if("preppm".equalsIgnoreCase(operation)){
	modeLayoutUtil.setRequest(request);
	modeLayoutUtil.setUser(user);
	Id = modeLayoutUtil.createDefaultLayout();
	%>
	<script language="javascript">
		try{
			window.opener.location.reload();
		}catch(e){}
		location.href = "/formmode/setup/LayoutEdit.jsp?ajax=1&modeId=<%=modeId%>&formId=<%=formId%>&Id=<%=Id%>&type=<%=type%>&flag=<%=flag%>";
	</script>
	<%
}
%>
