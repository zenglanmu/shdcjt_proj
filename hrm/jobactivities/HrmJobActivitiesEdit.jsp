<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CompetencyComInfo" class="weaver.hrm.job.CompetencyComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String jobactivitymark="";
String jobactivityname="";
int joblevelfrom=0;
int joblevelto = 0;
String jobgroupid="";
RecordSet.executeProc("HrmJobActivities_SelectByID",""+id);

if(RecordSet.next()){
	jobactivitymark = Util.toScreenToEdit(RecordSet.getString("jobactivitymark"),user.getLanguage());
	jobactivityname = Util.toScreenToEdit(RecordSet.getString("jobactivityname"),user.getLanguage());
	joblevelfrom = Util.getIntValue(Util.toScreenToEdit(RecordSet.getString("joblevelfrom"),user.getLanguage()));
	joblevelto= Util.getIntValue(Util.toScreenToEdit(RecordSet.getString("joblevelto"),user.getLanguage()),0);
	jobgroupid = Util.toScreenToEdit(RecordSet.getString("jobgroupid"),user.getLanguage());
}

String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(357,user.getLanguage())+":"+jobactivityname;
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmJobActivitiesEdit:Edit", user)){
	canEdit = true;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmJobActivitiesAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/jobactivities/HrmJobActivitiesAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmJobActivitiesEdit:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmJobActivities:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+25+" and relatedid="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
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


<FORM id=weaver name=frmMain action="JobActivitiesOperation.jsp" method=post>

<%
String isdisable = "";
if(!canEdit)
	isdisable = " disabled";
%>
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="48%">
  <COL width=24>
  <COL width="48%">
  <TBODY>
  <TR class=HEADER>
      <TH align=left><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%>
      </TH>    
  </TR>
  <TR class=Spacing>
    <TD class=Sep1></TD>    
  </TR>
  <TR>
  <TD vAlign=top>
  <TABLE class=ViewForm>
   <TBODY>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
      <TD class=Field><%if(canEdit){%>
      <INPUT class=inputstyle type=text size=30 name="jobactivitymark" value="<%=jobactivitymark%>" onchange='checkinput("jobactivitymark","jobactivitymarkimage")'>
      <%}else{%><%=jobactivitymark%><%}%>
      <SPAN id=jobactivitymarkimage></SPAN></TD>
    </tr>   
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
       <TD class=Field><%if(canEdit){%><INPUT class=inputstyle type=text size=30 name="jobactivityname"  value="<%=jobactivityname%>"onchange='checkinput("jobactivityname","jobactivitynameimage")'>
       <%}else{%><%=jobactivityname%><%}%>  <SPAN id=jobactivitynameimage></SPAN></TD>
    </tr>        
           <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(15854,user.getLanguage())%></TD>
      <TD class=FIELD colSpan=3>
      <%if(canEdit){%>
      <%}%>
      <span class=inputstyle id=jobgroupspan>
	      <INPUT class=wuiBrowser id=jobgroupid type=hidden name=jobgroupid value="<%=jobgroupid%>"
	      _url="/systeminfo/BrowserMain.jsp?url=/hrm/jobgroups/JobGroupsBrowser.jsp" _required=yes
	      _displayTemplate="<A href='/hrm/jobgroups/HrmJobGroupsEdit.jsp?#b{id}'target='_blank'>#b{name}</A>"
	      _displayText="<%=JobGroupsComInfo.getJobGroupsname(jobgroupid)%>"
	      >
       </span> 
      </TD>
    </TR>              
           <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<!--
   <TR>
    <TD>工作级别、从</TD>
    <TD class=Field>
    <input type=text  name="joblevelfrom" value="<%=joblevelfrom%>" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevelfrom")'>    
  </tr>   
  <TR>
    <TD>工作级别、到</TD>
    <TD class=Field>
    <input type=text  name="joblevelto" value="<%=joblevelto%>" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevelto")'>    
  </tr>   
-->  
          
 </TBODY>
 </TABLE>
 </TD> 
   <input class=inputstyle type="hidden" name=operation>
   <input class=inputstyle type="hidden" name=id value=<%=id%>>
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
 sub onShowJobGroup()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobgroups/JobGroupsBrowser.jsp")
	if Not isempty(id) then 
	if id(0)<> 0 then
	jobgroupspan.innerHtml = id(1)
	frmMain.jobgroupid.value=id(0)
	else
	jobgroupspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	frmMain.jobgroupid.value=""
	end if
	end if
end sub

sub showDoc()
	id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if Not isempty(id) then
		frmMain.docid.value=id(0)&""
		docidname.innerHtml = "<a href='/docs/docs/DocDsp.jsp?id="&id(0)&"'>"&id(1)&"</a>"	
	end if	
end sub

</script>
 <script language=javascript>
 function onSave(){
	if(check_form(document.frmMain,'jobactivitymark,jobactivityname,jobgroupid')){
	 	document.frmMain.operation.value="edit";
		document.frmMain.submit();
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="delete";
			document.frmMain.submit();
		}
}
 </script>
</BODY></HTML>
