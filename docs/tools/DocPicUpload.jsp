<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="PicUploadManager" class="weaver.docs.tools.PicUploadManager" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagetype=Util.null2String(request.getParameter("imagetype"));

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(74,user.getLanguage())+SystemEnv.getHtmlLabelName(320,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("DocPicUploadAdd:Add", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:onNew(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("DocPicUpload:Log", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =8',_top} " ;
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

<form name="form1" method="post" action="DocPicUpload.jsp">


<TABLE class=ListStyle cellspacing=1>
    <COLGROUP>
  	<COL width="10%">
  	<COL width="40%">
  	<COL width="40%">
  	<COL width="10%">

    <tbody>
	<TR class=header>
    	<TH colSpan=1><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></TH>
    	<TH colSpan=3>
<%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
<select class=InputStyle  size="1" name="imagetype" onChange="form1.submit();">
<option value="" <%if(imagetype.equals("")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
<option value="1" <%if(imagetype.equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(2009,user.getLanguage())%></option>
<option value="3" <%if(imagetype.equals("3")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(2010,user.getLanguage())%></option>
</select>
        </TH>
    </TR>
  	<TR class=Header>
    	<TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
    	<TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
    	<TD><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></TD>
    	<TD><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())+SystemEnv.getHtmlLabelName(2036,user.getLanguage())%></TD>
    	</TR>
    	<%
    	PicUploadManager.resetParameter();

    	PicUploadManager.setPictype(imagetype);
  	PicUploadManager.selectPicUpload();
    	int i=0;
    	while(PicUploadManager.next()){
    		int id=PicUploadManager.getId();
    		String picname=Util.toScreen(PicUploadManager.getPicname(),user.getLanguage());
    		String pictype=Util.toScreen(PicUploadManager.getPictype(),user.getLanguage());
    		String imageid = Util.null2String(PicUploadManager.getImagefileid());
    		//int width=PicUploadManager.getImagefilewidth();
    		//int height=PicUploadManager.getImagefileheight();
    		float imagefilesize=PicUploadManager.getImagefilesize();
    		//float scale=PicUploadManager.getImagefilescale();
    		imagefilesize=(float)((int)(imagefilesize*10/1024))/(float)10;
    		//scale=(float)((int)(scale*10))/(float)10;

    	if(i==0){
  		i=1;
  	%>
  	<TR class=datalight>
  	<%
  	}else{
  		i=0;
  	%>
  	<TR class=datadark>
  	<%  }
  	%>
  	<td>
  	<%if(pictype.equals("1")){%>
  	<%=SystemEnv.getHtmlLabelName(2009,user.getLanguage())%>
  	<%}if(pictype.equals("2")){%>
  	<%=SystemEnv.getHtmlLabelName(333,user.getLanguage())%>
  	<%}if(pictype.equals("3")){%>
  	<%=SystemEnv.getHtmlLabelName(2010,user.getLanguage())%>
  	<%}if(pictype.equals("4")){%>
  	<%=SystemEnv.getHtmlLabelName(335,user.getLanguage())%>
  	<%}%>
  	</td>
  	<td><a href="DocPicUploadEdit.jsp?id=<%=id%>"><%=picname%></a></td>
  	<%
  	if(imageid.equals("")){
  	%>
    	<TD></TD>
    	<%} else{
    	%>
    	<TD>
     	<img border=0 width="75" src="/weaver/weaver.file.FileDownload?fileid=<%=imageid%>"></TD>
    	<%}%>
    	<td><%=imagefilesize%><%=SystemEnv.getHtmlLabelName(337,user.getLanguage())%></td>
    	<%}
   	PicUploadManager.closeStatement();%>
    </tbody>
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
</form>
<script>
    function onNew(){
    		location="/docs/tools/DocPicUploadAdd.jsp"
    }
</script>
</BODY></HTML>