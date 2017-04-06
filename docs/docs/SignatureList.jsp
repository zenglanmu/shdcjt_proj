<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<%@ page import="weaver.docs.category.* " %>
<%@ page import="java.util.*"%>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>

<jsp:useBean id="SignatureManager" class="weaver.docs.docs.SignatureManager" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("SignatureList:List", user)){
    response.sendRedirect("/notice/noright.jsp");
}
String imagefilename = "/images/hdMaintenance.gif";
String titlename = "<b>"+SystemEnv.getHtmlLabelName(16627,user.getLanguage())+"</b>";
String needfav = "1";
String needhelp = "1";

String  deptid = Util.null2String(request.getParameter("deptid"));
if(deptid.equals("")){
    SignatureManager.getSignatureInfo();
}else{

    SignatureManager.setDeptid(deptid);
    SignatureManager.getSignatureInfoByDeptId();
}

//out.println("deptid:"+deptid+":");
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput.js"></script>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<SCRIPT language="javascript">
function showHeader(){
	if(oDiv.style.display=='')
		oDiv.style.display='none';
	else
		oDiv.style.display='';
}


function onshowdocmain(vartmp){
	if(vartmp==1)
		otrtmp.style.display='';
	else	
		otrtmp.style.display='none';
}

function onRefrush(){
    weaver.submit();
}

function onNew(){
    window.location="/docs/docs/SignatureAdd.jsp";
}
</script>
 
</head>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onRefrush(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if(HrmUserVarify.checkUserRight("SignatureAdd:Add", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(16387,user.getLanguage())+",javascript:onNew(),_top} " ;
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
<FORM id=weaver name=frmmain method=post action="SignatureList.jsp">


<table class=ViewForm>
  <colgroup>
  <col width="20%">
  <col width="80%">
  <tbody>
    <TR style="height: 1px!important;"><TD class=Line1 colSpan=2></TD></TR>
    <tr>
    <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
    <td class=field>
       
        <input class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp" _displayText="<%=Util.toScreen(DepartmentComInfo.getDepartmentmark(deptid+""),user.getLanguage())%>" type="hidden" name="deptid" value="<%=deptid%>">
    </td>
  </tr>
  <TR style="height: 1px!important;"><TD class=Line1 colSpan=2></TD></TR>
  </tbody>
</table>
</form>
<br>


<table class=ListStyle  cellspacing="1"  id=tblReport>
    <colgroup> 
    <col valign=top align=left width="20%"> 
    <col valign=top align=left width="20%"> 
    <col valign=top align=left width="40%"> 
    <col valign=top align=left width="20%">
    <tbody> 
    <TR class=header><Th colspan=4><%=SystemEnv.getHtmlLabelName(16627,user.getLanguage())%></Th></TR>
    <tr class=Header> 
      <th><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(18694,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(19520,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></th>
    </tr>
    <TR class=Line style="height: 1px!important;"><TD colSpan=4 style="padding: 0!important;"></TD></TR>
<%
int prehrmresid=-1;
int i=1;
String markDate=null;
while(SignatureManager.next()){
    markDate=Util.null2String(SignatureManager.getMarkDate());
	if(markDate.length()>19){
		markDate=markDate.substring(0,19);
	}
    if((i+2)%2==0){
%>
    <tr  class=datalight >
<%
    }else{
%>
     <tr  class=datadark >
<%
    }
%>
      <td>
    <%
    int hrmresid = SignatureManager.getHrmresId();
    if(hrmresid!=prehrmresid){
    %>
      <A href="javaScript:openhrm(<%=hrmresid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(""+hrmresid),user.getLanguage())%></A>
    <%
        prehrmresid=hrmresid;
    }
    %>
      </td>
      <td><%=SignatureManager.getMarkName()%></td>        
      <td><%=markDate%></td>
      <td>
        <%if(HrmUserVarify.checkUserRight("SignatureEdit:Edit", user)){%>
        <a href="SignatureEdit.jsp?markId=<%=SignatureManager.getMarkId()%>"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></a>
        <%}%>
      </td>
     </tr>
<%
    i++;
}
%>

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
</body>