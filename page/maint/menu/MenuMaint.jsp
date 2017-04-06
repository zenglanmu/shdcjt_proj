<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
String imagefilename = "/images/home.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
boolean HeadMenuhasRight = HrmUserVarify.checkUserRight("HeadMenu:Maint", user);	//总部菜单维护权限 
boolean SubMenuRight = HrmUserVarify.checkUserRight("SubMenu:Maint", user);			//分部菜单维护权限  

if(!HeadMenuhasRight && !SubMenuRight){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

//是否分权系统，如不是，则不显示框架，直接转向到列表页面
rs.executeSql("select detachable from SystemSet");
int detachable=0;
if(rs.next()){
    detachable=rs.getInt("detachable");
    session.setAttribute("detachable",String.valueOf(detachable));
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language="JavaScript">
	var contentUrl = (window.location+"").substring(0,(window.location+"").lastIndexOf("/")+1)+"HompepageRight.jsp";
    if (window.jQuery.client.browser == "Firefox") {
		jQuery(document).ready(function () {
			jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			window.onresize = function () {
				jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			};
		});
	}
</script>
</HEAD>
<body>
<TABLE class=viewform width=100% id=oTable1 height=100%>
  <TBODY>
		<tr><td  height=100% id="oTd1" name="oTd1" width="250px"> 
		<IFRAME name=leftframe id=leftframe src="MenuLeft.jsp?rightStr=SubMenu:Maint" width="100%" height="100%" frameborder=no scrolling=no>
		浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
		</td>
		<td height=100% id=oTd0 name=oTd0 width="10px">
		<IFRAME name=middleframe id=middleframe   src="/framemiddle.jsp" width="100%" height="100%" frameborder=no scrolling=no noresize>
		浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
		</td>
		<td height=100% id=oTd2 name=oTd2 width="*" id="tdcontent">
		<IFRAME name=contentframe id=contentframe src="MenuCenter.jsp?menutype=2" width="100%" height="100%" frameborder=no scrolling=auto>
		浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
		</td>
		</tr>
  </TBODY>
</TABLE>
</body>
</html>
