<%@ page language="java" contentType="text/html; charset=gbk" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="subcompany" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="PhotoComInfo" class="weaver.album.PhotoComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>
<%
String strId = Util.null2String(request.getParameter("id"));
int id = Util.getIntValue(strId, 0);
//if(id==0) id=user.getUserSubCompany1();

//String subcompanyName = subcompany.getSubCompanyname(String.valueOf(id));
int subCompanyId=id;
if(id<0){
	subCompanyId=Util.getIntValue(PhotoComInfo.getSubCompanyId(""+id), -1);
	if(subCompanyId<-1){
		subCompanyId=user.getUserSubCompany1();
	}
}

String sName = Util.null2String(request.getParameter("sName"));
String sUserId = Util.null2String(request.getParameter("sUserId"));
String sDate1 = Util.null2String(request.getParameter("sDate1"));
String sDate2 = Util.null2String(request.getParameter("sDate2"));

String imagefilename = "/images/hdMaintenance.gif";
String _breadcrumb = breadcrumb("",String.valueOf(id));
if(_breadcrumb.endsWith(" ")) _breadcrumb=_breadcrumb.substring(0,_breadcrumb.length()-1);
if(_breadcrumb.endsWith(">")) _breadcrumb=_breadcrumb.substring(0,_breadcrumb.length()-1);
String titlename = "" + _breadcrumb;
String needfav ="1";
String needhelp ="";
%>
<html> 
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=gbk" />
<head>
<script type="text/javascript" src="/js/weaver.js"></script>
<script type="text/javascript" src="/js/prototype1.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver.css" />
<style type="text/css">.href{color:blue;text-decoration:underline;cursor:hand}</style>
</head>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
String canEdit = "false";
String canDel = "false";
if(!strId.equals("")){

//if(HrmUserVarify.checkUserRight("Album:Maint",user)){
//	canEdit = "true";
//	RCMenu += "{"+SystemEnv.getHtmlLabelName(20001,user.getLanguage())+",javascript:upload(),_self} " ;    
//	RCMenuHeight += RCMenuHeightStep;
//	RCMenu += "{"+SystemEnv.getHtmlLabelName(20002,user.getLanguage())+",javascript:location.href='AlbumFolderAdd.jsp?id="+id+"',_self} " ;    
//	RCMenuHeight += RCMenuHeightStep;
//	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deletePhotoBatch();,_self} ";
//	RCMenuHeight += RCMenuHeightStep;
//}

    //是否分权系统，如不是，则不显示框架，直接转向到列表页面
    rs.executeSql("select detachable from SystemSet");
    int detachable=0;
    if(rs.next()){
        detachable=rs.getInt("detachable");
    }

    int operatelevel=0;

    if(detachable==1){  
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Album:Maint",subCompanyId);
    }else{
        //if(HrmUserVarify.checkUserRight("FieldManage:All", user))
        if(HrmUserVarify.checkUserRight("Album:Maint", user)){
            operatelevel=2;
		}
    }

	if(operatelevel>=1){
		canEdit="true";
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(20001,user.getLanguage())+",javascript:upload(),_self} " ;    
	    RCMenuHeight += RCMenuHeightStep;
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(20002,user.getLanguage())+",javascript:location.href='AlbumFolderAdd.jsp?id="+id+"',_self} " ;    
	    RCMenuHeight += RCMenuHeightStep;
	}
		RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:search(),_self} ";
        RCMenuHeight += RCMenuHeightStep;
	if(operatelevel==2){
		canDel="true";
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deletePhotoBatch();,_self} ";
	    RCMenuHeight += RCMenuHeightStep;
	}

    
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} ";
    RCMenuHeight += RCMenuHeightStep;
}

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table style="width:100%;height:92%;border-collapse:collapse">
<tr>
	<td height="10"></td>
</tr>
<tr>
	<td valign="top">
		<TABLE class=Shadow>
		<colgroup>
			<col width="10"/>
			<col width=""/>
			<col width="10"/>
		</colgroup>
		<tr>
		<td></td>
		<td valign="top">
