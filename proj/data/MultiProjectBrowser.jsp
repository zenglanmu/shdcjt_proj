<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK rel="stylesheet" type="text/css" href="/css/Weaver.css"></HEAD>

<%
String name = Util.null2String(request.getParameter("name"));
String description = Util.null2String(request.getParameter("description"));
String prjtype = Util.null2String(request.getParameter("prjtype"));
String worktype = Util.null2String(request.getParameter("worktype"));
String manager = Util.null2String(request.getParameter("manager"));
String status = Util.null2String(request.getParameter("status"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String check_per = Util.null2String(request.getParameter("projectids"));

String resourceids = "";
String resourcenames = "";
if (!check_per.equals("")) {
	String strtmp = "select id,name from Prj_ProjectInfo  where id in ("+check_per+")";
	RecordSet.executeSql(strtmp);
	Hashtable ht = new Hashtable();
	while (RecordSet.next()) {
		ht.put( Util.null2String(RecordSet.getString("id")), Util.null2String(RecordSet.getString("name")));
		/*
		if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){

				resourceids +="," + RecordSet.getString("id");
				resourcenames += ","+RecordSet.getString("lastname");
		}
		*/
	}
	try{
		StringTokenizer st = new StringTokenizer(check_per,",");

		while(st.hasMoreTokens()){
			String s = st.nextToken();
			resourceids +=","+s;
			resourcenames += ","+ht.get(s).toString();
		}
	}catch(Exception e){
		resourceids ="";
		resourcenames ="";
	}
}

int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!name.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
}
if(!description.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.description like '%" + Util.fromScreen2(description,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and t1.description like '%" + Util.fromScreen2(description,user.getLanguage()) +"%' ";
}
if(!prjtype.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.prjtype = "+ prjtype ;
	}
	else
		sqlwhere += " and t1.prjtype = "+ prjtype;
}
if(!worktype.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.worktype = "+ worktype ;
	}
	else
		sqlwhere += " and t1.worktype = "+ worktype ;
}
if(!manager.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.manager = "+ manager ;
	}
	else
		sqlwhere += " and t1.manager = "+ manager;
}
if(!status.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.status =" + status +" " ;
	}
	else
		sqlwhere += " and t1.status =" + status +" " ;
}

int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int	perpage=50;
//添加判断权限的内容--new


String temptable = "prjstemptable"+ Util.getRandom() ;
String SearchSql = "";
String SqlWhere = "";

if(!sqlwhere.equals("")){
	SqlWhere = sqlwhere +" and t1.id = t2.prjid and t2.usertype="+user.getLogintype()+" and t2.userid="+user.getUID();
}else{
	SqlWhere = " where t1.id = t2.prjid and t2.usertype="+user.getLogintype()+" and t2.userid="+user.getUID();
}

if(RecordSet.getDBType().equals("oracle")){
	SearchSql = "create table "+temptable+"  as select * from (select  t1.id,t1.name,t1.prjtype,t1.worktype,t1.manager,t1.status from Prj_ProjectInfo  t1,PrjShareDetail  t2  "+ SqlWhere +" order by t1.id desc ) where rownum<"+ (pagenum*perpage+2);
}else if(RecordSet.getDBType().equals("db2")){
    SearchSql = "create table "+temptable+"  as (select  t1.id,t1.name,t1.prjtype,t1.worktype,t1.manager,t1.status from Prj_ProjectInfo  t1,PrjShareDetail  t2 ) definition only ";

    RecordSet.executeSql(SearchSql);

    SearchSql = "insert into "+temptable+" (select t1.id,t1.name,t1.prjtype,t1.worktype,t1.manager,t1.status from Prj_ProjectInfo  t1,PrjShareDetail  t2  " + SqlWhere + " order by t1.id desc fetch first "+(pagenum*perpage+1)+" rows only )"; 
}else{
	SearchSql = "select top "+(pagenum*perpage+1)+" t1.id,t1.name,t1.prjtype,t1.worktype,t1.manager,t1.status into "+temptable+" from Prj_ProjectInfo  t1,PrjShareDetail  t2  " + SqlWhere + " order by t1.id desc"; 
}
 

