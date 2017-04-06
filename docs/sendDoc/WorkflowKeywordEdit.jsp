<%@ page language="java" contentType="text/html; charset=GBK" %> 


<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="WorkflowKeywordComInfo" class="weaver.docs.senddoc.WorkflowKeywordComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("SendDoc:Manage", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>

<%
int id=Util.getIntValue(request.getParameter("id"),0);

String keywordName="";
String keywordDesc="";
int parentId=0;
String isKeyword="";
double showOrder=0;

RecordSet.executeSql("select * from Workflow_Keyword where id="+id);
if(RecordSet.next()){
	keywordName=Util.null2String(RecordSet.getString("keywordName"));
	keywordDesc=Util.null2String(RecordSet.getString("keywordDesc"));
	parentId=Util.getIntValue(RecordSet.getString("parentId"),0);
	isKeyword=Util.null2String(RecordSet.getString("isKeyword"));
	showOrder=Util.getDoubleValue(RecordSet.getString("showOrder"),0);
}


%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>

</head>
<%

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(16978,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/sendDoc/WorkflowKeywordDsp.jsp?id="+id+",_self} " ;
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

<FORM id=weaver name=frmMain action="WorkflowKeywordOperation.jsp" method=post target="_parent">

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
            <TD><%=SystemEnv.getHtmlLabelName(21510,user.getLanguage())%></TD>
            <TD class=FIELD>
              <INPUT class=InputStyle  name=keywordName value="<%=keywordName%>" onchange='checkinput("keywordName","keywordNameImage")'>
                 <SPAN id=keywordNameImage></SPAN>
              </TD>
          </TR>
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 

			   <TR> 
				<TD><%=SystemEnv.getHtmlLabelName(21511,user.getLanguage())%></TD>
				<TD class=FIELD> 
					<INPUT class=InputStyle  name=keywordDesc style="width:80%" value="<%=keywordDesc%>">					           
				  </TD>
			  </TR>
			<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 

          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(19411,user.getLanguage())%></TD>
            <TD class=Field>
              <BUTTON type='button' class=Browser type="button" id=SelectParentId onclick="onShowParent()"></BUTTON>
              <SPAN id=parentSpan>
			  <%=WorkflowKeywordComInfo.getKeywordName(""+parentId)%>
              </SPAN>
              <INPUT id=parentId type=hidden name=parentId value="<%=parentId%>">
            </TD>
          </TR>
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>

			<TR> 
				<TD><%=SystemEnv.getHtmlLabelName(21512,user.getLanguage())%></TD>
				 <TD class=FIELD>
				     <select name="isKeyword" class=InputStyle>
					     <option value="0" <%="0".equals(isKeyword)?"selected":""%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
					     <option value="1" <%="1".equals(isKeyword)?"selected":""%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
				     </select>				 
				 </TD>
			  </TR>
			<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 

          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>
            <TD class=Field>
              <INPUT class=InputStyle name=showOrder size=7 maxlength=7 value="<%=showOrder%>"   onKeyPress='ItemDecimal_KeyPress("showOrder",6,2)'  onBlur='checknumber("showOrder");checkDigit("showOrder",6,2);checkinput("showOrder","showOrderImage")' onchange='checkinput("showOrder","showOrderImage")'>
              <SPAN id=showOrderImage></SPAN>
            </TD>
          </TR>
         <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
          </TBODY>
        </TABLE>


   <input type=hidden name=operation>
   <input type=hidden name=id value="<%=id%>">
 </FORM>
<iframe id="workflowKeywordIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
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
//           2:提示字段名称不能重复

function checkForEditSave(o){
    if(o=="2"){
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(21515,user.getLanguage())%>";
		return;
	}else if(o==""){
		document.frmMain.operation.value="EditSave";
		document.frmMain.submit();	
	}
}


function onSave(){

 	if(check_form(document.frmMain,'keywordName,showOrder')){
		var newKeywordId=<%=id%>;
		var newKeywordName=document.all("keywordName").value;
		var newParentId=document.all("parentId").value;

		document.all("workflowKeywordIframe").src="WorkflowKeywordIframe.jsp?operation=EditSave&newKeywordId="+newKeywordId+"&newParentId="+newParentId+"&newKeywordName="+newKeywordName;
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

function onShowParent(){
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
	parentId=document.frmMain.parentId.value
	url="/docs/sendDoc/WorkflowKeywordBrowserSingle.jsp?excludeId=<%=id%>&keywordId="+parentId
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url,"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	
	if (data){
	    if (data.id!="") {
	        parentSpan.innerHTML = data.name
	        frmMain.parentId.value=data.id
	    }else{
	        parentSpan.innerHTML = ""
	        frmMain.parentId.value="0"
	    }
	}
}

</script>
