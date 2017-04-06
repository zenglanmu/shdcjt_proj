<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%@ page import="weaver.systeminfo.menuconfig.SystemModuleHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.SystemModuleInfo" %>
<%
if(Util.getIntValue(user.getSeclevel(),0)<20){
 	response.sendRedirect("ManageSystemModule.jsp");
    return;
}

String moduleId = "";
String moduleName=""; 
String moduleReleased=""; 

SystemModuleHandler systemModuleHandler = new SystemModuleHandler();

moduleId = Util.null2String(request.getParameter("id"));

SystemModuleInfo info = systemModuleHandler.getInfo(Util.getIntValue(moduleId));

moduleName = info.getName();
moduleReleased = info.isReleased()?"1":"0";

%>

<html>
<head>
<LINK href="/css/BacoSystem.css" type=text/css rel=STYLESHEET>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<BODY>
<DIV class=HdrTitle>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD align=left width=55><IMG height=24 src="/images/hdDOC.gif"></TD>
    <TD align=left><SPAN id=BacoTitle class=titlename>添加: 系统模块</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>

  <FORM style="MARGIN-TOP: 0px" name=frmView method=post action="ManageSystemModuleOperation.jsp">

    <input type="hidden" name="moduleId" value=<%=moduleId%>>
   <input type="hidden" name="operation" value="editModule">

    <BUTTON class=btn id=btnSave accessKey=S name=btnSave onClick="editModule()"><U>S</U>-保存</BUTTON>
    <BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重新设置</BUTTON>
    <br>
    <TABLE class=Form>
          <COLGROUP> <COL width="20%"> <COL width="60%"><COL width="20%">
          <TR class=Section> 
            <TH colSpan=3>模块信息</TH>
          </TR>
          <TR class=Separator> 
            <TD class=sep1 colSpan=3></TD>
          </TR>
          <TR> 
            <TD>模块名称</TD>
            <TD Class=Field colSpan=1>
			<INPUT  maxlength=60 size=30 class=FieldLong name="moduleName" value="<%=moduleName%>" onChange='checkinput("moduleName","moduleNameImage")'>
            <span id=moduleNameImage><img src="/images/BacoError.gif" align=absMiddle></span></TD>
          </TR>
          <TR class=Separator> 
            <TD class=sep1 colSpan=3></TD>
          </TR>
          <TR> 
            <TD colspan=1>是否发布</TD>
            <TD Class=Field colspan=1> 
			<INPUT type="checkbox" name=moduleReleased value="1" <% if(moduleReleased.equals("1")) {%>checked<%}%>></TD>
          </TR>
          <TR class=Separator> 
            <TD class=sep1 colSpan=3></TD>
          </TR>
    </TABLE>

    <br>
  </FORM>

<script language="javascript">

function editModule(){
    frmView.operation.value = "editModule";
    if (check_form(frmView,'moduleName')){
        document.frmView.submit();
    }
}
</script>

</BODY>
</HTML>
