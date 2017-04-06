<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.page.maint.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="su" class="weaver.page.style.StyleUtil" scope="page" />
<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<%
String styleid =Util.null2String(request.getParameter("styleid"));	
String type = Util.null2String(request.getParameter("type"));
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(22913,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";

StyleMaint sm=new StyleMaint(user);
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
<%
   
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
    
	if(!"template".equals(styleid)){
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDel(this),_self} " ;
    	RCMenuHeight += RCMenuHeightStep ;
    }


	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<%
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>

<html>
 <head>
	<!--Base Css And Js-->
   	<link href="/css/Weaver.css" type="text/css" rel=stylesheet>
	<link href="/page/maint/style/common.css" type="text/css" rel=stylesheet>

	<SCRIPT language="javascript" src="/js/weaver.js"></script>
	<SCRIPT language="javascript" src="/js/jquery/jquery.js"></script>

	 <!--For Corner-->
	<SCRIPT type="text/javascript" src="/js/jquery/plugins/corner/jquery.corner.js"></script>

	<!--For Jquery UI-->
	<link href="/js/jquery/ui/jquery-ui.css" type="text/css" rel=stylesheet>
	<script type="text/javascript" src="/js/jquery/ui/ui.core.js"></script>

	<!--For Tab-->
	<SCRIPT language="javascript" src="/js/jquery/ui/ui.tabs.js"></script>
	
	<!--For Dialog-->
	<script type="text/javascript" src="/js/jquery/ui/ui.draggable.js"></script>
    <script type="text/javascript" src="/js/jquery/ui/ui.resizable.js"></script>
    <script type="text/javascript" src="/js/jquery/ui/ui.dialog.js"></script>

	<!--For Color-->
	<link rel="stylesheet" href="/js/jquery/plugins/farbtastic/farbtastic.css" type="text/css" />
	<script type="text/javascript" src="/js/jquery/plugins/farbtastic/farbtastic.js"></script>	

	<!--For Spin Button-->
	<SCRIPT type="text/javascript" src="/js/jquery/plugins/spin/jquery.spin.js"></script>	

	<!--For File Browser Tree-->
	<SCRIPT type="text/javascript" src="/js/jquery/plugins/filetree/jquery.filetree.js"></script>	
	
	<!--common js-->
	<SCRIPT type="text/javascript" src="/page/maint/style/common.js"></script>
	
 </head>
<body  id="myBody">
<form id="frmEdit" name="frmEdit" method="post" action="StyleOprate.jsp">
<input type="hidden" id="styleid" name="styleid" value="<%=styleid%>">
<input type="hidden" id="type" name="type" value="<%=type%>">
<input type="hidden" id="method" name="method" value="edit">

