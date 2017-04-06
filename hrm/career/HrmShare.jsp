<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<%
int applyid = Util.getIntValue(request.getParameter("applyid"),0);
String firstname="";
String lastname="";
String resourceid="";

RecordSet.executeProc("HrmCareerApply_SelectId",""+applyid);
if(RecordSet.next()){
firstname=RecordSet.getString("firstname");
lastname=RecordSet.getString("lastname");
}
//out.print("user.getUID():"+user.getUID());

%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(1932,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage())+
"-"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+
": <a href='HrmCareerApplyEdit.jsp?applyid="+applyid+"'>"+Util.toScreen(lastname,user.getLanguage())+Util.toScreen(firstname,user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
// firstname=Util.toScreen(firstname,user.getLanguage(),"0");
 //lastname=Util.toScreen(lastname,user.getLanguage(),"0");
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/career/HrmCareerApplyEdit.jsp?applyid="+applyid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM id=weaver name=weaver action="HrmShareOperation.jsp" method=post >
<input type="hidden" name="method" value="add">
<input type="hidden" name="applyid" value="<%=applyid%>">
<input type=hidden name="firstname" value="<%=firstname%>">
<input type=hidden name="lastname" value="<%=lastname%>">

	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
        <TBODY>

       <tr> 
      <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
      <td class=Field>

            <input class="wuiBrowser" id=resourceid type=hidden name=resourceid value="<%=resourceid%>"
			_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			_displayText="<%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%>">
          </td>
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
		</TBODY>
	  </TABLE>
	  
<!--默认共享-->
        <table class=Viewform>
          <colgroup> 
          <col width="30%"> 
          <col width="50%">
          <col width="20%">
          <tr class=title> 
            <th><%=SystemEnv.getHtmlLabelName(1932,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage())+
"-"+SystemEnv.getHtmlLabelName(119,user.getLanguage())%></th>
          <tr class=spacing style="height:2px"> 
            <td class=line1 colspan=3></td>
          </tr>
<%
	//查找已经添加的默认共享
	RecordSet.executeProc("HrmShare_SelectByApply",""+applyid);
	while(RecordSet.next()){%>
	        <TR>
	          <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("hrmid")),user.getLanguage())%>
			  </TD>
			  <TD class=Field align=right>
				<a href="HrmShareOperation.jsp?method=delete&resourceid=<%=RecordSet.getString("hrmid")%>&applyid=<%=applyid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
			  </TD>
	        </TR>
                    <%}%>
        </table>
      </TD></TR>
    </TBODY>
  </TABLE>
</form>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
<script language=javascript>  
function submitData() {
 if(check_form(weaver,"resourceid")){
 weaver.submit();
 }
}
</script>

<SCRIPT language=VBS>
sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	weaver.resourceid.value=id(0)
	else 
	resourceidspan.innerHtml = ""
	weaver.resourceid.value=""
	end if
	end if
end sub
</SCRIPT>
</BODY>
</HTML>