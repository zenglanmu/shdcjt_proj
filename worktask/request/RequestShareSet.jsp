<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%

int needchange=0;
int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
//返回按钮，返回到查看页面
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290, user.getLanguage())+",javaScript:OnComeBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=weaver name=weaver action="RequestShareOperation.jsp" method=post >
<input type="hidden" name="method" value="add">
<input type="hidden" name="types" value="1">
<input type="hidden" name="wtid" value="<%=wtid%>" >
<input type="hidden" name="requestid" value="<%=requestid%>" >
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
            <Td><%=SystemEnv.getHtmlLabelName(21947, user.getLanguage())%></Td>
			<TD class=field >
			<select class=inputstyle  name="taskstatus" >
                  <option value="-1"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				  <option value="1"><%=SystemEnv.getHtmlLabelName(21948, user.getLanguage())%></option>
				  <option value="2"><%=SystemEnv.getHtmlLabelName(21949, user.getLanguage())%></option>
 			  </SELECT>
            </td>
          </TR>
         	<TR style="height: 1px;">
            <Td colSpan=2 class="Line1"></Td>
          </TR>
		<tr>
		<TD >
			 <%=SystemEnv.getHtmlLabelName(19117,user.getLanguage())%>  
		  </TD>
          <TD class=field >
			<select class=inputstyle  name=sharetype onchange="onChangeSharetype()" >
				<option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
				<option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
				<option value="3" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
				<option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
				<option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
				<option value="6"><%=SystemEnv.getHtmlLabelName(18583,user.getLanguage())%></option>
				<option value="7"><%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%></option>
				<option value="8"><%=SystemEnv.getHtmlLabelName(18584,user.getLanguage())%></option>
			</SELECT>
			<BUTTON  type="button" class=Browser style="display:none" onClick="onShowBrowser('showrelatedsharename','relatedshareid',1)" name=showresource></BUTTON> 
			<BUTTON  type="button" class=Browser style="display:none" onClick="onShowBrowser('showrelatedsharename','relatedshareid',2)" name=showsubcompany></BUTTON> 
			<BUTTON  type="button" class=Browser                      onClick="onShowBrowser('showrelatedsharename','relatedshareid',3)" name=showdepartment></BUTTON> 
			<BUTTON  type="button" class=Browser style="display:none" onclick="onShowBrowser('showrelatedsharename','relatedshareid',4)" name=showrole></BUTTON>
			 <INPUT type=hidden name=relatedshareid id="relatedshareid" value="">
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
		<TR style="height: 1px;">
            <Td colSpan=2 class="Line1"></Td>
          </TR>
          <TD>
			 <%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>
		  </TD>
          <TD class=field>
			<select class=inputstyle  name=sharelevel>
			  <option value="0" selected><%=SystemEnv.getHtmlLabelName(367, user.getLanguage())%></option>
			  <option value="1"><%=SystemEnv.getHtmlLabelName(21950, user.getLanguage())%></option>
			</SELECT> 
          </TD>
		</TR>
<TR style="height: 1px;">
            <Td colSpan=2 class="Line1"></Td>
          </TR>
		</TBODY>
	  </TABLE>
	</form>  
