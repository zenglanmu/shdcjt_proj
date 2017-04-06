<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.docs.category.security.*" %>

<jsp:useBean id="MainCategoryManager" class="weaver.docs.category.MainCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryManager" class="weaver.docs.category.SubCategoryManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="DocFTPConfigComInfo" class="weaver.docs.category.DocFTPConfigComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
</head>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
MainCategoryManager.setCategoryid(id);
MainCategoryManager.getCategoryInfoById();
String categoryname=MainCategoryManager.getCategoryname();
categoryname = categoryname.replaceAll("&","&amp;");
categoryname = categoryname.replaceAll("\"","&quot;").replaceAll("\''","\'");;
String coder = MainCategoryManager.getCoder();
float categoryorder=MainCategoryManager.getCategoryorder();
String categoryimageid=MainCategoryManager.getCategoryiamgeid();
int noRepeatedName = MainCategoryManager.getNoRepeatedName();
int messageid = Util.getIntValue(request.getParameter("message"),0);
int errorcode = Util.getIntValue(request.getParameter("errorcode"),0);
boolean canEdit = false;

AclManager am = new AclManager();
boolean hasSubManageRight = am.hasPermission(id, AclManager.CATEGORYTYPE_MAIN, user, AclManager.OPERATION_CREATEDIR);
%>
<BASE TARGET="_parent">
<BODY>


