function openFullWindow(url){
  var redirectUrl = url ;
  var width = screen.width ;
  var height = screen.height ;
  if (height == 768 ) height -= 75 ;
  if (height == 600 ) height -= 60 ;
  var szFeatures = "top=0," ; 
  szFeatures +="left=0," ;
  szFeatures +="width="+width+"," ;
  szFeatures +="height="+height+"," ; 
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
  if (height <= 600 ) szFeatures +="scrollbars=yes," ;
  else szFeatures +="scrollbars=no," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}

function openFullWindowHaveBar(url){
  var redirectUrl = url ;
  var width = screen.availWidth-10 ;
  var height = screen.availHeight-50 ;
  //if (height == 768 ) height -= 75 ;
  //if (height == 600 ) height -= 60 ;
   var szFeatures = "top=0," ;
  szFeatures +="left=0," ;
  szFeatures +="width="+width+"," ;
  szFeatures +="height="+height+"," ;
  szFeatures +="directories=no," ;
  szFeatures +="status=yes,toolbar=no,location=no," ;
  szFeatures +="menubar=no," ;
  szFeatures +="scrollbars=yes," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}

function openFullWindowHaveBarForWFList(url,requestid){
	try{
		document.getElementById("wflist_"+requestid+"span").innerHTML = "";
	}catch(e){}
	var redirectUrl = url ;
	var width = screen.availWidth-10 ;
	var height = screen.availHeight-50 ;
	//if (height == 768 ) height -= 75 ;
	//if (height == 600 ) height -= 60 ;
	var szFeatures = "top=0," ;
	szFeatures +="left=0," ;
	szFeatures +="width="+width+"," ;
	szFeatures +="height="+height+"," ;
	szFeatures +="directories=no," ;
	szFeatures +="status=yes,toolbar=no,location=no," ;
	szFeatures +="menubar=no," ;
	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ; //channelmode
	window.open(redirectUrl,"",szFeatures) ;
}

//为了删除时用
function openFullWindow1(url){
  var redirectUrl = url ;
  var width = screen.width ;
  var height = screen.height ;
  if (height == 768 ) height -= 75 ;
  if (height == 600 ) height -= 60 ;
  var szFeatures = "top="+height/2+"," ; 
  szFeatures +="left="+width/2+"," ; 
  szFeatures +="width=181," ;
  szFeatures +="height=129," ; 
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
  if (height <= 600 ) szFeatures +="scrollbars=yes," ;
  else szFeatures +="scrollbars=no," ;
  szFeatures +="resizable=no" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}


function openFullWindowForXtable(url){
  var redirectUrl = url ;
  var width = screen.width ;
  var height = screen.height ;
  //if (height == 768 ) height -= 75 ;
  //if (height == 600 ) height -= 60 ;
  var szFeatures = "top=100," ; 
  szFeatures +="left=400," ;
  szFeatures +="width="+width/2+"," ;
  szFeatures +="height="+height/2+"," ; 
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
  szFeatures +="scrollbars=yes," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}

function  readCookie(name){  
   var  cookieValue  =  "7";  
   var  search  =  name  +  "=";
   try{
	   if(document.cookie.length  >  0) {    
	       offset  =  document.cookie.indexOf(search);  
	       if  (offset  !=  -1)  
	       {    
	           offset  +=  search.length;  
	           end  =  document.cookie.indexOf(";",  offset);  
	           if  (end  ==  -1)  end  =  document.cookie.length;  
	           cookieValue  =  unescape(document.cookie.substring(offset,  end))  
	       }  
	   }  
   }catch(exception){
   }
   return  cookieValue;  
} 

function setMenuDisabled(){
	var o, _disabled;
	switch(arguments.length){
		case 0 :
			o = window.frames["rightMenuIframe"].event.srcElement;
			_disabled = true;
			break;
		case 1 :
			o = arguments[0];
			_disabled = true;
			break;
		case 2 :
			o = arguments[0];
			_disabled = arguments[1];
			break;
	}
	o.disabled = _disabled;
}

/**
 * 根据标识（name或者id）获取元素，主要用于解决系统中很多元素没有id属性，
 * 却在js中使用document.getElementById(name)来获取元素的问题。
 * @param identity name或者id
 * @return 元素
 */
function $GetEle(identity, _document) {
	var rtnEle = null;
	if (_document == undefined || _document == null) _document = document;
	
	rtnEle = _document.getElementById(identity);
	if (rtnEle == undefined || rtnEle == null) {
		rtnEle = _document.getElementsByName(identity);
		if (rtnEle.length > 0) rtnEle = rtnEle[0];
		else rtnEle = null;
	}
	return rtnEle;
}

function $G(identity, _document) {
	return $GetEle(identity, _document);
}

