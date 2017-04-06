<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />
<jsp:useBean id="TrainResourceComInfo" class="weaver.hrm.train.TrainResourceComInfo" scope="page" />
<%
/*
if(!HrmUserVarify.checkUserRight("HrmTrainEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
*/
%>	
<html>
<%	
String trainid = request.getParameter("trainid");
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(678,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(6106,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/train/HrmTrainTest.jsp?trainid="+trainid+",_self} " ;
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

<FORM id=weaver name=frmMain action="TrainOtherOperation.jsp" method=post >
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(16143,user.getLanguage())%></TH></TR>
  <TR><TD class=Line1 colSpan=2></TD></TR>
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(15648,user.getLanguage())%> </td>
          <td class=Field>
	      <BUTTON class=Browser onClick="onShowResource(actor,actorspan)" onchange='checkinput("actor","actorspan")'>
	      </BUTTON> 
	      <span class=InputStyle id=actorspan><IMG src="/images/BacoError.gif" align=absMiddle>
	      </span> 
	      <INPUT class=InputStyle id=actor type=hidden name=actor>
	      </td>	   
        </tr> 
        <TR><TD class=Line colSpan=2></TD></TR>
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(15920,user.getLanguage())%></td>
          <td class=Field>
            <select class=InputStyle name=result>       
              <option value=0><%=SystemEnv.getHtmlLabelName(16130,user.getLanguage())%></option>
              <option value=1 selected><%=SystemEnv.getHtmlLabelName(16131,user.getLanguage())%></option>
              <option value=2><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%></option>
              <option value=3><%=SystemEnv.getHtmlLabelName(824,user.getLanguage())%></option>
            </select>
          </td>
        </tr> 
        <TR><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
          <td class=Field>
             <textarea class=InputStyle cols=50 rows=4 name=explain></textarea>      
          </td>
        </tr>     
        <TR><TD class=Line colSpan=2></TD></TR> 
  </TBODY>
</TABLE> 
<input class=InputStyle type="hidden" name=operation> 
<input class=InputStyle type=hidden name=trainid value=<%=trainid%>>
</form>
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

 <script language=vbs>
sub onShowResource(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	    resourceids = id(0)
		resourcename = id(1)
		sHtml = ""
		resourceids = Mid(resourceids,2,len(resourceids))
		resourcename = Mid(resourcename,2,len(resourcename))
		inputname.value= resourceids
		while InStr(resourceids,",") <> 0
			curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
		spanname.innerHtml = sHtml
	else	
    	spanname.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
    	inputname.value=""
	end if
	end if
end sub
</script>
<script language=javascript>
function dosave(){
  if(check_form(document.frmMain,'actor')){      
    document.frmMain.operation.value="addtest";
    document.frmMain.submit();
    }
  } 
 </script>
 
</BODY></HTML>
