<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput.js"></script>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<body>
<%
String id = Util.null2String(request.getParameter("id"));
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(716,user.getLanguage());
String needfav ="1";
String needhelp ="";

String typename = Util.null2String(request.getParameter("typename"));
int saveurl = Util.getIntValue(request.getParameter("saveurl"),-1);
String templetid = Util.null2String(request.getParameter("contracttempletid"));
String ishirecontract = Util.null2String(request.getParameter("ishirecontract"));
String remindaheaddate = Util.null2String(request.getParameter("remindaheaddate"));
String remindman = Util.null2String(request.getParameter("remindman"));
int subcompanyid = Util.getIntValue((request.getParameter("subcompanyid")));
session.setAttribute("HrmContractTypeEditDo_",String.valueOf(subcompanyid));
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String sql = "select * from HrmContractType where id = "+id;
rs.executeSql(sql);
while(rs.next()){
    if(typename.equals("")){
        typename  = Util.null2String(rs.getString("typename"));
    }      
    if(saveurl==-1){
        saveurl  = Util.getIntValue(rs.getString("saveurl"),-1);
    }      
    if(templetid.equals("")){
        templetid  = Util.null2String(rs.getString("contracttempletid"));
    }      
    if(ishirecontract.equals("")){
        ishirecontract  = Util.null2String(rs.getString("ishirecontract"));
    }      
    if(remindaheaddate.equals("")){
        remindaheaddate  = Util.null2String(rs.getString("remindaheaddate"));
    }      
    if(remindman.equals("")){
        remindman  = Util.null2String(rs.getString("remindman"));
    }
}    

String path = "";
if (saveurl != -1) {
    path = "/"+CategoryUtil.getCategoryPath(saveurl);
}
%>
<%
	boolean canDelete = false;
	sql ="Select ID From HrmContract where ContractTypeID = "+id;
	RecordSet.executeSql(sql);
	RecordSet.next();
		if(Util.null2String(RecordSet.getString("ID")).equals(""))
			canDelete = true;


%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmContractTypeEdit:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmContractTypeDelete:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:dodelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/contract/contracttype/HrmContractTypeEdit.jsp?id="+id+",_self} " ;
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
<input class=inputStyle type=hidden name=operation>
<input class=inputStyle type=hidden name=id value="<%=id%>">
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
<%
  
%>  
  <tr>  
    <TD ><%=SystemEnv.getHtmlLabelName(15775,user.getLanguage())%> </TD>
    <td class=Field>
       <input class=inputStyle  name="typename" value="<%=typename%>" onChange='checkinput("typename","typenamespan")' >
       <SPAN id="typenamespan">       
       </SPAN>
    </td>
  </tr>   
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <tr>
    <TD> <%=SystemEnv.getHtmlLabelName(15790,user.getLanguage())%> </TD>  
    <td class=Field>
<%
  sql = "select templetname from HrmContractTemplet where id = "+templetid;
  
  rs2.executeSql(sql);
  String templetname = "";
  while(rs2.next()){
    templetname = rs2.getString("templetname");
  }  
%>     

        <INPUT class="wuiBrowser" id=contracttempletid type=hidden name=contracttempletid value="<%=templetid%>"
		_url="/systeminfo/BrowserMain.jsp?url=/hrm/contract/contracttemplet/HrmConTempletBrowser.jsp?subcompanyid=<%=subcompanyid%>"
		_required="yes" _displayText="<%=templetname%>">                 
       
    </td>  
  </TR>  
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<!--  
  <tr>  
    <TD class=Field>´æ·ÅÄ¿Â¼ </TD>    
    <td class=Field><input type=text name=saveurl value="<%=saveurl%>"></td>
  </tr> 
