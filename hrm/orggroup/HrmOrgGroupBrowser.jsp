<%@ page language="java" contentType="text/html; charset=GBK" %> 

<jsp:useBean id="HrmOrgGroupSearchManager" class="weaver.hrm.orggroup.HrmOrgGroupSearchManager" scope="page"/>

<jsp:useBean id="HrmOrgGroupComInfo" class="weaver.hrm.orggroup.HrmOrgGroupComInfo" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<%


String orgGroupNameSearch = Util.null2String(request.getParameter("orgGroupNameSearch"));
String orgGroupDescSearch = Util.null2String(request.getParameter("orgGroupDescSearch"));

String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));

String sqlwhere = "" ;

String check_per = Util.null2String(request.getParameter("orgGroupIds"));
String orgGroupIds = "" ;
String orgGroupNames ="";

String newOrgGroupIds="";

// 2005-04-08 Modify by guosheng for TD1769
if (!check_per.equals("")) {
	orgGroupIds=","+check_per;
	String[] tempArray = Util.TokenizerString2(orgGroupIds, ",");
	for (int i = 0; i < tempArray.length; i++) {
		String tempDocName=HrmOrgGroupComInfo.getOrgGroupName(tempArray[i]);
		if(!"".equals(tempDocName)) {
			newOrgGroupIds += ","+tempArray[i];
			orgGroupNames += ","+tempDocName;			
		}
	}
}
orgGroupIds=newOrgGroupIds;

if(!sqlwhere1.equals("")) {
	sqlwhere = sqlwhere1 + " and (isDelete is null or isDelete='0') ";
}else{
	sqlwhere = " where  (isDelete is null or isDelete='0') ";
}

if (!orgGroupNameSearch.equals("")) {
	sqlwhere = sqlwhere + " and orgGroupName like '%"+ Util.toHtml100(orgGroupNameSearch) + "%' ";
}
if (!orgGroupDescSearch.equals("")) {
	sqlwhere = sqlwhere + " and orgGroupDesc like '%"+ Util.toHtml100(orgGroupDescSearch) + "%' ";
}
String orderclause = " order by showOrder " ;

//int perpage = 30 ;
int perpage = 10 ;
int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;
boolean hasNextPage=false;
HrmOrgGroupSearchManager.getSelectResultCount(sqlwhere,user);
int RecordSetCounts = HrmOrgGroupSearchManager.getRecordersize();
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}
%>
</HEAD>

<BODY>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>


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
		<td valign="top" colspan="2">

<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="HrmOrgGroupBrowser.jsp" method=post>
<input type="hidden" name="pagenum" value=''>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnsub_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S  id=btnsub onclick="btnsub_onclick()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T id=myfun1  type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=O id=btnok onclick="btnok_onclick()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=C id=btnclear onclick="btnclear_onclick()"><U>C</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>



<table width=100% class=ViewForm>
<TR>
<TD width=15%>群组名称</TD>
<TD width=35% class=field><input  class=InputStyle  name=orgGroupNameSearch value="<%=orgGroupNameSearch%>"></TD>
<TD width=15%>群组描述</TD>
<TD width=35% class=field><input  class=InputStyle  name=orgGroupDescSearch value="<%=orgGroupDescSearch%>"></TD>
</TR><tr style="height: 1px"><td class=Line colspan=4></td></tr>






</table>
<!--#################Search Table END//######################-->
<tr width="100%">
<td width="60%" >
<TABLE class="BroswerStyle" cellspacing="0" cellpadding="0" width="100%">
		<COLGROUP>
		<COL width="50%">
		<COL width="50%">
		<TR class=DataHeader>
    <TH>群组名称</TH>
    <TH>群组描述</TH>
		</TR>
		<TR class=Line><TH colspan="2"></TH></TR>

		<TR>
		<td colspan="2" width="100%">
			<div style="overflow-y:scroll;width:100%;height:350px">
			<table width="100%" id="BrowseTable">
			<COLGROUP>
			<COL width="50%">
			<COL width="50%">
			<%
			int  orgGroupId=0;
			String orgGroupName=null;
			String orgGroupDesc=null;

			int i=0;
			HrmOrgGroupSearchManager.setPagenum(pagenum) ;
			HrmOrgGroupSearchManager.setPerpage(perpage) ;
			HrmOrgGroupSearchManager.getSelectResult(sqlwhere,orderclause,user) ;
			while(HrmOrgGroupSearchManager.next()) {
				orgGroupId = HrmOrgGroupSearchManager.getId();
				orgGroupName = HrmOrgGroupSearchManager.getOrgGroupName();
				orgGroupDesc = HrmOrgGroupSearchManager.getOrgGroupDesc();			
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
					<TD style="display:none"><A HREF=#><%=orgGroupId%></A></TD>
					<TD style="word-break:break-all"><%=orgGroupName%></TD>
					<TD style="word-break:break-all"><%=orgGroupDesc%></TD>
				</TR>
				<%}%>
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
									<button type=submit class=btn accessKey=P id=prepage onclick="setResourceStr();document.all('pagenum').value=<%=pagenum-1%>;"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button>
							   <%}%>
						   </td>
						   <td>
							   <%if(hasNextPage){%>
						<%
						RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:weaver.nextpage.click(),_top} " ;
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
				<img src="/images/arrow_u.gif" style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromList();">
				<br><br>
					<img src="/images/arrow_left_all.gif" style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(17025,user.getLanguage())%>" onClick="javascript:addAllToList()">
				<br><br>
				<img src="/images/arrow_right.gif"  style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="javascript:deleteFromList();">
				<br><br>
				<img src="/images/arrow_right_all.gif"  style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(16335,user.getLanguage())%>" onclick="javascript:deleteAllFromList();">
				<br><br>
				<img src="/images/arrow_d.gif"   style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromList();">
			</td>
			<td align="center" valign="top" width="70%">
				<select size="15" name="srcList" multiple="true" style="width:100%;word-wrap:break-word" >
					
				</select>
			</td>
		</tr>
		
	</table>
	<!--########//Select Table End########-->
  <input type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>' >
  <input type="hidden" name="orgGroupIds" value="">
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>

