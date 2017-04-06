
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>

<%
String capitalid = Util.fromScreen(request.getParameter("capitalid"),user.getLanguage());
String discarddate = Util.fromScreen(request.getParameter("discarddate"),user.getLanguage());
String capitalnum = Util.fromScreen(request.getParameter("capitalnum"),user.getLanguage());
String userequest = Util.fromScreen(request.getParameter("userequest"),user.getLanguage());
String fee = ""+Util.getDoubleValue(request.getParameter("fee"),0);
String sptcount = Util.fromScreen(request.getParameter("sptcount"),user.getLanguage());
if(fee.equals("")){
    fee = "0";
}
String remark = Util.fromScreenForCpt(request.getParameter("remark"),user.getLanguage());

if(!HrmUserVarify.checkUserRight("CptCapital:Discard", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}

String sqlstr ="select sptcount from CptCapital where id = " + capitalid;
RecordSet.executeSql(sqlstr);
RecordSet.next();
sptcount = RecordSet.getString("sptcount");
if (sptcount.equals("")){
		sptcount="0" ;
}

char separator = Util.getSeparator() ;
String para = "";
if(sptcount.equals("1")){
para = capitalid;
para +=separator+discarddate;
para +=separator+"0";
para +=separator+"0";
para +=separator+"1";
para +=separator+"";
para +=separator+"0";
para +=separator+"";
para +=separator+fee;
para +=separator+"5";
para +=separator+remark;
para +=separator+sptcount;
RecordSet.executeProc("CptUseLogDiscard_Insert",para);
}
else
{
para = capitalid;
para +=separator+discarddate;
para +=separator+"0";
para +=separator+"0";
para +=separator+capitalnum;
para +=separator+"";
para +=separator+"0";
para +=separator+"";
para +=separator+fee;
para +=separator+"5";
para +=separator+remark;
para +=separator+sptcount;

RecordSet.executeProc("CptUseLogDiscard_Insert",para);
RecordSet.next();
String rtvalue = RecordSet.getString(1);    
	//ÊýÁ¿´íÎó
    if(rtvalue.equals("-1"))
	{
       response.sendRedirect("CptCapitalDiscard.jsp?capitalid="+capitalid+"&msgid=1"); 
	} 
}
CapitalComInfo.removeCapitalCache();
response.sendRedirect("CptCapital.jsp?id="+capitalid);
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">