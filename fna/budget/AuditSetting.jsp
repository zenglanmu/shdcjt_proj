<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="compInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="budgetHandler" class="weaver.fna.budget.BudgetHandler" scope="page" />
<%
boolean hasPriv = HrmUserVarify.checkUserRight("FnaBudget:All", user);
if (!hasPriv) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
<link type="text/css" rel="stylesheet" href="/js/xloadtree/xtree.css">
<style>
TABLE.Shadow A {
	COLOR: #333; TEXT-DECORATION: none
}
TABLE.Shadow A:hover {
	COLOR: #333; TEXT-DECORATION: none
}

TABLE.Shadow A:link {
	COLOR: #333; TEXT-DECORATION: none
}
TABLE.Shadow A:visited {
	TEXT-DECORATION: none
}
</style>
<script type="text/javascript" src="/js/xloadtree/xtree4performance.js"></script>
<script type="text/javascript" src="/js/xloadtree/xloadtree4performance.js"></script>
<script type="text/javascript" src="/js/xmlextras.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(18436,user.getLanguage());
String needfav ="1";
String needhelp ="";
String companyIcon = "/images/treeimages/global16.gif";
String flowName = "";
RecordSet.executeSql("select * from BudgetAuditMapping where subcompanyid=0");
if(RecordSet.next()){
   flowName= WorkflowComInfo.getWorkflowname(RecordSet.getString("workflowid"));
}

%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
   
    /*
    RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:submitData(),_self} ";
    RCMenuHeight += RCMenuHeightStep;
    */
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

    <table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
        <colgroup>
            <col width="10">
            <col width="">
            <col width="10">
        </colgroup>
        <tr>
            <td></td>
            <td valign="top">
               <table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td></td>
<td valign="top">
<TABLE class="Shadow">
<tr>
<td valign="top">
<!--=================================-->
<TABLE class=ListStyle cellspacing=1>
<TR class=Header>
	<TH width="50%"><%=SystemEnv.getHtmlLabelName(17871,user.getLanguage())%></TH>
	<th width="50%"><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15058,user.getLanguage())%></th>

</TR>
<TR class=Line>
	<TD colSpan=2 style="padding: 0"></TD>
