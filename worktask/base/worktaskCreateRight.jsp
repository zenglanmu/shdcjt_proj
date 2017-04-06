<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/systeminfo/init.jsp"%>
<%@ page import="weaver.general.GCONST"%>
<%@ page import="weaver.general.IsGovProj"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.docs.category.CategoryUtil"%>
<%@ page import="weaver.docs.category.security.*"%>
<jsp:useBean id="CustomerTypeComInfo"
	class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo"
	class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo"
	class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo"
	scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ShareManager" class="weaver.share.ShareManager"
	scope="page" />
<html>
<HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
	String para = Util.null2String(request.getParameter("para"));

	String[] paraArray = Util.TokenizerString2(para, "_");
	int browserType = Util.getIntValue(paraArray[0], 0); //1:表示 目录中的默认共享    2:表示文档中的默认共享

	//System.out.println("browserType = "+browserType);

	int wtid = Util.getIntValue(paraArray[1], 0); // browserType:1 docid用目录ID   2 docid 为文档ID

	//System.out.println("wtid = "+wtid);

	boolean blnOsp = "true".equals(request.getParameter("blnOsp")); //用于存放共享提醒对话框的设置

	//System.out.println("blnOsp:"+blnOsp);
%>
<body>
	<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
	<%
		RCMenu += "{" + SystemEnv.getHtmlLabelName(826, user.getLanguage())
				+ ",javascript:doSave(this),_top} ";
		RCMenuHeight += RCMenuHeightStep;
		if (browserType == 1) {
			RCMenu += "{"
					+ SystemEnv.getHtmlLabelName(201, user.getLanguage())
					+ ",javascript:location.reload(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"
					+ SystemEnv.getHtmlLabelName(21931, user.getLanguage())
					+ ",javascript:useSetto(),_self}";
			RCMenuHeight += RCMenuHeightStep;
		}
		if (browserType == 2) {
			RCMenu += "{"
					+ SystemEnv.getHtmlLabelName(1290, user.getLanguage())
					+ ",/docs/docs/DocShare.jsp?docid=" + wtid + ",_self} ";
			RCMenuHeight += RCMenuHeightStep;
		}
	%>
	<%@ include file="/systeminfo/RightClickMenu.jsp"%>
	<%
		//通过文档的id得到文档的类型,文档创建人类型,文档创建者所具有的条件'
		String createUserType = "";
		String strSql = "select usertype from docdetail  where id=" + wtid;
		//rs.executeSql(strSql);
		//if (rs.next()){
		//createUserType = Util.null2String(rs.getString("usertype"));           
		//}
	%>
	<form name="weaver" method="post">
		<table width=100% height=100% border="0" cellspacing="0"
			cellpadding="0">
			<colgroup>
				<col width="10">
				<col width="">
				<col width="10">
		    </colgroup>		
			<tr>
				<td></td>
				<td valign="top">
					<TABLE class=Shadow>
						<tr>
							<td valign="top"><INPUT TYPE="hidden" NAME="wtid"
								value="<%=wtid%>"> <INPUT type="hidden" Name="method"
								value="addMutil"> <INPUT type="hidden" Name="delids"
								value="">
								<TABLE class=ViewForm>
									<COLGROUP>
										<COL width="30%">
										<COL width="70%">
									<TBODY>
										<TR class="Title">
											<TH colSpan=2><%=SystemEnv.getHtmlLabelName(21945, user.getLanguage())%></TH>
										</TR>
										<TR class="Spacing" style="height: 2px">
											<TD class="Line1" colSpan=2></TD>
										</TR>
										<TR>
											<TD><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%>
											</TD>

											<TD class="field"><SELECT class=InputStyle
												name=sharetype onChange="onChangeSharetype()">
													<option value="1" selected><%=SystemEnv.getHtmlLabelName(1867, user.getLanguage())%></option>
													<option value="2"><%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%></option>
													<option value="3"><%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%></option>
													<option value="4"><%=SystemEnv.getHtmlLabelName(122, user.getLanguage())%></option>
													<option value="5"><%=SystemEnv.getHtmlLabelName(235, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127, user.getLanguage())%></option>
											</SELECT> &nbsp;&nbsp;
												<BUTTON class=Browser type="button" style="display: "
													onClick="onShowResource('relatedshareid','showrelatedsharename')"
													name=showresource></BUTTON>
												<BUTTON class=Browser type="button" style="display: none"
													onClick="onShowSubcompany('showrelatedsharename','relatedshareid')"
													name=showsubcompany></BUTTON>
												<BUTTON class=Browser type="button" style="display: none"
													onClick="onShowDepartment('relatedshareid','showrelatedsharename')"
													name=showdepartment></BUTTON>
												<BUTTON class=Browser type="button" style="display: none"
													onClick="onShowRole('showrelatedsharename','relatedshareid')"
													name=showrole></BUTTON> <INPUT type=hidden
												name=relatedshareid id="relatedshareid" value=""> <span
												id=showrelatedsharename name=showrelatedsharename><IMG
													src='/images/BacoError.gif' align=absMiddle>
											</span></TD>
										</TR>
										<TR style="height: 1px">
											<TD class=Line colSpan=2></TD>
										</TR>

										<TR id=showrolelevel name=showrolelevel style="display: none">
											<TD><%=SystemEnv.getHtmlLabelName(3005, user.getLanguage())%>
											</TD>
											<td class="field"><SELECT name=rolelevel>
													<option value="0" selected><%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%>
													<option value="1"><%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%>
													<option value="2"><%=SystemEnv.getHtmlLabelName(140, user.getLanguage())%>
											</SELECT></td>
										</TR>
										<TR style="height: 1px">
											<TD class=Line colSpan=2 id=showrolelevel_line
												name=showrolelevel_line style="display: none"></TD>
										</TR>

										<TR id=showseclevel name=showseclevel style="display: none">
											<TD><%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>
											</TD>
											<td class="field"><INPUT type=text name=seclevel
												class=InputStyle size=6 value="10"
												onchange='checkinput("seclevel","seclevelimage")'
												onKeyPress="ItemCount_KeyPress()"> <span
												id=seclevelimage></span></td>
										</TR>
										<TR style="height: 1px">
											<TD class=Line colSpan=2 id=showseclevel_line
												name=showseclevel_line style="display: 'none'"></TD>
										</TR>
										<tr>
											<TD colspan=2>
												<TABLE width="100%">
													<TR>
														<TD width="*"></TD>
														<TD width="300px">
															<button class="btnNew" type="button"
																title="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>"
																onClick="addValue()" accesskey="a">
																<u>A</u>&nbsp;<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%></button>
															&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
															<button class="btnDelete" type="button"
																title="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"
																onClick="removeValue()" accesskey="d">
																<u>D</u>&nbsp;<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></button>
														</TD>
													</TR>
												</TABLE></TD>
										<tr>
										<TR style="height: 1px">
											<TD class=Line colSpan=2></TD>
										</TR>
										<tr>
											<td colspan=2>
												<table class="listStyle" id="oTable" name="oTable" style="margin-bottom: 0px;">
													<colgroup>
														<col width="5%">
														<col width="20%">
														<col width="30%">
														<col width="25%">
														<col width="25%">
													<tr class="header">
														<td><input type="checkbox" name="chkAll"
															onClick="chkAllClick(this)">
														</td>
														<td><%=SystemEnv.getHtmlLabelName(21956, user.getLanguage())%></td>
														<td><%=SystemEnv.getHtmlLabelName(21957, user.getLanguage())%></td>
														<td><%=SystemEnv.getHtmlLabelName(21958, user.getLanguage())%></td>
														<td><%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%></td>
													</tr>
												</table>
												<table class="listStyle" id="oTable2" name="oTable2" style="margin: 0px;">
													<colgroup>
														<col width="5%">
														<col width="20%">
														<col width="30%">
														<col width="25%">
														<col width="25%">
														<%
															String classStr = "DataDark";
															boolean classFlag = true;
															rs.execute("select * from worktaskcreateshare where taskid=" + wtid);
															while (rs.next()) {
																int id = Util.getIntValue(rs.getString("id"), 0);
																int seclevel = Util.getIntValue(rs.getString("seclevel"), 0);
																int rolelevel = Util.getIntValue(rs.getString("rolelevel"), 0);
																int sharetype = Util.getIntValue(rs.getString("sharetype"), 0);
																int userid = Util.getIntValue(rs.getString("userid"), 0);
																int subcompanyid = Util.getIntValue(
																		rs.getString("subcompanyid"), 0);
																int departmentid = Util.getIntValue(
																		rs.getString("departmentid"), 0);
																int roleid = Util.getIntValue(rs.getString("roleid"), 0);
																int foralluser = Util
																		.getIntValue(rs.getString("foralluser"), 0);
																String sharetypeStr = "";
																String objname_Str = "";
																String rolelevelStr = "";
																int relatedshareid = 0;
																if (sharetype == 5) {
																	sharetypeStr = SystemEnv.getHtmlLabelName(235,
																			user.getLanguage())
																			+ SystemEnv.getHtmlLabelName(127,
																					user.getLanguage());
																	objname_Str = "";
																} else if (sharetype == 4) {
																	sharetypeStr = SystemEnv.getHtmlLabelName(122,
																			user.getLanguage());
																	rs1.executeSql("select rolesmark from hrmroles where id="
																			+ roleid);
																	rs1.next();
																	objname_Str = rs1.getString(1);
																	relatedshareid = roleid;
																	if (rolelevel == 2) {
																		rolelevelStr = SystemEnv.getHtmlLabelName(140,
																				user.getLanguage());
																	} else if (rolelevel == 1) {
																		rolelevelStr = SystemEnv.getHtmlLabelName(141,
																				user.getLanguage());
																	} else {
																		rolelevelStr = SystemEnv.getHtmlLabelName(124,
																				user.getLanguage());
																	}
																} else if (sharetype == 3) {
																	sharetypeStr = SystemEnv.getHtmlLabelName(124,
																			user.getLanguage());
																	objname_Str = "<a href=javaScript:openFullWindowHaveBar(\'/hrm/company/HrmDepartmentDsp.jsp?id="
																			+ departmentid
																			+ "\') >"
																			+ DepartmentComInfo.getDepartmentname(""
																					+ departmentid) + "</a>";
																	relatedshareid = departmentid;
																} else if (sharetype == 2) {
																	sharetypeStr = SystemEnv.getHtmlLabelName(141,
																			user.getLanguage());
																	objname_Str = "<a href=javaScript:openFullWindowHaveBar(\'/hrm/company/HrmSubCompanyDsp.jsp?id="
																			+ subcompanyid
																			+ "\') >"
																			+ SubCompanyComInfo.getSubCompanyname(""
																					+ subcompanyid) + "</a>";
																	relatedshareid = subcompanyid;
																} else {
																	sharetypeStr = SystemEnv.getHtmlLabelName(1867,
																			user.getLanguage());
																	objname_Str = "<a href=javaScript:openFullWindowHaveBar(\'/hrm/resource/HrmResource.jsp?id="
																			+ userid
																			+ "\') >"
																			+ ResourceComInfo.getResourcename("" + userid)
																			+ "</a>";
																	relatedshareid = userid;
																}
																//String totalValue = ""+sharetype+"_"+relatedshareid+"_"+rolelevel+"_"+seclevel;
														%>
													
													<tr class="<%=classStr%>">
														<td><input class="inputStyle" type="checkbox"
															name="chkShareDetail2" value="<%=id%>"><input
															type="hidden" name="txtShareDetail2" value="<%=id%>">
														</td>
														<td><%=sharetypeStr%></td>
														<td><%=objname_Str%></td>
														<td><%=rolelevelStr%></td>
														<td><%=seclevel%></td>
													</tr>
													<%
														if (classFlag == true) {
																classFlag = false;
																classStr = "DataLight";
															} else {
																classFlag = true;
																classStr = "DataDark";
															}
														}
													%>
												</table></td>
										</tr>
									</TBODY>
								</TABLE></td>
						</tr>
					</TABLE></td>
				<td></td>
			</tr>
			<tr>
				<td height="10" colspan="3"></td>
			</tr>
		</table>
	</form>
