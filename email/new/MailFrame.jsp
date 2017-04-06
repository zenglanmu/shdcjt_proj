<%@ page language="java" contentType="text/html; charset=gbk" %>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh-CN" lang="zh-CN"> 
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=gbk" />
<link rel="stylesheet" type="text/css" href="" />
</head>
</html>
<frameset id="mailFrameSet" cols="160,8,*" border="0">
	<frame src="leftmenuForMailFrame.jsp" name="mailFrameLeft" frameborder=no />
	<frame src="/email/MailToggle.jsp" frameborder=no scrolling=no />  
	<frame src="/email/new/MailInBox.jsp" name="mailFrameRight" id="mailFrameRight" frameborder=no />
</frameset>
