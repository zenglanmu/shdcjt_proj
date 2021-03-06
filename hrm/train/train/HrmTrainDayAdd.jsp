<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />
<jsp:useBean id="TrainResourceComInfo" class="weaver.hrm.train.TrainResourceComInfo" scope="page" />
<%
/*if(!HrmUserVarify.checkUserRight("HrmTrainEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}*/
%>
<html>

<%
String trainid = request.getParameter("trainid");
/**
 * Added By Charoes Huang on May 18,2004
 * Get the startDate and endDate of the HrmTrain
  */
String sqlstr ="";
String startDate ="";
String endDate ="";
if(!trainid.equals("")){
    sqlstr = "Select startdate,enddate from HrmTrain WHERE id="+trainid;
    rs.executeSql(sqlstr);
    rs.next();
    startDate = rs.getString("startdate");
    endDate = rs.getString("enddate");
}
String actor = "";
String sql = "select planactor from HrmTrainPlan where id = (select planid from HrmTrain where id = "+trainid+")";	
rs.executeSql(sql);
rs.next();
actor = rs.getString("planactor");
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(678,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(2211,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/train/HrmTrainEdit.jsp?id="+trainid+",_self} " ;
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
<FORM id=weaver name=frmMain action="TrainDayOperation.jsp" method=post >
<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6128,user.getLanguage())%></TH></TR>
  <TR class=spacing>
    <TD class=line1 colSpan=2 ></TD>
  </TR>
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
          <td class=Field>
            <BUTTON class=Calendar id=selectstartdate onclick="getDate(dayspan,day)" onchange='checkinput("day","dayspan")'></BUTTON> 
            <SPAN id=dayspan ><IMG src="/images/BacoError.gif" align=absMiddle></SPAN> 
            <input class=inputstyle type="hidden" id="day" name="day" >            
          </td>
        </tr>  
        <TR><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></td>
          <td class=Field>
            <textarea class=inputstyle cols=50 rows=4 name=content ></textarea>
          </td>
        </tr>   
        <TR><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%> </td>
          <td class=Field>
            <textarea class=inputstyle  cols=50 rows=4 name=aim></textarea>            
          </td>
        </tr>   
        <TR><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(16140,user.getLanguage())%> </td>
          <td class=Field>
	      <BUTTON class=Browser onClick="onShowResource(actor,actorspan)">
	      </BUTTON> 
	      <span class=inputStyle id=actorspan><%=ResourceComInfo.getMulResourcename(actor)%>
	      </span> 
	      <INPUT class=inputStyle id=actor type=hidden name=actor value="<%=actor%>">
	      </td>	   
        </tr>   
        <TR><TD class=Line colSpan=2></TD></TR> 
  </TBODY>
</TABLE> 
<input class=inputstyle type="hidden" name=operation> 
<input class=inputstyle type=hidden name=trainid value=<%=trainid%>>

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
sub onShowResource(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+inputname.value)
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
			sHtml = sHtml&"<a href=javascript:openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id="&curid&"')>"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href=javascript:openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id="&resourceids&"')>"&resourcename&"</a>&nbsp"
		spanname.innerHtml = sHtml
	else
    	spanname.innerHtml = ""
    	inputname.value="0"
	end if
	end if
end sub

sub onShowTrainResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/train/trainresource/HrmTrainResourceBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	resourcespan.innerHtml = id(1)
	frmMain.resource.value=id(0)
	else
	resourcespan.innerHtml = ""
	frmMain.resource.value=""
	end if
	end if
end sub

</script>
<script language=javascript>
function dosave(){
if(check_form(document.frmMain,'day')&&checkDateValidity()){
    document.frmMain.operation.value="add";
    document.frmMain.submit();
    }
  }

function checkDateValidity(){
    var isValid = true;
    var selectDay = frmMain.day.value;
    var startDate ="<%=startDate%>";
    var endDate ="<%=endDate%>";
    if(compareDate(startDate,selectDay)==1 || compareDate(selectDay,endDate)==1){
        alert("培训日期必须在"+startDate+"和"+endDate+"之间");
        isValid = false;
    }
    return isValid;
}
/**
 *Author: Charoes Huang
 *compare two date string ,the date format is: yyyy-mm-dd hh:mm
 *return 0 if date1==date2
 *       1 if date1>date2
 *       -1 if date1<date2
*/
function compareDate(date1,date2){
	//format the date format to "mm-dd-yyyy hh:mm"
	var ss1 = date1.split("-",3);
	var ss2 = date2.split("-",3);

	date1 = ss1[1]+"-"+ss1[2]+"-"+ss1[0];
	date2 = ss2[1]+"-"+ss2[2]+"-"+ss2[0];

	var t1,t2;
	t1 = Date.parse(date1);
	t2 = Date.parse(date2);
	if(t1==t2) return 0;
	if(t1>t2) return 1;
	if(t1<t2) return -1;

    return 0;
}
 </script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
