<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BankComInfo" class="weaver.hrm.finance.BankComInfo" scope= "page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<HTML>
<%
String id = request.getParameter("id");
String isView = request.getParameter("isView");
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;

int hrmid = user.getUID();
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel=0;
if(detachable==1){
    String deptid=ResourceComInfo.getDepartmentID(id);
    String subcompanyid=DepartmentComInfo.getSubcompanyid1(deptid)  ;
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmResourceEdit:Edit",Integer.parseInt(subcompanyid));
}else{
    if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user))
        operatelevel=2;
}
boolean isf = ResourceComInfo.isFinInfoView(hrmid,id);
if(!(isf&&operatelevel>0)){
	response.sendRedirect("/notice/noright.jsp") ;
}

%>
<HEAD>
  <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(189,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %> 
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:edit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:viewFinanceInfo(),_self} " ;
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
<FORM name=resourcefinanceinfo id=resource action="HrmResourceOperation.jsp" method=post enctype="multipart/form-data">
<input type=hidden name=operation>
<input type=hidden name=id value="<%=id%>">
<input type=hidden name=isView value="<%=isView%>">
<input type=hidden name=isfromtab value="<%=isfromtab%>">
<TABLE class=viewForm>
    <COLGROUP> 
    <COL width="49%"> 
    <COL width=10> 
    <COL width="49%"> 
	<TBODY> 
    <TR> 
      <TD vAlign=top> 
      <TABLE width="100%">
          <COLGROUP> 
          <COL width=20%> 
          <COL width=80%>
	      <TBODY> 
          <TR class=title> 
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15805,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing style="height:2px"> 
            <TD class=line1 colSpan=2></TD>
          </TR>	

 <%
  String sql = "";
  sql = "select * from HrmResource where id = "+id;  
  rs.executeSql(sql);
  while(rs.next()){
    String bankid1 = Util.null2String(rs.getString("bankid1"));
    String accountid1 = Util.null2String(rs.getString("accountid1"));
    String accumfundaccount = Util.null2String(rs.getString("accumfundaccount"));    
%>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15812,user.getLanguage())%></TD>           
             <TD class=Field>

              <input class="wuiBrowser" id=bankid1 type=hidden name=bankid1 value="<%=bankid1%>"
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/finance/bank/BankBrowser.jsp"
			  _displayText="<%=BankComInfo.getBankname(bankid1)%>">
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(16016,user.getLanguage())%></TD>
            <TD class=Field> 
              <input type=text name="accountid1" value="<%=accountid1%>">
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
	      <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(16085,user.getLanguage())%></TD>
            <TD class=Field> 
              <input type=text name="accumfundaccount" value="<%=accumfundaccount%>">
            </TD>
          </TR>	    
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<%
  }
%>    
 	      </tbody>
       </table>
   </tr>
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
<script language=vbs>
sub onShowBank(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/finance/bank/BankBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
	else 
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub
</script>
<script language=javascript>
  function edit(){
  	  document.resourcefinanceinfo.operation.value="addresourcefinanceinfo";
	  document.resourcefinanceinfo.submit();
  }
  
  function viewFinanceInfo(){    
    location = "/hrm/resource/HrmResourceFinanceView.jsp?id=<%=id%>&isView=<%=isView%>";
  }
</script> 
</BODY>
</HTML>