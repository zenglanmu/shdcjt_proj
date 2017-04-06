<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.system.code.*"%>
<%@ page import="weaver.docs.category.security.AclManager" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />
<jsp:useBean id="DocMouldComInfo1" class="weaver.docs.mouldfile.DocMouldComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script src="/js/prototype.js" type="text/javascript"></script>
</HEAD>

<%
	String id = Util.null2String(request.getParameter("id"));
    RecordSet.executeProc("Doc_SecCategory_SelectByID",id+"");
	RecordSet.next();
	String subcategoryid=RecordSet.getString("subcategoryid");
	int mainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(subcategoryid),0);
	//初始值
    boolean hasSubManageRight = false;
	boolean hasSecManageRight = false;
	AclManager am = new AclManager();
	hasSubManageRight = am.hasPermission(mainid, AclManager.CATEGORYTYPE_MAIN, user, AclManager.OPERATION_CREATEDIR);
	hasSecManageRight = am.hasPermission(Integer.parseInt(subcategoryid.equals("")?"-1":subcategoryid), AclManager.CATEGORYTYPE_SUB, user, AclManager.OPERATION_CREATEDIR);

    boolean canEdit = false;
	if (HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit",user) || hasSubManageRight || hasSecManageRight) {
		canEdit = true;
	}

    String isUseET=BaseBean.getPropValue("weaver_obj","isUseET");
