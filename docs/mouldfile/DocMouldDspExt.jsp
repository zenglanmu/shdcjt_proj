<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/docs/docs/iWebOfficeConf.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script>
var canDelete="<%=Util.null2String(request.getParameter("state"))%>";
if(canDelete=="nodelete")alert("<%=SystemEnv.getHtmlLabelName(21799,user.getLanguage())%>");

</script>
</head>
<jsp:useBean id="MouldManager" class="weaver.docs.mouldfile.MouldManager" scope="page" />
<%
//编辑：王金永 
String temStr = request.getRequestURI();
temStr=temStr.substring(0,temStr.lastIndexOf("/")+1);

String mServerUrl=temStr+mServerName;
String mClientUrl="/docs/docs/"+mClientName;

int id = Util.getIntValue(request.getParameter("id"),0);
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String urlfrom = Util.null2String(request.getParameter("urlfrom"));
MouldManager.setId(id);
MouldManager.getMouldInfoById();
MouldManager.getMouldSubInfoById();
int subcompanyid1 = MouldManager.getSubcompanyid1();
String mouldname=MouldManager.getMouldName();
String mouldtext=MouldManager.getMouldText();
int mouldType = MouldManager.getMouldType();
String docType=".doc";
if(mouldType==2){
    docType=".doc";
}else if(mouldType==3){
    docType=".xls";
}else if(mouldType==4){
    docType=".wps";
}else if(mouldType==5){
    docType=".et";
}else{
    docType=".doc";
}
session.setAttribute("DocMouldDspExt.jsp_",String.valueOf(subcompanyid1));

MouldManager.closeStatement();

boolean canNotDelete = false;
RecordSet.executeSql("select t1.* from DocSecCategoryMould t1 where t1.mouldId = "+id+" and mouldType in(2,4,6,8)");
if(RecordSet.getCounts()>0){
    canNotDelete = true;
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = "";
if(urlfrom.equals("hr")){
  titlename = SystemEnv.getHtmlLabelName(614,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(64,user.getLanguage());
}else{
  titlename = SystemEnv.getHtmlLabelName(16449,user.getLanguage())+"："+mouldname;
}
String needfav ="1";
String needhelp ="";

%>

<script>
function StatusMsg(mString){
  StatusBar.innerText=mString;
}

function WebSaveLocal(){
  try{
    weaver.WebOffice.WebSaveLocal();
    StatusMsg(weaver.WebOffice.Status);
  }catch(e){}
}

function WebOpenLocal(){
  try{
    weaver.WebOffice.WebOpenLocal();
    StatusMsg(weaver.WebOffice.Status);
  }catch(e){
  }
}

function Load(){
  //weaver.WebOffice.WebUrl="<%=mServerUrl%>"
  try{
  weaver.WebOffice.WebUrl="<%=mServerUrl%>";
  weaver.WebOffice.RecordID="<%=id%>";
  weaver.WebOffice.Template="";
  weaver.WebOffice.FileName="";
  weaver.WebOffice.FileType="<%=docType%>";
<%if(isIWebOffice2006 == true){%>
//iWebOffice2006 特有内容开始
  weaver.WebOffice.EditType="0,0";
  weaver.WebOffice.ShowToolBar="0";      //ShowToolBar:是否显示工具栏:1显示,0不显示
//iWebOffice2006 特有内容结束
<%}else{%>
  weaver.WebOffice.EditType="0";
<%}%>
  weaver.WebOffice.UserName="<%=user.getUsername()%>";
  weaver.WebOffice.WebOpen();  	//打开该文档
<%if(isIWebOffice2006 == true){%>
//iWebOffice2006 特有内容开始
  weaver.WebOffice.ShowType="1";  //文档显示方式  1:表示文字批注  2:表示手写批注  0:表示文档核稿
//iWebOffice2006 特有内容结束
<%}%>
  StatusMsg(weaver.WebOffice.Status);

  }catch(e){}
}



function UnLoad(){
  try{
  if (!weaver.WebOffice.WebClose()){
     StatusMsg(weaver.WebOffice.Status);
  }else{
     StatusMsg("关闭文档...");
  }
  }catch(e){}
}
</script>


<BODY onLoad="Load()" onUnload="UnLoad()">
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

<FORM id=weaver name=weaver action="UploadDoc.jsp" method=post enctype="multipart/form-data">
<input type=hidden name=urlfrom value="<%=urlfrom%>">
<DIV>
<%
if(HrmUserVarify.checkUserRight("DocMouldEdit:Edit", user)){
%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:location='DocMouldEdit.jsp?id="+id+"&urlfrom="+urlfrom+"&subcompanyid1="+subcompanyid1+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(HrmUserVarify.checkUserRight("DocMouldEdit:add", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='DocMouldAdd.jsp?urlfrom="+urlfrom+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
}if(HrmUserVarify.checkUserRight("DocMouldEdit:Delete", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
}if(HrmUserVarify.checkUserRight("DocMould:log", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?secid=63&sqlwhere=where operateitem=75 and relatedid="+id+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
}
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/mouldfile/DocMould.jsp?urlfrom="+urlfrom+"&subcompanyid1="+subcompanyid1+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
</DIV>
<br>
<TABLE class=ViewForm>
<TBODY>
<TR class=Spacing><TD aligh=left colspan=2>
<b>
<%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%>
</b>
</TD></TR>
<TR class=Spacing><TD class=Line1 colspan=2></TD></TR>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></td>
<td width=85% class=field>
<%=id%>
</td>
</tr>
<TR>
	<TD class=Line colSpan=2></TD>
</TR>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></td>
<td width=85% class=field>
<%=mouldname%>
</td>
<%if(urlfrom.equals("hr")){%>
<%if(detachable==1){%>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></td>
<td width=85% class=field>
<%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subcompanyid1))%>
</td>
</tr>
<%}%>
<%}%>
</tr>
<TR>
	<TD class=Line1 colSpan=2></TD>
</TR>
</tbody>
</table>
<div id=imgfield>
</div>

<TABLE class=ViewForm>
<TBODY>
<TR class=Spacing>
<TD class=Line1></TD></TR>


<tr><td colspan = 2>
<div style="POSITION: relative;width:100%;height:660;OVERFLOW:hidden;">
    <OBJECT  id="WebOffice" style="POSITION: relative;top:-20" width="100%"  height="680"  value="" classid="<%=mClassId%>" codebase="<%=mClientUrl%>" >
    </OBJECT>
</div>
</td></tr>
<tr><td colspan = 2>
    <span id=StatusBar>&nbsp;</span>
</td></tr>

</TBODY>
</TABLE>

<input type=hidden name=operation>
<input type=hidden name=id value="<%=id%>">
<input type=hidden name=mouldname value="<%=mouldname%>">
<textarea name=mouldtext style="display:none;width:100%;height=500px"><%=mouldtext%></textarea>
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
</body>

<script>
function onDelete(){

	if(<%=canNotDelete%>){
		alert("<%=SystemEnv.getHtmlLabelName(23134,user.getLanguage())%>");
		return;
	}

	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
	document.weaver.operation.value='delete';
	document.weaver.submit();
	}
}
</script>