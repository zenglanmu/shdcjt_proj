<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="FormManager" class="weaver.workflow.form.FormManager" scope="session"/>
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<jsp:useBean id="FieldMainManager" class="weaver.workflow.field.FieldMainManager" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="DetailFieldComInfo" class="weaver.workflow.field.DetailFieldComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%FormFieldMainManager.resetParameter();%>
<HTML><HEAD>

<%
	if(!HrmUserVarify.checkUserRight("FormManage:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");
    	
		return;
	}
%>

<%
    String ajax=Util.null2String(request.getParameter("ajax"));
    if(!ajax.equals("1")){
%>
<LINK href="/js/jquery/plugins/tooltip/simpletooltip.css" type=text/css rel=STYLESHEET>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<!-- add by xhheng @20050204 for TD 1538-->
<script language=javascript src="/js/weaver.js"></script>
<script language=javascript src="/js/jquery/plugins/tooltip/jquery.tooltip.js"></script>

<%
    }
%>
</head>

<%
	String formname="";
	String formdes="";
	int formid=0;
	formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
	int sysFormId=0;
    RecordSet.execute("select formid from workflow_base where id=1");
    
    if (RecordSet.next())
    {
    sysFormId=RecordSet.getInt(1);
    }
  

	int errorcode=Util.getIntValue(Util.null2String(request.getParameter("errorcode")),0);
	FormManager.setFormid(formid);
	FormManager.getFormInfo();
	formname=FormManager.getFormname();
	formdes=FormManager.getFormdes();
	formdes = Util.StringReplace(formdes,"\n","<br>");
    
	String imagefilename = "/images/hdMaintenance.gif";
	String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(261,user.getLanguage());
	String needfav ="";
	if(!ajax.equals("1"))
	{
	needfav ="1";
	}
	String needhelp ="";
    
    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;
    
    if(detachable==1){  
        subCompanyId=Util.getIntValue(String.valueOf(FormManager.getSubCompanyId2()),-1);
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"FormManage:All",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("FormManage:All", user))
            operatelevel=2;
    }
