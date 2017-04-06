<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ page import="weaver.docs.category.DocTreeDocFieldConstant" %>

<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>



<%
if(!HrmUserVarify.checkUserRight("DummyCata:Maint", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>

<%
String treeDocFieldId=Util.null2String(request.getParameter("id"));
String err=Util.null2String(request.getParameter("err"));


String treeDocFieldName=DocTreeDocFieldComInfo.getTreeDocFieldName(treeDocFieldId);
String superiorFieldId = DocTreeDocFieldComInfo.getSuperiorFieldId(treeDocFieldId);
String showOrder = DocTreeDocFieldComInfo.getShowOrder(treeDocFieldId);


String treeDocFieldDesc = DocTreeDocFieldComInfo.getTreeDocFieldDesc(treeDocFieldId);
String mangerids = DocTreeDocFieldComInfo.getMangerids(treeDocFieldId);
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<script type='text/javascript' src='/dwr/interface/DocTreeDocFieldUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
</head>
<%

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(19410,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

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

<div id=divMessage style="color:red">
</div>

<FORM id=weaver name=frmMain action="DocTreeDocFieldOperation.jsp" method=post target="_parent">
<%
	if("isUsed".equals(err)){ 
		out.println("<font color=#FF0000>"+SystemEnv.getHtmlLabelName(20552,user.getLanguage())+"</a>");		
	}
%>

        <TABLE class=ViewForm width="100%">
          <COLGROUP>
          <COL width="30%">
          <COL width="70%">
          <TBODY>
          <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%></TH>
          </TR>
          <TR class=Spacing style="height: 1px!important;">
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
            <TD class=FIELD>
              <INPUT class=InputStyle  name=treeDocFieldName value="<%=treeDocFieldName%>" onchange='checkinput("treeDocFieldName","treeDocFieldNameImage")'>
                 <SPAN id=treeDocFieldNameImage></SPAN>
              </TD>
          </TR>
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 

			   <TR> 
				<TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
				<TD class=FIELD> 
					<INPUT class=InputStyle  name=treeDocFieldDesc style="width:80%" value="<%=treeDocFieldDesc%>">					           
				  </TD>
			  </TR>
			<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 

			<TR> 
				<TD><%=SystemEnv.getHtmlLabelName(1507,user.getLanguage())%></TD>
				 <TD class=FIELD> 			 					  
					  <BUTTON class=Browser  type="button" onclick="onShowManagerids(mangerids,spanmangerids)"></BUTTON> 
					  <SPAN id=spanmangerids><%=ResourceComInfo.getMulResourcename1(mangerids)%></SPAN>
					  <INPUT class=inputstyle id=mangerids type=hidden name=mangerids value="<%=mangerids%>">
					  
				  </TD>
			  </TR>
			<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 

          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(19411,user.getLanguage())%></TD>
            <TD class=Field>
              <BUTTON class=Browser type="button" id=SelectSuperiorFieldId onclick="onShowSuperiorField()"></BUTTON>
              <SPAN id=superiorFieldSpan>
			  <%=DocTreeDocFieldComInfo.getAllSuperiorFieldName(""+superiorFieldId)%>
              </SPAN>
              <INPUT id=superiorFieldId type=hidden name=superiorFieldId value="<%=superiorFieldId%>">
            </TD>
          </TR>
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
            <TD class=Field>
              <INPUT class=InputStyle name=showOrder size=7 maxlength=7 value="<%=showOrder%>"   onKeyPress='ItemDecimal_KeyPress("showOrder",6,2)'  onBlur='checknumber("showOrder");checkDigit("showOrder",6,2);checkinput("showOrder","showOrderImage")' onchange='checkinput("showOrder","showOrderImage")'>
              <SPAN id=showOrderImage></SPAN>
            </TD>
          </TR>
         <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          </TBODY>
        </TABLE>


   <input type=hidden name=operation>
   <input type=hidden name=id value="<%=treeDocFieldId%>">
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
</BODY></HTML>


<script language=javascript>

//o为错误类型 1:系统不支持10层以上的树状字段！
//           2:同级字段名称不能重复

function checkForEditSave(o){
	if(o=="1"){
		//alert("<%=SystemEnv.getHtmlLabelName(19414,user.getLanguage())%>");
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(19414,user.getLanguage())%>";
		return;
	}else if(o=="2"){
		//alert("<%=SystemEnv.getHtmlLabelName(19442,user.getLanguage())%>");
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(19442,user.getLanguage())%>";
		return;
	}else if(o==""){
		document.frmMain.operation.value="EditSave";
		document.frmMain.submit();	
	}
}


function onSave(){

 	if(check_form(document.frmMain,'treeDocFieldName,showOrder')){
		var newTreeDocFieldId=<%=treeDocFieldId%>;
		var newTreeDocFieldName=document.all("treeDocFieldName").value;
		var newSuperiorFieldId=document.all("superiorFieldId").value;

        newTreeDocFieldName=escape(newTreeDocFieldName);
			DocTreeDocFieldUtil.whetherCanEditSave(newTreeDocFieldId,newTreeDocFieldName,newSuperiorFieldId,checkForEditSave);
	}

 }
 
//o为错误类型 1:当前字段有下级节点，不能删除。
//           2:该记录被引用,不能删除。
function checkForDelete(o){
	if(o=="1"){
		//alert("<%=SystemEnv.getHtmlLabelName(19441,user.getLanguage())%>");
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(19441,user.getLanguage())%>";
		return;
	}else if(o=="2"){
		//alert("<%=SystemEnv.getErrorMsgName(20,user.getLanguage())%>")
		divMessage.innerHTML="<%=SystemEnv.getErrorMsgName(20,user.getLanguage())%>";
		return;
	}else if(o==""){
		document.frmMain.operation.value="Delete";
		document.frmMain.submit();	
	}
}


function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		var treeDocFieldId=<%=treeDocFieldId%>;
		DocTreeDocFieldUtil.whetherCanDelete(treeDocFieldId,checkForDelete);
    }
}

function encode(str){
    return escape(str);
}


/*
p（精度）
指定小数点左边和右边可以存储的十进制数字的最大个数。精度必须是从 1 到最大精度之间的值。最大精度为 38。

s（小数位数）
指定小数点右边可以存储的十进制数字的最大个数。小数位数必须是从 0 到 p 之间的值。默认小数位数是 0，因而 0 <= s <= p。最大存储大小基于精度而变化。
*/
function checkDigit(elementName,p,s){
	tmpvalue = document.all(elementName).value;

    var len = -1;
    if(elementName){
		len = tmpvalue.length;
    }

	var integerCount=0;
	var afterDotCount=0;
	var hasDot=false;

    var newIntValue="";
	var newDecValue="";
    for(i = 0; i < len; i++){
		if(tmpvalue.charAt(i) == "."){ 
			hasDot=true;
		}else{
			if(hasDot==false){
				integerCount++;
				if(integerCount<=p-s){
					newIntValue+=tmpvalue.charAt(i);
				}
			}else{
				afterDotCount++;
				if(afterDotCount<=s){
					newDecValue+=tmpvalue.charAt(i);
				}
			}
		}		
    }

    var newValue="";
	if(newDecValue==""){
		newValue=newIntValue;
	}else{
		newValue=newIntValue+"."+newDecValue;
	}
    document.all(elementName).value=newValue;
}

function onShowManagerids(inputname,spanname){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			_displayTemplate:"#b{name}",
			_displaySelector:"",
			_required:"no",
			_displayText:"",
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	
	linkurl="javaScript:openhrm('"
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+inputname.value,"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (data) {
		if (data.id!="") {
		    resourceids = data.id.split(",")
			resourcename = data.name.split(",")
			sHtml = ""
			//resourceids = Mid(resourceids,2,len(resourceids))
			//resourcename = Mid(resourcename,2,len(resourcename))
			inputname.value= data.id
			for(var i=0;i<resourceids.length;i++){
				sHtml = sHtml+"<a href='"+linkurl+resourceids[i]+");' onclick='pointerXY(event);'>"+resourcename[i]+"</a>&nbsp"
			}
			
			//sHtml = sHtml&"<a href='&linkurl&resourceids&);' onclick='pointerXY(event);'>"&resourcename&"</a>&nbsp"
			spanname.innerHTML = sHtml
		}else{	
			spanname.innerHTML = ""
			inputname.value=""
		}
	}	
}

function onShowSuperiorField(){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			_displayTemplate:"#b{name}",
			_displaySelector:"",
			_required:"no",
			_displayText:"",
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	superiorFieldId=document.frmMain.superiorFieldId.value
	url="/docs/category/DocTreeDocFieldBrowserSingle.jsp?superiorFieldId="+superiorFieldId
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url,"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	
	if (data){
	    if (data.id != ""){
	        superiorFieldSpan.innerHTML = data.name
	        frmMain.superiorFieldId.value=data.id
	    }else{
	        superiorFieldSpan.innerHTML = ""
	        frmMain.superiorFieldId.value="<%=DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID%>"
	    }
	}
}
</script>
