<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />

<%
int categoryid = Util.getIntValue(request.getParameter("categoryid"),0);
int categorytype = Util.getIntValue(request.getParameter("categorytype"),0);
int operationcode = Util.getIntValue(request.getParameter("operationcode"),0);

if (!CategoryUtil.checkCategoryExistence(categorytype, categoryid)) {
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	return;
}

AclManager am = new AclManager();
if (!HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) && !am.hasPermission(categoryid, categorytype, user, AclManager.OPERATION_CREATEDIR)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdCRMAccount.gif";
String titlename = Util.null2String(request.getParameter("titlename"));
if("".equals(titlename)) titlename = SystemEnv.getHtmlLabelName(119,user.getLanguage());
if(categorytype==0)
    titlename += " - "+SystemEnv.getHtmlLabelName(65,user.getLanguage()) ;
else if(categorytype==1)
    titlename += " - "+SystemEnv.getHtmlLabelName(66,user.getLanguage()) ;
else
    titlename += " - "+SystemEnv.getHtmlLabelName(67,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location.href='"+CategoryUtil.getCategoryEditPage(categorytype, categoryid)+"',_top} " ;
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

<FORM id=mainform name=mainform action="PermissionOperation.jsp" method=post onsubmit='return check_by_permissiontype()'>
  <input type="hidden" name="method" value="add">
  <input type="hidden" name="categoryid" value="<%=categoryid%>">
  <input type="hidden" name="categorytype" value="<%=categorytype%>">
  <input type="hidden" name="operationcode" value="<%=operationcode%>">

  <input type="hidden" name="mutil" value="1">

  <TABLE class=ViewForm>
    <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
    </COLGROUP>
    <TBODY>
      <TR class=Title><TH colSpan=2>
      </TH></TR>
      <TR class=Spacing style="height: 1px"><TD class=Line1 colSpan=2>
      </TD></TR>
      <TR><TD class=field colSpan=2>
        <SELECT class=InputStyle name=permissiontype onchange="onChangePermissionType()">
          <option selected value="1"><%=SystemEnv.getHtmlLabelName(7175,user.getLanguage())%></option>
          <option value="6"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>＋<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(7176,user.getLanguage())%></option>
          <option value="3"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></option>
          <option value="4"><%=SystemEnv.getHtmlLabelName(7178,user.getLanguage())%></option>
          <option value="5"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
        </SELECT>
      </TD></TR>
<TR  style="height: 1px"><TD class=Line colSpan=2></TD></TR>
      <TR><TD class=field>
        <BUTTON class=Browser type="button" style="display:none" onClick="onShowSubcompany('showrelatedsharename','subcompanyid')" name=showsubcompany></BUTTON>
        <INPUT type=hidden name=subcompanyid value="">
        <BUTTON class=Browser type="button" style="display:''" onClick="onShowDepartment('showrelatedsharename','departmentid')" name=showdepartment></BUTTON>
        <INPUT type=hidden name=departmentid value="">
        <BUTTON class=Browser type="button" style="display:none" onclick="onShowRole('showrelatedsharename','roleid')" name=showrole></BUTTON>
        <INPUT type=hidden name=roleid value="">
        <BUTTON class=Browser  type="button" style="display:none" onclick="onShowResource('showrelatedsharename','userid')" name=showuser></BUTTON>
        <INPUT type=hidden name=userid value="">
        <span id=showrelatedsharename name=showrelatedsharename></span>
        <span id=showusertype name=showusertype style="display:none">
          <%=SystemEnv.getHtmlLabelName(7179,user.getLanguage())%>:
          <SELECT  class=InputStyle name=usertype onchange="onChangeUserType()">
          <option selected value="0"><%=SystemEnv.getHtmlLabelName(131,user.getLanguage())%></option>
          <%while(CustomerTypeComInfo.next()){
        	  String curid=CustomerTypeComInfo.getCustomerTypeid();
        	  String curname=CustomerTypeComInfo.getCustomerTypename();
        	  String optionvalue=curid;
          %>
          <option value="<%=optionvalue%>"><%=Util.toScreen(curname,user.getLanguage())%></option>
          <%}%>
          </SELECT>
        </span>
      </TD>
      <TD class=field>
        <span id=showseclevel name=showseclevel style="display:''">
        <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:
        <INPUT type=text id=seclevel name=seclevel size=6 value="10" onchange="checkinput('seclevel','seclevelimage')">
        <SPAN id=seclevelimage></SPAN>
        </span>
        <span id=showrolelevel name=showrolelevel style="display:none">
          &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
          <%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:
          <SELECT class=InputStyle name=rolelevel>
            <option selected value="0"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
            <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
            <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
          </SELECT>
        </span>
      </TD>
      </tr>
<TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
    </TBODY>
  </TABLE>
</FORM>

<script language=javascript>
onChangePermissionType();

function check_by_permissiontype() {
    if (document.mainform.permissiontype.value == 1) {
        return check_form(mainform, "departmentid, seclevel")
    } else if (document.mainform.permissiontype.value == 2) {
        return check_form(mainform, "roleid, rolelevel, seclevel");
    } else if (document.mainform.permissiontype.value == 3) {
        return check_form(mainform, "seclevel");
    } else if (document.mainform.permissiontype.value == 4) {
        return check_form(mainform, "usertype, seclevel");
    } else if (document.mainform.permissiontype.value == 5) {
        return check_form(mainform, "userid");
    } else if (document.mainform.permissiontype.value == 6) {
        return check_form(mainform, "subcompanyid, seclevel")
    } else {
        return false;
    }
}

function doSave(obj) {
    if (check_by_permissiontype()) {
    	obj.disabled=true;
	    document.mainform.submit();
	}
}

function onChangePermissionType() {
	thisvalue=document.mainform.permissiontype.value;
	document.mainform.departmentid.value="";
	document.mainform.roleid.value="";
	document.mainform.userid.value="";

	if (thisvalue == 1) {
	    jQuery($GetEle("showrelatedsharename")).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
 		jQuery($GetEle("showsubcompany")).css("display","none");
 		jQuery($GetEle("showdepartment")).css("display","");
 		jQuery($GetEle("showrole")).css("display","none");
 		jQuery($GetEle("showusertype")).css("display","none");
 		jQuery($GetEle("showrolelevel")).css("display","none");
 		jQuery($GetEle("showuser")).css("display","none");
 		jQuery($GetEle("showseclevel")).css("display","");
    }
	else if (thisvalue == 2) {
	    jQuery($GetEle("showrelatedsharename")).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
 		jQuery($GetEle("showsubcompany")).css("display","none");
 		jQuery($GetEle("showdepartment")).css("display","none");
 		jQuery($GetEle("showrole")).css("display","");
 		jQuery($GetEle("showusertype")).css("display","none");
 		jQuery($GetEle("showrolelevel")).css("display","");
 		jQuery($GetEle("showuser")).css("display","none");
 		jQuery($GetEle("showseclevel")).css("display","");
	}
	else if (thisvalue == 3) {
	    jQuery($GetEle("showrelatedsharename")).html("");
 		jQuery($GetEle("showsubcompany")).css("display","none");
 		jQuery($GetEle("showdepartment")).css("display","none");
 		jQuery($GetEle("showrole")).css("display","none");
 		jQuery($GetEle("showusertype")).css("display","none");
 		jQuery($GetEle("showrolelevel")).css("display","none");
 		jQuery($GetEle("showuser")).css("display","none");
 		jQuery($GetEle("showseclevel")).css("display","");
	}
	else if (thisvalue == 4) {
	    jQuery($GetEle("showrelatedsharename")).html("");
 		jQuery($GetEle("showsubcompany")).css("display","none");
 		jQuery($GetEle("showdepartment")).css("display","none");
 		jQuery($GetEle("showrole")).css("display","none");
 		jQuery($GetEle("showusertype")).css("display","");
 		jQuery($GetEle("showrolelevel")).css("display","none");
 		jQuery($GetEle("showuser")).css("display","none");
 		jQuery($GetEle("showseclevel")).css("display","");
	}
	else if (thisvalue == 5) {
	    jQuery($GetEle("showrelatedsharename")).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
 		jQuery($GetEle("showsubcompany")).css("display","none");
 		jQuery($GetEle("showdepartment")).css("display","none");
 		jQuery($GetEle("showrole")).css("display","none");
 		jQuery($GetEle("showusertype")).css("display","none");
 		jQuery($GetEle("showrolelevel")).css("display","none");
 		jQuery($GetEle("showuser")).css("display","");
 		jQuery($GetEle("showseclevel")).css("display","none");
	}
	else if (thisvalue == 6) {
	    jQuery($GetEle("showrelatedsharename")).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
 		jQuery($GetEle("showsubcompany")).css("display","");
 		jQuery($GetEle("showdepartment")).css("display","none");
 		jQuery($GetEle("showrole")).css("display","none");
 		jQuery($GetEle("showusertype")).css("display","none");
 		jQuery($GetEle("showrolelevel")).css("display","none");
 		jQuery($GetEle("showuser")).css("display","none");
 		jQuery($GetEle("showseclevel")).css("display","");
	}
}

