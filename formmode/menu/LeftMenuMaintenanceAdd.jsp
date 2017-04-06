<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%
if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)&&!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(18986, user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(18773,user.getLanguage());
String needfav ="1";
String needhelp ="";    

int resourceId = Util.getIntValue(request.getParameter("resourceId"));
String resourceType = Util.null2String(request.getParameter("resourceType"));
int sync = Util.getIntValue(request.getParameter("sync"),0);

int infoId = Util.getIntValue(request.getParameter("id"),0);
int userid=0;
userid=user.getUID();
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <link href="/css/Weaver.css" type=text/css rel=stylesheet>
	<SCRIPT language="javascript" src="../../js/weaver.js"></script>
  </head>
  
  <body>
  <%@ include file="/systeminfo/TopTitle.jsp" %>
  <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
  
  <%
  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(this),_self} " ;
  RCMenuHeight += RCMenuHeightStep ;

  if(infoId != 0) {
  RCMenu += "{"+SystemEnv.getHtmlLabelName(19048,user.getLanguage())+",javascript:onAdvanced(this),_self} " ;
  RCMenuHeight += RCMenuHeightStep ;
  }

  RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(this),_self} " ;
  RCMenuHeight += RCMenuHeightStep ;
  %>
  
  <%@ include file="/systeminfo/RightClickMenu.jsp" %>

	<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="LeftMenuMaintenanceOperation.jsp">
	<input name="method" type="hidden" value="add"/>
	<input name="resourceId" type="hidden" value="<%=resourceId%>">
	<input name="resourceType" type="hidden" value="<%=resourceType%>">
	<input name="parentId" type="hidden" value="<%=infoId%>"/>
	<input name="sync" type="hidden" value="<%=sync%>"/>
	
	<%-- ͼ�� --%>
	<INPUT name="customIconUrl" type="hidden" value="<% if(infoId != 0) {%>/images_face/ecologyFace_2/LeftMenuIcon/level3.gif<%} else {%>/images/folder.png<%}%>">
	
	
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
		
		<TABLE class="Shadow">
			<tr>
				<td valign="top">
				
				
    <TABLE class=ViewForm>
		<COLGROUP>
		<COL width="20%">
		<COL width="80%">
		
		<TBODY>
		
                <TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing>
				  <TD class=Line1 colSpan=2></TD>
				</TR>
                
                <tr>
				  <td><%=SystemEnv.getHtmlLabelName(18390,user.getLanguage())%></td>
				  <td class=Field>
				  	<INPUT class=InputStyle maxLength=50 name="customMenuName" value="" onchange="checkinput('customMenuName','Nameimage')">
				  	<SPAN id=Nameimage><IMG src='/images/BacoError.gif' align=absMiddle></SPAN>
				  </td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR>

				<% if(infoId != 0) { %>
				
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%><br>(<%=SystemEnv.getHtmlLabelName(18391,user.getLanguage())%>)</td>
				  <td class=Field>
					<INPUT class=InputStyle maxLength=200 style="width:80%" name="customMenuLink" value="http://www.weaver.com.cn" onchange="checkinput('customMenuLink','linkImage')">
					<SPAN id=linkImage></SPAN>
				  </td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR>
				
				 <tr>
				  <td><%=SystemEnv.getHtmlLabelName(20235,user.getLanguage())%></td>
				  <td class=Field>
					
					<INPUT class=InputStyle maxLength=20  name="targetframe" value="">  <font color=red>(<%=SystemEnv.getHtmlLabelName(20236,user.getLanguage())%>)</font>
					
					
				  </td>
				</tr>
                <TR><TD class=Line colSpan=2></TD></TR>
				<% } %>
				
				<%--
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(19063,user.getLanguage())%></td>
				  <td class=Field>
					<INPUT class=InputStyle maxLength=200 style="width:80%" name="customIconUrl" value="<% if(infoId != 0) {%>/images_face/ecologyFace_2/LeftMenuIcon/level3.gif<%} else {%>/images/folder.png<%}%>"  onchange="checkinput('customIconUrl','iconUrlImage')">
					<SPAN id=iconUrlImage></SPAN><IMG src='/images/Undo.GIF' align=absMiddle onclick="document.frmMain.customIconUrl.value='<% if(infoId != 0) {%>/images_face/ecologyFace_2/LeftMenuIcon/level3.gif<%} else {%>/images/folder.png<%}%>';checkinput('customIconUrl','iconUrlImage');" style="cursor:hand">
				  </td>
				</tr>
                <TR><TD class=Line colSpan=2></TD></TR>
                --%>

				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%></td>
				  <td class=Field>
					<INPUT class=InputStyle maxLength=50  name="customMenuViewIndex" value="">
				  </td>
				</tr>
                <TR><TD class=Line colSpan=2></TD></TR>
		
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
    </FORM>


</body>

<script LANGUAGE="JavaScript">
function checkSubmit(obj){
	<% if(infoId == 0) { %>
	if(check_form(frmMain,'customMenuName,iconUrlImage')){
		frmMain.submit();
	}
	<% } else { %>
	if(check_form(frmMain,'customMenuName,customMenuLink,iconUrlImage')){
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		frmMain.submit();
	}
	<% } %>
	obj.disabled=true;
}

function onBack(obj){
	location.href="LeftMenuMaintenanceList.jsp?resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&sync=<%=sync%>";
	obj.disabled=true;
}

function onAdvanced(obj){
	location.href="LeftMenuMaintenanceAddAdvanced.jsp?id=<%=infoId%>&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&sync=<%=sync%>";
	obj.disabled=true;
}
</script>

</html>

