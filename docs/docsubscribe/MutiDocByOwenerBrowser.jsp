<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.docSubscribe.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />

<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page"/>
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<SCRIPT language="javascript" src="/js/weaver.js"></script>

<%
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String subscribePara = Util.null2String(request.getParameter("subscribePara"));
String[] tempStr = Util.TokenizerString2(subscribePara,"_");
String subscribeHrmId = tempStr[0];
String ownerType = tempStr[1];
String subscribeDocId = tempStr[2];

String islink = Util.null2String(request.getParameter("islink"));
String searchid = Util.null2String(request.getParameter("searchid"));
String searchmainid = Util.null2String(request.getParameter("searchmainid"));
String searchsubject = Util.null2String(request.getParameter("searchsubject"));
String searchcreater = Util.null2String(request.getParameter("searchcreater"));
String searchdatefrom = Util.null2String(request.getParameter("searchdatefrom"));
String searchdateto = Util.null2String(request.getParameter("searchdateto"));
String crmId = Util.null2String(request.getParameter("txtCrmId"));
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String sqlwhere = "" ;

if(!sqlwhere1.equals("")) {
	sqlwhere = sqlwhere1 + " and  (t1.docstatus !='3' and t1.ownerid ="+user.getUID()+" ) ";
}
else {
		sqlwhere = " where  (t1.docstatus !='3' and t1.ownerid ="+user.getUID()+" ) ";
}

String check_per = Util.null2String(request.getParameter("documentids"));
String documentids = "" ;
String documentnames ="";

// 2005-04-08 Modify by guosheng for TD1769
if (!check_per.equals("")) {
	documentids=","+check_per;
	String[] tempArray = Util.TokenizerString2(documentids, ",");
	for (int i = 0; i < tempArray.length; i++) {
		documentnames += ","+DocComInfo.getDocname(tempArray[i]);
	}
}

if(!islink.equals("1")) {
    DocSearchComInfo.resetSearchInfo() ;

    if(!searchid.equals("")) DocSearchComInfo.setDocid(searchid) ;
    if(!searchmainid.equals("")) DocSearchComInfo.setMaincategory(searchmainid) ;
    if(!searchsubject.equals("")) DocSearchComInfo.setDocsubject(searchsubject) ;    
    if(!searchdatefrom.equals("")) DocSearchComInfo.setDoclastmoddateFrom(searchdatefrom) ;
    if(!searchdateto.equals(""))  DocSearchComInfo.setDoclastmoddateTo(searchdateto) ;
    if(!searchcreater.equals("")) {
        DocSearchComInfo.setOwnerid(searchcreater) ;
        DocSearchComInfo.setUsertype("1");
    }
    if(!crmId.equals("")) {
        DocSearchComInfo.setDoccreaterid(crmId) ;   
        DocSearchComInfo.setUsertype("2");    
    }
    DocSearchComInfo.setOrderby("4") ;
}

String docstatus[] = new String[]{"1","2","5","7"};
for(int i = 0;i<docstatus.length;i++){
   	DocSearchComInfo.addDocstatus(docstatus[i]);
}

String tempsqlwhere = DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
String orderclause = DocSearchComInfo.FormatSQLOrder() ;
String orderclause2 = DocSearchComInfo.FormatSQLOrder2() ;

if(!tempsqlwhere.equals("")) sqlwhere += " and " + tempsqlwhere ;

/* added by wdl 2007-03-16 不显示历史版本 */
sqlwhere+=" and (ishistory is null or ishistory = 0) ";
/* added end */

sqlwhere+=" and t1.id !="+subscribeDocId;

int perpage = 30 ;
int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;
boolean hasNextPage=false;
DocSearchManage.getSelectResultCount(sqlwhere,user);
int RecordSetCounts = DocSearchManage.getRecordersize();
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

