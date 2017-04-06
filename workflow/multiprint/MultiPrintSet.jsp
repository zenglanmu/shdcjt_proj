<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<body>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="showNodeAttrOperate.jsp" method="post">
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

		    <TABLE class="viewform">
		    <COLGROUP>
		    <COL width="50%">
		    <COL width="50%">
            <TR class="Title">
		        <TH colSpan=2><%=SystemEnv.getHtmlLabelName(20756,user.getLanguage())%></TH>
		    </TR>
		    <TR class="Spacing">
		        <TD class="Line1" colSpan=2></TD>
		    </TR>
		    <TR>
			    <TD><%=SystemEnv.getHtmlLabelName(27208,user.getLanguage())%></TD>
			    <TD class=Field>
				<select id="nPrintOrient" name="nPrintOrient">
					<option value="1" selected><%=SystemEnv.getHtmlLabelName(19073,user.getLanguage())%></option>
					<option value="2"><%=SystemEnv.getHtmlLabelName(19072,user.getLanguage())%></option>
				</select>
				</TD>
		    </TR>
		    <TR class="Spacing">
		        <TD class="Line" colSpan=2></TD>
		    </TR>
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


</form>

</body>
</html>
<script language=javascript>
function onSave(){
	window.parent.returnValue = document.getElementById("nPrintOrient").value;
	window.parent.close();
}
function onClose(){
	window.parent.close();
}

</script>
