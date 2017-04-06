<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<HTML>
<HEAD>
<title></title>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<LINK href="/blog/css/blog.css" type=text/css rel=STYLESHEET>
<link type='text/css' rel='stylesheet'  href='/blog/js/treeviewAsync/eui.tree.css'/>
<script language='javascript' type='text/javascript' src='/blog/js/treeviewAsync/jquery.treeview.js'></script>
<script language='javascript' type='text/javascript' src='/blog/js/treeviewAsync/jquery.treeview.async.js'></script>
</HEAD>
<%

if (!HrmUserVarify.checkUserRight("blog:specifiedShare", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

int userid=user.getUID();

%>	
<body scroll=no style="overflow-y:hidden">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

 <div>
	 <DIV id=bg></DIV>
	 <div id="loading">
			<div style=" position: absolute;top: 35%;left: 25%" align="center">
			    <img src="/images/loading2.gif" style="vertical-align: middle"><label id="loadingMsg"><%=SystemEnv.getHtmlLabelName(23278,user.getLanguage())%></label>
			</div>
	 </div>
 </div>
 
	<div id=divContent style="padding-bottom: 10px;height: 100%"> 
		<table  border=0 height=100% width=100% cellpadding="0" cellspacing="0" >
			<tr>
				<td width='240px' nowrap="nowrap" valign="top" id="itmeList">
					<div id="divListContentContaner" style="position:relative;height: 100%;overflow: auto;width: 240px">
						<div id="listItems">
						   <ul id="hrmOrgTree" style="width: 100%"></ul>
						</div>
					</div>
				</td>
				<td width="8"  align=left valign=middle height=100% id="frmCenter" style="background:#B1D4D9;;cursor:e-resize;">
				     <div id="frmCenterImg" onclick="mnToggleleft(this)" class="frmCenterImgOpen" style="height: 100%"></div>
                </td>
				<td valign="top">
				     <iframe id='ifmBlogItemContent' src='blogSpecifiedShareList.jsp' height=100% width="100%" border=0 frameborder="0" scrolling="auto"></iframe>
				</td>
			</tr>
		</table>
	</div>
</body>
<script>
  
  jQuery(document).ready(function(){
	    jQuery("#divListContentContaner").height(jQuery("#itmeList").height()); //固定 divListContentContaner高度防止不出现滚动条      
	    $("#hrmOrgTree").addClass("hrmOrg"); 
	    $("#hrmOrgTree").treeview({
	         url:"/blog/hrmOrgTree.jsp"
	    });
  });

  function openBlog(blogid,type,obj){
	var url="";
	if(type==1){
	  url="addSpecifiedShare.jsp?specifiedid="+blogid;
    }
	if(type==2||type==3){
	  return ;
	}
	jQuery("#ifmBlogItemContent").attr("src",url);
	if(obj){
		 jQuery(obj).css("font-weight","normal");
		 jQuery(obj).parent().parent().find(".selected").removeClass("selected");
		 jQuery(obj).parent().addClass("selected");
	}
 }


/*收缩左边栏*/
function mnToggleleft(obj){
	if(jQuery("#itmeList").is(":hidden")){
	        jQuery("#frmCenterImg").removeClass("frmCenterImgClose");
	        jQuery("#frmCenterImg").addClass("frmCenterImgOpen");
			jQuery("#itmeList").show();
	}else{
	        jQuery("#frmCenterImg").removeClass("frmCenterImgOpen");
	        jQuery("#frmCenterImg").addClass("frmCenterImgClose"); 
			jQuery("#itmeList").hide();
	}
}
</script>
