<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>

<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>



 
<%
int ownerid=Util.getIntValue(request.getParameter("ownerid"));
if(ownerid==0) ownerid=user.getUID() ;
String owneridname=ResourceComInfo.getResourcename(ownerid+"");
String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
%>

 

<HTML>
  <HEAD>
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
	<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/ext-all.css" />
	<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/xtheme-gray.css" />
 </HEAD>
  <BODY>
   
	<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
	<%
	%>
	<%@ include file="/systeminfo/RightClickMenu.jsp" %>

  <div id="tree_projectcategory"></div>
  <br>
  <div align="center">
	<BUTTON type="button" class=btn accessKey=C onclick="window.close()"><U>C</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON><!--取消-->
	&nbsp;
	<BUTTON type="button" class=btn accessKey=R onclick="btnclear_onclick()"><U>R</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON><!--清除-->
  </div>
 </BODY>
 </HTML>

 <SCRIPT LANGUAGE="JavaScript">
	<!--          
	  function onSubmit(obj){        
		 obj.disabled=true ;
		 frmDocSubscribeAdd.submit();
	  }

	   function onBack(){ 
		 window.history.go(-1);
	  }         
	 
	//-->
	</SCRIPT>
	<script type="text/javascript" src="/js/extjs/adapter/ext/ext-base.js"></script>
	<script type="text/javascript" src="/js/extjs/ext-all.js"></script>
	<!-- Files needed for SwfUploaderPanel -->
	
   <SCRIPT LANGUAGE="JavaScript">
		 Ext.onReady(function() {	
			 

			  // Define Tree.
				var Tree_Category_Loader = new Ext.tree.TreeLoader({
					//baseParams:{requestAction: 'projectCategoryTree'},
					dataUrl   :"WfTreeData.jsp?sqlwhere=<%=sqlwhere%>"
				});
				//lable 21409:具有创建权限的目录
				var Tree_Category = new Ext.tree.TreePanel({
					title            : '<%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%>', 
					collapsible      : false,
					animCollapse     : false,
					border           : true,
					id               : "tree_projectcategory",
					el               : "tree_projectcategory",
					autoScroll       : true,
					animate          : true,
					enableDD         : true,
					containerScroll  : true,
					height           : 420,
					width            : 498,
					loader           : Tree_Category_Loader
				});



				  
				// SET the root node.
				//lable 1478: 目录信息
				var Tree_Category_Root = new Ext.tree.AsyncTreeNode({
					text		: '<%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%>',
					
					draggable	: false,
					id		: 'root_0'  //root  main  sub
				});
			 
				// Render the tree.
				Tree_Category.setRootNode(Tree_Category_Root);


				Tree_Category.on("click",function(node,event){
					var nodepara=node.id.split("_");
					var nodetype=nodepara[0];
					var nodeid=nodepara[1];

					if(nodetype=="request"){	
						btnSubmit(nodeid,node.text,node.parentNode.parentNode.text+"/"+node.parentNode.text+"/"+node.text);
						//alert(nodeid+":"+node.text+":"+node.parentNode.parentNode.text+"/"+node.parentNode.text+"/"+node.text);
					}
				});

				Tree_Category.render();
				Tree_Category_Root.expand();
		});
	</script>



	

	
<SCRIPT LANGUAGE=VBScript>

Sub btnclear_onclick()
     window.parent.returnvalue = Array(0,"","")
     window.parent.close
End Sub

Sub btnSubmit(nodeId,nodeText,nodePath)
     window.parent.returnvalue = Array(nodeId,nodeText,nodePath)
     window.parent.close
End Sub
</SCRIPT>