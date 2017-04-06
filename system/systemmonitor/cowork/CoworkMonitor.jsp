<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<script type="text/javascript" src="/js/jquery/jquery.js"></script>
<script type="text/javascript" src="/cowork/js/cowork.js"></script>
<%
if(!HrmUserVarify.checkUserRight("collaborationmanager:edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}


String name = Util.null2String(request.getParameter("name"));
String creater = Util.null2String(request.getParameter("creater"));
String typeid = Util.null2String(request.getParameter("typeid"));
String begindate = Util.null2String(request.getParameter("begindate"));
String enddate = Util.null2String(request.getParameter("enddate"));
String status = Util.null2String(request.getParameter("status"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));

if(!name.equals("")){
	sqlwhere += " and t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
}
if(!creater.equals("")){
	sqlwhere += " and t1.creater = "+ creater;
}
if(!typeid.equals("")){
	sqlwhere += " and t1.typeid = "+ typeid;
}
if(!begindate.equals("")){
	sqlwhere += " and t1.begindate >= '"+begindate+"'";
}
if(!enddate.equals("")){
	sqlwhere += " and t1.enddate <= '"+enddate+"'";
}
if(!status.equals("")){
	sqlwhere += " and t1.status =" + status +" " ;
}
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteCowork(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(405,user.getLanguage())+",javascript:endCowork(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if(RecordSet.getDBType().equals("db2")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=90,_self} " ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=90,_self} " ;
}
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100%  border="0" cellspacing="0" cellpadding="0">
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

<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="CoworkMonitor.jsp" method=post>
<input type=hidden id="operation" name=operation value="deletecowork">
<input type=hidden name=deletecoworkid id="deletecoworkid" value="">
<input type=hidden name=coworkids value="" id="coworkids">
<table class=ViewForm>
  <colgroup>
  <col width="10%">
  <col width="20%">
  <col width="5%">
  <col width="10%">
  <col width="20%">
  <col width="5%">
  <col width="10%">
  <col width="20">
  <tbody>
    <tr>
		<td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
		<td class="field">
     		<input type="text"  class=InputStyle  name="name" value="<%=name%>">
		</td>
		<td>&nbsp;</td>
		<td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
		<td class=field>
			<BUTTON type="button" class=Browser id=SelectCreaterID onClick="onShowResourceOnly('creater','createrspan')"></BUTTON> 
			<span id=createrspan><%if(!"".equals(creater)){%><a href="/hrm/resource/HrmResource.jsp?id=<%=creater%>"><%=ResourceComInfo.getResourcename(creater)%></a><%}%></span> 
			<INPUT type=hidden id=creater name=creater value="<%=creater%>">
		</td>
		<td>&nbsp;</td>
		<td><%=SystemEnv.getHtmlLabelName(17694,user.getLanguage())%></td>
		<td class=field>
			<select name="typeid" size=1 style="width:80%">
				<option value="">&nbsp;</option>
				<%
				String typesql="select * from cowork_types" ;
				RecordSet.executeSql(typesql);
				while(RecordSet.next()){
					String tmptypeid=RecordSet.getString("id");
					String typename=RecordSet.getString("typename");
	        	%>
				<option value="<%=tmptypeid%>" <%if(typeid.equals(tmptypeid)){%>selected<%}%>><%=typename%></option>
	        	<%}%>
	        </select>
        </td>
	</tr>
	<TR style="height: 1px"><TD class=Line colSpan=8></TD></TR>
	<tr>
		<TD><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TD>
		<TD class=Field>
			<BUTTON type="button" class=Calendar onclick="getDate(begindatespan,begindate)"></BUTTON> 
			<SPAN id=begindatespan><%=begindate%></SPAN> 
			<input type="hidden" name="begindate" id="begindate" value="<%=begindate%>">
		</TD>  
		<td>&nbsp;</td>
		<TD><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></TD>
		<TD class=Field>
			<BUTTON type="button" class=Calendar onclick="getDate(enddatespan,enddate)"></BUTTON> 
			<SPAN id=enddatespan><%=enddate%></SPAN> 
			<input type="hidden" name="enddate" id="enddate" value="<%=enddate%>">
		</TD>
		<td>&nbsp;</td>
		<td><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
		<td class=field>
			<select name=status>
				<option value="">&nbsp;</option>
				<option value="1" <%if("1".equals(status)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
				<option value="2" <%if("2".equals(status)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%></option>
			</select>
		</td>
	</tr>
	<TR style="height: 1px"><TD class=Line colSpan=8></TD></TR>
	</tbody>
</table>

<TABLE width="100%">
	<tr>
		<td valign="top">
		<%
            String backfields = "t1.id,t1.name,t1.creater,t1.typeid,t2.typename,t1.status,t1.begindate,t1.enddate";
            String fromSql  = " from cowork_items t1,cowork_types t2";
            String sqlWhere = " where t1.typeid=t2.id"+sqlwhere;
            String orderby = "" ;
            int	perpage=10;
            String tableString = "<table tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
                                 "	  <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"desc\" sqlisdistinct=\"true\"/>"+
                                 "    <head>"+
                                 "		  <col width=\"10%\"  text=\"ID"+"\" column=\"id\" orderkey=\"t1.id\" />"+
                                 "		  <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(344,user.getLanguage())+"\" column=\"name\"  orderkey=\"name\" />"+
                                 "		  <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"creater\"  transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" />"+
                                 "		  <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(17694,user.getLanguage())+"\" column=\"typename\"  orderkey=\"typename\" />"+
                      			 "		  <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(742,user.getLanguage())+"\" column=\"begindate\"  orderkey=\"begindate\" />"+
                      			 "		  <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(743,user.getLanguage())+"\" column=\"enddate\"  orderkey=\"enddate\" />"+
                      			 "		  <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"status\"  orderkey=\"status\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.cowork.CoworkItemsVO.getTransStatus\"/>"+
                                 "	  </head>"+
                                 "</table>";
		%>
		<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
		</td>
	</tr>
</TABLE>
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
<SCRIPT LANGUAGE=VBS>
sub onShowCreaterID()
	id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id1)) then
		if id1(0)<> "" then
			createrspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id1(0)&"'>"&id1(1)&"</A>"
			weaver.creater.value=id1(0)
		else 
			createrspan.innerHtml = ""
			weaver.creater.value=""
		end if
	end if
end sub
</SCRIPT>
<script language="javascript">

function doSearch(){
   jQuery("#weaver").submit();
}


//删除协作
function deleteCowork(){
	if(isdel()) {
	    jQuery("#deletecoworkid").val(_xtable_CheckedCheckboxId());
		//document.weaver.deletecoworkid.value=_xtable_CheckedCheckboxId();
		jQuery("#weaver").attr("action",'/system/systemmonitor/MonitorOperation.jsp');
        //document.weaver.action='/system/systemmonitor/MonitorOperation.jsp';
        jQuery("#weaver").submit();
	}
}
//结束协作
function endCowork(){
    if(_xtable_CheckedCheckboxId()!=""){
       jQuery("#operation").val("endCowork");
       var coworkids=_xtable_CheckedCheckboxId();
       coworkids=coworkids.substring(0,coworkids.length-1);
       jQuery("#coworkids").val(coworkids);
       jQuery("#weaver").attr("action",'/system/systemmonitor/MonitorOperation.jsp');
       jQuery("#weaver").submit();
    }    
}
</script>
</BODY>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
