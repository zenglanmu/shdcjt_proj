<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.systeminfo.menuconfig.SystemModuleHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.SystemModuleInfo" %>
<%@ page import="weaver.systeminfo.menuconfig.HtmlLabelUtil" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuInfo" %>
<%@ page import="weaver.systeminfo.menuconfig.LabelInfo" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
if(Util.getIntValue(user.getSeclevel(),0)<20){
 	response.sendRedirect("ManageMainMenu.jsp");
    return;
}

String labelId=""; 
String menuName="";
String linkAddress ="";
String parentFrame ="";

String defaultParentId=""; 
String defaultLevel="";
String defaultIndex = "1";

String needRightToVisible = "";
String rightDetailToVisible = "";
String needRightToView = "";
String rightDetailToView = "";

String needSwitchToVisible = "";
String switchClassNameToVisible = "";
String switchMethodNameToVisible = "";


String needSwitchToView = "";
String switchClassNameToView = "";
String switchMethodNameToView = "";


String systemModuleId=""; 
String descLike ="";
String oldIndex = "";
String menuId = "";

MainMenuInfo editMenuInfo = null;

menuId = Util.null2String(request.getParameter("id"));


labelId = Util.null2String(request.getParameter("labelId"));
menuName = Util.null2String(request.getParameter("menuName"));
linkAddress = Util.null2String(request.getParameter("linkAddress"));
parentFrame = Util.null2String(request.getParameter("parentFrame"));

defaultParentId = Util.null2String(request.getParameter("defaultParentId"));
defaultLevel = Util.null2String(request.getParameter("defaultLevel"));
defaultIndex = Util.null2String(request.getParameter("defaultIndex"));

needRightToVisible = Util.null2String(request.getParameter("needRightToVisible"));
rightDetailToVisible = Util.null2String(request.getParameter("rightDetailToVisible"));
needRightToView = Util.null2String(request.getParameter("needRightToView"));
rightDetailToView = Util.null2String(request.getParameter("rightDetailToView"));

needSwitchToVisible = Util.null2String(request.getParameter("needSwitchToVisible"));
switchClassNameToVisible = Util.null2String(request.getParameter("switchClassNameToVisible"));
switchMethodNameToVisible = Util.null2String(request.getParameter("switchMethodNameToVisible"));

needSwitchToView = Util.null2String(request.getParameter("needSwitchToView"));
switchClassNameToView = Util.null2String(request.getParameter("switchClassNameToView"));
switchMethodNameToView = Util.null2String(request.getParameter("switchMethodNameToView"));

systemModuleId = Util.null2String(request.getParameter("systemModuleId"));
descLike = Util.null2String(request.getParameter("descLike"));

MainMenuInfoHandler mainMenuInfoHandler = new MainMenuInfoHandler();

if(descLike.equalsIgnoreCase("")){
    
	editMenuInfo = mainMenuInfoHandler.getMenuInfo(menuId);
	
    labelId = String.valueOf(editMenuInfo.getLabelId());
    menuName = Util.null2String(editMenuInfo.getMenuName());
    linkAddress = Util.null2String(editMenuInfo.getLinkAddress());
    parentFrame = Util.null2String(editMenuInfo.getParentFrame());

    defaultParentId = String.valueOf(editMenuInfo.getDefaultParentId());
    defaultLevel = Util.null2String(String.valueOf(editMenuInfo.getDefaultLevel()));
    defaultIndex = Util.null2String(String.valueOf(editMenuInfo.getDefaultIndex()));

    needRightToVisible = editMenuInfo.isNeedRightToVisible()?"1":"0";
    rightDetailToVisible = Util.null2String(editMenuInfo.getRightDetailToVisible());
    needRightToView = editMenuInfo.isNeedRightToView()?"1":"0";
    rightDetailToView = Util.null2String(editMenuInfo.getRightDetailToView());

    needSwitchToVisible = editMenuInfo.isNeedSwitchToVisible()?"1":"0";
    switchClassNameToVisible = Util.null2String(editMenuInfo.getSwitchClassNameToVisible());
    switchMethodNameToVisible = Util.null2String(editMenuInfo.getSwitchMethodNameToVisible());

    needSwitchToView = editMenuInfo.isNeedSwitchToView()?"1":"0";
    switchClassNameToView = Util.null2String(editMenuInfo.getSwitchClassNameToView());
    switchMethodNameToView = Util.null2String(editMenuInfo.getSwitchMethodNameToView());

    systemModuleId = Util.null2String(String.valueOf(editMenuInfo.getRelatedModuleId()));


	oldIndex = defaultIndex;
}

