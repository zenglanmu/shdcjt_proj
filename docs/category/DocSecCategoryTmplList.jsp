<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(67,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(19456,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
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

<TABLE class=ListStyle cellspacing=1 >
  <colgroup>
  <col width="10%">
  <col width="35%">
  <col width="*">
  <col width="10%">
  </colgroup>
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(19996,user.getLanguage())%></th>
  <th>&nbsp</th>
  </tr>
  <TR class=Line><TD colSpan=4 style="padding: 0"></TD></TR>
<%
int i=0;
RecordSet.executeSql(" select * from DocSecCategoryTemplate order by id ");
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
	<TD><%=id%></TD>
	<TD><%=name%></TD>
	<TD><%=MainCategoryComInfo.getMainCategoryname(SubCategoryComInfo.getMainCategoryid(SecCategoryComInfo.getSubCategoryid(fromdir+"")))%>/<%=SubCategoryComInfo.getSubCategoryname(SecCategoryComInfo.getSubCategoryid(fromdir+""))%>/<%=SecCategoryComInfo.getSecCategoryname(fromdir+"")%></TD>
	<TD><a href="#" onClick="onDelete(<%=id%>);"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a></TD>
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
</BODY>
<script type="text/javascript">
function onDelete(id){
	if(window.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
		location.href="/docs/category/DocSecCategorySaveAsTmplOperation.jsp?tmplId="+id+"&method=deletetmpl";
	}
}
</script>
</HTML>