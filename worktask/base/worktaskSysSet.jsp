<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,
                 weaver.file.Prop,
                 weaver.general.GCONST" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FieldMainManager" class="weaver.workflow.field.FieldMainManager" scope="page"/>
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<jsp:useBean id="DetailFieldComInfo" class="weaver.workflow.field.DetailFieldComInfo" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<%
	if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");
    	
		return;
	}
%>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<!--begin-->
<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/xtheme-gray.css" />
<link rel="stylesheet" type="text/css" href="/css/weaver-ext.css" />	
<script type="text/javascript" src="/js/extjs/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/js/extjs/ext-all.js"></script>  
<%if(user.getLanguage()==7) {%>
	<script type='text/javascript' src='/js/weaver-lang-cn-gbk.js'></script>
	<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-zh_CN_gbk.js'></script>
<%} else if(user.getLanguage()==8) {%>
	<script type='text/javascript' src='/js/weaver-lang-en-gbk.js'></script>
	<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-en.js'></script>
<%}%>
<!--end-->
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(21928, user.getLanguage());
String needfav ="1";
String needhelp ="";
String items = "{ id:'0', contentEl:'div0', title :'"+SystemEnv.getHtmlLabelName(16510, user.getLanguage())+"' },";
items += "{ id:'1', contentEl:'div1', title :'"+SystemEnv.getHtmlLabelName(21929, user.getLanguage())+"' }";
String divStr = "<div id=\"div0\"><iframe id=\"ifrm_0\" src=\"/worktask/base/worktaskFieldEdit.jsp\" frameborder=\"0\" style=\"width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding-right:0\" scrolling=\"auto\"></iframe></div>";
divStr += "<div id=\"div1\"><iframe id=\"ifrm_1\" src=\"/worktask/base/worktaskListEdit.jsp\" frameborder=\"0\" style=\"width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding-right:0\" scrolling=\"auto\"></iframe></div>";
%>
</head>
<body>
    <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

    <%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%@ include file="/systeminfo/TopTitleExt.jsp"%>
<%=divStr%>

<SCRIPT LANGUAGE="JavaScript">
<!--  
		var items=[
		<%=items%>
		];

		Ext.onReady(function() {
			Ext.QuickTips.init();
			Ext.BLANK_IMAGE_URL = '/js/extjs/resources/images/default/s.gif';

			var viewport = new Ext.Viewport({
					layout : 'border',
					items : [	
						panelTitle,		
						new Ext.TabPanel({
						    listeners :{
								beforetabchange :function ( tabPanle,  newTab, currentTab ){
									var newTabId = newTab.id;
									if(newTabId!=null){
										var iframe=document.getElementById("ifrm_"+newTabId);
										try{
											if(newTabId == "0"){
												iframe.src="/worktask/base/worktaskFieldEdit.jsp";
											}else if(newTabId == "1"){
												iframe.src="/worktask/base/worktaskListEdit.jsp";
											}
										}catch(e){}
									}
								}
							},
							//title : 'ttt',
							region : 'center',
							activeTab : 0,
							frame : true,
							tabPosition : 'top',
							//minTabWidth : 150,
							//resizeTabs : true,
							enableTabScroll:true,
							items :items
						})
					]
			});
		});

//-->
</SCRIPT>

</body>
</html>
<BODY>