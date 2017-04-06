<%@ page import="weaver.email.domain.MailFolder"%>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="fms" class="weaver.email.service.FolderManagerService" scope="page" />

<link href="/email/css/base.css" rel="stylesheet" type="text/css" />
<link href="/email/css/color.css" rel="stylesheet" type="text/css" />
<link type="text/css" rel="stylesheet" href="/css/Weaver.css" />

<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog.js" charset="GBK"></script>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag.js" ></script>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:doAdd(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<div class="w-all ">
	
	<div>
		<table class="liststyle" id="labelList">
			<tr class="header">
				
					<th ><%=SystemEnv.getHtmlLabelName(19825,user.getLanguage()) %></th>
					<th><%=SystemEnv.getHtmlLabelName(27603,user.getLanguage()) %></th>
					<th><%=SystemEnv.getHtmlLabelName(81315,user.getLanguage()) %></th>
					<th  width="30px"><%=SystemEnv.getHtmlLabelName(104,user.getLanguage()) %></th>
				
			</tr>
			<%
			ArrayList<MailFolder> folderList = fms.getFolderManagerList(user.getUID());
			for(int i=0;i<folderList.size();i++){
				MailFolder mf = folderList.get(i);
			%>
			<tr id="folder_<%=mf.getId()%>">
				<td><b style="background: ;" class="labelcolor left m-r-10"></b> <span class="foldername"><%=mf.getFolderName() %></span></td>
				<td><%=mf.getUnreadcount() %></td>
				<td><%=mf.getAllmailcount() %></td>
				<td align="" width="100px;"><a href="javascript:doEdit(<%=mf.getId()%>,this)"><%=SystemEnv.getHtmlLabelName(26473,user.getLanguage()) %></a> <a href="javascript:doClearFolder(<%=mf.getId()%>)"><%=SystemEnv.getHtmlLabelName(15504,user.getLanguage()) %></a> <a href="javascript:doDel(<%=mf.getId()%>)"><%=SystemEnv.getHtmlLabelName(23777,user.getLanguage()) %></a> </td>
			</tr>
			<%} %>
			
		</table>
	</div>
</div>

<input type="hidden" id="method" name="method">
<input type="hidden" id="editfolderid" name="editfolderid">
<div id="folderEditor" class="" style="display: none">
<div id="content" class="p-t-15 p-b-15 p-l-30">
	<table >
		<tr class="h-35">
			<td class="color333 font14 w-100">
				<%=SystemEnv.getHtmlLabelName(81318,user.getLanguage()) %> 
			</td>
			<td>
				<input type="text" class="w-300" name="foldername" id="foldername">
			</td>
		</tr>
	</table>
</div>	



</div>


<style>


body{
	height: auto;
}
#labelList tr{
	border-bottom: 1px solid #eee;
	height: 35px;
}

#labelList td,th{
	padding: 5px;
	font-size: 12px;
	color:#333;
	vertical-align: middle;
}

#labelList b{
	display: block;
	height: 10px;
	width: 10px;
}

#lean_overlay {
    position: fixed;
    z-index:100;
    top: 0px;
    left: 0px;
    height:100%;
    width:100%;
    background: #000;
    display: none;
    filter: alpha(opacity=30);
}

.colorpicker{
	width: 120px;
	box-shadow:rgba(0,0,0,0.2) 0px 0px 5px 0px;
    border: 2px solid #90969E;
    background: #ffffff;
    height: 100px;
    left:0px;
    padding-left:10px;
    padding-top: 10px;
    position: absolute;
    z-index: 1000000;
    
}

.colorpicker div{
	display: block;
	width: 10px;
	height: 10px;
	margin: 5px;
	cursor:pointer;
	float: left;
	border-radius:3px;
}
.colorpicker div:hover{
	border-radius:0px;
	border: 1px solid #3366cc;
	
}
.popWindow{
      width:450px;
      height:auto;
      box-shadow:rgba(0,0,0,0.2) 0px 0px 5px 0px;
      border: 2px solid #90969E;
      background: #ffffff;
    }
</style>

<script>

function doAdd(){
	
	var diag = new Dialog();
	diag.Width  = "480px";
	diag.Title = "<%=SystemEnv.getHtmlLabelName(81317,user.getLanguage()) %>";
	diag.InvokeElementId="folderEditor";
	diag.OKEvent = function(){doSubmit(1)};
	diag.CancelEvent = function(){doClear()};
	diag.show();
}

function doSubmit(type_n){
	if($.trim($("#foldername").val())==""){
		alert("<%=SystemEnv.getHtmlLabelName(81319,user.getLanguage()) %>")
		return;
	}
	if(type_n==1){
		$("#method").val("add");
	}else if(type_n==2){
		$("#method").val("edit");
	}
	var para ={method:$("#method").val(), foldername:$("#foldername").val(), editfolderid:$("#editfolderid").val()}	;
	
	$.post("/email/new/FolderManageOperation.jsp",para,function(data){
		
		if(data!='repeat'){
			Dialog.getInstance('0').close();
			document.location.reload();
		}else{
			alert('<%=SystemEnv.getHtmlLabelName(26603,user.getLanguage()) %>')
		}
	})
}

function doClear(){
	Dialog.getInstance('0').close();
	$("#foldername").val("");
}


function doDel(id){	
	//这个地方做物理删除，并且还要刷新左边菜单-??
	if(window.confirm("<%=SystemEnv.getHtmlLabelName(31265, user.getLanguage()) %>?")){
		var para ={method:'del',folderid:id};
		$.post("/email/new/FolderManageOperation.jsp",para,function(){
			document.location.reload();
		})
	}
}

function doClearFolder(id){
	//这个地方做逻辑删除-??
	if(window.confirm("<%=SystemEnv.getHtmlLabelName(31266, user.getLanguage()) %>?")){
		var para ={method:'clear',folderid:id};
		$.post("/email/new/FolderManageOperation.jsp",para,function(){
			document.location.reload();
		})	 		
	}
}

function isclear(){
	var tip = "<%=SystemEnv.getHtmlLabelName(81423, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(2040, user.getLanguage()) %>?";
	
	if(confirm(tip)) {
		return true;
	} else {
		return false;
	}
}

function doEdit(id,obj){
	$("#method").val("edit")
	$("#editfolderid").val(id);
	$("#foldername").val($("#folder_"+id).find(".foldername").text());
	var diag = new Dialog();
	diag.Width  = "480px";
	diag.Title = "<%=SystemEnv.getHtmlLabelName(31224,user.getLanguage()) %>";
	diag.InvokeElementId="folderEditor";
	diag.OKEvent = function(){doSubmit(2)};
	diag.CancelEvent = function(){doClear()};
	diag.show();
	
}

function getBackgroundColor(selecter){
	<%if(isIE.equals("true")){%>
		var color= $(selecter).css("background-color");
		<%
	}else{
		%>
		var color= $(selecter).getHexBackgroundColor();
		<%
	}
	%>
	
	return color;
}




$.fn.getHexBackgroundColor = function() {
    var rgb = $(this).css('background-color');
    rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
    function hex(x) {return ("0" + parseInt(x).toString(16)).slice(-2);}
    return "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3]);
}

$(document).ready(function(){
	
	$("#colorselector").bind("click",function(){
		
		$(".colorpicker").fadeIn(200)
	});
	
	
	$("#addFolder").bind("click",function(){
		$("#method").val("add");
	})
	
	$("#colorpicker").find("div").bind("click",function(event){
		$(".selectedColor").css("background-color",$(this).css("background-color"));
		$("#colorpicker").hide();
		stopEvent();
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