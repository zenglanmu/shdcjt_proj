/*---------------------------------------*/
/**/ 
/*---------------------------------------*/

function weaverTable(xmlFile,refreshTime,tableInstanceId,tableString,mode,selectedstrs,tableInfo,showExpExcel,isShowTopInfo,isShowBottomInfo,isShowThumbnail,imageNumberPerRow,TopLeftText,BottomLeftText, isCellThumbnailDis){   
	//初始化值	
	this.languageid=readCookie("languageidweaver");
	this.id = XTableHandler.getId();
	XTableHandler.all[this.id] = this;
	this.xmlFile = xmlFile;
	this.refreshTime=refreshTime;
	this.loadText = "正在加载，请稍候......";
	if(this.languageid==8) this.loadText = "Loading......";
	if(this.languageid==9) this.loadText = "正在加載，請稍候......";
	this.tableInfo = tableInfo=='null'?'':tableInfo;
	this.TopLeftText=TopLeftText=='null'?'':TopLeftText;
	this.BottomLeftText=BottomLeftText=='null'?'':BottomLeftText;
	this.showExpExcel = showExpExcel=='true'?true:false;
	this.isShowTopInfo = isShowTopInfo=='false'?false:true;
	this.isShowBottomInfo = isShowBottomInfo=='false'?false:true;
	
	/* edited by wdl 2006-05-24 left menu new requirement 显示缩略图 */
	this.isShowThumbnail = isShowThumbnail;
	this.imageNumberPerRow = imageNumberPerRow;
	/* edited by wdl end */
	
	this.div = this.createByName("div");
	
	//tableInfoDiv
	this.tableInfoDiv = this.createByName("div");	
	if((tableInfo!="null"&&tableInfo!="")||showExpExcel){
		jQuery(this.div).append(this.tableInfoDiv);
	}
	
	//info
	this.infoDivTop = this.createByName("div");
	jQuery(this.infoDivTop).attr("class", "xTable_info");
	jQuery(this.div).append(this.infoDivTop);


	//table
	this.tableDiv = this.createByName("div");
	jQuery(this.tableDiv).attr("class", "table");
	
	//info
	this.infoDiv = this.createByName("div");
	jQuery(this.infoDiv).attr("class", "xTable_info");

	//this.initDiv = this.createByName("div");
	//this.initDiv.innerHTML="<center><font color=\"AAAAAA\">"+this.loadText+"</font></center>";
	//this.tableDiv.appendChild(this.initDiv);
	//this.div.appendChild(this.tableDiv);
	jQuery(this.div).append(this.tableDiv);
	
	//messagge
	//this.messageDiv = this.createByName("div");
	//this.messageDiv.className="xTable_message";	
	//this.div.appendChild(this.messageDiv);
	
	this.tableInstanceId=tableInstanceId;
	this.tableString=tableString;
	this.mode=mode;
	this.selectedstrs = selectedstrs;	

	this.orderValue=null;						//排序列
	this.orderType = null;
	this.loading = false;						//是否正在加载
	
	this.page=true;							//是否分页？
	this.pageNum=0;
	this.nowPage=0;
	this.recordCount=0;
	this.pagesize=0;
	this.tabletype="";
	this.havaOperates="false";
	this.operatesWidth="";
	this.optUrls = null;
	this.optTexts = null;	
	this.optLinkkeys=null;	
	this.optTargets=null;	


	this.load();
	
	//动态刷新
	if(this.refreshTime>0){
		var xt = this;
		window.clearInterval();
		window.setInterval(function(){xt.load();},this.refreshTime);				
	}
	
	this.isCellThumbnailDis = (isCellThumbnailDis == null || undefined ) ? false : isCellThumbnailDis == true ? true : false;
}


weaverTable.prototype.create = function(){
	return this.div;
}
weaverTable.prototype.toString = function(){
	return this.div.outerHTML;	
}

weaverTable.prototype.load = function(){
	//如果正在加载，则不重复加载
	if(this.loading){
		return;	
	}		
	this.loading = true;
	var xmlHttp = XmlHttp.create();	
	/*var postdata = "<?xml version=\"1.0\" encoding=\"GBK\"?>";
		postdata += "<postdata>";
		postdata += "<tableInstanceId>"+this.tableInstanceId+"</tableInstanceId>";
		postdata += "	<tableString>"+this.tableString+"</tableString>";
		postdata += "	<pageIndex>"+this.nowPage+"</pageIndex>";
		postdata += "	<orderBy>"+this.orderValue+"</orderBy>";
		postdata += "	<otype>"+this.orderType+"</otype>";
		postdata += "	<mode>"+this.mode+"</mode>";
		postdata += "	<selectedstrs>"+this.selectedstrs+"</selectedstrs>";
		postdata += "</postdata>";*/
		
		var postdata = "";
		postdata += "tableInstanceId="+this.tableInstanceId+"&";
		postdata += "tableString="+this.tableString+"&";
		postdata += "pageIndex="+this.nowPage+"&";
		postdata += "orderBy="+this.orderValue+"&";
		postdata += "otype="+this.orderType+"&";
		postdata += "mode="+this.mode+"&";
		postdata += "selectedstrs="+this.selectedstrs;
		
		postdata = postdata.replace(new RegExp('&nbsp;', 'g'),' ');
		//异步加载数据
		xmlHttp.open("POST", this.xmlFile+"?"+postdata, true);
		var weaverTable = this;		
		xmlHttp.onreadystatechange = function () {	
			switch (xmlHttp.readyState) {
			   case 0 :  //uninitialized
					break ;
			   case 1 :   //loading							
					break ;
			   case 2 :   //loaded
				   if(readCookie("languageidweaver")==8) 
					   weaverTable.showMessage("Executing....");
				   else if(readCookie("languageidweaver")==9) 
					   weaverTable.showMessage("服務器正在處理,請稍等....");
				   else 
					  weaverTable.showMessage("服务器正在处理,请稍等....");
				   break ;
			   case 3 :   //interactive
				   var message="";				   

				   if(readCookie("languageidweaver")==8) 
					   message="Transfering....";
				   else if(readCookie("languageidweaver")==9) 
					   message = "正在傳輸數據,請稍等....";
				   else 
					   message="正在传输数据,请稍等....";

                    weaverTable.showMessage(message);

				   break ;
			   case 4 :  //complete
					if (xmlHttp.status==200)  {
						if(readCookie("languageidweaver")==8) {
							weaverTable.showMessage("Parseing....");
						} else if(readCookie("languageidweaver")==9) { 
							weaverTable.showMessage("正在解析數據,請稍等....");
						} else { 
							weaverTable.showMessage("正在解析数据,请稍等...");
						}
						var xmlDoc = XmlDocument.create();
						if(xmlHttp.responseXML!=null){
							xmlDoc = jQuery(xmlHttp.responseXML)[0];
						}
						if(xmlHttp.responseXML==null&&xmlHttp.responseText!=null){
							xmlDoc.async = false; 						
							xmlDoc = jQuery(xmlHttp.responseText)[0];
						}
						weaverTable.parse(xmlDoc,xmlHttp.responseText);	
						break ;	
				   } else {	
					   if(xmlHttp.status!=0){
							var showTableDiv  = document.getElementById('_xTable');						
							showTableDiv.innerHTML=creatErrorStr(xmlHttp.status,xmlHttp.statusText,xmlHttp.responseText);
					   }
				   }			  		
			} 
		}
				
		xmlHttp.setRequestHeader("Content-Type","text/xml");	
		xmlHttp.send();		
}

weaverTable.prototype.showMessage= function(info){	
	var message_table_Div  = document.getElementById("message_table_Div");
	jQuery("#message_table_Div").css("display", "inline");	
	jQuery("#message_table_Div").html(info);
	
	var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
	var pLeft= document.body.offsetWidth/2-50;
	
	jQuery(message_table_Div).css("position", "absolute");
	jQuery(message_table_Div).css("top", pTop);
	jQuery(message_table_Div).css("left", pLeft);
}


weaverTable.prototype.parse = function(oXmlDoc,docStr){
	if (this.mode=="debug"){
		alert(docStr);			
	}		
	//如果用xmlhttp加载失败 显示出错信息
	if(oXmlDoc == null||oXmlDoc.documentElement == null){
	   var showTableDiv  = document.getElementById('_xTable');	
	   if(readCookie("languageidweaver")==8) 
		   showTableDiv.innerHTML=creatErrorStr(0,"Server Run Error!",docStr);
	   else if(readCookie("languageidweaver")==9) 
		   showTableDiv.innerHTML=creatErrorStr(0,"服務器運行出錯",docStr);
	   else 
		   showTableDiv.innerHTML=creatErrorStr(0,"服务器运行出错!",docStr);
	}
	if( oXmlDoc == null || oXmlDoc.documentElement == null) {
		var showTableDiv  = document.getElementById('_xTable');						
		showTableDiv.innerHTML=creatErrorStr('','',docStr);		
	}else {
		var root = oXmlDoc.documentElement;
	    /* edited by wdl 2006-05-24 left menu new requirement 显示缩略图 */
		if(this.isShowThumbnail=="")
			this.showData(root);
		else
			this.showThumbnail(root);
		/* edited by wdl end */
	}
}

