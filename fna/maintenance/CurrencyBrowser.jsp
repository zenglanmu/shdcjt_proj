<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>

<%

String currencyname = Util.null2String(request.getParameter("currencyname"));
String currencydesc = Util.null2String(request.getParameter("currencydesc"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!currencyname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where currencyname like '%" + Util.fromScreen2(currencyname,7) +"%' ";
	}
	else 
		sqlwhere += " and currencyname like '%" + Util.fromScreen2(currencyname,7) +"%' ";
}
if(!currencydesc.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where currencydesc like '%" + Util.fromScreen2(currencydesc,7) +"%' ";
	}
	else
		sqlwhere += " and currencydesc like '%" + Util.fromScreen2(currencydesc,7) +"%' ";
}

String sqlstr = "select id,currencyname,currencydesc "+
			    "from FnaCurrency " + sqlwhere ;
if(ishead ==0) sqlstr += "where activable = '1' " ;
else sqlstr += " and activable = '1' " ;
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
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="CurrencyBrowser.jsp" method=post>
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
<BUTTON  class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON type="button" class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=ViewForm>
    <TR class=spacing style="height: 1px"> 
      <TD class=line1 colspan=4></TD>
    </TR>
    <TR> 
      <TD width=15%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
      <TD width=35% class=field> 
        <input class=inputstyle name=currencyname value="<%=currencyname%>">
      </TD>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
      <TD width=35% class=field> 
        <input class=inputstyle name=currencydesc value="<%=currencydesc%>">
      </TD>
    </TR>
    </table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
<TR class=DataHeader>
      <TH width=15%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
      <TH width=30%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TH>
      <TH width=55%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
      </tr><TR class=Line style="height: 1px"><TH colspan="4" ></TH></TR>
<%
int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String currencynames = Util.toScreen(RecordSet.getString("currencyname"),7);
	String currencydescs = Util.toScreen(RecordSet.getString("currencydesc"),7);
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
	<TD><A HREF=#><%=ids%></A></TD>
	<TD><%=currencynames%></TD>
	<TD><%=currencydescs%></TD>
</TR>
<%}
%>

</TABLE>
  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
</FORM>
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
	window.parent.returnValue = {id:"",name:""};
	window.parent.close()
}

</script>
</BODY></HTML>