<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="MutiDocByOwenerBrowser.jsp" method=post>
<input type="hidden" name="pagenum" value=''>
<input type="hidden" name="subscribePara" value='<%=subscribePara%>'>
<input type="hidden" name="documentids" value='<%=documentids%>'>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btnSearch accessKey=S  id=btnsub onclick="doSearch()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T id=myfun1  type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doOk(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=O id=btnok onclick="doOk()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:doClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=C id=btnclear onclick="doClear()"><U>C</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>



<table width=100% class=ViewForm>
<TR class=Spacing>
<TD class=Line1 colspan=4></TD></TR>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD>
<TD width=35% class=field><input class=InputStyle id=searchid name=searchid value="<%=searchid%>" onKeyPress="ItemNum_KeyPress()" onBlur='checkcount1(this)'></TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></TD>
<TD width=35% class=field>
<select class=InputStyle  name=searchmainid>
<option value=""></option>
<%
while(MainCategoryComInfo.next()){
	String isselected ="";
	if(MainCategoryComInfo.getMainCategoryid().equals(searchmainid))
		isselected=" selected";
%>
<option value="<%=MainCategoryComInfo.getMainCategoryid()%>" <%=isselected%>><%=MainCategoryComInfo.getMainCategoryname()%>
<%}%>
</select>
</TD>
</TR><tr style="height: 1px"><td class=Line colspan=4></td></tr>


<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
<TD width=35% class=field><input  class=InputStyle  name=searchsubject value="<%=searchsubject%>"></TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TD>
<TD width=35% class=field>
    <button type="button" class=Calendar id=selectdate1 onClick="getDate(searchdatefrom,searchdatefromspan)"></button>
              <span id=searchdatefromspan ><%=searchdatefrom%></span> -
    <button type="button" class=Calendar id=selectdate2 onClick="getDate(searchdateto,searchdatetospan)"></button>
              <span id=searchdatetospan ><%=searchdateto%></span>

    <input type=hidden id =searchdatefrom name=searchdatefrom maxlength=10 size=10 value="<%=searchdatefrom%>">
    <input type=hidden id =searchdateto name=searchdateto maxlength=10 size=10 value="<%=searchdateto%>">
</td>
</TR>

<tr style="height: 1px"><td class=Line colspan=4></td></tr>

<tr>    
<TD width=15%><%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%></TD>
	<TD width=35% class=field>
	    
	    <input class="wuiBrowser" _url="/hrm/resource/ResourceBrowser.jsp" _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>" _displayText=" <%=Util.toScreen(ResourceComInfo.getResourcename(searchcreater),user.getLanguage())%>" type=hidden id=searchcreater name=searchcreater value="<%=searchcreater%>">
	</TD>
    <TD width=15%><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></TD>
         <TD width=35% class=field>
            <input class="wuiBrowser" _url="/CRM/data/CustomerBrowser.jsp" _displayText=" <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmId),user.getLanguage())%>" type=hidden id=txtCrmId name=txtCrmId value="<%=crmId%>">
        </TD>
</TR>

<tr style="height: 1px"><td class=Line colspan=4></td></tr>

