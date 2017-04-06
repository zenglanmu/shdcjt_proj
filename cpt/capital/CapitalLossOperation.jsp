
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>

<%
String capitalid = Util.fromScreen(request.getParameter("capitalid"),user.getLanguage());
String sptcount = Util.fromScreen(request.getParameter("sptcount"),user.getLanguage());
String capitalnum = Util.fromScreen(request.getParameter("capitalnum"),user.getLanguage());
String lossdate = Util.fromScreen(request.getParameter("lossdate"),user.getLanguage());
String departmentid = ""+Util.getIntValue(request.getParameter("departmentid"),0);
String resourceid = ""+Util.getIntValue(request.getParameter("resourceid"),0);
String fee = ""+Util.getDoubleValue(request.getParameter("fee"),0);
if(fee.equals("")){
    fee="0";
}
String remark = Util.fromScreenForCpt(request.getParameter("remark"),user.getLanguage());

if(!HrmUserVarify.checkUserRight("CptCapital:Loss", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}


char separator = Util.getSeparator() ;
String para = "";

if(sptcount.equals("1")){
    para = capitalid;
    para +=separator+lossdate;
    para +=separator+departmentid;
    para +=separator+resourceid;
    para +=separator+"1";
    para +=separator+"";
    para +=separator+"0";
    para +=separator+"";
    para +=separator+fee;
    para +=separator+"-7";
    para +=separator+remark;
    para +=separator+"0";
    para +=separator+sptcount;

    RecordSet.executeProc("CptUseLogLoss_Insert",para);
}
else{
    para = capitalid;
    para +=separator+lossdate;
    para +=separator+departmentid;
    para +=separator+resourceid;
    para +=separator+capitalnum;
    para +=separator+"";
    para +=separator+"0";
    para +=separator+"";
    para +=separator+fee;
    para +=separator+"-7";
    para +=separator+remark;
    para +=separator+"0";
    para +=separator+sptcount;

    RecordSet.executeProc("CptUseLogLoss_Insert",para);
    RecordSet.next();
    String rtvalue = RecordSet.getString(1);
    //ÊýÁ¿´íÎó
    if(rtvalue.equals("-1")){
        response.sendRedirect("CptCapitalLoss.jsp?capitalid="+capitalid+"&sptcount="+sptcount+"&msgid=1");
    }
}

CapitalComInfo.removeCapitalCache();
response.sendRedirect("CptCapital.jsp?id="+capitalid);
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">