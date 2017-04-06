<%@ page import="weaver.general.Util,
                 weaver.hrm.resign.ResignProcess,
                 weaver.hrm.resign.CustomDetail" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%
String id=Util.null2String(request.getParameter("id"));
//当前用户为记录本人或者其上级或者具有“离职审批”权限则可查看此页面
String userId = "" + user.getUID();
String managerId = ResourceComInfo.getManagerID(id);
if(!userId.equals(id) && !userId.equals(managerId) && !HrmUserVarify.checkUserRight("Resign:Main", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(17571,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%





boolean hasNextPage=false;


int total=Util.getIntValue(Util.null2String(request.getParameter("total")),1);
int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
int perpage=Util.getIntValue(Util.null2String(request.getParameter("perpage")),10);
ArrayList customers=ResignProcess.getCustomDetail(id,start,perpage,user.getLanguage());
if(total>start*perpage){
	hasNextPage=true;
}


%>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>


<FORM id=weaver name=frmmain method=post action="Customers.jsp">
<input name=start type=hidden value="<%=start%>">
<input name=total type=hidden value="<%=total%>">
<input name=id type=hidden value="<%=id%>">
<input name=perpage type=hidden value="<%=perpage%>">
</form>
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

<TABLE class=ListStyle cellspacing=1>
  <TBODY>
  
  <TR class=Header>
  <th ><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></th>
  
  </tr>
  <TR class=Line><TD ></TD></TR>
  <%
boolean islight=true;
int totalline=1;

Iterator iter=customers.iterator();
while(iter.hasNext()){
        CustomDetail customer=(CustomDetail)iter.next();
	String customerid=customer.getId();
	String name=customer.getCustomer();
	
	
%>
    <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
  <td ><A
  href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=customerid%>"><B><%=name%></B></A>&nbsp;
  </td>
  
  
  </tr>
  

<%
	islight=!islight;
	if(hasNextPage){
		totalline+=1;
		if(totalline>perpage)	break;
	}
}
%>
  </tbody>
</table>


<table align=right>
   <tr>
   <td>&nbsp;</td>
   <td>
   <%if(start>1){%>
   <%

RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:OnChangePage("+(start-1)+"),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
     <%}%>
 <td><%if(hasNextPage){%>
      <%

RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:OnChangePage("+(start+1)+"),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>     <%}
if(HrmUserVarify.checkUserRight("HrmRrightTransfer:Tran", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(16528,user.getLanguage())+",/hrm/transfer/HrmRightTransfer.jsp,_self}" ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:returnMain(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;

%>
 <td>&nbsp;</td>
   </tr>
	  </TABLE>
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

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<SCRIPT language="javascript">
function OnChangePage(start){
        document.frmmain.start.value = start;
		document.frmmain.submit();
}

function returnMain(){
        window.location="/hrm/resign/Resign.jsp?resourceid=<%=id%>";
}
</script>
</BODY></HTML>