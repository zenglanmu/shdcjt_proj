<%@ page language="java" contentType="text/html; charset=gbk" %>
<%@ page import="weaver.email.domain.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="crm" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="lms" class="weaver.email.service.LabelManagerService" scope="page" />
<jsp:useBean id="fms" class="weaver.email.service.FolderManagerService" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(19828,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";

String showTop = Util.null2String(request.getParameter("showTop"));

String sql = "";
String ruleName = "", matchAll = "", applyTime = "";
int mailAccountId = 0;
int ruleId = Util.getIntValue(request.getParameter("id"));
sql = "SELECT * FROM MailRule WHERE id="+ruleId+"";
rs.executeSql(sql);
if(rs.next()){
	ruleName = rs.getString("ruleName");
	matchAll = rs.getString("matchAll");
	applyTime = rs.getString("applyTime");
	mailAccountId = rs.getInt("mailAccountId");
}
%>

<%if(showTop.equals("")) {%>
	<%@ include file="/systeminfo/TopTitle.jsp" %>
<%} else if(showTop.equals("show800")) {%>
	
<%}%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<script type="text/javascript" src="/js/weaver.js"></script>
<script type="text/javascript" src="/js/prototype.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver.css" />
<script type="text/javascript" src="/js/dojo.js"></script>

<script language="javascript">

dojo.require("dojo.widget.TabSet");
dojo.require("dojo.io.*");
dojo.require("dojo.event.*");

 function  MailRuleSubmit(){
     if(check_form(fMailRule,'ruleName')){
		
		var boo=true;	
		try{
				
		var cSourceArray="";
		var operatorArray="";
		var cTargetArray="";
		var cTargetPriorityArray="";
		var SendDateArray="";
		
		for(var i=1;i<=termsRowlength;i++){
				   if(document.getElementById("cSource"+i)==null){
						continue;
				   }	         
				 cSourceArray+=document.getElementById("cSource"+i).value+",";
			
				  	
				  var operL=document.getElementById("operator"+i+"L").disabled;	
				 
				  var operK=document.getElementById("operator"+i+"K").disabled;
				 
				  var operJ=document.getElementById("operator"+i+"J").disabled;
				 
				  if(operL==false&&operK!=false&&operJ!=false){
				  		
				   		operatorArray+=document.getElementById("operator"+i+"L").value+",";
				  }	
				  if(operK==false&&operL!=false&&operJ!=false){
				  		
				  		operatorArray+=document.getElementById("operator"+i+"K").value+",";
				  }	
				  if(operJ==false&&operL!=false&&operK!=false){
				  		
				  		operatorArray+=document.getElementById("operator"+i+"J").value+",";
				  }	 
				  
				   		cTargetArray+=document.getElementById("cTarget"+i).value+",";
				  								
						cTargetPriorityArray+=document.getElementById("cTargetPriority"+i).value+",";
				  				 				  
						SendDateArray+=document.getElementById("sendDate"+i).value+"a,";
				
				}
		
		document.getElementById("cSource").value = cSourceArray;
		document.getElementById("operator").value = operatorArray;
		document.getElementById("cTarget").value = cTargetArray;
		document.getElementById("cTargetPriority").value = cTargetPriorityArray;
		document.getElementById("SendDateArrayass").value = SendDateArray;
		
		
		
		var aSourceArray="";
		var aTargetFolderIdArray="";
		var aTargetCRMIdArray="";
		var mainIdArray="";
		var subIdArray="";
		var secIdArray="";
		
			for(var j=1;j<=actionRowLength;j++){
				
				if(document.getElementById("aSource"+j)==null){
					continue
				}
					
			  
					aSourceArray+=document.getElementById("aSource"+j).value+",";
				
				
				
					aTargetFolderIdArray+=document.getElementById("aTargetFolderId"+j).value+",";
				
				
				
					aTargetCRMIdArray+=document.getElementById("aTargetCRMId"+j).value+",";
			
				
				
					mainIdArray+=document.getElementById("mainId"+j).value+",";
				
				
				
					subIdArray+=document.getElementById("subId"+j).value+",";
				
				
				
					secIdArray+=document.getElementById("secId"+j).value+",";
				
			}
		
		
		
		document.getElementById("aSource").value = aSourceArray;
		document.getElementById("aTargetFolderId").value = aTargetFolderIdArray;
		document.getElementById("aTargetCRMId").value = aTargetCRMIdArray;
		document.getElementById("mainId").value = mainIdArray;
		document.getElementById("subId").value = subIdArray;
		document.getElementById("secId").value = secIdArray;
		
		var aSourceList=aSourceArray.split(",");
		var aTargetCRMIdList=aTargetCRMIdArray.split(",");
		var aTargetFolderId=aTargetFolderIdArray.split(",");
		for(var i=0;i<aSourceList.length;i++){
			if(aTargetCRMIdList[i]==""&&aSourceList[i]==4){
          	alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
          	boo=false;   
        	}else if(aTargetFolderId[i]==""&&(aSourceList[i]==1||aSourceList[i]==2)){
         	alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
         	boo=false;
         }
        }
		
		
		}catch(e){
			
		}
		
		if(boo){
			fMailRule.submit();
		}
	}
 }
 
 function redirect(url){    
    if(url == "" || url == undefined){
    <%if(showTop.equals("")) {%>
		url = "MailRule.jsp";
	<%} else if(showTop.equals("show800")) {%>
		url = "MailRule.jsp?showTop=show800";
	<%}%>
    }
    window.location.href = url;
 }
 
 
function delrule(thisvalue,thisaction){
   var actionId=0;
   if((confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>"))){
		   if(thisaction=="deleteRuleCondition"){
			     for(var k=document.getElementsByName("rule_1").length-1;k>-1;k--){
			     	var bool=false;
			         if(document.getElementsByName("rule_1")[k].checked==true){
			         	document.getElementById("conditionId").value+=","+document.getElementsByName("rule_1")[k].value; 
			         	if(document.getElementsByName("ck_1")[k].value=="1"){ 		
			          		// termsRowlength--;
			          		 bool=true;
			     		 }
			     		
			     		document.getElementsByName("rule_1")[k].parentNode.parentNode.style.border="#FFFFFF 0px";
			     		//document.getElementsByName("rule_1")[k].parentNode.parentNode.removeNode(document.getElementsByName("rule_1")[k].parentNode);
			     		jQuery(jQuery("input[name=rule_1]")[k]).parent().parent().remove();
			         }
			              
			     }
		   	}
		    if(thisaction=="deleteRuleAction"){
			     for(var k=document.getElementsByName("rule_2").length-1;k>-1;k--){
			     	var bool=false;
			        if(document.getElementsByName("rule_2")[k].checked==true){
			        	document.getElementById("actionId").value+=","+document.getElementsByName("rule_2")[k].value;
			        	if(document.getElementsByName("ck_2")[k].value=="1"){
			          	 	var bool=false;
			        	}
			        	document.getElementsByName("rule_2")[k].parentNode.parentNode.style.border="#FFFFFF 0px";
			        	//document.getElementsByName("rule_2")[k].parentNode.parentNode.removeNode(document.getElementsByName("rule_2")[k].parentNode);
						jQuery(jQuery("input[name=rule_2]")[k]).parent().parent().remove();
			        }
			     }   
	   		}
   	}
}

function onSelectMailInbox(himself,num){
	switch(himself.value) {
	case "1" :
		var _selectInnerHTML_ = 
		'<option value="0">收件箱</option>'+
      	'<option value="-1">发件箱</option>'+
      	'<option value="-2">草稿箱</option>'+
      	'<option value="-3">垃圾箱</option>'
      	<%
		ArrayList<MailFolder> folderList= fms.getFolderManagerList(user.getUID());
		for(int i=0; i<folderList.size();i++){
			MailFolder mf = folderList.get(i);
		%>
		+'<option value="<%=mf.getId() %>"><%=mf.getFolderName() %></option>'
		<%
		}
		%>
		dojo.byId("aTargetFolderId"+num).innerHTML = _selectInnerHTML_;
		break;
	case "2" :
		var _selectInnerHTML_ = 
		'<option value="0">收件箱</option>'+
      	'<option value="-1">发件箱</option>'+
      	'<option value="-2">草稿箱</option>'+
      	'<option value="-3">垃圾箱</option>'
      	<%
		for(int i=0; i<folderList.size();i++){
			MailFolder mf = folderList.get(i);
		%>
		+'<option value="<%=mf.getId() %>"><%=mf.getFolderName() %></option>'
		<%
		}
		%>
		dojo.byId("aTargetFolderId"+num).innerHTML = _selectInnerHTML_;
		break;
	case "6" :
		var _selectInnerHTML_ = 
      	<%
 			ArrayList<MailLabel> lmsList= lms.getLabelManagerList(user.getUID());
			for(int i=0; i<lmsList.size();i++){
			MailLabel ml = lmsList.get(i);
		%>
		+'<option value="<%=ml.getId() %>"><%=ml.getName() %></option>'
		<%
			}
		%>
		dojo.byId("aTargetFolderId"+num).innerHTML = _selectInnerHTML_;
		break;
	default:
		dojo.byId("aTargetFolderId"+num).innerHTML = "";
		break;
	}
}

function getMailInboxFolderName(paramFolderId){
	var folderName = "";
	if(paramFolderId==-1){
		folderName = "<%=SystemEnv.getHtmlLabelName(2038,user.getLanguage())%>";
	}else if(paramFolderId==-2){
		folderName = "<%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%>";
	}else if(paramFolderId==-3){
		folderName = "<%=SystemEnv.getHtmlLabelName(19817,user.getLanguage())%>";
	}else if(paramFolderId==0){
		folderName = "<%=SystemEnv.getHtmlLabelName(19816,user.getLanguage())%>";
	}else{
		for(var i=0;i<$("folderSelect").options.length;i++){
			if(paramFolderId==$("folderSelect").options[i].value){
				folderName = $("folderSelect").options[i].innerHTML;
				break;
			}
		}
	}
	return folderName;
}
 
var termsRowlength=0;
var actionRowLength=0;

function addRow(tabName){
	var tab=document.getElementById(tabName);
	var row=tab.insertRow(-1);
	
	if(tabName=="termsBody"){
		termsRowlength++;
	}else{
		actionRowLength++;
	}
	
	for(var i=0;i<2;i++){
		cell=row.insertCell(-1);
		if(tabName=="termsBody"){
			
			if(i==0){
				cell.innerHTML='<input class="inputstyle" type="checkbox" name="rule_1"><input type="hidden" name="ck_1" value="1"/>';
			}
			else{
				//cell.className="Field";
				var tbtrone="<table>";
				 tbtrone+='<tr><td><select name="cSource" id="cSource'+termsRowlength+'" class="rule" onchange="conditionChange('+termsRowlength+',this)"> '+
							                  '<option value="1"><%=SystemEnv.getHtmlLabelName(344, user.getLanguage())//主题%></option>'+
			                     			  '<option value="2"><%=SystemEnv.getHtmlLabelName(2034, user.getLanguage())//发件人%></option>'+
			                                  '<option value="3"><%=SystemEnv.getHtmlLabelName(2046, user.getLanguage())//收件人%></option>'+
			                                  '<option value="4"><%=SystemEnv.getHtmlLabelName(2084, user.getLanguage())//抄送%></option>'+
			                                  '<option value="5"><%=SystemEnv.getHtmlLabelName(848, user.getLanguage())//重要性%></option>'+
			                                  '<option value="6"><%=SystemEnv.getHtmlLabelName(2047, user.getLanguage())//发件日期%></option>'+
			                                  '<option value="7"><%=SystemEnv.getHtmlLabelName(19842, user.getLanguage())//邮件大小%></option>'+
			                             '</select>';
			     tbtrone+='&nbsp;'+
			     			'<select name="operator1" id="operator'+termsRowlength+'L">'+
								 '<option value="1"><%=SystemEnv.getHtmlLabelName(346, user.getLanguage())//包含%></option>'+
								 '<option value="2"><%=SystemEnv.getHtmlLabelName(15507, user.getLanguage())//不包含%></option>'+
								 '<option value="3"><%=SystemEnv.getHtmlLabelName(163, user.getLanguage())//是%></option>'+
								 '<option value="4"><%=SystemEnv.getHtmlLabelName(19843, user.getLanguage())//不是%></option>'+
							 '</select>'+
							 '<select name="operator2" id="operator'+termsRowlength+'J" style="display:none" disabled="true">'+
								'<option value="5"><%=SystemEnv.getHtmlLabelName(15508, user.getLanguage())//大于%></option>'+
								'<option value="6"><%=SystemEnv.getHtmlLabelName(15509, user.getLanguage())//小于%></option>'+
							'</select>'+
							'<select name="operator3" id="operator'+termsRowlength+'K" style="display:none" disabled="true">'+
								'<option value="3"><%=SystemEnv.getHtmlLabelName(163, user.getLanguage())//是%></option>'+
							'</select>'
							 +
			     		   '</td>'; 
			     tbtrone+='<td>'+
			     			'<input type="text" name="cTarget" id="cTarget'+termsRowlength+'" class="inputstyle" style="width:250px" />'+
			     			'<select name="cTargetPriority" id="cTargetPriority'+termsRowlength+'" style="display:none">'+
								'<option value="3"><%=SystemEnv.getHtmlLabelName(2086, user.getLanguage())//普通%></option>'+
								'<option value="2"><%=SystemEnv.getHtmlLabelName(15533, user.getLanguage())//重要%></option>'+
								'<option value="4"><%=SystemEnv.getHtmlLabelName(2087, user.getLanguage())//紧急%></option>'+
							'</select>'+
							'<button name="browserDate" type="button" class="calendar" id="browserDate'+termsRowlength+'" onclick="getDateMail(\'sendDate'+termsRowlength+'\',\'sendDateSpan'+termsRowlength+'\')" style="display:none"></button>'+
							'<span name="sendDateSpan" id="sendDateSpan'+termsRowlength+'"></span>'+
							'<input type="hidden" id="sendDate'+termsRowlength+'" name="sendDate" value="">'+
			    			'</td></tr></table>';
			     cell.innerHTML=tbtrone;		    		                         
			}
		}else{
			
			if(i==0){
				cell.innerHTML='<input class="inputstyle" type="checkbox" name="rule_2"><input type="hidden" name="ck_2" value="1"/>';
			}
			else{
				//cell.className="Field";
				var tbtrone="<table>";
				 tbtrone+='<tr><td><select name="aSource" id="aSource'+actionRowLength+'" class="rule" onchange="actionChange('+actionRowLength+',this),onSelectMailInbox(this,'+actionRowLength+')">'+
										'<option value="1"><%=SystemEnv.getHtmlLabelName(19832,user.getLanguage())//移动邮件至%></option>'+
										'<option value="2"><%=SystemEnv.getHtmlLabelName(19833,user.getLanguage())//复制邮件至%></option>'+
										'<option value="3"><%=SystemEnv.getHtmlLabelName(18492,user.getLanguage())//标记为已读%></option>'+
										'<option value="5"><%=SystemEnv.getHtmlLabelName(31258,user.getLanguage())//标记为星标%></option>'+
										'<option value="4"><%=SystemEnv.getHtmlLabelName(19822,user.getLanguage())//导入客户联系%></option>'+
										'<option value="6"><%=SystemEnv.getHtmlLabelName(81324,user.getLanguage())//添加标签%></option>'+
						  '</select></td>';
			     tbtrone+='<td><span style="width:20px"></span>'+
			     		      '<select name="aTargetFolderId" id="aTargetFolderId'+actionRowLength+'">'+
				     		      	'<option value="0"><%=SystemEnv.getHtmlLabelName(19816,user.getLanguage())//收件箱%></option>'+
				     		      	'<option value="-1"><%=SystemEnv.getHtmlLabelName(2038,user.getLanguage())//发件箱%></option>'+
				     		      	'<option value="-2"><%=SystemEnv.getHtmlLabelName(2039,user.getLanguage())//草稿箱%></option>'+
				     		      	'<option value="-3"><%=SystemEnv.getHtmlLabelName(2040,user.getLanguage())//垃圾箱%></option>'+
				     		      	<%
										for(int i=0; i<folderList.size();i++){
											MailFolder mf = folderList.get(i);
											%>
											'<option value="<%=mf.getId() %>"><%=mf.getFolderName() %></option>'+
											<%
										}
									%>
			     		      '</select>'+
							  '<button name="browserCRM" type="button" class="browser" id="browserCRM'+actionRowLength+'" onclick="getCRM(\'aTargetCRMId'+actionRowLength+'\',\'aTargetCRMIdSpan'+actionRowLength+'\')" style="display:none"></button>'+
							  '<input type="hidden" name="aTargetCRMId" id="aTargetCRMId'+actionRowLength+'"/>'+
		   					  '<span name="aTargetCRMIdSpan" id="aTargetCRMIdSpan'+actionRowLength+'" style="display: none;"><img src="/images/BacoError.gif" align="absMiddle"></span>'+
		  					  '<input type="hidden" name="mainId" id="mainId'+actionRowLength+'"/>'+
		                      '<input type="hidden" name="subId" id="subId'+actionRowLength+'"/>'+
		                      '<input type="hidden" name="secId" id="secId'+actionRowLength+'"/>'+
				 			'</td></tr></table>';
			     cell.innerHTML=tbtrone;	
			     	    		                         
			}
		}	
		row.appendChild(cell);
	}
}


function encode(str){     
       return escape(str);
}

// 获取event
function getEvent() {
	if (window.ActiveXObject) {
		return window.event;// 如果是ie
	}
	func = getEvent.caller;
	while (func != null) {
		var arg0 = func.arguments[0];
		if (arg0) {
			if ((arg0.constructor == Event || arg0.constructor == MouseEvent)
					|| (typeof (arg0) == "object" && arg0.preventDefault && arg0.stopPropagation)) {
				return arg0;
			}
		}
		func = func.caller;
	}
	return null;
}

function conditionChange(num,o){

	var oValue = Value = o.options[o.selectedIndex].value;
	var skipFields = "";
	switch(oValue){
		case "1":
		case "2":
		case "3":
		case "4":
			skipFields = "operator"+num+"L,cTarget"+num+",";
			break;
		case "5"://重要性
			skipFields = "operator"+num+"K,cTargetPriority"+num+",";
			break;
		case "6"://发件日期
			skipFields = "operator"+num+"J,browserDate"+num+",sendDateSpan"+num+",";
			break;
		case "7"://邮件大小
			skipFields = "operator"+num+"J,cTarget"+num+",";
			break;
	}
	hideConditionFormField(skipFields,num);
}
function hideConditionFormField(skipField,num){
	var fieldIds = ["operator"+num+"L","operator"+num+"J","operator"+num+"K","cTargetPriority"+num,"browserDate"+num,"sendDateSpan"+num,"cTarget"+num];
	for(var i=0;i<fieldIds.length;i++){
		if(skipField.indexOf(fieldIds[i]+",") !=- 1){
			dojo.byId(fieldIds[i]).style.display = "";	
			dojo.byId(fieldIds[i]).disabled = false;
			continue;
		}
		dojo.byId(fieldIds[i]).style.display = "none";
		dojo.byId(fieldIds[i]).disabled = true;
	}
}
function actionChange(num,o){
	
	var oValue = Value = o.options[o.selectedIndex].value;
	
	switch(oValue){
		case "1" ://移动到
			dojo.byId("aTargetFolderId"+num).style.display = "";
			dojo.byId("browserCRM"+num).style.display = "none";
			dojo.byId("aTargetCRMIdSpan"+num).style.display = "none";
			break;
		case "2" ://复制到
			dojo.byId("aTargetFolderId"+num).style.display = "";
			dojo.byId("browserCRM"+num).style.display = "none";
			dojo.byId("aTargetCRMIdSpan"+num).style.display = "none";
			break;
		case "3" ://标记为已读
			dojo.byId("aTargetFolderId"+num).style.display = "none";
			dojo.byId("browserCRM"+num).style.display = "none";
			dojo.byId("aTargetCRMIdSpan"+num).style.display = "none";
			break;
		case "4" ://导入客户联系
			dojo.byId("aTargetFolderId"+num).style.display = "none";
			dojo.byId("browserCRM"+num).style.display = "";
			dojo.byId("aTargetCRMIdSpan"+num).style.display = "";
			break;
		case "5" ://标记为星标
			dojo.byId("aTargetFolderId"+num).style.display = "none";
			dojo.byId("browserCRM"+num).style.display = "none";
			dojo.byId("aTargetCRMIdSpan"+num).style.display = "none";
			break;
		case "6" ://标记为标签
			dojo.byId("aTargetFolderId"+num).style.display = "";
			dojo.byId("browserCRM"+num).style.display = "none";
			dojo.byId("aTargetCRMIdSpan"+num).style.display = "none";
			break;
	}
}
 
 function getDateMail(inputname,spanname){
	 WdatePicker({el:$dp.$(spanname),onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;
			},oncleared:function(dp){$dp.$(inputname).value = '';$dp.$(spanname).value = ''}});
}
 

function getCRM(inputname,spanname){
	returndate = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (returndate!=null){
		jQuery("#"+inputname).val(returndate.id);
		jQuery("#"+spanname).html(returndate.name);
		if (jQuery("#"+inputname).val()==""){
		    jQuery("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
		}
	}
}
 
</script>

<script type="text/vbscript">
sub getDate1(inputname,spanname)
    returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
    spanname.innerHtml = returndate
    inputname.value = returndate
end sub

sub getCRM1(inputname,spanname)
	returndate = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(returndate)) then
		
		inputname.value=returndate(0)
		spanname.innerHtml=returndate(1)	
		if (IsEmpty(inputname.value)) then
		    spanname.innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>"
		end if
	end if
end sub


</script>

<%
//RCFromPage="mailOption";//屏蔽右键菜单时使用
//RCMenu += "{添加条件,javascript:redirect(\"MailRuleConditionAdd.jsp?ruleId="+ruleId+"\", \"tab2\"),_self} " ;    
//RCMenuHeight += RCMenuHeightStep;
//RCMenu += "{添加动作,javascript:redirect(\"MailRuleActionAdd.jsp?ruleId="+ruleId+"\", \"tab2\"),_self} " ;    
//RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:MailRuleSubmit(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:redirect(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script type="text/javascript" src="/js/prototype.js"></script>

<table style="width:100%;height:92%;border-collapse:collapse">

<tr>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<!--==========================================================================================-->
<form method="post" action="MailRuleOperation.jsp" id="fMailRule" name="fMailRule">
<input type="hidden" name="operation" value="edit" />
<input type="hidden" name="id" value="<%=ruleId%>" />
<%if(showTop.equals("")) {%>

<%} else if(showTop.equals("show800")) {%>
<input type="hidden" name="showTop" value="show800" />
<%}%>
<input type="hidden" name="conditionId" id="conditionId" value="0"> 
<input type="hidden" name="actionId" id="actionId" value="0">
<input type="hidden" name="ruleConditionRowIndex" id="ruleConditionRowIndex" value="10," />
<input type="hidden" name="ruleActionRowIndex" id="ruleActionRowIndex" value="16," />

<input type="hidden" name="cSource" id="cSource" value="">
<input type="hidden" name="operator" id="operator" value="">
<input type="hidden" name="cTarget" id="cTarget" value="">
<input type="hidden" name="cTargetPriority" id="cTargetPriority" value="">
<input type="hidden" name="SendDate" id="SendDate" value="">
<input type="hidden" name="SendDateArrayass" id="SendDateArrayass" value="">

<input type="hidden" name="aSource" id="aSource" value="">
<input type="hidden" name="aTargetFolderId" id="aTargetFolderId" value="">
<input type="hidden" name="aTargetCRMId" id="aTargetCRMId" value="">
<input type="hidden" name="mainId" id="mainId" value="">
<input type="hidden" name="subId" id="subId" value="">
<input type="hidden" name="secId" id="secId" value="">

<table id="tblMailRule" class="ViewForm">
<tbody>
<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(19834,user.getLanguage())//规则定义%></th>
</tr>
<tr class="Spacing" style="height:2px"><td class="Line1" colspan="2"></td></tr>
<tr>
	<td width="15%"><%=SystemEnv.getHtmlLabelName(19829,user.getLanguage())//规则名称%></td>
	<td width="85%" class="Field">
		<input type="text" name="ruleName" class="inputstyle" value="<%=ruleName%>" style="width:90%" onchange="checkinput('ruleName','ruleNameSpan')" />
		<SPAN id="ruleNameSpan"></SPAN>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(19835,user.getLanguage())//匹配规则%></td>
	<td class="Field">
		<input type="radio" id="matchAll0" name="matchAll" value="0" <%if(matchAll.equals("0"))out.print("checked");%> /><label for="matchAll0" class="ruleDefine"><%=SystemEnv.getHtmlLabelName(19836,user.getLanguage())//匹配所有规则%></label>
		<input type="radio" id="matchAll1" name="matchAll" value="1" <%if(matchAll.equals("1"))out.print("checked");%> /><label for="matchAll1" class="ruleDefine"><%=SystemEnv.getHtmlLabelName(19837,user.getLanguage())//匹配任一规则%></label>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(19838,user.getLanguage())//应用时间%></td>
	<td class="Field">
		<input type="radio" id="applyTime0" name="applyTime" value="0" <%if(applyTime.equals("0"))out.print("checked");%> /><label for="applyTime0" class="ruleDefine"><%=SystemEnv.getHtmlLabelName(19839,user.getLanguage())//邮件到达%></label>
		<input type="radio" id="applyTime1" name="applyTime" value="1" <%if(applyTime.equals("1"))out.print("checked");%> /><label for="applyTime1" class="ruleDefine"><%=SystemEnv.getHtmlLabelName(19840,user.getLanguage())//邮件发送%></label>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(19830,user.getLanguage())//应用帐户%></td>
	<td class="Field">
		<select name="mailAccountId">
		<option value="-1" <%if(-1==mailAccountId)out.print("selected");%>>所有帐号</option>
		<%rs.executeSql("SELECT * FROM MailAccount WHERE userId="+user.getUID()+"");while(rs.next()){%>
		<option value="<%=rs.getInt("id")%>" <%if(rs.getInt("id")==mailAccountId)out.print("selected");%>><%=rs.getString("accountName")%></option>
		<%}%>
		</select>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
</tbody>
<tbody id="termsBody">
<tr class="Title">
	<th><%=SystemEnv.getHtmlLabelName(19841, user.getLanguage())//执行条件%></th>
	<td style="text-align:right">
		<button accesskey="A" class="btnNew" type="button" onclick="addRow('termsBody')"><u>A</u>-<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%></button>
		<button accesskey="D" class="btnDelete" type="button" onclick="javascript:delrule('<%=ruleId%>','deleteRuleCondition')"><u>D</u>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></button>
	</td>
</tr>
<tr class="Spacing" style="height:2px"><td class="Line1" colspan="2"></td></tr>
<%
int cSource=0,operator=0;
String sSource="",cTarget="",cTargetPriority="";
rs.executeSql("SELECT * FROM MailRuleCondition WHERE ruleId="+ruleId+"");
while(rs.next()){
	cSource = rs.getInt("cSource");
	operator = rs.getInt("operator");
	cTarget = rs.getString("cTarget");
	cTargetPriority = rs.getString("cTargetPriority");
	if(cSource==1){
		sSource = SystemEnv.getHtmlLabelName(344, user.getLanguage());
	}else if(cSource==2){
		sSource = SystemEnv.getHtmlLabelName(2034, user.getLanguage());
	}else if(cSource==3){
		sSource = SystemEnv.getHtmlLabelName(2046, user.getLanguage());
	}else if(cSource==4){
		sSource = SystemEnv.getHtmlLabelName(2084, user.getLanguage());
	}else if(cSource==5){
		sSource = SystemEnv.getHtmlLabelName(848, user.getLanguage());
		if(cTargetPriority.equals("2")){
			cTarget = SystemEnv.getHtmlLabelName(15533, user.getLanguage());
		}else if(cTargetPriority.equals("3")){
			cTarget = SystemEnv.getHtmlLabelName(2086, user.getLanguage());
		}else{
			cTarget = SystemEnv.getHtmlLabelName(2087, user.getLanguage());
		}
	}else if(cSource==6){
		sSource = SystemEnv.getHtmlLabelName(2047, user.getLanguage());
		cTarget = rs.getString("cSendDate");
	}else if(cSource==7){
		sSource = SystemEnv.getHtmlLabelName(19842, user.getLanguage());
	}
%>
<tr>
    <TD><input class="inputstyle" type="checkbox" name="rule_1" value="<%=rs.getInt("id")%>"><input type="hidden" name="ck_1" value="0"/></TD>
	<td class="field">
		<table cellpadding="0" cellspacing="0" style="width:100%">
		<tr>
		  <td width="25%"><span style="width:105px"><%=sSource%> </span>&nbsp;<span style="color:red;style="width:105px""><%=getRuleConditionOperator(String.valueOf(operator), user)%></span></td>
		  <td width="75%"><%=cTarget%></td>			
		</tr>
		</table>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<%}%>
</tbody>
<tbody>
<tr class="Title">
	<th><%=SystemEnv.getHtmlLabelName(19831,user.getLanguage())//执行动作%></th>
	<TD style="text-align:right">
	   <button accesskey="i" class="btnNew" type="button" onclick="addRow('actionBody')"><u>I</u>-<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%></button>
	   <button accesskey="e" class="btnDelete" type="button" onclick="javascript:delrule('<%=ruleId%>','deleteRuleAction')"><u>E</u>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></button>
	</TD>
</tr>
<tr class="Spacing" style="height:2px"><td class="Line1" colspan="2"></td></tr>
</tbody>
<tbody id="actionBody">
<%
String aSource="",aSourceAction="",aTargetFolderId="",aTargetCRMId="",aMainId="",aSubId="",aSecId="";
int aRowIndex = 0;
rs.executeSql("SELECT * FROM MailRuleAction WHERE ruleId="+ruleId+"");
while(rs.next()){
	aSource = rs.getString("aSource");
	aTargetFolderId = rs.getString("aTargetFolderId");
	aTargetCRMId = rs.getString("aTargetCRMId");
	aMainId = rs.getString("aMainId");
	aSubId = rs.getString("aSubId");
	aSecId = rs.getString("aSecId");

	if(aSource.equals("1")){
		aSourceAction = SystemEnv.getHtmlLabelName(19832,user.getLanguage());
	}else if(aSource.equals("2")){
		aSourceAction = SystemEnv.getHtmlLabelName(19833,user.getLanguage());
	}else if(aSource.equals("3")){
		aSourceAction = SystemEnv.getHtmlLabelName(18492,user.getLanguage());
	}else if(aSource.equals("4")){
		aSourceAction = SystemEnv.getHtmlLabelName(19822,user.getLanguage());
	}else if(aSource.equals("5")){
		aSourceAction = "标记为星标邮件";
	}else if(aSource.equals("6")){
		aSourceAction = "添加标签";
	}
%>
<tr>
    <TD><input class="inputstyle" type="checkbox" name="rule_2" value="<%=rs.getInt("id")%>"><input type="hidden" name="ck_2" value="0"/></TD>	
	<td class="Field">
		<table cellpadding="0" cellspacing="0" style="width:100%">
		<tr>
		    <td width="15%"><%=aSourceAction%></td>
			<td width="85%">
			<%
			if(aSource.equals("1") || aSource.equals("2")){
				out.print(getFolderName(aTargetFolderId, user.getUID(), user));
			}else	if(aSource.equals("5")){
				out.print(crm.getCustomerInfoname(aTargetCRMId));
			}else	if(aSource.equals("6")){
				MailLabel mailLable = lms.getLabelInfo(aTargetFolderId);
			%>
				<div style="display:inline-block; _zoom:1;_display:inline; margin-top:8px; border-radius:2px; height:10px; width:10px; background:<%=mailLable.getColor()%>;">&nbsp;</div>
				<span><%=mailLable.getName() %></span>
			<%
			}
			%>
			</td>
		</tr>
		</table>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<%}%>
</tbody>
</table>
</form>
<!--==========================================================================================-->
		</td>
		</tr>
		</table>
	</td>
</tr>

</table>



<%!
String getRuleConditionOperator(String cOperator, weaver.hrm.User user){
	String operator = "";
	if(cOperator.equals("1")){
		 operator = SystemEnv.getHtmlLabelName(346, user.getLanguage());
	}else if(cOperator.equals("2")){
		operator = SystemEnv.getHtmlLabelName(15507, user.getLanguage());
	}else if(cOperator.equals("3")){
		operator = SystemEnv.getHtmlLabelName(163, user.getLanguage());
	}else if(cOperator.equals("4")){
		operator = SystemEnv.getHtmlLabelName(19843, user.getLanguage());
	}else if(cOperator.equals("5")){
		operator = SystemEnv.getHtmlLabelName(15508, user.getLanguage());
	}else if(cOperator.equals("6")){
		operator = SystemEnv.getHtmlLabelName(15509, user.getLanguage());
	}
	return operator;
}

String getFolderName(String fId, int userId, weaver.hrm.User user){
	int folderId = Util.getIntValue(fId);
	String folderName = "";
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	
	rs.executeSql("SELECT folderName FROM MailInboxFolder WHERE userId="+userId+" AND id="+folderId+"");
	if(rs.next()){
		folderName = Util.null2String(rs.getString("folderName"));
	}else{
		if(folderId==0){
			folderName = SystemEnv.getHtmlLabelName(19816,user.getLanguage());
		}else if(folderId==-1){
			folderName = SystemEnv.getHtmlLabelName(2038,user.getLanguage());
		}else if(folderId==-2){
			folderName = SystemEnv.getHtmlLabelName(220,user.getLanguage());
		}else if(folderId==-3){
			folderName = SystemEnv.getHtmlLabelName(19817,user.getLanguage());
		}
	}
	return folderName;
}
%>
	<script language="javascript" defer="defer" src="/js/datetime.js"></script>
	<script language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
