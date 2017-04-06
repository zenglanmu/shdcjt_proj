<%@ page import="weaver.general.Util,
                 weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="AwardComInfo" class="weaver.hrm.award.AwardComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%!
   /**
    * Added By Charoes Huang On May 20 ,2004
    * @param resourceid
    * @param comInfo
    * @return  the resource name string with hyper link
    */
   private String getRecourceLinkStr(String resourceid,ResourceComInfo comInfo){
       String linkStr ="";
       String[] resources =Util.TokenizerString2(resourceid,",");
       for(int i=0;i<resources.length;i++){
           linkStr += "<A href=\"/hrm/resource/HrmResource.jsp?id="+resources[i]+"\">"+comInfo.getResourcename(resources[i])+"</A>&nbsp;";
       }
       return linkStr;
   }
%>
<%
String id = request.getParameter("id");
String rptitle="";
String resourceid="" ;
String rptypeid="" ;

String rpdate="" ;
String rpexplain="";
String rptransact="" ;

boolean canEdit = false;
if(HrmUserVarify.checkUserRight("HrmResourceRewardsRecordEdit:Edit", user)){
	canEdit = true;
}
RecordSet.executeProc("HrmAwardInfo_SByid",id);
if( RecordSet.next()) {
    rptitle = RecordSet.getString("rptitle");
    resourceid = Util.toScreenToEdit(RecordSet.getString("resourseid"),user.getLanguage());
    rptypeid = Util.toScreenToEdit(RecordSet.getString("rptypeid"),user.getLanguage());
    rpdate = Util.toScreenToEdit(RecordSet.getString("rpdate"),user.getLanguage());
    rpexplain = Util.toScreenToEdit(RecordSet.getString("rpexplain"),user.getLanguage());
    rptransact = Util.toScreenToEdit(RecordSet.getString("rptransact"),user.getLanguage());
}

String imagefilename = "/images/hdHRMCard.gif";
String titlename = (canEdit?SystemEnv.getHtmlLabelName(93,user.getLanguage()):SystemEnv.getHtmlLabelName(89,user.getLanguage()))+":"+SystemEnv.getHtmlLabelName(6100,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmResourceRewardsRecordEdit:Edit", user)){
	canEdit = true;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmResourceRewardsRecordAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/award/HrmAwardAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmResourceRewardsRecordEdit:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/award/HrmAward.jsp,_self} " ;
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
<FORM id=frmMain name=frmMain action="HrmAwardOperation.jsp" method=post>
<%
String isdisable = "";
if(!canEdit)
	isdisable = " disabled";
%>
<TABLE class=ViewFORM>
  <COLGROUP>
  <COL width="48%">
  <COL width=24>
  <COL width="48%">
  <TBODY>
  <TR class=HEADER>
      <TH align=left><%=SystemEnv.getHtmlLabelName(6100,user.getLanguage())%>
      </TH>    
  </TR>
  <TR class= Spacing>
    <TD class=Line1></TD>    
  </TR>
  <TR>
  <TD vAlign=top>
  <TABLE class=ViewFORM>
  <COLGROUP> <COL width="12%"><COL width="88%">
   <TBODY>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(15665,user.getLanguage())%></TD>
      <TD class=Field><%if(canEdit){%>
      <input class=inputstyle type=text size=30 name="rptitle" value="<%=rptitle%>" onchange='checkinput("rptitle","rptitleimage")'>
      <%}else{%><%=rptitle%><%}%>
      <SPAN id=rptitleimage></SPAN></TD>
    </tr>
   <TR><TD class=Line colSpan=2></TD></TR>        
    <tr> 
    <td><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></td>
    <TD class=Field>
	<%if(canEdit){%>
    <BUTTON class=Browser onclick="onShowResource(resourceid,resourceidspan)"></BUTTON>
	<%}%>
    <input class=inputstyle type=hidden name=resourceid id=resourceid value="<%=RecordSet.getString("resourseid")%>">
    <span id=resourceidspan> 
    <a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("resourseid")%>">
    <%=Util.toScreen(getRecourceLinkStr(RecordSet.getString("resourseid"),ResourceComInfo),user.getLanguage())%> </a></span>
        </TD>    
  </tr>
  <TR><TD class=Line colSpan=2></TD></TR> 
  <TD><%=SystemEnv.getHtmlLabelName(6099,user.getLanguage())%></TD>
  <td class=Field>
	<%if(canEdit){%>
    <BUTTON class=Browser onclick="onShowAwardTypeID(rptypeidspan,rptypeid)"></BUTTON> 
	<%}%>
    <input class=inputstyle type=hidden name=rptypeid id=rptypeid value="<%=RecordSet.getString("rptypeid")%>">
    <span id=rptypeidspan>
    <%=Util.toScreen(AwardComInfo.getAwardName(RecordSet.getString("rptypeid")),user.getLanguage())%>
    </span> 
  </td>
  </TR>
  <TR><TD class=Line colSpan=2></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(1962,user.getLanguage())%></TD>
    <td class=Field>
		<%if(canEdit){%>
          <button class=Calendar id=selectbememberdate onClick="getHrmDate(rpdatespan, rpdate)"></button> 
		<%}%>
          <input class=inputstyle type="hidden" name="rpdate" id="rpdate" value="<%=RecordSet.getString("rpdate")%>">
          <span id=rpdatespan>
          <%=rpdate%>
          </span> 
        </td>
  </TR>
