<%@ page import="weaver.general.Util" %>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="LanguageManager" class="weaver.systeminfo.language.LanguageManager" scope="session"/>
<%
	
  String src = Util.null2String(request.getParameter("src"));
////得到标记信息
  if(src.equalsIgnoreCase("addlanguage")){
	LanguageManager.reset();
  	LanguageManager.setAction("addlanguage");
    String Oid1 = Util.null2String(request.getParameter("id"));	
	int  oid = Util.getIntValue(Oid1,7);
	LanguageManager.setLanguageid(oid);
	
	LanguageManager.setLanguagename(Util.null2String(request.getParameter("languagename")));
  	LanguageManager.setencode(Util.null2String(request.getParameter("encode")));
  	LanguageManager.setisactive(Util.null2String(request.getParameter("isactive")));
  	LanguageManager.setLanguageInfo();
  	 LanguageComInfo.removeLanguageCache();
    response.sendRedirect("managelanguage.jsp");

  }
  else if(src.equalsIgnoreCase("editlanguage")){
    
	
  	int languageid=Util.getIntValue(Util.null2String(request.getParameter("languageid")),0);
	LanguageManager.reset();
  	LanguageManager.setAction("editlanguage");
  	LanguageManager.setLanguageid(languageid);
  	LanguageManager.setLanguagename(Util.null2String(request.getParameter("languagename")));
  	LanguageManager.setencode(Util.null2String(request.getParameter("encode")));
  	LanguageManager.setisactive(Util.null2String(request.getParameter("isactive")));
  	LanguageManager.setLanguageInfo();
  	 LanguageComInfo.removeLanguageCache();
    response.sendRedirect("language/managelanguage.jsp");

  }
  else ;

%>
 <input type="button" name="Submit2" value="退 回" onClick="javascript:history.go(-1)">