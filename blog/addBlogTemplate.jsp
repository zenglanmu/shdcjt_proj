<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

if (!HrmUserVarify.checkUserRight("blog:templateSetting", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdSystem.gif";
String titlename =SystemEnv.getHtmlLabelName(28051,user.getLanguage()); //新建模版
String needfav ="1";
String needhelp ="";

int userid=user.getUID();

String operation=Util.null2String(request.getParameter("operation"));
int tempid=Util.getIntValue(request.getParameter("tempid"),0);

String tempName="";
String isUsed="1";
String tempContent="";

String sqlstr="select * from blog_template where id="+tempid;
RecordSet.execute(sqlstr);

if(RecordSet.next()){
	tempName=RecordSet.getString("tempName");
	isUsed=RecordSet.getString("isUsed");
	tempContent=RecordSet.getString("tempContent");
}


%>
<html>
  <head>
    <link href="/css/Weaver.css" type=text/css rel=stylesheet>
    <script type="text/javascript">var languageid=<%=user.getLanguage()%>;</script>
	<script type="text/javascript" src="/kindeditor/kindeditor.js"></script>
	<script type="text/javascript" src="/kindeditor/kindeditor-Lang.js"></script>
	<script type="text/javascript" src="/js/weaver.js"></script>
  </head>
  <body>
 <%@ include file="/systeminfo/TopTitle.jsp" %>
 <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
 <% 
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doBack(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
 %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
  <form action="BlogSettingOperation.jsp" method="post"  id="mainform" enctype="multipart/form-data">
    <input type="hidden" value="addTemp" name="operation"/> 
    <input type="hidden" value="<%=tempid%>" name="tempid"/>
    
    <table class=viewform style="width: 98%" align="center">
  <COL width="20%">
  <COL width="80%">
  <TR>
    <TD height="20px" colspan=2></TD>
  </TR> 
  <tr>
      <td><%=SystemEnv.getHtmlLabelName(28050,user.getLanguage())%></td>
      <td class=Field>
          <input type="text" style="width: 60%"  maxlength="50" id="tempName" value="<%=tempName%>" name="tempName" onChange="checkinput('tempName','tempNamespan')" />
          <span id="tempNamespan">
            <%if(tempName.equals("")){%>
               <img src="/images/BacoError.gif" align=absmiddle>
            <%} %>
          </span>
      </td>
  </tr>
  <TR style="height: 1px;"><TD class=Line colspan=2></TD></TR> 
  <tr>
      <td><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></td>
      <td class=Field>
          <input type="checkbox" name="isUsed" <%if(isUsed.equals("1")){%>checked="checked"<%}%> value="1" />
      </td>
  </tr>
  <TR style="height: 1px;"><TD class=Line colspan=2></TD></TR>
  <tr>
      <td><%=SystemEnv.getHtmlLabelName(28053,user.getLanguage())%></td>
      <td class=Field>
         <textarea style="height: 150px;width: 100%" name="tempContent" id="tempContent"><%=tempContent%></textarea>
      </td>
  </tr>
  <TR style="height: 1px;"><TD class=Line colspan=2></TD></TR>
</table>
	</form>  
  </body>
 <script type="text/javascript">
  jQuery(document).ready(function(){
       highEditor("tempContent",240);
  });
  function doSave(){
   if(check_form(mainform,"tempName"))
     jQuery("#mainform").submit();
  }
  
  function doBack(){
    window.location.href="BlogTemplateSetting.jsp";
  }
  
   /*高级编辑器*/
	function highEditor(remarkid,height){
	    height=!height||height<150?150:height;
	    if(jQuery("#"+remarkid).is(":visible")){
			
			var  items=[
							'source','justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist', 'insertunorderedlist', 
							'title', 'fontname', 'fontsize',  'textcolor', 'bold','italic',  'strikethrough', 'image', 'advtable','remote_image'
					   ];
				 
		    KE.init({
						id : remarkid,
						height :height+'px',
						width:'auto',
						resizeMode:1,
						imageUploadJson : '/kindeditor/jsp/upload_json.jsp',
					    allowFileManager : false,
		                newlineTag:'br',
		                items : items,
					    afterCreate : function(id) {
							KE.util.focus(id);
					    }
		   });
		   KE.create(remarkid);
		}
	}
  
 </script>
</html>
