<%@ page import="weaver.general.Util,
                 weaver.sms.SMSSaveAndSend" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SMSSaveAndSend" class="weaver.sms.SMSSaveAndSend" scope="page" />

<%
//String message = new String(request.getParameter("message").getBytes("8859_1"));
    String message = request.getParameter("message");
    String rechrmnumber = Util.null2String(request.getParameter("recievenumber1"));
    String reccrmnumber = Util.null2String(request.getParameter("recievenumber2"));

    String customernumber = Util.null2String(request.getParameter("customernumber"));

    String rechrmids = Util.null2String(request.getParameter("hrmids02"));
    String reccrmids = Util.null2String(request.getParameter("crmids02"));

    String sendnumber = Util.fromScreen(request.getParameter("sendnumber"), user.getLanguage());
    int requestid = 0;
    int userid = user.getUID();
    String usertype = user.getLogintype();

    SMSSaveAndSend.reset();
    SMSSaveAndSend.setMessage(message + "-" + user.getUsername() + "(" + user.getUID() + ")");
    SMSSaveAndSend.setRechrmnumber(rechrmnumber);
    SMSSaveAndSend.setReccrmnumber(reccrmnumber);
    SMSSaveAndSend.setCustomernumber(customernumber);
    System.out.println("customernumber = " + customernumber);

    SMSSaveAndSend.setRechrmids(rechrmids);
    SMSSaveAndSend.setReccrmids(reccrmids);
    SMSSaveAndSend.setSendnumber(sendnumber);
    SMSSaveAndSend.setRequestid(requestid);
    SMSSaveAndSend.setUserid(userid);
    SMSSaveAndSend.setUsertype(usertype);
    if (SMSSaveAndSend.send()) {
        response.sendRedirect("/sms/SmsMessageSuccess.jsp");
    } else {
        response.sendRedirect("/sms/SmsMessageError.jsp");
    }
%>