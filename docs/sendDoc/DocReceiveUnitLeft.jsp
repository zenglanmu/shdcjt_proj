<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ include file="/systeminfo/init.jsp" %>

<%
String rightStr = "SRDoc:Edit";
if(!HrmUserVarify.checkUserRight(rightStr, user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
String receiveUnitId=Util.null2String(request.getParameter("receiveUnitId"));
String nodeid=null;
%>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<script type="text/javascript" src="/js/xtree.js"></script>
<script type="text/javascript" src="/js/xmlextras.js"></script>
<script type="text/javascript" src="/js/cxloadtree.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree2.css" />
<script type="text/javascript">
if (window.jQuery.client.browser == "Firefox") {
	jQuery(document).ready(function () {
		jQuery("#deeptree").css("height", jQuery(document.body).height());
	});
}
</script>
</HEAD>


<BODY onload="initTree()">
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="DocReceiveUnitRight.jsp" method=post target="contentframe">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script>
rightMenu.style.visibility = "hidden";
</script>	

<table height="100%" width=100% class="ViewForm" valign="top">
	
	<!--######## Search Table Start########-->
	<TR>
	<td height="100%" valign="top">
		<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" />
	</td>
	</tr>
	</table>

	<input class=inputstyle type="hidden" id="id" name="id" >
	<input class=inputstyle type="hidden" id="subcompanyid" name="subcompanyid" >

	<!--########//Search Table End########-->
	</FORM>

</BODY>
</HTML>

<script language="javascript">
function initTree(){
    webFXTreeConfig.lMinusIcon      = "/images/xp2/Lminus.png";
    webFXTreeConfig.lPlusIcon       = "/images/xp2/Lplus.png";
    webFXTreeConfig.tMinusIcon      = "/images/xp2/Tminus.png";
    webFXTreeConfig.tPlusIcon       = "/images/xp2/Tplus.png";
    webFXTreeConfig.iIcon           = "/images/xp2/I.png";
    webFXTreeConfig.lIcon           = "/images/xp2/L.png";
    webFXTreeConfig.tIcon           = "/images/xp2/T.png";

	cxtree_id = '<%=Util.null2String(nodeid)%>';
	CXLoadTreeItem("", "/docs/sendDoc/DocReceiveUnitXML.jsp?rightStr=<%=rightStr%>");
	var tree = new WebFXTree();
	tree.add(cxtree_obj);
	//document.write(tree);
	document.getElementById('deeptree').innerHTML = tree;
	cxtree_obj.expand();
}

//to use xtree,you must implement top() and showcom(node) functions

function top(){
<%
	if(subcompanyid!=null&&!subcompanyid.equals("")&&!subcompanyid.equals("0")){
%>
	deeptree.scrollTop=com_<%=subcompanyid%>.offsetTop;
	deeptree.HighlightNode(com_<%=subcompanyid%>.parentElement);
	com_<%=subcompanyid%>.click();
	deeptree.ExpandNode(com_<%=subcompanyid%>.parentElement);
<%
	}else if(receiveUnitId!=null&&!receiveUnitId.equals("")&&!receiveUnitId.equals("0")){
%>
    deeptree.scrollTop=unit_<%=receiveUnitId%>.offsetTop;
    deeptree.HighlightNode(unit_<%=receiveUnitId%>.parentElement);
    unit_<%=receiveUnitId%>.click();
    deeptree.ExpandNode(unit_<%=receiveUnitId%>.parentElement);
<%
	}
%>
}

function showcom(node){
}

function check(node){
}

function setReceiveUnit(nodeid){
    var receiveUnitId = nodeid.substring(nodeid.lastIndexOf("_")+1);
    document.all("id").value = receiveUnitId;

	if(receiveUnitId=="0"||receiveUnitId==0){
		document.SearchForm.action = "DocReceiveUnitRight.jsp";
	}else{
		document.SearchForm.action = "DocReceiveUnitDsp.jsp";
	}

    document.SearchForm.submit();
}
function setSubcompany(nodeid){
    var subcompanyid = nodeid.substring(nodeid.lastIndexOf("_")+1);

    document.getElementById("subcompanyid").value = subcompanyid;

	document.SearchForm.action = "DocReceiveUnitRight.jsp";

    document.SearchForm.submit();
}

</script>
<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub
</SCRIPT>