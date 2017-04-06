<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CarTypeComInfo" class="weaver.car.CarTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<%
int userId=0, subCompanyId=0;
userId = user.getUID();
RecordSet.executeSql("select detachable from SystemSet");
int detachable=0;
if(RecordSet.next()){
    detachable=RecordSet.getInt("detachable");
   
}
//int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);

if(detachable==1){
subCompanyId = user.getUserSubCompany1();
}
else
{
  subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));
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

<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:weaver.reset(),_top}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top}";
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
		<FORM id=weaver NAME=frmmain STYLE="margin-bottom:0" action="CarInfoBrowser.jsp" method=post>
		<table width=100% class=ViewForm>
		<TR>
			<td width="15%">厂牌型号</td>
			<td width="35%" class=field><input class=InputStyle  name=factoryNo value="<%=factoryNo%>"></td>
			<td width="15%">车牌号</td>
			<td width="35%" class=field><input class=InputStyle  name=carNo value="<%=carNo%>"></td>
		</TR>
		<TR>
			<td width="15%">类型</td>
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
			<td width="15%">购置日期</td>
			<td width="35%" class=field>
				<%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%>&nbsp;&nbsp;
				<BUTTON type="button" class=Calendar onclick="getDate(startdatespan,startdate)"></BUTTON> 
				<SPAN id=startdatespan><%=startdate%></SPAN> 
				<input type="hidden" name="startdate" value="<%=startdate%>">
				<%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%>&nbsp;&nbsp;
				<BUTTON type="button" class=Calendar onclick="getDate(enddatespan,enddate)"></BUTTON> 
				<SPAN id=enddatespan><%=enddate%></SPAN> 
				<input type="hidden" name="enddate" value="<%=enddate%>">
			</td>
		</TR>
		<TR class=Spacing><TD class=Line1 colspan=8></TD></TR>
		</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" style="width:100%">
<TR class=DataHeader>
<TH width=20%>厂牌型号</TH>
<TH width=20%>车牌号</TH>
<TH width=20%>类型</TH>
<TH width=20%>司机</TH>
<TH width=20%>购置日期</TH>
</tr>
<TR class=Line><Th colspan="5" ></Th></TR> 
<%
int i=0;
sqlwhere = "select * from CarInfo "+sqlwhere;
RecordSet.execute(sqlwhere);
while(RecordSet.next()){
	if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
	<%
	}
	%>
	<TD style="display:none"><%=RecordSet.getString("id")%></TD>
	<TD><%=RecordSet.getString("factoryNo")%></TD>
	<TD><%=RecordSet.getString("carNo")%></TD>
	<TD><%=CarTypeComInfo.getCarTypename(RecordSet.getString("carType"))%></TD>
	<TD><%=ResourceComInfo.getResourcename(RecordSet.getString("driver"))%></TD>
	<TD><%=RecordSet.getString("buyDate")%></TD>
</TR>
<%}%>
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

<script type="text/javascript">
function BrowseTable_onmouseover(e){
	e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
}
function BrowseTable_onmouseout(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
      p=jQuery(target).parents("tr")[0];
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark"
      }else{
         p.className = "DataLight"
      }
   }
}

function BrowseTable_onclick(e){
	var e=e||event;
	var target=e.srcElement||e.target;
	if( target.nodeName =="TD"||target.nodeName =="A"  ){
		var curTr=jQuery(target).parents("tr")[0];
		window.parent.parent.returnValue = {id:jQuery(curTr.cells[0]).text(),name:(jQuery(curTr.cells[2]).text())};
		window.parent.parent.close();
	}
}

function btnclear_onclick(){
	window.parent.parent.returnValue = {id:"",name:""};
	window.parent.parent.close();
}

$(function(){
	$("#BrowseTable").mouseover(BrowseTable_onmouseover);
	$("#BrowseTable").mouseout(BrowseTable_onmouseout);
	$("#BrowseTable").click(BrowseTable_onclick);
});
</script>
<script language=javascript>
function doSearch(){
	document.frmmain.submit();
}
function submitClear(){
	btnclear_onclick();
}
</script>
</body>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>