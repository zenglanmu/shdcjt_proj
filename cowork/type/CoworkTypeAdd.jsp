<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CoMainTypeComInfo" class="weaver.cowork.CoMainTypeComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%

if(! HrmUserVarify.checkUserRight("collaborationarea:edit", user)) { 
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
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17694,user.getLanguage());
String needfav ="1";
String needhelp ="";

int userid=user.getUID();
String logintype = user.getLogintype();
String hrmid = Util.null2String(request.getParameter("hrmid"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:back(),_self} " ;
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
			
<FORM id=weaver name=frmMain action="TypeOperation.jsp" method=post>

  <TABLE class=ViewForm width="100%">
    <TBODY>
    <TR class=Title> 
      <TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></TH>
      </TR>
      <TR class=spacing>
        <TD class=line1 colSpan=2></TD></TR>
      <TR>
    <TR vAlign=top width=100%> 
      <TD width=100%> 
        <TABLE class=ViewForm width="100%">
          <COLGROUP> <COL width="25%"> <COL width="75%"> <TBODY> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
            <TD class=FIELD><nobr> 
              <INPUT class=inputstyle type=text maxLength=60 size=25 name=name id=coworkname onchange='checkinput("name","nameimage")'>
              <SPAN id=nameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
          </TR>
          <TR><TD class=Line colspan=2></TD></TR> 
          <tr> <TD><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></TD>
            <TD class=FIELD>
            <select name=departmentid id=dpid>
            <%while(CoMainTypeComInfo.next()){%>
            <option value="<%=CoMainTypeComInfo.getCoMainTypeid()%>"><%=CoMainTypeComInfo.getCoMainTypename()%></option>
            <%}%>
            </select>
            </TD>
          </TR>   
          <TR><TD class=Line colspan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
    </TR>
          
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
		$.post("/cowork/type/CoworkTypeCheck.jsp",{coworkname:encodeURIComponent($("#coworkname").val()),departmentid:$("#dpid").val()},function(datas){  
				 if(datas.indexOf("unfind") > 0 && check_form(frmMain,'name,departmentid,managerid,members')){
						frmMain.submit();
				 } else if (datas.indexOf("exist") > 0){				 	  
				 	  alert("<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%> [ "+coworkname+" ] <%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>");
				 }
		});
}
function back()
{
	window.history.back(-1);
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
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+weaver.managerid.value)
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
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+weaver.members.value)
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

sub onShowResource(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&document.getElementById(inputname).value)
	if (Not IsEmpty(id)) then
		if (Len(id(0)) > 2000) then '500为表结构文档字段的长度
			result = msgbox("您选择的参与人数量太多，请重新选择！",48,"注意")
		elseif id(0)<> "" then
			sHtml = ""
			resourceids = Mid(id(0),2,len(id(0)))
			resourcename = Mid(id(1),2,len(id(1)))
			document.getElementById(inputname).value= resourceids

			while InStr(resourceids,",") <> 0
				curid = Mid(resourceids,1,InStr(resourceids,",")-1)
				curname = Mid(resourcename,1,InStr(resourcename,",")-1)
				resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
				resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
				sHtml = sHtml&"<a href='/hrm/resource/HrmResource.jsp?id="&curid&"'>"&curname&"</a>&nbsp"
			wend
			sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
			document.getElementById(spanname).innerHtml = sHtml
		else	
    		document.getElementById(spanname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
    		document.getElementById(inputname).value="0"
		end if
	end if
end sub

</script >

</BODY></HTML>

