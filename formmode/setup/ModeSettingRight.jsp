<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.docs.category.DocTreeDocFieldConstant" %>
<jsp:useBean id="ModeTreeFieldComInfo" class="weaver.formmode.setup.ModeTreeFieldComInfo" scope="page" />
<jsp:useBean id="ModeTreeFieldManager" class="weaver.formmode.setup.ModeTreeFieldManager" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
String treeFieldId = Util.null2String(request.getParameter("id"));
String err = Util.null2String(request.getParameter("err"));
String superFieldId = "";
int level = 0;
int isLast = 0;
String showOrder = "";
String treeFieldDesc = "";

if(treeFieldId.equals(""))
	treeFieldId=DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID;
if(Util.getIntValue(treeFieldId) > 1){
	superFieldId = ModeTreeFieldComInfo.getSuperFieldId(treeFieldId);
	level=Util.getIntValue(ModeTreeFieldComInfo.getLevel(treeFieldId),0);
	isLast=Util.getIntValue(ModeTreeFieldComInfo.getIsLast(treeFieldId),0);
	showOrder = ModeTreeFieldComInfo.getShowOrder(treeFieldId);
	treeFieldDesc = ModeTreeFieldComInfo.getTreeModeFieldDesc(treeFieldId);
}
String treeFieldName=ModeTreeFieldComInfo.getTreeModeFieldName(treeFieldId);
boolean isCreateOrDel = true;
if(isLast == 1){
	rs.executeSql("select 1 from modeinfo where modetype="+treeFieldId);
	if(rs.next()) isCreateOrDel = false;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<style>
.loading{
    position:absolute;
    left:45%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
}
</style>
</head>
<%

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(23669,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    if(level > 0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(19413,user.getLanguage())+",/formmode/setup/ModeTreeFieldAdd.jsp?superFieldId="+superFieldId+",_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		
    }
	if(level<DocTreeDocFieldConstant.TREE_DOC_FIELD_MAX_LEVEL && isCreateOrDel){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(19412,user.getLanguage())+",/formmode/setup/ModeTreeFieldAdd.jsp?superFieldId="+treeFieldId+",_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	}
	if(isLast == 1){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(28349,user.getLanguage())+",/formmode/setup/ModeManage.jsp?typeId="+treeFieldId+",_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	}
	if(level > 0 && isCreateOrDel){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<div class="loading" >
	<span><img src="/images/loadingext.gif" align="absmiddle"></span>
	<span id="loading-msg"><%=SystemEnv.getHtmlLabelName(19945,user.getLanguage())%></span>
</div>
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
<FORM id=weaver name=frmMain action="ModeTreeFieldOperation.jsp" method=post target="_parent" onsubmit="return false">
<%

if("1".equals(err)){ 
	out.println("<font color=#FF0000>"+SystemEnv.getHtmlLabelName(28472,user.getLanguage())+"</a>");		
}else if("2".equals(err)){ 
	out.println("<font color=#FF0000>"+SystemEnv.getHtmlLabelName(21089,user.getLanguage())+"</a>");		
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
              <INPUT class=InputStyle  name=treeFieldName value="<%=treeFieldName%>" maxlength="40" onchange='checkinput("treeFieldName","treeFieldNameImage")'>
                 <SPAN id=treeFieldNameImage></SPAN>
              </TD>
          </TR>
         <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
         <%
         if(Util.getIntValue(treeFieldId)>1){
         %>
         <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
            <TD class=FIELD> 
				<INPUT class=InputStyle  name=treeFieldDesc value="<%=treeFieldDesc%>" maxlength="125" size="50">             
              </TD>
          </TR>
    	  <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(19411,user.getLanguage())%></TD>
            <TD class=Field>
              <SPAN id=superiorFieldSpan>
                  <%=ModeTreeFieldComInfo.getAllSuperiorFieldName(""+superFieldId)%>
              </SPAN> 
              <INPUT class=inputstyle name=superFieldId type=hidden name=superFieldId value=<%=superFieldId%>>                           
            </TD>
          </TR>         
    	  <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 
            <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
            <TD class=Field> 
              <INPUT class=InputStyle id=showOrder name=showOrder value="<%=showOrder %>" size=7 maxlength=7  onKeyPress='ItemDecimal_KeyPress("showOrder",6,2)' onBlur='checknumber("showOrder");checkDigit("showOrder",6,2);checkinput("showOrder","showOrderImage")' onchange='checkinput("showOrder","showOrderImage")' >
              <SPAN id=showOrderImage></SPAN>
            </TD>
          </TR>
          <TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR> 
          <%} %>
          </TBODY>
        </TABLE>


   <input type=hidden name=operation>
   <input type=hidden name=id value="<%=treeFieldId%>">
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
$(document).ready(function(){//onload事件
	$(".loading").hide(); //隐藏加载图片
})
//o为错误类型 1:当前字段有下级节点，不能删除。
//           2:该记录被引用,不能删除。
function checkForDelete(o){
	if(o=="1"){
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(28472,user.getLanguage())%>";
		return;
	}else if(o=="2"){
		divMessage.innerHTML="<%=SystemEnv.getHtmlLabelName(21089,user.getLanguage())%>";
		return;
	}else if(o==""){
		document.frmMain.operation.value="DelTree";
		enableAllmenu();
		$(".loading").show(); 
		document.frmMain.submit();	
	}
}

function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
	<%
	ModeTreeFieldManager.setTreeFieldId(treeFieldId);
	err = ModeTreeFieldManager.whetherCanDelete();
	%>
	checkForDelete('<%=err%>');
    }
}
function onSave(){
<%
if(Util.getIntValue(treeFieldId)>1){
%>
document.frmMain.operation.value="EditSave";
<%	
}else{
%>	
	document.frmMain.operation.value="RootEditSave";
<%}%>
	if(check_form(frmMain,"treeFieldName,showOrder")){
		enableAllmenu();
		$(".loading").show(); 
		document.frmMain.submit();
	}
}
/*
p（精度）
指定小数点左边和右边可以存储的十进制数字的最大个数。精度必须是从 1 到最大精度之间的值。最大精度为 38。

s（小数位数）
指定小数点右边可以存储的十进制数字的最大个数。小数位数必须是从 0 到 p 之间的值。默认小数位数是 0，因而 0 <= s <= p。最大存储大小基于精度而变化。
*/
function checkDigit(elementName,p,s){
	tmpvalue = document.getElementById(elementName).value;

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
    document.getElementById(elementName).value=newValue;
}
</script>