if(labelId.equalsIgnoreCase("-1")){
	labelId = "";
}
if(defaultParentId.equalsIgnoreCase("-1")){
	defaultParentId = "";
}
if(systemModuleId.equalsIgnoreCase("-1")){
	systemModuleId = "";
}

SystemModuleHandler systemModuleHandler = new SystemModuleHandler();
MainMenuHandler mainMenuHandler = new MainMenuHandler();

HtmlLabelUtil htmlLabelUtil = new HtmlLabelUtil();

%>

<html>
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
<%        String titleLabel = "";
          int level = Util.getIntValue(defaultLevel,0);
          if(level==0){
              titleLabel = "系统级菜单:	";
          }
          else if(level==1){
              titleLabel = "一级菜单:	";
          }
          else if(level==2){
              titleLabel = "二级菜单:	";
          }
          else if(level==3){
              titleLabel = "三级菜单:	";
          }
		  titleLabel+= editMenuInfo.getOriginalName(user.getLanguage());
          %>
    <TD align=left><SPAN id=BacoTitle class=titlename>添加: 主菜单 - <%=titleLabel%></SPAN></TD>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>

  <FORM style="MARGIN-TOP: 0px" name=frmView method=post action="ManageMainMenuOperation.jsp">

   <input type="hidden" name="operation" value="editMainMenuInfo">
   <input type="hidden" name="menuId" value=<%=menuId%>>
   <input type="hidden" name="oldIndex" value=<%=oldIndex%>>

    <BUTTON class=btn id=btnSave accessKey=S name=btnSave onClick="editMainMenuInfo()"><U>S</U>-保存</BUTTON>
    <BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重新设置</BUTTON>
    <br>
    <TABLE class=Form>
          <COLGROUP> <COL width="25%"><COL width="5%"> <COL width="10%"> <COL width="25%"> <COL width="10%"> <COL width="25%">
          <TR class=Section> 
            <TH colSpan=6 align = left>菜单信息</TH>
          </TR>
          <TR class=Separator> 
            <TD class=sep1 colSpan=6></TD>
          </TR>
          <TR> 
            <TD>标签ID</TD>
            <TD Class=Field colSpan=5><INPUT class=FieldxLong name="labelId" value="<%=labelId%>"></TD>
          </TR>
          <TR> 
            <TD>名称</TD>
            <TD Class=Field colSpan=5>
			<INPUT class=FieldxLong name=menuName value="<%=menuName%>"></TD>
          </TR>
          <TR> 
            <TD>链接页面的地址</TD>
            <TD Class=Field colSpan=5>
<%			if(linkAddress.equalsIgnoreCase("")){				%>
			<INPUT  class=FieldxLong name="linkAddress" value=""></TD>
<%			}else{											%>
			<INPUT  class=FieldxLong name="linkAddress" value="<%=linkAddress%>"></TD>
<%			}												%>
          </TR>
          <TR>
            <TD>父窗体</TD>
            <TD Class=Field colspan=5>
              <SELECT name=parentFrame>
                  <OPTION value="" <%if(parentFrame.equals("")){%> selected <%}%>></OPTION>
                  <OPTION value="mainFrame" <%if(parentFrame.equals("mainFrame")){%> selected <%}%>>mainFrame</OPTION>
                  <OPTION value="_blank" <%if(parentFrame.equals("_blank")){%> selected <%}%>>_blank</OPTION>
              </SELECT>
            </TD>
          </TR>
