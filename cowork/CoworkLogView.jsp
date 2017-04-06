<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
    String id = (String)request.getParameter("id");
    int currentpage =Util.getIntValue((String)request.getParameter("currentpage"),1);
    String from = Util.null2String(request.getParameter("from"));
    int pagesize = 20;//讨论交流每页显示条数
    int totalsize =0;
    
	String selSql = "select count(*) as total from cowork_log where coworkid="+id;
	RecordSet.executeSql(selSql);
	
	while(RecordSet.next()){
		totalsize=RecordSet.getInt("total");
	}
	
    int totalpage = totalsize / pagesize;
    if(totalsize - totalpage * pagesize > 0) totalpage = totalpage + 1;
	int pageSet=totalsize>(currentpage*pagesize)?pagesize:(pagesize-(currentpage*pagesize-totalsize));
	
	boolean isoracle = (RecordSet.getDBType()).equals("oracle");
	
	if(isoracle){
		selSql = "select * from cowork_log where coworkid="+id+" order by modifydate desc,modifytime desc";
		selSql = "select t1.*,rownum rn from (" + selSql + ") t1 where rownum <= " + (currentpage*pagesize);
		selSql = "select t2.* from (" + selSql + ") t2 where rn > " + (currentpage*pagesize - pagesize);
	}else{
	    selSql = "select top " + currentpage*pagesize +" * from cowork_log where coworkid="+id+" order by modifydate desc,modifytime desc,type desc";
	    selSql = "select top " + pageSet+" t1.* from (" + selSql + ") t1 order by t1.modifydate asc,t1.modifytime asc,t1.type asc";
	    selSql = "select top " + pageSet+" t2.* from (" + selSql + ") t2 order by t2.modifydate desc,t2.modifytime desc,t2.type desc";
	}
	RecordSet.executeSql(selSql);
%>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
<script type="text/javascript" src="/js/jquery/jquery.js"></script>
<script type="text/javascript">
   $(document).ready(function(){
      //左侧下拉框处理
      if(jQuery(window.parent.document).find("#ifmCoworkItemContent")[0]!=undefined){
		    jQuery(document.body).bind("mouseup",function(){
			   parent.jQuery("html").trigger("mouseup.jsp");	
		    });
		    jQuery(document.body).bind("click",function(){
				jQuery(parent.document.body).trigger("click");		
		    });
	   } 
   });
   
   function goBack(){
     window.location.href="/cowork/ViewCoWork.jsp?from=<%=from%>&id=<%=id%>"
   }
   
   var currentpage=<%=currentpage%>;
   var totalpage=<%=totalpage%>;
   
   //首页
   function toFirstPage(){
         if(currentpage==1)
            return ;
 		 window.location.href="/cowork/CoworkLogView.jsp?from=<%=from%>&id=<%=id%>&currentpage=1" 
 	}
   
    //上一页
   function toPrePage(){
 		if(currentpage == 1) 
 			return;
 		window.location.href="/cowork/CoworkLogView.jsp?from=<%=from%>&id=<%=id%>&currentpage=<%=currentpage-1%>" 
 	}
   
   //下一页
 	function toNextPage(){
 		if(currentpage ==totalpage)
 			return;
        window.location.href="/cowork/CoworkLogView.jsp?from=<%=from%>&id=<%=id%>&currentpage=<%=currentpage+1%>" 		
 	}

   //尾页
    function toLastPage(){
         if(currentpage ==totalpage)
 			return;
         window.location.href="/cowork/CoworkLogView.jsp?from=<%=from%>&id=<%=id%>&currentpage=<%=totalpage%>"
 	}

  //转到
 	function toGoPage(topage){
 	
 	    var topagenum=$("#"+topage);
 		var topage =topagenum.val();
 		
 		if(topage <0 || topage!=parseInt(topage) ) {
              alert("<%=SystemEnv.getHtmlLabelName(25167,user.getLanguage())%>");  //请输入整数
              topagenum.val(""); //置空
              topagenum.focus();
 		     return ;
 		 }
 		if(topage ==currentpage) return; //相等时返回
 		
 		if(topage>totalpage) //大于最大页数
 		    topage=totalpage;
 		
 		if(topage==0)       //小于最小页数 
 		    topage=1;
 		
 		window.location.href="/cowork/CoworkLogView.jsp?from=<%=from%>&id=<%=id%>&currentpage="+topage;
 	}


</script>
<style>
  .activepage{cursor:hand;TEXT-DECORATION:none;}
  .normalpage{TEXT-DECORATION:none;color:black}
