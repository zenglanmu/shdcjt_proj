<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.net.URLDecoder" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.systeminfo.menuconfig.SystemModuleHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.SystemModuleInfo" %>

<html>
<%
	String moduleId="";
	String moduleName="";

    moduleId = Util.null2String(request.getParameter("moduleId"));
	moduleName = Util.null2String(request.getParameter("moduleName"));

    String sqlWhere = "";
    if(!moduleId.equalsIgnoreCase("")){
        sqlWhere+=" where id =" + moduleId + " ";
    }
    if(!moduleName.equalsIgnoreCase("")){
        sqlWhere+=" where moduleName like '%" + moduleName + "%' ";
    }

    SystemModuleHandler systemModuleHandler = new SystemModuleHandler();
%>
<head>
<LINK href="/css/BacoSystem.css" type=text/css rel=STYLESHEET>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>

</head>
<BODY>
<DIV class=HdrTitle>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD align=left width=55><IMG height=24 src="/images/hdDOC.gif"></TD>
    <TD align=left><SPAN id=BacoTitle class=titlename>搜索: 系统模块</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>

  <FORM style="MARGIN-TOP: 0px" name=frmSearch method=post action="\systeminfo\menuconfig\Maint\ManageSystemModuleOperation.jsp">
    <BUTTON class=btn id=btnSearch accessKey=S name=btnSearch type=submit onclick="searchlabel()"><U>S</U>-搜索</BUTTON>
    <BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重新设置</BUTTON>
	<%if(Util.getIntValue(user.getSeclevel(),0)>=20){%>
    <BUTTON class=btn id=btnAdd accessKey=A name=btnAdd onclick="addModule()"><U>A</U>-添加系统模块</BUTTON>
    <BUTTON class=btn id=btnDelete accessKey=D name=btnDelete onclick="deleteModule()"><U>D</U>-删除</BUTTON>
	<%}%>

    <br>
        <TABLE class=Form>
          <COLGROUP> <COL width="5%"> <COL width="32%"> <COL width=1> <COL width="10%"> <COL width="32%"> <TBODY>
          <TR class=Section>
            <TH colSpan=5>搜索条件</TH>
          </TR>
          <TR class=Separator>
            <TD class=sep1 colSpan=5></TD>
          </TR>
		  <TR>
            <TD>系统模块ID</TD>
            <TD Class=Field colspan=4>
              <INPUT class=FieldxLong name=moduleId accessKey=Z value="<%=moduleId%>">
            </TD>
          </TR>
          <TR>
            <TD>系统模块名称</TD>
            <TD Class=Field colspan=4>
              <INPUT class=FieldxLong name=moduleName accessKey=Z value="<%=moduleName%>">
            </TD>
          </TR>
          </TBODY>
        </TABLE>
        <br>
        <TABLE class=ListShort>
          <COLGROUP> <COL width="10%"> <COL width="30%"> <COL width="30%"> <COL width="10%"> <COL width="20%"> <TBODY>
          <TR class=Section>
            <TH colSpan=5>搜索结果</TH>
          </TR>
          <TR class=Separator>
            <TD class=sep2 colSpan=5></TD>
          </TR>
          <TR class=Header>
            <Td >选择</Td>
            <Td >标识</Td>
            <Td >名称</Td>
            <Td >发布</Td>
            <Td >细节</Td>
          </TR>
          <%
          
          ArrayList systemModules = systemModuleHandler.getSystemModuleInfos(sqlWhere);
          for(int i = 0;i<systemModules.size();i++){
              SystemModuleInfo info = (SystemModuleInfo)systemModules.get(i);
          %>
<%            if(i%2==1){      %>
	      <TR CLASS="DataDark">
<%		      }else{          %>
	      <TR CLASS="DataLight">
<%		      }               %>
            <TD><input type="checkbox" name="deleteModuleId" value="<%=info.getId()%>" onClick=unselectall()></TD>
            <TD><%=info.getId()%></TD>
            <TD><%=info.getName()%></TD>
            <TD><%=info.isReleased()%></TD>
            <TD><a href="SystemModuleEdit.jsp?id=<%=info.getId()%>"><img src="/images/iedit.gif" width="16" height="16" border="0"></a></TD>
          </TR>
<%        }%>

<TR class=Separator>
            <TD class=sep2 colSpan=5>
            <input type="hidden" name="operation" value="search">
            </TD>
          </TR>
<tr>
          </TBODY>
        </TABLE>
        <br>
        <input type="checkbox" name="checkall0" onClick="CheckAll(checkall0.checked)" value="ON">全部选中<br>

		<br><br>

      </FORM>

<script language="javascript">

function CheckAll(checked) {
    len = document.frmSearch.elements.length;   
    var i=0;
    
    for( i=0; i<len; i++) {
        if (document.frmSearch.elements[i].name=='deleteModuleId') {
            document.frmSearch.elements[i].checked=(checked==true?true:false);
        } 
    } 
}
function unselectall(){
    if(document.frmSearch.checkall0.checked){
        document.frmSearch.checkall0.checked =0;
    }
}

function confirmdel() {
	return confirm("确定删除选定的信息吗?") ;
}
function addModule() {
	location="SystemModuleAdd.jsp";
}

function searchlabel() {
	document.frmSearch.operation.value="search";
	document.frmSearch.submit();
}
function deleteModule() {
	document.frmSearch.operation.value="deleteModule";
	if(confirmdel()){
		document.frmSearch.submit();
    }
}
function viewSQL(){
    document.frmSearch.action="SystemModuleViewSql.jsp";
    document.frmSearch.submit();
}

</script>


</BODY>
</HTML>
