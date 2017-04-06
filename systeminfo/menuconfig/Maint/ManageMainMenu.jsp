<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.net.URLDecoder" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuInfo" %>

<html>
<%
	String menuId="";
	String searchMenuName="";
    String defaultLevel=""; 
    String defaultParentId=""; 

    menuId = Util.null2String(request.getParameter("menuId"));
	searchMenuName = Util.null2String(request.getParameter("searchMenuName"));
    defaultLevel = Util.null2String(request.getParameter("defaultLevel"));
    defaultParentId = Util.null2String(request.getParameter("defaultParentId"));

    String sqlWhere = "";
    if(!menuId.equalsIgnoreCase("")){
        sqlWhere+=" and t1.id =" + menuId + " ";
    }
    if(!searchMenuName.equalsIgnoreCase("")){
        sqlWhere+=" and t3.labelName like '%" + searchMenuName + "%' ";
    }
    if(!defaultLevel.equalsIgnoreCase("")&&!defaultLevel.equalsIgnoreCase("-1")){
        sqlWhere+=" and t1.defaultLevel =" + defaultLevel + " ";
    }
    if(!defaultParentId.equalsIgnoreCase("")&&!defaultParentId.equalsIgnoreCase("0")){
        sqlWhere+=" and t1.defaultParentId =" + defaultParentId + " ";
    }

    MainMenuHandler mainMenuHandler = new MainMenuHandler();
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
    <TD align=left><SPAN id=BacoTitle class=titlename>搜索: 主菜单</SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>

  <FORM style="MARGIN-TOP: 0px" name=frmSearch method=post action="\systeminfo\menuconfig\Maint\ManageMainMenuOperation.jsp">
    <BUTTON class=btn id=btnSearch accessKey=S name=btnSearch type=submit onclick="searchlabel()"><U>S</U>-搜索</BUTTON>
    <BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重新设置</BUTTON>
	<%if(Util.getIntValue(user.getSeclevel(),0)>=20){%>
    <BUTTON class=btn id=btnAdd accessKey=A name=btnAdd onclick="addSystemLevelMainMenu()"><U>A</U>-添加系统级菜单</BUTTON>
    <BUTTON class=btn id=btnAdd accessKey=F name=btnAdd onclick="addFirstLevelMainMenu()"><U>F</U>-添加一级菜单</BUTTON>
    <BUTTON class=btn id=btnAdd accessKey=B name=btnAdd onclick="addSecondLevelMainMenu()"><U>B</U>-添加二级菜单</BUTTON>
    <BUTTON class=btn id=btnAdd accessKey=T name=btnAdd onclick="addThirdLevelMainMenu()"><U>T</U>-添加三级菜单</BUTTON>
    <BUTTON class=btn id=btnDelete accessKey=D name=btnDelete onclick="deleteMenu()"><U>D</U>-删除</BUTTON>
	<%}%>
    <BUTTON class=btn id=btnEdit accessKey=S name=btnEdit onclick="viewSQL()"><U>E</U>-导出SQL</BUTTON>

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
            <TD>主菜单ID</TD>
            <TD Class=Field colspan=4>
              <INPUT class=FieldxLong name=menuId accessKey=Z value="<%=menuId%>">
            </TD>
          </TR>
          <TR>
            <TD>主菜单名称</TD>
            <TD Class=Field colspan=4>
              <INPUT class=FieldxLong name=searchMenuName accessKey=Z value="<%=searchMenuName%>">
            </TD>
          </TR>
          <TR>
            <TD>菜单等级</TD>
            <TD Class=Field colspan=4>
              <SELECT name=defaultLevel>
                  <OPTION value=-1></OPTION>
                  <OPTION value=0 <%if(defaultLevel.equals("0")){%> selected <%}%>>系统级菜单</OPTION>
                  <OPTION value=1 <%if(defaultLevel.equals("1")){%> selected <%}%>>一级菜单</OPTION>
                  <OPTION value=2 <%if(defaultLevel.equals("2")){%> selected <%}%>>二级菜单</OPTION>
                  <OPTION value=3 <%if(defaultLevel.equals("3")){%> selected <%}%>>三级菜单</OPTION>
              </SELECT>
            </TD>
          </TR>
          </TBODY>
        </TABLE>
        <br>
        <TABLE class=ListShort>
          <COLGROUP> <COL width="10%"> <COL width="20%"> <COL width="30%"> <COL width="10%"> <COL width="10%"> <COL width="20%"> <TBODY>
          <TR class=Section>
            <TH colSpan=6>搜索结果</TH>
          </TR>
          <TR class=Separator>
            <TD class=sep2 colSpan=6></TD>
          </TR>
          <TR class=Header>
            <Td >选择</Td>
            <Td >标识</Td>
            <Td >名称</Td>
            <Td >等级</Td>
            <Td >上级菜单</Td>
            <Td >细节</Td>
          </TR>
          <%
          
          ArrayList mainMenuInfos = mainMenuHandler.getAllMainMenuInfos(sqlWhere);
          for(int i = 0;i<mainMenuInfos.size();i++){
              MainMenuInfo info = (MainMenuInfo)mainMenuInfos.get(i);
              MainMenuInfo parentInfo = mainMenuHandler.getMenuInfo(info.getDefaultParentId());
          %>
<%            if(i%2==1){      %>
	      <TR CLASS="DataDark">
<%		      }else{          %>
	      <TR CLASS="DataLight">
<%		      }               %>
            <TD><input type="checkbox" name="deleteMenuId" value="<%=info.getId()%>" onClick=unselectall()></TD>
            <TD><%=info.getId()%></TD>
            <TD><%=SystemEnv.getHtmlLabelName(info.getLabelId(),user.getLanguage())%></TD>
            <TD ><%=info.getDefaultLevel()%></TD>
<%          if(parentInfo!=null){                %> 
            <TD ><%= SystemEnv.getHtmlLabelName(parentInfo.getLabelId(),user.getLanguage())%></TD>
<%          }else{                               %>
            <TD ></TD>
<%         }                                     %>
            <TD><a href="MainMenuEdit.jsp?id=<%=info.getId()%>"><img src="/images/iedit.gif" width="16" height="16" border="0"></a></TD>
          </TR>
<%        }%>

          <TR class=Separator>
            <TD class=sep2 colSpan=6>
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
        if (document.frmSearch.elements[i].name=='deleteMenuId') {
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
function addSystemLevelMainMenu() {
	location="MainMenuAdd.jsp?defaultLevel=0";
}
function addFirstLevelMainMenu() {
	location="MainMenuAdd.jsp?defaultLevel=1";
}
function addSecondLevelMainMenu() {
	location="MainMenuAdd.jsp?defaultLevel=2";
}
function addThirdLevelMainMenu() {
	location="MainMenuAdd.jsp?defaultLevel=3";
}
function searchlabel() {
	document.frmSearch.operation.value="search";
	document.frmSearch.submit();
}
function deleteMenu() {
	document.frmSearch.operation.value="deleteMenu";
	if(confirmdel()){
		document.frmSearch.submit();
    }
}
function viewSQL(){
    document.frmSearch.action="MainMenuViewSql.jsp";
    document.frmSearch.submit();
}
</script>


</BODY>
</HTML>
