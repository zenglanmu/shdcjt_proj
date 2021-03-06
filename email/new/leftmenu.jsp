<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.email.domain.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="lms" class="weaver.email.service.LabelManagerService" scope="page" />
<jsp:useBean id="fms" class="weaver.email.service.FolderManagerService" scope="page" />
<jsp:useBean id="mas" class="weaver.email.service.MailAccountService" scope="page" />
<jsp:useBean id="mss" class="weaver.email.service.MailSettingService" scope="page" />
<link rel="stylesheet" href="/email/js/jscrollpane/jquery.jscrollpane.css" />
<script type="text/javascript" src="/email/js/jscrollpane/jquery.mousewheel.js"></script>
<script type="text/javascript" src="/email/js/jscrollpane/jquery.jscrollpane.min.js"></script>

<center>
<div class="center" style="width:160px;">

<%
	mss.selectMailSetting(user.getUID());
	int userLayout = Util.getIntValue(mss.getLayout(),0);
 %>
 
<div class=" h-30 center" style="width:160px; background-image: url('/email/images/leftBtnBg.png');margin-left: 0px">
	<table class="w-all h-30">
		<tr>
			<td  class="bold colo333  relative  hand"  align="right" width="50%" style="border-right: 1px solid #96bdc5;">
				
				
				
				
				<div class="left p-l-30  relative hand" id="addMail" target='' style="padding-top: 5px">
					<img class="absolute" style="top:7px;left:5px" src="/email/images/newEmail.png">
					<%=SystemEnv.getHtmlLabelName(81300, user.getLanguage())%>
				</div>
				<div class="left hand" id="addMailsBtn" style="padding-top: 5px;width: 20px;height: 22px;">
					<img class="absolute" style="top:12px;right:5px" src="/email/images/iconDArr.png"/>
				</div>
				
				<div class="clear"></div>
				<ul class="btnGrayDropContent addMailsBtnDown hide " style="width: 160px;left: 0px;top:28px;" >
				
								
					<li class=""  style="font-weight: normal;line-height: 20px;" onclick="addMail(1)" ><%=SystemEnv.getHtmlLabelName(24714,user.getLanguage())%></li>
					<li class=""  style="font-weight: normal;line-height: 20px;" onclick="addMail(0)"><%=SystemEnv.getHtmlLabelName(31139,user.getLanguage())%></li>
								
						
				</ul>
				
				
				
				
				
			</td>
			<td id="" class="bold colo333 lh-30 relative   relative" width="50%">
				<div class="left p-l-30  relative hand" id="receiveMail"  style="padding-top: 5px">
					<img class="absolute" style="top:7px;left:5px" src="/email/images/getEmail.png">
					<%=SystemEnv.getHtmlLabelName(81346, user.getLanguage())%>
				</div>
				<div class="left hand" id="accountsBtn" style="padding-top: 5px;width: 20px;height: 22px;">
					<img class="absolute" style="top:12px;right:5px" src="/email/images/iconDArr.png"/>
				</div>
				
				<div class="clear"></div>
						<ul class="btnGrayDropContent accountsBtnDown hide " style="width: 160px;left: -80px;top:28px;" >
							<%
								mas.clear();
								mas.setUserid(user.getUID()+"");
								mas.selectMailAccount();
								while(mas.next()){
									
											%>
										
											<li class=""  style="font-weight: normal;line-height: 20px;" target="<%=mas.getId()%>" ><%=mas.getAccountname() %></li>
										
									<%
								}
							%>
						</ul>
						
			</td>
		</tr>
	</table>