%>
<%
if(!ajax.equals("1")){
%>
<script language="JavaScript">
var operatelevel = <%=operatelevel%>;
<!--Begin
// Add the selected items in the parent by calling method of parent
function addSelectedItemsToParent() {
self.opener.addToParentList(window.document.tabfieldfrm.destList);
window.close();
}
// Fill the selcted item list with the items already present in parent.
function fillInitialDestList() {
	var destList = window.document.tabfieldfrm.destList;
	var srcList = self.opener.window.document.tabfieldfrm.parentList;
	for (var count = destList.options.length - 1; count >= 0; count--) {
		destList.options[count] = null;
	}
	if(srcList != null){
		for(var i = 0; i < srcList.options.length; i++) {
			if (srcList.options[i] != null)
				destList.options[i] = new Option(srcList.options[i].text,srcList.options[i].value);
   		}
   	}
}
// Add the selected items from the source to destination list
function addSrcToDestList() 
{
	
	if(operatelevel<=0)
	{
		return false;
	}
	destList = window.document.tabfieldfrm.destList;
	srcList = window.document.tabfieldfrm.srcList;
	var len = destList.length;
	for(var i = 0; i < srcList.length; i++) {
		if ((srcList.options[i] != null) && (srcList.options[i].selected)) {
			//Check if this value already exist in the destList or not
			//if not then add it otherwise do not add it.
			var found = false;
			for(var count = 0; count < len; count++) {
				if (destList.options[count] != null) {
					if (srcList.options[i].text == destList.options[count].text) {
						found = true;
						break;
			  		}
  				 }
			}
			if (found != true) {
				destList.options[len] = new Option(srcList.options[i].text,srcList.options[i].value);
				len++;
	        	}
     		}
  	 }
}

// Add the selected items from the source to destination list2
function addSrcToDestList2() {
	if(operatelevel<=0)
	{
		return false;
	}
	destList = window.document.tabfieldfrm.destList2;
	srcList = window.document.tabfieldfrm.srcList2;
	var len = destList.length;
	var rowindex = fromfieldoTable.tBodies[0].rows.length - 1;
	for(var i = 0; i < srcList.length; i++) {
		if ((srcList.options[i] != null) && (srcList.options[i].selected)) {
			//Check if this value already exist in the destList or not
			//if not then add it otherwise do not add it.
			var found = false;
			for(var count = 0; count < len; count++) {
				if (destList.options[count] != null) {
					if (srcList.options[i].text == destList.options[count].text) {
						found = true;
						break;
			  		}
  				 }
			}
			
			for (var count=0;count<rowindex;count++)
			{
			destListTemp=document.all("destListMul"+count);
		    var len1 = destListTemp.length;
			for(var count1 = 0; count1 < len1; count1++) 
			{
			if (destListTemp.options[count1] != null) {
					if (srcList.options[i].value == destListTemp.options[count1].value) {
						found = true;
						break;
			  		}
  				 }
			}
			}
			
			if (found != true) {
				destList.options[len] = new Option(srcList.options[i].text,srcList.options[i].value);
				len++;
	        	}
     		}
  	 }
}

// Add the selected items from the source to destination listMul
function addSrcToDestList3(src,dst) {
	if(operatelevel<=0)
	{
		return false;
	}
	srcList= document.all(src);
	destList=document.all(dst);
	var len = destList.length;
	//window.document.tabfieldfrm.destList2;
	//srcList = window.document.tabfieldfrm.srcList2;	
	var rowindex = fromfieldoTable.tBodies[0].rows.length - 1;
	destList1 = window.document.tabfieldfrm.destList2;
	var len2 = destList1.length;
	
	for(var i = 0; i < srcList.length; i++) {
		if ((srcList.options[i] != null) && (srcList.options[i].selected)) {
			//Check if this value already exist in the destList or not
			//if not then add it otherwise do not add it.
			var found = false;
			for(var count = 0; count < len; count++) {
				if (destList.options[count] != null) {
					if (srcList.options[i].text == destList.options[count].text) {
						found = true;
						break;
			  		}
  				 }
			}
			//var found1 = false;
			for(var count = 0; count < len2; count++) {
				if (destList1.options[count] != null) {
				  
					if (srcList.options[i].value == destList1.options[count].value) {
					   
						found = true;
						
						break;
			  		}
  				 }
			}
			//var found2 = false;
			for (var count=0;count<rowindex;count++)
			{
			destListTemp=document.all("destListMul"+count);
			//alert(destListTemp);
			
			if (destListTemp!=destList)
			{var len1 = destListTemp.length;
			for(var count1 = 0; count1 < len1; count1++) 
			{
			if (destListTemp.options[count1] != null) {
			         //alert("src:"+srcList.options[i].text);
			         //alert("dst:"+destListTemp.options[count1].text);
					if (srcList.options[i].value == destListTemp.options[count1].value) {
						found = true;
						
						break;
			  		}
  				 }
			}
			}
			}
			if (found != true) {
				destList.options[len] = new Option(srcList.options[i].text,srcList.options[i].value);
				len++;
	        	}
     		}
  	 }
}
// Deletes from the destination mul.
function deleteFromDestList3(src,dst) {
if(operatelevel<=0)
{
	return false;
}
var destList  = destList=document.all(dst);
var len = destList.options.length;
for(var i = (len-1); i >= 0; i--) {
if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
destList.options[i] = null;
      }
   }
}

