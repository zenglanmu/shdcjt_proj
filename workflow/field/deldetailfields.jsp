<%@ page import="weaver.general.Util" %>
<jsp:useBean id="FieldMainManager" class="weaver.workflow.field.FieldMainManager" scope="page"/>
<jsp:useBean id="DetailFieldComInfo" class="weaver.workflow.field.DetailFieldComInfo" scope="page" />

<%
  FieldMainManager.DeleteDetailField(request.getParameterValues("delete_field_id"));
  DetailFieldComInfo.removeFieldCache();
  response.sendRedirect("managedetailfield.jsp");
%>
