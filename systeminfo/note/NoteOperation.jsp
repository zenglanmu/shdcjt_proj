<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
 char separator = Util.getSeparator() ;
  String operation = Util.null2String(request.getParameter("operation"));
  if(operation.equalsIgnoreCase("search")){
    String searchcon=request.getParameter("searchcon");	
    response.sendRedirect("ManageNote.jsp?searchcon="+searchcon);
  }
  
  //添加操作
  else if(operation.equalsIgnoreCase("addnote")){ 
  	
  	String indexdesc = Util.fromScreen(request.getParameter("indexdesc"),user.getLanguage());
/*
  	NoteMainManager.resetParameter();
  	NoteMainManager.setIndexdesc(indexdesc);
  	NoteMainManager.setAction(operation);
  	NoteMainManager.setNoteInfo();
  	
	int id =0 ; 	
 	NoteMainManager.resetParameter();
  	NoteMainManager.setIndexdesc(indexdesc);
  	NoteMainManager.selectSigleNoteInfo();
  	if(NoteMainManager.next()) id = NoteMainManager.getId();
  	NoteMainManager.closeStatement();

	while(LanguageComInfo.next()){
		String langid = LanguageComInfo.getLanguageid();
	  	NoteInfoManager.resetParameter();
	  	NoteInfoManager.setAction(operation);
	  	NoteInfoManager.setIndexid(id);
	  	NoteInfoManager.setLanguageid(Util.getIntValue(langid,0));
	  	String notename = Util.fromScreen(request.getParameter("notename"+langid),user.getLanguage());
	  	NoteInfoManager.setNotename(notename);
	  	NoteInfoManager.setNoteInfo();
	}
	NoteComInfo.removeNoteCache();
  	response.sendRedirect("ManageNote.jsp");
*/
  
  	String id_1 = Util.fromScreen(request.getParameter("id_1"),user.getLanguage());
	String cfSql = "";
	if(rs.getDBType().equals("oracle")){
		cfSql="select id from (select id  from htmlNoteindex where id="+id_1+") where rownum=1 ";
	}else{
		cfSql = "select top 1 id  from htmlNoteindex where id="+id_1;
	}

	rs.executeSql(cfSql); 
	if(rs.next()){
	response.sendRedirect("AddNote.jsp?errorMsg=1");
	   return;
	} 	
	String indexdesc_1 = Util.fromScreen(request.getParameter("indexdesc"),user.getLanguage());
  	String para=""+id_1+separator+indexdesc_1;
    rs.executeProc("HtmlNoteIndex_Insert",para);
//多语言加入相同的indexid写入info表
        rs.executeSql("select * from syslanguage");
	while(rs.next()){
		//String langid = LanguageComInfo.getLanguageid();
		String langid=rs.getString("id");
		String notename = Util.fromScreen(request.getParameter("notename"+langid),user.getLanguage());
		para=""+id_1+separator+notename+separator+langid;
		rs.executeProc("HtmlNoteInfo_Insert",para);
	}
    	response.sendRedirect("ManageNote.jsp");
  	return ;	
 }
 
 //删除操作
 else if(operation.equalsIgnoreCase("deletenote")){
 
 if(Util.getIntValue(user.getSeclevel(),0)<20){
		response.sendRedirect("ManageNote.jsp");
	}
	String[] delete_note_id=request.getParameterValues("delete_note_id");
	if (delete_note_id!=null){
	
	 for(int i = 0; i < delete_note_id.length; i++){
  	String deleteSql1="delete from HtmlNoteIndex where id=" + delete_note_id[i];
  	String deleteSql2="delete from HtmlNoteInfo where indexid=" + delete_note_id[i];
        rs.executeSql(deleteSql1);
        rs.executeSql(deleteSql2);
        }}
  	response.sendRedirect("ManageNote.jsp");
  	return ;
 
 }
 //修改--采用先删后加的形式
 else if(operation.equalsIgnoreCase("editnote")){ 
  	String indexdesc = Util.fromScreen(request.getParameter("indexdesc"),user.getLanguage());
  	int id = Util.getIntValue(request.getParameter("id"),0);
  	
  	rs.executeSql("delete from HtmlNoteIndex where id=" + id);//删除index记录
        rs.executeSql("delete from HtmlNoteInfo where indexid=" + id);//删除info记录
  	/*
  	NoteMainManager.resetParameter();
  	NoteMainManager.setIndexdesc(indexdesc);
  	NoteMainManager.setId(id);
  	NoteMainManager.setAction(operation);
  	NoteMainManager.setNoteInfo();
  	out.print("id is " + id);
  	out.print("indexdesc is " + indexdesc);
	while(LanguageComInfo.next()){
		String langid = LanguageComInfo.getLanguageid();
	  	NoteInfoManager.resetParameter();
	  	NoteInfoManager.setAction(operation);
	  	NoteInfoManager.setIndexid(id);
	  	NoteInfoManager.setLanguageid(Util.getIntValue(langid,0));
	  	String notename = Util.fromScreen(request.getParameter("notename"+langid),user.getLanguage());
	  	NoteInfoManager.setNotename(notename);
	  	out.print("notename is " + notename);
	  	NoteInfoManager.setNoteInfo();
	}
	NoteComInfo.removeNoteCache();
	*/
	
   String para=""+id+separator+indexdesc;
    rs.executeProc("HtmlNoteIndex_Insert",para);
//多语言加入相同的indexid写入info表
        rs.executeSql("select * from syslanguage");
	while(rs.next()){
		//String langid = LanguageComInfo.getLanguageid();
		String langid=rs.getString("id");
		String notename = Util.fromScreen(request.getParameter("notename"+langid),user.getLanguage());
		para=""+id+separator+notename+separator+langid;
		rs.executeProc("HtmlNoteInfo_Insert",para);
	}
	
 	response.sendRedirect("ManageNote.jsp");
 }
%>