<%@ page import="weaver.general.Util,weaver.hrm.User,
                 weaver.rtx.RTXConfig" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RTXExtCom" class="weaver.rtx.RTXExtCom" scope="page" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE> New Document </TITLE>
<META NAME="Generator" CONTENT="EditPlus">
<META NAME="Author" CONTENT="">
<META NAME="Keywords" CONTENT="">
<META NAME="Description" CONTENT="">
<%
    String notify = Util.null2String(request.getParameter("notify"));
    String rtxname = user.getLoginid();
    String sessionKey = RTXExtCom.getSessionKey(rtxname);
    RTXConfig rtxConfig = new RTXConfig();
    String serverUrl="";
    
    String serverUrl_in = rtxConfig.getPorp(RTXConfig.RTX_SERVER_IP); 
    String serverUrl_out = rtxConfig.getPorp(RTXConfig.RTX_SERVER_OUT_IP);
	String rtxConnServer = Util.null2String(rtxConfig.getPorp(RTXConfig.RTX_ConnServer));
    if("".equals(rtxConnServer)) rtxConnServer = "8000";
    String strIsaIp=Util.null2String(rtxConfig.getPorp("ISAIP"));
    String strRemoteIp=Util.null2String(request.getRemoteHost());


    out.println("strIsaIp:"+strIsaIp);
    out.println("remoteAddr2:"+strRemoteIp);

    if(!strIsaIp.equals("")){
	if(strRemoteIp.equals(strIsaIp)){
		serverUrl=serverUrl_out;
	} else {
		serverUrl=serverUrl_in;
	}
    } else {
	try{
	    String[]  aryRemote=Util.TokenizerString2(strRemoteIp,".");  
	    String[]  aryAddr_in=Util.TokenizerString2(serverUrl_in,".");  
	   
	    if(aryRemote[0].equals(aryAddr_in[0]) || aryRemote[0].equals("127")){
	    	serverUrl=serverUrl_in;
	    } else {
	    	serverUrl=serverUrl_out;
	    }
         }catch(Exception ex){
    	   serverUrl=serverUrl_out;
	 }
    }
    
    //System.out.println("sessionKey = " + sessionKey);
    out.println("serverUrl = " + serverUrl);

%>
<SCRIPT language=VBScript>
function window_onload()
<%if(sessionKey != null && !sessionKey.equals("")){%>
    on error resume next
    Set objProp = RTXCLIENT.GetObject("Property")

    objProp.value("RTXUsername") = "<%=rtxname%>"
    objProp.value("LoginSessionKey") = "<%=sessionKey%>"
    objProp.value("ServerAddress") = "<%=serverUrl%>" 'RTX Server IP地址
    objProp.value("ServerPort") = "<%=rtxConnServer%>"
    RTXCLIENT.CALL 2, objProp

    <%if(notify.equals("true")){%>
    if (err.number <> 0) then
        alert "您没有安装RTX的客户端,请到系统里的泛微插件下载页面下载并安装客户端"
    end if
    <%}%>
<%}%>
end function
</SCRIPT>
</HEAD>

<BODY>
<%if(sessionKey != null && !sessionKey.equals("")){%>
<OBJECT classid=clsid:5EEEA87D-160E-4A2D-8427-B6C333FEDA4D id=RTXCLIENT>　</OBJECT>
<%}%>
</BODY>
</HTML>
