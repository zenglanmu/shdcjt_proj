<%@ page import="weaver.general.Util,weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="AwardComInfo" class="weaver.hrm.award.AwardComInfo" scope="page" />

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

<% if(!HrmUserVarify.checkUserRight("HrmResourceRewardsRecordAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>



<HTML><HEAD>
</STYLE>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
String rptitle = Util.null2String(request.getParameter("rptitle")); /*奖惩标题*/
String resourceid =    Util.null2String(request.getParameter("resourceid"));/*员工id*/
String rptypeid = Util.null2String(request.getParameter("rptypeid"));  /*奖惩种类*/
String rpdate = Util.null2String(request.getParameter("rpdate")) ;       /*奖惩日期*/	
String rpexplain = Util.null2String(request.getParameter("rpexplain")) ;	/*说明*/
String rptransact = "" ; 

if( ! rptypeid.equals("") ) {
    String sql="select transact from HrmAwardType where id="+rptypeid ;
    rs.executeSql(sql) ;
    if( rs.next() ) rptransact =  rs.getString("transact") ;/*相关处理*/
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(6100,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goPunishManagerBack(),_self} " ;
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
<FORM name=hrmaward id=hrmaward action="HrmAwardOperation.jsp" method=post >
<input class=inputstyle type=hidden name=operation value="add">
<TABLE class=ViewForm>
<COLGROUP> <COL width="15%"> <COL width="85%"> <TBODY> 
  <TR class=Title> 
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6100,user.getLanguage())%></TH>
  </TR>
  <TR class=Spacing style="height:2px"> 
    <TD class=Line1 colSpan=2></TD>
  </TR>
  <TR> 
    <TD><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
    <TD class=Field> 
      <INPUT class=InputStyle maxLength=30 size=30 name="rptitle" onchange='checkinput("rptitle","rptitlespan")' value="<%=rptitle%>">
      <SPAN id=rptitlespan><% if(rptitle.equals("")) {%><IMG src="/images/BacoError.gif" align=absMiddle><%}%>
      </SPAN> </TD>
  </TR>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <tr> 
    <td><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></td>
    <TD class=Field> 
    <BUTTON class=Browser type="button"  onclick="onShowResource(resourceid,resourceidspan)"></BUTTON>
    <input class=inputstyle type=hidden name=resourceid id=resourceid value="<%=resourceid%>">
    <span id=resourceidspan><%=Util.toScreen(getRecourceLinkStr(resourceid,ResourceComInfo),user.getLanguage())%>
    <% if(resourceid.equals("")) {%> <img src="/images/BacoError.gif" align=absMiddle><%}%></span> 
        </TD>    
  </tr>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
  <TD><%=SystemEnv.getHtmlLabelName(6099,user.getLanguage())%></TD>
  <td class=Field> 
    <BUTTON class=Browser type="button" onclick="onShowAwardTypeID(rptypeidspan,rptypeid)"></BUTTON> 
    <input class=inputstyle type=hidden name=rptypeid id=rptypeid  value="<%=rptypeid%>">
    <span id=rptypeidspan><%=Util.toScreen(AwardComInfo.getAwardName(rptypeid),user.getLanguage())%>
    
    <% if(rptypeid.equals("")) {%> <img src="/images/BacoError.gif" align=absMiddle><%}%></span> 
  </td>
  </TR>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <TR>
    <TD height="20"><%=SystemEnv.getHtmlLabelName(1962,user.getLanguage())%></TD>
    <td class=Field>
          <button class=Calendar type="button" id=selectbememberdate onClick="getHrmDate(rpdatespan, rpdate)"></button> 
          <input class=inputstyle type="hidden" name="rpdate" id="rpdate"  value="<%=rpdate%>">
          <span id=rpdatespan>
          <%=rpdate%>
          <% if(rpdate.equals("")) {%> <img src="/images/BacoError.gif" align=absMiddle><%}%>
          </span> 
        </td>
  </TR>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <TR> 
    <TD height="47"><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
    <td class=Field> 
          <textarea class=InputStyle style="WIDTH: 50%" name=rpexplain rows=6 ><%=rpexplain%></textarea>
        </td>
  </TR>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
  <TR> 
    <TD height="47"><%=SystemEnv.getHtmlLabelName(15432,user.getLanguage())%></TD>
    <td class=Field> 
          <textarea class=InputStyle style="WIDTH: 50%" name=rptransact rows=6 ><%=Util.StringReplace(rptransact,"<br>","\n")%></textarea>
        </td>
  </TR>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
  </TBODY>
</TABLE>
 </FORM>
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
function submitData(obj) {
if(check_form(hrmaward,'rptitle,rptypeid,resourceid,rpdate')){
 obj.disabled=true;
 hrmaward.submit();
}
}

function goPunishManagerBack(){
  
document.location.href="/hrm/award/HrmAward.jsp";

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
			document.hrmaward.action="HrmAwardAdd.jsp";
			document.hrmaward.submit();
		}else{
			jQuery(spanname).html("<img src='/images/BacoError.gif' align=absMiddle>");
			jQuery(inputname).val("");
		}
	}
}
</script>
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

sub onShowResource(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+hrmaward.resourceid.value)
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

sub onShowAwardTypeID(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/award/AwardTypeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
    document.hrmaward.action="HrmAwardAdd.jsp"
    document.hrmaward.submit()
	else
	spanname.innerHtml = "<img src='/images/BacoError.gif' align=absMiddle>"
	inputname.value=""
	end if
	end if
end sub
</script>
-->
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>