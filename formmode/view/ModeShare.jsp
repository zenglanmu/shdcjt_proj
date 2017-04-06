<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<%
int modeId = Util.getIntValue(request.getParameter("modeId"),0);
int formId = Util.getIntValue(request.getParameter("formId"),0);
int billid = Util.getIntValue(request.getParameter("billid"),0);
int ajax = Util.getIntValue(request.getParameter("ajax"),0);
int MaxShare = Util.getIntValue(request.getParameter("MaxShare"),0);
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<BODY>
<%
String imagefilename = "/images/hdCRMAccount.gif";
String titlename = SystemEnv.getHtmlLabelName(16526,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if(ajax == 2){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(15033,user.getLanguage())+",javascript:window.close()',_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location.href='/formmode/setup/ModeRightEdit.jsp?modeId="+modeId+"',_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<FORM id=weaver name=weaver action="/formmode/setup/ModeRightOperation.jsp" method=post onsubmit='return check_by_permissiontype()'>
  <input type="hidden" name="method" value="addShare">
  <input type="hidden" name="modeId" value="<%=modeId%>">
  <input type="hidden" name="billid" value="<%=billid%>">
  <input type="hidden" name="MaxShare" value="<%=MaxShare%>">
  <TABLE class=ViewForm>
    <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
    </COLGROUP>
    <TBODY>
     <TR><!-- 共享类型 -->
       <TD><%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%></TD>
       <TD class="field">
         <SELECT class=InputStyle  name=sharetype onChange="onChangeSharetype()" >  
           <option value="1" selected><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option> <!-- 人员 -->
           <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><!-- 分部 -->
           <option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option><!-- 部门 -->
           <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option><!-- 角色 -->
           <option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option><!-- 所有人 -->
         </SELECT>
         <span id=showspan >
	         <INPUT type=hidden name="relatedid"  id="relatedid" value="">
	         <BUTTON class=Browser id="btnRelated" onClick="onShowRelated(relatedid,showrelatedname)" name="btnRelated"></BUTTON>
	         <span id="showrelatedname" name="showrelatedname"><IMG src='/images/BacoError.gif' align=absMiddle></span>
         </span>
       </TD>
     </TR>
     <TR style="height: 1px"> <TD class=Line colSpan=2></TD></TR>
     <!-- 角色级别 -->
     <TR id=rolelevel_tr name=id=rolelevel_tr style="display:none">
       <td><%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%></td>
       <td class="field">
           <SELECT  name=rolelevel>
	           <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><!-- 部门 -->
	           <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><!-- 分部 -->
	           <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%><!-- 总部 -->
	       </SELECT>
       </td>
     </TR>
     <TR id=rolelevel_line name=rolelevel_line style="display:none;height: 1px">
       <TD class=Line colSpan=2  ></TD>
     </TR>
     <!-- 安全级别 -->
     <TR  id=showlevel_tr name=showlevel_tr style="display:none;height: 1px">
       <TD><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></TD>
       <TD class="field">
       	 <INPUT type=text name=showlevel class=InputStyle size=6 value="10" onchange='checkinput("showlevel","showlevelimage")' onKeyPress="ItemCount_KeyPress()">
         <span id=showlevelimage></span>
       </TD>
     </TR>
     <TR id=showlevel_line name=showlevel_line style="display:none;height: 1px">
        <TD class=Line colSpan=2 ></TD>
     </TR>
     <!-- 权限项 -->
     <TR>
       <td><%=SystemEnv.getHtmlLabelName(440,user.getLanguage())%></td>
       <TD class="field">
         <SELECT class=InputStyle  name=righttype >
	         <option value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
	         <%if(MaxShare > 1){ %>
			 <option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>
			 <%}if(MaxShare > 2){ %>
			 <option value="3"><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option>
			 <%} %>
		 </SELECT>
       </TD>
     </TR>
     <TR class="Spacing"><TD class="Line1" colspan=2></TD></TR>
     
     <TR>
       <TD  colspan=2>
         <TABLE  width="100%">
           <TR>
     		<TD width="*"></TD>
        	<TD width="300px">
        	<button class="btnNew" type="button" onClick="addValue()" title="<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage())%>" accesskey="a"><u>A</u>&nbsp;<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage())%></button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        	<button class="btnDelete" type="button" onClick="removeValue()" title="<%=SystemEnv.getHtmlLabelName(18646,user.getLanguage())%>" onClick="removeValue()" accesskey="d"><u>D</u>&nbsp;<%=SystemEnv.getHtmlLabelName(18646,user.getLanguage())%></button></TD>
           </TR>
         </TABLE>
       </TD>
     </TR>
     <TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
     <tr>
       <td colspan=2>
         <table class="listStyle" id="oTable" name="oTable">
             <colgroup>
             <col width="3%">
             <col width="20%">
             <col width="20%">
             <col width="17%">
             <col width="20%">
             <col width="20%">
             <tr class="header">
                 <th><input type="checkbox" name="chkAll" onClick="chkAllClick(this)"></th>
                 <th><%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%></th>
                 <th><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%></th>
                 <th><%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%></th>
                 <th><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></th>
                 <th><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%></th>
             </tr>
             <tr class=Line style="height: 1px" ><td colspan=6 style="padding: 0px"></td></tr>
       <%
       	rs.executeSql("select * from modeDataShare_"+modeId+" where sourceid="+billid+" and isDefault=0");
        String oldIds = "";
       	while(rs.next()){
       		System.out.println("select * from modeDataShare_"+modeId+" where sourceid="+billid+" and isDefault=0");
       		oldIds += ",'"+Util.null2String(rs.getString("id"))+"'";
       		String shareTypeValue = rs.getString("type");		//Sharetype共享类型 1.人员 2、分部 3.部门 4.角色 5.所有人
       		
       		String relatedids = "";
       		String relatedShareNames = "";
       		String rolelevelValue = "0";
       		String rolelevelText = "";
       		String righttypelText = "";
       		//Relatedids+Rolelevel 类型为角色时 =角色ID+角色级别ID;(0: 部门 1：分部 2：总部)如 230表示角色ID=23,级别为:部门
       		String content = rs.getString("content");	
       		String showlevelValue = rs.getString("seclevel");	//Showlevel 安全级别type=1时此处为0
       		String showlevelText = "";
       		String sharelevel = rs.getString("sharelevel");//Righttype 共享级别1、查看；2、编辑；3、完全控制
       		
       		if(!shareTypeValue.equals("1"))
       			showlevelText = showlevelValue;
       		if(shareTypeValue.equals("4")){//角色
       			relatedids = content.substring(0,content.length()-1);
       			rolelevelValue = content.substring(content.length()-1);	//角色级别
       			if(rolelevelValue.equals("0")) rolelevelText = SystemEnv.getHtmlLabelName(124,user.getLanguage());
       			if(rolelevelValue.equals("1")) rolelevelText = SystemEnv.getHtmlLabelName(141,user.getLanguage());
       			if(rolelevelValue.equals("2")) rolelevelText = SystemEnv.getHtmlLabelName(140,user.getLanguage());
       		}else{
       			relatedids = content;
       		}
       		if(sharelevel.equals("1"))	//权限项
       			righttypelText = SystemEnv.getHtmlLabelName(367,user.getLanguage());
       		else if(sharelevel.equals("2"))
       			righttypelText = SystemEnv.getHtmlLabelName(93,user.getLanguage());
       		else if(sharelevel.equals("3"))
       			righttypelText = SystemEnv.getHtmlLabelName(17874,user.getLanguage());
       		
       		String totalValue = shareTypeValue+"_"+relatedids+"_"+rolelevelValue+"_"+showlevelValue+"_"+sharelevel+"_"+righttypelText;
       		String shareTypeText = "";
       		if(shareTypeValue.equals("1")) shareTypeText = SystemEnv.getHtmlLabelName(1867,user.getLanguage());
       		else if(shareTypeValue.equals("2")) shareTypeText = SystemEnv.getHtmlLabelName(141,user.getLanguage());
       		else if(shareTypeValue.equals("3")) shareTypeText = SystemEnv.getHtmlLabelName(124,user.getLanguage());
       		else if(shareTypeValue.equals("4")) shareTypeText = SystemEnv.getHtmlLabelName(122,user.getLanguage());
       		else if(shareTypeValue.equals("5")) shareTypeText = SystemEnv.getHtmlLabelName(1340,user.getLanguage());
       		
       		if(shareTypeValue.equals("1")) relatedShareNames = ResourceComInfo.getLastname(relatedids);
       		else if(shareTypeValue.equals("2")) relatedShareNames = SubCompanyComInfo.getSubCompanyname(relatedids);
       		else if(shareTypeValue.equals("3")) relatedShareNames = DepartmentComInfo.getDepartmentname(relatedids);
       		else if(shareTypeValue.equals("4")) relatedShareNames = RolesComInfo.getRolesRemark(relatedids);
       		%>
       		<tr>
       		  <td>
       		   <div>
       		     <input class='inputStyle' type='checkbox' name='chkShareDetail' value='<%=totalValue %>'>
       		     <input type='hidden' name='txtShareDetail' value='<%=totalValue %>'>
       		   </div>
       		  </td>
       		  <td>
       		   <div>
       		    <%=shareTypeText %>
       		   </div>
       		  </td>
       		  <td>
       		   <div>
       		    <%=relatedShareNames %>
       		   </div>
       		  </td>
       		  <td>
       		   <div>
       		    <%=rolelevelText %>
       		   </div>
       		  </td>
       		  <td>
       		   <div>
       		    <%=showlevelText %>
       		   </div>
       		  </td>
       		  <td>
       		   <div>
       		    <%=righttypelText %>
       		   </div>
       		  </td>
       		</tr>
       		<%
       	}
       	if(!oldIds.equals("")) oldIds = oldIds.substring(1);
       %>
         </table>
       </td>
  	  </tr>
    </TBODY>
  </TABLE>
  <input type=hidden name=oldIds id=oldIds value="<%=oldIds%>">
</FORM>

		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

<script language=javascript>
function onChangeSharetype(){
	var thisvalue=$GetEle("sharetype").value;	
    var strAlert= ""
	if(thisvalue==1 || thisvalue==2 || thisvalue==3 || thisvalue==4){//需要浏览框
		$GetEle("showspan").style.display='';	//浏览框
		$GetEle("relatedid").value="";
		$GetEle("showrelatedname").innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";
	}else{
		$GetEle("showspan").style.display='none';	//不需要浏览框
	}
	if(thisvalue != 4){
		$GetEle("rolelevel_tr").style.display='none';	//角色级别
		$GetEle("rolelevel_line").style.display='none';	
	}else{
		$GetEle("rolelevel_tr").style.display='';	//需要角色级别
		$GetEle("rolelevel_line").style.display='';	
	}
	if(thisvalue == 1){//人员不需要安全级别
		$GetEle("showlevel_tr").style.display='none';	//安全级别
		$GetEle("showlevel_line").style.display='none';
	}else{
		$GetEle("showlevel_tr").style.display='';	//安全级别
		$GetEle("showlevel_line").style.display='';
	}
}


function onShowRelated(inputname,spanname){
	var sharetype = $G("sharetype").value;
	var datas = "";
	if(sharetype == '1'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+inputname.value);
	}else if(sharetype == '2'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+inputname.value+"&selectedDepartmentIds="+inputname.value);
	}else if(sharetype == '3'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+inputname.value);
	}else if(sharetype == '4'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp");
	}
	if(datas){
		var ids = "";
		var names = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		if(datas.id != ''){
			if(sharetype != '4'){
				ids = datas.id.substring(1);
				names = datas.name.substring(1);
			}else{
				ids = datas.id;
				names = datas.name;
			}
			inputname.value = ids;
			spanname.innerHTML = names;
		}else{
			inputname.value = ids;
			spanname.innerHTML = names;
		}
	}
}


