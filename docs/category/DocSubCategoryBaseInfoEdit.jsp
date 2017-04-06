<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>

<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryManager" class="weaver.docs.category.SubCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
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
String categoryname=SubCategoryComInfo.getSubCategoryname(""+id);
categoryname = categoryname.replaceAll("&nbsp","&amp;nbsp").replaceAll("\''","\'");
String coder = SubCategoryComInfo.getCoder(""+id);
int noRepeatedName = Util.getIntValue(SubCategoryComInfo.getNoRepeatedName(""+id),0);
int mainid=Util.getIntValue(SubCategoryComInfo.getMainCategoryid(""+id),0);
int fathersubid = Util.getIntValue(SubCategoryComInfo.getFatherSubCategoryid(""+id),-1);
int messageid = Util.getIntValue(request.getParameter("message"),0);
int errorcode = Util.getIntValue(request.getParameter("errorcode"),0);
RecordSet.executeSql("select suborder from DocSubCategory where id = "+id);
RecordSet.next();
float suborder = RecordSet.getFloat("suborder");//顺序
RecordSet.executeSql(" select norepeatedname from DocMainCategory where id = " + mainid);
RecordSet.next();
if(Util.getIntValue(RecordSet.getString("norepeatedname"),0)==1) noRepeatedName = 11;

boolean canEdit = false;
boolean canAdd = false;
boolean canDelete = false;
boolean canLog = false;
boolean hasSubManageRight = false;
AclManager am = new AclManager();

/* 以下通过结合旧类型的edit权限和新类型的CREATEDIR权限来设定是否可以编辑 */
//hasSubManageRight = am.hasPermission(id, AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR);
hasSubManageRight = am.hasPermission(mainid, AclManager.CATEGORYTYPE_MAIN, user, AclManager.OPERATION_CREATEDIR);
if (HrmUserVarify.checkUserRight("DocSubCategoryEdit:edit", user) || hasSubManageRight) {
    canEdit = true;
}
boolean hasSecManageRight = am.hasPermission(id, AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR);;
//if (HrmUserVarify.checkUserRight("DocSubCategoryAdd:add", user)) {
//    canAdd = true;
//} else {
//    if (fathersubid < 0) {
//        canAdd = am.hasPermission(mainid, AclManager.CATEGORYTYPE_MAIN, user, AclManager.OPERATION_CREATEDIR);
//    } else {
//        canAdd = am.hasPermission(fathersubid, AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR);
//    }
//}

if (HrmUserVarify.checkUserRight("DocSubCategoryAdd:add", user) || hasSubManageRight) {
    canAdd = true;
}

