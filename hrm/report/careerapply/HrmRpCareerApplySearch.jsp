<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CareerInviteComInfo" class="weaver.hrm.career.CareerInviteComInfo" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="HrmCareerApplyComInfo" class="weaver.hrm.career.HrmCareerApplyComInfo" scope="session"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
HrmCareerApplyComInfo.resetSearchInfo();

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(773,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(352,user.getLanguage())+",/hrm/report/careerapply/HrmRpCareerApply.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15101,user.getLanguage())+",/hrm/report/careerapply/HrmCareerApplyReport.jsp,_self} " ;
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

<FORM NAME=frmain action="HrmRpCareerApplyOperation.jsp" method=post>
<TABLE class=ViewForm>
    <COLGROUP> <col width="20%"> <col width="30%"> <col width="20%"> <col width="30%"> 
    <tbody> 
    <tr> 
      <th align=left colspan=6><%=SystemEnv.getHtmlLabelName(1869,user.getLanguage())%></th>
    </tr>
    <tr class= Spacing style="height: 1px;"> 
      <td class=Line1 colspan=6></td>
    </tr>
    <TR style="height: 1px;"><TD class=Line colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
      <TD class=Field ><INPUT class=inputStyle maxlength=10 size=10 name="Name"  value="<%=HrmCareerApplyComInfo.getName()%>">
      </TD>  
      <td><%=SystemEnv.getHtmlLabelName(6132,user.getLanguage())%></td>
      <td class=Field>
        <input   class=wuiBrowser class=inputstyle id=plan type=hidden name=plan 
	      _url="/systeminfo/BrowserMain.jsp?url=/hrm/career/careerplan/CareerPlanBrowser.jsp"
	    >
      <!--
        <BUTTON  type="button" class=Browser id=SelectPlan onclick="onShowCareerPlan()"></BUTTON> 
        <SPAN id=planspan></SPAN> 
        <input class=inputstyle id=plan type=hidden name=plan>
       -->  
      </td>
   </tr>
   <TR style="height: 1px;"><TD class=Line colSpan=6></TD></TR> 
   <tr>
     <td><%=SystemEnv.getHtmlLabelName(671,user.getLanguage())%></td>
     <td class=Field> 
       <input class=inputStyle maxlength=10 size=5 name=CareerAgeFrom onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(CareerAgeFrom)'>-
       <input class=inputStyle maxlength=10  size=5 name=CareerAgeTo onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(CareerAgeTo)'>
     </td>
     <td><%=SystemEnv.getHtmlLabelName(1855,user.getLanguage())%></td>
     <td class=field>
       <BUTTON  type="button" class=calendar id=SelectDate onclick=getfromDate()></BUTTON>
       <SPAN id=fromdatespan style="FONT-SIZE: x-small"><%=HrmCareerApplyComInfo.getFromDate()%></SPAN>
       <input class=inputstyle type="hidden" name="FromDate" value=<%=HrmCareerApplyComInfo.getFromDate()%>>гн<BUTTON  type="button" class=calendar id=SelectDate onclick=getendDate()></BUTTON>
       <SPAN id=enddatespan style="FONT-SIZE: x-small"><%=HrmCareerApplyComInfo.getEndDate()%></SPAN>
       <input class=inputstyle type="hidden" name="EndDate" value=<%=HrmCareerApplyComInfo.getEndDate()%>>  
     </td>  
   </tr>
   <TR style="height: 1px;"><TD class=Line colSpan=6></TD></TR> 
   <tr>
     <TD><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TD>
     <TD class=Field> 
       <select class=inputStyle id=Sex name=Sex>  
         <option value=0 selected><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%></option>
         <option value=1 selected><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%></option>         
         <option value="" selected></option>
       </select>
     </TD>
     <td><%=SystemEnv.getHtmlLabelName(1844,user.getLanguage())%></td>
     <td class=Field> 
      <input class=inputStyle maxlength=10 size=5 name=WorkTimeFrom onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("WorkTimeFrom")' value="<%=HrmCareerApplyComInfo.getWorkTimeFrom()%>">-<input class=inputStyle       maxlength=10  size=5 name=WorkTimeTo onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("WorkTimeTo")' value="<%=HrmCareerApplyComInfo.getWorkTimeTo()%>"> 
     </td>
   </tr>
   <TR style="height: 1px;"><TD class=Line colSpan=6></TD></TR> 
   <tr>
     <TD><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></TD>
     <TD class=Field> 
       <SELECT class=inputStyle id=MaritalStatus name=MaritalStatus>			   
         <OPTION value=0 selected><%=SystemEnv.getHtmlLabelName(470,user.getLanguage())%></OPTION>
         <OPTION value=1 selected><%=SystemEnv.getHtmlLabelName(471,user.getLanguage())%></OPTION>
         <OPTION value=""selected></OPTION>			   
       </SELECT>
     </TD>
     <td><%=SystemEnv.getHtmlLabelName(15937,user.getLanguage())%></td>
     <td class=Field> 
       <select class=inputStyle id=Category name=Category>		    
         <option value="0" selected><%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%></option>
         <option value="1" selected><%=SystemEnv.getHtmlLabelName(1830,user.getLanguage())%></option>
         <option value="2" selected><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></option>
         <option value="3" selected><%=SystemEnv.getHtmlLabelName(1832,user.getLanguage())%></option>
	 <option value="" selected></option>
       </select>
     </td>     
   </tr>
   <TR style="height: 1px;"><TD class=Line colSpan=6></TD></TR> 
   <tr>
     <td><%=SystemEnv.getHtmlLabelName(15683,user.getLanguage())%></td>
     <td class=Field> 
      <input class=inputStyle maxlength=25 size=25 name=RegResidentPlace value="<%=HrmCareerApplyComInfo.getRegResidentPlace()%>">
     </td>
     <td><%=SystemEnv.getHtmlLabelName(15673,user.getLanguage())%></td>
     <td class=field>
       <input class=inputStyle maxlength=10 size=5 name=SalaryNeedFrom onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=HrmCareerApplyComInfo.getSalaryNeedFrom()%>">-
       <input class=inputStyle maxlength=10  size=5 name=SalaryNeedTo onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=HrmCareerApplyComInfo.getSalaryNeedTo()%>">
     </td>        
   </tr>
   <TR style="height: 1px;"><TD class=Line colSpan=6></TD></TR> 
   <tr>
     <td ><%=SystemEnv.getHtmlLabelName(15671,user.getLanguage())%></td>
      <td class=field>  
        <input   class=wuiBrowser class=inputstyle id=jobtitle type=hidden name=jobtitle 
	      _url="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
	    >
       <!--
     	<BUTTON  type="button" class=Browser id=SelectJobTitle onclick="onShowJobtitle()"></BUTTON> 
        <SPAN id=jobtitlespan>          
        </SPAN> 
        <input class=inputstyle id=jobtitle type=hidden name=jobtitle >
        --> 
     </td>
     <td><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></td>
     <TD class=field>
       <input   class=wuiBrowser class=inputstyle id=EducationLevel type=hidden name=EducationLevel 
	      _url="/systeminfo/BrowserMain.jsp?url=/hrm/educationlevel/EduLevelBrowser.jsp"
	    >
	   <!--
	      <BUTTON  type="button" class=Browser name="btneducationlevel"  onclick="onShowEduLevel(educationlevelspan,EducationLevel)"> </BUTTON>
	      <SPAN id=educationlevelspan></SPAN>
	      <input class=inputstyle type=hidden name=EducationLevel> 
       -->
     </TD>     
   </tr> 
   <TR style="height: 1px;"><TD class=Line colSpan=6></TD></TR> 
 </TABLE>
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
</SCRIPT>
<SCRIPT language="javascript">
function OnSubmit(){
		document.frmain.submit();
}
function submitData() {
 frmain.submit();
}

</script>
<script language=vbs>
sub onShowJobtitle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	jobtitlespan.innerHtml = id(1)
	frmain.jobtitle.value=id(0)
	else 
	jobtitlespan.innerHtml = ""
	frmain.jobtitle.value=""
	end if
	end if
end sub  
sub onShowCareerPlan()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/career/careerplan/CareerPlanBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	planspan.innerHtml = id(1)
	frmain.plan.value=id(0)
	else 
	planspan.innerHtml = ""
	frmain.plan.value=""
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
 </BODY>
 <SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>