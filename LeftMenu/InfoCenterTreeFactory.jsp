<%response.setHeader("Cache-Control","no-store");response.setHeader("Pragrma","no-cache");response.setDateHeader("Expires",0);%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Pragma" content="no-cache" /> 
<meta http-equiv="Cache-Control" content="no-cache" /> 
<meta http-equiv="Expires" content="0" />
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
webFXTreeConfig.fileIcon		= "/images/xp/file.png";
webFXTreeConfig.lMinusIcon		= "/images/xp/Lminus.png";
webFXTreeConfig.lPlusIcon		= "/images/xp/Lplus.png";
webFXTreeConfig.tMinusIcon		= "/images/xp/Tminus.png";
webFXTreeConfig.tPlusIcon		= "/images/xp/Tplus.png";
webFXTreeConfig.iIcon			= "/images/xp/I.png";
webFXTreeConfig.lIcon			= "/images/xp/L.png";
webFXTreeConfig.tIcon			= "/images/xp/T.png";

var rti;
var tree = new WebFXTree();
tree.add(rti = new WebFXLoadTreeItem("", "InfoCenterTree.jsp"));
document.write(tree);
rti.expand();
</script>

</body>
</html>
