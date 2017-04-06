<%@page import="weaver.email.service.MailGuideService"%>
<%@ page language="java" contentType="text/html; charset=gbk" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="mss" class="weaver.email.service.MailSettingService" scope="page" />
<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" scope="page" />
<jsp:useBean id="mas" class="weaver.email.service.MailAccountService" scope="page" />
<jsp:useBean id="mfs" class="weaver.email.service.MailFolderService" scope="page" />
<jsp:useBean id="lms" class="weaver.email.service.LabelManagerService" scope="page" />
<jsp:useBean id="fms" class="weaver.email.service.FolderManagerService" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<script type="text/javascript" src="/email/js/wdScrollTab/Fader.js"></script>
<script type="text/javascript" src="/email/js/wdScrollTab/TabPanel.js"></script>
<script type="text/javascript" src="/email/js/wdScrollTab/Math.uuid.js"></script>
<script type="text/javascript" src="/email/joyride/jquery.cookie.js"></script>
<script type="text/javascript" src="/email/joyride/modernizr.mq.js"></script>
<script type="text/javascript" src="/email/joyride/jquery.joyride-1.0.5.js"></script>
<link rel="stylesheet" href="/email/joyride/joyride-1.0.5.css">
<link rel="stylesheet" href="/email/joyride/demo-style.css">
<link rel="stylesheet" href="/email/joyride/mobile.css">
<link href="/email/css/TabPanel.css" rel="stylesheet" type="text/css"/>
<link href="/email/css/base.css" rel="stylesheet" type="text/css"/>

<%
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragrma","no-cache");
response.setDateHeader("Expires",0);

String receivemail = Util.null2String(request.getParameter("receivemail"));

String receivemailid = Util.null2String(request.getParameter("receivemailid"));
mss.selectMailSetting(user.getUID());

int userLayout = Util.getIntValue(mss.getLayout(),3);



String labelid =Util.null2String(request.getParameter("labelid"));
String star =Util.null2String(request.getParameter("star"));
int isInternal = Util.getIntValue(request.getParameter("isInternal"),-1);
String folderid = Util.null2String(request.getParameter("folderid"));
String opNewEmail=Util.null2String(request.getParameter("opNewEmail"));
String mailid = Util.null2String(request.getParameter("mailid"));
String status = Util.null2String(request.getParameter("status"));
//clickObj=0点击是“全部",=1点击的是"未读",=2点击的是某个标签,=""不是点击【全部，未读，标签】进行搜索
String clickObj=Util.null2String(request.getParameter("clickObj"));
//布局信息
mss.selectMailSetting(user.getUID());
int layout = Util.getIntValue(mss.getLayout(),3);
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
}else {
	displayName = SystemEnv.getHtmlLabelName(81337,user.getLanguage());
}
boolean checkuser=MailGuideService.checkUserSeeGuide(user.getUID()+"");
if(!checkuser){
	MailGuideService.insertEmailGuide(user.getUID()+"");
}	
//用于列表切换的tab的id叫:MailChangeList
String MailChangeList="MailChangeList";
//用于新建、发送、回复邮件的id叫：MailChangeUpdae
String MailChangeUpdae="MailChangeUpdae";
String   url="";
if(userLayout==1){
	 url="/email/new/MailInboxListMain.jsp";
}else if(userLayout==2){
	 url="/email/new/MailInboxListMain.jsp";
}else{
	url="/email/new/MailInboxList.jsp";
}
 url+="?isInternal="+isInternal;
 url+="&receivemailid="+receivemailid;
 url+="&star="+star;
 url+="&labelid="+labelid;
 url+="&folderid="+folderid;
 url+="&receivemail="+receivemail;
 url+="&status="+status;
 url+="&clickObj="+clickObj;
 url+="&checkuser="+checkuser+"";
 if(!mailid.equals("")){
	 url = "/email/new/MailView.jsp?mailid="+mailid;
 }

%>

</head>
<style>
			.userLayout1{
					position: absolute;
					z-index: 999;
					right: 10px;top:10px; 
					background-repeat: no-repeat; 		
					background:url("/email/images/sxlayout.png");
			}
			.userLayout2{
					position: absolute;
					z-index: 999;
					right: 10px;top:10px; 
					background-repeat: no-repeat; 
					background:url("/email/images/zylayout.png");
			}
			.userLayout3{
					position: absolute;
					z-index: 999;
					right: 10px;top:10px; 
					background-repeat: no-repeat; 
					background:url("/email/images/pplayout.png ");
			}
			.guide{
					background:url("/email/joyride/light.png");
					display:block; 
					width:23px;
					height:23px;
					float:right;
					position:absolute;
					margin-left:-30px;
					margin-top:0px;
					background-repeat: no-repeat; 		
			}
			.guide:hover{
					background:url("/email/joyride/lightOver.png");
					display:block; 
					width:23px;
					height:23px;
					float:right;
					position:absolute;
					margin-left:-30px;
					margin-top:0px;
					background-repeat: no-repeat; 		
			}
			
			.hidediv{
					background:url("/email/joyride/light.png");
					width:0px;
					height:0px;
					float:right;
					position:absolute;
					margin-top:50px;
					margin-left:90%;
					background-repeat: no-repeat; 		
			}
			.maskguide{
				top:0px;
				background-color: rgb(0, 0, 0);
				z-index: 9;
				position: absolute;
				width: 100%;
				height: 0px;
				filter:alpha(opacity=30);
				opacity:0.3;
			}
