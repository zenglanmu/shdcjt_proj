<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String locationname = Util.null2String(request.getParameter("locationname"));
String locationdesc = Util.null2String(request.getParameter("locationdesc"));
String address = Util.null2String(request.getParameter("address"));
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!locationname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where locationname like '%";
		sqlwhere += Util.fromScreen2(locationname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and locationname like '%";
		sqlwhere += Util.fromScreen2(locationname,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!locationdesc.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where locationdesc like '%";
		sqlwhere += Util.fromScreen2(locationdesc,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and locationdesc like '%";
		sqlwhere +=  Util.fromScreen2(locationdesc,user.getLanguage());
		sqlwhere += "%'";
	}
}if(!address.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where address1 like '%";
		sqlwhere +=  Util.fromScreen2(address,user.getLanguage());
		sqlwhere += "%' or address2 like '%";
		sqlwhere += Util.fromScreen2(address,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and (address1 like '%";
		sqlwhere += Util.fromScreen2(address,user.getLanguage());
		sqlwhere += "%' or address2 like '%";
		sqlwhere += Util.fromScreen2(address,user.getLanguage());
		sqlwhere += "%')";
	}
}
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
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
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="LocationBrowser.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="<%=sqlwhere1%>">
<DIV align=right style="display:none">

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=ViewForm>
<TR class=Spacing style="height: 1px"><TD class=Line1 colspan=4></TD></TR>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
<TD width=35% class=field><input class=inputstyle name=locationname value="<%=locationname%>"></TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
<TD width=35% class=field><input class=inputstyle name=locationdesc value="<%=locationdesc%>"></TD>
</TR>
<TR style="height: 1px"><TD class=Line colSpan=6></TD></TR> 
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%> 1</TD>
<TD colspan=3 class=field><input class=inputstyle name=address size=40 value="<%=address%>"></TD>
</TR>
</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
<TR class=DataHeader>
<TH width=25%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<TH width=25%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TH>
<TH width=25%><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TH>
<TH width=25%><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%> 1</TH>
</tr><TR class=Line style="height: 1px"><TH colspan="4" ></TH></TR>
<%
int i=0;
sqlwhere = "select * from HrmLocations "+sqlwhere +" order by showOrder asc ";
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
	<TD><%=(RecordSet.getString(4)).equals("")?RecordSet.getString(5):RecordSet.getString(4)%></TD>
	
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
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
			
		window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
			window.parent.close()
		})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})

})


function submitClear()
{
	window.parent.returnValue = {id:"0",name:""};
	window.parent.close()
}
</script>
</BODY></HTML>

