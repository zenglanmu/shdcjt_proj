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
	int isFromMode = Util.getIntValue(request.getParameter("isFromMode"),0);
	type = Util.null2String(request.getParameter("src"));

    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;

	if(type=="")
		type = "addform";
	if(!type.equals("addform")){
		FormManager.setFormid(formid);
		FormManager.getFormInfo();
		formname=FormManager.getFormname();
        subCompanyId2 = ""+FormManager.getSubCompanyId2() ;
		formdes=FormManager.getFormdes();
	}
	
    if(detachable==1){  
        subCompanyId=Util.getIntValue(subCompanyId2,-1);
        if(subCompanyId == -1){
            subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),-1);
            if(subCompanyId == -1) subCompanyId = user.getUserSubCompany1();
        }
        if(subCompanyId == 0){//系统管理员分部id=0
            RecordSet.executeProc("SystemSet_Select","");
            RecordSet.next();
            subCompanyId = Util.getIntValue(RecordSet.getString("dftsubcomid"),0);
        }
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"FormManage:All",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("FormManage:All", user))
            operatelevel=2;
    }
    if(subCompanyId == 0) subCompanyId2 = "";
    else subCompanyId2 = ""+subCompanyId;


String message = Util.null2String(request.getParameter("message"));
if("issamename".equals(message)){ 
    message = SystemEnv.getHtmlLabelName(22750,user.getLanguage());
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage())+":";
String needfav ="";
if(!ajax.equals("1"))
{
needfav ="1";
}
String needhelp ="";
if(type.equals("addform"))	titlename+=SystemEnv.getHtmlLabelName(611,user.getLanguage());
else titlename+=SystemEnv.getHtmlLabelName(93,user.getLanguage());
	
	String from = Util.null2String(request.getParameter("from"));
	
boolean candelete = true;
RecordSet.executeSql("select * from workflow_base where formid="+formid);
if(RecordSet.next()) candelete = false;
%>  
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<br>
<form name="addformtabspecial" method="post" action="/workflow/form/form_operation.jsp" >
<%if(isformadd==1 && ajax.equals("1") && !type.equals("addform")){%>
<iframe src="/workflow/form/FormIframe.jsp?formname=<%=formname%>&formid=<%=formid%>" width=0 height=0></iframe>
<%}%>
<input type="hidden" value="<%=type%>" name="src">
<input type="hidden" value="<%=formid%>" name="formid">
<input type="hidden" value="<%=formid%>" name="delete_form_id">
<input type=hidden name="ajax" value="<%=ajax%>">
<input type="hidden" value="<%=isformadd%>" name="isformadd">
<input type="hidden" value="<%=from%>" name="from">
<input type="hidden" value="<%=isFromMode%>" name="isFromMode">
<%
    if(operatelevel>0){
        if(!ajax.equals("1"))
        RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self}" ;
        else if(from.equals("addDefineForm")){
        	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:addformtabsubmit1(this),_self}" ;
	      }else{
	        RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:addformtabsubmit0(this),_self}" ;
        }
	      RCMenuHeight += RCMenuHeightStep ;
    }
    if(type.equals("editform")&&operatelevel>0){
				if(formid != 14){
	        //RCMenu += "{"+SystemEnv.getHtmlLabelName(15449,user.getLanguage())+",addformfield.jsp?formid="+formid+",_self}" ;
	        //RCMenuHeight += RCMenuHeightStep ;
				}
				
        //RCMenu += "{"+SystemEnv.getHtmlLabelName(15450,user.getLanguage())+",addformfieldlabel.jsp?formid="+formid+",_self}" ;
        //RCMenuHeight += RCMenuHeightStep ;
        
				if(formid != 14){
        //RCMenu += "{"+SystemEnv.getHtmlLabelName(18368,user.getLanguage())+",addformrowcal.jsp?formid="+formid+",_self}" ;
        //RCMenuHeight += RCMenuHeightStep ;
        }
				if(formid != 14){
        //RCMenu += "{"+SystemEnv.getHtmlLabelName(18369,user.getLanguage())+",addformcolcal.jsp?formid="+formid+",_self}" ;
        //RCMenuHeight += RCMenuHeightStep ;
				}
        if(formid != 14 && candelete){
            RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteform(),_self}" ;
            RCMenuHeight += RCMenuHeightStep ;
        }
    }
    if(!ajax.equals("1"))
    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",manageform.jsp,_self}" ;
    else
    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:addformtabretun(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
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
    <%if(operatelevel>0){%>
    	<input type="text" name="formname" class=Inputstyle size=40 value="<%=Util.toScreenToEdit(formname,user.getLanguage())%>"
    	onChange="checkinput('formname','formnamespan')" maxlength="50">
    	<span id=formnamespan><%if(formname.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></span>
    <%} else {%>
    	<%=Util.toScreen(formname,user.getLanguage())%>
    <%}%>
    </td>
  </tr><TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
	<%//选择已有表单，只有新建表单时才有。TD10835
		if("addform".equals(type)){
	%>
        <tr>
            <td ><%=SystemEnv.getHtmlLabelName(23946,user.getLanguage())%></td>
            <td colspan=5 class=field >
                <%if(operatelevel>0){%>
                    <BUTTON type='button' class="Browser" id="billidSelect" name="billidSelect" onClick="onShowFormSelectForCopy('0', oldformid, oldformidspan,'0')"></BUTTON>
                <%}%>
                <SPAN id="oldformidspan" name="oldformidspan"></SPAN>
                <INPUT type="hidden" id="oldformid" name="oldformid" value="">
            </td>
        </tr>
        <tr class="Spacing" style="height: 1px"><td colspan=2 class="Line"></td></tr>
	<%}%>
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
	if (check_form(addformtabspecial,'formname,subcompanyid')){
		addformtabspecial.submit();
        obj.disabled=true;
    }
}
function deleteform(){
    addformtabspecial.action = "/workflow/form/delforms.jsp";
    addformtabspecial.submit();
}
</script>
<script language="VBScript">
sub adfonShowSubcompany()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowManage:All&selectedids="&addformtabspecial.subcompanyid.value)
	issame = false
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = addformtabspecial.subcompanyid.value then
		issame = true
	end if
	subcompanyspan1.innerHtml = id(1)
	addformtabspecial.subcompanyid.value=id(0)
	else
	subcompanyspan1.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	addformtabspecial.subcompanyid.value=""
	end if
	end if
end sub
sub onShowFormSelectForCopy(isbill,inputName, spanName,isMand)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/wfFormBrowser.jsp?isbill="+isbill)

	if (Not IsEmpty(id)) then
	    if id(0)<>"" then
		    inputName.value=id(0)
		    spanName.innerHtml = id(1)
	    else
		    inputName.value=""
		    if isMand=1 then
			    spanName.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			else
			    spanName.innerHtml = ""
			end if
	    end if
	end if
end sub
</script>
<%}%>
</body>
</html>