/* edited by wdl 2006-05-24 left menu new requirement 显示缩略图 */
weaverTable.prototype.showThumbnail = function(re){
    
	this.page = jQuery(re).attr("page");
	this.pageNum = jQuery(re).attr("pagenum");
	this.nowPage = jQuery(re).attr("nowpage");
	this.recordCount = jQuery(re).attr("recordCount");
	this.tabletype = jQuery(re).attr("tabletype");
	this.orderValue = jQuery(re).attr("orderValue");
	this.orderType = jQuery(re).attr("orderType");
	this.pagesize=jQuery(re).attr("pagesize");
	
	this.havaOperates = jQuery(re).attr("havaOprates");
	this.operatesWidth = jQuery(re).attr("operatesWidth");
	
	if(this.imageNumberPerRow==""||this.imageNumberPerRow=="0") this.imageNumberPerRow = 5;

	// checkbox ids arrays
	var checkboxArrays = new Array(this.pagesize);

	var tab = this.createByName("table");
	
	if (this.isCellThumbnailDis) {
		jQuery(tab).css("table-layout","fixed");
	} 
	
	jQuery(tab).css("width", jQuery(re).attr("width"));
	tab.cellSpacing="1pt";

	jQuery(this.div).css("width", jQuery(re).attr("width"));
	//tab.className="ListStyle";
	jQuery(tab).attr("class", "ListStyle");
	
	var tbody = this.createByName("tbody");	
	//tab.appendChild(tbody);	
	jQuery(tab).append(tbody);

	var rows = jQuery(re).children();
	var size = rows.length;
	var tempi = 0;				//记录奇偶行
	var _aligns;				//每列对齐样式
	var _hrefs;				//每列的链接
	var _colids;				//链接列的参数
	var _targets;				//每列链接的目标框架
	var _keys;				//主键列
	var row;
	var celstr;
	var titlestrs;
	var currentDocId = 0;
	
	for(var i = 0;i<size;i++){		
		//表头
		if(rows[i].tagName=="head"){
			var heads = jQuery(rows[i]).children();
			
			var hSize = heads.length;			
		
			_aligns = new Array(hSize);
			_hrefs = new Array(hSize);
			_targets = new Array(hSize);
			_colids = new Array(hSize);
			_keys = new Array(hSize);
			var __coli = 0;
			
			titlestrs = new Array(hSize);
			
			for(var hi=0;hi<hSize;hi++){
			
				if(heads[hi].tagName!="col"){
					continue;
				}
				
				_hrefs[__coli] = jQuery(heads[hi]).attr("href");
				_targets[__coli] = jQuery(heads[hi]).attr("target");
				_keys[__coli] = jQuery(heads[hi]).attr("key");

				titlestrs[__coli] = jQuery(heads[hi]).attr("text");

				__coli++;
			}
		
			if(this.havaOperates=="true"){
			}

			continue;
		}
		
		if(rows[i].tagName!="row"){	
			continue;	
		}

		tempi ++;
		if(tempi == 1){
		    row = this.createByName("tr");
		}

		var cels = jQuery(rows[i]).children();
		var cSize = cels.length;

		var __coli = 0;
		var __optIds = new Array(cSize);
		
 		var cel = this.createByName("td");
		
		//TD29472 注销此行 相册中显示的高度被固定，无法显示出全部的缩略图
 		if (this.isCellThumbnailDis) {
 			cel.style.height = "38px";
 		}
		//End TD29472 
 		if (this.isCellThumbnailDis) {
			jQuery(cel).css("text-Overflow", "ellipsis");
			jQuery(cel).css("white-Space", "nowrap");
			jQuery(cel).css("word-Break", "keep-all");
			jQuery(cel).css("overflow", "hidden");
 		}
   		celstr = "";
   		var _tdstyle= this.isCellThumbnailDis ? " style=\"display:inline-block;word-break:keep-all;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;width:100%;\" " : " style=\"word-wrap:break-word;word-break:break-all;\"";
		//行
		for(var j = 0;j<cSize;j++){
			
			if(cels[j].tagName=="col"){
			
				var __nowId = (jQuery(cels[j]).attr("linkvalue")==null)?jQuery(cels[j]).attr("text"):jQuery(cels[j]).attr("linkvalue");
				
				var showvalue=jQuery(cels[j]).attr("showvalue");
				var isChecked = (jQuery(cels[j]).attr("checked")=="true"?true:false);
				
				//checkbox
				if (jQuery(cels[j]).attr("type")=="checkbox") {//checkbox
					
					if (_xtable_checkedList.contains(__nowId)||isChecked)	{		
						checkboxArrays[i] = "_xTable_"+__nowId;
					}
					 
					celstr = celstr + "<input type=checkbox name=chkInTableTag id=_xTable_"+__nowId+" checkboxId="+__nowId+"  value=\""+showvalue+"\"  onClick=_xtalbe_chkCheck(this)>";					
					
					//是否为主键
					if(_keys[__coli]=="true"||_keys[__coli]=="TRUE"||_keys[__coli]=="Y"){
						__optIds[__coli] = __nowId;
					}

					//check
					if (isChecked){

					}
					__coli++;				
					continue ;				
				
				} else if (jQuery(cels[j]).attr("type")=="radio") {//radio
				
					if (_xtalbe_radiocheckId == __nowId||isChecked)	{
						
						celstr = celstr + "<input type=radio name=rdoInTableTag  radioId="+__nowId+" checked id=_xTable_"+__nowId+" value=\""+showvalue+"\" onClick=rdoCheck(this)>";
					    
					} else {
						
						celstr = celstr + "<input type=radio name=rdoInTableTag radioId="+__nowId+" id=_xTable_"+__nowId+" value=\""+showvalue+"\" onClick=rdoCheck(this)>";
					    
					}
					//是否为主键
					if(_keys[__coli]=="true"||_keys[__coli]=="TRUE"||_keys[__coli]=="Y"){
						__optIds[__coli] = __nowId;
					}
					__coli++;
					continue ;
				
				} else if (jQuery(cels[j]).attr("type")=="none") {
					
					celstr = celstr + "<input type=checkbox  style='display:none' id="+__nowId+" value="+showvalue+">";// xwj for td2180 20050818
					
					//是否为主键
					if(_keys[__coli]=="true"||_keys[__coli]=="TRUE"||_keys[__coli]=="Y"){
						__optIds[__coli] = __nowId;	
					}
					
					__coli++;
					continue ;
				} else if (jQuery(cels[j]).attr("type")=="thumbnail") {
					
					if (_xtable_checkedList.contains(__nowId)||isChecked)	{		
						checkboxArrays[i] = "_xTable_"+__nowId;
					}
					celstr = celstr + "<input type=checkbox name=chkInTableTag id=_xTable_"+__nowId+" checkboxId="+__nowId+"  value=\""+showvalue+"\"  onClick=_xtalbe_chkCheckThumbnail(this)>";

					var imgsrc = jQuery(cels[j]).attr("imgsrc");
			        //显示图片
			        celstr = "<table cellpadding=\"1\" style=\"border:1px solid #DDD;border-collapse:collapse\">" +
			        		 "<tr><td style=\"width:96px;height:96px;text-align:center\">" +
			        		 "<img src='"+imgsrc+"'>" +
			        		 "</td></tr>" +
			        		 "</table>" +
			        		 celstr;
				
					__coli++;
					continue ;
				} else if (jQuery(cels[j]).attr("type")=="thumbnailNoCheck") {
					
					if (_xtable_checkedList.contains(__nowId)||isChecked)	{		
						checkboxArrays[i] = "_xTable_"+__nowId;
					}

					var imgsrc = jQuery(cels[j]).attr("imgsrc");
			        //显示图片
			        celstr = "<table cellpadding=\"1\" style=\"border:1px solid #DDD;border-collapse:collapse\">" +
			        		 "<tr><td style=\"width:96px;height:96px;text-align:center\">" +
			        		 "<img src='"+imgsrc+"'>" +
			        		 "</td></tr>" +
			        		 "</table>" +
			        		 celstr;
				
					__coli++;
					continue ;
				}
				
				//是否为主键
				if(_keys[__coli]=="true"||_keys[__coli]=="TRUE"||_keys[__coli]=="Y"){
					__optIds[__coli] = __nowId;	
				}
				
				if(_hrefs[__coli]!=null){
				
					var str = "";
					
					if (_targets[__coli]=="_fullwindow"){
						if(__nowId!=""){
							var tempUrl = _hrefs[__coli]+this.getAttendChar(_hrefs[__coli])+jQuery(cels[j]).attr("linkkey")+"="+__nowId;
	
							str = "<a href=\"javascript:this.openFullWindowForXtable('"+tempUrl+"')\""  + _tdstyle + ">"+ jQuery(cels[j]).text()+"</a>";
						}
					} else {
					     if(__nowId!=""){
							 str = "<a href=\""+_hrefs[__coli]+this.getAttendChar(_hrefs[__coli])+jQuery(cels[j]).attr("linkkey")+"="+__nowId+
							       "\" target=\""+_targets[__coli]+"\" " + _tdstyle + ">"+jQuery(cels[j]).text()+"</a>";
					     }
					}
					
					celstr = celstr + str;
					
				} else {
				    var str = jQuery(cels[j]).text();
				    
				    //if(celstr.substr(celstr.length-4)!="<br>") celstr = celstr + "<br>";
					
					celstr = celstr + str;
					
				}
				
				__coli++;
				
			} else if (cels[j].tagName=="operates"){
			
				//显示操作栏				
				var optStrAll="";

				//var opas = cels[j].childNodes;
				var opas = jQuery(cels[j]).children();
				for(var opti = 0;opti<opas.length;opti++){
					var opa = opas[opti];
					var text = jQuery(opa).attr("text");
					var href = jQuery(opa).attr("href");
					var target = jQuery(opa).attr("target");
					var linkkey = jQuery(opa).attr("linkkey");
					var value = jQuery(opa).attr("value");
					var operateStr="";
					if (href!=null) {				
						var operateStrLower = href.toLowerCase(); 				
						var pos =operateStrLower.indexOf("javascript:");						
						if (pos != -1)  {
							var strJavaScript="";
							var posBracketStart = href.lastIndexOf("(");
							var posBracketEnd = href.lastIndexOf(")");	
							var strInBracket = href.substring(posBracketStart+1,posBracketEnd);
							
							if (strInBracket.replace(/(^\s*)|(\s*$)/g, "")=="") {  //删除空格
								strJavaScript = href.substring(0,posBracketEnd)+"\""+value+"\""+href.substring(posBracketEnd);		
							} else {
								strJavaScript = href.substring(0,posBracketEnd)+",\""+value+"\""+href.substring(posBracketEnd);		
							}

							operateStr = "<a href='"+strJavaScript+"'>"+text+"</a>";
						} else {
							if (target=="_fullwindow") {
								var tempStr = href+"?"+linkkey+"="+value;					
								operateStr = "<a href=javascript:this.openFullWindowForXtable('"+tempStr+"')>"+text+"</a>";	
							} else {
								operateStr = "<a href="+href+"?"+linkkey+"="+value+" target="+target+">"+text+"</a>";	
							}
						}									
					} else {
						operateStr=text;
					}
					optStrAll += operateStr +"&nbsp;";
				}
				celstr = celstr + "<br>" + optStrAll;
     		}
		}
		
		cel.align = "center";
		
		cel.vAlign = "top";

		cel.innerHTML = celstr;
		cel.width = (100 / this.imageNumberPerRow).toString()+"%";
		celstr = "";
		jQuery(row).append(cel);
		if((tempi % this.imageNumberPerRow == 0 && tempi>1)||tempi==size-1){
		    if((tempi==size-1)&&(tempi%this.imageNumberPerRow!=0)){
		        for(var bi=0;bi< this.imageNumberPerRow - (tempi % this.imageNumberPerRow) ; bi++){
		            var nullcel = this.createByName("td");
		            nullcel.innerHTML = "&nbsp;";
		            //row.appendChild(nullcel);
		            jQuery(row).append(nullcel);
		        }
		        jQuery(tbody).append(row);
		    } else {
    		    //tbody.appendChild(row);
		    	jQuery(tbody).append(row);
    		    row = this.createByName("tr");
    		}
		}
	}

	//是否是重新加载
	if(this.tableDiv.firstChild!=null){
		this.tableDiv.removeChild(this.tableDiv.firstChild);
	}
	//this.tableDiv.appendChild(tab);	
	jQuery(this.tableDiv).append(tab);
	if(this.page=="true"||this.page=="TRUE"||this.page=="Y"){
		//this.div.appendChild(this.infoDiv);
		jQuery(this.div).append(this.infoDiv);
		if (this.isShowTopInfo){
			this.infoDivTop.innerHTML =  this.buildInfo("top");  //1:top 2:buttom
		}
		if (this.isShowBottomInfo){
			this.infoDiv.innerHTML =  this.buildInfo("buttom");	
		}
		this.tableInfoDiv.innerHTML =  this.buildInfo("tableInfoDiv");
	}

	this.loading = false;
	this.loadOver();
	
	//checked checkbox
	for (var i=0;i<checkboxArrays.length ;i++ )	{
		var temp = checkboxArrays[i];
		if (temp!=null&&temp!=this.pagesize)	{	
			var tempobj = document.getElementById(temp);
			if (tempobj.tagName=="INPUT")	{
				tempobj.checked=true;				
				//tempobj.parentElement.parentElement.className = "Selected"
				thumbnailSelected(tempobj);
			}
		}
	}
}
/* edited by wdl end */


