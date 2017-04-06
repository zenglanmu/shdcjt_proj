<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css />
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<%
int modeId = Util.getIntValue(request.getParameter("modeId"));
String selfieldid = Util.null2String(request.getParameter("selectedids"));
//out.println(modeId+"	"+selfieldid);
String searchfieldname = Util.null2String(request.getParameter("searchfieldname"));
int type = Util.getIntValue(request.getParameter("type"));


int formid = 0;
String sql = "select formid from modeinfo where id = " + modeId;
rs.executeSql(sql);
while(rs.next()){
	formid = rs.getInt("formid");
}

HashMap hm = new HashMap();
String fieldsql = "select b.indexdesc,a.id,a.fieldname,a.fieldhtmltype,a.type from workflow_billfield a,HtmlLabelIndex b "; 
fieldsql += "where billid = "+formid+" and a.fieldlabel = b.id and a.viewtype = 0 "; 
fieldsql += "and a.fieldhtmltype = 3 ";
if(type==1){//人员
	fieldsql += " and a.type in (166,165,17,1) ";	
}else if(type==2){//部门
	fieldsql += " and a.type in (168,167,57,4) ";
}else if(type==3){//分部
	fieldsql += " and a.type in (170,169,164) ";
} 

fieldsql += "order by a.id desc ";
rs.executeSql(fieldsql);
while(rs.next()){
	String indexdesc = Util.null2String(rs.getString("indexdesc"));
	String id = Util.null2String(rs.getString("id"));
	String fieldname = Util.null2String(rs.getString("fieldname"));
	hm.put(id,indexdesc);
}

String resourceids ="";
String resourcenames = "";

if (!selfieldid.equals("")) {
	String[] tempArray = Util.TokenizerString2(selfieldid, ",");
	for (int i = 0; i < tempArray.length; i++) {
		String tempname = Util.null2String((String)hm.get(tempArray[i]));
		if(!"".equals(tempname)) {
			resourceids += ","+tempArray[i];
			resourcenames += ","+tempname;
		}
	}
}
//out.println("<br>"+resourceids+"	"+resourcenames);

%>

</HEAD>

<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id="SearchForm" NAME=SearchForm STYLE="margin-bottom:0" action="MultiFormmodeShareFieldBrowser.jsp" method=post>
<input type="hidden" name="modeId" value='<%=modeId%>'>
<input type="hidden" name="selfieldid" value='<%=selfieldid%>'>
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
<table width=100% class=ViewForm>
  <TR>
	<TD width=15%><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></TD>
	<TD width=35% class=field><input class=InputStyle id=searchfieldname name=searchfieldname value="<%=searchfieldname%>" ></TD>
  </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
</table> 
<tr width="100%">
<td width="60%" valign="top">
	<table class=BroswerStyle>
	  <tr class=DataHeader>
	    <TH ><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></TH>
	  </tr>
	  <TR class=Line><TH></TH></TR>
	  <TR>
		<td width="100%">
		  <div style="overflow-y:scroll;width:100%;height:400px">
			<table width="100%" id="BrowseTable" >
			<COLGROUP>
			<%
			rs.executeSql(fieldsql);
			int j=0;
			while(rs.next()) {
				String indexdesc = Util.null2String(rs.getString("indexdesc"));
				String id = Util.null2String(rs.getString("id"));
				String fieldname = Util.null2String(rs.getString("fieldname"));
				if(indexdesc.toUpperCase().indexOf(searchfieldname.toUpperCase())<0){
					continue;
				}
                if(j==0){
					j=1;
			%> <TR class=DataLight>
			<%  }else{
					j=0;
			%> <TR class=DataDark>
			<%  }%>
				 <TD style="display:none"><A HREF=#><%=id%></A></TD>
				 <TD style="word-break:break-all"><%=indexdesc%></TD>
			   </TR>
			<%}%>
		  	</table>
		  </div>
		</td>
	  </TR>
	</table>
</td>
<td width="40%" valign="top">
	<table  cellspacing="1" align="left" width="100%">
		<tr>
			<td align="center" valign="top" width="20%">
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
			<td align="center" valign="top" width="80%">
				<select size="30" name="srcList" multiple="true" style="width:100%;word-wrap:break-word" >

				</select>
			</td>
		</tr>

	</table>
	 	</td>
	 	</tr>
	   </TABLE>
	 </td>
  </tr>
</table>
<input type="text" name="selectedids" value="">
</FORM>
<script type="text/javascript">
 var resourceids ="<%=resourceids%>"
 var resourcenames = "<%=resourcenames%>"
	
function btnclear_onclick(){
    window.parent.parent.returnValue = {id:"",name:""};
    window.parent.parent.close();
}


function btnok_onclick(){
	 setResourceStr();
	 if(resourceids != ''){
	 	resourceids = resourceids.substring(1);
	 	resourcenames = resourcenames.substring(1);
	 }
	 window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
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

//Load
var resourceArray = new Array();
for(var i =1;i<resourceids.split(",").length;i++){
	resourceArray[i-1] = resourceids.split(",")[i]+"~"+resourcenames.split(",")[i];
}

loadToList();
function loadToList(){
	var selectObj = $("select[name=srcList]")[0];
	for(var i=0;i<resourceArray.length;i++){
		addObjectToSelect(selectObj,resourceArray[i]);
	}
	
}/**
加入一个object 到Select List
*/
function addObjectToSelect(obj,str){
	
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
		var str=$($(this)[0].cells[0]).text()+"~"+$.trim($($(this)[0].cells[1]).text());
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
	$("input[name=selectedids]").val( resourceids.substring(1));
}

function doSearch()
{
	setResourceStr();
   $("selectedids").val(resourceids.substring(1)) ;
   document.SearchForm.submit();
}
</script>
</BODY>
</HTML>