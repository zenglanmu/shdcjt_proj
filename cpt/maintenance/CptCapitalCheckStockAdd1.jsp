<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>

<%

if(!HrmUserVarify.checkUserRight("CptCapitalCheckStockAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(1506,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<FORM id=weaver name=frmain method=post onSubmit="onSubmit()">
<DIV class=HdrProps></DIV>
<BUTTON class=btnSave accessKey=S onclick="onSubmit()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(1402,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=B onclick='window.history.back(-1)'><U>B</U>-<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></BUTTON>
  <TABLE class=form>
    <COLGROUP> <COL width="15%"> <COL width="85%"> <TBODY> 
   	<tr> 
      <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
      <td class=Field><button class=Browser id=SelectDeparment onClick="onShowDepartment()"></button> 
        <span class=saveHistory id=departmentspan></span> 
        <input id=departmentid type=hidden name=departmentid>
      </td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(1387,user.getLanguage())%></td>
      <td class=Field> 
        <input type=text size=60 maxlength=100 name="location" >
      </td>
    </tr>
   </TBODY> 
  </TABLE>
 </form>
 <script language=vbs>
 sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmain.departmentid.value)
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = frmain.departmentid.value then
		issame = true 
	end if
	departmentspan.innerHtml = id(1)
	frmain.departmentid.value=id(0)
	else
	departmentspan.innerHtml = ""
	frmain.departmentid.value=""
	end if
	end if
end sub

</script>
 <script language="javascript">
 function onSubmit(){
 	if((frmain.departmentid.value=="")&&(frmain.location.value=="")){
		alert('<%=SystemEnv.getHtmlLabelName(15318,user.getLanguage())%>');
	}else{
        document.frmain.action="CptCapitalCheckStockAdd2.jsp"
		document.frmain.submit();
    }
 }
 </script>
</BODY></HTML>
