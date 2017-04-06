<%@page import="weaver.email.domain.MailLabel"%>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="lms" class="weaver.email.service.LabelManagerService" scope="page" />

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
<script type="text/javascript" src="/email/js/colorselect/jquery.colorselect.js"></script>

<div class="w-all ">
	
	<div>
		<table class="liststyle" id="labelList">
			<tr class="header">
				
					<th class=""><%=SystemEnv.getHtmlLabelName(81323,user.getLanguage()) %></th> 
					<th><%=SystemEnv.getHtmlLabelName(27603,user.getLanguage()) %></th>
					<th><%=SystemEnv.getHtmlLabelName(81315,user.getLanguage()) %></th>
					<th align="" width="30px"><%=SystemEnv.getHtmlLabelName(30585,user.getLanguage()) %></th>
				
			</tr>
			<%
			ArrayList<MailLabel> labelList = lms.getLabelManagerList(user.getUID());
			for(int i=0;i<labelList.size();i++){
				MailLabel ml = labelList.get(i);
			%>
			<tr id="label_<%=ml.getId()%>">
				<td><b style="background: <%=ml.getColor() %>;" class="labelcolor m-t-3 left m-r-10"></b> <span  class="labelname"><%=ml.getName() %></span></td>
				<td><%=ml.getUnreadcount() %></td>
				<td><%=ml.getAllmailcount() %></td>
				<td align="" width="80px;">
					<a href="javascript:doEdit(<%=ml.getId()%>,this)"><%=SystemEnv.getHtmlLabelName(26473,user.getLanguage()) %></a>
					<a href="javascript:doClearLabel(<%=ml.getId()%>)"><%=SystemEnv.getHtmlLabelName(15504,user.getLanguage()) %></a>
					<a href="javascript:doDel(<%=ml.getId()%>)"><%=SystemEnv.getHtmlLabelName(23777,user.getLanguage()) %></a>
				</td>
			</tr>
			<%} %>
			
		</table>
	</div>
</div>

<input type="hidden" id="method" name="method" value='add'>
<input type="hidden" id="editlableid" name="editlableid">
<div id="labelEditor" style="display: none">
	<div id="content" class="p-t-30 p-l-30">
		<table >
			<tr class="h-35">
				<td class="color333 font14 w-100">
					<%=SystemEnv.getHtmlLabelName(81325,user.getLanguage()) %>
				</td>
				<td>
					<input type="text" class="w-300" name="labelname" id="labelname">
				</td>
			</tr>
			<tr>
				<td class="color333 font14">
					<%=SystemEnv.getHtmlLabelName(31214,user.getLanguage()) %>
				</td>
				<td class="font12" style="font-size: 12px!important;">
					<div class="btnGray w-80 relative font12 p-l-10" id="colorselector" style="line-height: 28px;"><b class="selectedColor h-10 w-10  font12 absolute" style="overflow:hidden;top:10px;left:2px;display:block;background: #B54143"></b>&nbsp;<%=SystemEnv.getHtmlLabelName(16217,user.getLanguage()) %>
					 <img class="absolute" style="right: 5px; top:10px" src="/email/images/iconDArr.png">
						
					</div>
				</td>
			</tr>
		</table>
	</div>	

</div>

<div id="colorpicker" class="colorpicker hide ">
							<div class=item1></div>
							<div class=item2></div>
							<div class=item3></div>
							<div class=item4></div>
							<div class=item5></div>
							<div class=item6></div>
							<div class=item7></div>
							<div class=item8></div>
							<div class=item9></div>
							<div class=item10></div>
							<div class=item11></div>
							<div class=item12></div>
							<div class=item13></div>
							<div class=item14></div>
							<div class=item15></div>
							<div class=item16></div>
							<div class=item17></div>
							<div class=item18></div>
							<div class=item19></div>
							<div class=item20></div>
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
	overflow:hidden;
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
	
	width: 10px;
	height:10px!important;
	margin: 5px;
	cursor:pointer;
	float: left;
	border-radius:3px;
	min-height: 0px;
	overflow:hidden;
	
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
      top:100px;
      left:50%;
    }
