<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK rel="stylesheet" type="text/css" href="/css/Weaver.css"></HEAD>

<%
String subject = Util.null2String(request.getParameter("subject"));
String prjid = Util.null2String(request.getParameter("prjid"));
String begindate = Util.null2String(request.getParameter("begindate"));
String enddate = Util.null2String(request.getParameter("enddate"));
//String worktype = Util.null2String(request.getParameter("worktype"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String check_per = Util.null2String(request.getParameter("resourceids"));
String resourceids = "";
String resourcenames = "";

if (!check_per.equals("")) {
	String strtmp = "select id,subject,prjid from Prj_TaskProcess  where id in ("+check_per+")";
	RecordSet.executeSql(strtmp);
	Hashtable ht = new Hashtable();
	while (RecordSet.next()) {
		ht.put( Util.null2String(RecordSet.getString("id")), Util.null2String(RecordSet.getString("subject")));
	}
	try{
		StringTokenizer st = new StringTokenizer(check_per,",");

		while(st.hasMoreTokens()){
			String s = st.nextToken();
			if(ht.containsKey(s)){//如果check_per中的已选的任务此时不存在会出错
				resourceids +=","+s;
				resourcenames += ","+ht.get(s).toString();
			}
		}
	}catch(Exception e){
		resourceids ="";
		resourcenames ="";
	}
}
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!subject.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.subject like '%" + Util.fromScreen2(subject,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and t1.subject like '%" + Util.fromScreen2(subject,user.getLanguage()) +"%' ";
}

if(!prjid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.prjid = "+ prjid ;
	}
	else
		sqlwhere += " and t1.prjid = "+ prjid ;
}

if(!begindate.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.begindate >= '"+ begindate+"'" ;
	}
	else
		sqlwhere += " and t1.begindate >= '"+ begindate+"'" ;
}

if(!enddate.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.enddate <= '"+ enddate+"'" ;
	}
	else
		sqlwhere += " and t1.enddate <= '"+ enddate+"'" ;
}

if(!hrmid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.hrmid = "+ hrmid ;
	}
	else
		sqlwhere += " and t1.hrmid = "+ hrmid;
}

int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int	perpage=50;
//添加判断权限的内容--new


String temptable = "temptable"+ Util.getRandom() ;
String SearchSql = "";
String SqlWhere = "";

SqlWhere = sqlwhere;
if(!sqlwhere.equals("")){
	SqlWhere = sqlwhere +" and t1.prjid = t2.prjid and t2.usertype="+user.getLogintype()+" and t2.userid="+user.getUID();
}else{
	SqlWhere = " where t1.prjid = t2.prjid and t2.usertype="+user.getLogintype()+" and t2.userid="+user.getUID();
}

if(RecordSet.getDBType().equals("oracle")){
	SearchSql = "create table "+temptable+"  as select * from (select  t1.id,t1.subject,t1.prjid,t1.hrmid from Prj_TaskProcess  t1,PrjShareDetail t2 "+ SqlWhere +" order by t1.id desc ) where rownum<"+ (pagenum*perpage+2);
}else if(RecordSet.getDBType().equals("db2")){
	SearchSql = "create table "+temptable+"  as  (select  t1.id,t1.subject,t1.prjid,t1.hrmid from Prj_TaskProcess  t1,PrjShareDetail t2  ) definition only ";

    RecordSet.executeSql(SearchSql);
    
	SearchSql = "insert into "+temptable+" (select t1.id,t1.subject,t1.prjid,t1.hrmid from Prj_TaskProcess  t1,PrjShareDetail t2 "+ SqlWhere + " order by t1.id desc fetch first "+(pagenum*perpage+1)+" rows only )"; 
}else{
	SearchSql = "select top "+(pagenum*perpage+1)+" t1.id,t1.subject,t1.prjid,t1.hrmid into "+temptable+" from Prj_TaskProcess  t1,PrjShareDetail t2 "+ SqlWhere + " order by t1.id desc"; 
}
 
RecordSet.executeSql(SearchSql);

//添加判断权限的内容--new--end

RecordSet.executeSql("Select count(id) RecordSetCounts from "+temptable);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}
	String sqltemp="";
