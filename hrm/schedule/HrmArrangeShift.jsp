<%@ page import = "weaver.general.Util" %>
<%@ page import = "weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file = "/systeminfo/init.jsp" %>
<jsp:useBean id = "rs" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>

<HTML><HEAD>
<LINK href = "/css/Weaver.css" type = text/css rel = STYLESHEET>
<SCRIPT language = "javascript" src = "/js/weaver.js"></script>
</head>
<%
String id = Util.null2String(request.getParameter("id")) ; 
String imagefilename = "/images/hdReport.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(16255 , user.getLanguage()) + ":" +                                             SystemEnv.getHtmlLabelName(93 , user.getLanguage()) ; 
String needfav = "1" ; 
String needhelp = "" ; 

boolean CanEdit = HrmUserVarify.checkUserRight("HrmArrangeShift:Maintance" , user) ; 
                         

String shiftname = "" ; 
String shiftbegintime = "" ; 
String shiftendtime = "" ; 
String validedatefrom = "" ; 

RecordSet.executeProc("HrmArrangeShift_Select_Default" , id ) ; 	
if(RecordSet.next()){ 
    shiftname = Util.null2String( RecordSet.getString("shiftname") ) ; 
    shiftbegintime = Util.null2String( RecordSet.getString("shiftbegintime") ) ; 
    shiftendtime = Util.null2String( RecordSet.getString("shiftendtime") ) ; 
    validedatefrom = Util.null2String( RecordSet.getString("validedatefrom") ) ; 
}
%>
<BODY>
<%@ include file = "/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(CanEdit){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/schedule/HrmArrangeShiftList.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>		
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM id = frmmain name = frmmain action = "HrmArrangeShiftOperation.jsp" method = post>
<input type = "hidden" name = "operation">
<input type = "hidden" name = "changeinhistory" value="0">
<input type = "hidden" name = "id" value = "<%=id%>">

<table class = viewform>
  <colgroup>
  <col width = "15%">
  <col width = "85%">
    <tbody>
    <tr class = Title>
    <TH colSpan = 2><%=SystemEnv.getHtmlLabelName(16255,user.getLanguage())%></TH>
    </TR>
    <TR class=Spacing style="height:2px"><TD class =Line1 colSpan = 2></TD></TR>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
      <td class = field>
        <input type = "text" name = "shiftname" maxLength = 10 onchange = "checkinput('shiftname','shiftnamespan')" size = 43 value="<%=shiftname%>">
    	<span id = "shiftnamespan"></span>
      </td>
    </tr>
	<TR style="height:1px"><TD class =Line colSpan = 2></TD></TR>
    <tr>
    <td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
    <td class = field>
    <button class = Clock type="button" onclick="onShowTime(shiftbegintimespan,shiftbegintime)"></button>
    <span id = "shiftbegintimespan"><%=shiftbegintime%></span>
    <input type = hidden name ="shiftbegintime" value = "<%=shiftbegintime%>">
    <input type = "hidden" name = "oldshiftbegintime" value="<%=shiftbegintime%>">
    </td>     
    </tr>
<TR style="height:1px"><TD class =Line colSpan = 2></TD></TR>
    <tr>
    <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
    <td class=field>
    <button class = Clock type="button" onclick = "onShowTime(shiftendtimespan,shiftendtime)"></button>
    <span id = "shiftendtimespan"><%=shiftendtime%></span>
    <input type = hidden name = "shiftendtime" value = "<%=shiftendtime%>">
    <input type = hidden name = "oldshiftendtime" value = "<%=shiftendtime%>">
    </td>
    </tr>
<TR style="height:1px"><TD class =Line colSpan = 2></TD></TR>
   <tr>
    <td><%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%></td>
    <td class=field>
    <button class = Clock type="button" onclick = "onHrmShowDate(validedatefromspan,validedatefrom)"></button>
    <span id = "validedatefromspan"><%=validedatefrom%></span>
    <input type = hidden name = "validedatefrom" value = "<%=validedatefrom%>">
    <input type = hidden name = "oldvalidedatefrom" value = "<%=validedatefrom%>">
    </td>
    </tr>
<TR style="height:1px"><TD class =Line colSpan = 2></TD></TR>
</tbody>
</table>
</form>

</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>

<script language = javascript>
function doSave(){ 
	document.frmmain.operation.value = "editshift" ; 
    needinputfield = "" ;
    newshiftbegintime = document.frmmain.shiftbegintime.value ;
    oldshiftbegintime = document.frmmain.oldshiftbegintime.value ;
    newshiftendtime = document.frmmain.shiftendtime.value ;
    oldshiftendtime = document.frmmain.oldshiftendtime.value ;
    
    if(newshiftbegintime != oldshiftbegintime || newshiftendtime != oldshiftendtime ) {
        if( confirm( "<%=SystemEnv.getHtmlLabelName(16748,user.getLanguage())%>") ) {
            needinputfield = "shiftname,validedatefrom" ;
            if(check_form(document.frmmain ,needinputfield)) {
                document.frmmain.changeinhistory.value = "1" ; 
                document.frmmain.submit() ; 
            }
        }
        else {
            needinputfield = "shiftname" ;
            if(check_form(document.frmmain ,needinputfield)) {
                document.frmmain.changeinhistory.value = "0" ; 
                document.frmmain.submit() ; 
            }
        }
    }
    else {
        needinputfield = "shiftname" ;
        if(check_form(document.frmmain ,needinputfield)) {
            document.frmmain.changeinhistory.value = "0" ; 
            document.frmmain.submit() ; 
        }
    }

} 

function doDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7 , user.getLanguage())%>")) {
		document.frmmain.operation.value = "deleteshift" ; 
		document.frmmain.submit() ; 
	} 
} 


function ItemCount_KeyPress() { 
 if(!((window.event.keyCode>=48) && (window.event.keyCode<=58))) { 
     window.event.keyCode=0 ; 
  } 
} 
function checknumber(objectname) { 	
	valuechar = document.all(objectname).value.split("") ; 
	isnumber = false ; 
	for(i=0 ; i<valuechar.length ; i++) {
        charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!=":") isnumber = true ;
        }
	if(isnumber) document.all(objectname).value = ""  ; 
} 
</SCRIPT>
</BODY>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
