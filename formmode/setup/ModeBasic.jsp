<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ModeTreeFieldComInfo" class="weaver.formmode.setup.ModeTreeFieldComInfo" scope="page"/>
<jsp:useBean id="MainCCI" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCCI" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCCI" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<html>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
String isloadleft = Util.null2String(request.getParameter("isloadleft"));	
String modeId = Util.null2String(request.getParameter("modeId"));
String typeId = Util.null2String(request.getParameter("typeId"));
String treeFieldId = "";
if(isloadleft.equals("1")){
	treeFieldId = typeId+"_"+modeId;
%><script>
    parent.parent.document.getElementById('leftframe').src="ModeSettingLeft.jsp?treeFieldId=<%=treeFieldId%>";
  </script>
<%}

String operate = modeId.equals("")?"AddMode":"EditMode";
String modeName = "";
String modeDesc = "";
String formId = "";
String maincategory = "";
String subcategory = "";
String seccategory = "";
String isImportDetail = "";
String path = "";
if(Util.getIntValue(modeId,0) > 0){
	RecordSet.executeSql("select * from modeinfo where id="+modeId);
	if(RecordSet.next()){
		modeName = Util.null2String(RecordSet.getString("modeName"));
		modeDesc = Util.null2String(RecordSet.getString("modeDesc"));
		formId = Util.null2String(RecordSet.getString("formId"));
		maincategory = Util.null2String(RecordSet.getString("maincategory"));
		subcategory = Util.null2String(RecordSet.getString("subcategory"));
		seccategory = Util.null2String(RecordSet.getString("seccategory"));
		isImportDetail = Util.null2String(RecordSet.getString("isImportDetail"));
	}
}
if(!maincategory.equals("0")&&!subcategory.equals("0")&&!seccategory.equals("0")){
	path="/"+MainCCI.getMainCategoryname(maincategory)+"/"+SubCCI.getSubCategoryname(subcategory)+"/"+SecCCI.getSecCategoryname(seccategory);
	if(path.length()==3){
		path = "";
	}
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(19049,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(82,user.getLanguage());
String needfav ="";
String needhelp ="";
if(Util.getIntValue(modeId,0) > 0){
	titlename = SystemEnv.getHtmlLabelName(19049,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());
}
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if(!formId.equals("")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(28493,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(82,user.getLanguage())+"),javascript:createMenu(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(28624,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(82,user.getLanguage())+"),javascript:viewmenu(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<body>

<form name="weaver" id="weaver" method="post" action="ModeOperation.jsp">
<input type="hidden" name="modeId" id="modeId" value="<%=modeId%>">
<input type="hidden" name="operate" id="operate" value="<%=operate %>">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
 <tr>
  <td height="10" colspan="3"></td>
 </tr>
 <tr>
  <td></td>
   <td valign="top">
	<TABLE class=Shadow>
	 <tr>
	 <td valign="top">
	  <table class="viewform">
   	   <COLGROUP>
   		<COL width="20%">
  		<COL width="80%">
  		<TR class="Title">
  		 <TH colSpan=2> <%=SystemEnv.getHtmlLabelName(23669,user.getLanguage())%></TH>
  		</TR>
  		<TR class="Spacing" style="height:1px;"><TD class="Line1" colSpan=2></TD></TR>
  		
  		<tr><!-- 模块名称 -->
  		 <td><%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
  		 <td class=field>
  		  <input class=Inputstyle type="text" name="modeName" id="modeName" value="<%=modeName %>" size="40" maxlength="50" onChange="checkinput('modeName','modeNamespan')" maxlength="50" >
  		  <span id=modeNamespan><%if(modeName.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></span>
  		 </td>
  		</tr>
  		<TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
  		
  		<tr><!-- 模块描述 -->
  		 <td><%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td>
  		 <td class=field style="word-wrap: break-word; word-break: break-all;">
  		  <textarea rows="6" name="modeDesc" id=modeDesc class=Inputstyle style="width:60%" onchange="checkLengthfortext('modeDesc','1000','模块描述','文本长度不能超过','1个中文字符等于2个长度')"><%=Util.toScreenToEdit(modeDesc,user.getLanguage())%></textarea>
  		 </td>
  		</tr>
  		<TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
  		
  		<tr><!-- 模块类型 -->
  		 <td><%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
  		 <td class=field>
  		  <select class=inputstyle  name=typeId name=typeId style="width:50%">
  		  <%
  			while(ModeTreeFieldComInfo.next()){
  				String checktmp = "";
  				String isLast = ModeTreeFieldComInfo.getIsLast();
  				if(isLast.equals("1")) {
  					if(ModeTreeFieldComInfo.getId().equals(typeId))
  						checktmp=" selected";
  				%>
  				<option value="<%=ModeTreeFieldComInfo.getId()%>" <%=checktmp%>><%=ModeTreeFieldComInfo.getTreeModeFieldName()%></option>
  				<%
  				}
  			}
  		  %>
  		  </select>
  		 </td>
  		</tr>
  		<TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
  		
  		<tr><!-- 表单 -->
  		 <td><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></td>
  		 <td class=field>
  		 <%
  		 String bname = "<IMG src=\"/images/BacoError.gif\" align=absMiddle>";
  		 RecordSet.executeSql("select * from workflow_bill where id='"+formId+"'");
 		 if(RecordSet.next()){
 			int tmplable = RecordSet.getInt("namelabel");
 			bname = "<a href=\"#\" onclick=\"toformtab('"+formId+"')\" style=\"color:blue;TEXT-DECORATION:none\">"+SystemEnv.getHtmlLabelName(tmplable,user.getLanguage())+"</a>";
 		 }
  		 %>
  		 <button type="button" class=Browser id=formidSelect onClick="onShowFormSelect( formId, formidSelectSpan)" name=formidSelect></BUTTON>
  		 <span name="formidSelectSpan" id=formidSelectSpan><%=bname%></span>
  		 <font color="red"><%=SystemEnv.getHtmlLabelName(18720,user.getLanguage())%><a href="#" onclick="toformtab('')" style="color:blue;TEXT-DECORATION:none"><b><%=SystemEnv.getHtmlLabelName(700,user.getLanguage())%></b></a><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></font>
  		 <span id=createMenuSpan >
<!--  		  <a href="#" style="TEXT-DECORATION:none" onclick="createMenu()"><b>-->
<!--  		  <%=SystemEnv.getHtmlLabelName(28493,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>)-->
<!--  		  </b></a>-->
  		 </span>
  		 <input type="hidden" name="formId" id="formId" value="<%=formId%>">
  		 </td>
  		</tr>
  		<TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
  		<!-- 附件上传目录 -->
  		<tr>
  			<td><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(92,user.getLanguage())%></td>
    		<td class=field>
	    		<button type="button" class=Browser id=selectCategoryid name=selectCategoryid onClick="onShowCatalog('mypath')" ></BUTTON>
    			<span id=mypath><%=path%></span>
   			    <input type=hidden id='maincategory' name='maincategory' value="<%=maincategory%>">
   				<INPUT type=hidden id='subcategory' name='subcategory' value="<%=subcategory%>">
   				<INPUT type=hidden id='seccategory' name='seccategory' value="<%=seccategory%>">
    		</td>
  		</tr>   
  		<TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
  		<!-- 允许导入明细 -->
  		<tr>
  			<td><%=SystemEnv.getHtmlLabelName(28503,user.getLanguage())%></td>
  			<td class=field>
  				<input type="checkbox" name=isImportDetail id=isImportDetail value="1" <% if(isImportDetail.equals("1")) {%> checked <%}%> >
  			</td>
  		</tr>
  		<TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
  	  </table>
  	 </td>
  	 </tr>
  	</TABLE>
   </td>
   <td></td>
  </tr>
 </table>
</form>
</body>
<script type="text/javascript">

$(document).ready(function(){//onload事件
	$(".loading", window.parent.document).hide(); //隐藏加载图片
	var formId = $("#formId").val();
	var modeId = $("#modeId").val();
	if(formId==''||modeId==''){
		$("#createMenuSpan").attr("style","display:none");
	}
})

function createMenu(){
	var formId = $("#formId").val();
	var modeId = $("#modeId").val();
	if(formId == '') {
		alert("请选择表单！");
		return;
	}
	var height = document.body.clientHeight;
	var width = document.body.clientWidth;
	
	var parmes = escape("/formmode/view/AddFormMode.jsp?modeId="+modeId+"&formId="+formId+"&type=1");
	var url = "/formmode/menu/CreateMenu.jsp?menuaddress="+parmes;
	var handw = "dialogHeight="+height+";dialogWidth="+width;
	window.open(url);
}
function viewmenu(){
	var formId = $("#formId").val();
	var modeId = $("#modeId").val();
	if(formId == '') {
		alert("请选择表单！");
		return;
	}
	var height = document.body.clientHeight;
	var width = document.body.clientWidth;
	
	var url = "/formmode/view/AddFormMode.jsp?modeId="+modeId+"&formId="+formId+"&type=1";
	prompt("<%=SystemEnv.getHtmlLabelName(28624,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>)",url);
}

function onShowFormSelect(inputName, spanName){
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/setup/FormBrowser.jsp");
	if (datas){
	    if(datas.id!=""){
		    $(inputName).val(datas.id);
			if ($(inputName).val()==datas.id){
		    	$(spanName).html(datas.name);
			}
	    }else{
		    $(inputName).val("");
			$(spanName).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
		}
	} 
}

function submitData(){
	if(check_form(weaver,"modeName,formId")){
		enableAllmenu();
		weaver.submit();
	}
}

function toformtab(formid){
	var height = document.body.clientHeight;
	var width = document.body.clientWidth;
	var parm = "&formid="+formid;
	if(formid=='') 
		parm = '';
	var url = "/workflow/form/addDefineForm.jsp?isFromMode=1"+parm;
	var handw = "dialogHeight="+height+";dialogWidth="+width;
	//window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+escape(url),window,handw);
	window.open(url);
}

function onShowCatalog(spanName) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp");
    if (result) {
        if (result.tag>0)  {
           $G(spanName).innerHTML = result.path;
           $G("maincategory").value=result.mainid;
           $G("subcategory").value=result.subid;
           $G("seccategory").value=result.id;
        }else{
           $G(spanName).innerHTML = "";
           $G("maincategory").value="";
           $G("subcategory").value="";
           $G("seccategory").value="";
        }
    }
}
</script>
</html>