</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
<!--

function onChangeSharetype(){
	var thisvalue=jQuery("select[name=sharetype]").val();
	jQuery("#relatedshareid").val("");
	jQuery("#showseclevel").show();
	jQuery("#showseclevel_line").show();

	jQuery("#showrelatedsharename").html("<IMG src='/images/BacoError.gif' align=absMiddle>");

	if(thisvalue==1){
		jQuery("button[name=showresource]").show();
		jQuery("#showseclevel").hide();
		jQuery("#showseclevel_line").hide();
		jQuery("input[name=seclevel]").val(0);
	}else{
		jQuery("button[name=showresource]").hide();
	}

	if(thisvalue==2){
 		jQuery("button[name=showsubcompany]").show();
 		jQuery("input[name=seclevel]").val(10);
	}else{
		jQuery("button[name=showsubcompany]").hide();
		jQuery("input[name=seclevel]").val(10);
	}
	if(thisvalue==3){
 		jQuery("button[name=showdepartment]").show();
 		jQuery("input[name=seclevel]").val(10);
	}else{
		jQuery("button[name=showdepartment]").hide();
		jQuery("input[name=seclevel]").val(10);
	}
	if(thisvalue==4){
		jQuery("button[name=showrole]").show();
		jQuery("#showrolelevel").show();
		jQuery("#showrolelevel_line").show();
		jQuery("select[name=rolelevel]").show();
		jQuery("input[name=seclevel]").val(10);
	}else{
		jQuery("button[name=showrole]").hide();
		jQuery("#showrolelevel").hide();
		jQuery("#showrolelevel_line").hide();
		jQuery("select[name=rolelevel]").hide();
		jQuery("input[name=seclevel]").val(10);
    }
	if(thisvalue==5){
		jQuery("#showrelatedsharename").html("");
		jQuery("#relatedshareid").val(-1);
		jQuery("input[name=seclevel]").val(10);
	}
}

