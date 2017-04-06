<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK rel="stylesheet" type="text/css" href="/css/Weaver.css"></HEAD>

<%
int childfieldid = Util.getIntValue(request.getParameter("childfieldid"), 0);
int isbill = Util.getIntValue(request.getParameter("isbill"), 0);
int isdetail = Util.getIntValue(request.getParameter("isdetail"), 0);
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));

String userid = ""+user.getUID() ;
String usertype = "0";

if(user.getLogintype().equals("2")){
	usertype = "1";
}
String fieldname = "";
String description = "";
if(isbill == 0){
	if(isdetail == 0){
		RecordSet.executeSql("select fieldname, description from workflow_formdict where id="+childfieldid);
	}else{
		RecordSet.executeSql("select fieldname, description from workflow_formdictdetail where id="+childfieldid);
	}
}else{
	RecordSet.executeSql("select fieldname, fieldlabel from workflow_billfield where id="+childfieldid);
}
if(RecordSet.next()){
	fieldname = Util.null2String(RecordSet.getString("fieldname"));
	if(isbill == 0){
		description = Util.null2String(RecordSet.getString("description"));
	}else{
		int fieldlabel = Util.getIntValue(RecordSet.getString("fieldlabel"), 0);
		description = SystemEnv.getHtmlLabelName(fieldlabel, user.getLanguage());
	}
}

String check_per = Util.null2String(request.getParameter("resourceids"));

String resourceids = "";
String selectnames = "";

if(!check_per.equals("")){
	String strtmp = "select id, selectname, selectvalue from workflow_SelectItem where fieldid="+childfieldid+" and selectvalue in ("+check_per+")";
	RecordSet.executeSql(strtmp);
	Hashtable ht = new Hashtable();
	while(RecordSet.next()){
		String id_tmp = Util.null2String(RecordSet.getString("selectvalue"));
		String selectname_tmp = Util.null2String(RecordSet.getString("selectname"));
		ht.put(id_tmp, selectname_tmp);
	}
	try{
		StringTokenizer st = new StringTokenizer(check_per, ",");
		while(st.hasMoreTokens()){
			String s = st.nextToken();
			if(ht.containsKey(s)){//如果check_per中的已选的任务此时不存在会出错
				resourceids += ","+s;
				selectnames += ","+Util.null2String((String)ht.get(s));
			}
		}
	}catch(Exception e){
		resourceids = "";
		selectnames = "";
	}
}


if(!sqlwhere.equals("")){
	sqlwhere += (" and fieldid="+childfieldid);
}else{
	sqlwhere = " where fieldid="+childfieldid;
}
sqlwhere += " and isbill="+isbill;

String sqlstr = "" ;

if(RecordSet.getDBType().equals("oracle")){
	sqlstr = "select distinct id, selectname, selectvalue, listorder from workflow_SelectItem " + sqlwhere + "  and (cancel IS NULL OR cancel!=1) order by listorder, id asc";
}else{
	sqlstr = "select distinct id, selectname, selectvalue, listorder from workflow_SelectItem " + sqlwhere + " and (cancel IS NULL OR cancel!=1)  order by listorder, id asc";
}
RecordSet.executeSql(sqlstr);

%>
<BODY>
<FORM id="SearchForm" name="SearchForm" style="margin-bottom:0" action="SelectItemBrowser.jsp" method=post>
<input type="hidden" name="sqlwhere" value="<%=sqlwhere%>">
<input type="hidden" name="pagenum" value=''>
<input type="hidden" name="resourceids" value="">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	<tr>
		<td ></td>
		<td valign="top" width="100%">
		<TABLE class=Shadow>
			<tr>
			<td valign="top">
			<table class="ViewForm">
			<tr>
				<td colspan="3">
					<table class="ViewForm">
					<tr height="22">
						<td width="20%"><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
						<td width="80%" class="field"><%=fieldname%></td>
					</tr>
					<tr style="height:1px;"><td class="Line" colspan="2"></td></tr>
					<tr height="22">
						<td width="20%"><%=SystemEnv.getHtmlLabelName(21934,user.getLanguage())%></td>
						<td width="80%" class="field"><%=description%></td>
					</tr>
					<tr style="height:1px;"><td class="Line1" colspan="2"></td></tr>
					</table>
				</td>
			</tr>
			<tr><td colspan="3" height="10"></td></tr>
			<tr>
				<td align="center" valign="top" width="45%">
					<select size="20" id="fromList" name="fromList" multiple="true" style="width:100%" class="InputStyle" onclick="blur1(srcList)" onkeypress="checkForEnter(fromList, srcList)" ondblclick="one2two(fromList, srcList)">
					</select>
					<script>
						<%
						int i=0;
						int totalline=1;
						while(RecordSet.next()){
							String selectvalue_tmp = Util.null2String(RecordSet.getString("selectvalue"));
							String selectname_tmp = Util.toScreen(RecordSet.getString("selectname"), user.getLanguage());
						%>
							document.all("fromList").options.add(new Option('<%=selectname_tmp%>','<%=selectvalue_tmp%>'));
						<%}%>
					</script>
				</td>
				<td align="center" width="10%">
					<img src="/images/arrow_u.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromList();">
					<br>
					<img src="/images/arrow_left.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>" onClick="javascript:one2two(fromList,srcList);">
					<br>
					<img src="/images/arrow_right.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="javascript:two2one(fromList,srcList);">				
					<br>
					<img src="/images/arrow_left_all.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(17025,user.getLanguage())%>" onClick="javascript:removeAll(fromList,srcList);">
					<br>				
					<img src="/images/arrow_right_all.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(16335,user.getLanguage())%>" onclick="javascript:removeAll(srcList,fromList);">				
					<br>
					<img src="/images/arrow_d.gif"   style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromList();">
				</td>
				<td align="center" valign="top" width="45%">
					<select size="20" id="srcList" name="srcList" multiple="true" style="width:100%" class="InputStyle" onclick="blur1(fromList)" onkeypress="checkForEnter(srcList,fromList)" ondblclick="two2one(fromList,srcList)">
					</select>
				</td>
			</tr>
			<tr>
				<td height="10" colspan=3></td>
			</tr>
			<tr>
				<td align="center" valign="bottom" colspan=3>
				<BUTTON type='button' class=btn accessKey=O  id=btnok onclick="btnok_onclick();"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
				<BUTTON type='button' class=btn accessKey=2  id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
				<BUTTON type='button' class=btnReset accessKey=T  id=btncancel onclick="btncancel_onclick();"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
				</td>
			</tr>
			</table>
			</td>
			</tr>
		</table>
	</td>
	<td ></td>
	</tr>
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
</TABLE>

