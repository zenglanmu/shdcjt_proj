<%@ page import="weaver.general.Util" %>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="LanguageMainManager" class="weaver.systeminfo.language.LanguageMainManager" scope="page"/>

<%
  LanguageMainManager.DeleteLanguage(request.getParameterValues("delete_language_id"));
  LanguageComInfo.removeLanguageCache();
  response.sendRedirect("managelanguage.jsp");
%>
