<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.formmode.tree.CustomTreeData" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
	<TITLE></TITLE>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery-1.4.4.min.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core.min.js"></script>
	<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client.js"></script>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">
</HEAD>
	<%
		String id = Util.null2String(request.getParameter("id"));
		String expandfirstnode = Util.null2String(request.getParameter("expandfirstnode"));
		String sql = "select * from mode_customtree where id = " + id;
		rs.executeSql(sql);
		while(rs.next()){
			expandfirstnode = Util.null2String(rs.getString("expandfirstnode"));
		}
	%>
<BODY>
	<div style="height:100%">
		<ul id="CustomTree" class="ztree"></ul>
	</div>
	
	<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom:0" action="/formmode/tree/CustomTreeRight.jsp" method="get" target="contentframe">
		<input class=inputstyle type="hidden" name="mainid" id="mainid" value="<%=id%>">
		<input class=inputstyle type="hidden" name="name" id="name" value="">
		<input class=inputstyle type="hidden" name="pid" id="pid" value="0<%=CustomTreeData.Separator %>0">
	</FORM>
	
</BODY>
	<SCRIPT type="text/javascript">
	var firstclick = 0;
	var expandfirstnode = "<%=expandfirstnode%>";
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		var url = "";
		//获取子节点时
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	url = "/formmode/tree/CustomTreeAjax.jsp?id=<%=id%>&&init=false&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	url = "/formmode/tree/CustomTreeAjax.jsp?id=<%=id%>&init=true";
	    }
	    return url;
	};
	//zTree配置信息
	var setting = {
		async: {
			enable: true,       //启用异步加载
			dataType: "text",   //ajax数据类型
			url: getAsyncUrl,    //ajax的url
			type:"post",
			autoParam: ["id=pid","name=name"]
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
		$.fn.zTree.init($("#CustomTree"), setting, zNodes);
	});
	
	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
		var node = treeObj.getNodeByParam("id", "field_0", null);
	    if (node != undefined && node != null ) {
	    	treeObj.selectNode(node);
	    	zTreeOnClick(event, treeId, node);
	    	alert(222);
	    }

		//默认展开一级节点
	    if(firstclick==0&&expandfirstnode==1){
			$("#CustomTree_1_switch")[0].click();
			firstclick++;
	    }
	    
	}
	
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
		setTreeField(treeNode);
	};

	function setTreeField(treeNode) {
		var url = "/formmode/tree/CustomTreeHrefAjax.jsp?mainid=<%=id%>&pid="+treeNode.id;
		jQuery.ajax({
			url : url,
			type : "post",
			processData : false,
			data : "",
			dataType : "text",
			async : true,
			success: function do4Success(msg){
				var returnurl = jQuery.trim(msg);
				if(returnurl==""){
					
				}else{//如果返回的url不为空，那么页面跳转
					if(returnurl.toLowerCase().indexOf("http")>-1){
						$("#SearchForm").attr("method","get");
					}else{
						$("#SearchForm").attr("method","post");
					}
					$("#SearchForm").attr("action",returnurl);
				    $("#SearchForm")[0].submit();
				}
			}
		});

	}
	</SCRIPT>
</HTML>