</table>
<!--#################Search Table END//######################-->
<tr width="100%">
<td width="60%">
<TABLE class="BroswerStyle" cellspacing="0" cellpadding="0">
		<COLGROUP>
		<COL width="50%">
		<COL width="25%">
		<COL width="25%">
		<TR class=DataHeader>
    <TH width="50%"><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TH>
    <TH width="25%"><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></TH>
    <TH width="25%"><%=SystemEnv.getHtmlLabelName(2094,user.getLanguage())%></TH>
		</TR>
		<TR class=Line><TH colspan="4"></TH></TR>

		<TR>
		<td colspan="4" width="100%">
			<div style="overflow-y:scroll;width:100%;height:350px">
			<table width="100%" id="BrowseTable">
			<COLGROUP>
			<COL width="50%">
			<COL width="25%">
			<COL width="25%">
			<%
			if(!check_per.equals(""))  
					check_per = "," + check_per + "," ;
			int i=0;
			DocSearchManage.setPagenum(pagenum) ;
			DocSearchManage.setPerpage(perpage) ;
			DocSearchManage.getSelectResult(sqlwhere,orderclause,orderclause2,user) ;
			while(DocSearchManage.next()) {
					String docid = ""+DocSearchManage.getID();
					String mainid = ""+DocSearchManage.getMainCategory();
					String subject = DocSearchManage.getDocSubject();
					String createrid = ""+DocSearchManage.getOwnerId();
					String modifydate = DocSearchManage.getDocLastModDate();
					String usertype=Util.null2String(DocSearchManage.getUsertype());
			
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
					<TD style="display:none"><A HREF=#><%=docid%></A></TD>
					<TD style="word-break:break-all;" valign="top" ><%=subject%></TD>
					<TD style="word-break:break-all;" valign="top" ><%=MainCategoryComInfo.getMainCategoryname(mainid)%></TD>
					<TD style="word-break:break-all;" valign="top" ><%if(usertype.equals("1")){%>
							<%=Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage())%>
							<%}else{%>
							<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(createrid),user.getLanguage())%>
							<%}%>
					 </TD>
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
  <input type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
  <input type="hidden" name="documentids" value="">
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

<script language="javascript">
documentids = "<%=documentids%>"
documentnames = "<%=documentnames%>"
function btnclear_onclick(){
     window.parent.returnValue = {id:"",name:""};
     window.parent.close();
}

function btnok_onclick(){
	setResourceStr();
	window.parent.returnValue = {id:documentids,name:documentnames};
	window.parent.close();
}

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

jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick)
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover)
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout)
})	

</script>
<script type="text/javascript">

