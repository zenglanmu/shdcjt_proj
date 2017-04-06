<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<SCRIPT language="javascript" src="/js/weaver.js"></script>

<%


String check_per = Util.null2String(request.getParameter("beanids"));
//System.out.println(check_per);
String beanids = "" ;
String beannames ="";
String beandescs="";
String name = Util.null2String(request.getParameter("name"));
String type = Util.null2String(request.getParameter("type"));
String workflowid = Util.getIntValue(request.getParameter("workflowid"),-1)+"";
String currenttime = Util.null2String(request.getParameter("currenttime"));
String issearch = Util.null2String(request.getParameter("issearch"));

String bts[] = type.split("\\|");
String frombrowserid = "";
type = bts[0];
if(bts.length>1){
	frombrowserid = bts[1];
}

Browser browser=(Browser)StaticObj.getServiceByFullname(type, Browser.class);
String href = Util.null2String(browser.getHref());
String outpage = Util.null2String(browser.getOutPageURL());
if(!outpage.equals("")){
	if(outpage.indexOf("?")>=0){
		outpage += "&browsertype="+type+"&beanids="+check_per;
	}else{
		outpage += "?browsertype="+type+"&beanids="+check_per;
	}
	response.sendRedirect(outpage);
	return;
}
// 2005-04-08 Modify by guosheng for TD1769
if (!check_per.equals("")) {
	beanids=","+check_per;
	String[] tempArray = Util.TokenizerString2(beanids, ",");
	for (int i = 0; i < tempArray.length; i++) {
		beannames += ","+browser.searchById(tempArray[i]).getName();
		beandescs += ","+browser.searchById(tempArray[i]).getDescription();
	}
}

//
String needChangeFieldString = Util.null2String((String)session.getAttribute("needChangeFieldString_"+workflowid+"_"+currenttime));
HashMap allField = (HashMap)session.getAttribute("allField_"+workflowid+"_"+currenttime);
ArrayList allFieldList = (ArrayList)session.getAttribute("allFieldList_"+workflowid+"_"+currenttime);
if(allField==null){
	allField = new HashMap();
}
if(allFieldList==null){
	allFieldList = new ArrayList();
}
String fieldids[] = needChangeFieldString.split(",");
HashMap valueMap = new HashMap();
for(int i=0;i<fieldids.length;i++){
	String fieldid = Util.null2String(fieldids[i]);
	if(!fieldid.equals("")){
		String fieldvalue = Util.null2String(request.getParameter(fieldid));
		if(fieldid.split("_").length==2){
			fieldid = fieldid.split("_")[0];
		}
		//System.out.println(fieldid+"	"+fieldvalue);
		valueMap.put(fieldid,fieldvalue);
	}
}
if(issearch.equals("1")){
	valueMap = (HashMap)session.getAttribute("valueMap_"+workflowid+"_"+currenttime);
	if(valueMap==null){
		valueMap = new HashMap();
	}
}else{
	session.setAttribute("valueMap_"+workflowid+"_"+currenttime,valueMap);
}

String Search = browser.getSearch();//.toLowerCase();//
String SearchByName = browser.getSearchByName();//.toLowerCase();// 

for(int i=0;i<allFieldList.size();i++){
	String fieldname = Util.null2String((String)allFieldList.get(i));
	if(!fieldname.equals("")){
		String fieldid = Util.null2String((String)allField.get(fieldname));
		String fieldvalue = Util.null2String((String)valueMap.get(fieldid));
		//System.out.println(fieldname +"	@	"+fieldid+"	@	"+fieldvalue);
		Search = Search.replace(fieldname,fieldvalue);
		SearchByName = SearchByName.replace(fieldname,fieldvalue);
	}
}

String userid = user.getUID()+"";
List l;
if(name.equals(""))
l=browser.search(userid,Search);
else
l=browser.searchByName(userid,name,SearchByName);
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
	<td valign="top" >
		<TABLE class=Shadow>
		<tr style="height:1px;">
		<td valign="top" colspan="2" >

