<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ include file="/hrm/performance/common.jsp" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="resource" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<% 
  //if (!Rights.getRights("","","","")){//权限判断
  //	response.sendRedirect("/notice/noright.jsp") ;
//	return ;
 //  }
%>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<STYLE>
	.vis1	{ visibility:"visible" }
	.vis2	{ visibility:"hidden" }
</STYLE>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
//GeneratePro.createAll("workPlan");
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18181,user.getLanguage());
String type=Util.null2String(request.getParameter("type"));  //周期
String planDate=Util.null2String(request.getParameter("planDate"));  
String pName=Util.null2String(request.getParameter("pName"));  
String needfav ="1";
String needhelp ="";
String sum="0";
String resourceId = String.valueOf(user.getUID());	//默认为当前登录用户
String objId=Util.null2String((String)SessionOper.getAttribute(session,"hrm.objId"));
String type_d=Util.null2String((String)SessionOper.getAttribute(session,"hrm.type_d"));
if (rs1.getDBType().equals("oracle"))
rs1.executeSql("select sum(percent_n) from workPlan where objId="+objId+" and cycle='"+type+"' and  planType='"+type_d+"' and planDate='"+planDate+"' and type_n='6' ");
else if (rs1.getDBType().equals("db2"))
rs1.executeSql("select sum(double(percent_n)) from workPlan where objId="+objId+" and cycle='"+type+"' and  planType='"+type_d+"' and planDate='"+planDate+"' and type_n='6' ");
else
rs1.executeSql("select sum(convert(float,percent_n)) from workPlan where objId="+objId+" and cycle='"+type+"' and  planType='"+type_d+"' and planDate='"+planDate+"' and type_n='6' ");
if (rs1.next())
{
sum=Util.null2o(rs1.getString(1));
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:window.history.go(-1),_self} " ;
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

