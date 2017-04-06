<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CareerApplyComInfo" class="weaver.hrm.career.HrmCareerApplyComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<html>

<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String id = Util.null2String(request.getParameter("id"));
String planid = Util.null2String(request.getParameter("planid"));
String sql = "select lastname from HrmCareerApply where id ="+id;
rs.executeSql(sql);
rs.next();
String name = Util.null2String(rs.getString("lastname"));

String step = CareerApplyComInfo.getStep(id);
String stepname = CareerApplyComInfo.getStepname(id);

String date = "" ;
String time = "" ;
String address = "" ;
String notice = "" ;
String interviewer = "" ;

sql = "select * from HrmInterview where resourceid = "+id+ " and stepid = "+step;
rs.executeSql(sql);
if( rs.next() ) {
    date = Util.null2String(rs.getString("date_n"));
    time = Util.null2String(rs.getString("time"));
    address = Util.null2String(rs.getString("address"));
	notice = Util.fromScreen(rs.getString("notice"),user.getLanguage());
    interviewer = Util.null2String(rs.getString("interviewer"));
}

boolean isInformer = CareerApplyComInfo.isInformer(id,user.getUID());  

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(6134,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(6103,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if( isInformer ) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
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
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

  <FORM name=resource id=resource action="HrmInterviewOperation.jsp" method=post>
    <input class=inputstyle type=hidden name=operation value="plan">
    <input class=inputstyle type=hidden name=planid value="<%=planid%>">
      <TABLE class=viewForm>
      <COLGROUP> <COL width="49%"> <COL width=10> <COL width="49%"> 
      <TBODY>
      <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> 
          <COL width=30%> 
          <COL width=70%> 
          <TBODY> 
          <TR class=title> 
            <TH colSpan=2 height="19"><%=SystemEnv.getHtmlLabelName(15729,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=2></TD>
          </TR>  
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15732,user.getLanguage())%></TD>
            <TD class=Field>
              <%=name%>
              <input class=inputstyle type=hidden name=resourceid value=<%=id%>>              
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(15731,user.getLanguage())%></td>
            <td class=Field>
              <%=stepname%>       
              <input class=inputstyle type=hidden name=step value=<%=step%>>
            </td>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15733,user.getLanguage())%></TD>
            <TD class=Field>
            <% if( isInformer ) { %>
            <BUTTON class=Calendar id=selectdate onclick="getDate(datespan,date)"></BUTTON> 
              <SPAN id=datespan ><%=date%></SPAN> 
              <input class=inputstyle type="hidden" name="date" value="<%=date%>">
            <%} else {%>
            <%=date%>
            <%}%>
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15734,user.getLanguage())%></TD>
            <TD class=Field>
              <% if( isInformer ) { %>
              <button class=Clock onclick="onShowTime(Timespan,time)"></button>
              <span id="Timespan"><%=time%></span>
              <input class=inputstyle type=hidden name="time" value=<%=time%>>
              <%} else {%>
                <%=time%>
              <%}%>
            </TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15735,user.getLanguage())%></TD>
            <td class=field>
              <% if( isInformer ) { %>
              <input class=inputstyle type=text name=address value=<%=address%>>
              <%} else {%>
                <%=address%>
              <%}%>
            </td>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(15736,user.getLanguage())%></td>
            <td class=Field>
              <% if( isInformer ) { %>
              <textarea rows=5 cols=40 name="notice"><%=Util.toScreenToEdit(notice,user.getLanguage())%></textarea>
              <%} else {%>
                <%=notice%>
              <%}%>
            </td>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 
          <!--         
          <TR>
            <td>√Ê ‘’ﬂ</td>
            <td class=Field>
              <BUTTON class=Browser onClick="onShowResource(interviewer,interviewerspan)">
	      </BUTTON> 
	      <span class=inputstyle id=interviewerspan>
	      <%=ResourceComInfo.getMulResourcename(interviewer)%>
	      </span> 
	      <INPUT class=inputstyle id=interviewer type=hidden name=interviewer value=<%=interviewer%>>
            </td>
          </TR>
          -->           
      </tbody>
    </table>
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
<script language=vbs>  
sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?status=1 ")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.resourceid.value=id(0)
	else 
	resourceidspan.innerHtml = ""
	resource.resourceid.value=""
	end if
	end if
end sub

sub onShowResource(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
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
			sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
		spanname.innerHtml = sHtml
	else	
    	spanname.innerHtml = ""
    	inputname.value="0"
	end if
	end if
end sub

</script>
<script language=javascript>
function doSave() {
   document.resource.submit() ;
}
function doDelete() {
  if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
   document.resource.operation.value="plandelete";
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
</body>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
</html>