<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<% if(!HrmUserVarify.checkUserRight("CrmProduct:Add",user)) {
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
RecordSet.executeProc("LgcAssetAssortment_SSupAssort",supassortmentid);
RecordSet.next();
supassortmentstr = Util.null2String(RecordSet.getString(1))+supassortmentid+"|" ;
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(178,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
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

<FORM id=frmain name=frmain action=LgcAssortmentOperation.jsp method=post enctype="multipart/form-data" onSubmit='return  check_form(this,"assortmentname")'>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<DIV style="display:none"><BUTTON class=btnSave id=mysave accessKey=S type=submit><U>S</U>-±£´æ</BUTTON></DIV>
<input type="hidden" name="supassortmentid" value="<%=supassortmentid%>">
<input type="hidden" name="supassortmentstr" value="<%=supassortmentstr%>">
<input type="hidden" name="operation" value="addassortment">
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="49%">
  <COL width=10>
  <COL width="49%">
  <TBODY>
  <TR>
    <TD vAlign=top><!-- General -->
        <TABLE class=ViewForm>
          <COLGROUP> <COL width=130> <TBODY> 
           <TR class=Spacing style='height:1px'> 
            <TD class=Line1 colSpan=2></TD>
          </TR>

          <TR> 
		    <td>Ãû³Æ</td>
            <td class=FIELD>
			<input class=InputStyle  accesskey=Z name=assortmentname size="30" onChange='checkinput("assortmentname","assortmentnameimage")'>
			<span id=assortmentnameimage><img src="/images/BacoError.gif" align=absMiddle></span> </td>
          </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>

        </TABLE>
      </TD>
    <TD></TD>
      <TD vAlign=top>
        <table class=ViewForm>
          <colgroup> <col width=130> <tbody> 
           <TR class=Spacing style='height:1px'> 
            <td class=Line1 colspan=2></td>
          </tr>
          <tr> 
            <td>Í¼Æ¬</td>
            <td class=Field> 
              <input class=InputStyle  type="file" name=assortmentimage>
            </td>
          </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
          </tbody> 
        </table>
      </TD>
    </TR></TBODY></TABLE>
  <TABLE class=ViewForm>
    <COLGROUP> <COL width="49%"> <COL width=10> <COL width="49%"> <TBODY> 
    <TR class=Title> 
      <TH>±¸×¢</TH>
    </TR>
     <TR class=Spacing style='height:1px'> 
      <TD class=Line1></TD>
    </TR>
    <TR> 
      <TD vAlign=top> 
        <TEXTAREA class=InputStyle style="WIDTH: 100%" name=Remark rows=8></TEXTAREA>
      </TD>
    </TR><tr style="height: 1px"><td class=Line colspan=1></td></tr>
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script type="text/javascript">
function doSave(){
	if(check_form(frmain,"assortmentname")){
		document.frmain.submit();
	}

}
</script>
<script language=vbs>

sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmain.resourceid.value=id(0)
	else 
	resourceidspan.innerHtml = ""
	frmain.resourceid.value=""
	end if
	end if
end sub

</script>
</BODY></HTML>
