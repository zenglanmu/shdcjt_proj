<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%
boolean cansave=HrmUserVarify.checkUserRight("CustomGroup:Edit", user);
    		
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%

int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(17617,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";

int groupid = Util.getIntValue(request.getParameter("groupid"));

if(groupid!=0)
titlename = SystemEnv.getHtmlLabelName(17617,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());
int ownerid = user.getUID();

String name = Util.null2String(request.getParameter("name"));
String type = Util.null2String(request.getParameter("type"));
String hrmids = Util.null2String(request.getParameter("hrmids"));
String hrmnames = Util.null2String(request.getParameter("hrmnames"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver name=frmMain action="GroupOperation.jsp" method=post >
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3">



</td>
</tr>


<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">



<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <%
if(msgid!=-1){
%>
<DIV>
<FONT color="red" size="2">
<%=SystemEnv.getHtmlLabelName(msgid,user.getLanguage())%>
</FONT>
</DIV>
<%}%>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(17617,user.getLanguage())%></TH></TR>
  <TR class= Spacing style="height: 1px;">
    <TD class=Line1 colSpan=2 ></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle type=text size=30 name="name" value="<%=name%>" onchange='checkinput("name","nameimage")'>
          <SPAN id=nameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
           <script>
          checkinput("name","nameimage")
          </script>
        </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR>
        <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
        <%if(cansave){if(!type.equals("1")){%>
          <TD class=Field><select name="type">
                         <option value=0 <%if(type.equals("0")){%>selected<%}%>>私人组</option>
                         <option value=1 <%if(type.equals("1")){%>selected<%}%>>公共组</option>
                         </select>
         </TD>
         <%}else{%>
         <TD class=Field><select name="type0" disabled>
                         <option value=0 >私人组</option>
                         <option value=1 selected>公共组</option>
                         </select>
         <input class=inputstyle type="hidden" name=type value="1">
         </TD>
         <%}}else{%>

         <TD class=Field><select name="type0" disabled>
                         <option value=0 selected>私人组</option>
                         <option value=1>公共组</option>
                         </select>
         <input class=inputstyle type="hidden" name=type value="0">
         </TD>
         <%}%>
        </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></TD>
          <TD class=Field> 
            <input class="wuiBrowser" name="hrmids" type="hidden"  value="<%=hrmids%>"
             _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?groupid=<%=groupid%>"
             _displayText="<%=hrmnames%>"  _required="yes"
            >
            <!--
			<button class=Browser onclick="showHrmMultiBrowser('hrmidsspan','hrmids')"></button>
			<span id="hrmidsspan"><%=hrmnames%> <%if (hrmnames.equals("") ){%><img src="/images/BacoError.gif" align=absmiddle><%}%> </span>
		    -->
		  </TD>
        </TR>
        <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR> 
        <input class=inputstyle type="hidden" name=groupid value="<%=groupid%>">
		<input class=inputstyle type="hidden" name=ownerid value="<%=ownerid%>">
        <input class=inputstyle type="hidden" name=operation value=addgroup>
        <input  name="hrmnames"  type="hidden"  value="<%=hrmnames%>">
 </TBODY></TABLE>

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
<script language=javascript>
function submitData() {
 if(check_form(frmMain,'name,hrmids')){
 frmMain.submit();
 }
}

</script>

<script language=vbs>
sub showHrmMultiBrowser1(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?groupid=<%=groupid%>")
		    if (Not IsEmpty(id1)) then
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
						sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&resourceids&">"&resourcename&"</a>&nbsp"
					document.all(spanname).innerHtml = sHtml

				else
					document.all(spanname).innerHtml ="<img src='/images/BacoError.gif' align=absmiddle>"
					document.all(inputename).value=""
				end if
			end if
end sub
</script>
</BODY>
</HTML>