<FORM name=resource id=resource action="PlanOperation.jsp" method=post>
<input type=hidden name=operationType value="planAdd" >
<input type=hidden name=nodesumd>
<input type=hidden name=nodesumu>
<input type=hidden name=sum value=<%=sum%>>
<input type=hidden name=planDate value=<%=planDate%> >
<input type=hidden name=type value=<%=type%> >
<input type=hidden name=pName value=<%=pName%> >
   <TABLE class=ViewForm>
    <COLGROUP> 
    <COL width="50%"> 
    <COL width="50%"> 
    <TBODY> 
  
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=10%> <COL width=70%> <TBODY> 
          <TR class=title> 
            <TH colSpan=2 ><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=50 size=50 
            name=name  onchange='checkinput("name","nameimage")'>
			<SPAN id=nameimage>
			<IMG src='/images/BacoError.gif' align=absMiddle>
			</SPAN>
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=4 size=4 
            name=percent_n  onchange='checknumber("percent_n");checkinput("percent_n","pimage")'>%
			<SPAN id=pimage>
			<IMG src='/images/BacoError.gif' align=absMiddle>
			</SPAN>
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
            <TD class=Field> 
            <%=SystemEnv.getHtmlLabelName(18181,user.getLanguage())%>
              <input class=inputstyle name=type_n type="hidden" value="6">
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18191,user.getLanguage())%></TD>
            <TD class=Field> 
           <BUTTON class=Browser id=SelectTargetID onClick="onShowTarget('oppositeGoal','targetidspan')"></BUTTON> 
              <span 
            id=targetidspan><img src="/images/BacoError.gif" 
            align=absMiddle></span> 
              <INPUT class=inputStyle id=oppositeGoal 
            type=hidden name=oppositeGoal>
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
         
         <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></TD>
            <TD class=Field> 
             <%rs1.execute("select * from HrmPerformancePlanKindDetail order by sort");%>
              <select class=inputStyle id=planProperty 
              name=planProperty>
              <option value="0"> </option>
              <%while (rs1.next()) {%>
                <option value="<%=rs1.getString("id")%>"><%=rs1.getString("planName")%></option>
               <%}%></select>
               <!--计划性质-->
      
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(17478,user.getLanguage())%></TD>
            <TD class=Field> 
               <INPUT type="checkbox" name="isremind" onclick="onNeedRemind()" value="2">
				<SPAN id="remindspan" class="vis2">&nbsp;&nbsp;
				<INPUT name="waketime" maxlength="10" size="5" onKeyPress="ItemNum_KeyPress()" class="InputStyle">&nbsp;
				<SELECT name="unittype">
				<OPTION value="1" selected><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></OPTION>
				<OPTION value="2"><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></OPTION>
				</SELECT>
				</SPAN>
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></TD>
            <TD class=Field> 
              <%=user.getLastname()%>
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
            <TD class=Field> 
              <BUTTON class=Browser style="display:" onClick="onShowMultiHrmResourceNeeded('principal','hrmidspan','true')" name=showresource></BUTTON> 
			  <span 
              id=hrmidspan>
              <A href="/hrm/resource/HrmResource.jsp?id=<%=resourceId%>">
		      <%=Util.toScreen(resource.getResourcename(resourceId),user.getLanguage())%></A></span> 
              <INPUT class=inputStyle id=principal 
            type=hidden name=principal value="<%=resourceId%>">
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        
         <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18188,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(16936,user.getLanguage())%></TD>
            <TD class=Field> 
              <BUTTON class=Browser style="display:" onClick="onShowMultiHrmResourceNeeded('cowork','coworkidspan','false')" name=showresource></BUTTON> 
			  <span 
              id=coworkidspan></span> 
              <INPUT class=inputStyle id=cowork 
            type=hidden name=cowork>
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18183,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
            <TD class=Field> 
            <!--新增上下游部门/负责人-->
            <input type="hidden" name="upPrincipals">
            <BUTTON BUTTON class="WorkPlan" type=button accessKey=A onclick="addRow1()"><U>A</U><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
            <BUTTON BUTTON class="WorkPlan"  type=button accessKey=E onclick="deleteRow1()"><U>E</U><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
            <table Class=listStyle cols=2 id="oTable1" width="50%">
	      	<COLGROUP> 
	      	<COL width="10%"><COL width="90%">
	      
	    	</table>
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
         <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18184,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
            <TD class=Field> 
              <!--新增上下游部门/负责人-->
             <input type="hidden" name="downPrincipals">
            <BUTTON BUTTON class="WorkPlan" type=button accessKey=Q onclick="addRow2()"><U>Q</U><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
            <BUTTON BUTTON class="WorkPlan" type=button accessKey=W onclick="deleteRow2()"><U>W</U><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
            <table Class=listStyle cols=2 id="oTable2" width="50%">
	      	<COLGROUP> 
	      	<COL width="10%"><COL width="90%">
	       
	    	</table>
             
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18192,user.getLanguage())%></TD>
            <TD class=Field> 
              <textarea class=inputstyle name=teamRequest  rows="5" style="width:98%""></textarea>
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
          <TR>         
	<TD><%=SystemEnv.getHtmlLabelName(18182,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TD>
	  <TD class="Field"><BUTTON class="Calendar" id="rSelectBeginDate" onclick="getDate('rbegindatespan','rbegindate')"></BUTTON> 
		  <SPAN id="rbegindatespan">
		  <%=TimeUtil.getCurrentDateString()%></SPAN> 
		  <INPUT type="hidden" name="rbegindate" value="<%=TimeUtil.getCurrentDateString()%>">  
		  &nbsp;&nbsp;&nbsp;
		  <%=SystemEnv.getHtmlLabelName(277, user.getLanguage())%><BUTTON class="Clock" id="rSelectBeginTime" onclick="onShowTime(rbegintimespan,rbegintime)"></BUTTON>
		  <SPAN id="rbegintimespan"></SPAN>
		  <INPUT type="hidden" name="rbegintime" ></TD>
	</TR>
	<TR><TD class="Line" colSpan="2"></TD></TR>

	<TR>
	  <TD><%=SystemEnv.getHtmlLabelName(18182,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1035,user.getLanguage())%></TD>
	  <TD class="Field"><BUTTON class="Calendar" id="rSelectEndDate" onclick="getDate('renddatespan','renddate')"></BUTTON> 
		  <SPAN id="renddatespan"></SPAN> 
		  <INPUT type="hidden" name="renddate">  
		  &nbsp;&nbsp;&nbsp;
		  <%=SystemEnv.getHtmlLabelName(277, user.getLanguage())%><BUTTON class="Clock" id="rSelectEndTime" onclick="onShowTime(rendtimespan,rendtime)"></BUTTON>
		  <SPAN id="rendtimespan"></SPAN>
		  <INPUT type="hidden" name="rendtime"></TD>
	</TR>
	<TR><TD class="Line" colSpan="2"></TD></TR> 
        <TR>          
	<TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TD>
	  <TD class="Field"><BUTTON class="Calendar" id="SelectBeginDate" onclick="getDate('begindatespan','begindate')"></BUTTON> 
		  <SPAN id="begindatespan">
		    <%=TimeUtil.getCurrentDateString()%></SPAN> 
		  <INPUT type="hidden" name="begindate" value="<%=TimeUtil.getCurrentDateString()%>">  
		  &nbsp;&nbsp;&nbsp;
		  <%=SystemEnv.getHtmlLabelName(277, user.getLanguage())%><BUTTON class="Clock" id="SelectBeginTime" onclick="onShowTime(begintimespan,begintime)"></BUTTON>
		  <SPAN id="begintimespan"></SPAN>
		  <INPUT type="hidden" name="begintime"></TD>
	</TR>
	<TR><TD class="Line" colSpan="2"></TD></TR>

	<TR>
	  <TD><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TD>
	  <TD class="Field"><BUTTON class="Calendar" id="SelectEndDate" onclick="getDate('enddatespan','enddate')"></BUTTON> 
		  <SPAN id="enddatespan"></SPAN> 
		  <INPUT type="hidden" name="enddate">  
		  &nbsp;&nbsp;&nbsp;
		  <%=SystemEnv.getHtmlLabelName(277, user.getLanguage())%><BUTTON class="Clock" id="SelectEndTime" onclick="onShowTime(endtimespan,endtime)"></BUTTON>
		  <SPAN id="endtimespan"></SPAN>
		  <INPUT type="hidden" name="endtime"></TD>
	</TR>
	<TR><TD class="Line" colSpan="2"></TD></TR> 
	 <TR>
	  <TD><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></TD>
	  <TD class="Field">
		<BUTTON class="Browser" id="SelectCrm" onclick="onShowMultiCustomer('crmid','crmspan')"></BUTTON>		
		<SPAN id="crmspan"></SPAN> 
		<INPUT type="hidden" name="crmid" >
	  </TD>
	</TR>
	<TR><TD class="Line" colSpan="2"></TD></TR> 
	<TR>
	  <TD><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></TD>
	  <TD class="Field"><BUTTON class="Browser" id="SelectMultiDoc" onclick="onShowMultiDocs('docid','docspan')"></BUTTON>    
	  <SPAN id="docspan"></SPAN>
	  <INPUT type="hidden" name="docid" ></TD>
	</TR>
	<TR><TD class="Line" colSpan="2"></TD></TR> 
	<TR>
		<TD><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></TD>
		 <TD class="Field">
		 <BUTTON class="Browser" id="SelectMultiProject" onclick="onShowMultiProject('projectid','projectspan')"></BUTTON>      
		<SPAN id="projectspan"></SPAN>
		<INPUT type="hidden" name="projectid"></TD>
	</TR>
	<TR><TD class="Line" colSpan="2"></TD></TR>
	<TR>
		<TD><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></TD>
		 <TD class="Field">
		 <BUTTON class="Browser" id="SelectMultiRequest" onclick="onShowMultiRequest('requestid','requestspan')"></BUTTON>      
		<SPAN id="requestspan"></SPAN>
		<INPUT type="hidden" name="requestid"></TD>
	</TR>
	<TR><TD class="Line" colSpan="2"></TD></TR>
	<TR>
	  <TD><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></TD>
	  <TD class="Field"><TEXTAREA class="InputStyle" name="description" rows="5" style="width:98%" ></TEXTAREA>
      </TD>
	</TR>
	<TR><TD class="Line" colSpan="2"></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
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

<SCRIPT language="VBS" src="/js/browser/CustomerMultiBrowser.vbs"></SCRIPT>
<SCRIPT language="VBS" src="/js/browser/DocsMultiBrowser.vbs"></SCRIPT>
<SCRIPT language="VBS" src="/js/browser/ProjectMultiBrowser.vbs"></SCRIPT>
<SCRIPT language="VBS" src="/js/browser/RequestMultiBrowser.vbs"></SCRIPT>

<SCRIPT language="JavaScript" src="/js/OrderValidator.js"></SCRIPT>
<SCRIPT language="vbs">
Sub onShowDepartment(inputname, spanname)
    dim inputid
    oldValue=document.all(inputname).value
	retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&document.all(inputname).value)
	inputid=CStr(inputname)
    inputnamehrm=mid(inputid,1,instr(inputid,"_")-1)&"hrm_"&mid(inputid,instr(inputid,"_")+1,len(inputid))
    inputnamehrmspan=mid(inputid,1,instr(inputid,"_")-1)&"idspanhrm_"&mid(inputid,instr(inputid,"_")+1,len(inputid))
	If (Not IsEmpty(retValue)) Then
		If retValue(0) <> "" Then
			document.all(spanname).innerHtml = "<A href='/hrm/company/HrmDepartmentDsp.jsp?id="&retValue(0)&"'>"&retValue(1)&"</A>"
			document.all(inputname).value = retValue(0)
            If (retValue(0)<>oldValue) then
            document.all(inputnamehrm).value = ""
			document.all(inputnamehrmspan).innerHtml = ""
            End If
		Else 
			document.all(inputname).value = ""
			document.all(spanname).innerHtml = ""
            document.all(inputnamehrm).value = ""
			document.all(inputnamehrmspan).innerHtml = ""
			
		End If
	End If
