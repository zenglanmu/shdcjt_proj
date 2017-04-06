<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="weaver.blog.BlogDao"%>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
if (!HrmUserVarify.checkUserRight("blog:specifiedShare", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdSystem.gif";
String titlename =SystemEnv.getHtmlLabelName(28205,user.getLanguage()); 
String needfav ="1";
String needhelp ="";

int userid=user.getUID();

String operation=Util.null2String(request.getParameter("operation"));

String sqlstr="SELECT * FROM (SELECT min(id) AS minid,specifiedid FROM blog_specifiedShare  GROUP BY specifiedid)  t ORDER BY t.minid";
RecordSet.execute(sqlstr);
BlogDao blogDao=new BlogDao();
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
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(28205,user.getLanguage())+",javascript:addSpecifiedShare(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
 %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
  <form action="BlogSettingOperation.jsp" method="post"  id="mainform" enctype="multipart/form-data">
    <input type="hidden" value="editApp" name="operation"/> 
	<TABLE class=ListStyle cellspacing=1 style="width: 98%" align="center">
		<TR class=Header>
			<TH width="15%"><%=SystemEnv.getHtmlLabelName(28209,user.getLanguage())%></TH> <!-- 指定共享人 -->
			<th width="50%"><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())+SystemEnv.getHtmlLabelName(345,user.getLanguage())%></th><!-- 条件内容 -->
			<th width="20%"><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></th>
		</TR>
		<%while(RecordSet.next()){ 
		  String specifiedid=RecordSet.getString("specifiedid");
		  String specifiedName=ResourceComInfo.getLastname(specifiedid);
		%>
		   <tr>
		      <td><a href="addBlogTemplate.jsp?specifiedid=<%=specifiedid%>"><%=specifiedName%></a></td>
		      <td>
		      <table class="viewform">
		      <%
				List alist=blogDao.getSpecifiedShareList(specifiedid); 
				for(int i=0;i<alist.size();i++){
				  HashMap hm=(HashMap)alist.get(i);
				  String typeName=SystemEnv.getHtmlLabelName(Util.getIntValue((String)hm.get("typeName")),user.getLanguage());
				  String contentName=(String)hm.get("contentName");
				  String seclevel=(String)hm.get("seclevel");
				  String shareid=(String)hm.get("shareid");
				  
				  String type=(String)hm.get("type");
			   %>
			   <tr style="height: 24px !important;">
			      <td style="padding: 5px;width:10%"><%=typeName %></td>
			      <td class=Field style="padding: 5px;width:90%">
					<span class="showrelatedsharename" id="showrelatedsharename_<%=hm.get("shareid")%>" name="showrelatedsharename">
						<%=contentName %>
					</span>
			      </td>
			   </tr>
			   <%if(i!=alist.size()-1){%>
			   <TR style="height: 1px;"><TD class=Line colspan=2></TD></TR>	
			   <%}%>
		      <% }%>
		      </table>
		      </td>
		      <td>
		         <a href="addSpecifiedShare.jsp?specifiedid=<%=specifiedid%>"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%><!-- 编辑 --></a>&nbsp;&nbsp;
		         <a href="javascript:void(0)" onclick="delSpecified(this,<%=specifiedid%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a><!-- 删除 -->
		       </td>
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
  
  function addSpecifiedShare(){
    window.location.href="addSpecifiedShare.jsp";
  }
  
  function delSpecified(obj,specifiedid){
    if(window.confirm("<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage())%>?")){  //确认删除条件
         jQuery.post("/blog/BlogSettingOperation.jsp?operation=deleteSpecified&specifiedid="+specifiedid,{},function(){
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