RecordSet.executeSql(SearchSql);
//添加判断权限的内容--new--end*/

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
     sqltemp="select * from "+temptable+"  order by id fetch first "+(RecordSetCounts-(pagenum-1)*perpage)+" rows only ";
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by id ";
}
RecordSet.executeSql(sqltemp);
%>
<BODY scroll="no">
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

		<FORM id=weaver name=SearchForm style="margin-bottom:0" action="MultiProjectBrowser.jsp" method=post>
		<input type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
		<input type="hidden" name="pagenum" value=''>
		<input type="hidden" name="projectids" value="">
		<!--##############Right click context menu buttons START####################-->
			<DIV align=right style="display:none">
			<%
			RCMenuHeight += RCMenuHeightStep ; //取消右键按钮 看不到按钮，只能查看3个！
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>


			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btn accessKey=O id=btnok onclick="btnok_onclick();"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
			
			<%
			//2012-08-17 ypc 修改  "取消" 右键菜单的事件 要严格的按照 window.parent.parent.close();   这种写法 只能在IE浏览器中识别 ——> window.close()
			RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.parent.close(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>


			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<BUTTON class=btn accessKey=2 id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
			</DIV>
		<!--##############Right click context menu buttons END//####################-->
		<!--######## Search Table Start########-->
	<table width=100% class=viewform>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
<TD width=35% class=field><input name=name value="<%=name%>" class="InputStyle"></TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <select  class=inputstyle id=status name=status>
		<option value=""></option>
		<% while(ProjectStatusComInfo.next()) {  
			String tmpstatus = ProjectStatusComInfo.getProjectStatusid() ;
		%>
          <option value=<%=tmpstatus%> <% if(tmpstatus.equals(status)) {%>selected<%}%>>
		  <%=Util.toScreen(SystemEnv.getHtmlLabelName(Util.getIntValue(ProjectStatusComInfo.getProjectStatusname()),user.getLanguage()),user.getLanguage())%></option>
		<% } %>
        </select>
      </TD>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <select  class=inputstyle id=prjtype name=prjtype>
        <option value=""></option>
       	<%
       	while(ProjectTypeComInfo.next()){
       	%>		  
          <option value="<%=ProjectTypeComInfo.getProjectTypeid()%>" <%if(prjtype.equalsIgnoreCase(ProjectTypeComInfo.getProjectTypeid())) {%>selected<%}%>><%=ProjectTypeComInfo.getProjectTypename()%></option>
            <%}%>
        </select>
      </TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(432,user.getLanguage())%></TD>
      <TD width=35% class=field>
      <select  class=inputstyle id=worktype name=worktype>
        <option value=""></option>
       	<%
       	while(WorkTypeComInfo.next()){
       	%>		  
          <option value="<%=WorkTypeComInfo.getWorkTypeid()%>" <%if(worktype.equalsIgnoreCase(WorkTypeComInfo.getWorkTypeid())) {%>selected<%}%>><%=WorkTypeComInfo.getWorkTypename()%></option>
            <%}%>
        </select>
      </TD>
</tr><TR  style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
<%if(!user.getLogintype().equals("2")){%>
<tr>
<TD width=15%><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></TD>
<td width=35% class=field>
      <INPUT class="wuiBrowser" type=hidden name=manager value="<%=manager%>" _displayText="<%=ResourceComInfo.getResourcename(manager+"")%>"
       _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" >
    </td>
	   <TD width=15%></TD>
      <TD width=35% class=field></TD>
</tr><TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
<%}%>
</table>
<!--#################Search Table END//######################-->
<tr width="100%">
<td width="60%">
	<!--############Browser Table START################-->
	<TABLE class="BroswerStyle" cellspacing="0" cellpadding="0" style="width:100%">
		<COLGROUP>
			<COL width="28%">
			<COL width="29%">
			<COL width="18%">
			<COL width="25%">	
		<TR class=DataHeader>
		  <TH><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>      
		  <TH><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></TH>
		  <TH><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></TH>
		  <TH><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></TH></tr>
		  <TR class=Line style="height:1px;"><TH colspan="4"></TH>
		</TR>

		<TR>
		<td colspan="4" width="100%">
			<div style="overflow-y:scroll;width:100%;height:330px">
			<table width="100%" id="BrowseTable"  style="width:100%;">
			<COLGROUP>
			<COL width="30%">
			<COL width="30%">
			<COL width="20%">
			<COL width="20%">
				<%
				int i=0;
				int totalline=1;
				if(RecordSet.last()){
					do{
					String ids = RecordSet.getString("id");
					String names = Util.toScreen(RecordSet.getString("name"),user.getLanguage());
					String prjtypes = RecordSet.getString("prjtype");
					String worktypes = RecordSet.getString("worktype");
					String managers = RecordSet.getString("manager");
					String statuss = RecordSet.getString("status");
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
				<TD style="word-break:break-all"><%=names%></TD>
				<TD style="word-break:break-all"><%=Util.toScreen(ProjectTypeComInfo.getProjectTypename(prjtypes),user.getLanguage())%></TD>
				<TD style="word-break:break-all"><%=Util.toScreen(ResourceComInfo.getResourcename(managers),user.getLanguage())%></TD>
				<TD style="word-break:break-all"><%=Util.toScreen(SystemEnv.getHtmlLabelName(Util.getIntValue(ProjectStatusComInfo.getProjectStatusname(statuss)),user.getLanguage()),user.getLanguage())%></TD>
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
						RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:weaver.prepage.click(),_top} " ;
						RCMenuHeight += RCMenuHeightStep ;
						%>
									<button type=submit class=btn accessKey=P id=prepage onclick="setResourceStr();$('input[name=pagenum]').val(<%=pagenum-1%>);"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button>
							   <%}%>
						   </td>
						   <td>
							   <%if(hasNextPage){%>
						<%
						RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:weaver.nextpage.click(),_top} " ;
						RCMenuHeight += RCMenuHeightStep ;
						%>
									<button type=submit class=btn accessKey=N  id=nextpage onclick="setResourceStr();$('input[name=pagenum]').val(<%=pagenum+1%>);"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button>
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
			    <br>
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
			 <br>
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
jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
})	
function BrowseTable_onclick(e){
	var target =  e.srcElement||e.target ;
	try{
	if(target.nodeName == "TD" || target.nodeName == "A"){
		var newEntry = $($(target).parents("tr")[0].cells[0]).text()+"~"+$($(target).parents("tr")[0].cells[1]).text() ;
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
		var str=$($(this)[0].cells[0]).text()+"~"+$($(this)[0].cells[1]).text();
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
	var destList = $("select[name=srcList]")[0];
	for(var i=0;i<destList.options.length;i++){
		resourceArray[i] = destList.options[i].value+"~"+destList.options[i].text ;
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
	$("input[name=projectids]").val(resourceids.substring(1));
}

function doSearch()
{
	setResourceStr();
    $("input[name=projectids]").val(resourceids.substring(1)) ;
    document.SearchForm.submit();
}
</script>