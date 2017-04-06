<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String sname = Util.null2String(request.getParameter("name"));

%>
<BODY>


<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.reset(),_self} " ;
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

<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="DocSecCategoryTmplBrowser.jsp" method=post>

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



<table width=100% class="viewform">
<tr>
<TD ><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
<TD  class=field colspan=3><input class=Inputstyle name=name value="<%=sname%>"></TD>
</TR>
<TR class="Spacing" style="height: 1px!important;"><TD class="Line1" colspan=4></TD></TR>
</table>

<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" width="100%">
<TR class=DataHeader>
<TH width=10%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<TH width=35%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<TH width=45%><%=SystemEnv.getHtmlLabelName(19996,user.getLanguage())%></TH></tr>

<TR class=Line style="height: 1px!important;"><th colspan="3" ></Th></TR> 
<%
String sqlstr = " select * from DocSecCategoryTemplate ";
if(!"".equals(sname)){
    sqlstr += " where name like '%"+sname+"%'";
}
sqlstr += " order by id ";
int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
    int id = RecordSet.getInt("id");
    String name = RecordSet.getString("name");
    int fromdir = RecordSet.getInt("fromdir");
    
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
	<TD><%=MainCategoryComInfo.getMainCategoryname(SubCategoryComInfo.getMainCategoryid(SecCategoryComInfo.getSubCategoryid(fromdir+"")))%>/<%=SubCategoryComInfo.getSubCategoryname(SecCategoryComInfo.getSubCategoryid(fromdir+""))%>/<%=SecCategoryComInfo.getSecCategoryname(fromdir+"")%></TD>
	
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</FORM></BODY></HTML>



<script language="javascript">
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