%>
<BASE TARGET="_parent">
<BODY >
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
  //菜单
  if (canEdit){
	  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
	  RCMenuHeight += RCMenuHeightStep ;
  }
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM METHOD="POST" name="frmTemplet" ACTION="DocSecCategoryTempletOperation.jsp">
<input type="hidden" name="isedit" id="isedit" value="0">
<INPUT TYPE="hidden" NAME="method" id="method" VALUE="save">
<INPUT TYPE="hidden" NAME="secCategoryId"  id="secCategoryId" value="<%=id%>">
<input type="hidden" name="dMouldType"  id="dMouldType" value="" />
<input type="hidden" name="dIsDefault" id="dIsDefault" value="" />
<input type="hidden" name="dMouldBind" id="dMouldBind" value="" />
		<table class="viewForm">
			<COLGROUP>
			<COL width="25%">
			<COL width="75%">
			<TBODY>
			<TR class=Title>
				<TH><%=SystemEnv.getHtmlLabelName(16448,user.getLanguage())%></TH>
				<TH><%if(canEdit){%><div align="right"><BUTTON Class=Btn type=button accessKey=A onclick="addrow()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON></div><%}%></TH>
			</TR>
			<TR class=Spacing style="height: 1px">
            	<TD class=Line1 colSpan=2></TD>
			</TR>
			</TBODY>
		</table>
		
		<TABLE width=100% class=ListStyle cellspacing=1 id=inputface>
		<TBODY>
		<COLGROUP>
		<col width="20%">
		<col width="30%">
		<col width="*">
		<col width="20%">
		<col width="15%">
		<col width="*">
		<THEAD>
		    <TR class=Header>
		        <th><%=SystemEnv.getHtmlLabelName(19471, user.getLanguage())%></th>
		        <th><%=SystemEnv.getHtmlLabelName(19472, user.getLanguage())%></th>
		        <th><%=SystemEnv.getHtmlLabelName(149, user.getLanguage())%></th>
		        <th><%=SystemEnv.getHtmlLabelName(19473, user.getLanguage())%></th>
		        <th><%=SystemEnv.getHtmlLabelName(19480, user.getLanguage())%></th>
		        <th><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></th>
		    </TR>
		    <TR class=Line><TD colspan="6"></TD></TR>
		</THEAD>
		<%
		RecordSet.executeSql("select * from DocSecCategoryMould where secCategoryId = "+id+" order by id ");
		int i=0;
		while(RecordSet.next()){
			i++;
			int cId = Util.getIntValue(Util.null2o(RecordSet.getString("id")));
			int cSecCategoryId = Util.getIntValue(Util.null2o(RecordSet.getString("secCategoryId")));
			int cMouldType = Util.getIntValue(Util.null2o(RecordSet.getString("mouldType")));
			int cMouldId = Util.getIntValue(Util.null2o(RecordSet.getString("mouldId")));
			int cIsDefault = Util.getIntValue(Util.null2o(RecordSet.getString("isDefault")));
			int cMouldBind = Util.getIntValue(Util.null2o(RecordSet.getString("mouldBind")));
		%>
		<TR class="<%=((i % 2) == 0)?"datadark":"datalight"%>">
			<TD style="border-bottom:silver 1pt solid">
			   	<select name="mouldType" onChange="onChangeMould(this);" <%if(!canEdit){%>disabled<%}%>>
				  <option value="1" <%=(cMouldType==1)?"selected":""%>><%=SystemEnv.getHtmlLabelName(19474, user.getLanguage())%></option>
					<option value="2" <%=(cMouldType==2)?"selected":""%>><%=SystemEnv.getHtmlLabelName(19475, user.getLanguage())%></option>
					<option value="3" <%=(cMouldType==3)?"selected":""%>><%=SystemEnv.getHtmlLabelName(19476, user.getLanguage())%></option>
					<option value="4" <%=(cMouldType==4)?"selected":""%>><%=SystemEnv.getHtmlLabelName(19477, user.getLanguage())%></option>
<!--					<option value="5" <%=(cMouldType==5)?"selected":""%>><%=SystemEnv.getHtmlLabelName(22313, user.getLanguage())%></option>-->
					<option value="6" <%=(cMouldType==6)?"selected":""%>><%=SystemEnv.getHtmlLabelName(22314, user.getLanguage())%></option>
					<option value="7" <%=(cMouldType==7)?"selected":""%>><%=SystemEnv.getHtmlLabelName(22361, user.getLanguage())%></option>
					<option value="8" <%=(cMouldType==8)?"selected":""%>><%=SystemEnv.getHtmlLabelName(22362, user.getLanguage())%></option>
<%if("1".equals(isUseET)){%>
<!--					<option value="9" <%=(cMouldType==9)?"selected":""%>>WPS表格显示模板</option>-->
					<option value="10" <%=(cMouldType==10)?"selected":""%>><%=SystemEnv.getHtmlLabelName(24546, user.getLanguage())%></option>
<%}%>
			    </select>
				<input type="hidden" name="id" value="<%=cId%>">
				<input type="hidden" name="mouldType<%=cId%>" value=<%=cMouldType%> />
			</TD>
			<TD style="border-bottom:silver 1pt solid">
				<%if(canEdit){%>
					 <button class=browser onclick="onShowMould(this)" type="button"></button> 
					
				<%}%>
				<span id=selectmouldspan>
				<a style='cursor:pointer' onclick='gotoMouldNew(<%=cMouldType%>,<%=cMouldId%>);'>
				<%if(cMouldType==1||cMouldType==3||cMouldType==5||cMouldType==7){ %>
				<%=DocMouldComInfo.getDocMouldname(""+cMouldId)%>
				<% } else { %>
				<%=DocMouldComInfo1.getDocMouldname(""+cMouldId)%>
				<% } %>
				</a>
				</span>
				<input type=hidden name="mouldId" value="<%=cMouldId%>">	        
			</TD>
			<TD style="border-bottom:silver 1pt solid">
			  	<INPUT class=InputStyle type=checkbox value="<%=cId%>" name="isDefault" <%=(cIsDefault==1)?"checked":""%> style="display:<%=(cMouldBind!=1)?"none":""%>" onclick="onCheckIsDefault(this);" <%if(!canEdit){%>disabled<%}%>>
			  	<INPUT class=InputStyle type=checkbox name="isDefault_disabled" disabled style="display:<%=(cMouldBind!=1)?"":"none"%>" <%if(!canEdit){%>disabled<%}%>>
			</TD>
			<TD style="border-bottom:silver 1pt solid">
			  	<select name="mouldBind" onChange="onChangeBind(this);" style="display:" <%if(!canEdit){%>disabled<%}%>>
				  	<option value="1" <%=(cMouldBind==1)?"selected":""%>><%=SystemEnv.getHtmlLabelName(166, user.getLanguage())%></option>
					<option value="2" <%=(cMouldBind==2)?"selected":""%>><%=SystemEnv.getHtmlLabelName(19478, user.getLanguage())%></option>
					<option value="3" <%=(cMouldBind==3)?"selected":""%>><%=SystemEnv.getHtmlLabelName(19479, user.getLanguage())%></option>
				</select>
			  	<select name="mouldBind_disabled" disabled style="display:none" <%if(!canEdit){%>disabled<%}%>>
				  	<option value="1" <%=(cMouldBind==1)?"selected":""%>><%=SystemEnv.getHtmlLabelName(166, user.getLanguage())%></option>
					<option value="2" <%=(cMouldBind==2)?"selected":""%>><%=SystemEnv.getHtmlLabelName(19478, user.getLanguage())%></option>
					<option value="3" <%=(cMouldBind==3)?"selected":""%>><%=SystemEnv.getHtmlLabelName(19479, user.getLanguage())%></option>
				</select>
				<input type="hidden" name="mouldBind<%=cId%>" value="<%=cMouldBind%>" />
			</TD>
			<TD style="border-bottom:silver 1pt solid">
				&nbsp;<%if(canEdit){%><a style='cursor:pointer;display:<%=(cMouldType==3)?"":"none"%>' onclick="contentSet(this);"><%=SystemEnv.getHtmlLabelName(19480, user.getLanguage())%></a><%}%>
			</TD>
			<TD style="border-bottom:silver 1pt solid">
				<%if(canEdit){%><a style='cursor:pointer' onclick="deleteRow(this);"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></a><%}%>
			</TD>
		</TR>
		<% } %>
		</TBODY>
		</TABLE>

<div id="message_table_Div" style='padding:3px;display:none'></div>

<script>
jQuery(document).ready(function(){

	//jQuery(".wuiBrowser").modalDialog();
	
})
function bindUrl(opts,e){
	var obj = e.srcElement||e.target;
	var openmouldurl = new Array(10)
	openmouldurl[0] = "/docs/mould/DocMouldBrowser.jsp?doctype=.htm"
	openmouldurl[1] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.htm"
	openmouldurl[2] = "/docs/mould/DocMouldBrowser.jsp?doctype=.doc"
	openmouldurl[3] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.doc"
	openmouldurl[4] = "/docs/mould/DocMouldBrowser.jsp?doctype=.xls"
	openmouldurl[5] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.xls"
	openmouldurl[6] = "/docs/mould/DocMouldBrowser.jsp?doctype=.wps"
	openmouldurl[7] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.wps"
	openmouldurl[8] = "/docs/mould/DocMouldBrowser.jsp?doctype=.et"
	openmouldurl[9] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.et"
		//alert(jQuery("#"+id).attr("tagName"))
		//alert(jQuery("#"+id).parent().parent().children(":first").children(":first").val())
	opts._url = openmouldurl[jQuery(obj).parent().parent().children(":first").children(":first").val()-1];
	
	//alert(jQuery("#"+id).attr("_url"));
	//jQuery(".wuiBrowser").modalDialog();
}



function showPrompt(content,show){
    var message_table_Div  = document.getElementById("message_table_Div");
    if(show){
        message_table_Div.style.display="";
        message_table_Div.innerHTML=content;
    } else {
        message_table_Div.style.display="none";
    }
}

function addrow(){
  jQuery('#isedit').val("1");
  var url = 'DocSecCategoryTempletOperation.jsp';
  var pars = 'secCategoryId=<%=id%>&mouldType=1&mouldId=0&isDefault=0&mouldBind=1&method=add';
  
  showPrompt("<%=SystemEnv.getHtmlLabelName(19205, user.getLanguage())%>",true);
  
  var myAjax = new Ajax.Request(
	url,
	{method: 'post', parameters: pars, onComplete: doAddrow}
  );
}

function doAddrow(req){
	var id = req.responseXML.getElementsByTagName('id')[0].firstChild.data;
	
	var oRow;
	var oCell;
	
	var inputface = document.getElementById("inputface");
	
	oRow = inputface.insertRow(-1);
	
	if(inputface.rows.length % 2==0)
		oRow.className = "datadark";
	else
		oRow.className = "datalight";
	
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
    oCell.style.padding="10px 5px";
	oCell.innerHTML = flable1.innerHTML.replace("#value#",id);
	
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
    oCell.style.padding="10px 5px";
	oCell.innerHTML = flable2.innerHTML;
	
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
    oCell.style.padding="10px 5px";
	oCell.innerHTML = flable3.innerHTML.replace("#value#",id) ;
	
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
    oCell.style.padding="10px 5px";
	oCell.innerHTML = flable4.innerHTML.replace("#value#",id) ;
	
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
    oCell.style.padding="10px 5px";
    oCell.innerHTML = flable5.innerHTML ;
    
	oCell = oRow.insertCell(-1);
    oCell.style.borderBottom="silver 1pt solid";
    oCell.style.padding="10px 5px";
	oCell.innerHTML = flable6.innerHTML ;

	showPrompt("",false);

	checkAdd(jQuery(oRow).children("::eq(3)").children(":first"));
}

function checkAdd(obj){
	//新增行的初始数据固定
	//alert(0)
	//var trobj = obj.parentElement;
	//while(trobj.tagName!="TR") trobj = trobj.parentElement;
	var trobj = jQuery(obj).parents("tr:first");
	var inputface = document.getElementById("inputface");
	
	//var row = inputface.rows.length;
	jQuery("#inputface").children("tr").each(function(i,obj){

		if(i<2) return true;
		if(obj==trobj) return true;
		if(jQuery(obj).children("::eq(3)")==undefined) return true;
		if(jQuery(obj).children("::eq(3)").children(":first")==undefined) return true;

		var mouldType = jQuery(obj).children("::eq(0)").children(":first").val();
		var isDefault = jQuery(obj).children("::eq(2)").children(":first").attr("checked");
		var mouldBind = jQuery(obj).children("::eq(3)").children(":first").val();
		if(mouldType != 1){
			return true;
		}
		if(mouldType == '1' && isDefault == true){
			jQuery(trobj).children("::eq(2)").children(":first").attr("checked",false);
			jQuery(trobj).children("::eq(2)").children("::eq(1)").attr("checked",false);
			//trobj.children(2).children(1).checked = false;
			jQuery(trobj).children("::eq(2)").children(":first").hide();
			jQuery(trobj).children("::eq(2)").children("::eq(1)").css("display","");
			//trobj.children(2).children(0).style.display = "none";
			//trobj.children(2).children(1).style.display = "";
			//break;
			return false;
		}
		if(mouldType == '1' && mouldBind == '2'){
			jQuery(trobj).children("::eq(2)").children(":first").attr("checked",false);
			jQuery(trobj).children("::eq(2)").children("::eq(1)").attr("checked",false);
			//trobj.children(2).children(0).checked = false;
			//trobj.children(2).children(1).checked = false;
			jQuery(trobj).children("::eq(2)").children(":first").hide();
			jQuery(trobj).children("::eq(2)").children("::eq(1)").css("display","");
			//trobj.children(2).children(0).style.display = "none";
			//trobj.children(2).children(1).style.display = "";
			jQuery(trobj).children("::eq(3)").children(":first").val("1");
			jQuery(trobj).children("::eq(3)").children("::eq(2)").val("1");
			//trobj.children(3).children(0).style.display = "none";
			//trobj.children(3).children(1).style.display = "";
			
			jQuery(trobj).children("::eq(3)").children(":first").hide();
			jQuery(trobj).children("::eq(3)").children("::eq(1)").css("display","");
			//break;
			return false;
		}
	})
}

function deleteRow(obj){
if(isdel()){
  jQuery('#isedit').val("1");
  var id = jQuery(obj).parent().parent().children(":first").children("::eq(1)").val();//parentElement.parentElement.children(0).children(1).value;

  var mouldType = jQuery(obj).parent().parent().children(":first").children("::eq(0)").val();//obj.parentElement.parentElement.children(0).children(0).value;
  var mouldId = jQuery(obj).parent().parent().children("::eq(1)").children("::eq(2)").val();//obj.parentElement.parentElement.children(1).children(2).value;
  mouldId = 0
  //预处理3个暂存input，保存将被删除的行的信息 Start
  document.frmTemplet.dMouldType.value = jQuery(obj).parent().parent().children(":first").children(":first").val();
  if(jQuery(obj).parent().parent().children("::eq(2)").children("::eq(0)").attr("checked") == true){
		document.frmTemplet.dIsDefault.value = '1';
  }else{
	  document.frmTemplet.dIsDefault.value = '0';
  }
 document.frmTemplet.dMouldBind.value = jQuery(obj).parent().parent().children("::eq(3)").children(":first").val();
 //预处理3个暂存input，保存将被删除的行的信息 End
 id = jQuery.trim(id)
 
  var url = 'DocSecCategoryTempletOperation.jsp';
  var pars = 'id='+id+'&method=delete&mouldType='+mouldType+'&mouldId='+mouldId+'&secCategoryId=<%=id%>';
  
  showPrompt("<%=SystemEnv.getHtmlLabelName(19205, user.getLanguage())%>",true);
  
  var myAjax = new Ajax.Request(
	url,
	{method: 'post', parameters: pars, onComplete: doDeleteRow}
  );
}
}

function doDeleteRow(req){
	//alert(req)
	var id = req.responseXML.getElementsByTagName('id')[0].firstChild.data.replace(/(^\s*)|(\s*$)/g,"");
	id = jQuery.trim(id);
	var arrayinputid = document.frmTemplet.id;
	
	var obj = null;
	if(arrayinputid!=null){
		if(arrayinputid.value!=null){
			obj = arrayinputid;
		} else {
			
			for(var i=0;i<arrayinputid.length;i++){
				//alert(arrayinputid[i].value+"%%%"+id)
				if(jQuery.trim(arrayinputid[i].value)==id)
					obj = arrayinputid[i];
			}
		}
	}
	
	if(obj!=null){
		obj = jQuery(obj).parents("tr:first");
		obj.remove();
	}

	showPrompt("",false);
	
	checkDelete(document.frmTemplet.id[0]);
	
}

function checkDelete(obj){
	
	
	var inputface = document.getElementById("inputface");
	var trobj = jQuery(obj).parents("tr:first");
	
	//while(trobj.tagName!="TR") trobj =  jQuery(trobj).parent();
	
	if(document.frmTemplet.dIsDefault.value == '1'){//被删除项原来是默认模板绑定
		var row = inputface.rows.length;
		for(var i=2; i<=row; i++){
			if(jQuery(inputface).find("::eq("+i+")") == undefined){
				continue;
			}
			if(jQuery(inputface).find("::eq("+i+")").children("::eq(0)") == undefined){
				continue;
			}
			if(jQuery(inputface).find("::eq("+i+")").children("::eq(0)").children("::eq(0)") == undefined){
				continue;
			}
			var mouldType = jQuery(inputface).find("::eq("+i+")").children("::eq(0)").children("::eq(0)").val();
			var isDefault = jQuery(inputface).find("::eq("+i+")").children("::eq(2)").children("::eq(0)").attr("checked");
			var mouldBind = jQuery(inputface).find("::eq("+i+")").children("::eq(3)").children("::eq(0)").val();
			if(mouldType == document.frmTemplet.dMouldType.value){
				jQuery(inputface).find("::eq("+i+")").children("::eq(2)").children("::eq(0)").attr("checked",false);
				jQuery(inputface).find("::eq("+i+")").children("::eq(2)").children("::eq(1)").attr("checked",false);
				
				//inputface.rows(i).cells(2).children(1).checked = false;
				jQuery(inputface).find("::eq("+i+")").children("::eq(2)").children("::eq(0)").css("display","");
				jQuery(inputface).find("::eq("+i+")").children("::eq(2)").children("::eq(1)").hide()
				
				//inputface.rows(i).cells(2).children(0).style.display = "";
				//inputface.rows(i).cells(2).children(1).style.display = "none";
			}
		}
	}
	
	//alert(document.frmTemplet.dMouldBind.value);
	if(document.frmTemplet.dMouldBind.value == '2'){//被删除项原来是正常模板绑定 mouldBind==2
		var row = inputface.rows.length;
		for(var i=2; i<=row; i++){
			if(jQuery(inputface).find("::eq("+i+")") == undefined){
				continue;
			}
			if(jQuery(inputface).find("::eq("+i+")").children("::eq(0)") == undefined){
				continue;
			}
			if(jQuery(inputface).find("::eq("+i+")").children("::eq(0)").children("::eq(0)") == undefined){
				continue;
			}
			var mouldType = jQuery(inputface).find("::eq("+i+")").children("::eq(0)").children("::eq(0)").val();
			var isDefault = jQuery(inputface).find("::eq("+i+")").children("::eq(2)").children("::eq(0)").attr("checked");
			var mouldBind = jQuery(inputface).find("::eq("+i+")").children("::eq(3)").children("::eq(0)").val();
			
			if(mouldType == document.frmTemplet.dMouldType.value){
				//inputface.rows(i).cells(2).children(0).checked = false;
				jQuery(inputface).find("::eq("+i+")").children("::eq(2)").children("::eq(0)").attr("checked",false);
				jQuery(inputface).find("::eq("+i+")").children("::eq(2)").children("::eq(1)").attr("checked",false);
				//inputface.rows(i).cells(2).children(1).checked = false;
				jQuery(inputface).find("::eq("+i+")").children("::eq(2)").children("::eq(0)").css("display","");
				jQuery(inputface).find("::eq("+i+")").children("::eq(2)").children("::eq(1)").hide();
				//inputface.rows(i).cells(2).children(0).style.display = "";
				//inputface.rows(i).cells(2).children(1).style.display = "none";
				jQuery(inputface).find("::eq("+i+")").children("::eq(3)").children("::eq(0)").val("1");
				//inputface.rows(i).cells(3).children(0).value = '1';
				jQuery(inputface).find("::eq("+i+")").children("::eq(3)").children("::eq(1)").val("1")
				//inputface.rows(i).cells(3).children(1).value = inputface.rows(i).cells(3).children(0).value;
				jQuery(inputface).find("::eq("+i+")").children("::eq(3)").children("::eq(2)").val("1")
				//inputface.rows(i).cells(3).children(2).value = inputface.rows(i).cells(3).children(0).value;
				//inputface.rows(i).cells(3).children(0).style.display = "";
				jQuery(inputface).find("::eq("+i+")").children("::eq(3)").children("::eq(0)").css("display","");
				jQuery(inputface).find("::eq("+i+")").children("::eq(3)").children("::eq(1)").hide();
				//inputface.rows(i).cells(3).children(1).style.display = "none";
			}
		}
	}
}

function gotoMould(d,id){
	if(($('isedit').value=="1"&&window.confirm("<%=SystemEnv.getHtmlLabelName(18407, user.getLanguage())%>"))||$('isedit').value=="0"){
		if(d==1){
			window.parent.location = "/docs/mould/DocMouldDsp.jsp?id="+id;
		} else if(d==2){
			window.parent.location = "/docs/mouldfile/DocMouldDsp.jsp?id="+id+"&urlfrom=";
		} else if(d==3){
			window.parent.location = "/docs/mould/DocMouldDspExt.jsp?id="+id;
		} else if(d==4){
			window.parent.location = "/docs/mouldfile/DocMouldDsp.jsp?id="+id+"&urlfrom=";
		} else if(d==5){
			window.parent.location = "/docs/mould/DocMouldDspExt.jsp?id="+id;
		} else if(d==6){
			window.parent.location = "/docs/mouldfile/DocMouldDsp.jsp?id="+id+"&urlfrom=";
		} else if(d==7){
			window.parent.location = "/docs/mould/DocMouldDspExt.jsp?id="+id;
		} else if(d==8){
			window.parent.location = "/docs/mouldfile/DocMouldDsp.jsp?id="+id+"&urlfrom=";
		} else if(d==9){
			window.parent.location = "/docs/mould/DocMouldDspExt.jsp?id="+id;
		} else if(d==10){
			window.parent.location = "/docs/mouldfile/DocMouldDsp.jsp?id="+id+"&urlfrom=";
		}
	}
}

function gotoMouldNew(d,id){
	if(($('isedit').value=="1"&&window.confirm("<%=SystemEnv.getHtmlLabelName(18407, user.getLanguage())%>"))||$('isedit').value=="0"){
		if(d==1){
			window.open("/docs/mould/DocMouldDsp.jsp?id="+id);
		} else if(d==2){
			window.open("/docs/mouldfile/DocMouldDsp.jsp?id="+id+"&urlfrom=");
		} else if(d==3){
			window.open("/docs/mould/DocMouldDspExt.jsp?id="+id);
		} else if(d==4){
			window.open("/docs/mouldfile/DocMouldDsp.jsp?id="+id+"&urlfrom=");
		} else if(d==5){
			window.open("/docs/mould/DocMouldDspExt.jsp?id="+id);
		} else if(d==6){
			window.open("/docs/mouldfile/DocMouldDsp.jsp?id="+id+"&urlfrom=");
		} else if(d==7){
			window.open("/docs/mould/DocMouldDspExt.jsp?id="+id);
		} else if(d==8){
			window.open("/docs/mouldfile/DocMouldDsp.jsp?id="+id+"&urlfrom=");
		} else if(d==9){
			window.open("/docs/mould/DocMouldDspExt.jsp?id="+id);
		} else if(d==10){
			window.open("/docs/mouldfile/DocMouldDsp.jsp?id="+id+"&urlfrom=");
		}
	}
}

function onCheckIsDefault(obj){
	document.frmTemplet.dMouldType.value = obj.parentElement.parentElement.children(0).children(2).value;
	obj.parentElement.parentElement.children(0).children(2).value = obj.parentElement.parentElement.children(0).children(0).value;
	if(obj.parentElement.parentElement.children(2).children(0).checked == true){
		document.frmTemplet.dIsDefault.value = '1';
	}else{
		document.frmTemplet.dIsDefault.value = '0';
	}
	document.frmTemplet.dMouldBind.value = obj.parentElement.parentElement.children(3).children(2).value;
	obj.parentElement.parentElement.children(3).children(2).value = obj.parentElement.parentElement.children(3).children(0).value;
	var trobj = obj.parentElement;
	
	var inputface = document.getElementById("inputface");
	
	while(trobj.tagName!="TR") trobj = trobj.parentElement;
	var row = inputface.rows.length;
	for(var i=2; i<=row; i++){
		if(inputface.rows(i) == undefined){
			continue;
		}
		if(inputface.rows(i) == trobj){
			continue;
		}
		if(inputface.rows(i).cells(0) == undefined){
			continue;
		}
		if(inputface.rows(i).cells(0).childNodes[0] == undefined){
			continue;
		}
		var mouldType = inputface.rows(i).cells(0).children(0).value;
		var isDefault = inputface.rows(i).cells(2).children(0).checked;
		var mouldBind = inputface.rows(i).cells(3).children(0).value;
		if(mouldType == document.frmTemplet.dMouldType.value){
			if(mouldBind != '3' && document.frmTemplet.dIsDefault.value == '1' && inputface.rows(i).cells(2).children(0).style.display == ""){//勾选
				inputface.rows(i).cells(2).children(0).checked = false;
				inputface.rows(i).cells(2).children(1).checked = false;
				inputface.rows(i).cells(2).children(0).style.display = "none";
				inputface.rows(i).cells(2).children(1).style.display = "";
			}else if(mouldBind != '3' && document.frmTemplet.dIsDefault.value == '0' && inputface.rows(i).cells(2).children(0).style.display == "none"){//取消勾选
				inputface.rows(i).cells(2).children(0).checked = false;
				inputface.rows(i).cells(2).children(1).checked = false;
				inputface.rows(i).cells(2).children(0).style.display = "";
				inputface.rows(i).cells(2).children(1).style.display = "none";
			}
		}
	}
}

function onChangeMould(obj){
	jQuery('#isedit').val("1");
	jQuery(obj).parent().parent().children("::eq(1)").children("::eq(1)").html("");
	//obj.parentElement.parentElement.children(1).children(1).innerHTML = "";
	jQuery(obj).parent().parent().children("::eq(1)").children("::eq(2)").val("");
	//obj.parentElement.parentElement.children(1).children(2).value = "";
	if(jQuery(obj).parent().parent().children("::eq(0)").children("::eq(0)").val()==3){
		jQuery(obj).parent().parent().children("::eq(4)").children("::eq(0)").css("display","");
		//obj.parentElement.parentElement.children(4).children(0).style.display = "";
	} else {
		//obj.parentElement.parentElement.children(4).children(0).style.display = "none";
		jQuery(obj).parent().parent().children("::eq(4)").children("::eq(0)").hide();
	}
	//预处理3个暂存input
	document.frmTemplet.dMouldType.value = jQuery(obj).parent().parent().children("::eq(0)").children("::eq(2)").val();
	jQuery(obj).parent().parent().children("::eq(0)").children("::eq(2)").val(jQuery(obj).parent().parent().children("::eq(0)").children("::eq(0)").val());
	if(jQuery(obj).parent().parent().children("::eq(2)").children("::eq(0)").attr("checked") == true){
		document.frmTemplet.dIsDefault.value = '1';
		jQuery(obj).parent().parent().children("::eq(0)").children("::eq(0)").attr("checked",false);
		jQuery(obj).parent().parent().children("::eq(2)").children("::eq(0)").attr("checked",false);
	}else{
		document.frmTemplet.dIsDefault.value = '0';
	}
	document.frmTemplet.dMouldBind.value = jQuery(obj).parent().parent().children("::eq(3)").children("::eq(2)").val();
	jQuery(obj).parent().parent().children("::eq(3)").children("::eq(0)").val("1");
	//obj.parentElement.parentElement.children(3).children(1).value = obj.parentElement.parentElement.children(3).children(0).value;
	//obj.parentElement.parentElement.children(3).children(2).value = obj.parentElement.parentElement.children(3).children(0).value;
	jQuery(obj).parent().parent().children("::eq(3)").children("::eq(1)").val("1");
	jQuery(obj).parent().parent().children("::eq(3)").children("::eq(2)").val("1");
	checkChangeMouldType(obj);
}

function checkChangeMouldType(obj){
	//与删除操作类似，解开被disable的页面元素
	//var trobj = obj.parentElement;
	//while(trobj.tagName!="TR") trobj = trobj.parentElement;
	var trobj = jQuery(obj).parents("tr:first");
	
	//用于标识目的模板类型中，是否已经有默认或正常模板绑定
	var hasIsDefault = false;
	var hasMouldBind2 = false;

	var inputface = document.getElementById("inputface");
	
	var row = inputface.rows.length;

	jQuery("#inputface").children("tr").each(function(i,obj){
		if(i>2) return true;
		if(obj==trobj) return true;
		if(jQuery(obj).children("::eq(0)")==undefined) return true;
		if(jQuery(obj).children("::eq(0)").children(":first")==undefined) return true;
		
		var mouldType = jQuery(obj).children("::eq(0)").children(":first").val();
		var isDefault = jQuery(obj).children("::eq(2)").children(":first").attr("checked");
		var mouldBind = jQuery(obj).children("::eq(3)").children(":first").val();
		if(document.frmTemplet.dIsDefault.value == '1' && mouldType == document.frmTemplet.dMouldType.value){
			jQuery(obj).children("::eq(2)").children(":first").attr("checked",false);
			jQuery(obj).children("::eq(2)").children("::eq(1)").attr("checked",false);
			//inputface.rows(i).cells(2).children(0).checked = false;
			//inputface.rows(i).cells(2).children(1).checked = false;
			jQuery(obj).children("::eq(2)").children(":first").css("display","");
			jQuery(obj).children("::eq(2)").children("::eq(1)").hide();
			//inputface.rows(i).cells(2).children(0).style.display = "";
			//inputface.rows(i).cells(2).children(1).style.display = "none";
		}
		if(document.frmTemplet.dMouldBind.value == '2' && mouldType == document.frmTemplet.dMouldType.value){
			//inputface.rows(i).cells(2).children(0).checked = false;
			//inputface.rows(i).cells(2).children(1).checked = false;
			jQuery(obj).children("::eq(2)").children(":first").attr("checked",false);
			jQuery(obj).children("::eq(2)").children("::eq(1)").attr("checked",false);
			//inputface.rows(i).cells(2).children(0).style.display = "";
			//inputface.rows(i).cells(2).children(1).style.display = "none";
			jQuery(obj).children("::eq(2)").children(":first").css("display","");
			jQuery(obj).children("::eq(2)").children("::eq(1)").hide();
			jQuery(obj).children("::eq(3)").children(":first").val("1");
			jQuery(obj).children("::eq(3)").children("::eq(1)").val("1");
			jQuery(obj).children("::eq(3)").children("::eq(2)").val("1");
			//inputface.rows(i).cells(3).children(0).value = '1';
			//inputface.rows(i).cells(3).children(1).value = inputface.rows(i).cells(3).children(0).value;
			//inputface.rows(i).cells(3).children(2).value = inputface.rows(i).cells(3).children(0).value;
			//inputface.rows(i).cells(3).children(0).style.display = "";
			//inputface.rows(i).cells(3).children(1).style.display = "none";
			jQuery(obj).children("::eq(3)").children(":first").css("display","");
			jQuery(obj).children("::eq(3)").children("::eq(1)").hide();
			if(mouldType == jQuery(trobj).children("::eq(0)").children("::eq(0)").val()){
				if(isDefault == true){
					hasIsDefault = true;
				}
				if(mouldBind == '2'){
					hasMouldBind2 = true;
				}
			}
		}
		
		})
	
	if(hasIsDefault == true && hasMouldBind2 == false){
		jQuery(trobj).children("::eq(2)").children("::eq(0)").attr("checked",false);
		jQuery(trobj).children("::eq(2)").children("::eq(1)").attr("checked",false);
		//trobj.children(2).children(1).checked = false;
		jQuery(trobj).children("::eq(2)").children("::eq(0)").hide();
		jQuery(trobj).children("::eq(2)").children("::eq(1)").css("display","");
		//trobj.children(2).children(0).style.display = "none";
		//trobj.children(2).children(1).style.display = "";
	}else if(hasIsDefault == false && hasMouldBind2 == true){
		//trobj.children(2).children(0).checked = false;
		//trobj.children(2).children(1).checked = false;
		jQuery(trobj).children("::eq(2)").children("::eq(0)").attr("checked",false);
		jQuery(trobj).children("::eq(2)").children("::eq(1)").attr("checked",false);
		//trobj.children(2).children(0).style.display = "none";
		//trobj.children(2).children(1).style.display = "";
		jQuery(trobj).children("::eq(2)").children("::eq(0)").hide();
		jQuery(trobj).children("::eq(2)").children("::eq(1)").css("display","");
		jQuery(trobj).children("::eq(3)").children("::eq(0)").val("1");
		jQuery(trobj).children("::eq(3)").children("::eq(1)").val("1");
		jQuery(trobj).children("::eq(3)").children("::eq(2)").val("1");
		//trobj.children(3).children(0).value = '1';
		//trobj.children(3).children(1).value = trobj.children(3).children(0).value;
		//trobj.children(3).children(2).value = trobj.children(3).children(0).value;
		//trobj.children(3).children(0).style.display = "none";
		//trobj.children(3).children(1).style.display = "";
		jQuery(trobj).children("::eq(3)").children("::eq(0)").hide();
		jQuery(trobj).children("::eq(3)").children("::eq(1)").css("display","");
	}else if(hasIsDefault == false && hasMouldBind2 == false){
		//trobj.children(2).children(0).checked = false;
		//trobj.children(2).children(1).checked = false;
		jQuery(trobj).children("::eq(2)").children("::eq(0)").attr("checked",false);
		jQuery(trobj).children("::eq(2)").children("::eq(1)").attr("checked",false);
		//trobj.children(2).children(0).style.display = "";
		//trobj.children(2).children(1).style.display = "none";
		jQuery(trobj).children("::eq(2)").children("::eq(1)").hide();
		jQuery(trobj).children("::eq(2)").children("::eq(0)").css("display","");
		//trobj.children(3).children(0).value = '1';
		//trobj.children(3).children(1).value = trobj.children(3).children(0).value;
		//trobj.children(3).children(2).value = trobj.children(3).children(0).value;
		jQuery(trobj).children("::eq(3)").children("::eq(0)").val("1");
		jQuery(trobj).children("::eq(3)").children("::eq(1)").val("1");
		jQuery(trobj).children("::eq(3)").children("::eq(2)").val("1");
		//trobj.children(3).children(0).style.display = "";
		//trobj.children(3).children(1).style.display = "none";
		jQuery(trobj).children("::eq(3)").children("::eq(1)").hide();
		jQuery(trobj).children("::eq(3)").children("::eq(0)").css("display","");
	}
}

function onChangeBind(obj){
	jQuery('#isedit').val("1");
	//修改绑定类型会联动check框，所以先保存原来的check框的display类型
	var cdisplay0 = jQuery(obj).parent().parent().children("::eq(2)").children("::eq(0)").css("display");
	var cdisplay1 = jQuery(obj).parent().parent().children("::eq(2)").children("::eq(1)").css("display");
	if(jQuery(obj).parent().parent().children("::eq(3)").children("::eq(0)").val()!=1){
		jQuery(obj).parent().parent().children("::eq(2)").children("::eq(0)").attr("checked",false);
		//obj.parentElement.parentElement.children(2).children(0).disabled = true;
		jQuery(obj).parent().parent().children("::eq(2)").children("::eq(0)").hide();
		jQuery(obj).parent().parent().children("::eq(2)").children("::eq(1)").css("display","");
		//obj.parentElement.parentElement.children(2).children(0).style.display = "none";
		//obj.parentElement.parentElement.children(2).children(1).style.display = "";
	} else {
		//obj.parentElement.parentElement.children(2).children(0).disabled = false;
		jQuery(obj).parent().parent().children("::eq(2)").children("::eq(1)").hide();
		jQuery(obj).parent().parent().children("::eq(2)").children("::eq(0)").css("display","");
		//obj.parentElement.parentElement.children(2).children(0).style.display = "";
		//obj.parentElement.parentElement.children(2).children(1).style.display = "none";
	}
	//预处理3个暂存input
	document.frmTemplet.dMouldType.value = jQuery(obj).parent().parent().children("::eq(0)").children("::eq(2)").val();//存原来的模版类型
	obj.parentElement.parentElement.children(0).children(2).value = jQuery(obj).parent().parent().children("::eq(0)").children("::eq(0)").val();
	if(jQuery(obj).parent().parent().children("::eq(2)").children("::eq(0)").attr("checked") == true){//存原来的默认信息
		document.frmTemplet.dIsDefault.value = '1';
	}else{
		document.frmTemplet.dIsDefault.value = '0';
	}
	document.frmTemplet.dMouldBind.value = jQuery(obj).parent().parent().children("::eq(3)").children("::eq(2)").val();//存原来的绑定类型
	jQuery(obj).parent().parent().children("::eq(3)").children("::eq(2)").val(jQuery(obj).parent().parent().children("::eq(3)").children("::eq(0)").val());

	checkChangeBind(obj, cdisplay0, cdisplay1);
}

function checkChangeBind(obj, cdisplay0, cdisplay1){
	//alert(document.frmTemplet.dMouldType.value);
	//alert(document.frmTemplet.dIsDefault.value);
	//alert(document.frmTemplet.dMouldBind.value);
	//var trobj = obj.parentElement;
	//while(trobj.tagName!="TR") trobj = trobj.parentElement;
	var trobj = jQuery(obj).parents("tr:first");
	var hasMouldBind2 = false;
	var isChange = true;
	//做循环，检查是否需要改变check和selection Start
	
	var inputface = document.getElementById("inputface");
	
	var row = inputface.rows.length;

	jQuery("#inputface").children("tr").each(function(i,obj){
		if(i>2) return true;
		if(obj==trobj) return true;
		if(jQuery(obj).children("::eq(0)")==undefined) return true;
		if(jQuery(obj).children("::eq(0)").children(":first")==undefined) return true;
		
		var mouldType = jQuery(obj).children("::eq(0)").children(":first").val();
		var isDefault = jQuery(obj).children("::eq(2)").children(":first").attr("checked");
		var mouldBind = jQuery(obj).children("::eq(3)").children(":first").val();

		if(mouldType == jQuery(trobj).children("::eq(0)").children("::eq(0)").val() && mouldBind == '3' && jQuery(trobj).children("::eq(3)").children("::eq(0)").val()=='3'){
			alert("<%=SystemEnv.getHtmlLabelName(19507, user.getLanguage())%>");
			if(document.frmTemplet.dIsDefault.value == '1'){//原来是默认绑定
				
				jQuery(trobj).children("::eq(2)").children("::eq(0)").attr("checked","true");
				jQuery(trobj).children("::eq(2)").children("::eq(1)").attr("checked","true");
				//trobj.children(2).children(1).checked = true;
				jQuery(trobj).children("::eq(2)").children("::eq(0)").css("display","");
				jQuery(trobj).children("::eq(2)").children("::eq(1)").hide();
				//trobj.children(2).children(0).style.display = "";
				//trobj.children(2).children(1).style.display = "none";
				jQuery(trobj).children("::eq(3)").children("::eq(0)").val("1");
				jQuery(trobj).children("::eq(3)").children("::eq(1)").val("1");
				jQuery(trobj).children("::eq(3)").children("::eq(2)").val("1");
				//trobj.children(3).children(0).value = '1';
				//trobj.children(3).children(1).value = trobj.children(3).children(0).value;
				//trobj.children(3).children(2).value = trobj.children(3).children(0).value;
				//trobj.children(3).children(0).style.display = "";
				//trobj.children(3).children(1).style.display = "none";
				jQuery(trobj).children("::eq(3)").children("::eq(0)").css("display","");
				jQuery(trobj).children("::eq(3)").children("::eq(1)").hide();
			}else if(document.frmTemplet.dMouldBind.value == '1'){
				//trobj.children(2).children(0).checked = false;
				//trobj.children(2).children(1).checked = false;
				jQuery(trobj).children("::eq(2)").children("::eq(0)").attr("checked",false);
				jQuery(trobj).children("::eq(2)").children("::eq(1)").attr("checked",false);
				//trobj.children(2).children(0).style.display = cdisplay0;
				//trobj.children(2).children(1).style.display = cdisplay1;
				jQuery(trobj).children("::eq(2)").children("::eq(0)").css("display",cdisplay0);
				jQuery(trobj).children("::eq(2)").children("::eq(1)").css("display",cdisplay1);
				//trobj.children(3).children(0).value = '1';
				//trobj.children(3).children(1).value = trobj.children(3).children(0).value;
				//trobj.children(3).children(2).value = trobj.children(3).children(0).value;
				jQuery(trobj).children("::eq(3)").children("::eq(0)").val("1");
				jQuery(trobj).children("::eq(3)").children("::eq(1)").val("1");
				jQuery(trobj).children("::eq(3)").children("::eq(2)").val("1");
				//trobj.children(3).children(0).style.display = "";
				//trobj.children(3).children(1).style.display = "none";
				jQuery(trobj).children("::eq(3)").children("::eq(0)").css("display","");
				jQuery(trobj).children("::eq(3)").children("::eq(1)").hide();
			}else if(document.frmTemplet.dMouldBind.value == '2'){
				//trobj.children(2).children(0).checked = false;
				//trobj.children(2).children(1).checked = false;
				jQuery(trobj).children("::eq(2)").children("::eq(0)").attr("checked",false);
				jQuery(trobj).children("::eq(2)").children("::eq(1)").attr("checked",false);
				//trobj.children(2).children(0).style.display = cdisplay0;
				//trobj.children(2).children(1).style.display = cdisplay1;
				jQuery(trobj).children("::eq(2)").children("::eq(0)").css("display",cdisplay0);
				jQuery(trobj).children("::eq(2)").children("::eq(1)").css("display",cdisplay1);
				//trobj.children(3).children(0).value = '2';
				//trobj.children(3).children(1).value = trobj.children(3).children(0).value;
				//trobj.children(3).children(2).value = trobj.children(3).children(0).value;
				jQuery(trobj).children("::eq(3)").children("::eq(0)").val("2");
				jQuery(trobj).children("::eq(3)").children("::eq(1)").val("2");
				jQuery(trobj).children("::eq(3)").children("::eq(2)").val("2");
				//trobj.children(3).children(0).style.display = "";
				//trobj.children(3).children(1).style.display = "none";
				jQuery(trobj).children("::eq(3)").children("::eq(0)").css("display","");
				jQuery(trobj).children("::eq(3)").children("::eq(1)").hide();
			}
			isChange = false;
			return true;
		}
		if(mouldType == jQuery(trobj).children("::eq(0)").children("::eq(0)").val() && mouldBind == '2' && jQuery(trobj).children("::eq(3)").children("::eq(0)").val()=='2'){
			alert("<%=SystemEnv.getHtmlLabelName(19506, user.getLanguage())%>");
			//mouldBind不能变成2，却变成了2，只能是3->2
			//trobj.children(2).children(0).checked = false;
			//trobj.children(2).children(1).checked = false;
			jQuery(trobj).children("::eq(2)").children("::eq(0)").attr("checked",false);
			jQuery(trobj).children("::eq(2)").children("::eq(1)").attr("checked",false);
			//trobj.children(2).children(0).style.display = cdisplay0;
			//trobj.children(2).children(1).style.display = cdisplay1;
			jQuery(trobj).children("::eq(2)").children("::eq(0)").css("display",cdisplay0);
			jQuery(trobj).children("::eq(2)").children("::eq(1)").css("display",cdisplay1);
			//trobj.children(3).children(0).value = '3';
			//trobj.children(3).children(1).value = trobj.children(3).children(0).value;
			//trobj.children(3).children(2).value = trobj.children(3).children(0).value;
			jQuery(trobj).children("::eq(3)").children("::eq(0)").val("3");
			jQuery(trobj).children("::eq(3)").children("::eq(1)").val("3");
			jQuery(trobj).children("::eq(3)").children("::eq(2)").val("3");
			//trobj.children(3).children(0).style.display = "";
			//trobj.children(3).children(1).style.display = "none";
			jQuery(trobj).children("::eq(3)").children("::eq(0)").css("display","");
			jQuery(trobj).children("::eq(3)").children("::eq(1)").hide();
			isChange = false;
			return true;
		}
		if(mouldType == trobj.children(0).children(0).value && mouldBind == '2'){
			hasMouldBind2 = true;
		}
	})

	//做循环，检查是否需要改变check和selection End
	//确实改变了绑定类型 Start
	if(isChange == true){
		jQuery("#inputface").children("tr").each(function(i,obj){
			if(i>2) return true;
			if(obj==trobj) return true;
			if(jQuery(obj).children("::eq(0)")==undefined) return true;
			if(jQuery(obj).children("::eq(0)").children(":first")==undefined) return true;
			var mouldType = jQuery(obj).children("::eq(0)").children(":first").val();
			var isDefault = jQuery(obj).children("::eq(2)").children(":first").attr("checked");
			var mouldBind = jQuery(obj).children("::eq(3)").children(":first").val();
			if(mouldType != document.frmTemplet.dMouldType.value ||  mouldBind == '3'){//模板类型不同，或者是临时绑定，不改变
				return true;
			}
			if(document.frmTemplet.dMouldBind.value == '2' && (jQuery(trobj).children("::eq(3)").children("::eq(0)").val() == '1' || jQuery(trobj).children("::eq(3)").children("::eq(0)").value == '3')){//2->1的解锁，全解
				//inputface.rows(i).cells(2).children(0).checked = false;//原来有
				//inputface.rows(i).cells(2).children(1).checked = false;
				jQuery(obj).children("::eq(2)").children("::eq(0)").attr("checked",false);
				jQuery(obj).children("::eq(2)").children("::eq(1)").attr("checked",false);
				//inputface.rows(i).cells(2).children(0).style.display = "";
				//inputface.rows(i).cells(2).children(1).style.display = "none";
				jQuery(obj).children("::eq(2)").children("::eq(0)").css("display","");
				jQuery(obj).children("::eq(2)").children("::eq(1)").hide();
				//inputface.rows(i).cells(3).children(0).value = '1';
				//inputface.rows(i).cells(3).children(1).value = inputface.rows(i).cells(3).children(0).value;
				//inputface.rows(i).cells(3).children(2).value = inputface.rows(i).cells(3).children(0).value;
				jQuery(obj).children("::eq(3)").children("::eq(0)").val("1");
				jQuery(obj).children("::eq(3)").children("::eq(1)").val("1");
				jQuery(obj).children("::eq(3)").children("::eq(2)").val("1");
				//inputface.rows(i).cells(3).children(0).style.display = "";
				//inputface.rows(i).cells(3).children(1).style.display = "none";
				jQuery(obj).children("::eq(3)").children("::eq(0)").css("display","");
				jQuery(obj).children("::eq(3)").children("::eq(1)").hide();
			}else if(document.frmTemplet.dMouldBind.value == '1' && jQuery(trobj).children("::eq(3)").children("::eq(0)").val() == '2'){//1->2的关锁，全关
				//inputface.rows(i).cells(2).children(0).checked = false;
				//inputface.rows(i).cells(2).children(1).checked = false;
				jQuery(obj).children("::eq(2)").children("::eq(0)").attr("checked",false);
				jQuery(obj).children("::eq(2)").children("::eq(1)").attr("checked",false);
				//inputface.rows(i).cells(2).children(0).style.display = "none";
				//inputface.rows(i).cells(2).children(1).style.display = "";
				jQuery(obj).children("::eq(2)").children("::eq(1)").css("display","");
				jQuery(obj).children("::eq(2)").children("::eq(0)").hide();
				//inputface.rows(i).cells(3).children(0).value = '1';
				//inputface.rows(i).cells(3).children(1).value = inputface.rows(i).cells(3).children(0).value;
				//inputface.rows(i).cells(3).children(2).value = inputface.rows(i).cells(3).children(0).value;
				jQuery(obj).children("::eq(3)").children("::eq(0)").val("1");
				jQuery(obj).children("::eq(3)").children("::eq(1)").val("1");
				jQuery(obj).children("::eq(3)").children("::eq(2)").val("1");
				//inputface.rows(i).cells(3).children(0).style.display = "none";
				//inputface.rows(i).cells(3).children(1).style.display = "";
				jQuery(obj).children("::eq(3)").children("::eq(1)").css("display","");
				jQuery(obj).children("::eq(3)").children("::eq(0)").hide();
			}else if(document.frmTemplet.dMouldBind.value == '1' && jQuery(trobj).children("::eq(3)").children("::eq(0)").val() == '3'){//1->3 不影响其他的
				//操作留空
			}else if(document.frmTemplet.dMouldBind.value == '3' && jQuery(trobj).children("::eq(3)").children("::eq(0)").val() == '2'){//3->2 关锁
				//inputface.rows(i).cells(2).children(0).checked = false;
				//inputface.rows(i).cells(2).children(1).checked = false;
				jQuery(obj).children("::eq(2)").children("::eq(0)").attr("checked",false);
				jQuery(obj).children("::eq(2)").children("::eq(1)").attr("checked",false);
				//inputface.rows(i).cells(2).children(0).style.display = "none";
				//inputface.rows(i).cells(2).children(1).style.display = "";
				jQuery(obj).children("::eq(2)").children("::eq(1)").css("display","");
				jQuery(obj).children("::eq(2)").children("::eq(0)").hide();
				//inputface.rows(i).cells(3).children(0).value = '1';
				//inputface.rows(i).cells(3).children(1).value = inputface.rows(i).cells(3).children(0).value;
				//inputface.rows(i).cells(3).children(2).value = inputface.rows(i).cells(3).children(0).value;
				jQuery(obj).children("::eq(3)").children("::eq(0)").val("1");
				jQuery(obj).children("::eq(3)").children("::eq(1)").val("1");
				jQuery(obj).children("::eq(3)").children("::eq(2)").val("1");
				
				//inputface.rows(i).cells(3).children(0).style.display = "none";
				//inputface.rows(i).cells(3).children(1).style.display = "";
				jQuery(obj).children("::eq(3)").children("::eq(1)").css("display","");
				jQuery(obj).children("::eq(3)").children("::eq(0)").hide();
			}
			})
		
		if(document.frmTemplet.dMouldBind.value == '3' && jQuery(trobj).children("::eq(3)").children("::eq(0)").val() == '1'){//3->1 不影响其他的，但要判断本身是否该display
			//当存在mouldBind2时，要display
			//因为不影响其他的行，所以不放在循环中
			if(hasMouldBind2 == true){
				//trobj.children(2).children(0).checked = false;
				//trobj.children(2).children(1).checked = false;
				jQuery(trobj).children("::eq(2)").children("::eq(0)").attr("checked",false);
				jQuery(trobj).children("::eq(2)").children("::eq(1)").attr("checked",false);
				//trobj.children(2).children(0).style.display = "none";
				//trobj.children(2).children(1).style.display = "";
				jQuery(trobj).children("::eq(2)").children("::eq(0)").css("display","");
				jQuery(trobj).children("::eq(2)").children("::eq(1)").hide();
				//trobj.children(3).children(0).value = '1';
				//trobj.children(3).children(1).value = trobj.children(3).children(0).value;
				//trobj.children(3).children(2).value = trobj.children(3).children(0).value;
				jQuery(trobj).children("::eq(3)").children("::eq(0)").val("1");
				jQuery(trobj).children("::eq(3)").children("::eq(1)").val("1");
				jQuery(trobj).children("::eq(3)").children("::eq(2)").val("1");
				//trobj.children(3).children(0).style.display = "none";
				//trobj.children(3).children(1).style.display = "";
				jQuery(trobj).children("::eq(3)").children("::eq(0)").css("display","");
				jQuery(trobj).children("::eq(3)").children("::eq(1)").hide();
			}
		}
	}
	//确实改变了绑定类型 End
}

function onCheckMould(obj){
	jQuery('#isedit').val("1");
	onCheckIsDefault(obj);
}

function checkSelection(){
    var flag = true;

	var amouldtype = document.frmTemplet.mouldType;
	var amouldbind = document.frmTemplet.mouldBind;
	var aid = document.frmTemplet.id;
	var amouldid = document.frmTemplet.mouldId;
	var aisdefault = document.frmTemplet.isDefault;

    if(aid!=null&&typeof(aid.length)=="undefined"){
        if(aid.value==0||amouldid.value==0){
            flag = false;
        }
	}
	
    for(var i=0;aid!=null&&aid.length>0&&i<aid.length;i++){
        //checkSave(amouldtype[i]);
		if(aid.length==1){
            if(aid[i].value==0||amouldid.value==0){
                flag = false;
                alert(1)
                break;
            }
		}else{
			
            if(aid[i].value==0||amouldid[i].value==0){
                flag = false;
                break;
            }
		}
    }
    return flag;
}

//function checkSave(obj){


//}

function checkLoad(){
	//alert('Load OK !');
	var hasIsDefault = new Array();
	hasIsDefault[0] = false;
	hasIsDefault[1] = false;
	hasIsDefault[2] = false;
	hasIsDefault[3] = false;
	var hasMouldBind2 = new Array();
	hasMouldBind2[0] = false;
	hasMouldBind2[1] = false;
	hasMouldBind2[2] = false;
	hasMouldBind2[3] = false;
	//做循环，检查4种模板类型是否有默认或正常绑定（可选择和临时绑定不影响同类型其他行） Start
	
	var inputface = document.getElementById("inputface");
	
	var row = inputface.rows.length;
	jQuery("#inputface").children("tr").each(function(i,obj){
		if(i<2) return true;
		if(jQuery(obj).children("::eq(0)")==undefined) return true;
		if(jQuery(obj).children("::eq(0)").children(":first")==undefined) return true;
		var mouldType = jQuery(obj).children("::eq(0)").children(":first").val();
		var isDefault = jQuery(obj).children("::eq(2)").children(":first").attr("checked");
		var mouldBind = jQuery(obj).children("::eq(3)").children(":first").val();
		if(isDefault == true){
			hasIsDefault[mouldType] = true;
		}
		if(mouldBind == '2'){
			hasMouldBind2[mouldType] = true;
		}
	})
	
	jQuery("#inputface").children("tr").each(function(i,obj){
		if(i<2) return true;
		if(jQuery(obj).children("::eq(0)")==undefined) return true;
		if(jQuery(obj).children("::eq(0)").children(":first")==undefined) return true;
		var mouldType = jQuery(obj).children("::eq(0)").children(":first").val();
		var isDefault = jQuery(obj).children("::eq(2)").children(":first").attr("checked");
		var mouldBind = jQuery(obj).children("::eq(3)").children(":first").val();
		if(hasIsDefault[mouldType] == true && isDefault == false && mouldBind == '1'){//同模板类型有默认值，但当前不是默认，并且不是临时绑定
			//inputface.rows(i).cells(2).children(0).checked = false;
			//inputface.rows(i).cells(2).children(1).checked = false;
			jQuery(obj).children("::eq(2)").children(":first").attr("checked",false);
			jQuery(obj).children("::eq(2)").children("::eq(1)").attr("checked",false);
			jQuery(obj).children("::eq(2)").children(":first").hide();
			jQuery(obj).children("::eq(2)").children("::eq(1)").css("display","");
			//inputface.rows(i).cells(2).children(0).style.display = "none";
			//inputface.rows(i).cells(2).children(1).style.display = "";
			//inputface.rows(i).cells(3).children(0).value = '1';
			//inputface.rows(i).cells(3).children(2).value = inputface.rows(i).cells(3).children(0).value;
			//inputface.rows(i).cells(3).children(0).style.display = "";
			//inputface.rows(i).cells(3).children(1).style.display = "none";
		}
		if(hasMouldBind2[mouldType] == true && mouldBind != '2' && mouldBind != '3'){//同模板类型有正常绑定，但当前不是正常绑定，并且不是临时绑定
			//inputface.rows(i).cells(2).children(0).checked = false;
			//inputface.rows(i).cells(2).children(1).checked = false;
			jQuery(obj).children("::eq(2)").children(":first").attr("checked",false);
			jQuery(obj).children("::eq(2)").children("::eq(1)").attr("checked",false);
			//inputface.rows(i).cells(2).children(0).style.display = "none";
			//inputface.rows(i).cells(2).children(1).style.display = "";
			jQuery(obj).children("::eq(2)").children(":first").hide();
			jQuery(obj).children("::eq(2)").children("::eq(1)").css("display","");
			//inputface.rows(i).cells(3).children(0).value = '1';
			//inputface.rows(i).cells(3).children(1).value = inputface.rows(i).cells(3).children(0).value;
			//inputface.rows(i).cells(3).children(2).value = inputface.rows(i).cells(3).children(0).value;
			jQuery(obj).children("::eq(3)").children(":first").val("1");
			jQuery(obj).children("::eq(3)").children("::eq(1)").val("1");
			jQuery(obj).children("::eq(3)").children("::eq(2)").val("1");
			//inputface.rows(i).cells(3).children(0).style.display = "none";
			//inputface.rows(i).cells(3).children(1).style.display = "";
			jQuery(obj).children("::eq(3)").children(":first").hide();
			jQuery(obj).children("::eq(3)").children("::eq(1)").css("display","");
			//break;
		}
	})
	//做循环，检查4种模板类型是否有默认或正常绑定（可选择和临时绑定不影响同类型其他行） End
}

checkLoad();

function onSave(obj){
	if(checkSelection()){
		document.frmTemplet.submit();
		obj.disabled = true;
	} else {
		alert("<%=SystemEnv.getHtmlLabelName(19508, user.getLanguage())%>!");
	}
}

function contentSet(obj){
	
	if((jQuery('#isedit').val() == 1&&window.confirm("<%=SystemEnv.getHtmlLabelName(18407, user.getLanguage())%>"))||jQuery('#isedit').val() == 0){
		window.parent.location = "ContentSetting.jsp?id="+jQuery(obj).parent().parent().children("::eq(0)").children("::eq(1)").val()+"&mould="+jQuery(obj).parent().parent().children("::eq(1)").children("::eq(2)").val()+"&seccategory="+document.frmTemplet.secCategoryId.value;
	}
}


function onShowMould(obj){
	var openmouldurl = new Array(10)
	openmouldurl[0] = "/docs/mould/DocMouldBrowser.jsp?doctype=.htm"
	openmouldurl[1] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.htm"
	openmouldurl[2] = "/docs/mould/DocMouldBrowser.jsp?doctype=.doc"
	openmouldurl[3] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.doc"
	openmouldurl[4] = "/docs/mould/DocMouldBrowser.jsp?doctype=.xls"
	openmouldurl[5] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.xls"
	openmouldurl[6] = "/docs/mould/DocMouldBrowser.jsp?doctype=.wps"
	openmouldurl[7] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.wps"
	openmouldurl[8] = "/docs/mould/DocMouldBrowser.jsp?doctype=.et"
	openmouldurl[9] = "/docs/mouldfile/DocMouldBrowser.jsp?doctype=.et"
		var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_scroll:"auto",
			_displaySelector:"",
			_required:"no",
			_displayText:"",
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	var data = window.showModalDialog(openmouldurl[jQuery(obj).parent().parent().children(":first").children(":first").val()-1],null,"addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	
	jQuery(obj).parent().parent().children("::eq(1)").children("::eq(1)").html( "<a style='cursor:pointer' onclick='gotoMould("+jQuery(obj).parent().parent().children(":first").children(":first").val()+","+data.id+");'>"+data.name+"</a>")
	jQuery(obj).parent().parent().children("::eq(1)").children("::eq(2)").val(data.id)
	frmTemplet.isedit.value = "1"
	
}
</script>

</FORM>

<div style="display:none" id="flable1">
   	<select name="mouldType" onChange="onChangeMould(this);">
   	<option value="1"><%=SystemEnv.getHtmlLabelName(19474, user.getLanguage())%></option>
		<option value="2"><%=SystemEnv.getHtmlLabelName(19475, user.getLanguage())%></option>
		<option value="3"><%=SystemEnv.getHtmlLabelName(19476, user.getLanguage())%></option>
		<option value="4"><%=SystemEnv.getHtmlLabelName(19477, user.getLanguage())%></option>
<!--		<option value="5"><%=SystemEnv.getHtmlLabelName(22313, user.getLanguage())%></option>-->
		<option value="6"><%=SystemEnv.getHtmlLabelName(22314, user.getLanguage())%></option>
		<option value="7"><%=SystemEnv.getHtmlLabelName(22361, user.getLanguage())%></option>
		<option value="8"><%=SystemEnv.getHtmlLabelName(22362, user.getLanguage())%></option>
<%if("1".equals(isUseET)){%>
<!--		<option value="9">WPS表格显示模板</option>-->
		<option value="10"><%=SystemEnv.getHtmlLabelName(24546, user.getLanguage())%></option>
<%}%>
    </select>
	<input type="hidden" name="id" value="#value#">
	<input type="hidden" name="mouldType#value#" value="1" />
</div>

<div style="display:none" id="flable2">
	 <button class=browser onclick="onShowMould(this)" type="button"></button> 
	
	<span id=selectmouldspan></span>
	<input type=hidden name="mouldId" value="">	        
</div>

<div style="display:none" id="flable3">
  	<INPUT class=InputStyle type=checkbox value="#value#" name="isDefault" style="display:;" onclick="onCheckMould(this);">
  	<INPUT class=InputStyle type=checkbox disabled name="isDefault_disabled" style="display:none;">
</div>

<div style="display:none" id="flable4">
  	<select name="mouldBind" onChange="onChangeBind(this);" style="display:">
  		<option value="1"><%=SystemEnv.getHtmlLabelName(166, user.getLanguage())%></option>
		<option value="2"><%=SystemEnv.getHtmlLabelName(19478, user.getLanguage())%></option>
		<option value="3"><%=SystemEnv.getHtmlLabelName(19479, user.getLanguage())%></option>
	</select>
  	<select name="mouldBind_disabled" disabled style="display:none">
  		<option value="1"><%=SystemEnv.getHtmlLabelName(166, user.getLanguage())%></option>
		<option value="2"><%=SystemEnv.getHtmlLabelName(19478, user.getLanguage())%></option>
		<option value="3"><%=SystemEnv.getHtmlLabelName(19479, user.getLanguage())%></option>
	</select>
	<input type="hidden" name="mouldBind#value#" value="1" />
</div>

<div style="display:none" id="flable5">
	&nbsp;<a style='cursor:pointer;display:none' onclick="contentSet(this);"><%=SystemEnv.getHtmlLabelName(19480, user.getLanguage())%></a>
</div>

<div style="display:none" id="flable6">
	<a style='cursor:pointer' onclick="deleteRow(this);"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></a>
</div>

</BODY>
</HTML>