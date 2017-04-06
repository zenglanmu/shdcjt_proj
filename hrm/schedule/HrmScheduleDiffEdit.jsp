<%@ page import = "weaver.general.Util" %>
<%@ page import = "weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file = "/systeminfo/init.jsp" %>

<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id = "SalaryComInfo" class = "weaver.hrm.finance.SalaryComInfo" scope = "page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<HTML>
<HEAD>
<LINK href = "/css/Weaver.css" type = text/css rel = STYLESHEET>
<SCRIPT language = "javascript" src = "../../js/weaver.js"></script>
</head>

<%
boolean CanEdit= HrmUserVarify.checkUserRight("HrmScheduleDiffAdd:Add" , user);
if(!CanEdit){
    		response.sendRedirect("/notice/noright.jsp") ;
    		return ;
	}
String imagefilename = "/images/hdReport.gif" ; 
String titlename =  SystemEnv.getHtmlLabelName(6139 , user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93 , user.getLanguage()) ; 
String needfav = "1" ; 
String needhelp = "" ;
String subcompanyid = Util.null2String(request.getParameter("subcompanyid") ) ;
String rolelevel=CheckUserRight.getRightLevel("HrmScheduleDiffAdd:Add" , user);
int id = Util.getIntValue(request.getParameter("id") , 0) ;

%>

<BODY>
<%@ include file = "/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;


RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;


    if(RecordSet.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem) ="+17+",_self} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem ="+17+",_self} " ;
    }
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/schedule/HrmScheduleDiff.jsp?subcompanyid="+subcompanyid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id = frmmain name = frmmain method = post action = "HrmScheduleDiffOperation.jsp">
<input class=inputstyle type = "hidden" name = "operation">
<input class=inputstyle type = "hidden" name = "id" value = "<%=id%>">
<input class=inputstyle type = "hidden" name = "subcompanyid" value = "<%=subcompanyid%>">
<table class=Viewform>
  <colgroup>
  <col width = "49%">
  <col width = "2%">
  <col width = "49%">
  <tbody>
    <tr class=Title>
      <TH colSpan = 3><%=SystemEnv.getHtmlLabelName(6139,user.getLanguage())%></TH>
    </TR>
    <TR class=Spacing style="height:2px"> 
      <TD class=Line1 colSpan = 3></TD>
    </TR>
    <%
    RecordSet.executeProc("HrmScheduleDiff_Select_ByID" , id + "") ;
    RecordSet.next() ; 
    %>
         <tr>
          <td>
          <table class = form>
          <colgroup>
          <col width = "20%">
          <col width = "80%">
          <tbody>        
        <tr>
      <td nowrap><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></td>
      <td class = field>
        <%if(CanEdit){%>
        <input class=inputstyle type = "text" name = "diffname" maxLength = 10 value = "<%=Util.toScreenToEdit(RecordSet.getString("diffname") , user.getLanguage())%>" onchange = "checkinput('diffname','InvalidFlag_Description1')" size = 10>
    	<SPAN id = InvalidFlag_Description1>
    	  <% if(RecordSet.getString("diffname").equals("")){%>
    	    <IMG src = "../../images/BacoError.gif" align = absMiddle>
    	  <%} %>
    	</SPAN>
    	<%} else {%>
    	<%=Util.toScreen(RecordSet.getString("diffname") , user.getLanguage())%><%}%>
      </td>
      <td>&nbsp;</td>
    </tr>
   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <tr>
      <td nowrap><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
      <td class = field>
      <%if(CanEdit){%>
        <input class=inputstyle type = "text" name = "diffdesc" maxLength = 30 value = "<%=Util.toScreenToEdit(RecordSet.getString("diffdesc"),user.getLanguage())%>" onchange = "checkinput('diffdesc','InvalidFlag_Description3')" style = "width:88%">
    	<SPAN id = InvalidFlag_Description3>
    	<% if(RecordSet.getString("diffdesc").equals("")){%>
    	 <IMG src = "/images/BacoError.gif" align = absMiddle>
    	<%}%>
    	</SPAN>
      <%} else {%><%=Util.toScreen(RecordSet.getString("diffdesc") , user.getLanguage())%><%}%>
      </td>   
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
      <tr>
      <td nowrap><%=SystemEnv.getHtmlLabelName(19374,user.getLanguage())%></td>
          <td class = field>
           <%if(CanEdit){%>
          <select class=inputstyle name = "diffscope" size = 1>
          <%if(user.getLoginid().equalsIgnoreCase("sysadmin")||rolelevel.equals("2")){%>
          <option value = "0" <% if(RecordSet.getString("diffscope").equals("0")){%> selected<%}%>>
          <%=SystemEnv.getHtmlLabelName(140 , user.getLanguage())%></option>
          <%}%>    
          <option value = "1" <% if(RecordSet.getString("diffscope").equals("1")){%> selected<%}%>>
          <%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>
          <option value = "2" <% if(RecordSet.getString("diffscope").equals("2")){%> selected<%}%>>
          <%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18921, user.getLanguage())%></option>
        </select>
        <%} else {%>
        <%if(RecordSet.getString("diffscope").equals("0")){%><%=SystemEnv.getHtmlLabelName(140 , user.getLanguage())%><%}%>
        <%if(RecordSet.getString("diffscope").equals("1")){%><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%><%}%>
        <%if(RecordSet.getString("diffscope").equals("2")){%><%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18921 , user.getLanguage())%><%}%>
        <% } %>
        </td>
        </tr>
   <TR style="height:1px;display:none"><TD class=Line colSpan=2></TD></TR>
    <tr style="display:none">
      <td nowrap><%=SystemEnv.getHtmlLabelName(447,user.getLanguage())%></td>
      <td class = field>
        <%if(CanEdit){%>
        <input type = "radio" name = "difftype" value = "0" <% if(RecordSet.getString("difftype").equals("0")){%> checked<%}%>>
        <%=SystemEnv.getHtmlLabelName(456 , user.getLanguage())%>  
        <input type = "radio" name = "difftype" value = "1" <% if(RecordSet.getString("difftype").equals("1")){%> checked<%}%>>
        <%=SystemEnv.getHtmlLabelName(457 , user.getLanguage())%>
        <%} else {%>
        <% if(RecordSet.getString("difftype").equals("0")){%><%=SystemEnv.getHtmlLabelName(456 , user.getLanguage())%><%}%>
        <% if(RecordSet.getString("difftype").equals("1")){%><%=SystemEnv.getHtmlLabelName(457 , user.getLanguage())%><%}%>
        <%}%>
      </td>
      </tr>
     <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
      <tr>
      <td nowrap><%=SystemEnv.getHtmlLabelName(450,user.getLanguage())%></td>
          <td class = field>
           <%if(CanEdit){%>
          <select class=inputstyle name = "difftime" size = 1>
          <option value = "0" <% if(RecordSet.getString("difftime").equals("0")){%> selected<%}%>>
          <%=SystemEnv.getHtmlLabelName(380 , user.getLanguage())%><%=SystemEnv.getHtmlLabelName(277 , user.getLanguage())%></option>
          <option value = "1" <% if(RecordSet.getString("difftime").equals("1")){%> selected<%}%>>
          <%=SystemEnv.getHtmlLabelName(458 , user.getLanguage())%></option>
          <option value = "2" <% if(RecordSet.getString("difftime").equals("2")){%> selected<%}%>>
          <%=SystemEnv.getHtmlLabelName(370 , user.getLanguage())%><%=SystemEnv.getHtmlLabelName(371 , user.getLanguage())%></option>
        </select>
        <%} else {%>
        <%if(RecordSet.getString("difftime").equals("0")){%><%=SystemEnv.getHtmlLabelName(380 , user.getLanguage())%><%=SystemEnv.getHtmlLabelName(277 , user.getLanguage())%><%}%> 
        <%if(RecordSet.getString("difftime").equals("1")){%><%=SystemEnv.getHtmlLabelName(458 , user.getLanguage())%><%}%>
        <%if(RecordSet.getString("difftime").equals("2")){%><%=SystemEnv.getHtmlLabelName(370 , user.getLanguage())%><%=SystemEnv.getHtmlLabelName(371 , user.getLanguage())%><%}%>
        <% } %>   
        <td></td>  
        </tr>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <tr>             
      <td nowrap><%=SystemEnv.getHtmlLabelName(16071,user.getLanguage())%></td>
      <td class = field>
        <TABLE class=Viewform>
        <tr><td width = 5%>
        <%if(CanEdit){%><button class = Browser type="button" onclick="onShowColor('colorspan','color')"></button> <%}%>
        </td><td>       
        <TABLE border = 1 cellspacing = 0 cellpadding = 0 bordercolor = black>
	<TR><TD STYLE = "border:1px" ID = SelectedColor BGCOLOR = "<%=RecordSet.getString("color")%>">&nbsp;&nbsp;&nbsp;&nbsp;</TD></TR>
	</TABLE>
	</td>
    </tr>
	</table>
        <input class=inputstyle type="hidden" name="color" value="<%=RecordSet.getString("color")%>">
      </td>
    </tr> 
   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>   
   <tr> 
      <td nowrap><%=SystemEnv.getHtmlLabelName(454 , user.getLanguage())%></td>
      <td class = FIELD>
      <%if(CanEdit){%><textarea class=inputstyle name = diffremark rows = 8 cols = 50><%=Util.toScreenToEdit(RecordSet.getString("diffremark") , user.getLanguage())%></textarea>
      <%} else {%><%=Util.toScreen(RecordSet.getString("diffremark") , user.getLanguage())%><%}%>
      </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    </tbody>
    </table>
     </td>
      <!---->
    <td style="display:none"></td>
    <td valign = "top" style="display:none">
       <table class=Viewform>
          <colgroup>
          <col width = "20%">
          <col width = "80%">
          <tbody>
                
      <tr>
      <td nowrap><%=SystemEnv.getHtmlLabelName(16709 , user.getLanguage())%></td>
      <td class = field>
        <%if(CanEdit){%>
        <input class=inputstyle type = checkbox name = "salaryable" value = "1" <% if(RecordSet.getString("salaryable").equals("1")){%> checked<%}%>>
        <%} else {%>
        <% if(RecordSet.getString("salaryable").equals("1")){%><%=SystemEnv.getHtmlLabelName(163 , user.getLanguage())%>
        <% } else {%><%=SystemEnv.getHtmlLabelName(161 , user.getLanguage())%> <% } %>
        <%}%>
      </td> 
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>     
   <tr>
   <td nowrap><%=SystemEnv.getHtmlLabelName(16710 , user.getLanguage())%></td>
     <td class = field>
        <%if(CanEdit){%>
        <select class=inputstyle name = "counttype" size = 1>
          <option value = "0" <% if(RecordSet.getString("counttype").equals("0")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(452 , user.getLanguage())%></option>
          <option value="1" <% if(RecordSet.getString("counttype").equals("1")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(459 , user.getLanguage())%></option>
        </select>
        <%} else {%>
        <% if(RecordSet.getString("counttype").equals("0")){%><%=SystemEnv.getHtmlLabelName(452 , user.getLanguage())%><%}%>
        <% if(RecordSet.getString("counttype").equals("1")){%><%=SystemEnv.getHtmlLabelName(459 , user.getLanguage())%><%}%>
        <%}%>
      </td>
    </tr>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
      <tr>
      <td nowrap><%=SystemEnv.getHtmlLabelName(16711 , user.getLanguage())%></td>
      <td class = field>
      <%if(CanEdit){%>
      <input class=inputstyle onKeyPress = "ItemNum_KeyPress()" onBlur = 'checknumber1(this)' name = "countnum" size = "10" maxlength = "5" 
      <%if(!RecordSet.getString("countnum").equals("0")){%>value = "<%=Util.toScreenToEdit(RecordSet.getString("countnum") , user.getLanguage())%>"<%}%>>
      <%} else {%>
      <%=Util.toScreenToEdit(RecordSet.getString("countnum") , user.getLanguage())%>
      <%}%>
      </td>
    </tr>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <tr>
     <td nowrap><%=SystemEnv.getHtmlLabelName(16712 , user.getLanguage())%></td>
      <td class = field>
        <%if(CanEdit){%>
          <button class = Browser type="button" onclick = "onShowSalaryItem('salaryitemspan' , 'salaryitem')"></button>
        <%}%>
        <input class=inputstyle type = "hidden" name = "salaryitem" value = "<%=RecordSet.getString("salaryitem")%>">
        <SPAN id = salaryitemspan>        
          <%=Util.toScreen(SalaryComInfo.getSalaryname(RecordSet.getString("salaryitem")) , user.getLanguage())%>                
        </SPAN>
      </td>
      </tr>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <tr>
      <td nowrap><%=SystemEnv.getHtmlLabelName(16713 , user.getLanguage())%></td>
      <!--最小计算时间-->
      <td class = field>
     <%if(CanEdit){%>
      <input class=inputstyle onKeyPress = "ItemCount_KeyPress()" onBlur = 'checknumber("mindifftime")' name = "mindifftime" size = "10" maxlength = "5" 
      <% if(RecordSet.getInt("mindifftime")!=0){%>value="<%=Util.toScreenToEdit(RecordSet.getString("mindifftime") , user.getLanguage())%>"<%}%>>
      <%} else {%>
      <%=Util.toScreen(RecordSet.getString("mindifftime") , user.getLanguage())%>
      <%}%>
      </td>
      </tr>
   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
      <tr>       
        <tr> 
          <td nowrap><%=SystemEnv.getHtmlLabelName(16714 , user.getLanguage())%></td>
          <td class = field>
            <%
            String timecounttype = Util.null2String(RecordSet.getString("workflowid")) ;
            if(CanEdit){%>
            <input type=radio name="timecounttype" value="1" <% if(timecounttype.equals("1")) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(16715 , user.getLanguage())%><br>
            <input type=radio name="timecounttype" value="2" <% if(timecounttype.equals("2")) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(16716 , user.getLanguage())%><br>
            <input type=radio name="timecounttype" value="3" <% if(timecounttype.equals("3")) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(16717 , user.getLanguage())%><br>
            <input type=radio name="timecounttype" value="4" <% if(timecounttype.equals("4")) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(16718 , user.getLanguage())%><br>
            <input type=radio name="timecounttype" value="5" <% if(timecounttype.equals("5")) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(19375 , user.getLanguage())%>
            <%} else {%>
            <% if(timecounttype.equals("1")) {%><%=SystemEnv.getHtmlLabelName(16715 , user.getLanguage())%>
            <%} else if(timecounttype.equals("2")) {%><%=SystemEnv.getHtmlLabelName(16716 , user.getLanguage())%>
            <%} else if(timecounttype.equals("3")) {%><%=SystemEnv.getHtmlLabelName(16717 , user.getLanguage())%>
            <%} else if(timecounttype.equals("4")) {%><%=SystemEnv.getHtmlLabelName(16718 , user.getLanguage())%>
            <%} else if(timecounttype.equals("5")) {%><%=SystemEnv.getHtmlLabelName(19375 , user.getLanguage())%><%}%>
            <%}%>
         </td>    
        </tr>    
     </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    </tbody>
     </table>
   </td>
   </tr>
  </tbody>

<script language=javascript>
function doSave(obj){
	document.frmmain.operation.value = "save" ; 
    if(check_form(document.frmmain,'diffname,diffdesc,workflowid')){
        if( document.frmmain.salaryable.checked) {
            timecounttypecheck = false ;
            for( i=0; i< document.frmmain.timecounttype.length; i++) {
                if( document.frmmain.timecounttype[i].checked ) {
                    timecounttypecheck =  true ;
                    break ;
                }
            }

            if( timecounttypecheck ) {
                obj.disabled = true;
                frmmain.submit();
                }
            else alert("<%=SystemEnv.getHtmlLabelName(16747 , user.getLanguage())%>") ;
        }
        else {
            obj.disabled = true;
            frmmain.submit(); }
    }
} 

function doDelete(obj){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7 , user.getLanguage())%>")) {
		document.frmmain.operation.value = "delete" ;
        obj.disabled = true;
        document.frmmain.submit() ;
	} 
} 

