<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<%
    int categoryid = Util.getIntValue(request.getParameter("categoryid"), -1);
    int categorytype = Util.getIntValue(request.getParameter("categorytype"), -1);
    int operationcode = Util.getIntValue(request.getParameter("operationcode"), -1);
    AclManager am = new AclManager();
    if (categoryid != -1 && categorytype != -1) {
        if (!am.hasPermission(categoryid, categorytype, user.getUID(), user.getType(), Util.getIntValue(user.getSeclevel(),0), operationcode)) {
            response.sendRedirect("/notice/noright.jsp");
        	return;
        }
    }
    CategoryTree tree = am.getPermittedTree(user.getUID(), user.getType(), Util.getIntValue(user.getSeclevel(),0), operationcode);
%>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<script>
function clearCategory() {
    window.parent.returnValue=Array(0, 0);
    window.parent.close();
}
function selectCategory(nodeID) {
    var node = tree.getNode(nodeID);
    var path = node.text;
    var id = node.categoryid;
    var subid = -1;
    var mainid = -1;
    while (node.parent != null) {
        path = node.parent.text + "/" + path;
        if (node.parent.categorytype == 1 && subid == -1) {
            subid = node.parent.categoryid;
        }
        if (node.parent.categorytype == 0) {
            mainid = node.parent.categoryid;
        }
        node = node.parent;
    }
    window.parent.returnValue = Array(1, id, path, mainid, subid);
    window.parent.close();
}
</script>
</HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>


<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">


<iframe height=0 src="about:blank" width=0></iframe>

<DIV align=right style="display:none">

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=2 onclick="clearCategory()" id=btnclear><U></U><%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>

<table class=ViewForm>
    <colgroup>
        <col width=100%>
    <tr class=Spacing>
        <TD class=Line1 colspan=1></TD>
    </tr>
</table>

<script src=/js/tree_maker.js></script>
<script>
function load(nodeID) // nodeID为点击结点的id
{
    var node = tree.getNode(nodeID);
    if( node && node.loaded!=true ) // 如果未加载就载入子菜单
    {  	
		var str=new String(window.location);
		str=str.substring(0,str.lastIndexOf("/")+1);
        window.frames[0].location= str +"OpenCategory.jsp?categoryid="+node.categoryid+"&categorytype="+node.categorytype+"&node="+nodeID;
    }
}
function findThisNode(categoryid, categorytype) {
    var i;
    var node;
    for (i=0;i<Tree_node_array.length;i++) {
        node = Tree_node_array[i];
        if (node != null && node.categoryid == categoryid && node.categorytype == categorytype) {
            return node;
        }
    }
    return null;
}
function loadthisnode(categoryid, categorytype) {
    var node = findThisNode(categoryid, categorytype);
    if (node != null) {
        load(node.id);
    }
}
function expandthisnode(categoryid, categorytype) {
    var node = findThisNode(categoryid, categorytype);
    if (node != null) {
        alert('expanding ' + node.text);
        node.expand(true);
    }
}
</script>
<script>
var tree = new Tree_treeView(); // 生成 Tree_treeView 对象
tree.showLine=true; //显示连线
tree.lineFolder = "/images/treemaker/"
tree.fileImg="/images/treemaker/link.gif"; // 设置默认图片
tree.folderImg1="/images/treemaker/clsfld.gif";
tree.folderImg2="/images/treemaker/openfld.gif";
var node;
var parentNode;
<%
    CategoryUtil.generateAddNodeScript(out, tree.mainCategories, null);
    if (categoryid > 0) {
        if (categorytype == AclManager.CATEGORYTYPE_SUB || categorytype == AclManager.CATEGORYTYPE_SEC) {
            int id;
            int type;
            CategoryManager cm = new CategoryManager();
            RecordSet rs = cm.getSuperiorSubCategoryList(categoryid, categorytype);
            int i = 0;
            while (rs.next()) {
                if (i == 0) {
                    i = 1;
                    id = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(rs.getString("subcategoryid")),0);
%>
parentNode = findThisNode(<%=id%>, <%=AclManager.CATEGORYTYPE_MAIN%>);
parentNode.expand(true);
<%
                }
                id = rs.getInt("subcategoryid");
%>
parentNode = findThisNode(<%=id%>, <%=AclManager.CATEGORYTYPE_SUB%>);
parentNode.expand(true);
<%
            }
        }
    }
%>
</script>

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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

</BODY></HTML>
