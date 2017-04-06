<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>

<style type="text/css">
#departmentid, #country1 {
	width:100%;
}
</style>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String currUserId = String.valueOf(user.getUID());  //用户ID
String currUserType = user.getLogintype();  //用户类型
String from=Util.null2String(request.getParameter("from"));
String planName = Util.null2String(request.getParameter("planname"));  //日程名
String urgentLevel = Util.null2String(request.getParameter("urgentlevel"));  //紧急程度
String planType = Util.null2String(request.getParameter("plantype"));  //日程类型
String planStatus = Util.null2String(request.getParameter("planstatus"));  //状态  0：代办；1：完成；2、归档
String createrId = Util.null2String(request.getParameter("createrid"));  //提交人
String receiveID = Util.null2String(request.getParameter("receiveID"));  //接收ID
String beginDate = Util.null2String(request.getParameter("begindate"));  //开始日期
String endDate = Util.null2String(request.getParameter("enddate"));  //结束日期
String beginDate2 = Util.null2String(request.getParameter("begindate2"));  //开始日期
String endDate2 = Util.null2String(request.getParameter("enddate2"));  //结束日期

if("".equals(from)){
	createrId=currUserId;
}
if("".equals(from)){
	receiveID=currUserId;
}
if("".equals(receiveID)&&receiveID.indexOf(",")==0){
	receiveID=receiveID.substring(1).trim();
}
if(!"".equals(receiveID)&&receiveID.lastIndexOf(",")+1==receiveID.length()){
	receiveID=receiveID.substring(0,receiveID.length()-1).trim();
}
Calendar thisCalendar = Calendar.getInstance(); //当前日期
String today=Util.add0(thisCalendar.get(Calendar.YEAR),4)+"-"+Util.add0(thisCalendar.get(Calendar.MONTH)+1,2)+"-"+Util.add0(thisCalendar.get(Calendar.DAY_OF_MONTH),2);
beginDate="".equals(from)?today:beginDate;
endDate="".equals(from)?today:endDate;
endDate2="".equals(from)?today:endDate2;
beginDate2="".equals(from)?today:beginDate2;

StringBuffer sqlbuf=new StringBuffer();
sqlbuf.append("SELECT id,name,createrid,begindate,begintime,enddate,endtime,resourceid,description FROM (SELECT workPlan. *, ");
sqlbuf.append(" workPlanType.workPlanTypeColor,workPlanType.workPlanTypeID FROM WorkPlan workPlan  , WorkPlanType workPlanType WHERE ");
if("".equals(planStatus)){
	sqlbuf.append(" (workPlan.status = 0 OR workPlan.status = 1 OR workPlan.status = 2) ");
}else{
	sqlbuf.append("workPlan.status ="+planStatus);
}

sqlbuf.append(" AND workPlan.deleted <> 1 AND workPlan.type_n = workPlanType.workPlanTypeId AND workPlan.createrType = '1' ");
sqlbuf.append("	AND ((workPlan.beginDate >= '");
sqlbuf.append(beginDate);
sqlbuf.append("' AND workPlan.beginDate <= '");
sqlbuf.append(endDate);
sqlbuf.append("')	OR (workPlan.endDate >= '");
sqlbuf.append(beginDate);
sqlbuf.append("' AND workPlan.endDate <= '");
sqlbuf.append(endDate);
sqlbuf.append("')   OR ((workPlan.endDate IS NULL OR workPlan.endDate = ''))");
sqlbuf.append(")) A LEFT JOIN (SELECT workPlanShareDetail.workId , max (shareLevel) shareLevel FROM WorkPlanShareDetail workPlanShareDetail ");
sqlbuf.append("	WHERE workPlanShareDetail.userId = ");
sqlbuf.append(currUserId);
sqlbuf.append(" AND workPlanShareDetail.userType = 1 GROUP BY workPlanShareDetail.workId) B ");
sqlbuf.append("	 ON A.id = B.workId WHERE shareLevel>1 ");
sqlbuf.append("  and name like '%"+planName+"%' " );
if(!"".equals(createrId)){
	sqlbuf.append( " and A.createrid= '");
	sqlbuf.append(createrId);
	sqlbuf.append("'");
}
if(!"".equals(receiveID)){
	sqlbuf.append("and(( a.resourceid like ',"+receiveID+"%' or a.resourceid like '"+receiveID+"%')");
	sqlbuf.append("or ( a.resourceid like '%,"+receiveID+",%')");
	sqlbuf.append("or ( a.resourceid like '%"+receiveID+"' or a.resourceid like '%"+receiveID+",')) ");
}
if(!"".equals(urgentLevel)){
	sqlbuf.append(" and a.urgentLevel = '"+urgentLevel+"'");
}
if(!"".equals(planType)){
	sqlbuf.append(" and a.workplantypeid = '"+planType+"'");
}
sqlbuf.append(" order by begindate");
System.out.println(sqlbuf.toString());
RecordSet.executeSql(sqlbuf.toString());
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	
	<td valign="top">
		<!--########Shadow Table Start########-->