<TABLE width=100% height=100% border="0" cellspacing="0">
    <colgroup>
    <col width="10">
    <col width="">
    <col width="10">
    <tr>
      <td height="10" colspan="3"></td>
    </tr>
    <tr>
        <td></td>
        <td valign="top">
			<table class="Shadow">
				<colgroup>
				<col width="1">
				<col width="">
				<col width="10">
				<tr>
					<TD></TD>		
					<td valign="top">
								<textarea style="width:90%;height:200px;display:none" id="css" name="css"></textarea>
								<textarea style="width:90%;height:200px;display:none" id="cssBak" name="cssBak"><%=esc.getCss(styleid)%></textarea>
								<div style="width:48%;float:left;">
									<div style="width:95%;margin:0 20 0 20">
										<%
										String msg =Util.null2String(request.getParameter("msg"));
										if(!"".equals(msg)){
											out.println("<div style='color:red'>"+SystemEnv.getHtmlLabelName(19640,user.getLanguage())+"</div>");
										}
										%>
										<TABLE class="viewForm" cellspacing="1" cellpadding="1">
											<colgroup>
												<col width="30%">
												<col width="70%">	
											</colgroup>
											<TR>
												<TD><%=SystemEnv.getHtmlLabelName(19621,user.getLanguage())%><!--样式名称--></TD>
												<TD>
													<input type="input" name="title" value="<%=Util.toHtml5(esc.getTitle(styleid))%>" style="width:95%" class="inputstyle_1" onchange='checkinput("title","titlespan")'>
													<input type="hidden" name="oldtitle" value="<%=Util.toHtml5(esc.getTitle(styleid))%>">
													<SPAN id=titlespan>
										               <IMG src="/images/BacoError.gif" align=absMiddle style="display:none">
										             </SPAN>								
												</TD>
											</TR>
											<TR style="height:1px;"><TD class=line colspan=2></TD></TR>
											<TR>
												<TD><%=SystemEnv.getHtmlLabelName(19622,user.getLanguage())%><!--样式描述--></TD>
												<TD>
													<input type="input"  name="desc"  value="<%=Util.toHtml5(esc.getDesc(styleid))%>"  style="width:95%" class="inputstyle_1">
												</TD>
											</TR>
											<TR style="height:1px;"><TD class=line colspan=2></TD></TR>
										  </TABLE>
									</div>
									<br>
									<%
										String style="color:#676767;font-style:normal;font-size:12px;text-decoration:none;";
									%>
									<div id="tabs"  style="width:95%;margin:0 20 0 20;">
										<ul>											
											<li><a style="<%=style%>" href="#fragment-2"><span><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%><!-- 标题 --></span></a></li>
											<li><a style="<%=style%>" href="#fragment-3"><span><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%><!-- 内容 --></span></a></li>
											<li><a style="<%=style%>" href="#fragment-4"><span><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%><!-- 其它 --></span></a></li>
										</ul>									
										<div id="fragment-2">
											<fieldset> 
												  <legend><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><!-- 基本 --></legend> 
												  <div class="row">
													<span class="left"><%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%><!-- 高度 --></span>
													<span class="right2"><input  class="spin height" type="text"  r_id="header" r_attr="height"></span>													
												  </div>
												  <div class="row">
														<span class="left"><%=SystemEnv.getHtmlLabelName(22969,user.getLanguage())%></span>
														<span class="right2">	
															<input class='filetree'  r_id='iconLogo' r_attr='src' name="iconLogo">
														</span>
													</div>
												   <div class="row">
													<span class="left"><%=SystemEnv.getHtmlLabelName(22969,user.getLanguage())%></span>
													<span class="right2">
														 <%=SystemEnv.getHtmlLabelName(22952,user.getLanguage())%><!-- 距上 --><input  class="spin height" type="text" r_id="icon" r_attr="top">
														 <%=SystemEnv.getHtmlLabelName(22953,user.getLanguage())%><!-- 距左 --><input  class="spin height" type="text"  r_id="icon" r_attr="left">
													</span>													
												  </div>
												  <div class="row">
													<span class="left"><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%><!--标题 --></span>
													<span class="right2">
														<%=SystemEnv.getHtmlLabelName(22952,user.getLanguage())%><!-- 距上 --><input  class="spin height" type="text"  r_id="title" r_attr="top">
														<%=SystemEnv.getHtmlLabelName(22953,user.getLanguage())%><!-- 距左 --><input  class="spin height" type="text"  r_id="title" r_attr="left">
													</span>													
												  </div>
												   <div class="row">
													<span class="left"><%=SystemEnv.getHtmlLabelName(22956,user.getLanguage())%><!--工具条 --></span>
													<span class="right2">
														<%=SystemEnv.getHtmlLabelName(22952,user.getLanguage())%><!-- 距上 --><input  class="spin height" type="text"  r_id="toolbar" r_attr="top">
														<%=SystemEnv.getHtmlLabelName(22954,user.getLanguage())%><!-- 距右 --><input  class="spin height" type="text"  r_id="toolbar" r_attr="right">
													</span>													
												  </div>
												  
											</fieldset>												
											<%=sm.getFont("title")%>
											<%=sm.getBackground("header")%>
											<%=sm.getBorder("header")%>	
										</div>
										<div id="fragment-3" >											
											<%=sm.getFont("font")%>	
											<%=sm.getBackground("content")%>
											<%=sm.getBorder("content")%>											
											<fieldset> 
												  <legend><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%><!--其它--></legend>
													 
													<div class="row">
														<span class="left"><%=SystemEnv.getHtmlLabelName(22957,user.getLanguage())%><!--行小图标--></span>
														<span class="right2">													
																<input class='filetree'  r_id='iconEsymbol' r_attr='src' name="iconEsymbol">
														</span>
													</div>

													<div class="row">
														<span class="left"><%=SystemEnv.getHtmlLabelName(22958,user.getLanguage())%><!--分隔线--></span>
														<span class="right2">		
															<input class='filetree'  r_id='sparator' r_attr='background-image'>		
														</span>
													</div>

													<div class="row">
														<span class="left"><%=SystemEnv.getHtmlLabelName(22959,user.getLanguage())%><!--内容边距--></span>
														<span class="right2">		
															 <%=SystemEnv.getHtmlLabelName(22952,user.getLanguage())%><!-- 距上 --><input  class="spin height" type="text"  r_id="content" r_attr="padding-top">	
															 <%=SystemEnv.getHtmlLabelName(22955,user.getLanguage())%><!-- 距下 --><input  class="spin height" type="text"  r_id="content" r_attr="padding-bottom">
															 <br>
															<%=SystemEnv.getHtmlLabelName(22953,user.getLanguage())%><!-- 距左 --><input  class="spin height" type="text"  r_id="content" r_attr="padding-left">
															<%=SystemEnv.getHtmlLabelName(22954,user.getLanguage())%><!-- 距右 --><input  class="spin height" type="text"  r_id="content" r_attr="padding-right">
														</span>
													</div>
											</fieldset>	
										</div>	
										<div id="fragment-4">
											<fieldset> 
												  <legend><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><!-- 主要 --></legend> 
												  <div class="row" style="border:1px solid gray;padding:5px;margin-bottom:5px;">
														<%=SystemEnv.getHtmlLabelName(22976,user.getLanguage())%>
													</div>
													<div class="row">
														<span class="left"><%=SystemEnv.getHtmlLabelName(22963,user.getLanguage())%><!--上边角 --></span>
														<span class='right2 corner'  pos="top" r_id='header'>															
															<input type='radio' name='cornerTop' value='Right'><%=SystemEnv.getHtmlLabelName(22960,user.getLanguage())%><!-- 直角 -->
															<br>
															<input type='radio' name='cornerTop' value='Round' loc="top"><%=SystemEnv.getHtmlLabelName(22961,user.getLanguage())%><!-- 圆角 --><input type="text" style='width:40px' class='inputstyle radian' name='cornerTopRadian'>
														</span>
														
													</div>
													<div class="row">
														<span class="left" ><%=SystemEnv.getHtmlLabelName(22964,user.getLanguage())%><!--下边角 --></span>
														<span class='right2 corner'  pos="bottom"   r_id='content'>
															<input type='radio' name='cornerBottom' value='Right'><%=SystemEnv.getHtmlLabelName(22960,user.getLanguage())%><!-- 直角 -->
															<br>
															<input type='radio' name='cornerBottom' value='Round' loc="bottom"><%=SystemEnv.getHtmlLabelName(22961,user.getLanguage())%><!-- 圆角 --><input type="text" style='width:40px' class='inputstyle radian' name='cornerBottomRadian'>
														</span>
													</div>

													<div class="row">
														<span class="left"><%=SystemEnv.getHtmlLabelName(22965,user.getLanguage())%><!--标题栏 --></span>
														<span class="right2">		
															<input type="radio" value="show"  r_id="header"  name="titleState" class="showOrHidden"><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><!-- 显示 -->
															<input type="radio" value="hidden" r_id="header" name="titleState" class="showOrHidden"><%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%><!-- 隐藏 -->
														</span>
													</div>

													<div class="row">
														<span class="left"><%=SystemEnv.getHtmlLabelName(22966,user.getLanguage())%><!--设置栏 --></span>
														<span class="right2">		
															<input type="radio" value="show"  r_id="toolbar" name="settingState"  class="showOrHidden"><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><!-- 显示 -->
															<input type="radio" value="hidden" r_id="toolbar" name="settingState" class="showOrHidden"><%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%><!-- 隐藏 -->
														</span>
													</div>
													
													<div class="row">
														<span class="left"><%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%><!--刷新 --></span>
														<span class="right2">		
															<input type="radio" value="show"  r_id="iconRefresh" name="refreshIconState"  class="showOrHidden"><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><!-- 显示 -->
															<input type="radio" value="hidden" r_id="iconRefresh" name="refreshIconState" class="showOrHidden"><%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%><!-- 隐藏 -->
														</span>
													</div>
													
													<div class="row">
														<span class="left"><%=SystemEnv.getHtmlLabelName(22250,user.getLanguage())%><!--设置 --></span>
														<span class="right2">		
															<input type="radio" value="show"  r_id="iconSetting" name="settingIconState"  class="showOrHidden"><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><!-- 显示 -->
															<input type="radio" value="hidden" r_id="iconSetting" name="settingIconState" class="showOrHidden"><%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%><!-- 隐藏 -->
														</span>
													</div>
													<div class="row">
														<span class="left"><%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%><!--关闭 --></span>
														<span class="right2">		
															<input type="radio" value="show"  r_id="iconClose" name="closeIconState"  class="showOrHidden"><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><!-- 显示 -->
															<input type="radio" value="hidden" r_id="iconClose" name="closeIconState" class="showOrHidden"><%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%><!-- 隐藏 -->
														</span>
													</div>

													<div class="row">
														<span class="left"><%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%></span>
														<span class="right2">		
															<input type="radio" value="title"  r_id="iconMore" name="moreLocal"  class="showOrHidden"><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%><!--标题 -->
															<input type="radio" value="footer"  r_id="iconMore" name="moreLocal"  class="showOrHidden"><%=SystemEnv.getHtmlLabelName(22433,user.getLanguage())%><!--底部 -->
															<input type="radio" value="hidden" r_id="iconMore" name="moreLocal" class="showOrHidden"><%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%><!-- 隐藏 -->
														</span>
													</div>													

													<div class="row">
														<span class="left"><%=SystemEnv.getHtmlLabelName(22968,user.getLanguage())%><!--图显 --></span>
														<span class="right2">		
																<input type="radio" value="page" class="imgMode" name="imgMode"><%=SystemEnv.getHtmlLabelName(22967,user.getLanguage())%><!--页面 -->
																<input type="radio" value="flash" class="imgMode" name="imgMode">Flash
														</span>
													</div>	  
											</fieldset>	
											<fieldset> 
												  <legend><%=SystemEnv.getHtmlLabelName(22969,user.getLanguage())%><!--图标 --></legend> 
												    <div class="row">
														<span class="left"><%=SystemEnv.getHtmlLabelName(16213,user.getLanguage())%><!--锁定 --></span>
														<span class="right2">													
																<input class='filetree'  r_id='iconLock' r_attr='src' name="iconLock">
														</span>
													</div>	
													<div class="row">
														<span class="left"><%=SystemEnv.getHtmlLabelName(19446,user.getLanguage())%><!--非锁定--></span>
														<span class="right2">													
																<input class='filetree'  r_id='iconUnLock' r_attr='src'  name="iconUnLock">
														</span>
													</div>	
													<div class="row">
														<span class="left"><%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%><!--刷新 --></span>
														<span class="right2">													
																<input class='filetree'  r_id='iconRefresh' r_attr='src'  name="iconRefresh">
														</span>
													</div>	
													<div class="row">
														<span class="left"><%=SystemEnv.getHtmlLabelName(22250,user.getLanguage())%><!--设置 --></span>
														<span class="right2">													
																<input class='filetree'  r_id='iconSetting' r_attr='src'  name="iconSetting">
														</span>
													</div>	
													<div class="row">
														<span class="left"><%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%><!--关闭 --></span>
														<span class="right2">													
																<input class='filetree'  r_id='iconClose' r_attr='src'  name="iconClose">
														</span>
													</div>	
													<div class="row">
														<span class="left"><%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%><!--更多 --></span>
														<span class="right2">													
																<input class='filetree'  r_id='iconMore' r_attr='src'  name="iconMore">
														</span>
													</div>	
											</fieldset>	

											<fieldset> 
												  <legend><%=SystemEnv.getHtmlLabelName(22970,user.getLanguage())%><!--TAB页 --></legend> 
												    <div class="row">
														<span class="left"><%=SystemEnv.getHtmlLabelName(22971,user.getLanguage())%><!--背景条 --></span>
														<span class="right2">		
																<input class='filetree'  r_id='tab2' r_attr='background-image'>
														</span>
													</div>	
													<div class="row">
														<span class="left"><%=SystemEnv.getHtmlLabelName(22972,user.getLanguage())%><!--选中前--></span>
														<span class="right2">													
																<input class='filetree'  r_id='tab2unselected' r_attr='background-image'>
														</span>
													</div>	
													<div class="row">
														<span class="left"><%=SystemEnv.getHtmlLabelName(22973,user.getLanguage())%><!--选中后 --></span>
														<span class="right2">													
																<input class='filetree'  r_id='tab2selected' r_attr='background-image'>
														</span>
													</div>	
													<%=sm.getFont("tab2unselected",SystemEnv.getHtmlLabelName(16189,user.getLanguage()))%>
													<%=sm.getFont("tab2selected",SystemEnv.getHtmlLabelName(22978,user.getLanguage()))%>
											</fieldset>	
										</div>
									</div>
								</div>
								
											  
								<div style="width:50%;float:right;height:100%;position:relative;" id="divPreview">
									<fieldset> 
											<legend><%=SystemEnv.getHtmlLabelName(22974,user.getLanguage())%><!--预览区 --></legend> 
											<div  style="padding:30px;" id='divContainer'>
												<%=su.getContainerForStyle(styleid)%>
											</div>
											</fieldset> 
										</div>										
								
								</div>
								<div style="clear:both"></div>								
					</td>
				</tr><TR style="height:1px;"><TD class=line colspan=3></TD></TR><tr>
				</tr>
				<tr>
					<td height="10" colspan="3"></td>
				</tr>
			</table>
			</form>
	    </td>
		<td></td>
	</tr>
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
</TABLE>
<div id="coloPanel" title="<%=SystemEnv.getHtmlLabelName(22975,user.getLanguage())%>">
	<div id="colorPicker"></div>
	<div style='text-align:center'><input id="txtColorTemp"></div>
