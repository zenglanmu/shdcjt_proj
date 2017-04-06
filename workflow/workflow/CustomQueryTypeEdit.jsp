<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%
 if(!HrmUserVarify.checkUserRight("WorkflowCustomManage:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(23799,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

String id = Util.null2String(request.getParameter("id"));
RecordSet.executeSql("SELECT * FROM workflow_customQuerytype where id="+id);
RecordSet.next();
String typename = Util.toScreen(RecordSet.getString("typename"),user.getLanguage()) ;
String typenamemark = Util.toScreenToEdit(RecordSet.getString("typenamemark"),user.getLanguage()) ;
String showorder = Util.null2String(RecordSet.getString("showorder"));
//判断是否有该类型的自定义查询，如果有则不允许删除
RecordSet.executeSql("SELECT count(*) FROM Workflow_Custom where Querytypeid="+id);
int typecount=0;
if(RecordSet.next()){
    typecount= RecordSet.getInt(1);
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:donewQueryType(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
if(typecount==0){
  RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
  RCMenuHeight += RCMenuHeightStep;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doback(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%
// }
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver name=frmMain action="CustomQueryTypeOperation.jsp" method=post >

<%
if(msgid!=-1){
%>
  <DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>

<%
 // if(HrmUserVarify.checkUserRight("HrmProvinceAdd:Add", user)){
%>




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
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class="Title">
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15434,user.getLanguage())%></TH>
    </TR>
  <TR class="Spacing" style="height:1px;">
    <TD class="Line1" colSpan=2 ></TD></TR>
  <TR>

      <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field>
        <INPUT type=text class=Inputstyle size=30  name="typename" onchange='checkinput("typename","typenameimage")' value="<%=typename%>">
          <SPAN id=typenameimage></SPAN></TD>
        </TR>  <TR class="Spacing" style="height:1px;">
    <TD class="Line" colSpan=2 ></TD></TR>
  <TR>
        <TR>

      <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field>
              <textarea rows="4" cols="80" name="typenamemark" class=Inputstyle><%=typenamemark%></textarea>
          </TD>
        </TR>  <TR class="Spacing" style="height:1px;">
    <TD class="Line" colSpan=2 ></TD></TR>
  <TR>
  <TR>

      <TD><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>

      <TD class=Field>
        <input type="text" class=Inputstyle  name="showorder" size="7" value="<%=showorder%>" onKeyPress="ItemNum_KeyPress('showorder')" onBlur="checknumber1(this);">
      </TD>
        </TR>  <TR class="Spacing">
    <TD class="Line1" colSpan=2 style="height:1px;"></TD></TR>
  <TR>
        <input type="hidden" name=operation value=querytypeedit>
		<input type="hidden" name=id value=<%=id%>>
 </TBODY></TABLE>

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
 <script>
function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
            enableAllmenu();
			document.frmMain.operation.value="querytypedelete";
			document.frmMain.submit();
		}
}
</script>

<script language="javascript">
function submitData()
{
	if (check_form(weaver,'typename')){
        enableAllmenu();
		weaver.submit();
    }
}
function donewQueryType(){
        enableAllmenu();
        location.href="/workflow/workflow/CustomQueryTypeAdd.jsp";
    }
function doback(){
    enableAllmenu();
    location.href="/workflow/workflow/CustomQueryType.jsp";
}
</script>
</BODY></HTML>
