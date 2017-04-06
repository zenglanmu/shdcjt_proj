<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.workflow.WfLinkageInfo" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<%
int wfid = Util.getIntValue(request.getParameter("wfid"));
int nodeid = Util.getIntValue(request.getParameter("nodeid"));
String fieldname = Util.null2String(request.getParameter("fieldname"));
String selfieldid = Util.null2String(request.getParameter("selfieldid"));
String viewtype="-1";
int selectfieldid=0;
int indx=selfieldid.indexOf("_");
if(indx!=-1){
    selectfieldid=Util.getIntValue(selfieldid.substring(0,indx));
    viewtype=selfieldid.substring(indx+1);
}
WfLinkageInfo wfli=new WfLinkageInfo();
wfli.init(wfid,user.getLanguage());
String check_per = Util.null2String(request.getParameter("fieldids"));
String fieldids = "" ;
String fieldnames ="";

String newfieldids="";

// 2005-04-08 Modify by guosheng for TD1769
if (!check_per.equals("")) {
	fieldids=","+check_per;
	String[] tempArray = Util.TokenizerString2(fieldids, ",");
	for (int i = 0; i < tempArray.length; i++) {
		String tempDocName=wfli.getFieldnames(Util.getIntValue(tempArray[i].substring(0,tempArray[i].indexOf("_"))));
		if(!"".equals(tempDocName)) {
			newfieldids += ","+tempArray[i];
			fieldnames += ","+tempDocName;
		}
	}
}
fieldids=newfieldids;

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

<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="MultiWorkflowFieldBrowser.jsp" method=post>
<input type="hidden" name="nodeid" value='<%=nodeid%>'>
<input type="hidden" name="wfid" value='<%=wfid%>'>
<input type="hidden" name="selfieldid" value='<%=selfieldid%>'>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S  type="submit" id=btnsub><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T id=myfun1  type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type='button' class=btn accessKey=O id=btnok onclick="btnok_onclick()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type='button' class=btn accessKey=C id=btnclear onclick="btnclear_onclick()"><U>C</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>



<table width=100% class=ViewForm>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></TD>
<TD width=35% class=field><input class=InputStyle id=fieldname name=fieldname value="<%=fieldname%>" ></TD>
<!--TD width=15%><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></TD>
<TD width=35% class=field>
<select class=InputStyle  name=viewtype>
<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
<option value="0" <%if(viewtype.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18020,user.getLanguage())%></option>
<option value="1" <%if(viewtype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18021,user.getLanguage())%></option>
</select>
</TD-->
</TR><tr style="height: 1px"><td class=Line colspan=4></td></tr>

</table>
<!--#################Search Table END//######################-->
<tr width="100%">
<td width="60%" valign="top">
<TABLE class="BroswerStyle" cellspacing="0" cellpadding="0" width="100%">
		<COLGROUP>
		<TR class=DataHeader>
    <TH ><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></TH>
		</TR>
		<TR class=Line><TH colspan="4"></TH></TR>

		<TR>
		<td colspan="4" width="100%">
			<div style="overflow-y:scroll;width:100%;height:400px">
			<table width="100%" id="BrowseTable" >
			<COLGROUP>
			<%
			String fieldid=null;
			String _fielddbname=null;
			String _fieldname=null;
			String _viewtype=null;

            wfli.setSearchfieldname(fieldname.trim());
            wfli.setViewtype(viewtype.trim());
            wfli.setFieldid(selectfieldid);
            ArrayList[] fieldlist=wfli.getFieldsByEdit(nodeid);
            ArrayList fieldidlist=fieldlist[0];
            ArrayList fieldnamelist=fieldlist[1];
            ArrayList fieldisdetaillist=fieldlist[2];
			int i=0;
			for(int j=0;j<fieldidlist.size();j++){
				fieldid = (String)fieldidlist.get(j);
				_fieldname = (String)fieldnamelist.get(j);
                _viewtype =(String)fieldisdetaillist.get(j);
                if(selfieldid.equals(fieldid+"_"+_viewtype)) continue;
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
					<TD style="display:none"><A HREF=#><%=fieldid+"_"+_viewtype%></A></TD>
					<TD style="word-break:break-all"><%=_fieldname%></TD>
				</TR>
				<%}%>
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
	<!--########//Select Table End########-->

  <input type="hidden" name="fieldids" value="">
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
 var resourceids ="<%=fieldids%>"
 var resourcenames = "<%=fieldnames%>"
	
function btnclear_onclick(){
    window.parent.parent.returnValue = {id:"",name:""};
    window.parent.parent.close();
}


function btnok_onclick(){
	 setResourceStr();
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
	//alert(resourceArray[i-1]);
}

loadToList();
function loadToList(){
	var selectObj = $("select[name=srcList]")[0];
	for(var i=0;i<resourceArray.length;i++){
		addObjectToSelect(selectObj,resourceArray[i]);
	}
	
}/**
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
</BODY>
</HTML>