<%        if(!defaultLevel.equals("0")){      %>
          <TR>
            <TD>上级菜单</TD>
            <TD class="field" colspan=5 >
<%			  if(defaultLevel.equals("1")){				%>
              <BUTTON class=Browser onClick="onShowSysParentLevelMainMenu()"></BUTTON>
<%            }else{                                     %>
              <BUTTON class=Browser onClick="onShowParentLevelMainMenu()"></BUTTON>
<%            }                                         %>
              <SPAN id=parentIdSpan>
<%            if(!defaultParentId.equals("-1")&&Util.getIntValue(defaultParentId,0)!=0){
                  MainMenuInfo parentInfo = mainMenuHandler.getMenuInfo(Util.getIntValue(defaultParentId,0));
%>
                  <%=parentInfo.getOriginalName(user.getLanguage())%>
<%            }       %>
              </SPAN>
              <INPUT type="hidden" name="defaultParentId" value="<%=Util.getIntValue(defaultParentId,0)%>">
            </TD>
          </TR>
<%          }                                   %>
          <TR>
            <TD>菜单等级</TD>
            <TD colSpan=5>
              <SPAN id=defaultLevelSpan><%=titleLabel%>
			  </SPAN>	
              <INPUT type="hidden" name="defaultLevel" value="<%=Util.getIntValue(defaultLevel,0)%>">
            </TD>
          </TR>
          <TR> 
            <TD>所属模块</TD>
            <TD class="field" colspan=5 >
              <BUTTON class=Browser onClick="onShowSystemModule()"></BUTTON>
              <SPAN id=systemModuleSpan>
<%            if(Util.getIntValue(systemModuleId,0)!=0){
                  SystemModuleInfo systemModuleInfo = systemModuleHandler.getInfo(Util.getIntValue(systemModuleId,0));
%>
                  <%=systemModuleInfo.getName()%>
<%            }       %>
              </SPAN>
              <INPUT type="hidden" name="systemModuleId" value="<%=Util.getIntValue(systemModuleId,0)%>">
            </TD>
          </TR>

          <TR> 
            <TD>位置:前一个菜单</TD>
            <TD class="field" colspan=5 >
<%			  if(defaultLevel.equals("0")){				%>
			  <BUTTON class=Browser onClick="onShowPreSysLevelMainMenu()"></BUTTON>
<%			  }else{									%>
			  <BUTTON class=Browser onClick="onShowPreLevelMainMenu()"></BUTTON>
<%            }                                                                     %>        
              <SPAN id=defaultIndexSpan>
<%if(!defaultIndex.equalsIgnoreCase("")&&Util.getIntValue(defaultIndex,0)!=1){
                  MainMenuInfo mainMenuInfo = mainMenuInfoHandler.getPreMenuInfo(Util.getIntValue(defaultIndex,0),Util.getIntValue(defaultLevel),Util.getIntValue(defaultParentId));
%>
                  <%=mainMenuInfo.getOriginalName(user.getLanguage())%>
<%            }       %>
              </SPAN>
              <INPUT type="hidden" name="defaultIndex" value="<%=Util.getIntValue(defaultIndex,1)%>">
            </TD>
          </TR>
          <TR class=Separator> 
            <TD class=sep1 colSpan=6></TD>
          </TR>
