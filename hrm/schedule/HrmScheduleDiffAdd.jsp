<%@ page import = "weaver.general.Util" %>
<%@ page import = "weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file = "/systeminfo/init.jsp" %>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("HrmScheduleDiffAdd:Add" , user)){ 
    		response.sendRedirect("/notice/noright.jsp") ; 
    		return ; 
	} %>

<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<HTML><HEAD>
<LINK href = "/css/Weaver.css" type = text/css rel = STYLESHEET>
<SCRIPT language = "javascript" src = "/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdReport.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(6139 , user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(82 , user.getLanguage()) ; 
String needfav = "1" ; 
String needhelp = "" ; 
boolean CanAdd = HrmUserVarify.checkUserRight("HrmScheduleDiffAdd:Add" , user) ;
String subcompanyid = Util.null2String(request.getParameter("subcompanyid") ) ;
%>
<BODY>
<%@ include file = "/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

String rolelevel=CheckUserRight.getRightLevel("HrmScheduleDiffAdd:Add" , user);
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/schedule/HrmScheduleDiff.jsp?subcompanyid="+subcompanyid+",_self} " ;
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
<FORM id=weaver name = frmmain method = post action = "HrmScheduleDiffOperation.jsp" >
<input class=inputstyle type = "hidden" name = "operation" value = "insert">
<input class=inputstyle type = "hidden" name = "subcompanyid" value = "<%=subcompanyid%>">
<table class=viewform>
  <colgroup>
  <col width = "49%">
  <col width = "2%">
  <col width = "49%">
  <tbody>
    <tr class = Title>
      <TH colSpan = 3><%=SystemEnv.getHtmlLabelName(6139,user.getLanguage())%></TH>
    </TR>
    <TR class = Spacing style="height:2px"> 
      <TD class = Line1 colSpan = 3></TD>
    </TR>
    <tr>
      <td>
        <table class=Viewform >
          <colgroup>
          <col width = "20%">
          <col width = "80%">
          <tbody>
          <tr>
          <td nowrap><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></td>
          <td class = field>
            <input class=inputstyle type = "text" name = "diffname" maxLength = 10 onchange = "checkinput('diffname' , 'InvalidFlag_Description1')" size = 10 >
            <SPAN id = InvalidFlag_Description1><IMG src = "/images/BacoError.gif" align=absMiddle></SPAN>
          </td>
          </tr>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td nowrap><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
          <td class = field>
            <input class=inputstyle type = "text" name = "diffdesc" maxLength = 30 onchange = "checkinput('diffdesc' , 'InvalidFlag_Description3')" style = "width:95%">
            <SPAN id = InvalidFlag_Description3><IMG src = "../../images/BacoError.gif" align = absMiddle></SPAN>
          </td>
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
        <tr>
          <td nowrap><%=SystemEnv.getHtmlLabelName(19374,user.getLanguage())%></td>
          <td class = field>
          <select class=inputstyle name = "diffscope" size = 1>
          <%if(user.getLoginid().equalsIgnoreCase("sysadmin")||rolelevel.equals("2")){%>
          <option value = "0" >
          <%=SystemEnv.getHtmlLabelName(140 , user.getLanguage())%></option>
          <%}%>    
          <option value = "1" >
          <%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%></option>
          <option value = "2" >
          <%=SystemEnv.getHtmlLabelName(141 , user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18921, user.getLanguage())%></option>
        </select>
        </td>
        </tr>
        <TR style="display:none"><TD class=Line colSpan=2></TD></TR>
        <tr style="display:none">
          <td nowrap><%=SystemEnv.getHtmlLabelName(447,user.getLanguage())%></td>
          <td class = field>
            <input type = "radio" name = "difftype" value = "0"><%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%> 
            <input type = "radio" name = "difftype" value = "1" checked><%=SystemEnv.getHtmlLabelName(457,user.getLanguage())%>
          </td>
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
        <tr>
          <td nowrap><%=SystemEnv.getHtmlLabelName(450,user.getLanguage())%></td>
          <td class = field>
            <select class=inputstyle name = "difftime" size = 1>
              <option value = "0"><%=SystemEnv.getHtmlLabelName(380 , user.getLanguage())%><%=SystemEnv.getHtmlLabelName(277 , user.getLanguage())%></option>
              <option value="1"><%=SystemEnv.getHtmlLabelName(458 , user.getLanguage())%></option>
              <option value="2"><%=SystemEnv.getHtmlLabelName(370,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(371 , user.getLanguage())%></option>
            </select></td> 
            <td></td>  
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
        <tr>             
          <td nowrap><%=SystemEnv.getHtmlLabelName(16071,user.getLanguage())%></td>
          <td class = field>
            <TABLE class=Viewform>
            <tr><td width = 5%>
            <button class = Browser type="button" onclick = "onShowColor('colorspan','color')"></button> 
            </td><td>       
            <TABLE border = 1 cellspacing = 0 cellpadding = 0 bordercolor = black>
        <TR><TD STYLE = "border:1px" ID = SelectedColor BGCOLOR = "000000">&nbsp;&nbsp;&nbsp;&nbsp;</TD></TR>
        </TABLE>
        </td>
        </tr>
        </table>
            <input class=inputstyle type = "hidden" name = "color" value="000000">
          </td>
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr> 
          <td nowrap><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
          <td class = FIELD>
            <textarea class=inputstyle name = diffremark rows = 8 cols = 50></textarea>
          </td>      
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
      </tbody>
    </table>
    </td>
    <td style="display:none"></td>
    <td valign = "top" style="display:none">
       <table class=Viewform>
          <colgroup>
          <col width = "20%">
          <col width = "80%">
          <tbody>
          <tr>
          <td nowrap><%=SystemEnv.getHtmlLabelName(16709,user.getLanguage())%></td>
          <td class = field>
            <input class=inputstyle type = "checkbox" name = "salaryable" value = "1" >
          </td>
          </tr>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
          <tr>
          <td nowrap><%=SystemEnv.getHtmlLabelName(16710,user.getLanguage())%></td>
          <td class = field>
            <select class=inputstyle name = "counttype" size = 1>
              <option value = "0"><%=SystemEnv.getHtmlLabelName(452 , user.getLanguage())%></option>
              <option value = "1"><%=SystemEnv.getHtmlLabelName(459 , user.getLanguage())%></option>
            </select></td>
          <td></td> 
          </tr>
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
         <tr>
         <td nowrap><%=SystemEnv.getHtmlLabelName(16711,user.getLanguage())%></td>
          <td class = field>
            <input class=inputstyle onKeyPress = "ItemNum_KeyPress()" onBlur = 'checknumber1(this)' name = "countnum" size = "10" maxlength = "5" style = "width:25%">
          </td>
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
        <tr>           
          <td nowrap><%=SystemEnv.getHtmlLabelName(16712,user.getLanguage())%></td>
          <td class = field>
         
            <input type = "hidden" name = "salaryitem" id="salaryitem"  class="wuiBrowser"
			_url="/systeminfo/BrowserMain.jsp?url=/hrm/finance/salary/SalaryItemBrowser.jsp">
            
             </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
       <tr>       
        <tr> 
          <td nowrap><%=SystemEnv.getHtmlLabelName(16713,user.getLanguage())%></td>
          <td class = field>
            <input class=inputstyle onKeyPress = "ItemCount_KeyPress()" onBlur = 'checknumber("mindifftime")' name = "mindifftime" size = "10" maxlength = "5"
             style = "width:25%">
         </td>    
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
       <tr>       
        <tr> 
          <td nowrap><%=SystemEnv.getHtmlLabelName(16714,user.getLanguage())%></td>
          <td class = field>
            <input type=radio name="timecounttype" value="1"><%=SystemEnv.getHtmlLabelName(16715,user.getLanguage())%><br>
            <input type=radio name="timecounttype" value="2"><%=SystemEnv.getHtmlLabelName(16716,user.getLanguage())%><br>
            <input type=radio name="timecounttype" value="3"><%=SystemEnv.getHtmlLabelName(16717,user.getLanguage())%><br>
            <input type=radio name="timecounttype" value="4"><%=SystemEnv.getHtmlLabelName(16718 , user.getLanguage())%><br>
            <input type=radio name="timecounttype" value="5" checked><%=SystemEnv.getHtmlLabelName(19375 , user.getLanguage())%>
         </td>    
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
      </tbody>
    </table>
    </td>
   </tr>
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
<SCRIPT language = javascript>
function submitData(obj) {
    if(check_form(frmmain,'diffname,diffdesc,workflowid')){
        if( document.frmmain.salaryable.checked) {
            timecounttypecheck = false ;
            for( i=0; i< document.frmmain.timecounttype.length; i++) {
                if( document.frmmain.timecounttype[i].checked ) {
                    timecounttypecheck =  true ;
                    break ;
                }
            }

            if( timecounttypecheck ) {
                obj.disabled=true;
                frmmain.submit();
                }
            else alert("<%=SystemEnv.getHtmlLabelName(16747 , user.getLanguage())%>") ;
        }
        else {
            obj.disabled=true;
            frmmain.submit();
            }
    }
}
function ItemCount_KeyPress(){ 
    if(!((window.event.keyCode>=48) && (window.event.keyCode<=58))) { 
       window.event.keyCode=0 ; 
  } 
} 
function checknumber(objectname){ 	
	valuechar = jQuery("#"+objectname).val().split("") ; 
	isnumber = false ; 
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!=":") isnumber = true ;}
	if(isnumber) jQuery("#"+objectname).val(""); 
} 

function onShowColor(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/systeminfo/ColorBrowser.jsp");
	if (data!=null){
	        if(data!=""){
				SelectedColor.bgColor = data;
				jQuery("input[name="+inputename+"]").val(data);
			}else{
				SelectedColor.bgColor = data;
				jQuery("input[name="+inputename+"]").val("");
			}
	}
}
</SCRIPT>

<script language = vbs>
sub onShowSalaryItem(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/finance/salary/SalaryItemBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> 0 then
		tdname.innerHtml = id(1)
		inputename.value = id(0)
		else
		tdname.innerHtml = ""
		inputename.value = ""
		end if
	end if
end sub

sub onShowWorkflow(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value = id(0)
		else
		document.all(tdname).innerHtml = "<IMG src = '/images/BacoError.gif' align = absMiddle>"
		document.all(inputename).value = ""
		end if
	end if
end sub

</script>
</body>
</html>