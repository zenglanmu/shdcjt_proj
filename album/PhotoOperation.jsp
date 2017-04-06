<%@ page language="java" contentType="text/html; charset=gbk" %>
<%@ page import="java.util.*,java.sql.*,java.io.*" %>
<%@ page import="weaver.general.*,weaver.album.PhotoSequence,weaver.file.FileManage" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="p" class="weaver.album.PhotoComInfo" scope="page" />
<%
String sql = "";
int id = Util.getIntValue(request.getParameter("id"));
String operation = Util.null2String(request.getParameter("operation"));
String realPath = request.getRealPath("..").substring(0, request.getRealPath("..").length()-1);

if(operation.equals("add")){

//=======================================================================
}else if(operation.equals("delete")){
	String subIds = p.getSubIds(""+id);
	subIds = subIds + id;
	if(subIds.endsWith(",")) subIds=subIds.substring(0,subIds.length()-1);

	sql = "DELETE FROM AlbumPhotos WHERE id IN ("+subIds+")";
	rs.executeSql(sql);

	//sqlserver使用触发器
	String parentId = p.getParentId(""+id);
	String ancestorId = p.getAncestorId(""+id);
	if(rs.getDBType().equals("oracle")){
		p.updateCountAndSize(ancestorId, parentId);
	}

	String[] _ids = Util.TokenizerString2(subIds, ",");
	for(int i=0;i<_ids.length;i++){
		id = Util.getIntValue(_ids[i]);
		if(!p.getPhotoPath(""+id).equals("/images/xpfolder38.gif")){//不删除图片文件夹图标
			if(p.getPhotoPath(""+id).startsWith("/")){
				FileManage.DeleteFile(realPath + File.separator + "album" + File.separator + "UploadFolder" + File.separator + id);	
			}else{
				FileManage.DeleteFile(p.getPhotoPath(""+id));
			}
			FileManage.DeleteFile(realPath + File.separator + "album" + File.separator + "UploadFolder" + File.separator + "thumbnail" + File.separator + id);
		}
	}

	//p.updatePhotoInfoCache(p.getParentId(String.valueOf(id)));
	p.removePhotoComInfoCache();
	if(p.getIsFolder(""+id).equals("1"))	out.print("reloadTree");

//=======================================================================
}else if(operation.equals("edit")){
	String title = Util.null2String(request.getParameter("title"));
	title = Util.toHtml6(title);
	sql = "UPDATE AlbumPhotos SET photoName='"+title+"' WHERE id="+id+"";
	rs.executeSql(sql);

	p.updatePhotoInfoCache(""+id);
	if(p.getIsFolder(""+id).equals("1"))	out.print("reloadTree");

//=======================================================================
}else if(operation.equals("batchdelete")){
	String ancestorId = "";
	String parentId = "";

	String ids = Util.null2String(request.getParameter("ids"));
	String[] _ids = Util.TokenizerString2(ids, ",");
	for(int i=0;i<_ids.length;i++){
		ancestorId = p.getAncestorId(""+_ids[i]);
		parentId = p.getParentId(""+_ids[i]);
		ids += p.getSubIds(_ids[i]);
	}
	if(ids.endsWith(",")) ids=ids.substring(0,ids.length()-1);

	sql = "DELETE FROM AlbumPhotos WHERE id IN ("+ids+")";
	rs.executeSql(sql);

	//sqlserver使用触发器
	if(rs.getDBType().equals("oracle")){
		p.updateCountAndSize(ancestorId, parentId);
	}

	String[] idArray = Util.TokenizerString2(ids, ",");
	for(int i=0;i<idArray.length;i++){
		if(!p.getPhotoPath(""+id).equals("/images/xpfolder38.gif")){//不删除图片文件夹图标
			if(p.getPhotoPath(idArray[i]).startsWith("/")){
				FileManage.DeleteFile(realPath + File.separator + "album" + File.separator + "UploadFolder" + File.separator + idArray[i]);	
			}else{
				FileManage.DeleteFile(p.getPhotoPath(idArray[i]));
			}
			FileManage.DeleteFile(realPath + File.separator + "album" + File.separator + "UploadFolder" + File.separator + "thumbnail" + File.separator + idArray[i]);
		}
	}

	p.removePhotoComInfoCache();

//=======================================================================
}else if(operation.equals("updateAlbumSize")){
	int albumSize = Util.getIntValue(request.getParameter("albumSize"))*1000;
	sql = "UPDATE AlbumSubcompany SET albumSize="+albumSize+" WHERE subcompanyId="+id+"";
	rs.executeSql(sql);
	response.sendRedirect("AlbumSubcompany.jsp?id="+id+"");
}
%>