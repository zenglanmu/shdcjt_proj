<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@page import="weaver.general.Util"%>
<%@page import="weaver.email.domain.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<html xmlns="http://www.w3.org/1999/xhtml">

<%@ page language="java" contentType="text/html; charset=GBK" %> 
<jsp:useBean id="mss" class="weaver.email.service.MailSettingService" scope="page" />
<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" scope="page" />
<jsp:useBean id="mas" class="weaver.email.service.MailAccountService" scope="page" />
<jsp:useBean id="mfs" class="weaver.email.service.MailFolderService" scope="page" />
<jsp:useBean id="lms" class="weaver.email.service.LabelManagerService" scope="page" />
<jsp:useBean id="fms" class="weaver.email.service.FolderManagerService" scope="page" />
<title>sample</title>
<style type="text/css"  >
html, body { 
	width : 100%;
	height : 100%;
	padding : 0; 
	margin : 0px; 
	padding:0px;'
	overflow : hidden;
	font-family:"Lucida Grande","Lucida Sans Unicode",Arial,Verdana,sans-serif; /* MAIN BODY FONTS */
}
.jcTab { width:100%; height:100%;}



.layout-panel{
	
}
.centerDiv{
	overflow:hidden!important;
}
</style>
<!-- link href="css/core.css" rel="stylesheet" type="text/css"/ -->
<link href="/email/css/TabPanel.css" rel="stylesheet" type="text/css"/>
<link href="/email/js/easyui/themes/default/layout.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript">
var  tempuserid ='';
</script>

<script type="text/javascript" src="/email/js/wdScrollTab/Fader.js"></script>
<script type="text/javascript" src="/email/js/wdScrollTab/TabPanel.js"></script>
<script type="text/javascript" src="/email/js/wdScrollTab/Math.uuid.js"></script>
<script type="text/javascript" src="/email/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="/email/js/resize/jquery.resize.min.js"></script>


		
		