function addValue(){
	thisvalue=$GetEle("sharetype").value;
	var shareTypeValue = thisvalue;
	var shareTypeText = $GetEle("sharetype").options.item($GetEle("sharetype").selectedIndex).text;
	//人力资源(1),分部(2),部门(3),角色后的那个选项值不能为空(4)
	var relatedids="0";
	var relatedShareNames="";
	if (thisvalue==1||thisvalue==2||thisvalue==3||thisvalue==4) {
	    if(!check_form(document.weaver,'relatedid')) {
	        return ;
	    }
	    if (thisvalue == 4){
	        if (!check_form(document.weaver,'rolelevel'))
	            return;
	    }
	    relatedids = $GetEle("relatedid").value;
	    relatedShareNames= $GetEle("showrelatedname").innerHTML;
	}
	if(thisvalue != 1){
    	if (!check_form(document.weaver,'showlevel'))
            return;
    }
	var showlevelValue="0";
	var showlevelText="";
	if (thisvalue!=1) {
	    showlevelValue = $GetEle("showlevel").value;
	    showlevelText = showlevelValue;
	}
	var rolelevelValue=0;
	var rolelevelText="";
	if (thisvalue==4){  //角色  0:部门   1:分部  2:总部
	   	rolelevelValue = $GetEle("rolelevel").value;
	    	rolelevelText = $GetEle("rolelevel").options.item($GetEle("rolelevel").selectedIndex).text;
	}
	
	var righttypeValue =  $GetEle("righttype").value;
	var righttypelText = $GetEle("righttype").options.item($GetEle("righttype").selectedIndex).text;
	
	//共享类型 + 共享者ID +共享角色级别 +共享级别+共享权限+下载权限(TD12005)
	var totalValue=shareTypeValue+"_"+relatedids+"_"+rolelevelValue+"_"+showlevelValue+"_"+righttypeValue+"_"+righttypelText;
	var oRow = oTable.insertRow(-1);
	var oRowIndex = oRow.rowIndex;
	
	if (oRowIndex%2==0) oRow.className="dataLight";
	else oRow.className="dataDark";
	
	for (var i =1; i <=6; i++) {   //生成一行中的每一列
		oCell = oRow.insertCell(-1);
		var oDiv = document.createElement("div");
		if (i==1) oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='chkShareDetail' value='"+totalValue+"'><input type='hidden' name='txtShareDetail' value='"+totalValue+"'>";
		else if (i==2) oDiv.innerHTML=shareTypeText;
		else  if (i==3) oDiv.innerHTML=relatedShareNames;
		else  if (i==4) oDiv.innerHTML=rolelevelText;
		else  if (i==5) {if (showlevelText=="0") showlevelText=""; oDiv.innerHTML=showlevelText;}
		else  if (i==6) oDiv.innerHTML=righttypelText;
		oCell.appendChild(oDiv);
	}
}

function removeValue(){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=chks.length-1;i>=0;i--){
        var chk = chks[i];
        if (chk.checked)
            oTable.deleteRow(chk.parentElement.parentElement.parentElement.rowIndex)
    }
}

function chkAllClick(obj){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        chk.checked=obj.checked;
    }
}

function doSave(obj){
    obj.disabled=true;
    weaver.submit();
}
</script>

</BODY>
</HTML>