weaverTable.prototype.showData = function(re){
	this.page = jQuery(re).attr("page");
	this.pageNum = jQuery(re).attr("pagenum");
	this.nowPage = jQuery(re).attr("nowpage");
	var tbodyIframe = null;
	try{
		tbodyIframe = window.frames["rightMenuIframe"].document.getElementById("menuTable");
	}catch(e)
	{
		tbodyIframe = "";
	}
	if(tbodyIframe!=""&&tbodyIframe!=null){
	if(tbodyIframe.cells != undefined) {    // 使用右键菜单
		if(parseInt(this.nowPage)==1){	
			for(var i = 0; i < tbodyIframe.cells.length; i++) {
				//var val = tbodyIframe.cells[i].outerHTML;
				var val = jQuery(tbodyIframe.cells[i]).html();
				if(val.indexOf("新建首页") > 0 || val.indexOf("新建首頁") > 0 || val.indexOf("Newfirst page") > 0) {
					continue;
				}
				if(val.indexOf("首页") > 0 || val.indexOf("首頁") > 0 || val.indexOf("first page") > 0) {
					var button = tbodyIframe.cells[i].children[0];
					button.disabled = true;
				}
				if(val.indexOf("上一页") > 0 || val.indexOf("上一頁") > 0 || val.indexOf("Front Page") > 0) {
					var button = tbodyIframe.cells[i].children[0];
					button.disabled = true;
				}
			}	
		}
		if(parseInt(this.pageNum)==1){
			for(var i = 0; i < tbodyIframe.cells.length; i++) {
				//var val = tbodyIframe.cells[i].outerHTML;
				var val = jQuery(tbodyIframe.cells[i]).html();
				if(val.indexOf("下一页") > 0 || val.indexOf("下一頁") > 0 || val.indexOf("Next Page") > 0) {
					var button = tbodyIframe.cells[i].children[0];
					button.disabled = true;
				}
				if(val.indexOf("尾页") > 0 || val.indexOf("尾頁") > 0 || val.indexOf("last page") > 0) {
					var button = tbodyIframe.cells[i].children[0];
					button.disabled = true;
				}
			}
		}
	}else{// 不使用右键菜单
		if(parseInt(this.nowPage)==1){
			for(var i = 0; i < tbodyIframe.children.length; i++) {
				//var val = tbodyIframe.children[i].outerHTML;
				var val = jQuery(tbodyIframe.children[i]).html();
				if(val.indexOf("新建首页") > 0 || val.indexOf("新建首頁") > 0 || val.indexOf("Newfirst page") > 0) {
					continue;
				}
				if(val.indexOf("首页") > 0 || val.indexOf("首頁") > 0 || val.indexOf("first page") > 0) {
					var button = tbodyIframe.children[i];
					button.disabled = true;
				}
				if(val.indexOf("上一页") > 0 || val.indexOf("上一頁") > 0 || val.indexOf("Front Page") > 0) {
					var button = tbodyIframe.children[i];
					button.disabled = true;
				}
			}
		}
		if(parseInt(this.pageNum)==1){	
			for(var i = 0; i < tbodyIframe.children.length; i++) {
				//var val = tbodyIframe.children[i].outerHTML;
				var val = jQuery(tbodyIframe.children[i]).html();
				if(val.indexOf("下一页") > 0 || val.indexOf("下一頁") > 0 || val.indexOf("Next Page") > 0) {
					var button = tbodyIframe.children[i];
					button.disabled = true;
				}
				if(val.indexOf("尾页") > 0 || val.indexOf("尾頁") > 0 || val.indexOf("last page") > 0) {
					var button = tbodyIframe.children[i];
					button.disabled = true;
				}
			}
		}
	}
	}
	this.recordCount = jQuery(re).attr("recordCount");
	this.tabletype = jQuery(re).attr("tabletype");
	this.orderValue = jQuery(re).attr("orderValue");
	this.orderType = jQuery(re).attr("orderType");
	this.pagesize=jQuery(re).attr("pagesize");
	this.havaOperates = jQuery(re).attr("havaOprates");
	this.operatesWidth = jQuery(re).attr("operatesWidth");

	// checkbox ids arrays
	var checkboxArrays = new  Array(this.pagesize);

	var tab = this.createByName("table");
	
	if (this.isCellThumbnailDis) {
		jQuery(tab).css("table-layout","fixed");
	}
	
	jQuery(tab).css("width", jQuery(re).attr("width"));
	tab.cellSpacing="1pt";

	this.valign=jQuery(re).attr("valign");
    if (this.valign==null) this.valign="middle"

	tab.onmousemove = this.mouseMove;
	tab.onmouseup = this.mouseUp;
	tab.onmousedown = this.mouseDown;
	//onmouseover
	tab.onmouseover=function (e){
		try{
			var evt = e ? e:(window.event?window.event:null);
			var targetObj = evt.srcElement ? evt.srcElement : evt.target;
			//var e = window.event.srcElement		
			var targetObjParent = null;
			if (targetObj.tagName == "TD") {
				//e.parentElement.className = "Selected"
				targetObjParent = jQuery(targetObj).parent(); 
				//jQuery(targetObj).parent().removeClass("DataDark DataLight"); 
				//jQuery(targetObj).parent().addClass("Selected");
			}else if( targetObj.tagName == "A" || (targetObj.tagName == "INPUT"&&targetObj.name!="_allselectcheckbox")){
				targetObjParent = jQuery(targetObj).parent().parent();
				//e.parentElement.parentElement.className = "Selected"
			}
			targetObjParent.removeClass("DataDark DataLight"); 
			targetObjParent.addClass("Selected");
		}catch(e){
			//TODO
		}
	};
	//onmouseout
	tab.onmouseout=function (e){	
		try{
			//var e = window.event.srcElement
			var evt = e ? e:(window.event?window.event:null);
			var targetObj = evt.srcElement ? evt.srcElement : evt.target;
			if (targetObj.tagName == "TD"||targetObj.tagName == "A" ||(targetObj.tagName == "INPUT"&&targetObj.name!="_allselectcheckbox")){		
				var p = null;
				if (targetObj.tagName == "TD") {
					p = jQuery(targetObj).parent()[0];
				} else {
					p = jQuery(targetObj).parent().parent()[0];
				}
				//看看是否是有checkbox框，并且这个checkbox框是否选中，如果选中则不改变其行的CSS样式
				// 第一个TD
				var firstTd=jQuery(p).children()[0];
				//第一个CHECKBOX
				var firstCheckbox = jQuery(firstTd).children()[0];			
				if (firstCheckbox.tagName=="INPUT" && firstCheckbox.checked) {
					return null;
				}
				
				if (p.rowIndex % 2==0)	{				
					//p.className = "DataDark"
					jQuery(p).removeClass("Selected");
					jQuery(p).addClass("DataDark");
				} else {
					//p.className = "DataLight"
					jQuery(p).removeClass("Selected");
					jQuery(p).addClass("DataLight");
				}			
			}
		}catch(e){
			//TODO
		}
	};
	
	//this.div.style.width=jQuery(re).attr("width");
	jQuery(this.div).css("width", jQuery(re).attr("width"));
	jQuery(tab).attr("class", "ListStyle");	
	//tab.border="1px";
	var thead = this.createByName("thead");
	var tbody = this.createByName("tbody");	
	//tab.appendChild(thead);	
	//tab.appendChild(tbody);		
	jQuery(tab).append(thead);
	jQuery(tab).append(tbody);

	//操作列
	var optNameColumn = null;

	var rows = jQuery(re).children();
	var size = rows.length;
	var tempi = 0;				//记录奇偶行
	var _aligns;				//每列对齐样式
	var _hrefs;				//每列的链接
	var _colids;				//链接列的参数
	var _targets;				//每列链接的目标框架
	var _keys;				//主键列
	for(var i = 0;i<size;i++){		
		//表头
		if(rows[i].tagName=="head"){
			var hd = this.createByName("tr");
			jQuery(hd).attr("class", "HeaderForXtalbe");

			var heads = jQuery(rows[i]).children();
			
			var hSize = heads.length;			
		
			_aligns = new Array(hSize);
			_hrefs = new Array(hSize);
			_targets = new Array(hSize);
			_colids = new Array(hSize);
			_keys = new Array(hSize);
			var __coli = 0;		
			for(var hi=0;hi<hSize;hi++){			
				if(heads[hi].tagName!="col"){
					continue;
				}
				var hdi = this.createByName("th");				
//				hdi.style.height="38px";
//				hdi.style.textOverflow = "ellipsis";
//				hdi.style.whiteSpace = "nowrap";
//				hdi.style.wordBreak = "keep-all";
//				hdi.style.overflow = "hidden";
				jQuery(hdi).css("height", "38px");
				if (this.isCellThumbnailDis) {
					jQuery(hdi).css("text-overflow", "ellipsis");
					jQuery(hdi).css("white-space", "nowrap");
					jQuery(hdi).css("word-break", "keep-all");
					jQuery(hdi).css("overflow", "hidden");
				}
				var _xtb = this;
				//排序操作
				var  hid = jQuery(heads[hi]).attr("orderkey");
				
				if(hid!=null){
					hdi.id = hid;
					hdi.onclick=function(){_xtb.orderByCol(this);};
					 if(readCookie("languageidweaver")==8) 
					    hdi.title="click order by this"
					 if(readCookie("languageidweaver")==9) 
					    hdi.title="單擊按此列排序"
				     else 
						hdi.title="单击按此列排序"
				}
				//宽度
				if(jQuery(heads[hi]).attr("width")!=null){
					hdi.width = jQuery(heads[hi]).attr("width");
				}	

				if(jQuery(heads[hi]).attr("display")=="none"){
					//hdi.style.display ="none";
					jQuery(hdi).css("display", "none");
				}	
				//对齐
				var __align  = jQuery(heads[hi]).attr("align");			
				if (__align==null)	{
					__align="left";
				}
				/*if(__align!=null){
					hdi.align=__align;
				}*/				
				_aligns[__coli] = __align;
				_hrefs[__coli] = jQuery(heads[hi]).attr("href");
				_targets[__coli] = jQuery(heads[hi]).attr("target");
				_keys[__coli] = jQuery(heads[hi]).attr("key");
				_colids[__coli] = hid;
				__coli++;
				
				var _istr = jQuery(heads[hi]).attr("text");
				//alert(_istr)
				//排序
				if(this.orderValue!=null&&this.orderValue==hid){
					if(this.orderType=="DESC"){
						if (window.ActiveXObject) {
							_istr += "<span class=\"xTable_order xTable_order_desc\">"+ this.getOrderButton("-") +"</span>";
						} else {
							_istr += "<span class=\"xTable_order_desc\" style=\"overflow:hidden;padding-left:5px;\">"+ "▼" +"</span>";
						}
					}else{
						if (window.ActiveXObject) {
							_istr += "<span class=\"xTable_order xTable_order_asc\">"+ this.getOrderButton("+") +"</span>";
						} else {
							_istr += "<span class=\"xTable_order_asc\" style=\"overflow:hidden;padding-left:5px;\">"+ "▲" +"</span>";
						}
						
					}
				}else if(hid!=null){
					_istr+="&nbsp;";	
				}
				//-----------------------------
				// 当此列需要排序时，title的显示
				//-----------------------------
				var tabTitleStr = "";
				if (hdi.title != undefined && hdi.title != null && hdi.title != ""  ) {
					tabTitleStr = _istr.replace("&nbsp;", "").replace("", "") + "(" + hdi.title + ")";
				} else {
					tabTitleStr = _istr.replace("&nbsp;", "");
				}
				if (this.isCellThumbnailDis) {
					//-----------------------------
					// 当此列为checkbox时的处理
					//-----------------------------
					if (_istr.indexOf("checkbox") != -1 || _istr.indexOf("CHECKBOX") != -1) {
						tabTitleStr = "";
						hdi.width = "30px";
					}
					var spanExist = _istr.toLowerCase().indexOf("<span");
					if (spanExist != -1) {
						tabTitleStr = _istr.substring(0, spanExist);
					}
				}
				
				
				//hdi.title = tabTitleStr;
				hdi.innerHTML = _istr;
				jQuery(hd).append(hdi);
				
			}
			if(this.havaOperates=="true"){
				var optCol = this.createByName("th");
				jQuery(optCol).attr("class", "Header");
				optNameColumn = optCol;
				if (this.operatesWidth!=null){
					optCol.width=this.operatesWidth;
				}	
				 if(readCookie("languageidweaver")==8) { 
				   jQuery(optCol).html("Operation");
				 } else { 
					jQuery(optCol).html("操作");
				 }
				jQuery(hd).append(optCol);
			}
			if (this.isCellThumbnailDis) {
				if (optCol != undefined && optCol != null) {
					optCol.title = optCol.innerHTML;
				}
			}
			//thead.appendChild(hd);	
			jQuery(thead).append(hd);
			// 表头下面的线
			var lineAfterHead = this.createByName("tr");
			jQuery(lineAfterHead).attr("class", "Line");

			var tempTD= this.createByName("th");
			tempTD.colSpan=50;		
			lineAfterHead.appendChild(tempTD);		
			//tbody.appendChild(lineAfterHead);
			continue;
		}		
		if(rows[i].tagName!="row"){	
			continue;	
		}
		tempi ++;
		var row = this.createByName("tr");
		if(tempi%2==0){
			jQuery(row).attr("class", "DataDark");
		}else{
			//row.className="DataLight";
			jQuery(row).attr("class", "DataLight");
		}
		
		jQuery(row).css("vertical-align", this.valign);
		//row.style.verticalAlign =this.valign;
		
		var cels = jQuery(rows[i]).children();
		var  cSize = cels.length;
		var __coli = 0;
		var __optIds = new Array(cSize);
		
		var _tdstyle= this.isCellThumbnailDis ? " style=\"display:inline-block;word-break:keep-all;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;width:100%;\" " : " style=\"word-wrap:break-word;word-break:break-all;\"";
		
		//行
		for(var j = 0;j<cSize;j++){
			if(cels[j].tagName=="col"){			
				var __nowId = (jQuery(cels[j]).attr("linkvalue")==null)?jQuery(cels[j]).attr("text"):jQuery(cels[j]).attr("linkvalue");			
				var cel = this.createByName("td");
				
 				//TD高度设置
				//cel.style.height = "38px";
				jQuery(cel).css("height", "38px");

				try{
					if(jQuery(heads[j]).attr("display")=="none"){
						//hdi.style.display ="none";
						jQuery(cel).css("display", "none");
					}
				}catch(ee22){}
				
				var celTitle = "";
				
				var showvalue=jQuery(cels[j]).attr("showvalue");				
				var isChecked = (jQuery(cels[j]).attr("checked")=="true"?true:false)				
				//checkbox	
				if (jQuery(cels[j]).attr("type")=="checkbox") {					
					
					if (_xtable_checkedList.contains(__nowId)||isChecked)	{		
						checkboxArrays[i] = "_xTable_"+__nowId;						
					} 
					cel.innerHTML ="<input type=checkbox name=chkInTableTag id=_xTable_"+__nowId+" checkboxId="+__nowId+"  value=\""+showvalue+"\"  onClick=_xtalbe_chkCheck(this)>";					
					//row.appendChild(cel);
					jQuery(row).append(cel);
					//是否为主键
					if(_keys[__coli]=="true"||_keys[__coli]=="TRUE"||_keys[__coli]=="Y"){
						__optIds[__coli] = __nowId;	
					}

					//check
					if (isChecked){

					}
					__coli++;				
					continue ;				
				} else if (jQuery(cels[j]).attr("type")=="radio") {		//radio		
					if (_xtalbe_radiocheckId == __nowId||isChecked)	{					
						cel.innerHTML ="<input type=radio name=rdoInTableTag  radioId="+__nowId+" checked id=_xTable_"+__nowId+" value=\""+showvalue+"\" onClick=rdoCheck(this)>";
					} else {
						cel.innerHTML ="<input type=radio name=rdoInTableTag radioId="+__nowId+"  id=_xTable_"+__nowId+"  value=\""+showvalue+"\"　 onClick=rdoCheck(this)>";
					}
					//row.appendChild(cel);
					jQuery(row).append(cel);
					//是否为主键
					if(_keys[__coli]=="true"||_keys[__coli]=="TRUE"||_keys[__coli]=="Y"){
						__optIds[__coli] = __nowId;	
					}
					__coli++;
					continue ;
				} else if (jQuery(cels[j]).attr("type")=="none") {	
					cel.innerHTML ="<input type=checkbox  style='display:none' id="+__nowId+" value="+showvalue+">";// xwj for td2180 20050818				
					if (this.tabletype=="none"){
						//cel.style.display="none";
						jQuery(cel).css("display", "none");
					}
					//row.appendChild(cel);
					jQuery(row).append(cel);
					//是否为主键
					if(_keys[__coli]=="true"||_keys[__coli]=="TRUE"||_keys[__coli]=="Y"){
						__optIds[__coli] = __nowId;	
					}
					__coli++;	
					continue ;
				}
							
				if(_aligns[__coli]!=null){
					cel.align=_aligns[__coli];	
				}
				//是否为主键
				if(_keys[__coli]=="true"||_keys[__coli]=="TRUE"||_keys[__coli]=="Y"){
					__optIds[__coli] = __nowId;	
				}
				
				if(_hrefs[__coli]!=null){				
					var str = "";
					if (_targets[__coli]=="_fullwindow"){
						var thref = _hrefs[__coli];
						if(thref=="/hrm/resource/HrmResource.jsp")
						{
							if(__nowId!=""&&__nowId!="0"){
								
								str = "<a href='javaScript:openhrm("+__nowId+");' onclick='pointerXY(event);' " + _tdstyle + ">"+ jQuery(cels[j]).text()+"</a>";
							}
						}
						else
						{
							if(__nowId!=""){
								var tempUrl = _hrefs[__coli]+this.getAttendChar(_hrefs[__coli])+jQuery(cels[j]).attr("linkkey")+"="+__nowId;
								
								if (jQuery(cels[j]).text().indexOf("<a") != -1 || jQuery(cels[j]).text().indexOf("<A") != -1) {
									str = "<span href=\"javascript:this.openFullWindowForXtable('"+tempUrl+"')\" " + (this.isCellThumbnailDis ? "" : "") + ">"+ jQuery(cels[j]).text().substring(0, 2) + _tdstyle + jQuery(cels[j]).text().substr(2) +"</span>";
								} else {
									str = "<a href=\"javascript:this.openFullWindowForXtable('"+tempUrl+"')\" " + _tdstyle + ">"+ jQuery(cels[j]).text()+"</a>";
								}
							}
						}
						
					} else {
						if(__nowId!=""){
							 str = "<a href=\""+
							  _hrefs[__coli]+this.getAttendChar(_hrefs[__coli])+jQuery(cels[j]).attr("linkkey")+"="+__nowId+
							  "\" target=\""+_targets[__coli]+"\" " + _tdstyle + ">"+				
							  jQuery(cels[j]).text()+
								  "</a>";
						}
					}
					cel.innerHTML = str;
				}else{
//					cel.innerHTML = jQuery(cels[j]).text().replace(new RegExp("<br>","gm"), "&nbsp;");
					cel.innerHTML = jQuery(cels[j]).text().replace(new RegExp("<br>","gm"), "&nbsp;");
					//---------------------
					// 当td中为纯文本时
					//---------------------
					if (this.isCellThumbnailDis) {
						jQuery(cel).css("text-overflow", "ellipsis");
						jQuery(cel).css("white-space", "nowrap");
						jQuery(cel).css("word-break", "keep-all");
						jQuery(cel).css("overflow", "hidden");
					}
				}
				var tempTitleStr = "";
				if (jQuery(cels[j]).text().toLowerCase().indexOf("<a") != -1) {
					var astartIndex = jQuery(cels[j]).text().indexOf(">");
					var aendIndex = jQuery(cels[j]).text().indexOf("</");
					tempTitleStr = jQuery(cels[j]).text().substring(astartIndex + 1, aendIndex);
				} else {
					tempTitleStr = jQuery(cels[j]).text().replace(new RegExp("<br>","gm"), " ");
				}
				
				if (tempTitleStr.toLowerCase().indexOf("<span") != -1) {
					var astartIndex = tempTitleStr.indexOf(">");
					var aendIndex = tempTitleStr.indexOf("</");
					tempTitleStr = tempTitleStr.substring(astartIndex + 1, aendIndex);
					
					astartIndex = tempTitleStr.indexOf(">");
					if (astartIndex != -1) {
						tempTitleStr = tempTitleStr.substr(astartIndex + 1);
					}
				}
				if (this.isCellThumbnailDis) {
					cel.title = removeHTMLTag(jQuery(cels[j]).text());
				
					if (jQuery(cel).children("Table").length != 0) {
						var innerTr = jQuery(jQuery(cel).children("Table")[0]).children("Tbody").children("TR");
						jQuery(cel).css("height", 38 + innerTr.length * 32 + "px");
					} 
				}
				__coli++;
				//row.appendChild(cel);			
				jQuery(row).append(cel);
			} else if (cels[j].tagName=="operates"){
				//显示操作栏				
				var optCol = this.createByName("td");
				
				var optTextCnt = "";			
				
				var optStrAll="";

				var opas = jQuery(cels[j]).children();
				for(var opti = 0;opti<opas.length;opti++){
					var opa = opas[opti];
					var text = jQuery(opa).attr("text");
					var href = jQuery(opa).attr("href");
					var target = jQuery(opa).attr("target");
					var linkkey = jQuery(opa).attr("linkkey");
					var value = jQuery(opa).attr("value");
					var operateStr="";
					if (href!=null) {				
						var operateStrLower = href.toLowerCase(); 				
						var pos =operateStrLower.indexOf("javascript:");						
						if (pos != -1)  {
							var strJavaScript="";
							var posBracketStart = href.lastIndexOf("(");
							var posBracketEnd = href.lastIndexOf(")");	
							var strInBracket = href.substring(posBracketStart+1,posBracketEnd);
							
							if (strInBracket.replace(/(^\s*)|(\s*$)/g, "")=="") {  //删除空格
								strJavaScript = href.substring(0,posBracketEnd)+"\""+value+"\""+href.substring(posBracketEnd);		
							} else {
								strJavaScript = href.substring(0,posBracketEnd)+",\""+value+"\""+href.substring(posBracketEnd);		
							}

							operateStr = "<a href='"+strJavaScript+"' title=" + text + ">"+text+"</a>";	
						} else {
							if (target=="_fullwindow") {
								var tempStr = href+"?"+linkkey+"="+value;					
								operateStr = "<a href=javascript:this.openFullWindowForXtable('"+tempStr+"') title=" + text + ">"+text+"</a>";	
							} else {
								operateStr = "<a href="+href+"?"+linkkey+"="+value+" target="+target+" title=" + text + ">"+text+"</a>";	
							}
						}									
					} else {
						operateStr=text;
						//operateStr=text;
					}
					optStrAll += operateStr +"&nbsp;";
					
					optTextCnt += text + " ";
				}
				optCol.innerHTML = optStrAll;
				//row.appendChild(optCol);
				jQuery(row).append(optCol);
				if (this.isCellThumbnailDis) {
					try {
						if (parseInt(optNameColumn.width.replace("px"),"") < (optTextCnt.length * 11)) {
							optNameColumn.width = (optTextCnt.length * 11) + "px";
						}
					} catch (e) {}
				}
     		}
		}		
		//tbody.appendChild(row);
		jQuery(tbody).append(row);
	}
	// 最后一行 是一条线
	var lineAfterLast = this.createByName("tr");
	//lineAfterLast.className="xTable_line";
	jQuery(lineAfterLast).attr("class", "xTable_line");
	
	

	var tempTD= this.createByName("th");
	tempTD.colSpan=50;		
	
	//lineAfterLast.appendChild(tempTD);
	jQuery(lineAfterLast).append(tempTD);
	//tbody.appendChild(lineAfterLast)

	
	
	//是否是重新加载/
	if(this.tableDiv.firstChild!=null){
		this.tableDiv.removeChild(this.tableDiv.firstChild);
	}
	//this.tableDiv.appendChild(tab);	
	jQuery(this.tableDiv).append(tab);
	
	if(this.page=="true"||this.page=="TRUE"||this.page=="Y"){
		//this.div.appendChild(this.infoDiv);
		jQuery(this.div).append(this.infoDiv);
		if (this.isShowTopInfo){
			this.infoDivTop.innerHTML =  this.buildInfo("top");  //1:top 2:buttom
		}
		if (this.isShowBottomInfo){
			this.infoDiv.innerHTML =  this.buildInfo("buttom");	
		}
		this.tableInfoDiv.innerHTML =  this.buildInfo("tableInfoDiv");	
	}

	this.loading = false;
	this.loadOver();
	
	//checked checkbox
	for (var i=0;i<checkboxArrays.length ;i++ )	{
		var temp = checkboxArrays[i];
		if (temp!=null&&temp!=this.pagesize)	{	
			var tempobj = document.getElementById(temp);
			if (tempobj.tagName=="INPUT")	{
				tempobj.checked=true;				
				//tempobj.parentElement.parentElement.className = "Selected"
				jQuery(tempobj).parent().parent().attr("class", "Selected");
			}
		}
	}
	
	//处理门户里的列表开始
	try{		
		var oFrm=parent.document.frames["mainFrame"];			
		var realHeight=oFrm.document.body.scrollHeight;
		parent.document.getElementById("mainFrame").height=realHeight;		
	} catch(e){
		//alert(e)
	}
	//--门户里的列表结束
}
//页面跳转
weaverTable.prototype.buildInfo = function(type){
	var returnStr="";
	
	if (type=="tableInfoDiv")	{
		var strExpExcel="";
		if (this.showExpExcel)	{
			 strExpExcel="<div align='right'><img src='/images/expExcel1.gif' style='cursor:pointer' onclick='javaScript:_xtable_getExcel()'>&nbsp;&nbsp<img src='/images/expExcel2.gif' style='cursor:pointer' onclick='javaScript:_xtable_getAllExcel()'></div>";
		}	
		returnStr="<table width=100%><tr><td><div align='left'>"+this.tableInfo+"</div></td><td>"+strExpExcel+"</td></tr> <tr class='xTable_line1'><td colspan=2></td></tr> </table>"		
		return returnStr;
	}
	var str = "";
	
	if(readCookie("languageidweaver")==8) {
		//str = "&raquo; record:"+this.recordCount+"&nbsp&nbsp&nbsp current/page: "+this.nowPage+"/"+this.pageNum+"&nbsp&nbsp&nbsp ";
		str = "<span style=\"TEXT-DECORATION:none;height:21px;padding-top:2px;\">&raquo; record:"+this.recordCount + "</span>";
	} else if(readCookie("languageidweaver")==9) { 
		//str = "&raquo; 共"+this.recordCount+"條記錄&nbsp&nbsp&nbsp每頁"+this.pagesize+"條&nbsp&nbsp&nbsp共"+this.pageNum+"頁&nbsp&nbsp&nbsp當前第"+this.nowPage + "頁";
		str = "<span style=\"TEXT-DECORATION:none;height:21px;padding-top:2px;\">&raquo; 共"+this.recordCount+"條記錄&nbsp&nbsp&nbsp每頁"+this.pagesize+"條" + "</span>";
	} else { 
		//str = "&raquo; 共"+this.recordCount+"条记录&nbsp&nbsp&nbsp每页"+this.pagesize+"条&nbsp&nbsp&nbsp共"+this.pageNum+"页&nbsp&nbsp&nbsp当前第"+this.nowPage + "页";	
		str = "<span style=\"TEXT-DECORATION:none;height:21px;padding-top:2px;\">&raquo; 共"+this.recordCount+"条记录&nbsp&nbsp&nbsp每页"+this.pagesize+"条" + "</span>";
	}
	str += "&nbsp&nbsp"
	
	
	//-------------------------------------------------
    // new page start 
    //-------------------------------------------------
    var sbf = "";
    var z_index = parseInt(this.nowPage) - 2;
    var y_num = parseInt(this.nowPage) + 2;
    var tempCent = "";
    var tempLeft = "";
    var tempRight = "";
	if (z_index > 1) {
        tempLeft += "<a style=\"display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:19px;border:1px solid #6ec8ff;margin-right:5px;padding:0 5px 0 5px;\" _jumpTo=\"" + this.id + "\" onClick=\"XTableHandler.jumpTo(this, 1)\">" + 1 + "</a>";
    }
    if (z_index > 2) {
        tempLeft += "<span style=\"display:inline-block;height:19px;text-align:center;\">&nbsp;...&nbsp;</span>";
    }
    
    if (y_num < (this.pageNum - 1)) {
        tempRight += "<span style=\"display:inline-block;height:19px;text-align:center;\">&nbsp;...&nbsp;</span>";
    }
    
    if (y_num < this.pageNum) {
        tempRight += "<span style=\"display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:19px;border:1px solid #6ec8ff;margin-right:5px;padding:0 5px 0 5px;\" _jumpTo=\"" + this.id + "\" onClick=\"XTableHandler.jumpTo(this, " + this.pageNum + ")\">" + this.pageNum + "</span>";
    }
    
    for(;z_index<=y_num; z_index++) {
        if (z_index>0 && z_index<=this.pageNum) {
            if (z_index == this.nowPage) {
                tempCent +="<span style=\"display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:19px;border:1px solid #6ec8ff;margin-right:5px;padding:0 5px 0 5px;\" _jumpTo=\"" + this.id + "\" onClick=\"XTableHandler.jumpTo(this, " + z_index + ")\" class=\"weaverTableCurrentPageBg\" >" + z_index + "</span>";                
            } else {
                tempCent +="<span style=\"display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:19px;border:1px solid #6ec8ff;margin-right:5px;padding:0 5px 0 5px;\" _jumpTo=\"" + this.id + "\" onClick=\"XTableHandler.jumpTo(this, " + z_index + ")\">" + z_index + "</span>";
            }
        }
    }
    
    sbf = tempLeft + tempCent + tempRight;
	
	
	
	if(parseInt(this.nowPage)>1){
		str +="<span class=\"weaverTablePrevPage\" style=\"width:21px;display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:21px;margin-right:5px;\" id=\""+this.id+"-pre\" onClick=\"+XTableHandler.prePage(this)\" onmouseover=\"pmouseover(this, true)\" onmouseout=\"pmouseover(this, false)\">&nbsp;</span>"	
		
	}else{
		str += "<span class=\"weaverTablePrevPageOfDisabled\" style=\"display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:21px;margin-right:5px;width:21px;\">&nbsp;</span>";
	}
	str += sbf;
	if(parseInt(this.nowPage)<this.pageNum){
		str +="<span class=\"weaverTableNextPage\" style=\"width:21px;display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:21px;margin-right:5px;\" id=\""+this.id+"-next\" onClick=\"+XTableHandler.nextPage(this)\" onmouseover=\"pmouseover(this, true)\" onmouseout=\"pmouseover(this, false)\">&nbsp;</span>"	
	}else{
		str += "<span class=\"weaverTableNextPageOfDisabled\" style=\"display:inline-block;cursor:pointer;TEXT-DECORATION:none;height:21px;margin-right:5px;width:21px;\">&nbsp;</span>";
	}	

	var tempTableInfo = this.tableInfo;
	if (type=="top"){
		if(readCookie("languageidweaver")==8){
			str += jumpInternational(this.id, this.nowPage, "", "PAGE", "jump", "_XTABLE_GOPAGE_top", "top");
		}
		else if(readCookie("languageidweaver")==9){
			str += jumpInternational(this.id, this.nowPage, "第", "頁", "跳轉", "_XTABLE_GOPAGE_top", "top");
		}else {
			str += jumpInternational(this.id, this.nowPage, "第", "页", "跳转", "_XTABLE_GOPAGE_top", "top");  
		}
	} else {
		tempTableInfo = "" ;
		if(readCookie("languageidweaver")==8){
            str += jumpInternational(this.id, this.nowPage, "", "PAGE", "jump", "_XTABLE_GOPAGE_buttom", "buttom");
        } else if(readCookie("languageidweaver")==9){
            str += jumpInternational(this.id, this.nowPage, "第", "頁", "跳轉", "_XTABLE_GOPAGE_buttom", "buttom");
        } else {
            str += jumpInternational(this.id, this.nowPage, "第", "页", "跳转", "_XTABLE_GOPAGE_buttom", "buttom");
        }
	}		
	str += "";	
	var strExcel="";	
	var selectAll="";
	if(readCookie("languageidweaver")==8){
		selectAll = "Select All";
	}else if(readCookie("languageidweaver")==9){
		selectAll = "全選";
	}else{
		selectAll = "全选";
	}
	//var strExcel="<div align=left><button class=xTable_btnExcel onclick='javascript:_xtable_getExcel()'>export this</button>&nbsp;<button class=xTable_btnExcel onclick='javascript:_xtable_getAllExcel()'>export all</button></div>";
	if (this.tabletype=="checkbox"){	
			if (type=="top"){
				returnStr = "<div><table width=100%><tr><td>"+this.TopLeftText+"</td><td><div align=right>"+str+"</div></td></tr></table></div>"
			} else {				
				returnStr = "<div><table width=100%><tr><td>"+this.BottomLeftText+" <input name='_allselectcheckbox' type=checkbox onClick='checkAllChkBox(this.checked)'> "+selectAll+"</td><td><div align=right>"+str+"</div></td></tr></table></div>"
			}
	} else if(this.tabletype=="thumbnail"){
			if (type=="top"){
				returnStr = "<div><table width=100%><tr><td>"+this.TopLeftText+"</td><td><div align=right>"+str+"</div></td></tr></table></div>"
			} else {				
				returnStr = "<div><table width=100%><tr><td>"+this.BottomLeftText+" <input name='_allselectcheckbox' type=checkbox onClick='checkAllThumbnailBox(this.checked)'> "+selectAll+"</td><td><div align=right>"+str+"</div></td></tr></table></div>"
			}
	} else if(this.tabletype=="thumbnailNoCheck"){
			if (type=="top"){
				returnStr = "<div><table width=100%><tr><td>"+this.TopLeftText+"</td><td><div align=right>"+str+"</div></td></tr></table></div>"
			} else {				
				returnStr = "<div><table width=100%><tr><td>"+this.BottomLeftText+"</td><td><div align=right>"+str+"</div></td></tr></table></div>"
			}
	} else {
		if (type=="top"){
				returnStr = "<div><table width=100%><tr><td>"+this.TopLeftText+" "+strExcel+"</td><td><div  align=right>"+str+"</div></td></tr></table></div>"		
			} else {				
				returnStr = "<div><table width=100%><tr><td>"+this.BottomLeftText+" "+strExcel+"</td><td><div  align=right>"+str+"</div></td></tr></table></div>"		
			}	
	}
	return returnStr;
}


