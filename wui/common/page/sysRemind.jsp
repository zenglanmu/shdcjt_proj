<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%
  int labelid=Util.getIntValue(((String)request.getAttribute("labelid")==null?request.getParameter("labelid"):(String)request.getAttribute("labelid")),0);
  String msg=SystemEnv.getHtmlLabelName(labelid,7);
%>
<html>
  <head>
    <title>系统提醒</title>
    <script type="text/javascript" src="/wui/common/jquery/jquery.js"></script>
    <link type='text/css' rel='stylesheet'  href='/wui/theme/ecology7/skins/default/wui.css'/>
  </head>
<body style="margin:0px;padding:0px;">
<div style="width: 100%;position:absolute;margin-top: 10%" align="center" id="messageArea">
    <div style="width: 582px;font-size:16px;height:309px;background:url(/wui/common/page/images/error.png) no-repeat;text-align:left;" align="center">
    <div style="float:left; ">
    	<div style=" height:128px; width:123px;background: url(/wui/common/page/images/error_left.png); margin-top:80px;margin-left:40px!important; margin-left:20px"></div>
    </div>
	<div style=" height:120px; border-left:solid 1px #e3e3e3; margin:20px; float:left; margin-left:40px;margin-top:80px"></div>
	<div style="height:260px; width:320px; float:left;margin-top:40px; line-height:25px;padding-top:30px;">
		
		<%if(labelid==1){ //浏览器版本不支持提醒
		    String browserName=Util.null2String(request.getParameter("browserName"));
		    String browserVersion=request.getParameter("browserVersion");
		    String minVersion="";
		    if(browserName.equals("IE"))
		    	minVersion="IE 8";
		    else if(browserName.equals("FF"))
		    	minVersion="Firefox 9";
		    else if(browserName.equals("Chrome"))
		    	minVersion="Chrome 14";
		    else if(browserName.equals("Safari"))
		    	minVersion="Safari 5";
		%>
		  <p style=" font-weight:bold">
		             您当前的浏览器是<%=browserName%>浏览器， 版本是<%=browserVersion%>,版本过低，请升级<%=browserName%>至<span style="color: red;"><%=minVersion%></span>以上，或者使用其他浏览器！<br>
		            <a href="http://windows.microsoft.com/zh-CN/internet-explorer/products/ie/home"  style="text-decoration: underline !important;">IE</a>&nbsp;
		            <a href="http://www.google.cn/chrome/intl/zh-CN/landing_chrome.html" style="text-decoration: underline !important;">Chrome</a>&nbsp;
		            <a href="http://www.firefox.com.cn/download/"  style="text-decoration: underline !important;">Firefox</a>&nbsp;
		            <a href="http://www.apple.com.cn/safari/download/"  style="text-decoration: underline !important;">Safari</a>
		  </p>   
		<%}else if(labelid==2){  //移动设备访问提醒
			 String browserOS=Util.null2String(request.getParameter("browserOS"));
		%>   
			<p style=" font-weight:bold">
	                 很抱歉当前系统暂不支持<span style="color: red;"><%=browserOS%></span>访问，移动设备请使用E-Mobile访问！
            </p>
			
		 <%}else if(labelid==3){
			 String browserOS=Util.null2String(request.getParameter("browserOS"));
			 String browserName=Util.null2String(request.getParameter("browserName"));
		 %>
		     <p style=" font-weight:bold">
	                 很抱歉当前系统暂不支持<span style="color: red;"><%=browserOS%>系统下<%=browserName%>浏览器</span>访问，请使用IE或chrome访问！
             </p>
		 <%}else if(labelid==4){%>
		     <object name="AXDemo" id="AXDemo" height="0" width="0"  classid="clsid:B248518D-6707-4710-BE96-7063C501A9F4" codebase="/weaverplugin/DownloadFilePrj.ocx"></object>
			 <p id="msg" style="font-weight:bold">
	               您当前的浏览器是IE浏览器版本过低，请升级IE至<span style="color: red;">IE8</span>以上，或者使用其他浏览器！<br>
             </p>
             <script type="text/javascript">
              if(confirm("您的IE版本低于IE8,只有IE8及以上版本可以访问,是否安装IE8?")){   
                   jQuery("#msg").html("请稍等，正在下载IE8，请勿关闭窗口");
                   try{ 
			           AXDemo.DownloadFileByUrl('<%=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()%>/weaverplugin/IE8-WindowsXP-x86-CHS.exe'); //下载IE8 
			           jQuery("#msg").html("请稍等，操作系统正在安装IE8，安装成功之后，请重启操作系统后访问。"); 
			       }catch(e){
			           jQuery("#msg").html('您当前的浏览器是IE浏览器版本过低，请升级IE至<span style="color: red;">IE8</span>以上，或者使用其他浏览器！<br>'); 
			           alert("请先安装提示信息中Activex控件后再访问该页面"); 
			       }
		      }
            </script>
          <%}else if(labelid==5){%>
			 <p id="msg" style="font-weight:bold">
	               您当前的浏览器没有安装offic多浏览器插件，请安装插件后在非IE上进行文档操作！
	             <a href="/weaverplugin/iWebPlugin.exe">插件下载</a><br>
             </p>
		 <%}else{%>
		
			<p style=" font-weight:bold">
					很抱歉，当前浏览器暂不支持"<span style="color: red;"><%=msg%></span>"！
			</p>
			<p>
			  <%if(labelid==27889||labelid==27890){%><!-- 主题不支持提醒 -->
				请使用IE8或IE8以上版本访问。或者跳转到<a href="/wui/theme/ecology7/page/skinSetting.jsp?skin=default&theme=ecologyBasic">EcologyBasic主题</a>
			  <%}else{%>
			    1、请使用IE8或IE8以上版本访问。<br>
				不支持原因：由于此功能依赖于IE浏览器的Activex， 
				我们正在努力的寻求解决方案，使其能在多浏览器下运行，给您造成的不便敬请谅解！
			  <%}%>	
			 </p>  
		<%}%>	 
		<p>
			如有疑问请联系系统管理员。</p>
		</div>
    </div>
    
</div>
</body>
</html>    
  
