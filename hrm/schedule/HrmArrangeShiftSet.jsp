<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<HTML>

<%
if(!HrmUserVarify.checkUserRight("HrmArrangeShiftMaintance:Maintance", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String isself = Util.null2String(request.getParameter("isself"));
String department = Util.fromScreen(request.getParameter("department") , user.getLanguage()) ; //部门
String fromdate = Util.fromScreen(request.getParameter("fromdate") , user.getLanguage()) ; //排班日期从
String enddate = Util.fromScreen(request.getParameter("enddate") , user.getLanguage()) ; //排班日期到
if(!department.equals("")) isself = "1" ;

ArrayList resourceids = new ArrayList() ;

String sql = " select * from HrmArrangeShiftSet " ;
rs.executeSql(sql);
while ( rs.next() ) {
    String resourceid = Util.null2String(rs.getString("resourceid"));  
    resourceids.add( resourceid ) ;
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(16749 , user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<HEAD>
  <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
  <SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>    
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:document.frmmain.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/schedule/HrmArrangeShiftMaintance.jsp?department="+department+"&fromdate="+fromdate+"&enddate="+enddate+",_self} " ;
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

<FORM name=frmmain action="HrmArrangeShiftSetOperation.jsp" method=post>
<input type="hidden" name="isself" value="1">
<input type="hidden" name="fromdate" value="<%=fromdate%>">
<input type="hidden" name="enddate" value="<%=enddate%>">

<table class =viewform>
<tbody>
 <TR class=Title>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%></TH>
  </TR>
<TR CLASS=Spacing style="height:2px"><TD colspan = 2 class=Line1></TD></TR>
<tr>
    <TD width=10%><%=SystemEnv.getHtmlLabelName(124 , user.getLanguage())%></TD>
    <TD class = Field>

    <input class="wuiBrowser" id=department type=hidden name=department value="<%=department%>"
	_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
	_displayText="<%=Util.toScreen(DepartmentComInfo.getDepartmentmark(department),user.getLanguage())%>">
    </TD>
</tr>
 <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
</tbody>
</table>
<br>

<% if(isself.equals("1")) { %>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="5%">
  <COL width="40%">
  <COL width="55%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(16749 , user.getLanguage())%></TH></TR>
    <TR class=Header>
    <td><input type="checkbox" name="chkdeptid" value="chkdeptid" onClick="CheckAll(this)"></td>
    <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
  </TR>

<% 

// 从人力资源数据库中获取在职人员
sql = "select id, lastname , departmentid from Hrmresource where status in (0,1,2,3) "; 

if(!department.equals("")) sql += " and departmentid = " + department ;

String rightlevel = HrmUserVarify.getRightLevel("HrmArrangeShiftMaintance:Maintance" , user ) ;

if(rightlevel.equals("0") ) {
    sql += " and departmentid = " + user.getUserDepartment() ; 
}
else if(rightlevel.equals("1") ) {
    sql += " and subcompanyid1 = " + user.getUserSubCompany1() ; 
}


sql += " order by departmentid "; 

String selectresourceid = "" ;      // 用于删除的时候，只删除选中了的人力资源

rs.executeSql(sql); 
boolean isLight = false ; 
while(rs.next()){ 
    String	id = Util.null2String( rs.getString("id") ); 
    String  lastname = Util.toScreen( rs.getString("lastname") , user.getLanguage()); 
    String  departmentid = Util.null2String( rs.getString("departmentid") ); 

    if(selectresourceid.equals("")) selectresourceid = id ;
    else selectresourceid += "," + id ;

    boolean  arrangeshiftable = false ;
    int resourceidindex = resourceids.indexOf(id) ;
    if( resourceidindex != -1 ) arrangeshiftable = true ;
    
    isLight = !isLight ;
%> 
    <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
       <TD><input type='checkbox' name="resourceids" value="<%=id%>" <% if( arrangeshiftable ) {%>checked<%}%>></TD>
       <TD><a target="_blank" href="/hrm/resource/HrmResource.jsp?id=<%=id%>"><%=lastname%></a></TD> 
       <TD><%=DepartmentComInfo.getDepartmentname(departmentid)%></TD> 
      </TR>
    <% 
} 
%>
</TBODY></TABLE>
<input type="hidden" name="selectresourceid" value="<%=selectresourceid%>">
<%}%>
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

<script language = vbs>  
sub onShowDepartment(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&inputname.value)
	if Not isempty(id) then
	if id(0)<> 0 then
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

function submitData() {
    document.frmmain.action="HrmArrangeShiftSet.jsp" ; 
    document.frmmain.submit();
}
function CheckAll(obj) {
	var chks=document.getElementsByName("resourceids");
	for(var i=0;i<chks.length;i++)chks[i].checked=obj.checked;

}
</script>

</BODY>
</HTML>