<TR><TD class=Line colSpan=2></TD></TR>     <TR>
      <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
      
      <TD class=Field> <%if(canEdit){%>
      <TEXTAREA class=inputstyle style="WIDTH: 50%" name="rpexplain" rows=6><%=rpexplain%></TEXTAREA><%}else{%><%=rpexplain%><%}%>
      <SPAN id=rpexplainimage></SPAN></TD>
    </tr> 
    <TR><TD class=Line colSpan=2></TD></TR> 
    <TR>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(15432,user.getLanguage())%></TD>
      
      <TD class=Field><%if(canEdit){%>
      <TEXTAREA class=inputstyle style="WIDTH: 50%" name="rptransact" value="<%=RecordSet.getString("rptransact")%>" rows=6><%=rptransact%></TEXTAREA><%}else{%><%=rptransact%><%}%>
      <SPAN id=rptransacimage></SPAN></TD>
    </tr> 
    <TR>
    <TR><TD class=Line colSpan=2></TD></TR> 
 </TBODY>
 </TABLE>
 </TD> 
   <input class=inputstyle type="hidden" name=operation value="edit">
   <input class=inputstyle type="hidden" name=id value="<%=id%>">
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
<!--
<script language=vbs>
  sub onShowResourceID(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else
	spanname.innerHtml = "<img src='/images/BacoError.gif' align=absMiddle>"
	inputname.value=""
	end if
	end if
end sub

sub onShowAwardTypeID(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/award/AwardTypeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
    else
	spanname.innerHtml = "<img src='/images/BacoError.gif' align=absMiddle>"
	inputname.value=""
	end if
	end if
end sub

sub onShowResource(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+frmMain.resourceid.value)
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
</script>
-->
 <script language=javascript>
 function onSave(){
	if(check_form(frmMain,'rptitle,resourceid,rptypeid,rpdate ')){
		document.frmMain.submit();
	}
 }
 function onDelete(){
      if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
			document.frmMain.operation.value="delete";
			document.frmMain.submit();
		}
}
 function onShowResource(inputname,spanname){
		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+jQuery("input[name=resourceid]").val());
		if (data!=null){
			if (data.id!= ""){
				ids = data.id.split(",");
				names =data.name.split(",");
				sHtml = "";
				for( var i=0;i<ids.length;i++){
					if(ids[i]!=""){
						sHtml = sHtml+"<a href=/hrm/resource/HrmResource.jsp?id="+ids[i]+"'>"+names[i]+"</a>&nbsp;";
					}
				}
				jQuery(inputname).val(data.id);
				jQuery(spanname).html(sHtml);
			}else{
				jQuery(spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
				jQuery(inputname).val("0");
			}
		}
}
 function onShowAwardTypeID(spanname, inputname){
		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/award/AwardTypeBrowser.jsp");
		if (data!=null){
			if (data.id!= ""){
				jQuery(spanname).html(data.name);
				jQuery(inputname).val(data.id);
			}else{
				jQuery(spanname).html("<img src='/images/BacoError.gif' align=absMiddle>");
				jQuery(inputname).val("");
			}
		}
	}
 </script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>