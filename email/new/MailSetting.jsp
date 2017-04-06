<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>

<link href="/email/css/base.css" rel="stylesheet" type="text/css" />

<script type="text/javascript">var languageid=<%=user.getLanguage()%>;</script>


<script type="text/javascript" src="/email/js/autocomplete/jquery.autocomplete.js"></script>
<link href="/email/js/autocomplete/jquery.autocomplete.css" rel="stylesheet" type="text/css" />

<%
String target = Util.null2String(request.getParameter("target"));
String class1="";
String class2="";
String class3="";
String class4="";
String class5="";
String class6="";
String class7="";

if(target.equals("label")){
	class1="tabItemUnSelect";
	class2="tabItemUnSelect";
	class3="tabItemUnSelect";
	class4="tabItemUnSelect";
	class5="tabItemUnSelect";
	class6="tabItemSelect";
	class7="tabItemUnSelect";
}else if(target.equals("folder")){
	class1="tabItemUnSelect";
	class2="tabItemUnSelect";
	class3="tabItemUnSelect";
	class4="tabItemUnSelect";
	class5="tabItemUnSelect";
	class6="tabItemUnSelect";
	class7="tabItemSelect";
}else{
	class1="tabItemSelect";
	class2="tabItemUnSelect";
	class3="tabItemUnSelect";
	class4="tabItemUnSelect";
	class5="tabItemUnSelect";
	class6="tabItemUnSelect";
	class7="tabItemUnSelect";
}
%>
<div class="w-all h-all ">
	
	<ul class="tabNav">
		<li class="<%=class1 %>" target="/email/MailAccount.jsp?showTop=show800"><%=SystemEnv.getHtmlLabelName(81339, user.getLanguage())%></li>
		<li class="<%=class2 %>" target="/email/MailSetting.jsp?showTop=show800"><%=SystemEnv.getHtmlLabelName(81340, user.getLanguage())%></li>
		<li class="<%=class3 %>" target="/email/MailTemplate.jsp?showTop=show800"><%=SystemEnv.getHtmlLabelName(17857, user.getLanguage())%></li>
		<li class="<%=class4 %>" target="/email/MailSign.jsp?showTop=show800"><%=SystemEnv.getHtmlLabelName(24267, user.getLanguage())%></li>
		<li class="<%=class5 %>" target="/email/MailRule.jsp?showTop=show800"><%=SystemEnv.getHtmlLabelName(19828, user.getLanguage())%></li>
		<li class="<%=class6 %>" target="/email/new/LabelManage.jsp"><%=SystemEnv.getHtmlLabelName(81342, user.getLanguage())%></li>
		<li class="<%=class7 %>" target="/email/new/FolderManage.jsp"><%=SystemEnv.getHtmlLabelName(81343, user.getLanguage())%></li>
	</ul>
	<div style="height: 4px;background:#35b2e1;overflow: hidden;" class="w-all"></div>
	<div style="height: 4px;background:#d0eaf4;overflow: hidden;" class="w-all"></div>
	
	<div id="tabContent p-t-10">
		<iframe class="w-all " id="contentFrame" height="100%" src="#" frameborder="0"></iframe>
	</div>
</div>

<style>
<!--

 
 .tabNav{
 	background: #ffffff;
 	height: 42px;
 	
 	padding-left:15px;
 }
 
 
 .tabItemUnSelect{
 	background:#dbe6ea;
 	font-weight:bold;
 	height: 30px;
 	line-height: 30px;
 	font-size:14px;
 	width:80px;
 	text-align: center;
 	margin-top:12px;
 	float:left;
 	bottom: 0px;
 	cursor: pointer;
 	color:#000000;
 	margin-right:5px;
 	
 }
 
 .tabItemSelect{
 	margin-right:5px;
 	font-weight:bold;
 	background: #35b2e1;
 	
 	border-bottom: none;
 	height: 30px;
 	line-height: 30px;
 	font-size:14px;
 	width:80px;
 	text-align: center;
 	margin-top:12px;
 	float:left;
 	bottom: 0px;
 	cursor: pointer;
 	color:#ffffff;
 	
 	
 }


 .searchFrom{
 	background: url('/email/images/search.png') no-repeat;
 	width: 13px;
 	height: 13px;
 	position: absolute;
 	cursor: pointer;
 	right: 45px;
 	top:15px;
 }
  .clearFrom{
  	color:#cccccc;
 	width: 13px;
 	height: 13px;
 	position: absolute;
 	cursor: pointer;
 	right: 45px;
 	top:13px;
 	font-family: verdana!important;
 }
 
  .addFrom{
 	background: url('/email/images/add.png') no-repeat;
 	width: 13px;
 	height: 13px;
 	position: absolute;
 	cursor: pointer;
 	right: 15px;
 	top:15px;
 }
 .addFrom:hover{
 	background: url('/email/images/addOver.png') no-repeat;
 	
 }
 .iconRArr {
	width: 4px;
	height: 7px;
	background: url(/email/images/iconRArr.png) no-repeat;
	position: absolute;
	top:5px;
	left: 5px;
 }
  .iconDArr {
	width: 4px;
	height: 7px;
	background: url(/email/images/iconDArr.png) no-repeat;
	position: absolute;
	top:5px;
	left: 5px;
 }
 
 .contactsItem:hover{
 	background: #CCCCCC;
 }
 
 .contactsFold{
 	margin-top: 5px;
 }
-->
</style>

<script>
jQuery(document).ready(function(){
	
	$("#contentFrame").attr("src",$(".tabItemSelect").attr("target"));

	
	$(".tabNav").find("li").bind("click",function(){
		if(!$(this).hasClass("tabItemSelect")){
			$(".tabItemSelect").removeClass("tabItemSelect").addClass("tabItemUnSelect");
			$(this).removeClass("tabItemUnSelect").addClass("tabItemSelect");
			$("#contentFrame").attr("src",$(this).attr("target"))
		}
	})
});

</script>