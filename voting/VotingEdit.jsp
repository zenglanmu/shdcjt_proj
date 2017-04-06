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
String titlename = SystemEnv.getHtmlLabelName(17599,user.getLanguage());
String needfav ="1";
String needhelp ="";

String userid=user.getUID()+"";
String votingid=Util.fromScreen(request.getParameter("votingid"),user.getLanguage());

boolean canmaint=HrmUserVarify.checkUserRight("Voting:Maint", user);
boolean canedit=false ;

RecordSet.executeProc("Voting_SelectByID",votingid);
RecordSet.next();
String subject=RecordSet.getString("subject");
String detail=RecordSet.getString("detail");
String createrid=RecordSet.getString("createrid");
String createdate=RecordSet.getString("createdate");
String createtime=RecordSet.getString("createtime");
String approverid=RecordSet.getString("approverid");
String approvedate=RecordSet.getString("approvedate");
String approvetime=RecordSet.getString("approvetime");
String begindate=RecordSet.getString("begindate");
String begintime=RecordSet.getString("begintime");
String enddate=RecordSet.getString("enddate");
String endtime=RecordSet.getString("endtime");
String isanony=RecordSet.getString("isanony");
String docid=RecordSet.getString("docid");
String crmid=RecordSet.getString("crmid");
String projectid=RecordSet.getString("projid");
String requestid=RecordSet.getString("requestid");
String votingcount = RecordSet.getString("votingcount");
String status = RecordSet.getString("status");
String isSeeResult = RecordSet.getString("isSeeResult");//投票后是否可以查看结果
int votingtype = Util.getIntValue(RecordSet.getString("votingtype"));//调查类型

if(userid.equals(createrid) || userid.equals(approverid))
    canedit=true ;
if(canmaint)
    canedit=true ;
if(!"".equals(userid)) canedit=true;
if(!canedit){
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

        RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete()',_top} "  ;
        RCMenuHeight += RCMenuHeightStep ;

        RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1)',_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
    %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form name=frmmain action="VotingOperation.jsp" method=post onsubmit="return check_form(this,'subject,creater,begindate')">