<script language="javascript">

function btnclear_onclick(){
    window.parent.returnValue = {id:"",name:""};
    window.parent.close();
}

function btnok_onclick(){
	setResourceStr();
	window.parent.returnValue = {id:orgGroupIds,name:orgGroupNames};
	window.parent.close();
}
jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
})
function btnsub_onclick(){
	doSearch();
}

function BrowseTable_onclick(e){
	var target =  e.srcElement||e.target ;
	try{
	if(target.nodeName == "TD" || target.nodeName == "A"){
		var newEntry = $($(target).parents("tr")[0].cells[0]).text()+"~"+$($(target).parents("tr")[0].cells[1]).text() ;
		if(!isExistEntry(newEntry,resourceArray)){
			addObjectToSelect(document.all("srcList"),newEntry);
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

</script>
<script type="text/javascript">
var orgGroupIds = "<%=orgGroupIds%>";
var orgGroupNames = "<%=orgGroupNames%>";
//Load
var resourceArray = new Array();
for(var i =1;i<orgGroupIds.split(",").length;i++){
if(orgGroupNames.split(",")[i]!=null&&orgGroupNames.split(",")[i]!=""){
resourceArray[i-1] = orgGroupIds.split(",")[i]+"~"+orgGroupNames.split(",")[i];
}
}

loadToList();
function loadToList(){
var selectObj = document.all("srcList");
for(var i=0;i<resourceArray.length;i++){
	addObjectToSelect(selectObj,resourceArray[i]);
}

}
/**
加入一个object 到Select List
格式object ="1~董芳"
*/
function addObjectToSelect(obj,str){
if(obj.tagName != "SELECT") return;
var oOption = document.createElement("OPTION");
obj.options.add(oOption);
$(oOption).val(str.split("~")[0]);
$(oOption).text(str.split("~")[1])  ;

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
var destList  = document.all("srcList");
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
		addObjectToSelect(document.all("srcList"),str);
});
reloadResourceArray();
}

function deleteFromList(){
var destList  = document.all("srcList");
var len = destList.options.length;
for(var i = (len-1); i >= 0; i--) {
if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
destList.options[i] = null;
	  }
}
reloadResourceArray();
}
function deleteAllFromList(){
var destList  = document.all("srcList");
var len = destList.options.length;
for(var i = (len-1); i >= 0; i--) {
if (destList.options[i] != null) {
destList.options[i] = null;
	  }
}
reloadResourceArray();
}
function downFromList(){
var destList  = document.all("srcList");
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
function reloadResourceArray(){
resourceArray = new Array();
var destList = document.all("srcList");
for(var i=0;i<destList.options.length;i++){
	resourceArray[i] = destList.options[i].value+"~"+destList.options[i].text ;
}
}

function setResourceStr(){

orgGroupIds ="";
orgGroupNames = "";
for(var i=0;i<resourceArray.length;i++){
	orgGroupIds += "," +resourceArray[i].split("~")[0];
	orgGroupNames += "," +replaceToHtml(resourceArray[i].split("~")[1]);
}
document.all("orgGroupIds").value = orgGroupIds.substring(1)
}

function doSearch()
{
setResourceStr();
document.all("orgGroupIds").value = orgGroupIds.substring(1) ;
document.SearchForm.submit();
}

function replaceToHtml(str){
var re = str;
var re1 = "<";
var re2 = ">";
do{
	re = re.replace(re1,"&lt;");
	re = re.replace(re2,"&gt;");
   re = re.replace(",","，");
   re = re.replace("&quot;","“");
}while(re.indexOf("<")!=-1 || re.indexOf(">")!=-1||re.indexOf(",")!=-1||re.indexOf("&quot;")!=-1)
return re;
}


</SCRIPT>
</BODY>
</HTML>