<%@ page import="weaver.general.Util,
                 weaver.conn.RecordSet" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>

<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<SCRIPT language="javascript" src="/js/chechinput.js"></script>
</HEAD>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String planid = Util.null2String(request.getParameter("planid"));
String id = Util.null2String(request.getParameter("id"));
String sql = "select lastname,sex,jobtitle from HrmCareerApply where id = "+id;
rs.executeSql(sql);
rs.next();
String jobtitle =Util.null2String(rs.getString("jobtitle"));
   /*Add by Charoes Huang On May 26,2004 For Bug 519*/
String lastname,sex;
       lastname = rs.getString("lastname");
       sex = rs.getString("sex");


String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(773,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(1853,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1402,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doBack(),_self} " ;
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

<FORM name=resource id=resource action="HrmApplyOperation.jsp" method=post enctype="multipart/form-data">
<input class=inputstyle type=hidden name=operation value="add">
<input class=inputstyle type=hidden name=id value="<%=id%>">
  <TABLE class=viewForm>

    <TBODY> 
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> 
          <COL width=30%> 
          <COL width=70%>
          <TBODY> 
          <TR class=title> 
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing style="height:1px"> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TD>
            <TD class=Field>
              <input class=inputstyle maxLength=30 size=30 name="workcode">
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <%--Add by Charoes Huang ON May 26,2004 FOR BUG 519--%>
            <TR>
            <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
            <TD class=Field>
               <SPAN id=lastnamespan>
                   <%=lastname%>
              </SPAN>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TD>
            <TD class=Field>
                <%if(sex.equals("0")){%>
                    <%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%>
                <%}else if(sex.equals("1")){%>
                    <%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%>
                <%}%>
            </TD>
          </TR>


          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle type="file" name="photoid">
            </TD>
          </TR> 
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD height=><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
            <TD class=Field >               

              <input class="wuiBrowser" id=departmentid type=hidden name=departmentid value="<%=JobTitlesComInfo.getDepartmentid(jobtitle)%>" onchange="checkinput('departmentid','departmentspan')"
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
			  _displayText="<%=DepartmentComInfo.getDepartmentname(JobTitlesComInfo.getDepartmentid(jobtitle))%>" _required="yes">
            </TD>
          </TR>    
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<%  if(software.equals("ALL") || software.equals("HRM")){%>	
    <!--	  
          <TR> 
            <TD height=>成本中心</TD>
            <TD class=Field >               
              <BUTTON class=Browser id=SelectCostcenter onclick="onShowCostcenter()"></BUTTON> 
              <SPAN id=costcenterspan>
               <IMG src="/images/BacoError.gif" align=absMiddle>
              </SPAN> 
              <input class=inputstyle id=costcenterid type=hidden name=costcenterid onchange='checkinput("costcenterid","costcenterspan")'>              
            </TD>
          </TR>
       -->  
       <input class=inputstyle id=costcenterid type=hidden name=costcenterid value='1'> 
<%}else{%>
              <input class=inputstyle id=costcenterid type=hidden name=costcenterid value='1'>              
<%}%>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
            <TD class=Field>

              <input class="wuiBrowser" id=jobtitle type=hidden name=jobtitle value="<%=jobtitle%>" onchange="checkinput('jobtitle','jobtitlespan')"
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
			  _displayText="<%=JobTitlesComInfo.getJobTitlesname(jobtitle)%>"
			  _required="yes">
            </TD>
          </TR>
           <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(806,user.getLanguage())%></TD>
            <TD class=Field>

              <input class="wuiBrowser" id=jobcall type=hidden name=jobcall
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/jobcall/JobCallBrowser.jsp">
            </TD>
          </TR>  
           <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td><%=SystemEnv.getHtmlLabelName(1909,user.getLanguage())%></td>
            <td class=Field> 
              <input class=inputstyle maxlength=3 size=5 name=joblevel onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevel")'>
            </td>
          </tr>		 
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15708,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle maxLength=90 size=30 name=jobactivitydesc>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	     <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%></TD>
            <TD class=Field>

              <input class="wuiBrowser" id=managerid type=hidden name=managerid onchange="checkinput('managerid','manageridspan')"
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			  _displayTemplate="<A target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>"
			  _required="yes">
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD id=lblAss><%=SystemEnv.getHtmlLabelName(441,user.getLanguage())%></TD>
            <TD class=Field id=txtAss>

              <input class="wuiBrowser" id=assistantid type=hidden name=assistantid
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			  _displayTemplate="<A target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>">
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
            <TD class=Field>
                <select name=status value="0">
                  <option value="0"><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></option>
                  <option value="1"><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
                  <option value="0"><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
                </select>             
            </TD>
          </TR>          
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD id=lblLocation><%=SystemEnv.getHtmlLabelName(15712,user.getLanguage())%></TD>
            <TD class=Field id=txtLocation>

              <input class="wuiBrowser" id=locationid type=hidden name=locationid onchange="checkinput('locationid','locationidspan')"
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/location/LocationBrowser.jsp"
			  _required="yes">
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <tr> 
            <td id=lblRoom><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%></td>
            <td class=Field id=txtRoom> 
              <input class=inputstyle maxlength=30 size=30 name=workroom>
            </td>          
          </tr>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR>             
            <TD><%=SystemEnv.getHtmlLabelName(15713,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle maxLength=25 size=30 name=telephone>
            </TD>
          </TR>   
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle maxLength=25 size=30  name=mobile>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15714,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle maxLength=15 size=30 name=mobilecall>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></TD>
            <TD class=Field>
              <input class=inputstyle maxLength=15 size=30 name=fax>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <%
            boolean hasFF = true;
            rs.executeProc("Base_FreeField_Select","hr");
            if(rs.getCounts()<=0)
                hasFF = false;
            else
                rs.first();

            if(hasFF){
                for(int i=1;i<=5;i++)
                {
                    if(rs.getString(i*2+1).equals("1"))
                    {%>
                          <TR>
                            <TD><%=rs.getString(i*2)%></TD>
                            <TD class=Field>
                                <button class=Calendar id=selectbepartydate onClick="onShowHrmDate('<%=i-1%>','<%=i%>')"></button>
                                <span id=span<%=i%> ></span>
                                <input class=inputstyle type="hidden" name="datefield<%=(i-1)%>" value="">
                            </TD>
                          </TR>
                        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
                          <%}
                }
                for(int i=1;i<=5;i++)
                {
                    if(rs.getString(i*2+11).equals("1"))
                    {%>
                          <TR>
                            <TD><%=rs.getString(i*2+10)%></TD>
                            <TD class=Field>
                                <input class=InputStyle  name="numberfield<%=(i-1)%>" value="" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("numberfield<%=(i-1)%>")'>
                            </TD>
                          </TR>
                         <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
                          <%}
                }
                for(int i=1;i<=5;i++)
                {
                    if(rs.getString(i*2+21).equals("1"))
                    {%>
                          <TR>
                            <TD><%=rs.getString(i*2+20)%></TD>
                            <TD class=Field>
                                <input class=InputStyle  name="textfield<%=(i-1)%>" value="">
                            </TD>
                          </TR>
                        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
                          <%}
                }
                for(int i=1;i<=5;i++)
                {
                    if(rs.getString(i*2+31).equals("1"))
                    {%>
                          <TR>
                            <TD><%=rs.getString(i*2+30)%></TD>
                            <TD class=Field>
                              <INPUT class=inputstyle type=checkbox  name="tinyintfield<%=(i-1)%>" value="1">
                            </TD>
                          </TR>
                   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
                          <%}
                }
            }

            %>
          </TBODY>
        </TABLE>
    </TR>
    </FORM>
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

sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&resource.departmentid.value)
	issame = false
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = resource.departmentid.value then
		issame = true
	end if
	departmentspan.innerHtml = id(1)
	resource.departmentid.value=id(0)
	else
	departmentspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resource.departmentid.value=""
	end if
	if issame = false then
		//	costcenterspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		//	resource.costcenterid.value=""
	end if
	end if
end sub

sub onShowCostCenter()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/CostcenterBrowser.jsp?sqlwhere= where departmentid="&resource.departmentid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	costcenterspan.innerHtml = id(1)
	resource.costcenterid.value=id(0)
	else
	costcenterspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resource.costcenterid.value=""
	end if
	end if
end sub

sub onShowManagerID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	manageridspan.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.managerid.value=id(0)
	else
	manageridspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resource.managerid.value=""
	end if
	end if
end sub

sub onShowAssistantID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	assistantidspan.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.assistantid.value=id(0)
	else
	assistantidspan.innerHtml = ""
	resource.assistantid.value=""
	end if
	end if
end sub

sub onShowLocationID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/location/LocationBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	locationidspan.innerHtml = id(1)
	resource.locationid.value=id(0)
	else
	locationidspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resource.locationid.value=""
	end if
	end if
end sub

sub onShowJobtitle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp?sqlwhere= where jobdepartmentid="&resource.departmentid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	jobtitlespan.innerHtml = id(1)
	resource.jobtitle.value=id(0)
	else
	jobtitlespan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resource.jobtitle.value=""
	end if
	end if
end sub

sub onShowJobcall()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobcall/JobCallBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	jobcallspan.innerHtml = id(1)
	resource.jobcall.value=id(0)
	else
	jobcallspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resource.jobcall.value=""
	end if
	end if
end sub

sub onShowJobType()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtype/JobtypeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	jobtypespan.innerHtml = id(1)
	resource.jobtype.value=id(0)
	else
	jobtypespan.innerHtml = ""
	resource.jobtype.value=""
	end if
	end if
end sub

</script>

<script language=javascript>
function doSave() {
  if(check_form(document.resource,'departmentid,costcenterid,jobtitle,managerid,locationid')){
      document.resource.submit() ;
    }
  }
function doBack() {
   if("<%=planid%>"==""){
     location="HrmCareerApplyEdit.jsp?applyid=<%=id%>";
   }else{
     location="HrmCareerApplyList.jsp?id=<%=planid%>";
   }
}
</script>

<script language="vbs">
//ADD BY Charoes Huang
sub onShowBrowser(id,id2,url,linkurl,type1,ismand)

	if type1= 2 or type1 = 19 then
		id1 = window.showModalDialog(url,,"dialogHeight:320px;dialogwidth:275px")
		document.all("span"+id2).innerHtml = id1
		document.all("dateField"+id).value=id1
	else
		if type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>4 and type1<>167 and type1<>164 and type1<>169 and type1<>170 then
			id1 = window.showModalDialog(url)
		elseif type1=4 or type1=167 or type1=164 or type1=169 or type1=170 then
            tmpids = document.all("dateField"+id).value
			id1 = window.showModalDialog(url&"?selectedids="&tmpids)
		else
			tmpids = document.all("dateField"+id).value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
		end if
		if NOT isempty(id1) then
			if type1 = 17 or type1 = 18 or type1=27 or type1=37 then
				if id1(0)<> ""  and id1(0)<> "0" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all("dateField"+id).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
					document.all("span"+id2).innerHtml = sHtml

				else
					if ismand=0 then
						document.all("span"+id2).innerHtml = empty
					else
						document.all("span"+id2).innerHtml ="<img src='/images/BacoError.gif' align=absmiddle>"
					end if
					document.all("dateField"+id).value=""
				end if

			else
			   if  id1(0)<>""   and id1(0)<> "0"  then
			        if linkurl = "" then
						document.all("span"+id2).innerHtml = id1(1)
					else
						document.all("span"+id2).innerHtml = "<a href="&linkurl&id1(0)&">"&id1(1)&"</a>"
					end if
					document.all("dateField"+id).value=id1(0)
				else
					if ismand=0 then
						document.all("span"+id2).innerHtml = empty
					else
						document.all("span"+id2).innerHtml ="<img src='/images/BacoError.gif' align=absmiddle>"
					end if
					document.all("dateField"+id).value=""
				end if
			end if
		end if
	end if
end sub
</script>
</BODY>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>