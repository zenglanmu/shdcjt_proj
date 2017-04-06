<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

if (!HrmUserVarify.checkUserRight("blog:templateSetting", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdSystem.gif";
String titlename =SystemEnv.getHtmlLabelName(28171,user.getLanguage()); //微博应用设置
String needfav ="1";
String needhelp ="";

int userid=user.getUID();

String operation=Util.null2String(request.getParameter("operation"));

String sqlstr="select * from blog_template order by id desc";
RecordSet.execute(sqlstr);

%>
<html>
  <head>
    <link href="/css/Weaver.css" type=text/css rel=stylesheet>
    <script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog.js"></script>
    <script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag.js"></script>
  </head>
  <body>
 <%@ include file="/systeminfo/TopTitle.jsp" %>
 <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
 <% 
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(28051,user.getLanguage())+",javascript:addTemp(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
 %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
  <form action="BlogSettingOperation.jsp" method="post"  id="mainform" enctype="multipart/form-data">
    <input type="hidden" value="editApp" name="operation"/> 
	<TABLE class=ListStyle cellspacing=1 style="width: 98%" align="center">
		<TR class=Header>
			<TH width="50%"><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></TH>
			<th width="15%"><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></th>
			<th width="15%"><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></th>
			<th width="20%"><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></th>
		</TR>
		<%while(RecordSet.next()){ 
		  String tempid=RecordSet.getString("id");
		  String tempName=RecordSet.getString("tempName");
		  String isUsed=RecordSet.getString("isUsed");
		%>
		   <tr>
		      <td><a href="addBlogTemplate.jsp?tempid=<%=tempid%>"><%=tempName%></a></td>
		      <td><input type="checkbox" <%if(isUsed.equals("1")){%> checked="checked"<%}%> disabled="disabled"></td>
		      <td><a href="javascript:void(0)" onclick="preViw(<%=tempid%>)">预览</a></td>
		      <td><a href="addBlogTemplate.jsp?tempid=<%=tempid%>">编辑</a>&nbsp;&nbsp;<a href="blogTemplateShare.jsp?tempid=<%=tempid%>">共享设置</a>&nbsp;&nbsp;<a href="javascript:void(0)" onclick="delTemp(this,<%=tempid%>)">删除</a></td>
		   </tr>
		<%} %>
	</TABLE>
	</form>  
  </body>
 <script type="text/javascript">
  function doSave(){
     jQuery("#mainform").submit();
  }
  
  function doEdit(){
    window.location.href="BlogAppSetting.jsp?operation=editApp";
  }
  
  function addTemp(){
    window.location.href="addBlogTemplate.jsp?operation=editApp";
  }
  
  function delTemp(obj,tempid){
    if(window.confirm("<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage())%>?")){  //确认删除条件
         jQuery.post("BlogSettingOperation.jsp?operation=deleteTemp&tempid="+tempid,{},function(){
            jQuery(obj).parents("tr:first").remove(); 
         });
    }
  }
  
  function preViw(tempid){
    var diag = new Dialog();
    diag.Modal = false;
    diag.Drag=true;
	diag.Width = 550;
	diag.Height = 450;
	diag.ShowButtonRow=false;
	diag.Title = "模版预览";

	diag.URL = "blogTemplateView.jsp?tempid="+tempid;
    diag.show();
  }
  
  
 </script>
</html>