//转到按钮的语言设置
function jumpInternational(id, nowPage, jTo, jPg, jJump, topOrButtom, what) {
    var result = "";
    result += "<span style=\"TEXT-DECORATION:none;height:21px;line-height:21px;\">" + jTo + "&nbsp;</span>";
    result += "<input id=\""+ id + topOrButtom + "\" type=\"text\" value=\""+nowPage+"\" size=\"3\" class=\"text\" onMouseOver=\"this.select()\" style=\"text-align:right;line-height:20px;height:20px;widht:30px;border:1px solid #6ec8ff;background:none;margin-right:5px;padding-right:2px;\"/>";
    result += "<span style=\"TEXT-DECORATION:none;height:21px;line-height:21px;\">" + jPg + "</span>"
    result += "&nbsp;<span id=\""+id+"-goPage\" onClick=\"+XTableHandler.goPage(this,'" + what + "')\" style=\"display:inline-block;line-height:21px;cursor:pointer;background:url(/wui/theme/" + GLOBAL_CURRENT_THEME + "/skins/" + GLOBAL_SKINS_FOLDER + "/table/jump.png) no-repeat;height:21px;width:38px;margin-right:5px;text-align:center;border:none;\">" + jJump + "</span>";
    return result;
}

function pmouseover(obj, flag) {
    if (obj == undefined) {
        return;
    }
    if (flag == true) {
    	if (jQuery(obj).attr("class") == "weaverTableNextPage") {
    		//obj.className = "weaverTableNextSltPage";
    		jQuery(obj).attr("class", "weaverTableNextSltPage");
    	} else {
    		//obj.className = "weaverTablePrevSltPage";
    		jQuery(obj).attr("class", "weaverTablePrevSltPage");
    	}
    } else {
        if (obj.className == "weaverTableNextSltPage") {
        	jQuery(obj).attr("class", "weaverTableNextPage");
        } else {
        	jQuery(obj).attr("class", "weaverTablePrevPage");
        }
    }
}
//排序按钮
weaverTable.prototype.getOrderButton = function(x1){
	var ch = "";
	if(document.all){
		switch(x1){
			case "+":ch="5";break;
			case "-":ch="6";break;
		}
	}else{
		switch(x1){
			case "+":ch=">";break;
			case "-":ch="<";break;
		}
	}
	return ch;
}
//翻页按钮
weaverTable.prototype.getPageButton = function(x1,useable){
	var c = (useable?"class=\"xTable_pageua\"":"class=\"xTable_pageda\"");
	var ch = "";
	if(readCookie("languageidweaver")==8){
		if(document.all){
			switch(x1){
				case 1:ch="FirstPage";break;
				case 2:ch="prePage";break;
				case 3:ch="NextPage";break;
				case 4:ch="LastPage";break;
			}
		}else{
			var alt = "";
			var gif = "";
			switch(x1){
				case 1:ch="FirstPage";break;
				case 2:ch="prePage";break;
				case 3:ch="NextPage";break;
				case 4:ch="LastPage";break;
			}
		}
	}
	else if(readCookie("languageidweaver")==9) {
		if(document.all)
		{ 
			switch(x1)
			{ 
				case 1:ch="首頁";break; 
				case 2:ch="上一頁";break; 
				case 3:ch="下一頁";break; 
				case 4:ch="尾頁";break; 
			} 
		}
		else
		{ 
			var alt = ""; 
			var gif = ""; 
			switch(x1){ 
				case 1:ch="首頁";break; 
				case 2:ch="上一頁";break; 
				case 3:ch="下一頁";break; 
				case 4:ch="尾頁";break; 
			} 
		}
    } 
	else{
		if(document.all){
			switch(x1){
				case 1:ch="首页";break;
				case 2:ch="上一页";break;
				case 3:ch="下一页";break;
				case 4:ch="尾页";break;
			}
		}else{
			var alt = "";
			var gif = "";
			switch(x1){
				case 1:ch="首页";break;
				case 2:ch="上一页";break;
				case 3:ch="下一页";break;
				case 4:ch="尾页";break;
			}
		}
    }
	return str ="<span>"+ch+"</span>";
}


