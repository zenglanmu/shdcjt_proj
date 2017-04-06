<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.io.*" %>
<%@page import="weaver.blog.BlogDao"%>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ include file="/hrm/resource/simpleHrmResource.jsp" %>
<jsp:useBean id="DocDsp" class="weaver.docs.docs.DocDsp" scope="page"/>
<%
BaseBean baseBeanRigthMenu = new BaseBean();

int userightmenu = 1;
try{
	userightmenu = Util.getIntValue(baseBeanRigthMenu.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}

BlogDao blogDao=new BlogDao();
String isOpenBlog=blogDao.getBlogStatus(); //是否启用微博模块 
%>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<LINK href="/FCKEditor/editor/css/fck_editorarea_docdsp.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/jquery/jquery.js"></script>
<%
  if(isOpenBlog.equals("1")){
%>
<!-- 微博便签 -->
<script type="text/javascript" src="/blog/js/notepad/notepad.js"></script>
<%} %>
<script type="text/javascript">
<!--
if (document.getElementById('FONT2SYSTEMF').href) {
	document.getElementById('FONT2SYSTEMF').href = "";
}
//-->
</script>
<style>
#spanContent A {
	COLOR: blue; TEXT-DECORATION: underline
}
#spanContent A:hover {
	COLOR: red; TEXT-DECORATION: underline
}

#spanContent A:link {
	COLOR: blue; TEXT-DECORATION: underline
}
#spanContent A:visited {
	TEXT-DECORATION: underline}
body{
	padding:0;
}	
</style>
<%
int docid=Util.getIntValue(request.getParameter("docid"),0);
int imagefileId=Util.getIntValue(request.getParameter("imagefileId"),0);
boolean isPDF = Util.getIntValue(request.getParameter("isPDF"),0)==1;
boolean canEdit = Util.getIntValue(request.getParameter("canEdit"),0)==1;
boolean canPrint = Util.getIntValue(request.getParameter("canPrint"),0)==1;
%>
<% if(isPDF){ %>
<%@ include file="iWebPDFConf.jsp" %>
<%
String temStr = request.getRequestURI();
temStr=temStr.substring(0,temStr.lastIndexOf("/")+1);

String mServerUrl=temStr+mServerName;
String mClientUrl=temStr+mClientName;

%>
<OBJECT id="WebPDF" width="100%" height="103%" classid="<%=mClassId%>" codebase="<%=mClientName%>" VIEWASTEXT style="POSITION:absolute;top:-23;filter='progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)';">
</object>
<script type="text/javascript">
<!--
$(document).ready(function(){
try{
	if(document.getElementById("WebPDF").Version){
	    //以下属性必须设置，实始化iWebPDF
	    document.getElementById("WebPDF").WebUrl="<%=mServerName%>";
	    document.getElementById("WebPDF").RecordID="<%=docid%>";
	    document.getElementById("WebPDF").FileName="<%=imagefileId%>";
	    document.getElementById("WebPDF").UserName="<%=user.getUID()%>";
	
	    document.getElementById("WebPDF").ShowTools = 0;
	    document.getElementById("WebPDF").ShowMenus = 0;
	    document.getElementById("WebPDF").ShowState = 1;
	    document.getElementById("WebPDF").ShowSides = 0;
	    document.getElementById("WebPDF").ShowMarks = 0;
	    document.getElementById("WebPDF").ShowTitle = 1;
	    document.getElementById("WebPDF").ShowBookMark = 0;
	    document.getElementById("WebPDF").ShowSigns = 0;
	    document.getElementById("WebPDF").AlterUser = 0;
		document.getElementById("WebPDF").PrnScreen = false;
	    document.getElementById("WebPDF").SaveRight = 0;
	
		<% if(canPrint){ %>
	    document.getElementById("WebPDF").PrintRight = 1;
	    <% } else { %>
	    document.getElementById("WebPDF").PrintRight = 0;
	    <% } %>
	    
	    document.getElementById("WebPDF").WebOpen();
	
		<% if(canEdit){ %>
	    document.getElementById("WebPDF").CursorState = 1;
	    <% } else { %>
	    document.getElementById("WebPDF").CursorState = 0;
	    <% } %>
	    
	    document.getElementById("WebPDF").Zoom = 100;
	    document.getElementById("WebPDF").Rotate = 360;
	    document.getElementById("WebPDF").CurPage = 1;
	    
	    document.body.scroll = "no";
	    document.oncontextmenu = function(){
	   		return false;
	    }
	} else {
		alert("<%=SystemEnv.getHtmlLabelName(25132,user.getLanguage())%>");
	}
}catch(e){
    //alert(e.description);
}
});
//-->
</script>
<% } else { %>
<table width="100%">
	<tr>
	<td>&nbsp;</td>
	<td>
		<span id="spanContent">
		<%
			if(docid!=0) {
				String str=(String)session.getAttribute("html_"+docid);
				out.println(str);
				int htmlcounter=Util.getIntValue((String)session.getAttribute("htmlcounter_"+docid),-1);
				if(htmlcounter<=1){
					session.removeAttribute("html_"+docid);
					session.removeAttribute("htmlcounter_"+docid);
				}else{
					htmlcounter--;
					session.setAttribute("htmlcounter_"+docid,""+htmlcounter);
				} 
			}
		%>
		</span>
	</td>
	</tr>
</table>
<% } %>
<script>
	<%if(userightmenu==1){%>
		document.oncontextmenu=showRightClickMenu;
		document.body.onclick=hideRightClickMenu;		
	<%}%>
	var rightMenu=parent.document.getElementById('rightMenu');
	function showRightClickMenu(e){	
			var event = e?e:(window.event?window.event:null);
			var loc=event.clientY+35;
			var rightedge=document.body.clientWidth-event.clientX
			var bottomedge=document.body.clientHeight-event.clientY
			if (rightedge<rightMenu.offsetWidth)
				rightMenu.style.left=event.clientX-rightMenu.offsetWidth
			else
				rightMenu.style.left=event.clientX
			if (bottomedge<rightMenu.offsetHeight)
				rightMenu.style.top=loc-rightMenu.offsetHeight;
			else
				rightMenu.style.top=loc;
				rightMenu.style.visibility="visible"
				rightMenu.style.display="";
				
			return false
	}
	
	function hideRightClickMenu(){		
			rightMenu.style.visibility="hidden"
			rightMenu.style.display="none";
			
	}

	$(document).ready(function(){
		$("a[target='_self']").attr("target","_blank")
<%
  if(isOpenBlog.equals("1")){
%>
		notepad('#spanContent');
<%} %>
	});

</script>