<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
if(HrmUserVarify.checkUserRight("DocMainCategoryEdit:Edit", user)){
	canEdit = true;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(HrmUserVarify.checkUserRight("DocMainCategoryAdd:add", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(65,user.getLanguage())+",javascript:onNew(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("DocSubCategoryAdd:add", user)||hasSubManageRight){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(66,user.getLanguage())+",javascript:onNewSub(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%
}if(HrmUserVarify.checkUserRight("DocMainCategoryEdit:Delete", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(HrmUserVarify.checkUserRight("DocMainCategory:log", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>


<%
if(messageid !=0) {
%>
<DIV><font color="#FF0000"><%=SystemEnv.getHtmlNoteName(messageid,user.getLanguage())%></font></DIV>
<%}%>
            <%if(errorcode == 10){%>
            	<div><font color="red"><%=SystemEnv.getHtmlLabelName(21999,user.getLanguage()) %></font></div>
            <%}%>
<iframe name="DocFTPConfigInfoGetter" style="width:100%;height:200;display:none"></iframe>

<FORM id=frmMain name=frmMain action="UploadFile.jsp" method=post enctype="multipart/form-data">
<DIV>

    
      <TABLE class=ViewForm>
        <TBODY>
	    <COLGROUP>
	    <COL width="20%">
	    <COL width="80%">

        <TR class=Title>
            <TH colSpan=4><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style="height: 1px!important;">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=hidden name="id" value="<%=id%>"><%=id%></TD>
        </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><INPUT maxLength=100 size=60 class=InputStyle name="categoryname" temptitle="<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>" value="<%=categoryname%>" onChange="checkinput('categoryname','categorynamespan')"><%}else{%><%=categoryname%><%}%>
         <%if(canEdit){%><INPUT type="hidden" size=60 class=InputStyle name="srccategoryname" value="<%=categoryname%>"><%}%>
          <SPAN id=categorynamespan><%if(categoryname.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle>
          <%}%></SPAN></TD>
        </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(19387,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><INPUT maxLength=50 size=30 class=InputStyle name="coder" value="<%=coder%>"><%}else{%><%=coder%><%}%></TD>
         </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><INPUT maxLength=5 size=5 class=InputStyle name="categoryorder" onKeyPress="ItemNum_KeyPress()" onBlur='check_number("categoryorder")' value="<%=categoryorder%>"><%}else{%><%=categoryorder%><%}%></TD>
         </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
		
		
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(19449,user.getLanguage())%></TD>
          <TD class=Field><INPUT type="checkbox" class=InputStyle name="norepeatedname" value="1" <%if(noRepeatedName==1){%>checked<%}%> <%if(!canEdit){%>disabled<%}%>></TD>
         </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
		
		
        </TBODY></TABLE>

<%
	String isUseFTPOfSystem=BaseBean.getPropValue("FTPConfig","ISUSEFTP");
	if("1".equals(isUseFTPOfSystem)){
		String refreshSubAndSec="1";
		String isUseFTP="0";
		int FTPConfigId=0;
		String FTPConfigName="";
		String FTPConfigDesc="";
		String serverIP="";
		String serverPort="";
		String userName="";
		String userPassword="";
		String defaultRootDir="";
		int maxConnCount=0;
		float showOrder=0;
		RecordSet.executeSql("select * from DocMainCatFTPConfig where mainCategoryId=" + id);
		if(RecordSet.next()){
			refreshSubAndSec = Util.null2String(RecordSet.getString("refreshSubAndSec"));
			isUseFTP = Util.null2String(RecordSet.getString("isUseFTP"));
			FTPConfigId = Util.getIntValue(RecordSet.getString("FTPConfigId"),0);
		}
		
		if(FTPConfigId==0){
			DocFTPConfigComInfo.setTofirstRow();
			if(DocFTPConfigComInfo.next()){
				FTPConfigId=Util.getIntValue(DocFTPConfigComInfo.getId(),0);
			}
		}

		FTPConfigName = Util.null2String(DocFTPConfigComInfo.getFTPConfigName(""+FTPConfigId));
		FTPConfigDesc = Util.null2String(DocFTPConfigComInfo.getFTPConfigDesc(""+FTPConfigId));
		serverIP = Util.null2String(DocFTPConfigComInfo.getServerIP(""+FTPConfigId));
		serverPort = Util.null2String(DocFTPConfigComInfo.getServerPort(""+FTPConfigId));
		userName = Util.null2String(DocFTPConfigComInfo.getUserName(""+FTPConfigId));
		userPassword = Util.null2String(DocFTPConfigComInfo.getUserPassword(""+FTPConfigId));
        if(!userPassword.equals("")){
		    userPassword="¡ñ¡ñ¡ñ¡ñ¡ñ¡ñ";
	    }
		defaultRootDir = Util.null2String(DocFTPConfigComInfo.getDefaultRootDir(""+FTPConfigId));
		maxConnCount = Util.getIntValue(DocFTPConfigComInfo.getMaxConnCount(""+FTPConfigId),0);
		showOrder = Util.getFloatValue(DocFTPConfigComInfo.getShowOrder(""+FTPConfigId),0);
%>
<INPUT type="hidden" name="isUseFTPOfSystem" value="<%=isUseFTPOfSystem%>">

      <TABLE class=ViewForm>
        <TBODY>
	    <COLGROUP>
	    <COL width="20%">
	    <COL width="80%">

        <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(20518,user.getLanguage())%></TH>
            <TH>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<INPUT type="checkbox" name="refreshSubAndSec" value="1" <%if(refreshSubAndSec.equals("1")){%>checked<%}%> <%if(!canEdit){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(22517,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style="height: 1px!important;">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></TD>
          <TD class=Field><INPUT type="checkbox" class=InputStyle name="isUseFTP" value="1" onclick="showFTPConfig()"  <%if("1".equals(isUseFTP)){%>checked<%}%> <%if(!canEdit){%>disabled<%}%>></TD>
        </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        </TBODY></TABLE>
    <DIV id="FTPConfigDiv" <% if("1".equals(isUseFTP)) { %> style="display:block" <% } else { %> style="display:none" <% } %>>
      <TABLE class=ViewForm>
        <TBODY>
	    <COLGROUP>
	    <COL width="20%">
	    <COL width="80%">
        <TR>
		    <TD><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%></TD>
		    <TD class=Field>
		        <SELECT class=inputstyle name="FTPConfigId" onChange="loadDocFTPConfigInfo(this)">
<%
		            DocFTPConfigComInfo.setTofirstRow();
		            while(DocFTPConfigComInfo.next()){
%>
		                <OPTION value=<%= DocFTPConfigComInfo.getId() %> <% if(Util.getIntValue(DocFTPConfigComInfo.getId(),-1) == FTPConfigId) { %> selected <% } %> ><%= DocFTPConfigComInfo.getFTPConfigName() %></OPTION>
<%
		            }
%>
		        </SELECT>
		    </TD>
        </TR>
        <TR class="Spacing" style="height: 1px!important;"><TD class="Line" colSpan=2></TD></TR>

        <tr>
        <td><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
        <td class=field><SPAN id=FTPConfigNameSpan><%=FTPConfigName%></SPAN></td>
        </tr>
        <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <tr>
        <td><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td>
        <td class=field><SPAN id=FTPConfigDescSpan><%=FTPConfigDesc%></SPAN></td>
        </tr>
        <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>

        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></TD>
          <TD class=Field>
          <SPAN id=serverIPSpan><%=serverIP%></SPAN></TD>
        </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18782,user.getLanguage())%></TD>
          <TD class=Field>
          <SPAN id=serverPortSpan><%=serverPort%></SPAN></TD>
         </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2072,user.getLanguage())%></TD>
          <TD class=Field>
          <SPAN id=userNameSpan><%=userName%></SPAN></TD>
         </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></TD>
          <TD class=Field>
          <SPAN id=userPasswordSpan><%=userPassword%></SPAN></TD>
         </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18476,user.getLanguage())%></TD>
          <TD class=Field>
          <SPAN id=defaultRootDirSpan><%=defaultRootDir%></SPAN></TD>
         </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20522,user.getLanguage())%></TD>
          <TD class=Field>
          <SPAN id=maxConnCountSpan><%=maxConnCount%></SPAN></TD>
         </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
          <TD class=Field>
          <SPAN id=showOrderSpan><%=showOrder%></SPAN></TD>
         </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>		
        </TBODY></TABLE>
    </div>

<%
	}
%>


<input type=hidden name="operation">

<TABLE class=ListStyle cellspacing=1>
  <TBODY>
  <TR class=header>
    <TD ><B><%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%></B></TD>
    <TD align=right colspan = 2>
        <%if(HrmUserVarify.checkUserRight("DocSubCategoryAdd:add", user)){%><A href="DocSubCategoryAdd.jsp?id=<%=id%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></A><%}%></TD></TR>
  <TR class=Header>
      <TD width = 33%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD>
      <TD width = 33%><%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%></TD>
      <TD width = 33%><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
    </TR>
<TR style="height: 1px!important;" class=Line><TD colSpan=3></TD></TR>
<%
SubCategoryManager.setMainCategoryid(id);
SubCategoryManager.selectCategoryInfo();
  int i=0;
  while(SubCategoryManager.next()){
  	int subid = SubCategoryManager.getCategoryid();
  	String name = SubCategoryManager.getCategoryname();
  	name = name.replaceAll("&nbsp","&amp;nbsp").replaceAll("\''","\'");;
  	float suborder = SubCategoryManager.getSuborder();
  	int fathersubid = SubCategoryManager.getSubCategoryid();
  	if (fathersubid < 0) {
  	if(i==0){
  		i=1;
  %>
  <TR class=datalight>
  <%}else{
  		i=0;
  %>
  <TR class=datadark>
  <% }%>
  <td><%=subid%><input type = hidden name = subid value="<%=subid%>"></td>
  <td> <a href="DocSubCategoryEdit.jsp?id=<%=subid%>"><%=name%></a></td>
  <td class = field><input maxLength=5 size=5 class=InputStyle name="suborder" onKeyPress="ItemNum_KeyPress()" <%if(!canEdit) out.println("disabled");%> onBlur='check_number("suborder")' value="<%=suborder%>"></td>
  </tr>
  <%
  }}
  SubCategoryManager.closeStatement();
  %>
</TBODY></TABLE>
</FORM>



</BODY></HTML>

<script>
function onSave(){
	if(check_form(document.frmMain,'categoryname')){
		document.frmMain.target="contentframe";
		document.frmMain.operation.value="edit";
		document.frmMain.submit();
	}
}
function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		document.frmMain.target="contentframe";
		document.frmMain.operation.value="delete";
		document.frmMain.submit();
	}
}
function onDelPic(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(8,user.getLanguage())%>")) {
		document.frmMain.target="contentframe";
		document.frmMain.operation.value="delpic";
		document.frmMain.submit();
	}
}
function onNew(){
	window.parent.location = "/docs/category/DocMainCategoryAdd.jsp";
}
function onNewSub(){
	window.parent.location = "/docs/category/DocSubCategoryAdd.jsp?id=<%=id%>";
}
function onLog(){
	window.parent.location = "/systeminfo/SysMaintenanceLog.jsp?secid=65&sqlwhere=where operateitem=1 and relatedid=<%=id%>";
}

function showFTPConfig(){
    if(document.all("isUseFTP").checked){
        document.all("FTPConfigDiv").style.display = "block";
    }else{
    	document.all("FTPConfigDiv").style.display = "none";
    }
}

function loadDocFTPConfigInfo(obj){
	document.all("DocFTPConfigInfoGetter").src="DocFTPConfigIframe.jsp?operation=loadDocFTPConfigInfo&FTPConfigId="+obj.value;
}


function returnDocFTPConfigInfo(FTPConfigName,FTPConfigDesc,serverIP,serverPort,userName,userPassword,defaultRootDir,maxConnCount,showOrder){
	FTPConfigNameSpan.innerHTML=FTPConfigName;
	FTPConfigDescSpan.innerHTML=FTPConfigDesc;
	serverIPSpan.innerHTML=serverIP;
	serverPortSpan.innerHTML=serverPort;
	userNameSpan.innerHTML=userName;
	userPasswordSpan.innerHTML=userPassword;
	defaultRootDirSpan.innerHTML=defaultRootDir;
	maxConnCountSpan.innerHTML=maxConnCount;
	showOrderSpan.innerHTML=showOrder;
}

</script>