<!--原有共享--><br>
        <table class=liststyle cellspacing=1>
          <colgroup> 
          <col width="15%"> 
          <col width="40%">
		  <col width="10%">
          <col width="25%">
		  <col width="10%">
          <tr class="Title"> 
            <th colspan=7><%=SystemEnv.getHtmlLabelName(1279,user.getLanguage())%></th>
          <tr class="Spacing" style="height: 1px;"> 
            <td class="Line1" colspan="5" style="padding: 0px;"></td>
          </tr>
		  <tr class=Header> 
            <td><%=SystemEnv.getHtmlLabelName(21947,user.getLanguage())%></td>
			<td><%=SystemEnv.getHtmlLabelName(19117,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%></td>
			<td ></td>
          </tr>
		  <TR style="height: 1px;">
            <Td colSpan="5" class="Line1" style="padding: 0px;"></Td>
          </TR>
<%
	//查找已经添加的共享
	String newName="";
	String oldName="";
	RecordSet.execute("select s.* from requestshareset s  where s.requestid="+requestid+" and s.taskid="+wtid+" order by s.id desc");
	boolean isLight = false;
	while(RecordSet.next()){
		String taskstatus = Util.null2String(RecordSet.getString("taskstatus"));
		String taskstatuscn = "";
		if("1".equals(taskstatus)){
			taskstatuscn = SystemEnv.getHtmlLabelName(21948,user.getLanguage());
		}else if("2".equals(taskstatus)){
			taskstatuscn = SystemEnv.getHtmlLabelName(21949, user.getLanguage());
		}else{
			taskstatuscn = SystemEnv.getHtmlLabelName(332, user.getLanguage());
		}
		if(isLight = !isLight){
			out.println("<TR CLASS=\"DataLight\">");
		}else{
			out.println("<TR CLASS=\"DataDark\">");
		}
	%>
	<td><%=taskstatuscn%></td>
	<td><%
	int sharetype=RecordSet.getInt("sharetype");
	switch(sharetype){
		case 1:			//人员
			String suerid = RecordSet.getString("objid");
			if(!suerid.equals("")){
				String hrmName = hrmName = "<a href=/hrm/resource/HrmResource.jsp?id="+suerid+">"+ResourceComInfo.getResourcename(suerid)+"</a>";
				out.print(hrmName);
			}
			break;
		case 2:			//分部
			String checkBranchId = RecordSet.getString("objid");
			if(!checkBranchId.equals("")){
				String branchName = "<a href=/hrm/company/HrmSubCompanyDsp.jsp?id="+checkBranchId+">"+SubCompanyComInfo.getSubCompanyname(checkBranchId)+"</a>";
				out.print(branchName);
			}
			break;
		case 3:			//部门
			String checkDeptId = RecordSet.getString("objid");
			if(!checkDeptId.equals("")){
				String deptName = "<a href=/hrm/company/HrmDepartmentDsp.jsp?id="+checkDeptId+">"+DepartmentComInfo.getDepartmentname(checkDeptId)+"</a>";
				out.print(deptName);
			}
			break;
		case 4:			//角色
			String SROLEID=RecordSet.getString("objid");
			int SROLELEVEL=RecordSet.getInt("rolelevel");
			String SROLELEVELName = "";
			if (SROLELEVEL==0){
				SROLELEVELName=SystemEnv.getHtmlLabelName(124,user.getLanguage());
			}else if (SROLELEVEL==1){
				SROLELEVELName=SystemEnv.getHtmlLabelName(141,user.getLanguage());
			}else if (SROLELEVEL==2){
				SROLELEVELName=SystemEnv.getHtmlLabelName(140,user.getLanguage());
			}
			out.print(RolesComInfo.getRolesname(SROLEID)+"/"+SROLELEVELName);
			break;
		case 5:			//所有人
			out.print(SystemEnv.getHtmlLabelName(1340,user.getLanguage()));
			break;
		case 6:			//直接上级
			out.print(SystemEnv.getHtmlLabelName(18583,user.getLanguage()));
			break;
		case 7:			//本部门
			out.print(SystemEnv.getHtmlLabelName(15081,user.getLanguage()));
			break;
		case 8:			//本分部
			out.print(SystemEnv.getHtmlLabelName(18584,user.getLanguage()));
			break;
	}
	%></td>
	<td><%if(sharetype!=1){%><%=RecordSet.getString("seclevel")%><%}%></td>
	<td><% 
		int SHARELEVEL = RecordSet.getInt("sharelevel");
        String SHARELEVELNAME="";
		if(SHARELEVEL==0){
			SHARELEVELNAME=SystemEnv.getHtmlLabelName(367,user.getLanguage());
		}else if(SHARELEVEL==1){
			SHARELEVELNAME=SystemEnv.getHtmlLabelName(21950,user.getLanguage());
		}
        out.print(SHARELEVELNAME);
     %></td>
	<td><A href="#" onclick="delplan(<%=Util.null2o(RecordSet.getString("id"))%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> </td>
	</tr>
<%}
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

<script language=javascript>
function delplan(id){
	if(isdel()){
		location.href="RequestShareOperation.jsp?requestid=<%=requestid%>&wtid=<%=wtid%>&types=0&method=delete&id="+id;
	}
}

function doSave(obj){
	thisvalue=document.weaver.sharetype.value;
	var checkstr="";
	if (thisvalue==1 || thisvalue==2 || thisvalue==3 || thisvalue==4){
		checkstr="relatedshareid";
	}
	if(check_form(document.weaver, checkstr)){
		document.weaver.submit();
		obj.disabled=true;
	}
}
</script>

<script language=javascript>
function onChangeSharetype(){
	thisvalue=document.weaver.sharetype.value;
	document.weaver.relatedshareid.value="";
	$G("showseclevel").style.display='';

	showrelatedsharename.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"

	if(thisvalue==1){
		$G("showresource").style.display='';
		$G("showseclevel").style.display='none';
	}
	else{
		$G("showresource").style.display='none';
	}
	if(thisvalue==2){
 		$G("showsubcompany").style.display='';
 		document.weaver.seclevel.value=10;
	}
	else{
		$G("showsubcompany").style.display='none';
		document.weaver.seclevel.value=10;
	}
	if(thisvalue==3){
 		$G("showdepartment").style.display='';
 		document.weaver.seclevel.value=10;
	}
	else{
		$G("showdepartment").style.display='none';
		document.weaver.seclevel.value=10;
	}
	if(thisvalue==4){
 		$G("showrole").style.display='';
		$G("showrolelevel").style.visibility='visible';
		document.weaver.seclevel.value=10;
	}
	else{
		$G("showrole").style.display='none';
		$G("showrolelevel").style.visibility='hidden';
		document.weaver.seclevel.value=10;
    }
	if(thisvalue==5){
		showrelatedsharename.innerHTML = "";
		document.weaver.relatedshareid.value=-1;
		document.weaver.seclevel.value=10;
	}
	if(thisvalue>=6){
		showrelatedsharename.innerHTML = "";
		document.weaver.seclevel.value=0;
	}
	if(thisvalue<0){
		showrelatedsharename.innerHTML = ""
		document.weaver.relatedshareid.value=-1;
		document.weaver.seclevel.value=0;
	}
}

function onChangeShareLevel(){
	thisvalue = document.weaver.sharelevel.value;
	document.weaver.departmentids.value = "";
	departmentidspan.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	if(thisvalue==9){
 		$G("departmentnames").style.display='';
        $G("departmentidspan").style.visibility='visible';
    }else{
		$G("departmentnames").style.display='none';
        $G("departmentidspan").style.visibility='hidden';
    }
}
</script>

<SCRIPT language=VBS>
sub onShowSubcompany(tdname,inputename)
    linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id="
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="&inputename.value)
    if NOT isempty(id) then
        if id(0)<> "" then        
        resourceids = id(0)
        resourcename = id(1)
        sHtml = ""
        resourceids = Mid(resourceids,2,len(resourceids))
        resourcename = Mid(resourcename,2,len(resourcename))
        inputename.value = resourceids
        while InStr(resourceids,",") <> 0
            curid = Mid(resourceids,1,InStr(resourceids,",")-1)
            curname = Mid(resourcename,1,InStr(resourcename,",")-1)
            resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
            resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
            sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
        wend
        sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
        tdname.innerHtml = sHtml

        else
        tdname.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
        inputename.value=""
        end if
    end if
end sub

sub onShowDepartment(spanname,inputname)
    linkurl="/hrm/company/HrmDepartmentDsp.jsp?id="
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="&inputname.value)
    if (Not IsEmpty(id)) then
    if id(0)<> "" then
        resourceids = id(0)
        resourcename = id(1)
        sHtml = ""
        resourceids = Mid(resourceids,2,len(resourceids))
        resourcename = Mid(resourcename,2,len(resourcename))
        inputname.value= resourceids
        while InStr(resourceids,",") <> 0
            curid = Mid(resourceids,1,InStr(resourceids,",")-1)
            curname = Mid(resourcename,1,InStr(resourcename,",")-1)
            resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
            resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
            sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
        wend
        sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
        spanname.innerHtml = sHtml
    else    
          spanname.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
         inputname.value=""
    end if
    end if
end sub

sub onShowResource(spanname,inputname)
    linkurl="/hrm/resource/HrmResource.jsp?id="
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
    if (Not IsEmpty(id)) then
    if id(0)<> "" then
        resourceids = id(0)
        resourcename = id(1)
        sHtml = ""
        resourceids = Mid(resourceids,2,len(resourceids))
        resourcename = Mid(resourcename,2,len(resourcename))
        inputname.value= resourceids
        while InStr(resourceids,",") <> 0
            curid = Mid(resourceids,1,InStr(resourceids,",")-1)
            curname = Mid(resourcename,1,InStr(resourcename,",")-1)
            resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
            resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
            sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
        wend
        sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
         spanname.innerHtml = sHtml
    else    
         spanname.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
         inputname.value=""
    end if
    end if
end sub

sub onShowRole(tdname,inputename)
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
    if NOT isempty(id) then
        if id(0)<> "" then
        tdname.innerHtml = id(1)
        inputename.value=id(0)
        else
        tdname.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
        inputename.value=""
        end if
    end if
end sub

</SCRIPT>
<script language="javascript">

function openFullWindowHaveBarTmp(url){
	var redirectUrl = url ;
	var width = screen.width ;
	var height = screen.height ;
	var szFeatures = "top=100," ; 
	szFeatures +="left=400," ;
	szFeatures +="width="+width/2+"," ;
	szFeatures +="height="+height/2+"," ; 
	szFeatures +="directories=no," ;
	szFeatures +="status=yes," ;
	szFeatures +="menubar=no," ;
	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ; //channelmode
	if(typeof(window.dialogArguments) == "object"){
		openobj =  window.dialogArguments;
		openobj.open(redirectUrl,"",szFeatures);
	}else{
		window.open(redirectUrl,"",szFeatures);
	}
}
function OnComeBack(){
	location.href="/worktask/request/ViewWorktask.jsp?requestid=<%=requestid%>";
}

function onShowBrowser(spanname,inputname,browserType){
    var linkurl="";
    var dialogurl="";
    var selectedids=jQuery("#"+inputname).val();
    if(browserType==1){         //人力资源
       linkurl="/hrm/resource/HrmResource.jsp?id=";
       dialogurl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp";
    }else if(browserType==2){   //分部
       linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id=";
       dialogurl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp";
    }else if(browserType==3){   //部门
       linkurl="/hrm/company/HrmDepartmentDsp.jsp?id=";
       dialogurl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp";
    }else if(browserType==4){   //角色
       linkurl="";
       dialogurl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp";
    }   
    var results = window.showModalDialog(dialogurl+"?selectedids="+selectedids);
    if(results){
       if(results.id!=""){
          var id ="";
          var name = "";
          if(dialogurl=="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
          {
           	 id=results.id;
             name=results.name;
          }else{
             id=results.id.substr(1);
             name=results.name.substr(1);
          }
          
          var ids=id.split(",");
          var names=name.split(",");
          
          var sHtml="";
          for(var i=0;i<ids.length;i++){
              if(ids[i]!="")
                 sHtml=sHtml+"<a href="+linkurl+ids[i]+" target='blank'>"+names[i]+"</a>&nbsp";
          }
          jQuery("#"+inputname).val(id);
          jQuery("#"+spanname).html(sHtml);
       }else{
          jQuery("#"+inputname).val("");
          jQuery("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
       }
    }
}

</script>
</BODY>
</HTML>
