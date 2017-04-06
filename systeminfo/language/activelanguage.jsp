<%@ page import="weaver.general.Util" %>
<jsp:useBean id="LanguageManager" class="weaver.systeminfo.language.LanguageManager" scope="page"/>

<%
  int languageid=Util.getIntValue(request.getParameter("languageid"));
  String isactive=Util.null2String(request.getParameter("isactive"));
  LanguageManager.setLanguageStatus(languageid,isactive);
  response.sendRedirect("managelanguage.jsp");
%>
