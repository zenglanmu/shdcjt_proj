
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>

<%
String capitalid = Util.fromScreen(request.getParameter("capitalid"),user.getLanguage());
String stateid = Util.fromScreen(request.getParameter("stateid"),user.getLanguage());
String afterstateid = Util.fromScreen(request.getParameter("afterstateid"),user.getLanguage());
String returndate = Util.fromScreen(request.getParameter("returndate"),user.getLanguage());
String departmentid = Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());
String costcenterid = Util.fromScreen(request.getParameter("costcenterid"),user.getLanguage());
String resourceid = Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());
String userequest = Util.fromScreen(request.getParameter("userequest"),user.getLanguage());
String fee = Util.fromScreen(request.getParameter("fee"),user.getLanguage());
if(fee.equals("")){
    fee="0";
}
String location = Util.fromScreen(request.getParameter("location"),user.getLanguage());
String remark = Util.fromScreenForCpt(request.getParameter("remark"),user.getLanguage());

if(!HrmUserVarify.checkUserRight("CptCapital:Return", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}


char separator = Util.getSeparator() ;
String para = "";

    para = capitalid;
    para +=separator+returndate;
    para +=separator+departmentid;
    para +=separator+resourceid;
    para +=separator+"1";
    para +=separator+location;
    para +=separator+userequest;
    para +=separator+"";
    para +=separator+fee;
    para +=separator+stateid;
    para +=separator+remark;
    para +=separator+costcenterid;
    para +=separator+afterstateid;

    RecordSet.executeProc("CptUseLogReturn_Insert",para);

CapitalComInfo.removeCapitalCache();
response.sendRedirect("CptCapital.jsp?id="+capitalid);
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">