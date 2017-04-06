<%@ page import="weaver.general.Util,weaver.file.*,java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="weaver.general.StaticObj"%>
<%@page import="weaver.join.hrm.in.ImportLog"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%
	if (!HrmUserVarify.checkUserRight("HrmDefaultScheduleEdit:Edit",
			user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
   StaticObj staticObj=StaticObj.getInstance();

   //importStatus 导入状态 在hrmImportProcess.jsp中设置
   String importStatus=(String)staticObj.getObject("importStatus");
   
   String keyField=(String)staticObj.getObject("keyField");
   
   //设置读取下标，避免重复读取
   int index=Integer.parseInt(request.getParameter("index"));
   if("importing".equals(importStatus)||"over".equals(importStatus)){
	   List  resultList=(List)staticObj.getObject("resultList");
       if(resultList!=null){
   %>
      <%
         ImportLog log;
         for(;index<resultList.size();index++){
        	 log=(ImportLog)resultList.get(index);
      %>
       		<TABLE class=ListStyle cellspacing=1 border="0" cellspacing="0" width="100%">
	       		<TR <%if(index%2==0) out.print("class=datalight"); else out.print("class=datadark");%>>
			        <TD width="10%">
			        <%               //只需要关键字段列
			                         if(keyField.equals("workcode"))
			                        	 out.print(log.getWorkCode());
			                         else if(keyField.equals("loginid"))
			                        	 out.print(log.getLoginid());
			                         else if(keyField.equals("lastname"))
			                        	 out.print(log.getLastname()); 
			        %>
			        </TD>
			        <TD width="55%"><%=log.getDepartment()%></TD>
					<TD width="10%"><%=log.getOperation()%></TD>
					<TD width="25%" <%if(log.getStatus().equals("失败")) out.print("style='color: red'");else out.print("style='color: blue'");%>>
					<%=log.getStatus()%><br>
					<%if(!log.getReason().equals("")) out.print(log.getReason());%>
					</TD>
               </TR>
			 </table>
      <%
      }
         if("over".equals(importStatus)){
	 	     String logFile=(String)staticObj.getObject("logFile");
			 out.println("<script>callback('ok','"+logFile+"');</script>"); 
			 staticObj.removeObject("importFlag");
			 staticObj.removeObject("resultList");
			 staticObj.removeObject("logFile");
	   }
      out.println("<script>changeIndex("+index+");</script>"); 
       }
   }
   
   else if("error".equals(importStatus)){
	   List errorInfo=(List)staticObj.getObject("errorInfo");
       if(errorInfo!=null&&!errorInfo.isEmpty()){
      %>
  <!-- 错误提示 -->
  <table class=viewform >
    <tbody> 
    <TR style="height:1px;"><TD class=Line1 colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(24647,user.getLanguage())%></td>
      <td style="color: red">
      <%
      //输出错误提示 
        for(int i=0;i<errorInfo.size();i++){
        	String msg=(String)errorInfo.get(i);
        	out.print(msg+"<br>");
        }
      %>
      </td>
    </tr> 
    <TR style="height:1px;"><TD class=Line1 colSpan=2></TD></TR> 
    </tbody> 
  </table>
  <%
     out.println("<script>callback('error')</script>"); 
     staticObj.removeObject("errorInfo");
    }
   } 
  %>
