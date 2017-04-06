<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetS" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
char flag=2;

String CustomerID = Util.null2String(request.getParameter("CustomerID"));
if(CustomerID.equals("")){
	CustomerID="0";
}

String userId = String.valueOf(user.getUID());
String userType = user.getLogintype();

String crmId = CustomerID;

String sql = "" ;

if (RecordSet.getDBType().equals("oracle"))
	sql = " SELECT id, begindate, begintime, description, name " 
		+ " FROM WorkPlan WHERE id IN ( " 
	    + " SELECT DISTINCT a.id FROM WorkPlan a, WorkPlanShareDetail b "
        + " WHERE a.id = b.workid" 
		+ " AND (CONCAT(CONCAT(',',a.crmid),',')) LIKE '%," + crmId + ",%'"
		+ " AND b.usertype = " + userType + " AND b.userid = " + userId
		+ " AND a.type_n = '3')";
else if (RecordSet.getDBType().equals("db2"))
	sql = " SELECT id, begindate, begintime, description, name " 
		+ " FROM WorkPlan WHERE id IN ( " 
	    + " SELECT DISTINCT a.id FROM WorkPlan a, WorkPlanShareDetail b "
        + " WHERE a.id = b.workid" 
		+ " AND (CONCAT(CONCAT(',',a.crmid),',')) LIKE '%," + crmId + ",%'"
		+ " AND b.usertype = " + userType + " AND b.userid = " + userId
		+ " AND a.type_n = '3')";
else
	sql = "SELECT id, begindate , begintime, description, name " 
		+ " FROM WorkPlan WHERE id IN ( " 
	    + " SELECT DISTINCT a.id FROM WorkPlan a,  WorkPlanShareDetail b WHERE a.id = b.workid" 
		+ " AND (',' + a.crmid + ',') LIKE '%," + crmId + ",%'" 
		+ " AND b.usertype = " + userType + " AND b.userid = " + userId
		+ " AND a.type_n = '3')";

sql += " ORDER BY begindate DESC, begintime DESC";

RecordSet.executeSql(sql);

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

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="LgcProductBrowser.jsp" method=post>
  <input type="hidden" name="pagenum" value=''>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onclear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=2 id=btnclear onclick="onclear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>

<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 width="100%">
<colgroup>
<col width="30%">
<col width="*">
<col width="20%">
<TR class=DataHeader>
	<TH width=0% style="display:none"></TH>
	<TH><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TH>
	<th><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></th>
	<th><%=SystemEnv.getHtmlLabelName(621,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></th>
</tr><TR class=Line style="height: 1px"><TH colSpan=4></TH></TR>
<%

int i=0;
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
	<TD style="display:none"><A HREF=#><%=RecordSet.getString("id")%></A></TD>
	<TD><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%></TD>
	<TD><%=Util.toScreen(RecordSet.getString("description"),user.getLanguage())%></TD>
	<TD><%=RecordSet.getString("begindate")%> <%=RecordSet.getString("begintime")%></TD>
</TR>
<%}%>
</TABLE>
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
function onclear(){
     window.parent.returnValue = {id:"",name:""}
     window.parent.close()
}
</script>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>        
</BODY></HTML>


