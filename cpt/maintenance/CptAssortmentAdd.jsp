<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<% if(!HrmUserVarify.checkUserRight("CptCapitalGroupAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String paraid = Util.null2String(request.getParameter("paraid")) ;
String supassortmentid = "" ;
String supassortmentstr ="" ;
if(paraid.equals("")) {
	supassortmentid="0";
	supassortmentstr = "0|" ;
}
else {
supassortmentid=paraid;
RecordSet.executeProc("CptCapitalAssortment_SSupAssor",supassortmentid);
RecordSet.next();
supassortmentstr = Util.null2String(RecordSet.getString(1))+supassortmentid+"|" ;
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(831,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(365,user.getLanguage());
if(msgid!=-1)
titlename += "<font color=red size=2>" + SystemEnv.getErrorMsgName(msgid,user.getLanguage()) + "</font>" ;

String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),mainFrame} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=frmain action=CptAssortmentOperation.jsp method=post >
<input type="hidden" name="supassortmentid" value="<%=supassortmentid%>">
<input type="hidden" name="supassortmentstr" value="<%=supassortmentstr%>">
<input type="hidden" name="operation" value="addassortment">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
		<TABLE class=ViewForm>
		  <TBODY>
		  <TR>
			<TD vAlign=top><!-- General -->
				<TABLE class=ViewForm>
				  <COLGROUP> <COL width=130> <TBODY> 
				  <TR class=Title> 
					<TH colSpan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
				  </TR>
				  <TR class=Spacing style="height:2px"> 
					<TD class=Line1 colSpan=2></TD>
				  </TR>
				  <TR> 
					<td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
					<td class=FIELD>
					<input accesskey=Z name=assortmentname size="30" onChange='checkinput("assortmentname","assortmentnameimage")' class="InputStyle">
					<span id=assortmentnameimage><img src="/images/BacoError.gif" align=absMiddle></span> </td>
				  </TR>
				  <TR style="height:1px"> 
						<TD class=Line colSpan=2></TD>
				  </TR>
				  <TR> 
					<td><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
					<td class=FIELD>
					<input accesskey=Z name=assortmentmark size="30" onChange='checkinput("assortmentmark","assortmentmarkimage")'  class="InputStyle">
					<span id=assortmentmarkimage><img src="/images/BacoError.gif" align=absMiddle ></span> </td>
				  </TR>
				  <TR style="height:1px"> 
						<TD class=Line colSpan=2></TD>
				  </TR>
				  <!--<TR><TD>Group</TD><TD class=Field></TD></TR> -->
				  </TBODY> 
				</TABLE>
			  </TD>
			</TR></TBODY></TABLE>
		  <TABLE class=ViewForm>
			<TBODY> 
			<TR class=Title> 
			  <TH><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
			</TR>
			<TR class=Spacing style="height:2px"> 
			  <TD class=Line1></TD>
			</TR>
			<TR> 
			  <TD vAlign=top> 
				<TEXTAREA class=InputStyle style="WIDTH: 100%" name=Remark rows=8></TEXTAREA>
			  </TD>
			</TR>
			</TBODY> 
		  </TABLE>
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr  style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
</table>
</FORM>
<script language="javascript">
function submitData()
{
	if (check_form(frmain,'assortmentname,assortmentmark'))
		frmain.submit();
}
</script>

</BODY></HTML>