<!--==========================================================================================-->
<table class="viewform">
<form name="searchForm" method="post" action="">
<colgroup>
	<col width="6%"/>
	<col width="20%"/>
	<col width="1%"/>
	<col width="6%"/>
	<col width="15%"/>
	<col width="1%"/>
	<col width="6%"/>
	<col width="35%"/>
</colgroup>
<tbody>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
	<td class=field>
		<input type="text" name="sName" style="width:100%" class="Inputstyle" value="<%=sName%>"/>
	</td>
	<td></td>
	<td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
	<td class=field>
	 	<button type="button" class="Browser" onClick="onShowHRMResource()"></BUTTON>
	
	 
		<span id="sUserIdSpan"><%=ResourceComInfo.getResourcename(sUserId)%></span>
		<input type="hidden" _url="" name="sUserId" value="<%=sUserId%>"/>
	</td>
	<td></td>
	<td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
	<td class=field>
	    <input name="sDate1" type="hidden" class=wuiDate  value="<%=sDate1%>"></input> 
	    -&nbsp;
	     <input name="sDate2" type="hidden" class=wuiDate value="<%=sDate2%>" ></input> 
	</td>
</tr>
<tr style="height:2px" ><td class="line" colspan="8"></td></tr>
</form>
</table>
<!--==========================================================================================-->
<form id="weaver" method="post" action="">
<%
String sqlWhere = "WHERE parentId="+id+" ";
if(!sName.equals("")){
	sqlWhere += " AND isFolder='0' AND photoName LIKE '%"+sName+"%' ";
}
if(!sUserId.equals("")){
	sqlWhere += " AND userId="+sUserId+" ";
}
if(!sDate1.equals("")&&!sDate2.equals("")){
	sqlWhere += " AND postdate BETWEEN '"+sDate1+"' AND DATEADD(day,1,'"+sDate2+"') ";
}else if(!sDate1.equals("")){
	sqlWhere += " AND postdate>'"+sDate1+"' ";
}else if(!sDate2.equals("")){
	sqlWhere += " AND postdate<DATEADD(day,1,'"+sDate2+"') ";
}
String tableString=""+
	"<table pagesize=\"20\" tabletype=\"thumbnail\">"+
	"<browser imgurl=\"/weaver/weaver.album.ThumbnailServlet\" linkkey=\"\" linkvaluecolumn=\"\" path=\"thumbnailPath\" />"+
	"<sql backfields=\"*\" sqlform=\"AlbumPhotos\" sqlprimarykey=\"id\" sqlsortway=\"desc\" sqlorderby=\"isFolder,orderNum,postDate\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" />"+
	"<head>"+
//		"<col width=\"100%\" text=\"\" column=\"photoName\" orderkey=\"photoName\" transmethod=\"weaver.splitepage.transform.SptmForAlbum.getHref\" otherpara=\"column:id+column:isFolder+column:photoCount+column:userId+"+user.getUID()+"+"+canEdit+"+list\" />"+
		"<col width=\"100%\" text=\"\" column=\"photoName\" orderkey=\"photoName\" transmethod=\"weaver.splitepage.transform.SptmForAlbum.getHref\" otherpara=\"column:id+column:isFolder+column:photoCount+column:userId+"+user.getUID()+"+"+canEdit+"+list+"+canDel+"\" />"+
	"</head>"+
	"</table>";
%>
<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" isShowTopInfo="false" isShowThumbnail="1" imageNumberPerRow="5"/>
</form>
<!--==========================================================================================-->
<iframe id="iframeAlbumSubcompany" style="width:100%;height:180px" frameborder="0" src="AlbumSubcompany.jsp?id=<%=id%>"></iframe>
<!--==========================================================================================-->
		</td>
		<td></td>
		</tr>
		</TABLE>
	</td>
	