<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="MultiCommonBrowser.jsp" method=post>
<input type="hidden" name="type" value='<%=type%>'>
<input type=hidden id='curpage' name='curpage' value="1">
<input type=hidden id='workflowid' name='workflowid' value="<%=workflowid%>">
<input type=hidden id='currenttime' name='currenttime' value="<%=currenttime%>">
<input type=hidden id='issearch' name='issearch' value="1">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnsubClick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type=button  class=btnSearch accessKey=S  id=btnsub><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:myfun1Click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type=button  class=btnReset accessKey=T id=myfun1  type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnokClick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type=button  class=btn accessKey=O id=btnok><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclearClick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type=button  class=btn accessKey=C id=btnclear><U>C</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>



<table width=100% class=ViewForm>
<TR class=Spacing style="height:1px;">
<TD class=Line1 colspan=4></TD></TR>
<TR>
<TD width=15%><%=Util.null2String(browser.getNameHeader())%></TD>
<TD width=35% class=field><input class=InputStyle id="InputStyle" id=name name='name' value="<%=name%>"></TD>

</TR><tr style="height:1px;"><td class=Line colspan=4></td></tr>


</table>
<!--#################Search Table END//######################-->
<tr width="100%" valign="top">
<td width="60%">
<TABLE class="BroswerStyle" cellspacing="0" cellpadding="0" width="100%">
		
		<TR>
		<td colspan="3" width="100%">
			<table width="100%" class=BroswerStyle cellspacing="0" cellpadding="0">
			<TR class=DataHeader>
			    <TH style="display:none"></TH>
			    <TH><%=Util.null2String(browser.getNameHeader())%></TH>
			    <TH><%=Util.null2String(browser.getDescriptionHeader())%></TH>
			</TR>		
			<TR class=Line style="height:1px;"><TH colspan=2></TH></TR>
			</table>

			<div style="overflow-y:scroll;width:100%;height:350px">
			<table width="100%" id="BrowseTable">
			<%
			if(!check_per.equals(""))  
					check_per = "," + check_per + "," ;

			int curpage = Util.getIntValue(request.getParameter("curpage"),1);//当前页
			int perpage = 50;//每页行数
			List templist = new ArrayList();
			int sumcount = l.size();
			boolean nextpage = false;
			boolean lastpage = false;
			if(curpage*perpage<sumcount) nextpage = true;
			if(curpage>1) lastpage = true;				
			if(lastpage){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:onPage("+(curpage-1)+"),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(nextpage){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:onPage("+(curpage+1)+"),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			int start = (curpage-1) * perpage;
			int end = curpage * perpage;
			if(end>sumcount) end = sumcount;
			for(int t=start;t<end;t++){
				templist.add(l.get(t));
			}

			int i=0;
			
			Iterator iter=templist.iterator();
			while(iter.hasNext()) {
			BrowserBean bean=(BrowserBean)iter.next();
			String id = bean.getId();
			String beanname = bean.getName();
			String desc=bean.getDescription();
			
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
					<TD style="display:none"><A HREF=#><%=id%></A></TD>
					<TD style= "word-break:break-all"><%=beanname%></TD>
					<TD style= "word-break:break-all"><%=desc%></TD>
					
				</TR>
				<%}%>
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
  <input type="hidden" name="beanids" value="">
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

<script type="text/javascript">
//<!--
var beanids = "<%=beanids%>";
var beannames = "<%=beannames%>";
var beandescs = "<%=beandescs%>";
function btnokClick() {
	document.getElementById('btnok').click();
}

function btnsubClick() {
	//document.getElementById('btnsub').click();
	document.SearchForm.submit();
}

function myfun1Click() {
	//document.getElementById('myfun1').click()
	//岗位多选 自定义浏览按钮 页面的 右键重新设置不会清空 输入的值 下面改为 2012-08-27 ypc 修改
	document.getElementById("InputStyle").value="";
}

function btnclearClick() {
	document.getElementById('btnclear').click();
}

jQuery(document).ready(function () {
	jQuery("#btnclear").bind("click", function () {
		window.parent.returnValue = {id:"", name:"", key3:"",href:''};//Array("","","")
	    window.parent.close();
	});

	jQuery("#btnok").bind("click", function () {
		setResourceStr();
		
		window.parent.returnValue = {id:"," + beanids, name:"," + beannames, key3:"," + beandescs,href:'<%=href%>'};//Array(beanids,beannames,beandescs)
		window.parent.close();
	});

	jQuery("#btnsub").bind("click", function () {
		doSearch();
	});

	
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(event){
		if(event.target.tagName == "TD" || event.target.tagName == "A"){
			var curEle = event.target;

			if (event.target.tagName == "A") {
				curEle = jQuery(curEle).parent()[0];
			}
			
			var newEntry = jQuery(jQuery(curEle).parent().children()[0]).text() + "~"
			    + jQuery(jQuery(curEle).parent().children()[1]).text() + "~"
			    + jQuery(jQuery(curEle).parent().children()[2]).text();

			if(!isExistEntry(newEntry, resourceArray)){
				addObjectToSelect($G("srcList"),newEntry);
				reloadResourceArray();
			}
		} 
	});
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
		$(this).addClass("Selected")
	});
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
		$(this).removeClass("Selected")
	});
});
//-->
</script>
<!-- 
<SCRIPT LANGUAGE=VBScript>
beanids = "<%=beanids%>"
beannames = "<%=beannames%>"
beandescs = "<%=beandescs%>"
Sub btnclear_onclick()
     window.parent.returnvalue = Array("","","")
     window.parent.close
