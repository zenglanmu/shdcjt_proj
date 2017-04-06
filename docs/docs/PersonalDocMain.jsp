<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<html>
<head></head>
<frameset name="pdocMain"  cols="175,6,*"  rows="*" frameborder="no" border="0" framespacing="5" > 
    <frame name="pdocLeft"  scrolling="auto"  src="PersonalDocLeft.jsp"   NORESIZE="true" > 
    <frame name="pdocCenter"  scrolling="no" src="PersonalDocCenter.jsp" NORESIZE="true" > 
    <frame name="pdocRight"  scrolling="auto" src="PersonalDocRight.jsp"  NORESIZE="true" > 
</frameset>
<noframes>
<body bgcolor="#FFFFFF" text="#000000">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
    对不起，您的浏览器不支持框架
</body>
</noframes>
</html>
