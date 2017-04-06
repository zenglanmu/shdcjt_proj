<%--
  Created by IntelliJ IDEA.
  User: sean
  Date: 2006-3-29
  Time: 9:12:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/integration/integrationinit.jsp" %>
<%
    String id=Util.null2String(request.getParameter("capitalgroupid"));
    //1����Դ������2ע��������
    String showtype=Util.null2String(request.getParameter("showtype"));
%>
<HTML>
<HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery-1.4.4.min.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core.min.js"></script>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle.css" type="text/css">

</HEAD>
</HTML>
<BODY oncontextmenu=self.event.returnValue=false>
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
		//��ʼ��zTree
		$.fn.zTree.init($("#ztreeObj"), setting, zNodes);
	 });

	/**
	 * ��ȡurl��alax��ʽ����ӽڵ�ʱʹ�ã�
	 */
	function getAsyncUrl(treeId, treeNode) {
		//��ȡ�ӽڵ�ʱ
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/integration/serviceReg/serviceRegTreeXML.jsp?" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//��ʼ��ʱ
	    	return "/integration/serviceReg/serviceRegTreeXML.jsp<%if(!id.equals("")){%>?id=<%=id%>&init=y<%}%>";
	    }
	};
	//zTree������Ϣ
	var setting = {
		async: {
			enable: true,       //�����첽����
			dataType: "text",   //ajax��������
			url: getAsyncUrl    //ajax��url
		},
		data: {
			simpleData: {
				enable: true,   //���ص�json����Ϊ���������ͣ��Ǹ���json��������
				idKey:"id",     //tree�ı�ʶ����
				pIdKey:"pId",   //���ڵ��ʶ����
				rootPId: 0      //�����ڵ�ĸ�id
			}
		},
		view: {
			expandSpeed: ""     //Ч��
		},
		callback: {
			onClick: zTreeOnClick,   //�ڵ����¼�
			onAsyncSuccess: zTreeOnAsyncSuccess  //ajax�ɹ��¼�
		}
	};

	var zNodes =[];
	

	
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
	
	//�������β˵��е�ÿһ��ѡ��ʱ onClick() ����Ӧ�ú� zTreeOnClick()����д��һ��Script���� �����ڹȸ��в��ܰ�ѡ�еĽڵ��ֵ���뵽onClick()��
	//2012-13-13 ypc �޸�
	function onClick(id){
		if(id){
			var array = id.split("_");
			if(array[2]){
			
				 //1����Դ������2ע��������
	    		if("<%=showtype%>"=="1"){
	    						if(array[2]=="1"){
	    							window.parent.document.getElementById("contentframe").src="/integration/dateSource/dataDMLlist.jsp?hpid="+array[1];
	    						}else if(array[2]=="2"){
	    							window.parent.document.getElementById("contentframe").src="/integration/dateSource/dataWebservicelist.jsp?hpid="+array[1];
	    						}else if(array[2]=="3"){
	    							window.parent.document.getElementById("contentframe").src="/integration/dateSource/dataSAPlist.jsp?hpid="+array[1];
	    						}
	    						//loadurl="/integration/dateSource/dataSAPlist.jsp";
								///integration/dateSource/dataDMLlist.jsp
								///integration/dateSource/dataWebservicelist.jsp
							
	    		}else if("<%=showtype%>"=="2"){
	    				window.parent.document.getElementById("contentframe").src="/integration/serviceReg/serviceReg_"+array[2]+"list.jsp?hpid="+array[1];
	    		}
		  	}
	   }
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