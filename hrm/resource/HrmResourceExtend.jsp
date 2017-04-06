<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<html>
<% if(!HrmUserVarify.checkUserRight("HrmResourceAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String resourceid=Util.null2String((String)request.getParameter("id"));
boolean hasFF = true;
rs.executeProc("Base_FreeField_Select","hr");
if(rs.getCounts()<=0)
	hasFF = false;
else
	rs.first();
	
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(6089,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(179,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM name=resource id=resource action="HrmResourceStatusOperation.jsp" method=post>
<input class=inputstyle type=hidden name=operation value="extend">
<%
String errmsg = Util.null2String(request.getParameter("errmsg"));
if(errmsg.equals("1")){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getHtmlLabelName(16078,user.getLanguage())%>
</div>
<%}%>        
    <TABLE class=ViewForm>

      <TBODY>
      <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=30%> <COL width=70%> <TBODY> 
          <TR class=Title> 
            <TH colSpan=2 height="19"><%=SystemEnv.getHtmlLabelName(15729
            ,user.getLanguage())%></TH>
          </TR>
          <TR class=Spacing style="height:2px"> 
            <TD class=Line1 colSpan=2></TD>
          </TR>   
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(16079,user.getLanguage())%></TD>
            <TD class=Field>
			<BUTTON class=Browser type="button" onclick="onShowResourceID(resourceid,resourceidspan)"></BUTTON>
              <SPAN id=resourceidspan>
                <%if(resourceid.equals("")){%><IMG src='/images/BacoError.gif' align=absMiddle><%}else{%>
                  <a href="HrmResource.jsp?id=<%=resourceid%>"><%=resourceComInfo.getLastname(resourceid)%></a>
              <%}%>
              </SPAN>
              <input class=inputstyle type=hidden name=resourceid value="<%=resourceid%>">
            </TD>
          </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(16080,user.getLanguage())%></TD>
            <TD class=Field>
                <select class=inputstyle name=status value="1">         
                  <option value="1"><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></option>
                  <option value="0"><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></option>
                </select>             
            </TD>
          </TR> 
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15970,user.getLanguage())%></TD>
            <TD class=Field><BUTTON class=Calendar type="button" id=selectcontractdate onclick="getchangedate()"></BUTTON> 
              <SPAN id=changedatespan ><IMG src='/images/BacoError.gif' align=absMiddle></SPAN>
              <input class=inputstyle type="hidden" name="changedate">
            </TD>
          </TR>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15971,user.getLanguage())%></TD>
            <TD class=Field><BUTTON class=Calendar type="button" id=selectcontractdate onclick="getchangeenddate()"></BUTTON> 
              <SPAN id=changeenddatespan ><IMG src='/images/BacoError.gif' align=absMiddle></SPAN>
              <input class=inputstyle type="hidden" name="changeenddate">
            </TD>
          </TR>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(16081,user.getLanguage())%></td>
            <td class=Field>
              <textarea class=inputstyle rows=5 cols=40 name="changereason"></textarea>
            </td>
          </TR>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(16082,user.getLanguage())%></td>
            <td class=Field>

              <input class="wuiBrowser" type=hidden name=changecontractid
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/contract/contract/HrmContractBrowser.jsp"
			  _displayTemplate="<A href='/hrm/contract/contract/HrmContractEdit.jsp?id=#b{id}'>#b{name}</A>">              
            </td>
          </TR>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(16083,user.getLanguage())%></td>
            <td class=Field>
		<BUTTON class=Browser type="button" onClick="onShowResource(infoman,infomanspan)">
	      </BUTTON>
	      <span class=inputstyle id=infomanspan>
	      </span>
	      <INPUT class=inputstyle id=organizer type=hidden name=infoman >
            </td>
          </TR>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
      </tbody>
    </table>
  </FORM>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
</table>
<script language=vbs>
sub onShowContract()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/contract/contract/HrmContractBrowser.jsp?status=1 ")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	contractspan.innerHtml = "<A href='/hrm/contract/contract/HrmContractEdit.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.changecontractid.value=id(0)
	else
	contractspan.innerHtml = ""
	resource.changecontractid.value=""
	end if
	end if
end sub


</script>
<script language="javascript">
function disModalDialogRtnM(url, inputname, spanname) {
	var id = window.showModalDialog(url);
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			var ids = wuiUtil.getJsonValueByIndex(id, 0).substr(1);
			var names = wuiUtil.getJsonValueByIndex(id, 1).substr(1);

			jQuery(inputname).val(ids);
			var sHtml = "";
			var ridArray = ids.split(",");
			var rNameArray = names.split(",");

			linkurl = ""

			for ( var i = 0; i < ridArray.length; i++) {

				var curid = ridArray[i];
				var curname = rNameArray[i];

				sHtml += "<a tatrget='_blank' href=/hrm/resource/HrmResource.jsp?id=" + curid + ">" + curname + "</a>&nbsp;";
			}

			jQuery(spanname).html(sHtml);
		} else {
			jQuery(inputname).val("")
			jQuery(spanname).html("");
		}
	}
}

function onShowResource(inputname,spanname){
	disModalDialogRtnM("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp",inputname,spanname)
}

function onShowResourceID(inputname,spanname){
	disModalDialogRtnM("/systeminfo/BrowserMain.jsp?url=/hrm/resource/browser/extend/MutiResourceBrowser.jsp",inputname,spanname)
}


function doSave(obj) {
    if(check_form(document.resource,"resourceid,changedate,changeenddate")&&checkDateRange(resource.changedate,resource.changeenddate,"<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>"))
	{
    	obj.disabled=true;
        document.resource.submit();
     }
}

</script>
<%@include file="../include.jsp"%>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>

