<%@ page language="java" contentType="text/html; charset=gbk" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="companyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

String companyName = companyComInfo.getCompanyname("1");
%>
<!--
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
-->
<html> 
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=gbk" />
<base target="contentframe" />
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript" src="/js/album/xtree.js"></script>
<script type="text/javascript" src="/js/album/xmlextras.js"></script>
<script type="text/javascript" src="/js/album/xloadtree.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree2.css" />
<style>body{margin:0 0 0 3px}</style>
<script type="text/javascript">
  jQuery(document).ready(function(){
    jQuery("#mailTreeMenu").height(jQuery("#treeBody").height());
  }); 
  window.onresize=function(){ 
    jQuery("#mailTreeMenu").height(jQuery("#treeBody").height());
  }
</script>
</head>
<body id="treeBody">
<div id="mailTreeMenu" style="overflow: auto;">
<script type="text/javascript">
//====================================================================
// WebFxTree (sText, sAction, sBehavior, sIcon, sOpenIcon)
//====================================================================
webFXTreeConfig.rootIcon		= "/images/treeimages/global16.gif";
webFXTreeConfig.openRootIcon	= "/images/xp/openfolder.png";
webFXTreeConfig.folderIcon		= "/images/xp/folder.png";
webFXTreeConfig.openFolderIcon	= "/images/xp/openfolder.png";
webFXTreeConfig.fileIcon		= "/images/xp2/file.png";
webFXTreeConfig.lMinusIcon		= "/images/xp2/Lminus.png";
webFXTreeConfig.lPlusIcon		= "/images/xp2/Lplus.png";
webFXTreeConfig.tMinusIcon		= "/images/xp2/Tminus.png";
webFXTreeConfig.tPlusIcon		= "/images/xp2/Tplus.png";
webFXTreeConfig.iIcon			= "/images/xp2/I.png";
webFXTreeConfig.lIcon			= "/images/xp2/L.png";
webFXTreeConfig.tIcon			= "/images/xp2/T.png";

var rti;
var tree = new WebFXLoadTree("<%=companyName%>","PhotoSearchMenuTree.jsp","","","/images/treeimages/global16.gif","/images/treeimages/global16.gif");
document.write(tree);
//tree.expandAll();

// Refresh TreeMenu
function refrehMailTreeMenu(){
	$("mailTreeMenu").innerHTML = tree.toString();
}
</script>
</div>

</script>
</body>
</html>

<%!

%>