</div>
<div id="autoHight" class="scroll-pane" style="height: auto;overflow: auto;">
				<div class="p-t-15">
					<div class="h-25  hand" id="inboxBtn">
						<div class="left p-l-15"><img src="/email/images/inbox.png"></div>
						<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(19816, user.getLanguage())%></div>
						<div class="clear"></div>
					</div>
					
					<div class="h-25  hand " id="outboxBtn">
						<div class="left p-l-15"><img src="/email/images/outbox.png"></div>
						<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(19558, user.getLanguage())%></div>
						<div class="clear"></div>
					</div>
					
					<div class="h-25  hand" id="drafboxBtn">
						<div class="left p-l-15"><img src="/email/images/draftbox.png"></div>
						<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(2039, user.getLanguage())%></div>
						<div class="clear"></div>
					</div>
						<div class="h-25  hand" id="delboxBtn">
						<div class="left p-l-15"><img src="/email/images/delbox.png"></div>
						<div class="left color333 p-l-5 title"><%=SystemEnv.getHtmlLabelName(2040, user.getLanguage())%></div>
						<div class="left p-l-15 colorddd hide  hand m-l-10" title="<%=SystemEnv.getHtmlLabelName(15504, user.getLanguage())%>" style="height:16px; background: url(/email/images/clear.png) no-repeat center center ;" id="removeAll"></div>
						<div class="clear"></div>
					</div>
						
					<div class="h-25  hand" id="internal">
						<div class="left p-l-15"><img src="/email/images/internalbox.png"></div>
						<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(24714, user.getLanguage())%></div>
						<div class="clear"></div>
					</div>
						<div class="h-25  hand" id="star">
						<div class="left p-l-15"><img src="/email/images/importantbox.png"></div>
						<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(81337, user.getLanguage())%></div>
						<div class="clear"></div>
					</div>
			</div>
			<div class="line-gray1 m-l-15 m-r-30">&nbsp;</div>
			<div class="p-t-10">
				<div class="h-20  hand" id="mailSetting">
					<div class="left p-l-15"><img src="/email/images/setting.png"></div>
					<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(24751, user.getLanguage())%></div>
					<div class="clear"></div>
				</div>
				
				<div class="h-25  hand" id='contactsBtn'>
					<div class="left p-l-15"><img src="/email/images/contacts.png"></div>
					<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(572, user.getLanguage())%></div>
					<div class="clear"></div>
				</div>
			</div>
			<div class="line-gray1 m-l-15 m-r-30">&nbsp;</div>
			<div class="" >
			<div class="m-t-10">
				<div class="h-25  hand main" id="forder" target="subFolder">
					<div class="left p-l-15"><img src="/email/images/folder.png"></div>
					<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(81348, user.getLanguage())%></div>
					<div class="left p-l-15 colorddd hide  hand m-l-10" title="<%=SystemEnv.getHtmlLabelName(633, user.getLanguage())%>" style="height:16px; background: url(/email/images/manage.png) no-repeat center center ;" id="folderManage"></div>
					<div class="clear"></div>
				</div>
				<div class="p-l-30 hide" id="subFolder">
				<%
						ArrayList<MailFolder> folderList= fms.getFolderManagerList(user.getUID());
							for(int i=0; i<folderList.size();i++){
								MailFolder mf = folderList.get(i);
								%>
								<div class="h-25 subfolder  hand" target="<%=mf.getId()%>">
									<div class="left"><img src="/email/images/subfolder.png"></div>
									<div class="left color333 p-l-5 " title="<%=mf.getFolderName()%>"><%=Util.getMoreStr(mf.getFolderName(),4,"...") %></div>
									<div class="clear"></div>
								</div>
								
								<%
							}
						%>
					
				</div>
			</div>
			<div class="line-gray1 m-l-15 m-r-30">&nbsp;</div>
			<div class="m-t-10"  >
				
				<div class="h-25  hand main" id="tag" target="subTag">
					<div class="left p-l-15"><img src="/email/images/folder.png"></div>
					<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(81349, user.getLanguage())%></div>
					<div class="left p-l-15 colorddd hide  hand m-l-10" title="<%=SystemEnv.getHtmlLabelName(633, user.getLanguage())%>" style="height:16px; background: url(/email/images/manage.png) no-repeat center center ;" id="tagManage"></div>
					<div class="clear"></div>
				</div>
				<div class="p-l-30 hide" id="subTag" >
				<%
						 ArrayList<MailLabel> lmsList= lms.getLabelManagerList(user.getUID());
							for(int i=0; i<lmsList.size();i++){
								MailLabel ml = lmsList.get(i);
								%>
								<div class="h-25 label hand" target="<%=ml.getId()%>">
									<div class="left center p-t-5"><div style="width: 8px; height: 8px; overflow:hidden; background: <%=ml.getColor()%>"></div></div>
									<div class="left color333 p-l-5 " title="<%=ml.getName()%>"><%=Util.getMoreStr(ml.getName(),4,"...") %></div>
									<div class="clear"></div>
								</div>
								<%
							}
				%>
				</div>
			</div>
			
			</div>