// Up selections from the destination mul.
function upFromDestList3(dst) {
if(operatelevel<=0)
{
	return false;
}
var destList  = destList=document.all(dst);
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
}
// Down selections from the destination mul.
function downFromDestList3(dst) {
if(operatelevel<=0)
{
	return false;
}
var destList  = destList=document.all(dst);
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
}
// Deletes from the destination list.
function deleteFromDestList() {
if(operatelevel<=0)
{
	return false;
}
var destList  = window.document.tabfieldfrm.destList;
var len = destList.options.length;
for(var i = (len-1); i >= 0; i--) {
if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
destList.options[i] = null;
      }
   }
}
// Deletes from the destination list2.
function deleteFromDestList2() {
if(operatelevel<=0)
{
	return false;
}
var destList  = window.document.tabfieldfrm.destList2;
var len = destList.options.length;
for(var i = (len-1); i >= 0; i--) {
if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
destList.options[i] = null;
      }
   }
}
// Up selections from the destination list.
function upFromDestList() {
if(operatelevel<=0)
{
	return false;
}
var destList  = window.document.tabfieldfrm.destList;
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
}
// Up selections from the destination list2.
function upFromDestList2() {
if(operatelevel<=0)
{
	return false;
}
var destList  = window.document.tabfieldfrm.destList2;
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
}
// Down selections from the destination list.
function downFromDestList() {
if(operatelevel<=0)
{
	return false;
}
var destList  = window.document.tabfieldfrm.destList;
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
}

// Down selections from the destination list2.
function downFromDestList2() {
if(operatelevel<=0)
{
	return false;
}
var destList  = window.document.tabfieldfrm.destList2;
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
}
  
    //oPopup   =   window.createPopup();   
    function   showtitle(evt){   
    	//var evt = e ? e : (window.event ? window.event : null);
    	
    	if($.browser.msie){
			obj = evt.srcElement
			if(obj.selectedIndex!=-1){   
				
				if(obj.options[obj.selectedIndex].text.length > 2){  					
					$("#simpleTooltip").remove();					
					var  tipX;
					var  tipY;
					tipX=evt.clientX+document.body.scrollLeft+6;
					tipY=evt.clientY+document.body.scrollTop+6;		
					$("body").append("<div id='simpleTooltip' style='position: absolute; z-index: 100; display: none;'>" + obj.options[obj.selectedIndex].text + "</div>");
					var tipWidth = $("#simpleTooltip").outerWidth(true)
					$("#simpleTooltip").width(tipWidth);
					$("#simpleTooltip").css("left", tipX).css("top", tipY).fadeIn("medium");
				}
			}
		}
    }   


function selectall(obj){
	tmpstr="";
	destinationList = window.document.tabfieldfrm.destList;
	for(var count = 0; count <= destinationList.options.length - 1; count++) {
		tmpstr+=destinationList.options[count].value;
		tmpstr+=",";
	}
	window.document.tabfieldfrm.formfields.value=tmpstr;

    tmpstr="";
	destinationList = window.document.tabfieldfrm.destList2;
	for(count = 0; count <= destinationList.options.length - 1; count++) {
		tmpstr+=destinationList.options[count].value;
		tmpstr+=",";
	}
	window.document.tabfieldfrm.formfields2.value=tmpstr;
	window.document.tabfieldfrm.rownum.value=fromfieldoTable.tBodies[0].rows.length - 1;
	var len=fromfieldoTable.tBodies[0].rows.length - 1;
	for(var i=0;i<len;i++)
	{
	dstlists=document.all("destListMul"+i);
	for(var count = 0; count <= dstlists.options.length - 1; count++)
     {
      dstlists.options[count].selected=true;
	 }
	 }
//	alert(tmpstr);
	window.document.tabfieldfrm.submit();
    obj.disabled=true;
}
// End -->
</script>
<%}%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<br>

<form name="tabfieldfrm" method=post action="/workflow/form/form_operation.jsp">
<input type="hidden" value="formfield" name="src">
<input type="hidden" value="<%=formid%>" name="formid">
<input type="hidden" value="" name="formfields">
<input type="hidden" value="" name="formfields2">
<input type="hidden" value="" name="rownum">
<input type=hidden name="ajax" value="<%=ajax%>">
<%




