<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuInfo" %>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

String level = request.getParameter("defaultLevel");

int defaultLevel = Util.getIntValue(level,0);
int parentLevel = defaultLevel -1;


String parentId = Util.null2String(request.getParameter("defaultParentId"));
String systemLevelIdParam = Util.null2String(request.getParameter("systemLevelId"));

int defaultParentId = Util.getIntValue(parentId,0);

String sqlWhere = "";
String searchMenuName ="";
int systemLevelId = 0;


searchMenuName = Util.null2String(request.getParameter("searchMenuName"));

if(!searchMenuName.equalsIgnoreCase("")){
        sqlWhere+=" and t3.labelName like '%" + searchMenuName + "%' ";
}

MainMenuInfoHandler mainMenuInfoHandler = new MainMenuInfoHandler();

if(systemLevelIdParam.equalsIgnoreCase("")){
    systemLevelId = mainMenuInfoHandler.getSystemLevelId(defaultParentId);
}
else{
    systemLevelId = Util.getIntValue(systemLevelIdParam);
}

if(systemLevelId!=0){
    if(parentLevel==1){
        //sqlWhere+=" AND t1.id IN (SELECT id FROM t1 WHERE t1.defaultParentId = "+ systemLevelId +")";
    }
    else if(parentLevel==2){
        //sqlWhere+=" AND t1.id IN (SELECT id FROM t1 WHERE t1.defaultParentId IN ";
    }
}

ArrayList sysLevelMainMenuInfos = mainMenuInfoHandler.getPreLevelMainMenuInfos(0,0,"");

ArrayList parentLevelMainMenuInfos = mainMenuInfoHandler.getParentLevelMainMenuInfos(parentLevel,defaultParentId,systemLevelId,sqlWhere);

RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:SearchForm.btnclear.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<BODY>
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
		<TABLE class=Shadow>
		<tr>
		<td valign="top">


<FORM NAME=SearchForm STYLE="margin-bottom:0" action="ParentLevelMainMenuBrowser.jsp" method=post>

   <input type="hidden" name="defaultLevel" value="<%=defaultLevel%>">
   <input type="hidden" name="systemLevelId" value="<%=systemLevelId%>">


<DIV align=right style="display:none">
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=2 id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<TABLE>

    <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
      <TD width=35% class=field><input class=inputstyle name=searchMenuName value="<%=searchMenuName%>"></TD>
<%          if(parentLevel!=0){                    %>

      <TD width=15%>系统级菜单</TD>
      <TD width=40% class=field>
        <select class=inputstyle id=systemLevel name=systemLevel onchange="changeSystemLevel()">
		<option value="0"></option>
		<% for(int i=0;i<sysLevelMainMenuInfos.size();i++) {  
			 MainMenuInfo sysInfo = (MainMenuInfo)sysLevelMainMenuInfos.get(i);
             int tempSysInfoId = sysInfo.getId();
		%>
          <option value=<%=tempSysInfoId%> <%if(tempSysInfoId==systemLevelId){%>selected<%}%>>
		  <%=sysInfo.getOriginalName(user.getLanguage())%></option>
		<% } %>
        </select>
      </TD>

<%          }else{                                       %>
      <TD width=15%></TD>
      <TD width=40%></TD>
<%          }                                            %>
    </TR>
    <TR><TD class=Line colSpan=6></TD></TR> 

</TABLE>
<TABLE ID=browseTable class=BroswerStyle onclick="browseTable_onclick()" onmouseover="browseTable_onmouseover()" onmouseout="browseTable_onmouseout()"   cellspacing=1>
<TR class=DataHeader>
<TH><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<TH><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<%if(parentLevel!=0){              %>
<TH>上级菜单</TH>
<%}                                 %>
<%
for(int i=0;i<parentLevelMainMenuInfos.size();i++){
    MainMenuInfo info = (MainMenuInfo)parentLevelMainMenuInfos.get(i);
    MainMenuInfo parentInfo = null;
    if(parentLevel!=0){
        parentInfo = mainMenuInfoHandler.getMenuInfo(String.valueOf(info.getDefaultParentId()));
    }

	if(i%2==0){
%>
<TR class=DataLight>
<%
	}else{
%>
<TR class=DataDark>
	<%
	}
	%>
	<TD width=20%><A HREF=#><%=info.getId()%></A></TD>
	<TD width=40%><%=info.getOriginalName(user.getLanguage())%></TD>
<%  if(parentLevel!=0){              %>
    <TD width=40%><%=parentInfo.getOriginalName(user.getLanguage())%></TD>
<%  }                                 %>
</TR>
<%}%>


</TABLE></FORM>


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



<script language="javascript">

function btnclear_onclick(){
    var array = new Array(2);
    array[0] = "0";
    array[1] = "";
    window.parent.returnValue = array;
    window.parent.close();
}

function browseTable_onclick(){
    var array = new Array(2);
    var e = window.event.srcElement;
    if(e.tagName == "TD"){
        array[0] = e.parentElement.cells(0).innerText;
        array[1] = e.parentElement.cells(1).innerText;
    }
    else if(e.tagName == "A"){
        array[0] = e.parentElement.parentElement.cells(0).innerText;
        array[1] = e.parentElement.parentElement.cells(1).innerText;
    }
    window.parent.returnValue = array;
    window.parent.close();
}

function browseTable_onmouseover(){
    var e = window.event.srcElement;
    if(e.tagName == "TD"){
        e.parentElement.className = "Selected";
    }
    else if(e.tagName == "A"){
        e.parentElement.parentElement.className = "Selected";
    }
}
function browseTable_onmouseout(){
    var e = window.event.srcElement;
    if(e.tagName == "TD"||e.tagName == "A"){
        var p;
        if(e.tagName == "TD"){
            p = e.parentElement;
        }
        else{
            p = e.parentElement.parentElement;
        }
        if(p.rowIndex%2==0){
            p.className = "DataLight";
        }
        else{
            p.className = "DataDark";
        }
    }
}

function changeSystemLevel(){
    var selectValue = document.all("systemLevel").value;
    SearchForm.systemLevelId.value = document.all("systemLevel").value;
}

</script>

</BODY>
</HTML>