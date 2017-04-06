<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ include file="/systeminfo/init.jsp" %>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%

    if(!HrmUserVarify.checkUserRight("GroupsSet:Maintenance", user)){
		response.sendRedirect("/notice/noright.jsp");
    	return;
	}

String orgGroupName = Util.null2String(request.getParameter("orgGroupName"));
String orgGroupDesc = Util.null2String(request.getParameter("orgGroupDesc"));


String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(24001, user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%


    RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javaScript:frmMain.submit(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javaScript:onAdd(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%

    String sqlwhere =" where (isDelete is null or isDelete='0') ";



    if (!"".equals(orgGroupName)) {
  	    sqlwhere = sqlwhere + " and orgGroupName like '%"+Util.toHtml100(orgGroupName)+"%'" ;
    }
    if (!"".equals(orgGroupDesc)) {
  	    sqlwhere = sqlwhere + " and orgGroupDesc like '%"+Util.toHtml100(orgGroupDesc)+"%'" ;
    }

int perpage=Util.getIntValue(request.getParameter("perpage"),0);

if(perpage<=1 )	perpage=10;
String backfields = "id,orgGroupName,orgGroupDesc,showOrder";
String fromSql  = " from HrmOrgGroup ";
String orderby = " showOrder " ;
String tableString =" <table instanceid=\"HrmOrgGroup\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
                 "	   <sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+orderby+"\" sqlprimarykey=\"id\"   sqlsortway=\"asc\" />"+
                 "			<head>"+
                 "				<col width=\"35%\"   text=\""+SystemEnv.getHtmlLabelName(24679,user.getLanguage())+"\" column=\"orgGroupName\" orderkey=\"orgGroupName\" linkvaluecolumn=\"id\" linkkey=\"id\" href=\"/hrm/orggroup/HrmOrgGroupEdit.jsp\"  target=\"_fullwindow\"/>"+
                 "				<col width=\"35%\"   text=\""+SystemEnv.getHtmlLabelName(24680,user.getLanguage())+"\" column=\"orgGroupDesc\" orderkey=\"orgGroupDesc\" />"+
                 "				<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(24662,user.getLanguage())+"\" column=\"id\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.hrm.orggroup.SptmForOrgGroup.getRelatedSetting\" linkvaluecolumn=\"id\" linkkey=\"orgGroupId\" href=\"/hrm/orggroup/HrmOrgGroupRelated.jsp\"  target=\"_fullwindow\"/>"+
                 "				<col width=\"15%\"   text=\""+SystemEnv.getHtmlLabelName(88,user.getLanguage())+"\" column=\"showOrder\" orderkey=\"showOrder\"  />"+               
                 "			</head>"+
                 " </table>";
  %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<!--add by dongping for fiveStar request-->

<form name="frmMain" method="post" action="">
	<table class="ViewForm">
	  <COLGROUP>
	  <COL width="15%">
	  <COL width="35%">
	  <COL width="15%">
	  <COL width="35%">

      <TR class=Title>
          <TH colSpan=4><%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%></TH>
      </TR>
      <TR class=Spacing style="height:2px">
          <TD class=Line1 colSpan=4 ></TD>
      </TR>

		<tr>
			<td><%=SystemEnv.getHtmlLabelName(24679,user.getLanguage())%></td>
			<td class="Field">
				<input type="text" name="orgGroupName" class="inputStyle" value=<%=orgGroupName%>>
			</td>
			<td><%=SystemEnv.getHtmlLabelName(24680,user.getLanguage())%></td>
			<td class="Field">
				<input type="text" name="orgGroupDesc" class="inputStyle" value=<%=orgGroupDesc%>>
			</td>
		</tr>
        <TR style="height:1px"><TD class=Line colSpan=4></TD></TR>   
        <tr><td colSpan=4> <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" /></td></tr>
    </table>
</form>

</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>

 
</BODY></HTML>


<script language=javascript>
function onAdd(){
	this.openFullWindowForXtable("/hrm/orggroup/HrmOrgGroupAdd.jsp");
}
</script>