<%@ page language="java" contentType="text/html; charset=GBK" %> 

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />


<%@ include file="/systeminfo/init.jsp" %>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
    if(!HrmUserVarify.checkUserRight("GroupsSet:Maintenance", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}


    int id = Util.getIntValue(request.getParameter("id"),0);
    String orgGroupName="";
	String orgGroupDesc="";
	String showOrder = "";

	RecordSet.executeSql("select * from HrmOrgGroup where id = "+id);
	if(RecordSet.next()){
		orgGroupName=Util.null2String(RecordSet.getString("orgGroupName"));
		orgGroupDesc=Util.null2String(RecordSet.getString("orgGroupDesc"));
		showOrder = ""+Util.getDoubleValue(RecordSet.getString("showOrder"),0);
	}
	int index0 = showOrder.indexOf(".");
	if(index0 > -1){
		showOrder = showOrder + "0000";
		showOrder = showOrder.substring(0, index0 + 3);
	}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(24002,user.getLanguage()) +  "&nbsp;&nbsp;" + orgGroupName;
String needfav ="1";
String needhelp ="";


%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/orggroup/HrmOrgGroupAdd.jsp,_self} " ;
    RCMenuHeight += RCMenuHeightStep ;    

    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(24662,user.getLanguage())+",/hrm/orggroup/HrmOrgGroupRelated.jsp?orgGroupId="+id+",_self} " ;
    RCMenuHeight += RCMenuHeightStep ;

%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>


<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<DIV id=msgDiv style="color:red"></DIV>

<iframe name="msgDivGetter" style="width:100%;height:200;display:none"></iframe>

<FORM id=weaver name=frmMain action="HrmOrgGroupOperation.jsp" method=post>
<input class=inputstyle type="hidden" name=operation>
<input class=inputstyle type="hidden" name=id value="<%=id%>">

        <TABLE class=ViewForm width="100%">
          <COLGROUP>
          <COL width="30%">
          <COL width="70%">
          <TBODY>
          <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(24002,user.getLanguage())%></TH>
          </TR>
          <TR class=Spacing style="height:2px">
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
            <TD class=FIELD>
              <INPUT class=InputStyle temptitle="<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>"  name=orgGroupName value="<%=orgGroupName%>" size=30 maxlength=30   onchange='checkinput("orgGroupName","orgGroupNameImage")'>
                 <SPAN id=orgGroupNameImage><%if(orgGroupName.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></SPAN>
              </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 

			   <TR> 
				<TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
				<TD class=FIELD> 
					<INPUT class=InputStyle  name=orgGroupDesc value="<%=orgGroupDesc%>" size=60 maxlength=100>					           
				  </TD>
			  </TR>
			<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 


          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
            <TD class=Field>
              <INPUT class=InputStyle temptitle="<%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%>" name=showOrder size=7 maxlength=7 value="<%=showOrder%>"   onKeyPress='ItemDecimal_KeyPress("showOrder",6,2)'  onBlur='checknumber("showOrder");checkDigit("showOrder",6,2);checkinput("showOrder","showOrderImage")' onchange='checkinput("showOrder","showOrderImage")'>
              <SPAN id=showOrderImage></SPAN>
            </TD>
          </TR>
         <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          </TBODY>
        </TABLE>

</form> 

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


function onSave(){

 	if(check_form(document.frmMain,'orgGroupName,showOrder')){
		document.frmMain.operation.value="EditSave";
		document.frmMain.submit();
		enableAllmenu();
	}
 }


 function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		document.all("msgDivGetter").src="HrmOrgGroupIframe.jsp?operation=Delete&orgGroupId="+<%=id%>;
		enableAllmenu();
    }
}

function checkForDelete(returnString){
	if(returnString=='') {
		document.frmMain.operation.value="Delete";
		document.frmMain.submit();
		enableAllmenu();
	}else{
		msgDiv.innerHTML=returnString;
		ableAllmenu();
	}
}
function ableAllmenu(){
	for (a=0;a<window.frames["rightMenuIframe"].document.all.length;a++){
		if(window.frames["rightMenuIframe"].document.all.item(a).tagName == "BUTTON"){
			window.frames["rightMenuIframe"].document.all.item(a).disabled=false;
		}
	}
	try{
		for (b=0;b<parent.document.getElementById("toolbarmenu").all.length;b++){
			if(parent.document.getElementById("toolbarmenu").all.item(b).tagName == "TABLE"){
				parent.document.getElementById("toolbarmenu").all.item(b).disabled=false;
			}
		}
	}catch(e){
	}
}


</script>
