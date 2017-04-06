<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="InterfaceTransmethod" class="weaver.formmode.interfaces.InterfaceTransmethod" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
FileUpload fu = new FileUpload(request);

String operation = Util.null2String(fu.getParameter("operation"));
String sql = "";

String treename = InterfaceTransmethod.toHtmlForMode(fu.getParameter("treename"));
String treedesc = InterfaceTransmethod.toHtmlForMode(fu.getParameter("treedesc"));
String rootname = InterfaceTransmethod.toHtmlForMode(fu.getParameter("rootname"));
String rooticon = Util.null2String(fu.uploadFiles("rooticon"));
String oldrooticon = Util.null2String(fu.getParameter("oldrooticon"));
String defaultaddress = InterfaceTransmethod.toHtmlForMode(fu.getParameter("defaultaddress"));
String expandfirstnode = InterfaceTransmethod.toHtmlForMode(fu.getParameter("expandfirstnode"));
int id = Util.getIntValue(Util.null2String(fu.getParameter("id")),0);
String currentdate = TimeUtil.getCurrentDateString();
String currenttime = TimeUtil.getOnlyCurrentTimeString();
if(rooticon.equals("")){
	rooticon = oldrooticon;
}
int creater = user.getUID();
if (operation.equals("save")) {
	sql = "insert into mode_customtree(treename,treedesc,creater,createdate,createtime,rootname,rooticon,defaultaddress,expandfirstnode)"+
	" values ('"+treename+"','"+treedesc+"','"+creater+"','"+currentdate+"','"+currenttime+"','"+rootname+"','"+rooticon+"','"+defaultaddress+"','"+expandfirstnode+"')";
	rs.executeSql(sql);
	
	sql = "select max(id) id from mode_customtree where creater = " + creater + " and treename = '"+treename+"'";
	rs.executeSql(sql);
	while(rs.next()){
		id = rs.getInt("id");
	}
	response.sendRedirect("/formmode/tree/CustomTreeView.jsp?id="+id);
}else if (operation.equals("edit")) {
	sql = "update mode_customtree set";
	sql += " treename = '"+treename+"',";
	sql += " treedesc = '"+treedesc+"',";
	sql += " rootname = '"+rootname+"',";
	sql += " defaultaddress = '"+defaultaddress+"',";
	sql += " expandfirstnode = '"+expandfirstnode+"',";
	sql += " rooticon = '"+rooticon+"'";
	sql += " where id = " + id;
	rs.executeSql(sql);
	response.sendRedirect("/formmode/tree/CustomTreeView.jsp?id="+id);
}else if (operation.equals("del")) {
	sql = "delete from mode_customtree ";
	sql += " where id = " + id;
	rs.executeSql(sql);
	response.sendRedirect("/formmode/tree/CustomTreeList.jsp");
%>
	<!-- 
	<script language="javascript">
		var newwin = window.open("","_parent","").close();
	</script>
	-->
<%	
}

%>