</style>
<body scroll="no">

<div  class="maskguide"  id="maskguide"></div>

		 
<div id="tab" style="position: relative;height: 100%">
		
<%if(mailid.equals("")){ %>
	<!--  
	<div class="hidediv" id="sxjb"></div>
	-->
	<div class="userLayout<%=userLayout%>"  id="changeBk" _xuhao=0>
		<a class=" hand  guide"  href="javascript:showjoy()"  onclick="" id="clickshowjoy"></a>	
		<div class="left hand layout" type="sx" value="1" title="<%=SystemEnv.getHtmlLabelName(19851,user.getLanguage()) %>" style="width:28px;height:22px;">
		</div>
		<div class="left hand layout" type="zy" value="2" title="<%=SystemEnv.getHtmlLabelName(20825,user.getLanguage()) %>" style="width:28px;height:22px;">
		</div>
		<div class="left hand layout" type="pp" value="3" title="<%=SystemEnv.getHtmlLabelName(19852,user.getLanguage()) %>" style="width:28px;height:22px;">
		</div>
	</div>
	
<%} %>

</div>


 <!-- 缓存当前切换的url -->
 <input type="hidden" id="comurl" value="<%=url%>"/>
 
  <!-- 缓存当前切换的css-->
 <input type="hidden" id="comcss" value="<%=layout%>"/>




<ol id="joyRideTipContent">
<li data-id="changeBk" data-text="下一个" class="custom">
<span>视图切换</span>
<p></p>
<p>您可以在这里快速切换邮件阅读版式</p>
</li>
</ol>



<script type="text/javascript" >
var userLayout="<%=userLayout%>";
var checkuser="<%=checkuser%>";
var tabpanel;  

var jcTabs = [
'<iframe src="<%=url%>" width="100%" height="100%" frameborder="0" id="mainConEmail" ></iframe>'
];
var tempid=1;


$(document).ready(function(){  
	if(userLayout=="3"&&checkuser=="false"){
		//$("#maskguide").height("47px");
		$(this).joyride({"postStepCallback":nextWizard,"postRideCallback":finishALL,"inline":"true"});
	}
	if(userLayout=="1"||userLayout=="2"){
		$("#clickshowjoy").hide();
	}else{
		$("#clickshowjoy").show();
	}
	$(".layout").click(function(){
		var tempjie=$(this).attr("value");
		if($(this).attr("value")==$("#comcss").val()){
			return;
		}else{
			
			$.post("/email/new/MailManageOperation.jsp",{operation:"editLayout",layout:$(this).attr("value")},function(){
				//刷新树菜单的布局的值
				try{
							window.parent.changeUserLayout(tempjie);
							var url="";
							if(tempjie=="1"||tempjie=="2"){
									url=$("#comurl").val().replace("MailInboxList.jsp","MailInboxListMain.jsp");
									$("#clickshowjoy").hide();
									//alert("1-2"+url);
							}else{
									url=$("#comurl").val().replace("MailInboxListMain.jsp","MailInboxList.jsp");
									$("#clickshowjoy").show();
									//alert("3"+url);
							}
							$("#changeBk").removeClass("userLayout1");
							$("#changeBk").removeClass("userLayout2");
							$("#changeBk").removeClass("userLayout3");
							//设置为缓存的css
							$("#comcss").val(tempjie);
							$("#changeBk").addClass("userLayout"+tempjie);
							//document.location.reload();
							//切换到缓存的url
							document.getElementById("mainConEmail").src=url;
					
				}catch(e){
						//说明是老版的模式查看
						window.parent.document.getElementById("LeftMenuFrame").contentWindow.document.getElementById("ifrm2").contentWindow.changeUserLayout(tempjie);	
					 		var url="";
							if(tempjie=="1"||tempjie=="2"){
									url=$("#comurl").val().replace("MailInboxList.jsp","MailInboxListMain.jsp");
									$("#clickshowjoy").hide();
									//alert("1-2"+url);
							}else{
									url=$("#comurl").val().replace("MailInboxListMain.jsp","MailInboxList.jsp");
									$("#clickshowjoy").show();
									//alert("3"+url);
							}
							//addClass
							$("#changeBk").removeClass("userLayout1");
							$("#changeBk").removeClass("userLayout2");
							$("#changeBk").removeClass("userLayout3");
							//设置为缓存的css
							$("#comcss").val(tempjie);
							$("#changeBk").addClass("userLayout"+tempjie);
							//document.location.reload();
							//切换到缓存的url
							document.getElementById("mainConEmail").src=url;
			
				}
			})
			
		
		}
	})
	
    tabpanel = new TabPanel({  
        renderTo:'tab',  
        //border:'none',  
        active : 0,
        //maxLength : 10,  
        items : [
          		  {id:'<%=MailChangeList%>',title:'<%=displayName%>',html:jcTabs[0],closable: false}
        ]
    }); 
    
	<%
		if(opNewEmail.equals("1")){
	%>
			addTab("1","/email/new/MailAdd.jsp?isInternal=<%=isInternal%>","<%=SystemEnv.getHtmlLabelName(30912,user.getLanguage()) %>");
			
	<%
		}
	%>
}); 
function showjoy(){
		
		$("#clickshowjoy").attr("href","javascript:void(0)");
		tabpanel.show(0,false);//跳到收件箱界面
		//$("#maskguide").height("0px");
		//$($("#mainConEmail")[0].contentWindow.document).find("#maskguidelist").height("100%");
		$(document).joyride({"postStepCallback":nextWizard,"postRideCallback":finishALL,"inline":"true"});
}
function nextWizard(obj){
	//每次完成后调用的函数
	
}
function finishALL(obj){
	//完成所有项后提示的函数
	if(obj!="#close"&&(typeof(obj) != "undefined")){
		$("#mainConEmail")[0].contentWindow.ShowWizard(); 
	}else{
		$("#clickshowjoy").attr("href","javascript:showjoy()");
	//	$("#maskguide").height("0px");
		//$($("#mainConEmail")[0].contentWindow.document).find("#maskguidelist").height("0px");
	}
	$(".joyride-tip-guide").remove();
	
}

