<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="PicUploadManager" class="weaver.docs.tools.PicUploadManager" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
int id=Util.getIntValue(request.getParameter("id"),0);
String errorcode = Util.null2String(request.getParameter("errorcode"));
boolean canedit=HrmUserVarify.checkUserRight("DocPicUploadEdit:Edit", user);
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(70,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(74,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(canedit){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("DocPicUploadEdit:Delete", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
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

<FORM id=weaver name=frmmain action="UploadImage.jsp" method=post enctype="multipart/form-data">
<input type="hidden" name="operation">
<input type="hidden" name="id" value=<%=id%>>
<script>
function onSave(){
	if(check_form(document.frmmain,'picname')){
	document.frmmain.operation.value="edit";
	document.frmmain.submit();
	}
}
function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(8,user.getLanguage())%>")) {
		document.frmmain.operation.value="delete";
		document.frmmain.submit();
	}
}
</script>

<TABLE class=ViewForm>
    <COLGROUP>
  	<COL width="15%">
  	<COL width="85%">
    <tbody>
	<TR class=Title>
    	<TH colSpan=2><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%>
        <%if(errorcode.equals("1")){%><font color="red">图片已经被引用，不能删除！</font><%}%>
        </TH></TR>
  	<TR class=Spacing style="height: 1px!important;">
    	<TD class=Line1 colSpan=2></TD></TR>
    	<%
    	PicUploadManager.resetParameter();
    	PicUploadManager.setId(id);
  	PicUploadManager.selectImageById();
  	if(PicUploadManager.next()){
    	%>
    	<tr>
    	<td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
    	<td class=field>
    	<% if(canedit){%>
    	<input type="text" name="picname" value=<%=Util.toScreenToEdit(PicUploadManager.getPicname(),user.getLanguage())%> maxLength=30
    	onchange="checkinput('picname','InvalidFlag_Description')" size=30><SPAN id=InvalidFlag_Description>
    	</span>
    	<% }else{%>
    	<%=Util.toScreen(PicUploadManager.getPicname(),user.getLanguage())%>
    	<%}%>
    	</td>
    	</tr>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
    	<tr>
    	<td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
    	<td class=field>
    	<%if(canedit){%>
    	<select class=InputStyle  size=1 name="pictype">
	<option value="1" <%if(PicUploadManager.getPictype().equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(2009,user.getLanguage())%></option>
	<option value="3" <%if(PicUploadManager.getPictype().equals("3")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(2010,user.getLanguage())%></option>
	</select>
	<% }else{%>
		<%if(PicUploadManager.getPictype().equals("1")){%>
  		<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>
  		<%}if(PicUploadManager.getPictype().equals("2")){%>
  		<%=SystemEnv.getHtmlLabelName(285,user.getLanguage())%>
  		<%}if(PicUploadManager.getPictype().equals("3")){%>
  		<%=SystemEnv.getHtmlLabelName(287,user.getLanguage())%>
  		<%}if(PicUploadManager.getPictype().equals("4")){%>
  		<%=SystemEnv.getHtmlLabelName(289,user.getLanguage())%>
  		<%}}%>
    	</td>
    	</tr>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
    	<tr>
    	<td><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></td>
    	<td class=field>
    	<img border=0 src="/weaver/weaver.file.FileDownload?fileid=<%=PicUploadManager.getImagefileid()%>">
    	<input type="hidden" name="imagefileid" value=<%=PicUploadManager.getImagefileid()%>>
    	<input type="hidden" name="imagefilename" value=<%=PicUploadManager.getImagefilename()%>>
    	<input type="hidden" name="imagefilewidth" value=<%=PicUploadManager.getImagefilewidth()%>>
    	<input type="hidden" name="imagefileheight" value=<%=PicUploadManager.getImagefileheight()%>>
    	<input type="hidden" name="imagefilesize" value=<%=PicUploadManager.getImagefilesize()%>>
    	<input type="hidden" name="imagefilescale" value=<%=PicUploadManager.getImagefilescale()%>>
    	</td>
    	</tr>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
    	<%if (canedit)%>
    	<tr><td><%=SystemEnv.getHtmlLabelName(293,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></td>
    	<td class=Field><input type="file" class=InputStyle name="imagefile"></td></tr>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
    	<%}
    	PicUploadManager.closeStatement();
    	%>
    </tbody>
 </table>
		</td>
		</tr>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>

</table>

 </form>
 </body></html>