<TABLE class=Shadow>
		<tr style="height:1px;">
		<td valign="top" colspan="2">
		
		<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="?from=1#" method=post>
		<DIV align=right style="display:none">
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>


			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btn accessKey=O id=btnok onclick="btnok_onclick(event)"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>

			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.close(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>


			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btn accessKey=2 id=btnclear onclick="btnclear_onclick(event);"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
			</DIV>
<table width=100% class=ViewForm valign="top">
	<TR class=Spacing style="height:1px;"><TD class=Line1 colspan=4></TD></TR>
	<TR>
		<TD width=15%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
		<TD class="Field"><INPUT class="InputStyle" maxlength="100" size="30" name="planname" value="<%=planName %>"></TD>
		<TD><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></TD>
									<TD class="Field">
							    		<SELECT name="urgentlevel">
											<OPTION value="" <%if("".equals(urgentLevel)){ %> selected<%} %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
											<OPTION value="1" <%if("1".equals(urgentLevel)){ %> selected<%} %>><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></OPTION>
											<OPTION value="2" <%if("2".equals(urgentLevel)){ %> selected<%} %>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></OPTION>
											<OPTION value="3" <%if("3".equals(urgentLevel)){ %> selected<%} %>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></OPTION>
										</SELECT>
									</TD>
	</TR>
	<tr style="height:1px;">
		<td class="Line" colspan="4"></td>
	</tr>
	<TR>
		<TD><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></TD>
	 	<TD class="Field">								 										 									 	
		  	<INPUT type="hidden" name="createrid" class="wuiBrowser"
		  		value="<%=createrId %>" _displayText="<%=ResourceComInfo.getLastname(createrId) %>"
		  		_displayTemplate="<A href=/hrm/resource/HrmResource.jsp?id=#b{id}>#b{name}</A>"
		  		_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
		  		>
		</TD>
		<TD width="15%"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
		<TD width="35%" class="Field">
			<SELECT name="planstatus">
				<OPTION value="" <%if("".equals(planStatus)){ %> selected<%} %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
				<OPTION value="0" <%if("0".equals(planStatus)){ %> selected<%} %>><%=SystemEnv.getHtmlLabelName(16658,user.getLanguage())%></OPTION>
				<OPTION value="1" <%if("1".equals(planStatus)){ %> selected<%} %>><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></OPTION>
				<OPTION value="2" <%if("2".equals(planStatus)){ %> selected<%} %>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></OPTION>		
			</SELECT>
		</TD>
	</TR>
	<tr style="height:1px;">
		<td class="Line" colspan="4"></td>
	</tr>
	<tr>
		<TD><%=SystemEnv.getHtmlLabelName(896,user.getLanguage())%></TD>
		<TD class="Field">
			<INPUT type=hidden name=receiveType value="1" />
			<INPUT type="hidden" name="receiveID" class="wuiBrowser" value="<%=receiveID %>"
				_displayText="<%=ResourceComInfo.getLastname(receiveID) %>"
		  		_displayTemplate="<A href=/hrm/resource/HrmResource.jsp?id=#b{id}>#b{name}</A>"
		  		_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp">									
		</TD>
		<TD><%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%></TD>
		<TD class="Field">
			<SELECT name="plantype">
				<OPTION value="" <%if("".equals(planType)){ %> selected<%} %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>											
				<%
		  			rs.executeSql("SELECT * FROM WorkPlanType ORDER BY displayOrder ASC");
		  			while(rs.next())
		  			{
		  		%>
		  			<OPTION value="<%= rs.getInt("workPlanTypeID") %>" <%if(rs.getString("workPlanTypeID").equals(planType)){ %> selected<%} %>><%= rs.getString("workPlanTypeName") %></OPTION>
		  		<%
		  			}
		  		%>
			</SELECT>
		</TD>
	</tr>
	<tr style="height:1px;">
		<td class="Line" colspan="4"></td>
	</tr>
	<!--================== 开始日期  ==================-->
	<TR>
		<TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TD>
	  	<TD class="Field">
			<button type="button" class="Calendar" id="SelectBeginDate" onclick="getDate(begindatespan,begindate)"></BUTTON> 
		  	<SPAN id="begindatespan"><%=beginDate %></SPAN> 
	  		<INPUT type="hidden" name="begindate" value="<%=beginDate %>">  
		</TD>
		<TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
	  	<TD class="Field">
			<button type="button" class="Calendar" id="SelectBeginDate2" onclick="getDate(endDateSpan,enddate)"></BUTTON> 
		  	<SPAN id="endDateSpan"><%=endDate %></SPAN> 
	  		<INPUT type="hidden" name="enddate" value="<%=endDate %>">  
	  		
		</TD>
	</TR>
	
	<TR class=Spacing style="height:1px;"><TD class=Line1 colspan=4></TD></TR>
</table>
<!--#################Search Table END//######################-->
<tr width="100%">
<td width="60%" valign="top">
	<!--############Browser Table START################-->
	<TABLE class=BroswerStyle cellspacing="0" cellpadding="0" style="width:100%;">
		<TR class=DataHeader>
			<TH  style="display:none;"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
			<TH style="width:30%"><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TH>      
			<TH style="width:20%"><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></TH>
			<TH style="width:25%"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TH>
			<TH style="width:25%"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></TH>
			<TH style="width:18px;padding:0;">&nbsp;</TH>
		</tr>

		<tr>
		<td colspan="6" width="100%" height="260px">
			<div style="overflow-y:scroll;width:100%;height:260px;padding:0;">
			<table width="100%" id="BrowseTable"  style="width:100%;">
				<%

				int i=0;
				int totalline=1;
				if(RecordSet.last()){
					do{
					String ids = RecordSet.getString("id");
					String names = Util.toScreen(RecordSet.getString("name"),user.getLanguage());
					String createrid = Util.toScreen(RecordSet.getString("createrid"),user.getLanguage());
					String begindate= Util.toScreen(RecordSet.getString("begindate"),user.getLanguage());
					String begintime= Util.toScreen(RecordSet.getString("begintime"),user.getLanguage());
					String enddate= Util.toScreen(RecordSet.getString("enddate"),user.getLanguage());
					String endtime= Util.toScreen(RecordSet.getString("endtime"),user.getLanguage());
					String description=Util.toScreen(RecordSet.getString("description"),user.getLanguage());
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
					<TD style="display:none;"><A HREF=#><%=ids%></A></TD>
					
				<td  style="width:30%;word-break:break-all"> <%=names%></TD>
				<TD  style="width:20%;word-break:break-all"><%=ResourceComInfo.getLastname(createrid)%>
				</TD>
				<TD  style="width:25%;word-break:break-all">&nbsp;<%=(begindate+" "+begintime) %></TD>
				<TD  style="width:25%;word-break:break-all"><%=(enddate+" "+endtime) %></TD>
				<td  style="display:none"><%=URLEncoder.encode(description,"UTF-8") %></td>
				</TR>
				<%
				}while(RecordSet.previous());
				}
				//RecordSet.executeSql("drop table "+temptable);
				%>
						</table>
						<table align=right style="display:none">
						<tr>
						   <td>&nbsp;</td>
						   <td>
							
						   </td>
						   <td>&nbsp;</td>
						</tr>
						</table>
			</div>
		</td>
	</tr>
	</TABLE>
</td>
<!--##########Browser Table END//#############-->
<td width="40%" valign="top">
	<!--########Select Table Start########-->
	<table  cellspacing="1" align="left" width="100%">
		<tr>
			<td align="center" valign="top" width="30%">
				<img src="/images/arrow_u.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromList();">
				<br><br>
					<img src="/images/arrow_left_all.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(17025,user.getLanguage())%>" onClick="javascript:addAllToList()">
				<br><br>
				<img src="/images/arrow_right.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="javascript:deleteFromList();">
				<br><br>
				<img src="/images/arrow_right_all.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(16335,user.getLanguage())%>" onclick="javascript:deleteAllFromList();">
				<br><br>
				<img src="/images/arrow_d.gif"   style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromList();">
			</td>
			<td align="center" valign="top" width="70%">
				<select size="15" name="srcList" multiple="true" style="width:100%;word-wrap:break-word" >
					
					
				</select>
			</td>
		</tr>
		
	</table>
	<!--########//Select Table End########-->

</td>
</tr>

	</FORM>

		</td>
		</tr>
		</TABLE>
		<!--##############Shadow Table END//######################-->
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</BODY>
<%@page import="java.net.URLEncoder"%></HTML>





<script type="text/javascript">
<!--
	resourceids = "";
	resourcenames = "";
	resourcedesc ="";
	function btnclear_onclick(){
	    window.parent.parent.returnValue = {id:"",name:"",resourcedesc:""};
	    window.parent.parent.close();
	}


jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
})