//添加tab页
function addTab(type,url,tabname,mailId){
	
	//这里的id分为li--tab的id,和tab里面内嵌的iframe的id
	var v_mailId="";
	var mainConEmail="";
	if(type=="1"){
		v_mailId="<%=MailChangeUpdae%>";
		mainConEmail="sh_"+v_mailId;
	}else{
		v_mailId=mailId;
		mainConEmail="sh_"+v_mailId;
	}
	var wk=tabpanel.getTabPosision(v_mailId);
	 if(typeof wk == 'number'){
	 			tabpanel.show(wk,false);//设置tab被选中，并且显示
	 			tabpanel.setTitle(wk, tabname);//设置tab的标题
	 			document.getElementById(mainConEmail).src=url;//刷新页面
	 			return;
	 }
	var page="<iframe src='"+url+"' width='100%' height='100%' frameborder='0' id='"+mainConEmail+"'></iframe>";
	tabpanel.addTab({id:v_mailId,title:tabname,html:page,closable: true});
}

//切换tab页
function refreshTab(type,url,tabname){	
			tabpanel.show(0,false);
			$(".active > .title").html(tabname);	
			//缓存切换的url
			$("#comurl").val(url);
			//缓存切换的css
			try{
				$("#comcss").val(window.parent.document.getElementById("menu_userLayout").value);
			}catch(e){
				//说明是经典模式下
				$("#comcss").val(window.parent.document.getElementById("LeftMenuFrame").contentWindow.document.getElementById("ifrm2").contentWindow.document.getElementById("menu_userLayout").value);
			}
			document.getElementById("mainConEmail").src=url;//刷新页面
}

//删除tab页
function deleteTab(v_mailId){	
		if(<%=layout%>==3){
			var wk=tabpanel.getActiveIndex();
			 if(typeof wk == 'number'){
			 			tabpanel.kill(wk);
			 			tabpanel.show(0,false);
			 			//刷新页面，调至收件箱
						document.getElementById("mainConEmail").src="/email/new/MailInboxList.jsp?folderid=0&receivemail=false&"+new Date().getTime();
					/* 	//删除邮件的同时，把回复的界面也删除掉,163的好像没删除
						var wks=tabpanel.getTabPosision("MailChangeUpdae");
						tabpanel.kill(wks); */
			 }	
		 }else{
	 				tabpanel.show(0,false);
		 			//刷新页面，调至收件箱
					document.getElementById("mainConEmail").src="/email/new/MailInboxListMain.jsp?folderid=0&receivemail=false&"+new Date().getTime();
					/* //删除邮件的同时，把回复的界面也删除掉,163的好像没删除,
					var wks=tabpanel.getTabPosision("MailChangeUpdae");
					tabpanel.kill(wks); */
		 }
		 
}
//跳到收件箱或发件箱
function gosjx(type,url,tabname){	
		var wk=tabpanel.getActiveIndex();
		 if(typeof wk == 'number'){
	 			tabpanel.kill(wk);//关闭发送成功或失败的界面
				tabpanel.show(0,false);//跳到收件箱界面
				$(".active > .title").html(tabname);
				document.getElementById("mainConEmail").src=url;//刷新页面
		}
}
</script>


</body>
</html>
