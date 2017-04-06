<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("HrmTrainLayoutAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6128,user.getLanguage());
String needfav ="1";
String needhelp ="";
String layoutassessor=Util.null2String(request.getParameter("layoutassessor"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmTrainLayoutAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/trainlayout/HrmTrainLayout.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
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

<FORM id=weaver name=frmMain action="TrainLayoutOperation.jsp" method=post >

<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6128,user.getLanguage())%></TH></TR>
  <TR class=spacing style="height:2px">
    <TD class=line1 colSpan=2 ></TD>
  </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=text size=30 name="layoutname" onchange='checkinput("layoutname","layoutnameimage")'>
          <SPAN id=layoutnameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>          
          </td>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6130,user.getLanguage())%></TD>
          <TD class=Field>
	    <INPUT class=wuiBrowser id=typeid type=hidden name=typeid onchange='checkinput("typeid","typeidspan")'
	    _url="/systeminfo/BrowserMain.jsp?url=/hrm/train/traintype/TrainTypeBrowser.jsp" _required=yes>  
          </TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
          <td class=Field>
            <BUTTON class=Calendar type="button" id=selectlayoutstartdate onclick="getDate(layoutstartdatespan,layoutstartdate)"></BUTTON> 
            <SPAN id=layoutstartdatespan ></SPAN> 
            <input class=inputstyle type="hidden" id="layoutstartdate" name="layoutstartdate" >
          </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
          <td class=Field>
            <BUTTON class=Calendar type="button" id=selectlayoutenddate onclick="getDate(layoutenddatespan,layoutenddate)"></BUTTON> 
            <SPAN id=layoutenddatespan ></SPAN> 
            <input class=inputstyle type="hidden" id="layoutenddate" name="layoutenddate" >
          </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></td>
          <td class=Field>
            <textarea class=inputstyle cols=50 rows=4 name=layoutcontent ></textarea>
          </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%> </td>
          <td class=Field>
            <textarea class=inputstyle cols=50 rows=4 name=layoutaim ></textarea>            
          </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(15696,user.getLanguage())%> </td>
         <td class=Field>
            <BUTTON class=Calendar type="button" id=selectlayouttestdatedate onclick="getDate(layouttestdatespan,layouttestdate)"></BUTTON> 
            <SPAN id=layouttestdatespan ></SPAN> 
            <input class=inputstyle type="hidden" id="layouttestdate" name="layouttestdate" >            
          </td>  
        </tr>          
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(15695,user.getLanguage())%> </td>
          <td class=Field>
	      <INPUT class=wuiBrowser id=layoutassessor type=hidden name=layoutassessor
	      _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" _required=yes
	      _diaplayTemplate="<a href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</a>&nbsp;">
	  </td>
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
  	<input class=inputstyle type="hidden" name=operation value=add>
 </TBODY>
 </TABLE>
 </form>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
</table>
<script language=javascript>
function submitData() {
 if(check_formM(frmMain,'layoutname,typeid,layoutassessor')&&checkDateRange(frmMain.layoutstartdate,frmMain.layoutenddate,"<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>")){
 frmMain.submit();
 }
}

 function check_formM(thiswins,items){
	thiswin = thiswins
	items = ","+items + ",";
	
	for(i=1;i<=thiswin.length;i++)
	{
	tmpname = thiswin.elements[i-1].name;
	tmpvalue = thiswin.elements[i-1].value;
	if(tmpname=="layoutassessor"){
		if(tmpvalue == 0){
			alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>"); 
			return false;
		}
	}
    if(tmpvalue==null){
        continue;
    }
	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	
	if(tmpname!="" &&items.indexOf(","+tmpname+",")!=-1 && tmpvalue == ""){
		 alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
		 return false;
		}

	}
	return true;
}
</script>

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
    	inputname.value="0"
	end if
	end if
end sub

sub onShowType()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/train/traintype/TrainTypeBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	typeidspan.innerHtml = id(1)
	frmMain.typeid.value=id(0)
	else
	typeidspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	frmMain.typeid.value=""
	end if
	end if
end sub
</script>
<%@include file="/hrm/include.jsp"%>
</BODY>
 <SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>