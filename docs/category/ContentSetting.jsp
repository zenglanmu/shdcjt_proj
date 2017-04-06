<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,weaver.conn.RecordSet"%>
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />
<jsp:useBean id="MouldBookMarkComInfo" class="weaver.docs.bookmark.MouldBookMarkComInfo" scope="page" />
<jsp:useBean id="SecCategoryDocPropertiesComInfo" class="weaver.docs.category.SecCategoryDocPropertiesComInfo" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>
<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
int docSecCategoryMouldId = Util.getIntValue(request.getParameter("id"));
int secCategoryId = Util.getIntValue(request.getParameter("seccategory"));
int mouldId = Util.getIntValue(request.getParameter("mould"));
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


<FORM METHOD="POST" name="SearchForm" action="ContentSettingOperation.jsp">
<input type=hidden name="docSecCategoryMouldId" value="<%=docSecCategoryMouldId%>">
<input type=hidden name="seccategory" value="<%=secCategoryId%>">
<input type=hidden name="operation" value="save">
<br>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" onclick="onSubmit()" class=btn accessKey=L id=btnsave><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onBack(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type='button' class=btn accessKey=C onclick="window.close()"><U>C</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
</DIV>

<table width=100% class=ViewForm>
<colgroup>
<col width="35%">
<col width="*">
</colgroup>
<TR class=Title>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(19499,user.getLanguage())%></TH>
</TR>
<TR class=Spacing style="height: 1px!important;">
  <TD class=Line1 colSpan=2></TD>
</TR>
<TR>
  <TD><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></TD>
  <TD class=Field><%=DocMouldComInfo.getDocMouldname(""+mouldId)%></TD>
</TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
</table>

<p></p>

<TABLE class=BroswerStyle cellspacing=1 width=100%>
<colgroup>
<col width="35%">
<col width="*">
</colgroup>
<TR class=DataHeader>
<TH><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%></TH>
<TH><%=SystemEnv.getHtmlLabelName(19451,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></TH>
</tr><TR class=Line style="height: 1px!important;"><TH colSpan=2></TH></TR>
</table>

<table width=100% class=ViewForm>
<colgroup>
<col width="35%">
<col width="*">
</colgroup>
<%
RecordSet rs = new RecordSet();
RecordSet rs1 = new RecordSet();
//rs.executeSql("select * from mouldbookmark a left join DocSecCategoryMouldBookMark b on a.id = b.BookMarkId and b.docSecCategoryMouldId = "+docSecCategoryMouldId+" where a.mouldid = "+mouldId);
rs.executeSql("select * from mouldbookmark a left join DocSecCategoryMouldBookMark b on a.id = b.BookMarkId and b.docSecCategoryMouldId = "+docSecCategoryMouldId+" where a.mouldid = "+mouldId+" order by a.showOrder asc,a.id asc");
while(rs.next()){
	int bookMarkId = rs.getInt("id");
	String bookmarkName = MouldBookMarkComInfo.getMouldBookMarkName(""+bookMarkId);
	int docSecCategoryDocPropertyId = Util.getIntValue(rs.getString("DocSecCategoryDocPropertyId"),0);
	String docSecCategoryDocPropertyName = Util.null2String((Util.getIntValue(SecCategoryDocPropertiesComInfo.getIsCustom(docSecCategoryDocPropertyId+""))==1||(SecCategoryDocPropertiesComInfo.getCustomName(docSecCategoryDocPropertyId+"")!=null&&!"".equals(SecCategoryDocPropertiesComInfo.getCustomName(docSecCategoryDocPropertyId+""))))?SecCategoryDocPropertiesComInfo.getCustomName(docSecCategoryDocPropertyId+""):SystemEnv.getHtmlLabelName(Util.getIntValue(SecCategoryDocPropertiesComInfo.getLabelId(docSecCategoryDocPropertyId+"")), user.getLanguage()));
%>
<TR>
	<TD><%=bookmarkName%><input type=hidden name="bookMarkId" value="<%=bookMarkId%>"></TD>
	<TD class=Field>
		<!-- 
			<button class=browser onclick="onDocSecCategoryDocProperty(<%=secCategoryId%>,this);"></button> 
			<span id=selectdocSecCategoryDocPropertyId></span>
		-->
		
		<input type=hidden class="wuiBrowser" _displayText="<%=docSecCategoryDocPropertyName%>" _url="DocSecCategoryDocPropertyBrowser.jsp?seccategory=<%=secCategoryId %>" name="docSecCategoryDocPropertyId" value="<%=docSecCategoryDocPropertyId>0?""+docSecCategoryDocPropertyId:""%>">
	</TD>
</TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
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
</BODY></HTML>
<script type="text/javascript">

function onBack(){
	location.href="DocSecCategoryEdit.jsp?id=<%=secCategoryId%>&tab=4";
}
function onSubmit(){
	document.SearchForm.submit();
}
</script>


