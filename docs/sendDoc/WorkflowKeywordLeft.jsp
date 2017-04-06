<%@ page language="java" contentType="text/html; charset=GBK"%>

<jsp:useBean id="WorkflowKeywordComInfo"
	class="weaver.docs.senddoc.WorkflowKeywordComInfo" scope="page" />

<%@ include file="/systeminfo/init.jsp"%>

<%

String keywordId=Util.null2String(request.getParameter("keywordId"));

boolean exist=false;
if(keywordId!=null){
	exist=WorkflowKeywordComInfo.getKeywordName(""+keywordId).equals("")?false:true;
}

if(!exist){
	keywordId="";
}

%>



<script type="text/javascript">
//<!--
if (window.jQuery.client.browser == "Firefox") {
	jQuery(document).ready(function (){
		jQuery("#ztreeDiv").height(jQuery(document.body).height());
	});
}
//-->
</script>
<HTML>
<HEAD>
	<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery-1.4.4.min.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core.min.js"></script>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
</HEAD>


<BODY>
<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom: 0"
	action="WorkflowKeywordDsp.jsp" method=post target="contentframe">


<table height="100%" width=100% class="ViewForm" valign="top">

	<!--######## Search Table Start########-->
	<TR>
		<td height="100%">
		<div id="ztreeDiv" style="height:100%;width:100%;overflow:auto;">
             	<ul id="ztreeObj" class="ztree"></ul>
             </div>
		</td>
	</tr>
</table>

<input class=inputstyle type="hidden" name="id" id="hdnid"> <!--########//Search Table End########-->
</FORM>

</BODY>
</HTML>

<script type="text/javascript">
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/docs/sendDoc/WorkflowKeywordLeftXML.jsp?" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/docs/sendDoc/WorkflowKeywordLeftXML.jsp<%if(keywordId!=null){%>?init=true&keywordId=<%=keywordId%><%}%>";
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
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    //treeObj.expandAll(true);keyword_0
	    var node = treeObj.getNodeByParam("id", "keyword_<%=keywordId%>", null);
	    
	    if (node != undefined && node != null ) {
	    	treeObj.selectNode(node);
	    	zTreeOnClick(event, treeId, node);
	    }
	}
	
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
		setKeyword(treeNode.id);
	};


	function setKeyword(nodeId) {

	    var keywordId=nodeId.substring(nodeId.lastIndexOf("_")+1);

		if(keywordId==0){
		    $("#SearchForm").attr("action", "WorkflowKeyword.jsp");
		    $("#hdnid").val(keywordId);
		    $("#SearchForm")[0].submit();
		}else{
		    $("#SearchForm").attr("action", "WorkflowKeywordDsp.jsp");
		    $("#hdnid").val(keywordId);
		    $("#SearchForm")[0].submit();
		}
	}
</SCRIPT>