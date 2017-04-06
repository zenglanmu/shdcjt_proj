<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<%
int subCompanyId=0;
int userId = user.getUID();
int operatelevel=0;
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);

if(detachable==1){
	if(request.getParameter("subCompanyId")!=null){
		subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));
	}

	operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Car:Maintenance",subCompanyId);
}else{
	subCompanyId = -1;
    if(HrmUserVarify.checkUserRight("Car:Maintenance", user))
    	operatelevel=2;
}

String carNo = Util.null2String(request.getParameter("carNo"));
String carType = Util.null2String(request.getParameter("carType"));
String factoryNo = Util.null2String(request.getParameter("factoryNo"));
String startdate = Util.null2String(request.getParameter("startdate"));
String enddate = Util.null2String(request.getParameter("enddate"));

String sqlwhere = " where 1=1";
if(!carNo.equals("")){
	sqlwhere += " and carNo like '%"+carNo+"%'";
}
if(!carType.equals("")){
	sqlwhere += " and carType="+carType+"";
}
if(!factoryNo.equals("")){
	sqlwhere += " and factoryNo like '%"+factoryNo+"%'";
}
if(!startdate.equals("")){
	sqlwhere += " and buyDate >= '"+startdate+"'";
}
if(!enddate.equals("")){
	sqlwhere += " and buyDate <= '"+enddate+"'";
}
if(subCompanyId!=-1){
	sqlwhere += " and subCompanyId="+subCompanyId+"";
}
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int	perpage=10;
%>

<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(60,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(20316,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(subCompanyId!=0){
	if(operatelevel>0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(20317,user.getLanguage())+",CarInfoAdd.jsp?subCompanyId="+subCompanyId+",_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	if(operatelevel>-1){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
}
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
		<FORM id=weaver NAME=frmmain STYLE="margin-bottom:0" action="CarInfoMaintenance.jsp" method=post>
		<input type="hidden" name="subCompanyId" value="<%=subCompanyId%>">
		<table width=100% class=ViewForm>
		<TR>
			<td width="15%"><%=SystemEnv.getHtmlLabelName(20318,user.getLanguage())%></td>
			<td width="35%" class=field><input class=InputStyle  name=factoryNo value="<%=factoryNo%>"></td>
			<td width="15%"><%=SystemEnv.getHtmlLabelName(20319,user.getLanguage())%></td>
			<td width="35%" class=field><input class=InputStyle  name=carNo value="<%=carNo%>"></td>
		</TR>
		<TR  style="height:2px"><TD class=Line colspan="4"></TD></TR>
		<TR>
			<td width="15%"><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
			<td width="35%" class=field>
				<select name="carType">
					<option value="">
          			<%
          			RecordSet.executeProc("CarType_Select","");
          			while(RecordSet.next()){
          			%>
          			<option value="<%=RecordSet.getString("id")%>" <%if(carType.equals(RecordSet.getString("id"))){%>selected<%}%>><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%>
          			<%}%>
				</select>
			</td>
			<td width="15%"><%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%></td>
			<td width="35%" class=field>
				<%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%>&nbsp;&nbsp;
				<input name="startdate" type="hidden" class=wuiDate  ></input>
				<%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%>&nbsp;&nbsp;
				<input name="enddate" type="hidden" class=wuiDate />
			</td>
		</TR>
		<TR class=Spacing><TD class=Line1 colspan=8></TD></TR>
		</table>
		<TABLE width="100%">
			<tr>
				<td valign="top">
		        	<%
		            String backfields = "id, factoryNo, carNo, carType, driver, buyDate ";
		            String fromSql  = " from CarInfo ";
		            String sqlWhere = sqlwhere;
		            String orderby = "id" ;
		            String tableString = "";
		            tableString =" <table instanceid=\"CarTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
		                                     "		<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"desc\" sqlisdistinct=\"true\"/>"+
		                                     "		<head>"+
		                                     "			<col width=\"17%\"  text=\""+SystemEnv.getHtmlLabelName(20318,user.getLanguage())+"\" column=\"factoryNo\" orderkey=\"factoryNo\" />"+
		                                     "			<col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(20319,user.getLanguage())+"\" column=\"carNo\"  orderkey=\"carNo\" linkvaluecolumn=\"id\" linkkey=\"id\" href=\"/car/CarInfoView.jsp?fg=1&amp;flag=1\" target=\"_self\"/>"+
		                                   	 "			<col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"carType\" orderkey=\"carType\" transmethod=\"weaver.car.CarTypeComInfo.getCarTypename\" />"+
		                                   	 "			<col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(17649,user.getLanguage())+"\" column=\"driver\"  orderkey=\"driver\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" />"+
		                      				 "			<col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(16914,user.getLanguage())+"\" column=\"buyDate\"  orderkey=\"buyDate\" />"+
		                                     "		</head>"+
											 "		<operates width=\"15%\">";
					if(operatelevel>0){
						tableString +=		 "    		<operate href=\"javascript:doEdit()\"  text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>";
					}
					if(operatelevel>1){
						tableString +=		 "    		<operate href=\"javascript:doDel()\"  text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\"  index=\"1\"/>";
					}
						tableString +=		 "		</operates>"+
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
<script language=javascript>
function doSearch(){
	document.frmmain.submit();
}
function doEdit(id){
	document.frmmain.action="CarInfoEdit.jsp?id="+id;
	document.frmmain.submit();
}
function doDel(id){
	if(isdel()){
		document.frmmain.action="CarInfoOperation.jsp?operation=del&id="+id;
		document.frmmain.submit();
	}
}
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
</html>