<%


	String receivemail = Util.null2String(request.getParameter("receivemail"));
	String receivemailid = Util.null2String(request.getParameter("receivemailid"));
	String subject = Util.null2String(request.getParameter("subject"));
	String folderid = Util.null2String(request.getParameter("folderid"));
	String labelid = Util.null2String(request.getParameter("labelid"));
	String star = Util.null2String(request.getParameter("star"));
	String method = Util.null2String(request.getParameter("method"));
	String mailaccountid = Util.null2String(request.getParameter("mailaccountid"));
	String status = Util.null2String(request.getParameter("status"));
	String from = Util.null2String(request.getParameter("from"));
	String to = Util.null2String(request.getParameter("to"));
	String attachmentnumber = Util.null2String(request.getParameter("attachmentnumber"));
	int isInternal = Util.getIntValue(request.getParameter("isInternal"),-1);
	String startdate = Util.null2String(request.getParameter("startdate"));
	String enddate = Util.null2String(request.getParameter("enddate"));
	//clickObj=0点击是“全部",=1点击的是"未读",=2点击的是某个标签,=""不是点击【全部，未读，标签】进行搜索
	String clickObj=Util.null2String(request.getParameter("clickObj"));
	//1表示标签是在页面点击出来的，而不是通过超链接点击出来的
	String labelidchecked=Util.null2String(request.getParameter("labelidchecked"));
	//封装搜索条件对象
	MailSearchDomain msd = new MailSearchDomain();
	msd.setSubject(subject);
	msd.setFrom(from);
	msd.setTo(to);
	msd.setAttachmentnumber(attachmentnumber);
	msd.setMailaccountid(mailaccountid);
	msd.setStartdate(startdate);
	msd.setEnddate(enddate);
	msd.setStatus(status);
	
	mss.selectMailSetting(user.getUID());
	int userLayout = Util.getIntValue(mss.getLayout(),0);
	
	String url="/email/new/MailInboxList.jsp";
		 if(userLayout==3){
		 	//如果是3，通过url传中文有乱码，所以通过作用域来传递
		 	 String newurl="";
		 	 newurl+=""+isInternal;
			 newurl+="@"+receivemailid;
			 newurl+="@"+star;
			 newurl+="@"+labelid;
			 newurl+="@"+folderid;
			 newurl+="@"+receivemail;
			 newurl+="@"+subject;
			 newurl+="@"+from;
			 newurl+="@"+to;
			 newurl+="@"+status;
			 newurl+="@"+mailaccountid;
			 newurl+="@"+attachmentnumber;
			 newurl+="@"+startdate;
			 newurl+="@"+enddate;
			 newurl+="@"+labelidchecked;
			 //这后面加一个空字符串，非常重要
			//不然这个字符串【-1@@@@0@@会员@@@1@@@@@1】,以@分割转为数组的长度只有10
			 newurl+="@"+clickObj+" ";
			 session.setAttribute("newEmailurl",newurl);
		 }else{
			 url+="?isInternal="+isInternal;
			 url+="&receivemailid="+receivemailid;
			 url+="&star="+star;
			 url+="&labelid="+labelid;
			 url+="&folderid="+folderid;
			 url+="&receivemail="+receivemail;
			 url+="&subject="+subject;
			 url+="&from="+from;
			 url+="&to="+to;
			 url+="&status="+status;
			 url+="&mailaccountid="+mailaccountid;
			 url+="&attachmentnumber="+attachmentnumber;
			 url+="&startdate="+startdate;
			 url+="&enddate="+enddate;
			 url+="&labelidchecked="+labelidchecked;
			 url+="&clickObj="+clickObj;
	}	 
		//?isInternal="+isInternal+"&receivemailid="+receivemailid+"&star="+star+"&labelid="+labelid+"&folderid="+folderid+"&receivemail="+receivemail
		
	
	String displayName ="";
	if(!folderid.equals("")){
		displayName = mfs.getSysFolderName(Util.getIntValue(folderid),user.getLanguage());
		if(displayName.equals("")){
			mfs.selectMailFolderInfo(Util.getIntValue(folderid));
			if(mfs.next()){
				displayName = mfs.getFolderName();
			}
		}
	}else if(!labelid.equals("")){
		displayName = lms.getLabelInfo(labelid).getName();
	}else if(isInternal==1){
		displayName =  SystemEnv.getHtmlLabelName(24714,user.getLanguage());
	}else{
		displayName = SystemEnv.getHtmlLabelName(81337,user.getLanguage());
	}
	
	//用于列表切换的tab的id叫:MailChangeList
	String MailChangeList="MailChangeList";
	//用于新建、发送、回复邮件的id叫：MailChangeUpdae
	String MailChangeUpdae="MailChangeUpdae";
	String url02=mrs.getLatestEmailViewUrl(folderid,star,labelid,user.getUID(),msd);
	//MailView.jsp?isInternal==isInternal &star==star&folderid==folderid&receivemail==receivemail&mailid=mailid 
 %>
 <%
 //上下
 if(userLayout==1){
  %>
	  <script type="text/javascript">
	var languageid = '<%=user.getLanguage()%>'
	</script>
  <script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog.js" charset="GBK"></script>
  <script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag.js" ></script> 
  <script language="javascript" defer="defer" src="/js/datetime.js"></script>
 <script language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<script type="text/javascript" src="/js/messagejs/highslide/highslide-full.js"></script>
	<script type="text/javascript" src="/js/messagejs/simplehrm.js"></script>
	<script type="text/javascript" src="/js/messagejs/messagejs.js"></script>
  <div class="easyui-layout" style="width: 100%;height: 100%;">
 	<div class="northDiv" data-options="region:'north',split:true"  style="overflow:hidden"></div>  
    <div class="centerDiv " data-options="region:'center',title:'center title'"  style="overflow:hidden"></div>  
</div>
<!--  <frameset rows="40%,60%" border="1">
	<frame src="/email/new/MailInboxList.jsp?isInternal=<%=isInternal %>&receivemailid=<%=receivemailid %>&star=<%=star %>&labelid=<%=labelid %>&folderid=<%=folderid%>&receivemail=<%=receivemail%>" name="mailInboxLeft" />
	<frame src="<%=url02 %>" name="mailInboxRight" id="mailInboxRight" style="border-top:3px solid #B3B3B3" />
</frameset>
 -->
 <%
 //左右
 }else if(userLayout==2){
  %>
	  <script type="text/javascript">
	var languageid = '<%=user.getLanguage()%>'
	</script>
    <script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog.js" charset="GBK"></script>
	<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag.js" ></script> 
	<script language="javascript" defer="defer" src="/js/datetime.js"></script>
	<script language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
	<script type="text/javascript" src="/js/messagejs/highslide/highslide-full.js"></script>
	<script type="text/javascript" src="/js/messagejs/simplehrm.js"></script>
	<script type="text/javascript" src="/js/messagejs/messagejs.js"></script>
  <div class="easyui-layout" style="width: 100%;height: 100%;">
 	<div class="northDiv" data-options="region:'west',split:true" style="height:100%;"></div>  
    <div class="centerDiv " data-options="region:'center',title:'center title'" style="height: 60%;"></div>  
</div>
<!-- 
<frameset cols="45%,55%" border="1">
	<frame src="MailInboxList.jsp?isInternal=<%=isInternal %>&receivemailid=<%=receivemailid %>&star=<%=star %>&labelid=<%=labelid %>&folderid=<%=folderid%>&receivemail=<%=receivemail%>" name="mailInboxLeft" />
	<frame src="<%=url02 %>" name="mailInboxRight" id="mailInboxRight" style="border-left:3px solid #B3B3B3" />
</frameset>

 -->
 <%
 }else{
 	//request.getRequestDispatcher(url).forward(request, response);
	 response.sendRedirect(url);
	 return;
 }
  %>
