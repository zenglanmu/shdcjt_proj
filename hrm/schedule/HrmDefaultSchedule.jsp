
<%@ page language="java" contentType="text/html; charset=GBK" %>


<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id = "CompanyComInfo" class = "weaver.hrm.company.CompanyComInfo" scope = "page"/>
<jsp:useBean id = "SubCompanyComInfo" class = "weaver.hrm.company.SubCompanyComInfo" scope = "page"/>
<jsp:useBean id = "DepartmentComInfo" class = "weaver.hrm.company.DepartmentComInfo" scope = "page"/>
<jsp:useBean id = "ResourceComInfo" class = "weaver.hrm.resource.ResourceComInfo" scope = "page"/>



<%@ include file = "/systeminfo/init.jsp" %>


<HTML><HEAD>
<LINK href = "/css/Weaver.css" type = text/css rel = STYLESHEET>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
</head>
<%
String id = Util.null2String(request.getParameter("id")) ; 
String imagefilename = "/images/hdReport.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(16254 , user.getLanguage()) + "：" +    SystemEnv.getHtmlLabelName(93 , user.getLanguage()) ; 

String needfav = "1" ; 
String needhelp = "" ; 
boolean CanEdit = HrmUserVarify.checkUserRight("HrmDefaultScheduleEdit:Edit" , user) ; 
String totaltime = "" ; 
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/schedule/HrmDefaultScheduleList.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmDefaultSchedule:Log" , user)){ 
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem ="+13+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
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
<FORM id = frmmain name = frmmain method = post >
<input class=inputstyle type = "hidden" name = "operation">

<input class=inputstyle type = "hidden" name = "id" value = "<%=id%>">


