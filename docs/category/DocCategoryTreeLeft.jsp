<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<HTML>
<HEAD>
    <meta http-equiv="Pragma" content="no-cache" /> 
    <meta http-equiv="Cache-Control" content="no-cache" /> 
    <meta http-equiv="Expires" content="0" />
    
    <script type="text/javascript" src="/js/xmlextras.js"></script>
    <script type="text/javascript" src="/js/xtree1.js"></script>
    <script type="text/javascript" src="/js/xloadtree.js"></script>
	
		<link type="text/css" rel="stylesheet" href="/css/Weaver.css">
		<link type="text/css" rel="stylesheet" href="/js/xtree.css">

    <base target="mainFrame"/>

</HEAD>
<%
%>
<script>
WebFXTree.prototype.toString = function() {
	var str = "<div id=\"" + this.id + "\"></div>" +
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
	else if (!this.icon) { this.icon = webFXTreeConfig.fileIcon; }
	//var label = this.text.replace('&lt;', '<').replace('&gt;','>');
	var label = this.text;
	if(label!=""){
		var str = "";
		if(this.action=="noright"){
			str = "<div style=\"margin-left:0px\" id=\"" + this.id + "\" ondblclick=\"webFXTreeHandler.toggle(this);\" class=\"webfx-tree-item\" onkeydown=\"return webFXTreeHandler.keydown(this, event)\">" +
				indent +
				"<img id=\"" + this.id + "-plus\" src=\"" + ((this.folder)?((this.open)?((this.parentNode._last)?webFXTreeConfig.lMinusIcon:webFXTreeConfig.tMinusIcon):((this.parentNode._last)?webFXTreeConfig.lPlusIcon:webFXTreeConfig.tPlusIcon)):((this.parentNode._last)?webFXTreeConfig.lIcon:webFXTreeConfig.tIcon)) + "\" onclick=\"webFXTreeHandler.toggle(this);\">" +
				"<img id=\"" + this.id + "-icon\" class=\"webfx-tree-icon\" src=\"" + ((webFXTreeHandler.behavior == 'classic' && this.open)?this.openIcon:this.icon) + "\">" +
				"<label>" + label + "</label></div>" +
				"<div id=\"" + this.id + "-cont\" class=\"webfx-tree-container\" style=\"display: " + ((this.open)?'block':'none') + ";\">";
		}else{
			str = "<div style=\"margin-left:0px\" id=\"" + this.id + "\" ondblclick=\"webFXTreeHandler.toggle(this);\" class=\"webfx-tree-item\" onkeydown=\"return webFXTreeHandler.keydown(this, event)\">" +
				indent +
				"<img id=\"" + this.id + "-plus\" src=\"" + ((this.folder)?((this.open)?((this.parentNode._last)?webFXTreeConfig.lMinusIcon:webFXTreeConfig.tMinusIcon):((this.parentNode._last)?webFXTreeConfig.lPlusIcon:webFXTreeConfig.tPlusIcon)):((this.parentNode._last)?webFXTreeConfig.lIcon:webFXTreeConfig.tIcon)) + "\" onclick=\"webFXTreeHandler.toggle(this);\">" +
				"<img id=\"" + this.id + "-icon\" class=\"webfx-tree-icon\" src=\"" + ((webFXTreeHandler.behavior == 'classic' && this.open)?this.openIcon:this.icon) + "\" onclick=\"webFXTreeHandler.select(this);\">" +
				"<span style=\"cursor:hand; vertical-align: bottom; padding-left: 4px; line-height: 22px;	letter-spacing: 1pt; word-spacing: 1pt; border-bottom-width: 1px; border-bottom-style: dashed; border-bottom-color: #EEEEEE; color: #000000; \" "+
				" onclick=\"" + this.action + ";webFXTreeHandler.focus(this);\" id=\"" + this.id + "-anchor\" " +
				" onmouseover=\"this.style.color='#FF0000'; \" id=\"" + this.id + "-anchor\" " +
				" onmouseout=\"this.style.color='#000000'; \" id=\"" + this.id + "-anchor\" " +
				" onfocus=\"webFXTreeHandler.focus(this);\" onblur=\"webFXTreeHandler.blur(this);\"" +
				(this.target ? " target=\"" + this.target + "\"" : "") +
				">" + label + "</span></div>" +
				"<div id=\"" + this.id + "-cont\" class=\"webfx-tree-container\" style=\"display: " + ((this.open)?'block':'none') + ";\">";
		}
		var sb = [];
		for (var i = 0; i < this.childNodes.length; i++) {
			sb[i] = this.childNodes[i].toString(i,this.childNodes.length);
		}
		this.plusIcon = ((this.parentNode._last)?webFXTreeConfig.lPlusIcon:webFXTreeConfig.tPlusIcon);
		this.minusIcon = ((this.parentNode._last)?webFXTreeConfig.lMinusIcon:webFXTreeConfig.tMinusIcon);
		return str + sb.join("") + "</div>";
	}else{
		var str = "<div style=\"margin-left:0px\" id=\"" + this.id + "\" ondblclick=\"webFXTreeHandler.toggle(this);\" class=\"webfx-tree-item\" onkeydown=\"return webFXTreeHandler.keydown(this, event)\" style=\"width:0;height:0;overflow:hidden\">" +
			indent +
			"<img id=\"" + this.id + "-plus\" src=\"" + ((this.folder)?((this.open)?((this.parentNode._last)?webFXTreeConfig.lMinusIcon:webFXTreeConfig.tMinusIcon):((this.parentNode._last)?webFXTreeConfig.lPlusIcon:webFXTreeConfig.tPlusIcon)):((this.parentNode._last)?webFXTreeConfig.lIcon:webFXTreeConfig.tIcon)) + "\" onclick=\"webFXTreeHandler.toggle(this);\">" +
			"<img id=\"" + this.id + "-icon\" class=\"webfx-tree-icon\" src=\"" + ((webFXTreeHandler.behavior == 'classic' && this.open)?this.openIcon:this.icon) + "\" onclick=\"webFXTreeHandler.select(this);\">" +
			"<span style=\"cursor:hand; vertical-align: bottom; padding-left: 4px; line-height: 22px;	letter-spacing: 1pt; word-spacing: 1pt; border-bottom-width: 1px; border-bottom-style: dashed; border-bottom-color: #EEEEEE; color: #000000; \" "+
			" onclick=\"" + this.action + ";webFXTreeHandler.focus(this);\" id=\"" + this.id + "-anchor\" " +
			" onmouseover=\"this.style.color='#FF0000'; \" id=\"" + this.id + "-anchor\" " +
			" onmouseout=\"this.style.color='#000000'; \" id=\"" + this.id + "-anchor\" " +
			" onfocus=\"webFXTreeHandler.focus(this);\" onblur=\"webFXTreeHandler.blur(this);\"" +
			(this.target ? " target=\"" + this.target + "\"" : "") +
			">" + label + "</span></div>" +
			"<div id=\"" + this.id + "-cont\" class=\"webfx-tree-container\" style=\"display: " + ((this.open)?'block':'none') + ";\">";
		var sb = [];
		for (var i = 0; i < this.childNodes.length; i++) {
			sb[i] = this.childNodes[i].toString(i,this.childNodes.length);
		}
		this.plusIcon = ((this.parentNode._last)?webFXTreeConfig.lPlusIcon:webFXTreeConfig.tPlusIcon);
		this.minusIcon = ((this.parentNode._last)?webFXTreeConfig.lMinusIcon:webFXTreeConfig.tMinusIcon);
		return str + sb.join("") + "</div>";
	}
};
</script>
<BODY oncontextmenu="return false;">
    <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

    <%@ include file="/systeminfo/RightClickMenu.jsp" %>

    <table width=100% class="ViewForm" valign="top">

        <TR>
            <td>
                
				    <script type="text/javascript">
				  	  webFXTreeConfig.defaultBehavior = "explorer";
				      // XP Look
				      webFXTreeConfig.rootIcon        = "/images/treeimages/global16.gif";
				      webFXTreeConfig.openRootIcon    = "/images/treeimages/global16.gif";
				      webFXTreeConfig.folderIcon      = "/images/treeimages/book1_close.gif";
				      webFXTreeConfig.openFolderIcon  = "/images/treeimages/book1_open.gif";
				      webFXTreeConfig.fileIcon        = "/images/treeimages/subCopany_Colse.gif";
				      webFXTreeConfig.lMinusIcon      = "/images/xp/Lminus.png";
				      webFXTreeConfig.lPlusIcon       = "/images/xp/Lplus.png";
				      webFXTreeConfig.tMinusIcon      = "/images/xp/Tminus.png";
				      webFXTreeConfig.tPlusIcon       = "/images/xp/Tplus.png";
				      webFXTreeConfig.iIcon           = "/images/xp/I.png";
				      webFXTreeConfig.lIcon           = "/images/xp/L.png";
				      webFXTreeConfig.tIcon           = "/images/xp/T.png";
				  	  
				      var rti;
				      var tree = new WebFXTree('');
				      tree.setBehavior("explorer");
				      
							tree.add(rti = new WebFXLoadTreeItem("<%=SystemEnv.getHtmlLabelName(16447,user.getLanguage())%>", "DocCategoryTreeLeftXML.jsp"));
							
							rti.icon = webFXTreeConfig.rootIcon;
							rti.openIcon = webFXTreeConfig.openRootIcon;

							document.write(tree);
							
							rti.expand();
				    </script>
            </td>
        </tr>
    </table>
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="DocCategoryEdit.jsp" method=post target="contentframe">
    <input type="hidden" name="maincategory" value="">
    <input type="hidden" name="subcategory" value="">
    <input type="hidden" name="seccategory" value="">
    </FORM>
    
<script type="text/javascript">
function onClickCategory(id,level) {
	document.all("maincategory").value = "";
	document.all("subcategory").value = "";
	document.all("seccategory").value = "";
	if(level==0){
		document.all("maincategory").value = id;
		document.SearchForm.submit();
	} else if(level==1) {
		document.all("subcategory").value = id;
		document.SearchForm.submit();
	} else if(level==2) {
		document.all("seccategory").value = id;
		document.SearchForm.submit();
	}
}
</script>
</BODY>
</HTML>