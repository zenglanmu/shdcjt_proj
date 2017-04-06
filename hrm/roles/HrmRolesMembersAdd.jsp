<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
rs.executeProc("SystemSet_Select","");
rs.next();
int detachable=Util.getIntValue(rs.getString("detachable"),0);
//System.out.println("detachable######:"+detachable);

%>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(122,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(431,user.getLanguage());
String needfav ="1";
String needhelp ="";
/*本页面使用变量*/
String roleID=Util.null2String(request.getParameter("roleID"));
String para=""+roleID;
rs.execute("hrmroles_selectSingle",para);
rs.next();

int roletype=Util.getIntValue(rs.getString(4),0);

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1),_self} " ;
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


<form name=weaver method="post" action="HrmRolesMembersOperation.jsp" onSubmit='return check_form(this,"employeeID,roleID")'>
<input type=hidden name="operationType" value="New">
<input type=hidden name="roleID" value="<%=roleID%>">

<TABLE class=ViewForm>

 
  <tr>
    <td height="22" width="35"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></td>
	<td class=field colspan=2><%=Util.toScreen(RolesComInfo.getRolesRemark(roleID),user.getLanguage())%></td>
  </tr>
  <TR style="height:1px;"><TD class=Line colSpan=3></TD></TR> 
  <TR>
	<TD width="35"><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TD>
	<TD CLASS=FIELD colspan=2>
	<SELECT class=inputstyle Name=level>
			<OPTION VALUE=2><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></OPTION>
			<OPTION VALUE=1 ><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></OPTION>
			<OPTION VALUE=0 selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></OPTION>						
	</SELECT>	
	</TD>
  </TR>
  <TR style="height:1px;"><TD class=Line colSpan=3></TD></TR> 
  <tr>
    <td width="35"><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></td>

    <TD class=field>
    <SELECT class=inputstyle name=sharetype onchange="onChangeSharetype()">
    <%if(roletype==0){%>
        <option value="1" selected><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
        <option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
        <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
        <option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
		<%if(detachable==1){%>
        <option value="6"><%=SystemEnv.getHtmlLabelName(17870,user.getLanguage())%></option>
        <%}%>
        <option value="7"><%=SystemEnv.getHtmlLabelName(16139,user.getLanguage())%></option>
    <%}else{%>
        <option value="1" selected><%=SystemEnv.getHtmlLabelName(17870,user.getLanguage())%></option>
    <%}%>
    </SELECT>
	</TD>
    <TD class=field>
    <%if(roletype==0){%>
        <button type=button  class=Browser style="display:''" onClick="onShowResource('showrelatedsharename','relatedshareid')" name=showresource></BUTTON>
        <button type=button  class=Browser style="display:none" onclick="onShowHrmmanager('showrelatedsharename','relatedshareid')" name=showresourcemanager></button>
    <%}else{%>
        <button type=button  class=Browser onclick="onShowHrmmanager('showrelatedsharename','relatedshareid')" name=showresourcemanager></button>
    <%}%>
    <button type=button  class=Browser style="display:none" onClick="onShowDepartment('showrelatedsharename','relatedshareid')" name=showdepartment></BUTTON> 
    <button type=button  class=Browser style="display:none" onclick="onShowRole('showrelatedsharename','relatedshareid')" name=showrole></BUTTON>
    <INPUT class=inputstyle type=hidden name=relatedshareid value="">
    <span id=showrelatedsharename name=showrelatedsharename><IMG src='/images/BacoError.gif' align=absMiddle>
    </span>
    <span id=showrolelevel name=showrolelevel style="visibility:hidden">
    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
    <%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:
    <SELECT class=inputstyle name=rolelevel>
      <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
      <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
      <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
    </SELECT>
    </span>
    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
    <span id=showseclevel name=showseclevel style="display:none"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:
    <INPUT class=inputstyle type=text name=seclevel size=6 value="10" onchange='checkinput("seclevel","seclevelimage")'>
    </span>
    <SPAN id=seclevelimage></SPAN>
    </TD>

  </TR>
  <TR style="height:1px;"><TD class=Line colSpan=3></TD></TR>

</TABLE>
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

<script language=javascript>
function doSave() {
thisvalue=document.weaver.sharetype.value;
	if ( (thisvalue==1)||(thisvalue==3)||(thisvalue==4)||(thisvalue==6))
	{
		if(check_form(document.weaver,'relatedshareid')){
			$GetEle("weaver").submit();
			enableAllmenu();
		}
	}else{
		$GetEle("weaver").submit();
		enableAllmenu(); 
	}
	//alert('thisvalue:'+thisvalue+",relatedshareid:"+document.getElementById("relatedshareid").value);
}
</script>

