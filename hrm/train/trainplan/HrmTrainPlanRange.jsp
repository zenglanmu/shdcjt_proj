<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<%
int planid = Util.getIntValue(request.getParameter("planid"),0);
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(6103,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6104,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/trainplan/HrmTrainPlanEdit.jsp?id="+planid+",_self} " ;
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

<FORM id=weaver name=weaver action="TrainPlanOperation.jsp" method=post>
<input type="hidden" name="operation" value="addrange">
<input type="hidden" name="planid" value="<%=planid%>">
<TABLE class=viewForm>
  <COLGROUP>
	<COL width="20%">
  	<COL width="80%">
    <TBODY>
      <TR class=Title
        <TH colSpan=2></TH></TR>
      <TR class=spacing
        <TD class=line1  colSpan=2></TD>
      </TR>
      <TR>
        <td>
          <SELECT class=inputstyle name=sharetype onchange="onChangeSharetype()">
            <option value="0" selected><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>  
            <option value="1" ><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
            <option value="2"><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></option>
            <option value="3"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>            
            <option value="4"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>   
          </SELECT>
        </TD>	 
        <TD class=field >
          <BUTTON class=Browser style="display:none" onClick="onShowResource('showrelatedsharename','relatedshareid')" name=showresource></BUTTON>
          <BUTTON class=Browser style="display:none" onClick="onShowDepartment('showrelatedsharename','relatedshareid')" name=showdepartment></BUTTON> 
          <BUTTON class=Browser style="display:none" onClick="onShowJobActivitiew('showrelatedsharename','relatedshareid')" name=showjobactivities></BUTTON> 
          <BUTTON class=Browser style="display:none" onclick="onShowJobTitles('showrelatedsharename','relatedshareid')" name=showjobtitles></BUTTON>
          <INPUT type=hidden name=relatedshareid value=""> 
          <span id=showrelatedsharename name=showrelatedsharename></span>
		  <span id=showseclevel name=showseclevel style="display:''"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:
    <INPUT class=inputstyle type=text name=seclevel size=6 value="10">
    </span>
    <SPAN id=seclevelimage></SPAN>
		</TD>		
	  </tr>
   </TBODY>
</TABLE>
	  
<!--已有公开范围-->
        <table class=viewform>
          <colgroup> 
          <col width="20%"> 
          <col width="60%">
          <col width="20%">
          <tr class=Section> 
            <th align="left"><%=SystemEnv.getHtmlLabelName(6104,user.getLanguage())%></th>
          <tr class=spacing> 
            <td class=line1 colspan=3></td>
          </tr>
<%
	//查找已经添加的公开范围
	String sql = "select * from HrmTrainPlanRange where planid ="+planid+" order by id asc";	
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		if(RecordSet.getInt("type_n")==0){%>
	        <TR>
			<TD><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></TD>
	          <TD class=Field>
			  <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen((RecordSet.getString("seclevel")),user.getLanguage())%>
			  </TD>
			  <TD class=Field align=right>				
				<a href="TrainPlanOperation.jsp?operation=deleterange&id=<%=RecordSet.getString("id")%>&planid=<%=planid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 				
			  </TD>			  
	        </TR>
	    <%}else if(RecordSet.getInt("type_n")==1){%>
	        <TR>
	          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("resourceid")),user.getLanguage())%>
			  </TD>
			  <TD class=Field align=right>				
				<a href="TrainPlanOperation.jsp?operation=deleterange&id=<%=RecordSet.getString("id")%>&planid=<%=planid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 				
			  </TD>
	        </TR>
		<%}else if(RecordSet.getInt("type_n")==2)	{%>
	        <TR>
	          <TD><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(JobActivitiesComInfo.getJobActivitiesname(RecordSet.getString("resourceid")),user.getLanguage())%>
			  </TD>
			  <TD class=Field align=right>				
				<a href="TrainPlanOperation.jsp?operation=deleterange&id=<%=RecordSet.getString("id")%>&planid=<%=planid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 				
			  </TD>
	        </TR>
		<%}else if(RecordSet.getInt("type_n")==3)	{%>
	        <TR>
	          <TD><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(RecordSet.getString("resourceid")),user.getLanguage())%>
			  </TD>
			  <TD class=Field align=right>				
				<a href="TrainPlanOperation.jsp?operation=deleterange&id=<%=RecordSet.getString("id")%>&planid=<%=planid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 				
			  </TD>			  
	        </TR>
	     <%}else if(RecordSet.getInt("type_n")==4)	{%>
	        <TR>
	          <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
			  <TD class=Field>
				<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("resourceid")),user.getLanguage())%>
			  </TD>
			  <TD class=Field align=right>				
				<a href="TrainPlanOperation.jsp?operation=deleterange&id=<%=RecordSet.getString("id")%>&planid=<%=planid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 				
			  </TD>
	        </TR>
		<%}else if(RecordSet.getInt("type_n")==3)	{%>   		    
		<%}%>
