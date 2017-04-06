<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<% if(!HrmUserVarify.checkUserRight("HrmCheckKindAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>

<HTML>
<%
String id = request.getParameter("id");
String checkitemid = Util.null2String(request.getParameter("checkitemid"));
String jobid = Util.null2String(request.getParameter("jobid"));
String resourceid = Util.null2String(request.getParameter("resourceid"));


%>
<HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6118,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>   
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doBack(),_self} " ;
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

<FORM name=hrmcheckkind id=hrmcheckkind action="HrmCheckOperation.jsp" method=post>
<input class=inputstyle type=hidden name=operation>
<input class=inputstyle type=hidden name=id value="<%=id%>">
<input class=inputstyle type=hidden name=trainrownum>
<input class=inputstyle type=hidden name=rewardrownum>
<input class=inputstyle type=hidden name=cerrownum>

      <TABLE width="100%"  class=viewForm>
          <COLGROUP> <COL width=15%> <COL width=85%>
	      <TBODY> 
          <TR class=title> 
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15759,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing style="height:2px"> 
            <TD class=line1 colSpan=2></TD>
          </TR>	
          <TR> 
            <TD ><%=SystemEnv.getHtmlLabelName(15755,user.getLanguage())%></TD>            
             <TD class=Field> 
      <input class=inputstyle  maxLength=30 size=30 name="kindname" onchange='checkinput("kindname","kindnamespan")'>
      <SPAN id=kindnamespan><IMG src="/images/BacoError.gif" align=absMiddle></SPAN> 
    </TD>
    </TR>	    
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
     <TR> 
    <TD><%=SystemEnv.getHtmlLabelName(15386,user.getLanguage())%></TD>
    <td class=Field> 
      <select class=inputstyle name=checkcycle >
        <option value="1"><%=SystemEnv.getHtmlLabelName(541,user.getLanguage())%></option>
        <option value="2"><%=SystemEnv.getHtmlLabelName(543,user.getLanguage())%></option>
        <option value="3"><%=SystemEnv.getHtmlLabelName(538,user.getLanguage())%></option>
        <option value="4"><%=SystemEnv.getHtmlLabelName(546,user.getLanguage())%></option>
      </select>
    </td>
  </TR>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <TR> 
    <TD><%=SystemEnv.getHtmlLabelName(15757,user.getLanguage())%></TD>
    <TD class=Field> 
      <input class=inputstyle  maxLength=30 size=5 name="checkexpecd" onchange='checkinput("checkexpecd","checkexpecdspan")' onKeyPress="ItemCount_KeyPress()">Ìì
      <SPAN id=checkexpecdspan><IMG src="/images/BacoError.gif" align=absMiddle></SPAN> 
    </TD>
  </TR>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
            <TD ><%=SystemEnv.getHtmlLabelName(15758,user.getLanguage())%></TD>
            <TD class=Field>
              <input class=wuiDate type="hidden" id="checkstartdate" name="checkstartdate" value="" _isrequired="yes">
            </TD>
          </TR>
            </tbody>
       </table>

    
<br>
       <TABLE width=100%  class=ListStyle cellspacing=1  cols=3 id="trainTable">

	      <TBODY> 
          <TR class=Header> 
            <TH colspan=2><%=SystemEnv.getHtmlLabelName(17425,user.getLanguage())%></TH>
			<Td align=right colspan=2>
			 <BUTTON class=btnNew type="button" accessKey=A onClick="addtrainRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,user.getLanguage())%></BUTTON>
			 <BUTTON class=btnDelete type="button" accessKey=D onClick="javascript:if(isdel()){deletetrainRow1()};"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>	
 		    </Td>
          </TR>
          <TR class=spacing style="display:none"> 
            <TD class=Sep1 colSpan=3></TD>
          </TR>	
		  <tr class=Header>
            <td width=4% > </td>
		    <td width=20% ><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></td>
			<td width=76% ></td>
		  </tr> 
      </tbody>
       </table>
<br>
        <TABLE width="100%"  class=ListStyle cellspacing=1  cols=3 id="cerTable">

	      <TBODY> 
          <TR class=Header> 
            <TH colspan=2><%=SystemEnv.getHtmlLabelName(6117,user.getLanguage())%></TH>
			<Td align=right colspan=3>
			 <BUTTON class=btnNew type="button" accessKey=A onClick="addcerRow();"><U>A</U><%=SystemEnv.getHtmlLabelName(551,user.getLanguage())%> </BUTTON>
			 <BUTTON class=btnDelete type="button" accessKey=D onClick="javascript:if(isdel()){deletecerRow1()};"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>	
 		    </Td>
          </TR>
          <TR class=spacing style="display:none"> 
            <TD class=Sep1 colSpan=3></TD>
          </TR>	
		  <tr class=header>
            <td width=7%></td>
		    <td width=71%><%=SystemEnv.getHtmlLabelName(6117,user.getLanguage())%></td>
			<td width=22%><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%></td>
				
		  </tr> 
      </tbody>
       </table>

<br>

        <TABLE width="100%"  class=ListStyle cellspacing=1  cols=4 id="rewardTable">

	      <TBODY> 
          <TR class=Header> 
            <TH colspan=3><%=SystemEnv.getHtmlLabelName(15662,user.getLanguage())%></TH>
			<Td align=right colspan=1>
			 <BUTTON class=btnNew type="button" accessKey=A onClick="addrewardRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,user.getLanguage())%></BUTTON> 
			 <BUTTON class=btnDelete type="button" accessKey=D onClick="javascript:if(isdel()){deleterewardRow1()};"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
 		    </Td>
          </TR>
          <TR class=spacing style="display:none"> 
            <TD class=Sep1 colSpan=4></TD>
          </TR>	
		  <tr class=header>
            <td width=12%></td>
		    <td width=21%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
			<td width=45%><%=SystemEnv.getHtmlLabelName(15761,user.getLanguage())%></td>			
			<td width=21%><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%></td>
		  </tr> 
      </tbody>
       </table>

<input class=inputstyle type=hidden name="trainrowcount" >
<input class=inputstyle type=hidden name="cerrowindex" >
<input class=inputstyle type=hidden name="rewardrowindex" >
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
<script language="JavaScript" src="/js/addRowBg.js" >   
</script>  
<script language=javascript>
 
trainrowindex = 0 ;
var rowColor="" ;
function addtrainRow()
{
	ncol = jQuery("#trainTable").find("tr:nth-child(3)").find("td").length;
	rowColor = getRowBg();
	oRow = trainTable.insertRow(-1);
	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1); 
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox'  style='width:100%' name='check_train' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=wuiBrowser type=hidden name=jobid_"+trainrowindex+" span id=jobid_"+trainrowindex+" span value='' _url='/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				jQuery(oDiv).find(".wuiBrowser").modalDialog();
				break;
		}
	}
	trainrowindex = trainrowindex*1 +1;
	
}

function deletetrainRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_train')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_train'){
			if(document.forms[0].elements[i].checked==true) {
				trainTable.deleteRow(rowsum1+2);	
			}
			rowsum1 -=1;
		}
	
	}	
}	


cerrowindex = 0 ;
function addcerRow()
{
	ncol = jQuery("#cerTable").find("tr:nth-child(3)").find("td").length;
	rowColor = getRowBg();
	oRow = cerTable.insertRow(-1);
	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1); 
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox'  style='width:100%' name='check_cer' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:

				var oDiv = document.createElement("div");
				var sHtml = "<input class=wuiBrowser type=hidden name=checkitemid_"+cerrowindex+" span id=checkitemid_"+cerrowindex+" span value='' _url='/systeminfo/BrowserMain.jsp?url=/hrm/check/CheckItemBrowser.jsp'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				jQuery(oDiv).find(".wuiBrowser").modalDialog();
				break;
			case 2: 
                oCell.style.width=100;
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=inputstyle type=text style='width:30%' name='checkitemproportion_"+cerrowindex+"' onKeyPress='ItemCount_KeyPress()'>%";				
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
			document.forname.cerrowindex = cerrowindex ;		    
		}
	}
	cerrowindex = cerrowindex*1 +1;
	
}

function deletecerRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_cer')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_cer'){
			if(document.forms[0].elements[i].checked==true) {
				cerTable.deleteRow(rowsum1+2);	
			}
			rowsum1 -=1;
		}
	
	}	
}	

