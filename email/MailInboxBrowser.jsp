<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>
<html>
<head>
<link type="text/css" rel="stylesheet" href="/js/mail/xtree.css" />
<style type="text/css" media="screen">
.clickRightMenu{
	BORDER-RIGHT: none;	
	BORDER-TOP: none; 
	BORDER-LEFT: none;
	BORDER-BOTTOM: none; 
	PADDING-RIGHT: 5px; 
	DISPLAY: block; 
	PADDING-LEFT: 5px; 
	LEFT: -10000px;
	PADDING-BOTTOM: 3px; 
	WIDTH: 1px; PADDING-TOP: 3px; 	
	POSITION: absolute; 
	TOP: -10000px
}
.clickRightMenuOver{
	BORDER-RIGHT: #001E9E 1px solid; 
	BORDER-TOP: #001E9E 1px solid; 
	BORDER-LEFT: #001E9E 1px solid;
	PADDING-RIGHT: 10px;	
	DISPLAY: block;
	PADDING-LEFT: 10px;
	PADDING-BOTTOM: 0px;
	FONT: 12px verdana; 	
	WIDTH: 1px; 
	COLOR: #000000; 
	PADDING-TOP: 4px; 	
	HEIGHT: 24px; 
	TEXT-DECORATION: none;
	BORDER-BOTTOM: #001E9E 1px solid; 
	BACKGROUND-COLOR: #EBF8FE
}
.clickRightMenuOut{
	BORDER-RIGHT: #fffffa 1px solid;
	BORDER-TOP: #fffffa 1px solid;
	BORDER-LEFT: #fffffa 1px solid; 
	PADDING-RIGHT: 10px;	
	DISPLAY: block;
	PADDING-LEFT: 10px;
	PADDING-BOTTOM: 0px;
	FONT: 12px verdana; 	
	WIDTH: 1px; 
	COLOR: #000000; 
	PADDING-TOP: 4px; 	
	HEIGHT: 24px; 
	TEXT-DECORATION: none;
	BORDER-BOTTOM: #fffffa 1px solid
}
table.Shadow{
	border: #000000 ;
	width:100% ;
	height:100% ;
	border-color:#ffffff;
	border-top: 3px outset #ffffff;
	border-right: 3px outset #000000;
	border-bottom: 3px outset #000000;
	border-left: 3px outset #ffffff;
	background-color:#FFFFFF
}
</style>
<script type="text/javascript" src="/js/mail/xtree.js"></script>
</head>

<body>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(Util.null2String(request.getParameter("hasMenu")).equals("true")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:setFolder(-4),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
	<col width="10">
	<col width="">
	<col width="10">
</colgroup>
<tr style="height:0px"> 
	<td height="0" colspan="3"></td>
</tr>
<tr>
	<td></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top" style="padding:5px 0 0 10px">
<!--==========================================================================================-->
<script type="text/javascript">
// WebFxTree (sText, sAction, sBehavior, sIcon, sOpenIcon)
webFXTreeConfig.openRootIcon	= "/images/xp/openfolder.png";
webFXTreeConfig.folderIcon		= "/images/xp/folder.png";
webFXTreeConfig.openFolderIcon	= "/images/xp/openfolder.png";
webFXTreeConfig.fileIcon		= "/images/xp/file.png";
webFXTreeConfig.blankIcon		= "/images/xp2/blank.png";
webFXTreeConfig.lMinusIcon		= "/images/xp2/Lminus.png";
webFXTreeConfig.lPlusIcon		= "/images/xp2/Lplus.png";
webFXTreeConfig.tMinusIcon		= "/images/xp2/Tminus.png";
webFXTreeConfig.tPlusIcon		= "/images/xp2/Tplus.png";
webFXTreeConfig.iIcon			= "/images/xp2/I.png";
webFXTreeConfig.lIcon			= "/images/xp2/L.png";
webFXTreeConfig.tIcon			= "/images/xp2/T.png";

var rti;
var tree = new WebFXTree("<%=SystemEnv.getHtmlLabelName(1213,user.getLanguage())%>", "", "", "/images/mail.gif", "/images/mail.gif");
tree.add(rtiInbox = new WebFXTreeItem("<%=SystemEnv.getHtmlLabelName(19816,user.getLanguage())%>", "javascript:setFolder(0)", "", "/images/mail_inbox.gif", "/images/mail_inbox.gif"));
rtiInbox.folderId = "0";
<%=getInboxFolderTreeNode(user, 0)%>
tree.add(rti = new WebFXTreeItem("<%=SystemEnv.getHtmlLabelName(2038,user.getLanguage())%>", "javascript:setFolder(-1)", "", "/images/mail_outbox.gif", "/images/mail_outbox.gif"));
tree.add(rti = new WebFXTreeItem("<%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%>", "javascript:setFolder(-2)", "", "/images/mail_draft.gif", "/images/mail_draft.gif"));
tree.add(rti = new WebFXTreeItem("<%=SystemEnv.getHtmlLabelName(2040,user.getLanguage())%>", "javascript:setFolder(-3)", "", "/images/mail_junk.gif", "/images/mail_junk.gif"));
document.write(tree);
tree.expandAll();

function setFolder(folderId){
	window.parent.parent.returnValue = folderId;
	window.parent.parent.close();
}
function traceMouseDrag(){}
</script>
<!--==========================================================================================-->
		</td>
		</tr>
		</table>
	</td>
</tr>
<tr style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
</table>
</body>
</html>

<%!
//=================================================================
// Tree Node Recursion
//=================================================================
String getInboxFolderTreeNode(weaver.hrm.User user, int parentId){
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	String html = "";
	String sql = "SELECT * FROM MailInboxFolder WHERE userId="+user.getUID()+" AND parentId="+parentId+" ORDER BY folderName";
	rs.executeSql(sql);
	while(rs.next()){
		if(parentId==0){
			html += "rtiInbox.add(rtiInbox"+rs.getInt("id")+" = new WebFXTreeItem('"+rs.getString("folderName")+"',";
		}else{
			html += "rtiInbox"+parentId+".add(rtiInbox"+rs.getInt("id")+" = new WebFXTreeItem('"+rs.getString("folderName")+"',";
		}
		html += "'javascript:setFolder("+rs.getInt("id")+")',";
		html += "'','/images/mail_folder.gif','/images/mail_folder.gif'));";
		html += "rtiInbox"+rs.getInt("id")+".folderId = '"+rs.getInt("id")+"';";
		if(rs.getInt("subCount")!=0){
			html += getInboxFolderTreeNode(user, rs.getInt("id"));
		}
	}
	return html;
}
%>