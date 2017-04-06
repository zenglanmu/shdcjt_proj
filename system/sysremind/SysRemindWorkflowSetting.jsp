<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>

<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>

<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/xtheme-gray.css" />
<script type="text/javascript" src="/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/extjs/ext-all.js"></script>
<script type="text/javascript"  src="/js/weaver.js"></script>
<!-- Files needed for SwfUploaderPanel -->
<%
	String typeids = Util.null2String(request.getParameter("typeids"));
	String flowids = Util.null2String(request.getParameter("flowids"));
	String flowmodule = Util.null2String(request.getParameter("flowmodule"));
	String issubmit = Util.null2String(request.getParameter("issubmit"));
	if(issubmit.equals("true")){
		String strSql="select id from SysPoppupRemindInfoConfig where resourceid ="+user.getUID();
		rs.executeSql(strSql);
		while(rs.next()){
			int setid =  rs.getInt(1);
			String delsql = "delete from SysPoppupRemindInfoConfig where id = "+setid;
			rs.executeSql(delsql);
		}
		String insertSql1 = "insert into SysPoppupRemindInfoConfig (resourceid,id_type,ids,idsmodule) values ("+user.getUID()+",'typeids','-1',"+flowmodule+")";
		rs.executeSql(insertSql1);
		ArrayList typeidList= Util.TokenizerString(typeids,",");
		ArrayList flowidList= Util.TokenizerString(flowids,",");
		for(int i=0;i<typeidList.size();i++){ 
			String  typeid = (String)typeidList.get(i);
			String insertSql = "insert into SysPoppupRemindInfoConfig (resourceid,id_type,ids,idsmodule) values ("+user.getUID()+",'typeids','"+typeid+"',"+flowmodule+")";
			rs.executeSql(insertSql);
		}
		for(int i=0;i<flowidList.size();i++){
			String  flowid = (String)flowidList.get(i);
			String insertSql = "insert into SysPoppupRemindInfoConfig (resourceid,id_type,ids,idsmodule) values ("+user.getUID()+",'flowids','"+flowid+"',"+flowmodule+")";
			rs.executeSql(insertSql);
		}
	}
%>
<%
String loginid = Util.null2String(request.getParameter("loginid"));
int module=0;
String sqlStr = "select idsmodule from SysPoppupRemindInfoConfig  where id_type = 'flowids' and resourceid="+user.getUID();
rs.execute(sqlStr);
if(rs.next()){
	module = rs.getInt("idsmodule");
}
%>

<SCRIPT LANGUAGE="JavaScript">
	 var Tree_Category;
	 Ext.onReady(function() {	
		 

			Ext.BLANK_IMAGE_URL = '/js/extjs/resources/images/default/s.gif';
		   // Define Tree.
			var Tree_Category_Loader = new Ext.tree.TreeLoader({
				baseParams:{"loginid":'<%=loginid%>'},
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
				height           : 500,				
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
				
				if(!node.isExpanded()){	
					node.expand();
					Tree_Category.fireEvent('sleep', node); 
				} else {
					Tree_Category.suspendEvents();
					node.eachChild(function(child) { 
					   child.attributes.checked = checked;  
					   //child.fireEvent('checkchange', child, checked); 
					   child.ui.toggleCheck(checked);  
					});			
						
					if(checked){
						node.parentNode.attributes.checked = checked; 
						node.parentNode.ui.toggleCheck(checked);
					}
					
					var isAllUncheck=true;
					 node.parentNode.eachChild(function(child) { 
						 if(child.attributes.checked) {
							 isAllUncheck=false;
						 }
					 });	
		
					 if(isAllUncheck){
						 node.parentNode.attributes.checked = false; 
						 node.parentNode.ui.toggleCheck(false);
					 }
					
					Tree_Category.resumeEvents();
				}
		    });
			Tree_Category.render();			
			Tree_Category_Root.expand();						
	});


	function onGetChecked(btn){
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
				} 				
			}
		}		
		if(typeids!=="") typeids=typeids.substring(0,typeids.length-1);
		if(flowids!=="") flowids=flowids.substring(0,flowids.length-1);
		document.getElementById("typeids").value = typeids;
		document.getElementById("flowids").value = flowids;
		var module = document.getElementById("module").value;
		document.getElementById("flowmodule").value = module;
		btn.disabled=true;
		document.getElementById("frmFlwCenter").submit();
	}
</script>
<HEAD>

<BODY>
	<%
    int userId = user.getUID();
	String imagefilename = "/images/hdMaintenance.gif";
	String titlename = SystemEnv.getHtmlLabelName(28582,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(320,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	%>
	<%@ include file="/systeminfo/TopTitle.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onGetChecked(this);,_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td >
		
	</td>
	<td valign="top">
		<select style="width:100%" id="module">
			<option value="0" 
			<%if(module==0){ %>
			selected
			<%} %>
			>提醒以下所选类型流程</option>
			<option value="1"
			<%if(module==1){ %>
			selected
			<%} %>
			>排除提醒以下所选类型流程</option>
		</select>
	</td>
	<td >
		
	</td>
</tr>
<tr>
	<td >
	</td>
	<td valign="top">
		<div id="tree"></div>
	</td>
	<td >
		
	</td>
</tr>
</table>
	
<form name="frmFlwCenter"  id="frmFlwCenter" action="" method="post">
	<input type='hidden' name='typeids'  id='typeids'>
	<input type='hidden' name='flowids'  id='flowids'>
	<input type='hidden' name='flowmodule'  id ="flowmodule">
	<input type='hidden' name='issubmit'  value="true">
</form>
</BODY>
</HTML>