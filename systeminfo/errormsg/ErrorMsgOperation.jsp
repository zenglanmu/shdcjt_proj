<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ErrorMsgComInfo" class="weaver.systeminfo.errormsg.ErrorMsgComInfo" scope="page"/>
<%
 char separator = Util.getSeparator() ;
  String operation = Util.null2String(request.getParameter("operation"));
  if(operation.equalsIgnoreCase("search")){
    String searchcon=request.getParameter("searchcon");	
    response.sendRedirect("ManageErrorMsg.jsp?searchcon="+searchcon);
  }
  
  //删除操作
  else if(operation.equalsIgnoreCase("deleteerrormsg")){ 
  	String[] delete_errormsg_id=request.getParameterValues("delete_errormsg_id");
	if (delete_errormsg_id!=null){
	
	 for(int i = 0; i < delete_errormsg_id.length; i++){
  	String deleteSql1="delete from ErrorMsgIndex where id=" + delete_errormsg_id[i];
  	String deleteSql2="delete from ErrorMsgInfo where indexid=" + delete_errormsg_id[i];
        rs.executeSql(deleteSql1);
        rs.executeSql(deleteSql2);
        }}
        ErrorMsgComInfo.removeErrorMsgCache();
  	response.sendRedirect("ManageErrorMsg.jsp");
  	return ;
  }
  
  //添加操作
  else if(operation.equalsIgnoreCase("adderrormsg")){ 
  	
  	String indexdesc = Util.fromScreen(request.getParameter("indexdesc"),user.getLanguage());

  	String id_1 = Util.fromScreen(request.getParameter("id_1"),user.getLanguage());
	String cfSql = "";
	if(rs.getDBType().equals("oracle")){
		cfSql="select id from (select id  from ErrorMsgindex where id="+id_1+") where rownum=1 ";
	}else{
		cfSql = "select top 1 id  from ErrorMsgindex where id="+id_1;
	}

	rs.executeSql(cfSql); 
	if(rs.next()){
	response.sendRedirect("AddErrorMsg.jsp?errorMsg=1");
	   return;
	} 	
	String indexdesc_1 = Util.fromScreen(request.getParameter("indexdesc"),user.getLanguage());
  	String para=""+id_1+separator+indexdesc_1;
    rs.executeProc("ErrorMsgIndex_Insert",para);
//多语言加入相同的indexid写入info表
        rs.executeSql("select * from syslanguage");
	while(rs.next()){
		//String langid = LanguageComInfo.getLanguageid();
		String langid=rs.getString("id");
		String errormsgname = Util.fromScreen(request.getParameter("errormsgname"+langid),user.getLanguage());
		para=""+id_1+separator+errormsgname+separator+langid;
		rs.executeProc("ErrorMsgInfo_Insert",para);
	}
   ErrorMsgComInfo.removeErrorMsgCache();
  	response.sendRedirect("ManageErrorMsg.jsp");
  	return ;	

 }
//修改操作
 else if(operation.equalsIgnoreCase("editerrormsg")){ 
  	String indexdesc = Util.fromScreen(request.getParameter("indexdesc"),user.getLanguage());
  	int id = Util.getIntValue(request.getParameter("id"),0);
  	rs.executeSql("delete from ErrorMsgIndex where id=" + id);//删除index记录
        rs.executeSql("delete from ErrorMsgInfo where indexid=" + id);//删除info记录
  		
   String para=""+id+separator+indexdesc;
    rs.executeProc("ErrorMsgIndex_Insert",para);
//多语言加入相同的indexid写入info表
        rs.executeSql("select * from syslanguage");
	while(rs.next()){
		String langid=rs.getString("id");
		String errormsgname = Util.fromScreen(request.getParameter("errormsgname"+langid),user.getLanguage());
		para=""+id+separator+errormsgname+separator+langid;
		rs.executeProc("ErrorMsgInfo_Insert",para);
	}
	   ErrorMsgComInfo.removeErrorMsgCache();
  	response.sendRedirect("ManageErrorMsg.jsp");
  	
  	
  	}
%>
