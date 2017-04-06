<%@ page language="java" contentType="text/html; charset=gbk" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="mainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="subCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="secCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(19516,user.getLanguage());
String needfav ="1";
String needhelp ="";

String showTop = Util.null2String(request.getParameter("showTop"));

int mainId = 0, subId = 0, secId = 0, crmSecId = 0, layout = 3, perpage = 20, emlsavedays = 30 , defaulttype=1,autosavecontact=0;
String categoryPath = "", crmCategoryPath="";

rs.executeSql("SELECT * FROM SystemSet");
if(rs.next()) emlsavedays = rs.getInt("emlsavedays");

rs.executeSql("SELECT * FROM MailSetting WHERE userId="+user.getUID()+"");
if(rs.next()){
	mainId = rs.getInt("mainId");
	subId = rs.getInt("subId");
	secId = rs.getInt("secId");
	crmSecId = rs.getInt("crmSecId");
	layout = rs.getInt("layout");
	perpage = rs.getInt("perpage");
	emlsavedays = rs.getInt("emlsavedays");
	defaulttype = rs.getInt("defaulttype");
	autosavecontact = rs.getInt("autosavecontact");
	categoryPath = secId>0 ? CategoryUtil.getCategoryPath(secId) : "";
	crmCategoryPath = crmSecId>0 ? CategoryUtil.getCategoryPath(crmSecId) : "";
}
%>

<%if(showTop.equals("")) {%>
	<%@ include file="/systeminfo/TopTitle.jsp" %>
<%} else if(showTop.equals("show800")) {%>
	
<%}%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<script type="text/javascript" src="/js/weaver.js"></script>
<script type="text/javascript" src="/js/prototype.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver.css" />
<script type="text/javascript" src="/js/dojo.js"></script>

<script language="javascript">

dojo.require("dojo.widget.TabSet");
dojo.require("dojo.io.*");
dojo.require("dojo.event.*");

 function  formSubmit(){
     fMailSetting.submit();
 }
 
 
 function onSelectDocCategory(_categoryname,_secId,_mainId,_subId) {
	//window.parent.returnValue = Array(1, id, path, mainid, subid);
	var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/PermittedCategoryBrowser.jsp?operationcode=<%=AclManager.OPERATION_CREATEDOC%>");
	if(typeof result!="undefined"){
		if(result.length==2){
			jQuery("#"+_categoryname).html("");
			jQuery("input[name="+_secId+"]").val("");
			jQuery("input[name="+_mainId+"]").val("");
			jQuery("input[name="+_subId+"]").val("");
		}else{
			jQuery("#"+_categoryname).html(result[2]);
			jQuery("input[name="+_secId+"]").val(result[1]);
			jQuery("input[name="+_mainId+"]").val(result[3]);
			jQuery("input[name="+_subId+"]").val(result[4]);
		}
	}
}
 
 
</script>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:formSubmit(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table style="width:98%;height:92%;border-collapse:collapse" align="center">
<tr style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
<tr>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<!--==========================================================================================-->
<form method="post" action="MailSettingOperation.jsp" id="fMailSetting" name="fMailSetting">
<table class="ViewForm">
<colgroup>
<col width="30%">
<col width="70%">
</colgroup>
<tbody>
<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(19847,user.getLanguage())%></th>
</tr>
<tr class="Spacing" style="height:2px"><td class="Line1" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(19947,user.getLanguage())%></td>
	<td class="Field">
		<button class=browser type=button onclick="onSelectDocCategory('categoryname','secId','mainId','subId')"></button>
		<span id="categoryname"><%=categoryPath%></span>
		<%if(showTop.equals("")) {%>

		<%} else if(showTop.equals("show800")) {%>
		<input type="hidden" name="showTop" value="show800" />
		<%}%>
		<input type="hidden" name="mainId" value="<%=mainId%>" />
		<input type="hidden" name="subId" value="<%=subId%>" />
		<input type="hidden" name="secId" value="<%=secId%>" />
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(19948,user.getLanguage())%></td>
	<td class="Field">
		<button class=browser type=button onclick="onSelectDocCategory('crmCategoryName','crmSecId','crmMainId','crmSubId')"></button>
		<span id="crmCategoryName"><%=crmCategoryPath%></span>
		<input type="hidden" name="crmSecId" value="<%=crmSecId%>" />
		<input type="hidden" name="crmMainId" value="" />
		<input type="hidden" name="crmSubId" value="" />
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(19849,user.getLanguage())%></th>
</tr>
<tr class="Spacing" style="height:2px"><td class="Line1" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(19850,user.getLanguage())%></td>
	<td class="Field">
		<input type="radio" name="layout" value="1" <%if(layout==1){out.println("checked='checked'");}%> /><%=SystemEnv.getHtmlLabelName(19851,user.getLanguage())%>
		<input type="radio" name="layout" value="2" <%if(layout==2){out.println("checked='checked'");}%> 
		/><%=SystemEnv.getHtmlLabelName(20825,user.getLanguage())%>
		<input type="radio" name="layout" value="3" <%if(layout==3){out.println("checked='checked'");}%>  /><%=SystemEnv.getHtmlLabelName(19852,user.getLanguage())%>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(17491,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="perpage" class="inputstyle"  value="<%=perpage%>" />
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>

<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(21422,user.getLanguage())%></th>
</tr>
<tr class="Spacing" style="height:2px"><td class="Line1" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(21421,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" size = 5 maxlength = 4 name="emlsavedays" class="inputstyle" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("emlsavedays")' value="<%=emlsavedays%>" /><%=(" "+SystemEnv.getHtmlLabelName(1925,user.getLanguage()))%>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>

<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(31137,user.getLanguage())%></th>
</tr>
<tr class="Spacing" style="height:2px"><td class="Line1" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(31138,user.getLanguage())%></td>
	<td class="Field">
		<input type="radio" name="defaulttype" value="0" <%if(defaulttype==0){out.println("checked='checked'");}%> /><%=SystemEnv.getHtmlLabelName(24714,user.getLanguage())%>
		<input type="radio" name="defaulttype" value="1" <%if(defaulttype==1){out.println("checked='checked'");}%> /><%=SystemEnv.getHtmlLabelName(31139,user.getLanguage())%>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(31272,user.getLanguage())%></th>
</tr>
<tr class="Spacing" style="height:2px"><td class="Line1" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(31272 ,user.getLanguage())%></td>
	<td class="Field">
		<input type="checkbox"  name="autosavecontact" value="1" <%if(autosavecontact==1){out.println("checked='checked'");}%> />
		
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
</table>
</form>
<!--==========================================================================================-->
		</td>
		</tr>
		</table>
	</td>
</tr>
<tr style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
</table>