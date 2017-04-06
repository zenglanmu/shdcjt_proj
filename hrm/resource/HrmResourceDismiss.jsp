<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
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

boolean hasFF = true;
rs.executeProc("Base_FreeField_Select","hr");
if(rs.getCounts()<=0)
	hasFF = false;
else
	rs.first();
	
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(6091,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(179,user.getLanguage());
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
    <input type=hidden name=operation value="dismiss">
     <TABLE class=ViewForm>

      <TBODY>
      <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=30%> <COL width=70%> <TBODY> 
          <TR class=Title> 
            <TH colSpan=2 height="19"><%=SystemEnv.getHtmlLabelName(15729,user.getLanguage())%></TH>
          </TR>
          <TR class=Spacing style="height:2px"> 
            <TD class=Line1 colSpan=2></TD>
          </TR>   
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(897,user.getLanguage())%></TD>
            <TD class=Field> <BUTTON class=Browser  type="button" onclick="onShowResource(resourceid,assistantidspan)"></BUTTON> 
              <SPAN id=assistantidspan><IMG src='/images/BacoError.gif' align=absMiddle></SPAN> 
              <INPUT type=hidden name=resourceid onChange='checkinput("resourceid","assistantidspan")'>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15961,user.getLanguage())%></TD>
            <TD class=Field><BUTTON class=Calendar type="button" id=selectcontractdate onclick="getchangedate()"></BUTTON> 
              <SPAN id=changedatespan ><IMG src='/images/BacoError.gif' align=absMiddle></SPAN> 
              <input type="hidden" name="changedate" onChange='checkinput("changedate","changedatespan")'>
            </TD>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(1978,user.getLanguage())%></td>
            <td class=Field>
              <textarea class=inputstyle rows=5 cols=40 name="changereason"></textarea>
            </td>
          </TR><TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<%if(software.equals("ALL") || software.equals("HRM")){%>          
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(6120,user.getLanguage())%>
            <td class=Field>
				<BUTTON class=Browser type="button" onclick="onShowContract()"></BUTTON> 
              <SPAN id=contractspan></SPAN> 
              <input class=inputstyle type=hidden name=changecontractid>                            
            </td>
          </TR>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<%}else{%>          
              <INPUT type=hidden name=changecontractid value='0'>                            
<%}%>
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(16077,user.getLanguage())%></td>
            <td class=Field>
              <BUTTON class=Browser type="button" onClick="onShowResource(infoman,infomanspan)">
	      </BUTTON>
	      <span id=infomanspan>
	      </span>
	      <INPUT class=inputstyle id=organizer type=hidden name=infoman >
            </td>
          </TR>
             <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
      </tbody>
    </table>
  </FORM>
  
<SCRIPT language="javascript">
  function  getchangedate(){
	var returndate = window.showModalDialog("/systeminfo/Calendar.jsp",null,"dialogHeight:320px;dialogwidth:275px");

	if (returndate!=null&&returndate!=""){
	    changedatespan.innerHTML= returndate;
        resource.changedate.value=returndate;
	}else{    
           if (returndate==""){           
	       changedatespan.innerHTML= "<IMG src='/images/BacoError.gif' align=absMiddle>";
           resource.changedate.value=returndate;         
           }
         } 
}

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
	disModalDialogRtnM("/systeminfo/BrowserMain.jsp?url=/hrm/resource/browser/dismiss/MutiResourceBrowser.jsp",inputname,spanname);
}

function onShowContract(){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/contract/contract/HrmContractBrowser.jsp?status=1 ");
	if (data!=null){
		if (data.id!= ""){
			jQuery("#contractspan").html("<A href=javascript:openFullWindowForXtable('/hrm/contract/contract/HrmContractEdit.jsp?id="+data.id+"')>"+data.name+"</A>");
			jQuery("#changecontractid").val(data.id);
		}else{
			jQuery("#contractspan").html("");
			jQuery("#changecontractid").val("");
		}
	}
}
</SCRIPT>

<script language=javascript>
function doSave(obj) {
   if(check_form(document.resource,"resourceid,changedate"))
	{
	   obj.disabled=true;
	   document.resource.submit();
	}

}
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>