if(operatelevel>0){
%>
<DIV class=BtnBar>
	  <%
if (formid!=sysFormId)
{
if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(this),_self}" ;
else
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:fieldselectall(this),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
}
}
%>
<%
String nocancelmenuflag = Util.null2String(request.getParameter("nocancelmenuflag"));
if(!ajax.equals("1")&&!nocancelmenuflag.equals("nocancelmenu")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",addDefineForm.jsp?isoldform=1&formid="+formid+",_parent}" ;
RCMenuHeight += RCMenuHeightStep ;
}
%>

<%if(!ajax.equals("1")){%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}

 
%>

<%
	if (formid==sysFormId)  //如果是系统提醒工作流不能修改字段
    {
    out.print("<font color='red'>"+SystemEnv.getHtmlLabelName(19318,user.getLanguage())+"</font>");
   
    return;
    }
	
%>
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



<table class="viewform">
   <COLGROUP>
   <COL width="20%">
   <COL width="80%">
   <TR class="Title">
    	  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(700,user.getLanguage())%>
          <%if(errorcode==1){%>
          	<font color="red"><%=SystemEnv.getHtmlLabelName(22410,user.getLanguage())%>！</font>
          <%}else if(errorcode==2){%>
          	<font color="red"><%=SystemEnv.getHtmlLabelName(24311,user.getLanguage())%>！</font>
          <%}%>

          </TH></TR>
    <TR class="Spacing" style="height: 1px">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></td>
    <td class=field><strong><%=Util.toScreen(formname,user.getLanguage())%><strong></td>
  </tr><TR class="Spacing" style="height: 1px">
    	  <TD class="Line" colSpan=2></TD></TR> <strong></strong>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15452,user.getLanguage())%></td>
    <td class=field><strong><%=Util.toScreen(formdes,user.getLanguage())%></strong></td>
  </tr><TR class="Spacing" style="height: 1px">
    	  <TD class="Line1" colSpan=2></TD></TR>
</table>
<br>

<table class="viewform">
  <COLGROUP>
   <COL width="45%">
   <COL width="10%">
   <COL width="45%">
  <TR class="Title">
    	  <TH colSpan=3><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></TH></TR>
    <TR class="Spacing" style="height: 1px">
    	  <TD class="Line1" colSpan=3></TD></TR>
  <tr class=header>
    <td align=center class=field><%=SystemEnv.getHtmlLabelName(15453,user.getLanguage())%></td>
    <td align=center class=field><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>    
    <td align=center class=field><%=SystemEnv.getHtmlLabelName(18765,user.getLanguage())%></td>
    <td>&nbsp;</td>
  </tr>
      <TR class="Spacing" style="height: 1px">
    	  <TD class="Line" colSpan=3></TD></TR>
  <tr>
    <td vaglin="middle">
	<select class=inputstyle  size="15" name="srcList" multiple style="width:100%" onchange="showtitle(event)" ondblclick="addSrcToDestList()">
    <%
        FieldMainManager.resetParameter() ;
        FieldMainManager.setUserid(user.getUID());
        FieldMainManager.selectAllCodViewField();
    %>
	<%while(FieldMainManager.next()){%>
	<option class="vtip" title="<%=FieldMainManager.getFieldManager().getFieldname() %>[<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=FieldMainManager.getFieldManager().getFielddbtype()%>]<%if (!Util.null2String(FieldMainManager.getFieldManager().getDescription()).equals("")){%>[<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:<%=FieldMainManager.getFieldManager().getDescription()%>]<%}%>" value="<%=FieldMainManager.getFieldManager().getFieldid() %>"><%=FieldMainManager.getFieldManager().getFieldname() %>[<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=FieldMainManager.getFieldManager().getFielddbtype()%>]<%if (!Util.null2String(FieldMainManager.getFieldManager().getDescription()).equals("")){%>[<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:<%=FieldMainManager.getFieldManager().getDescription()%>]<%}%>
	
	
	</option>
	
	<%}%>
	</select>
    </td>
    <td align=center>
    	<img src="/images/arrow_u.gif" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromDestList();">
	<br><br>
    	<img src="/images/arrow_l.gif" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="javascript:deleteFromDestList();">
	<br><br>
	<img src="/images/arrow_r.gif"  title="<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>" onclick="javascript:addSrcToDestList();">
	<br><br>
	<img src="/images/arrow_d.gif"   title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromDestList();">
    </td>
    <td align=center>
	<select class=inputstyle  size=15 name="destList" multiple style="width:100%" onchange="showtitle(event)" ondblclick="deleteFromDestList()">
