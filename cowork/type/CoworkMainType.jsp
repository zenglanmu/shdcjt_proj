<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<HTML><HEAD>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />

<jsp:useBean id="CoMainTypeComInfo" class="weaver.cowork.CoMainTypeComInfo" scope="page"/>
	
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%

if(! HrmUserVarify.checkUserRight("collaborationtype:edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

%>
<%
String imagefilename = "/images/hdHRM.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(178,user.getLanguage());
String needfav ="1";
String needhelp ="";

String sql="select * from cowork_maintypes ";
RecordSet.executeSql(sql);

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",CoworkMainTypeAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

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
			
			<TABLE class="Shadow">
			<tr>
			<td valign="top">
			
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COLS width="40">
  <COLS width="60">
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>    
    <TH><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(92,user.getLanguage())%></TH>
  </TR>
<%
    
    int needchange = 0;
    while(RecordSet.next()){
        String category = Util.null2String(RecordSet.getString("category"));
        String categorypath = "";
        if(!category.equals("")){
            String[] categoryArr = Util.TokenizerString2(category,",");
            categorypath += "/"+MainCategoryComInfo.getMainCategoryname(categoryArr[0]);
            categorypath += "/"+SubCategoryComInfo.getSubCategoryname(categoryArr[1]);
            categorypath += "/"+SecCategoryComInfo.getSecCategoryname(categoryArr[2]);
        }     
       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <%  	}%>
    <TD><a href="CoworkMainTypeEdit.jsp?id=<%=RecordSet.getString("id")%>"><%=RecordSet.getString("typename")%></a></TD>
    <TD><%=categorypath%></TD>
  </TR>

<%}%>
 </TBODY></TABLE>
 <BR>

			
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


</BODY></HTML>
