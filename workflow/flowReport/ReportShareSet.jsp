<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
if(!HrmUserVarify.checkUserRight("REPORTSHARE:WORKFLOW", user))  {
        response.sendRedirect("/notice/noright.jsp") ;
	    return ;
    }
String imagefilename = "/images/hdCRMAccount.gif";
String titlename = SystemEnv.getHtmlLabelName(19024,user.getLanguage())+
"-"+SystemEnv.getHtmlLabelName(19025,user.getLanguage()) ;
int needchange=0;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=weaver name=weaver action="ReportShareOperation.jsp" method=post onsubmit='return check_form(this,"")'>
<input type="hidden" name="method" value="add">
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
	  <TABLE class="viewform">
        <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
        <TBODY>
    
          	<TR>
            <Td>
            <%=SystemEnv.getHtmlLabelName(19026,user.getLanguage())%>
            </Td><TD class=field >
             <select class=inputstyle  name=reportType >
                  <option value="0"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				  <option value="-1"><%=SystemEnv.getHtmlLabelName(19027,user.getLanguage())%></option>
				  <option value="-2"><%=SystemEnv.getHtmlLabelName(19028,user.getLanguage())%></option>
				  <option value="-3" ><%=SystemEnv.getHtmlLabelName(19029,user.getLanguage())%></option>
				  <option value="-4"><%=SystemEnv.getHtmlLabelName(19030,user.getLanguage())%></option>
				  <option value="-5"><%=SystemEnv.getHtmlLabelName(19031,user.getLanguage())%></option>
				   <option value="-6"><%=SystemEnv.getHtmlLabelName(19032,user.getLanguage())%></option>
				  <option value="-7"><%=SystemEnv.getHtmlLabelName(19034,user.getLanguage())%></option>
				  <option value="-8" ><%=SystemEnv.getHtmlLabelName(19035,user.getLanguage())%></option>
				  <option value="-9"><%=SystemEnv.getHtmlLabelName(19036,user.getLanguage())%></option>
				  <option value="-10"><%=SystemEnv.getHtmlLabelName(19037,user.getLanguage())%></option>
				  <option value="-11"><%=SystemEnv.getHtmlLabelName(21899,user.getLanguage())%></option>
				 
 			  </SELECT>
            </td>
          </TR>
         	<TR style="height:1px;">
            <Td colSpan=2 class="Line1"></Td>
          </TR>
        <TR>
          <TD class=field>
			  <select class=inputstyle  name=sharetype onchange="onChangeSharetype()" >
				  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
				  <!-- option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>/option -->
				  <option value="3" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
				  <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
				  <option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
 			  </SELECT>
		  </TD>
          <TD class=field >
			<button type=button  class=Browser style="display:none" onClick="onShowResource('showrelatedsharename','relatedshareid')" name=showresource></BUTTON> 
			<button type=button  class=Browser style="display:none" onClick="onShowSubcompany('showrelatedsharename','relatedshareid')" name=showsubcompany></BUTTON> 
			<button type=button  class=Browser style="display:''" onClick="onShowDepartment('showrelatedsharename','relatedshareid')" name=showdepartment></BUTTON> 
			<button type=button  class=Browser style="display:none" onclick="onShowRole('showrelatedsharename','relatedshareid')" name=showrole></BUTTON>
			 <INPUT type=hidden name=relatedshareid value="">
			 <span id=showrelatedsharename name=showrelatedsharename><IMG src='/images/BacoError.gif' align=absMiddle></span>
			<span id=showrolelevel name=showrolelevel style="visibility:hidden">
			&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
			<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:
			<select class=inputstyle  name=rolelevel  >
			  <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
			  <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
			</SELECT>
			</span>
			&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
			<span id=showseclevel name=showseclevel>
			<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:
			<INPUT type=text class="InputStyle" name=seclevel size=6 value="10" onchange='checkinput("seclevel","seclevelimage")' >
			</span>
			<SPAN id=seclevelimage></SPAN>
		  </TD>		
		</TR> 
		<TR  style="height:1px;">
            <Td colSpan=2 class="Line1"></Td>
          </TR>
          <TD>
			<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
		  </TD>
          <TD class=field>
			<select class=inputstyle  name=sharelevel onchange="onChangeShareLevel()">
			  <option value="0" selected><%=SystemEnv.getHtmlLabelName(18511,user.getLanguage())%></option>
			  <option value="1"><%=SystemEnv.getHtmlLabelName(18512,user.getLanguage())%></option>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
              <option value="3"><%=SystemEnv.getHtmlLabelName(18513,user.getLanguage())%></option>
              <option value="9"><%=SystemEnv.getHtmlLabelName(17006,user.getLanguage())%></option>
			</SELECT>
            &nbsp;&nbsp;
            <button type=button  class=Browser style="display:none" onClick="onShowMutiDepartment('departmentidspan','departmentids')" name=departmentnames></BUTTON>
            <INPUT type=hidden name=departmentids value="">
			<span id=departmentidspan name=departmentidspan style="visibility:hidden"><IMG src='/images/BacoError.gif' align=absMiddle></span>
          </TD>
		</TR>