</div>	
</body>
</html>
<script language="javascript">
		function onSave(obj){
		 	if(check_form(frmEdit,'title')){
		 		var titles =[];
				var states = 0;
				<%
				List titlelist = esc.getTitleList();
				for(int i = 0; i < titlelist.size() ; i++){
				%>
					titles[<%=i%>]="<%=titlelist.get(i)%>";
				<%}%>
				for(var i=0; i<titles.length; i++){
					if(titles[i] == frmEdit.title.value)
						states++;
				}
		 		if(frmEdit.title.value != frmEdit.oldtitle.value && states >0){
		 			alert("<%=SystemEnv.getHtmlLabelName(19641,user.getLanguage())%>");
		 		}else{
					generateCss();
					obj.disabled=true;
					frmEdit.submit();
				}
			}
		}

		function onDel(obj){
			if(isdel()){
				frmEdit.method.value="del";
				obj.disabled=true;
				frmEdit.submit();			
			}
		}

		$(document).ready(function(){
			//以下是元素样式中所特有的js方法
			
			
			//圆角弧度
			$('.radian').each(function(){
				var cValue="";
				if(this.name=="cornerTopRadian"){
					cValue="<%=esc.getCornerTopRadian(styleid)%>"
				} else if(this.name=="cornerBottomRadian"){
					cValue="<%=esc.getCornerBottomRadian(styleid)%>"
				} 

				this.value=cValue;
				$(this).bind("blur",function(){
					var prevObj=this.previousSibling.previousSibling.previousSibling ;		
							
					if(prevObj.value=="Right") { //直角
						$("."+(prevObj.parentNode.r_id)).uncorner(); 
					} else { //圆角
						$("."+(prevObj.parentNode.r_id)).uncorner(); 						
						$("."+(prevObj.parentNode.r_id)).corner("Round "+prevObj.loc+" "+this.value); 
					}			
				});	
			});
			
			$(".corner").each(function(){
				var cornerTop="<%=esc.getCornerTop(styleid)%>"
				var cornerBottom="<%=esc.getCornerBottom(styleid)%>"					
				
				var r_id=this.r_id;
				var cValue="";
				var cPos="";		
				if(this.pos=="top") {
					cValue=cornerTop;
					cPos="top";
				} else {
					cValue=cornerBottom;
					cPos="bottom";
				}
				for(var i=0;i<this.children.length;i++){		
					var child=this.children[i];		
					$(child).bind("click",function(){	
						if(this.checked){
							if(this.value=="Right") { //直角
								$("."+r_id).uncorner(); 
							} else { //圆角
								$("."+r_id).uncorner(); 
								var cValueRadian=$(this).parent().children("INPUT.radian").val();
								//alert(cValueRadian);
								
								$("."+r_id).corner(" "+this.value+" "+cPos+" "+cValueRadian); 
							}
						}					
					});
					if(child.value==cValue){
						child.checked=true;
						$(child).trigger("click");
					}
				}
			});
			 
			//标题栏
			$('.showOrHidden').each(function(){
				var r_id=this.r_id;
				var cValue="";
				if(this.name=="titleState") cValue="<%=esc.getTitleState(styleid)%>";
				else if(this.name=="settingState") cValue="<%=esc.getSettingState(styleid)%>";
				else if(this.name=="refreshIconState") cValue="<%=esc.getRefreshIconState(styleid)%>";
				else if(this.name=="settingIconState") cValue="<%=esc.getSettingIconState(styleid)%>";
				else if(this.name=="closeIconState") cValue="<%=esc.getCloseIconState(styleid)%>";
				else if(this.name=="moreLocal") cValue="<%=esc.getMoreLocal(styleid)%>";
				

				$(this).bind("click",function(){
					if(this.value=="hidden"){
						$("."+r_id).hide();
					} else{
						$("."+r_id).show();		
						if(this.name=="moreLocal"){
							var objMore=$(".iconMore")[0].parentNode;
							if(this.value=="title"){
								//alert("title")
								$(".toolbar").children("ul li:last").append($(objMore));
							} else if (this.value=="footer"){
								$(".footer").append($(objMore));
								//alert($(".footer").html())
							}
						}
					}		
				});
				if(this.value==cValue){
					this.checked=true;
					$(this).trigger("click");
				}
			});
			//图片模式
			$('.imgMode').each(function(){
				if(this.value=="<%=esc.getImgMode(styleid)%>"){
					this.checked=true;		
				}
			});


		});	

		/*当主菜单和子菜单的图标发生更改时，处理图标的是否显示判断*/
		  $(".iconEsymbol").bind('error',function(){
				if($(this).attr("src")==''){
					$(this).hide();
				}
		  })
		  
		  $(".iconEsymbol").bind('load',function(){
				if($(this).attr("src")!=''){
					$(this).show();
				}
		  })
		  
		  $(".toolbar").find("img").bind('error',function(){
				if($(this).attr("src")==''){
					$(this).hide();
				}
		  })
		  
		   $(".toolbar").find("img").bind('load',function(){
				if($(this).attr("src")!=''){
					$(this).show();
				}
		  })

		document.body.onscroll=function(){
			$("#divPreview").css("top",document.body.scrollTop);
		}
		
		function onBack(){
			location.href='/page/maint/style/StyleList.jsp?type=element';
		}
	</script>
