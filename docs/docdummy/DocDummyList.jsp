<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<html>
<head>
<script type="text/javascript">
   if (window.jQuery.client.browser == "Firefox") {
		jQuery(document).ready(function () {
			jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			window.onresize = function () {
				jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
			};
		});
	}
   
</script>
<head>
<body  scroll="no">
	<%
	int dummyId = Util.getIntValue(request.getParameter("dummyId"),1);
	%>
	<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>

	<TABLE class=viewform width=100% id=oTable1 height=100% cellpadding="0px" cellspacing="0px">
	  <TBODY>
	<tr><td  height=100% id=oTd1 name=oTd1 width="220"  style="padding:0px">
	<IFRAME name=leftframe id=leftframe src="DocDummyLeft.jsp?dummyId=<%=dummyId%>" width="100%" height="100%" frameborder=no scrolling=yes>
	<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
	</td>
	<td height=100% id=oTd0 name=oTd0 width="10"  style="padding:0px">
	<IFRAME name=middleframe id=middleframe   src="/framemiddle.jsp" width="100%" height="100%" frameborder=no scrolling=no noresize>
	<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
	</td>
	<td height=100% id=oTd2 name=oTd2 width="*"  style="padding:0px">
	<IFRAME name=contentframe id=contentframe src="" width="100%" height="100%" frameborder=no scrolling=yes>
	<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
	</td>
	</tr>
	  </TBODY>
	</TABLE>
</body>
</html>