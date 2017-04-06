<%@ page language="java" contentType="text/html; charset=GBK" %>
<jsp:useBean id="compInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="chatCompInfo" class="weaver.hrm.chat.ChatHrmListTree" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<%
String companyIcon = "/images/treeimages/global16.gif";
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
<script type="text/javascript" src="/js/chathrm/xtree4goal.js"></script>
<script type="text/javascript" src="/js/xloadtree/xloadtree4goal.js"></script>
<script type="text/javascript" src="/js/xmlextras.js"></script>
</head>
<body style="padding:5px">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script type="text/javascript">
webFXTreeConfig.blankIcon		= "/images/xp2/blank.png";
webFXTreeConfig.lMinusIcon		= "/images/xp2/Lminus.png";
webFXTreeConfig.lPlusIcon		= "/images/xp2/Lplus.png";
webFXTreeConfig.tMinusIcon		= "/images/xp2/Tminus.png";
webFXTreeConfig.tPlusIcon		= "/images/xp2/Tplus.png";
webFXTreeConfig.iIcon			= "/images/xp2/I.png";
webFXTreeConfig.lIcon			= "/images/xp2/L.png";
webFXTreeConfig.tIcon			= "/images/xp2/T.png";

var tree = new WebFXTree('<%=compInfo.getCompanyname("1")%>','setCompany(0);','','<%=companyIcon%>','<%=companyIcon%>');
<%out.println(chatCompInfo.getSubCompanyTreeJSByChat());%>
document.write(tree);
tree.expand();
</script>
</body>
</html>

<script type="text/javascript">
function setCompany(id){
    
}
function setSubcompany(nodeid){ 

}
function setDepartment(nodeid){

}

function setHrm(nodeid){
     objid = nodeid.substring(nodeid.indexOf("_")+1,nodeid.length);
     showHrmChat(objid);
}

</script>