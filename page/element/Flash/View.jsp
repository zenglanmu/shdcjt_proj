<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ include file="common.jsp" %>
<%
	String widthValue = (String)valueList.get(nameList.indexOf("width"));
	String heightValue = (String)valueList.get(nameList.indexOf("height"));
	String flashSrc = (String)valueList.get(nameList.indexOf("flashSrc"));
%>
<div id="flash_play_<%=eid%>" style="width:100%;height:<%=heightValue%>px;">
<!-- 
<object id ="flashPlayer_<%=eid %>"     
        type="application/x-shockwave-flash" width="100%" height="<%=heightValue%>">
        <param name="movie" value="<%=flashSrc%>" />
         <param name="wmode" value="transparent" />

</object>
 -->
<embed width="100%" height="<%=heightValue%>px;" wmode="opaque" name="plugin" src="<%=flashSrc%>" type="application/x-shockwave-flash">
</div>
