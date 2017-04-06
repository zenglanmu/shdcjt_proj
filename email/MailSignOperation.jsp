<%@ page language="java" contentType="text/html; charset=gbk" %> 
<%@ page import="weaver.general.Util,weaver.file.*,weaver.conn.*" %>
<%@ page import="java.io.Writer,oracle.sql.CLOB,weaver.conn.ConnStatement" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
FileUpload fu = new FileUpload(request, false);
int id = Util.getIntValue(fu.getParameter("id"));
int userId = Util.getIntValue(fu.getParameter("userid"));
if(userId==-1){
	userId = user.getUID();
}

String showTop = Util.null2String(fu.getParameter("showTop"));

String sql = "";
String operation = Util.null2String(fu.getParameter("operation"));
String signName = Util.null2String(fu.getParameter("signName"));
String signDesc = Util.null2String(fu.getParameter("signDesc"));
String signContent = Util.null2String(fu.getParameter("signContent"));
String defaultSignId = Util.null2String(fu.getParameter("defaultSignId"));

if(operation.equals("add") || operation.equals("update")){
    Hashtable _imgnames = fu.getUploadImgNames();
    String img_flag="<img alt=\"docimages_";
    int tmppos = signContent.indexOf(img_flag);
    ArrayList list = new ArrayList();
    String docimageNum = "0";
    int tmppos2 = 0;
    while(tmppos != -1) {
		tmppos2 = tmppos;
		tmppos = signContent.indexOf("src=\"",tmppos+20);
		docimageNum = signContent.substring(tmppos2+19, tmppos-1);
		docimageNum = docimageNum.substring(1,docimageNum.indexOf('"'));
		int startpos = signContent.indexOf("\"", tmppos);
		int endpos = signContent.indexOf("\"", startpos + 1);
		String tempStr = signContent.substring(startpos + 1, endpos);
		String replaceStr = "cid:img"+docimageNum+"@www.weaver.com.cn";

		if(tempStr.indexOf("weaver.email.FileDownloadLocation")!=-1){
			tmppos = signContent.indexOf(img_flag, startpos+tempStr.length());
		}
		signContent = Util.StringReplace(signContent, tempStr,replaceStr);
		tmppos = signContent.indexOf(img_flag, startpos+replaceStr.length());
		list.add(docimageNum);
	}
if(operation.equals("add"))
{
	signContent =signContent.replaceAll("'", "''");
	sql = "insert into MailSign(userId,signName,signDesc,signContent) values("+userId+",'"+signName+"','"+signDesc+"','"+signContent+"')";
	rs.executeSql(sql);
	int signId=0;
	String signSql ="select max(id) from MailSign where userid="+userId;
	rs.execute(signSql);
	if(rs.next())
	signId=rs.getInt(1);
	for(int j=0;j<list.size();j++){
		try{
			String imgfilerealpath = (String)_imgnames.get(list.get(j).toString());
			String imgfilename = imgfilerealpath.substring(imgfilerealpath.lastIndexOf("\\")+1);

			String imgsql = "INSERT INTO MailResourceFile (mailid,filename,attachfile,filetype,filerealpath,iszip,isencrypt,isfileattrachment,fileContentId,isEncoded,filesize,signid) VALUES (null,'"+imgfilename+"',null,'image/gif','"+imgfilerealpath+"','0','0','0','img"+list.get(j)+"@www.weaver.com.cn','0',0,'"+signId+"')";
			rs.executeSql(imgsql);
		}catch(NullPointerException nulle){
		}
	}
}
else if(operation.equals("update"))
{
	sql = "update MailSign set signName='"+signName+"',signDesc='"+signDesc+"',signContent='"+signContent+"' where userid="+userId+" and id="+id;
	//System.out.println("sql : "+sql);
	rs.executeSql(sql);
	if(_imgnames.size()>0)
	rs.execute("delete from MailResourceFile where signid="+id+"and isfileattrachment=0"); 
	for(int j=0;j<list.size();j++){
		try{
			String imgfilerealpath = (String)_imgnames.get(list.get(j).toString());
			String imgfilename = imgfilerealpath.substring(imgfilerealpath.lastIndexOf("\\")+1);
			String imgsql = "INSERT INTO MailResourceFile (mailid,filename,attachfile,filetype,filerealpath,iszip,isencrypt,isfileattrachment,fileContentId,isEncoded,filesize,signid) VALUES (null,'"+imgfilename+"',null,'image/gif','"+imgfilerealpath+"','0','0','0','img"+list.get(j)+"@www.weaver.com.cn','0',0,'"+id+"')";
			rs.executeSql(imgsql);
		}catch(NullPointerException nulle){
		}
	}
}
}
else if(operation.equals("default")) {
	if(defaultSignId.equals("")) {
		sql = "update MailSign set isActive=0 where isActive=1 and userId="+ userId;
		rs.executeSql(sql);
	} else {
		sql = "update MailSign set isActive=0 where id in (select id from MailSign where isActive=1 and userId="+ userId +")";
		if(rs.executeSql(sql)) {
			sql = "update MailSign set isActive=1 where id="+ defaultSignId +"and userId=" + userId;
			rs.executeSql(sql);
		}
	}
}
else
{
	sql = "delete from MailSign where id="+id;
	rs.executeSql(sql);
}
if(showTop.equals("")) {
	response.sendRedirect("MailSign.jsp?userid="+userId+"");
} else if(showTop.equals("show800")) {
	response.sendRedirect("MailSign.jsp?showTop=show800&userid="+userId+"");
}
%>