.labelcolor{
	border-radius:2px;
	display: inline-block;
}
</style>

<script>

function doAdd(){
	<%-- $("#labelEditor").show();
	var diag = new Dialog();
	diag.Width  = "480px";
	diag.Title = "<%=SystemEnv.getHtmlLabelName(81324,user.getLanguage()) %>";
	diag.InvokeElementId="labelEditor";
	diag.OKEvent = function(){doSubmit()};
	diag.CancelEvent = function(){doClear()};
	diag.show(); --%>
	
	openDialogcreateLabel("<%=SystemEnv.getHtmlLabelName(81324,user.getLanguage()) %>","/email/new/LabelCreate.jsp?type=1",1);
	
}

function doEdit(id,obj){
	<%-- $("#method").val("edit")
	$("#editlableid").val(id);
	$("#labelname").val($("#label_"+id).find(".labelname").text());
	$(".selectedColor").css("background-color",$("#label_"+id).find(".labelcolor").css("background-color"));
	$("#labelEditor").show();
	var diag = new Dialog();
	diag.Width  = "480px";
	diag.Title = "<%=SystemEnv.getHtmlLabelName(31224,user.getLanguage()) %>";
	diag.InvokeElementId="labelEditor";
	diag.OKEvent = function(){doSubmit()};
	diag.CancelEvent = function(){doClear()};
	diag.show();
	$("#colorselector").parent().parent().css('font-size','12px') --%>
	openDialogcreateLabel("<%=SystemEnv.getHtmlLabelName(31231,user.getLanguage()) %>","/email/new/LabelCreate.jsp?type=3&labelid="+id,1);
	
}


var dlgcreateLabel;
//在其子页面中，调用此方法打开相应的界面
function openDialogcreateLabel(title,url,type) {
			dlgcreateLabel=new Dialog();//定义Dialog对象
			dlgcreateLabel.Model=true;
			dlgcreateLabel.Width=500;//定义长度
			if(type==2){
				dlgcreateLabel.Height=100;
			}else{
				dlgcreateLabel.Height=200;
			}
			dlgcreateLabel.URL=url;
			dlgcreateLabel.Title=title;
			dlgcreateLabel.OKEvent = SaveDatecreateLabel;//点击确定后调用的方法
			dlgcreateLabel.show();			
}
function closeDialogcreateLabel() {
		dlgcreateLabel.close();
		window.location.reload();
}
function SaveDatecreateLabel(){
	     document.getElementById("_DialogFrame_0").contentWindow.submitDate(dlgcreateLabel);
}


function doSubmit(){
	if($.trim($("#labelname").val())==""){
		alert("<%=SystemEnv.getHtmlLabelName(81327,user.getLanguage()) %>")
		return;
	}
	var labelcolor= getBackgroundColor(".selectedColor");
	var labelid="";
	if($("#method").val()=="edit"){
		labelid=$("#editlableid").val()
	}
	var para ={method:$("#method").val(),labelname:$("#labelname").val(),labelcolor:labelcolor,labelid:labelid}	;
	
	$.post("/email/new/LabelManageOperation.jsp",para,function(data){
		
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
	$("#labelname").val("");
}


function doDel(id){	
	if(isdel()){
		var para ={method:'del',labelid:id};
		
		$.post("/email/new/LabelManageOperation.jsp",para,function(){
			document.location.reload();
		})		
	}
}


function doClearLabel(id) {
	if(confirm('是否要清空该标签下的所有邮件')) {
		var param = {'method': 'clear', 'labelid': id};
		$.get("/email/new/LabelManageOperation.jsp", param, function(){
			document.location.reload();
		});
	}
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
		
		//$(this).offset().top
		$(".colorpicker").css("left",$(this).offset().left)
		$(".colorpicker").css("top",$(this).offset().top+30)
		$(".colorpicker").fadeIn(200)
	});
	
	
	
	$("#colorpicker").find("div").bind("click",function(event){
		$(".selectedColor").css("background-color",$(this).css("background-color"));
		$("#colorpicker").hide();
		event.stopPropagation();
	})
	
})
</script>