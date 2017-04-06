<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ page import="weaver.general.GCONST" %>
<%
//if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)&&!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
//    response.sendRedirect("/notice/noright.jsp");
//    return;
//}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(18986, user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(18773,user.getLanguage());
String needfav ="1";
String needhelp ="";    

int resourceId = Util.getIntValue(request.getParameter("resourceId"));
String resourceType = Util.null2String(request.getParameter("resourceType"));
String type = Util.null2String(request.getParameter("type"));
String menuflag = Util.null2String(request.getParameter("menuflag"));//表单建模新增菜单地址
String menuaddress = Util.null2String((String)session.getAttribute(user.getUID()+"_"+menuflag+"_menuaddress"));//表单建模新增菜单地址
boolean displayAdvanced = true;
if(menuaddress.equals("")){
	displayAdvanced = false;
	menuaddress = "http://www.weaver.com.cn";
}
//out.println("menuaddress:"+menuaddress);

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
  
  <body  width="100%">
  
  <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
  
  <%
  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(this,event),_self} " ;
  RCMenuHeight += RCMenuHeightStep ;

  if("left".equals(type)&&displayAdvanced){
 	 RCMenu += "{"+SystemEnv.getHtmlLabelName(19048,user.getLanguage())+",javascript:onAdvanced(this),_self} " ;
  	 RCMenuHeight += RCMenuHeightStep ;
  }

  %>
  
  <%@ include file="/systeminfo/RightClickMenu.jsp" %>

	<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="/formmode/menu/MenuMaintenanceOperation.jsp" enctype="multipart/form-data">
	<input name="method" type="hidden" value="add"/>
	<input name="resourceId" type="hidden" value="<%=resourceId%>">
	<input name="resourceType" type="hidden" value="<%=resourceType%>">
	<input name="parentId" type="hidden" value="<%=infoId%>"/>
	<input name="type" type="hidden" value="<%=type%>">
	<input name="menuflag" type="hidden" value="<%=menuflag%>">
	<%-- 图标 --%>
	<INPUT name="customIconUrl" type="hidden" value="<% if(infoId != 0) {%>/images_face/ecologyFace_2/LeftMenuIcon/level3.gif<%} else {%>/images/folder.png<%}%>">
	
<table width=100% height=305px border="0" cellspacing="0" cellpadding="0">
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
		

				
    <TABLE width="100%" class="viewform">
		<COLGROUP>
		<COL width="25%">
		<COL width="75%">
		
		<TBODY>
		
                <TR class=Title>
				  <TH><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
				   <TH><%if(!"3".equals(resourceType)){%><div  align="right"><%=SystemEnv.getHtmlLabelName(20827,user.getLanguage())%><input type="checkbox" value="1" id="chkSynch" name="chkSynch"> &nbsp;</div><%}%></TH>
				</TR>
				<TR class=Spacing style="height: 1px">
				  <TD class=Line1 colSpan=2></TD>
				</TR>
                
                <tr>
				  <td><%=SystemEnv.getHtmlLabelName(18390,user.getLanguage())%></td>
				  <td class=Field>
				  	<INPUT class=InputStyle maxLength=50 name="customMenuName" value="" onchange="checkinput('customMenuName','Nameimage')">
				  	<SPAN id=Nameimage><IMG src='/images/BacoError.gif' align=absMiddle></SPAN>
				  </td>
				</tr>
				<TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>


				 <tr>
				  <td><%=SystemEnv.getHtmlLabelName(20593,user.getLanguage())%></td>
				  <td class=Field>
				  	<INPUT class=InputStyle maxLength=50 name="customName_e" value="">				
				  </td>
				</tr>
				<TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
				<%if(GCONST.getZHTWLANGUAGE()==1){ %>
				 <tr>
				  <td><%=SystemEnv.getHtmlLabelName(21864,user.getLanguage())%></td>
				  <td class=Field>
				  	<INPUT class=InputStyle maxLength=50 name="customName_t" value="">				
				  </td>
				</tr>
				<TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
				<%} %>
				
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%></td>
				  <td class=Field>
					<INPUT class=InputStyle style="width:300px" name="customMenuLink" value="<%=menuaddress%>" title="<%=SystemEnv.getHtmlLabelName(18391,user.getLanguage())%>">
					<SPAN id=linkImage></SPAN>
				  </td>
				</tr>
				<TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
				
				 <tr>
				  <td><%=SystemEnv.getHtmlLabelName(20235,user.getLanguage())%></td>
				  <td class=Field>
					<select  name="targetframe">
						<option value="" selected><%=SystemEnv.getHtmlLabelName(20597,user.getLanguage())%></option>
						<option value="_blank"><%=SystemEnv.getHtmlLabelName(18717,user.getLanguage())%></option>
					</select>								
					
				  </td>
				</tr>
                <TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
				
				
				
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(20592,user.getLanguage())%></td>
				  <td class=Field>				  
					<input type="file" name="customIconUrl" onchange="onIcoChange(this)" value="">&nbsp;(16*16)&nbsp;<span id=spanShow></span>
				  </td>
				</tr>
                <TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
                <%if(infoId==0){%>
	                <tr>
					  <td><%=SystemEnv.getHtmlLabelName(20611,user.getLanguage())+SystemEnv.getHtmlLabelName(22969,user.getLanguage())%></td>
					  <td class=Field>				  
						<input type="file" name="topIconUrl" value="">&nbsp;(32*32)&nbsp;
					  </td>
					</tr>
					<TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
				<%}%>
				
                <TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td rowSpan=4 valign=top><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
				  <td class=Field>				  
					1.<%=SystemEnv.getHtmlLabelName(20599,user.getLanguage())%>&nbsp;"Http://"
				  </td>
				</tr>              
				<tr>				  
				  <td class=Field>				  
					2.<%=SystemEnv.getHtmlLabelName(20600,user.getLanguage())%>
				  </td>
				</tr>
				<tr>				  
				  <td class=Field>				  
					3.<%=SystemEnv.getHtmlLabelName(20601,user.getLanguage())%>&nbsp;<img src="/images_face/ecologyFace_2/LeftMenuIcon/level3.gif">
				  </td>
				</tr>
				<tr>				  
				  <td class=Field>				  
					4.<%=SystemEnv.getHtmlLabelName(20602,user.getLanguage())%><br>"/images_face/ecologyFace_2/LeftMenuIcon/"
				  </td>
				</tr>
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
function checkSubmit(obj,event){
	
	<% if(infoId == 0) { %>
	if(check_form(frmMain,'customMenuName')){
		obj.disabled=true;
		frmMain.submit();	 	
	}
	<% } else { %>
	if(check_form(frmMain,'customMenuName')){
		//window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		event = jQuery.event.fix(event);
		event.target.disabled = true;
		obj.disabled=true;
		frmMain.submit();

	}
	<% } %>
	
}

function onBack(obj){
	location.href="/formmode/menu/MenuMaintenanceList.jsp?type=<%=type%>&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>";
	obj.disabled=true;
}

function onAdvanced(obj){
	location.href="/formmode/menu/MenuMaintenanceAddAdvanced.jsp?type=<%=type%>&id=<%=infoId%>&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>";
	obj.disabled=true;
}


function onIcoChange(obj){
	if(this.vlaue!='') spanShow.innerHTML="<img src='"+obj.value+"'>"
}



</script>



</html>

