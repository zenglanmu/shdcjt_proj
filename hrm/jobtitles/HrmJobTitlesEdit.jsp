<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK"%> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

/*Added by Charoes Huang, June 4,2004*/
String errorMsg ="";
if("1".equals(Util.null2String(request.getParameter("message")))){
	errorMsg = SystemEnv.getHtmlLabelName(17426,user.getLanguage());
}

String jobtitlemark = Util.toScreenToEdit(JobTitlesComInfo.getJobTitlesmark(""+id),user.getLanguage());
String jobtitlename = Util.toScreenToEdit(JobTitlesComInfo.getJobTitlesname(""+id),user.getLanguage());
String depid = Util.toScreenToEdit(JobTitlesComInfo.getDepartmentid(""+id),user.getLanguage());
String jobactivityid = Util.toScreenToEdit(JobTitlesComInfo.getJobactivityid(""+id),user.getLanguage());
String jobresponsibility = Util.toScreenToEdit(JobTitlesComInfo.getJobresponsibility(""+id),user.getLanguage());
String jobcompetency = Util.toScreenToEdit(JobTitlesComInfo.getJobcompetency(""+id),user.getLanguage());
String jobtitleremark = Util.toScreenToEdit(JobTitlesComInfo.getJobtitleremark(""+id),user.getLanguage());
String jobdoc = Util.toScreenToEdit(JobTitlesComInfo.getJobdoc(""+id),user.getLanguage());
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(6086,user.getLanguage())+":"+jobtitlename;
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
boolean changeDept = true;
String sql = "select count(id) from HrmResource where jobtitle = "+id;
	RecordSet.executeSql(sql);
	RecordSet.next();
    if(RecordSet.getInt(1)>0)
    changeDept=false;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
if (detachable == 0){
		String detasql = "select detachable from systemset";
		RecordSet.executeSql(detasql);
		if (RecordSet.next()){
				detachable = Integer.parseInt(Util.null2String(RecordSet.getString("detachable")));
		}
}
int operatelevel = 0;	
String subcompanyid = "";			
if (!"".equals(depid) && detachable == 1){
			//String subsql = "select subcompanyid1  from Hrmresource where id="+user.getUID();
			String subsql = "select subcompanyid1 from HrmDepartment where id="+depid;
			RecordSet.executeSql(subsql);				
			if (RecordSet.next()){
					subcompanyid = Util.null2String(RecordSet.getString("subcompanyid1"));
			}
}

if(HrmUserVarify.checkUserRight("HrmJobTitlesEdit:Edit", user)){
		canEdit = true;
		
		if(detachable == 1 && !"".equals(subcompanyid)){
				operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmJobTitlesEdit:Edit",Integer.parseInt(subcompanyid));
				if(operatelevel>0){
						RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
						RCMenuHeight += RCMenuHeightStep ;
				}					
		} else {
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
		}
}
/*if(HrmUserVarify.checkUserRight("HrmJobTitlesAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/jobtitles/HrmJobTitlesAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}*/
if(HrmUserVarify.checkUserRight("HrmJobTitlesEdit:Delete", user)){
		if(detachable == 1 && !"".equals(subcompanyid)){
				operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmJobTitlesEdit:Delete",Integer.parseInt(subcompanyid));
				if(operatelevel==2){
						RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
						RCMenuHeight += RCMenuHeightStep ;
				}

		} else {
				RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
		}
}
if(HrmUserVarify.checkUserRight("HrmJobTitles:Log", user)){
    if(RecordSet.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=26 and relatedid="+id+",_self} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=26 and relatedid="+id+",_self} " ;
    }
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

<FORM id=weaver name=frmMain action="JobTitlesOperation.jsp" method=post>