</style>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width="100%" cellpadding="0" cellspacing="0" style="margin-top: 5px">
	<!-- 日志内容 -->
	<tr>
	     <td id="discusses">
	          <table ID=BrowseTable class=ListStyle cellspacing=1>
					<TBODY>
					<COLGROUP>
						<COL width="45%">
						<COL width="15%">
						<COL width="15%">
						<COL width="25%">
					  <tr align="center" class="Header">
					     <th><%=SystemEnv.getHtmlLabelName(277,user.getLanguage()) %></th><!-- 时间 -->
					     <th><%=SystemEnv.getHtmlLabelName(99,user.getLanguage()) %></th><!-- 操作者 -->
					     <th><%=SystemEnv.getHtmlLabelName(63,user.getLanguage()) %></th><!-- 类型 -->
					     <th>IP<%=SystemEnv.getHtmlLabelName(110,user.getLanguage()) %></th><!-- IP地址 -->
					  </tr>
					<%
					boolean isLight = false;
					while(RecordSet.next()){%>
					  <tr CLASS=<%if(isLight){%>"DataDark"<%}else{%>"DataLight"<%}%>>
					    <td><%=RecordSet.getString("modifydate")+" "+RecordSet.getString("modifytime")%></td>
					    <td><%=ResourceComInfo.getResourcename(RecordSet.getString("modifier"))%></td>
					    <!-- 1 新建 2 查看 3 编辑 -->
					    <td><%if(RecordSet.getInt("type")==1)out.print(SystemEnv.getHtmlLabelName(82,user.getLanguage()));else if(RecordSet.getInt("type")==2)out.print(SystemEnv.getHtmlLabelName(367,user.getLanguage()));else if(RecordSet.getInt("type")==3)out.print(SystemEnv.getHtmlLabelName(93,user.getLanguage()));%></td>
					    <td><%=RecordSet.getString("clientip")%></td>
					  </tr>
					<%
					isLight = !isLight;
					}%>
					<TBODY>
			 </table>
	     </td>
	</tr>
	<!-- 日志内容 -->
	
	<!-- 分页 -->
	<tr style="<%if(totalsize==0){ %>display:none<%}%>;background:#E6E6E6">
	     <td align="right">
		     <%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())%><span class="totalsize"><%=totalsize%></span><%=SystemEnv.getHtmlLabelName(24683,user.getLanguage())%> <!-- 共62条记录 -->
	         <%=SystemEnv.getHtmlLabelName(265,user.getLanguage())%><%=pagesize%><%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%>    <!-- 每页10条 -->
	         <%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())%><span class="totalpage"><%=totalpage%></span><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%> <!-- 共7页 -->
	         <%=SystemEnv.getHtmlLabelName(524,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%><span class="currentpage"><%=currentpage%></span><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%><!-- 当前第1页 --> 
	          <!-- 首页 上一页 下一页 尾页 --> 
	         <%if(totalpage>1&&currentpage!=1){%> 
			   <A href="javascript:toFirstPage()"><%=SystemEnv.getHtmlLabelName(18363,user.getLanguage())%></A>
			 <%}else{%>
			    <%=SystemEnv.getHtmlLabelName(18363,user.getLanguage())%>
			 <%} %>
			 <%if(totalpage>1&&currentpage!=1){%>
			 <A  href="javascript:toPrePage()" ><%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></A>
			 <%}else{%>
			    <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%>
			 <%}%>
			 <%if(totalpage>1&&currentpage!=totalpage){%>
			 <A  href="javascript:toNextPage()"><%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></A>
			 <%}else{ %>
			     <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%>
			 <%}%>
			 <%if(totalpage>1&&currentpage!=totalpage){%>
			 <A  href="javascript:toLastPage()"><%=SystemEnv.getHtmlLabelName(18362,user.getLanguage())%></A>
	         <%}else{ %>
	              <%=SystemEnv.getHtmlLabelName(18362,user.getLanguage())%>
	         <%} %>
	         <input type="button" onclick="toGoPage('topagenum2')" value="<%=SystemEnv.getHtmlLabelName(23162,user.getLanguage())%>" style="cursor: pointer;height: 18px;font-size: 12px"><%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%><input type="text" size="2" style="height: 18px;text-align: right" name='topagenum2' id="topagenum2" class="text" value="<%=currentpage %>"><%=SystemEnv.getHtmlLabelName(23161,user.getLanguage())%>
	     </td>
	</tr>
	<!-- 分页 -->
</table>
