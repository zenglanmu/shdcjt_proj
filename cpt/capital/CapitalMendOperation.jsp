
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>

<%
String capitalid = Util.fromScreen(request.getParameter("capitalid"),user.getLanguage());
String menddate = Util.fromScreen(request.getParameter("menddate"),user.getLanguage());
String userequest = Util.fromScreen(request.getParameter("userequest"),user.getLanguage());
String maintaincompany = Util.fromScreen(request.getParameter("maintaincompany"),user.getLanguage());
String remark = Util.fromScreenForCpt(request.getParameter("remark"),user.getLanguage());
String resourceid = Util.fromScreenForCpt(request.getParameter("resourceid"),user.getLanguage());
String mendperioddate = Util.fromScreenForCpt(request.getParameter("mendperioddate"),user.getLanguage());
if(!HrmUserVarify.checkUserRight("CptCapital:Mend", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}


char separator = Util.getSeparator() ;
String para = "";

    para = capitalid;
    para +=separator+menddate;
    para +=separator+"";
    para +=separator+"";
    para +=separator+"1";
    para +=separator+"";
    para +=separator+"0";
    para +=separator+maintaincompany;
    para +=separator+"0";
    para +=separator+"4";
    para +=separator+remark;
    para +=separator+resourceid;
    para +=separator+mendperioddate;

    RecordSet.executeProc("CptUseLogMend_Insert",para);

CapitalComInfo.removeCapitalCache();
response.sendRedirect("CptCapital.jsp?id="+capitalid);
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">