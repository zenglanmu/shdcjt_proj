<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<jsp:useBean id="TrainLayoutComInfo" class="weaver.hrm.train.TrainLayoutComInfo" scope="page" />
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page" />
<html>
<%
   
//if(!HrmUserVarify.checkUserRight("HrmTrainPlanAdd:Add", user)){
//    		response.sendRedirect("/notice/noright.jsp");
//    		return;
//	}
	
int userid = user.getUID();
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String msg = Util.null2String(request.getParameter("msg"));
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(6103,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/trainplan/HrmTrainPlan.jsp,_self} " ;
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

<FORM id=weaver name=frmMain action="TrainPlanOperation.jsp" method=post >

<%if(msg.equals("1")){%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getHtmlLabelName(16163,user.getLanguage())%>
</div>
<%}%>
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="15%">
  <COL width="85%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6156,user.getLanguage())%></TH></TR>
  <TR class=Spacing style="height:2px">
    <TD class=Line1 colSpan=2 ></TD>
  </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle type=text size=30 name="name" onchange="checkinput('name','nameimage')">
          <SPAN id=nameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN> 
          </td>
        </TR>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6128,user.getLanguage())%></TD>
          <TD class=Field>
	        <INPUT class=wuiBrowser id=layoutid type=hidden name=layoutid 
	        _url="/systeminfo/BrowserMain.jsp?url=/hrm/train/trainlayout/TrainLayoutBrowser.jsp" _required=yes>
          </TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(16141,user.getLanguage())%> </td>
          <td class=Field>
	      <INPUT class=wuiBrowser id=organizer type=hidden name=organizer value="<%=user.getUID()%>"
	      _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
	      _displayTemplate="<a href=javascript:openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id=#b{id}');>#b{name}</a>&nbsp;"
	      _displayText="<%=ResourceComInfo.getResourcename(""+user.getUID())%>">
	  </td>	   
        </tr> 
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
          <td class=Field>
            <BUTTON class=Calendar type="button" id=selectstartdate onclick="getDate(startdatespan,startdate)"></BUTTON> 
            <SPAN id=startdatespan ></SPAN> 
            <input class=inputstyle type="hidden" id="startdate" name="startdate" >
          </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>          
          <td class=Field>
            <BUTTON class=Calendar type="button" id=selectenddate onclick="getDate(enddatespan,enddate)"></BUTTON> 
            <SPAN id=enddatespan ></SPAN> 
            <input class=inputstyle type="hidden" id="enddate" name="enddate" >
          </td>            
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></td>
          <td class=Field>
            <textarea class=inputstyle cols=50 rows=4 name=content ></textarea>
          </td>
        </tr>          
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%> </td>
          <td class=Field>
            <textarea class=inputstyle cols=50 rows=4 name=aim ></textarea>            
          </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1395,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle type=text size=30 name="address" >
          </td>
        </TR>                
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15879,user.getLanguage())%></TD>
          <TD class=Field>
	        <INPUT class=wuiBrowser id=resource type=hidden name=resource 
	        _url="/systeminfo/BrowserMain.jsp?url=/hrm/train/trainresource/HrmTrainResourceBrowser.jsp">          
          </td>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(18876,user.getLanguage())%></TD>
          <TD class=Field>
           <button class=Browser type="button" onclick="onShowMultiDoc(docsspan,docs)" ></button>
           <span id=docsspan name=docsspan></span>
           <input type=hidden id=docs name=docs>
          </td>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(15761,user.getLanguage())%></td>
          <td class=Field>
	      <INPUT class=wuiBrowser id=actor type=hidden name=actor 
	      _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" _required=yes
	      _displayTemplate="<a href=javascript:openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id=#b{id});'>#b{name}</a>&nbsp;">
	  </td>	 
      </tr>
      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
      <TR>
          <TD><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TD>
          <TD class=Field>
            <INPUT class=inputstyle type=text size=30 name="budget" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("budget")'>
          </td>
        </TR>        
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15371,user.getLanguage())%></TD>
          <TD class=Field>
	    <INPUT class=wuiBrowser id=budgettype type=hidden name=budgettype 
	    _url="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?sqlwhere=where feetype='1'">
          </td>
        </TR>        
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<!--        <TR>
          <TD>¹«¿ª·¶Î§</TD>
          <TD class=Field><INPUT class=inputstyle type=text size=30 name="openrange" >
          </td>
        </TR>                 
        </tr>  