End Sub

sub onShowResource(inputename,spanname)
o=window.event.srcElement.id
pos=instr(o,"_")
sid=mid(o,pos)
head=mid(o,1,pos-1)
if head="upPrincipalhrmid" then
heads="upPrincipal"
else
heads="downPrincipal"
end if 
heads=heads+sid

tmpids=document.all(heads).value

    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/performance/ResourceBrowser.jsp?departmentId="&tmpids)
        if (Not IsEmpty(id1)) then
        if id1(0)<> "" then
          resourceids = id1(0)
          resourcename = id1(1)
          sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&resourceids&">"&resourcename&"</a>&nbsp"
          document.all(spanname).innerHtml = sHtml
          document.all(inputename).value=resourceids
        else
          document.all(spanname).innerHtml =""
          document.all(inputename).value=""
        end if
         end if
end sub


sub onShowMultiHrmResourceNeeded(inputename,spanname,needed)
    tmpids = document.all(inputename).value
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&tmpids)
        if (Not IsEmpty(id1)) then
        if id1(0)<> "" then
          resourceids = id1(0)
          resourcename = id1(1)
          sHtml = ""
          resourceids = Mid(resourceids,2,len(resourceids))
          document.all(inputename).value= resourceids
          resourcename = Mid(resourcename,2,len(resourcename))
          while InStr(resourceids,",") <> 0
            curid = Mid(resourceids,1,InStr(resourceids,",")-1)
            curname = Mid(resourcename,1,InStr(resourcename,",")-1)
            resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
            resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
            sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&curid&">"&curname&"</a>&nbsp"
          wend
          sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&resourceids&">"&resourcename&"</a>&nbsp"
          document.all(spanname).innerHtml = sHtml
          
        else
          if needed then
          document.all(spanname).innerHtml ="<IMG src='/images/BacoError.gif' align=absMiddle>"
          end if
		 document.all(inputename).value=""
        end if
         end if