//Load
var resourceArray = new Array();
for(var i =1;i<documentids.split(",").length;i++){
if(documentnames.split(",")[i]!=null&&documentnames.split(",")[i]!=""){
resourceArray[i-1] = documentids.split(",")[i]+"~"+documentnames.split(",")[i];
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

documentids ="";
documentnames = "";
for(var i=0;i<resourceArray.length;i++){
	documentids += "," +resourceArray[i].split("~")[0];
	documentnames += "," +replaceToHtml(resourceArray[i].split("~")[1]);
}
document.all("documentids").value = documentids.substring(1)
}

function doSearch()
{
setResourceStr();
document.all("documentids").value = documentids.substring(1) ;
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
function doClear(){
	window.parent.returnValue = {id:"",name:""};
	window.parent.close();
}

function doOk(){
	setResourceStr()
	window.parent.returnValue = {id:documentids,name:documentnames}
	window.parent.close()
}

</SCRIPT>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</BODY>

</HTML>
<%--
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/docs/common.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
 
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page"/>
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session"/>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<%
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String subscribePara = Util.null2String(request.getParameter("subscribePara"));
String[] tempStr = Util.TokenizerString2(subscribePara,"_");
String subscribeHrmId = tempStr[0];
String ownerType = tempStr[1];
String subscribeDocId = tempStr[2];

String islink = Util.null2String(request.getParameter("islink"));
String searchid = Util.null2String(request.getParameter("searchid"));
String searchmainid = Util.null2String(request.getParameter("searchmainid"));
String searchsubject = Util.null2String(request.getParameter("searchsubject"));
String searchcreater = Util.null2String(request.getParameter("searchcreater"));
String searchdatefrom = Util.null2String(request.getParameter("searchdatefrom"));
String searchdateto = Util.null2String(request.getParameter("searchdateto"));
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String sqlwhere = "" ;



String check_per = ","+Util.null2String(request.getParameter("documentids"))+",";
String documentids = "" ;
String documentnames ="";
String strtmp = "select id,docsubject from DocDetail ";
RecordSet.executeSql(strtmp);
while(RecordSet.next()){
	if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){

		 	documentids +="," + RecordSet.getString("id");
		 	documentnames += ","+RecordSet.getString("docsubject");
	}
}

if(!sqlwhere1.equals("")) {
	sqlwhere = sqlwhere1 + " and  (t1.docstatus !='3' and t1.ownerid ="+user.getUID()+" ) ";
}
else {
		sqlwhere = " where  (t1.docstatus !='3' and t1.ownerid ="+user.getUID()+" ) ";
}
    //System.out.println("sqlwhere = " + sqlwhere);


if(!islink.equals("1")) {
    DocSearchComInfo.resetSearchInfo() ;

    if(!searchid.equals("")) DocSearchComInfo.setDocid(searchid) ;
    if(!searchmainid.equals("")) DocSearchComInfo.setMaincategory(searchmainid) ;
    if(!searchsubject.equals("")) DocSearchComInfo.setDocsubject(searchsubject) ;
    if(!searchcreater.equals("")) DocSearchComInfo.setOwnerid(searchcreater) ;
    if(!searchdatefrom.equals("")) DocSearchComInfo.setDoclastmoddateFrom(searchdatefrom) ;
    if(!searchdateto.equals(""))  DocSearchComInfo.setDoclastmoddateTo(searchdateto) ;

    DocSearchComInfo.setOrderby("4") ;
}

String tempsqlwhere = DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
String orderclause = DocSearchComInfo.FormatSQLOrder() ;
String orderclause2 = DocSearchComInfo.FormatSQLOrder2() ;

if(!tempsqlwhere.equals("")) sqlwhere += " and " + tempsqlwhere ;

int perpage = 30 ;
int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;

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
		<td valign="top">

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MutiDocByOwenerBrowser.jsp" method=post>

<input type="hidden" name="subscribePara" value="<%=subscribePara%>">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:SearchForm.btnsub.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S  id=btnsub><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.myfun1.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T id=myfun1  type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:SearchForm.btnok.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=O id=btnok><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:SearchForm.btnclear.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=C id=btnclear><U>C</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>



<table width=100% class=ViewForm>
<TR class=Spacing>
<TD class=Line1 colspan=4></TD></TR>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD>
<TD width=35% class=field><input class=InputStyle id=searchid name=searchid value="<%=searchid%>" onKeyPress="ItemNum_KeyPress()" onBlur='checkcount1(this)'></TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></TD>
<TD width=35% class=field>
<select class=InputStyle  name=searchmainid>
<option value=""></option>
<%
while(MainCategoryComInfo.next()){
	String isselected ="";
	if(MainCategoryComInfo.getMainCategoryid().equals(searchmainid))
		isselected=" selected";
%>
<option value="<%=MainCategoryComInfo.getMainCategoryid()%>" <%=isselected%>><%=MainCategoryComInfo.getMainCategoryname()%>
<%}%>
</select>
</TD>
</TR><tr><td class=Line colspan=4></td></tr>


<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
<TD width=35% class=field><input  class=InputStyle  name=searchsubject value="<%=searchsubject%>"></TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(2094,user.getLanguage())%></TD>
<TD width=35% class=field>
    <BUTTON class=Browser id=SelectQwnerID onClick="onShowOwnerID(searchcreater,onweridspan)"></BUTTON>
    <span id=onweridspan> <%=Util.toScreen(ResourceComInfo.getResourcename(searchcreater),user.getLanguage())%></span>
    <input type=hidden id=searchcreater name=searchcreater value="<%=searchcreater%>"></TD>
</TR><tr><td class=Line colspan=4></td></tr>

<tr>
<TD width=15%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TD>
<TD width=35% class=field colspan=3>
    <button class=Calendar id=selectdate1 onClick="getDate(searchdatefrom,searchdatefromspan)"></button>
              <span id=searchdatefromspan ><%=searchdatefrom%></span> -
    <button class=Calendar id=selectdate2 onClick="getDate(searchdateto,searchdatetospan)"></button>
              <span id=searchdatetospan ><%=searchdateto%></span>

    <input type=hidden id =searchdatefrom name=searchdatefrom maxlength=10 size=10 value="<%=searchdatefrom%>">
    <input type=hidden id =searchdateto name=searchdateto maxlength=10 size=10 value="<%=searchdateto%>">
</td>
</TR><tr><td class=Line colspan=4></td></tr>

<tr>
            <td colspan="5" height="19">
              <input  type="checkbox" name="checkall0" onClick="CheckAll(checkall0.checked)" value="ON">
              <%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%></td>
 </tr>

<TR class=Spacing><TD class=Line1 colspan=5></TD></TR>
</table>



<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1>
<TR class=DataHeader>
      <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
	 <TH width=5%></TH>
    <TH width=45%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TH>
    <TH width=18%><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></TH>
    <TH width=14%><%=SystemEnv.getHtmlLabelName(2094,user.getLanguage())%></TH>
    <TH width=18%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TH>
    </tr><TR class=Line><TH colSpan=6></TH></TR>
<%
SplitPageParaBean spp = new SplitPageParaBean();
SplitPageUtil spu = new SplitPageUtil();

String columnPara =" t1.id,t1.maincategory, t1.docsubject,t1.doccreaterid,t1.doclastmoddate,t1.doccreatedate";
String fromSql = " from docdetail t1 , "+tables+" t2  "+ sqlwhere +" and t1.id=t2.sourceid    and t1.usertype="+user.getLogintype()+" and      t1.doccreaterid ="+user.getUID()+" and t1.id !="+subscribeDocId ;

spp.setBackFields(columnPara);
spp.setSqlFrom(fromSql);
spp.setDistinct(true);
spp.setPrimaryKey("t1.id");
spp.setSqlOrderBy("t1.doccreatedate");
spp.setSortWay(spp.DESC);

spu.setSpp(spp);
int recordSize = spu.getRecordCount();   //所有的条记录数  
rs = spu.getCurrentPageRs(pagenum,10);
int i=0;


while(rs.next()) {
		String docid = Util.null2String(rs.getString("id"));
		String mainid = Util.null2String(rs.getString("maincategory"));
		String subject = Util.null2String(rs.getString("docsubject"));
		String createrid = Util.null2String(rs.getString("doccreaterid"));
		String modifydate = Util.null2String(rs.getString("doclastmoddate"));

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
	<TD style="display:none"><A HREF=#><%=docid%></A></TD>

	 <%
	 String ischecked = "";
	 if(check_per.indexOf(","+docid+",")!=-1){
	 	ischecked = " checked ";
	 }%>
	<TD><input type=checkbox name="check_per" value="<%=docid%>" <%=ischecked%>></TD>
		<TD><%=subject%></TD>
		<TD ><%=MainCategoryComInfo.getMainCategoryname(mainid)%></TD>
		<TD><%=Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage())%></TD>
		<TD><%=modifydate%></TD>
</TR>
<%}
%>
<br>
<table width=100% class=Data>
<tr>
<td align=center><%=Util.makeNavbar3(pagenum, recordSize , perpage, "MutiDocByOwenerBrowser.jsp?islink=1&subscribePara="+subscribePara)%></td>
</tr>
</table>
<br>
</TABLE>
  <input type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
  <input type="hidden" name="documentids" value="">
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

