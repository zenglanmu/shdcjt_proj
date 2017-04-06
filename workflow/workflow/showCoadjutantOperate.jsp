<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.*" %>
 <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%

String coadjutantpost = Util.null2String(request.getParameter("coadjutantpost"));
String coadjutantclear = Util.null2String(request.getParameter("coadjutantclear"));
int IsCoadjutant = Util.getIntValue(Util.null2String(request.getParameter("iscoadjutant")),0);
int signtype = Util.getIntValue(Util.null2String(request.getParameter("signtype")),2);
String coadjutants=Util.null2String(request.getParameter("coadjutants"));
String coadjutantnames=Util.null2String(ResourceComInfo.getLastname(coadjutants));
int issubmitdesc = Util.getIntValue(Util.null2String(request.getParameter("issubmitdesc")),0);
int ispending=Util.getIntValue(Util.null2String(request.getParameter("ispending")),0);
int isforward=Util.getIntValue(Util.null2String(request.getParameter("isforward")),0);
int ismodify=Util.getIntValue(Util.null2String(request.getParameter("ismodify")),0);
int issyscoadjutant=Util.getIntValue(Util.null2String(request.getParameter("issyscoadjutant")),1);
String coadjutantcn="";
boolean hasrighthead=false;
if(coadjutantpost.equals("1")){
    if(IsCoadjutant==1){
        if(issyscoadjutant==0){
            coadjutantcn+=SystemEnv.getHtmlLabelName(22723,user.getLanguage())+"("+coadjutantnames+")";
        }else{
            coadjutantcn+=SystemEnv.getHtmlLabelName(22723,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(22695,user.getLanguage())+")";
        }
        if(signtype==0){
            coadjutantcn+=" "+SystemEnv.getHtmlLabelName(21790,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(15556,user.getLanguage())+")";
        }else if(signtype==1){
            coadjutantcn+=" "+SystemEnv.getHtmlLabelName(21790,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(15557,user.getLanguage())+")";
        }else{
            coadjutantcn+=" "+SystemEnv.getHtmlLabelName(21790,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(22694,user.getLanguage())+")";
        }
        if(issubmitdesc==1){
            if(hasrighthead){
                coadjutantcn+=","+SystemEnv.getHtmlLabelName(22698,user.getLanguage());
            }else{
                coadjutantcn+=" "+SystemEnv.getHtmlLabelName(22697,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(22698,user.getLanguage());
                hasrighthead=true;
            }
        }
        if(ispending==1){
            if(hasrighthead){
                coadjutantcn+=","+SystemEnv.getHtmlLabelName(22699,user.getLanguage());
            }else{
                coadjutantcn+=" "+SystemEnv.getHtmlLabelName(22697,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(22699,user.getLanguage());
                hasrighthead=true;
            }
        }
        if(isforward==1){
            if(hasrighthead){
                coadjutantcn+=","+SystemEnv.getHtmlLabelName(22700,user.getLanguage());
            }else{
                coadjutantcn+=" "+SystemEnv.getHtmlLabelName(22697,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(22700,user.getLanguage());
                hasrighthead=true;
            }
        }
        if(ismodify==1){
            if(hasrighthead){
                coadjutantcn+=","+SystemEnv.getHtmlLabelName(22701,user.getLanguage());
            }else{
                coadjutantcn+=" "+SystemEnv.getHtmlLabelName(22697,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(22701,user.getLanguage());
                hasrighthead=true;
            }
        }
        if(hasrighthead) coadjutantcn+=")";
    }else{
        coadjutantclear="1";
    }
}

if(coadjutantclear.equals("1")){
}
%>
<BODY>
<script language=vbs>
if "<%=coadjutantpost%>" = "1" then
	window.parent.returnvalue = Array("<%=IsCoadjutant%>","<%=signtype%>","<%=issyscoadjutant%>","<%=coadjutants%>","<%=coadjutantnames%>","<%=issubmitdesc%>","<%=ispending%>","<%=isforward%>","<%=ismodify%>","<%=coadjutantcn%>")
	window.parent.close
end if
if "<%=coadjutantclear%>" = "1" then
	window.parent.returnvalue = Array("","","","","","","","","","")
	window.parent.close
end if
</script>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(15504,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="showCoadjutantOperate.jsp" method="post">
<input type=hidden name=coadjutantpost value="">
<input type=hidden name=coadjutantclear value="">

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

<table width=100% class="viewform">
<COLGROUP>
   <COL width="4%">
   <COL width="16%">
   <COL width="40%">
   <COL width="40%">

<TR class="title">
    	  <TH colSpan=4><%=SystemEnv.getHtmlLabelName(22673,user.getLanguage())%></TH></TR>
<TR class="title"><TD class="Line1" colspan=4></TD></TR>
<TR  class="title">
    	  <Td  colSpan=4>
              <input type="checkbox" name="iscoadjutant" id="iscoadjutant" value="1" <%if(IsCoadjutant==1){%> checked<%}%> onclick="checknodepass(this)"><%=SystemEnv.getHtmlLabelName(22693,user.getLanguage())%></Td>
    	  </TR>
<TR class="Spacing"><TD class="Line" colspan=4></TD></TR>
<TR  class="title">
    <Td></Td>
    <Td><%=SystemEnv.getHtmlLabelName(21790,user.getLanguage())%></Td>
    <Td colSpan=2>
        <input type="radio"  name="signtype"  value="0" <%if(signtype==0){%>checked<%}%> <%if(IsCoadjutant!=1){%> disabled<%}%>><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>
        <input type="radio"  name="signtype"  value="1" <%if(signtype==1){%>checked<%}%> <%if(IsCoadjutant!=1){%> disabled<%}%>><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>
        <input type="radio"  name="signtype"  value="2" <%if(signtype==2){%>checked<%}%> <%if(IsCoadjutant!=1){%> disabled<%}%>><%=SystemEnv.getHtmlLabelName(22694,user.getLanguage())%>
    </Td>
          </TR>
<TR class="Spacing"><TD class="Line" colspan=4></TD></TR>
<TR  class="title">
    <Td></Td>
    <Td><%=SystemEnv.getHtmlLabelName(22671,user.getLanguage())%></Td>
    <Td colspan=2>
        <input type="radio"  name="issyscoadjutant" value="1" <%if(issyscoadjutant==1){%>checked<%}%> <%if(IsCoadjutant!=1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(22695,user.getLanguage())%><br>
        <input type="radio"  name="issyscoadjutant"  value="0" <%if(issyscoadjutant==0){%>checked<%}%> <%if(IsCoadjutant!=1){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(22696,user.getLanguage())%>
        <button class=Browser name="coadjutantbrw" onclick="onShowMutiHrm('coadjutantspan','coadjutants','coadjutantnames')" <%if(IsCoadjutant!=1){%>disabled<%}%>></button>
        <span name="coadjutantspan" id="coadjutantspan"> <%if(issyscoadjutant==0){%><%=coadjutantnames%><%}%></span>
        <input type=hidden name="coadjutants" value="<%=coadjutants%>">
        <input type=hidden name="coadjutantnames" value="<%=coadjutantnames%>">
    </Td>
    </TR>
<TR class="Spacing"><TD class="Line" colspan=4></TD></TR>
<TR  class="title">
    <Td></Td>
    <Td><%=SystemEnv.getHtmlLabelName(22697,user.getLanguage())%></Td>
    <Td >
        <input type="checkbox"  name="issubmitdesc" id ="issubmitdesc"  value="1" <%if(issubmitdesc==1){%>checked<%}%> <%if(IsCoadjutant!=1){%> disabled<%}%>><%=SystemEnv.getHtmlLabelName(22698,user.getLanguage())%></Td>
    <Td>
        <input type="checkbox"  name="ispending" id ="ispending"  value="1" <%if(ispending==1){%>checked<%}%> <%if(IsCoadjutant!=1){%> disabled<%}%>><%=SystemEnv.getHtmlLabelName(22699,user.getLanguage())%></Td>
    </TR>
<TR class="Spacing"><TD class="Line" colspan=4></TD></TR>
<TR  class="title">
    <Td></Td>
    <Td></Td>
    <Td >
        <input type="checkbox"  name="isforward" id ="isforward"  value="1" <%if(isforward==1){%>checked<%}%> <%if(IsCoadjutant!=1){%> disabled<%}%>><%=SystemEnv.getHtmlLabelName(22700,user.getLanguage())%></Td>
    <Td >
        <input type="checkbox"  name="ismodify" id ="ismodify"  value="1" <%if(ismodify==1){%>checked<%}%> <%if(IsCoadjutant!=1){%> disabled<%}%>><%=SystemEnv.getHtmlLabelName(22701,user.getLanguage())%>
        </Td>
    </TR>
<TR class="Spacing"><TD class="Line" colspan=4></TD></TR>
<TR class="Spacing"><TD colspan=4>&nbsp;</TD></TR>

</table>

<BR>
<table class=ReportStyle>
<TBODY>
<TR><TD>
<B><%=SystemEnv.getHtmlLabelName(19010,user.getLanguage())%></B>:<BR>
<B><%=SystemEnv.getHtmlLabelName(21790,user.getLanguage())%>£º</B><%=SystemEnv.getHtmlLabelName(22703,user.getLanguage())%>
<BR>
<%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>£º<%=SystemEnv.getHtmlLabelName(22704,user.getLanguage())%>
<BR>
<%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>£º<%=SystemEnv.getHtmlLabelName(22705,user.getLanguage())%>
<BR>
<%=SystemEnv.getHtmlLabelName(22694,user.getLanguage())%>£º<%=SystemEnv.getHtmlLabelName(22706,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(22671,user.getLanguage())%>£º</B><%=SystemEnv.getHtmlLabelName(22707,user.getLanguage())%>
<BR>
<%=SystemEnv.getHtmlLabelName(22695,user.getLanguage())%>£º<%=SystemEnv.getHtmlLabelName(22708,user.getLanguage())%>
<BR>
<%=SystemEnv.getHtmlLabelName(22696,user.getLanguage())%>£º<%=SystemEnv.getHtmlLabelName(22709,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(22697,user.getLanguage())%>£º</B><%=SystemEnv.getHtmlLabelName(22710,user.getLanguage())%>
<BR>
<%=SystemEnv.getHtmlLabelName(22698,user.getLanguage())%>£º<%=SystemEnv.getHtmlLabelName(22711,user.getLanguage())%>
<BR>
<%=SystemEnv.getHtmlLabelName(22699,user.getLanguage())%>£º<%=SystemEnv.getHtmlLabelName(22712,user.getLanguage())%>
<BR>
<%=SystemEnv.getHtmlLabelName(22700,user.getLanguage())%>£º<%=SystemEnv.getHtmlLabelName(22713,user.getLanguage())%>
<BR>
<%=SystemEnv.getHtmlLabelName(22701,user.getLanguage())%>£º<%=SystemEnv.getHtmlLabelName(22714,user.getLanguage())%>
<BR>
</TD>
</TR>
</TBODY>
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

</FORM></BODY>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
<SCRIPT LANGUAGE=VBS>

sub onShowMutiHrm(spanname,inputename,showname)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
		    if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
					document.all(inputename).value= resourceids
					document.all(spanname).innerHtml = resourcename
                    document.all(showname).value = resourcename
                    document.all("issyscoadjutant")(0).checked=false
                    document.all("issyscoadjutant")(1).checked=true
                else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
                    document.all(showname).value=""
                    document.all("issyscoadjutant")(0).checked=true
                    document.all("issyscoadjutant")(1).checked=false
                end if
			end if
end sub

</script>
   <script language="javascript">
function submitData()
{
    if (SearchForm.iscoadjutant.checked&&document.all("issyscoadjutant")[1].checked&&document.all("coadjutants").value=="") {
        alert("<%=SystemEnv.getHtmlLabelName(22715,user.getLanguage())%>");
        return;
    }
    document.all("coadjutantpost").value="1";
    document.SearchForm.submit();
}

function submitClear()
{
	document.all("coadjutantclear").value="1";
     document.SearchForm.submit();
}
function checknodepass(obj) {
    if (obj.checked) {
        SearchForm.coadjutantbrw.disabled = false;
        SearchForm.issubmitdesc.disabled = false;
        SearchForm.ispending.disabled = false;
        SearchForm.isforward.disabled = false;
        SearchForm.ismodify.disabled = false;
        document.all("signtype")[0].disabled=false;
        document.all("signtype")[1].disabled=false;
        document.all("signtype")[2].disabled=false;
        document.all("issyscoadjutant")[0].disabled=false;
        document.all("issyscoadjutant")[1].disabled=false;
    } else {
        SearchForm.coadjutantbrw.disabled = true;
        SearchForm.issubmitdesc.disabled = true;
        SearchForm.ispending.disabled = true;
        SearchForm.isforward.disabled = true;
        SearchForm.ismodify.disabled = true;
        document.all("signtype")[0].disabled=true;
        document.all("signtype")[1].disabled=true;
        document.all("signtype")[2].disabled=true;
        document.all("issyscoadjutant")[0].disabled=true;
        document.all("issyscoadjutant")[1].disabled=true;
    }
}
</script>