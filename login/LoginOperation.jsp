<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.*,weaver.general.*,weaver.systeminfo.*" %>
<%@page import="weaver.hrm.settings.RemindSettings"%>
<%@page import="weaver.hrm.settings.BirthdayReminder"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="weaver.login.CheckIpNetWork"%>

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
String method=Util.null2String(request.getParameter("method"));

RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
if(settings==null){
    BirthdayReminder birth_reminder = new BirthdayReminder();
    settings=birth_reminder.getRemindSettings();
    if(settings==null){
        out.println("Cann't create connetion to database,please check your database.");
        return;
    }
    application.setAttribute("hrmsettings",settings);
}

if("add".equals(method)) {
	Thread threadSysUpgrade = null;
	threadSysUpgrade = (Thread)weaver.general.InitServer.getThreadPool().get(0);
	int filePercent = 0;
	int currentFile = 0, fileList = 0;
	if(threadSysUpgrade.isAlive()){
		currentFile = weaver.system.SystemUpgrade.getCurrentFile();
		fileList = weaver.system.SystemUpgrade.getFileList();

		if(currentFile!=0 && fileList!=0){
			double mins = MathUtil.div(currentFile*100,fileList,2);
			out.println(","+mins+",");
		}else{
			out.println(",0,");
		}
	}else{
		out.println(",0,");
	}
}else if("checkTokenKey".equals(method)){
	String loginid=URLDecoder.decode(request.getParameter("loginid"),"utf-8"); 
	String sysNeedusb=Util.null2String(settings.getNeedusb());
	String usbType =Util.null2String(settings.getUsbType());
	String userNeedusb="0";
	String userUsbType="";
	String tokenkey="";
	String id="0";
	RecordSet recordSet=new RecordSet();
	recordSet.execute("select id,needusb,userUsbType,tokenkey from hrmresource where loginid='"+loginid+"'");
	
	if(recordSet.next()){
		id=recordSet.getString("id");
	    userNeedusb=recordSet.getString("needusb");
	    userUsbType=recordSet.getString("userUsbType");
	    tokenkey=recordSet.getString("tokenkey");
	}   
	
	if(userUsbType.equals(""))
		userUsbType=usbType;    
	
	/**检测是否启用usb网段策略开始**/
	CheckIpNetWork checkipnetwork = new CheckIpNetWork();
	String clientIP = request.getRemoteAddr();
	boolean checktmp = checkipnetwork.checkIpSeg(clientIP);//true表示在网段之外,false表示在网段之内
	/**检测是否启用usb网段策略结束**/
	
	if(sysNeedusb.equals("1")&&userNeedusb.equals("1")&&checktmp){
		if(userUsbType.equals("3")){
			String sql="select * from tokenJscx WHERE tokenKey='"+tokenkey+"'";
			recordSet.execute(sql);
			if(tokenkey.equals("")||!recordSet.next()) //令牌未绑定或者未初始化
				out.print("0");  
			else
				out.print(userUsbType);
		}else
		   out.print(userUsbType);
	}else
		out.print("0");
	
}else if("checkIsBind".equals(method)){
	
	String userid=Util.null2String(request.getParameter("userid"));
	String requestFrom=Util.null2String(request.getParameter("requestFrom"));
	String loginid=Util.null2String(request.getParameter("loginid"));
	String tokenKey=Util.null2String(request.getParameter("tokenKey"));
	
	String sysNeedusb=Util.null2String(settings.getNeedusb());
	String usbType =Util.null2String(settings.getUsbType());
	String userNeedusb="0";
	String userUsbType="";
	String tempUserid="0";
	if(sysNeedusb.equals("1")){
	RecordSet recordSet=new RecordSet();
	if(!requestFrom.equals("system")){ //检查用户是否启用usbkey
		recordSet.execute("select id,loginid,needusb,userUsbType from hrmresource WHERE loginid='"+loginid+"'");
		if(recordSet.next()){
			userNeedusb=Util.null2String(recordSet.getString("needusb"));
			userUsbType=Util.null2String(recordSet.getString("userUsbType"));
		}
	}else{
		userNeedusb="1";
		userUsbType="3";
	}
	if(userNeedusb.equals("1")&&userUsbType.equals("3")){
	//检查令牌是否已经绑定过
	boolean isBind=false; //是否绑定过
	String stauts="";     //被绑定人状态
	String tempLoginid="";//被绑定人id
	String sql="select * from tokenJscx  WHERE tokenKey='"+tokenKey+"'";
	recordSet.execute(sql);
	if(recordSet.next()){
		isBind=true;
		//查询当前串号被绑定的用户
		sql="select id,loginid,needusb,status from hrmresource where tokenKey='"+tokenKey+"'";
		recordSet.execute(sql);
		if(recordSet.next()){
			tempUserid=recordSet.getString("id");
			stauts=recordSet.getString("status");
			tempLoginid=recordSet.getString("loginid");
		}
	}
	if(requestFrom.equals("system"))
	    sql="select id,loginid,needusb,status,tokenKey from hrmresource WHERE id="+userid; //检查当前用户是否已经绑定过
	else
		sql="select id,loginid,needusb,status,tokenKey from hrmresource WHERE loginid='"+loginid; //检查当前用户是否已经绑定过
		
	recordSet.execute(sql);	
	String bindTokenkey=Util.null2String(recordSet.getString("tokenKey"));
	
	if(isBind){
		if((!requestFrom.equals("system")&&loginid.equals(tempLoginid))||(requestFrom.equals("system")&&userid.equals(tempUserid)))
			out.print("0");//被绑定人和当前用户是同一个人
		else{
			if(stauts.equals("0")||stauts.equals("1")||stauts.equals("2")||stauts.equals("3")){
				out.print("1"); //被绑定的用户属于正常状态用户,不能再绑定给其他用户
			}else{
				if(!bindTokenkey.equals("")){
					out.print("5"); //当前用户已经绑定过，但需要提醒用户确认令牌串号
				}else
				    out.print("2"); //令牌已经被激活，更改用户需要验证令牌口令
			}
		}
	}else{
        if(bindTokenkey.equals(tokenKey))
        	out.print("7"); //令牌已经绑定给用户但还未初始化
        else if(bindTokenkey.equals(""))
        	out.print("3"); //当前令牌还未绑定过
        else
        	out.print("4"); //当前用户已经绑定过，但需要提醒用户确认令牌串号
	}
	}else
		out.print("6"); //用户未启用usbkey验证，则不需要进行绑定
  }else 
	  out.print("6"); //系统未启用usbkey验证，则不需要进行绑定
}else if("checkIsUsed".equals(method)){ //检查令牌是否绑定给其他用户
   String tokenKey=Util.null2String(request.getParameter("tokenKey"));
   String userid=Util.null2String(request.getParameter("userid"));
   String sql="select id,lastname from hrmresource where id <>+"+userid+" and tokenkey='"+tokenKey+"' and status in(0,1,2,3)";
   RecordSet recordSet=new RecordSet();
   recordSet.execute(sql);
   String result="";
   if(recordSet.next()){  //令牌已经被使用
	   String lastname=recordSet.getString("lastname");
	   result="{status:\"1\",lastname:\""+lastname+"\"}";
   }else{
	   result="{status:\"0\",lastname:\"\"}";
   }
   out.println(result);
}
%>