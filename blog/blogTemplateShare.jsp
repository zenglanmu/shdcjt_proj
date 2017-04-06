<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="weaver.blog.BlogDao"%>
<%@ include file="/systeminfo/init.jsp" %>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.blog.BlogShareManager"%>
<html>
<head>
<LINK href="/css/Weaver.css" type='text/css' rel='STYLESHEET'>
<LINK href="css/blog.css" type=text/css rel=STYLESHEET>
</head>
<body>
<%
String imagefilename = "/images/hdSystem.gif";
String titlename =SystemEnv.getHtmlLabelName(2112,user.getLanguage()); //微博应用设置
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<% 
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} ";
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doBack(),_self} ";
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%
 String tempid=""+Util.getIntValue(request.getParameter("tempid"),0);
 BlogDao blogDao=new BlogDao();
 String sql="select * from blog_template where id="+tempid;
 RecordSet recordSet=new RecordSet();
 recordSet.execute(sql);
 String tempName="";
 if(recordSet.next())
	 tempName=recordSet.getString("tempName");
%>
<form action="BlogSettingOperation.jsp?operation=addTempShare" method="post"  id="mainform" enctype="multipart/form-data">
<input type="hidden" name="tempid" value="<%=tempid%>">
<TABLE class=ViewForm style="width: 98%;margin-top: 10px;" align="center">
		<COLGROUP>
		<COL width="30%">
		<COL width="70%">
			<TR class=Title>
				<TH colSpan=2><%=tempName%></TH> <!-- 模版名称 -->
			</TR>
			<TR class=Spacing style="height: 1px;">
			     <TD class=Line1 colSpan=2></TD>
			</TR>
</TABLE>			
<table id="shareList" class=ListStyle cellspacing=1 style="font-size: 9pt;margin-top:5px;;margin-bottom: 20px;width: 98%" align="center">
	<COLGROUP>
	<COL width="20%">
	<COL width="50%">
	<COL width="15%">
	<COL width="15%">
	<tbody>
		<tr align="center" class="Header">
			<th><%=SystemEnv.getHtmlLabelName(23243,user.getLanguage())%></th><!-- 条件类型 -->
			<th><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())+SystemEnv.getHtmlLabelName(345,user.getLanguage())%></th><!-- 条件内容 --> 
			<th align="center"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></th><!-- 安全级别 --> 
			<th align="center">
			  <a class="btnEcology" href="javascript:void(0)" onclick="addShare()" style="margin-right: 8px">
		       <div class="left" style="width:60px;font-weight: normal;"><span ><%=SystemEnv.getHtmlLabelName(15582,user.getLanguage())%></span></div><!-- 添加条件 --> 
		       <div class="right"> &nbsp;</div>
	         </a>
			</th>
		</tr>
	   <%
		List alist=blogDao.getTempShareList(tempid);
		for(int i=0;i<alist.size();i++){
		  HashMap hm=(HashMap)alist.get(i);
		  String typeName=SystemEnv.getHtmlLabelName(Util.getIntValue((String)hm.get("typeName")),user.getLanguage());
		  String contentName=(String)hm.get("contentName");
		  String seclevel=(String)hm.get("seclevel");
		  String shareid=(String)hm.get("shareid");
		  
		  String type=(String)hm.get("type");
		  String clickMethod="";
		  if("1".equals(type)||"7".equals(type))
			  clickMethod="onShowResource('relatedshareid_"+shareid+"','showrelatedsharename_"+shareid+"')";
		  else if("2".equals(type))
			  clickMethod="onShowSubcompany('relatedshareid_"+shareid+"','showrelatedsharename_"+shareid+"')";
		  else if("3".equals(type))
			  clickMethod="onShowDepartment('relatedshareid_"+shareid+"','showrelatedsharename_"+shareid+"')";
		  else if("4".equals(type))
			  clickMethod="onShowRole('relatedshareid_"+shareid+"','showrelatedsharename_"+shareid+"')";
		  else if("5".equals(type))
			  clickMethod="onShowJobTitles('relatedshareid_"+shareid+"','showrelatedsharename_"+shareid+"')";
	   %>
	   <tr>
	      <td><%=typeName %></td>
	      <td>
	        <input type="hidden" name="sharetype" value="<%=hm.get("type")%>">
			<input type="hidden" name="relatedshareid" id="relatedshareid_<%=hm.get("shareid")%>" value="<%=hm.get("content")%>">
			<input type="hidden" name="shareid" value="<%=hm.get("shareid")%>"> 
			<input type="hidden" value="<%=hm.get("seclevel")%>" name="secLevel"/>
			<button class="Browser  btnShare" onclick="<%=clickMethod%>" type="button" style="display: <%=!"6".equals(type)?"inherit":"none"%>"></button>
			<span class="showrelatedsharename" id="showrelatedsharename_<%=hm.get("shareid")%>" name="showrelatedsharename">
				<%=contentName %> 
			</span>
	      </td>
	      <td align="center"><%=seclevel%></td>
		  <td align="left">
		     <a href="javascript:void(0)" onclick="delShare(this,'<%=shareid%>')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> <!-- 删除 -->
		  </td>
	   </tr>	
  <% }%>
	</tbody>
