<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.systeminfo.menuconfig.*" %>

<%
int userid=0;
userid=user.getUID();

int id = Util.getIntValue(request.getParameter("id"));
int resourceId = Util.getIntValue(request.getParameter("resourceId"));
String resourceType = Util.null2String(request.getParameter("resourceType"));
String type = Util.null2String(request.getParameter("type"));
int sync = Util.getIntValue(request.getParameter("sync"),1);


MenuMaint  mm=new MenuMaint(type,Util.getIntValue(resourceType),resourceId,user.getLanguage());

String imagefilename = "/images/hdMaintenance.gif";
String titlename = "";
if(resourceType.equalsIgnoreCase("3"))
	titlename = SystemEnv.getHtmlLabelName(17594,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17596,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17607,user.getLanguage());
else {
	titlename += SystemEnv.getHtmlLabelName(18986, user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17607,user.getLanguage());
}
String needfav ="1";
String needhelp ="";    


MenuConfigBean mcb = mm.getMenuConfigBeanByInfoId(id);
MenuInfoBean info = mcb.getMenuInfoBean();

int labelId = info.getLabelId();
String infoCustomName = Util.null2String(info.getCustomName());
String isCustomMenu = Util.null2String(info.getIsCustom());

boolean useCustomName = mcb.isUseCustomName();
String customName = mcb.getCustomName();
String 	customName_e = mcb.getCustomName_e();
String 	customName_t = mcb.getCustomName_t();
String targetFrame=mcb.getMenuInfoBean().getTargetBase();
if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)){
	if("1".equals(resourceType)){
		response.sendRedirect("/notice/noright.jsp");
        return;
	}
}
if(!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
	if("2".equals(resourceType)){
		response.sendRedirect("/notice/noright.jsp");
        return;
	}
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
  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_self} " ;
  RCMenuHeight += RCMenuHeightStep ;
  %>
  
  <%@ include file="/systeminfo/RightClickMenu.jsp" %>

	<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="CustomMenuNameOperation.jsp" onsubmit='return doCheck_form()'>
		<input type=hidden name=id value=<%=id%>>
		<input type=hidden name=resourceId value=<%=resourceId%>>
		<input type=hidden name=resourceType value=<%=resourceType%>>
		<input type=hidden name=sync value=<%=sync%>>
		<input type=hidden name=type value=<%=type%>>

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
		
		
		
    				
				
    <TABLE class=ViewForm>
		<COLGROUP>
		<COL width="30%">
		<COL width="*">
		
		<TBODY>
		
                <TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(17608,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing>
				  <TD class=Line1 colSpan=2></TD>
				</TR>
                
                <tr>
				  <td><%=SystemEnv.getHtmlLabelName(17609,user.getLanguage())%></td>
				  <td class=Field>
					<%if(isCustomMenu.equals("2")){%>
					<%=infoCustomName%>
					<%}else if(isCustomMenu.equals("1")){%>
					<%=customName%>
					<%}else{%>
					<%=SystemEnv.getHtmlLabelName(labelId,user.getLanguage())%>
					<%}%>
				  </td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(20235,user.getLanguage())%></td>
				  <td class=Field>					
					<select  name="basetarget">
						<option value="" <%if("".equals(targetFrame)) out.println(" selected ");%>><%=SystemEnv.getHtmlLabelName(20597,user.getLanguage())%></option>
						<option value="_blank" <%if(!"".equals(targetFrame)) out.println(" selected ");%>><%=SystemEnv.getHtmlLabelName(18717,user.getLanguage())%></option>
					</select>							
				  </td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(17610,user.getLanguage())%></td>
				  <td class=Field>
					
					<INPUT class=InputStyle maxLength=50  name="customName"  onchange='doCheck_Input()' value="<%=customName%>">
					<SPAN id=Nameimage><%if(useCustomName&&customName.equals("")){%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></SPAN>
					
				  </td>
				</tr>

				<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(20768,user.getLanguage())%></td>
				  <td class=Field>					
					<INPUT class=InputStyle maxLength=50  name="customName_e"  value="<%=customName_e%>">									
				  </td>
				</tr>
				<%if(GCONST.getZHTWLANGUAGE()==1){ %>
				<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(21863,user.getLanguage())%></td>
				  <td class=Field>					
					<INPUT class=InputStyle maxLength=50  name="customName_t"  value="<%=customName_t%>">									
				  </td>
				</tr>
				<%} %>
				
				
				<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(17611,user.getLanguage())%></td>
				  <td class=Field>
                  <%if(useCustomName){%>
                    <input type="checkbox" name=useCustom  value="1" onclick='doCheck_Input()' checked>
                  <%}
                    else{%>
					<input type="checkbox" name=useCustom  value="1" onclick='doCheck_Input()'>
                  <%}%>
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

function checkSubmit(){

	if(frmMain.useCustom.checked){
		if(check_form(frmMain,'customName')){
			frmMain.submit();
		}
	}
	else{
		frmMain.submit();
	}
}

function doCheck_form(){
	if(frmMain.useCustom.checked){
		return check_form(frmMain,'customName');
	}
	else{
		return true;
	}
}

function doCheck_Input(){
	if(frmMain.useCustom.checked){
		checkinput("customName","Nameimage");
	}
	else{
		document.all("Nameimage").innerHTML='';
	}
}

</script>

</html>

