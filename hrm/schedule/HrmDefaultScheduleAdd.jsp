<%@ page import = "weaver.general.Util" %>
<%@ page import = "weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file = "/systeminfo/init.jsp" %>

<%
if(!HrmUserVarify.checkUserRight("HrmDefaultScheduleAdd:Add" , user)) { 
    response.sendRedirect("/notice/noright.jsp") ; 
    return ; 
} 
%>

<jsp:useBean id = "rs" class = "weaver.conn.RecordSet" scope = "page"/>
<SCRIPT language = "javascript" src = "/js/weaver.js"></script>
<HTML><HEAD>
<LINK href = "/css/Weaver.css" type = text/css rel = STYLESHEET>
</head>
<%
String id = Util.null2String(request.getParameter("id")) ; 
String imagefilename = "/images/hdReport.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(16254 , user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(82 , user.getLanguage()) ; 

String needfav = "1" ; 
String needhelp = "" ; 

%>
<BODY>
<%@ include file = "/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:window.history.go(-1),_self} " ;
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

<FORM id = frmmain name = frmmain method = post  >
<input class=inputstyle type = "hidden" name = "operation"  >

<table class=Viewform>
  <tbody>
  <COLGROUP>   
    <COL width="15%">
    <COL width="35%"> 
    <COL width="15%">
    <COL width="35%">
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
    <td class=field>
	    <select class=inputstyle  size=1 name=scheduleType style=width:150  onChange="javascript:clearRelatedInfo()">
            <option value="3" ><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
     	    <option value="4" ><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
<!--     	    
            <option value="5" ><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
     	    <option value="6" ><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
-->
     </select>
    </td>
    <td ><span id=spanShowRelatedIdLabel></span></td>

    <td class=field>
	    <button class=browser type="button" onClick="javascript:onShowRelatedId()" name=buttonShowRelatedId style="display:none"></button>
	    <span id=relatedNameSpan></span>
	    <input name=relatedId type=hidden value="">
		<input name=relatedname type=hidden value="">
    </td>
    <td>
 </tr>  
<TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
  </tbody>
</table>