</div>
</div>
</center>
<input type="hidden" name="menu_userLayout"  id="menu_userLayout"  value="<%=userLayout%>"/>
<script type="text/javascript">
function changeUserLayout(objvalue){
		//刷新树菜单的布局的值
		jQuery("#menu_userLayout").attr("value",objvalue);
}

jQuery("#addMail").bind("click",function(){
	
	//jQuery("#mainFrame").attr("src","/email/new/MailAdd.jsp");
	//写信
	//jQuery("#mainFrame").attr("src","/email/new/MailInBox.jsp?opNewEmail=1");
	try{
				document.getElementById("mainFrame").contentWindow.addTab("1","/email/new/MailAdd.jsp?isInternal="+$(this).attr("target"),"写信");
	}catch(e){
					//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?opNewEmail=1&folderid=0&isInternal="+$(this).attr("target");
					
	}
	$(this).attr("target","");
})

function addMail(type){
	jQuery("#addMail").attr("target",type).trigger("click");
}

jQuery("#receiveMail").bind("click",function(){
	//收信
	
	//jQuery("#mainFrame").attr("src","/email/new/MailInBox.jsp?folderid=0&receivemail=true&"+new Date().getTime());
	var menu_userLayout=jQuery("#menu_userLayout").val();
	if(menu_userLayout==3){
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("2","/email/new/MailInboxList.jsp?folderid=0&receivemail=true&"+new Date().getTime());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?folderid=0&receivemail=true&"+new Date().getTime();
		}
	}else{
			try{
				document.getElementById("mainFrame").contentWindow.refreshTab("2","/email/new/MailInboxListMain.jsp?folderid=0&receivemail=true&"+new Date().getTime());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?folderid=0&receivemail=true&"+new Date().getTime();
		}
	}
})

jQuery("#contactsBtn").bind("click",function(){
	jQuery("#mainFrame").attr("src","/email/new/Contacts.jsp");
})

jQuery("#inboxBtn").bind("click",function(){
	var menu_userLayout=jQuery("#menu_userLayout").val();
	//收件箱
	//jQuery("#mainFrame").attr("src","/email/new/MailInBox.jsp?folderid=0&receivemail=false&"+new Date().getTime());
	//MailInboxListMain.jsp
	if(menu_userLayout==3){
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("2","/email/new/MailInboxList.jsp?folderid=0&receivemail=false&"+new Date().getTime(),$(this).text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?folderid=0&receivemail=false&"+new Date().getTime();
		}
		
	}else{
		try{
		document.getElementById("mainFrame").contentWindow.refreshTab("2","/email/new/MailInboxListMain.jsp?folderid=0&receivemail=false&"+new Date().getTime(),$(this).text());
		}catch(e){
			//表示右边结构被切换到邮件设计或联系人界面
			document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?folderid=0&receivemail=false&"+new Date().getTime();
		}
	}
})

jQuery("#mailSetting").bind("click",function(){
	jQuery("#mainFrame").attr("src","/email/new/MailSetting.jsp");
})


jQuery("#outboxBtn").bind("click",function(){
	var menu_userLayout=jQuery("#menu_userLayout").val();
	//发件箱
	//jQuery("#mainFrame").attr("src","/email/new/MailInBox.jsp?folderid=-1&"+new Date().getTime());
	if(menu_userLayout==3){
			try{
				document.getElementById("mainFrame").contentWindow.refreshTab("3","/email/new/MailInboxList.jsp?folderid=-1&"+new Date().getTime(),$(this).text());
			}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?folderid=-1&"+new Date().getTime();
			}
	}else{
			try{
     			document.getElementById("mainFrame").contentWindow.refreshTab("3","/email/new/MailInboxListMain.jsp?folderid=-1&"+new Date().getTime(),$(this).text());
     		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?folderid=-1&"+new Date().getTime();
			}
	}
})

jQuery("#drafboxBtn").bind("click",function(){
	var menu_userLayout=jQuery("#menu_userLayout").val();
	//草稿箱
	//jQuery("#mainFrame").attr("src","/email/new/MailInBox.jsp?folderid=-2&"+new Date().getTime());
	if(menu_userLayout==3){
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("4","/email/new/MailInboxList.jsp?folderid=-2&"+new Date().getTime(),$(this).text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?folderid=-2&"+new Date().getTime();
			}
	}else{
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("4","/email/new/MailInboxListMain.jsp?folderid=-2&"+new Date().getTime(),$(this).text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?folderid=-2&"+new Date().getTime();
		}
	}
})

