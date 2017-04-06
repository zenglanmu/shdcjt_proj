<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page"/>
<% if(!HrmUserVarify.checkUserRight("FnaLedgerEdit:Edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
String id=Util.fromScreen(request.getParameter("id"),user.getLanguage());
int msgid = Util.getIntValue(request.getParameter("msgid") , -1); 
String name = "" ;
String feelevel="";
String feeperiod = "" ;
String feetype = "" ;
String agreegap = "" ;
String description = "" ;
String supsubject="";
String alertvalue="";
RecordSet.executeProc("FnaBudgetfeeType_SelectByID",id);
if( RecordSet.next() ) {
    name = Util.toScreenToEdit(RecordSet.getString("name"),user.getLanguage());
    feelevel= Util.null2String(RecordSet.getString("feelevel"));
    feeperiod = Util.null2String(RecordSet.getString("feeperiod"));
    feetype = Util.null2String(RecordSet.getString("feetype"));
    agreegap = Util.null2String(RecordSet.getString("agreegap"));
    description = Util.toScreenToEdit(RecordSet.getString("description"),user.getLanguage());
    supsubject = Util.null2String(RecordSet.getString("supsubject"));
    alertvalue = Util.null2String(RecordSet.getString("alertvalue"));
    if( agreegap.equals("0") ) agreegap = "" ;
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(1011,user.getLanguage())+" : "+Util.toScreen(name,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doEdit(this),_TOP} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(this),_TOP} " ;
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
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid , user.getLanguage())%>
</font>
</DIV>
<%}%>

