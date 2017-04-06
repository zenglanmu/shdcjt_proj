<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="org.apache.commons.lang.RandomStringUtils"%>
<%@ page import="org.apache.commons.lang.time.DateFormatUtils"%>
<%
String uploadPath =GCONST.getRootPath()+"/rte/uploads/";
String tempPath = uploadPath+"Temp";

//自动创建目录
if(!new File(uploadPath).isDirectory())	new File(uploadPath).mkdirs();
if(!new File(tempPath).isDirectory())		new File(tempPath).mkdirs();

DiskFileUpload fu = new DiskFileUpload();
fu.setSizeMax(4194304);				//4MB
fu.setSizeThreshold(4096);			//缓冲区大小4kb
fu.setRepositoryPath(tempPath);

List fileItems = fu.parseRequest(request);
Iterator i = fileItems.iterator();

while(i.hasNext()) {
	FileItem item = (FileItem)i.next();
	
	if(!item.isFormField()){
		String name = item.getName().replace('\\','/');		
		if(Util.isExcuteFile(name)) continue;
		File f = new File(name); 
		String newName=RandomStringUtils.randomAlphabetic(8)+DateFormatUtils.format(new Date(),"ss")+f.getName();
		File savedFile = new File(uploadPath+File.separatorChar ,newName);
		item.write(savedFile);		
		out.println("{'error':'','file':'/rte/uploads/"+newName+"','tmpfile':'/rte/uploads/Temp/"+newName+"','size':"+item.getSize()+"}");		
	}
}


%>