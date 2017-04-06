<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<%
boolean canedit=false;

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int subcompanyid=-1;
int subid=Util.getIntValue(request.getParameter("subCompanyId"));
if(subid<0){
        subid=user.getUserSubCompany1();
}
ArrayList subcompanylist=SubCompanyComInfo.getRightSubCompany(user.getUID(),"MeetingType:Maintenance");
int operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"MeetingType:Maintenance",subid);
if(detachable==1){
	if(subid!=0 && operatelevel<1){
		canedit=false;
	}else{
		canedit=true;
	}
}else{
	if(HrmUserVarify.checkUserRight("MeetingType:Maintenance",user)) {
	canedit=true;
}
}
String name="";
String approver="";
String desc="";
String category = "";
String categorypath = "";
String id=Util.null2String(request.getParameter("id"));

if(!id.equals("")){
	RecordSet.executeProc("Meeting_Type_SelectByID",id);
	if(RecordSet.next()){
	 name=Util.null2String(RecordSet.getString("name"));
	 approver=Util.null2String(RecordSet.getString("approver"));
	 desc=Util.null2String(RecordSet.getString("desc_n"));
     subcompanyid=Util.getIntValue(RecordSet.getString("subcompanyid"));
     category = Util.null2String(RecordSet.getString("catalogpath"));
     if(!category.equals("")){
         String[] categoryArr = Util.TokenizerString2(category,",");
         categorypath += "/"+MainCategoryComInfo.getMainCategoryname(categoryArr[0]);
         categorypath += "/"+SubCategoryComInfo.getSubCategoryname(categoryArr[1]);
         categorypath += "/"+SecCategoryComInfo.getSecCategoryname(categoryArr[2]);
     }
    }
}
if(subcompanyid<0){
   subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
   if(subcompanyid<0){subcompanyid=user.getUserSubCompany1();}
}

