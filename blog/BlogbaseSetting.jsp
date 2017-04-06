<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<%

if (!HrmUserVarify.checkUserRight("blog:baseSetting", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String imagefilename = "/images/hdSystem.gif";
String titlename =SystemEnv.getHtmlLabelName(26760,user.getLanguage()); //微博基本设置
String needfav ="1";
String needhelp ="";

int userid=0;
userid=user.getUID();

String operation=Util.null2String(request.getParameter("operation"));

String allowRequest="";   //允许关注申请
String enableDate="";     //微博启用时间
String isSingRemind="";   //签到提交提醒
String isManagerScore=""; //启用上级评分
String attachmentDir="";  //微博附件上传目录
String pathcategory = "";
String isAttachment="0";

String sqlstr="select * from blog_sysSetting";
RecordSet.execute(sqlstr);
RecordSet.next();

allowRequest=RecordSet.getString("allowRequest");
enableDate=RecordSet.getString("enableDate");
isSingRemind=RecordSet.getString("isSingRemind");
isManagerScore=RecordSet.getString("isManagerScore");
attachmentDir=RecordSet.getString("attachmentDir");
if(attachmentDir!=null&&!attachmentDir.equals("")){
    String attachmentDirs[]=Util.TokenizerString2(attachmentDir,"|");
    pathcategory = "/"+MainCategoryComInfo.getMainCategoryname(attachmentDirs[0])+
                  "/"+SubCategoryComInfo.getSubCategoryname(attachmentDirs[1])+
                  "/"+SecCategoryComInfo.getSecCategoryname(attachmentDirs[2]);
}
	
RecordSet.execute("select isActive from blog_app WHERE appType='attachment'");
if(RecordSet.next())
	isAttachment=RecordSet.getString("isActive");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <link href="/css/Weaver.css" type=text/css rel=stylesheet>
    <SCRIPT language="javascript"  defer="defer" src="/js/datetime.js"></script>
	<SCRIPT language="javascript"  src="/js/selectDateTime.js"></script>
	<SCRIPT language="javascript" defer="defer" src='/js/JSDateTime/WdatePicker.js?rnd="+Math.random()+"'></script>
  </head>
  <body>
 <%@ include file="/systeminfo/TopTitle.jsp" %>
 <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
 <% 
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
 %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
  <form action="BlogSettingOperation.jsp" method="post"  id="mainform" enctype="multipart/form-data">
    <input type="hidden" value="editBaseSetting" name="operation"/> 
    <TABLE class=ViewForm style="width: 98%" align="center">
		<COLGROUP>
		<COL width="30%">
		<COL width="70%">
		<TBODY>
			<TR class=Title>
				<TH colSpan=2><%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%></TH> <!-- 基本设置 -->
			</TR>
			
			<TR class=Spacing style="height: 1px;">
			<TD class=Line1 colSpan=2></TD>
			</TR>
		
			<tr>
			  <td><%=SystemEnv.getHtmlLabelName(115,user.getLanguage())+SystemEnv.getHtmlLabelName(26941,user.getLanguage())%></td> <!-- 允许申请关注 -->
			  <td class=Field>
				<input type="checkbox"  <%=allowRequest.equals("1")?"checked=checked":""%> name="allowRequest"  value="1" />
			  </td>
			</tr>
			<TR style="height: 1px;"><TD class=Line colspan=2></TD></TR>
			<tr>
			  <td><%=SystemEnv.getHtmlLabelName(26467,user.getLanguage())+SystemEnv.getHtmlLabelName(1046,user.getLanguage())%></td> <!-- 微博启用时间 -->
			  <td class=Field>
			       <BUTTON type="button" class=calendar  onclick="onShowDate(enableDatespan,enableDate)"></BUTTON> 
			       <input type="hidden"  name="enableDate" id="enableDate" value=<%=enableDate%>>
		           <SPAN id=enableDatespan style="font-weight:normal !important;color:#000000 !important;"><%=enableDate%></SPAN>
			  </td>
			</tr>
			<TR style="height: 1px;"><TD class=Line colspan=2></TD></TR>
			
			<tr>
			  <td><%=SystemEnv.getHtmlLabelName(27033,user.getLanguage())%></td> <!-- 启用签到提醒 -->
			  <td class=Field>
			      <input type="checkbox"  <%=isSingRemind.equals("1")?"checked=checked":""%> name="isSingRemind"  value="1" />
			  </td>
			</tr>
			<TR style="height: 1px;"><TD class=Line colspan=2></TD></TR>
			
			<tr>
			  <td>直接上级评分</td> <!-- 启用上级评分 -->
			  <td class=Field>
			      <input type="checkbox"  <%=isManagerScore.equals("1")?"checked=checked":""%> name="isManagerScore"  value="1" />
			  </td>
			</tr>
			<TR style="height: 1px;"><TD class=Line colspan=2></TD></TR>
			
			<tr>
			  <td>附件上传目录</td> <!-- 启用上级评分 -->
			  <td class=Field>
			      <BUTTON type="button" class=Browser onClick="onShowCatalog()" name=selectCategory></BUTTON>
				  <span id=mypathspan>
				    	<%if(pathcategory.equals("")&&isAttachment.equals("1")){%><IMG src='/images/BacoError.gif' align=absMiddle>
				    	<%}else{%><%=pathcategory%><%}%>
				  </span>
				  <INPUT type=hidden id='attachmentDir' name='attachmentDir' value="<%=attachmentDir%>">
			  </td>
			</tr>
			<TR style="height: 1px;"><TD class=Line colspan=2></TD></TR>
			
		</TBODY>
	</TABLE>
	</form>  
  </body>
 <script type="text/javascript">
  function doSave(){
     if(jQuery("#enableDate").val()==""){
       alert("<%=SystemEnv.getHtmlLabelName(23073,user.getLanguage())+SystemEnv.getHtmlLabelName(26467,user.getLanguage())+SystemEnv.getHtmlLabelName(1046,user.getLanguage())%>");
       return ;
     }  
     
     if("<%=isAttachment%>"=="1"&&jQuery("#attachmentDir").val()==""){
       alert("请选择附件上传目录！");
       return ;
     };
     
     jQuery("#mainform").submit();
  }
  
  function onShowCatalog() {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp");
    if (result != null) {
        if (wuiUtil.getJsonValueByIndex(result,0)> 0){
           jQuery("#mypathspan").html(wuiUtil.getJsonValueByIndex(result,2));
          //result[2] 路径字符串   result[3] maincategory result[4] subcategory  result[1] seccategory
          jQuery("#attachmentDir").val(wuiUtil.getJsonValueByIndex(result,3)+"|"+wuiUtil.getJsonValueByIndex(result,4)+"|"+wuiUtil.getJsonValueByIndex(result,1));
        }else{
        if("<%=isAttachment%>"=="1")
          jQuery("#mypathspan").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
        else
          jQuery("#mypathspan").html("");  
          jQuery("#attachmentDir").val("");
        }
    }
   }
  
 </script>
</html>
