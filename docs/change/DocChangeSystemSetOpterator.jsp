<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/systeminfo/init.jsp"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.TimeUtil"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocChangeManager" class="weaver.docs.change.DocChangeManager" scope="page" />

<%
String autoSend = Util.null2String((String) request.getParameter("autoSend"));
int autoSendTime = Util.getIntValue(request.getParameter("autoSendTime"), 60);
String autoReceive = Util.null2String((String) request.getParameter("autoReceive"));
int autoReceiveTime = Util.getIntValue(request.getParameter("autoReceiveTime"), 60);
String serverURL = Util.null2String((String) request.getParameter("serverURL"));
int serverPort = Util.getIntValue((String) request.getParameter("serverPort"), 21);
String serverUser = Util.null2String((String) request.getParameter("serverUser"));
String serverPwd = Util.null2String((String) request.getParameter("serverPwd"));
String changeMode = Util.null2String((String) request.getParameter("changeMode"));
String maincategory = Util.null2String((String) request.getParameter("maincategory"));
String subcategory = Util.null2String((String) request.getParameter("subcategory"));
String seccategory = Util.null2String((String) request.getParameter("seccategory"));
String pathcategory = Util.null2String((String) request.getParameter("pathcategory"));

//±£´æÐÅÏ¢
String sql = "UPDATE DocChangeSetting SET ";
sql += "autoSend='"+autoSend+"',autoSendTime="+autoSendTime+",autoReceive='"+autoReceive+"',autoReceiveTime="+autoReceiveTime+",";
sql += "serverURL='"+serverURL+"',serverPort="+serverPort+",serverUser='"+serverUser+"',serverPwd='"+serverPwd+"',changeMode='"+changeMode+"',";
sql += "maincategory='"+maincategory+"',subcategory='"+subcategory+"',seccategory='"+seccategory+"',pathcategory='"+pathcategory+"'";
boolean issuccess = RecordSet.executeSql(sql);

if(issuccess) {
	staticobj.removeObject("DocChangeSetting.autoSend");
	DocChangeManager.setSettingCache();
%>
<script type="text/javascript">
alert('<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>');
location.href = '/docs/change/DocChangeSystemSet.jsp';
</script>
<%
}
else {
%>
<script type="text/javascript">
alert('<%=SystemEnv.getHtmlLabelName(15173,user.getLanguage())%>');
location.href = '/docs/change/DocChangeSystemSet.jsp';
</script>
<%
}
%>