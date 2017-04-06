<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.User"%>
<%@ page import="java.util.*"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String id=Util.null2String(request.getParameter("selectedids"));
	RecordSet.executeSql("select * from Workflow_MonitorType order by typeorder");
%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(16634,user.getLanguage())+",javascript:isConfirm(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
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
		<table class="viewForm">
			<tr>
			<td>
			<Table width='100%' class='liststyle'>
			<colgroup>
			<col width='10%'>
			<col width='90%'>
			<tr class="Header">
				<td colspan="2"><%=SystemEnv.getHtmlLabelName(2239,user.getLanguage())%></td>
			</tr>
			<TR class=Line><TD colspan="2" ></TD></TR>
			<%
				boolean trClass = false;
				while(RecordSet.next())
				{
					String ids = Util.null2String(RecordSet.getString("id"));
					String typename = Util.null2String(RecordSet.getString("typename"));
			%>
			<tr class="<%=trClass?"DataLight":"DataDark" %>">
				<td class=field><input type="radio" class="inputstyle" name="typeid" value="<%=ids%>" <%if(id.equals(ids)){out.print("checked");} %> ></td>
				<td class=field><%=typename%><input type="hidden" name="typename_<%=ids%>" value="<%=typename%>"></td>
			</tr>
			<%
					trClass = trClass?false:true;
				}
			%>
			</table>
			</td>
			</tr>
		</table>
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

</BODY>

<script type="text/javascript">
function returnValue(){
	var id="";
	var name="";
	
	for(var i=0;i<document.getElementsByName("typeid").length;i++){
			if(document.getElementsByName("typeid")[i].checked){
				id=document.getElementsByName("typeid")[i].value;	
			}
		
	}
	if(id!=""){
		name=document.all("typename_"+id).value;
	}
	return {id:""+id,name:""+name};
}
</script>


<SCRIPT type="text/javascript">
function isConfirm(){

	window.parent.returnValue = returnValue();
    window.parent.close();
}

function onClose(){
	window.parent.close();
}
</script>
</html>