<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuInfo" %>

<%

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(17594,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17597,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17607,user.getLanguage());
String needfav ="1";
String needhelp ="";    

int userid=0;
userid=user.getUID();

int id = Util.getIntValue(request.getParameter("id"));
int systemId = Util.getIntValue(request.getParameter("systemId"));


MainMenuHandler mainMenuHandler = new MainMenuHandler();
MainMenuInfo info = mainMenuHandler.getMenuInfo(id);

int labelId = info.getLabelId();
boolean useCustomName = info.isUseCustomName();
String customName = Util.null2String(info.getCustomName());

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
  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_self} " ;
  RCMenuHeight += RCMenuHeightStep ;

  RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",MainMenuConfig.jsp?id="+systemId+",_self} " ;
  RCMenuHeight += RCMenuHeightStep ;
  %>
  
  <%@ include file="/systeminfo/RightClickMenu.jsp" %>

	<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="CustomMainMenuNameOperation.jsp" onsubmit='return doCheck_form()'>
		<input type=hidden name=id value=<%=id%>>
<input type=hidden name=systemId value=<%=systemId%>>
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
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(17608,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing>
				  <TD class=Line1 colSpan=2></TD>
				</TR>
                
                <tr>
				  <td><%=SystemEnv.getHtmlLabelName(17609,user.getLanguage())%></td>
				  <td class=Field>
					
					<%=SystemEnv.getHtmlLabelName(labelId,user.getLanguage())%>
					
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