<FORM style="MARGIN-TOP: 0px" id=frmmain  action="FnaBudgetfeeTypeOperation.jsp" method=post>
  <input class=inputstyle type="hidden" name="operation" value="add">
  <input class=inputstyle type="hidden" name="id" value="<%=id%>">
 
  <TABLE class=ViewForm>
    <COLGROUP> <COL width="15%"> <COL width="85%"><TBODY> 
    <TR class=Title> 
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(1011,user.getLanguage())%></TH>
    </TR>
    <TR class=Spacing style="height:2px"> 
      <TD class=Line1 colSpan=2></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
      <td class=Field>
        <input class=inputstyle name=name size="30" onchange='checkinput("name","nameimage")' 
        value="<%=name%>">
        <SPAN id=nameimage></SPAN>
      </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(18427,user.getLanguage())%></td>
      <td class=Field>
        <select class=inputstyle id=feelevel name="feelevel" style="width:35%" onchange="change_feelevel()">
              <option value="1" <% if(feelevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18424,user.getLanguage())%></option>
              <option value="2" <% if(feelevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18425,user.getLanguage())%></option>
              <option value="3" <% if(feelevel.equals("3") || "".equals(feelevel)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18426,user.getLanguage())%></option>
        </select>
      </td>
    </tr>
    <!--add by lupeng for TD439-->
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
  <TR  id=sup style="display:none;">
        <TD><%=SystemEnv.getHtmlLabelName(18428,user.getLanguage())%></TD>
        <TD class=Field >
                <BUTTON class=Browser type="button" id=SelectSupsubject onclick="onShowBudgetfeeType()"></BUTTON>
                <SPAN id=supsubjectspan><%if(supsubject==null||"".equals(supsubject)||"0".equals(supsubject)){%><IMG src="/images/BacoError.gif" align=absMiddle><%} else {%><%=BudgetfeeTypeComInfo.getBudgetfeeTypename(supsubject)%><%}%></SPAN>
                <input class=inputstyle type=hidden name=supsubject value="<%if(supsubject!=null&&!"".equals(supsubject)&&!"0".equals(supsubject)) out.print(supsubject);%>">
        </TD>
    </TR>
    <TR id=supline style="display:none;height:1px"><TD class=Line colSpan=2></TD></TR>

    <TR id=ftype>
        <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
        <TD class=Field > 
            <select class=inputstyle id=feetype name="feetype" style="visibility:hidden;width:35%">
              <option value="1" <% if(feetype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(629,user.getLanguage())%></option>
              <option value="2" <% if(feetype.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(566,user.getLanguage())%></option>
              <!--option value="3" <% if(feetype.equals("3")) {%>selected<%}%>>?</option-->
            </select>
        </TD>
    </TR>
	<!--add by lupeng for TD439-->
  <TR id=ftypeline style="height:1px"><TD class=Line colSpan=2></TD></TR>
  <!--end-->
    <TR id=period>
        <TD><%=SystemEnv.getHtmlLabelName(15388,user.getLanguage())%></TD>
        <TD class=Field > 
            <select class=inputstyle id=feeperiod name="feeperiod" style="visibility:hidden;width:35%">
              <option value="1" <% if(feeperiod.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(541,user.getLanguage())%></option>
              <option value="2" <% if(feeperiod.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(543,user.getLanguage())%></option>
              <option value="3" <% if(feeperiod.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(538,user.getLanguage())%></option>
              <option value="4" <% if(feeperiod.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(546,user.getLanguage())%></option>
            </select>
        </TD>
    </TR>
	<!--add by lupeng for TD439-->
  <TR id=periodline style="height:1px"><TD class=Line colSpan=2></TD></TR>
  <!--end-->
  <tr id=alertval style="display:none;">
      <td><%=SystemEnv.getHtmlLabelName(18429,user.getLanguage())%></td>
      <td class=Field>
	  <!--"size=10 maxlength=3" added by lupeng 2004.05.13 for TD492.-->
        <input class=inputstyle type=text name=alertvalue size=10 maxlength=3 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)' value="<%=alertvalue%>">%
      </td>
    </tr>
    <TR id=alertvalline style="display:none;height:1px"><TD class=Line colSpan=2></TD></TR>
    <tr id=gap>
      <td><%=SystemEnv.getHtmlLabelName(15389,user.getLanguage())%></td>
      <td class=Field> 
		<!--"size=10 maxlength=3" added by lupeng 2004.05.13 for TD492.-->
        <input class=inputstyle type=text name=agreegap size=10 maxlength=3 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)' value="<%=agreegap%>">%
      </td>
    </tr>
	<!--add by lupeng for TD439-->
  <TR id=gapline style="height:1px"><TD class=Line colSpan=2></TD></TR>
  <!--end-->
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td>
      <td class=Field>
        <textarea class=inputstyle name="description" cols="60" rows=4><%=description%></textarea>
      </td>
    </tr>	
	<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    </TBODY> 
  </TABLE>
</FORM>
<script>
jQuery(document).ready(
	change_feelevel()
);

function change_feelevel(){
    if(jQuery("select[name=feelevel]").val()!=1){
		jQuery("select[name=feeperiod]")[0].style.visibility = 'hidden';
        jQuery("#sup").show();
        jQuery("#supline").show();
        jQuery("#period").hide();
        jQuery("#periodline").hide();}
    else {
		jQuery("select[name=feeperiod]")[0].style.visibility = 'visible';
        jQuery("#sup").hide();
        jQuery("#supline").hide();
        jQuery("#period").show();;
        jQuery("#periodline").show();;}
    if(jQuery("select[name=feelevel]").val()!=3){
        jQuery("select[name=feetype]")[0].style.visibility = 'hidden';
        jQuery("#alertval").hide();
        jQuery("#alertvalline").hide();
        jQuery("#gap").hide();
        jQuery("#gapline").hide();
        jQuery("#ftype").hide();
        jQuery("#ftypeline").hide();}
    else {
        jQuery("select[name=feetype]")[0].style.visibility = 'visible';
        jQuery("#alertval").show();
        jQuery("#alertvalline").show();
        jQuery("#gap").show();
        jQuery("#gapline").show();
        jQuery("#ftype").show();
        jQuery("#ftypeline").show();}
}

function doEdit(obj){
    if(frmmain.feelevel.value>1){
        if(check_form(frmmain,"name")&&check_form(frmmain,"supsubject")){
            frmmain.operation.value="edit";
            frmmain.submit();
            obj.disabled=true;
        }
    } else {
        if(check_form(frmmain,"name")){
            frmmain.operation.value="edit";
            frmmain.submit();
            obj.disabled=true;
        }
    }
}
function doDelete(obj){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			frmmain.operation.value="delete";
			frmmain.submit();
            obj.disabled=true;
        }
}

function onShowBudgetfeeType(){
    level=jQuery("select[name=feelevel]").val()-1;
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?level="+level);
    if (data!=null){
		if (data.id!= 0){
			if(data.id!="<%=id%>"){
            jQuery("#supsubjectspan").html(data.name);
			jQuery("input[name=supsubject]").val(data.id);
			}else{
				alert("<%=SystemEnv.getHtmlLabelName(24125,user.getLanguage())%>");
			}
		}else{
			jQuery("#supsubjectspan").html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			jQuery("input[name=supsubject]").val("");
		}
	}
}
</script>
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

</BODY>
<!--
<script language=vbs>
sub onShowBudgetfeeType()
    level=frmmain.feelevel.value-1
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?level="&level)
	if (Not IsEmpty(id)) then
		if id(0)<> 0 then
			if id(0)<>"<%=id%>" then
			supsubjectspan.innerHtml = id(1)
			frmmain.supsubject.value=id(0)
			else
				alert("<%=SystemEnv.getHtmlLabelName(24125,user.getLanguage())%>")
			end if
			else
			supsubjectspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			frmmain.supsubject.value=""
		end if
	end if
end sub
</script>-->
</HTML>