-->  
  <tr>  
    <TD ><%=SystemEnv.getHtmlLabelName(15791,user.getLanguage())%> </TD>        
    <td class=Field>
      <select class=inputStyle name=ishirecontract value="<%=ishirecontract%>">
        <option value="0" <%if(ishirecontract.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
        <option value="1" <%if(ishirecontract.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
      </select>      
    </td>
  </tr> 
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <tr>  
    <TD ><%=SystemEnv.getHtmlLabelName(15792,user.getLanguage())%> </TD>    
    <td class=Field><input class=inputstyle type=text name=remindaheaddate value="<%=remindaheaddate%>" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("remindaheaddate")'> </td>
  </tr> 
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <tr>  
    <TD ><%=SystemEnv.getHtmlLabelName(15793,user.getLanguage())%> </TD>    
    <td class=Field>

      <INPUT class="wuiBrowser" id=remindman type=hidden name=remindman value="<%=remindman%>" _param="resourceids"
	  _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" 
	  _displayTemplate="<a href=javascript:openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id=#b{id}')>#b{name}</a>&nbsp;"
	  _displayText="<%=ResourceComInfo.getMulResourcename(remindman)%>">      
    </td>
  </tr> 
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<tr>
    <td ><%=SystemEnv.getHtmlLabelName(15787,user.getLanguage())%></td>
    <td class=field>
        <BUTTON type="button" class=Browser onClick="onSelectCategory(1)" name=selectCategory></BUTTON>
        <span id=srcpath name=srcpath><%=path%></span>    
        <INPUT class=inputStyle type=hidden name=saveurl id="saveurl" value="<%=saveurl%>">
    </td>
</tr>   
<%if(detachable==1){%>
    <tr>
        <td ><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></td>
        <td colspan=5 class=field >

		    <INPUT class="wuiBrowser" id=subcompanyid type=hidden name=subcompanyid value="<%=subcompanyid%>"
			_required="yes" _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp" 
			_displayText="<%=SubCompanyComInfo.getSubCompanyname(""+subcompanyid) %>">
			
        </td>
    </tr>
    <tr class="Spacing" style="height:1px"><td colspan=6 class="Line"></td></tr>
<%}%>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>   </tbody>      
</table>
</form>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
 

<script language=javascript>
function onSelectCategory(whichcategory) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp");
	if (result) {
	    if (wuiUtil.getJsonValueByIndex(result,0)> 0)  {
    	    if (whichcategory == 1) {
    	        //location = "HrmContractTypeAdd.jsp?saveurl="+result[1]
    	        jQuery("#saveurl").val(wuiUtil.getJsonValueByIndex(result,1));
    	        //document.contracttype.saveurl.value=wuiUtil.getJsonValueByIndex(result,1);
    	    } else {
    	        //location = "HrmContractTypeAdd.jsp?saveurl="+document.all("srcsecid").value
    	        jQuery("#saveurl").val($GetEle("srcsecid").value);
    	        //document.contracttype.saveurl.value=document.all("srcsecid").value;
    	    }    	 
    	}
    	document.contracttype.action="HrmContractTypeEditDo.jsp";
    	document.contracttype.submit();
	}
}
  function dosave(){
   if(document.contracttype.contracttempletid.value == ""){
     alert("<%=SystemEnv.getHtmlLabelName(15794,user.getLanguage())%>!!!");
   }else{
    if(check_form(document.contracttype,'typename,subcompanyid')){
    document.contracttype.operation.value = "edit";
    document.contracttype.submit();
   }
   }
  }
  function dodelete(){
	  <%if(canDelete) {%>
    if(confirm("<%=SystemEnv.getHtmlLabelName(17048,user.getLanguage())%>")){
      document.contracttype.operation.value = "delete";
      document.contracttype.submit();
    }
	<%}else{%>
			alert("<%=SystemEnv.getHtmlLabelName(17049,user.getLanguage())%>");
		<%}%>
  }
  function mainchange(){
    document.contracttype.action="HrmContractTypeEditDo.jsp";
    document.contracttype.submit();
  }
  function subchange(){
    document.contracttype.action="HrmContractTypeEditDo.jsp";
    document.contracttype.submit();
  }
  function submitData() {
 contracttype.submit();
}

</script>
</body>
</html>