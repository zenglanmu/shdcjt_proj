<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@page import="org.apache.commons.lang.StringUtils" %>
<%@page import="weaver.docs.docs.DocManager"%>
<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ include file="common.jsp" %>

<link rel="stylesheet" href="/css/Weaver.css" type="text/css">
<%
String noticeImg = (String)valueList.get(nameList.indexOf("noticeimg"));
String noticeTitle = (String)valueList.get(nameList.indexOf("noticetitle"));
String noticeContent = (String) valueList.get(nameList.indexOf("noticecontent"));
String direction = (String) valueList.get(nameList.indexOf("direction"));
String scrollDelay = (String) valueList.get(nameList.indexOf("scrollDelay"));
DocManager dcm=new DocManager();
dcm.setId(Util.getIntValue(noticeContent,-1));
dcm.getDocInfoById();
noticeContent =dcm.getDoccontent();
int tmppos = noticeContent.indexOf("!@#$%^&*");
if(tmppos!=-1)	{
	noticeContent = noticeContent.substring(tmppos+8);
}
if(noticeContent.indexOf("<script>")!=-1){
	//noticeContent = noticeContent.substring(0,noticeContent.indexOf("<script>"))+noticeContent.substring(noticeContent.indexOf("</script>")+8,noticeContent.length());
}

%>

	<style>
	td{
		margin: 0px;
	}
	table {
		margin: 0px;
	}  
</style>
	<table width=100%>
		<TR>
			<%if(!noticeImg.equals("")&&!noticeImg.equals("none")) {%>
			<TD width='20'>
				<img src=<%=noticeImg%> />
			</TD>
			<%} %>
			<%if(!noticeTitle.trim().equals("")) {%>
			<TD width='20%'>
				<font class='font'><%=noticeTitle%></font>
			</TD>
			<%} %>
			<TD class="field" width='*' valign="bottom">
			<marquee align=bottom  direction=<%= direction%>  onmouseout='this.start();'   onmouseover='this.stop();'   scrollAmount=1   scrollDelay=<%=scrollDelay %>   scrollleft='0'   scrolltop='0'>
				<font class='font'>
				<%
				if(direction.equals("right")&&false){
					out.print(StringUtils.reverse(noticeContent));
				}else{
					out.print(noticeContent);
				}
	
				%>
				</font>
			</marquee>
			</TD>
		</TR>		
		
	</TABLE>

	
