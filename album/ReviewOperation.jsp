<%@ page language="java" contentType="text/html; charset=gbk" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="weaver.general.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hrm" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
String sql = "";
int photoId = Util.getIntValue(request.getParameter("id"));
int userId = user.getUID();
String postdate = "";
String reviewContent = Util.null2String(request.getParameter("reviewContent"));

rs.executeSql("INSERT INTO AlbumPhotoReview (photoId,userId,postdate,content) VALUES ("+photoId+","+userId+",'"+postdate+"','"+reviewContent+"')");
response.sendRedirect("PhotoReview.jsp?id="+photoId+"");
%>