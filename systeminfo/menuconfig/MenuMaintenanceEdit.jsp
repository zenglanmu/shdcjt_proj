<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.systeminfo.menuconfig.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
//if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)&&!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
//    response.sendRedirect("/notice/noright.jsp");
//    return;
//}


int infoId = Util.getIntValue(request.getParameter("id"));
int resourceId = Util.getIntValue(request.getParameter("resourceId"));
String resourceType = Util.null2String(request.getParameter("resourceType"));
int sync = Util.getIntValue(request.getParameter("sync"),0);
String edit = Util.null2String(request.getParameter("edit"));
String type = Util.null2String(request.getParameter("type"));

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(18986, user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(18772,user.getLanguage());
if(edit.equals("sub")){
	titlename = SystemEnv.getHtmlLabelName(18986, user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(18773,user.getLanguage());
}
String needfav ="1";
String needhelp ="";


int userid=0;
userid=user.getUID();

String linkAddress="",customName="",iconUrl="",topIconUrl="",customName_e="",customName_t="";
int menuLevel=0;
int viewIndex = 0;


MenuUtil mu=new MenuUtil(type,Util.getIntValue(resourceType),resourceId,user.getLanguage());
MenuMaint  mm=new MenuMaint(type,Util.getIntValue(resourceType),resourceId,user.getLanguage());



MenuConfigBean mcb = mm.getMenuConfigBeanByInfoId(infoId);
String targetFrame="";
if(mcb!=null){
	linkAddress = mcb.getMenuInfoBean().getLinkAddress();
	customName = mcb.getName();
	customName_e=mcb.getName_e();
	customName_t = mcb.getName_t();
	viewIndex = mcb.getViewIndex();
	iconUrl = mcb.getMenuInfoBean().getIconUrl();
	topIconUrl=mcb.getMenuInfoBean().getTopIconUrl();
	menuLevel=mcb.getMenuInfoBean().getMenuLevel();
	targetFrame= mcb.getMenuInfoBean().getTargetBase();
	if(mcb.getMenuInfoBean().getIsAdvance()==1)//高级模式菜单
		response.sendRedirect("MenuMaintenanceEditAdvanced.jsp?type="+type+"&id="+infoId+"&resourceId="+resourceId+"&resourceType="+resourceType+"&edit="+edit+"&sync="+sync);
	
}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<link href="/css/Weaver.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>

<body>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ; 

//RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteMenu(this),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(this),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="MenuMaintenanceOperation.jsp" enctype="multipart/form-data">
<input name="method" type="hidden" value="edit"/>
<input type="hidden" name="infoId" value="<%=infoId%>"/>
<input type="hidden" name="resourceId" value="<%=resourceId%>"/>
<input type="hidden" name="resourceType" value="<%=resourceType%>"/>
<input name="sync" type="hidden" value="<%=sync%>"/>
<input name="type" type="hidden" value="<%=type%>">
<%-- 图标 --%>
<INPUT name="customIconUrl" type="hidden" value="<%=iconUrl%>">
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
		

		
<!--================================================================================-->		
<TABLE class=ViewForm>
<COLGROUP>
<COL width="20%">
<COL width="80%">
<TBODY>
<TR class=Title>
	<TH><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
	<TH>
		<%if(!"3".equals(resourceType)){%><div  align="right"><%=SystemEnv.getHtmlLabelName(20827,user.getLanguage())%><input type="checkbox" value="1" id="chkSynch" name="chkSynch"> &nbsp;</div><%}%>
	</TH>

</TR>
<TR class=Spacing style="height: 1px"><TD class=Line1 colSpan=2></TD></TR>			 
<tr>
	<%if(edit.equals("sub")){%>
	<td><%=SystemEnv.getHtmlLabelName(18390,user.getLanguage())%></td>
	<%}else{%>
	<td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
	<%}%>
	<td class=Field>
		<INPUT class=InputStyle maxLength=50 style="" name="customMenuName" value="<%=customName%>" onchange="checkinput('customMenuName','Nameimage')">
		<SPAN id=Nameimage></SPAN>
	</td>
</tr>
<TR  style="height: 1px"><TD class=Line colSpan=2></TD></TR>

 <tr>
	  <td><%=SystemEnv.getHtmlLabelName(20593,user.getLanguage())%></td>
	  <td class=Field>
		<INPUT class=InputStyle  name="customName_e" value="<%=customName_e%>">				
	  </td>
	</tr>
	<TR  style="height: 1px"><TD class=Line colSpan=2></TD></TR>
<%if(GCONST.getZHTWLANGUAGE()==1){ %>
 <tr>
	  <td><%=SystemEnv.getHtmlLabelName(21864,user.getLanguage())%></td>
	  <td class=Field>
		<INPUT class=InputStyle  name="customName_t" value="<%=customName_t%>">				
	  </td>
 </tr>
 <TR  style="height: 1px"><TD class=Line colSpan=2></TD></TR>
<%} %>
<%if(edit.equals("sub")){%>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%></td>
	<td class=Field>
		<INPUT class=InputStyle  style="width:300px"  name="customMenuLink" value="<%=linkAddress%>" >
		<SPAN id=linkImage></SPAN>
	</td>
</tr>
<TR  style="height: 1px"><TD class=Line colSpan=2></TD></TR>
<tr>
				  <td><%=SystemEnv.getHtmlLabelName(20235,user.getLanguage())%></td>
				  <td class=Field>					

					<select  name="targetframe">
						<option value="" <%if("".equals(targetFrame)) out.println(" selected ");%>><%=SystemEnv.getHtmlLabelName(20597,user.getLanguage())%></option>
						<option value="_blank" <%if(!"".equals(targetFrame)) out.println(" selected ");%>><%=SystemEnv.getHtmlLabelName(18717,user.getLanguage())%></option>
					</select>	
					
				  </td>
				</tr>
<TR  style="height: 1px"><TD class=Line colSpan=2></TD></TR>
<%}%>


<tr>
  <td><%=SystemEnv.getHtmlLabelName(19063,user.getLanguage())%></td>
  <td class=Field>	 
	 <input type="file" name="customIconUrl" onchange="onIcoChange(this)" value="">&nbsp;(16*16)&nbsp;<span id=spanShow><img src="<%=iconUrl%>"></span>	
  </td>
</tr>
<TR  style="height: 1px"><TD class=Line colSpan=2></TD></TR>
<%if(menuLevel==1){%>
<tr>
  <td><%=SystemEnv.getHtmlLabelName(20611,user.getLanguage())+SystemEnv.getHtmlLabelName(22969,user.getLanguage())%></td>
  <td class=Field>				  
	<input type="file" name="topIconUrl" value="">&nbsp;(32*32)&nbsp;<span id=topspanShow><%if(!"".equals(topIconUrl)){%><img src="<%=topIconUrl%>"><%}%></span>
  </td>
</tr>
<TR  style="height: 1px"><TD class=Line colSpan=2></TD></TR>
<%} %>
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
		3.<%=SystemEnv.getHtmlLabelName(20601,user.getLanguage())%>&nbsp;<img src="<%=iconUrl%>">
	  </td>
	</tr>
	<tr>				  
	  <td class=Field>				  
		4.<%=SystemEnv.getHtmlLabelName(20602,user.getLanguage())%><br>"/images_face/ecologyFace_2/LeftMenuIcon/"
	  </td>
	</tr>

</TBODY>
</TABLE>
<!--================================================================================-->	

	
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
function deleteMenu(obj){
	if(confirm("<%=SystemEnv.getHtmlLabelName(17048,user.getLanguage())%>?")){
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		location.href = "LeftMenuMaintenanceOperation.jsp?type=<%=type%>&method=del&infoId=<%=infoId%>&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&sync=<%=sync%>";
		obj.disabled=true;
	}
}

function checkSubmit(obj){
	if(check_form(frmMain,'customMenuName')){
		frmMain.submit();
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		obj.disabled=true;
	}
}

function doCheck_form(obj){
	if(check_form(frmMain,'customMenuName,customIconUrl')){
		frmMain.submit();
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		obj.disabled=true;
	}
}

function onBack(obj){
	location.href="MenuMaintenanceList.jsp?type=<%=type%>&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&sync=<%=sync%>";
	obj.disabled=true;
}

function onIcoChange(obj){
	if(this.vlaue!='') spanShow.innerHTML="<img src='"+obj.value+"'>"
}


</script>




</html>

