<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

    String dataCenterWorkflowTypeId="";
	RecordSet.executeSql("select currentId from sequenceindex where indexDesc='dataCenterWorkflowTypeId'");
	if(RecordSet.next()){
		dataCenterWorkflowTypeId=Util.null2String(RecordSet.getString("currentId"));
	}

    RecordSet.executeSql("SELECT DISTINCT workflowtype FROM workflow_base");
    StringBuffer sb = new StringBuffer();
    String allRef = "";
    while(RecordSet.next()){
        allRef += "," + RecordSet.getString(1);
    }
    allRef += ",";
	String id = request.getParameter("id");

	RecordSet.executeProc("workflow_wftype_SelectByID",id);


	RecordSet.first();

boolean canedit = HrmUserVarify.checkUserRight("WorkflowManage:All",user);

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = null;
    if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
        titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(16579,user.getLanguage());
    }else{
        titlename = SystemEnv.getHtmlLabelName(89,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(16579,user.getLanguage());
    }
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%
}
if(HrmUserVarify.checkUserRight("WorkflowManage:All", user) && allRef.indexOf(","+id+",")==-1&&(!dataCenterWorkflowTypeId.equals(id))){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:submitDel(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onReturn(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver action="WorkTypeOperation.jsp" method=post >
  <input type="hidden" name="method" value="edit">
  <input type="hidden" name="id" value="<%=id%>">
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

<TABLE class="viewform">
  <COLGROUP>
  <COL width="100%">
  <TBODY>
  <TR>
    <TD vAlign=top>
      <TABLE class="viewform">
      <COLGROUP>
  	<COL width="20%">
  	<COL width="80%">
        <TBODY>
        <TR class="Title">
            <TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
          </TR>
        <TR class="Spacing" style="height:1px;">
          <TD class="Line1" colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit) {%><INPUT class=Inputstyle maxLength=50 size=20 name="type" onchange='checkinput("type","typeimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage())%>"><SPAN id=typeimage></SPAN><%}else {%><%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%>  <%}%></TD>
        </TR> <TR class="Spacing" style="height:1px;">
          <TD class="Line" colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit) {%><INPUT class=Inputstyle maxLength=150 size=50 name="desc" onchange='checkinput("desc","descimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(3),user.getLanguage())%>"><SPAN id=descimage></SPAN><%}else {%> <%=Util.toScreen(RecordSet.getString(3),user.getLanguage())%> <%}%></TD>
         </TR>   <TR class="Spacing" style="height:1px;">
          <TD class="Line" colSpan=2></TD></TR>
         <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>
          <TD class=Field><% if(canedit) {%><INPUT class=Inputstyle maxLength=3 size=20 name="dsporder" value="<%=Util.getIntValue(RecordSet.getString("dsporder"),0)%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'><%}else {%> <%=Util.getIntValue(RecordSet.getString("dsporder"),0)%> <%}%></TD>
         </TR>   <TR class="Spacing" style="height:1px;">
          <TD class="Line1" colSpan=2 ></TD></TR>
        </TBODY></TABLE></TD>
    </TR></TBODY></TABLE>
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


</FORM>
<iframe id="checkType" src="" style="display: none"></iframe>
<script language="javascript">
function submitData()
{
	if (check_form(weaver,'type,desc')){
	    //通过iframe验证类型名称是否重复
	    //document.getElementById("checkType").src="WorkTypeOperation.jsp?type="+document.all("type").value+"&method=valRepeat&id="+<%=id%>;
	    document.getElementById("checkType").src="WorkTypeOperation.jsp?method=valRepeat&type="+myescapecode(document.all("type").value)+"&id="+<%=id%>;
    }
}

function submitDel()
{
	if(isdel()){
		document.all("method").value="delete" ;
		weaver.submit();
		}
}
function onReturn(){
	location="/workflow/workflow/ListWorkType.jsp";
}
//类型名称已经存在
function typeExist(){
    alert("<%=SystemEnv.getHtmlLabelName(24256,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>");
    return ;
}

//提交表单
function submitForm(){
    weaver.submit();
}
</script>
</BODY>
</HTML>