-->        
 </TBODY>
 </TABLE> 
 
 <TABLE width="100%"  class=ListStyle cellspacing=1  cols=6 id="oTable">

	      <TBODY> 
          <TR class=Header> 
            <TH colspan=3><%=SystemEnv.getHtmlLabelName(16150,user.getLanguage())%></TH>
			<Td align=right colspan=3>
			 <BUTTON class=btnNew type="button" accessKey=A onClick="addoRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,user.getLanguage())%></BUTTON>
	         <BUTTON class=btnDelete type="button" accessKey=D onClick="javascript:if(isdel()){deleteoRow1()};"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON> 	
 		    </Td>
          </TR>
          <TR class=Spacing style="display:none"> 
            <TD class=sep1 colSpan=6></TD>
          </TR>	
		  <tr class=header>
            <td></td>
		    <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>	</td>
            <td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></td>
			<td><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%></td>
		  </tr>
      </tbody>
       </table>

<input class=inputstyle type="hidden" name=operation>
<input class=inputstyle type=hidden name=rowindex>
</form>

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
sub onShowResource(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	    resourceids = id(0)
		resourcename = id(1)
		sHtml = ""
		resourceids = Mid(resourceids,2,len(resourceids))
		resourcename = Mid(resourcename,2,len(resourcename))
		inputname.value= resourceids
		while InStr(resourceids,",") <> 0
			curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			sHtml = sHtml&"<a href=javascript:openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id="&curid&"')>"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href=javascript:openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id="&resourceids&"')>"&resourcename&"</a>&nbsp"
		spanname.innerHtml = sHtml
	else
    	spanname.innerHtml = ""
    	inputname.value="0"
	end if
	end if
end sub

sub onShowLayout()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/train/trainlayout/TrainLayoutBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	layoutidspan.innerHtml = id(1)
	frmMain.layoutid.value=id(0)
	else
	layoutidspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	frmMain.layoutid.value=""
	end if
	end if
end sub

sub onShowTrainResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/train/trainresource/HrmTrainResourceBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	resourcespan.innerHtml = id(1)
	frmMain.resource.value=id(0)
	else
	resourcespan.innerHtml = ""
	frmMain.resource.value=""
	end if
	end if
end sub

sub onShowBudgetType()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?sqlwhere=where feetype='1'")
	if Not isempty(id) then
	if id(0)<> "" then
	budgettypespan.innerHtml = id(1)
	frmMain.budgettype.value=id(0)
	else
	budgettypespan.innerHtml = ""
	frmMain.budgettype.value=""
	end if
	end if
end sub
</script>
<script language="JavaScript" src="/js/addRowBg.js" >
</script>
<script language=javascript>
  rowindex = "0"
  var rowColor="" ;

function addoRow()
{
	ncol = jQuery("#oTable").find("tr:nth-child(3)").find("td").length;

	oRow = oTable.insertRow(-1);
		rowColor = getRowBg();

	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
    	oCell.style.background= rowColor;

		switch(j) {
            case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox' name='check_o' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				oCell.style.width=100;
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar type=button  onclick='getDate(datespan_"+rowindex+" , date_"+rowindex+")' > </BUTTON><SPAN id='datespan_"+rowindex+"'></SPAN> <input class=inputstyle type=hidden id='date_"+rowindex+"' name='date_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 2:
				oCell.style.width=100;
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar type=button  onclick='onTrainPlanTime(starttimespan_"+rowindex+" , starttime_"+rowindex+")' > </BUTTON><SPAN id='starttimespan_"+rowindex+"'></SPAN> <input class=inputstyle type=hidden id='starttime_"+rowindex+"' name='starttime_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 3:
				oCell.style.width=100;
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar type=button  onclick='onTrainPlanTime(endtimespan_"+rowindex+" , endtime_"+rowindex+")' > </BUTTON><SPAN id='endtimespan_"+rowindex+"'></SPAN> <input class=inputstyle type=hidden id='endtime_"+rowindex+"' name='endtime_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 4:
			        var oDiv = document.createElement("div");
				var sHtml = "<textarea class=inputstyle cols=50 rows=4 name='daycontent_"+rowindex+"'></textarea>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 5:
				var oDiv = document.createElement("div");
				var sHtml = "<textarea class=inputstyle cols=50 rows=4 name='dayaim_"+rowindex+"'></textarea>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	rowindex = rowindex*1 +1;
}

function deleteoRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_o')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_o'){
			if(document.forms[0].elements[i].checked==true) {
				oTable.deleteRow(rowsum1+2);
			}
			rowsum1 -=1;
		}

	}
}