<input type=hidden name=method value="edit">
<input type=hidden name=votingid value="<%=votingid%>">
<input type=hidden name=votingcount value="<%=votingcount%>">
<input type=hidden name=status value="<%=status%>">
<input type=hidden name="createrid" value="<%=createrid%>">
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
<table class=Viewform>
<col width=15%><col width=35%><col width=15%><col width=35%>
  <TR>
    <TH colSpan=4><div align="left"><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></div></TH></TR>
  <TR style="height: 1px!important;"><TD class=line1 colSpan=4></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
    <td class=field>
    <input type=input name="subject" class="inputstyle" value="<%=subject%>" onchange=checkinput('subject','subjectspan') style="width:90%">
    <span id="subjectspan">
    
    <%if ("".equals(subject)){
        out.println("<IMG src='/images/BacoError.gif'      align=absMiddle>");}%>
    
    </span> 
    </td>
    <td><%=SystemEnv.getHtmlLabelName(24111,user.getLanguage())%></td>
    <td class=field>    
          <select name="votingtype">
              <option value="0"></option>
             <% 
	          RecordSet.executeSql("select * from voting_type");
	          while(RecordSet.next()) {
	        	  int votingtypeid = RecordSet.getInt("id");
	         %>
               <option value="<%=votingtypeid%>" <%if(votingtype == votingtypeid){%>selected<%}%>><%=RecordSet.getString("typename")%></option>
             <%}%>
          </select>        
    </td>
  </tr>
  <TR style="height: 1px!important;"><TD class=line colSpan=4></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
    <td class=field>
        <BUTTON class=Calendar type="button" onclick="onShowDate(BeginDatespan,begindate)"></BUTTON>
    	<SPAN id=BeginDatespan><%=begindate%> <%if ("".equals(begindate)){
        out.println("<IMG src='/images/BacoError.gif'      align=absMiddle>");}%></SPAN>
    	<input type="hidden" name="begindate" value="<%=begindate%>">
    </td>
    <td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
    <td class=field>
        <button class=Clock type="button" onclick="onShowTime(BeginTimespan,begintime)"></button>
    	<span id="BeginTimespan"><%=begintime%></span>
    	<INPUT type=hidden name="begintime" id="begintime" value="<%=begintime%>">
    </td>
  </tr>
  <TR style="height: 1px!important;"><TD class=line colSpan=4></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
    <td class=field>
        <BUTTON class=Calendar type="button" onclick="onShowDate1('EndDatespan','enddate')"></BUTTON>
    	<SPAN id=EndDatespan><%=enddate%></SPAN>
    	<input type="hidden" name="enddate" id="enddate" value="<%=enddate%>">
    </td>
    <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
    <td class=field>
        <button class=Clock type="button" onclick="onShowTime(EndTimespan,endtime)"></button>
    	<span id="EndTimespan"><%=endtime%></span>
    	<INPUT type=hidden name="endtime" id="endtime" value="<%=endtime%>">
  </tr>
  <TR style="height: 1px!important;"><TD class=line colSpan=4></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
    <td class=field>
         <input class="wuiBrowser" _displayText="<%=DocComInfo.getDocname(docid)%>" _url="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp" _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}' target='_blank'>#b{name}</a>" type=hidden name='docid' value='<%=docid%>'>
        
    </td>
    <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
    <td class=field>
     <input class="wuiBrowser" _displayText="<%=CustomerInfoComInfo.getCustomerInfoname(crmid)%>" _displayTemplate="<a href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}' target='_blank'>#b{name}</a>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" type=hidden name='crmid' value='<%=crmid%>'>
      
  </tr>
  <TR style="height: 1px!important;"><TD class=line colSpan=4></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></td>
    <td class=field>
     <input class="wuiBrowser" _displayText="<%=ProjectInfoComInfo.getProjectInfoname(projectid)%>" _displayTemplate="<a href='/proj/data/ViewProject.jsp?ProjID=#b{id}' target='_blank'>#b{name}</a>" _url="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp" type=hidden name='projectid'  value='<%=projectid%>'>
        
    </td>
    <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
    <td class=field>
     <input class="wuiBrowser" _displayText="<%=RequestComInfo.getRequestname(requestid)%>"  _displayTemplate="<a href='/workflow/request/ViewRequest.jsp?requestid=#b{id}' target='_blank'>#b{name}</a>"  type=hidden  _url="/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp" name='requestid' value='<%=requestid%>'>
  </tr>  
  <TR style="height: 1px!important;"><TD class=line colSpan=4></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(18576,user.getLanguage())%></td>
    <td class=field>
    <input type=checkbox name="isanony"  class="inputstyle" <%if(isanony.equals("1")){%> checked <%}%> value="1">
    </td>   
    <td valign=top><%=SystemEnv.getHtmlLabelName(21723,user.getLanguage())%></td>
    <td valign=top class=field>
      <input type=checkbox name="isSeeResult"  class="inputStyle" <%if("1".equals(isSeeResult)){%> checked <%}%> value="1">
    </td>
  </tr>
  <TR style="height: 1px!important;"><TD class=line colSpan=4></TD></TR>
  <tr>   
    <td valign=top><%=SystemEnv.getHtmlLabelName(16284,user.getLanguage())%></td>
    <td class=field colSpan=3>
    <textarea name="detail" class="inputstyle" rows=3 style="width:100%"><%=Util.fromHtmlToEdit(detail)%></textarea>
    </td>
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
<script language=javascript>
 function doDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmmain.method.value="delete";
			document.frmmain.submit();
			enableAllmenu();
		}
}
</script>
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
//-->
</SCRIPT>