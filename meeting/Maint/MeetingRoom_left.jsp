<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
boolean canedit = false;
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int subcompanyid=-1;
int subid=Util.getIntValue(request.getParameter("subCompanyId"));
if(subid<0){
        subid=user.getUserSubCompany1();
}
ArrayList subcompanylist=SubCompanyComInfo.getRightSubCompany(user.getUID(),"MeetingRoomAdd:Add");
int operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"MeetingRoomAdd:Add",subid);
if(detachable==1){
	if(subid!=0 && operatelevel<1){
		canedit=false;
	}else{
		canedit=true;
	}
}else{
	if(HrmUserVarify.checkUserRight("MeetingRoomAdd:Add",user)) {
	canedit=true;
   }
}
String name="";
String approver="";
String desc="";
String hrmid="";
String id=Util.null2String(request.getParameter("id"));
if(!id.equals("")){
	RecordSet.executeProc("MeetingRoom_SelectById",id);
	if(RecordSet.next()){
	 name=Util.null2String(RecordSet.getString("name"));
	 desc=Util.null2String(RecordSet.getString("roomdesc"));
	 hrmid=Util.null2String(RecordSet.getString("hrmid"));
     subcompanyid=Util.getIntValue(RecordSet.getString("subcompanyid"));
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
<script type="text/javascript" src="/wui/common/jquery/plugin/jQuery.modalDialog.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(780,user.getLanguage());
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
RCMenuHeight += RCMenuHeightStep ;}else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
}
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

