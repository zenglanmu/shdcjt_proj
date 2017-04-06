<%--
  Created by IntelliJ IDEA.
  User: sean.yang
  Date: 2006-3-3
  Time: 13:21:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%
    String id=Util.null2String(request.getParameter("paraid"));
    String checktype=Util.null2String(request.getParameter("checktype"));  //radio or not
    String onlyendnode=Util.null2String(request.getParameter("onlyendnode")); //如果需要check是否仅仅只是没有孩子的节点
%>
<HTML>
<HEAD>

	<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery-1.4.4.min.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core.min.js"></script>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">

<script language="javascript">
 

//to use xtree,you must implement top() and showcom(node) functions

function top(){

}

function showcom(node){

}

function check(id,name){

}

function onClick(id){
	 var array = id.split("_");
	 id = array[array.length-1]
	       	
     if(id>0){
        document.all.form1.action = "/cpt/maintenance/CptAssortmentView.jsp";
        document.all.paraid.value=id;
     }
     else if(id==0){
        document.all.form1.action = "/cpt/maintenance/CptAssortmentAdd.jsp";
        document.all.paraid.value=0;
     }
     document.all.form1.submit();
}

</script>
<script type="text/javascript">
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/cpt/maintenance/CptAssortmentTreeXML.jsp?" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	//alert("/cpt/maintenance/CptAssortmentTreeXML.jsp?showcptcount=y&checktype=<%=checktype%>&onlyendnode=<%=onlyendnode%><%if(!id.equals("")){%>&id=<%=id%>&init=y<%}%>")
	    	return "/cpt/maintenance/CptAssortmentTreeXML.jsp?showcptcount=y&checktype=<%=checktype%>&onlyendnode=<%=onlyendnode%><%if(!id.equals("")){%>&id=<%=id%>&init=y<%}%>";
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
	
	$(document).ready(function(){
		//初始化zTree
		$.fn.zTree.init($("#ztreeObj"), setting, zNodes);
	});
	
	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
		//alert(msg)
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
		var node = treeObj.getNodeByParam("id", "com_0", null);
	    
	    if (node != undefined && node != null ) {
	    	treeObj.selectNode(node);
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

	
</SCRIPT>
</HEAD>
</HTML>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>
<table height="100%" width="100%" cellspacing="0" cellpadding="0">
    <form action="" name="form1" id ="form1" method="get" target="optFrame">
     <input type="hidden"  name="paraid" id ="paraid">
    <tr>
        <td height="100%">
          <div id="ztreeDiv" style="height:100%;width:100%;">
             	<ul id="ztreeObj" class="ztree"></ul>
             </div>
        <td>
    </tr>
    </form>
</table>
</BODY>
</HTML>