End Sub

Sub btnok_onclick()
	setResourceStr()
	window.parent.returnvalue = Array(beanids,beannames,beandescs)
	window.parent.close
End Sub

Sub btnsub_onclick()
	doSearch()
End Sub

</SCRIPT>

<script language="javascript" for="BrowseTable" event="onclick">
	var e =  window.event.srcElement ;
	if(e.tagName == "TD" || e.tagName == "A"){
		var newEntry = e.parentElement.cells(0).innerText+"~"+e.parentElement.cells(1).innerText+"~"+e.parentElement.cells(2).innerText ;
		//alert(newEntry);
		if(!isExistEntry(newEntry,resourceArray)){
			addObjectToSelect($G("srcList"),newEntry);
			reloadResourceArray();
		}
	}
</script>

<script language="javascript" for="BrowseTable" event="onmouseover">
	var eventObj = window.event.srcElement ;
	if(eventObj.tagName =='TD'){
		var trObj = eventObj.parentElement ;
		trObj.className ="Selected";
	}else if (eventObj.tagName == 'A'){
		var trObj = eventObj.parentElement.parentElement;
		trObj.className = "Selected";
	}
</script>

<script language="javascript" for="BrowseTable" event="onmouseout">
	var eventObj = window.event.srcElement ;
	if(eventObj.tagName =='TD'){
		var trObj = eventObj.parentElement ;
		if(trObj.rowIndex%2 == 0)
			trObj.className ="DataLight";
		else
			trObj.className ="DataDark";
	}else if (eventObj.tagName == 'A'){
		var trObj = eventObj.parentElement.parentElement;
		if(trObj%2 == 0)
			trObj.className ="DataLight";
		else
			trObj.className ="DataDark";
	}
</script>
 -->
<script language="javascript">

//Load
var resourceArray = new Array();
for(var i =1;i<beanids.split(",").length;i++){
	
	resourceArray[i-1] = beanids.split(",")[i]+"~"+beannames.split(",")[i]+"~"+beandescs.split(",")[i];
	//alert(resourceArray[i-1]);
}