function removeValue(){
    
    if(jQuery("input[name='chkShareDetail2']:checked").length==0&&jQuery("input[name='chkShareDetail']:checked").length==0){
       alert("<%=SystemEnv.getHtmlLabelName(18131, user.getLanguage())%>");
       return ;
    }
    
    if(jQuery("input[name='chkShareDetail2']:checked").length>0||jQuery("input[name='chkShareDetail']:checked").length>0){
       if(!window.confirm("<%=SystemEnv.getHtmlLabelName(23069, user.getLanguage())%>?"))
          return ;
    }
	try{
		var chks = document.getElementsByName("chkShareDetail");
		for (var i=chks.length-1; i>=0; i--){
			var chk = chks[i];
			//alert(i);
			//alert(chk.value);
			//alert(chk.parentElement.parentElement.parentElement.tagName);
			if (chk.checked){
				oTable.deleteRow(jQuery(chk).parent().parent().parent().index());
			}
		}
	}catch(e){}
	try{
		var chks2 = document.getElementsByName("chkShareDetail2");
		for (var j=chks2.length-1; j>=0; j--){
			var chk2 = chks2[j];
			var delids = document.weaver.delids.value;
			if (chk2.checked){
				//alert(j);
				//alert(chk2.value);
				//alert(chk2.parentElement.parentElement.rowIndex);
				oTable2.deleteRow(jQuery(chk2).parent().parent().index());
				document.weaver.delids.value = delids + chk2.value + ",";
				delids = document.weaver.delids.value;
			}
		}
	}catch(e){}
}