<%
FormFieldMainManager.setFormid(formid);
FormFieldMainManager.selectFormField();
while(FormFieldMainManager.next()){

%>
	<option class="vtip" title="<%=FieldComInfo.getFieldname(""+FormFieldMainManager.getFieldid())%>[<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=FormFieldMainManager.getFieldDbType()%>]<%if (!FormFieldMainManager.getDescription().equals("")){%>[<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:<%=FormFieldMainManager.getDescription()%>]<%}%>" value="<%=FormFieldMainManager.getFieldid()%>"><%=FieldComInfo.getFieldname(""+FormFieldMainManager.getFieldid())%>[<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=FormFieldMainManager.getFieldDbType()%>]<%if (!FormFieldMainManager.getDescription().equals("")){%>[<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:<%=FormFieldMainManager.getDescription()%>]<%}%>
	
    </option>

<%
}
%>
	</select>
    </td>
    <td >&nbsp;</td>
  </tr>
  <tr class=header>
    <td align=center class=field><%=SystemEnv.getHtmlLabelName(15453,user.getLanguage())%></td>
    <td align=center class=field><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
    <td align=center class=field><%=SystemEnv.getHtmlLabelName(18766,user.getLanguage())%></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td vaglin="middle">
	<select class=inputstyle  size="15" name="srcList2" multiple style="width:100%" onchange="showtitle(event)"  ondblclick="addSrcToDestList2()">
    <%
        FieldMainManager.resetParameter() ;
        FieldMainManager.setUserid(user.getUID());
        FieldMainManager.selectAllCodViewDetailField() ;
    %>
	<%while(FieldMainManager.next()){%>
	<option class="vtip" title="<%=FieldMainManager.getFieldManager().getFieldname() %>[<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=FieldMainManager.getFieldManager().getFielddbtype()%>]<%if (!Util.null2String(FieldMainManager.getFieldManager().getDescription()).equals("")){%>[<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:<%=FieldMainManager.getFieldManager().getDescription()%>]<%}%>" value="<%=FieldMainManager.getFieldManager().getFieldid() %>"><%=FieldMainManager.getFieldManager().getFieldname() %>[<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=FieldMainManager.getFieldManager().getFielddbtype()%>]<%if (!Util.null2String(FieldMainManager.getFieldManager().getDescription()).equals("")){%>[<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:<%=FieldMainManager.getFieldManager().getDescription()%>]<%}%>
	</option>
	<%}%>
	</select>
    </td>
    <td align=center>
    	<img src="/images/arrow_u.gif" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromDestList2();">
	<br><br>
    	<img src="/images/arrow_l.gif" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="javascript:deleteFromDestList2()">
	<br><br>
	<img src="/images/arrow_r.gif"  title="<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>" onclick="javascript:addSrcToDestList2();">
	<br><br>
	<img src="/images/arrow_d.gif"   title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromDestList2();">
    </td>

    <td align=center>
	<select class=inputstyle  size=15 name="destList2" multiple style="width:100%" onchange="showtitle(event)" ondblclick="deleteFromDestList2()">
<%
FormFieldMainManager.setFormid(formid);
FormFieldMainManager.selectDetailFormField();
boolean flags=false;
while(FormFieldMainManager.next()){
flags=true;
%>
	<option class="vtip" title="<%=DetailFieldComInfo.getFieldname(""+FormFieldMainManager.getFieldid())%>[<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=FormFieldMainManager.getFieldDbType()%>]<%if (!FormFieldMainManager.getDescription().equals("")){%>[<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:<%=FormFieldMainManager.getDescription()%>]<%}%>" value="<%=FormFieldMainManager.getFieldid()%>"><%=DetailFieldComInfo.getFieldname(""+FormFieldMainManager.getFieldid())%>[<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=FormFieldMainManager.getFieldDbType()%>]<%if (!FormFieldMainManager.getDescription().equals("")){%>[<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:<%=FormFieldMainManager.getDescription()%>]<%}%>
	

	</option>
<%
}
%>
	</select>
    </td>
    <td >&nbsp;</td>
  </tr>
