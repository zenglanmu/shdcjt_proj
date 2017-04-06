<%@ page import="weaver.general.Util,weaver.file.*,java.util.*" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="java.io.File"%>
<%@page import="java.io.BufferedInputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%
	if (!HrmUserVarify.checkUserRight("HrmDefaultScheduleEdit:Edit",
			user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%!
//读取的日志文件根据修改时间进行排序
class CompratorByLastModified implements Comparator  
{   
 public int compare(Object f1, Object f2) {
  File file1=(File)f1; 
  File file2=(File)f2; 
  long diff = file1.lastModified()-file2.lastModified();  
      if(diff<0)   
        return 1;   
      else if(diff==0)   
        return 0;   
      else  
        return 0;   
      }   
}
%>
<%
      String option=request.getParameter("option");
      
      if("downLoad".equals(option)){
    	  
    	  String filePath=request.getParameter("path");
    	  File file = new File(filePath); 
    	  if(file.exists()){ 
    	  try { 
    	  
    	  String fileName=filePath.substring(filePath.lastIndexOf("/")+1);	  
    	  BufferedReader bis=new BufferedReader(new FileReader(filePath));
    	  fileName =URLEncoder.encode(fileName, "UTF-8");// 处理中文文件名的问题 
    	  response.reset(); 
    	  response.setContentType("application/x-msdownload");// 不同类型的文件对应不同的MIME类型 
    	  response.setHeader("Content-Disposition", 
    	  "attachment; filename=" + fileName); 
    	  OutputStream os = response.getOutputStream();
    	  String str="";
    	  while ((str=bis.readLine())!=null){
        	  os.write((str+"\r\n").getBytes()); 
        	  } 
    	  bis.close(); 
    	  os.flush();
    	  os.close(); 
    	  } catch (Exception e) { 
    	  e.printStackTrace(); 
    	  } 
    	  } 
      }else if("delete".equals(option)){
    	  String filePath=request.getParameter("path");
    	  File file = new File(filePath);
    	  out.print(file.delete());
      }else{

      String filePath=request.getRealPath("/").replace("\\","/")+"/log/hrmImportLog";
      File logFile=new File(filePath);
       if (!logFile.exists()) {
       logFile.mkdir();
      }
      File logList[]=logFile.listFiles();
      
      Arrays.sort(logList,new CompratorByLastModified());
%>
  

      <%
          SimpleDateFormat  dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
          
          for(int i=0;i<logList.length;i++){
      %>
	        <TR <%if(i%2==0) out.print("class=datalight"); else out.print("class=datadark");%>>
	        <td><%=dateFormat.format(new Date(logList[i].lastModified()))%></td>
	        <td><%=logList[i].getName()%></td>
	        <td>
	            <a href="#" onclick="downLoadLog('<%=filePath+"/"+logList[i].getName()%>')"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%></a>
	        </td>
	        <td>
	            <a href="#" onclick="deleteLog('<%=filePath+"/"+logList[i].getName()%>',this)"><%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%></a>
	        </td>
	        </TR>
        <%
          }
        %>
    <script type="text/javascript">callback('log');</script>
    <%} %>