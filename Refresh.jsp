<%@ page import="weaver.general.Util" %>
<%
String loginfile = Util.null2String(request.getParameter("loginfile")) ;
String message = Util.null2String(request.getParameter("message")) ;
%>



<script>
	window.top.location.href = "<%=loginfile%>&message=<%=message%>"
</script>