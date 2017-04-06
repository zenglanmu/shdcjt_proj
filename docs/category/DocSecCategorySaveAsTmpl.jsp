<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
<script src="/js/prototype.js" type="text/javascript"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(86,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(64,user.getLanguage());
String needfav ="1";
String needhelp ="";

int id = Util.getIntValue(request.getParameter("id"),0);
int msgid = Util.getIntValue(request.getParameter("msgid"),0);
String name = Util.null2String(request.getParameter("name"));

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onBack(this),_top} " ;
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
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
		
			<%
			if(msgid>0){
			%>
			<font color=red><%=SystemEnv.getHtmlLabelName(msgid,user.getLanguage()) %></font>
			<%} %>
		
			<FORM id=weaver name=weaver action="DocSecCategorySaveAsTmplOperation.jsp" method=post>
			<input type=hidden name="method" value="saveastmpl">
			<input type=hidden name="secCategoryId" value="<%=id%>">


				<TABLE class=ViewForm>
				<COLGROUP>
				<COL width="30%">
				<COL width="*">
				</COLGROUP>
				<TBODY>
				<TR>
					<TD><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></TD>
					<TD class=Field>
					<INPUT class=InputStyle maxLength=30 size=30 name=name onChange="checkinput('name','namespan')" value="<%=name%>">
					<span id=namespan><%if("".equals(name)){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></span>
					</TD>
				</TR>
				<TR class=Spacing style="height: 1px!important;">
					<TD class=Line colSpan=2></TD>
				</TR>
				<TR>
					<TD><%=SystemEnv.getHtmlLabelName(19996,user.getLanguage())%></TD>
					<TD class=Field>
					<INPUT type=hidden name="fromdir" value="<%=id%>">
					<a href="DocSecCategoryEdit.jsp?id=<%=id%>"><%=SecCategoryComInfo.getSecCategoryname(id+"")%></a>
					</TD>
				</TR>
				<TR class=Spacing style="height: 1px!important;">
					<TD class=Line colSpan=2></TD>
				</TR>
				</TBODY>
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
function onSave(obj){
	obj.disabled = true;
	if(check_form(document.weaver,'name')){
		document.weaver.submit();
	}
}
function onBack(obj){
	history.back();
}
</script>

</BODY>
</HTML>