<TR  style="height:1px;">
            <Td colSpan=2 class="Line1"></Td>
          </TR>
		</TBODY>
	  </TABLE>
	</form>  
<!--原有共享-->
        <table class=liststyle cellspacing=1>
          <colgroup> 
          <col width="25%"> 
          <col width="10%"> 
          <col width="50%">
          <col width="15%">
          <tr class="Title"> 
            <th colspan=4><%=SystemEnv.getHtmlLabelName(19024,user.getLanguage())%></th>
          <tr class="Spacing" style="height:1px;"> 
            <td class="Line1" colspan=4></td>
          </tr>
<%
	//查找已经添加的共享
	String newName="";
	String oldName="";
	RecordSet.execute("select * from WorkflowReportShare where reportid in (-1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-11) order by reportid desc,sharetype asc");
	while(RecordSet.next()){
	  
		String tempsharelevel = "" ;
		newName=RecordSet.getString("reportid");
		if(RecordSet.getInt("sharelevel")==0) tempsharelevel = SystemEnv.getHtmlLabelName(18511,user.getLanguage()) ;
		if(RecordSet.getInt("sharelevel")==1) tempsharelevel = SystemEnv.getHtmlLabelName(18512,user.getLanguage()) ;
		if(RecordSet.getInt("sharelevel")==2) tempsharelevel = SystemEnv.getHtmlLabelName(140,user.getLanguage()) ;
    //add by xhheng @20050126 for TD 1614
    if(RecordSet.getInt("sharelevel")==3) tempsharelevel = SystemEnv.getHtmlLabelName(18513,user.getLanguage()) ;
        if(RecordSet.getInt("sharelevel")==9){
            String deptnames="";
            ArrayList tempdepts=Util.TokenizerString(RecordSet.getString("mutidepartmentid"),",");
            for(int i=0;i<tempdepts.size();i++){
                int deptidtemp=Util.getIntValue((String)tempdepts.get(i));
                if(deptidtemp>0)
                deptnames+=DepartmentComInfo.getDepartmentname(""+deptidtemp)+",";
            }
            if(deptnames.length()>0){
                deptnames=deptnames.substring(0,deptnames.length()-1);
            }
            tempsharelevel = SystemEnv.getHtmlLabelName(17006,user.getLanguage())+"("+deptnames+")";
        }
	          if(needchange ==0){
       				needchange = 1;
				%>
				  <TR class=datalight>
				  <%
				  	}else{
				  		needchange=0;
				  %><TR class=datadark>
				  <%}%>
	          <td><%
	          if (oldName.equals("")||(!oldName.equals(newName)))
	          {
	          switch (RecordSet.getInt("reportid"))
	          {
	          case -1:
	          out.print(SystemEnv.getHtmlLabelName(19027,user.getLanguage()));
	          break;
	          case -2:
	          out.print(SystemEnv.getHtmlLabelName(19028,user.getLanguage()));
	          break;
	          case -3:
	          out.print(SystemEnv.getHtmlLabelName(19029,user.getLanguage()));
	          break;
	          case -4:
	          out.print(SystemEnv.getHtmlLabelName(19030,user.getLanguage()));
	          break;
	          case -5:
	          out.print(SystemEnv.getHtmlLabelName(19031,user.getLanguage()));
	          break;
	          case -6:
	          out.print(SystemEnv.getHtmlLabelName(19032,user.getLanguage()));
	          break;
	          case -7:
	          out.print(SystemEnv.getHtmlLabelName(19034,user.getLanguage()));
	          break;
	          case -8:
	          out.print(SystemEnv.getHtmlLabelName(19035,user.getLanguage()));
	          break;
	          case -9:
	          out.print(SystemEnv.getHtmlLabelName(19036,user.getLanguage()));
	          break;
	          case -10:
	          out.print(SystemEnv.getHtmlLabelName(19037,user.getLanguage()));
	          break;
	          case -11:
	          out.print(SystemEnv.getHtmlLabelName(21899,user.getLanguage()));
	          break;
	          }
	          }
	          %></td>
	          <%
              if(RecordSet.getInt("sharetype")==1){%>
	          <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
			  <TD >
				<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("userid")%>" target="_blank"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("userid")),user.getLanguage())%></a>/<%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>:<%=tempsharelevel%>
			  </TD>
			  <%}else if(RecordSet.getInt("sharetype")==2){%>
			  <TD<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>/TD>
			  <TD >
				<a href="/hrm/company/HrmSubCompanyDsp.jsp?id=<%=RecordSet.getString("subcompanyid")%>" target="_blank"><%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(RecordSet.getString("subcompanyid")),user.getLanguage())%></a>/<%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>:<%=tempsharelevel%>
			  </TD>
			  <%}else if(RecordSet.getInt("sharetype")==3)	{%>
			   <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
			  <TD >
				<a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=RecordSet.getString("departmentid")%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("departmentid")),user.getLanguage())%></a>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>:<%=tempsharelevel%>
			  </TD>
			  <%}else if(RecordSet.getInt("sharetype")==4)	{%>
			  <TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
			  <TD >
			  	  <%
			  	  	RecordSet1.executeSql("select rolesmark from hrmroles where id = "+RecordSet.getString("roleid"));
			  		RecordSet1.next();
			  	  %>
				<%=Util.toScreen(RecordSet1.getString(1),user.getLanguage())%>/<% if(RecordSet.getInt("rolelevel")==0)%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
				<% if(RecordSet.getInt("rolelevel")==1)%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
				<% if(RecordSet.getInt("rolelevel")==2)%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>:<%=tempsharelevel%>
			  </TD>
			  <%}else if(RecordSet.getInt("sharetype")==5)	{%>
			  <TD><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></TD>
			  <TD >
				<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>:<%=tempsharelevel%>
			  </TD>
			  <%}%>
			  <TD class=Field align=right>
				<a href="ReportShareOperation.jsp?method=delete&id=<%=RecordSet.getString("id")%>&reportid=<%=RecordSet.getInt("reportid")%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
			  </TD>
	        </TR>  <tr class="Spacing" style="height:1px;"> 
            <td class="Line" colspan=4></td>
          </tr>   
	    <%
	     oldName=RecordSet.getString("reportid");
	    }%>
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