if (HrmUserVarify.checkUserRight("DocSubCategoryEdit:Delete", user) || hasSubManageRight) {
    canDelete = true;
}
if (HrmUserVarify.checkUserRight("DocSubCategory:log", user) || hasSubManageRight) {
    canLog = true;
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(66,user.getLanguage())+":"+categoryname;
String needfav ="1";
String needhelp ="";
CategoryManager cm = new CategoryManager();
%>
<BASE TARGET="_parent">
<BODY>


<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
//if(HrmUserVarify.checkUserRight("DocSubCategoryEdit:Edit", user)){
if (canEdit) {
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(canAdd){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(66,user.getLanguage())+",javascript:onNew(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("DocSecCategoryAdd:add", user) ||hasSecManageRight){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(67,user.getLanguage())+",javascript:onNewSec(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(canDelete){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(canLog){
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
<%
if(errorcode == 10) {
%>
<div><font color="red"><%=SystemEnv.getHtmlLabelName(21999,user.getLanguage()) %></font></div>
<%}%>

<iframe name="DocFTPConfigInfoGetter" style="width:100%;height:200;display:none"></iframe>

<FORM id=weaver name=frmMain action="SubCategoryOperation.jsp" method=post>
<DIV>

<TABLE class=ViewForm>
 
  <TBODY>
  <TR>
    <TD vAlign=top >
      <TABLE class=ViewForm>
	  <COLGROUP>
	  <COL width="20%">
	  <COL width="80%">
        <TBODY>
        <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
            <td align=right>
                <A href="DocMainCategory.jsp" target="mainFrame"><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></A> >
            	<A href="DocMainCategoryEdit.jsp?id=<%=mainid%>"><%=MainCategoryComInfo.getMainCategoryname(""+mainid)%></A>
<%              RecordSet rs = cm.getSuperiorSubCategoryList(id, AclManager.CATEGORYTYPE_SUB);
                while (rs.next()) {         %>
                     >
                    <A href="DocSubCategoryEdit.jsp?id=<%=rs.getInt("subcategoryid")%>"><%=Util.toScreen(rs.getString("subcategoryname"), user.getLanguage())%></A>
<%              }                           %>
            </td>

          </TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=hidden name="id" value="<%=id%>"><%=MainCategoryComInfo.getMainCategoryname(""+mainid)%></TD>
        </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
<%      if (fathersubid >= 0) {   %>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())+SystemEnv.getHtmlLabelName(66,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=hidden name="subid" value="<%=fathersubid%>"><%=SubCategoryComInfo.getSubCategoryname(""+fathersubid)%></TD>
        </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
<%      }                   %>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=hidden name="mainid" value="<%=mainid%>"><%=id%></TD>
        </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><INPUT class=InputStyle maxLength=100 size=60 name="categoryname" value="<%=categoryname%>"
          onChange="checkinput('categoryname','categorynamespan')"><%}else{%><%=categoryname%><%}%>
          <span id=categorynamespan><%if(categoryname.equals("")){%><IMG src="../../images/BacoError.gif" align=absMiddle><%}%></span>
          <INPUT type=hidden maxLength=60 size=50 name="srccategoryname" value="<%=categoryname%>">
          </TD>
        </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(19388,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><INPUT maxLength=50 size=30 class=InputStyle name="coder" value="<%=coder%>"><%}else{%><%=coder%><%}%></TD>
         </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><INPUT maxLength=5 size=5 class=InputStyle name="suborder" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("suborder")' value="<%=suborder%>"><%}else{%><%=suborder%><%}%></TD>
         </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
		
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(19449,user.getLanguage())%></TD>
          <TD class=Field><INPUT type="checkbox" class=InputStyle name="norepeatedname" value="1" <%if(noRepeatedName==1){%>checked<%}%> <%if(noRepeatedName==11){%>checked disabled<%}%> <%if(!canEdit){%>disabled<%}%>></TD>
         </TR>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
				
        </TBODY></TABLE>

<%
	String isUseFTPOfSystem=BaseBean.getPropValue("FTPConfig","ISUSEFTP");
	if("1".equals(isUseFTPOfSystem)){
		String refreshSec="1";
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

		RecordSet.executeSql("select * from DocSubCatFTPConfig where subCategoryId=" + id);
		if(RecordSet.next()){
			refreshSec = Util.null2String(RecordSet.getString("refreshSec"));
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
		    userPassword="●●●●●●";
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
            <TH>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<INPUT type="checkbox" name="refreshSec" value="1" <%if(!refreshSec.equals("0")){%>checked<%}%> <%if(!canEdit){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(22518,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing>
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


		</TD>

        </TR></TBODY></TABLE>

<input type=hidden name="operation">
<!-- 分目录列表 -->
<!-- 因多级目录还未做完, 这里将分目录列表和在分目录下创建分目录屏蔽, 谭小鹏 2003-06-17
<TABLE class=ListStyle>
  <COLGROUP>
	<COL width="30%">
	<COL width="70%">
  <TBODY>
  <TR class=Title>
    <TD><B><%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%></B></TD>
    <TD align=right><A
      href="DocSubCategoryAdd.jsp?id=<%=mainid%>&subid=<%=id%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></A></TD></TR>
  <TR class=Spacing>
    <TD class=Sep2 colSpan=2></TD></TR>
  <TR class=Header>
      <TD colSpan=2><%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%></TD>
    </TR>
    <%
  SubCategoryManager.selectCategoryInfo(id);
  int i=0;
  while(SubCategoryManager.next()){
  	int subid = SubCategoryManager.getCategoryid();
  	String name = SubCategoryManager.getCategoryname();
  	if(i==0){
  		i=1;
  %>
  <TR class=datalight>
  <%}else{
  		i=0;
  %>
  <TR class=datadark>
  <% }%>
  <td><%=subid%></td>
  <td> <a href="DocSubCategoryEdit.jsp?id=<%=subid%>"><%=name%></a></td></tr>
  <%
  }
  SubCategoryManager.closeStatement();
  %>
</TBODY></TABLE>
-->
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
	<COL width="30%">
	<COL width="30%">
	<COL width="40%">
  <TBODY>
  <TR class=header>
    <TD><B><%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%></B></TD>
    <TD align=right colspan = 2>
        <%if(HrmUserVarify.checkUserRight("DocSecCategoryAdd:add", user)){%><A href="DocSecCategoryAdd.jsp?id=<%=id%>&mainid=<%=mainid%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></A><%}%></TD></TR>
  <TR class=Header>
      <TD><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD>
      <TD><%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%></TD>
      <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
    </TR>
<TR class=Line style="height: 1px!important;"><TD colSpan=3></TD></TR>
    <%
SecCategoryManager.setSubcategoryid(id);
SecCategoryManager.selectCategoryInfo();
  i=0;
  while(SecCategoryManager.next()){
  	int secid = SecCategoryManager.getId();
  	String name = SecCategoryManager.getCategoryname();
  	name = name.replaceAll("&nbsp","&amp;nbsp").replaceAll("\''","\'");
  	float secorder = SecCategoryManager.getSecorder();
  	if(i==0){
  		i=1;
  %>
  <TR class=datalight>
  <%}else{
  		i=0;
  %>
  <TR class=datadark>
  <% }%>
  <td><%=secid%><input type=hidden name=secid value="<%=secid%>"></td>
  <td> <a href="DocSecCategoryEdit.jsp?id=<%=secid%>"><%=name%></a></td>
  <td class = field><input maxLength=5 size=5 class=InputStyle name="secorder" onKeyPress="ItemNum_KeyPress()" <%if(!canEdit) out.println("disabled");%> onBlur='check_number("secorder")' value="<%=secorder%>"></td>
  </tr>
  <%
  }
  SecCategoryManager.closeStatement();
  %>
</TBODY></TABLE>
</FORM>


</BODY></HTML>
<script>
function onNew(){
	window.parent.location="DocSubCategoryAdd.jsp?id=<%=mainid%>";
}
function onNewSec(){
	window.parent.location="DocSecCategoryAdd.jsp?id=<%=id%>&mainid=<%=mainid%>";
}
function onLog(){
	window.parent.location="/systeminfo/SysMaintenanceLog.jsp?secid=66&sqlwhere=where operateitem=2 and relatedid=<%=id%>";
}
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

