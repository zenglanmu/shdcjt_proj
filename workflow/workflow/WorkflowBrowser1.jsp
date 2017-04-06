<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="WorkFlowTree" class="weaver.workflow.workflow.WorkFlowTree" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<style>
#divTree { overflow: scroll; height: 170; width: 100%; }
</style>
<script src="/js/tree.js"></script>

</HEAD>

<BODY>
<%
int uid=user.getUID();
int isTemplate=Util.getIntValue(Util.null2String(request.getParameter("isTemplate")),0);
List grouplist=WorkFlowTree.getWrokflowTree(user,isTemplate);

//System.out.println("nodes"+grouplist.size());
request.setAttribute("grouplist",grouplist);
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
%>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/workflow/workflow/WorkflowSelect.jsp" method=post target="frame2">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
		
<%
loadTopMenu = 0;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T style="display:none" id=btncancel><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
loadTopMenu = 0;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:SearchForm.btnclear.click(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=C style="display:none" id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>
	
<table width=100% class="ViewForm" valign="top">
	
	<!--######## Search Table Start########-->
	
	
	
	<TR>
	<td>
	<wea:tree nodes="grouplist"  titleproperty="title" expandall="true" style="cursor: hand"  />
	<td>
	</tr>
	
	
	</table>
  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
  <input class=inputstyle type="hidden" name="tabid" >
  <input class=inputstyle type="hidden" name="typeid" >
  <input class=inputstyle type="hidden" name="isTemplate">
	<!--########//Search Table End########-->
	</FORM>

<script language="javascript">
  
function setGroup(id){
    document.all("isTemplate").value=id
    document.all("tabid").value=1
    document.all("typeid").value=""
    document.SearchForm.submit();
}
function setWorkflowType(template,id){
    document.all("isTemplate").value=template
    document.all("typeid").value=id
    document.all("tabid").value=1
    document.SearchForm.submit();
}
</script>
 
<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub
</SCRIPT>
</BODY>
</HTML>