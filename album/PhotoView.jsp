<%@ page language="java" contentType="text/html; charset=gbk" %>
<jsp:useBean id="hrm" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="chk" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="p" class="weaver.album.PhotoComInfo" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<%
String src = Util.null2String(request.getParameter("src"));
int id = Util.getIntValue(request.getParameter("id"));
String photoName="",photoPath="",photoDescription="",userId="",postdate="",subcompanyId="";
int parentId = 0;
rs.executeSql("SELECT * FROM AlbumPhotos WHERE id="+id+"");
if(rs.next()){
	parentId = rs.getInt("parentId");
	photoName = rs.getString("photoName");
	photoPath = rs.getString("photoPath");
	photoDescription = rs.getString("photoDescription");
	userId = rs.getString("userId");
	postdate = rs.getString("postdate");
	subcompanyId = rs.getString("subcompanyId");
}
//if(!photoPath.startsWith("/")){
	photoPath = "http://"+Util.getRequestHost(request)+"/weaver/weaver.album.ShowImgServlet?id="+id;
//}

//int[] ids = chk.getSubComByUserEditRightId(user.getUID(), "Album:Maint");
int[] ids = chk.getSubComByUserRightId(user.getUID(), "Album:Maint");
String _ids = "," + user.getUserSubCompany1() + ",";
for(int i=0;i<ids.length;i++){
	_ids += ids[i] + ",";
}


int previousId=0, nextId=0;
ArrayList siblingPhotos = new ArrayList();
rs.executeSql("SELECT id FROM AlbumPhotos WHERE parentId="+parentId+" AND isFolder='0' ORDER BY orderNum,postDate DESC");
while(rs.next()){
	siblingPhotos.add(rs.getString("id"));
}
int myPos = siblingPhotos.indexOf(""+id);
if(myPos>0){
	previousId = Util.getIntValue((String)siblingPhotos.get(myPos-1));
}
if(myPos<siblingPhotos.size()-1){
	nextId = Util.getIntValue((String)siblingPhotos.get(myPos+1));
}

if(_ids.indexOf(","+subcompanyId+",")==-1){
	response.sendRedirect("/notice/noright.jsp");
}