function btnok_onclick(){
	  setResourceStr();
	 window.parent.parent.returnValue = {id:resourceids,name:resourcenames,resourcedesc:resourcedesc};
    window.parent.parent.close();
}

function btnsub_onclick(){
    setResourceStr();
   $("#resourceids").val(resourceids);
   document.SearchForm.submit();
}
	
function BrowseTable_onclick(e){
	var target =  e.srcElement||e.target ;
	try{
		if(target.nodeName == "TD" || target.nodeName == "A"){
			var newEntry = $($(target).parents("tr")[0].cells[0]).text()+"~"+jQuery.trim($($(target).parents("tr")[0].cells[1]).text())+"~"+jQuery.trim($($(target).parents("tr")[0].cells[5]).text()) ;
			if(!isExistEntry(newEntry,resourceArray)){
				addObjectToSelect($("select[name=srcList]")[0],newEntry);
				reloadResourceArray();
			}
		}
	}catch (en) {
		alert(en.message);
	}
}
function BrowseTable_onmouseover(e){
	var e=e||event;
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
         p.className = "DataDark";
      }else{
         p.className = "DataLight";
      }
   }
}
//-->
</script>
<script language="javascript">
//Load
var resourceArray = new Array();
for(var i =1;i<resourceids.split(",").length;i++){
	
	resourceArray[i-1] = resourceids.split(",")[i]+"~"+resourcenames.split(",")[i]+"~";
	//alert(resourceArray[i-1]);
}

