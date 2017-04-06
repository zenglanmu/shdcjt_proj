<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>

<%@ page import="java.util.*" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>



 
<%
	int eid=Util.getIntValue(request.getParameter("eid"));
	int viewType=Util.getIntValue(request.getParameter("viewType"));  //1:为待办事宜
	String tabId=Util.null2String(request.getParameter("tabId"));
	String showCopy = Util.null2String(request.getParameter("showCopy"));
	String completeflag = Util.null2String(request.getParameter("completeflag"));
	int isExclude=0;
	RecordSet rs=new RecordSet();
	rs.executeSql("select * from hpsetting_wfcenter where eid="+eid+"and tabId='"+tabId+"'");
	if(rs.next()){
		isExclude=rs.getInt("isExclude");			
		completeflag=rs.getString("completeflag");		
	}else{
		if (session.getAttribute(eid + "_Add") != null) {
			Hashtable tabAddList = (Hashtable) session.getAttribute(eid+ "_Add");
			if (tabAddList.containsKey(tabId)) {
				Hashtable tabInfo = (Hashtable) tabAddList.get(tabId);
				isExclude = Util.getIntValue((String) tabInfo.get("isExclude"));
				completeflag = Util.null2String((String) tabInfo.get("completeflag"));
			}
		}
	}
	String strExclude1="";
	String strExclude2="";
	if(isExclude==0){
		strExclude1=" selected ";
	} else {
		strExclude2=" selected ";
	}
%>

<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/xtheme-gray.css" />
<style>
body   {   
  overflow-x   :   auto   ;   
  overflow-y   :   hidden   ;   
    
  }
</style>
<form name="frmFlwCenter"  id="frmFlwCenter" action="WorkflowCenterOpration.jsp" method="post">
	<input type='hidden' name='viewType' value="<%=viewType%>">
	<input type='hidden' name='eid' value="<%=eid%>">
	<input type='hidden' name='typeids'  id='typeids'>
	<input type='hidden' name='flowids'  id='flowids'>
	<input type='hidden' name='nodeids'  id='nodeids'>
	<input type='hidden' name='tabTitle' id='tabTitle'>
	<input type='hidden' name='tabId'    id='tabId'>
	<input type='hidden' name='method'   id='method'>
	<input type='hidden' name='showCopy' id="showCopy" value="<%=showCopy%>">
	<input type='hidden' name='completeflag' id="completeflag" value="<%=completeflag%>">
	<input type="hidden"  id="btnSave"  onclick='onGetChecked()'>
<%if(viewType!=6){%>
	<div>		
		<select  name='isExclude' id='isExclude' style="width:100%" onchange="clearSelected()"><option value='0' <%=strExclude1%>><%=SystemEnv.getHtmlLabelName(22048,user.getLanguage())%></option><option value='1' <%=strExclude2%>><%=SystemEnv.getHtmlLabelName(22049,user.getLanguage())%></option></select>
	</div>
<%}%>
	<div id="tree" style='overflow-x: auto;'></div>
<form>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script type="text/javascript" src="/wui/common/jquery/jquery.js"></script>
<script type="text/javascript" src="/js/homepage/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/homepage/extjs/ext-all.js"></script>
<!-- Files needed for SwfUploaderPanel -->





