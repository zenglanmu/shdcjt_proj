<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>

<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="DocFTPConfigComInfo" class="weaver.docs.category.DocFTPConfigComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
<script language=javascript >
function checkSubmit(){
    if(check_form(weaver,'categoryname')){
        weaver.submit();
    }
}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(66,user.getLanguage());
String needfav ="1";
String needhelp ="";
CategoryManager cm = new CategoryManager();
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%
int mainid = Util.getIntValue(request.getParameter("id"),0);
/* 上级分目录id */
int subid = Util.getIntValue(request.getParameter("subid"), -1);

int errorcode = Util.getIntValue(request.getParameter("errorcode"),0);

AclManager am = new AclManager();
if (subid < 0) {
    if(!HrmUserVarify.checkUserRight("DocSubCategoryAdd:add", user) && !am.hasPermission(mainid, AclManager.CATEGORYTYPE_MAIN, user, AclManager.OPERATION_CREATEDIR)){
        		response.sendRedirect("/notice/noright.jsp");
        		return;
    }
} else {
    if(!HrmUserVarify.checkUserRight("DocSubCategoryAdd:add", user) && !am.hasPermission(subid, AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR)){
        		response.sendRedirect("/notice/noright.jsp");
        		return;
    }
}
%>


<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

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

<iframe name="DocFTPConfigInfoGetter" style="width:100%;height:200;display:none"></iframe>

<FORM id=weaver action="SubCategoryOperation.jsp" method=post >
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="100%">
  <TBODY>
  <TR>
    <TD vAlign=top>
      <TABLE class=ViewForm>
      <COLGROUP>
  	<COL width="20%">
  	<COL width="80%">
        <TBODY>
          <TR class=Title>
          <th colspan=2>
            <%if(errorcode == 10){%>
            	<div><font color="red"><%=SystemEnv.getHtmlLabelName(21999,user.getLanguage()) %></font></div>
            <%}%>
          </th></tr>
        <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(95,user.getLanguage())%></TH>
            <td align="right">
            <A href="DocMainCategory.jsp" target="mainFrame"><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></A> >
            	<A href="DocMainCategoryEdit.jsp?id=<%=mainid%>"><%=MainCategoryComInfo.getMainCategoryname(""+mainid)%></A>
<%              if (subid > 0) {
                RecordSet rs = cm.getSuperiorSubCategoryList(subid, AclManager.CATEGORYTYPE_SUB);
                while (rs.next()) {         %>
                     >
                    <A href="DocSubCategoryEdit.jsp?id=<%=rs.getInt("subcategoryid")%>"><%=Util.toScreen(rs.getString("subcategoryname"), user.getLanguage())%></A>
<%              }                           %>
                     >
                    <A href="DocSubCategoryEdit.jsp?id=<%=subid%>"><%=SubCategoryComInfo.getSubCategoryname(""+subid)%></A>
<%              }                           %>
            </td>
          </TR>
        <TR class=Spacing style="height: 1px!important;">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></TD>
          <TD class=Field><%=MainCategoryComInfo.getMainCategoryname(""+mainid)%><INPUT type=hidden value="<%=mainid%>" name="maincategoryid"></TD>
        </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
<%      if (subid >= 0) {   %>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())+SystemEnv.getHtmlLabelName(66,user.getLanguage())%></TD>
          <TD class=Field><%=SubCategoryComInfo.getSubCategoryname(""+subid)%><INPUT type=hidden value="<%=subid%>" name="subcategoryid"></TD>
        </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
<%      }                   %>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=60 name="categoryname" temptitle="<%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%>" onChange="checkinput('categoryname','categorynamespan')">
          <INPUT type=hidden size=60 name="srccategoryname" >
          <SPAN id=categorynamespan><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
         </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(19388,user.getLanguage())%></TD>
          <TD class=Field><INPUT maxLength=50 size=30 class=InputStyle name="coder" value=""></TD>
         </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
          <TD class=Field><INPUT maxLength=5 size=5 class=InputStyle name="suborder" onKeyPress="ItemNum_KeyPress()" onBlur='check_number("suborder")'></TD>
         </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>

        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(19449,user.getLanguage())%></TD>
          <TD class=Field><INPUT type="checkbox" class=InputStyle name="norepeatedname" value="1"></TD>
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

        boolean canEdit = false;
		if(HrmUserVarify.checkUserRight("DocSubCategoryEdit:Edit", user)){
			canEdit = true;
		}

		String refreshSubAndSec="";
		RecordSet.executeSql("select * from DocMainCatFTPConfig where mainCategoryId=" + mainid);
		if(RecordSet.next()){
			refreshSubAndSec = Util.null2String(RecordSet.getString("refreshSubAndSec"));
			if(refreshSubAndSec.equals("1")){
				isUseFTP = Util.null2String(RecordSet.getString("isUseFTP"));
			    FTPConfigId = Util.getIntValue(RecordSet.getString("FTPConfigId"),0);
			}
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
		</TD>
    </TR></TBODY></TABLE>
          <input type=hidden value="add" name="operation">
</FORM>

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

</BODY></HTML>


<script language=javascript >
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