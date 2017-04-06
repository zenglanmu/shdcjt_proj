<%@ page import="weaver.general.Util" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="/js/xtree.js"></script>
<script type="text/javascript" src="/js/xmlextras.js"></script>
<script type="text/javascript" src="/js/xloadtree.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree.css" />
<base target="mainFrame"/>
</head>
<body oncontextmenu="return false;">
<script type="text/javascript">
/// XP Look
webFXTreeConfig.rootIcon		= "/images/xp/folder.png";
webFXTreeConfig.openRootIcon	= "/images/xp/openfolder.png";
webFXTreeConfig.folderIcon		= "/images/xp/folder.png";
webFXTreeConfig.openFolderIcon	= "/images/xp/openfolder.png";
//webFXTreeConfig.fileIcon		= "/images/xp/file.png";
webFXTreeConfig.fileIcon		= "/images_face/ecologyFace_2/LeftMenuIcon/level3.gif";
webFXTreeConfig.lMinusIcon		= "/images/xp/Lminus.png";
webFXTreeConfig.lPlusIcon		= "/images/xp/Lplus.png";
webFXTreeConfig.tMinusIcon		= "/images/xp/Tminus.png";
webFXTreeConfig.tPlusIcon		= "/images/xp/Tplus.png";
webFXTreeConfig.iIcon			= "/images/xp/I.png";
webFXTreeConfig.lIcon			= "/images/xp/L.png";
webFXTreeConfig.tIcon			= "/images/xp/T.png";

var rti;
var tree = new WebFXTree();
<%if(Util.null2String(request.getParameter("extra")).equals("myReport")){%>
tree.add(rti = new WebFXLoadTreeItem("", "SysSettingTree.jsp?parentid=10"));
<%}else{%>
tree.add(rti = new WebFXLoadTreeItem("", "SysSettingTree.jsp"));
<%}%>
document.write(tree);
rti.expand();
</script>

</body>
</html>