if(RecordSet.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+temptable+" order by id) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else if(RecordSet.getDBType().equals("db2")){
     sqltemp="select  * from "+temptable+"  order by id fetch first "+(RecordSetCounts-(pagenum-1)*perpage)+" rows only ";
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by id ";
}
RecordSet.executeSql(sqltemp);
%>
<BODY  scroll="no">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	
	<td valign="top">
		<!--########Shadow Table Start########-->
<TABLE class=Shadow>
		<tr>
		<td valign="top" colspan="2">

		<FORM id=weaver name=SearchForm style="margin-bottom:0" action="MultiTaskBrowser.jsp" method=post>
		<input type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
		<input type="hidden" name="pagenum" value=''>
		<input type="hidden" name="resourceids" value="">
		<!--##############Right click context menu buttons START####################-->
			<DIV align=right style="display:none">
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>


			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<button type="button" class=btn accessKey=O id=btnok><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>

			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:closeWindow(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>


			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<button type="button" class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
			</DIV>
		<!--##############Right click context menu buttons END//####################-->
		<!--######## Search Table Start########-->
	<table width=100% class=viewform>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
<TD width=35% class=field><input name=subject value="<%=subject%>" class="InputStyle"></TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TD>
<TD width=35% class=field>
    <input type="hidden" class="wuiBrowser" name="prjid" value="<%=prjid%>"
     _url="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"
     _displayText="<%=ProjectInfoComInfo.getProjectInfoname(prjid)%>"
    >
   <!-- 
    <button type="button" class=Browser id=SelectProjectID onClick="onShowProject('prjid','projectspan')"></BUTTON>
	<span id=projectspan><%=ProjectInfoComInfo.getProjectInfoname(prjid)%></span>
	<INPUT class=Inputstyle id=prjid type=hidden name=prjid value="<%=prjid%>">
    -->
</TD>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
<tr>
<TD><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
<TD class=Field>
<button type="button" type="button" class=Calendar onclick="getDate(begindatespan,begindate)"></BUTTON> 
<SPAN id=begindatespan><%=begindate%></span> 
<input type="hidden" name="begindate" id="begindate" value="<%=begindate%>">   
</td>
<TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
<TD class=Field>
<button type="button" type="button" class=Calendar onclick="getDate(enddatespan,enddate)"></BUTTON> 
<SPAN id=enddatespan><%=enddate%></span> 
<input type="hidden" name="enddate" id="enddate" value="<%=enddate%>">   
</td>
</tr>  
<TR style="height:1px;"><TD class=Line colspan=4></TD></TR> 
<tr>
<TD width=15%><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
<TD width=35% class=field>
   <input type="hidden" class="wuiBrowser" name="hrmid" value="<%=hrmid%>"
     _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
     _displayText="<%=Util.toScreen(ResourceComInfo.getResourcename(hrmid),user.getLanguage())%>"
   >
	<!--
		<button type="button" type="button" class=Browser id=SelectHrmID onClick="onShowHrmID(hrmid,hrmspan)"></BUTTON>
		<span id=hrmspan><%=Util.toScreen(ResourceComInfo.getResourcename(hrmid),user.getLanguage())%></span>
		<INPUT class=Inputstyle id=hrmid type=hidden name=hrmid value="<%=hrmid%>">
	 -->
</TD>
</tr><TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
</table>
<!--#################Search Table END//######################-->
<tr width="100%">
<td width="60%" VALIGN="TOP">
	<!--############Browser Table START################-->
	<TABLE class="BroswerStyle" cellspacing="0" cellpadding="0" style="width:100%;">
		<COLGROUP>
		<COL width="40%">
		<COL width="40%">
		<COL width="20%">
		<TR class=DataHeader>
		  <TH><%=SystemEnv.getHtmlLabelName(1352,user.getLanguage())%></TH>      
		  <TH><%=SystemEnv.getHtmlLabelName(17749,user.getLanguage())%></TH>
		  <TH><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TH>
		</TR>
		<TR class=Line style="height:1px;"><TH colspan="4" ></TH></TR>

		<TR>
		<td colspan="4" width="100%">
			<div style="overflow-y:scroll;width:100%;height:260px">
			<table width="100%" id="BrowseTable" style="width:100%;"  style="width:100%;">
			<COLGROUP>
			<COL width="40%">
			<COL width="40%">
			<COL width="20%">
				<%
				int i=0;
				int totalline=1;
				if(RecordSet.last()){
					do{
					String ids = RecordSet.getString("id");
					String subjects = Util.toScreen(RecordSet.getString("subject"),user.getLanguage());
					String prjids = RecordSet.getString("prjid");
					String hrmids = RecordSet.getString("hrmid");
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
					<TD style="display:none"><A HREF=#><%=ids%></A></TD>
				<TD style="word-break:break-all"><%=subjects%></TD>
				<TD style="word-break:break-all"><%=ProjectInfoComInfo.getProjectInfoname(prjids)%></TD>
				<TD style="word-break:break-all"><%=ResourceComInfo.getResourcename(hrmids)%></TD>
				</TR>
				<%
					if(hasNextPage){
						totalline+=1;
						if(totalline>perpage)	break;
					}
				}while(RecordSet.previous());
				}
				RecordSet.executeSql("drop table "+temptable);
				%>
						</table>
						<table align=right style="display:none">
						<tr>
						   <td>&nbsp;</td>
						   <td>
							   <%if(pagenum>1){%>
						<%
						RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:prepage(),_top} " ;
						RCMenuHeight += RCMenuHeightStep ;
						%>
									<button  type=submit class=btn accessKey=P id=prepage onclick="setResourceStr();document.all('pagenum').value=<%=pagenum-1%>;"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button>
							   <%}%>
						   </td>
						   <td>
							   <%if(hasNextPage){%>
						<%
						RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:nextpage(),_top} " ;
						RCMenuHeight += RCMenuHeightStep ;
						%>
									<button type=submit class=btn accessKey=N  id=nextpage onclick="setResourceStr();document.all('pagenum').value=<%=pagenum+1%>;"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button>
							   <%}%>
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
					<img src="/images/arrow_all.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(17025,user.getLanguage())%>" onClick="javascript:addAllToList()">
				<br><br>
				<img src="/images/arrow_out.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="javascript:deleteFromList();">
				<br><br>
				<img src="/images/arrow_all_out.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(16335,user.getLanguage())%>" onclick="javascript:deleteAllFromList();">
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
</BODY></HTML>


	



