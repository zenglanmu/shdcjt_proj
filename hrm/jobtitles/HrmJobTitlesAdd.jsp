<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("HrmJobTitlesAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
String departmentid = Util.null2String(request.getParameter("departmentid"));    
String[] strObj = null ;
String errorMsg ="";
if("1".equals(Util.null2String(request.getParameter("message")))){
	try{
		
		strObj = (String[])request.getSession().getAttribute("JobTitle.error");
		if(strObj != null){
			errorMsg = SystemEnv.getHtmlLabelName(17426,user.getLanguage());
		}
	}catch(Exception e){}
}else{
	request.getSession().removeAttribute("JobTitle.error");
}
%>
<jsp:useBean id="CompetencyComInfo" class="weaver.hrm.job.CompetencyComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(6086,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmJobTitlesAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:1px;">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=weaver name=frmMain action="JobTitlesOperation.jsp" method=post >
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="48%">
  <COL width=24>
  <COL width="48%">
  <TBODY>
  <%if(!"".equals(errorMsg)){%>
	<TR style="height:1px;">
		<TD colspan = "3">
			<li><font color="red">
				<%=errorMsg%>
			</font></li>
		</TD>
	</TR>
  <%}%>
  <TR class=HEADER>
      <TH align=left><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
    <TH></TH>
      <TH align=left><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
    </TR>
  <TR class=Spacing style="height:1px">
    <TD class=Line1></TD>
    <TD class=Line1 colspan="2"></TD>
  </TR>
  <TR>
    <TD vAlign=top>
    <TABLE class=ViewForm>
    <TBODY>
     <TR>
      <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
      <TD class=Field><INPUT class=inputstyle type=text  name="jobtitlemark" onchange='checkinput("jobtitlemark","jobtitlemarkimage")'  value="<%=(strObj==null?"":strObj[0])%>">
      <SPAN id=jobtitlemarkimage>
		<%if(strObj == null){%>
		<IMG src="/images/BacoError.gif" align=absMiddle>
		<%}%>
		</SPAN></TD>
     </tr>   
     <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
     <TR>
      <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
      <TD class=Field><INPUT class=inputstyle type=text  name="jobtitlename" onchange='checkinput("jobtitlename","jobtitlenameimage")' value="<%=(strObj==null?"":strObj[1])%>">
      <SPAN id=jobtitlenameimage>
		<%if(strObj == null){%>
		<IMG src="/images/BacoError.gif" align=absMiddle>
		<%}%>
	  </SPAN>
	 </TD>
     </tr>   
     <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
     <TR>
        <TD><%=SystemEnv.getHtmlLabelName(15855,user.getLanguage())%></TD>
        <TD class=FIELD>

        <INPUT class="wuiBrowser" id=jobactivityid type=hidden name=jobactivityid  value="<%=(strObj==null?"":strObj[3])%>"
		_url="/systeminfo/BrowserMain.jsp?url=/hrm/jobactivities/JobActivitiesBrowser.jsp"
		_displayTemplate="<a target='_blank' href='/hrm/jobactivities/HrmJobActivitiesEdit.jsp?id=#b{id}'>#b{name}</a>"
		_required="yes">      
        </TD>
     </TR>
     <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
     <TR>
        <TD><%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%></TD>
        <TD class=FIELD>
                
           <INPUT class="wuiBrowser" id=jobdepartmentid type=hidden name=jobdepartmentid value="<%=departmentid%>"
		   _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser2.jsp"
		   _displayText="<%=DepartmentComInfo.getDepartmentname(departmentid)%>"
		   _required="yes">       
        </TD>
     </TR>    
     <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
     <TR>
      <TD><%=SystemEnv.getHtmlLabelName(15856,user.getLanguage())%></TD>
      <TD class=Field>
	  <textarea class=inputstyle style="width:90%" rows=4 name="jobresponsibility" ><%=(strObj==null?"":strObj[4])%></textarea>
     </tr>
     <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
     <TR>
      <TD><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></TD>
      <TD class=Field>

          <INPUT class="wuiBrowser" type=hidden id="jobdoc" name="jobdoc" 
		  _url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
		  _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}' target='_new'>#b{name}</a>">

     </tr>
     <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
     <TR>
      <TD><%=SystemEnv.getHtmlLabelName(895,user.getLanguage())%></TD>
      <TD class=Field><textarea class=inputstyle style="width:90%" rows=4 name="jobcompetency" ><%=(strObj==null?"":strObj[5])%></textarea>
      </TD>
     </tr>   
     <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
</TBODY>
</TABLE>
</TD>
    <TD></TD>
    <TD vAlign=top>
      <TABLE class=ViewForm>
        <TBODY>
        <TR>
          <TD class="Field"><TEXTAREA class=inputstyle name=jobtitleremark rows=8 style="width:90%"><%=(strObj==null?"":strObj[6])%></TEXTAREA>
		  </TD>
		</TR>
	  </TBODY>
	  </TABLE></TD></TR>
  </TBODY></TABLE>
    <input class=inputstyle type="hidden" name=operation value=add>
 </form>
 </td>
</tr>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
</TABLE>
</td>
<td></td>
</tr>
<tr style="height:1px;">
<td height="0" colspan="3"></td>
</tr>
</table>
  <script language=javascript>
function submitData() {
  if(check_form(frmMain,'jobtitlemark,jobtitlename,jobactivityid,jobdepartmentid')){
  frmMain.submit();
  }
}
function encode(str){
       return escape(str);
    }     
	
</script>
 <script language=vbs>
 sub onShowJobActivity()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobactivities/JobActivitiesBrowser.jsp")
	if Not isempty(id) then 
	if id(0)<> 0 then
	jobactivityspan.innerHtml = "<a href='/hrm/jobactivities/HrmJobActivitiesEdit.jsp?id="&id(0)&"'>"&id(1)&"</a>"
	frmMain.jobactivityid.value=id(0)
	else
	jobactivityspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	frmMain.jobactivityid.value=""
	end if
	end if
end sub
sub onShowDoc(inputname,spanname)
                id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
                if Not isempty(id) then
                    inputname.value=id(0)&""
                    spanname.innerHtml = "<a href='/docs/docs/DocDsp.jsp?id="&id(0)&"' target='_new'>"&id(1)&"</a>"
                end if
end sub         
sub onShowDepartment()
    url=encode("/hrm/company/DepartmentBrowser2.jsp?isedit=1&rightStr=HrmResourceEdit:Edit&selectedids="&frmMain.jobdepartmentid.value)
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url)
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = frmMain.jobdepartmentid.value then
		issame = true 
	end if
	departmentspan.innerHtml = id(1)
	frmMain.jobdepartmentid.value=id(0)
	else
	departmentspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	frmMain.jobdepartmentid.value=""
	end if
	end if
end sub
</script>
</BODY>
</HTML>