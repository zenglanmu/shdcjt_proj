<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>

<%
String capitalname = Util.null2String(request.getParameter("capitalname"));
String capitalid = Util.null2String(request.getParameter("capitalid"));

RecordSet.executeProc("CptCapital_SelectByID",capitalid);
if(RecordSet.getCounts()<=0)
{
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	return;
}
RecordSet.first();
String resourceid = Util.null2String(RecordSet.getString("resourceid"));
String startdate = Util.null2String(RecordSet.getString("startdate"));
String enddate = Util.null2String(RecordSet.getString("enddate"));

RecordSetShare.executeProc("CptCapitalShareInfo_SbyRelated",capitalid);

/*显示权限判断*/
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     			Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     			Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

//boolean isSelf		=	false;
//boolean isManager	=	false;
boolean displayAll	=	false;
boolean canedit     =   false;
boolean canview    =   false;
boolean canviewlog	 = false;
//AllManagers.getAll(resourceid);

/*有显示权限的可以查看所有资产*/
if(HrmUserVarify.checkUserRight("CptCapital:Display",user))  {
	displayAll		=	true;
}

/*未生效的资产只有有查看权限的人才可以查看*/
if(!((currentdate.compareTo(startdate)>=0 || startdate.equals(""))&& (currentdate.compareTo(enddate)<=0 || enddate.equals("")))){
	if (!displayAll){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
}

///*用户可以查看自己的资产*/
//if (resourceid.equals(""+user.getUID()) ){
//	isSelf = true;
//}
//
///*用户的直接上级和间接上级都可以查看他的资产*/
//while(AllManagers.next()){
//	String tempmanagerid = AllManagers.getManagerID();
//	if (tempmanagerid.equals(""+user.getUID())) {
//		isManager = true;
//	}
//}

/*可否编辑*/
if(HrmUserVarify.checkUserRight("CptCapitalEdit:Edit",user))  {
	canedit		=	true;
}

/*可否查看日志*/
if(HrmUserVarify.checkUserRight("CptCapital:Log",user))  {
	canviewlog	= true;
}

/*共享权限判断*/
RecordSetShare.executeProc("CptCapitalShareInfo_SbyRelated",capitalid);
while(RecordSetShare.next()){
	if(RecordSetShare.getInt("sharetype")==1){
	  if(RecordSetShare.getInt("userid")==user.getUID()){
		    canview=true;
		if(RecordSetShare.getInt("sharelevel")==2){
			canedit=true;
			canviewlog=true;
		}
	  }
	}else if(RecordSetShare.getInt("sharetype")==2){
	  if(RecordSetShare.getInt("departmentid")==user.getUserDepartment()){
		  if(RecordSetShare.getInt("seclevel")<=Util.getIntValue(user.getSeclevel())){
			canview=true;
			if(RecordSetShare.getInt("sharelevel")==2){
				canedit=true;
				canviewlog=true;
			}
		  }
	  }
	}else if(RecordSetShare.getInt("sharetype")==3){
		if(CheckUserRight.checkUserRight(""+user.getUID(),RecordSetShare.getString("roleid"),RecordSetShare.getString("rolelevel"))){
			if((RecordSetShare.getString("rolelevel").equals("0") && user.getUserDepartment()==RecordSet.getInt("department")) || (RecordSetShare.getString("rolelevel").equals("1") && user.getUserSubCompany1()==RecordSet.getInt("subcompanyid1")) || (RecordSetShare.getString("rolelevel").equals("2")) ){
				  if(RecordSetShare.getInt("seclevel")<=Util.getIntValue(user.getSeclevel())){
					canview=true;
					if(RecordSetShare.getInt("sharelevel")==2){
						canedit=true;
						canviewlog=true;
					}
				  }
			}
	   }
	}else if(RecordSetShare.getInt("sharetype")==4){
		if(RecordSetShare.getInt("seclevel")<=Util.getIntValue(user.getSeclevel())){
			canview=true;
			if(RecordSetShare.getInt("sharelevel")==2){
				canedit=true;
				canviewlog=true;
			}
		}
	}
}

RecordSetShare.first();

/*可否添加共享*/
if(!(displayAll||canview||canedit)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限判断结束*/

%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(119,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(535,user.getLanguage())+":<a href='/cpt/capital/CptCapital.jsp?id="+capitalid+"'>"+Util.toScreen(capitalname,user.getLanguage(),"0")+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=weaver name=weaver action="/cpt/capital/ShareOperation.jsp" method=post onsubmit='return check_form(this,"itemtype,relatedshareid,sharetype,rolelevel,seclevel,sharelevel")'>
<input type="hidden" name="method" value="add">
<input type="hidden" name="capitalid" value="<%=capitalid%>">
<input type="hidden" name="capitalname" value='<%=Util.toScreen(capitalname,user.getLanguage(),"0")%>'>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

			  <TABLE class=ViewForm>
				<COLGROUP>
				<COL width="20%">
				<COL width="80%">
				<TBODY>
				<TR class=Spacing  style="height:1px">
				  <TD class=Line colSpan=2></TD></TR>
				<TR>
				  <TD>
		<SELECT name=sharetype onchange="onChangeSharetype()" class="InputStyle">
		  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>
		  <option value="2" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
		  <option value="3"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>
		  <option value="4"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>
		</SELECT>
				  </TD>
				  <TD class=field>
		<BUTTON class=Browser type="button" style="display:none" onClick="onShowResource('showrelatedsharename','relatedshareid')" name=showresource></BUTTON> 
		<BUTTON class=Browser type="button" style="display:''" onClick="onShowDepartment('showrelatedsharename','relatedshareid')" name=showdepartment></BUTTON> 
		<BUTTON class=Browser type="button" style="display:none" onclick="onShowRole('showrelatedsharename','relatedshareid')" name=showrole></BUTTON>
		 <INPUT type=hidden name=relatedshareid value="<%=user.getUserDepartment()%>">
		 <span id=showrelatedsharename name=showrelatedsharename ><%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+user.getUserDepartment()),user.getLanguage())%></span>
		<span id=showrolelevel name=showrolelevel style="visibility:hidden">
		&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
		<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:
		<SELECT name=rolelevel class="InputStyle">
		  <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
		  <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
		  <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
		</SELECT>
		</span>
		&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
		<span id=showseclevel name=showseclevel>
		<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:
		<INPUT class="InputStyle" maxLength=3 size=5 
					name=seclevel onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("seclevel");checkinput("seclevel","seclevelimage")' value="10" >
		</span>
		<SPAN id=seclevelimage></SPAN>

				  </TD>		
				</TR>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<TR>
				  <TD >
					<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
				  </TD>
				  <TD class=field>
					<SELECT name=sharelevel class="InputStyle" class="InputStyle">
					  <option value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
					  <%if(canedit){%>
					  <option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
					  <%}%>
					</SELECT>
				  </TD>		
				</TR>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				</TBODY>
			  </TABLE>

		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
</table>

<script language=javascript>
  function onChangeSharetype(){
	thisvalue= jQuery("select[name=sharetype]").val();
	jQuery("input[name=relatedshareid]").val("");
	jQuery("#showseclevel").show();

	jQuery("#showrelatedsharename").html("<IMG src='/images/BacoError.gif' align=absMiddle>");

	if(thisvalue==1){
 		jQuery("button[name=showresource]").show();
		jQuery("#showseclevel").hide();

		//TD33012 当安全级别为空时，选择人力资源，赋予安全级别默认值10，否则无法提交保存
		seclevelimage.innerHTML = ""
		if(jQuery("input[name=seclevel]").val()==""){
			jQuery("input[name=seclevel]").val(10);
		}
		//End TD33012
	}
	else{
		jQuery("button[name=showresource]").hide();
	}
	if(thisvalue==2){
 		jQuery("button[name=showdepartment]").show();
	}
	else{
		jQuery("button[name=showdepartment]").hide();
	}
	if(thisvalue==3){
 		jQuery("button[name=showrole]").show();
		jQuery("#showrolelevel")[0].style.visibility='visible';
	}
	else{
		jQuery("button[name=showrole]").hide();
		jQuery("#showrolelevel")[0].style.visibility='hidden';
    }
	if(thisvalue==4){
		jQuery("#showrelatedsharename").html("");
		jQuery("input[name=relatedshareid]").val("-1");

	}
}
</script>
<script language="javascript">
function onShowDepartment(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+jQuery("input[name="+inputename+"]").val());
	if (data!=null){
	    if (data.id != ""){
			jQuery("#"+tdname).html(data.name);
			jQuery("input[name="+inputename+"]").val(data.id);
		}else{
			jQuery("#"+tdname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			jQuery("input[name="+inputename+"]").val("");
		}
	}
}

function onShowResource(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if (data!=null){
	    if (data.id != ""){
			jQuery("#"+tdname).html(data.name);
			jQuery("input[name="+inputename+"]").val(data.id);
		}else{
			jQuery("#"+tdname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			jQuery("input[name="+inputename+"]").val("");
		}
	}
}

function onShowRole(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp");
	if (data!=null){
	    if (data.id != ""){
			jQuery("#"+tdname).html(data.name);
			jQuery("input[name="+inputename+"]").val(data.id);
		}else{
			jQuery("#"+tdname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			jQuery("input[name="+inputename+"]").val("");
		}
	}
}

 function onSubmit()
{
	weaver.submit();
}

 function back()
{
	window.history.back(-1);
}
</script>
</BODY>
</HTML>
