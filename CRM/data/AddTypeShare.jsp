<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />

<%
String crmtypename = Util.null2String(request.getParameter("crmtypename"));
String typeid = Util.null2String(request.getParameter("typeid"));
String itemtype = Util.null2String(request.getParameter("itemtype"));


//out.print(typeid);
boolean canedit_share = HrmUserVarify.checkUserRight("EditCustomerType:Edit",user);

if(!canedit_share) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
 }
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(119,user.getLanguage())+"- "+SystemEnv.getHtmlLabelName(1282,user.getLanguage())+":"+Util.toScreen(crmtypename,user.getLanguage(),"0");
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>


<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">

<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<FORM id=weaver name=weaver action="/CRM/data/TypeShareOperation.jsp" method=post onsubmit='return check_form(this,"itemtype,relatedshareid,sharetype,rolelevel,seclevel,sharelevel")'>
<input type="hidden" name="method" value="add">
<input type="hidden" name="typeid" value="<%=typeid%>">
<input type="hidden" name="itemtype" value="<%=itemtype%>">
<DIV style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:document.weaver.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
	<BUTTON class=btnSave accessKey=S id=mysave type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:doClick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
	<BUTTON class=BtnDelete id=myfun1 accessKey=C name=button1 onclick='doClick()'><U>C</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
</DIV>
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2></TH>
          </TR>
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD class=field>
<SELECT class=InputStyle  name=sharetype onchange="onChangeSharetype()">
  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>
  <option value="2" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
  <option value="3"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>
  <option value="4"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>
</SELECT>
		  </TD>
          <TD class=field>
<BUTTON class=Browser style="display:none" type="button" onClick="onShowResource('showrelatedsharename','relatedshareid')" name=showresource></BUTTON> 
<BUTTON class=Browser style="display:''" type="button"  onClick="onShowDepartment('showrelatedsharename','relatedshareid')" name=showdepartment></BUTTON> 
<BUTTON class=Browser style="display:none" type="button"  onclick="onShowRole('showrelatedsharename','relatedshareid')" name=showrole></BUTTON>
 <INPUT type=hidden name=relatedshareid value="<%=user.getUserDepartment()%>">
 <span id=showrelatedsharename name=showrelatedsharename ><%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+user.getUserDepartment()),user.getLanguage())%></span>
<span id=showrolelevel name=showrolelevel style="visibility:hidden">
&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:
  <SELECT name=rolelevel class=InputStyle>
  <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
  <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
  <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
</SELECT>
</span>
&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
<span id=showseclevel name=showseclevel>
<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:
<INPUT class=InputStyle maxLength=3 size=5 
            name=seclevel onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("seclevel");checkinput("seclevel","seclevelimage")' value="10">
</span>
<SPAN id=seclevelimage></SPAN>

		  </TD>		
		</TR>
          <TD class=field>
			<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
		  </TD>
          <TD class=field>
			<SELECT class=InputStyle  name=sharelevel>
			  <option value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
			</SELECT>
		  </TD>		
		</TR>

		</TBODY>
	  </TABLE>
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
<script language=javascript>
	
  function onChangeSharetype(){
	thisvalue=document.weaver.sharetype.value
	document.weaver.relatedshareid.value=""
	$("#showseclevel").show();

	$("#showrelatedsharename").html("<IMG src='/images/BacoError.gif' align=absMiddle>");

	if(thisvalue==1){
 		$("button[name=showresource]").show();
		$("#showseclevel").hide();
		//TD33012 当安全级别为空时，选择人力资源，赋予安全级别默认值10，否则无法提交保存
		$("#seclevelimage").empty();
		if($("input[name=seclevel]").val()==""){
			$("input[name=seclevel]").val(10);
		}
		//End TD33012
	}
	else{
		$("button[name=showresource]").hide();
	}
	if(thisvalue==2){
		$("button[name=showdepartment]").show();
	}
	else{
		$("button[name=showdepartment]").hide();
	}
	if(thisvalue==3){
 		$("button[name=showrole]").show();
		$("#showrolelevel").css("visibility","visible");
	}
	else{
		$("button[name=showrole]").hide();
		$("#showrolelevel").css("visibility","hidden");
    }
	if(thisvalue==4){
		$("#showrelatedsharename").empty();
		document.weaver.relatedshareid.value="-1"

	}
	//TD33012 切换时，增加对安全级别为空的提示；人力资源没有安全级别
	if(document.all("seclevel").value==""&&thisvalue!=1){
		$("#seclevelimage").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
	}
	//End TD33012
}
</script>

<SCRIPT language=VBS>





</SCRIPT>
<script type="text/javascript">
function onShowRole(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if (data){
	    if (data.id!=""){
			document.all(tdname).innerHTML = data.name
			document.all(inputename).value=data.id
	    }else{
			document.all(tdname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			document.all(inputename).value=""
	    }
	}
}
function onShowResource(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (data){
	    if (data.id!=""){
			document.all(tdname).innerHTML = data.name
			document.all(inputename).value=data.id
	    }else{
			document.all(tdname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			document.all(inputename).value=""
	    }
	}
}
function onShowDepartment(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+document.all(inputename).value)
	if (data){
	    if (data.id!=""){
			document.all(tdname).innerHTML = data.name
			document.all(inputename).value=data.id
	    }else{
			document.all(tdname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			document.all(inputename).value=""
	    }
	}
}
function doClick(){
	location.href="/CRM/Maint/EditCustomerType.jsp?id=<%=typeid%>"
}
</script>

</BODY>
</HTML>