<SCRIPT LANGUAGE=VBScript>
documentids = "<%=documentids%>"
documentnames = "<%=documentnames%>"
Sub btnclear_onclick()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub
Sub BrowseTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
   	set obj = e.parentelement.cells(1).all("check_per")
   	if obj.checked then
   		obj.checked = false
   		documentids = replace(documentids,","&e.parentelement.cells(0).innerText,"")
   		documentnames = replace(documentnames,","&e.parentelement.cells(2).innerText,"")

   	else
   		obj.checked = true
   		documentids = documentids & "," & e.parentelement.cells(0).innerText
   		documentnames = documentnames & "," & e.parentelement.cells(2).innerText
   	end if

   ElseIf e.TagName = "A" Then
   	set obj = e.parentelement.cells(1).all("check_per")
   	if obj.checked then
   		obj.checked = false
   		documentids = replace(documentids,","&e.parentelement.parentelement.cells(0).innerText,"")
   		documentnames = replace(documentnames,","&e.parentelement.parentelement.cells(2).innerText,"")
   	else
   		obj.checked = true
   		documentids = documentids & "," & e.parentelement.parentelement.cells(0).innerText
   		documentnames = documentnames & "," & e.parentelement.parentelement.cells(2).innerText
   	end if

   ElseIf e.TagName = "INPUT" Then
   	if e.checked then
	   	documentids = documentids & "," & e.parentelement.parentelement.cells(0).innerText
	   	documentnames = documentnames & "," & e.parentelement.parentelement.cells(2).innerText
	 else
	 	documentids = replace(documentids,","&e.parentelement.parentelement.cells(0).innerText,"")
   		documentnames = replace(documentnames,","&e.parentelement.parentelement.cells(2).innerText,"")
   	end if

   End If
