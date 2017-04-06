<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
    String operation = request.getParameter("operation");
    String meetingids = Util.null2String(request.getParameter("meetingids")) ;

    if (operation.equals("delMeeting")){   //点击删除时的操作
          //save data
          ArrayList idS = Util.TokenizerString(meetingids,",");
          for (int j=0 ;j<idS.size();j++){
              rs.executeSql("delete from meeting  where id ="+idS.get(j));
              rs.executeSql("delete from Meeting_ShareDetail where meetingid="+idS.get(j));
              rs.executeSql("delete from Meeting_View_Status where meetingid="+idS.get(j));
          }
          //redirect
          response.sendRedirect("MeetingMonitor.jsp");          
    }
%>

