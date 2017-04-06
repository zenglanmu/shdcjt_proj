<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />

<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page"/>
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="dm" class="weaver.docs.docs.DocManager" scope="page" />


<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<%
Enumeration em = request.getParameterNames();
boolean isinit = true;
while(em.hasMoreElements())
{
	String paramName = (String)em.nextElement();
	if(!paramName.equals("")&&!paramName.equals("splitflag"))
		isinit = false;
	break;
}
int date2during= Util.getIntValue(request.getParameter("date2during"),0) ;
int olddate2during = 0;
BaseBean baseBean = new BaseBean();
String date2durings = "";
try
{
	date2durings = Util.null2String(baseBean.getPropValue("docdateduring", "date2during"));
}
catch(Exception e)
{}
String[] date2duringTokens = Util.TokenizerString2(date2durings,",");
if(date2duringTokens.length>0)
{
	olddate2during = Util.getIntValue(date2duringTokens[0],0);
}
if(olddate2during<0||olddate2during>36)
{
	olddate2during = 0;
}
if(isinit)
{
	date2during = olddate2during;
}

int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String islink = Util.null2String(request.getParameter("islink"));
String searchid = Util.null2String(request.getParameter("searchid"));
//String searchmainid = Util.null2String(request.getParameter("searchmainid"));
String searchsubject = Util.null2String(request.getParameter("searchsubject"));
String searchcreater = Util.null2String(request.getParameter("searchcreater"));
String searchdatefrom = Util.null2String(request.getParameter("searchdatefrom"));
String searchdateto = Util.null2String(request.getParameter("searchdateto"));
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String crmId = Util.null2String(request.getParameter("txtCrmId"));
String sqlwhere = "" ;

String secCategory = Util.null2String(request.getParameter("secCategory"));
String path= Util.null2String(request.getParameter("path"));
if (!secCategory.equals("")) path = "/"+CategoryUtil.getCategoryPath(Util.getIntValue(secCategory));

String check_per = Util.null2String(request.getParameter("documentids"));
String documentids = "" ;
String documentnames ="";

String newDocumentids="";

// 2005-04-08 Modify by guosheng for TD1769
if (!check_per.equals("")) {
	documentids=","+check_per;
	String[] tempArray = Util.TokenizerString2(documentids, ",");
	for (int i = 0; i < tempArray.length; i++) {
		String tempDocName=DocComInfo.getDocname(tempArray[i]);
		if(!"".equals(tempDocName)) {
			newDocumentids += ","+tempArray[i];
			documentnames += ","+Util.StringReplace(Util.StringReplace(tempDocName,",","，"),"&quot;","“");
		}
	}
}
documentids=newDocumentids;
/*
if(!sqlwhere1.equals("")) {
	sqlwhere = sqlwhere1 + " and docstatus in ('1','2','5') ";
}
else {
		sqlwhere = " where  docstatus in ('1','2','5') ";
}
    //System.out.println("sqlwhere = " + sqlwhere);
*/
sqlwhere = " where 1=1 ";

if(!islink.equals("1")) {
    DocSearchComInfo.resetSearchInfo() ;

    if(!searchid.equals("")) DocSearchComInfo.setDocid(searchid) ;
    //if(!searchmainid.equals("")) DocSearchComInfo.setMaincategory(searchmainid) ;
    if(!secCategory.equals("")) DocSearchComInfo.setSeccategory(secCategory) ;
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
sqlwhere += dm.getDateDuringSql(date2during);

//int perpage = 30 ;
int perpage = 10 ;
int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;
boolean hasNextPage=false;

DocSearchManage.getSelectResultCount(sqlwhere,user);
int RecordSetCounts = DocSearchManage.getRecordersize();
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}
%>

</HEAD>

<BODY scroll="no">

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

<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="MutiDocBrowser.jsp" method=post>
<input type="hidden" name="pagenum" value=''>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.btnsub.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button"  class=btnSearch accessKey=S  id=btnsub onclick="btnsub_onclick()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.myfun1.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button   class=btnReset accessKey=T id=myfun1   type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button"  class=btn accessKey=O id=btnok onclick="btnok_onclick()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<button type="button"  class=btn accessKey=C id=btnclear onclick="btnclear_onclick()"><U>C</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>



<table width=100% class=ViewForm>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD>
<TD width=35% class=field><input class=InputStyle id=searchid name=searchid value="<%=searchid%>" onKeyPress="ItemNum_KeyPress()" onBlur='checkcount1(this)'></TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%></TD>
<TD width=35% class=field>
    <INPUT type=hidden name=secCategory class="wuiBrowser" value="<%=secCategory%>" _displayText="<%=path%>" _displayTemplate="#b{path}"  _url="/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp">
</TD>
</TR><tr style="height:1px;"><td class=Line colspan=4></td></tr>