End Sub
Sub BrowseTable_onmouseover()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
      e.parentelement.className = "Selected"
   ElseIf e.TagName = "A" Then
      e.parentelement.parentelement.className = "Selected"
   End If
End Sub
Sub BrowseTable_onmouseout()
   Set e = window.event.srcElement
   If e.TagName = "TD" Or e.TagName = "A" Then
      If e.TagName = "TD" Then
         Set p = e.parentelement
      Else
         Set p = e.parentelement.parentelement
      End If
      If p.RowIndex Mod 2 Then
         p.className = "DataLight"
      Else
         p.className = "DataDark"
      End If
   End If
End Sub

Sub btnok_onclick()

     window.parent.returnvalue = Array(documentids,documentnames)
    window.parent.close
End Sub

Sub btnsub_onclick()
    document.all("documentids").value = documentids
    document.SearchForm.submit
End Sub

sub onShowOwnerID(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub
</SCRIPT>

<script language="javascript">
function CheckAll(checked) {
//	alert(documentids);
//	documentids = "";
//	documentnames = "";
	len = document.SearchForm.elements.length;
	var i=0;
	for( i=0; i<len; i++) {
		if (document.SearchForm.elements[i].name=='check_per') {
			if(!document.SearchForm.elements[i].checked) {
				documentids = documentids + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(0).innerText;
		   		documentnames = documentnames + "," + document.SearchForm.elements[i].parentElement.parentElement.cells(2).innerText;
		   	}
		   	document.SearchForm.elements[i].checked=(checked==true?true:false);
		}
 	}
 //	alert(documentids);
}
</script>
<script language="JavaScript">
//下面的函数由分页栏产生的函数调用
function changePagePre(pageStr){
    changePageSubmit(pageStr);
}
//下面的函数由分页栏产生的函数调用
function changePageTo(pageStr){
    changePageSubmit(pageStr);
}
//下面的函数由分页栏产生的函数调用
function changePageNext(pageStr){
    changePageSubmit(pageStr);
}

function changePageSubmit(pageStr){
    //alert(pageStr+"&documentids="+documentids+"&searchid="+document.all("searchid").value+"&searchmainid="+document.all("searchmainid").value+"&searchsubject="+document.all("searchsubject").value+"&searchcreater="+document.all("searchcreater").value+"&searchdatefrom="+document.all("searchdatefrom").value+"&searchdatefrom="+document.all("searchdatefrom").value);
    location=pageStr+"&documentids="+documentids+"&searchid="+document.all("searchid").value+"&searchmainid="+document.all("searchmainid").value+"&searchsubject="+document.all("searchsubject").value+"&searchcreater="+document.all("searchcreater").value+"&searchdatefrom="+document.all("searchdatefrom").value+"&searchdatefrom="+document.all("searchdatefrom").value;
}
</script>
</BODY></HTML>
--%>