<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<%
boolean canedit_share = HrmUserVarify.checkUserRight("EditCustomerType:Edit",user);
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String id = request.getParameter("id");

	RecordSet.executeProc("CRM_CustomerType_SelectByID",id);

	if(RecordSet.getFlag()!=1)
	{
		response.sendRedirect("/CRM/DBError.jsp?type=FindData");
		return;
	}
	if(RecordSet.getCounts()<=0)
	{
		response.sendRedirect("/CRM/DBError.jsp?type=FindData");
		return;
	}
	RecordSet.first();


RecordSetShare.executeProc("CRM_T_ShareInfo_SbyRelateid",id);
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

// modified by lupeng 2004-8-7 for TD772
boolean canedit = (HrmUserVarify.checkUserRight("EditCustomerType:Edit",user) && !(Util.null2String(RecordSet.getString(5))).equals("n"));
// end.

String imagefilename = "/images/hdMaintenance.gif";
String titlename = "";
// added by lupeng 2004-8-6 for TD767
if (canedit)
	titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":&nbsp;"
			+SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage());
else
	titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":&nbsp;"
			+SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage());
// end.
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>


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
</DIV >
<%}%>
<FORM id=weaver name="weaver" action="/CRM/Maint/CustomerTypeOperation.jsp" method=post onsubmit='return check_form(this,"name,desc,workflowid")'>
<DIV>
<%
//out.print(RecordSet.getString(5));
if(canedit||HrmUserVarify.checkUserRight("EditCustomerType:Edit",user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:document.weaver.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
	<BUTTON class=btnSave accessKey=S  style="display:none" id=domysave  type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>

<%
if(HrmUserVarify.checkUserRight("EditCustomerType:Delete", user) && !(Util.null2String(RecordSet.getString(4)).equals("n"))){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
	<BUTTON class=btnDelete id=Delete accessKey=D  style="display:none"  onclick='doDel()'><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%}
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location='/CRM/Maint/ListCustomerType.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

</DIV>
<input type="hidden" name="method" value="edit">
<input type="hidden" name="id" value="<%=id%>">
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
        <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing  style="height:2px">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit) {%><INPUT class=InputStyle maxLength=50 size=20 name="name" onchange='checkinput("name","nameimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage())%>"><SPAN id=nameimage></SPAN><%}else {%><INPUT class=InputStylet type=hidden maxLength=50 size=20 name="name" onchange='checkinput("name","nameimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage())%>"><%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%><%}%></TD>
        </TR><tr style="height:2px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit) {%><INPUT class=InputStyle maxLength=150 size=50 name="desc" onchange='checkinput("desc","descimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(3),user.getLanguage())%>"><SPAN id=descimage></SPAN><%}else {%><INPUT class=InputStyle type=hidden maxLength=150 size=50 name="desc" onchange='checkinput("desc","descimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(3),user.getLanguage())%>"><%=Util.toScreen(RecordSet.getString(3),user.getLanguage())%><%}%></TD>
         </TR><tr style="height:2px"><td class=Line colspan=2></td></tr>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(15057,user.getLanguage())%></TD>
            <TD class=Field >
            <% if(HrmUserVarify.checkUserRight("EditCustomerType:Edit", user)) {%>
              <BUTTON  type=button class=Browser onClick="onShowWF()"></BUTTON>
              <SPAN id=workflowidspan>
               <%=Util.null2String(RecordSet.getString("workflowname"))%><%if(Util.null2String(RecordSet.getString("workflowname")).equals("")){%><IMG src='/images/BacoError.gif' align=absMiddle><%}%>
              </SPAN>
              <INPUT class=inputstyle id=workflowid type=hidden name=workflowid value="<%=RecordSet.getString("workflowid")%>" onchange='checkinput("workflowid","workflowidspan")'>
            <%}else{%>
            <%=Util.null2String(RecordSet.getString("workflowname"))%>
            <%}%>
            </TD>
    </TR>
    </TR><tr style="height:2px"><td class=Line colspan=2></td></tr>
        </TBODY></TABLE></TD>
    </TR></TBODY></TABLE>






