<%@ page language="java" contentType="text/html; charset=GBK" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>

<script language=javascript src="/js/weaver.js"></script>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<%

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(22764,user.getLanguage())+"£º"+SystemEnv.getHtmlLabelName(141,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>

</head>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<br>

<%

    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;

    if(detachable==1){  
        if(request.getParameter("subCompanyId")==null){
            subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managestruabbr_subCompanyId")),-1);
        }else{
            subCompanyId=Util.getIntValue(request.getParameter("subCompanyId"),-1);
        }
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        session.setAttribute("managestruabbr_subCompanyId",String.valueOf(subCompanyId));
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"StruAbbr:Maintenance",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("StruAbbr:Maintenance", user))
            operatelevel=2;
    }
    
    String subCompanyNameOfSearch = Util.null2String(request.getParameter("subCompanyNameOfSearch"));
%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearchForm(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;

if(operatelevel>=1){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
}
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>



<form name="formstruabbr" method="post" action="/workflow/workflow/managestruabbr_operation.jsp">
<input type=hidden name=operation value="managestruabbr_subcompany">
<input type=hidden name=subCompanyId value="<%=subCompanyId%>">

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

     <table class=viewform cellspacing=1  >
     	<COLGROUP>
     	<COL width="20%">
        <COL width="20%">
     	<COL width="10%">
        <COL width="20%">
     	<COL width="20%">
        <COL width="10%">

        <tr class=header>
            <td><%=SystemEnv.getHtmlLabelName(1878,user.getLanguage())%></td>
            <td class=field colspan=5><input type=text name=subCompanyNameOfSearch class=Inputstyle value="<%=subCompanyNameOfSearch%>"></td>
        </tr>
        <TR>
		    <TD height="10" colspan="6"></TD>
        </TR>
     </table>

     <table class=liststyle cellspacing=1  >
     	<COLGROUP>
     	<COL width="50%">
        <COL width="50%">
        <TR class="Header">
          <td><%=SystemEnv.getHtmlLabelName(1878,user.getLanguage())%></td>
          <td><%=SystemEnv.getHtmlLabelName(22764,user.getLanguage())%></td>
        </tr><TR class=Line><TD colspan="2" ></TD></TR>

<%
if(operatelevel>-1){

    int rowNum=0;

    String trClass="DataLight";

    int tempSubCompanyId=0;
    String tempSubCompanyName=null;
    int tempSubComAbbrDefId=0;
    String tempAbbr =null;

    StringBuffer abbrSb=new StringBuffer();
    abbrSb.append(" select HrmSubCompany.id as subCompanyId,HrmSubCompany.subCompanyName,workflow_subComAbbrDef.id as subComAbbrDefId,workflow_subComAbbrDef.abbr ")
	      .append("   from HrmSubCompany left join  workflow_subComAbbrDef ")
	      .append("     on HrmSubCompany.id=workflow_subComAbbrDef.subCompanyId ")
	      .append("  where (HrmSubCompany.canceled is null or HrmSubCompany.canceled='0') ");
    if(!subCompanyNameOfSearch.equals("")){
		abbrSb.append("    and HrmSubCompany.subCompanyName like '%").append(subCompanyNameOfSearch).append("%' ");
	}
    abbrSb.append("  order by HrmSubCompany.showOrder asc,HrmSubCompany.id asc ");

    RecordSet.executeSql(abbrSb.toString());
    while(RecordSet.next()){
	    tempSubCompanyId     =Util.getIntValue(RecordSet.getString("subCompanyId"),0);
	    tempSubCompanyName   =Util.null2String(RecordSet.getString("subCompanyName"));
	    tempSubComAbbrDefId  =Util.getIntValue(RecordSet.getString("subComAbbrDefId"),0);
	    tempAbbr=Util.null2String(RecordSet.getString("abbr"));

%>
        <TR class="<%=trClass%>">

            <td  height="23" align="left"><%=tempSubCompanyName%>
            <input type="hidden" name="abbr<%=rowNum%>_subCompanyId" value="<%=tempSubCompanyId%>">
            </td>
            <input type="hidden" name="abbr<%=rowNum%>_subComAbbrDefId" value="<%=tempSubComAbbrDefId%>">
            <td  height="23" align="left">
<%
		if(operatelevel>=1){
%>
		    <input class=Inputstyle type="text" name="abbr<%=rowNum%>_abbr" value="<%=tempAbbr%>" maxlength=50 >
<%
		}else{
%>
		    <%=tempAbbr%>
<%
		}
%>
            </td>
        </tr>

<%
        rowNum+=1;
        if(trClass.equals("DataLight")){
		    trClass="DataDark";
	    }else{
		    trClass="DataLight";
	    }
    }
%>
    <input type="hidden" value="<%=rowNum%>" name="rowNum">
<%
}
%>

      </table>


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



</form>

   <script language="javascript">
function submitData(){
		formstruabbr.submit();
}

function doSearchForm(){
    formstruabbr.action = "/workflow/workflow/managestruabbr_subcompany.jsp";
    formstruabbr.submit();
}
</script>

</body>
</html>