//显示加载信息
weaverTable.prototype.startLoad = function(){
	var message_table_Div  = document.getElementById("message_table_Div");
	//message_table_Div.style.display="inline";	
	jQuery(message_table_Div).css("display", "inline");	
	if(readCookie("languageidweaver")==8)
    	jQuery(message_table_Div).html("Executing....");
    else if(readCookie("languageidweaver")==9)
    	jQuery(message_table_Div).html("服務器正在處理,請稍等....");
	else 
		jQuery(message_table_Div).html("服务器正在处理,请稍等....");
	
	var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
	var pLeft= document.body.offsetWidth/2-50;
	
//	message_table_Div.style.position="absolute"
//	message_table_Div.style.posTop=pTop;
//	message_table_Div.style.posLeft=pLeft;
	
	jQuery(message_table_Div).css("position", "absolute");
	jQuery(message_table_Div).css("top", pTop);
	jQuery(message_table_Div).css("left", pLeft);
}
//隐藏加载信息
weaverTable.prototype.loadOver = function(){
	var message_table_Div  = document.getElementById("message_table_Div");	 	
	//message_table_Div.style.display="none";	
	jQuery(message_table_Div).css("display", "none");	
}
//得到消息层的位置。
weaverTable.prototype.getPosition = function(element){
	var xy = new Array(2);
    	if ( arguments.length != 1 || element == null ) 
    	{ 
        	element = this.div;
    	} 
    	var offsetTop = element.offsetTop; 
    	var offsetLeft = element.offsetLeft; 
    	var offsetWidth = element.offsetWidth; 
    	var offsetHeight = element.offsetHeight; 
    	while( element = element.offsetParent ){ 
	        offsetTop += element.offsetTop; 
	        offsetLeft += element.offsetLeft; 
    	} 
    	offsetLeft += offsetWidth/2 - this.messageDiv.offsetWidth;
    	offsetTop += offsetHeight/2 - this.messageDiv.offsetHeight;
    	xy[0] = offsetLeft;
    	xy[1] = offsetTop;
    	return xy;
}

