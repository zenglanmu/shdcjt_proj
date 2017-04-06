var viewport
Ext.onReady(function(){
	var itemds=[];
	if(displayUsage==1){ //ËõÂÔÍ¼
		itemds=[{title:'ÎÄµµÁÐ±í',contentEl:'divContent',autoScroll: true} ];
	} else{
		 grid = _table.getGrid();
		 itemds=[ grid];
	}
	var mainPanel=new Ext.Panel({		
		activeTab: 0,
        region: 'center',
        margins: '0 8 5 5',
        layout:'fit',
        border:false,
        resizeTabs: true,
        tabWidth: 150,
        minTabWidth: 120,
        enableTabScroll: true,
        plugins: new Ext.ux.TabCloseMenu(),       
        items: itemds
	});
	
	viewport = new Ext.Viewport({

        layout: 'border',
        items: [ panelTitle, mainPanel]
    
    });
    
    
    Ext.get('loading').fadeOut();
    if(displayUsage!=1)    _table.load();

	
});

   