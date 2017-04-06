<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String operation = Util.null2String(request.getParameter("operation"));

	String phraseId = Util.null2String(request.getParameter("phraseId"));
	String phraseShort = Util.null2String(request.getParameter("phraseShort"));
	String phraseDesc = Util.null2String(request.getParameter("phraseDesc"));		

	String userId = ""+user.getUID() ;
	char separator = Util.getSeparator() ;
	String para = "";
	

	if (operation.equals("add")) {
		para = userId + separator + phraseShort + separator + phraseDesc ;
		rs.executeProc("sysPhrase_insert",para);	
		response.sendRedirect("PhraseList.jsp");
		return ;
	} else if (operation.equals("edit")) {
        rs.executeSql("select * from sysPhrase where hrmid="+userId+" and id="+phraseId) ;
        if(rs.next()){
		para = phraseId + separator + userId + separator + phraseShort + separator + phraseDesc ;
		rs.executeProc("sysPhrase_update",para);
        }
		response.sendRedirect("PhraseView.jsp?phraseId="+phraseId);
		return ;
	} else if (operation.equals("delete")) {
        rs.executeSql("select * from sysPhrase where hrmid="+userId+" and id="+phraseId) ;
        if(rs.next()){
		para = phraseId ;
		rs.executeProc("sysPhrase_deleteById",para);
        }
		response.sendRedirect("PhraseList.jsp");
		return ;
	}

%>
