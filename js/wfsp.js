//--------------------------------------
// 流程签字意见分页用javascript
//--------------------------------------

function bodyresize(_document, iframeId, eachCnt){
	if (eachCnt >= 20) {
		return;
	}
	eachCnt++;
	try {	
		var _callbackfc = function() {
	        bodyresize(_document, iframeId, eachCnt);
	    };
	    var bodyContentHeight = 0;

	    if (jQuery.client.browser == "Explorer") {
	    	bodyContentHeight = _document.body.scrollHeight;
	    } else if (jQuery.client.browser == "Firefox") {
	    	bodyContentHeight = _document.body.offsetHeight;
	    } else if (jQuery.client.browser == "Chrome" || jQuery.client.browser == "Safari") {
	    	bodyContentHeight = jQuery(_document.body).children("TABLE").height() + 12;
	    }
	    
		if(bodyContentHeight==0){
			window.setTimeout(_callbackfc , 500);
		} else {
			document.getElementById(iframeId).height = bodyContentHeight + 2;
		}
		
		var objAList=_document.getElementsByTagName("A");
		for(var i=0; i<objAList.length; i++){
			var obj = objAList[i];
			var href = obj.href;
			var target = obj.target;
			if(href.indexOf("javascript:") == -1){
				obj.target = "_blank";
			}
		}
	} catch (e) {alert("error");}
}

function setIframeBodyContent(_contentWindow, tmpContextDiv, iframeId, _iframeHtml) {
	try {
	jQuery(_contentWindow.document.body).html( 
		"<table class=\"ViewForm\"><tr><td style=\"WORD-break:break-all;\">" +
		_iframeHtml +
		"</td></tr></table>"
	);
	} catch(e) {
		alert(e);
	}
}

function setIframeContent(_iframeId, _iframeHtml) {
	try {
		var _tcontentWindow = document.getElementById(_iframeId).contentWindow;
	    _tcontentWindow.document.write("<html><LINK href=\"/css/Weaver.css\" type=text/css rel=STYLESHEET>" 
		    + "<LINK href=\"/css/rp.css\" rel=\"STYLESHEET\" type=\"text/css\">" 
		    + "<body onload=\"" + "document.oncontextmenu = function () {parent.fckshowrightmenu(document, '" + _iframeId + "');return false;};document.onclick = parent.fckhiddenrightmenu;" + "\" bgColor=\"transparent\"></body></html>");
	    _tcontentWindow.document.close();
	    setIframeBodyContent(_tcontentWindow, _iframeId + "Div", _iframeId, _iframeHtml);
	} catch (e) {}
}


function fckhiddenrightmenu(){
	rightMenu.style.visibility="hidden";
    if (!window.ActiveXObject) {
		rightMenu.style.display = "none";
 	}
}

function getAbsolutePosition(_document, obj) {
    var position = new Object();
    position.x = 0;
    position.y = 0;
    var tempobj = obj;
    while(tempobj != null && tempobj != _document.body) {
    	position.x += tempobj.offsetLeft + tempobj.clientLeft;
    	position.y += tempobj.offsetTop + tempobj.clientTop;
    	tempobj = tempobj.offsetParent;
    }
    position.x += document.body.scrollLeft;
    if(document.getElementById("divWfBill")) {
    	position.y -= document.getElementById("divWfBill").scrollTop;
    }
    return position;
}

function fckshowrightmenu(_document, iframeId){
	var event = getIframeEvent(iframeId);
	var position = getAbsolutePosition(_document, document.getElementById(iframeId));
	var rightedge = document.body.clientWidth - event.clientX - position.x;
	var bottomedge = document.body.clientHeight - event.clientY - position.y;
	if (rightedge < rightMenu.offsetWidth){
		rightMenu.style.left = document.body.clientWidth - rightMenu.offsetWidth;
	}else{
		rightMenu.style.left = position.x + event.clientX;
	}
	
	//if (bottomedge < rightMenu.offsetHeight && document.getElementById(iframeId).offsetHeight <= document.body.clientHeight){
	//	rightMenu.style.top = document.body.clientHeight - rightMenu.offsetHeight;
	//}else{
		rightMenu.style.top = position.y + event.clientY;
	//}
	
	rightMenu.style.visibility = "visible";
	if (!window.ActiveXObject) {
		rightMenu.style.display = "";
	}
	return false
}

function getIframeEvent(iframeId) {
	if (window.ActiveXObject) {
		return document.getElementById(iframeId).contentWindow.event;// 如果是ie
	}
	func = getIframeEvent.caller;
	while (func != null) {
		var arg0 = func.arguments[0];
		if (arg0) {
			if ((arg0.constructor == Event || arg0.constructor == MouseEvent)
					|| (typeof (arg0) == "object" && arg0.preventDefault && arg0.stopPropagation)) {
				return arg0;
			}
		}
		func = func.caller;
	}
	return null;
}