<%        if(!defaultLevel.equals("0")){      %>
          <TR> 
            <TD>
            <B>菜单是否可见控制</B>
            </TD>
          </TR>
          <TR class=Separator> 
            <TD class=sep1 colSpan=6></TD>
          </TR>
          <TR> 
            <TD colspan=1>通过权限控制</TD>
            <TD Class=Field colspan=1> 
			<INPUT type="checkbox" name=needRightToVisible value="1" <%if(needRightToVisible.equals("1")){%>checked<%}%> ></TD>
            <TD>权限详细</TD>
            <TD Class=Field colspan=4 >
			<INPUT class=FieldLong name=rightDetailToVisible value="<%=rightDetailToVisible%>"></TD>
          </TR>

          <TR> 
            <TD>通过开关控制</TD>
            <TD Class=Field colspan=1> 
			<INPUT type="checkbox" name=needSwitchToVisible value="1" <%if(needSwitchToVisible.equals("1")){%>checked<%}%>></TD>
            <TD>类名称</TD>
            <TD Class=Field colspan=1 >
			<INPUT name=switchClassNameToVisible value="<%=switchClassNameToVisible%>"></TD>
            <TD>方法名称</TD>
            <TD Class=Field colspan=1 >
			<INPUT name=switchMethodNameToVisible value="<%=switchMethodNameToVisible%>"></TD>
          </TR>
          <TR class=Separator> 
            <TD class=sep1 colSpan=6></TD>
          </TR>
          <TR> 
            <TD>
            <B>页面访问控制</B>
            </TD>
          </TR>
          <TR class=Separator> 
            <TD class=sep1 colSpan=6></TD>
          </TR>
          <TR> 
            <TD>通过权限控制</TD>
            <TD Class=Field colspan=1> 
			<INPUT type="checkbox" name=needRightToView value="1" <%if(needRightToView.equals("1")){%>checked<%}%>></TD>
            <TD>权限详细</TD>
            <TD Class=Field colspan=4 >
			<INPUT class=FieldLong name=rightDetailToView value="<%=rightDetailToView%>"></TD>
          </TR>

          <TR> 
            <TD>通过开关控制</TD>
            <TD Class=Field colspan=1> 
			<INPUT type="checkbox" name=needSwitchToView value="1" <%if(needSwitchToView.equals("1")){%>checked<%}%>></TD>
            <TD>类名称</TD>
            <TD Class=Field colspan=1 >
			<INPUT name=switchClassNameToView value="<%=switchClassNameToView%>"></TD>
            <TD>方法名称</TD>
            <TD Class=Field colspan=1 >
			<INPUT name=switchMethodNameToView value="<%=switchMethodNameToView%>"></TD>
          </TR>

          <TR class=Separator> 
            <TD class=sep1 colSpan=6></TD>
          </TR>
<%        }                       %>
          </TABLE>

    <TABLE>
          <TR> 
            <TD><BUTTON class=btn id=btnSearch accessKey=Y name=btnSearch onclick="searchLabel()"><U>Y</U>-搜索标签</BUTTON>
            </TD>
            <TD><INPUT class=FieldxLong name=descLike accessKey=Z value="<%=descLike%>">
            </TD>
           
          </TR>
    </TABLE>

    <br>
        

    <TABLE name=result class=ListShort>
          <COLGROUP> <COL width="40%"> <COL width="60%">
          <TR class=Section>
            <TH colSpan=2>标签——搜索结果</TH>
          </TR>
          <TR class=Separator>
            <TD class=sep2 colSpan=2></TD>
          </TR>
          <TR class=Header>
            <Td >标识</Td>
            <Td >描叙</Td>
          </TR>
<%
		ArrayList labelInfos = htmlLabelUtil.getLabelInfos(descLike);

        int infoSize = labelInfos.size();
        for(int i=0;i<infoSize;i++){
            LabelInfo labelInfo = (LabelInfo)labelInfos.get(i);
		    if(i%2==1){                                                  %>

	      <TR CLASS="DataDark" onclick = "selectRow(this)" >
<%		    }else{                                                      %>
	      <TR CLASS="DataLight" onclick = "selectRow(this)" >
<%		    }                                                           %>
            <TD><%=labelInfo.getId()%></TD>
            <TD><%=labelInfo.getIndexDesc()%></TD>
          </TR>
<%
        }