rewardrowindex = 0 ;
function addrewardRow()
{
	ncol = jQuery("#rewardTable").find("tr:nth-child(3)").find("td").length;
	rowColor = getRowBg();
	oRow = rewardTable.insertRow(-1);
	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1); 
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
            case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox' name='check_reward' value='0'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<select class=inputstyle  name='typeid_"+rewardrowindex+"' onchange='onChangeSharetype("+rewardrowindex+")'><option value='1'><%=SystemEnv.getHtmlLabelName(15763,user.getLanguage())%></option><option value='2'><%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%></option><option value='3'><%=SystemEnv.getHtmlLabelName(15762,user.getLanguage())%></option><option value='4'><%=SystemEnv.getHtmlLabelName(15764,user.getLanguage())%></option><option value='5'><%=SystemEnv.getHtmlLabelName(15765,user.getLanguage())%></option><option value='6'><%=SystemEnv.getHtmlLabelName(15766,user.getLanguage())%></option><option value='7'><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option></select>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<div id='resourcediv_"+rewardrowindex+"' style='display:none'><input class=wuiBrowser type=hidden name=resourceid_"+rewardrowindex+" span id=resourceid_"+rewardrowindex+"span value='' _url='/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp' _displayTemplate='<A target=_blank href=/hrm/resource/HrmResource.jsp?id=#b{id}>#b{name}</A>' _required='yes'></div>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				jQuery(oDiv).find(".wuiBrowser").modalDialog();
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:30%' name='checkproportion_"+rewardrowindex+"' onKeyPress='ItemCount_KeyPress()'>%";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
           document.forname.rewardrowindex = rewardrowindex ;
		}
	}
	rewardrowindex = rewardrowindex*1 +1;

}

function deleterewardRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_reward')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_reward'){
			if(document.forms[0].elements[i].checked==true) {
				rewardTable.deleteRow(rowsum1+2);
			}
			rowsum1 -=1;
		}

	}
}
  /**
  *Add by Huang On May 10,2004 ,
  */
  function checkNoZero() {
       var checkValue = hrmcheckkind.checkexpecd.value;
       if(parseInt(checkValue)<=0 || parseInt(checkValue)+""=="NaN") {
        alert("<%=SystemEnv.getHtmlLabelName(17408,user.getLanguage())%>");
        return false;
       }
       return true;
  }
  function doSave(){
    if(check_form(document.hrmcheckkind,'kindname,checkexpecd,checkstartdate')&&checkNoZero()){
	 document.hrmcheckkind.trainrownum.value=trainrowindex;
	 document.hrmcheckkind.rewardrownum.value=rewardrowindex;
	 document.hrmcheckkind.cerrownum.value=cerrowindex;
     document.hrmcheckkind.operation.value="AddCheckKindinfo";
	 document.hrmcheckkind.submit();
    }
  }

  function doBack(){
	location = "HrmCheckKind.jsp";
  }
  function onChangeSharetype(rewardrowindex){
    thisvalue=jQuery("select[name=typeid_"+rewardrowindex+"]").val() ;

    if(thisvalue==7){
 		jQuery("#resourcediv_"+rewardrowindex).show();
	}
	else{
		jQuery("#resourcediv_"+rewardrowindex).hide();
	}
}


</script>

<script language=vbs>
sub onShowResourceID(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else
	spanname.innerHtml = "<img src='/images/BacoError.gif' align=absMiddle>"
	inputname.value=""
	end if
	end if
end sub

sub onShowUsekind()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/usekind/UseKindBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	usekindspan.innerHtml = id(1)
	resource.usekind.value=id(0)
	else
	usekindspan.innerHtml = ""
	resource.usekind.value=""
	end if
	end if
end sub

sub onShowSpeciality(inputspan,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/speciality/SpecialityBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	inputspan.innerHtml = id(1)
	inputname.value=id(0)
	else
	inputspan.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub
sub onShowCheckID(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/check/CheckItemBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
    else
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub
sub onShowJobID(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
    else
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub


</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>