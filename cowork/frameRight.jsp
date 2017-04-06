<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<%
String creater=Util.null2String(request.getParameter("creater"));//xiaofeng
String maintypeid = Util.null2String(request.getParameter("maintypeid"));
int isworkflow = Util.getIntValue(Util.null2String(request.getParameter("isworkflow")),0);
String typeid=Util.null2String(request.getParameter("typeid"));
String id=Util.null2String(request.getParameter("id"));
int docid=Util.getIntValue(Util.null2String(request.getParameter("docid")),0);//TD5067，从协作区创建文档返回的文档ID

%>
<html>
<head>
	<link rel="stylesheet" href="/css/Weaver.css" type="text/css">
</head>

<body>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width="100%" height="100%">
	<tr height=100% >
	<td width="2" align=left valign=middle>
    <IMG id=LeftHideShow name=LeftHideShow title=<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%> style="CURSOR: hand"  src="/cowork/images/show.gif" width=6 onclick=mnToggleleft()>
    </td>
	<td id=oTd2 name=oTd2 width=98%>
        <%if(creater.equals("")){
        %>
    <IFRAME name=HomePageIframe2 id=HomePageIframe2 src="ViewCoWork.jsp?maintypeid=<%=maintypeid%>&isworkflow=<%=isworkflow%>&typeid=<%=typeid%>&id=<%=id%>&docid=<%=docid%>" width="100%" height="100%" frameborder=no scrolling=yes>
	浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
        <%}else{%>
    <IFRAME name=HomePageIframe2 id=HomePageIframe2 src="SearchCowork.jsp" width="100%" height="100%" frameborder=no scrolling=yes>
	浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
        <%}%>
    </td>
	</tr>
</table>
</body>
<SCRIPT language=javascript>
function mnToggleleft(){
	with(window.parent.document.getElementById("frameBottom")){
		if(cols == '0,100%'){
			cols = '50%,50%';
			window.document.getElementById("LeftHideShow").src = "/cowork/images/show.gif";
			window.document.getElementById("LeftHideShow").title = '<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>'
		}else{
			cols = '0,100%';
			window.document.getElementById("LeftHideShow").src = "/cowork/images/hide.gif";
			window.document.getElementById("LeftHideShow").title = '<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>'
		}
	}
}

</SCRIPT>
</html>