loadToList();
function loadToList(){
	var selectObj = $("select[name=srcList]")[0];
	for(var i=0;i<resourceArray.length;i++){
		addObjectToSelect(selectObj,resourceArray[i]);
	}
	
}
/**
加入一个object 到Select List
 格式object ="1~董芳"
*/
function addObjectToSelect(obj,str){
	//alert(obj.tagName+"-"+str);
	
	if(obj.tagName != "SELECT") return;
	var oOption = document.createElement("OPTION");
	obj.options.add(oOption);
	oOption.value = str.split("~")[0];
	$(oOption).text(str.split("~")[1]);
	$(oOption).attr("dec",str.split("~")[2]);
	
}

function isExistEntry(entry,arrayObj){
	
	for(var i=0;i<arrayObj.length;i++){
		
		if(entry == arrayObj[i].toString()){
			return true;
		}
	}
	return false;
}

function upFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = 0; i <= (len-1); i++) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i>0 && destList.options[i-1] != null){
				fromtext = destList.options[i-1].text;
				fromvalue = destList.options[i-1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i-1] = new Option(totext,tovalue);
				destList.options[i-1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}
function addAllToList(){
	var table =$("#BrowseTable");
	$("#BrowseTable").find("tr").each(function(){
		var str=$($(this)[0].cells[0]).text()+"~"+$($(this)[0].cells[1]).text().trim()+"~"+$($(this)[0].cells[5]).text();
		if(!isExistEntry(str,resourceArray))
			addObjectToSelect($("select[name=srcList]")[0],str);
	});
	reloadResourceArray();
}

function deleteFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function deleteAllFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if (destList.options[i] != null) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function downFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i<(len-1) && destList.options[i+1] != null){
				fromtext = destList.options[i+1].text;
				fromvalue = destList.options[i+1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i+1] = new Option(totext,tovalue);
				destList.options[i+1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}
//reload resource Array from the List
function reloadResourceArray(){
	resourceArray = new Array();
	var destList =$("select[name=srcList]")[0];
	for(var i=0;i<destList.options.length;i++){
		resourceArray[i] = destList.options[i].value+"~"+jQuery.trim(destList.options[i].text)+"~"+jQuery.trim($(destList.options[i]).attr("dec")) ;
	}
	//alert(resourceArray.length);
}

function setResourceStr(){
	
	resourceids ="";
	resourcenames = "";
	resourcedesc ="";
	for(var i=0;i<resourceArray.length;i++){
		resourceids += ","+resourceArray[i].split("~")[0] ;
		resourcenames += ","+resourceArray[i].split("~")[1] ;
		resourcedesc+="\7"+resourceArray[i].split("~")[2] ;
	}
	//alert(resourceids+"--"+resourcenames);
	$("input[name=resourceids]").val( resourceids.substring(1));
}

function doSearch()
{
	setResourceStr();
	$("input[name=resourceids]").val(resourceids.substring(1)) ;
    document.SearchForm.submit();
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>