//标示当前操作页面是修改页面还是添加页面
String isupdate=request.getParameter("isupdate");
if (isupdate == null || isupdate.length() < 0){
		isupdate = "no";
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
<SCRIPT language="javascript" src="../../js/jquery/jquery.js"></script>
</HEAD>


<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(2104,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%



if(canedit){
    if(id.equals("")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:submitData(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">

<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<%if(canedit){%>
<FORM id=weaverA name=weaverA action="MeetingTypeOperation.jsp" method=post  >
<%if(id.equals("")){%>
	<input class=inputstyle type="hidden" name="method" value="add">
<%}else{%>
	<input class=inputstyle type="hidden" name="method" value="edit">
	<input class=inputstyle type="hidden" name="id" value="<%=id%>">
<%}%>
<TABLE class=Viewform>
  <COLGROUP>
  <COL width="15%">
  <COL width=85%>
  <TBODY>
  <TR class=Spacing>
          <TD class=Sep1 colSpan=4></TD></TR>

          <TD><%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%></TD>
          <TD class=Field>
              <input id=roomtypename name=name class=inputstyle style="width=80%" value="<%=Util.forHtml(name)%>" onblur="onblurCheckName()" onchange='checkinput("name","nameimage")'><SPAN id=nameimage><%if(name.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></SPAN><SPAN id=checknameinfo style='color:red'>&nbsp;</SPAN>
		  </TD>
        </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
        <%if(detachable==1){%>
        <tr>
            <td ><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></td>
            <td class=field >
                    <button type=button  class=Browser id=SelectSubCompany onclick="adfonShowSubcompany()"></BUTTON>
                <SPAN id=subcompanyspan name=subcompanyspan><%=SubCompanyComInfo.getSubCompanyname(""+subcompanyid)%>
                    <%if(subcompanyid<1){%>
                        <IMG src="/images/BacoError.gif" align=absMiddle>
                    <%}%>
                </SPAN>
            </td>
        </tr>
        <tr  style="height:1px;" class="Spacing"><td colspan=2 class="Line"></td></tr>
        <%}%>
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15057,user.getLanguage())%></TD>
          <TD class=Field>

			  <button type=button  class=browser onclick="onShowWorkflow()"></button>

              <span id=approvewfspan><%=WorkflowComInfo.getWorkflowname(approver)%></span>
              <input type=hidden name="approver" value="<%=approver%>">
              <INPUT class=inputstyle id=subcompanyid type=hidden name=subcompanyid value="<%=subcompanyid%>">
              <INPUT class=inputstyle id=subid type=hidden name=subid value="<%=subid%>">
          </TD>
        </TR>
       <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
       <tr>
	            <td><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(92,user.getLanguage())%></td>
	            <td class=field>
	                <button type=button  class=Browser onClick="onShowCatalog('catalogpathspan')" name=selectCategory></BUTTON>
	                <span id="catalogpathspan" name="catalogpathspan"><%=categorypath %></span>
	                <input type=hidden id='catalogpath' name='catalogpath' value="<%=category %>">
	            </td>
	        </tr>
          <TR style="height:1px;"><TD class=Line colspan=2></TD></TR> 
  </TBODY>
</TABLE>
</FORM>
<FORM id=weaverD  action="MeetingTypeOperation.jsp" method=post>
<input class=inputstyle type="hidden" name="method" value="delete">
<INPUT class=inputstyle id=subid type=hidden name=subid value="<%=subid%>">
<TABLE class=form>
  <COLGROUP>
  <COL width="20%">
  <COL width=80%>
  <TBODY>
  <TR class=separator>
          <TD class=Sep1 colSpan=2></TD></TR>
           <TR>
          <TD colSpan=2><button class=btnDelete accessKey=D type=submit  onclick="return isdel()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON></TD>
        </TR>
  </TBODY>
</TABLE>
<%}%>
	  <TABLE class=ListStyle cellspacing=1 >
        <TBODY>
	    <TR class=Header>
			<th width=10>&nbsp;</th>
			<th><%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%></th>
			<th><%=SystemEnv.getHtmlLabelName(15057,user.getLanguage())%></th>
            <%if(detachable==1){%><th><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></th><%}%>
            <th><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(92,user.getLanguage())%></th>
            <th><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></th>
	    </TR>
<TR class=Line><TD colspan="5" ></TD></TR>

<%

if(detachable==1){
    String subcompanys=SubCompanyComInfo.getRightSubCompanyStr1(""+subid,subcompanylist);
    if(subcompanys.length()>0){
        RecordSet.executeSql("select * from meeting_type where subcompanyid in("+subcompanys+")");
    }else{
        RecordSet.executeSql("select * from meeting_type where 1=2");
    }
}else{
    RecordSet.executeProc("Meeting_Type_SelectAll","");
}
boolean isLight = false;
while(RecordSet.next())
{
	category = Util.null2String(RecordSet.getString("catalogpath"));
    categorypath = "";
    if(!category.equals("")){
        String[] categoryArr = Util.TokenizerString2(category,",");
        categorypath += "/"+MainCategoryComInfo.getMainCategoryname(categoryArr[0]);
        categorypath += "/"+SubCategoryComInfo.getSubCategoryname(categoryArr[1]);
        categorypath += "/"+SecCategoryComInfo.getSecCategoryname(categoryArr[2]);
    }
		if(isLight)
		{%>
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>

			<th width=10><%if(canedit){%><input class=inputstyle type=checkbox name=MeetingTypeIDs value="<%=RecordSet.getString("id")%>"><%}%></th>
			<td><a href="MeetingType_left.jsp?id=<%=RecordSet.getString("id")%>&isupdate=yes&subCompanyId=<%=subid%>"><%=Util.forHtml(RecordSet.getString("name"))%></a></td>
			<td><%=WorkflowComInfo.getWorkflowname(RecordSet.getString("approver"))%></td>
            <%if(detachable==1){%><td><%=SubCompanyComInfo.getSubCompanyname(RecordSet.getString("subcompanyid"))%></td><%}%>
            <td><%=categorypath %></td>
            <td>
<!--				<a href="MeetingAddress.jsp?meetingtype=<%=RecordSet.getString("id")%>"><%=SystemEnv.getHtmlLabelName(2105,user.getLanguage())%></a>
-->
				<a href="MeetingMember.jsp?meetingtype=<%=RecordSet.getString("id")%>&subCompanyId=<%=subid%>"><%=SystemEnv.getHtmlLabelName(2106,user.getLanguage())%></a>
				<a href="MeetingService.jsp?meetingtype=<%=RecordSet.getString("id")%>&subCompanyId=<%=subid%>"><%=SystemEnv.getHtmlLabelName(2107,user.getLanguage())%></a>
				<a href="MeetingCaller.jsp?meetingtype=<%=RecordSet.getString("id")%>&subCompanyId=<%=subid%>"><%=SystemEnv.getHtmlLabelName(2152,user.getLanguage())%></a>
			</td>
    </tr>
<%
	isLight = !isLight;
}%>
</TBODY>
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
	
function submitData() {
		var typename = $("#roomtypename").val();
		
		var isupdate = '<%=isupdate%>';
		var detachable = '<%=detachable%>';
		if (isupdate == "no"){
				 $.post("/meeting/Maint/MeetingTypeCheck.jsp",{typename:encodeURIComponent($("#roomtypename").val())},function(datas){ 	
						 
						 $("#checknameinfo").hide();
						 
						 if(datas.indexOf("unfind") > 0){
						 		if(detachable==1){
						 				if(check_form(weaverA,'name,subcompanyid')){
											weaverA.submit();
										}
						 		}else{
									if(check_form(weaverA,"name")){
											weaverA.submit();
										}
						 		}
						 } else if (datas.indexOf("exist") > 0){				 	  
						 	  alert("<%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%> [ "+typename+" ] <%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>");
						 }
				});
		} else if (isupdate == "yes"){			
				$.post("/meeting/Maint/MeetingTypeCheck.jsp",{typename:encodeURIComponent($("#roomtypename").val()),id:'<%=id%>'},function(datas){ 	
						   
						 $("#checknameinfo").hide();
						 if(datas.indexOf("unfind") > 0){
								if(detachable==1){
						 				if(check_form(weaverA,'name,subcompanyid')){
											weaverA.submit();
										}
						 		}else{
									if(check_form(weaverA,"name")){
											weaverA.submit();
										}
						 		}
						 } else if (datas.indexOf("exist") > 0){				 	  
						 	  alert("<%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%> [ "+typename+" ] <%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>");
						 }
				});
			
	  } else if (check_form(weaverA,"name")){
				weaverA.submit();
		}
}

function onblurCheckName() {
		var typename = $("#roomtypename").val();				
		var isupdate = '<%=isupdate%>';
		var name = '<%=name%>';
		if (isupdate == "no"){
				$.post("/meeting/Maint/MeetingTypeCheck.jsp",{typename:encodeURIComponent($("#roomtypename").val())},function(datas){ 	
						 //alert(datas+"==");   
						 if (datas.indexOf("exist") > 0){
						 	  $("#checknameinfo").show();						 	
						 	  $("#checknameinfo").text(" <%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%> [ "+typename+" ] <%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>");
						 } else { 
						 		$("#checknameinfo").hide();
						 }
				});
		} else if (isupdate == "yes"){			
				$.post("/meeting/Maint/MeetingTypeCheck.jsp",{typename:encodeURIComponent($("#roomtypename").val()),id:'<%=id%>'},function(datas){ 	
						 if (datas.indexOf("exist") > 0){				 	  
						 	  $("#checknameinfo").show();						 	
						 	  $("#checknameinfo").text(" <%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%> [ "+typename+" ] <%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>");
						 }
				});				
	  }
}

function onShowCatalog(spanName) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
    if (result != null) {
        if (wuiUtil.getJsonValueByIndex(result, 0) > 0){
          $GetEle(spanName).innerHTML=wuiUtil.getJsonValueByIndex(result, 2);
          $GetEle("catalogpath").value=wuiUtil.getJsonValueByIndex(result, 3)+","+wuiUtil.getJsonValueByIndex(result, 4)+","+wuiUtil.getJsonValueByIndex(result, 1);
        }else{
          $G(spanName).innerHTML="";
          $GetEle("catalogpath").value="";
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



function onShowHrm(spanname,inputename,needinput) {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			, $GetEle(spanname)
			, $GetEle(inputename)
			, needinput == "1" ? true : false
			, "/hrm/resource/HrmResource.jsp?id=");
}

function adfonShowSubcompany() {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser4.jsp?rightStr=MeetingType:Maintenance"
			, $GetEle("subcompanyspan")
			, $GetEle("subcompanyid")
			, true);
}

function onShowWorkflow() {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere= where isbill=1 and formid=85"
			, $GetEle("approvewfspan")
			, $GetEle("approver")
			, false);
}

</script>

<%
 String noDelMeetTypes =  (String)session.getAttribute("noDelMeetTypes");
 if (noDelMeetTypes != null && noDelMeetTypes!="") {
 %>
    <script language="javaScript">
        alert('会议类型 <%=noDelMeetTypes%> 被使用过,不能被删除');
    </script>
<%
     session.setAttribute("noDelMeetTypes","");
    }%>