function ItemCount_KeyPress() { 
 if(!((window.event.keyCode>=48) && (window.event.keyCode<=58)))
  { 
     window.event.keyCode=0 ; 
  } 
} 

function checknumber(objectname) { 	
	valuechar = jQuery("#"+objectname).val().split("") ; 
	isnumber = false ; 
    for(i=0 ; i < valuechar.length ; i++ ) {
            charnumber = parseInt(valuechar[i]) ; 
            if( isNaN(charnumber)&& valuechar[i]!=":") isnumber = true ;
  }
	if(isnumber) jQuery("#"+objectname).val(""); 
}

function onShowColor(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/systeminfo/ColorBrowser.jsp");
	if (data!=null){
	        if( data!= ""){
				SelectedColor.bgColor = data;
				$G(inputename).value = data;
			}else{
				SelectedColor.bgColor = data;
				$G(inputename).value = "";
			}
	}
}

function onShowSalaryItem(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/finance/salary/SalaryItemBrowser.jsp")
	if (data!=null){
	        if( data!= ""){
				jQuery($G(tdname)).html(data.name);
				jQuery($G(inputename)).val(data.id);
			}else{
				jQuery($G(tdname)).html("");
				jQuery($G(inputename)).val("");
			}
	}
}
</script>
<script language = vbs>


sub onShowWorkflow(tdname , inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value = id(0)
		else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		document.all(inputename).value = ""
		end if
	end if
end sub
</script>
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
</body>
</html>