<script language=javascript>
function doSave(obj) {
thisvalue=document.weaver.sharetype.value;
levelsvalue=$G("sharelevel").value;
var checkstr="";
if (thisvalue==1 || thisvalue==2 || thisvalue==3 || thisvalue==4){
        if(levelsvalue==9){
           checkstr="relatedshareid,departmentids";
        }else{
            checkstr="relatedshareid";
        }
}

if(check_form(document.weaver,checkstr)){
document.weaver.submit();
obj.disabled=true;
}
}
</script>

<script language=javascript>
  function onChangeSharetype(){
	thisvalue=$G("sharetype").value;
	$G("relatedshareid").value="";
	$G("showseclevel").style.display='';

	$G("showrelatedsharename").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"

	if(thisvalue==1){
		$G("showresource").style.display='';
		$G("showseclevel").style.display='none';
		//TD33012 当安全级别为空时，选择人力资源，赋予安全级别默认值10，否则无法提交保存
		seclevelimage.innerHTML = ""
		if($G("seclevel").value==""){
			$G("seclevel").value=10;
		}
		//End TD33012
	}
	else{
		$G("showresource").style.display='none';
	}
	if(thisvalue==2){
 		$G("showsubcompany").style.display='';
 		$G("seclevel").value=10;
	}
	else{
		$G("showsubcompany").style.display='none';
		$G("seclevel").value=10;
	}
	if(thisvalue==3){
 		$G("showdepartment").style.display='';
 		$G("seclevel").value=10;
	}
	else{
		$G("showdepartment").style.display='none';
		$G("seclevel").value=10;
	}
	if(thisvalue==4){
 		$G("showrole").style.display='';
		$G("showrolelevel").style.visibility='visible';
		$G("seclevel").value=10;
	}
	else{
		$G("showrole").style.display='none';
		$G("showrolelevel").style.visibility='hidden';
		$G("seclevel").value=10;
    }
	if(thisvalue==5){
		$G("showrelatedsharename").innerHTML = ""
		$G("relatedshareid").value=-1;
		$G("seclevel").value=10;
	}
	if(thisvalue<0){
		$G("showrelatedsharename").innerHTML = ""
		$G("relatedshareid").value=-1;
		$G("seclevel").value=0;
	}
}
function onChangeShareLevel(){
	thisvalue=$G("sharelevel").value;
	$G("departmentids").value="";
	$G("departmentidspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";

	if(thisvalue==9){
 		$G("departmentnames").style.display='';
        $G("departmentidspan").style.visibility='visible';
    }
	else{
		$G("departmentnames").style.display='none';
        $G("departmentidspan").style.visibility='hidden';
    }
}
</script>


<script type="text/javascript">

function disModalDialog(url, spanobj, inputobj, need, curl) {
	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id != null) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		
		if (rid != "") {
			if (rid.indexOf(",") == 0) {
				rid = rid.substr(1);
				rname = rname.substr(1);
			}
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ rid + "'>"
						+ rname + "</a>";
			} else {
				spanobj.innerHTML = rname;
			}
			inputobj.value = rid;
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}