</table>
<%if (flags) {%>
<table class="viewform"><tr><td>
<font color="red">
<!-- a href="AddFormMultiDetail.jsp?formid=<%=formid%>">添加多明细</a-->
<BUTTON class=btnNew type="button" accessKey=A onClick="addRowx('fromfieldoTable');"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18903,user.getLanguage())%></BUTTON></font>
</td></tr></table>
<%}%>
<table  class="viewform" id="fromfieldoTable" >
  <COLGROUP>
   <COL width="45%">
   <COL width="10%">
   <COL width="45%">
<tbody>
<%if (flags) {%>
 <tr class=header>
    <td align=center class=field><%=SystemEnv.getHtmlLabelName(15453,user.getLanguage())%></td>
    <td align=center class=field><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
    <td align=center class=field><%=SystemEnv.getHtmlLabelName(18766,user.getLanguage())%></td>
    <td>&nbsp;</td>
  </tr>
<%	
int clos=0;	
RecordSet.execute("select distinct groupId from workflow_formfield where formid="+formid+" and isdetail='1'  and groupId>0 order by groupId");
while (RecordSet.next())
{%>
<tr>
    <td vaglin="middle">
	<select class=inputstyle  size="15" name="srcListMul<%=clos%>" multiple style="width:100%" onchange="showtitle(event)" ondblclick="addSrcToDestList3('srcListMul<%=clos%>','destListMul<%=clos%>')">
    <%
        FieldMainManager.resetParameter() ;
        FieldMainManager.setUserid(user.getUID());
        FieldMainManager.selectAllCodViewDetailField() ;
    %>
	<%while(FieldMainManager.next()){%>
	<option class="vtip" title="<%=FieldMainManager.getFieldManager().getFieldname() %>[<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=FieldMainManager.getFieldManager().getFielddbtype()%>]<%if (!Util.null2String(FieldMainManager.getFieldManager().getDescription()).equals("")){%>[<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:<%=FieldMainManager.getFieldManager().getDescription()%>]<%}%>" value="<%=FieldMainManager.getFieldManager().getFieldid() %>"><%=FieldMainManager.getFieldManager().getFieldname() %>[<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=FieldMainManager.getFieldManager().getFielddbtype()%>]<%if (!Util.null2String(FieldMainManager.getFieldManager().getDescription()).equals("")){%>[<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:<%=FieldMainManager.getFieldManager().getDescription()%>]<%}%>
	</option>
	<%}%>
	</select>
    </td>
    <td align=center>
    	<img src="/images/arrow_u.gif" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromDestList3('destListMul<%=clos%>');">
	<br><br>
    	<img src="/images/arrow_l.gif" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="javascript:deleteFromDestList3('srcListMul<%=clos%>','destListMul<%=clos%>')">
	<br><br>
	<img src="/images/arrow_r.gif"  title="<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>" onclick="javascript:addSrcToDestList3('srcListMul<%=clos%>','destListMul<%=clos%>');">
	<br><br>
	<img src="/images/arrow_d.gif"   title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromDestList3('destListMul<%=clos%>');">
    </td>

    <td align=center>
	<select class=inputstyle  size=15 name="destListMul<%=clos%>" multiple style="width:100%" onchange="showtitle(event)" ondblclick="deleteFromDestList3('srcListMul<%=clos%>','destListMul<%=clos%>')">
<%
FormFieldMainManager.setFormid(formid);
FormFieldMainManager.setGroupId(RecordSet.getInt(1));
FormFieldMainManager.selectDetailFormField();

while(FormFieldMainManager.next()){

%>
	<option class="vtip" title="<%=DetailFieldComInfo.getFieldname(""+FormFieldMainManager.getFieldid())%>[<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=FormFieldMainManager.getFieldDbType()%>]<%if (!FormFieldMainManager.getDescription().equals("")){%>[<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:<%=FormFieldMainManager.getDescription()%>]<%}%>" value="<%=FormFieldMainManager.getFieldid()%>"><%=DetailFieldComInfo.getFieldname(""+FormFieldMainManager.getFieldid())%>[<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>:<%=FormFieldMainManager.getFieldDbType()%>]<%if (!FormFieldMainManager.getDescription().equals("")){%>[<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>:<%=FormFieldMainManager.getDescription()%>]<%}%>
	

	</option>
<%
}
%>
	</select>
    </td>
    <td >&nbsp;</td>
  </tr>
<%
clos++;
}
%>
</tbody>
</table>               
<input type='hidden' id="nodesnum" name="nodesnum" value="0">
<input type='hidden' id="indexnum" name="indexnum" value="0">
<%}%>
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

