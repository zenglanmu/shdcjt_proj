<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.login.TokenJSCX"%>
<%@page import="weaver.hrm.settings.RemindSettings"%>
<%@page import="weaver.hrm.settings.BirthdayReminder"%>
<%@page import="weaver.general.GCONST"%>
<%@page import="weaver.file.Prop"%>
<%
 String tokenKey=Util.null2String(request.getParameter("tokenKey"));
 String tokenKeyCode1=Util.null2String(request.getParameter("tokenKeyCode1"));
 String tokenKeyCode2=Util.null2String(request.getParameter("tokenKeyCode2"));
 
 String flag="";
 String message="";
 if(!tokenKey.equals("")&&!tokenKeyCode1.equals("")&&!tokenKeyCode2.equals("")){
	 TokenJSCX tokenJSCX=new TokenJSCX();
	 flag=tokenJSCX.syncTokenKey(tokenKey,tokenKeyCode1,tokenKeyCode2);
 }
 
 if(flag.equals("1"))
	 message="令牌序列号不存在或没有绑定"; 
 else if(flag.equals("2"))
	 message="动态令牌同步失败，请再次同步，确保两个口令是连续的，<br>如果多次失败令牌可能永久失效，如果失效请联系系统管理员";
%>
<html>
  <head>
    <title>令牌同步</title>
    <script type="text/javascript" src="/wui/common/jquery/jquery.js"></script>
    <link type='text/css' rel='stylesheet'  href='/css/weaver.css'/>
    <link type='text/css' rel='stylesheet'  href='/wui/theme/ecology7/skins/default/wui.css'/>
    <script type="text/javascript">
	    $(document).ready(function () {
	    	var pTop= document.body.offsetHeight/2 + document.body.scrollTop - 154;
	        var pLeft= document.body.offsetWidth/2 - 50;
	        $("#messageArea").css("top", pTop);
	    });
	    function dosave(obj){
	       var tokenKey=jQuery("#tokenKey");
	       var tokenKeyCode1=jQuery("#tokenKeyCode1");
	       var tokenKeyCode2=jQuery("#tokenKeyCode2");
	       
           if(tokenKey.val()==""){
              alert("请输入令牌序列号！");
              tokenKey.focus();
              return ;
           }else if(!isdigit(tokenKey.val())||tokenKey.val().length!=10){
              alert("令牌序列号必须为10位数字！");
              tokenKey.focus();
              return ;
           }	
           
           var tokenType="";
           var startNumber=tokenKey.val().substr(0,1);
           if(startNumber=="1"){      //动联1代
               tokenType="5";
           }else{
               alert("令牌序列号不正确，请确认后输入");
               tokenKey.focus();
               return ;
           }
           
           if(tokenKeyCode1.val()==""){
              alert("请输入动态口令1！");
              tokenKeyCode1.focus();
              return ;
           }else if(tokenKeyCode1.val().length!=6||!isdigit(tokenKeyCode1.val())){
               alert("动态口令1必须为6位数字");   
               tokenKeyCode1.focus();
               return ;
           } 
           
           if(tokenKeyCode2.val()==""){
              alert("请输入动态口令2！");
              tokenKeyCode2.focus();
              return ;
           }else if(tokenKeyCode2.val().length!=6||!isdigit(tokenKeyCode2.val())){
              alert("动态口令2必须为6位数字");   
              tokenKeyCode2.focus();
              return ;
           }
           
           if(tokenKeyCode1.val()==tokenKeyCode2.val()){
              alert("动态口令1与动态口令2不能相同");
              return ;
           }
           jQuery("#weaver").submit();
	    }
	    
	    function isdigit(s){
			var r,re;
			re = /\d*/i; //\d表示数字,*表示匹配多个数字
			r = s.match(re);
			return (r==s)?true:false;
		}
    </script>
    <style>
      body{font-size:12px;}
    </style>
  </head>
<body style="margin:0px;padding:0px;background-color: rgb(241, 241, 241);">
<form name="weaver" id="weaver" action="syncTokenKey.jsp" method="post">
<div style="width: 100%;position:absolute;" align="center" id="messageArea">
    <div style="width: 582px;height:309px;font-size:12px;background:url(/wui/common/page/images/error.png) no-repeat;text-align:left;position: relative;" align="center">
	    <div style="height:45px;clear: both;">
	         <div style="padding-left: 15px;padding-top:25px;font-size:16px;"><span style="font-weight: bold;">动态令牌同步</span>
	         <span style="font-size: 12px;color: red">(提示：两次令牌口令必须连续，第1个口令变动后输入第2个)</span></div>
	    </div>
    <div>
    <div style="float:left; ">
    	<div style=" height:128px; width:123px;background: url(/wui/common/page/images/error_left.png); margin-top:20px;margin-left:40px!important; margin-left:20px"></div>
    </div>
	<div style=" height:120px; border-left:solid 1px #e3e3e3; margin:20px; float:left; margin-left:40px;margin-top:20px"></div>
		<div style="height:260px; width:320px; float:left;margin-top:10px; line-height:25px;">
		   <%if(flag.equals("")||flag.equals("1")||flag.equals("2")){%>
		   <table style="margin-top: 15px;width: 100%;font-size:12px;">
		       <tr>
		           <td width="75px">令牌序列号</td>
		           <td><input type="text" name="tokenKey" id="tokenKey" style="width: 150px;" maxlength="10">&nbsp;背面10位数字</td>
		       </tr>
		       <tr>
		           <td>动态口令1</td>
		           <td><input type="text" name="tokenKeyCode1" id="tokenKeyCode1" style="width: 150px;" maxlength="6">&nbsp;正面6位数字</td>
		       </tr>
		       <tr>
		           <td>动态口令2</td>
		           <td><input type="text" name="tokenKeyCode2" id="tokenKeyCode2" style="width: 150px;" maxlength="6">&nbsp;正面6位数字</td>
		       </tr>
		       <tr>
			       <td colspan="2">
			          <span style="color: red;"><%=message%></span>
			       </td>
			   </tr>
		       <tr>
			       <td colspan="2" align="center" style="padding-top: 5px;">
			         <input type="button" value="同步" onclick="dosave(this)">&nbsp;
			         <input type="reset" value="重置">
			      </td>
			   </tr>
		   </table>
		   <%}else{%>
		       <div style="margin-top: 45px;font-size: 15px;">
		         <span style="color: red;">令牌同步成功！</span><br>
		          请在令牌口令变化后&nbsp;<a href="/login/Login.jsp" style="font-weight: bold;font-size: 14px;">登录</a>系统，避免使用本次验证口令
		      </div>
		   <%}%>
	    </div>
	    </div>
    </div>
    
</div>
</form>
</body>
</html>    
  
