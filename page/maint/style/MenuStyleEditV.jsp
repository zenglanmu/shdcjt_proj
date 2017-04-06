<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.page.maint.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="su" class="weaver.page.style.StyleUtil" scope="page" />
<jsp:useBean id="mvsc" class="weaver.page.style.MenuVStyleCominfo" scope="page" />
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
String message = Util.null2String(request.getParameter("message"));
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(22915,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());
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
	<link href="/js/jquery/plugins/menu/menuv/menuv.css" type="text/css" rel=stylesheet>


	<SCRIPT language="javascript" src="/js/weaver.js"></script>
	<SCRIPT language="javascript" src="/js/jquery/jquery.js"></script>
	
	<!--For Menu-->
	<SCRIPT language="javascript" src="/js/jquery/plugins/menu/menuv/menuv.js"></script>

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
	

	<style id="styleMenu" type="text/css" title="styleMenu">
		<%=mvsc.getCss(styleid)%>
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
									<%=mvsc.getCss(styleid)%>
								</textarea>
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
													<input type="input" name="title" value="<%=Util.toHtml5(mvsc.getTitle(styleid))%>" style="width:95%" class="inputstyle_1" onchange='checkinput("title","titlespan")'>	
													<input type="hidden" name="oldtitle" value="<%=Util.toHtml5(mvsc.getTitle(styleid))%>">	
													<SPAN id=titlespan>
										               <IMG src="/images/BacoError.gif" align=absMiddle style="display:none">
										             </SPAN>	
												</TD>
											</TR>
											<TR style="height:1px;"><TD class=line colspan=2></TD></TR>
											<TR>
												<TD><%=SystemEnv.getHtmlLabelName(19622,user.getLanguage())%><!--样式描述--></TD>
												<TD>
													<input type="input"  name="desc"  value="<%=Util.toHtml5(mvsc.getDesc(styleid))%>"  style="width:95%" class="inputstyle_1">
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
											<li><a style="<%=style%>" href="#fragment-2"><span><%=SystemEnv.getHtmlLabelName(17612,user.getLanguage())%><!--顶级菜单--></span></a></li>
											<li><a style="<%=style%>" href="#fragment-3"><span><%=SystemEnv.getHtmlLabelName(17613,user.getLanguage())%><!--子菜单--></span></a></li>
										</ul>									
										<div id="fragment-2">	
											<%=sm.getFont("rule2",SystemEnv.getHtmlLabelName(16189,user.getLanguage()))%>	
											<%=sm.getSimpleFont("rule5",SystemEnv.getHtmlLabelName(22978,user.getLanguage()))%>	
											<%=sm.getSimpleBackground("rule1",SystemEnv.getHtmlLabelName(22989,user.getLanguage()))%>	
											<%=sm.getSimpleBackground("rule4",SystemEnv.getHtmlLabelName(22990,user.getLanguage()))%>	
											<%=sm.getSimpleBackground("rule0",SystemEnv.getHtmlLabelName(25292,user.getLanguage()))%>	
											<%=sm.getSimpleBackground("rule3",SystemEnv.getHtmlLabelName(25293,user.getLanguage()))%>	
											<fieldset>
												<legend><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%><!--其它--></legend>
												<div class="row">
													<span class="left"><%=SystemEnv.getHtmlLabelName(22991,user.getLanguage())%><!--收缩图标--></span>
													<span class="right2">		
														<input class='filetree'  r_id='rule8' r_attr='background-image' name="iconCollapsedMain">
													</span>
												</div>
												<div class="row">
													<span class="left"><%=SystemEnv.getHtmlLabelName(22992,user.getLanguage())%><!--展开图标--></span>
													<span class="right2">		
														<input class='filetree'  r_id='rule2' r_attr='background-image' name="iconExpandMain">
													</span>
												</div>
											</fieldset>
										</div>

										
										<div id="fragment-3" >		
											<%=sm.getFont("rule6",SystemEnv.getHtmlLabelName(16189,user.getLanguage()))%>
											<%=sm.getSimpleFont("rule7",SystemEnv.getHtmlLabelName(22978,user.getLanguage()))%>	
											<%=sm.getSimpleBackground("rule6",SystemEnv.getHtmlLabelName(334,user.getLanguage()))%>	
											<%=sm.getSimpleBackground("rule7",SystemEnv.getHtmlLabelName(22980,user.getLanguage()))%>
										</div>											
									</div>
								</div>
								
											  
								<div style="width:50%;float:right;height:100%;position:relative;" id="divPreview">
									<fieldset> 
											<legend><%=SystemEnv.getHtmlLabelName(22974,user.getLanguage())%><!--预览区--></legend> 
												   <div style="float:right" id="menuv" class="sdmenu">
													  <div class="mainBg_top">
														<a  href="#"  class="mainFont">Menu1</a>
														<a href="#" class="sub">Menu1-1</a>
														<a href="#" class="sub">Menu1-2</a>
														<a href="#" class="sub">Menu1-3</a>
													  </div>
													   <div class="mainBg">
														<a  href="#"  class="mainFont">Menu2</a>
														<a href="#" class="sub">Menu2-1</a>
														<a href="#" class="sub">Menu2-2</a>
														<a href="#" class="sub">Menu2-3</a>
													  </div>													
													  <div class="mainBg">
														<a  href="#"  class="mainFont">Menu3</a>
														<a href="#" class="sub">Menu3-1</a>
														<a href="#" class="sub">Menu3-2</a>
														<a href="#" class="sub">Menu3-3</a>   			
													  </div>
													  <div class="mainBg">
													 	 <a  href="#"class="collapsed mainFont">Menu4</a>
														  		
													  </div>
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
				List titlelist = mvsc.getTitleList();
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
		   if("<%=message%>"=="1")
	            alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>");	
		});	
		
		
		window.onscroll=function(){
			$("#divPreview").css("top",document.body.scrollTop);
		};
		function onBack(){
		    if(confirm("<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%>？"))
			 location.href='/page/maint/style/StyleList.jsp?type=<%=type%>';
		}
		
	</script>