jQuery("#delboxBtn").hover(
        function () {
            $(this).find("#removeAll").show();
          }, 
          function () {
          	 $(this).find("#removeAll").hide();
          }
  );
  
  
jQuery("#tag").hover(
        function () {
            $(this).find("#tagManage").show();
          }, 
          function () {
          	 $(this).find("#tagManage").hide();
          }
  );
  
  
jQuery("#forder").hover(
        function () {
            $(this).find("#folderManage").show();
          }, 
          function () {
          	 $(this).find("#folderManage").hide();
          }
  );
  

jQuery("#folderManage").click(function(event){
 
	     jQuery("#mainFrame").attr("src","/email/new/MailSetting.jsp?target=folder");
		 stopEvent(); 
	 
	
})


jQuery("#tagManage").click(function(event){
	
	     jQuery("#mainFrame").attr("src","/email/new/MailSetting.jsp?target=label");
		 stopEvent(); 
})


  
jQuery("#removeAll").click(function(event){
	 var tip = "<%=SystemEnv.getHtmlLabelName(30838, user.getLanguage()) %>?";
		
	 if(confirm(tip)) {
		 $.post("/email/new/MailManageOperation.jsp",{operation:'deleteAll',folderid:'-3'},function(){
			 jQuery("#delboxBtn").trigger("click");
		 })
		 stopEvent(); 
	 } 
	
})

jQuery("#delboxBtn").bind("click",function(){
	var menu_userLayout=jQuery("#menu_userLayout").val();
	//垃圾箱
	//jQuery("#mainFrame").attr("src","/email/new/MailInBox.jsp?folderid=-3&"+new Date().getTime());
	if(menu_userLayout==3){
			try{
					
					document.getElementById("mainFrame").contentWindow.refreshTab("5","/email/new/MailInboxList.jsp?folderid=-3&"+new Date().getTime(),$(this).find(".title").text());
			}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				//document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?folderid=-3&"+new Date().getTime();
			}
	}else{
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("5","/email/new/MailInboxListMain.jsp?folderid=-3&"+new Date().getTime(),$(this).find(".title").text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?folderid=-3&"+new Date().getTime();
		}
	}
})

jQuery("#internal").bind("click",function(){
	var menu_userLayout=jQuery("#menu_userLayout").val();
	//内部邮件
	//jQuery("#mainFrame").attr("src","/email/new/MailInBox.jsp?isInternal=1&"+new Date().getTime());
	if(menu_userLayout==3){
			try{
				document.getElementById("mainFrame").contentWindow.refreshTab("6","/email/new/MailInboxList.jsp?isInternal=1&"+new Date().getTime(),$(this).text());
			}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?isInternal=1&"+new Date().getTime();
			}
	}else{
		try{
			document.getElementById("mainFrame").contentWindow.refreshTab("6","/email/new/MailInboxListMain.jsp?isInternal=1&"+new Date().getTime(),$(this).text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?isInternal=1&"+new Date().getTime();
		}
	}
})

jQuery("#star").bind("click",function(){
	var menu_userLayout=jQuery("#menu_userLayout").val();
	//标星邮件
	//jQuery("#mainFrame").attr("src","/email/new/MailInBox.jsp?star=1&"+new Date().getTime());
	if(menu_userLayout==3){
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("7","/email/new/MailInboxList.jsp?star=1&"+new Date().getTime(),$(this).text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?star=1&"+new Date().getTime();
		}
	}else{
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("7","/email/new/MailInboxListMain.jsp?star=1&"+new Date().getTime(),$(this).text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?star=1&"+new Date().getTime();
		}
	}
	
})
jQuery(".subfolder").bind("click",function(){
	var menu_userLayout=jQuery("#menu_userLayout").val();
	//文件夹邮件
	//jQuery("#mainFrame").attr("src","/email/new/MailInBox.jsp?folderid="+$(this).attr("target")+"&"+new Date().getTime());
	if(menu_userLayout==3){
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("8","/email/new/MailInboxList.jsp?folderid="+$(this).attr("target")+"&"+new Date().getTime(),$(this).text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?folderid="+$(this).attr("target")+"&"+new Date().getTime();
		}
	}else{
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("8","/email/new/MailInboxListMain.jsp?folderid="+$(this).attr("target")+"&"+new Date().getTime(),$(this).text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?folderid="+$(this).attr("target")+"&"+new Date().getTime();
		}
	}
})