<script type="text/javascript">
<!--
	resourceids = "<%=resourceids%>";
	resourcenames = "<%=resourcenames%>";
	function btnclear_onclick(){
	    window.parent.parent.returnValue = {id:"",name:""};
	    window.parent.parent.close();
	}


function btnok_onclick(){
	  setResourceStr();
	 window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
    window.parent.parent.close();
}

function btnsub_onclick(){
    setResourceStr();
   $("#resourceids").val(resourceids);
   document.SearchForm.submit();
}

function nextpage(){
  jQuery('#nextpage').click();
}

function prepage(){
  jQuery('#prepage').click();
}
	
function closeWindow(){
  window.parent.parent.close();
}	
jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
})	
function BrowseTable_onclick(e){
	var target =  e.srcElement||e.target ;
	try{
		if(target.nodeName == "TD" || target.nodeName == "A"){
			var newEntry = $($(target).parents("tr")[0].cells[0]).text()+"~"+jQuery.trim($($(target).parents("tr")[0].cells[1]).text()) ;
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
//var resourceids = "<%=resourceids%>"
//var resourcenames = "<%=resourcenames%>"

//Load
var resourceArray = new Array();
for(var i =1;i<resourceids.split(",").length;i++){
	
	resourceArray[i-1] = resourceids.split(",")[i]+"~"+resourcenames.split(",")[i];
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
		var str=$($(this)[0].cells[0]).text()+"~"+$($(this)[0].cells[1]).text().trim();
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
		resourceArray[i] = destList.options[i].value+"~"+jQuery.trim(destList.options[i].text) ;
	}
	//alert(resourceArray.length);
}

function setResourceStr(){
	
	resourceids ="";
	resourcenames = "";
	for(var i=0;i<resourceArray.length;i++){
		resourceids += ","+resourceArray[i].split("~")[0] ;
		resourcenames += ","+resourceArray[i].split("~")[1] ;
	}
	//alert(resourceids+"--"+resourcenames);
	$("input[name=resourceids]").val( resourceids.substring(1));
}

function doSearch()
{
	setResourceStr();
    $("resourceids").val(resourceids.substring(1)) ;
    document.SearchForm.submit();
}
</script>

<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<script type="text/javascript" src="/js/selectDateTime.js"></script>