<%
String isdisable = "";
if(detachable == 1 && operatelevel <= 0) canEdit = false;

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
    <%if(!"".equals(errorMsg)){%>
	<TR>
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
  <TR class=Spacing style="height:2px">
    <TD class=Line1></TD>
    <TD class=Line1 colspan="2"></TD>
   </TR>
      <TR>
    <TD vAlign=top>
    <TABLE class=ViewForm>
    <TBODY>
      <TR>
        <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
        <TD class=Field>
        <%if(canEdit){%><INPUT class=inputstyle type=text size=30 name="jobtitlemark" value="<%=jobtitlemark%>" onchange='checkinput("jobtitlemark","jobtitlemarkimage")'>
        <%}else{%><%=jobtitlemark%><%}%>
        <SPAN id=jobtitlemarkimage></SPAN></TD>
      </tr>  
   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
      <TR>
        <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
        <TD class=Field><%if(canEdit){%><INPUT class=inputstyle type=text size=30 name="jobtitlename"  value="<%=jobtitlename%>" onchange='checkinput("jobtitlename","jobtitlenameimage")'>
        <%}else{%><%=jobtitlename%><%}%>  <SPAN id=jobtitlenameimage></SPAN></TD>
      </tr>   
     <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
      <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></TD>
          <TD class=FIELD><%if(canEdit){%>
          <%}%>
          <INPUT class=wuiBrowser id=jobactivityid type=hidden name=jobactivityid value="<%=jobactivityid%>" _required=yes
          _url="/systeminfo/BrowserMain.jsp?url=/hrm/jobactivities/JobActivitiesBrowser.jsp"
          _displayTemplate="<a href='/hrm/jobactivities/HrmJobActivitiesEdit.jsp?#b{id}' target='_fullwindow'>#b{name}</a>"
          _displayText="<a href='/hrm/jobactivities/HrmJobActivitiesEdit.jsp?id=<%=jobactivityid%>' target='_fullwindow'><%=JobActivitiesComInfo.getJobActivitiesname(jobactivityid)%></a>">
          </TD>
       </TR>       
            <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
       <TR>
        <TD><%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%></TD>
        <TD class=Field>         
            <%if(canEdit&&changeDept){%><BUTTON class=Browser id=SelectDepartment onclick="onShowDepartment()"></BUTTON><%}%> 
            <SPAN id=departmentspan> <%=DepartmentComInfo.getDepartmentname(depid)%>
<%
  if(depid.equals("")){
%>            
             <IMG src="/images/BacoError.gif" align=absMiddle>
<%
  }
%>             
            </SPAN> 
           <INPUT class=inputstyle id=jobdepartmentid type=hidden name=jobdepartmentid value="<%=depid%>">    
        </TD>
      </tr> 
      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
      <TR>
      <TD><%=SystemEnv.getHtmlLabelName(15856,user.getLanguage())%></TD>
      <TD class=Field>
      <%if(canEdit){%>
      <textarea class=inputstyle style="width: 80%" rows=4 name="jobresponsibility" value="<%=jobresponsibility%>"><%=jobresponsibility%></textarea>
      <%}else{%><%=jobresponsibility%><%}%>
      </TD>
     </tr>
     <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
      <TR>
      <TD><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></TD>
      <TD class=Field>
      <%if(canEdit){%>
          <INPUT class=wuiBrowser type=hidden id="jobdoc" name="jobdoc" value="<%=jobdoc%>"
          _url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
          _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}' target='_blank'>#b{name}</a>" _displayText="<%=DocComInfo.getDocname(jobdoc)%>" >
      <%}%>
      </TD>
     </tr>      
     <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
     <TR>
      <TD><%=SystemEnv.getHtmlLabelName(895,user.getLanguage())%></TD>      
      <TD class=Field>
      <%if(canEdit){%><textarea class=inputstyle style="width: 80%" rows=4 name="jobcompetency" value="<%=jobcompetency%>"><%=jobcompetency%></textarea>
      <%}else{%><%=jobcompetency%><%}%>
      </TD>
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
          <TD>
          <%if(canEdit){%>
          <TEXTAREA class=inputstyle name=jobtitleremark rows=8 style="width: 90%" <%=isdisable%>><%=jobtitleremark%></TEXTAREA>
          <%}else{%><%=jobtitleremark%><%}%>
          </TD>
        </TR>
</TBODY>
</TABLE>
</TD></TR>
</TBODY></TABLE>

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
 sub onShowJobActivity()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobactivities/JobActivitiesBrowser.jsp")
	if Not isempty(id) then 
	if id(0)<> 0 then
	jobactivityspan.innerHtml = "<a href='/hrm/jobactivities/HrmJobActivitiesEdit.jsp?id="&id(0)&"' target='_fullwindow'>"&id(1)&"</a>"
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
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmMain.jobdepartmentid.value)
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
 <script language=javascript>
 function onSave(){
	if(check_form(document.frmMain,'jobtitlemark,jobtitlename,jobactivityid,jobdepartmentid')){
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
</BODY>
</HTML>