<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%	
	if(!HrmUserVarify.checkUserRight("newstype:maint", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	
	String type = Util.forHtml(Util.null2String(request.getParameter("type")));
	boolean editable="edit".equals(type)?true:false;
	String id = Util.null2String(request.getParameter("id"));
	String Delname = "";
	String typename="";
	String typedesc="";
	if(editable) {
		if(rs.executeSql("select * from newstype where id="+id)){
			rs.next();
			Delname = rs.getString("typename");
			typename=Util.null2String(rs.getString("typename"));
			typedesc=Util.null2String(rs.getString("typedesc"));
		}
	}
	
	String msg = Util.null2String(request.getParameter("msg"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(19859,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doAdd(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	if(editable){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/news/type/newstypeList.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%if(msg!=null&&!"".equals(msg)){%><font color=red><%=SystemEnv.getHtmlLabelName(Util.getIntValue(msg),user.getLanguage())%><%}%>
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
			<form name="frmAdd" method="post" action="newstypeOperation.jsp">
			<%if(editable) {%>
				<input type="hidden" name="txtMethod" value="edit">
				<input type="hidden" name="id" value="<%=id%>">
			<%} else {%>
				<input type="hidden" name="txtMethod" value="add">
			<%}%>
			<TABLE class=ViewForm>
			  <COLGROUP>
			  <COL width="20%">
			  <COL width="80%">
			  <TBODY>
				  <TR class=Title>
					<th colSpan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></th>
				  </tr>
				  <TR style="height: 1px!important;"><TD colSpan=2  class=Line1></TD></TR>

				   <TR>
					<TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
					<TD class="field">
					<input type="text" class="inputstyle" name="txtName" <%if(editable) %> value="<%=Util.forHtml(typename)%>") onChange="checkinput('txtName','spanName')" >
					<span id=spanName>
						<%if(editable && ! Util.null2String(rs.getString("typename")).equals("")){ %>
						<%} else {%>
							<IMG src='/images/BacoError.gif' align=absMiddle>
						<%}%>
					</span>
					</TD>
				  </TR>
				  <TR style="height: 1px!important;"><TD colSpan=2  class=Line></TD></TR>

				  <TR>
					<TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
					<TD class="field"><input type="text" class="inputstyle"  <%if(editable) %> value="<%=Util.forHtml(typedesc) %>"  name="txtDesc"></TD>
				  </TR>
				  <TR style="height: 1px!important;"><TD colSpan=2  class=Line></TD></TR>

				  <TR>
					<TD><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>
					<TD class="field"><input type="text" class="inputstyle" <%if(editable) out.println("value='"+Util.null2String(rs.getString("dspnum"))+"'");%>  name="txtDspNum" value="0" size="4" onKeyPress="ItemCount_KeyPress()"></TD>
				  </TR>
				  <TR style="height: 1px!important;"><TD colSpan=2  class=Line></TD></TR>
			 </TABLE>
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
</BODY>
</HTML>
<SCRIPT LANGUAGE="JavaScript">
<!--
function doAdd(){
	if(check_form(frmAdd,'txtName'))	frmAdd.submit();
}
function doDel(){
	if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")) {
		window.location="newstypeOperation.jsp?txtMethod=del&id=<%=id%>&DocTypeName=<%=Util.forHtml(Delname)%>"
	}
}
//-->
</SCRIPT>
