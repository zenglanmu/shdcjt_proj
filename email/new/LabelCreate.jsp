<%@page import="weaver.email.service.LabelManagerService"%>
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

<%
	String mailsId = Util.null2String(request.getParameter("mailsId"));
	String labelid = Util.null2String(request.getParameter("labelid"));


	String type=Util.null2String(request.getParameter("type"));
	if("1".equals(type)){
	//新增标签
 %>
<div id="labelEditor" >
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
					<%=SystemEnv.getHtmlLabelName(81326,user.getLanguage()) %>
				</td>
				<td>
					<div class="btnGray w-100 relative font12 p-l-10" id="colorselector" style="line-height: 28px;width: 80px!important;"><b class="selectedColor h-10 w-10  font12 absolute" style="overflow:hidden;top:10px;left:2px;display:block;background: #B54143"></b>&nbsp;<%=SystemEnv.getHtmlLabelName(16217,user.getLanguage()) %>
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
<%
	}else if("2".equals(type)){
		//新增文件夹
%>
	<input type="hidden" id="method" name="method">
	<input type="hidden" id="editfolderid" name="editfolderid">
	<div id="folderEditor" class="" >
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
<%	
	}else if("3".equals(type)){
		
		MailLabel mb=LabelManagerService.getOnelabelByID(labelid);
 %>
	<div id="labelEditor" >
	<div id="content" class="p-t-30 p-l-30">
		<table >
			<tr class="h-35">
				<td class="color333 font14 w-100">
					<%=SystemEnv.getHtmlLabelName(81325,user.getLanguage()) %>
				</td>
				<td>
					<input type="text" class="w-300" name="labelname" id="labelname"  value="<%=mb.getName()%>">
				</td>
			</tr>
			<tr>
				<td class="color333 font14">
					<%=SystemEnv.getHtmlLabelName(81326,user.getLanguage()) %>
				</td>
				<td>
					<div class="btnGray w-80 relative font12 p-l-10" id="colorselector" style="line-height: 28px;width: 80px!important;"><b class="selectedColor h-10 w-10  font12 absolute" style="overflow:hidden;top:10px;left:2px;display:block;background: <%=mb.getColor()%>"></b>&nbsp;<%=SystemEnv.getHtmlLabelName(16217,user.getLanguage()) %>
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
<%	
	}
 %>


<style>
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
<script type="text/javascript">
	var type="<%=type%>";
	$(document).ready(function(){
		$("#colorselector").bind("click",function(){
			//$(this).offset().top
			$(".colorpicker").css("left",$(this).offset().left)
			$(".colorpicker").css("top",$(this).offset().top+30)
			$(".colorpicker").fadeIn(200)
		});
		
		$("#addLabel").bind("click",function(){
			$("#method").val("add");
		})
		
		$("#colorpicker").find("div").bind("click",function(event){
			$(".selectedColor").css("background-color",$(this).css("background-color"));
			$("#colorpicker").hide();
			event.stopPropagation();
		});
	});
function submitDate(){
	if(type==1||type==3){
		if($.trim($("#labelname").val())==""){
			alert("<%=SystemEnv.getHtmlLabelName(81327,user.getLanguage()) %>")
			return;
		}
		var labelcolor= getBackgroundColor(".selectedColor");
		var labelid="";
		var method="LabelCreate";
		<%	
			if("3".equals(type)){
		%>
			method="edit";
		<%
			}
		%>
		var para ={method:method,labelname:$("#labelname").val(),labelcolor:labelcolor,mailsId:"<%=mailsId%>",labelid:"<%=labelid%>"}	;
		$.post("/email/new/LabelManageOperation.jsp",para,function(data){
			if("repeat"==data){
					alert("<%=SystemEnv.getHtmlLabelName(31222,user.getLanguage()) %>!");
			}else{
				window.parent.closeDialogcreateLabel();
			}
		});
	}else if(type==2){
		if($.trim($("#foldername").val())==""){
			alert("<%=SystemEnv.getHtmlLabelName(81319,user.getLanguage()) %>")
			return;
		}
		var para ={method:"addandmt", foldername:$("#foldername").val(),mailsId:"<%=mailsId%>"}	;
		$.post("/email/new/FolderManageOperation.jsp",para,function(data){
			if("repeat"==data){
					alert("<%=SystemEnv.getHtmlLabelName(31223,user.getLanguage()) %>!");
			}else{
				window.parent.closeDialogcreateLabel();
			}
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
</script>
