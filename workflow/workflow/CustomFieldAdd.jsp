<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
 if(!HrmUserVarify.checkUserRight("WorkflowCustomManage:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	} 
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String id = Util.null2String(request.getParameter("id"));

String isBill = Util.null2String(request.getParameter("isBill"));

String formID = Util.null2String(request.getParameter("formID"));

int dbordercount = Integer.parseInt(Util.null2String(request.getParameter("dbordercount")));

String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(20773,user.getLanguage())+SystemEnv.getHtmlLabelName(261,user.getLanguage())+SystemEnv.getHtmlLabelName(19653,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doback(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=weaver name=frmMain action="CustomOperation.jsp" method=post>




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

  <TABLE class="viewform">
  
    <COLGROUP> <COL width="20%"> <COL width="30%"> <COL width="20%"> <COL width="20%"><COL width="15%"><TBODY> 
    <TR class="Title"> 
      <TH colSpan=4><%=SystemEnv.getHtmlLabelName(20773,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></TH>
    </TR>
    <TR class="Spacing" style="height:1px;"> 
      <TD class="Line1" colSpan=5 ></TD>
    </TR>
    <tr class=Header> 
   <TD><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></TD>
   <TD><%=SystemEnv.getHtmlLabelName(20779,user.getLanguage())%></TD>
   <TD><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>
   <TD><%=SystemEnv.getHtmlLabelName(20778,user.getLanguage())%></TD> <TD><%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>

    </tr>
    <TR class="Spacing"  style="height:1px;"> 
      <TD class="Line" colSpan=5 ></TD>
    </TR>
    

  <%
    int tmpcount = 0;
   int tmpcount1 = 0;
    int tmpcount2 = 0;
    String ifquery="";
	String isshows="";
    int dborder=-1;
    String dbordertype = "";
    int compositororder = 0;
    String dsporder="";
	String fieldname="";
	String fieldnamevalue="";
	String ifshows="";
    String queryorder="";
	for(int i = -1; i >-10; i--) 
	{
	tmpcount ++;
	ifquery="";
	isshows = ""; 
	dsporder="";
    queryorder="";
    rs.executeSql("select * from Workflow_CustomDspField where customid="+id+" and fieldid="+i+"  ");
    if(rs.next()){
      ifquery=rs.getString("ifquery");
	  isshows=rs.getString("ifshow");
      dsporder=rs.getString("showorder");
	  if (tmpcount1<Util.getIntValue(dsporder))
			tmpcount1=Util.getIntValue(dsporder);
      queryorder=rs.getString("queryorder");
      if (tmpcount2<Util.getIntValue(queryorder))
			tmpcount2=Util.getIntValue(queryorder);
    }

    //if (isshows.equals("1")) tmpcount1++;
	if("-1".equals(""+i))
	{
	fieldname=SystemEnv.getHtmlLabelName(1334,user.getLanguage());
	fieldnamevalue="requestname";
	}
	else if("-2".equals(""+i))
	{
	fieldname=SystemEnv.getHtmlLabelName(15534,user.getLanguage());
	fieldnamevalue="requestlevel";
	}
	else if("-9".equals(""+i))
	{
	fieldname=SystemEnv.getHtmlLabelName(16354,user.getLanguage());
	fieldnamevalue="";
	}
	else if("-8".equals(""+i))
	{
	fieldname=SystemEnv.getHtmlLabelName(1335,user.getLanguage());
	fieldnamevalue="status";
	}
	else if("-7".equals(""+i))
	{
	fieldname=SystemEnv.getHtmlLabelName(17994,user.getLanguage());
	fieldnamevalue="receivedate";
	}
	else if("-6".equals(""+i))
	{
	fieldname=SystemEnv.getHtmlLabelName(18564,user.getLanguage());
	fieldnamevalue="currentnodeid";
	}
	else if("-5".equals(""+i))
	{
	fieldname=SystemEnv.getHtmlLabelName(259,user.getLanguage());
	fieldnamevalue="workflowid";
	}
	else if("-4".equals(""+i))
	{
	fieldname=SystemEnv.getHtmlLabelName(882,user.getLanguage());
	fieldnamevalue="creater";
	}
	else if("-3".equals(""+i))
	{
	fieldname=SystemEnv.getHtmlLabelName(722,user.getLanguage());
	fieldnamevalue="createdate";
	}
  %>
  <TR>
      <TD>
      <%=fieldname%><%if (!fieldnamevalue.equals("")) {%>(<%=fieldnamevalue%>)<%}%>
      <input type="hidden" name='<%="fieldid_"+tmpcount%>' value="<%=i%>">
      <input type="hidden" name='<%="lable_"+tmpcount%>' value=<%=fieldname%>>
      </TD>
      <%String strtmpcount1 =(new Integer(tmpcount)).toString();%>

	  <td class=Field>
           <input type="checkbox" name='<%="isshows_"+tmpcount%>' onclick="onCheckShows(<%=strtmpcount1%>)"  value="1" <%if(isshows.equals("1")){%> checked <%}%> >
      </td>
      <TD class=Field>
         <%if(isshows.equals("1")){%>
         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" onblur="checkint('dsporder_<%=tmpcount%>')"  <%if(!"".equals(dsporder)){%> value=<%=dsporder%> <%}%>  >
         <%}
         else{%>
         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" value="" disabled = "true" onblur="checkint('dsporder_<%=tmpcount%>')">
         <%}%>
      </TD>
      <td class=Field>
           <input type="checkbox" name='<%="ifquery_"+tmpcount%>' value="1" <%if(ifquery.equals("1")){%> checked <%}%> onclick='onCheckShow(<%=strtmpcount1%>)' >
      </td>
      <TD class=Field>
         <%if(ifquery.equals("1")){%>

         <input type="text" onKeyPress="Count_KeyPress1('queryorder_',<%=strtmpcount1%>)"  class=Inputstyle name='<%="queryorder_"+tmpcount%>' size="6"  onblur="checkint('queryorder_<%=tmpcount%>')" <%if(!"".equals(queryorder)){%> value=<%=queryorder%> <%}%> >
         <%}
         else{%>

         <input type="text" onKeyPress="Count_KeyPress1('queryorder_',<%=strtmpcount1%>)" class=Inputstyle name='<%="queryorder_"+tmpcount%>' size="6" value="" disabled = "true" onblur="checkint('queryorder_<%=tmpcount%>')">
         <%}%>
      </TD>
      

    </TR>
    <TR class="Spacing"  style="height:1px;"> 
      <TD class="Line" colSpan=5 ></TD>
    </TR>
    
<%}%>

<%
int linecolor=0;
String sql="";
if(isBill.equals("0")){


sql = "select workflow_formfield.fieldid as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formfield.fieldorder as fieldorder,workflow_formdict.fielddbtype as dbtype, workflow_formdict.fieldhtmltype as httype,workflow_formdict.type as type from workflow_formfield,workflow_formdict,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = 1 and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and workflow_formfield.formid="+formID+" and (workflow_formfield.isdetail = '' or workflow_formfield.isdetail is null) order by workflow_formfield.fieldorder";

}else if(isBill.equals("1")){
	sql = "select workflow_billfield.id as id,workflow_billfield.fieldname as name,workflow_billfield.fieldlabel as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.fieldhtmltype as httype, workflow_billfield.type as type from workflow_billfield where workflow_billfield.billid="+formID+"  and (viewtype='0') order by dsporder";

}

rs.executeSql(sql);

while(rs.next()){
if(rs.getString("type").equals("226")||rs.getString("type").equals("227")||rs.getString("type").equals("224")||rs.getString("type").equals("225")){
	//ÆÁ±Î¼¯³Éä¯ÀÀ°´Å¥-zzl
	continue;
}

tmpcount ++;
String fieldid = rs.getString("id"); 
String label = rs.getString("label");
String dbtype= rs.getString("dbtype");
if(isBill.equals("1"))
	label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
ifquery="";
ifshows = ""; 
dsporder="";
queryorder="";
rs1.executeSql("select * from Workflow_CustomDspField where customid="+id+" and fieldid="+fieldid);
if(rs1.next()){
  ifquery=rs1.getString("ifquery");
  dsporder=rs1.getString("showorder");
  ifshows=rs1.getString("ifshow");
  queryorder=rs1.getString("queryorder");
  if (tmpcount1<Util.getIntValue(dsporder))
  tmpcount1=Util.getIntValue(dsporder);
  queryorder=rs1.getString("queryorder");
      if (tmpcount2<Util.getIntValue(queryorder))
			tmpcount2=Util.getIntValue(queryorder);
}

%>

    <TR> 
      <TD><%=label%>(<%=rs.getString("name")%>)
      <input type="hidden" name='<%="fieldid_"+tmpcount%>' value=<%=fieldid%>>
      <input type="hidden" name='<%="lable_"+tmpcount%>' value=<%=label%>>
      </TD>
      <%String strtmpcount =(new Integer(tmpcount)).toString();%>
     
      <td class=Field>
           <input type="checkbox" name='<%="isshows_"+tmpcount%>' onclick="onCheckShows(<%=strtmpcount%>)" value="1" <%if(ifshows.equals("1")){%> checked <%}%> >
      </td>
      <TD class=Field>
         <%if(ifshows.equals("1")){%>

         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount%>)"  class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6"  onblur="checkint('dsporder_<%=tmpcount%>')" <%if(!"".equals(dsporder)){%> value=<%=dsporder%> <%}%> >
         <%}
         else{%>

         <input type="text" onKeyPress="Count_KeyPress1('dsporder_',<%=strtmpcount%>)" class=Inputstyle name='<%="dsporder_"+tmpcount%>' size="6" value="" disabled = "true" onblur="checkint('dsporder_<%=tmpcount%>')">
         <%}%>
      </TD>
      <td class=Field>
           <input type="checkbox" name='<%="ifquery_"+tmpcount%>'  value="1" <%if(ifquery.equals("1")){%> checked <%}%>  onclick='onCheckShow(<%=strtmpcount%>)'>
      </td>
      
      <TD class=Field>
         <%if(ifquery.equals("1")){%>
        
         <input type="text" onKeyPress="Count_KeyPress1('queryorder_',<%=strtmpcount%>)"  class=Inputstyle name='<%="queryorder_"+tmpcount%>' size="6"  onblur="checkint('queryorder_<%=tmpcount%>')" <%if(!"".equals(queryorder)){%> value=<%=queryorder%> <%}%> >
         <%}
         else{%>
        
         <input type="text" onKeyPress="Count_KeyPress1('queryorder_',<%=strtmpcount%>)" class=Inputstyle name='<%="queryorder_"+tmpcount%>' size="6" value="" disabled = "true" onblur="checkint('queryorder_<%=tmpcount%>')">
         <%}%>
      </TD>
    </TR>
    <TR class="Spacing"  style="height:1px;"> 
      <TD class="Line" colSpan=6 ></TD>
    </TR>
    
 
     
<% } %>

  <input type="hidden" name=operation value=formfieldadd>
  <input type="hidden" name=reportid value=<%=id%>>
  <input type="hidden" name=tmpcount value=<%=tmpcount%>>
  <input type="hidden" name=tmpcount1 value=<%=tmpcount1%>>
  <input type="hidden" name=tmpcount2 value=<%=tmpcount2%>>
    </TBODY> 
  </TABLE>
  
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

 </form>

<script language="javascript">
var isenabled;
if(<%=dbordercount%>>0)
  isenabled=false;
else
  isenabled=true;


function submitData()
{    
 if (check_form(frmMain,'fieldidimage')){
	len = document.forms[0].elements.length;
  var i=0;
  var index;
  var selectName;
  var checkName;
  var lableName; 
  var compositororderName;
  submit = true;   

  var rowsum1 = 0;
  
  if(submit == true){
   if(checkSame()){
       enableAllmenu();
   frmMain.submit();
   }
  }
}
}

function doback(){
    enableAllmenu();
    location.href="/workflow/workflow/CustomEdit.jsp?id=<%=id%>";
}

function checkSame(){
var num = <%=tmpcount%>;
var showcount = 0;
var ordervalue = "";
var tempcount = -1;
var checkcount = 0;
for(i=1;i<=num;i++){
if(document.all("isshows_"+i).checked == true){
showcount = showcount+1;
}
}
var arr = new Array(showcount);
for(i=1;i<=num;i++){
if(document.all("isshows_"+i).checked == true){
tempcount = tempcount + 1;
arr[tempcount] = document.all("dsporder_"+i).value;
}
}
for(i=1;i<=num;i++){
checkcount = 0;
if(document.all("isshows_"+i).checked == true){
ordervalue = document.all("dsporder_"+i).value;
 for(a=0;a<arr.length;a++){
   if(parseFloat(ordervalue) == parseFloat(arr[a])){
   checkcount = checkcount + 1;
   }
 }
 if(checkcount>1){
 	alert("<%=SystemEnv.getHtmlLabelName(23277,user.getLanguage())%>!");
  return false;
 }
}
}
return true;
}
<!-- Modified  by xwj on 20051031 for td2974 end -->




 
function onCheckShows(index)
{
   num=document.all("tmpcount1").value;
   if (num=="") num=0;
   num=parseInt(num)+1;
   if(document.all("isshows_" + index).checked == true){
	 document.all("dsporder_" + index).disabled = false;
     document.all("dsporder_" + index).value = num;
     document.all("tmpcount1").value=num;
  }
 else{
      
      document.all("dsporder_" + index).disabled = true;
      document.all("dsporder_" + index).value = "";
      
 }
}


function onCheckShow(index)
{
   num=document.all("tmpcount2").value;
   if (num=="") num=0;
   num=parseInt(num)+1;
   if(document.all("ifquery_" + index).checked == true){
      document.all("queryorder_" + index).disabled = false;
      document.all("queryorder_" + index).value = num;
      document.all("tmpcount2").value=num;
  }
 else{
      document.all("queryorder_" + index).disabled = true;
      document.all("queryorder_" + index).value = "";
 }
}

function checkDsporder(index){ 
     var dsporderValue;
     if(document.all("dsporder_" + index).value == ""){
        document.all("dsporder_" + index).value = "0";
     }
     else{
     checkdecimal_length(index,2);
     }
}

function checkCompositororder(index){
     if(document.all("compositororder_" + index).value == ""){
       document.all("compositororder_" + index).value = "0";
     }
     
}


function Count_KeyPress(name,index)
{
 if(!(window.event.keyCode>=48 && window.event.keyCode<=57)) 
  {
     window.event.keyCode=0;
  }
}

<!-- Modified  by xwj on 2005-06-06 for td2099 end -->
 
 
function bak(){
  document.forms[0].elements[i].enabled==false;
  alert(document.forms[0].elements[i].name.substringData(0,8));
}


<!-- Modified  by xwj on 20051026 for td2974 begin -->

function checkdecimal_length(index,maxlength)
{
	var  elementname = "dsporder_" + index;
	if(!isNaN(parseInt(document.all(elementname).value)) && (maxlength > 0)){
		inputTemp = document.all(elementname).value ;
		if (inputTemp.indexOf(".") !=-1)
		{
			inputTemp = inputTemp.substring(inputTemp.indexOf(".")+1,inputTemp.length);
		}
		if (inputTemp.length > maxlength)
		{
			var tempvalue = document.all(elementname).value;
			tempvalue = tempvalue.substring(0,tempvalue.length-inputTemp.length+maxlength);
			document.all(elementname).value = tempvalue;
		}
	}
}

function Count_KeyPress1(name,index)
{
 var elementname = name + index;
 tmpvalue = document.all(elementname).value;
 var count = 0;
 var len = -1;
 if(elementname){
 len = tmpvalue.length;
 }
 for(i = 0; i < len; i++){
    if(tmpvalue.charAt(i) == "."){
    count++;     
    }
 }
 if(!(((window.event.keyCode>=48) && (window.event.keyCode<=57)) || window.event.keyCode==46 || window.event.keyCode==45) || (window.event.keyCode==46 && count == 1))
  {  
     
     window.event.keyCode=0;
     
  }
}
<!-- Modified  by xwj on 20051026 for td2974 end -->


</script>
</BODY></HTML>
