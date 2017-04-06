<%
weaver.hrm.User user = weaver.hrm.HrmUserVarify.getUser (request , response) ;
if(user == null){
	return ;
}
%>
<html>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp.css" rel="STYLESHEET" type="text/css">
<%@ page import="weaver.general.BaseBean" %>
<body bgColor="transparent" onload="bodyresize()">
<%
	response.setContentType("text/html;charset=UTF-8");
	int logid = weaver.general.Util.getIntValue(request.getParameter("logid"), 0);
	String pagestr = weaver.general.Util.null2String((String)session.getAttribute("FCKsignDesc_"+logid));
	java.util.Enumeration seccionANames = session.getAttributeNames();
	boolean hasSession = false;
    try{
    while(seccionANames!=null && seccionANames.hasMoreElements()){
    	String seccionAName = weaver.general.Util.null2String((String)seccionANames.nextElement());
    	if(seccionAName.equals("FCKsignDesc_"+logid)){
    		hasSession = true;
    		break;
    	}
    }
    }catch(Exception e){}
    if(hasSession == false){
    	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
    	rs.execute("select remark from workflow_requestlog where logid="+logid);
    	if(rs.next()){
    		pagestr = weaver.general.Util.null2String(rs.getString(1));
    	}
    }
	String retrunstr="";
	BaseBean baseBeanRigthMenu = new BaseBean();
	int userightmenu = 1;
	try{
		userightmenu = weaver.general.Util.getIntValue(baseBeanRigthMenu.getPropValue("systemmenu", "userightmenu"), 1);
	}catch(Exception e){}
%>
<script language="javascript">
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

function bodyresize(){
	if(document.body.scrollHeight==0){
		window.setTimeout("bodyresize()", 10);
	} else {
		parent.document.getElementById("FCKsigniframe<%=logid%>").height = parent.jQuery(contentTd).height() + 6;
	}

	var objAList=document.getElementsByTagName("A");
	for(var i=0; i<objAList.length; i++){
		var obj = objAList[i];
		var href = obj.href;
		var target = obj.target;
		if(href.indexOf("javascript:") == -1){
			obj.target = "_blank";
		}
	}
}

<%if(userightmenu == 1){%>
  //作用：点右键的时候显示右键菜单
if(document.all && window.print){
	document.oncontextmenu = fckshowrightmenu;
	document.onclick = fckhiddenrightmenu;
}
function fckhiddenrightmenu(){
	parent.rightMenu.style.visibility="hidden";
}
function getAbsolutePosition(obj){
	position = new Object();
	position.x = 0;
	position.y = 0;
	var tempobj = obj;
	while(tempobj!=null && tempobj!=document.body){
		position.x += tempobj.offsetLeft + tempobj.clientLeft;
		position.y += tempobj.offsetTop + tempobj.clientTop;
		tempobj = tempobj.offsetParent
	}
	position.x += parent.document.body.scrollLeft;
	if(parent.document.getElementById("divWfBill")) position.y -= parent.document.getElementById("divWfBill").scrollTop;
	return position;
}
function fckshowrightmenu(){
	var position=getAbsolutePosition(parent.document.getElementById("FCKsigniframe<%=logid%>"));
	var rightedge=parent.document.body.clientWidth-event.clientX-position.x
	var bottomedge=parent.document.body.clientHeight-event.clientY-position.y
	if (rightedge<parent.rightMenu.offsetWidth){
		parent.rightMenu.style.left=parent.document.body.clientWidth-parent.rightMenu.offsetWidth
	}else{
		parent.rightMenu.style.left=position.x+event.clientX
	}
	if(bottomedge<parent.rightMenu.offsetHeight){
		parent.rightMenu.style.top=parent.document.body.clientHeight-parent.rightMenu.offsetHeight
	}else{
		parent.rightMenu.style.top=position.y+event.clientY
	}
	parent.rightMenu.style.visibility="visible"
	return false
}
<%}%>
</script>
<table class="ViewForm">
<tr>
<td style="WORD-break:break-all;" id="contentTd">
<%
	//System.out.println(pagestr);
	//脚本过滤
	while(pagestr.toLowerCase().indexOf("<script")!=-1){
		int startindx=pagestr.toLowerCase().indexOf("<script");
		int endindx=pagestr.toLowerCase().indexOf("</script>");
		if(endindx!=-1 && endindx>startindx){
			retrunstr+=pagestr.substring(0,startindx);
			pagestr=pagestr.substring(endindx+9);
		}
	}
	retrunstr+=pagestr;
	//System.out.println(retrunstr);
	out.print(retrunstr);
%>
</td>
</tr>
</table>
</body>
</html>