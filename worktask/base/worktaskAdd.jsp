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
	if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user)){
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

String items = "";
String divStr = "";
int isnew = Util.getIntValue(request.getParameter("isnew"), 0);
int wtid = Util.getIntValue(request.getParameter("wtid"), 0);


if(isnew == 1 || wtid == 0){
	titlename = SystemEnv.getHtmlLabelName(82, user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(18177, user.getLanguage());
	items = "{ id:'0', contentEl:'div0', title :'"+SystemEnv.getHtmlLabelName(1361, user.getLanguage())+"' }";
	divStr = "<div id=\"div0\"><iframe id=\"ifrm_0\" src=\"/worktask/base/addwt0.jsp\" frameborder=\"0\" style=\"width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding-right:0\" scrolling=\"auto\"></iframe></div>";
}else{
	String name = "";
	RecordSet.execute("select name from worktask_base where id="+wtid);
	if(RecordSet.next()){
		name = ":" + Util.null2String(RecordSet.getString("name"));
	}
	titlename = SystemEnv.getHtmlLabelName(93, user.getLanguage())+name;
	items = "{ id:'0', contentEl:'div0', title :'"+SystemEnv.getHtmlLabelName(1361, user.getLanguage())+"' },";
	items += "{ id:'1', contentEl:'div1', title :'"+SystemEnv.getHtmlLabelName(21945, user.getLanguage())+"' },";
	items += "{ id:'2', contentEl:'div2', title :'"+SystemEnv.getHtmlLabelName(16510, user.getLanguage())+"' },";
	items += "{ id:'3', contentEl:'div3', title :'"+SystemEnv.getHtmlLabelName(21929, user.getLanguage())+"' },";
	items += "{ id:'4', contentEl:'div4', title :'"+SystemEnv.getHtmlLabelName(2112, user.getLanguage())+"' },";
	items += "{ id:'5', contentEl:'div5', title :'"+SystemEnv.getHtmlLabelName(18436, user.getLanguage())+"' },";
	items += "{ id:'6', contentEl:'div6', title :'"+SystemEnv.getHtmlLabelName(17989, user.getLanguage())+"' },";
	items += "{ id:'7', contentEl:'div7', title :'"+SystemEnv.getHtmlLabelName(19504, user.getLanguage())+"' },";
	items += "{ id:'8', contentEl:'div8', title :'"+SystemEnv.getHtmlLabelName(21946, user.getLanguage())+"' }";
	divStr = "<div id=\"div0\" style=\"display:''\"><iframe id=\"ifrm_0\" src=\"/worktask/base/addwt0.jsp?wtid="+wtid+"\" frameborder=\"0\" style=\"width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding-right:0\" scrolling=\"auto\"></iframe></div>";
/*
	divStr += "<div id=\"div1\" style=\"display:none\"><iframe id=\"ifrm_1\" src=\"/worktask/base/worktaskCreateRight.jsp?para=1_"+wtid+"\" frameborder=\"0\" style=\"width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding-right:0\" scrolling=\"auto\"></iframe></div>";
	divStr += "<div id=\"div2\" style=\"display:none\"><iframe id=\"ifrm_2\" src=\"/worktask/base/worktaskFieldEdit.jsp?wtid="+wtid+"\" frameborder=\"0\" style=\"width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding-right:0\" scrolling=\"auto\"></iframe></div>";
	divStr += "<div id=\"div3\" style=\"display:none\"><iframe id=\"ifrm_3\" src=\"/worktask/base/worktaskListEdit.jsp?wtid="+wtid+"\" frameborder=\"0\" style=\"width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding-right:0\" scrolling=\"auto\"></iframe></div>";
	divStr += "<div id=\"div4\" style=\"display:none\"><iframe id=\"ifrm_4\" src=\"/worktask/base/WorkTaskShareSet.jsp?wtid="+wtid+"\" frameborder=\"0\" style=\"width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding-right:0\" scrolling=\"auto\"></iframe></div>";
	divStr += "<div id=\"div5\" style=\"display:none\"><iframe id=\"ifrm_5\" src=\"/worktask/base/WTApproveWfEdit.jsp?wtid="+wtid+"\" frameborder=\"0\" style=\"width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding-right:0\" scrolling=\"auto\"></iframe></div>";
	divStr += "<div id=\"div6\" style=\"display:none\"><iframe id=\"ifrm_6\" src=\"/worktask/base/worktaskMonitorSet.jsp?wtid="+wtid+"\" frameborder=\"0\" style=\"width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding-right:0\" scrolling=\"auto\"></iframe></div>";
	divStr += "<div id=\"div7\" style=\"display:none\"><iframe id=\"ifrm_7\" src=\"/worktask/base/WTCode.jsp?wtid="+wtid+"\" frameborder=\"0\" style=\"width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding-right:0\" scrolling=\"auto\"></iframe></div>";
	divStr += "<div id=\"div8\" style=\"display:none\"><iframe id=\"ifrm_8\" src=\"/worktask/base/RemindedSet.jsp?wtid="+wtid+"\" frameborder=\"0\" style=\"width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding-right:0\" scrolling=\"auto\"></iframe></div>";
*/
	divStr += "<div id=\"div1\" style=\"display:none\"><iframe id=\"ifrm_1\" src=\"\" frameborder=\"0\" style=\"width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding-right:0\" scrolling=\"auto\"></iframe></div>";
	divStr += "<div id=\"div2\" style=\"display:none\"><iframe id=\"ifrm_2\" src=\"\" frameborder=\"0\" style=\"width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding-right:0\" scrolling=\"auto\"></iframe></div>";
	divStr += "<div id=\"div3\" style=\"display:none\"><iframe id=\"ifrm_3\" src=\"\" frameborder=\"0\" style=\"width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding-right:0\" scrolling=\"auto\"></iframe></div>";
	divStr += "<div id=\"div4\" style=\"display:none\"><iframe id=\"ifrm_4\" src=\"\" frameborder=\"0\" style=\"width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding-right:0\" scrolling=\"auto\"></iframe></div>";
	divStr += "<div id=\"div5\" style=\"display:none\"><iframe id=\"ifrm_5\" src=\"\" frameborder=\"0\" style=\"width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding-right:0\" scrolling=\"auto\"></iframe></div>";
	divStr += "<div id=\"div6\" style=\"display:none\"><iframe id=\"ifrm_6\" src=\"\" frameborder=\"0\" style=\"width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding-right:0\" scrolling=\"auto\"></iframe></div>";
	divStr += "<div id=\"div7\" style=\"display:none\"><iframe id=\"ifrm_7\" src=\"\" frameborder=\"0\" style=\"width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding-right:0\" scrolling=\"auto\"></iframe></div>";
	divStr += "<div id=\"div8\" style=\"display:none\"><iframe id=\"ifrm_8\" src=\"\" frameborder=\"0\" style=\"width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding-right:0\" scrolling=\"auto\"></iframe></div>";

}
%>
</head>
<body>
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
												iframe.src="/worktask/base/addwt0.jsp?wtid=<%=wtid%>";
											}else if(newTabId == "1"){
												iframe.src="/worktask/base/worktaskCreateRight.jsp?para=1_<%=wtid%>";
											}else if(newTabId == "2"){
												iframe.src="/worktask/base/worktaskFieldEdit.jsp?wtid=<%=wtid%>";
											}else if(newTabId == "3"){
												iframe.src="/worktask/base/worktaskListEdit.jsp?wtid=<%=wtid%>";
											}else if(newTabId == "4"){
												iframe.src="/worktask/base/WorkTaskShareSet.jsp?wtid=<%=wtid%>";
											}else if(newTabId == "5"){
												iframe.src="/worktask/base/WTApproveWfEdit.jsp?wtid=<%=wtid%>";
											}else if(newTabId == "6"){
												iframe.src="/worktask/base/worktaskMonitorSet.jsp?wtid=<%=wtid%>";
											}else if(newTabId == "7"){
												iframe.src="/worktask/base/WTCode.jsp?wtid=<%=wtid%>";
											}else if(newTabId == "8"){
												iframe.src="/worktask/base/RemindedSet.jsp?wtid=<%=wtid%>";
											}

											var currentTabId=currentTab.id;
											Ext.getDom("div"+newTabId).style.display='';
											Ext.getDom("div"+currentTabId).style.display='none';

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