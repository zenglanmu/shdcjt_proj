<%@ page import="weaver.general.Util,
                 weaver.sms.SMSSaveAndSend" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SMSSaveAndSend" class="weaver.sms.SMSSaveAndSend" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("CreateSMS:View", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
    }
//String message = new String(request.getParameter("message").getBytes("8859_1"));
    String message = request.getParameter("message");
	String sender = Util.null2String(request.getParameter("sender"));
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
	if("".equals(sender)){
	    SMSSaveAndSend.setMessage(message + "-" + user.getUsername());
	}else{
		SMSSaveAndSend.setMessage(message + "-" + sender);
	}
	String rechrmnumbe_new = "";
		String ss[] = rechrmnumber.split(",");

		for (int i = 0; i < ss.length; i++) {
			String temp = ss[i];
			if ("".equals(temp))
				continue;
			temp = temp.substring(temp.indexOf('<') + 1, temp.indexOf('>'));

			rechrmnumbe_new = rechrmnumbe_new + "," + temp;
		}
	System.out.println(rechrmnumbe_new);
    SMSSaveAndSend.setRechrmnumber(rechrmnumbe_new);
    SMSSaveAndSend.setReccrmnumber(reccrmnumber);
    SMSSaveAndSend.setCustomernumber(customernumber);
    //System.out.println("customernumber = " + customernumber);

    SMSSaveAndSend.setRechrmids(rechrmids);
    SMSSaveAndSend.setReccrmids(reccrmids);
    SMSSaveAndSend.setSendnumber(sendnumber);
    SMSSaveAndSend.setRequestid(requestid);
    SMSSaveAndSend.setUserid(userid);
    SMSSaveAndSend.setUsertype(usertype);
    if (SMSSaveAndSend.send()) {
        response.sendRedirect("/sms/SmsMessageSuccess.jsp?noback=1");
    } else {
        response.sendRedirect("/sms/SmsMessageError.jsp?noback=1");
    }
%>