</tr>
<tr>
	<td height="10"></td>
</tr>
</table>
<div class="xTable_message" style="display:" id="msgBox"></div>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>


<script type="text/javascript">
jQuery("#rightMenu").css("visibility","visible");
jQuery("#rightMenu").css("display","");
var dialogMsg = "<%=SystemEnv.getHtmlLabelName(20537,user.getLanguage())%>?";



function upload(){
	showMsgBox($G("msgBox"), "<img src='/images/loading2.gif'> 正在载入图片上传组件...");
	location.href = "ImageUploaderD.jsp?id=<%=id%>";
}
function search(){
	var f = $G("searchForm");
	f.submit();
}
function editTitle(id, isFolder){
	if(isFolder){
		location.href = "AlbumFolderEdit.jsp?id="+id;
		return false;
	}
	var photoName="",photoExtName="";
	var o = event.srcElement;
	while(o.tagName!="TD"){o = o.parentNode;}
	var str = o.innerHTML.match(/<A.*?>(.*)<\/A>/i)[1];
	var dotPos = str.lastIndexOf(".");
	var bracketPos = str.lastIndexOf("(");
	//if(dotPos==-1){
		//photoName = str.substring(0, bracketPos);
	//}else{
		photoName = str.substring(0, dotPos);
		photoExtName = str.substring(dotPos, str.length);
	//}
	var title = prompt("<%=SystemEnv.getHtmlLabelName(20008,user.getLanguage())%>:", photoName);
	if(title){
		title = title.replace(/\.|\(|\)/ig,"");
		callAjax("PhotoOperation.jsp", "operation=edit&id="+id+"&title="+escape(title+photoExtName));
	}
}
function deletePhotoBatch(){
	if(confirm(dialogMsg)){
		callAjax("PhotoOperation.jsp", "operation=batchdelete&ids="+_xtable_CheckedCheckboxValue()+"");
		reloadAlbumSubcompany();
	}
}
function deletePhoto(id){
	if(confirm(dialogMsg)){
		callAjax("PhotoOperation.jsp", "operation=delete&id="+id);
		reloadAlbumSubcompany();
	}
}
function callAjax(url, param){
	new Ajax.Request(url,{
		onSuccess : function(resp){
			_table.reLoad();
			var _operation = resp.responseText.stripScripts().stripTags().escapeHTML();
			if(_operation=="reloadTree" && parent.frames[0]){
				parent.frames[0].location.reload();
			}
		},
		onFailure : function(){alert("");},
		parameters : param
	});
}
function reloadAlbumSubcompany(){
	$G("iframeAlbumSubcompany").contentWindow.document.location.reload();
}

function onShowHRMResource(){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",

			value:""
			};
			var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
			var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
			opts.top=iTop;
			opts.left=iLeft;


	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
    if (datas){
	if (datas.id!=""){
		document.getElementById("sUserIdSpan").innerHTML = "<A href='/hrm/resource/HrmResource.jsp?id="+datas.id+"'>"+datas.name+"</A>"
		searchForm.sUserId.value = wuiUtil.getJsonValueByIndex(datas,0);
	}else{ 
		document.getElementById("sUserIdSpan").innerHTML = "";
		searchForm.sUserId.value = "";
	}
    }
}


</script>

<%!
String breadcrumb(String str, String id) throws Exception{
	weaver.album.PhotoComInfo p = new weaver.album.PhotoComInfo();
	weaver.hrm.company.SubCompanyComInfo c = new weaver.hrm.company.SubCompanyComInfo();
	int _id = Integer.parseInt(id);
	String parentId = "";
	String photoName = "";
	parentId = p.getParentId(id);
	if(!parentId.equals("")){
		str += breadcrumb(str,parentId);
	}
	photoName = _id>0 ? c.getSubCompanyname(id) : p.getPhotoName(id);
	str += "<a href='AlbumList.jsp?id="+id+"'>"+photoName+"</a> > ";
	return str;
}
%>