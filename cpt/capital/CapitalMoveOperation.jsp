
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CptShare" class="weaver.cpt.capital.CptShare" scope="page" />
<%
String replacecapitalid = Util.fromScreen(request.getParameter("replacecapitalid"),user.getLanguage());
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String CptDept_to = Util.fromScreen(request.getParameter("CptDept_to"),user.getLanguage());
String hrmid = Util.fromScreen(request.getParameter("hrmid"),user.getLanguage());
String usecount="1"; 

String usestatus ="-4";
String remark = Util.fromScreenForCpt(request.getParameter("remark"),user.getLanguage());
String CptDept_from = CapitalComInfo.getDepartmentid(replacecapitalid);
char flag=2;
String para = "";

    para = replacecapitalid ;
    para +=flag+currentdate;
    para +=flag+CptDept_to;
    para +=flag+hrmid;
    para +=flag+usecount;
    para +=flag+"";		//ResourceComInfo.getCostcenterID(CptDept_to);
    para +=flag+usestatus;
    para +=flag+remark;    
    para +=flag+CptDept_from;
    out.print(para);


 
 RecordSet.executeProc("Capital_Adjust",para);
 CapitalComInfo.removeCapitalCache();
 CptShare.setCptShareByCpt(replacecapitalid);//¸üÐÂdetail±í 
 response.sendRedirect("CptCapital.jsp?id="+replacecapitalid); 
%>