<SCRIPT LANGUAGE="JavaScript">
	 var Tree_Category;
	 $(document).ready(function() {	
			Ext.BLANK_IMAGE_URL = '/js/extjs/resources/images/default/s.gif';
		   // Define Tree.
			var Tree_Category_Loader = new Ext.tree.TreeLoader({
				baseParams:{"viewType":<%=viewType%>,"eid":<%=eid%>,"tabId":<%=tabId%>},
				dataUrl   :"WorkflowCenterTreeData.jsp"
			});

			
				
			//lable 21409:具有创建权限的目录
			Tree_Category = new Ext.tree.TreePanel({
				//title            : '<%=SystemEnv.getHtmlLabelName(21674,user.getLanguage())%>', 				
				collapsible      : false,
				animCollapse     : false,
				border           : true,
				//id               : "tree_projectcategory",
				el               :'tree',				
				autoScroll       : true,
				animate          : false,					
				containerScroll  : true,
				height           : 282,				
				rootVisible:true,
				loader           : Tree_Category_Loader	
			});



			  
			// SET the root node.
			//lable 1478: 目录信息
			var Tree_Category_Root = new Ext.tree.AsyncTreeNode({
				text		: '<%=SystemEnv.getHtmlLabelName(21674,user.getLanguage())%>',
				
				draggable	: false,
				id		: 'root_0'  //root  main  sub
			});			
			Tree_Category.setRootNode(Tree_Category_Root);
			Tree_Category.on('sleep', function(node) {
				if(!node.isExpanded()){
					setTimeout( function() {Tree_Category.fireEvent('sleep', node); }, 1000); 
				} else {
					Tree_Category.fireEvent('checkchange', node, node.attributes.checked); 
				}
				
			});
			Tree_Category.on('checkchange', function(node, checked) {
								
				if(!node.isExpanded()&&!node.isLeaf()){	
					 if(checked){
						node.expand();
						Tree_Category.fireEvent('sleep', node); 
					 }
				} else {
					  				 
				 node.eachChild(function(child) { 
				   child.attributes.checked = checked;  
				   child.fireEvent('checkchange', child, checked); 
				   child.ui.toggleCheck(checked);  
				 });			
				 node.attributes.checked = checked; 
				 node.ui.toggleCheck(checked);
				 if(checked){
				  	if("true"=="<%=viewType==6%>"||frmFlwCenter.isExclude[frmFlwCenter.isExclude.selectedIndex].value==0){
					  try{
						 node.parentNode.attributes.checked = checked; 
						 node.parentNode.ui.toggleCheck(checked);
						 node.parentNode.parentNode.attributes.checked = checked; 
						node.parentNode.parentNode.ui.toggleCheck(checked);
					  } catch(e){}
					}
				 } else {

					  try{
						 //查看一下其兄弟节点是不是都为空
						 var isAllUncheck=true;
						 node.parentNode.eachChild(function(child) { 
							 if(child.attributes.checked) {
								 isAllUncheck=false;							
							 }
						 });	
							
						  if(isAllUncheck){
						  	 node.parentNode.attributes.checked = checked; 
							 node.parentNode.ui.toggleCheck(checked);
						  }

						  //查看一下其所有的上级节点是不是都为空

						 isAllUncheck=true;
						 node.parentNode.parentNode.eachChild(function(child) { 
						 	if(child.attributes.checked) {
							 	isAllUncheck=false;							
							 }
						 });
							
						
						  if(isAllUncheck){
							 node.parentNode.parentNode.attributes.checked = checked; 
							 node.parentNode.parentNode.ui.toggleCheck(checked);
						  }

					 } catch(e){}
				 }
				}
		    });
			
			Tree_Category.render();			
			Tree_Category_Root.expand();						
	});

	function clearSelected(){
		Tree_Category.root.eachChild(function(child) { 
				child.fireEvent('checkchange', child, false); 
			 });	
	}
	
	function onGetChecked(){
		var objs=Tree_Category.getChecked("id");
		var typeids="";
	    var flowids="";
        var nodeids="";
		
		for(var i=0;i<objs.length;i++){
			var obj=objs[i];
			var pos=obj.indexOf("_");			
			if(pos!=-1){
				var type=obj.substring(0,pos);
				var content=obj.substring(pos+1);
				if(type=="wftype"){
					typeids+=content+",";
				} else if(type=="wf"){
					flowids+=content+",";
				} else if(type=="node"){
					nodeids+=content+",";
				}				
			}
		}		
		if(typeids!=="") typeids=typeids.substring(0,typeids.length-1);
		if(flowids!=="") flowids=flowids.substring(0,flowids.length-1);
		if(nodeids!=="") nodeids=nodeids.substring(0,nodeids.length-1);
		document.getElementById("typeids").value=typeids;
		document.getElementById("flowids").value=flowids;
		document.getElementById("nodeids").value=nodeids;


		//frmFlwCenter.submit();
	}
</script>

	

