<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />

<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String sqlstr="select  t1.id,t1.lastname,t1.jobtitle,t1.departmentid from HrmResource t1 "+ sqlwhere+" and t1.status in (0,1,2,3) and t1.loginid<>' '";
%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM NAME=SearchForm  action="#" method=post>
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
	
<TABLE ID=BrowseTable class="BroswerStyle" cellspacing="1" width="100%" >
<TR class=DataHeader>
      <TH ><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TH>      
      <TH ><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TH>      
	  <TH ><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%></TH>
 </tr>
	  <TR class=Line style="height:1px "><Th colspan="5" ></Th></TR> 
    <%RecordSet.executeSql(sqlstr);
	int i=0;
	     while(RecordSet.next()){
			 rs.executeSql("select jobtitlename from hrmjobtitles where id="+RecordSet.getInt("jobtitle"));
			 rs.last();
             rs1.executeSql("select departmentname from hrmdepartment where id="+RecordSet.getInt("departmentid"));
			 rs1.last();
			 if(i==0){
				 i=1;
	%> 
         <tr class=DataLight>
<%}else{  i=0;  %> 
         <tr class=DataDark>
   <%}%> 
             <TD style="display:none"><A HREF="#"><%=RecordSet.getInt("id")%></A></TD>
		    <td><%=RecordSet.getString("lastname")%></td>
			<td><%=rs.getString("jobtitlename")%></td>
			<td><%=rs1.getString("departmentname")%></td>
		</tr>
		</a>
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
</BODY>
</HTML>
<script language="javascript">



jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
		 var id0  = $(this).find("td:first").next().text();
	   
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