%>
          <TR class=Separator>
            <TD class=sep2 colSpan=2></TD>
          </TR>
    </TABLE>



  </FORM>

<script language="javascript">

var oldClassName;
var oldSelectedObj;

function searchLabel(){
    frmView.operation.value = "searchLabel";
    document.frmView.submit();
}

function editMainMenuInfo(){
    frmView.operation.value = "editMainMenuInfo";
    document.frmView.submit();
}
function onShowSysParentLevelMainMenu(){
    var pValue = frmView.defaultParentId.value;
    var lValue = frmView.defaultLevel.value;
    var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/systeminfo/menuconfig/Maint/ParentSysLevelMainMenuBrowser.jsp");
	if(id==null){
		return;
	}
    if(id[0]!=null){
        if(id[0]!="0"){
            parentIdSpan.innerHTML = id[1];
            frmView.defaultParentId.value=id[0];
        }
        else{
            parentIdSpan.innerHTML = "";
		    frmView.defaultParentId.value="";
        }
    }
}
function onShowParentLevelMainMenu(){
    var pValue = frmView.defaultParentId.value;
    var lValue = frmView.defaultLevel.value;

    var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/systeminfo/menuconfig/Maint/ParentLevelMainMenuBrowser.jsp?defaultParentId="+pValue+"&defaultLevel="+lValue);
	if(id==null){
		return;
	}
    if(id[0]!=null){
        if(id[0]!="0"){
            parentIdSpan.innerHTML = id[1];
            frmView.defaultParentId.value=id[0];
        }
        else{
            parentIdSpan.innerHTML = "";
		    frmView.defaultParentId.value="";
        }
    }
}

function onShowPreSysLevelMainMenu(){
    var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/systeminfo/menuconfig/Maint/PreSysLevelMainMenuBrowser.jsp");
	if(id==null){
		return;
	}
    if(id[0]!=null){
        if(id[0]!="0"){
            defaultIndexSpan.innerHTML = id[1];
            frmView.defaultIndex.value=parseInt(id[0]) + 1;
        }
        else{
            defaultIndexSpan.innerHTML = "";
		    frmView.defaultIndex.value="1";
        }
    }
}
function onShowPreLevelMainMenu(){
	var pValue = frmView.defaultParentId.value;
    var lValue = frmView.defaultLevel.value;

    var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/systeminfo/menuconfig/Maint/PreLevelMainMenuBrowser.jsp?defaultParentId="+pValue+"&defaultLevel="+lValue);
	if(id==null){
		return;
	}

    if(id[0]!=null){
        if(id[0]!="0"){
            defaultIndexSpan.innerHTML = id[1];
            frmView.defaultIndex.value=parseInt(id[0]) + 1;
        }
        else{
            defaultIndexSpan.innerHTML = "";
		    frmView.defaultIndex.value="1";
        }
    }
}

function onShowSystemModule(){
    var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/systeminfo/menuconfig/Maint/SystemModuleBrowser.jsp");
	if(id==null){
		return;
	}
    if(id[0]!=null){
        if(id[0]!="0"){
            systemModuleSpan.innerHTML = id[1];
            frmView.systemModuleId.value=id[0];
        }
        else{
            systemModuleSpan.innerHTML = "";
		    frmView.systemModuleId.value="1";
        }
    }
}
function selectRow(obj){
    if(obj==null){
        return;
	}
	else{
		oldClassName = obj.className;
		if(oldSelectedObj==null){
		}
		else{
			oldSelectedObj.className = oldClassName;
		}
	}
	oldSelectedObj = obj;
    obj.className="Selected";
    frmView.labelId.value = oldSelectedObj.cells(0).innerText;
}
</script>

</BODY>
</HTML>
