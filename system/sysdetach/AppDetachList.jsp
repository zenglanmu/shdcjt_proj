<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>

<%@ include file="/systeminfo/init.jsp" %>
<% if(!HrmUserVarify.checkUserRight("AppDetach:All", user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>

<BODY>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(24333,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
//初始化值
String searchname = Util.null2String(request.getParameter("searchname"));

//页标题

RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(this),_self}" ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",AppDetachEdit.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(24334,user.getLanguage())+",AppDetachReport.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

//backFields
String backFields=Util.toHtmlForSplitPage(" id,name,description ");

//from
String sqlFrom = " SysDetachInfo ";

//where
String sqlWhere = "";
if(searchname!=null&&!"".equals(searchname)) sqlWhere+= " name like '%" + searchname + "%' ";

//orderBy
String orderBy = "id";

//primarykey
String primarykey = "id";

//pagesize
int pagesize=10;

//colString
String colString ="<col width=\"35%\" text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" target=\"_self\" href=\"AppDetachEdit.jsp\" linkkey=\"id\" linkvaluecolumn=\"id\" />";
       colString+="<col width=\"65%\" text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"description\" orderkey=\"description\" />";

//operateString


String tableString="<table  pagesize=\""+pagesize+"\" tabletype=\"none\">";
       tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlorderby=\""+orderBy+"\" sqlprimarykey=\""+primarykey+"\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\"/>";
       tableString+="<head>"+colString+"</head>";

       tableString+="</table>";
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0" valign="top">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<TD valign="top">
		<TABLE class=Shadow valign="top">
		<TR>
            <TD valign="top">
            <FORM name="frmSearch" method="post" action="">
                <TABLE class=ViewForm valign="top">
                    <TR valign="top">
                        <TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
                         <TD CLASS="Field" WIDTH=*>
                          <INPUT type=text name=searchname class=InputStyle size=20 value="<%=searchname%>" >
                         </TD>

                    </TR>
                    <TR><TD class=Line colSpan=2></TD></TR>
                     <TR>
                         <TD valign="top" bgcolor="#FF6666" colspan=2>
                             <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run"/>
                          </TD>
                     </TR>
                </TABLE>
                </FORM>
             </TD>
         </TR>
         </TABLE>
    </TD>
    <td ></td>
</TR>
</TABLE>

</BODY>
</HTML>
<script language="javaScript">
    function onSearch(){
        frmSearch.submit();
    }
</script>