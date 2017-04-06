<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<html>
<% if(!HrmUserVarify.checkUserRight("HrmResourceAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String id = request.getParameter("resourceid");
String changedate = Util.null2String(request.getParameter("changedate"));
String changereason = Util.null2String(request.getParameter("changereason"));
String ischangesalary = Util.null2String(request.getParameter("ischangesalary"));
String infoman = Util.null2String(request.getParameter("infoman"));
String newjoblevel = Util.null2String(request.getParameter("newjoblevel"));
String newjobtitle = Util.null2String(request.getParameter("newjobtitle"));
String managerid = Util.null2String(request.getParameter("managerid"));

String sql = "select joblevel from HrmResource where id = "+id;
rs.executeSql(sql);
rs.next();
String joblevel = rs.getString(1);;

int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

boolean hasFF = true;
rs.executeProc("Base_FreeField_Select","hr");
if(rs.getCounts()<=0)
	hasFF = false;
else
	rs.first();
	
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(6090,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(179,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
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
<FORM name=resource id=resource action="HrmResourceStatusOperation.jsp" method=post>
<input class=inputstyle type=hidden name=operation value="redeploy">
     <TABLE class=ViewForm>
      <TBODY>
      <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=30%> <COL width=70%> <TBODY> 
          <TR class=Title> 
            <TH colSpan=2 height="19"><%=SystemEnv.getHtmlLabelName(15729,user.getLanguage())%></TH>
          </TR>
          <TR class=Spacing style="height:2px"> 
            <TD class=Line1 colSpan=2></TD>
          </TR>   
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(16001,user.getLanguage())%></TD>
            <TD class=Field>
				<BUTTON class=Browser type="button" onclick="onShowResourceID(resourceid,assistantidspan)"></BUTTON> 
              <SPAN id=assistantidspan>
                <%=ResourceComInfo.getResourcename(id)%>
                <%if(ResourceComInfo.getResourcename(id).equals("")){%>
                 <IMG src="/images/BacoError.gif" align=absMiddle>
                <%}%>
              </SPAN>
              <input class=inputstyle type=hidden name=resourceid value="<%=id%>" onChange='checkinput("resourceid","assistantidspan")'>
            </TD>
          </TR>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(6111,user.getLanguage())%></TD>
            <TD class=Field><BUTTON class=Calendar type="button" id=selectcontractdate onclick="getchangedate()"></BUTTON> 
              <SPAN id=changedatespan >               
<%if(!changedate.equals("")){%>                <%=changedate%><%}else{%>
                <IMG src="/images/BacoError.gif" align=absMiddle>     <%}%>        
              </SPAN> 
              <input class=inputstyle type="hidden" name="changedate" value="<%=changedate%>" onChange='checkinput("changedate","changedatespan")'>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(6116,user.getLanguage())%></td>
            <td class=Field>
              <textarea class=inputstyle rows=5 cols=40 name="changereason" value="<%=changereason%>"><%=changereason%></textarea>
            </td>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>       
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(6112,user.getLanguage())%></TD>
            <TD class=Field>
<!--               <BUTTON class=Browser id=SelectJobTitle onclick="onShowOldJobtitle()"></BUTTON> 
              <SPAN id=oldjobtitlespan>              
               </A>-->            
               <%=JobTitlesComInfo.getJobTitlesname(ResourceComInfo.getJobTitle(id))%>  
                  <%
				  System.out.println("==================================================" + id + "-----------");
	System.out.println(JobTitlesComInfo.getJobTitlesname(ResourceComInfo.getJobTitle(id)));
	System.out.println("==================================================");%>          
<!--               <IMG src="/images/BacoError.gif" align=absMiddle>
              </SPAN> 
-->              
              <input class=inputstyle id=jobtitle type=hidden name=oldjobtitle value="<%=ResourceComInfo.getJobTitle(id)%>">
            </TD>
          </TR>
			<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>   
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(20481,user.getLanguage())%></TD>
            <TD class=Field>

              <INPUT class="wuiBrowser" id=departmentid type=hidden name=departmentid 
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
			  _required="yes">
            </TD>
          </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>   
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(16107,user.getLanguage())%></TD>
            <TD class=Field>
			<BUTTON class=Browser type="button" id=SelectJobTitle onclick="onShowJobtitle1()"></BUTTON> 
              <SPAN id=newjobtitlespan>
				<%if(newjobtitle.equals("")){%> <IMG src="/images/BacoError.gif" align=absMiddle>
				<%}else{%> <%=JobTitlesComInfo.getJobTitlesname(newjobtitle)%> <%}%>
              </SPAN> 
              <input class=inputstyle id=jobtitle type=hidden name=newjobtitle value="<%=newjobtitle%>"onChange='checkinput("newjobtitle","newjobtitlespan")'>
            </TD>
          </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>   
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(6114,user.getLanguage())%></td>
            <td class=Field>
              <%=joblevel%>                 
              <input class=inputstyle type=hidden  name="oldjoblevel" value="<%=joblevel%>">
            </td>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(6115,user.getLanguage())%></td>
            <td class=Field>
              <input class=inputstyle type=text maxlength=3 size=3 name="newjoblevel" value="<%=newjoblevel%>" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("newjoblevel")'>
            </td>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(24129,user.getLanguage())%></td>
            <td class=Field>

<%
 sql = "select lastname from HrmResource where id = "+Util.getIntValue(managerid,-1);
rs2.executeSql(sql);
while(rs2.next()){
%>
    <%=rs2.getString("lastname")%>

<%}%>

              <INPUT class="wuiBrowser" id=managerid type=hidden name=managerid value="<%=managerid%>"
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			  _displayTemplate="<A target='_blank' href='HrmResource.jsp?id=#b{id}'>#b{name}</A>">
            </td>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(6157,user.getLanguage())%></td>
            <td class=field>
              <input class=inputstyle type=checkbox name="ischangesalary" value="1" <%if(ischangesalary.equals("1")){%>checked<%}%>>
            </td>
          </tr>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(16108,user.getLanguage())%></td>
            <td class=Field>
              <BUTTON class=Browser type="button" onClick="onShowResource(infoman,infomanspan)">
	      </BUTTON> 
	      <span id=infomanspan>
	        <%=ResourceComInfo.getMulResourcename(infoman)%>
	      </span> 
	      <INPUT class=inputstyle id=organizer type=hidden name=infoman value="<%=infoman%>">
            </td>
          </TR>
       <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
      </tbody>
    </table>
  </FORM>
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
<SCRIPT LANGUAGE="JavaScript">
function disModalDialogRtnM(url, inputname, spanname) {
	var id = window.showModalDialog(url);
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			var ids = wuiUtil.getJsonValueByIndex(id, 0).substr(1);
			var names = wuiUtil.getJsonValueByIndex(id, 1).substr(1);

			jQuery(inputname).val(ids);
			var sHtml = "";
			var ridArray = ids.split(",");
			var rNameArray = names.split(",");

			linkurl = ""

			for ( var i = 0; i < ridArray.length; i++) {

				var curid = ridArray[i];
				var curname = rNameArray[i];

				sHtml += "<a tatrget='_blank' href=/hrm/resource/HrmResource.jsp?id=" + curid + ">" + curname + "</a>&nbsp;";
			}

			jQuery(spanname).html(sHtml);
		} else {
			jQuery(inputname).val("")
			jQuery(spanname).html("");
		}
	}
}

function onShowResource(inputname,spanname){
	disModalDialogRtnM("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp",inputname,spanname);
}

function onShowResourceID(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/browser/redeploy/ResourceBrowser.jsp");
	if (data!=null){
	if (data.id!=""){
	jQuery("#assistantidspan").html("<A href='HrmResource.jsp?id="+data.id+"'>"+data.name+"</A>");
	jQuery("input[name=resourceid]").val(data.id);
	}else{
	jQuery("#assistantidspan").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
	jQuery("input[name=resourceid]").val("");
	}
	}
	document.forms[0].action="HrmResourceRedeploy.jsp";
	document.forms[0].submit();
}

function onShowJobtitle1(){
  var deptid = jQuery("#departmentid").val();
  if (deptid != ""){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp?sqlwhere= where jobdepartmentid="+deptid);
	if (data!=null){
		if (data.id != 0){
			jQuery("#newjobtitlespan").html(data.name);
			jQuery("input[name=newjobtitle]").val(data.id);
		}else{
			jQuery("#newjobtitlespan").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			jQuery("input[name=newjobtitle]").val("");
		}
	}
  }else{
	window.alert("<%=SystemEnv.getHtmlLabelName(21014,user.getLanguage())%>");
  }
}
</SCRIPT>
<!--
<script language=vbs>


sub onShowOldJobtitle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	oldjobtitlespan.innerHtml = id(1)
	resource.oldjobtitle.value=id(0)
	else
	jobtitlespan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resource.oldjobtitle.value=""
	end if
	end if
end sub

sub onShowJobtitle1()
  if  (resource.departmentid.value <> "") then
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp?sqlwhere= where jobdepartmentid="&resource.departmentid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	newjobtitlespan.innerHtml = id(1)
	resource.newjobtitle.value=id(0)
	else
	newjobtitlespan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resource.newjobtitle.value=""
	end if
	end if
	else
	window.alert("<%=SystemEnv.getHtmlLabelName(21014,user.getLanguage())%>")
	end if
end sub

sub onShowNewJobtitle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	newjobtitlespan.innerHtml = id(1)
	resource.newjobtitle.value=id(0)
	else
	newjobtitlespan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resource.newjobtitle.value=""
	end if
	end if
end sub
sub onShowResource1(inputname,spanname)
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
			sHtml = sHtml&"<a href=javascript:openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id="&curid&"')>"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href=javascript:openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id="&resourceids&"')>"&resourcename&"</a>&nbsp"
		spanname.innerHtml = sHtml
	else
    	spanname.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
    	inputname.value="0"
	end if
	end if
end sub
sub onShowDepartment()

	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&resource.departmentid.value)
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = resource.departmentid.value then
		issame = true 
	end if
	departmentspan.innerHtml = id(1)
	resource.departmentid.value=id(0)
	else
	departmentspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	resource.departmentid.value=""
	end if
	end if
end sub
sub onShowManagerID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	manageridspan.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.managerid.value=id(0)
	else
	manageridspan.innerHtml = ""
	resource.managerid.value=""
	end if
	end if
end sub
</script>
-->
<script language=javascript>
function doSave(obj) {
   if(check_form(document.resource,"resourceid,changedate,newjobtitle,departmentid"))
	{
	   obj.disabled=true;
		document.resource.submit();
	}

}
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>

