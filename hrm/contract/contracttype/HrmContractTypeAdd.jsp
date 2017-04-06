<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.docs.category.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="MouldManager" class="weaver.docs.mouldfile.MouldManager" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<html>
<%
if(!HrmUserVarify.checkUserRight("HrmContractTypeAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput.js"></script>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<body>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(716,user.getLanguage());

String typename=Util.null2String(request.getParameter("typename"));
String contracttempletid=Util.null2String(request.getParameter("contracttempletid"));
int ishirecontract=Util.getIntValue(request.getParameter("ishirecontract"),0);
String remindman=Util.null2String(request.getParameter("remindman"));
String remindaheaddate=Util.null2String(request.getParameter("remindaheaddate"));
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int subcompanyid= Util.getIntValue(request.getParameter("subcompanyid"));
String usertype = user.getLogintype();
String mainid=Util.null2String(request.getParameter("mainid"));
String subid=Util.null2String(request.getParameter("subid"));
int saveurl = Util.getIntValue(request.getParameter("saveurl"), -1);
String path = "";
if (saveurl != -1) {
    path = "/"+CategoryUtil.getCategoryPath(saveurl);
}



String needfav ="1";
String needhelp ="";
%>

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/contract/contracttype/HrmContractType.jsp?subcompanyid1="+subcompanyid+",_self} " ;
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
<FORM id=contracttype name=contracttype action="HrmConTypeOperation.jsp" method=post>
<input class=inputstyle type=hidden name=operation>
<TABLE class=ViewForm>
  <COLGROUP>   
    <COL width="15%">
    <COL width="85%">     
  <TBODY>
  <TR class=Title>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(6158,user.getLanguage())%></TH>
  </TR>
  <TR class= Spacing style="height:2px">
    <TD class=Line1 colSpan=3 ></TD>
  </TR>
  <tr>  
    <TD><%=SystemEnv.getHtmlLabelName(15775,user.getLanguage())%></TD>
    <td class=Field>
      <input class=inputStyle name="typename" value="<%=typename%>" onChange="checkinput('typename','typenamespan')" >
       <SPAN id="typenamespan">
	   <%if(typename.equals("")){%>
       <IMG src="/images/BacoError.gif" align=absMiddle>
	   <%}%>
       </SPAN>
    </td>
  </tr>   
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <tr>
    <TD><%=SystemEnv.getHtmlLabelName(15790,user.getLanguage())%></TD>  
    <td class=field>
  
        <INPUT class="wuiBrowser" id=contracttempletid type=hidden name=contracttempletid value="<%=contracttempletid%>"
		_url="/systeminfo/BrowserMain.jsp?url=/hrm/contract/contracttemplet/HrmConTempletBrowser.jsp?subcompanyid=<%=subcompanyid%>"
		_required="yes" _displayText="<%=Util.null2String(request.getParameter("templatename")) %>" _callback="$('input[name=templatename]').val(datas.name)">          
		<INPUT type="hidden" name="templatename" value='<%=Util.null2String(request.getParameter("templatename")) %>'/>
    </td>   
  </TR>  
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<!--  
  <tr>  
    <TD class=Field>´æ·ÅÄ¿Â¼ </TD>    
    <td class=Field><input type=text name=saveurl ></td>
  </tr> 
-->  
  <tr>  
    <TD ><%=SystemEnv.getHtmlLabelName(15791,user.getLanguage())%> </TD>    
    <td class=Field>
      <select class=inputstyle name=ishirecontract value="<%=ishirecontract%>">
        <option value="0" <%if(ishirecontract == 0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
        <option value="1" <%if(ishirecontract == 1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
      </select>
    </td>
  </tr> 
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <tr>  
    <TD ><%=SystemEnv.getHtmlLabelName(15792,user.getLanguage())%> </TD>    
    <td class=Field><input class=inputstyle type=text size=3 maxlength=3 name=remindaheaddate value="<%=remindaheaddate%>" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("remindaheaddate")'> </td>
  </tr> 
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <tr>  
    <TD><%=SystemEnv.getHtmlLabelName(15793,user.getLanguage())%> </TD>    
    <td class=Field>
     
     <INPUT  class="wuiBrowser" id="remindman" type=hidden name=remindman value="<%=remindman%>" _param="resourceids"
	 _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" 
	 _displayText="<%=ResourceComInfo.getMulResourcename(remindman)%>"
	 _displayTemplate="<a href=javascript:openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id=#b{id}')>#b{name}</a>&nbsp;">         
    </td>
  </tr> 
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<tr>
    <td ><%=SystemEnv.getHtmlLabelName(15787,user.getLanguage())%></td>
    <td class=field>
        <BUTTON type=button class=Browser onClick="onSelectCategory(1)" name=selectCategory></BUTTON>
        <span id=srcpath name=srcpath><%=path%>
		<%if(saveurl==-1){%>
		<IMG src="/images/BacoError.gif" align=absMiddle/>
		<%}%>
		</span>
    </td>
</tr>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<tr>
    <td>        
        <INPUT class=inputstyle type=hidden name=saveurl value="<%=saveurl%>">
    </td>
</tr> 
<%if(detachable==1){%>
    <tr>
        <td ><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></td>
        <td colspan=5 class=field >
		    <INPUT class="wuiBrowser" id=subcompanyid type=hidden name=subcompanyid value="<%=subcompanyid%>"
			_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp"
			_required="yes"
			_displayText="<%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subcompanyid))%>">
			
        </td>
    </tr>
    <tr class="Spacing" style="height:1px"><td colspan=6 class="Line"></td></tr>
<%}%>
  </tbody>      
</table>
</form>
<script language=javascript>
    function onSelectCategory(whichcategory) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp");
	
	if (result != null) {
	    if (result.tag > 0)  {
    	    if (whichcategory == 1) {
    	        //location = "HrmContractTypeAdd.jsp?saveurl="+result[1]
    	        document.contracttype.saveurl.value=result.id;
    	    } else {
    	        //location = "HrmContractTypeAdd.jsp?saveurl="+document.all("srcsecid").value
    	        document.contracttype.saveurl.value=document.all("srcsecid").value;
    	    }
			
    	}else{
			document.contracttype.saveurl.value=-1;
		}
    	document.contracttype.action="HrmContractTypeAdd.jsp";
    	document.contracttype.submit();
	}
}

  function dosave(){
   if(document.contracttype.contracttempletid.value == ""){
     alert("<%=SystemEnv.getHtmlLabelName(15794,user.getLanguage())%>!!!");
   }else{
	 if(document.contracttype.saveurl.value=="-1"||document.contracttype.saveurl.value==""){
		alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
		return false;
	 }
     if(check_form(document.contracttype,'typename,subcompanyid1')){
		document.contracttype.operation.value = "add";
		document.contracttype.submit();
	}
  }
  }
  function mainchange(){
    document.contracttype.action="HrmContractTypeAdd.jsp";
    document.contracttype.submit();
  }
  function subchange(){
    document.contracttype.action="HrmContractTypeAdd.jsp";
    document.contracttype.submit();
  }
</script>
</body>
</html>