jQuery(".label").bind("click",function(){
	var menu_userLayout=jQuery("#menu_userLayout").val();
	//jQuery("#mainFrame").attr("src","/email/new/MailInBox.jsp?labelid="+$(this).attr("target")+"&"+new Date().getTime());
	//标签
	if(menu_userLayout==3){
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("8","/email/new/MailInboxList.jsp?labelid="+$(this).attr("target")+"&"+new Date().getTime(),$(this).text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?labelid="+$(this).attr("target")+"&"+new Date().getTime();
		}
	}else{
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("8","/email/new/MailInboxListMain.jsp?labelid="+$(this).attr("target")+"&"+new Date().getTime(),$(this).text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?labelid="+$(this).attr("target")+"&"+new Date().getTime();
		}
	}
})

jQuery("#accountsBtn").click(function(event){
	$(".btnGrayDropContent").hide()
	$(".accountsBtnDown").toggle();
	 stopEvent(); 
})

jQuery("#addMailsBtn").click(function(event){
	$(".btnGrayDropContent").hide()
	$(".addMailsBtnDown").toggle();
	 stopEvent(); 
})


jQuery(".accountsBtnDown").find("li").click(function(event){
	var menu_userLayout=jQuery("#menu_userLayout").val();
	$(".btnGrayDropContent").hide();
	 stopEvent(); 
	 
	if(menu_userLayout==3){
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("8","/email/new/MailInboxList.jsp?receivemailid="+$(this).attr("target")+"&folderid=0&receivemail=true&"+new Date().getTime(),"<%=SystemEnv.getHtmlLabelName(19816, user.getLanguage())%>");
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?receivemailid="+$(this).attr("target")+"&folderid=0&receivemail=true&"+new Date().getTime();
		}
	}else{
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("8","/email/new/MailInboxListMain.jsp?receivemailid="+$(this).attr("target")+"&folderid=0&receivemail=true&"+new Date().getTime(),"<%=SystemEnv.getHtmlLabelName(19816, user.getLanguage())%>");
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?receivemailid="+$(this).attr("target")+"&folderid=0&receivemail=true&"+new Date().getTime();
		}
	}
	

})

jQuery(document).click(function(event){
	$(".btnGrayDropContent").hide();
	 stopEvent(); 
})

jQuery(".main").click(function(){
	if(jQuery("#"+jQuery(this).attr("target")).is(":hidden")){
		jQuery("#"+jQuery(this).attr("target")).show();
	}else{
		jQuery("#"+jQuery(this).attr("target")).hide();
	}
})

jQuery(document).ready(function(){

    var clientScreenHeight = document.body.clientHeight;
	
	$("#autoHight").css("height",clientScreenHeight-310+"px");
	$("#autoHight").css("width",$("#leftMenu").width()+4+"px");
	  $('.scroll-pane').jScrollPane({
	        autoReinitialise: true  //内容改变后自动计算高度
	    })

})

//阻止事件冒泡
function stopEvent() {
	if (event.stopPropagation) { 
		// this code is for Mozilla and Opera 
		event.stopPropagation();
	} 
	else if (window.event) { 
		// this code is for IE 
		window.event.cancelBubble = true; 
	}
}
</script>
<style>
.jspPane{
	margin-left: 0px!important;
	left:0px!important;
	width: 100%;
}

.line-gray1{background:#a0c0c7;height:1px;line-height:1px;}
.line-gray2{background:#a0c0c7;height:2px;line-height:2px;}
.line-gray3{background:#a0c0c7;height:3px;line-height:3px;}
.center{text-align:center;margin-left:auto;margin-right:auto;} 

.btnGrayDropContent  li{
	background-color:#f8f8f8;
	cursor:pointer;
	text-align:left;
	font-size: 12px;
	padding-left:5px;
	padding-top: 2px;
	color:#555555;
	height: 20px;
	padding:3px;
	list-style-type: none;
	
}

.btnGrayDropContent  li:hover{
	background-color:#cccccc;
}
.btnGrayDropContent{
	border: #bbb solid 1px;
	border-collapse: collapse;
	border-spacing: 0px;
	cursor: pointer;
	display: block;
	font-size: 12px;
	font-weight: bold;
	margin: 0px;
	padding: 0px;
	z-index: 1000;
	width: 160px;
	top: 28px;
	position: absolute;
	text-align: center;
	line-height: 30px;
	left: -138px;
}
.hide{
	display: none;
}
</style>
