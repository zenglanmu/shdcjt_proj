<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("DocPicUploadAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<jsp:useBean id="PicUploadManager" class="weaver.docs.tools.PicUploadManager" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
<SCRIPT language="javascript">
function checkSubmit(){
    if(check_form(weaver,'picname,imagefile')){
        weaver.submit();
    }
}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(70,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(74,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/tools/DocPicUpload.jsp,_self} " ;
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

<FORM id=weaver name=frmmain action="UploadImage.jsp" method=post enctype="multipart/form-data" onSubmit="return check_form(this,'picname,imagefile')">
<input type="hidden" name="operation" value="add">


<TABLE class=ViewForm>
    <COLGROUP>
  	<COL width="15%">
  	<COL width="85%">
    <tbody>
	<TR class=Title>
    	<TH colSpan=2><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></TH></TR>
  	<TR class=Spacing style="height: 1px!important;">
    	<TD class=Line1 colSpan=2></TD></TR>
    	<tr>
    	<td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
    	<td class=Field><input type="text" class=InputStyle name="picname" maxLength=30 
    	onchange="checkinput('picname','InvalidFlag_Description')" size=30>
    	<SPAN id=InvalidFlag_Description><IMG src="../../images/BacoError.gif" align=absMiddle></SPAN></td>
    	</tr>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
    	<tr>
    	<td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
    	<td class=Field><select class=InputStyle  size="1" name="pictype">
    		<option value="1" selected><%=SystemEnv.getHtmlLabelName(2009,user.getLanguage())%></option>
    		<option value="3"><%=SystemEnv.getHtmlLabelName(2010,user.getLanguage())%></option>
    		</select>
    	</td>
    	</tr>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
    	<tr>
    	<td><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></td>
    	<td class=Field><input type="file" class=InputStyle name="imagefile"></td>
    	</tr>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
    </tbody>
</table>
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

</body>
</html>