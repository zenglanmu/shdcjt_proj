var wemail;
var whrm;
var wmess;
var wmsm;
var W = 0;//取得屏幕分辨率宽度
var H = 0;//取得屏幕分辨率高度
var userid = "";
var tousername;
// 获得窗口宽度 
function getWin()
{
	if (window.innerWidth)   
	{
		W  =  window.innerWidth;
	}   
	else if ((document.body)  &&  (document.body.clientWidth))   
	{
		W  =  document.body.clientWidth;
	} 
	// 获得窗口高度 
	if (window.innerHeight)   
	{
		H  =  window.innerHeight;
	}   
	else if ((document.body)  &&  (document.body.clientHeight))   
	{
		H  =  document.body.clientHeight;
	} 
	if (document.documnetElement  &&  document.documnetElement.clientHeight  &&  document.documnetElement.clientWidth)   
	{
		W  =  document.documnetElement.clientWidth;
		H  =  document.documnetElement.clientHeight;
	} 
	
}
var oIframe = document.createElement('iframe');
var message_table_Div =  document.createElement("div");
var content;
if(M('mainsupports')!=null)
{
	content = M('mainsupports').innerHTML;
}

function M(id)
{
    var result = document.getElementById(id);
    if(result==null)
    {
    	result = parent.document.getElementById(id);
    }
    if(result==null)
    {
    	result = parent.parent.document.getElementById(id);
    }
    if(result==null)
    {
    	result = parent.parent.parent.document.getElementById(id);
    }
    return result;
}
function MC(t){
   return document.createElement(t);
};
function isIE(){
      return (document.all && window.ActiveXObject && !window.opera) ? true : false;
} 
var bodySize = [];
var clickSize = [];
function getBodySize(){
   return bodySize;
}
function getClickSize(){
   return clickSize;
}
function pointerXY(event)  
{    
     if(event.pageX||event.pageY)
     {
     	bodySize[0] = event.pageX;
     	bodySize[1] = event.pageY;
     	clickSize[0] = event.pageX;
     	clickSize[1] = event.pageY;
     }
     else
     {
     	bodySize[0] = event.clientX + document.body.scrollLeft+document.documentElement.clientWidth;
     	bodySize[1] = event.clientY + document.body.scrollTop+document.documentElement.clientHeight;
     	clickSize[0] = event.clientX;
     	clickSize[1] = event.clientY;
     }
} 

function pointerXYByObj(obj)  
{    
    
    	var p =  $(obj).position()
     	bodySize[0] = p.left;
     	bodySize[1] = p.top;
     	clickSize[0] = p.left;
     	clickSize[1] = p.top;
     
} 


//让层显示为块 
function openResource()
{
	var submitURL = "/hrm/resource/simpleHrmResourceTemp.jsp?userid="+userid;
	postXmlHttp(submitURL, "showResource()", "loadEmpty()");
}
function loadEmpty()
{
	void(0);
}
function showResource()
{
	var userinfo = _xmlHttpRequestObj.responseText;
	var re = /\$+([^\$]+)/ig; // 创建正则表达式模式。 
	var arr; 
	var i = 0;
	var language=readCookie("languageidweaver");
	
	
	while ((arr = re.exec(userinfo)) != null) 
	{
		var result = arr[1];

		if(result=="noright"){
			var noright = "";
			if(language==7||language==9){
				noright = "对不起，您暂时没有权限！";
			} else {
				noright = "Sorry,you haven''t popedom temporarily!";
			}
			M("message_table").innerHTML = "<div style=\"border:1px solid #aaaaaa;width:100%;height:100%;\"><div style=\"float:right; clear:both; width:100%; text-align:right; margin:5px 0 0 0\"><IMG style=\"COLOR: #262626; CURSOR: hand\" id=closetext onclick=javascript:closediv(); src=\"http://localhost:8080/images/messageimages/temp/closeicno.gif\" width=7 height=7></div><div style=\"text-indent:1.5pc; line-height:21px \"><b>"+noright+"</b></div></div>";
			return;
		}
		
		if(result ==',')
		{
			result = "";
			M("result"+i).innerHTML= result;
		}
		else
		{
			if(result=='Mr.'||result=='Ms.')
			{
				if(language==7||language==9)
				{
					if(result=='Mr.')
					{
						
						M("result"+i).innerHTML= "男";
					}
					else if(result=='Ms.')
					{
						M("result"+i).innerHTML= "女";
					}					
				}
				else
				{
					M("result"+i).innerHTML= result;
				}
			}
			else if(result.indexOf("imageid=")!=-1)
			{
				var resourceimageid = result.substring(8,result.length);
				if(resourceimageid!="" && resourceimageid!="0") 
				{
					M("resourceimg").src="/weaver/weaver.file.FileDownload?fileid="+resourceimageid;
					M("resourceimghref").href = "/weaver/weaver.file.FileDownload?fileid="+resourceimageid;
				}
				else
				{
					if(M("result2").innerHTML=="男"||M("result2").innerHTML=="Mr.")
					{
						M("resourceimg").src="/images/messageimages/temp/man.gif";
					}
					else
					{
						M("resourceimg").src="/images/messageimages/temp/women.gif";
					}
					M("resourceimghref").href="javascript:void(0);"
				}
			}
			else if(result.indexOf("ip=")!=-1)
			{
				var isonline = result.substring(3,result.length);
				if(isonline == ',')
				{
					M("isonline").src = "/images/messageimages/temp/offline.gif";
					if(language==7||language==9)
					{
						M("isonline").title = "离线";
					}
					else
					{
						M("isonline").title = "offline";
					}
					M("result0").innerHTML = "";
				}
				else
				{
					M("isonline").src = "/images/messageimages/temp/online.gif";
					if(language==7||language==9)
					{
						M("isonline").title = "在线";
					}
					else
					{
						M("isonline").title = "online";
					}
					M("result0").innerHTML = isonline;
				}
			}
			else if(result.indexOf("messager")!=-1){
				try {
				M("showMessagerTrForSimpleHrm").style.display="";
				} catch(e){}
			}
			else
			{
				if(M("result"+i)!=null){
					M("result"+i).innerHTML= result;
				}
			}
		}
		i++;
	}
	tousername = M('result1').innerHTML;
}