<%	}%>
        </table>
      </TD></TR>
    </TBODY>
  </TABLE>
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
function doSave() {
thisvalue=document.weaver.sharetype.value;
if (thisvalue==1)
	{if(check_form(document.weaver,'relatedshareid'))
	document.weaver.submit();}
else if (thisvalue==2)
	{if(check_form(document.weaver,'relatedshareid'))
	document.weaver.submit();}
else if (thisvalue==3)
	{if(check_form(document.weaver,'relatedshareid'))
	document.weaver.submit();}
else if (thisvalue==4)
	{if(check_form(document.weaver,'relatedshareid'))
	document.weaver.submit();}
else
	document.weaver.submit();
}
</script>

<script language=javascript>
  function onChangeSharetype(){
	thisvalue=document.weaver.sharetype.value;
	document.weaver.relatedshareid.value="";
	document.all("showseclevel").style.display='';
    showrelatedsharename.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"

    if(thisvalue==0){
 		document.all("showresource").style.display='none';
 		document.all("showdepartment").style.display='none';
 		document.all("showjobactivities").style.display='none';	
 		document.all("showjobtitles").style.display='none';	
		document.all("showseclevel").style.display="";
		showrelatedsharename.innerHTML = ""
	}
	if(thisvalue==1){
 		document.all("showresource").style.display='none';
 		document.all("showdepartment").style.display='';
 		document.all("showjobactivities").style.display='none';	
 		document.all("showjobtitles").style.display='none';	
		document.all("showseclevel").style.display='none';		
	}
	if(thisvalue==2){
 		document.all("showresource").style.display='none';
 		document.all("showdepartment").style.display='none';
 		document.all("showjobactivities").style.display='';	
 		document.all("showjobtitles").style.display='none';	
		document.all("showseclevel").style.display='none';
	}	
	if(thisvalue==3){
 		document.all("showresource").style.display='none';
 		document.all("showdepartment").style.display='none';
 		document.all("showjobactivities").style.display='none';	
 		document.all("showjobtitles").style.display='';		 
		document.all("showseclevel").style.display='none';
	}
	if(thisvalue==4){
 		document.all("showresource").style.display='';
 		document.all("showdepartment").style.display='none';
 		document.all("showjobactivities").style.display='none';	
 		document.all("showjobtitles").style.display='none';	 
		document.all("showseclevel").style.display='none';
	}	
}

function onShowResource(spanname, inputname) {
    tmpids = document.all(inputname).value;
    if(tmpids!="-1"){ 
     url="/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids;
    }else{
     url="/hrm/resource/MutiResourceBrowser.jsp";
    }
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0" && jsid[1]!="") {
            document.all(spanname).innerHTML = jsid[1].substring(1);
            document.all(inputname).value = jsid[0].substring(1);
        } else {
            document.all(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
            document.all(inputname).value = "";
        }
    }
}

function onShowDepartment(spanname, inputname) {
    
    url=escape("/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+document.all(inputname).value);
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0" && jsid[1]!="") {
            document.all(spanname).innerHTML = jsid[1].substring(1);
            document.all(inputname).value = jsid[0].substring(1);
        }else {
            document.all(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
            document.all(inputname).value = "";
        }
    }
}

</script>

<SCRIPT language=VBS>
sub onShowDepartmentMM(inputname,spanname)
    linkurl="/hrm/company/HrmDepartmentDsp.jsp?id="
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="&inputname.value)
	if (Not IsEmpty(id)) then
	    'if id(0)<> "" then
	    if id(0)<> "" and id(0)<> "0" then
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
    	    'inputname.value="0"
    	    inputname.value=""
	    end if
	end if
end sub

sub onShowJobActivitiew(tdname,inputename)
	Dim id
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobactivities/JobActivitiesBrowser.jsp")
	if NOT isempty(id) then
	'msgbox "id:" & typename(id) & ",ubound:" & ubound(id)
	'msgbox "info0," & id(0)
	'msgbox "info1," & id(1)
	    if id(0)<> "" and id(1)<> "" then
			document.all(tdname).innerHtml = id(1)
			document.all(inputename).value=id(0)
		else
			document.all(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			document.all(inputename).value=""
		end if
	end if
end sub

sub onShowResourceMM(inputname,spanname)
    linkurl="/hrm/resource/HrmResource.jsp?id="
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
    if (Not IsEmpty(id)) then
	    'if id(0)<> "" then
	    if id(0)<> "" and  id(0)<> "0" then
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
    	    'inputname.value="0"
    	    inputname.value=""
	    end if
    end if
end sub

sub onShowJobTitles(tdname,inputename)
	Dim id
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" and id(1)<> "" then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		document.all(inputename).value=""
		end if
	end if
end sub

</SCRIPT>
</BODY>
</HTML>
