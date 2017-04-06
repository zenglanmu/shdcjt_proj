<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<%
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;


String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));

String rolesname = Util.null2String(request.getParameter("rolesname"));

String hrm_id = Util.null2String(request.getParameter("hrm_id"));

String check_per = Util.null2String(request.getParameter("resourceids"));

String resourceids = "" ;
String resourcenames ="";
if(!check_per.equals("")){
	try{
	String strtmp = "select id,rolesmark from HrmRoles where id in ("+check_per+")";
	RecordSet.executeSql(strtmp);
	Hashtable ht = new Hashtable();
	while(RecordSet.next()){
		ht.put(RecordSet.getString("id"),RecordSet.getString("rolesmark"));
		/*
		if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){

				resourceids +="," + RecordSet.getString("id");
				resourcenames += ","+RecordSet.getString("lastname");
		}
		*/
	}

	StringTokenizer st = new StringTokenizer(check_per,",");

	while(st.hasMoreTokens()){
		String s = st.nextToken();
		resourceids +=","+s;
		resourcenames += ","+ht.get(s).toString();
	}
	}catch(Exception e){
		
	}
}

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);

if(!"".equals(hrm_id) && !"1".equals(hrm_id) && detachable == 1){
	sqlwhere += " where exists (select distinct subcompanyid from SysRoleSubcomRight where subcompanyid = HrmRoles.Subcompanyid and  exists (select roleid from hrmrolemembers where roleid = SysRoleSubcomRight.Roleid and resourceid = "+hrm_id+"))";
} else {
    sqlwhere += " where 1=1 ";
}

if(!rolesname.equals(""))
	sqlwhere += " and HrmRoles.rolesmark like '%"+rolesname+"%'";
String sqlstr = "select HrmRoles.id,HrmRoles.rolesmark from HrmRoles " + sqlwhere+" and HrmRoles.type=0 order by rolesmark" ;
%>

</HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>

<tr>
<td valign="top">
<!--########Shadow Table Start########-->
<TABLE class=Shadow>

<tr>
<td valign="top" width="100%" colspan="2">
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MutiRolesBrowser.jsp" method=post>
	<DIV align=right style="display:none">
	<%
	BaseBean baseBean_self = new BaseBean();
	int userightmenu_self = 1;
	try{
		userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
	}catch(Exception e){}	
		RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancle_onclick(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	%>
	<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
	<BUTTON class=btn accessKey=O id=btnok><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
	</DIV>
	<!--######## Search Table Start########-->
	<table width=100% class="ViewForm" valign="top">
	<TR class=Spacing style="height: 1px">
	<TD class=Line1 colspan=4></TD></TR>

	<tr>
		<td width="15%"><%=SystemEnv.getHtmlLabelName(15068,user.getLanguage())%></td>
		<td width="35%" class=field>
			<input class=inputstyle name="rolesname" maxlength=60 value="<%=rolesname%>">
		</td>
	</tr>
	<TR style="height: 1px"><TD class=Line colSpan=6></TD></TR>

	<TR class=Spacing style='height:1px'><TD class=Line1 colspan=4></TD></TR>

	</table>
	<!--########//Search Table End########-->
</td>
</tr>
<tr width="100%">
<td width="60%">
	<!--########Browser Table Start########-->
	<TABLE  cellpadding="1" id="BrowseTable" class="BroswerStyle"   width="100%" cellspacing="0" STYLE="margin-top:0" align="left">
	<TR class=DataHeader>
		  <TH width="0%" style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
		  <TH width="90%"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TH>
		  <TH width="7%"></TH>
		  </tr>
	</TR>

	<tr>
		<td colspan="5" width="100%">
			<div style="overflow-y:scroll;width:100%;height:410px">
				<table width="100%" id="BrowseTable">
					<%
					int i=0;
					RecordSet.executeSql(sqlstr);
					while(RecordSet.next()){
						String ids = RecordSet.getString("id");
						String roles_name = Util.toScreen(RecordSet.getString("rolesmark"),user.getLanguage());
					
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
							<TD width="240" style='word-WRAP: break-word'><%=roles_name%></TD>
							
							
						</TR>
						<%}
						%>
				</table>
			</div>
		</td>
	</tr>
	            

	</TABLE>
	<!--########//Browser Table END########-->
</td>
<td width="40%" valign="top">
	<!--########Select Table Start########-->
	<table  cellspacing="1" align="left" width="100%">
		<tr>
			<td align="center" valign="top" width="30%">
				<img src="/images/arrow_u.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromList();">
				<br><br>
				<img src="/images/arrow_right.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="javascript:deleteFromList();">
				<br><br>
				<img src="/images/arrow_left_all.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(17025,user.getLanguage())%>" onClick="javascript:addAllToList()">
				<br><br>
				<img src="/images/arrow_right_all.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(16335,user.getLanguage())%>" onclick="javascript:deleteAllFromList();">
				<br><br>
				<img src="/images/arrow_d.gif"   style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromList();">
				
			</td>
			<td align="center" valign="top" width="70%">
				<select size="20" name="srcList" multiple="true" style="width:100%" class="InputStyle">
					
					
				</select>
			</td>
		</tr>
		
	</table>
	<!--########//Select Table End########-->
  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
  <input class=inputstyle type="hidden" name="resourceids" value="">
  <input class=inputstyle type="hidden" name="hrm_id" value="<%=hrm_id%>">
</FORM>
 </td>
</tr>
</TABLE>
<!--########//Shadow Table End########-->
</td>
<td></td>
</tr>
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
</table>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script type="text/javascript">
 var resourceids = "<%=resourceids%>"
 var resourcenames = "<%=resourcenames%>"

function btnclear_onclick(){
    window.parent.parent.returnValue = {id:"",name:""};
    window.parent.parent.close();
}

function btncancle_onclick(){
    window.parent.parent.close();
}

function btnok_onclick(){
	 setResourceStr();
	 window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
	 window.parent.parent.close();
}
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


jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
})
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
		var re = /^[0-9]+.?[0-9]*$/; 
		 if (re.test($($(this)[0].cells[0]).text()+"~"))
    	{
		var str=$($(this)[0].cells[0]).text()+"~"+jQuery.trim($($(this)[0].cells[1]).text());
		if(!isExistEntry(str,resourceArray))
			addObjectToSelect($("select[name=srcList]")[0],str);
		}
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
	  var re = /^[0-9]+.?[0-9]*$/;   
      if (re.test(resourceArray[i].split("~")[0]))
    	{
    		resourceids += ","+resourceArray[i].split("~")[0] ;
			resourcenames += ","+resourceArray[i].split("~")[1] ;
   		 }
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