function dosave(){
   if(check_form(document.frmMain,'name,layoutid')&&checkDateValidity(frmMain.startdate.value,frmMain.enddate.value)){
    document.frmMain.rowindex.value=rowindex;
    document.frmMain.operation.value="add";
    document.frmMain.submit();
  }
  }


function checkDateValidity(startDate,endDate){
      var isValid = true;
      if(compareDate(startDate,endDate)==1){
        alert("<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>");
        isValid = false;
      }

      return isValid;
}
 /**
 *Author: Charoes Huang
 *compare two date string ,the date format is: yyyy-mm-dd hh:mm
 *return 0 if date1==date2
 *       1 if date1>date2
 *       -1 if date1<date2
*/
function compareDate(date1,date2){
	//format the date format to "mm-dd-yyyy hh:mm"
	var ss1 = date1.split("-",3);
	var ss2 = date2.split("-",3);

	date1 = ss1[1]+"-"+ss1[2]+"-"+ss1[0];
	date2 = ss2[1]+"-"+ss2[2]+"-"+ss2[0];

	var t1,t2;
	t1 = Date.parse(date1);
	t2 = Date.parse(date2);
	if(t1==t2) return 0;
	if(t1>t2) return 1;
	if(t1<t2) return -1;

    return 0;
}
  function onShowMultiDoc(spanname, inputname) {
      try {
      data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp");
      } catch(e) {
          return;
      }
      if (data != null) {
          if (data.id != ""){
        	  ids = data.id.split(",");
  			names =data.name.split(",");
              content="";
              for(i=0;i<ids.length;i++){
            	  if(ids[i]!="")
                  content+="<A href='/docs/docs/DocDsp.jsp?id="+ids[i]+"'>"+names[i]+"</A>&nbsp";
              }
              spanname.innerHTML = content;
              inputname.value = data.id.substring(1);
          }else {
              spanname.innerHTML = "";
              inputname.value = "";
          }
      }
  }
 function getTime(spanname,inputname){
      id = window.showModalDialog("/systeminfo/Clock.jsp",spanname.innerHTML,"dialogHeight:320px;dialogwidth:275px");
      if(spanname.id.indexOf("endtime")>-1){
         starttime=document.all("starttime_"+inputname.id.substring(inputname.id.indexOf("_")+1)).value;
         if(starttime!=null&&starttime!=""){
             if(id<starttime){
                 alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
                 return;
             }

         }
      }
      if(spanname.id.indexOf("starttime")>-1){
         endtime=document.all("endtime_"+inputname.id.substring(inputname.id.indexOf("_")+1)).value;
         if(endtime!=null&&endtime!=""){
             if(id>endtime){
                 alert("<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>");
                 return;
             }

         }
      }
      spanname.innerHTML=id;
      inputname.value=id;
  }
 </script>

</BODY>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
