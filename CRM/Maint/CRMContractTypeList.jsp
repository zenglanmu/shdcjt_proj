<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<%
//added by XWJ on 2005-03-16 for td:1549
String propertyOfApproveWorkFlow = Util.null2String(request.getParameter("propertyOfApproveWorkFlow"));

boolean canedit = HrmUserVarify.checkUserRight("CRM_ContractTypeAdd:Add",user);
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>

<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(6083,user.getLanguage());
String needfav ="1";
String needhelp ="";

String name="";
String contractdesc="";
String workflowid="";
String id=Util.null2String(request.getParameter("id"));
if(!id.equals("")){
	RecordSet.executeProc("CRM_ContractType_SelectById",id);
	if(RecordSet.next()){
	 name=Util.null2String(RecordSet.getString("name"));
	 contractdesc=Util.null2String(RecordSet.getString("contractdesc"));
	 workflowid = Util.null2String(RecordSet.getString("workflowid"));
	}
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(canedit){
	if(id.equals(""))
	RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:doSave1(),_top} " ;
	else
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave1(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_top} " ;
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
<%
if(msgid!=-1) {
%>
<DIV>
<FONT color="red" size="2">
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</FONT>
</DIV>
<%}%>

<%
if(canedit){
%>
<FORM id=weaver name=weaver action="/CRM/Maint/CRMContractTypeOperation.jsp" method=post >
<%if(id.equals("")){%>
	<input type="hidden" name="method" value="add">
<%}else{%>
	<input type="hidden" name="method" value="edit">
<%}%>
<input type="hidden" name="id" value="<%=id%>">

<%--added by XWJ on 2005-03-16 for td:1549--%>
<input type="hidden" name="propertyOfApproveWorkFlow" value="<%=propertyOfApproveWorkFlow%>">

<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="100%">
  <TBODY>
  <TR>
    <TD vAlign=top>
      <TABLE class=ViewForm>
      <COLGROUP>
  	<COL width="20%">
  	<COL width="80%">
        <TBODY>
		<TR >
        <TD colSpan=2>
		<BUTTON class=btnNew accessKey=A  id=domysave  style="display:none"  onclick ="doSave1()"><U>A</U>-<%if(id.equals("")){%><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%><%}%></BUTTON> 
		</TD></TR>
         <TR class=Spacing style='height:1px'>
          <TD class=Line1 colSpan=2></TD>
	    </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=20 name="name" onchange='checkinput("name","nameimage")' value="<%=name%>"><SPAN id=nameimage><%if(name.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></SPAN></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=40 name="contractdesc" onchange='checkinput("contractdesc","contractdescimage")' value="<%=contractdesc%>"><SPAN id=contractdescimage><%if(name.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></SPAN></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<tr> 
            <td><%=SystemEnv.getHtmlLabelName(1003,user.getLanguage())%></td>
            <td class=Field> 
             
              <input class="wuiBrowser" _displayText="<%=Util.toScreen(WorkflowComInfo.getWorkflowname(workflowid),user.getLanguage())%>" _url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere= where isbill=1 and formid=49" type=hidden name="workflowid" value="<%=workflowid%>">
            </td>
          </tr>		
		<tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        </TBODY></TABLE></TD>
    </TR></TBODY></TABLE>
</FORM>
<FORM id=weaverD action="/CRM/Maint/CRMContractTypeOperation.jsp" method=post>
<input type="hidden" name="method" value="delete">

<%--added by XWJ on 2005-03-16 for td:1549--%>
<input type="hidden" name="propertyOfApproveWorkFlow" value="<%=propertyOfApproveWorkFlow%>">

<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="20%">
  <COL width=80%>
  <TBODY>
           <TR>
          <TD colSpan=2>
		  <BUTTON class=btnDelete id=Delete accessKey=D   style="display:none"  type=submit onClick="return isdel()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
	  
		  </TD>
        </TR>
  </TBODY>
</TABLE>
<%}%>
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="5%">
  <COL width="25%">
  <COL width="40%">
  <COL width="30%">
  <TBODY>
  <TR class=Header>
  <th></th>
  <th><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(1003,user.getLanguage())%></th>
  </tr>
<TR class=Line><TD colSpan=4 style="padding: 0"></TD></TR>
<%
RecordSet.executeProc("CRM_ContractType_Select","");
boolean isLight = false;
	while(RecordSet.next())	{	
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
		<th width=10><%if(canedit){%><input type=checkbox name=CRM_ContractIDs value="<%=RecordSet.getString("id")%>"><%}%></th>
		<TD><a href="/CRM/Maint/CRMContractTypeList.jsp?propertyOfApproveWorkFlow=<%=propertyOfApproveWorkFlow%>&id=<%=RecordSet.getString("id")%>"><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%></a></TD>
		<TD><%=Util.toScreen(RecordSet.getString("contractdesc"),user.getLanguage())%></TD>
		<TD><%=WorkflowComInfo.getWorkflowname(RecordSet.getString("workflowid"))%></TD>
	</TR>
<%
	}
%>
 </TABLE>
<%if(canedit){
%>
</FORM>
<%}%>
<script language=javascript>
function doSave1(){	
	if (check_form(document.forms[0],"name,contractdesc")) 
	document.forms[0].submit();
	}
function doDel(){
	if(isdel){
		document.forms[1].submit();
	}
}
//	added by XWJ on 2005-03-16 for td:1549

</script>




</BODY>
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
</HTML>
