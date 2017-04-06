<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>

<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
String doctype = request.getParameter("doctype");
if(doctype!=null&&"".equals(doctype)) doctype = "0";
else if(doctype!=null&&!"".equals(doctype)){
	if(doctype.equals(".htm")) doctype = "0";
	else if(doctype.equals(".doc")) doctype = "2";
	else if(doctype.equals(".xls")) doctype = "3";
	else if(doctype.equals(".wps")) doctype = "4";
}
%>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">



<FORM NAME=SearchForm STYLE="margin-bottom:0;margin-right:0">
<br>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=C onclick="window.close()"><U>C</U>-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=L id=btnclear><U>L</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=ViewForm>
<TR class=Spacing style="height: 1px!important;">
<TD class=Line1></TD>
</TR>
</table>

<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 width=100%>
<TR class=DataHeader>
<TH><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<TH><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
</tr><TR class=Line style="height: 1px!important;"><TH colSpan=2></TH></TR>
<%
int i=0;
while(DocMouldComInfo.next()){
	
	String currentDocType = DocMouldComInfo.getDocMouldType();
	if(currentDocType==null||"".equals(currentDocType)||Util.getIntValue(currentDocType,0)<0) currentDocType = "0";
	
	if(doctype!=null&&!currentDocType.equals(doctype)) continue;
	
	if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
	<%
	}
	%>
	<TD><A HREF=#><%=DocMouldComInfo.getDocMouldid()%></A></TD>
	<TD><%=DocMouldComInfo.getDocMouldname()%></TD>
</TR>
<%}%>

</TABLE></FORM>

		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script type="text/javascript">

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr").bind("click",function(){
			
			window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
			window.parent.close()
		})
	jQuery("#BrowseTable").find("tr").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})

})
function submitClear()
{
	window.parent.returnValue = {id:"",name:""};
	window.parent.close()
}
</script>
</BODY></HTML>
