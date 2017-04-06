<%@ page language="java" contentType="text/html; charset=gbk" %> 
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String showTop = Util.null2String(request.getParameter("showTop"));
String sql = "";
int secId = Util.getIntValue(request.getParameter("secId"));
int mainId = Util.getIntValue(request.getParameter("mainId"));
int subId = Util.getIntValue(request.getParameter("subId"));
int crmSecId = Util.getIntValue(request.getParameter("crmSecId"));
int layout = Util.getIntValue(request.getParameter("layout"));
int perpage = Util.getIntValue(request.getParameter("perpage"));
int emlsavedays = Util.getIntValue(request.getParameter("emlsavedays"),0);
int defaulttype = Util.getIntValue(request.getParameter("defaulttype"));
int autosavecontact = Util.getIntValue(request.getParameter("autosavecontact"),0);

sql = "SELECT id FROM MailSetting WHERE userId="+user.getUID()+"";
rs.executeSql(sql);
if(rs.next()){
	rs.executeSql("UPDATE MailSetting SET mainId="+mainId+", subId="+subId+", secId="+secId+", crmSecId="+crmSecId+", layout="+layout+", perpage="+perpage+", emlsavedays="+emlsavedays+",defaulttype="+defaulttype+",autosavecontact="+autosavecontact+" WHERE userId="+user.getUID()+"");
}else{
	rs.executeSql("INSERT INTO MailSetting (userId, mainId, subId, secId, crmSecId, layout, perpage, emlsavedays,defaulttype,autosavecontact) VALUES ("+user.getUID()+", "+mainId+", "+subId+", "+secId+", "+crmSecId+", "+layout+", "+perpage+", "+emlsavedays+","+defaulttype+","+autosavecontact+")");
}
if(showTop.equals("")) {
	response.sendRedirect("MailSetting.jsp");
} else if(showTop.equals("show800")) {
	response.sendRedirect("MailSetting.jsp?showTop=show800");
}

%>