<!--共享信息begin-->

	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="20%">
  		<COL width="70%">
  		<COL width="10%">
        <TBODY>
        <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(2112,user.getLanguage())%></TH>
			<TD align=right colspan=2>
			<%if(canedit_share){%>
			<a href="/CRM/data/AddTypeShare.jsp?itemtype=2&typeid=<%=id%>&crmtypename=<%=RecordSet.getString(2)%>"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>
			<%}%>
			</TD>
          </TR>
        <TR class=Spacing style="height: 2px">
          <TD class=Line1 colSpan=3></TD></TR>
<%
if(RecordSetShare.first()){
do{
	if(RecordSetShare.getInt("sharetype")==1)	{
%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
		  <TD class=Field>
			<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetShare.getString("userid")),user.getLanguage())%>/<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			<% if(RecordSetShare.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
		  </TD>
		  <TD class=Field align =right>
			<%if(canedit_share){%>
			<a href="/CRM/data/TypeShareOperation.jsp?method=delete&typeid=<%=id%>&id=<%=RecordSetShare.getString("id")%>" onClick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
			<%}%>
		  </TD>
        </TR><tr style="height:2px"><td class=Line colspan=3></td></tr>
	<%}else if(RecordSetShare.getInt("sharetype")==2)	{%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
		  <TD class=Field>
			<%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSetShare.getString("departmentid")),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>/<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			<% if(RecordSetShare.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
		  </TD>
		  <TD class=Field align =right>
			<%if(canedit_share){%>
			<a href="/CRM/data/TypeShareOperation.jsp?method=delete&typeid=<%=id%>&id=<%=RecordSetShare.getString("id")%>"  onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
			<%}%>
		  </TD>
        </TR><tr style="height:2px"><td class=Line colspan=3></td></tr>
	<%}else if(RecordSetShare.getInt("sharetype")==3)	{%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
		  <TD class=Field>
			<%=Util.toScreen(RolesComInfo.getRolesname(RecordSetShare.getString("roleid")),user.getLanguage())%>/<% if(RecordSetShare.getInt("rolelevel")==0)%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
			<% if(RecordSetShare.getInt("rolelevel")==1)%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
			<% if(RecordSetShare.getInt("rolelevel")==2)%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>/<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			<% if(RecordSetShare.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
		  </TD>
		  <TD class=Field align =right>
			<%if(canedit_share){%>
			<a href="/CRM/data/TypeShareOperation.jsp?method=delete&typeid=<%=id%>&id=<%=RecordSetShare.getString("id")%>"  onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
			<%}%>
		  </TD>
        </TR><tr style="height:2px"><td class=Line colspan=3></td></tr>
	<%}else if(RecordSetShare.getInt("sharetype")==4)	{%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></TD>
		  <TD class=Field>
			<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>/<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			<% if(RecordSetShare.getInt("sharelevel")==2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
		  </TD>
		  <TD class=Field align =right>
			<%if(canedit_share){%>
			<a href="/CRM/data/TypeShareOperation.jsp?method=delete&typeid=<%=id%>&id=<%=RecordSetShare.getString("id")%>"  onclick="return isdel()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
			<%}%>
		  </TD>
        </TR><tr style="height:2px"><td class=Line colspan=3></td></tr>
	<%}%>
 <%}while(RecordSetShare.next());
}
%>
        </TBODY>
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<script language=javascript>

function onShowWF(){        
	var datas=null;
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置; 
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere=where isbill=1 and formid=79");
    
    if (datas){
	    if (datas.id!= "" ){
	    	var strs=datas.name+"&nbsp";
            
			jQuery("#workflowidspan").html(strs);
			jQuery("#workflowid").val(datas.id);
		}
		else{
			jQuery("#workflowidspan").html("");
			jQuery("#workflowid").val("");
		}
	}
}

function doDel(){
	if(isdel()){
		location.href="/CRM/Maint/CustomerTypeOperation.jsp?method=delete&id=<%=id%>"
	}
}




</script>

</BODY>
</HTML>
