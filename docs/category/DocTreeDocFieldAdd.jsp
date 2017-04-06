<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.docs.category.DocTreeDocFieldConstant" %>

<jsp:useBean id="DocTreeDocFieldComInfo" class="weaver.docs.category.DocTreeDocFieldComInfo" scope="page" />



<%
if(!HrmUserVarify.checkUserRight("DummyCata:Maint", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>

<%

String superiorFieldId=Util.null2String(request.getParameter("superiorFieldId"));
if(superiorFieldId.equals("")){
	superiorFieldId=DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID;
}

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

String titlename = SystemEnv.getHtmlLabelName(19410,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_TOP} " ;
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

<FORM id=weaver name=frmMain action="DocTreeDocFieldOperation.jsp" method=post  target="_parent">

        <TABLE class=ViewForm width="100%">
          <COLGROUP> 
		  <COL width="30%">
		  <COL width="70%">
		  <TBODY> 

          <TR class=Title> 
              <TH><%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%></TH>
          </TR>
          <TR class=Spacing style="height: 1px!important;"> 
            <TD class=Line1 colSpan=2></TD>
          </TR>

          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
            <TD class=FIELD> 
              <INPUT class=InputStyle  name=treeDocFieldName onchange='checkinput("treeDocFieldName","treeDocFieldNameImage")' value="">
              <SPAN id=treeDocFieldNameImage>
			  <IMG src="/images/BacoError.gif" align=absMiddle>
			  </SPAN>
              </TD>
          </TR>
    <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 

	 <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
            <TD class=FIELD> 
				<INPUT class=InputStyle  name=treeDocFieldDesc value="" style="width:80%">             
              </TD>
          </TR>
    <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 

	 <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(1507,user.getLanguage())%></TD>
             <TD class=FIELD> 			 
				  <BUTTON class=Browser type="button" onclick="onShowManagerids(mangerids,spanmangerids)"></BUTTON> 
				  <SPAN id=spanmangerids></SPAN>
				  <INPUT class=inputstyle id=mangerids type=hidden name=mangerids>
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
              <INPUT class=inputstyle id=superiorFieldId type=hidden name=superiorFieldId value=<%=superiorFieldId%>>                           
            </TD>
          </TR>         
    <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 
            <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
            <TD class=Field> 
              <INPUT class=InputStyle name=showOrder value=0 size=7 maxlength=7  onKeyPress='ItemDecimal_KeyPress("showOrder",6,2)' onBlur='checknumber("showOrder");checkDigit("showOrder",6,2);checkinput("showOrder","showOrderImage")' onchange='checkinput("showOrder","showOrderImage")' >
              <SPAN id=showOrderImage></SPAN>
            </TD>
          </TR>
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>

   <input class=inputstyle type=hidden name=operation value="AddSave">
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

</BODY>
</HTML>


<script language=javascript>

//o为错误类型 1:系统不支持10层以上的树状字段！
//           2:同级字段名称不能重复

function checkForAddSave(o){
	if(o=="1"){
		//alert("<%=SystemEnv.getHtmlLabelName(19414,user.getLanguage())%>");
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(19414,user.getLanguage())%>";
		return;
	}else if(o=="2"){
		//alert("<%=SystemEnv.getHtmlLabelName(19442,user.getLanguage())%>");
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(19442,user.getLanguage())%>";
		return;
	}else if(o==""){
		document.frmMain.submit();	
	}
}

function onSave(obj) {
    //obj.disabled = true ;
	if(check_form(frmMain,'treeDocFieldName,showOrder')){
		var newTreeDocFieldName=document.all("treeDocFieldName").value;
		var mewSuperiorFieldId=document.all("superiorFieldId").value;
		newTreeDocFieldName=escape(newTreeDocFieldName);

		DocTreeDocFieldUtil.whetherCanAddSave(newTreeDocFieldName,mewSuperiorFieldId,checkForAddSave);
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