</table>
</form>			
</body>

<script>

  function checkcount(obj)
 {
	valuechar =jQuery(obj).val().split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) {
		charnumber = parseInt(valuechar[i]);
		if( isNaN(charnumber) && (valuechar[i]!="-" || (valuechar[i]=="-" && i!=0))){
			isnumber = true ;
		}
		if (valuechar.length==1 && valuechar[i]=="-"){
		    isnumber = true ;
		}
	}
	if(isnumber){
		jQuery(obj).val("0");
		alert("<%=SystemEnv.getHtmlLabelName(23086,user.getLanguage())%>");
	}
}

  function doSave(){
    jQuery("#mainform").submit();
  
  }
  
  function doBack(){
    window.location.href="BlogTemplateSetting.jsp";
  }
  
  function delShare(obj,shareid){
    if(shareid){
    if(window.confirm("<%=SystemEnv.getHtmlLabelName(16631,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15583,user.getLanguage())%>?")){  //确认删除条件
         jQuery.post("BlogSettingOperation.jsp?operation=deleteTempShare&shareid="+shareid,{},function(){
            jQuery(obj).parent().parent().remove(); 
         });
    }
    }else
       jQuery(obj).parent().parent().remove();    
  }
  
  var index=0;
  function addShare(){
		var str="<tr>"+
		"	<td>"+getShareTypeStr()+"</td>"+
		"	<td>"+getShareContentStr()+"</td>"+
		"	<td align='center'>"+getSecLevel()+"</td>"+		
		"	<td align='left'>"+getOptStr()+"</td>"+
		"</tr>";	
		jQuery("#shareList tbody").append(str);	

		index++;	
	}
	
  function getShareTypeStr(){
		return  "<select class='sharetype inputstyle'  name='sharetype' onChange=\"onChangeConditiontype(this)\" >"+
		"	<option value='1' selected><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>" +
        //"	<option value='2'><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>" +
        //"	<option value='3'><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>" +
        //"	<option value='4'><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>" +
        "	<option value='5'><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>"+
        //"	<option value='6'><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>"+
        "</select>";        
	}	
	
	
  function getShareContentStr(){
		return   "<BUTTON type='button' class='Browser  btnShare' onClick=\"onShowResource('relatedshareid_"+index+"','showrelatedsharename_"+index+"')\" type=\"t1\"></BUTTON>"+		
       "<BUTTON type='button' class='Browser  btnShare' style=\"display:none\" onClick=\"onShowSubcompany('relatedshareid_"+index+"','showrelatedsharename_"+index+"')\"  type=\"t2\"></BUTTON>"+ 
       "<BUTTON type='button' class='Browser  btnShare' style=\"display:none\" onClick=\"onShowDepartment('relatedshareid_"+index+"','showrelatedsharename_"+index+"')\"   type=\"t3\"></BUTTON>"+ 
       "<BUTTON type='button' class='Browser  btnShare' style=\"display:none\" onClick=\"onShowRole('relatedshareid_"+index+"','showrelatedsharename_"+index+"')\"  type=\"t4\"></BUTTON>"+
       "<BUTTON type='button' class='Browser  btnShare' style=\"display:none\" onClick=\"onShowJobTitles('relatedshareid_"+index+"','showrelatedsharename_"+index+"')\"  type=\"t5\"></BUTTON>"+
       "<INPUT type='hidden' name='relatedshareid'  class='relatedshareid' id=\"relatedshareid_"+index+"\" value=''>"+ 
       "<input type='hidden' name='shareid' value='0'>"+
       "<span id=showrelatedsharename_"+index+" class='showrelatedsharename'  name='showrelatedsharename'></span>";
	}	
	
	function getSecLevel(){ 
		return "<input class='shareSecLevel inputstyle' style='width:30px;display:none;text-align:center' name='secLevel' value='0'  onblur='checkcount(this)'/>";
	}
  
  
    function getOptStr(){
		return 	"<a onclick='delShare(this)' href='javascript:void(0)' class='spanDelete'><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></a>";
	}  
	
	function onChangeConditiontype(obj){
		var thisvalue=jQuery(obj).val();
		var jQuerytr=jQuery(obj.parentNode.parentNode);
		jQuerytr.find(".btnShare").hide();		
		jQuerytr.find(".relatedshareid").val("");
		jQuerytr.find(".showrelatedsharename").html("");
		
		//jQuerytr.find(".shareSecLevel").val("");
		jQuerytr.find(".shareSecLevel").hide();

		if(thisvalue==6){
			jQuerytr.find(".showrelatedsharename").hide();
		} else {
			jQuerytr.find(".showrelatedsharename").show();
			jQuerytr.find("button")[(jQuery(obj).val()-1)].style.display='';
		}	
		if(thisvalue!=1){
			jQuerytr.find(".shareSecLevel").show();
		}	
	}
  
  function onShowSubcompany(inputid,spanid){
	   var currentids=jQuery("#"+inputid).val();
	   var id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+currentids);
	   if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=openFullWindowForXtable('/hrm/company/HrmSubCompanyDsp.jsp?id="+tempid+"')>"+tempname+"</a>&nbsp;";
	          }
	          ids=ids+",";
	          jQuery("#"+inputid).val(ids);
	          jQuery("#"+spanid).html(sHtml);
	       }else{
	          jQuery("#"+inputid).val("");
	          jQuery("#"+spanid).html("");
	       }
       }
	}
	
	
	
    function onShowDepartment(inputid,spanid){
	   var currentids=jQuery("#"+inputid).val();
	   var id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+currentids);
	   if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=openFullWindowForXtable('/hrm/company/HrmDepartmentDsp.jsp?id="+tempid+"')>"+tempname+"</a>&nbsp;";
	          }
	          ids=ids+",";
	          jQuery("#"+inputid).val(ids);
	          jQuery("#"+spanid).html(sHtml);
	       }else{
	          jQuery("#"+inputid).val("");
	          jQuery("#"+spanid).html("");
	       }
       }
	}
	
	function onShowResource(inputid,spanid){
	   var currentids=jQuery("#"+inputid).val();
	   var id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+currentids);
	   if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>0){
	          var tempids=ids.split(",");
	          var tempnames=names.split(",");
	          var sHtml="";
	          for(var i=0;i<tempids.length;i++){
	              var tempid=tempids[i];
	              var tempname=tempnames[i];
	              if(tempid!='')
	                sHtml = sHtml+"<a href='javascript:void(0)' onclick=openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id="+tempid+"')>"+tempname+"</a>&nbsp;";
	          }
	          ids=ids+",";
	          jQuery("#"+inputid).val(ids);
	          jQuery("#"+spanid).html(sHtml);
	       }else{
	          jQuery("#"+inputid).val("");
	          jQuery("#"+spanid).html("");
	       }
       }
	}
	
   function onShowRole(inputid,spanid){
	   var id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp");
	   if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>0){
	          jQuery("#"+inputid).val(ids);
	          jQuery("#"+spanid).html(names);
	       }else{
	          jQuery("#"+inputid).val("");
	          jQuery("#"+spanid).html("");
	       }
       }
	}
	
 function onShowJobTitles(inputid,spanid){
    var currentids=jQuery("#"+inputid).val();
	var results=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?jobtitles="+currentids);
	if(results){
	   if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	      jQuery("#"+spanid).html(wuiUtil.getJsonValueByIndex(results,1).substring(1));
	      $GetEle(inputid).value=wuiUtil.getJsonValueByIndex(results,0)+",";
	   }else{
	      jQuery("#"+spanid).html("");
		  $GetEle(inputid).value="";
	   }
	}
 }
</script>
</html>
