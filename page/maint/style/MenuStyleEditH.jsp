<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.page.maint.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="su" class="weaver.page.style.StyleUtil" scope="page" />
<jsp:useBean id="mhsc" class="weaver.page.style.MenuHStyleCominfo" scope="page" />
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%

String styleid =Util.null2String(request.getParameter("styleid"));	
String type = Util.null2String(request.getParameter("type"));
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(22914,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());
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



<html>
 <head>
	<!--Base Css And Js-->
   	<link href="/css/Weaver.css" type="text/css" rel=stylesheet>
	<link href="/page/maint/style/common.css" type="text/css" rel=stylesheet>
	<link href="/js/jquery/plugins/menu/menuh/menuh.css" type="text/css" rel=stylesheet>


	<SCRIPT language="javascript" src="/js/weaver.js"></script>
	<SCRIPT language="javascript" src="/js/jquery/jquery.js"></script>
	
	<!--For Menu-->
	<SCRIPT language="javascript" src="/js/jquery/plugins/menu/menuh/menuh.js"></script>

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
	
	
	

	<style id="styleMenu">
	<%=mhsc.getCss(styleid)%>
	</style>
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
								<textarea style="width:90%;height:200px;display:none" id="cssBak" name="cssBak">
									<%=mhsc.getCss(styleid)%>
		`						</textarea>
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
													<input type="input" name="title" value="<%=Util.toHtml5(mhsc.getTitle(styleid))%>" style="width:95%" class="inputstyle_1" onchange='checkinput("title","titlespan")'>
													<input type="hidden" name="oldtitle" value="<%=Util.toHtml5(mhsc.getTitle(styleid))%>">
													<SPAN id=titlespan>
										               <IMG src="/images/BacoError.gif" align=absMiddle style="display:none">
										             </SPAN>		
												</TD>
											</TR>
											<TR style="height:1px;"><TD class=line colspan=2></TD></TR>
											<TR>
												<TD><%=SystemEnv.getHtmlLabelName(19622,user.getLanguage())%><!--样式描述--></TD>
												<TD>
													<input type="input"  name="desc"  value="<%=Util.toHtml5(mhsc.getDesc(styleid))%>"  style="width:95%" class="inputstyle_1">
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
											<li><a style="<%=style%>" href="#fragment-2"><span><%=SystemEnv.getHtmlLabelName(17597,user.getLanguage())%><!--主菜单--></span></a></li>
											<li><a style="<%=style%>" href="#fragment-3"><span><%=SystemEnv.getHtmlLabelName(17613,user.getLanguage())%><!--子菜单--></span></a></li>
										</ul>									
										<div id="fragment-2">	
											<%=sm.getSimpleBackgroundForH("menuhContainer",SystemEnv.getHtmlLabelName(22977,user.getLanguage()))%>
											
											<%=sm.getFont("rule1",SystemEnv.getHtmlLabelName(16189,user.getLanguage()))%>
											<%=sm.getSimpleFont("rule2",SystemEnv.getHtmlLabelName(22978,user.getLanguage()))%>

											<%=sm.getSimpleBackground("rule1",SystemEnv.getHtmlLabelName(25272,user.getLanguage()))%>
											<%=sm.getSimpleBackground("rule2",SystemEnv.getHtmlLabelName(25273,user.getLanguage()))%>
											<%=sm.getBorderOnly(SystemEnv.getHtmlLabelName(22958,user.getLanguage()),"main","right")%>	
											<fieldset>
												<legend><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%><!--其它--></legend>
												<div class='row'>
													<span class='left'><%=SystemEnv.getHtmlLabelName(22981,user.getLanguage())%><!--位置--></span>
													<span class='right2 line-style'  r_id='menuhContainer' r_attr='text-align'>
														<input type='radio' value='left' name='menuhContainer_text-align'><%=SystemEnv.getHtmlLabelName(22986,user.getLanguage())%><!--左-->
														<input type='radio' value='center'  name='menuhContainer_text-align'><%=SystemEnv.getHtmlLabelName(22987,user.getLanguage())%><!--中-->
														<input type='radio' value='right' name='menuhContainer_text-align'><%=SystemEnv.getHtmlLabelName(22988,user.getLanguage())%><!--右-->
													</span>

												</div>
												<div class="row">
													<span class="left"><%=SystemEnv.getHtmlLabelName(22982,user.getLanguage())%><!--子菜单图标--></span>
													<span class="right2">		
														<input class='filetree'  r_id='downarrowclass' r_attr='src' name="iconMainDown">
													</span>
												</div>
												<div class="row">
													<span class="left"><%=SystemEnv.getHtmlLabelName(22959,user.getLanguage())%><!--内容边距--></span>
													<span class="right2">		
														  <%=SystemEnv.getHtmlLabelName(22952,user.getLanguage())%><!-- 距上 --><input  class="spin height" type="text"  r_id="main" r_attr="padding-top">	
														  <%=SystemEnv.getHtmlLabelName(22955,user.getLanguage())%><!-- 距下 --><input  class="spin height" type="text"  r_id="main" r_attr="padding-bottom">
														 <br>
														 <%=SystemEnv.getHtmlLabelName(22953,user.getLanguage())%><!-- 距左 --><input  class="spin height" type="text"  r_id="main" r_attr="padding-left">
														 <%=SystemEnv.getHtmlLabelName(22954,user.getLanguage())%><!-- 距右 --><input  class="spin height" type="text"  r_id="main" r_attr="padding-right">
													</span>
												</div>
												<!-- 首页导航是否显示这个功能未实现，在此先隐藏！-->
												<div class='row' style="display:none">
													<span class='left'> <%=SystemEnv.getHtmlLabelName(23858,user.getLanguage())%><!--显示菜单选中后状态--></span>
													<span class='right2'>
														<input type='radio' value='yes' <%="yes".equals(mhsc.getShowSelectedState(styleid))?"checked":""%> name="showSelectedState"> <%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%> <!--显示 -->
														<input type='radio' value='no'  <%="no".equals(mhsc.getShowSelectedState(styleid))?"checked":""%>  name="showSelectedState"> <%=SystemEnv.getHtmlLabelName(23857,user.getLanguage())%> <!--不显示-->
													</span>
												</div>												
											</fieldset>
										</div>
										<div id="fragment-3" >		
											<%=sm.getFont("rule3",SystemEnv.getHtmlLabelName(16189,user.getLanguage()))%>	
											<%=sm.getSimpleFont("rule4",SystemEnv.getHtmlLabelName(22978,user.getLanguage()))%>

											<%=sm.getSimpleBackground("rule3",SystemEnv.getHtmlLabelName(25272,user.getLanguage()))%>		
											<%=sm.getSimpleBackground("rule4",SystemEnv.getHtmlLabelName(25273,user.getLanguage()))%>	
											<%=sm.getBorderOnly(SystemEnv.getHtmlLabelName(22958,user.getLanguage()),"sub","bottom")%>	
											<fieldset>
												<legend><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%><!--其它--></legend>												
												<div class="row">
													<span class="left"><%=SystemEnv.getHtmlLabelName(22982,user.getLanguage())%><!--子菜单图标--></span>
													<span class="right2">		
														<input class='filetree'  r_id='rightarrowclass' r_attr='src' name="iconSubDown">
													</span>
												</div>
												<div class="row">
													<span class="left"><%=SystemEnv.getHtmlLabelName(22959,user.getLanguage())%><!--内容边距--></span>
													<span class="right2">		
														 <%=SystemEnv.getHtmlLabelName(22952,user.getLanguage())%><!-- 距上 --><input  class="spin height" type="text"  r_id="sub" r_attr="padding-top">	
														  <%=SystemEnv.getHtmlLabelName(22955,user.getLanguage())%><!-- 距下 --><input  class="spin height" type="text"  r_id="sub" r_attr="padding-bottom">
														 <br>
														 <%=SystemEnv.getHtmlLabelName(22953,user.getLanguage())%><!-- 距左 --><input  class="spin height" type="text"  r_id="sub" r_attr="padding-left">
														 <%=SystemEnv.getHtmlLabelName(22954,user.getLanguage())%><!-- 距右 --><input  class="spin height" type="text"  r_id="sub" r_attr="padding-right">
													</span>
												</div>
											</fieldset>
										</div>											
									</div>
								</div>
								
											  
								<div style="width:50%;float:right;height:100%;position:relative;" id="divPreview">
									<fieldset> 
											<legend><%=SystemEnv.getHtmlLabelName(22974,user.getLanguage())%><!--预览区--></legend> 
												<div class="menuhContainer" id="menuhContainer" cornerTop='<%=mhsc.getCornerTop(styleid) %>'  cornerTopRadian='<%=mhsc.getCornerTopRadian(styleid) %>'  cornerBottom='<%=mhsc.getCornerBottomRadian(styleid) %>'  cornerBottomRadian='<%=mhsc.getCornerBottomRadian(styleid) %>'>
												<span id="menuh" class="menuh" >	
													<ul>
														<li><a href="#"   class="main">Menu1</a></li>
														<li><a href="#" class="main">Menu2</a><ul>
														  <li><a href="#" class="sub">Menu2-1</a></li>
														  <li><a href="#" class="sub">Menu2-2</a><ul>
															<li><a href="#" class="sub">Menu2-2-1</a></li>
															<li><a href="#" class="sub">Menu2-2-2</a></li>												
															<li><a href="#" class="sub">Menu2-2-3</a></li>
															</ul>
														  </li>
														  </ul>
														</li>
														<li ><a href="#" class="main">Menu3</a></li>
													</ul>
													<br style="clear: left" />
												</span>
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
				List titlelist = mhsc.getTitleList();
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
			menuh.arrowimages.down[1]="<%=mhsc.getIconMainDown(styleid)%>";
			menuh.arrowimages.right[1]="<%=mhsc.getIconSubDown(styleid)%>";

			menuh.init({
				mainmenuid: "menuh", 
				contentsource: "markup"
			})
			
			$('.radian').each(function(){
				var cValue="";
				if(this.name=="cornerTopRadian"){
					cValue="<%=mhsc.getCornerTopRadian(styleid)%>"
				} else if(this.name=="cornerBottomRadian"){
					cValue="<%=mhsc.getCornerBottomRadian(styleid)%>"
				} 

				this.value=cValue;
				$(this).bind("blur",function(){
					var prevObj=this.previousSibling.previousSibling.previousSibling ;		
							
					if(prevObj.value=="Right") { //直角
						$("."+(prevObj.parentNode.r_id)).uncornerById(prevObj.loc); 
						
					} else { //圆角
						$("."+(prevObj.parentNode.r_id)).uncornerById(prevObj.loc); 						
						$("."+(prevObj.parentNode.r_id)).corner("Round "+prevObj.loc+" "+this.value,prevObj.loc); 
					}			
				});	
			});
			
			$(".corner").each(function(){
				var cornerTop="<%=mhsc.getCornerTop(styleid)%>"
				var cornerBottom="<%=mhsc.getCornerBottom(styleid)%>"					
				
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
					//alert(child);
					$(child).bind("click",function(){	
						if(this.checked){
							if(this.value=="Right") { //直角
								$("."+r_id).uncornerById(cPos); 
								
							} else { //圆角
								$("."+r_id).uncornerById(cPos); 
								var cValueRadian=$(this).parent().children("INPUT.radian").val();
								//alert(cValueRadian);
								//alert(r_id)
								$("."+r_id).corner(" "+this.value+" "+cPos+" "+cValueRadian,cPos); 
							}
						}					
					});
					if(child.value==cValue){
						child.checked=true;
						$(child).trigger("click");
					}
				}
			});

			  
		});	
		/*当主菜单和子菜单的图标发生更改时，处理图标的是否显示判断*/
		  $(".downarrowclass").bind('error',function(){
				if($(this).attr("src")==''){
					$(this).hide();
				}
		  })
		  
		  $(".downarrowclass").bind('load',function(){
				if($(this).attr("src")!=''){
					$(this).show();
				}
		  })
		  
		  $(".rightarrowclass").bind('error',function(){
				if($(this).attr("src")==''){
					$(this).hide();
				}
		  })
		  
		  $(".rightarrowclass").bind('load',function(){
				if($(this).attr("src")!=''){
					$(this).show();
				}
		  })
		
		window.onscroll=function(){
			$("#divPreview").css("top",document.body.scrollTop);
		};
		
		function onBack(){
			location.href='/page/maint/style/StyleList.jsp?type=<%=type%>';
		}	
	</script>
	<!--common js-->
	<SCRIPT type="text/javascript" src="/page/maint/style/common.js"></script>
