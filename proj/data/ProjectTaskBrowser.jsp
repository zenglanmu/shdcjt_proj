<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page"/>

<%@page import="java.net.URLDecoder"%>
<%@page import="weaver.proj.Maint.ProjectTask"%>
<%@page import="weaver.proj.Maint.ProjectTypeComInfo"%><HTML><HEAD>

<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="ProjectManagerBrowser.jsp" method=post>

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

<!--table width=100% class=viewform>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
<TD width=35% class=field>vvvvvvvvvvvvvvvvv</TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
<TD width=35% class=field>ggggggggggggggggg</TD>
</TR>
<TR class=spacing><TD class=line1 colspan=4></TD></TR>
</table-->
<div id="dataDIV"></div>
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
</FORM>
<script type="text/javascript">
function btnclear_onclick(){
	window.parent.parent.returnValue ={id:"",name:""};
	window.parent.parent.close();
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
         p.className = "DataDark"
      }else{
         p.className = "DataLight"
      }
   }
}

function BrowseTable_onclick(e){

   var e=e||event;
   var target=e.srcElement||e.target;
   if( target.nodeName =="TD"||target.nodeName =="A"  ){
	     window.parent.parent.returnValue = {id:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[1]).text()};
		 window.parent.parent.close();
	}
}

function submitData()
{
	if (check_form(SearchForm,''))
		SearchForm.submit();
}

function submitClear()
{
	btnclear_onclick();
}

//≥ı ºªØ

var tasks=window.parent.dialogArguments;
var taskstr = "<TABLE ID=BrowseTable class='BroswerStyle'  cellspacing='1' style='width:100%'><TR class=DataHeader><TH width=15%><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TH><TH><%=SystemEnv.getHtmlLabelName(1352,user.getLanguage())%></TH><TR class=Line><Th colspan='3' ></Th></TR>";

if(tasks.length>0) {
	for(i=0; i<tasks.length; i++) {
		if(i%2==0) taskstr += '<TR class=DataLight>';
		else taskstr += '<TR class=DataDark>';
		taskstr += '<TD>'+(i+1)+'</TD><TD>'+tasks[i].value+'</TD></TR>';
	}
	taskstr += '</TABLE>';
	document.getElementById('dataDIV').innerHTML = taskstr;

	$("#BrowseTable").mouseover(BrowseTable_onmouseover);
	$("#BrowseTable").mouseout(BrowseTable_onmouseout);
	$("#BrowseTable").click(BrowseTable_onclick);
	$("#btnclear").click(btnclear_onclick);
}
</script>
</BODY></HTML>
