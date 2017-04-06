
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CptShare" class="weaver.cpt.capital.CptShare" scope="page" />
<%
String capitalid = Util.fromScreen(request.getParameter("capitalid"),user.getLanguage());
String backdate = Util.fromScreen(request.getParameter("backdate"),user.getLanguage());
String sptcount = Util.fromScreen(request.getParameter("sptcount"),user.getLanguage());
String remark = Util.fromScreenForCpt(request.getParameter("remark"),user.getLanguage());

if(!HrmUserVarify.checkUserRight("CptCapital:Discard", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
int userid = user.getUID();
int  deparmentid  = user.getUserDepartment();
String sql="";
	sql="select sptcount from CptCapital where id="+ capitalid;
	RecordSetM.executeSql(sql);
	RecordSetM.next(); 
	sptcount = RecordSetM.getString("sptcount");

char separator = Util.getSeparator() ;
String para = "";

para = capitalid;
para +=separator+backdate;
para +=(separator+""+deparmentid);
para +=(separator+""+userid);
para +=separator+"1";
para +=separator+"";
para +=separator+"0";
para +=separator+"";
para +=separator+"0";
para +=separator+"1";
para +=separator+remark;
para +=separator+"0";
para +=separator+sptcount;
RecordSet.executeProc("CptUseLogBack_Insert",para);

CapitalComInfo.removeCapitalCache();
CptShare.setCptShareByCpt(capitalid);//¸üÐÂdetail±í 
response.sendRedirect("CptCapital.jsp?id="+capitalid);
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">