<%
    RecordSet.executeProc("HrmSchedule_Select_Default" , id) ; 
    if( RecordSet.next() ) {  
		String scheduleType=Util.null2String(RecordSet.getString("scheduleType"));
        int relatedId=Util.getIntValue(RecordSet.getString("relatedId"),0);
        String relatedName="";
            //获得对象名称
        if(scheduleType.equals("3")){
        	relatedName=CompanyComInfo.getCompanyname(""+relatedId);
        }else if(scheduleType.equals("4")){
        	relatedName=SubCompanyComInfo.getSubCompanyname(""+relatedId);
        }else if(scheduleType.equals("5")){
        	relatedName=DepartmentComInfo.getDepartmentname(""+relatedId);
        }else if(scheduleType.equals("6")){
        	relatedName=ResourceComInfo.getResourcename(""+relatedId);
        }
%>

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
            <option value="3" <% if(scheduleType.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
     	    <option value="4" <% if(scheduleType.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
<!--     	    <option value="5" <% if(scheduleType.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
     	    <option value="6" <% if(scheduleType.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>-->
     </select>
    </td>
    <td><span id=spanShowRelatedIdLabel><%if(Util.getIntValue(scheduleType,0)>3){%><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%><%}%></span></td>

    <td class=field>
	    <button class=browser type="button" onClick="javascript:onShowRelatedId()" name=buttonShowRelatedId <%if(Util.getIntValue(scheduleType,0)<=3){%>style="display:none"<%}%>></button>
	    <span id=relatedNameSpan><%=relatedName%></span>
	    <input name=relatedId type=hidden value="<%=relatedId%>">
		<input name=relatedname type=hidden value="<%=relatedName%>">
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
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(monstarttime1span,monstarttime1)"></button><%}%>
    <span id = "monstarttime1span"><%=Util.toScreen(RecordSet.getString("monstarttime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "monstarttime1" value = "<%=Util.toScreen(RecordSet.getString("monstarttime1") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(monendtime1span,monendtime1)"></button><%}%>
    <span id = "monendtime1span"><%=Util.toScreen(RecordSet.getString("monendtime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "monendtime1" value = "<%=Util.toScreen(RecordSet.getString("monendtime1") , user.getLanguage())%>">
    </TD>
    <TD>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(monstarttime2span,monstarttime2)"></button><%}%>
    <span id = "monstarttime2span"><%=Util.toScreen(RecordSet.getString("monstarttime2") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "monstarttime2" value = "<%=Util.toScreen(RecordSet.getString("monstarttime2") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(monendtime2span,monendtime2)"></button><%}%>
    <span id = "monendtime2span"><%=Util.toScreen(RecordSet.getString("monendtime2") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "monendtime2" value = "<%=Util.toScreen(RecordSet.getString("monendtime2"),user.getLanguage())%>">
    </TD>
  </TR>
  
 
  <TR class = datadark>
    <td><%=SystemEnv.getHtmlLabelName(393 , user.getLanguage())%></td>
    <TD>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(tuestarttime1span,tuestarttime1)"></button><%}%>
    <span id = "tuestarttime1span"><%=Util.toScreen(RecordSet.getString("tuestarttime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "tuestarttime1" value = "<%=Util.toScreen(RecordSet.getString("tuestarttime1") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(tueendtime1span,tueendtime1)"></button><%}%>
    <span id = "tueendtime1span"><%=Util.toScreen(RecordSet.getString("tueendtime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "tueendtime1" value = "<%=Util.toScreen(RecordSet.getString("tueendtime1") , user.getLanguage())%>">
    </TD>
    <TD>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(tuestarttime2span,tuestarttime2)"></button><%}%>
    <span id = "tuestarttime2span"><%=Util.toScreen(RecordSet.getString("tuestarttime2") , user.getLanguage())%></span>
    <input class=inputstyle type =hidden name = "tuestarttime2" value = "<%=Util.toScreen(RecordSet.getString("tuestarttime2") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(tueendtime2span,tueendtime2)"></button><%}%>
    <span id = "tueendtime2span"><%=Util.toScreen(RecordSet.getString("tueendtime2") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "tueendtime2" value = "<%=Util.toScreen(RecordSet.getString("tueendtime2") , user.getLanguage())%>">
    </TD>
  </TR>
  
    <TR class = datalight>
    <td><%=SystemEnv.getHtmlLabelName(394 , user.getLanguage())%></td>
    <TD>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(wedstarttime1span,wedstarttime1)"></button><%}%>
    <span id = "wedstarttime1span"><%=Util.toScreen(RecordSet.getString("wedstarttime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "wedstarttime1" value = "<%=Util.toScreen(RecordSet.getString("wedstarttime1") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(wedendtime1span,wedendtime1)"></button><%}%>
    <span id = "wedendtime1span"><%=Util.toScreen(RecordSet.getString("wedendtime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "wedendtime1" value = "<%=Util.toScreen(RecordSet.getString("wedendtime1") , user.getLanguage())%>">
    </TD>
    <TD>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(wedstarttime2span,wedstarttime2)"></button><%}%>
    <span id = "wedstarttime2span"><%=Util.toScreen(RecordSet.getString("wedstarttime2") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "wedstarttime2" value = "<%=Util.toScreen(RecordSet.getString("wedstarttime2") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(wedendtime2span,wedendtime2)"></button><%}%>
    <span id = "wedendtime2span"><%=Util.toScreen(RecordSet.getString("wedendtime2") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name="wedendtime2" value = "<%=Util.toScreen(RecordSet.getString("wedendtime2") , user.getLanguage())%>">
    </TD>
  </TR>
  
    <TR class = datadark>
    <td><%=SystemEnv.getHtmlLabelName(395 , user.getLanguage())%></td>
    <TD>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(thustarttime1span,thustarttime1)"></button><%}%>
    <span id="thustarttime1span"><%=Util.toScreen(RecordSet.getString("thustarttime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "thustarttime1" value = "<%=Util.toScreen(RecordSet.getString("thustarttime1") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(thuendtime1span,thuendtime1)"></button><%}%>
    <span id = "thuendtime1span"><%=Util.toScreen(RecordSet.getString("thuendtime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "thuendtime1" value = "<%=Util.toScreen(RecordSet.getString("thuendtime1") , user.getLanguage())%>">
    </TD>
    <TD>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(thustarttime2span,thustarttime2)"></button><%}%>
    <span id = "thustarttime2span"><%=Util.toScreen(RecordSet.getString("thustarttime2") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "thustarttime2" value="<%=Util.toScreen(RecordSet.getString("thustarttime2") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(thuendtime2span,thuendtime2)"></button><%}%>
    <span id = "thuendtime2span"><%=Util.toScreen(RecordSet.getString("thuendtime2") , user.getLanguage())%></span>
    <input class=inputstyle type =hidden name = "thuendtime2" value = "<%=Util.toScreen(RecordSet.getString("thuendtime2") , user.getLanguage())%>">
    </TD>
  </TR>
  
    <TR class = datalight>
    <td><%=SystemEnv.getHtmlLabelName(396 , user.getLanguage())%></td>
    <TD>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(fristarttime1span,fristarttime1)"></button><%}%>
    <span id = "fristarttime1span"><%=Util.toScreen(RecordSet.getString("fristarttime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "fristarttime1" value = "<%=Util.toScreen(RecordSet.getString("fristarttime1") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(friendtime1span,friendtime1)"></button><%}%>
    <span id = "friendtime1span"><%=Util.toScreen(RecordSet.getString("friendtime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "friendtime1" value="<%=Util.toScreen(RecordSet.getString("friendtime1") , user.getLanguage())%>">
    </TD>
    <TD>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(fristarttime2span,fristarttime2)"></button><%}%>
    <span id = "fristarttime2span"><%=Util.toScreen(RecordSet.getString("fristarttime2") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "fristarttime2" value = "<%=Util.toScreen(RecordSet.getString("fristarttime2") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(friendtime2span,friendtime2)"></button><%}%>
    <span id = "friendtime2span"><%=Util.toScreen(RecordSet.getString("friendtime2") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "friendtime2" value = "<%=Util.toScreen(RecordSet.getString("friendtime2") , user.getLanguage())%>">
    </TD>
  </TR>
  
    <TR class = datadark>
    <td><%=SystemEnv.getHtmlLabelName(397 , user.getLanguage())%></td>
    <TD>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(satstarttime1span,satstarttime1)"></button><%}%>
    <span id = "satstarttime1span"><%=Util.toScreen(RecordSet.getString("satstarttime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "satstarttime1" value = "<%=Util.toScreen(RecordSet.getString("satstarttime1") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(satendtime1span,satendtime1)"></button><%}%>
    <span id = "satendtime1span"><%=Util.toScreen(RecordSet.getString("satendtime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "satendtime1" value = "<%=Util.toScreen(RecordSet.getString("satendtime1") , user.getLanguage())%>">
    </TD>
    <TD>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(satstarttime2span,satstarttime2)"></button><%}%>
    <span id = "satstarttime2span"><%=Util.toScreen(RecordSet.getString("satstarttime2") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "satstarttime2" value = "<%=Util.toScreen(RecordSet.getString("satstarttime2") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(satendtime2span,satendtime2)"></button><%}%>
    <span id = "satendtime2span"><%=Util.toScreen(RecordSet.getString("satendtime2") , user.getLanguage())%></span>
    <input type = hidden name = "satendtime2" value = "<%=Util.toScreen(RecordSet.getString("satendtime2") , user.getLanguage())%>">
    </TD>
  </TR>
  
    <TR class = datalight>
    <td><%=SystemEnv.getHtmlLabelName(398 , user.getLanguage())%></td>
    <TD>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(sunstarttime1span,sunstarttime1)"></button><%}%>
    <span id = "sunstarttime1span"><%=Util.toScreen(RecordSet.getString("sunstarttime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "sunstarttime1" value = "<%=Util.toScreen(RecordSet.getString("sunstarttime1") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(sunendtime1span,sunendtime1)"></button><%}%>
    <span id = "sunendtime1span"><%=Util.toScreen(RecordSet.getString("sunendtime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "sunendtime1" value = "<%=Util.toScreen(RecordSet.getString("sunendtime1") , user.getLanguage())%>">
    </TD>
    <TD>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(sunstarttime2span,sunstarttime2)"></button><%}%>
    <span id = "sunstarttime2span"><%=Util.toScreen(RecordSet.getString("sunstarttime2") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "sunstarttime2" value = "<%=Util.toScreen(RecordSet.getString("sunstarttime2") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(sunendtime2span,sunendtime2)"></button><%}%>
    <span id = "sunendtime2span"><%=Util.toScreen(RecordSet.getString("sunendtime2") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "sunendtime2" value = "<%=Util.toScreen(RecordSet.getString("sunendtime2") , user.getLanguage())%>">
    </TD>
  </TR>
  
    <TR class = datadark>
    <td><%=SystemEnv.getHtmlLabelName(717 , user.getLanguage())%></td>
    <TD>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowDate(validedatefromspan,validedatefrom)"></button><%}%>
    <span id ="validedatefromspan"><%=Util.toScreen(RecordSet.getString("validedatefrom") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "validedatefrom" value ="<%=Util.toScreen(RecordSet.getString("validedatefrom") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowDate(validedatetospan,validedateto)"></button><%}%>
    <span id = "validedatetospan"><%=Util.toScreen(RecordSet.getString("validedateto") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "validedateto" value ="<%=Util.toScreen(RecordSet.getString("validedateto") , user.getLanguage())%>">
    </TD>
    <TD>&nbsp;</TD>
  </TR>
  
    <TR class = TOTAL style = "FONT-WEIGHT: bold; COLOR: red">
    <TD><%=SystemEnv.getHtmlLabelName(523 , user.getLanguage())%></TD>
    <TD>&nbsp;</TD>
    <%
    totaltime = Util.toScreen(RecordSet.getString("totaltime") , user.getLanguage()) ; 
    %>
    <TD class = FIELD><%=totaltime%></TD>	
  </tr>

 </TBODY></TABLE>

<%} %>  

 </form>

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

</BODY>
</HTML>

<script language = javascript>
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

function doSave() {
    document.frmmain.action="HrmDefaultScheduleOperation.jsp" ; 
    document.frmmain.operation.value="editschedule" ; 

	var needToCheck="validedatefrom,validedateto";
	scheduleType = jQuery("select[name=scheduleType]").val();

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

function doDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7 , user.getLanguage())%>")) {
        document.frmmain.action="HrmDefaultScheduleOperation.jsp" ; 
		document.frmmain.operation.value = "deleteschedule" ; 
		document.frmmain.submit() ; 
	} 
} 
</script>
<SCRIPT language = javascript>
function ItemCount_KeyPress()
{ 
 if(!((window.event.keyCode>=48) && (window.event.keyCode<=58)))
  { 
     window.event.keyCode=0 ; 
  } 
} 
function checknumber(objectname)
{ 	
	valuechar = jQuery("#"+objectname).val().split("") ; 
	isnumber = false ; 
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!=":") isnumber = true ;}
	if(isnumber) jQuery("#"+objectname).val(""); 
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

<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>