<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width = "30%">
  <COL width = "35%">
  <COL width = "35%">
  <TBODY>
   <TR class = Header>
    <TD><%=SystemEnv.getHtmlLabelName(390 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(16689 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(16690 , user.getLanguage())%></TD>
  </TR>

  <TR class = datalight>
    <td><%=SystemEnv.getHtmlLabelName(392 , user.getLanguage())%></td>
    <TD>
    <button class = Clock type="button" onclick = "onShowTime(monstarttime1span,monstarttime1)"></button>
    <span id = "monstarttime1span"></span>
    <input class=inputstyle type = hidden name = "monstarttime1" value = "">- 
    <button class = Clock type="button" onclick = "onShowTime(monendtime1span,monendtime1)"></button>
    <span id = "monendtime1span"></span>
    <input class=inputstyle type = hidden name = "monendtime1" value = "">
    </TD>
    <TD>
    <button class = Clock type="button" onclick = "onShowTime(monstarttime2span,monstarttime2)"></button>
    <span id = "monstarttime2span"></span>
    <input class=inputstyle type = hidden name = "monstarttime2" value = "">- 
    <button class = Clock type="button" onclick="onShowTime(monendtime2span,monendtime2)"></button>
    <span id = "monendtime2span"></span>
    <input class=inputstyle type = hidden name = "monendtime2" value = "">
    </TD>
  </TR>
  
    <TR class = datadark>
    <td><%=SystemEnv.getHtmlLabelName(393 , user.getLanguage())%></td>
    <TD>
    <button class = Clock type="button" onclick="onShowTime(tuestarttime1span,tuestarttime1)"></button>
    <span id = "tuestarttime1span"></span>
    <input class=inputstyle type = hidden name = "tuestarttime1" value = "">- 
    <button class = Clock type="button" onclick = "onShowTime(tueendtime1span,tueendtime1)"></button>
    <span id = "tueendtime1span"></span>
    <input class=inputstyle type = hidden name = "tueendtime1" value = "">
    </TD>
    <TD>
    <button class = Clock type="button" onclick = "onShowTime(tuestarttime2span,tuestarttime2)"></button>
    <span id = "tuestarttime2span"></span>
    <input class=inputstyle type = hidden name = "tuestarttime2" value = "">- 
    <button class = Clock type="button" onclick = "onShowTime(tueendtime2span,tueendtime2)"></button>
    <span id = "tueendtime2span"></span>
    <input class=inputstyle type = hidden name = "tueendtime2" value = "">
    </TD>
  </TR>

  <TR class = datalight>
    <td><%=SystemEnv.getHtmlLabelName(394 , user.getLanguage())%></td>
    <TD>
    <button class = Clock type="button" onclick = "onShowTime(wedstarttime1span,wedstarttime1)"></button>
    <span id = "wedstarttime1span"></span>
    <input class=inputstyle type = hidden name = "wedstarttime1" value = "">- 
    <button class = Clock type="button" onclick = "onShowTime(wedendtime1span,wedendtime1)"></button>
    <span id = "wedendtime1span"></span>
    <input class=inputstyle type = hidden name = "wedendtime1" value = "">
    </TD>
    <TD>
    <button class = Clock type="button" onclick = "onShowTime(wedstarttime2span,wedstarttime2)"></button>
    <span id = "wedstarttime2span"></span>
    <input class=inputstyle type = hidden name = "wedstarttime2" value="">- 
    <button class=Clock type="button" onclick="onShowTime(wedendtime2span,wedendtime2)"></button>
    <span id="wedendtime2span"></span>
    <input class=inputstyle type=hidden name="wedendtime2" value="">
    </TD>
  </TR>
  <TR class=datadark>
    <td><%=SystemEnv.getHtmlLabelName(395,user.getLanguage())%></td>
    <TD>
    <button class=Clock type="button" onclick="onShowTime(thustarttime1span,thustarttime1)"></button>
    <span id="thustarttime1span"></span>
    <input class=inputstyle type=hidden name="thustarttime1" value="">- 
    <button class=Clock type="button" onclick="onShowTime(thuendtime1span,thuendtime1)"></button>
    <span id="thuendtime1span"></span>
    <input class=inputstyle type=hidden name="thuendtime1" value="">
    </TD>
    <TD>
    <button class=Clock type="button" onclick="onShowTime(thustarttime2span,thustarttime2)"></button>
    <span id="thustarttime2span"></span>
    <input class=inputstyle type=hidden name="thustarttime2" value="">- 
    <button class=Clock type="button" onclick="onShowTime(thuendtime2span,thuendtime2)"></button>
    <span id="thuendtime2span"></span>
    <input class=inputstyle type=hidden name="thuendtime2" value="">
    </TD>
  </TR>
  <TR class=datalight>
    <td><%=SystemEnv.getHtmlLabelName(396,user.getLanguage())%></td>
    <TD>
    <button class=Clock type="button" onclick="onShowTime(fristarttime1span,fristarttime1)"></button>
    <span id="fristarttime1span"></span>
    <input class=inputstyle type=hidden name="fristarttime1" value="">- 
    <button class=Clock type="button" onclick="onShowTime(friendtime1span,friendtime1)"></button>
    <span id="friendtime1span"></span>
    <input class=inputstyle type=hidden name="friendtime1" value="">
    </TD>
    <TD>
    <button class=Clock type="button" onclick="onShowTime(fristarttime2span,fristarttime2)"></button>
    <span id="fristarttime2span"></span>
    <input class=inputstyle type=hidden name="fristarttime2" value="">- 
    <button class=Clock type="button" onclick="onShowTime(friendtime2span,friendtime2)"></button>
    <span id="friendtime2span"></span>
    <input class=inputstyle type=hidden name="friendtime2" value="">
    </TD>
  </TR>
  <TR class=datadark>
    <td><%=SystemEnv.getHtmlLabelName(397,user.getLanguage())%></td>
    <TD>
    <button class=Clock type="button" onclick="onShowTime(satstarttime1span,satstarttime1)"></button>
    <span id="satstarttime1span"></span>
    <input class=inputstyle type=hidden name="satstarttime1" value="">- 
    <button class=Clock type="button" onclick="onShowTime(satendtime1span,satendtime1)"></button>
    <span id="satendtime1span"></span>
    <input class=inputstyle type=hidden name="satendtime1" value="">
    </TD>
    <TD>
    <button class=Clock type="button" onclick="onShowTime(satstarttime2span,satstarttime2)"></button>
    <span id="satstarttime2span"></span>
    <input class=inputstyle type=hidden name="satstarttime2" value="">- 
    <button class=Clock type="button" onclick="onShowTime(satendtime2span,satendtime2)"></button>
    <span id="satendtime2span"></span>
    <input class=inputstyle type=hidden name="satendtime2" value="">
    </TD>
  </TR>
  <TR class=datalight>
    <td><%=SystemEnv.getHtmlLabelName(398,user.getLanguage())%></td>
    <TD>
    <button class=Clock type="button" onclick="onShowTime(sunstarttime1span,sunstarttime1)"></button>
    <span id="sunstarttime1span"></span>
    <input class=inputstyle type=hidden name="sunstarttime1" value="">- 
    <button class=Clock type="button" onclick="onShowTime(sunendtime1span,sunendtime1)"></button>
    <span id="sunendtime1span"></span>
    <input class=inputstyle type=hidden name="sunendtime1" value="">
    </TD>
    <TD>
    <button class=Clock type="button" onclick="onShowTime(sunstarttime2span,sunstarttime2)"></button>
    <span id="sunstarttime2span"></span>
    <input class=inputstyle type=hidden name="sunstarttime2" value="">- 
    <button class=Clock type="button" onclick="onShowTime(sunendtime2span,sunendtime2)"></button>
    <span id="sunendtime2span"></span>
    <input class=inputstyle type=hidden name="sunendtime2" value="">
    </TD>
  </TR>
  <TR class=datadark>
    <td><%=SystemEnv.getHtmlLabelName(717 , user.getLanguage())%></td>
    <TD>
    <button class=Clock type="button" onclick="onShowDate(validedatefromspan,validedatefrom)"></button>
    <span id="validedatefromspan"><IMG src = '/images/BacoError.gif' align = absMiddle></span>
    <input class=inputstyle type=hidden name="validedatefrom" value="">- 
    <button class=Clock type="button" onclick="onShowDate(validedatetospan,validedateto)"></button>
    <span id="validedatetospan"><IMG src = '/images/BacoError.gif' align = absMiddle></span>
    <input class=inputstyle type=hidden name="validedateto" value="">
    </TD>
    <TD>&nbsp;</TD>
  </TR>
 </TBODY></TABLE>
 </form>
  <!--新建时无需totaltime-->
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
</BODY>
</HTML>

 <SCRIPT language=VBS>



sub onShowRelatedId1()
	scheduleType = document.all("scheduleType").value

	if scheduleType = "4" then
	    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="&frmMain.relatedId.value)
	else if scheduleType = "5" then
	         id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmMain.relatedId.value)
	     else if scheduleType = "6" then 
	              id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="&frmMain.relatedId.value)
		      end if
		 end if
	end if

	if NOT isempty(id) then
	    if id(0)<> "" then
		    relatedNameSpan.innerHtml = id(1)
		    frmMain.relatedId.value = id(0)
		else
		    relatedNameSpan.innerHtml = ""
		    frmMain.relatedId.value="<IMG src = '/images/BacoError.gif' align = absMiddle>"
		end if
	end if

end sub
</SCRIPT>

<SCRIPT language = javascript>
function onShowRelatedId(){
	scheduleType = jQuery("select[name=scheduleType]").val();

	if (scheduleType == "4"){
	    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp");
	}else if(scheduleType == "5"){
	         data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp");
	}else if (scheduleType == "6"){
	              data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	}


	if(data!=null){
	    if (data.id!= ""){
		    jQuery("#relatedNameSpan").html(data.name);
		    jQuery("input[name=relatedId]").val(data.id);
			jQuery("input[name=relatedname]").val(data.name);
		}else{
		    jQuery("#relatedNameSpan").html("")
		    jQuery("input[name=relatedId]").val("<IMG src = '/images/BacoError.gif' align = absMiddle>");
			jQuery("input[name=relatedname]").val("");
		}
	}

}

function ItemCount_KeyPress() {
 if(!((window.event.keyCode>=48) && (window.event.keyCode<=58)))
  {
     window.event.keyCode=0;
  } 
} 

function checknumber(objectname) {	
	valuechar = document.all(objectname).value.split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!=":") isnumber = true ;
    }
	if(isnumber) document.all(objectname).value = "" ; 
} 