end sub
</SCRIPT>
<SCRIPT language="javascript">
function OnSubmit(){
      
      
    if(check_form(document.resource,"name,percent_n,principal,begindate,rbegindate,oppositeGoal")&&checkall()&&checkp()&&compareDate())
	{	
		document.resource.submit();
		enablemenu();
	}
}
function compareDate()
{
d1=document.resource.begindate.value;
d2=document.resource.enddate.value;
d3=document.resource.rbegindate.value;
d4=document.resource.renddate.value;
if (d1=="") d1="0000-00-00";
if (d2=="") d2="2222-01-01";
if (d3=="") d3="0000-00-00";
if (d4=="") d4="2222-01-01";
if (d1>d2||d3>d4) 
{
alert("<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>");
return false;
}
return true;
}
function checkp()
{
 if ((parseFloat(document.resource.percent_n.value)+parseFloat(document.resource.sum.value))>100) 
	     {
	     alert("<%=SystemEnv.getHtmlLabelName(18196,user.getLanguage())%>"+"<%=SystemEnv.getHtmlLabelName(15223,user.getLanguage())%>"+100);
	     return false;
	     }
	 return true;     
}
function checkall()
{
    document.all("nodesumd").value=rowindex2;
    document.all("nodesumu").value=rowindex1;
   
    for(i=0;i<rowindex1;i++)
    {   
       if ((document.all("upPrincipal_"+i).value!="")&&(document.all("upPrincipalhrm_"+i).value==""))
       {
          alert("<%=SystemEnv.getHtmlLabelName(18193,user.getLanguage())%>");
          document.all("upPrincipals").value="";
          return false;
       }
       if ((document.all("upPrincipal_"+i).value=="")&&(document.all("upPrincipalhrm_"+i).value==""))
       {
          alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>");
          document.all("upPrincipals").value="";
          return false;
       }
       if ((document.all("upPrincipal_"+i).value=="")&&(document.all("upPrincipalhrm_"+i).value!=""))
       {
          alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>");
          document.all("upPrincipals").value="";
          return false;
       }
       document.all("upPrincipals").value=document.all("upPrincipals").value+document.all("upPrincipal_"+i).value+"/"+document.all("upPrincipalhrm_"+i).value+",";
   
    }
      for(j=0;j<rowindex2;j++)
    {
       if ((document.all("downPrincipal_"+j).value!="")&&(document.all("downPrincipalhrm_"+j).value==""))
       {
          alert("<%=SystemEnv.getHtmlLabelName(18193,user.getLanguage())%>");
          document.all("downPrincipals").value="";
          return false;
       }
       if ((document.all("downPrincipal_"+j).value=="")&&(document.all("downPrincipalhrm_"+j).value==""))
       {
          alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>");
          document.all("upPrincipals").value="";
          return false;
       }
       if ((document.all("downPrincipal_"+j).value=="")&&(document.all("downPrincipalhrm_"+j).value!=""))
       {
          alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>");
          document.all("upPrincipals").value="";
          return false;
       }
     document.all("downPrincipals").value=document.all("downPrincipals").value+document.all("downPrincipal_"+j).value+"/"+document.all("downPrincipalhrm_"+j).value+",";  
    }
     
     return true;
}
function onNeedRemind() {
	if (document.all("isremind").checked) 
        document.all("remindspan").className = "vis1";
    else 
        document.all("remindspan").className = "vis2";
}
 

