<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<%
    String ajax=Util.null2String(request.getParameter("ajax"));
%>
<%if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<%WFNodeMainManager.resetParameter();%>
<html>
<%
	String wfname="";
	String wfdes="";
	String title="";
	int wfid=0;
	int formid=0;
    String isbill = "";
	wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
	title="edit";
	WFManager.setWfid(wfid);
	WFManager.getWfInfo();
	wfname=WFManager.getWfname();
	wfdes=WFManager.getWfdes();
	formid = WFManager.getFormid();
    isbill = WFManager.getIsBill();
	
	String message = Util.null2String(request.getParameter("message"));

	int rowsum=0;
%>
<head>

<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
if(message.equals("1")){

titlename = titlename + "<font color=red>Create" +SystemEnv.getHtmlLabelName(15595,user.getLanguage());
titlename = titlename +"!</font>";
}
String needfav ="";
String needhelp ="";
%>
</head>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>


<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(15598,user.getLanguage())+",javascript:addRow(\"oTableAddwfnode\"),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(15599,user.getLanguage())+",javascript:subclear(\"oTableAddwfnode\"),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(\"oTableAddwfnode\"),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
    if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:history.back(-1),_self}" ;
    else
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:cancelEditNode(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
    if(!ajax.equals("1")){
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>
<form id=nodeform name=nodeform method=post action="wf_operation.jsp">
<%
    if(ajax.equals("1")){
%>
<input type=hidden name=ajax value="1">
<%
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

<table class="ViewForm" cols=4>
 
      	<COLGROUP>
  	<COL width="10%">
  	<COL width="30%">
  	<COL width="30%">
    <COL width="30%">
        <TR class="Title">
    	  <TH colSpan=4><%=SystemEnv.getHtmlLabelName(15596,user.getLanguage())%></TH></TR>
  	<TR class="Spacing" style="height:1px;">
    	  <TD class="Line1" colSpan=4></TD></TR>
</table>
<table class="ViewForm" cols=4 id="oTableAddwfnode">
 
      	<COLGROUP>
  	<COL width="10%">
  	<COL width="30%">
  	<COL width="30%">
    <COL width="30%">
           <tr class=header>
            <td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(15536,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(21393,user.getLanguage())%></td>
</tr>  	<TR class="Spacing" style="height:1px;">
    	  <TD class="Line1" colSpan=4></TD></TR>
<%
String needcheck="";
WFNodeMainManager.setWfid(wfid);
WFNodeMainManager.selectWfNode(); 
while(WFNodeMainManager.next()){
int tmpid = WFNodeMainManager.getNodeid();
String tmpname = WFNodeMainManager.getNodename();
String tmptype = WFNodeMainManager.getNodetype();
String tmpattribute = WFNodeMainManager.getNodeattribute();
int tmppassnum = WFNodeMainManager.getNodepassnum();
needcheck += ",node_"+rowsum+"_name";
%>
<tr>
<td  height="23"><input type='checkbox' name='check_node' value="<%=tmpid%>" ></td>
<td  height="23">
<input type="hidden" name="node_<%=rowsum%>_id" value="<%=tmpid%>">
<input class=Inputstyle type="text" name="node_<%=rowsum%>_name" value="<%=tmpname%>" onblur="checkinput('node_<%=rowsum%>_name','node_<%=rowsum%>_namespan');checkSameName(<%=rowsum%>,this.value)" maxlength=30>
<span id="node_<%=rowsum%>_namespan"><%if(tmpname.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
</td>
<td  height="23">
<select class=inputstyle  name="node_<%=rowsum%>_type">
    <option value="-1">********<%=SystemEnv.getHtmlLabelName(15597,user.getLanguage())%>***********</option>
    <option value="0" <%if(tmptype.equals("0")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></strong>
    <option value="1" <%if(tmptype.equals("1")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></strong>
    <option value="2" <%if(tmptype.equals("2")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></strong>
    <option value="3" <%if(tmptype.equals("3")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></strong>
    </select>
</td>
<td  height="23">
<select class=inputstyle  name="node_<%=rowsum%>_attribute" onchange=changeattri(this)>
    <option value="0" <%if(tmpattribute.equals("0")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></strong>
    <option value="1" <%if(tmpattribute.equals("1")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(21394,user.getLanguage())%></strong>
    <option value="2" <%if(tmpattribute.equals("2")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(21395,user.getLanguage())%></strong>
    <option value="3" <%if(tmpattribute.equals("3")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(21396,user.getLanguage())%></strong>
    <option value="4" <%if(tmpattribute.equals("4")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(21397,user.getLanguage())%></strong>
    </select>
    <input type='input' class='InputStyle' size='5' maxlength=2 name='node_<%=rowsum%>_passnum' <%if(!tmpattribute.equals("3")){%>style='display:none'<%}%> value="<%=tmppassnum%>" onKeyPress=ItemCount_KeyPress() onBlur=checkcount1(this)>
</td>    
</tr>
<%
rowsum += 1;
}
%>
</table>

<BR>
<BR>
<BR>
<table class=ReportStyle>
<TBODY>
<TR><TD>
<B><%=SystemEnv.getHtmlLabelName(19010,user.getLanguage())%></B>:<BR>
<B><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>£º</B><%=SystemEnv.getHtmlLabelName(21425,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(21394,user.getLanguage())%>£º</B><%=SystemEnv.getHtmlLabelName(21426,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(21395,user.getLanguage())%>£º</B><%=SystemEnv.getHtmlLabelName(21427,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(21396,user.getLanguage())%>£º</B><%=SystemEnv.getHtmlLabelName(21428,user.getLanguage())%>
<BR>    
<B><%=SystemEnv.getHtmlLabelName(21397,user.getLanguage())%>£º</B><%=SystemEnv.getHtmlLabelName(21429,user.getLanguage())%>
<BR>
<BR>
</TD>
</TR>
</TBODY>
</table>
</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="4"></td>
</tr>
</table>

<center>
<input type="hidden" value="wfnodeadd" name="src" id="src">
<input type="hidden" value="<%=wfid%>" name="wfid" id="wfid">
<input type="hidden" value="<%=formid%>" name="formid" id="formid">
<input type="hidden" value="0" name="nodesnum" id="nodesnum">
<input type="hidden" value="" name="delids" id="delids">
<input type="hidden" value="<%=isbill%>" name="isbill" id="isbill">
<input type="hidden" value="<%=needcheck%>" name="needcheck" id="needcheck" >
<center>
</form>
<%
    if(ajax.equals("1")){
%>
<div id=noderowsum style="display:none;"><%=rowsum%></div>
<%}else{%>
<script>
rowindex = "<%=rowsum%>";
delids = "";
function addRow()
{
	ncol = oTable.cols;

	oRow = oTable.insertRow();

	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell();
		oCell.style.height=24;
		oCell.style.background= "";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<select class=inputstyle  name='node_"+rowindex+"_type'><option value='-1'>********<%=SystemEnv.getHtmlLabelName(15597,user.getLanguage())%>***********</option><option value='0'><strong><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></strong><option value='1'><strong><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></strong><option value='2'><strong><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></strong><option value='3'><strong><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></strong></select>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='input' class='InputStyle'name='node_"+rowindex+"_name' onblur='checkinput(\"node_"+rowindex+"_name\",\"node_"+rowindex+"_namespan\");checkSameName("+rowindex+",this.value)' maxlength=30><span id='node_"+rowindex+"_namespan'><img src='/images/BacoError.gif' align=absmiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<select class=inputstyle  name='node_"+rowindex+"_attribute' onchange=changeattri(this)><option value='0'><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></option><option value='1'><strong><%=SystemEnv.getHtmlLabelName(21394,user.getLanguage())%></strong><option value='2'><strong><%=SystemEnv.getHtmlLabelName(21395,user.getLanguage())%></strong><option value='3'><strong><%=SystemEnv.getHtmlLabelName(21396,user.getLanguage())%></strong><option value='4'><strong><%=SystemEnv.getHtmlLabelName(21397,user.getLanguage())%></strong></select><input type='input' class='InputStyle' size='5' maxlength=2 name='node_"+rowindex+"_passnum' style='display:none' onKeyPress=ItemCount_KeyPress() onBlur=checkcount1(this)>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
                break;
        }
	}
	document.getElementById("needcheck").value = document.getElementById("needcheck").value+",node_"+rowindex+"_name";
	rowindex = rowindex*1 +1;

}

function changeattri(obj){
    var attriname=obj.name;
    var passnumname=attriname.substring(0,attriname.length-9)+"passnum";
    if(obj.value=="3"){
        document.forms[0].all(passnumname).style.display='';
    }else{
        document.forms[0].all(passnumname).style.display='none';
    }
}

function deleteRow1()
{
	len = document.forms[0].elements.length;
	alert("len:"+len);
	return;
	
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				if(document.forms[0].elements[i].value!='0')
					delids +=","+ document.forms[0].elements[i].value;
				oTable.deleteRow(rowsum1+1);
			}
			rowsum1 -=1;
		}

	}
}

function selectall(){
	document.forms[0].nodesnum.value=rowindex;
	document.forms[0].delids.value=delids;
	window.document.forms[0].submit();
}

function subclear(){
if (isdel()) {
deleteRow1();
}
}

</script>
<%}%>
</body>

</html>