</body>
<script>
	$(document).ready(function(){
		var init = true;
		$(".northDiv").resize(function(){
			if(init){
				if(userLayout=="2"){
					$(".northDiv").find("#mailList").css("height",document.body.clientHeight-$("#mailListTop").height()-1);
					$("#mailContent").css("height",document.body.clientHeight-130);
				}else{
					$(".northDiv").find("#mailList").css("height",document.body.clientHeight/2-$("#mailListTop").height());
					$("#mailContent").css("height",document.body.clientHeight/2-130);
				}
			}else{
				if(userLayout=="2"){
					$(".northDiv").find("#mailList").css("height",$(".northDiv").height()-$("#mailListTop").height()-1);
					$("#mailContent").css("height",document.body.clientHeight-130);
					$("#mailContent").css("width",$(".centerDiv").width())
				}else{
					$(".northDiv").find("#mailList").css("height",$(".northDiv").height()-$("#mailListTop").height());
					$("#mailContent").css("height",$(".centerDiv").height()-130);
					$("#mailContent").css("width",$(".centerDiv").width())
				}
			}
			init = false;
			
			
		});
		
		var userLayout = "<%=userLayout%>";
		$(".northDiv").load("<%=url%>&"+new Date().getTime(),function(data){
			
			if(userLayout=="2"){
				$(".northDiv").css("width",document.body.clientWidth/2+"px")
				$(".northDiv").parent().css("width",document.body.clientWidth/2+"px")
			
				$(".layout-panel-center").css("left",document.body.clientWidth/2+"px")
			}else if(userLayout=="1"){
				
				$(".northDiv").css("height",document.body.clientHeight/2+"px")
				$(".northDiv").css("width","100%")
				$(".layout-panel-center").css("top",document.body.clientHeight/2+"px")
				$(".layout-panel-center").css("width","100%")
			}
		});
		 $(".centerDiv").load("<%=url02 %>&"+new Date().getTime(),function(){
			if(userLayout=="2"){
				$(".centerDiv").parent().css("width",document.body.clientWidth/2+"px")
				$(".centerDiv").css("width",document.body.clientWidth/2+"px")
				$(".centerDiv").parent().css("height","100%")
				$(".centerDiv").css("height","100%")
			}else if(userLayout=="1"){
				$(".centerDiv").parent().css("height",document.body.clientHeight/2+"px")
				$(".centerDiv").css("height",document.body.clientHeight/2+"px")
				$(".centerDiv").parent().css("width","100%")
				$(".centerDiv").css("width","100%")
			}
		}); 
	})

</script>
</html>