weaverTable.prototype.getAttendChar = function(str){
	return /\?/g.test(str)?"&":"?";
}
//排序
weaverTable.prototype.orderByCol = function(oid){
	if(this.orderValue!=null&&this.orderValue==oid.id){		
		if(this.orderType=="DESC"){			
			this.orderType = "ASC";
		}else{
			this.orderType = "DESC";
		}
	}else if(this.orderValue!=oid.id){
		this.orderType = "DESC";
	}
	this.orderValue = oid.id;
	this.reLoad();
}
//重新加载
weaverTable.prototype.reLoad = function(){
	this.startLoad();	
	this.load();
}

weaverTable.prototype.firstPage=function(){
	if(parseInt(this.nowPage)!=1){
		this.nowPage=0;
		this.reLoad();
	}
	var tbodyIframe = window.frames["rightMenuIframe"].document.getElementById("menuTable");
	if(tbodyIframe.cells != undefined) {   // 使用右键菜单
		for(var i = 0; i < tbodyIframe.cells.length; i++) {
			//var val = tbodyIframe.cells[i].outerHTML;
			var val = jQuery(tbodyIframe.cells[i]).html();
			if(val.indexOf("首页") > 0 || val.indexOf("首頁") > 0 || val.indexOf("first page") > 0) {
				var button = tbodyIframe.cells[i].children[0];
				button.disabled = true;
			}
			if(val.indexOf("上一页") > 0 || val.indexOf("上一頁") > 0 || val.indexOf("Front Page") > 0) {
				var button = tbodyIframe.cells[i].children[0];
				button.disabled = true;
			}
			if(val.indexOf("下一页") > 0 || val.indexOf("下一頁") > 0 || val.indexOf("Next Page") > 0) {
				var button = tbodyIframe.cells[i].children[0];
				button.disabled = '';
			}
			if(val.indexOf("尾页") > 0 || val.indexOf("尾頁") > 0 || val.indexOf("last page") > 0) {
				var button = tbodyIframe.cells[i].children[0];
				button.disabled = '';
			}
		}
	}else{// 不使用右键菜单
		for(var i = 0; i < tbodyIframe.children.length; i++) {
			//var val = tbodyIframe.children[i].outerHTML;
			var val = jQuery(tbodyIframe.children[i]).html();
			
			if(val.indexOf("首页") > 0 || val.indexOf("首頁") > 0 || val.indexOf("first page") > 0) {
				var button = tbodyIframe.children[i];
				button.disabled = true;
			}
			if(val.indexOf("上一页") > 0 || val.indexOf("上一頁") > 0 || val.indexOf("Front Page") > 0) {
				var button = tbodyIframe.children[i];
				button.disabled = true;
			}
			if(val.indexOf("下一页") > 0 || val.indexOf("下一頁") > 0 || val.indexOf("Next Page") > 0) {
				var button = tbodyIframe.children[i];
				button.disabled = '';
			}
			if(val.indexOf("尾页") > 0 || val.indexOf("尾頁") > 0 || val.indexOf("last page") > 0) {
				var button = tbodyIframe.children[i];
				button.disabled = '';
			}
		}
	}
}