<%if(canedit){%>
<FORM id=weaverA name=weaverA action="MeetingRoomOperation.jsp" method=post  >
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
  <TR class=Sapcing>
          <TD class=Sep1 colSpan=4></TD></TR>
          <TD><%=SystemEnv.getHtmlLabelName(780,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field>
              <input class=inputstyle id=roomname name=name  style="width:60%" onblur="onblurCheckName()" onchange='checkinput("name","nameimage")' value="<%if(!name.equals("")){%><%=Util.forHtml(name)%><%}%>"><SPAN id=nameimage><%if(id.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></SPAN><SPAN id=checknameinfo style='color:red;'>&nbsp;</SPAN>
		  </TD>
        </TR>
     <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
     <%if(detachable==1){%>
        <tr>
            <td ><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></td>
            <td class=field >
                <BUTTON class=Browser type="button" id=SelectSubCompany onclick="adfonShowSubcompany()"></BUTTON>
                <SPAN id=subcompanyspan name=subcompanyspan><%=SubCompanyComInfo.getSubCompanyname(""+subcompanyid)%>
                    <%if(subcompanyid<1){%>
                        <IMG src="/images/BacoError.gif" align=absMiddle>
                    <%}%>
                </SPAN>
            </td>
        </tr>
        <tr class="Spacing" style="height:1px"><td colspan=2 class="Line"></td></tr>
        <%}%>
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2156,user.getLanguage())%></TD>
          <TD class=Field>
          <SPAN id=hrmidspan></SPAN>
              <input class=wuiBrowser _displayText="<%if(!hrmid.equals("")){%><%="<A href='/hrm/resource/HrmResource.jsp?id=" + hrmid + "'>" + ResourceComInfo.getResourcename(hrmid) + "</A>"%><%}%>" id=hrmid type=hidden name=hrmid value="<%if(!hrmid.equals("")){%><%=hrmid%><%}%>"
              _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
              _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?#b{id}'>#b{name}</A>">
		  </TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(780,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field>
              <input class=inputstyle name=desc  style="width:60%" value="<%if(!desc.equals("")){%><%=Util.forHtml(desc)%><%}%>">
              <INPUT class=inputstyle id=subcompanyid type=hidden name=subcompanyid value="<%=subcompanyid%>">
              <INPUT class=inputstyle id=subid type=hidden name=subid value="<%=subid%>">
          </TD>
        </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
  </TBODY>
</TABLE>
</FORM>

<FORM id=weaverD action="MeetingRoomOperation.jsp" method=post>
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
          <TD colSpan=2>
		  <BUTTON class=btnDelete accessKey=D type=submit onclick="return isdel()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>

		  </TD>
        </TR>
  </TBODY>
</TABLE>
<%}%>
	  <TABLE class=ListStyle cellspacing=1 >
        <TBODY>
	    <TR class=Header>
			<th width=10>&nbsp;</th>
			<th><%=SystemEnv.getHtmlLabelName(780,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
            <%if(detachable==1){%><th><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></th><%}%>
            <th><%=SystemEnv.getHtmlLabelName(2156,user.getLanguage())%></th>
		<th><%=SystemEnv.getHtmlLabelName(780,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></th>
	    </TR>
        <TR class=Line><TD colspan="4" style="padding:0px"></TD></TR>
<%
if(detachable==1){
    String subcompanys=SubCompanyComInfo.getRightSubCompanyStr1(""+subid,subcompanylist);
    if(subcompanys.length()>0){
        RecordSet.executeSql("select * from MeetingRoom where subcompanyid in("+subcompanys+") order by id");
    }else{
        RecordSet.executeSql("select * from MeetingRoom where 1=2");
    }
}else{
    RecordSet.executeProc("MeetingRoom_SelectAll","");
}
boolean isLight = false;
while(RecordSet.next())
{
		if(isLight)
		{%>
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>

			<th width=10><%if(canedit){%><input class=inputstyle type=checkbox name=MeetingRoomIDs value="<%=RecordSet.getString("id")%>"><%}%></th>
			<td><a href="MeetingRoom_left.jsp?id=<%=RecordSet.getString("id")%>&isupdate=yes&subCompanyId=<%=subid%>"><%=Util.forHtml(RecordSet.getString("name"))%></A></td>
            <%if(detachable==1){%><td><%=SubCompanyComInfo.getSubCompanyname(RecordSet.getString("subcompanyid"))%></td><%}%>
            <td><A href='/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("hrmid")%>'><%=ResourceComInfo.getResourcename(RecordSet.getString("hrmid"))%></a></td>
			<td><%=Util.forHtml(RecordSet.getString("roomdesc"))%></td>
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

$(document).ready(function(){
	//alert("hide");
	$("#checknameinfo").hide();	
});


function submitData() {
		var roomname = $("#roomname").val();		
		var isupdate = '<%=isupdate%>';
		if (isupdate == "no"){
				$.post("/meeting/Maint/MeetingRoomCheck.jsp",{roomname:encodeURIComponent($("#roomname").val())},function(datas){ 							 
						 $("#checknameinfo").hide();
						 if(datas.indexOf("unfind") > 0 && check_form(weaverA,"name")){
								weaverA.submit();
						 } else if (datas.indexOf("exist") > 0){				 	  
						 	  alert("<%=SystemEnv.getHtmlLabelName(780,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%> [ "+roomname+" ] <%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>");
						 }
				});
		} else if (isupdate == "yes"){
			
				$.post("/meeting/Maint/MeetingRoomCheck.jsp",{roomname:encodeURIComponent($("#roomname").val()),id:'<%=id%>'},function(datas){ 	
						 //alert(datas+"==");   
						 $("#checknameinfo").hide();
						 if(datas.indexOf("unfind") > 0 && check_form(weaverA,"name")){
								weaverA.submit();
						 } else if (datas.indexOf("exist") > 0){				 	  
						 	  alert("<%=SystemEnv.getHtmlLabelName(780,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%> [ "+roomname+" ] <%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>");
						 }
				});	
			
	  } else if (check_form(weaverA,"name")){
				weaverA.submit();
		}
}

function onblurCheckName() {
		var roomname = $("#roomname").val();		
		var isupdate = '<%=isupdate%>';
		var name = '<%=name%>';
		if (isupdate == "no"){
				$.post("/meeting/Maint/MeetingRoomCheck.jsp",{roomname:encodeURIComponent($("#roomname").val())},function(datas){ 							 
						 if (datas.indexOf("exist") > 0){
						 	  $("#checknameinfo").show();						 	
						 	  $("#checknameinfo").text(" <%=SystemEnv.getHtmlLabelName(780,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%> [ "+roomname+" ] <%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>");
						 } else { 
						 		$("#checknameinfo").hide();
						 }
				});
		} else if (isupdate == "yes"){			
				$.post("/meeting/Maint/MeetingRoomCheck.jsp",{roomname:encodeURIComponent($("#roomname").val()),id:'<%=id%>'},function(datas){ 	
						 if (datas.indexOf("exist") > 0){				 	  
						 	  $("#checknameinfo").show();						 	
						 	  $("#checknameinfo").text(" <%=SystemEnv.getHtmlLabelName(780,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%> [ "+roomname+" ] <%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>");
						 }
				});				
	  }
}

function adfonShowSubcompany(){
	results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser4.jsp?rightStr=MeetingRoomAdd:Add")
	if(results){
	   if(results.id!=""){
	      $G("subcompanyspan").innerHTML =results.name;
	      $G("subcompanyid").value=results.id;
	   }else{
	      $G("subcompanyspan").innerHTML= "<IMG src='/images/BacoError.gif' align=absMiddle>"
	      $G("subcompanyid").value="";
	   }
	}
}

</script>
<script language=vbs>
sub onShowHrmID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	hrmidspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	weaverA.hrmid.value=id(0)
	else
    hrmidspan.innerHtml = ""
	weaverA.hrmid.value=""
	end if
	end if
end sub

</script>
</body>
</html>

<%
 String noDelRooms =  (String)session.getAttribute("noDelRooms");
 if (noDelRooms != null && noDelRooms!="") {
 %>
    <script language="javaScript">
        alert("<%=noDelRooms%> <%=SystemEnv.getHtmlLabelName(18973,user.getLanguage())%>");
    </script>
<%
     session.setAttribute("noDelRooms","");
    }%>