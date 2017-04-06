<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page"/>
<%
    String feelevel= Util.null2String(request.getParameter("feelevel"));
    String supsubject = Util.null2String(request.getParameter("supsubject"));

    if(!HrmUserVarify.checkUserRight("FnaLedgerAdd:Add",user)) {
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
   }
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(1011,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self} " ;
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

<FORM style="MARGIN-TOP: 0px" name=right method=post action="FnaBudgetfeeTypeOperation.jsp" >
  <input class=inputstyle type="hidden" name="operation" value="add">
  
  <TABLE class=ViewForm>
    <COLGROUP> <COL width="15%"> <COL width="85%"><TBODY> 
    <TR class=Title
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(1011,user.getLanguage())%></TH>
    </TR>
    <TR class=Spacing style="height: 1px"> 
      <TD class=Line1 colSpan=2></TD>
    </TR>
    <TR style="height: 1px"><TD class=Line colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
      <td class=Field> 
        <input class=inputstyle name=name size="30" onchange='checkinput("name","nameimage")'>
              <SPAN id=nameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>
      </td>
    </tr>
    <TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(18427,user.getLanguage())%></td>
      <td class=Field>
        <select class=inputstyle name="feelevel" style="width:35%" onchange="supsubjectspan.innerHTML='<IMG src=/images/BacoError.gif align=absMiddle>';supsubject.value='';if(this.value!=1){feeperiod.style.visibility='hidden';sup.style.display ='';supline.style.display ='';period.style.display ='none';periodline.style.display ='none';} else {feeperiod.style.visibility='visible';sup.style.display ='none';supline.style.display ='none';period.style.display ='';periodline.style.display ='';} if(this.value!=3){feetype.style.visibility='hidden';alertval.style.display ='none';alertvalline.style.display ='none';gap.style.display ='none';gapline.style.display ='none';ftype.style.display ='none';ftypeline.style.display ='none';} else {feetype.style.visibility='visible';alertval.style.display ='';alertvalline.style.display ='';gap.style.display ='';gapline.style.display ='';ftype.style.display ='';ftypeline.style.display ='';}">
              <option value="1" <%if("1".equals(feelevel)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18424,user.getLanguage())%></option>
              <option value="2" <%if("2".equals(feelevel)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18425,user.getLanguage())%></option>
              <option value="3" <%if("3".equals(feelevel)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18426,user.getLanguage())%></option>
        </select>
      </td>
    </tr>
    <TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
    <TR  id=sup style="display:none;">
        <TD><%=SystemEnv.getHtmlLabelName(18428,user.getLanguage())%></TD>
        <TD class=Field >
                <BUTTON class=Browser type="button" id=SelectSupsubject onclick="onShowBudgetfeeType()"></BUTTON>
                <SPAN id=supsubjectspan><%if(supsubject==null||"".equals(supsubject)||"0".equals(supsubject)){%><IMG src="/images/BacoError.gif" align=absMiddle><%} else {%><%=BudgetfeeTypeComInfo.getBudgetfeeTypename(supsubject)%><%}%></SPAN>
                <input class=inputstyle type=hidden name=supsubject value="<%if(supsubject!=null&&!"".equals(supsubject)&&!"0".equals(supsubject)) out.print(supsubject);%>">
        </TD>
    </TR>
    <TR id=supline style="display:none;height: 1px" ><TD class=Line colSpan=2></TD></TR>
    <TR id=ftype style="display:none;">
        <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
        <TD class=Field >
            <select class=inputstyle id=feetype name="feetype" style="width:35%">
              <option value="1"><%=SystemEnv.getHtmlLabelName(629,user.getLanguage())%></option>
              <option value="2"><%=SystemEnv.getHtmlLabelName(566,user.getLanguage())%></option>
              <!--option value="3">?</option-->
            </select>
        </TD>
    </TR>
    <TR id=ftypeline style="display:none;height: 1px"><TD class=Line colSpan=2></TD></TR>
    <TR id=period>
        <TD><%=SystemEnv.getHtmlLabelName(15388,user.getLanguage())%></TD>
        <TD class=Field >
            <select id=feeperiod class=inputstyle name="feeperiod" style="width:35%">
              <option value="1"><%=SystemEnv.getHtmlLabelName(541,user.getLanguage())%></option>
              <option value="2"><%=SystemEnv.getHtmlLabelName(543,user.getLanguage())%></option>
              <option value="3"><%=SystemEnv.getHtmlLabelName(538,user.getLanguage())%></option>
              <option value="4"><%=SystemEnv.getHtmlLabelName(546,user.getLanguage())%></option>
            </select>
        </TD>
    </TR>
    <TR id=periodline style="height: 1px"><TD class=Line colSpan=2></TD></TR>
    <tr id=alertval style="display:none;">
      <td><%=SystemEnv.getHtmlLabelName(18429,user.getLanguage())%></td>
      <td class=Field>
	  <!--"size=10 maxlength=3" added by lupeng 2004.05.13 for TD492.-->
        <input class=inputstyle type=text name=alertvalue size=10 maxlength=3 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'>%
      </td>
    </tr>
    <TR id=alertvalline style="display:none;height: 1px"><TD class=Line colSpan=2></TD></TR>
    <tr id=gap style="display:none;">
      <td><%=SystemEnv.getHtmlLabelName(15389,user.getLanguage())%></td>
      <td class=Field> 
	  <!--"size=10 maxlength=3" added by lupeng 2004.05.13 for TD492.-->
        <input class=inputstyle type=text name=agreegap size=10 maxlength=3 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'>%
      </td>
    </tr>
    <TR id=gapline style="display:none;height: 1px"><TD class=Line colSpan=2></TD></TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td>
      <td class=Field> 
        <textarea class=inputstyle name="description" cols="60" rows=4></textarea>
      </td>
    </tr>
    <TR style="height: 1px"><TD class=Line colSpan=2></TD></TR> 
    </TBODY> 
  </TABLE>
</FORM>
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
<Script language=javascript>
    if(right.feelevel.value!=1){
        right.feeperiod.style.visibility='hidden';
        sup.style.display ='';
        supline.style.display ='';
        period.style.display ='none';
        periodline.style.display ='none';}
    else {
        right.feeperiod.style.visibility='visible';
        sup.style.display ='none';
        supline.style.display ='none';
        period.style.display ='';
        periodline.style.display ='';}
    if(right.feelevel.value!=3){
        right.feetype.style.visibility='hidden';
        alertval.style.display ='none';
        alertvalline.style.display ='none';
        gap.style.display ='none';
        gapline.style.display ='none';
        ftype.style.display ='none';
        ftypeline.style.display ='none';}
    else {
        right.feetype.style.visibility='visible';
        alertval.style.display ='';
        alertvalline.style.display ='';
        gap.style.display ='';
        gapline.style.display ='';
        ftype.style.display ='';
        ftypeline.style.display ='';}

function submitData(obj) {
    if(right.feelevel.value>1){
        if(check_form(right,"name")&&check_form(right,"supsubject")){
            right.submit();
            obj.disabled=true;
        }
    } else {
        if(check_form(right,"name")){
            right.submit();
            obj.disabled=true;
        }
    }
}
function onShowBudgetfeeType(){
	var level=right.feelevel.value-1
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?level="+level)
	if (data){
		if (data.id!=0){
	        supsubjectspan.innerHTML = data.name;
			right.supsubject.value=data.id;
		}else{
			supsubjectspan.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			right.supsubject.value="";
		}
	}
}
</script>



</BODY>
</HTML>