</FORM>
</BODY></HTML>


<script language="javascript">

document.oncontextmenu=function(){
	   return false;
}

var resourceids = "<%=resourceids%>";
var selectnames = "<%=selectnames%>";

//Load
var resourceArray = new Array();
for(var i =1;i<resourceids.split(",").length;i++){
	resourceArray[i-1] = resourceids.split(",")[i]+"~"+selectnames.split(",")[i];
	//alert("resourceArray[" + (i-1) + "] = " + resourceArray[i-1]);
}

loadToList();
function loadToList(){
	var selectObj = document.all("srcList");
	for(var i=0;i<resourceArray.length;i++){
		addObjectToSelect(selectObj,resourceArray[i]);
	}
}


function addObjectToSelect(obj,str){
	//alert(obj.tagName+"-"+str)
	val = str.split("~")[0];
	txt = str.split("~")[1];
	obj.options.add(new Option(txt,val));
}

init(document.all("fromList"), document.all("srcList"));

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

function deleteFromList(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--){
		if((destList.options[i]!=null) && (destList.options[i].selected==true)){
			destList.options[i] = null;
		}
	}
	reloadResourceArray();
}
function removeAll(fromList, to){
	var len = fromList.options.length;
	for(var i=0; i<len; i++){
		to_len=to.options.length
		txt=fromList.options[i].text
		val=fromList.options[i].value
		to.options[to_len]=new Option(txt,val)	  
	}

	for(var i=len; i>=0; i--) {
		fromList.options[i]=null	  
	}
	reloadResourceArray();
}
function downFromList(){
	var destList  = document.all("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if((destList.options[i] != null) && (destList.options[i].selected == true)) {
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
	var destList = document.all("srcList");
	for(var i=0;i<destList.options.length;i++){
		resourceArray[i] = destList.options[i].value+"~"+destList.options[i].text ;
	}
}

//xiaofeng
function one2two(m1, m2)
{  
	// add the selected options in m1 to m2
	m1len = m1.length ;
	for ( i=0; i<m1len ; i++){
		if (m1.options[i].selected == true ) {
			m2len = m2.length;
			m2.options[m2len]= new Option(m1.options[i].text, m1.options[i].value);
		}
	}

	reloadResourceArray();

	// remove all the selected options from m1 (because they have already been added to m2)	
	j = -1;
	for ( i = (m1len -1); i>=0; i--){
		if (m1.options[i].selected == true ) {
			m1.options[i] = null;
			j = i;
		}
	}
	
	if (j == -1)
		return;
		
	// move focus to the next item
	if (m1.length <= 0)
		return;
		
	if ((j < 0) || (j > m1.length))
		return;
		
	if (j == 0)
		m1.options[j].selected = true;
	else if (j == m1.length)
		m1.options[j-1].selected = true
	else
		m1.options[j].selected = true;


}

function two2one(m1, m2)
{
   one2two(m2,m1);
   reloadResourceArray();
}

function blur1(m){
	for(i=0;i<m.length;i++){
		m.options[i].selected=false
	}
}

function checkForEnter(m1, m2) {
 
   var charCode =  event.keyCode;
   if (charCode == 13) {
	  
	  one2two(m1, m2);
   }
   return false;
}

function init(m1,m2){
	for(i=0;i<m2.length;i++){
		ids=m2.options[i].value;
		for(j=0;j<m1.length;j++){
			if(m1.options[j].value==ids){
				m1.options[j]=null;
				break;
			}
		}
	}
}

function setResourceStr(){
	
	var resourceids1 ="";
	var selectnames1 = "";
		
	for(var i=0;i<resourceArray.length;i++){
		resourceids1 += ","+resourceArray[i].split("~")[0];
		selectnames1 += ","+resourceArray[i].split("~")[1];
	}
	resourceids = resourceids1;
	selectnames = selectnames1;
}

</script>
<script type="text/javascript">


function btnclear_onclick() {
	 window.parent.returnValue = {id: "", name:""};
	 window.parent.close();
}


function btnok_onclick() {
	 setResourceStr();
	 window.parent.returnValue ={id:resourceids, name: selectnames};//Array(resourceids,selectnames)
	 window.parent.close();
}

function btnsub_onclick() {
	 $G("btnsub", window.parent.document).click()
}

function btncancel_onclick() {
	window.parent.close();
}

</script>
<!-- 
<SCRIPT LANGUAGE=VBS>


Sub btnclear_onclick()
	 window.parent.returnvalue = Array("","")
	 window.parent.close
End Sub


Sub btnok_onclick()
	 setResourceStr()
	 window.parent.returnvalue =Array(resourceids,selectnames)
	 window.parent.close
End Sub

Sub btnsub_onclick()
	 window.parent.frame1.SearchForm.btnsub.click()
End Sub

Sub btncancel_onclick()
	 window.close()
End Sub

</SCRIPT>
 -->
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>