String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(74,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<html>
<head>
<script type="text/javascript" src="/js/weaver.js"></script>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript">
function photoResize(){
	//var img = event.srcElement;
	var img = $("oImg");
	var imgWidth = img.width;
	var winWidth = document.body.offsetWidth;
	img.style.width = imgWidth>winWidth ? (winWidth-40)+"px" : imgWidth;
}
function openNewWin(){
	var img = event.srcElement;
	window.open(img.src,"","");
}
function loadPhotoReview(){
	var o = event.srcElement;
	$("tdReview").innerHTML = o.contentWindow.document.body.innerHTML;
}
function submitReview(){
	doSubmit("iframeReview", "PhotoReview.jsp?id=<%=id%>&operation=add");
	weaver.reviewContent.innerHTML = "";
}
function deleteReview(){
	var reviewId = event.srcElement.getAttribute("reviewId");
	if(!confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>")) return false;
	doSubmit("iframeReview", "PhotoReview.jsp?id=<%=id%>&reviewId="+reviewId+"&operation=delete");
}
function editReview(){
	var o = event.srcElement;
	var reviewId = o.getAttribute("reviewId");
	o.style.display = "none";
	$("linkSave"+reviewId).style.display = "inline";
	$("linkCancel"+reviewId).style.display = "inline";
	var td = findTD(o);
	try{
		document.body.removeChild(document.getElementById("hidden_"+reviewId));
	}catch(e){}
	var tempObj = document.createElement("DIV");
	tempObj.style.display = "none";
	tempObj.id = "hidden_"+reviewId;
	tempObj.innerHTML = td.innerHTML;
	document.body.appendChild(tempObj);
	td.innerHTML = "<textarea class='inputstyle' style='width:100%;height:100px;background-color:#FFFFF1'>"+td.innerHTML.replace(/<BR>/ig,"\n")+"</textarea>";
}
function cancelReview(o){
	var o = event.srcElement;
	var reviewId = o.getAttribute("reviewId");
	o.style.display = "none";
	$("linkSave"+reviewId).style.display = "none";
	$("linkEdit"+reviewId).style.display = "inline";
	var td = findTD(o);
	td.innerHTML = document.getElementById("hidden_"+reviewId).innerHTML;
}
function saveReview(){
	var o = event.srcElement;
	var reviewId = o.getAttribute("reviewId");
	var td = findTD(o);
	var txtReview = td.firstChild;
	txtReview.name = "reviewContentUpdate";
	doSubmit("iframeReview", "PhotoReview.jsp?id=<%=id%>&reviewId="+reviewId+"&operation=update");
}
function doSubmit(fTarget, fAction){
	$("weaver").target = fTarget;
	$("weaver").action = fAction;
	$("weaver").submit();
}
function findTD(o){
	while(o.tagName!="TABLE"){o = o.parentElement;}
	return o.rows[1].cells[0];
}
</script>
<link rel="stylesheet" type="text/css" href="/css/Weaver.css" />
<style type="text/css" media="screen">
.href{cursor:hand;color:blue;text-decoration:underline;padding:0 2px 0 2px}
input{width:90%;}
</style>
</head>
<body onload="photoResize()">
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(src.equals("list")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/album/AlbumList.jsp?id="+parentId+",_self} ";
	RCMenuHeight += RCMenuHeightStep;
	if(previousId!=0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(20205,user.getLanguage())+",/album/PhotoView.jsp?id="+previousId+"&src="+src+",_self} ";
		RCMenuHeight += RCMenuHeightStep;
	}
	if(nextId!=0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(20206,user.getLanguage())+",/album/PhotoView.jsp?id="+nextId+"&src="+src+",_self} ";
		RCMenuHeight += RCMenuHeightStep;
	}
}else if(src.equals("search")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/album/PhotoSearchResult.jsp,_self} ";
	RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table style="width:98%;height:92%;border-collapse:collapse" align="center">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td valign="top">
		<table class="Shadow">
		<tr>
		<td valign="top">
<!--==========================================================================================-->
<form method="post" action="AlbumFolderOperation.jsp" id="weaver" name="weaver">
<input type="hidden" name="operation" value="add" />
<input type="hidden" name="parentId" value="<%=id%>" />
<table class="ViewForm">
<colgroup>
<col width="15%">
<col width="85%">
</colgroup>
<tbody>
<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></th>
</tr>
<tr class="Spacing" style="height: 1px;"><td class="Line1" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
	<td class="Field"><%=photoName%></td>
</tr>
<tr style="height: 1px;"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
	<td class="Field"><a href="/hrm/resource/HrmResource.jsp?id=<%=userId%>"><%=hrm.getResourcename(userId)%></a></td>
</tr>
<tr style="height: 1px;"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
	<td class="Field"><%=postdate%></td>
</tr>
<tr style="height: 1px;"><td class="Line" colspan="2"></td></tr>
<tr>
	<td colspan="2" style="text-align:center">
	<img id="oImg" src="<%=photoPath%>" style="cursor:hand" onload="" onclick="openNewWin()" />
	</td>
</tr>
<tr style="height: 1px;"><td class="Line" colspan="2"></td></tr>
<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(675,user.getLanguage())%></th>
</tr>
<tr class="Spacing" style="height: 1px;"><td class="Line1" colspan="2"></td></tr>
<tr>
	<td colspan="2" id="tdReview">
		<img src="/images/loading2.gif"> <%=SystemEnv.getHtmlLabelName(20010,user.getLanguage())%>
	</td>
</tr>
<tr style="height: 1px;"><td class="Line" colspan="2"></td></tr>
<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(20009,user.getLanguage())%></th>
</tr>
<tr class="Spacing" style="height: 1px;"><td class="Line1" colspan="2"></td></tr>
<tr>
	<td colspan="2">
		<textarea class="inputstyle" name="reviewContent" style="width:100%;height:100px"></textarea>
		<input type="text" name="reviewContentUpdate" style="display:none" />
		<button class="btnSave" type="button" accesskey="S" onclick="submitReview()"><u>S</u>-<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></button>
	</td>
</tr>
</table>
</form>
<!--==========================================================================================-->
		</td>
		</tr>
		</table>
	</td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

<iframe name="iframeReview" src="PhotoReview.jsp?id=<%=id%>" onload="loadPhotoReview()" style="display:none"></iframe>
</body>
</html>