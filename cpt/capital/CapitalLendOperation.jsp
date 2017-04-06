
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CptShare" class="weaver.cpt.capital.CptShare" scope="page" />
<%
String capitalid = Util.fromScreen(request.getParameter("capitalid"),user.getLanguage());
String hrmid = Util.fromScreen(request.getParameter("hrmid"),user.getLanguage());
String departmentid = Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());
String lenddate = Util.fromScreen(request.getParameter("lenddate"),user.getLanguage());
String location = Util.fromScreen(request.getParameter("location"),user.getLanguage());
String remark = Util.fromScreenForCpt(request.getParameter("remark"),user.getLanguage());

if(!HrmUserVarify.checkUserRight("CptCapital:Lend", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}


char separator = Util.getSeparator() ;
String para = "";

// get today
Calendar todaycal = Calendar.getInstance ();
String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
               Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
               Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;

boolean isToday = lenddate.equals(today);
//modified by zhouquan TD1427 如果是当天借用的，就立即执行，否则加入缓存表，等待后台处理线程到达执行周期时执行
//修改成立即生效
if(isToday||true){
    para = capitalid;
    para +=separator+lenddate;
    para +=separator+departmentid;
    para +=separator+hrmid;
    para +=separator+"1";
    para +=separator+location;
    para +=separator+"0";
    para +=separator+"";
    para +=separator+"0";
    para +=separator+"3";
    para +=separator+remark;
    para +=separator+"0";

    RecordSet.executeProc("CptUseLogLend_Insert",para);
    CapitalComInfo.removeCapitalCache();
    CptShare.setCptShareByCpt(capitalid);//更新detail表 
}
else{
    para = capitalid;
    para +=separator+lenddate;
    para +=separator+departmentid;
    para +=separator+hrmid;
    para +=separator+location;
    para +=separator+remark;
    
    RecordSet.executeProc("CptBorrowBuffer_Insert", para);
}

if (RecordSet.next() && RecordSet.getInt(1) == -1 ) {
    response.sendRedirect("CptCapitalLend.jsp?msgid=-1");
    return;
}

response.sendRedirect("CptCapital.jsp?id="+capitalid);
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">