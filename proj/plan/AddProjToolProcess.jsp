<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="VerifyPower" class="weaver.proj.VerifyPower" scope="page" />

<%
String begindate="";
String enddate="";
String workday="";
String taskrecordid = Util.null2String(request.getParameter("taskrecordid"));
RecordSet.executeProc("Prj_TaskProcess_SelectByID",taskrecordid);
if(RecordSet.next()){
	begindate=RecordSet.getString("begindate");
	enddate=RecordSet.getString("enddate");
	workday=RecordSet.getString("workday");
}
String ProjID = RecordSet.getString("prjid");

String logintype = ""+user.getLogintype();
/*Ȩ�ޣ�begin*/
boolean canview=false;
boolean canedit=false;
boolean iscreater=false;
boolean ismanager=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
boolean isshare=false;
String iscustomer="0";

VerifyPower.init(request,response,ProjID);
if(logintype.equals("1")){
	iscreater = VerifyPower.isCreater();
	ismanager = VerifyPower.isManager();
	if(!iscreater && !ismanager){
		ismanagers = VerifyPower.isManagers();
	}
	if(!iscreater && !ismanager && !ismanagers){
		isrole = VerifyPower.isRole();
	}
}

if(iscreater || ismanager || ismanagers || isrole){
	canedit = true;
}

if(!canedit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*Ȩ�ޣ�end*/

RecordSet2.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet2.getCounts()<=0)
	response.sendRedirect("/proj/DBError.jsp?type=FindData_VP");
RecordSet2.first();

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdPRJ.gif";
String titlename =SystemEnv.getHtmlLabelName(1326,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:history.back(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver action="ProjToolProcessOperation.jsp" method=post >
<input type="hidden" name="method" value="add">
<input type="hidden" name="taskrecordid" value="<%=taskrecordid%>">

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

<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width=80%>
  <TBODY>
  <TR class=spacing>
          <TD class=line1 colSpan=2></TD></TR>
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1326,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Browser id=Selectrelateid onClick="onShowrelateid()"></BUTTON> <span 
            id=Prjrelateidspan><IMG src='/images/BacoError.gif' align=absMiddle></span> 
              <INPUT class=inputstyle type=hidden name="relateid"></TD>
        </TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(481,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(617,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Calendar onclick="getDate(BDatePspan,BDateP)"></BUTTON> 
              <SPAN id=BDatePspan >
			  	  <%if(!begindate.equals("x")){%>
						<%=begindate%>
				  <%}%> 			  
			  </SPAN> 
              <input type="hidden" name="begindate" id="BDateP" value=<%=begindate%>>-<BUTTON class=Calendar onclick="getDate(EDatePspan,EDateP)"></BUTTON> 
              <SPAN id=EDatePspan >
			  	  <%if(!enddate.equals("-")){%>
						<%=enddate%>
				  <%}%>  			  
			  </SPAN> 
              <input type="hidden" name="enddate" id="EDateP"  value=<%=enddate%>></TD>
	</TR>
	 <TR>
	 <TD><%=SystemEnv.getHtmlLabelName(1324,user.getLanguage())%></TD>
	  <TD class=Field><INPUT class=inputstyle maxLength=5 size=5 name="workday" value=<%=workday%> onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("workday")'><SPAN id=workdayimage></SPAN></TD>
	 </TR>
	 <TR>
	 <TD><%=SystemEnv.getHtmlLabelName(1327,user.getLanguage())%></TD>
	  <TD class=Field><INPUT class=inputstyle maxLength=10 size=10 name="cost" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("cost")'> <span 
		id=fixedcostspan></span> </TD>
	 </TR>
        
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

</form>
<script language=vbs>
sub onShowrelateid()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	Prjrelateidspan.innerHtml = "<A href='/cpt/capital/CptCapital.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	weaver.relateid.value=id(0)
	else 
	Prjrelateidspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	weaver.relateid.value=""
	end if
	end if
end sub
</script>
<script language="javascript">
function submitData()
{if (check_form(weaver,'relateid'))
		weaver.submit();
}
</script>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</html>