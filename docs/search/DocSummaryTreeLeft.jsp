<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ include file="/systeminfo/init.jsp" %>
<HTML>
<HEAD>
    <meta http-equiv="Pragma" content="no-cache" /> 
    <meta http-equiv="Cache-Control" content="no-cache" /> 
    <meta http-equiv="Expires" content="0" />
    
    <script type="text/javascript" src="/js/xmlextras.js"></script>
    <script type="text/javascript" src="/js/xtree1.js"></script>
    <script type="text/javascript" src="/js/xloadtree.js"></script>
	
	<link type="text/css" rel="stylesheet" href="/css/Weaver.css">
	<link type="text/css" rel="stylesheet" href="/js/xloadtree/xtree.css">

    <base target="mainFrame"/>

</HEAD>
<%
String displayUsage=Util.null2o(request.getParameter("displayUsage"));
int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
int infoId = Util.getIntValue(request.getParameter("infoId"),0);
String selectedContent = Util.null2String(request.getParameter("selectedContent"));

String selectArr = "";
LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
if(info!=null){
	selectArr = info.getSelectedContent();
}
if(!"".equals(selectedContent))
{
	selectArr = selectedContent;
}
selectArr+="|";
%>
<BODY oncontextmenu="return false;">
    <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

    <%@ include file="/systeminfo/RightClickMenu.jsp" %>

    <table width=100% class="ViewForm" valign="top">

        <TR>
            <td>
                
				    <script type="text/javascript">
				      // XP Look
				      webFXTreeConfig.rootIcon        = "/images/xp/folder.png";
				      webFXTreeConfig.openRootIcon    = "/images/xp/openfolder.png";
				      webFXTreeConfig.folderIcon      = "/images/xp/folder.png";
				      webFXTreeConfig.openFolderIcon  = "/images/xp/openfolder.png";
				      webFXTreeConfig.fileIcon        = "/images/xp/folder.png";
				      webFXTreeConfig.lMinusIcon      = "/images/xp/Lminus.png";
				      webFXTreeConfig.lPlusIcon       = "/images/xp/Lplus.png";
				      webFXTreeConfig.tMinusIcon      = "/images/xp/Tminus.png";
				      webFXTreeConfig.tPlusIcon       = "/images/xp/Tplus.png";
				      webFXTreeConfig.iIcon           = "/images/xp/I.png";
				      webFXTreeConfig.lIcon           = "/images/xp/L.png";
				      webFXTreeConfig.tIcon           = "/images/xp/T.png";
				  	  
				  	  var rti;
				      var tree = new WebFXTree('Root');
				      tree.setBehavior('explorer');
				      tree.add(rti = new WebFXLoadTreeItem("", "DocSummaryTreeLeftXML.jsp?fromadvancedmenu=<%=fromAdvancedMenu%>&infoId=<%=infoId%>&selectedContent=<%=selectedContent%>"));
				
				      document.write(tree);
				      
				      rti.expand();
				    </script>
            <td>
        </tr>
    </table>
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="DocSummaryList.jsp" method=post target="contentframe">
    <input type="hidden" name="displayUsage" value="<%=displayUsage%>">
    <input type="hidden" name="fromadvancedmenu" value="<%=fromAdvancedMenu%>">
    <input type="hidden" name="selectedContent" value="<%=selectedContent%>">
    <input type="hidden" name="infoId" value="<%=infoId%>">
    <input type="hidden" name="isNew" value="">
    <input type="hidden" name="maincategory" value="">
    <input type="hidden" name="subcategory" value="">
    <input type="hidden" name="seccategory" value="">
    <input type="hidden" name="showDocs" value="">
    </FORM>
    
<script type="text/javascript">
function onClickCategory(id,level) {
	document.all("maincategory").value = "";
	document.all("subcategory").value = "";
	document.all("seccategory").value = "";
	document.all("showDocs").value = "";
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
function onClickDocNumber(id,level) {
	document.all("maincategory").value = "";
	document.all("subcategory").value = "";
	document.all("seccategory").value = "";
	document.all("showDocs").value = "";
	document.all("isNew").value = "";
	if(level==0){
		document.all("showDocs").value = 1;
		document.all("maincategory").value = id;
		document.SearchForm.submit();
	} else if(level==1) {
		document.all("showDocs").value = 1;
		document.all("subcategory").value = id;
		document.SearchForm.submit();
	} else if(level==2) {
		document.all("showDocs").value = 1;
		document.all("seccategory").value = id;
		document.SearchForm.submit();
	}
}
function onOverNewDocNumber(obj) {
	obj.style.color="#FF0000";
}
function onOutNewDocNumber(obj) {
	obj.style.color="#0000FF";
}
function onClickNewDocNumber(id,level) {
	document.all("maincategory").value = "";
	document.all("subcategory").value = "";
	document.all("seccategory").value = "";
	document.all("showDocs").value = "";
	document.all("isNew").value = "yes";
	if(level==0){
		document.all("showDocs").value = 1;
		document.all("maincategory").value = id;
		document.SearchForm.submit();
	} else if(level==1) {
		document.all("showDocs").value = 1;
		document.all("subcategory").value = id;
		document.SearchForm.submit();
	} else if(level==2) {
		document.all("showDocs").value = 1;
		document.all("seccategory").value = id;
		document.SearchForm.submit();
	}
}
</script>
</BODY>
</HTML>