<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
<TD width=35% class=field><input  class=InputStyle  name=searchsubject value="<%=searchsubject%>"></TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TD>
<TD width=35% class=field>
    <button type="button"  class=Calendar id=selectdate1 onClick="getDate(searchdatefromspan,searchdatefrom)"></button>
              <span id=searchdatefromspan ><%=searchdatefrom%></span> -
    <button type="button"  class=Calendar id=selectdate2 onClick="getDate(searchdatetospan,searchdateto)"></button>
              <span id=searchdatetospan ><%=searchdateto%></span>

    <input type=hidden id =searchdatefrom name=searchdatefrom maxlength=10 size=10 value="<%=searchdatefrom%>">
    <input type=hidden id =searchdateto name=searchdateto maxlength=10 size=10 value="<%=searchdateto%>">
</td>
</TR>

<tr style="height:1px;"><td class=Line colspan=4></td></tr>

<tr>   
<%if(isgoveproj==0){%>
<TD width=15%><%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%></TD>
<%}else{%>
<TD width=15%><%=SystemEnv.getHtmlLabelName(20098,user.getLanguage())%></TD>
<%}%>
	<TD width=35% class=field>
	   
	    <input type=hidden class="wuiBrowser" id=searchcreater name=searchcreater value="<%=searchcreater%>" _displayText="<%=Util.toScreen(ResourceComInfo.getResourcename(searchcreater),user.getLanguage())%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp">
	</TD>
	<%if(isgoveproj==0){%>
    <TD width=15%><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></TD>
         <TD width=35% class=field>
            <input type=hidden id=txtCrmId name=txtCrmId class="wuiBrowser" value="<%=crmId%>" _displayText="<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmId),user.getLanguage())%>"  _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp">
        </TD>
		<%}else{%>
		<TD  colspan="2"></TD>
		<%}%>
</TR>
<tr style="height:1px;"><td class=Line colspan=4></td></tr>
<%if(date2duringTokens.length>0){ %>
<tr>
 <td class="lable"><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></td>
 <td class="field">
  <select class=inputstyle  size=1 id=date2during name=date2during style=width:80%>
  	<option value="">&nbsp;</option>
  	<%
  	for(int i=0;i<date2duringTokens.length;i++)
  	{
  		int tempdate2during = Util.getIntValue(date2duringTokens[i],0);
  		if(tempdate2during>36||tempdate2during<1)
  		{
  			continue;
  		}
  	%>
  	<!-- 最近个月 -->
  	<option value="<%=tempdate2during %>" <%if (date2during==tempdate2during) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(24515,user.getLanguage())%><%=tempdate2during %><%=SystemEnv.getHtmlLabelName(26301,user.getLanguage())%></option>
  	<%
  	} 
  	%>
  	<!-- 全部 -->
  	<option value="38" <%if (date2during==38) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
  </select>
 </td>
 <TD  colspan="2"></TD>
</tr>
<tr style="height:1px;"><td class=Line colspan=4></td></tr>
<%} %>

</table>
<!--#################Search Table END//######################-->
<tr width="100%">
<td width="60%" valign="top">
<TABLE class="BroswerStyle" cellspacing="0" cellpadding="0" width="100%">
		<COLGROUP>
		<COL width="40%">
		<COL width="40%">
		<COL width="20%">
		<col width="10px;">
		<TR class=DataHeader>
		    <TH ><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TH>
		    <TH ><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></TH>
		    <TH ><%=SystemEnv.getHtmlLabelName(2094,user.getLanguage())%></TH>
		    <th><div style="width:8px;"></div></th>
		</TR>
		<TR class=Line><TH colspan="4"></TH></TR>

		<TR>
		<td colspan="4" width="100%">
			<div style="overflow-y:scroll;height:250px" >
			<table    width="100%" id="BrowseTable" >
			<COLGROUP>
			<COL width="40%">
			<COL width="40%">
			<COL width="20%">
			</COLGROUP>
			<%
			//if(!check_per.equals(""))  
			//		check_per = "," + check_per + "," ;
			String docid=null;
			String mainid=null;
			String subject=null;
			String createrid=null;
			String usertype=null;

			int i=0;
			DocSearchManage.setPagenum(pagenum) ;
			DocSearchManage.setPerpage(perpage) ;
			DocSearchManage.getSelectResult(sqlwhere,orderclause,orderclause2,user) ;
			while(DocSearchManage.next()) {
				docid = ""+DocSearchManage.getID();
				mainid = ""+DocSearchManage.getMainCategory();
				subject = DocSearchManage.getDocSubject();
				createrid = ""+DocSearchManage.getOwnerId();
				//String modifydate = DocSearchManage.getDocLastModDate();
				usertype=Util.null2String(DocSearchManage.getUsertype());
			
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
					<TD style="word-break:break-all"><%=subject%></TD>
					<TD style="word-break:break-all"><%=MainCategoryComInfo.getMainCategoryname(mainid)%></TD>
					<TD style="word-break:break-all"><%if(usertype.equals("1")){%>
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
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>


<script type="text/javascript">
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


</SCRIPT>
</BODY>
</HTML>