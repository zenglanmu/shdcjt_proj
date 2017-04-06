<%@ page contentType="text/html;charset=gbk"%>
<%@ include file="/systeminfo/init.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=GBK">
		<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/ext-all.css" />
		<link rel="stylesheet" type="text/css" href="css/favourite-viewer.css" />
		<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/xtheme-gray.css" />
		<link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid.css" />	
		
		<script type="text/javascript" src="/js/extjs/adapter/ext/ext-base.js"></script>
		<script type="text/javascript" src="/js/extjs/ext-all.js"></script>
		<link rel="stylesheet" type="text/css" href="/css/weaver-ext.css" />
		<style type="text/css">
			.x-tree-root-node A {
				TEXT-DECORATION: none;
			}
			.x-tree-root-node A:hover {
				TEXT-DECORATION: none;
			}
			
			.x-tree-root-node A:link {
				TEXT-DECORATION: none;
			}
			.x-tree-root-node A:visited {
				TEXT-DECORATION: none;
			}
			.favourites-node{
				height: auto!important;
			}
		</style>
		<%if(user.getLanguage()==7) 
		{
		%>
			<script type='text/javascript' src='js/favourite-lang-cn-gbk.js'></script>
			<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-zh_CN_gbk.js'></script>
		<%
		}
		else if(user.getLanguage()==8) 
		{
		%>
			<script type='text/javascript' src='js/favourite-lang-en-gbk.js'></script>
			<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-en.js'></script>
		<%
		}
		else if(user.getLanguage()==9) 
		{
		%>
			<script type='text/javascript' src='js/favourite-lang-tw-gbk.js'></script>
			<script type='text/javascript' src='/js/extjs/build/locale/ext-lang-zh_TW.js'></script>
		<%
		}
		%>
		<script type="text/javascript" src="js/SysFavouritesPanel.js"></script>
		<script type="text/javascript" src="js/FavouriteTabsPanel.js"></script>
		<script type="text/javascript" src="js/SysFavouritesGrid.js"></script>
		<script type="text/javascript" src="js/FavouriteViewer.js"></script>
		<script type="text/javascript" src="js/FavouritesPanel.js"></script>
		<script type="text/javascript" src="js/FavouriteEditWindow.js"></script>
		<script type="text/javascript" src="/js/extjs/examples/view/data-view-plugins.js"></script>
		
		<script type="text/javascript">
		function openFullWindowForXtable(url)
		{
		  var grid = Ext.getCmp('topic-grid');
		  grid.suspendEvents();
		  var redirectUrl = url ;
		  window.open(redirectUrl);
		  //var width = screen.width ;
		  //var height = screen.height ;
		  //var szFeatures = "top=100," ;
		  //szFeatures +="left=400," ;
		  //szFeatures +="width="+width/2+"," ;
		  //szFeatures +="height="+height/2+"," ;
		  //szFeatures +="directories=no," ;
		  //szFeatures +="status=yes," ;
		  //szFeatures +="menubar=no," ;
		  //szFeatures +="scrollbars=yes," ;
		  //szFeatures +="resizable=yes" ; 
		  
		  //oNewWindow = window.open(redirectUrl,"",szFeatures) ;
		  //oNewWindow.onblur = gridResumeEvents(grid);
		  //oNewWindow.opener.onfocus = gridResumeEvents(grid);
		}
		function gridResumeEvents()
		{
			var grid = Ext.getCmp('topic-grid');
			grid.resumeEvents();
		}
		var win;
		function showOuterEditWindow(favouriteid,title,importlevel,type)
		{
			var ItemData = Ext.data.Record.create([ 
				{name: 'id'}, 
				{name: 'title'}, 
				{name: 'importlevel'},
				{name: 'favouritetype'}
			]);
			var itemData = new ItemData({ 
				id: favouriteid, 
				title: title, 
				importlevel: importlevel,
				favouritetype: type
		    }); 
		   var data = itemData.data;
		   win = new FavouriteEditWindow(data,2,favourite.maingrid.editfavourite);
		   win.on('validsysfavourite', this.editOuterSysFavourite, this);
		   win.show();
		}
		function editOuterSysFavourite()
		{
			if(win)
		   	{
		   		win.close();
		   	}
		   	var grid = Ext.getCmp('topic-grid');
		   	grid.store.reload();
		}
		function doScrollerIE(dir, amount) 
		{	
			if (amount==null) 
			{
				amount=10;
			}	
			if (dir=="left")
			{
				document.getElementById("favouriteinnertabs").scrollLeft-=amount;
			}
			else
			{
				document.getElementById("favouriteinnertabs").scrollLeft+=amount;
			}
			return false;
		}
		function saveLastActiveTab()
		{
			var activeid = "";
			var activetitle = "";
			var activetype = "";
			var maintabs = Ext.getCmp('main-tabs');
			var mainview = Ext.getCmp('main-view');
			var activepanel = maintabs.getActiveTab();
			activeid = activepanel.id;
			activetitle = activepanel.title;
			if(activeid=="main-view")
			{
				activeid = mainview.text;
				activetype = "1";
			}
			else
			{	
				if(activeid.indexOf("tab_")==0)
				{
					activeid = activeid.substring(4,activeid.lenght);
					activetype = "2";
				}
			}
			if(activeid=="-2")
			{
				return;
			}
			var r = /^-?[0-9]+$/g;　　//整数 
            var flag = r.test(activeid);
	        if(!flag)
	        {
	   			return;
	        }
			if(activeid=="-2")
			{
				return;
			}
			Ext.Ajax.request({
				url : '/favourite/FavouriteActiveOperation.jsp', 
				method: 'POST',
				params:{
					action:"save",
					activeid:activeid,
					activetitle:activetitle,
					activetype:activetype
				},
				success: function(response, request) 
				{				
																	
				},
				failure: function(result, request) 
				{ 
				} 
			});
		}
		function getLastActiveTab()
		{
			Ext.Ajax.request({
				url : '/favourite/FavouriteActiveOperation.jsp', 
				method: 'POST',
				success: function (response, request) 
				{									 
					 var responseArray = Ext.decode(response.responseText);
					 for(var i=0;i<responseArray.databody.length;i++)
					 {
	    				var id = responseArray.databody[i].id;
	        			var type = responseArray.databody[i].type;
	        			var title = responseArray.databody[i].title;
	        			if(id=="")
	        			{
	        				return;
	        			}
	        			else
	        			{
		    				if(type=="2")
		    				{
		    					var mainpanel = Ext.getCmp('main-tabs');
		    					mainpanel.initTabPanel(id,title);
		    				}
		    				else
		    				{
		    					var maintabs = Ext.getCmp('main-tabs');
								var mainpanel = Ext.getCmp('main-view');
								var attributes = {
							 						id:id,
							     					url:'/favourite/SysFavouriteOperation.jsp?favouriteid='+id,
							     					title:title,
							     					text: title
							 				};
							 	maintabs.showpanel.loadSysFavourite(attributes);
							    Ext.getCmp('main-view').setTitle(title);
							    Ext.getCmp('main-view').text = id;
								maintabs.activate(mainpanel);
		    				}
	    				}
					 }													
				},
				failure: function ( result, request) 
				{ 
				} 
			});
		}

		
		</script>
		
		
	</head>
	<body onload="getLastActiveTab();" onunload="saveLastActiveTab();" onfocusin="gridResumeEvents();">
		<div id="header">
		</div>
		<form action="javascript:void(0);">
			<input type="hidden" name="resourceids" id="resourceids" value="">
			<input type="hidden" name="resourcenames" id="resourcenames" value="">
			<input type="hidden" name="jsonvalues" id="jsonvalues" value="">
			<input type="hidden" name="favouritetypes" id="favouritetype" value="">
		</form>
		<script type="text/javascript">
		function onShowBrowser(url){
			data = window.showModalDialog(url)
			if (data){
				if (data.id!=""&&data.id!="0"){
					resourceids = data.id
					resourcename = data.name
					var sHtml = "{databody:["
					resourceids = resourceids.substring(1);
					$GetEle("resourceids").value= resourceids;
					resourcename = resourcename.substring(1);
					$GetEle("resourcenames").value= resourcename;
					
					favouritetypes= readCookie("favouritetypes")
					
					$GetEle("favouritetypes").value= favouritetypes
					ids = resourceids.split(",");
					names=resourcename.split(",");
					for(var i=0;i<ids.length;i++){
						if(ids[i]!=0){
							sHtml = sHtml+"{linkid:"+ids[i]+",pagename:'"+names[i]+"'},";
						}
					}
					if(sHtml!=""){
						sHtml = sHtml.substring(0,sHtml.length-1);
					}
					sHtml = sHtml+"]}";
					$GetEle("jsonvalues").value= sHtml
				}
			}
		}
		</script>
	</body>
</html>