function addValue(){
    thisvalue=jQuery("select[name=sharetype]").val();

   var shareTypeValue = thisvalue;
   var shareTypeText = jQuery("select[name=sharetype] option:selected").html();


    //人力资源(1),分部(2),部门(3),具体客户(9),角色后的那个选项值不能为空(4)
    var relatedShareIds="0";
    var relatedShareNames="";
    if (thisvalue==1||thisvalue==2||thisvalue==3||thisvalue==4||thisvalue==9) {
        if(!check_form(document.weaver,'relatedshareid')) {
            return ;
        }
        if (thisvalue==4){
            if (!check_form(document.weaver,'seclevel'))
                return;
        }
        relatedShareIds = jQuery("#relatedshareid").val();
        relatedShareNames= jQuery("#showrelatedsharename").html();
    }

    var secLevelValue="0";
    var secLevelText="";
    if (thisvalue!=1&&thisvalue!=-80&&thisvalue!=-81&&thisvalue!=-82&&thisvalue!=80&&thisvalue!=81&&thisvalue!=82) {
        secLevelValue = jQuery("input[name=seclevel]").val();
        secLevelText=secLevelValue;
    }

   var rolelevelValue=0;
   var rolelevelText="";
   if (thisvalue==4){  //角色  0:部门   1:分部  2:总部
       rolelevelValue = jQuery("select[name=rolelevel]").val();
       rolelevelText=jQuery("select[name=rolelevel] option:selected").html();
   }

   //共享类型 + 共享者ID +共享角色级别 +共享级别+共享权限
   var totalValue=shareTypeValue+"_"+relatedShareIds+"_"+rolelevelValue+"_"+secLevelValue;

   var oRow = oTable.insertRow(-1);
   var oRowIndex = oRow.rowIndex;

   if (oRowIndex%2==0) oRow.className="DataLight";
   else oRow.className="DataDark";

   for (var i =1; i <=5; i++) {   //生成一行中的每一列

      oCell = oRow.insertCell(-1);
      var oDiv = document.createElement("div");
      if (i==1) oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='chkShareDetail' value='"+totalValue+"'><input type='hidden' name='txtShareDetail' value='"+totalValue+"'>";
      else if (i==2) oDiv.innerHTML=shareTypeText;
      else  if (i==3) oDiv.innerHTML=relatedShareNames;
      else  if (i==4) oDiv.innerHTML=rolelevelText;
      else  if (i==5) {if (secLevelText=="0") secLevelText=""; oDiv.innerHTML=secLevelText;}

      oCell.appendChild(oDiv);
   }
}

