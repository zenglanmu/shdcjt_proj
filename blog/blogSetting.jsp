<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<HTML>
<HEAD>
<title><%=SystemEnv.getHtmlLabelName(26630,user.getLanguage()) %></title>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<LINK href="css/blog.css" type=text/css rel=STYLESHEET>
</HEAD>
<body scroll=no>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<% 
  String tabItem=Util.null2String(request.getParameter("tabItem"));
  tabItem=tabItem.equals("")?"base":"share";
%>
<table cellpadding="0" cellspacing="0" height="100%" width="100%" border="0">

<tr>
	<td height="30px" class="coworkTab" align=left >	
	  <table width=100% border=0 cellspacing=0 cellpadding=0 height=100%>
		<tr align=left>
		    <td nowrap class="item <%=tabItem.equals("base")?"itemSelected":""%>" url="baseSetting.jsp"><%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%></td><!-- 基本设置 -->
			<td nowrap width=2px>&nbsp;<td>
			<td nowrap class="item <%=tabItem.equals("share")?"itemSelected":""%>" id="share" url="shareSetting.jsp"><%=SystemEnv.getHtmlLabelName(26945,user.getLanguage())%></td><!-- 分享设置 -->
			<td nowrap width=2px>&nbsp;<td>
			<td nowrap class="righttab" align=right></td>
		</tr>
	 </table>
	</td>
	<td class="coworkTab" align=right>
        &nbsp;
	</td>
</tr>
<tr>
	<td colspan="2" style="border-left:1px solid #81b3cc;" valign="top" align="center">
        <iframe src="" width="100%" height="100%" scrolling="auto" frameborder="0" id="iframeSetting"></iframe>
    </td>
	</tr>
</table>

</body>
<script>

jQuery(document).ready(function(){
    jQuery("#iframeSetting").attr("src",jQuery(".itemSelected").attr("url"));

	//绑定tab页点击事件
	jQuery(".item").bind("click", function(){
  		var itemType=jQuery(this).attr("type");
  		
  		if(jQuery(this).hasClass("itemSelected"))
  			return;
	  	else{
	  		jQuery(".itemSelected").removeClass("itemSelected");
	  		jQuery(this).addClass("itemSelected");
	  		var url=jQuery(this).attr("url");
	  		jQuery("#iframeSetting").attr("src",url);
	  	}
  	});
});

</script>
