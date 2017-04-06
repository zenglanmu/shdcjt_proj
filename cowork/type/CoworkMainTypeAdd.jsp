<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="CoMainTypeComInfo" class="weaver.cowork.CoMainTypeComInfo" scope="page"/>
<%

if(! HrmUserVarify.checkUserRight("collaborationtype:edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
<SCRIPT language="javascript" src="../../js/jquery/jquery.js"></script>

</head>
<%

String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(178,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;
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
			
<FORM id=weaver name=frmMain action="MainTypeOperation.jsp" method=post>

  <TABLE class=ViewForm width="100%">
    <TBODY>
    <TR class=title> 
      <TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></TH>
      </TR>
        <TR class=spacing style="height: 1px;">
          <TD class=line1 colSpan=2></TD></TR>
        <TR>
    <TR vAlign=top width=100%> 
      <TD width=100%> 
        <TABLE class=ViewForm width="100%">
          <COLGROUP> <COL width="30%"> <COL width="70%"> <TBODY> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
            <TD class=FIELD><nobr> 
              <INPUT class=inputstyle type=text maxLength=60 size=25 name=name id=coworkname onchange='checkinput("name","nameimage")'>
              <SPAN id=nameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
          </TR>      
          <TR style="height: 1px;"><TD class=Line colspan=2></TD></TR> 
          <tr>
	            <td><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(92,user.getLanguage())%></td>
	            <td class=field>
	                <BUTTON class=Browser onClick="onShowCatalog(mypathspan)" name=selectCategory type="button"></BUTTON>
	                <span id="mypathspan" name="mypathspan"></span>
	                <input type=hidden id='mypath' name='mypath' value="">
	            </td>
	        </tr>
          <TR style="height: 1px;"><TD class=Line colspan=2></TD></TR> 
  </TABLE>
   <input type=hidden name=operation value="add">
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

function doSubmit() {
		var coworkname = $("#coworkname").val();				
		$.post("/cowork/type/CoworkMainTypeCheck.jsp",{coworkname:encodeURIComponent($("#coworkname").val())},function(datas){  
				 if(datas.indexOf("unfind") > 0 && check_form(frmMain,"name")){
						frmMain.submit();
				 } else if (datas.indexOf("exist") > 0){				 	  
				 	  alert("<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%> [ "+coworkname+" ] <%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>");
				 }
		});
}

function onShowCatalog(spanName) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp");
    if (result != null) {
        if (wuiUtil.getJsonValueByIndex(result,0)> 0){
          spanName.innerHTML=wuiUtil.getJsonValueByIndex(result,2);
          document.all("mypath").value=wuiUtil.getJsonValueByIndex(result,3)+","+wuiUtil.getJsonValueByIndex(result,4)+","+wuiUtil.getJsonValueByIndex(result,1);
        }else{
          spanName.innerHTML="";
          document.all("mypath").value="";
        }
    }
}
</script>


<script language=vbs>
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&weaver.departmentid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	departmentidspan.innerHtml = id(1)
	weaver.departmentid.value=id(0)
	else
	departmentidspan.innerHtml = "<IMG src=/images/BacoError.gif align=absMiddle>"
	weaver.departmentid.value=""
	end if
	end if
end sub

 sub onShowAssistantID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	    resourceids = id(0)
		resourcename = id(1)
		sHtml = ""
		resourceids = Mid(resourceids,2,len(resourceids))
		resourcename = Mid(resourcename,2,len(resourcename))
		weaver.managerid.value= resourceids
		while InStr(resourceids,",") <> 0
			curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			sHtml = sHtml&curname&"&nbsp"
		wend
		sHtml = sHtml&resourcename&"&nbsp"
		assistantidspan.innerHtml = sHtml
	else	
    	assistantidspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
    	weaver.managerid.value=""
	end if
	end if
	
end sub

sub onShowMemberID()

	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	    resourceids = id(0)
		resourcename = id(1)
		sHtml = ""
		resourceids = Mid(resourceids,2,len(resourceids))
		resourcename = Mid(resourcename,2,len(resourcename))
		weaver.members.value= resourceids
		while InStr(resourceids,",") <> 0
			curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			sHtml = sHtml&curname&"&nbsp"
		wend
		sHtml = sHtml&resourcename&"&nbsp"
		membersspan.innerHtml = sHtml
	else	
    	membersspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
    	weaver.members.value=""
	end if
	end if
end sub

</script >

</BODY></HTML>

