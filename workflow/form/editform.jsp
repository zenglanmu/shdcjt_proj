<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="session"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<html>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>

<%
	if(!HrmUserVarify.checkUserRight("FormManage:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");
    	
		return;
	}
%>

<%
    String ajax=Util.null2String(request.getParameter("ajax"));
    int isformadd = Util.getIntValue(request.getParameter("isformadd"),0);
    if(!ajax.equals("1")){
%>
<!-- add by xhheng @20050204 for TD 1538-->
<script language=javascript src="/js/weaver.js"></script>
<%
    }
%>

</head>
<%

	String type="";
	String formname="";
	String formdes="";
	int formid=0;
    String subCompanyId2 = "";
	formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);

    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;
 
RecordSet.executeSql("select * from workflow_bill where id="+formid);
if(RecordSet.next()){
	formname = Util.null2String(SystemEnv.getHtmlLabelName(RecordSet.getInt("namelabel"),user.getLanguage()));
	formname = formname.replaceAll("<","£¼").replaceAll(">","£¾").replaceAll("'","''");
	formdes = RecordSet.getString("formdes");
	formdes = formdes.replaceAll("<","£¼").replaceAll(">","£¾").replaceAll("'","''");
	subCompanyId = RecordSet.getInt("subcompanyid");
	subCompanyId2 = ""+subCompanyId;
}

boolean candelete = true;
RecordSet.executeSql("select * from workflow_base where formid="+formid);
if(RecordSet.next()) candelete = false;

    if(detachable==1){  
        //subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),-1);
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"FormManage:All",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("FormManage:All", user))
            operatelevel=2;
    }

    subCompanyId2 = ""+subCompanyId;
String message = Util.null2String(request.getParameter("message"));
if("issamename".equals(message)){ 
    message = SystemEnv.getHtmlLabelName(22750,user.getLanguage());
}  
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage())+":";
String needfav ="";
if(!ajax.equals("1")){
needfav ="1";
}
String needhelp ="";
titlename+=SystemEnv.getHtmlLabelName(93,user.getLanguage());
%>  
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<br>
<form name="addformtabspecial" method="post" action="/workflow/form/form_operation.jsp" >
<!--<iframe src="/workflow/form/FormIframe0.jsp?formname=<%=formname%>&formid=<%=formid%>" width=0 height=0></iframe>-->
<input type="hidden" value="eidtform" name="src">
<input type="hidden" value="<%=formid%>" name="formid">
<input type="hidden" value="<%=formid%>" name="delete_newform_id">
<input type=hidden name="ajax" value="<%=ajax%>">
<%
    if(operatelevel>0){
    	if(ajax.equals("1"))
        RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:addformtabsubmit0(this),_self}" ;
        RCMenuHeight += RCMenuHeightStep ;
    }
    if(ajax.equals("1")){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:addformtabretun(),_self}" ;
	    RCMenuHeight += RCMenuHeightStep ;
	    if(candelete){
	        RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteform(),_self}" ;
	        RCMenuHeight += RCMenuHeightStep ;
	    }
	  }
%>

<%if(!ajax.equals("1")){%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>
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


<table class="viewform">
  <COLGROUP>
   <COL width="20%">
   <COL width="80%">
  <TR class="Title">
    	  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%>&nbsp;&nbsp;<font color=red><%=message%></font></TH></TR>
    <TR class="Spacing" style="height: 1px">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></td>
    <td class=field>
    	<input type="text" name="formname" class=Inputstyle size=40 value="<%=Util.toScreenToEdit(formname,user.getLanguage())%>"
    	onChange="checkinput('formname','formnamespan')" maxlength="50">
    	<span id=formnamespan><%if(formname.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></span>
    </td>
  </tr><TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>

    <%if(detachable==1){%>  
        <tr>
            <td ><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></td>
            <td colspan=5 class=field >
                <%if(operatelevel>0){%>
                    <BUTTON type='button' class=Browser id=SelectSubCompany onclick="adfonShowSubcompany()"></BUTTON>
                <%}%>
                <SPAN id=subcompanyspan1 name=subcompanyspan1> <%=SubCompanyComInfo.getSubCompanyname(subCompanyId2)%>
                    <%if(subCompanyId2.equals("")){%>
                        <IMG src="/images/BacoError.gif" align=absMiddle>
                    <%}%>
                </SPAN>
                <INPUT class=inputstyle id=subcompanyid type=hidden name=subcompanyid value="<%=subCompanyId2%>">
            </td>
        </tr>
        <tr class="Spacing" style="height: 1px"><td colspan=2 class="Line"></td></tr>
    <%}%>

  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15452,user.getLanguage())%></td>
    <td class=field>
    <%if(operatelevel>0){%>
    <textarea rows="3" name="formdes" class=Inputstyle cols="40"><%=Util.toScreenToEdit(formdes,user.getLanguage())%></textarea>
    <%} else {%>
    	<%=Util.toScreen(formdes,user.getLanguage())%>
    <%}%>
    </td>
  </tr><TR style="height: 1px"><TD class=Line1 colSpan=2></TD></TR>
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
<%
if(!ajax.equals("1")){
%>
<script language="javascript">
function submitData(obj)
{
	if (check_form(addformtabf,'formname,subcompanyid')){
		addformtabf.submit();
        obj.disabled=true;
    }
}
</script>
<script language="VBScript">
sub adfonShowSubcompany()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowManage:All&selectedids="&addformtabf.subcompanyid.value)
	issame = false
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = addformtabf.subcompanyid.value then
		issame = true
	end if
	subcompanyspan1.innerHtml = id(1)
	addformtabf.subcompanyid.value=id(0)
	else
	subcompanyspan1.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	addformtabf.subcompanyid.value=""
	end if
	end if
end sub
</script>
<%}%>
</body>
</html>