function onChangeUserType() {
    thisvalue = document.all("usertype").value;
    if (thisvalue == "0") {
        document.all("seclevel").value = "10";
    } else {
        document.all("seclevel").value = "0";
    }
}
var opts={
		_dwidth:'550px',
		_dheight:'550px',
		_url:'about:blank',
		_scroll:"no",
		_dialogArguments:"",
		
		value:""
	};
var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
opts.top=iTop;
opts.left=iLeft;
function onShowResource(spanname,inputname){
	linkurl="javaScript:openhrm(";
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (datas) {
		if (datas.id!= "") {
			ids = datas.id.split(",");
			names =datas.name.split(",");
			sHtml = "";
			for( var i=0;i<ids.length;i++){
				if(ids[i]!=""){
					sHtml = sHtml+"<a href="+linkurl+ids[i]+")  onclick='pointerXY(event);'>"+names[i]+"</a>&nbsp";
				}
			}
			$("#"+spanname).html(sHtml);
			$("input[name="+inputname+"]").val(datas.id);
		} else {
			$("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			$("input[name="+inputname+"]").val("");
		}
	}
}
function onShowSubcompany(spanname,inputname)  {
	  linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id=";
	      datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+$("input[name="+inputname+"]").val()+"&selectedDepartmentIds="+$("input[name="+inputname+"]").val(),
	       "","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	     if (datas) {
	      if (datas.id!= "") {
	          ids = datas.id.split(",");
	      names =datas.name.split(",");
	      sHtml = "";
	      for( var i=0;i<ids.length;i++){
	      if(ids[i]!=""){
	       sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
	      }
	      }
	      $("#"+spanname).html(sHtml);
	      $("input[name="+inputname+"]").val(datas.id);
	      $GetEle("mutil").value = "1"
	      }
	      else {
	            $("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
	      		$("input[name="+inputname+"]").val("");
	      }
	  }
	  }

function onShowRole(tdname,inputename){
	  datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if(datas){
	    if (datas.id!=""){
		$("#"+tdname).html(datas.name);
		$("input[name="+inputename+"]").val(datas.id);
	    }else{
	    	$("#"+tdname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
	    	$("input[name="+inputename+"]").val("");
	    }
	}
}

function onShowDepartment(spanname,inputname){
	  
	  linkurl="/hrm/company/HrmDepartmentDsp.jsp?id=";
	  datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+$("input[name="+inputname+"]").val()+"&selectedDepartmentIds="+$("input[name="+inputname+"]").val(),
	  "","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	   if (datas) {
	      if (datas.id!= "") {
	          ids = datas.id.split(",");
	      names =datas.name.split(",");
	      sHtml = "";
	      for( var i=0;i<ids.length;i++){
	      if(ids[i]!=""){
	       sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
	      }
	      }
	      $("#"+spanname).html(sHtml);
	      $("input[name="+inputname+"]").val(datas.id);
	      $GetEle("mutil").value = "1"
	      }
	      else {
	            $("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
	      $("input[name="+inputname+"]").val("");
	      }
	  }
}
</script>

</BODY>
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
</HTML>