function changehrm()
{
   var mainsupports = M("mainsupports");   
   var bodySize = getBodySize();
   var clickSize = getClickSize();
   var wi = W-clickSize[0];
   var hi = H-clickSize[1];
   if(wi<372)
   {
   		wi=bodySize[0]+wi-372;
   }
   else
   {
   		wi = bodySize[0]
   }
   if(hi<230)
   {
   		hi=bodySize[1]+hi-230;
   }
   else
   {
   		hi = bodySize[1];
   }
   
   if(!window.ActiveXObject) {
	   var msfTop = document.body.clientHeight - (bodySize[1] - document.body.scrollTop) - 230;
	   if (msfTop < 0) {
		   hi = bodySize[1] + msfTop;
	   } else {
		   hi = bodySize[1];
	   }
   }
   showIframe(mainsupports,hi,wi);
}
function showIframe(div,hi,wi)
{
	 div.style.width = 373+"px";
     div.style.height = 216+"px";
     div.style.left = wi+"px";
     div.style.top = hi+"px";
	 div.style.display = 'block';
	 if(content==undefined||content==null)
	 {
	 	content = M('mainsupports').innerHTML;
	 }
	 div.innerHTML = "";
	 oIframe.id = 'HelpFrame';
     div.appendChild(oIframe);
     oIframe.frameborder = 1;
     oIframe.style.position = 'absolute';
     oIframe.style.zIndex = 9;
     
     oIframe.style.width = 373+"px"; 
     oIframe.style.height = 217+"px";
     oIframe.style.top = 'auto';
     oIframe.style.left = 'auto';
     oIframe.style.display = 'block';
     message_table_Div.id="message_table";
     message_table_Div.className="xTable_message";
     div.appendChild(message_table_Div);
     
     message_table_Div.innerHTML=content;
     message_table_Div.style.position="absolute"
     message_table_Div.style.width = 373+"px";
     message_table_Div.style.height = 216+"px";
     message_table_Div.style.padding = "0px";
     message_table_Div.style.margin = "0px";
     message_table_Div.style.border = "0px";
     message_table_Div.style.zIndex=10;
     message_table_Div.style.display="block";
     message_table_Div.style.top="0px";
     message_table_Div.style.left="0px";

}
//打开DIV层
function openhrm(tempuserid)
{
	userid = tempuserid;
	getWin();
  	openResource();
  	changehrm();
  	void(0);
}
function openemail()
{  	
  	openFullWindowForXtable("/email/MailAdd.jsp","email",'');
}
function openhrmresource()
{
  	openFullWindowForXtable("/hrm/resource/HrmResource.jsp?id="+userid);
}
function openmessage()
{
	openFullWindowForXtable("/sms/SmsMessageEdit.jsp?hrmid="+userid);
}
//关闭DIV层
function closediv()
{
	M('mainsupports').style.display="none";
	M('HelpFrame').style.display = 'none';
	M('message_table').style.display="none";
	
  	void(0);
}

//在线聊天
function showHrmChat(){
    try {    	
		top.Page.showMessage(userid);
		 /*var docobj="top.hrmChat";
		while (!eval(docobj)) {
		    docobj="opener."+docobj;  
		}
		eval(docobj).sendChatFun(objid);*/		
	} catch(e) {
	   //alert(e);
	}
}