function doSave() {
    document.frmmain.action="HrmDefaultScheduleOperation.jsp" ; 
    document.frmmain.operation.value="insertschedule" ;
	var needToCheck="validedatefrom,validedateto";
	scheduleType = document.all("scheduleType").value

	if(scheduleType!="3"){
		needToCheck+=",relatedId"
	}

    if(check_form(document.frmmain , needToCheck))  {
    


        if(
        ((document.frmmain.monstarttime1.value==""&&
          document.frmmain.monendtime1.value==""&&
          document.frmmain.monstarttime2.value==""&&
          document.frmmain.monendtime2.value=="")
        ||
         (document.frmmain.monstarttime1.value!=""&&
          document.frmmain.monendtime1.value!=""&&
          document.frmmain.monstarttime2.value!=""&&
          document.frmmain.monendtime2.value!=""))
        &&
          ((document.frmmain.tuestarttime1.value==""&&
          document.frmmain.tueendtime1.value==""&&
          document.frmmain.tuestarttime2.value==""&&
          document.frmmain.tueendtime2.value=="")
        ||
         (document.frmmain.tuestarttime1.value!=""&&
          document.frmmain.tueendtime1.value!=""&&
          document.frmmain.tuestarttime2.value!=""&&
          document.frmmain.tueendtime2.value!=""))
        &&
         ((document.frmmain.wedstarttime1.value==""&&
          document.frmmain.wedendtime1.value==""&&
          document.frmmain.wedstarttime2.value==""&&
          document.frmmain.wedendtime2.value=="")
        ||
         (document.frmmain.wedstarttime1.value!=""&&
          document.frmmain.wedendtime1.value!=""&&
          document.frmmain.wedstarttime2.value!=""&&
          document.frmmain.wedendtime2.value!=""))
        &&
         ((document.frmmain.thustarttime1.value==""&&
          document.frmmain.thuendtime1.value==""&&
          document.frmmain.thustarttime2.value==""&&
          document.frmmain.thuendtime2.value=="")
        ||
         (document.frmmain.thustarttime1.value!=""&&
          document.frmmain.thuendtime1.value!=""&&
          document.frmmain.thustarttime2.value!=""&&
          document.frmmain.thuendtime2.value!=""))
        &&
         ((document.frmmain.fristarttime1.value==""&&
          document.frmmain.friendtime1.value==""&&
          document.frmmain.fristarttime2.value==""&&
          document.frmmain.friendtime2.value=="")
        ||
         (document.frmmain.fristarttime1.value!=""&&
          document.frmmain.friendtime1.value!=""&&
          document.frmmain.fristarttime2.value!=""&&
          document.frmmain.friendtime2.value!=""))
        &&
         ((document.frmmain.satstarttime1.value==""&&
          document.frmmain.satendtime1.value==""&&
          document.frmmain.satstarttime2.value==""&&
          document.frmmain.satendtime2.value=="")
        ||
         (document.frmmain.satstarttime1.value!=""&&
          document.frmmain.satendtime1.value!=""&&
          document.frmmain.satstarttime2.value!=""&&
          document.frmmain.satendtime2.value!=""))
        &&
         ((document.frmmain.sunstarttime1.value==""&&
          document.frmmain.sunendtime1.value==""&&
          document.frmmain.sunstarttime2.value==""&&
          document.frmmain.sunendtime2.value=="")
        ||
         (document.frmmain.sunstarttime1.value!=""&&
          document.frmmain.sunendtime1.value!=""&&
          document.frmmain.sunstarttime2.value!=""&&
          document.frmmain.sunendtime2.value!=""))
         )
             document.frmmain.submit();
         else
             alert("<%=SystemEnv.getHtmlLabelName(16696 , user.getLanguage())%>") ; 
       }
   }

function clearRelatedInfo(){
	scheduleType = jQuery("select[name=scheduleType]").val();
	if(scheduleType=="3"){
		jQuery("#relatedNameSpan").html("");
		jQuery("select[name=scheduleType]").val("");
		jQuery("button[name=buttonShowRelatedId]").hide();
		jQuery("#spanShowRelatedIdLabel").html("");
	}else{
		jQuery("#relatedNameSpan").html("<IMG src = '/images/BacoError.gif' align = absMiddle>");
		jQuery("input[name=relatedId]").val("");
		jQuery("button[name=buttonShowRelatedId]").show();
		jQuery("#spanShowRelatedIdLabel").html("<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>");
	}

}


</SCRIPT>

<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>


