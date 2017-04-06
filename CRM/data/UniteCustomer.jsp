<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(136,user.getLanguage()) + SystemEnv.getHtmlLabelName(216,user.getLanguage());
String needfav ="1";
String needhelp ="";
String CustomerID=Util.null2String(request.getParameter("CustomerID"));
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
String userid = ""+user.getUID();
%>
<BODY>
<%if(!isfromtab) {%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%} %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(216,user.getLanguage())+",javascript:doSave(),_top} " ;
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
	<%if(!isfromtab){ %>
		<TABLE class=Shadow>
		<%}else{ %>
		<TABLE width='100%'>
		<%} %>
		<tr>
		<td valign="top">

<FORM id=weaver action="/CRM/data/UniteCustomerOperation.jsp" method=post >
<input type="hidden" name="isfromtab" value="<%=isfromtab%>">
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="100%">
  <TBODY>
  <TR>
    <TD vAlign=top>
      <TABLE class=ViewForm>
      <COLGROUP>
  	<COL width="20%">
  	<COL width="80%">
        <TBODY>
        <TR>
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD>
	    </TR>
		 <TR>
          <TD>CRM(<%=SystemEnv.getHtmlLabelName(6074,user.getLanguage())%>)</TD>
          <TD class=Field>
              <INPUT type=hidden class="wuiBrowser" _required="yes" _displayText="<a href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=CustomerID%>'><%=CustomerInfoComInfo.getCustomerInfoname(CustomerID)%></a>" _displayTemplate="<A href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</A>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?crmManager=<%=userid%>" name="CustomerID" value="<%=CustomerID%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD>CRM(<%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%>)</TD>
          <TD class=Field>
			
			<input type=hidden name="crmids" class="wuiBrowser" _displayTemplate="<a href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</a>&nbsp"  _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?crmManager=<%=userid%>" _param="resourceids" _required="yes" >
		
		  </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        </TBODY></TABLE></TD>
    </TR></TBODY></TABLE>
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
<script language=javascript>
function doSave(){
    if (check_form(document.forms[0],"CustomerID,crmids") && confirm("<%=SystemEnv.getHtmlLabelName(15160,user.getLanguage())%>£¿")) {
        var sub = document.all("crmids").value;
        var main = document.all("CustomerID").value;

        var subStr = new String(sub);
        var result = "";
        var begin = subStr.indexOf(main);
        if (begin != -1) {
            result = subStr.substring(0, begin) + subStr.substring(begin+main.length, subStr.length);
            document.all("crmids").value = result;
        }

        document.forms[0].submit();
    }
}
</script>
<script language=vbs>
crmManager = "<%=userid%>"
sub onShowMCrm(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="&tmpids&"&crmManager="&crmManager)
		if (not isEmpty(id1)) then
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all(inputename).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href=/CRM/data/ViewCustomer.jsp?CustomerID="&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href=/CRM/data/ViewCustomer.jsp?CustomerID="&resourceids&">"&resourcename&"</a>&nbsp"
					document.all(spanname).innerHtml = sHtml

				else
					document.all(spanname).innerHtml ="<IMG src=/images/BacoError.gif align=absMiddle>"
					document.all(inputename).value=""
				end if
		end if
end sub

sub onShowCustomerID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?crmManager="&crmManager)
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	customerspan.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="&id(0)&"'>"&id(1)&"</A>"
	weaver.CustomerID.value=id(0)
	else
	customerspan.innerHtml = "<IMG src=/images/BacoError.gif align=absMiddle>"
	weaver.CustomerID.value=""
	end if
	end if
end sub
</script>
</BODY>
</HTML>
