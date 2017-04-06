<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.systeminfo.menuconfig.SystemModuleHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.SystemModuleInfo" %>
<%@ page import="weaver.systeminfo.menuconfig.HtmlLabelUtil" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ page import="weaver.systeminfo.menuconfig.LabelInfo" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
if(Util.getIntValue(user.getSeclevel(),0)<20){
 	response.sendRedirect("ManageLeftMenu.jsp");
    return;
}

String parentId=""; 
String systemModuleId=""; 
String descLike ="";
String iconUrl=""; 
String labelId=""; 
String linkAddress ="";
String defaultIndex = "1";

String menuLevel = Util.null2String(request.getParameter("menuLevel"));
parentId = Util.null2String(request.getParameter("parentId"));
systemModuleId = Util.null2String(request.getParameter("systemModuleId"));
descLike = Util.null2String(request.getParameter("descLike"));
iconUrl = Util.null2String(request.getParameter("iconUrl"));
labelId = Util.null2String(request.getParameter("labelId"));
linkAddress = Util.null2String(request.getParameter("linkAddress"));
defaultIndex = Util.null2String(request.getParameter("defaultIndex"));

SystemModuleHandler systemModuleHandler = new SystemModuleHandler();
LeftMenuHandler leftMenuHandler = new LeftMenuHandler();
LeftMenuInfoHandler leftMenuInfoHandler = new LeftMenuInfoHandler();
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
<%        if(Util.getIntValue(menuLevel,0)==1){                              %>
    <TD align=left><SPAN id=BacoTitle class=titlename>添加: 左侧菜单 - 顶级菜单</SPAN></TD>
<%        }else{                                                             %>
    <TD align=left><SPAN id=BacoTitle class=titlename>添加: 左侧菜单 - 子菜单</SPAN></TD>
<%        }                                                                 %>
    <TD align=right>&nbsp;</TD>
    <TD width=5></TD>
  <tr>
 <TBODY>
</TABLE>
</div>

 <DIV class=HdrProps></DIV>

  <FORM style="MARGIN-TOP: 0px" name=frmView method=post action="ManageLeftMenuOperation.jsp">

   <input type="hidden" name="menuLevel" value=<%=menuLevel%>>
   <input type="hidden" name="operation" value="addLeftMenuInfo">

    <BUTTON class=btn id=btnSave accessKey=S name=btnSave onClick="addLeftMenuInfo()"><U>S</U>-保存</BUTTON>
    <BUTTON class=btn id=btnClear accessKey=R name=btnClear type=reset><U>R</U>-重新设置</BUTTON>
    <br>
    <TABLE class=Form>
          <COLGROUP> <COL width="20%"> <COL width="80%">
          <TR class=Section> 
            <TH colSpan=5>菜单信息</TH>
          </TR>
          <TR class=Separator> 
            <TD class=sep1 colSpan=5></TD>
          </TR>
          <TR> 
            <TD>标签ID</TD>
            <TD Class=Field><INPUT class=FieldxLong name="labelId" value="<%=labelId%>"></TD>
          </TR>
<%        if(Util.getIntValue(menuLevel,0)==2){                              %>
          <TR> 
            <TD>图标地址</TD>
            <TD Class=Field>
<%			if(iconUrl.equalsIgnoreCase("")){				%>
			<INPUT class=FieldxLong accessKey=Z name=iconUrl value="like: /images_face/ecologyFace_1/LeftMenuIcon/*.gif"></TD>
<%			}else{											%>
			<INPUT class=FieldxLong accessKey=Z name=iconUrl value="<%=iconUrl%>"></TD>
<%			}												%>
          </TR>
          <TR> 
            <TD>链接页面的地址</TD>
            <TD Class=Field>
<%			if(linkAddress.equalsIgnoreCase("")){				%>
			<INPUT  class=FieldxLong name="linkAddress" value="like: /workplan/data/WorkPlan.jsp"></TD>
<%			}else{											%>
			<INPUT  class=FieldxLong name="linkAddress" value="<%=linkAddress%>"></TD>
<%			}												%>
          </TR>
          <TR>
            <TD>上级菜单</TD>
            <TD class="field" colspan=4 >
              <BUTTON class=Browser onClick="onShowTopLevelLeftMenu()"></BUTTON>
              <SPAN id=parentIdSpan>
<%            if(Util.getIntValue(parentId,0)!=0){
                  LeftMenuInfo parentInfo = leftMenuHandler.getMenuInfo(Util.getIntValue(parentId,0));
%>
                  <%=parentInfo.getName(user.getLanguage())%>
<%            }       %>
              </SPAN>
              <INPUT type="hidden" name="parentId" value="<%=Util.getIntValue(parentId,0)%>">
            </TD>
          </TR>
<%        }                                                                 %>
          <TR> 
            <TD>所属模块</TD>
            <TD class="field" colspan=4 >
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
            <TD class="field" colspan=4 >
<%			  if(menuLevel.equals("1")){				%>
			  <BUTTON class=Browser onClick="onShowPreTopLeftMenu()"></BUTTON>
<%			  }else{									%>
			  <BUTTON class=Browser onClick="onShowPreSubLeftMenu()"></BUTTON>
<%			  }											%>
              <SPAN id=defaultIndexSpan>
<%            if(!defaultIndex.equalsIgnoreCase("")&&Util.getIntValue(defaultIndex,0)!=1){
                  LeftMenuInfo leftMenuInfo = leftMenuInfoHandler.getPreMenuInfo(Util.getIntValue(defaultIndex,0),Util.getIntValue(menuLevel),Util.getIntValue(parentId));

%>
                  <%=SystemEnv.getHtmlLabelName(leftMenuInfo.getLabelId(),user.getLanguage())%>
<%            }       %>
              </SPAN>
              <INPUT type="hidden" name="defaultIndex" value="<%=Util.getIntValue(defaultIndex,0)%>">
            </TD>
          </TR>
          <TR class=Separator> 
            <TD class=sep1 colSpan=5></TD>
          </TR>
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

function addLeftMenuInfo(){
    frmView.operation.value = "addLeftMenuInfo";
    document.frmView.submit();
}

function onShowTopLevelLeftMenu(){
    var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/systeminfo/menuconfig/Maint/TopLevelLeftMenuBrowser.jsp");
	if(id==null){
		return;
	}
    if(id[0]!=null){
        if(id[0]!="0"){
            parentIdSpan.innerHTML = id[1];
            frmView.parentId.value=id[0];
        }
        else{
            parentIdSpan.innerHTML = "";
		    frmView.parentId.value="";
        }
    }
}
function onShowPreTopLeftMenu(){
    var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/systeminfo/menuconfig/Maint/PreTopLevelLeftMenuBrowser.jsp");
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
function onShowPreSubLeftMenu(){
	var pValue = frmView.parentId.value;
    var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/systeminfo/menuconfig/Maint/PreSubLevelLeftMenuBrowser.jsp?parentId="+pValue);
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