weaverTable.prototype.prePage=function(){
	if(parseInt(this.nowPage)>1){
		this.nowPage--;
		this.reLoad();
	}
	this.pre();
}

weaverTable.prototype.nextPage=function(){
	if(parseInt(this.nowPage)<parseInt(this.pageNum)){
		this.nowPage++;
		this.reLoad();
	}
	this.next();
}


weaverTable.prototype.lastPage=function(){
	if(this.nowPage!=this.pageNum){
		this.nowPage=this.pageNum;
		this.reLoad();
	}
	var tbodyIframe = window.frames["rightMenuIframe"].document.getElementById("menuTable");
	if(tbodyIframe.cells != undefined) {    // 使用右键菜单
		for(var i = 0; i < tbodyIframe.cells.length; i++) {
			//var val = tbodyIframe.cells[i].outerHTML;
			var val = jQuery(tbodyIframe.cells[i]).html();
			if(val.indexOf("首页") > 0 || val.indexOf("首頁") > 0 || val.indexOf("first page") > 0) {
				var button = tbodyIframe.cells[i].children[0];
				button.disabled = '';
			}
			if(val.indexOf("上一页") > 0 || val.indexOf("上一頁") > 0 || val.indexOf("Front Page") > 0) {
				var button = tbodyIframe.cells[i].children[0];
				button.disabled = '';
			}
			if(val.indexOf("下一页") > 0 || val.indexOf("下一頁") > 0 || val.indexOf("Next Page") > 0) {
				var button = tbodyIframe.cells[i].children[0];
				button.disabled = true;
			}
			if(val.indexOf("尾页") > 0 || val.indexOf("尾頁") > 0 || val.indexOf("last page") > 0) {
				var button = tbodyIframe.cells[i].children[0];
				button.disabled = true;
			}
		}
	}else{// 不使用右键菜单
		for(var i = 0; i < tbodyIframe.children.length; i++) {
			//var val = tbodyIframe.children[i].outerHTML;
			var val = jQuery(tbodyIframe.children[i]).html();
			if(val.indexOf("首页") > 0 || val.indexOf("首頁") > 0 || val.indexOf("first page") > 0) {
				var button = tbodyIframe.children[i];
				button.disabled = '';
			}
			if(val.indexOf("上一页") > 0 || val.indexOf("上一頁") > 0 || val.indexOf("Front Page") > 0) {
				var button = tbodyIframe.children[i];
				button.disabled = '';
			}
			if(val.indexOf("下一页") > 0 || val.indexOf("下一頁") > 0 || val.indexOf("Next Page") > 0) {
				var button = tbodyIframe.children[i];
				button.disabled = true;
			}
			if(val.indexOf("尾页") > 0 || val.indexOf("尾頁") > 0 || val.indexOf("last page") > 0) {
				var button = tbodyIframe.children[i];
				button.disabled = true;
			}
		}
	}
}

weaverTable.prototype.goPage=function(a){	
	if(a>0&&a<=this.pageNum&&a!=this.nowPage){
		this.nowPage=a;
		this.reLoad();
	}
	this.pre();
	this.next();
}

weaverTable.prototype.createByName = function(n){
	return document.createElement(n);
}


//事件监听
XTableHandler = {
	idCounter : 0,
	idPrefix  : "-weaverTable-",
	all       : {},
	getId     : function() { return this.idPrefix + this.idCounter++; },
	firstPage : function (oItem) { this.all[oItem.id.replace('-first','')].firstPage(); },	
	prePage   : function (oItem) { this.all[oItem.id.replace('-pre','')].prePage(); },
	nextPage  : function (oItem) { this.all[oItem.id.replace('-next','')].nextPage(); },
	lastPage  : function (oItem) { this.all[oItem.id.replace('-last','')].lastPage(); },
	goPage	  :function(oItem,type){			
		//跳转到第几页
		
		var nid=oItem.id.replace('-goPage','');
		var goPage ;
		if (type=="top"){
			goPage = document.getElementById(nid+"_XTABLE_GOPAGE_top");
		} else {
			goPage = document.getElementById(nid+"_XTABLE_GOPAGE_buttom");
		}				
		 if(goPage!=null){
		 	var goone = parseInt(jQuery(goPage).val());
		 	//检查是否越界
		 	if(goone>0&&goone<=this.all[nid].pageNum&&goone!=this.all[nid].nowPage){
		 		this.all[nid].goPage(goone);
			}else{
				//重新赋值
				goPage.value=this.all[nid].nowPage;
			}
		}
	},
	jumpTo  : function(obj, a) {
	   var nid = jQuery(obj).attr("_jumpTo");
	   this.all[nid].goPage(a);
	}
}

/***********************************************************/

function creatErrorStr(status,statusText,responseText){
	var returnStr ="";
	responseText=responseText.replace(/(^\s*)|(\s*$)/g, "");	
	if(readCookie("languageidweaver")==8)  {
		if(responseText=="NoData"){
			returnStr="No Data To Show";
		} else {
			 returnStr =""+	
			"<font size=2>Server Run Error!<br>"+
			"Error Code:"+status+"<br>"+
		    "Error Description:"+statusText+"<br>"+
	        "Error Description Info:<a href=\"javaScript:isShowErrorDiv()\">SHOW/HIDDEN</a><br></font><br>"+
			"<div id='showerrordiv' style=\"overflow:auto;height:300px;width:100%;display:none\">"+responseText+"</div>"+
			"<hr>"+
			"<font size=2> solve method: <br>"+
			"</font>"+
			"<UL>"+
				"<li>Please <a href=javascript:location.reload()>refresh</a> this page."+
				"<li>Time out(exit and <a  href='javascript:document.URL=\"http://\"+location.host;'>login</a>) again."+
				"<li>Server run error,Send the error message to administrator ,please."+				
			"</UL>";
		}		
	}
	else if(readCookie("languageidweaver")==9) { 
    	if(responseText=="NoData"){ 
			returnStr="沒有可顯示的數據！"; 
		} 
		else 
		{ 
			returnStr =""+ 
			"<font size=2>服務器出錯!<br>"+ 
			"錯誤代碼:"+status+"<br>"+ 
			"錯誤描述:"+statusText+"<br>"+ 
			"錯誤詳細信息:<a href=\"javaScript:isShowErrorDiv()\">顯示/隱藏</a><br></font><br>"+ 
			"<div id='showerrordiv' style=\"overflow:auto;height:300px;width:100%;display:none\">"+responseText+"</div>"+ 
			"<hr>"+ 
			"<font size=2>解決方法: <br>"+ 
			"</font>"+ 
			"<UL>"+ 
			"<li>請<a href=javascript:location.reload()>刷新</a>此頁"+ 
			"<li>系統超時(退出系統重新<a href='javascript:document.URL=\"http://\"+location.host;'>登錄</a>)"+ 
			"<li>服務器出現問題,請把錯誤詳細信息發給系統管理員處理"+ 
			"</UL>"; 
		}
	} 
	else { 
    	if(responseText=="NoData"){
			returnStr="没有可显示的数据！";
		} else {
			 returnStr =""+	
			"<font size=2>服务器出错!<br>"+
			"错误代码:"+status+"<br>"+
		    "错误描述:"+statusText+"<br>"+
	        "错误详细信息:<a href=\"javaScript:isShowErrorDiv()\">显示/隐藏</a><br></font><br>"+
			"<div id='showerrordiv' style=\"overflow:auto;height:300px;width:100%;display:none\">"+responseText+"</div>"+
			"<hr>"+
			"<font size=2> 解决方法: <br>"+
			"</font>"+
			"<UL>"+
				"<li>请<a href=javascript:location.reload()>刷新</a>此页"+
				"<li>系统超时(退出系统重新<a  href='javascript:document.URL=\"http://\"+location.host;'>登录</a>)"+
				"<li>服务器出现问题,请把错误详细信息发给系统管理员处理"+				
			"</UL>";
		}
	}
		
   return returnStr;
}
function isShowErrorDiv(){
//	if(document.getElementById('showerrordiv').style.display=='none'){
//		document.getElementById('showerrordiv').style.display='';
//	}else{
//		document.getElementById('showerrordiv').style.display='none';
//	}
	if(jQuery("#showerrordiv").css("display") == "none"){
		jQuery("#showerrordiv").css("display", "");
	}else{
		jQuery("#showerrordiv").css("display", "none");
	}
}


function  rowOnMouseOver(obj){
	//obj.parentElement.parentElement.className = "Selected"
	jQuery(obj).parent().parent().attr("class", "Selected");
}

function  rowOnMouseOut(obj){
	//var p = obj.parentElement.parentElement;
	var p = jQuery(obj).parent().parent()[0];
	if (p.rowIndex % 2==0)	{				
		//p.className = "DataLight"
		jQuery(p).attr("class", "DataLight");
	} else {
		//p.className = "DataDark"
		jQuery(p).attr("class", "DataDark");
	}
}
/***************checkbo radio*******************************/