function $GetEles(identity) {
	var rtnEle = null;
	
	rtnEle = document.getElementsByName(identity);
	
	if (rtnEle.length == 1) {
		return rtnEle[0]; 
	} else if (rtnEle.length == 0) {
		return document.getElementById(identity);
	}
	return rtnEle;
}

var wuiUtil = {
	/**
	 * isNotNull 目标值不为null || undefined，返回true，否则返回false
	 */
	isNotNull: function (target) {
		if (target == undefined || target == null) {
			return false;
		}
		return true;
	}, 
	/**
	 * isNullOrEmpty 目标值为null、undefined、空，返回true，否则返回false
	 */
	isNullOrEmpty : function (target) {
		if (target == undefined || target == null || target == "") {
			return true;
		}
		return false;
	}, 
	/**
	 * isNotEmpty 目标值不为null、undefined、空，返回true，否则返回false
	 */
	isNotEmpty : function (target) {
		if (target == undefined || target == null || target == "") {
			return false;
		}
		return true;
	},
	getJsonValueByIndex: function (josinobj, index) {
		var _index = 0;
		try {
			for(var key in josinobj){
				if (index == _index) {
					return josinobj[key]; 			
				}
				_index++;
			}
		} catch (e) {alert("browser return value is error!");}
		return "";
	}
};

//-----------------------------------------
// 选择框用转换程序 start
//-----------------------------------------
if (typeof(SYSTEM_SHOW_MODAL_DIALOG) == "undefined" && typeof(SYSTEM_SHOW_MODAL_DIALOG) != "fucntion") {
	//系统模态窗口
	var SYSTEM_SHOW_MODAL_DIALOG = window.showModalDialog;
	if (window.showModalDialog == SYSTEM_SHOW_MODAL_DIALOG) {
		//重写系统模态窗口
		window.showModalDialog = function () {
			var url	= arguments[0];
			var parent = arguments[1];
			var dialogParent = arguments[2];

			if (!parent) {
				parent = "";
			}
			//ff下窗口不剧中问题统一处理
			if (!dialogParent) {
				dialogParent = "dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";";
			} else if (dialogParent != "" && dialogParent.indexOf("dialogTop") == -1) {
				dialogParent += ";dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";";
			}
			var returnValue;
			//调用系统模态窗口弹出function
			var rtnValue = SYSTEM_SHOW_MODAL_DIALOG(url, parent, dialogParent); 
			//ie下如果调用的是js，而返回值是vb则转换成json
			if (window.ActiveXObject) {
				//返回值是vb
				if (rtnValue != undefined && rtnValue != null && typeof(rtnValue) == "unknown") {
					var func = window.showModalDialog.caller;
					//判断调用模态窗口者是否是js
					if (typeof(func) == "function") {
						var tempArray = new VBArray(rtnValue).toArray();
						var tempJsonData = "{";
						if (tempArray != null) {
							for (var i=0; i<tempArray.length; i++) {
								if (i == 0) {
									tempJsonData += "id:\"" + tempArray[i] + "\"";
								} else if (i == 1) {
									tempJsonData += "name:\"" + tempArray[i] + "\"";
								} else {
									tempJsonData += "key" + i + ":\"" + tempArray[i] + "\"";
								}
								
								if (i < tempArray.length - 1) {
									tempJsonData += ", ";
								}
							}
						}
						tempJsonData += "}";
						
						returnValue =  eval('(' + tempJsonData + ')');
						return returnValue;
					}
				} else if (typeof(rtnValue) == "object"){
					//alert(window.showModalDialog.caller.caller);
					var func = window.showModalDialog.caller;
					try {
						window.console.log("href:" + window.location.href);
						window.console.log("caller type:" + typeof(func));
						window.console.log("caller content:" + func);
					} catch (e) {}
					//判断调用模态窗口者是否是vb
					if ((typeof(func) == "function" && func.toString().indexOf("function onclick()") != -1) || typeof(func) == "object") {
						return string2VbArray(json2String(rtnValue));
					} else {
						var	regex = new RegExp("jsid[ ]{0,}=[ ]{0,}new VBArray[\(]id[\)].toArray[\(][\)]", "g"); // 创建正则表达式对象。  
						var r = func.toString().match(regex);
					　　 if (r != null && r != undefined && r != "") {
						 	return string2VbArray(json2String(rtnValue));
					 	}
					}
				}
			}
			return rtnValue;
		};
	}
}

function json2String(josinobj) {
	if (josinobj == undefined || josinobj == null) {
		return "";
	}
	var ary = "";
	var _index = 0;
	try {
		for(var key in josinobj){
			if (_index++ > 0) {
				ary += "(~!@#$%^&*)";
			}
			ary += josinobj[key];
		}
	} catch (e) {}
	return ary;
}
//-----------------------------------------
//选择框用转换程序 END
//-----------------------------------------

