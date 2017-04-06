<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.settings.ChgPasswdReminder,weaver.hrm.settings.RemindSettings" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<html> 
<body> 
<%
	User user = HrmUserVarify.getUser (request , response) ;
	
	ChgPasswdReminder reminder=new ChgPasswdReminder();
	RemindSettings settings=reminder.getRemindSettings();
	String RedirectFile = Util.null2String(request.getParameter("RedirectFile")) ;
	String gopage = Util.null2String(request.getParameter("gopage")) ;
	
	if(!"".equals(gopage)){
		RedirectFile = RedirectFile+ "&gopageOrientation="+gopage+"&gopage="+gopage;
	}
	String PasswordChangeReminderstr = Util.null2String(settings.getPasswordChangeReminder());
	boolean PasswordChangeReminder = false;
	if("1".equals(PasswordChangeReminderstr)){
		PasswordChangeReminder = true;
	}
	int passwdReminder = 0;
	if(PasswordChangeReminder){
		passwdReminder = 1;
	}
	String ChangePasswordDays = settings.getChangePasswordDays();
	String DaysToRemind = settings.getDaysToRemind();
	int id = user.getUID();
	String passwdchgdate = "";
	int passwdchgeddate = 0;
	int passwdreminddatenum = 0;
	int passwdelse = 0;
	String passwdreminddate = "";
	String canpass = "0";
	String canremind = "0";
	if(PasswordChangeReminder){
		RecordSet.executeSql("select passwdchgdate from hrmresource where id = "+id);
		if(RecordSet.next()){
			passwdchgdate = RecordSet.getString(1);
			passwdchgeddate = TimeUtil.dateInterval(passwdchgdate,TimeUtil.getCurrentDateString());
			System.out.println(passwdchgeddate);
			if(passwdchgeddate<Integer.parseInt(ChangePasswordDays)){
				canpass = "1";
			}
			passwdreminddate = TimeUtil.dateAdd(passwdchgdate,Integer.parseInt(ChangePasswordDays)-Integer.parseInt(DaysToRemind));
			try {
				passwdreminddatenum = TimeUtil.dateInterval(passwdreminddate,TimeUtil.getCurrentDateString());
			} catch(Exception ex) {
				passwdreminddatenum = 0;
			}
			passwdelse = Integer.parseInt(DaysToRemind) - passwdreminddatenum;
			if(passwdreminddatenum>=0){
				canremind = "1";
			}
		}else{
			response.sendRedirect(RedirectFile);
			return;
		}
	}else{
		response.sendRedirect(RedirectFile);
		return;
	}
	
%>
</body>
</html>
<script language="javascript">
var passwdReminder = <%=passwdReminder%>
var canpass = <%=canpass%>
var canremind = <%=canremind%>
var passwdelse = <%=passwdelse%>
if(passwdReminder==1){
	if(canpass==1){
		if(canremind==1){
			result = confirm("<%=SystemEnv.getHtmlLabelName(23988,user.getLanguage())+passwdelse+SystemEnv.getHtmlLabelName(1925,user.getLanguage())+SystemEnv.getHtmlLabelName(23989,user.getLanguage())+"£¬"+SystemEnv.getHtmlLabelName(23990,user.getLanguage())+"£¿"%>");
			if(result){
				window.location = "/hrm/resource/HrmResourcePassword.jsp?frompage=/login/RemindLogin.jsp&canpass=1&RedirectFile=<%=RedirectFile%>";
			}else{
				window.location = "<%=RedirectFile%>";
			}
		}else{
			window.location = "<%=RedirectFile%>";
		}
	}else{
		result = confirm("<%=SystemEnv.getHtmlLabelName(23997,user.getLanguage())+"£¬"+SystemEnv.getHtmlLabelName(23998,user.getLanguage())+"£¡"%>");
		if(result){
			window.location = "/hrm/resource/HrmResourcePassword.jsp?frompage=/login/RemindLogin.jsp&RedirectFile=<%=RedirectFile%>";
		}else{
			window.location = "/login/Logout.jsp";
		}
	}
}
</script>