function checkAllChkBox(btnChecked){
    var chkboxElems= document.getElementsByName("chkInTableTag")  
    var _allselectcheckboxs = document.getElementsByName("_allselectcheckbox")  
    for (i=0;i<_allselectcheckboxs.length;i++){
        if (btnChecked) { 
            _allselectcheckboxs[i].checked = true ;
        } else {
            _allselectcheckboxs[i].checked = false ;
        }
   }
    for (j=0;j<chkboxElems.length;j++){
        if (btnChecked) {
            chkboxElems[j].checked = true ;			
        } else {       
            chkboxElems[j].checked = false ;
        }
        _xtalbe_chkCheck(chkboxElems[j]);   
    }
}
function _xtalbe_chkCheck(obj){  
 if (obj.checked){
     if (!_xtable_checkedList.contains(jQuery(obj).attr("checkboxId"))){
         _xtable_checkedList.add(jQuery(obj).attr("checkboxId"));
         _xtalbe_checkedValueList.add(jQuery(obj).attr("value"));
     }
	 rowOnMouseOver(obj);
 } else {
     if (_xtable_checkedList.contains(jQuery(obj).attr("checkboxId"))){
         var tempPos = _xtable_checkedList.indexOf(jQuery(obj).attr("checkboxId"));
         _xtable_checkedList.setElementAt(tempPos,null);
         _xtalbe_checkedValueList.setElementAt(tempPos,null);
     }   
	  rowOnMouseOut(obj);
 }
}
function checkAllThumbnailBox(btnChecked){
    var chkboxElems= document.getElementsByName("chkInTableTag")  
    var _allselectcheckboxs = document.getElementsByName("_allselectcheckbox")  
    for (i=0;i<_allselectcheckboxs.length;i++){
        if (btnChecked) { 
            _allselectcheckboxs[i].checked = true ;
        } else {
            _allselectcheckboxs[i].checked = false ;
        }
   }
    for (j=0;j<chkboxElems.length;j++){
        if (btnChecked) {
            chkboxElems[j].checked = true ;			
        } else {       
            chkboxElems[j].checked = false ;
        }
        _xtalbe_chkCheckThumbnail(chkboxElems[j]);   
    }
}
function _xtalbe_chkCheckThumbnail(obj){  
 if (obj.checked){
     if (!_xtable_checkedList.contains(jQuery(obj).attr("checkboxId"))){
         _xtable_checkedList.add(jQuery(obj).attr("checkboxId"));
         _xtalbe_checkedValueList.add(jQuery(obj).attr("value"));
     }
	 thumbnailSelected(obj)
 } else {
     if (_xtable_checkedList.contains(jQuery(obj).attr("checkboxId"))){
         var tempPos = _xtable_checkedList.indexOf(jQuery(obj).attr("checkboxId"));
         _xtable_checkedList.setElementAt(tempPos,null);
         _xtalbe_checkedValueList.setElementAt(tempPos,null);
     }
	 thumbnailUnSelected(obj)
 }
}
function thumbnailSelected(obj){
	while(obj.tagName!="TD"){obj = jQuery(obj).parent()[0];}
	//obj.style.backgroundColor = "aliceblue";
	jQuery(obj).css("background-color", "aliceblue");
	
}
function thumbnailUnSelected(obj){
	while(obj.tagName!="TD"){obj = jQuery(obj).parent()[0];}
	//obj.style.backgroundColor = "";
	jQuery(obj).css("background-color", "");
}
//radio
function rdoCheck(obj){	
	if (obj.checked) {
		_xtalbe_radiocheckId =  jQuery(obj).attr("radioId");
		_xtalbe_radiocheckValue = jQuery(obj).val();
	} else {		
		rowOnMouseOut(obj);
	}
}


function openFullWindowForXtable(url){
  var redirectUrl = url ;
  var width = screen.width ;
  var height = screen.height ;
  //if (height == 768 ) height -= 75 ;
  //if (height == 600 ) height -= 60 ;
  var szFeatures = "top="+(screen.height - height*2/3-50) / 2+"," ; 
  szFeatures +="left="+(screen.width - width*2/3) / 2+"," ;
  szFeatures +="width="+width*2/3+"," ;
  szFeatures +="height="+height*2/3+"," ; 
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
  szFeatures +="scrollbars=yes," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}
/*******************以下是功能函数***************************/
//得到checked　ids
 function _xtable_CheckedCheckboxId(){
 var strSelected = "";
 for (i=0;i<_xtable_checkedList.size();i++)  {
     if  (_xtable_checkedList.get(i)==null) continue;
     strSelected += _xtable_checkedList.get(i)+",";
 }
 return strSelected;
}

//得到checked values
function  _xtable_CheckedCheckboxValue(){
     var strSelected = "";
     for (i=0;i<_xtalbe_checkedValueList.size();i++)  {
         if  (_xtalbe_checkedValueList.get(i)==null) continue;
         strSelected += _xtalbe_checkedValueList.get(i)+",";
     }
 return strSelected;    
}

//清空checked
function _xtable_CleanCheckedCheckbox(){
    _xtable_checkedList.remove();
    _xtalbe_checkedValueList.remove();
    checkAllChkBox(false);
    $GetEle("_allselectcheckbox").checked=false;
}

//得到 radio　id
function _xtable_CheckedRadioId(){
    return _xtalbe_radiocheckId
}

//得到 radio　value
function _xtable_CheckedRadioValue(){
    return  _xtalbe_radiocheckValue;
}

//清空 radio　id
function _xtable_CleanCheckedRadio(){
    document.getElementById(_xtalbe_radiocheckId).checked=false;
    _xtalbe_radiocheckId =""; 
    _xtalbe_radiocheckValue = "";
}
 
 //得到当前页的excel
function _xtable_getExcel(){ 	
	window.location='/weaver/weaver.common.util.taglib.CreateExcelServer'
}


 //得到全部的excel
function _xtable_getAllExcel(){ 
    window.location='/weaver/weaver.common.util.taglib.CreateExcelServer?showOrder=all'
}

//
weaverTable.prototype.mouseMove = function(re){}
weaverTable.prototype.mouseUp = function(re){}
weaverTable.prototype.mouseDown = function(re){}

weaverTable.prototype.pre=function(){
	var tbodyIframe = window.frames["rightMenuIframe"].document.getElementById("menuTable");
	if(tbodyIframe.cells != undefined) {    // 使用右键菜单
		if(parseInt(this.nowPage)==1){			
			for(var i = 0; i < tbodyIframe.cells.length; i++) {
				//var val = tbodyIframe.cells[i].outerHTML;
				var val = jQuery(tbodyIframe.cells[i]).html();
				if(val.indexOf("首页") > 0 || val.indexOf("首頁") > 0 || val.indexOf("first page") > 0) {
					var button = tbodyIframe.cells[i].children[0];
					button.disabled = true;
				}
				if(val.indexOf("上一页") > 0 || val.indexOf("上一頁") > 0 || val.indexOf("Front Page") > 0) {
					var button = tbodyIframe.cells[i].children[0];
					button.disabled = true;
				}
			}
		}
		
		if(parseInt(this.nowPage)<parseInt(this.pageNum)){
			for(var i = 0; i < tbodyIframe.cells.length; i++) {
				//var val = tbodyIframe.cells[i].outerHTML;
				var val = jQuery(tbodyIframe.cells[i]).html();
				if(val.indexOf("下一页") > 0 || val.indexOf("下一頁") > 0 || val.indexOf("Next Page") > 0) {
					var button = tbodyIframe.cells[i].children[0];
					button.disabled = '';
				}
				if(val.indexOf("尾页") > 0 || val.indexOf("尾頁") > 0 || val.indexOf("last page") > 0) {
					var button = tbodyIframe.cells[i].children[0];
					button.disabled = '';
				}
			}
		}
	}else{// 不使用右键菜单
		if(parseInt(this.nowPage)==1){			
			for(var i = 0; i < tbodyIframe.children.length; i++) {
				//var val = tbodyIframe.children[i].outerHTML;
				var val = jQuery(tbodyIframe.children[i]).html();
				if(val.indexOf("首页") > 0 || val.indexOf("首頁") > 0 || val.indexOf("first page") > 0) {
					var button = tbodyIframe.children[i];
					button.disabled = true;
				}
				if(val.indexOf("上一页") > 0 || val.indexOf("上一頁") > 0 || val.indexOf("Front Page") > 0) {
					var button = tbodyIframe.children[i];
					button.disabled = true;
				}
			}
		}
		
		if(parseInt(this.nowPage)<parseInt(this.pageNum)){
			for(var i = 0; i < tbodyIframe.children.length; i++) {
				//var val = tbodyIframe.children[i].outerHTML;
				var val = jQuery(tbodyIframe.children[i]).html();
				if(val.indexOf("下一页") > 0 || val.indexOf("下一頁") > 0 || val.indexOf("Next Page") > 0) {
					var button = tbodyIframe.children[i];
					button.disabled = '';
				}
				if(val.indexOf("尾页") > 0 || val.indexOf("尾頁") > 0 || val.indexOf("last page") > 0) {
					var button = tbodyIframe.children[i];
					button.disabled = '';
				}
			}
		}
	}
}
weaverTable.prototype.next=function(){
	var tbodyIframe = window.frames["rightMenuIframe"].document.getElementById("menuTable");
	if(tbodyIframe.cells != undefined) {    // 使用右键菜单
		if(parseInt(this.nowPage)>=parseInt(this.pageNum)){
			for(var i = 0; i < tbodyIframe.cells.length; i++) {
				//var val = tbodyIframe.cells[i].outerHTML;
				var val = jQuery(tbodyIframe.cells[i]).html();
				if(val.indexOf("下一页") > 0 || val.indexOf("下一頁") > 0 || val.indexOf("Next Page") > 0) {
					var button = tbodyIframe.cells[i].children[0];
					button.disabled = true;
				}
				if(val.indexOf("尾页") > 0 || val.indexOf("尾頁") > 0 || val.indexOf("last page") > 0) {
					var button = tbodyIframe.cells[i].children[0];
					button.disabled = true;
				}
			}
		}
		if(parseInt(this.nowPage)>1){	
			for(var i = 0; i < tbodyIframe.cells.length; i++) {
				//var val = tbodyIframe.cells[i].outerHTML;
				var val = jQuery(tbodyIframe.cells[i]).html();
				if(val.indexOf("首页") > 0 || val.indexOf("首頁") > 0 || val.indexOf("first page") > 0) {
					var button = tbodyIframe.cells[i].children[0];
					button.disabled = '';
				}
				if(val.indexOf("上一页") > 0 || val.indexOf("上一頁") > 0 || val.indexOf("Front Page") > 0) {
					var button = tbodyIframe.cells[i].children[0];
					button.disabled = '';
				}
			}	
		}
	}else{// 不使用右键菜单
		if(parseInt(this.nowPage)>=parseInt(this.pageNum)){
			for(var i = 0; i < tbodyIframe.children.length; i++) {
				//var val = tbodyIframe.children[i].outerHTML;
				var val = jQuery(tbodyIframe.children[i]).html();
				if(val.indexOf("下一页") > 0 || val.indexOf("下一頁") > 0 || val.indexOf("Next Page") > 0) {
					var button = tbodyIframe.children[i];
					button.disabled = true;
				}
				if(val.indexOf("尾页") > 0 || val.indexOf("尾頁") > 0 || val.indexOf("last page") > 0) {
					var button = tbodyIframe.children[i];
					button.disabled = true;
				}
			}
		}
		if(parseInt(this.nowPage)>1){	
			for(var i = 0; i < tbodyIframe.children.length; i++) {
				//var val = tbodyIframe.children[i].outerHTML;
				var val = jQuery(tbodyIframe.children[i]).html();
				if(val.indexOf("首页") > 0 || val.indexOf("首頁") > 0 || val.indexOf("first page") > 0) {
					var button = tbodyIframe.children[i];
					button.disabled = '';
				}
				if(val.indexOf("上一页") > 0 || val.indexOf("上一頁") > 0 || val.indexOf("Front Page") > 0) {
					var button = tbodyIframe.children[i];
					button.disabled = '';
				}
			}	
		}
	}
}
function removeHTMLTag(str) {
    str = str.replace(/<\/?[^>]*>/g,''); //去除HTML tag
    str = str.replace(/[ | ]*\n/g,'\n'); //去除行尾空白
    //str = str.replace(/\n[\s| | ]*\r/g,'\n'); //去除多余空行
    str=str.replace(/&nbsp;/ig,'');//去掉&nbsp;
    return str;
}