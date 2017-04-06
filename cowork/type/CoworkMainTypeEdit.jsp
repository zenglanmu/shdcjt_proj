<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CoMainTypeComInfo" class="weaver.cowork.CoMainTypeComInfo" scope="page"/>

<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
<SCRIPT language="javascript" src="../../js/jquery/jquery.js"></script>
</head>
<%
if(! HrmUserVarify.checkUserRight("collaborationtype:edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

%>
<%
int id = Util.getIntValue(request.getParameter("id"),0);

String sql="select * from cowork_maintypes where id="+id;
RecordSet.executeSql(sql);
RecordSet.next();
String typename = RecordSet.getString("typename");
String category = Util.null2String(RecordSet.getString("category"));
String categorypath = "";
if(!category.equals("")){
    String[] categoryArr = Util.TokenizerString2(category,",");
    categorypath += "/"+MainCategoryComInfo.getMainCategoryname(categoryArr[0]);
    categorypath += "/"+SubCategoryComInfo.getSubCategoryname(categoryArr[1]);
    categorypath += "/"+SecCategoryComInfo.getSecCategoryname(categoryArr[2]);
}
boolean canDel = true;
if(id!=0){
	sql="select * from cowork_types where departmentid="+id;
	RecordSet.executeSql(sql);
	if(RecordSet.next()){
		canDel = false;
	}
}
String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(178,user.getLanguage());
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
			
			<TABLE class="Shadow">
			<tr>
			<td valign="top">
			
<FORM id=weaver name=frmMain action="MainTypeOperation.jsp" method=post>

  <TABLE class=ViewForm width="100%">
    <TBODY>
    <TR class=title> 
      <TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></TH>
      </TR>
      <TR class=spacing style="height: 1px;">
          <TD class=line1 colSpan=2></TD></TR>
      <TR>
    <TR vAlign=top width=100%> 
      <TD width=100%> 
        <TABLE class=ViewForm width="100%">
          <COLGROUP> <COL width="30%"> <COL width="70%"> <TBODY> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
            <TD class=FIELD><nobr> 
              <INPUT class=inputstyle type=text maxLength=60 size=25 name=name id=coworkname value="<%=typename%>" onchange='checkinput("name","nameimage")'>
              <SPAN id=nameimage></SPAN></TD>
          </TR>
          <TR style="height: 1px;"><TD class=Line colspan=2></TD></TR> 
          <tr>
	            <td><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(92,user.getLanguage())%></td>
	            <td class=field>
	                <BUTTON type="button" class=Browser onClick="onShowCatalog('mypathspan')" name=selectCategory></BUTTON>
	                <span id="mypathspan" name="mypathspan"><%=categorypath%></span>
	                <input type=hidden id='mypath' name='mypath' value="<%=category%>">
	            </td>
	        </tr>
          <TR style="height: 1px;"><TD class=Line colspan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
    </TR>
          
  </TABLE>
   <input type=hidden name=operation>
   <input type=hidden name=id value="<%=id%>">
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
	
function onSave() {
		var coworkname = $("#coworkname").val();
		var typename = '<%=typename%>';				
		$.post("/cowork/type/CoworkMainTypeCheck.jsp",{coworkname:encodeURIComponent($("#coworkname").val()),id:'<%=id%>'},function(datas){  
				 if(datas.indexOf("unfind") > 0 && check_form(document.frmMain,'name')){
				 		document.frmMain.operation.value="edit";
						document.frmMain.submit();						
				 } else if (datas.indexOf("exist") > 0){				 	  
				 	  alert("<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%> [ "+coworkname+" ] <%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>");
				 }
		});
}

function onDelete(){
	if(<%=canDel%>==false){
		alert("<%=SystemEnv.getHtmlLabelName(18863,user.getLanguage())%>");
		return;
	}
	if(isdel()) {
		document.frmMain.operation.value="delete";
		document.frmMain.submit();
	}
}
function onShowCatalog(spanName) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp");
    if (result != null) {
        if (wuiUtil.getJsonValueByIndex(result,0)> 0){
          jQuery("#"+spanName).html(wuiUtil.getJsonValueByIndex(result,2));
          jQuery("#mypath").val(wuiUtil.getJsonValueByIndex(result,3)+","+wuiUtil.getJsonValueByIndex(result,4)+","+wuiUtil.getJsonValueByIndex(result,1));
        }else{
          jQuery("#"+spanName).html("");
          jQuery("#mypath").val("");
        }
    }
}
</script>
</BODY></HTML>
