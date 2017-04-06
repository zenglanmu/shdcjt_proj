<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("DocTypeAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<SCRIPT language="javascript" >
function checkSubmit(){
	var languageid=<%=user.getLanguage()%>;
	if(check_form(weaver,'frontpagename')){
	    if(document.all("newsperpage").value != "" && document.all("newsperpage").value*1<=0){
	    	alert("<%=SystemEnv.getHtmlLabelName(23259,user.getLanguage())%>");
	      return;
	    }else if(document.all("titlesperpage").value != "" && document.all("titlesperpage").value*1<=0){
	    	alert("<%=SystemEnv.getHtmlLabelName(23260,user.getLanguage())%>");
	      return;
	    }
	    weaver.submit();
	}
}

</script>
</head>
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(70,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/news/DocNews.jsp,_self} " ;
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
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<FORM id=weaver name=weaver action="NewsOperation.jsp" method=post >

</DIV>
  <TABLE class=ViewForm>
    <COLGROUP>
    <COL width="15%"> <COL width="35%">
     <COL width=15> <COL width="35%">
     <TBODY>
    <TR class=Title>
      <TH colSpan=4><%=SystemEnv.getHtmlLabelName(316,user.getLanguage())%></TH>
    </TR>
     <TR class=Spacing style='height:1px'>
      <TD class=Line1 colSpan=4></TD>
    </TR>
    <TR>
      <td><%=SystemEnv.getHtmlLabelName(1996,user.getLanguage())%></td>
      <td class=field>
        <input type=radio name="languageid" value="7" checked ><%=SystemEnv.getHtmlLabelName(1997,user.getLanguage())%>
        <input type=radio name="languageid" value="8"><%=SystemEnv.getHtmlLabelName(1998,user.getLanguage())%>
        <input type=radio name="languageid" value="9" ><%=SystemEnv.getHtmlLabelName(23261,user.getLanguage())%>
      </td>
      <TD ><%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%></TD>
      <TD class=Field>
        <INPUT class=InputStyle name=isactive value=1 type=checkbox checked></TD>
    </TR>
<tr  style="height: 1px"><td class=Line colspan=4></TD></TR>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(70,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
      <TD class=Field>
      <INPUT class=InputStyle name=frontpagename onChange="checkinput('frontpagename','frontpagespan')" >
        <span id=frontpagespan><IMG src='/images/BacoError.gif' align=absMiddle></span></TD>
      <TD><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%>
      </TD>
      <TD class=Field>
        <INPUT class=wuiBrowser _displayTemplate="<a href='/docs/tools/DocPicUploadEdit.jsp?id=#b{id}'>#b{name}</a>" _url="/systeminfo/BrowserMain.jsp?url=/docs/tools/DocPicBrowser.jsp?pictype=1" type=hidden name=defnewspicid>
      </TD>
    </TR>
<tr  style="height: 1px"><td class=Line colspan=4></TD></TR>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>
      </TD>
      <TD class=Field>
        <input class=InputStyle name=frontpagedesc>
      </TD>
      <TD><%=SystemEnv.getHtmlLabelName(334,user.getLanguage())%></TD>
      <TD class=Field>
        <INPUT class=wuiBrowser _url="/systeminfo/BrowserMain.jsp?url=/docs/tools/DocPicBrowser.jsp?pictype=3" 
        _displayTemplate="<a href='/docs/tools/DocPicUploadEdit.jsp?id=#b{id}'>#b{name}</a>"
        type=hidden name=backgroundpicid>
      </TD>
    </TR>
<tr  style="height: 1px"><td class=Line colspan=4></TD></TR>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>
      </TD>
      <TD class=Field>
        <INPUT class=InputStyle name=hasdocsubject value=1 type=checkbox></TD>
      </TD>
      <TD><%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(70,user.getLanguage())%></TD>
      <TD class=Field>
      <INPUT class=InputStyle name=hasfrontpagelist value=1 type=checkbox></TD>
      </TD>
    </TR>
<tr  style="height: 1px"><td class=Line colspan=4></TD></TR>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(264,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(265,user.getLanguage())%></TD>
      <TD class=Field>
        <INPUT class=InputStyle maxLength=2 size=13 value=10 name=newsperpage>
      </TD>

      <TD><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(265,user.getLanguage())%></TD>
      <TD class=Field>
        <INPUT class=InputStyle maxLength=2 size=13 value=8 name=titlesperpage>
      </TD>
    </tr>

 <tr  style="height: 1px"><td class=Line colspan=4></TD></TR>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(19789,user.getLanguage())%></TD>
      <TD class=Field>
         <select class=InputStyle  name=newstypeid style="width:35%">
			<%
				rs.executeSql("select id,typename from newstype order by dspnum");
				while(rs.next()){
			%>	
				<option value="<%=rs.getString("id")%>"><%=rs.getString("typename")%></option>
			<%}%>
		 </select>
      </TD>

      <TD><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>
      <TD class=Field>
        <INPUT class=InputStyle maxLength=3 size=3 name=typeordernum>
      </TD>
    </TR>


<tr  style="height: 1px"><td class=Line colspan=4></TD></TR>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(1993,user.getLanguage())%></td>
      <td class=field>
        <select class=InputStyle  name=publishtype size=1>
        	<option value="1"><%=SystemEnv.getHtmlLabelName(1994,user.getLanguage())%></option>
        	<option value="0"><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%></option>
			<%if(isgoveproj==0){%>
<%if(isPortalOK){%><!--portal begin-->
       <%while(CustomerTypeComInfo.next()){
       		String curid=CustomerTypeComInfo.getCustomerTypeid();
       		String curname=CustomerTypeComInfo.getCustomerTypename();
       		String value="-"+curid;
       %>
       		<option value="<%=value%>"><%=Util.toScreen(curname,user.getLanguage())%></option>
       <%
       }%>
<%}%><!--portal end-->
<%}%>
        </select>
      </td>
    </TR>
<tr  style="height: 1px"><td class=Line colspan=4></TD></TR>

    <TR class=Title>
      <TH colSpan=4><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TH>
    </TR>
<tr  style="height: 1px"><td class=Line colspan=4></TD></TR>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(224,user.getLanguage())%></TD>
      <TD class=Field colspan=3>
      
        <INPUT class=wuiBrowser _url="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?initwhere=doctype<>2" 
        _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>"
        type=hidden name=headerdocid> 
      </TD>
    </TR>
<tr  style="height: 1px"><td class=Line colspan=4></TD></TR>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(322,user.getLanguage())%></TD>
      <TD class=Field colspan=3>
       <INPUT class="wuiBrowser" _url="/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp" _param="documentids" 
       _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>&nbsp"
       type=hidden name=importdocid value="">
       
      </TD>
    </TR>
<tr  style="height: 1px"><td class=Line colspan=4></TD></TR>
     <TR>
      <TD><%=SystemEnv.getHtmlLabelName(323,user.getLanguage())%></TD>
      <TD class=Field colspan=3>
        <INPUT class=wuiBrowser _url="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?initwhere=doctype<>2"
        _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>"
         type=hidden name=footerdocid>
      </TD>
    </TR>
<tr  style="height: 1px"><td class=Line colspan=4></TD></TR>
    </TBODY>
  </TABLE>

<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="15%">
  <COL width="33%">
  <COL width=24>
  <COL width="15%">
  <COL width="33%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=5><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
  </TR>

<tr  style="height: 1px"><td class=Line colspan=5></TD></TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD class=Field>
      <INPUT class=wuiBrowser _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp" type=hidden name=continuedepart>
       </TD>
    <TD></TD>
    <%if(isMultilanguageOK){   //  多语言版本， 在 init.jsp 中获得判断 %>
    <TD><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></TD>
    <TD class=Field>
      <INPUT class=wuiBrowser _url="/systeminfo/language/LanguageBrowser.jsp" type=hidden name=continuelanguagenameid>
      </TD>
    <% } else { %>
      <TD></TD>
    <TD></TD>
    <%}%>
      </TR>
<tr  style="height: 1px"><td class=Line colspan=5></TD></TR>
  <TR>
      <TD><%=SystemEnv.getHtmlLabelName(328,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
    <TD class=Field>
        <input class=InputStyle maxlength=2 size=10 name=continuetime>
        <%=SystemEnv.getHtmlLabelName(329,user.getLanguage())%></TD>
    <TD></TD>
      <TD></TD>
    <TD></TD>
   </TR>
<tr  style="height: 1px"><td class=Line colspan=5></TD></TR>

<TR>
    <TD valign=top><%=SystemEnv.getHtmlLabelName(15610,user.getLanguage())%></TD>
    <TD class=Field colspan=4>
        <TEXTAREA name=condition class=InputStyle rows=3 style="width:100%"></TEXTAREA>
    </TD>       
   </TR>
   <TR style="height: 1px!important;"><TD class=Line colSpan=5></TD></TR>
   <TR>
    <TD></TD>
    <TD class=Field colspan=3>
        <%=SystemEnv.getHtmlLabelName(18541,user.getLanguage())%>:maincategory=29 and subcategory=23
    </TD>       
   </TR>  
       <TR style="height: 1px!important;"><TD class=Line colSpan=5></TD></TR>
   </TBODY></TABLE>
   </SPAN>
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
<input type=hidden name=operation value=add>
</FORM>
</BODY></HTML>