rowindex1 = 0 ;

function addRow1()
{	
	ncol = oTable1.cols;
	oRow = oTable1.insertRow();
	oRow.id="tr_"+rowindex1;
    oRow.customIndex = rowindex1;
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_type' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON id='upPrincipalid_"+rowindex1+"' class=Browser onClick=onShowDepartment('upPrincipal_"+rowindex1+"','upPrincipalidspan_"+rowindex1+"')></BUTTON>" ;
                sHtml=sHtml+"<span id='upPrincipalidspan_"+rowindex1+"'></span>"
			    sHtml=sHtml+"<INPUT class=inputStyle id='upPrincipal_"+rowindex1+"'  type=hidden name='upPrincipal_"+rowindex1+"'>";
				sHtml=sHtml+"<BUTTON id='upPrincipalhrmid_"+rowindex1+"' class=Browser  onClick=onShowResource('upPrincipalhrm_"+rowindex1+"','upPrincipalidspanhrm_"+rowindex1+"')></BUTTON>";
                sHtml=sHtml+"<span id='upPrincipalidspanhrm_"+rowindex1+"'></span>";
                sHtml=sHtml+"<INPUT class=inputStyle id='upPrincipalhrm_"+rowindex1+"'  type=hidden name='upPrincipalhrm_"+rowindex1+"'>";
				oDiv.innerHTML = sHtml;      
				oCell.appendChild(oDiv);  
				break;
			
			
			
		}
	}
	rowindex1 = rowindex1*1 +1;
}

