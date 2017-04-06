<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String fullname = Util.null2String(request.getParameter("fullname"));
String description = Util.null2String(request.getParameter("description"));
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!fullname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where typename like '%";
		sqlwhere += Util.fromScreen2(fullname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and typename like '%";
		sqlwhere += Util.fromScreen2(fullname,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!description.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where typedesc like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and typedesc like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
}
%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(89,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:onReset(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>


<FORM NAME=SearchForm STYLE="margin-bottom:0" action="WorkTypeBrowser.jsp" method=post>
<input type=hidden name=sqlwhere value="<%=sqlwhere1%>">
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
	<td valign="top" width="100%">
		<TABLE class=Shadow width="100%">
		<tr>
		<td valign="top">


<table width=100% class="viewform">
<TR class="Spacing"  style="height:1px;"><TD class="Line1" colspan=4></TD></TR>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
<TD width=35% class=field><input class=Inputstyle name=fullname value="<%=fullname%>"></TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
<TD width=35% class=field><input  class=Inputstyle name=description value="<%=description%>"></TD>
</TR>
<TR class="Spacing"  style="height:1px;"><TD class="Line1" colspan=4></TD></TR>
</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" width="100%">
<TR class=DataHeader>
<TH width=30%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH></tr>
<TR class=Line style="height:1px;"><Th colspan="3" ></Th></TR>  
<%
int i=0;
sqlwhere = "select * from workflow_type "+sqlwhere+" order by id";
RecordSet.execute(sqlwhere);
while(RecordSet.next()){
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
	<TD><A HREF=#><%=RecordSet.getString(1)%></A></TD>
	<TD><%=RecordSet.getString(2)%></TD>
	<TD><%=RecordSet.getString(3)%></TD>
	
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

</FORM></BODY></HTML>
<script tyep="text/javascript">

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
			
		window.parent.returnValue = {
			id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
			window.parent.close()
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})

})

function submitClear() {
	window.parent.returnValue = {id:"0", name:""};
	window.parent.close()
}
</script>

<script language="javascript">
function submitData()
{
	btnok_onclick();
}

function onSubmit() {
		$G("SearchForm").submit()
	}
	function onReset() {
		$G("SearchForm").reset()
	}
</script>