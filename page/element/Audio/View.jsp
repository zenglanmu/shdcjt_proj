<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ include file="common.jsp" %>

<%
	String heightValue = (String)valueList.get(nameList.indexOf("height"));
	String widthValue = (String)valueList.get(nameList.indexOf("width"));
	String autoPlayValue = (String)valueList.get(nameList.indexOf("autoPlay"));
	String audioSrcValue = (String)valueList.get(nameList.indexOf("audioSrc"));
%>
<div id="audio_play_<%=eid%>" style="width:<%="100%"%>;height:<%=heightValue%>">

<object id="audioplayer_<%=eid%>" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" align="middle" height="<%=heightValue%>" width="<%="100%"%>">
    <param name="quality" value="best">
	<param name="SAlign" value="LT">
    <param name="allowScriptAccess" value="never">
    <param name="wmode" value="transparent">
    <param name="movie" value="<%=ePath%>resource/js/audio-player.swf?audioUrl=<%=audioSrcValue%>&<%=autoPlayValue.equals("on")?"autoPlay=true":""%>">
    <embed src="<%=ePath%>resource/js/audio-player.swf?audioUrl=<%=audioSrcValue%>&<%=autoPlayValue.equals("on")?"autoPlay=true":""%>" mce_src="flash/top.swf"  wmode="transparent" menu="false" quality="high"  
          width="100%" height="<%=heightValue%>" allowscriptaccess="sameDomain" type="application/x-shockwave-flash"  
         pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object>
</div>