loadToList();
function loadToList(){
	var selectObj = document.getElementsByName("srcList")[0];
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
	jQuery(oOption).text(str.split("~")[1]);
	oOption.desc = str.split("~")[2];
	
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
	var destList  = $G("srcList");
	var len = destList.options.length;
	for(var i = 0; i <= (len-1); i++) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i>0 && destList.options[i-1] != null){
				fromtext = destList.options[i-1].text;
				fromvalue = destList.options[i-1].value;
				fromdesc = destList.options[i-1].desc;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				todesc = destList.options[i].desc;
				tmpoption=new Option(totext,tovalue);
				tmpoption.desc=todesc;
				destList.options[i-1] = tmpoption;
				destList.options[i-1].selected = true;
                tmpoption=new Option(fromtext,fromvalue);
                tmpoption.desc=fromdesc;
				destList.options[i] =tmpoption ;		
			}
      }
   }
   reloadResourceArray();
}
function addAllToList(){
	var tmpTr =jQuery("#BrowseTable").children("TBODY").children("TR");
	
	//TD38865 通过条件搜索到的结果集，点击添加全部按钮无法添加对应 20120416
	//开始行由原来的2修改为0
	for(var i=0 ;i<tmpTr.length; i++){

		var curEle = jQuery(tmpTr[i]);

		var str = jQuery(curEle.children()[0]).text() + "~"
		    + jQuery(curEle.children()[1]).text() + "~"
		    + jQuery(curEle.children()[2]).text();

		if(!isExistEntry(str, resourceArray)){
			addObjectToSelect($G("srcList"), str);
		}
	}
	reloadResourceArray();
}

function deleteFromList(){
	var destList  = $G("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function deleteAllFromList(){
	var destList  = $G("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if (destList.options[i] != null) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function downFromList(){
	var destList  = $G("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i<(len-1) && destList.options[i+1] != null){
				fromtext = destList.options[i+1].text;
				fromvalue = destList.options[i+1].value;
				fromdesc = destList.options[i+1].desc;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				todesc = destList.options[i].desc;
                tmpoption=new Option(totext,tovalue);
                tmpoption.desc=todesc;
				destList.options[i+1] = tmpoption;
				destList.options[i+1].selected = true;
                tmpoption=new Option(fromtext,fromvalue);
                tmpoption.desc=fromdesc;
				destList.options[i] = tmpoption;		
			}
      }
   }
   reloadResourceArray();
}
//reload resource Array from the List
function reloadResourceArray(){
	resourceArray = new Array();
	var destList = $G("srcList");
	var srcListLength = destList.options ? destList.options.length : 0;
	for(var i=0;i<srcListLength;i++){
		resourceArray[i] = destList.options[i].value+"~"+destList.options[i].text+"~"+destList.options[i].desc ;
	}
	//alert(resourceArray.length);
}

function setResourceStr(){
	
	beanids ="";
	beannames = "";
	beandescs="";
	for(var i=0;i<resourceArray.length;i++){
		beanids += "," +resourceArray[i].split("~")[0];
		beannames += "," +replaceToHtml(resourceArray[i].split("~")[1]);
		beandescs += "," +replaceToHtml(resourceArray[i].split("~")[2]);
	}
	//alert(beanids+"--"+beannames);
	beanids = beanids.substring(1);
	beannames = beannames.substring(1);
	beandescs = beandescs.substring(1);
}

function doSearch()
{
	setResourceStr();
	document.all("beanids").value = beanids;
	document.SearchForm.submit();
}
function onPage(index)
{
	document.SearchForm.curpage.value = index;	
	setResourceStr();
	document.all("beanids").value = beanids;
	SearchForm.submit();
}
function replaceToHtml(str){
	var re = str;
	var re1 = "<";
	var re2 = ">";
	do{
		re = re.replace(re1,"&lt;");
		re = re.replace(re2,"&gt;");
	}while(re.indexOf("<")!=-1 || re.indexOf(">")!=-1)
	return re;
}
</SCRIPT>
</BODY>
</HTML>