<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.workflow.workflow.SubcompanyShowAttrUtil" %>

<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubcompanyShowAttrManager" class="weaver.workflow.workflow.SubcompanyShowAttrManager" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>
<%
String imagefilename = "/images/hdMaintenance.gif";
//TD3935
//modified by hubo,2006-03-16
String titlename = SystemEnv.getHtmlLabelName(18043,user.getLanguage());
String needfav ="1";
String needhelp ="";
 
%>

<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

int workflowId = Util.getIntValue(request.getParameter("workflowId"),0);
int formId = Util.getIntValue(request.getParameter("formId"),0);
int isBill = Util.getIntValue(request.getParameter("isBill"),0);
int fieldId = Util.getIntValue(request.getParameter("fieldId"),0);
int selectValue = Util.getIntValue(request.getParameter("selectValue"),-1);

String companyIcon = "/images/treeimages/global16.gif";
String objPara = SubcompanyShowAttrUtil.getObjPara(workflowId,formId,isBill,fieldId,selectValue,0,"0");
%>

<HTML>
<HEAD>
<link type="text/css" rel="stylesheet" href="/css/Weaver.css">
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
<script type="text/javascript" src="/js/xloadtree/xtree4SubcompanyShowAttr.js"></script>
<script type="text/javascript" src="/js/xloadtree/xloadtree4SubcompanyShowAttr.js"></script>
<script type="text/javascript" src="/js/xmlextras.js"></script>
</head>
<body>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
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
<!--
	<th width="25%"><%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%></th>
-->
	<th width="50%"><%=SystemEnv.getHtmlLabelName(21569,user.getLanguage())%></th>
</TR>
<TR class=Line>
	<TD colSpan=2></TD>
</TR>
<tr>
	<td colspan="2" id="treeTD">
	<script type="text/javascript">
	webFXTreeConfig.blankIcon		= "/images/xp2/blank.png";
	webFXTreeConfig.lMinusIcon		= "/images/xp2/Lminus.png";
	webFXTreeConfig.lPlusIcon		= "/images/xp2/Lplus.png";
	webFXTreeConfig.tMinusIcon		= "/images/xp2/Tminus.png";
	webFXTreeConfig.tPlusIcon		= "/images/xp2/Tplus.png";
	webFXTreeConfig.iIcon			= "/images/xp2/I.png";
	webFXTreeConfig.lIcon			= "/images/xp2/L.png";
	webFXTreeConfig.tIcon			= "/images/xp2/T.png";

	var rti;
	var tree = new WebFXTree('<%=CompanyComInfo.getCompanyname("1")%>','0|0|<%=objPara%>','','<%=companyIcon%>','<%=companyIcon%>');
	<%out.println(SubcompanyShowAttrManager.getSubCompanyTreeJSByComp(workflowId,formId,isBill,fieldId,selectValue));%>
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
<td height="10" colspan="3"></td>
</tr>
</table>

</body>
</html>


<script type="text/javascript">

//obj: objId|objType|详细设置信息|文档属性页设置_docPropId_secCategoryId
function onShowAttr(flowType,obj){
	if(flowType=="0"){
		
	}else if(flowType=="1"){

		var workflowId="<%=workflowId%>";
		var selectItemId="<%=selectValue%>";
		var docPropId=0;
		var pathCategory="";
		var secCategoryId=0;

	    var arrayObj = obj.split("|");
		var docProp=arrayObj[3];
	    var arrayDocProp = docProp.split("_");
		docPropId=arrayDocProp[1];
		secCategoryId=arrayDocProp[2];

		if(secCategoryId==0){
			alert("请先在字段设置中设置分部与文档目录对应");
			return;
		}

		url=encode('/workflow/workflow/WorkflowDocPropDetail.jsp?docPropId=' + docPropId + '&workflowId=' + workflowId+ '&selectItemId=' + selectItemId + '&pathCategory=' + pathCategory + '&secCategoryId=' + secCategoryId+"&objId="+arrayObj[0]+"&objType="+arrayObj[1]);

		var con = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
	}
}

function encode(str){
    return escape(str);
}
</script>