</script>

<script type="text/javascript">


function onShowDepartment(tdname,inputename) {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=" + $G(inputename).value;
	disModalDialog(url, $G(tdname), $G(inputename), true);
}

function onShowMutiDepartment(tdname,inputename) {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser1.jsp?selectedids=" + $G(inputename).value + "&selectedDepartmentIds=" + $G(inputename).value
	disModalDialog(url, $G(tdname), $G(inputename), true);
}

function onShowSubcompany(tdname,inputename) {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" + $G(inputename).value;
	disModalDialog(url, $G(tdname), $G(inputename), true);
}
function onShowResource(tdname,inputename) {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	disModalDialog(url, $G(tdname), $G(inputename), true);
}


function onShowRole(tdname,inputename) {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp";
	disModalDialog(url, $G(tdname), $G(inputename), true);
}

</script>


<SCRIPT language="javascript">
/*
sub onShowDepartment(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&$G(inputename).value)
	if NOT isempty(id) then
	        if id(0)<> "0" then
		$G(tdname).innerHtml = id(1)
		$G(inputename).value=id(0)
		else
		$G(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		$G(inputename).value=""
		end if
	end if
end sub

sub onShowMutiDepartment(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser1.jsp?selectedids="&$G(inputename).value&"&selectedDepartmentIds="+$G(inputename).value)
	if NOT isempty(id) then
	    if id(0)<> "" then
		$G(tdname).innerHtml = Mid(id(1),2,len(id(1)))
		$G(inputename).value=Mid(id(0),2,len(id(0)))
		else
		$G(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		$G(inputename).value=""
		end if
	end if
end sub



sub onShowSubcompany(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="&$G(inputename).value)
	if NOT isempty(id) then
	        if id(0)<> "" then
		$G(tdname).innerHtml = id(1)
		$G(inputename).value=id(0)
		else
		$G(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		$G(inputename).value=""
		end if
	end if
end sub





sub onShowResource(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		$G(tdname).innerHtml = id(1)
		$G(inputename).value=id(0)
		else
		$G(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		$G(inputename).value=""
		end if
	end if
end sub





sub onShowRole(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		$G(tdname).innerHtml = id(1)
		$G(inputename).value=id(0)
		else
		$G(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		$G(inputename).value=""
		end if
	end if
end sub
*/
</SCRIPT>
<script language="javascript">
function submitData()
{
	if (check_form(weaver,'PrjName,PrjType,WorkType,hrmids02,SecuLevel,PrjManager,PrjDept'))
		weaver.submit();
}
</script>
</BODY>
</HTML>
