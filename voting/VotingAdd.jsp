<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
<SCRIPT language="javascript" src="../../js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="../../js/JSDateTime/WdatePicker.js"></script>
<script type="text/javascript" src="../../js/selectDateTime.js"></script>
</head>
<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(17599,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(82,user.getLanguage());
String needfav ="1";
String needhelp ="";

String userid=user.getUID()+"";
boolean canmaint=HrmUserVarify.checkUserRight("Voting:Maint", user);
boolean cancreate=false ;
RecordSet.executeSql("select id from votingmaintdetail where createrid="+userid);
if(RecordSet.next())
    cancreate=true ;
if(canmaint)    cancreate=true ;
if(!"".equals(userid)) cancreate=true;

if(!cancreate){
    response.sendRedirect("/notice/noright.jsp");
    return ;
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
    <%
        RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onFrmSubmit()',_top} " ;
        RCMenuHeight += RCMenuHeightStep ;

         RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1)',_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
    %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<form name=frmmain action="VotingOperation.jsp" method=post >
<input type=hidden name=method value="add">
<input type=hidden name=votingcount value="0">
<input type=hidden name=status value="0">
<input type=hidden name="createrid" value="<%=userid%>">
 <TABLE width=100% height=100% border="0" cellspacing="0">
      <colgroup>
        <col width="10">
          <col width="">
            <col width="10">
              <tr>
                <td height="10" colspan="3"></td>
              </tr>
              <tr>
                <td></td>
                <td valign="top">  
                <form name="frmSubscribleHistory" method="post" action="">
                  <TABLE class=Shadow>
                    <tr>
                      <td valign="top">
<table class="ViewForm">
<col width=15%><col width=35%><col width=15%><col width=35%>
  <TR class=Section>
    <TH colSpan=4><div align="left"><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></div></TH></TR>
  <TR style="height: 1px!important;"><TD class=line1 colSpan=4></TD></TR>  
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
    <td class=field>
    <input type=input id="subject" name="subject" value="" class="inputStyle"   onchange=checkinput('subject','subjectspan') style="width:90%">
    <span id="subjectspan"><IMG src="/images/BacoError.gif" align=absMiddle></span>
    </td>
    <td><%=SystemEnv.getHtmlLabelName(24111,user.getLanguage())%></td>
    <td class=field>    
          <select name="votingtype">
              <option value="0"></option>
             <% 
	          RecordSet.executeSql("select * from voting_type");
	          while(RecordSet.next()) {
	         %>
               <option value="<%=RecordSet.getString("id")%>"><%=RecordSet.getString("typename")%></option>
             <%}%>
          </select>        
    </td>
  </tr>
  <TR style="height: 1px!important;"><TD class=line colSpan=4></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
    <td class=field>
        <BUTTON class=Calendar type="button" onclick="onShowVotingDate('BeginDatespan','begindate')"></BUTTON>
    	<SPAN id=BeginDatespan><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>
    	<input type="hidden" id="begindate" name="begindate" id="onFrmSubmit" value="">
    </td>
    <td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
    <td class=field>
        <button class=Clock type="button" onclick="onShowTime(BeginTimespan,begintime)"></button>
    	<span id="BeginTimespan"></span>
    	<INPUT type=hidden name="begintime" value="">
    </td>
  </tr>
  <TR style="height: 1px!important;"><TD class=line colSpan=4></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
    <td class=field>
        <BUTTON class=Calendar type="button" onclick="onShowDate1(EndDatespan,enddate)"></BUTTON>
    	<SPAN id=EndDatespan></SPAN>
    	<input type="hidden" name="enddate" value="">
    </td>
    <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
    <td class=field>
        <button class=Clock type="button" onclick="onShowTime(EndTimespan,endtime)"></button>
    	<span id="EndTimespan"></span>
    	<INPUT type=hidden name="endtime" value="">
  </tr>
  <TR style="height: 1px!important;"><TD class=line colSpan=4></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
    <td class=field>
        
        
        <input class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp" _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}' target='_blank'>#b{name}</a>" type=hidden name='docid' value=''>
    </td>
    <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
    <td class=field>
        
        <input class="wuiBrowser" _displayTemplate="<a href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}' target='_blank'>#b{name}</a>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" type=hidden name='crmid' value=''>
  </tr>
  <TR style="height: 1px!important;"><TD class=line colSpan=4></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></td>
    <td class=field>
        
        <input class="wuiBrowser" _displayTemplate="<a href='/proj/data/ViewProject.jsp?ProjID=#b{id}' target='_blank'>#b{name}</a>" _url="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp" type=hidden name='projectid' value=''>
    </td>
    <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
    <td class=field>
        
        <input class="wuiBrowser" _displayTemplate="<a href='/workflow/request/ViewRequest.jsp?requestid=#b{id}' target='_blank'>#b{name}</a>"  type=hidden  _url="/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp" name='requestid' value=''>
  </tr>
  <TR style="height: 1px!important;"><TD class=line colSpan=4></TD></TR>
  <tr>    
    <td><%=SystemEnv.getHtmlLabelName(18576,user.getLanguage())%></td>
    <td class=field>
    <input type=checkbox class="inputStyle" name="isanony" value="1">
    </td>
    <td valign=top><%=SystemEnv.getHtmlLabelName(21723,user.getLanguage())%></td>
    <td valign=top class=field>
      <input type=checkbox class="inputStyle" name="isSeeResult" value="1">
   </td>
  </tr>
  <TR style="height: 1px!important;"><TD class=line colSpan=4></TD></TR>
  <tr>
    <td valign=top><%=SystemEnv.getHtmlLabelName(16284,user.getLanguage())%></td>
    <td class=field colSpan=3><textarea name="detail" class="inputStyle" rows=3 style="width:100%"></textarea></td>
  </tr>
  <TR style="height: 1px!important;"><TD class=line colSpan=4></TD></TR>
</table>

                    </td>
                    </tr>
                  </TABLE>  
                  </form>
                </td>
                <td></td>
              </tr>
              <tr>
                <td height="10" colspan="3"></td>
              </tr>
            </table>
</form>

</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
<!--
function onFrmSubmit(){
    if(check_form(document.frmmain,"subject,creater,begindate")){
		document.frmmain.submit();
		enableAllmenu();
	}
}

function onShowVotingDate(spanname,inputname){	
	  var returnvalue;
	  var oncleaingFun = function(){
		   $(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
           $(inputname).value = '';
	      }
	   WdatePicker({el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
        jQuery("#"+inputname)[0].value = returnvalue;$dp.$(spanname).value = returnvalue;},oncleared:oncleaingFun});
        
        var hidename = $(inputname).value;
		 if(hidename != ""){
			$(inputname).value = hidename; 
			$(spanname).innerHTML = hidename;
		 }else{
		  $(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		 }
}
//-->
</SCRIPT>