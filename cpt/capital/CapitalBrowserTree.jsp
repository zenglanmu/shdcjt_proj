<%--
  Created by IntelliJ IDEA.
  User: sean
  Date: 2006-3-29
  Time: 9:12:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%
    String id=Util.null2String(request.getParameter("capitalgroupid"));
%>
<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery-1.4.4.min.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core.min.js"></script>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">

</HEAD>
</HTML>
<BODY >
<table height="100%" width="100%" cellspacing="0" cellpadding="0">
    <tr>
        <td height="100%">
             <div id="ztreeDiv" style="height:100%;width:100%;">
             	<ul id="ztreeObj" class="ztree"></ul>
             </div>
        </td>
    </tr>
</table>
<script type="text/javascript">

	 $(document).ready(function(){
		//初始化zTree
		$.fn.zTree.init($("#ztreeObj"), setting, zNodes);
	 });

	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/cpt/maintenance/CptAssortmentTreeXML.jsp?" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/cpt/maintenance/CptAssortmentTreeXML.jsp<%if(!id.equals("")){%>?id=<%=id%>&init=y<%}%>";
	    }
	};
	//zTree配置信息
	var setting = {
		async: {
			enable: true,       //启用异步加载
			dataType: "text",   //ajax数据类型
			url: getAsyncUrl    //ajax的url
		},
		data: {
			simpleData: {
				enable: true,   //返回的json数据为简单数据类型，非复杂json数据类型
				idKey:"id",     //tree的标识属性
				pIdKey:"pId",   //父节点标识属性
				rootPId: 0      //顶级节点的父id
			}
		},
		view: {
			expandSpeed: ""     //效果
		},
		callback: {
			onClick: zTreeOnClick,   //节点点击事件
			onAsyncSuccess: zTreeOnAsyncSuccess  //ajax成功事件
		}
	};

	var zNodes =[];
	var isInit=false;

	
	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
		//alert(msg)
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
		var node = treeObj.getNodeByParam("id", "com_0", null);
	    
	    if (node != undefined && node != null ) {
	    if(!isInit){
	    	treeObj.selectNode(node);
	    	isInit =true;	
	    }
	    	//zTreeOnClick(event, treeId, node);
	    }
	}
	
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
		
	    onClick(treeNode.id);
	};
	
	//单击树形菜单中的每一项选中时 onClick() 方法应该和 zTreeOnClick()方法写在一个Script里面 这样在谷歌中才能把选中的节点的值传入到onClick()中
	//2012-13-13 ypc 修改
	function onClick(id){
		var array = id.split("_");
		id = array[array.length-1]
	    window.parent.document.SearchForm.capitalgroupid.value=id;
	    window.parent.document.SearchForm.submit();
	}
	
</SCRIPT>
</BODY>
</HTML>

<script language="javascript">

//to use xtree,you must implement top() and showcom(node) functions

function top(){

}

function showcom(node){

}

function check(id,name){

}
</script>