</TR>
<tr>
	<td colspan="2" id="treeTD">
	<script type="text/javascript">
	webFXTreeConfig.blankIcon		= "/images/xp/blank.png";
	webFXTreeConfig.lMinusIcon		= "/images/xp/Lminus.png";
	webFXTreeConfig.lPlusIcon		= "/images/xp/Lplus.png";
	webFXTreeConfig.tMinusIcon		= "/images/xp/Tminus.png";
	webFXTreeConfig.tPlusIcon		= "/images/xp/Tplus.png";
	webFXTreeConfig.iIcon			= "/images/xp/I.png";
	webFXTreeConfig.lIcon			= "/images/xp/L.png";
	webFXTreeConfig.tIcon			= "/images/xp/T.png";

	var rti;
    WebFXTree.prototype.toString = function() {
    var goalFlowStr = "<button class='Browser' type='button' id='SelectFlowID' onClick=\"onShowFlowID('0','"+this.action+"')\" style=''></button>";
	//var planFlowStr = "<button class='Browser' id='SelectFlowID' onClick=\"onShowFlowID('1','"+this.action+"')\" style=''></button>";
	var tmpArray = this.action.split("|");
	var tmpArray2 = tmpArray[2]==null ? "" : tmpArray[2];


	var str = "<table onmouseover=\"document.getElementById('"+this.id+"-anchor').style.backgroundColor='#DDDDDD';document.getElementById('"+this.id+"-anchor').style.border='1px solid #0099CC';\" onmouseout=\"document.getElementById('"+this.id+"-anchor').style.backgroundColor='';document.getElementById('"+this.id+"-anchor').style.border='1px solid #FFFFFF';\" id=\"" + this.id + "\" ondblclick=\"webFXTreeHandler.toggle(this);\" class=\"webfx-tree-item\" onkeydown=\"return webFXTreeHandler.keydown(this, event)\" style=\"width:100%\" cellpadding=\"0\" cellspacing=\"0\"><tr><td width=\"50%\">" +
		"<img id=\"" + this.id + "-icon\" class=\"webfx-tree-icon\" src=\"" + ((webFXTreeHandler.behavior == 'classic' && this.open)?this.openIcon:this.icon) + "\" onclick=\"webFXTreeHandler.select(this);\">" +
		"<span style=\"cursor:hand;border:1px solid #FFFFFF;padding:0 4px 0 4px\" id=\"" + this.id + "-anchor\" onfocus=\"webFXTreeHandler.focus(this);\" onblur=\"webFXTreeHandler.blur(this);\"" +
		(this.target ? " target=\"" + this.target + "\"" : "") +
		">" + this.text + "</span></td><td width=\"50%\">"+goalFlowStr+tmpArray2+"</td></tr></table>" +
		"<div id=\"" + this.id + "-cont\" class=\"webfx-tree-container\" style=\"display: " + ((this.open)?'block':'none') + ";\">";
	var sb = [];
	for (var i = 0; i < this.childNodes.length; i++) {
		sb[i] = this.childNodes[i].toString(i, this.childNodes.length);
	}
	this.rendered = true;
	return str + sb.join("") + "</div>";
};
WebFXTreeItem.prototype.toString = function (nItem, nItemCount) {
	var foo = this.parentNode;
	var indent = '';
	if (nItem + 1 == nItemCount) { this.parentNode._last = true; }
	var i = 0;
	while (foo.parentNode) {
		foo = foo.parentNode;
		indent = "<img id=\"" + this.id + "-indent-" + i + "\" src=\"" + ((foo._last)?webFXTreeConfig.blankIcon:webFXTreeConfig.iIcon) + "\">" + indent;
		i++;
	}
	this._level = i;
	if (this.childNodes.length) { this.folder = 1; }
	else { this.open = false; }
	if ((this.folder) || (webFXTreeHandler.behavior != 'classic')) {
		if (!this.icon) { this.icon = webFXTreeConfig.folderIcon; }
		if (!this.openIcon) { this.openIcon = webFXTreeConfig.openFolderIcon; }
	}
	//else if (!this.icon) { this.icon = webFXTreeConfig.fileIcon; }
	var label = this.text.replace(/</g, '&lt;').replace(/>/g, '&gt;');

	//added by hubo,20060125
	//var flowStr = "<button class='Browser' id='SelectFlowID' onClick=\"onShowFlowID('0')\" style='margin-right:200px;float:right'></button>";
	var goalFlowStr = "<button type='button' class='Browser' id='SelectFlowID' onClick=\"onShowFlowID('0','"+this.action+"')\" style=''></button>";

	var tmpArray = this.action.split("|");
	var tmpArray2 = tmpArray[2]==null ? "" : tmpArray[2];


	var str = "<table onmouseover=\"document.getElementById('"+this.id+"-anchor').style.backgroundColor='#DDDDDD';document.getElementById('"+this.id+"-anchor').style.border='1px solid #0099CC';\" onmouseout=\"document.getElementById('"+this.id+"-anchor').style.backgroundColor='';document.getElementById('"+this.id+"-anchor').style.border='1px solid #FFFFFF';\" id=\"" + this.id + "\" ondblclick=\"webFXTreeHandler.toggle(this);\" class=\"webfx-tree-item\" onkeydown=\"return webFXTreeHandler.keydown(this, event)\" style=\"width:100%\" cellpadding=\"0\" cellspacing=\"0\"><tr><td width=\"50%\">" +
		indent +
		"<img id=\"" + this.id + "-plus\" src=\"" + ((this.folder)?((this.open)?((this.parentNode._last)?webFXTreeConfig.lMinusIcon:webFXTreeConfig.tMinusIcon):((this.parentNode._last)?webFXTreeConfig.lPlusIcon:webFXTreeConfig.tPlusIcon)):((this.parentNode._last)?webFXTreeConfig.lIcon:webFXTreeConfig.tIcon)) + "\" onclick=\"webFXTreeHandler.toggle(this);\">" +
		"<img id=\"" + this.id + "-icon\" class=\"webfx-tree-icon\" src=\"" + ((webFXTreeHandler.behavior == 'classic' && this.open)?this.openIcon:this.icon) + "\" onclick=\"webFXTreeHandler.select(this);\">" +
		"<span style=\"cursor:hand;border:1px solid #FFFFFF;padding:0 4px 0 4px\" id=\"" + this.id + "-anchor\" onfocus=\"webFXTreeHandler.focus(this);\" onblur=\"webFXTreeHandler.blur(this);\"" +
		(this.target ? " target=\"" + this.target + "\"" : "") +
		">" + label + "</span></td><td width=\"50%\">"+goalFlowStr+tmpArray2+"</td></tr></table>" +
		"<div id=\"" + this.id + "-cont\" class=\"webfx-tree-container\" style=\"display: " + ((this.open)?'block':'none') + ";\">";
	var sb = [];
	for (var i = 0; i < this.childNodes.length; i++) {
		sb[i] = this.childNodes[i].toString(i,this.childNodes.length);
	}
	this.plusIcon = ((this.parentNode._last)?webFXTreeConfig.lPlusIcon:webFXTreeConfig.tPlusIcon);
	this.minusIcon = ((this.parentNode._last)?webFXTreeConfig.lMinusIcon:webFXTreeConfig.tMinusIcon);
	return str + sb.join("") + "</div>";
    };

    var tree = new WebFXTree('<%=compInfo.getCompanyname("1")%>(<%=SystemEnv.getHtmlLabelName(18716,user.getLanguage())%>)','0|0|<%=flowName%>','','<%=companyIcon%>','<%=companyIcon%>');
	<%out.println(budgetHandler.getSubCompanyTreeJSByComp());%>
	document.write(tree);
	//rti.expand();
	</script>
	</td>
</tr>
</table>
<!--=================================-->
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="2"></td>
</tr>
</table>
            </td>
        </tr>
        <tr>
            <td height="10" colspan="3"></td>
        </tr>
    </table>

<SCRIPT LANGUAGE=javascript>


function onShowFlowID(flowType,obj){
    ids = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere=where formid=154")
    if (ids!=null) {

    var arrayObj = obj.split("|"); 
    if(arrayObj[0]!="0"&&confirm("<%=SystemEnv.getHtmlLabelName(18260,user.getLanguage())%>?")){
		location.href = "BudgetAuditOperation.jsp?syc=y&flowId="+ids.id+"&objId="+arrayObj[0];
	}else{
		location.href = "BudgetAuditOperation.jsp?syc=n&flowId="+ids.id+"&objId="+arrayObj[0];
	}


	}
}

</script>
</BODY>
</HTML>


