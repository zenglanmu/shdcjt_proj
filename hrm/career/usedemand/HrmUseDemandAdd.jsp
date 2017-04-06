<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="UseKindComInfo" class="weaver.hrm.job.UseKindComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("HrmUseDemandAdd:Add", user)){
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
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6131,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmUseDemandAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doedit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/career/usedemand/HrmUseDemand.jsp,_self} " ;
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
<FORM id=weaver name=frmMain action="UseDemandOperation.jsp" method=post >
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6131,user.getLanguage())%></TH></TR>
  <TR class=Spacing style="height:2px">
    <TD class=Line1 colSpan=2 ></TD>
  </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
          <TD class=Field>

              <input class="wuiBrowser" id=jobtitle type=hidden name=jobtitle 
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
			  _required="yes"> 
          </td>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></TD>
          <TD class=Field>
            <input class=inputstyle type=text size=30 name="demandnum" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("demandnum")' onchange='checkinput("demandnum","demandnumspan")'>
             <SPAN id=demandnumspan><IMG src="/images/BacoError.gif" align=absMiddle></SPAN> 
          </td>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></td>
          <td class=Field >

             <input class="wuiBrowser" type=hidden name=demandkind 
			 _url="/systeminfo/BrowserMain.jsp?url=/hrm/usekind/UseKindBrowser.jsp">
          </td>
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<!--                  
        <TR>
          <TD>状态</TD>
          <TD class=Field>
            <select name=status>              
              <option value=0 selected>未处理</option>
              <option value=1 >正在招聘</option>
              <option value=2 >已满足</option>
              <option value=3 >无用</option>
              <option value=4 >失效</option>              
            </select>
          </TD>
        </TR>
-->        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1860,user.getLanguage())%></TD>
          <TD class=Field>
<!--          
            <select class=inputstyle id=leastedulevel name="leastedulevel" >
	            <option value=0 ><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></option>
	            <option value=1 ><%=SystemEnv.getHtmlLabelName(819,user.getLanguage())%></option>
	            <option value=2 ><%=SystemEnv.getHtmlLabelName(764,user.getLanguage())%></option>
	            <option value=12 ><%=SystemEnv.getHtmlLabelName(2122,user.getLanguage())%></option>
	            <option value=13 ><%=SystemEnv.getHtmlLabelName(2123,user.getLanguage())%></option>
	            <option value=3 ><%=SystemEnv.getHtmlLabelName(820,user.getLanguage())%></option>
	            <option value=4 ><%=SystemEnv.getHtmlLabelName(765,user.getLanguage())%></option>
	            <option value=5 ><%=SystemEnv.getHtmlLabelName(766,user.getLanguage())%></option>
	            <option value=6 ><%=SystemEnv.getHtmlLabelName(767,user.getLanguage())%></option>
	            <option value=7 ><%=SystemEnv.getHtmlLabelName(768,user.getLanguage())%></option>
	            <option value=8 ><%=SystemEnv.getHtmlLabelName(769,user.getLanguage())%></option>
	            <option value=9 >MBA</option>
	            <option value=10 >EMBA</option>
	            <option value=11 ><%=SystemEnv.getHtmlLabelName(2119,user.getLanguage())%></option>
	     </select>  
-->	     

	      <input class="wuiBrowser" type=hidden name=leastedulevel 
		  _url="/systeminfo/BrowserMain.jsp?url=/hrm/educationlevel/EduLevelBrowser.jsp">
          </TD>
        </TR>         
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(6153,user.getLanguage())%></td>
          <td class=Field>
            <BUTTON class=Calendar type="button" id=selectdate onclick="getDate(datespan,date)"></BUTTON> 
              <SPAN id=datespan ></SPAN> 
              <input class=inputstyle type="hidden" id="date" name="date" >                        
          </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(1847,user.getLanguage())%></td>
          <td class=Field>
            <textarea class=inputstyle cols=50 rows=4 name=otherrequest ></textarea>
          </td>
        </tr>     
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
 </TBODY>
 </TABLE>
<input class=inputstyle type="hidden" name=operation>
<input class=inputstyle type=hidden name=createkind value="1">
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
<script language=vbs>
sub onShowUsekind()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/usekind/UseKindBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	usekindspan.innerHtml = id(1)
	frmMain.demandkind.value=id(0)
	else 
	usekindspan.innerHtml = ""
	frmMain.demandkind.value=""
	end if
	end if
end sub
sub onShowJobtitle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	jobtitlespan.innerHtml = id(1)
	frmMain.jobtitle.value=id(0)
	else 
	jobtitlespan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	frmMain.jobtitle.value=""
	end if
	end if
end sub

sub onShowEduLevel(inputspan,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/educationlevel/EduLevelBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	inputspan.innerHtml = id(1)
	inputname.value=id(0)
	else 
	inputspan.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub
</script>
 <script language=javascript>
 function doedit(){
    if(check_form(document.frmMain,'jobtitle,demandnum')){
   document.frmMain.operation.value="add";
   document.frmMain.submit();
  }
 }
</script> 
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>