<br>
</form>

</center>
<%

if(!ajax.equals("1")){
%>
<script language="javascript">
jQuery(document).ready(function(){
	jQuery(".vtip").simpletooltip("click");
	if($.browser.msie){
		jQuery(".vtip").attr("title","");
	}
})
function submitData()
{
	if (checksubmit())
		tabfieldfrm.submit();
}

function submitClear()
{
	if (isdel())
		deleteRow1();
}


function addRowx(obj)
{ 
        var oTbody = fromfieldoTable.tBodies[0];
			
		var ncol = oTbody.rows[0].cells.length;
			
		var oRow = oTbody.insertRow(-1);
			
		var rowindex = oRow.rowIndex - 1;
       
        <%String sHtml1="";
         String sHtml2="";
         String sHtml3="";
        
        // sHtml1="<tr class=header>";
        // sHtml1+="<td width=45% align=center class=field>"+SystemEnv.getHtmlLabelName(15453,user.getLanguage())+"</td>";
	    // sHtml1+="<td width=10% align=center class=field>"+SystemEnv.getHtmlLabelName(104,user.getLanguage())+"</td>";
	    // sHtml1+="<td width=45% align=center class=field>"+SystemEnv.getHtmlLabelName(18766,user.getLanguage())+"</td>";
	    // sHtml1+="<td>&nbsp;</td></tr>";
  
         //sHtml1+="<tr><td vaglin=middle>";
	     sHtml1+="<select class=inputstyle  size=15 name='srcListMul"+"\"+rowindex+\"' multiple style='width:100%' onchange=showtitle(event) ondblclick=addSrcToDestList3('srcListMul"+"\"+rowindex+\"','destListMul"+"\"+rowindex+\"')>";
    
        FieldMainManager.resetParameter() ;
        FieldMainManager.setUserid(user.getUID());
        FieldMainManager.selectAllCodViewDetailField() ;
         while(FieldMainManager.next()){
       	 String text = FieldMainManager.getFieldManager().getFieldname()+"["+SystemEnv.getHtmlLabelName(63,user.getLanguage())+":"+FieldMainManager.getFieldManager().getFielddbtype()+"]";
       	 if (!Util.null2String(FieldMainManager.getFieldManager().getDescription()).equals("")){
       		text+="["+SystemEnv.getHtmlLabelName(433,user.getLanguage())+":"+FieldMainManager.getFieldManager().getDescription()+"]";
   	     }
	     sHtml1+="<option class='vtip' title='"+text+"' value='"+FieldMainManager.getFieldManager().getFieldid()+"'>"+text;
	     
         sHtml1+="</option>";
	    }
	    sHtml1+="</select>";
	    //"</td>";
    
        //sHtml1+="<td align=center>
        sHtml2+="<img src='/images/arrow_u.gif' title='"+SystemEnv.getHtmlLabelName(15084,user.getLanguage())+"' onclick=upFromDestList3('destListMul"+"\"+rowindex+\"')>";
	    sHtml2+="<br><br>";
    	sHtml2+="<img src='/images/arrow_l.gif' title='"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"' onClick=deleteFromDestList3('srcListMul"+"\"+rowindex+\"','destListMul"+"\"+rowindex+\"')>";
	    sHtml2+="<br><br>";
	    sHtml2+="<img src='/images/arrow_r.gif'  title='"+SystemEnv.getHtmlLabelName(456,user.getLanguage())+"' onclick=addSrcToDestList3('srcListMul"+"\"+rowindex+\"','destListMul"+"\"+rowindex+\"')>";
	    sHtml2+="<br><br>";
	    sHtml2+="<img src='/images/arrow_d.gif'   title='"+SystemEnv.getHtmlLabelName(15085,user.getLanguage())+"' onclick=downFromDestList3('destListMul"+"\"+rowindex+\"')>";
       //sHtml1+="</td>";

     //sHtml1+="<td align=center>";
	   sHtml3+="<select class=inputstyle  size=15 name='destListMul"+"\"+rowindex+\"' multiple style='width:100%' onchange=showtitle(event) ondblclick=deleteFromDestList3('srcListMul"+"\"+rowindex+\"','destListMul"+"\"+rowindex+\"')>";

	   FormFieldMainManager.setFormid(formid);
	   FormFieldMainManager.setGroupId(-1);
	   FormFieldMainManager.selectDetailFormField();
	
	   while(FormFieldMainManager.next()){
	  sHtml3+="<option value='"+FormFieldMainManager.getFieldid()+"'>"+DetailFieldComInfo.getFieldname(""+FormFieldMainManager.getFieldid());
      sHtml3+="["+SystemEnv.getHtmlLabelName(63,user.getLanguage())+":"+FormFieldMainManager.getFieldDbType()+"]";
	  if (!FormFieldMainManager.getDescription().equals("")){
	  sHtml3+="["+SystemEnv.getHtmlLabelName(433,user.getLanguage())+":"+FormFieldMainManager.getDescription()+"]";
	  }
	  sHtml3+="</option>";
}

	 sHtml3+="</select>";
	//</td><td >&nbsp;</td></tr>";
        
        %>

       // oCell = oRow.insertCell();
       // oCell.style.height=24;
       // oCell.style.background= "#E7E7E7";
       // var oDiv = document.createElement("div");
       // var sHtml = "<%=sHtml1%>" ;
        //alert(sHtml);
       // oDiv.innerHTML = sHtml;
       // oCell.appendChild(oDiv);
        for(j=0; j<ncol; j++) {
        oCell = oRow.insertCell(-1);
		oCell.style.height = 24;
		
		switch(j) {
		case 0:
		{ 
		var oDiv = document.createElement("div");
        var sHtml = "<%=sHtml1%>" ;
        //alert(sHtml);
        oDiv.innerHTML = sHtml;
        oCell.appendChild(oDiv);
        break;}
		case 1:
		{
		var oDiv = document.createElement("div");
		oDiv.style.textAlign = "center";
        var sHtml = "<%=sHtml2%>" ;
        //alert(sHtml);
        oDiv.innerHTML = sHtml;
        oCell.appendChild(oDiv);
        break;
		}
		case 2:
		{
		var oDiv = document.createElement("div");
        var sHtml = "<%=sHtml3%>" ;
        //alert(sHtml);
        oDiv.innerHTML = sHtml;
        oCell.appendChild(oDiv);
        break;
		}
		case 3:
		}
		
        }
       // rowindex = rowindex*1 +1;
       //curindex = curindex*1 +1;
        //document.all("nodesnum"+obj).value = curindex ;
        //document.all('indexnum'+obj).value = rowindex;
        jQuery(".vtip").simpletooltip("click");
        if($.browser.msie){
    		jQuery(".vtip").attr("title","");
    	}
    
}
</script>
<%}%>
</body>
</html>