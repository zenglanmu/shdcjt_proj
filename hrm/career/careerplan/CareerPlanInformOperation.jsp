<%@ page import="weaver.general.Util,
                 weaver.conn.RecordSet,
                 weaver.hrm.career.HrmCareerPlanInform" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>

<%
int careerplanid = Util.getIntValue(request.getParameter("CareerPlanID"));
String principalid ="";
String topic ="";
RecordSet rs = new RecordSet();
String sql = "select * from HrmCareerPlan where id ="+careerplanid ;
rs.executeSql(sql);
while(rs.next()){
  topic = Util.null2String(rs.getString("topic"));
  principalid = Util.null2String(rs.getString("principalid"));
}

boolean haseditright = false ;

if( HrmUserVarify.checkUserRight("HrmCareerPlanEdit:Edit", user) || principalid.equals(""+user.getUID()))
    haseditright = true ;

if(!haseditright){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

    HrmCareerPlanInform inform = new HrmCareerPlanInform(user ,careerplanid);
    inform.setTopic(topic);
    inform.informAll();

    response.sendRedirect("HrmCareerPlanEdit.jsp?id="+careerplanid);
%>


