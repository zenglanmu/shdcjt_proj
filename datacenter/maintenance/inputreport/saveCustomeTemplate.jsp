<%@ page import="weaver.general.Util,java.io.File,org.apache.commons.io.FileUtils" %>
<%@ page import="weaver.file.FileUploadToPath,weaver.general.GCONST" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%

FileUploadToPath fu = new FileUploadToPath(request);
String excelName = fu.uploadFiles("customTemplate") ;
String fname = Util.null2String(fu.getParameter("fileName"));

String saveFileName = GCONST.getRootPath()+"datacenter" + File.separatorChar + "inputexcellfile" + File.separatorChar + fname+".xls";
File srcFile=new File(excelName);
File destFile=new File(saveFileName);
if(destFile.exists()) FileUtils.forceDelete(destFile);
FileUtils.copyFile(srcFile,destFile);
FileUtils.forceDelete(srcFile);
out.print("上传成功:"+excelName);
%>