function chkAllClick(obj){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        chk.checked = obj.checked;
    }
	try{
		var chks2 = document.getElementsByName("chkShareDetail2");
		for (var i=0;i<chks2.length;i++){
			var chk2 = chks2[i];
			chk2.checked = obj.checked;
		}
	}catch(e){}
}
//-->
</SCRIPT>
<script type="text/javascript">
var opts={
		_dwidth:'550px',
		_dheight:'550px',
		_url:'about:blank',
		_scroll:"no",
		_dialogArguments:"",
		
		value:""
	};
var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
opts.top=iTop;
opts.left=iLeft;

function onShowSubcompany(tdname,inputname){
linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id=";
data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
if (data!=null) {
    if (data.id!= "") { 	
    	ids = data.id.split(",");
		names =data.name.split(",");
        sHtml = "";
      	for(var i=0;i<ids.length;i++){
      		if(ids!=""){
            sHtml = sHtml+"<a href=javaScript:openFullWindowHaveBar('"+linkurl+ids[i]+"')>"+names[i]+"</a>&nbsp;";
      		}        
      	}
        jQuery("#"+tdname).html(sHtml);
        jQuery("input[name="+inputname+"]").val(data.id);
        }else{
        	jQuery("#"+tdname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
	    jQuery("input[name="+inputname+"]").val("");
	    }
	}
}

function onShowDepartment(inputname,spanname){
linkurl="/hrm/company/HrmDepartmentDsp.jsp?id=";
data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
if (data!=null) {
    if (data.id!= "" ) { 	
    	ids = data.id.split(",");
		names =data.name.split(",");
	    sHtml = "";
    	for(var i=0;i<ids.length;i++){
      		if(ids!=""){
		    	sHtml = sHtml+"<a href=javaScript:openFullWindowHaveBar('"+linkurl+ids[i]+"')>"+names[i]+"</a>&nbsp;";
      		}
      	}
	    jQuery("#"+spanname).html(sHtml);
	    jQuery("input[name="+inputname+"]").val(data.id);
    }else{
    	jQuery("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
    	jQuery("input[name="+inputname+"]").val("");
    }
}
}

function onShowCRM(inputname,spanname){
temp =jQuery("#"+inputname).val();
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="+temp,"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;")
	if (data!=null){
		if (data.id.length > 500){// '500为表结构相关客户字段的长度
		//	result = msgbox//("您选择的相关客户数量太多，数据库将无法保存所有的相关客户，请重新选择！",48,"注意")
			jQuery("#"+spanname).html("");
			jQuery("#"+inputname).val();
		}else if (data.id!= ""){
			ids = data.id.split(",");
			names =data.name.split(",");
			sHtml = "";
		     for(var i=0;i<ids.length;i++){
		      		if(ids!=""){
						sHtml = sHtml+"<a href='/CRM/data/ViewCustomer.jsp?CustomerID="+ids[i]+"'>"+names[i]+"</a>&nbsp;";
		      		}
		    }
			jQuery("#"+spanname).html(sHtml);
			jQuery("input[name="+inputname+"]").val(data.id);
	    }else{
	    	jQuery("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
	    	jQuery("input[name="+inputname+"]").val("");
		}
	}
	
}

function onShowResource(inputname,spanname){
	linkurl="/hrm/resource/HrmResource.jsp?id=";
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (data!=null) {
		if (data.id!= "") { 	
	    	ids = data.id.split(",");
			names =data.name.split(",");
	        sHtml = "";
	    	for(var i=0;i<ids.length;i++){
	      		if(ids!=""){
			    	sHtml = sHtml+"<a href=javaScript:openFullWindowHaveBar('"+linkurl+ids[i]+"')>"+names[i]+"</a>&nbsp;";
	      		}
	      	}
		    jQuery("#"+spanname).html(sHtml);
		    jQuery("input[name="+inputname+"]").val(data.id);
	    }else{
	    	jQuery("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
	    	jQuery("input[name="+inputname+"]").val("");
	    }
	}
	}
	
function onShowRole(tdname,inputname){
data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp")
if (data!=null){
    if (data.id != ""){
	    jQuery("#"+tdname).html(data.name);
	    jQuery("input[name="+inputname+"]").val(data.id);
    }else{
    	jQuery("#"+tdname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
    jQuery("input[name="+inputname+"]").val("");
	}
}
}

function doSave(obj){
	obj.disabled=true;
 	if (<%=browserType%>==1){ 
     document.weaver.action="/worktask/base/ShareOperation.jsp";
 	}else{
    document.weaver.action="DocShareOperation.jsp?wtid=<%=wtid%>&blnOsp=<%=blnOsp%>";
 	}
 	document.weaver.submit();
}

function useSetto(){
	url=escape("/worktask/base/WorktaskList.jsp?wtid=<%=wtid%>&usesettotype=3");
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url, window);
}
</script>


