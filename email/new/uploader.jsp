<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="utf-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.general.Util"%>
<%
   FileUpload fu = new FileUpload(request,"utf-8",false);
  
   String docid=fu.uploadFilesToEmail("Filedata");
   String docname = fu.getFileName();
   JSONObject obj = new JSONObject();
   obj.put("error", new Integer(0));
   obj.put("id", docid);
   obj.put("name", docname);
   
   response.setContentType("text/html;charset=GBK");
   PrintWriter outer = response.getWriter();
   outer.println(docid);
%>
