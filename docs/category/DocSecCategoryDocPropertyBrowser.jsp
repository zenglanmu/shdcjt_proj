<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.conn.RecordSet"%>

<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page"/>

<%@ include file="/systeminfo/init.jsp" %>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>

<BODY scroll='auto'>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:window.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>

<%
int secCategoryId = Util.getIntValue(request.getParameter("seccategory"));
String needDocumentCreator = Util.null2String(request.getParameter("needDocumentCreator"));//是否需要文档创建人  1：需要   其它：不需要
String needCurrentOperator = Util.null2String(request.getParameter("needCurrentOperator"));//是否需要当前操作者  1：需要   其它：不需要
%>

<FORM NAME=SearchForm STYLE="margin-bottom:0;margin-right:0">

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




<br>
<DIV align=right style="display:none">

<BUTTON type="button" class=btn accessKey=C onclick="window.close()"><U>C</U>-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%></BUTTON>

<BUTTON type="button" class=btn accessKey=L onclick="submitClear()" id=btnclear><U>L</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=ViewForm>
<TR class=Spacing>
<TD class=Line1></TD>
</TR>
</table>

<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 width=100%>
<TR class=DataHeader>
<TH><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<TH><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
</tr><TR class=Line><TH colSpan=2></TH></TR>
<%
int i=0;

if(needDocumentCreator.equals("1")){
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
	<TD><A HREF=#>-3</A></TD>
	<TD><%=SystemEnv.getHtmlLabelName(20558, user.getLanguage())%></TD>
</TR>
<%
}	
%>

<%

if(needCurrentOperator.equals("1")){
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
	<TD><A HREF=#>-2</A></TD>
	<TD><%=SystemEnv.getHtmlLabelName(18582, user.getLanguage())%></TD>
</TR>
<%
}	
%>


<%
SecCategoryDocPropertiesComInfo.addDefaultDocProperties(secCategoryId);
RecordSet rs = new RecordSet();
rs.executeSql("select * from DocSecCategoryDocProperty where secCategoryId =" + secCategoryId + "order by viewindex");

while(rs.next()){
	
	int id = rs.getInt("id");
	int labelId = rs.getInt("labelid");
	String customName = rs.getString("customname");
	int isCustom = rs.getInt("isCustom");
	
	String name = "";
	if(isCustom==1)
		name = customName;
	else
		if(customName!=null&&!"".equals(customName))
			name = customName;
		else
			name = SystemEnv.getHtmlLabelName(labelId, user.getLanguage());

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
	<TD><A HREF=#><%=id%></A></TD>
	<TD><%=name%></TD>
</TR>
<%}%>

</TABLE>

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
</FORM>
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

