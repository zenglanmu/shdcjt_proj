<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
int formid = Util.getIntValue(request.getParameter("formid"));
int layouttype = Util.getIntValue(request.getParameter("layouttype"));
int isbill = Util.getIntValue(request.getParameter("isbill"),0);
String layoutname = Util.null2String(request.getParameter("layoutname"));
String sqlStr = "";
if(!"".equals(layoutname)){
	sqlStr = " and layoutname like '%"+layoutname.replaceAll("'", "''")+"%'";
}
ArrayList modeidlist=new ArrayList();
ArrayList modenamelist=new ArrayList();
ArrayList modeisform=new ArrayList();
ArrayList nodenamelist=new ArrayList();
ArrayList workflownames=new ArrayList();
String id="0";
String modename="";
if(layouttype==1){//打印模板
	sqlStr += " and type in (0, 1) ";
}else if(layouttype == 0){
	sqlStr += " and type=0 ";
}else if(layouttype == 2) {
	sqlStr += " and type=2 ";
}
//添加and (b.isFreeNode != '1' OR b.isFreeNode IS null)条件, 限制查询条件不包括自由流转中的节点
RecordSet.executeSql("select l.id, l.layoutname, n.nodename, l.type, b.workflowname from workflow_nodehtmllayout l, workflow_base b, workflow_nodebase n where l.nodeid=n.id and l.workflowid=b.id and (n.isFreeNode != '1' OR n.isFreeNode IS null) and l.formid="+formid+" and l.isbill="+isbill+sqlStr+" order by l.nodeid");
while(RecordSet.next()){
    id=RecordSet.getString("id");
    modename=RecordSet.getString("layoutname");
    int tisprint=Util.getIntValue(RecordSet.getString("type"),0);
    String nodename=RecordSet.getString("nodename");
    if(layouttype==0 && tisprint==1){
        continue;
    }
    modeidlist.add(id);
    modenamelist.add(modename);
    modeisform.add("0");
    nodenamelist.add(nodename);
    workflownames.add(RecordSet.getString("workflowname"));
}
%>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:SearchForm.submit();,_top} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>


<FORM name="SearchForm" STYLE="margin-bottom:0" action="WorkflowHtmlBrowser.jsp" method="post">
<input type="hidden" id="formid" name="formid" value="<%=formid%>">
<input type="hidden" id="layouttype" name="layouttype" value="<%=layouttype%>">
<input type="hidden" id="isbill" name="isbill" value="<%=isbill%>">
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
<table class="ViewForm">
	<COLGROUP>
		<COL width="20%">
		<COL width="80%">
	<tr>
		<td><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></td>
		<td class="field"><input type="text" class="inputstyle" id="layoutname" name="layoutname" value="<%=layoutname%>"></td>
	</tr>
	<TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1"   width="100%">
<TR class=DataHeader>
<TH width=40%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></TH>
</tr>

<TR class=Line style="height:1px;"><th colspan="5" ></Th></TR>
<%
int i=0;
for(int j=0;j<modeidlist.size();j++){
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
	<TD style="display:none"><%=modeidlist.get(j)%></TD>
	<TD style="display:none"><%=modeisform.get(j)%></TD>
    <TD><%=modenamelist.get(j)%></TD>
	<TD><%=nodenamelist.get(j)%></TD>
    <TD><%=workflownames.get(j)%></TD>
</TR>
<%}%>
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

</FORM>
</BODY>
</HTML>

<script type="text/javascript">

function btnclear_onclick(){
	window.parent.returnValue = {id:"",isForm:"",name:""};
	window.parent.close();
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
jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
})
function BrowseTable_onclick(e){
   var e=e||event;
   var target=e.srcElement||e.target;

   if( target.nodeName =="TD"||target.nodeName =="A"  ){
     window.parent.returnValue = {id:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),isForm:jQuery(jQuery(target).parents("tr")[0].cells[1]).text(),name:jQuery(jQuery(target).parents("tr")[0].cells[2]).text()};
	 window.parent.close();
	}
}


function onSearch(){
	SearchForm.submit();
}
function submitData(){
	btnok_onclick();
}

function submitClear(){
	btnclear_onclick();
}

</script>