function deleteRow1()
  
{   
    if(jQuery("input[name='check_type']:checked").length>0&&window.confirm("<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage())%>?")){
    len = document.forms[0].elements.length;
	for(i=len-1; i >= 0;i--){		
		if(document.forms[0].elements[i].name=='check_type'){
			if(document.forms[0].elements[i].checked==true) {
				delRowIndex = document.forms[0].elements[i].parentNode.parentNode.parentNode.rowIndex;
				oTable1.deleteRow(delRowIndex);
				rowindex1--;
			}
		}
	}
	}
}



rowindex2 = 0 ;

function addRow2()
{	var oTbody = oTable2;
	var ncol = oTbody.firstChild.childNodes.length;
	var oRow = oTbody.insertRow();
	//ncol = oTable2.cols;
	//oRow = oTable2.insertRow();
	oRow.id="tr2_"+rowindex2;
    oRow.customIndex = rowindex2;
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		oCell.style.height=24;
		oCell.style.background= "#efefef";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_type2' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<BUTTON id='downPrincipalid_"+rowindex2+"' class=Browser onClick=onShowDepartment('downPrincipal_"+rowindex2+"','downPrincipalidspan_"+rowindex2+"')></BUTTON>" ;
                sHtml=sHtml+"<span id='downPrincipalidspan_"+rowindex2+"'></span>"
			    sHtml=sHtml+"<INPUT class=inputStyle id='downPrincipal_"+rowindex2+"'  type=hidden name='downPrincipal_"+rowindex2+"'>";
				sHtml=sHtml+"<BUTTON id='downPrincipalhrmid_"+rowindex2+"' class=Browser  onClick=onShowResource('downPrincipalhrm_"+rowindex2+"','downPrincipalidspanhrm_"+rowindex2+"')></BUTTON>";
                sHtml=sHtml+"<span id='downPrincipalidspanhrm_"+rowindex2+"'></span>";
                sHtml=sHtml+"<INPUT class=inputStyle id='downPrincipalhrm_"+rowindex2+"'  type=hidden name='downPrincipalhrm_"+rowindex2+"'>";
				oDiv.innerHTML = sHtml;      
				oCell.appendChild(oDiv);  
				break;
			
			
			
		}
	}
	rowindex2 = rowindex2*1 +1;
}

function deleteRow2()
{
   if(jQuery("input[name='check_type2']:checked").length>0&&window.confirm("<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage())%>?")){
   len = document.forms[0].elements.length;
	for(i=len-1; i >= 0;i--){		
		if(document.forms[0].elements[i].name=='check_type2'){
			if(document.forms[0].elements[i].checked==true) {
				delRowIndex = document.forms[0].elements[i].parentNode.parentNode.parentNode.rowIndex;
				oTable2.deleteRow(delRowIndex);
				rowindex2--;
			}
		}
	}
	}
}

function onShowTarget(inputename,spanname){
    var cycle1=<%=type%>
    if ("<%=type%>"=="0") {
         cycle="3"
    }else if("<%=type%>"=="1") {
        cycle="1"
    }else if("<%=type%>"=="2") {
         cycle="0"
	}else if("<%=type%>"=="3") {
         cycle="0"
    }
    var planDate="<%=planDate%>";
    var temp=planDate+"||"+cycle+"-"+cycle1;
    var id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/performance/goal/myGoalBrowserForPlan.jsp?temp="+temp);
        if (id1) {
        if (id1.id!="") {
          resourceids = id1.id;
          resourcename = id1.name;
          
          document.all(spanname).innerHTML = resourcename;
          document.all(inputename).value=resourceids;
        }else{
          document.all(spanname).innerHTML ="<IMG src='/images/BacoError.gif' align=absMiddle>"
          document.all(inputename).value=""
        }
      }
}

</script>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</BODY>
</HTML>