<script language=javascript>
  function onChangeSharetype(){
	thisvalue=document.weaver.sharetype.value;
	document.weaver.relatedshareid.value="";
	$GetEle("showseclevel").style.display='';
	showrelatedsharename.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	if(thisvalue==1){
 		$GetEle("showresource").style.display='';
		$GetEle("showseclevel").style.display='none';
	}
	else{
		$GetEle("showresource").style.display='none';
	}
	if(thisvalue==3){
 		$GetEle("showdepartment").style.display='';
 		document.weaver.seclevel.value=10;
	}
	else{
		$GetEle("showdepartment").style.display='none';
		document.weaver.seclevel.value=10;
	}
	if(thisvalue==4){
 		$GetEle("showrole").style.display='';
		$GetEle("showrolelevel").style.visibility='visible';
		document.weaver.seclevel.value=10;
	}
	else{
		$GetEle("showrole").style.display='none';
		$GetEle("showrolelevel").style.visibility='hidden';
		document.weaver.seclevel.value=10;
    }
	if(thisvalue==5){
		showrelatedsharename.innerHTML = ""
		document.weaver.relatedshareid.value="";
		document.weaver.seclevel.value=10;
	}
	if(thisvalue==6){
 		$GetEle("showresourcemanager").style.display='';
		$GetEle("showseclevel").style.display='none';
	}
	else{
		$GetEle("showresourcemanager").style.display='none';
	}
	if(thisvalue==7){
	    showrelatedsharename.innerHTML = "<%=SystemEnv.getHtmlLabelName(16139,user.getLanguage())%>";
        $GetEle('relatedshareid').value = 1;
        $GetEle("showseclevel").style.display='none';
	}else{
        $GetEle('relatedshareid').value = "";
	}
}

function onShowDepartment(spanname, inputname) {
    
    url=escape("/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+$GetEle(inputname).value);
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url, "", "dialogWidth:550px;dialogHeight:550px;");
    try {
        jsid = new Array();jsid[0]=wuiUtil.getJsonValueByIndex(id, 0);jsid[1]=wuiUtil.getJsonValueByIndex(id, 1);
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0" && jsid[1]!="") {
            $GetEle(spanname).innerHTML = jsid[1].substring(1);
            $GetEle(inputname).value = jsid[0].substring(1);
        }else {
            $GetEle(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
            $GetEle(inputname).value = "";
        }
    }
}

function onShowRole(spanname, inputname){
    tmpids = $GetEle(inputname).value;
    if(tmpids!="-1"){ 
      url=escape("/hrm/roles/MutiRolesBrowser.jsp?resourceids="+tmpids);
    }else{
      url=escape("/hrm/roles/MutiRolesBrowser.jsp");
    }
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url, "", "dialogWidth:550px;dialogHeight:550px;");
    try {
        jsid = new Array();jsid[0]=wuiUtil.getJsonValueByIndex(id, 0);jsid[1]=wuiUtil.getJsonValueByIndex(id, 1);
        
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0" && jsid[1]!="") {
            $GetEle(spanname).innerHTML = jsid[1].substring(1);
            $GetEle(inputname).value = jsid[0].substring(1);
        }else {
            $GetEle(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
            $GetEle(inputname).value = "";
        }
    }
}
function onShowResource(spanname, inputname) {
    tmpids = $GetEle(inputname).value;
    if(tmpids!="-1"){ 
     url="/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids;
    }else{
     url="/hrm/resource/MutiResourceBrowser.jsp";
    }
    result = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url, "", "dialogWidth:550px;dialogHeight:550px;");
    
    if (result) {
        if (result.id!="") {
            $GetEle(spanname).innerHTML =result.name.substring(1);
            $GetEle(inputname).value = result.id.substring(1);
        } else {
            $GetEle(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
            $GetEle(inputname).value = "";
        }
    }
}
</script>

<script type="text/javascript">
function disModalDialog(url, spanobj, inputobj, need, curl) {

	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}



function onShowDepartment2() {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=" + $GetEle(inputename).value
			, $GetEle("tdname")
			, $GetEle("inputename")
			, true
			);
}

function onShowSubcompany(tdname,inputename) {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" + $GetEle(inputename).value
			, $GetEle(tdname)
			, $GetEle(inputename)
			, true);
}

function onShowResource2(tdname,inputename) {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?needsystem=1"
			, $GetEle(tdname)
			, $GetEle(inputename)
			, true);
}

function onShowRole(tdname,inputename) {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp"
			, $GetEle(tdname)
			, $GetEle(inputename)
			, true);
}

function onShowHrmmanager(tdname,inputename) {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/systeminfo/sysadmin/sysadminBrowser.jsp"
			, $GetEle(tdname)
			, $GetEle(inputename)
			, true);
}
</script>
</BODY>
</HTML>
