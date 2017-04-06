<%@ page import="weaver.general.Util,
                 java.sql.Timestamp" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="MailMouldComInfo" class="weaver.docs.mail.MailMouldComInfo" scope="page" />
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("HrmCareerPlanAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
    Date newdate = new Date() ;
    long datetime = newdate.getTime() ;
    Timestamp timestamp = new Timestamp(datetime) ;
    String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
    String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);



String id = request.getParameter("id");

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6132,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCareerPlanAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doedit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/career/careerplan/HrmCareerPlan.jsp,_self} " ;
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

<FORM id=weaver name=frmMain action="CareerPlanOperation.jsp" method=post >
<TABLE class=Viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6132,user.getLanguage())%></TH></TR>
  <TR class=spacing style="height:2px">
    <TD class=Line1 colSpan=2 ></TD>
  </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
          <TD class=Field>
            <input class=inputstyle type=text size=30 name="topic" onchange="checkinput('topic','topicimage')">
          <SPAN id=topicimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN> 
          </td>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
          <TD class=Field>
 
              <input class="wuiBrowser" id=jobtitle type=hidden name=principalid 
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			  _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>">                                  
          </td>
        </TR>   
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(15669,user.getLanguage())%></td>
          <td class=Field >             

              <input class="wuiBrowser" id=jobtitle type=hidden name=informmanid 
			  _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			  _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>">                                            
          </td>
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <!--  去掉 并没有什么用处
        <tr>
          <td>通知邮件模板</td>
          <td class=Field>
            <BUTTON class=Browser id=selectdate onclick="onShowEmailMould()"></BUTTON> 
              <SPAN id=emailmouldspan ></SPAN> 
              <input class=inputstyle type="hidden" id="emailmould" name="emailmould" >                        
          </td>
        </tr>
        -->
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(15744,user.getLanguage())%></td>
          <td class=Field>
            <BUTTON class=Calendar type="button" id=selectdate onclick="getDate(datespan,startdate)"></BUTTON> 
              <SPAN id=datespan ></SPAN> 
              <input class=inputstyle type="hidden" id="startdate" name="startdate" >                        
          </td>
        </tr>   
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<!--        <TR>
          <TD>预算</TD>
          <TD class=Field>
            <input class=inputstyle type=text size=30 name="budget" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("budget")'> 
          </TD>
        </TR>
        <TR>
          <TD>预算类型</TD>
          <TD class=Field>
            <BUTTON class=Browser onClick="onShowBudgetType()">
	    </BUTTON> 
	    <span class=inputstyle id=budgettypespan>
	    </span> 
	    <INPUT class=inputstyle id=budgettype type=hidden name=budgettype >
          </TD>
        </TR> 
-->                  
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
          <td class=Field>
            <textarea class=inputstyle cols=50 rows=4 name=memo ></textarea>
          </td>
        </tr>     
        <TR style="height:2px"><TD class=Line1 colSpan=2></TD></TR> 
     </TBODY>
     </TABLE>
        <TABLE width="100%"  class=ListStyle cellspacing=1  cols=4 id="oTable">          
	   <TBODY> 
          <TR class=Header> 
            <TH colspan=2><%=SystemEnv.getHtmlLabelName(15745,user.getLanguage())%></TH>
	    <Td align=right colspan=4>
	 	<BUTTON class=btnNew type="button" accessKey=A onClick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,user.getLanguage())%></BUTTON>
		<BUTTON class=btnDelete type="button" accessKey=D onClick="confirmDel();"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>	
 	    </Td>
          </TR>
        <tr class=header>
            <td ></td>
	    <td ><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
	    <td ><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
	    <td ><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
          </tr> 

  </tbody>
</table>
<input class=inputstyle type="hidden" name=operation>
<input class=inputstyle type=hidden name=id value="<%=id%>">
<input class=inputstyle type=hidden name=rownum>
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

<script language=vbs>

sub onShowEmailMould()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/mail/DocMouldBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	emailmouldspan.innerHtml = id(1)
	frmMain.emailmould.value=id(0)
	else
	emailmouldspan.innerHtml = ""
	frmMain.emailmould.value=""
	end if
	end if
end sub
sub onShowResource(inputspan,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	inputspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else
	inputspan.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub
sub onShowBudgetType()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?sqlwhere=where feetype='1'")
	if Not isempty(id) then
	if id(0)<> 0 then
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
 function doedit(){
 if(check_form(document.frmMain,'topic')){
   if(checkDateValidity()){
       document.frmMain.rownum.value=rowindex;
       document.frmMain.operation.value="add";
       document.frmMain.submit();
   }
 }
 }
var rowColor="" ;
rowindex = 0;
function addRow()
{
	ncol = jQuery(oTable).find("tr:nth-child(2)").find("td").length;
	oRow = oTable.insertRow(-1);
	rowColor = getRowBg();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
                   	 case 0:
                 		oCell.style.width=20;
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox'  style='width:100%' name='check_node' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type=text style='width:100%' name='stepname_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
                		oCell.style.width=150;
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar type='button'  id=selectstepstartdate onclick='getDate(stepstartdatespan_"+rowindex+" , stepstartdate_"+rowindex+")' > </BUTTON><SPAN id='stepstartdatespan_"+rowindex+"'></SPAN> <input class=inputstyle type=hidden id='stepstartdate_"+rowindex+"' name='stepstartdate_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
                		oCell.style.width=150;
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar type='button' id=selectstependdate onclick='getDate(stependdatespan_"+rowindex+" , stependdate_"+rowindex+")' > </BUTTON><SPAN id='stependdatespan_"+rowindex+"'></SPAN> <input class=inputstyle type=hidden id='stependdate_"+rowindex+"' name='stependdate_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	rowindex = rowindex*1 +1;
}

function isCheckedOne(){
	len = document.forms[0].elements.length;
	var flag = false;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				flag = true;
				break;
			}
		}
	}
	return flag;
}
function confirmDel(){
	if(isCheckedOne()){
		if(isdel()){
			deleteRow1();
		}
	}else{
		alert("<%=SystemEnv.getHtmlLabelName(15445,user.getLanguage())%>");
	}
}

function deleteRow1(){
	var obj;
	var input_obj;
	for(var i=2;i<jQuery(oTable)[0].rows.length;i++){
		obj = oTable.rows[i].cells[0].children.item(0);
		if(obj!=null&&obj.tagName=="DIV"){
			input_obj =	obj.children.item(0);
			if(input_obj!=null&&input_obj.tagName=="INPUT"){
				if(input_obj.checked){
					oTable.deleteRow(i);
					i--;
				}
			}
		}
	}
}


/**
 *Added By Huang Yu On April 28,2004
 *Description : 检查日期的完整性
 *              招聘步骤的 开始时间 >= 招聘计划的 招聘时间
                招聘步骤的 开始时间 <= 结束时间
                招聘步骤的 前一步的开始时间 <=后一步的 开始时间
 *
*/
function checkDateValidity() {
    var currentDate ="<%=CurrentDate%>";
    var startDate = frmMain.startdate.value;
    //alert(startDate);
    /*
    if(compareDate(startDate,currentDate)== -1){
        alert("招聘计划的开始日期必须在当前日期之后");
        return false;
    }
    */
    var stepStartDate = new Array();
    var stepEndDate = new Array();
    var stepName = new Array();
    for(var i=3;i<oTable.rows.length;i++){
        var rowObj = oTable.rows.item(i);
        stepName[i-3] = rowObj.cells.item(1).children(0).children(0).value; //步骤名称
        stepStartDate[i-3] = rowObj.cells.item(2).innerText;    //步骤开始日期
        stepEndDate[i-3] = rowObj.cells.item(3).innerText;      //步骤结束日期
    }
    for(var i=0;i<stepName.length;i++){
        //alert(compareDate(stepStartDate[i],startDate));
        if(compareDate(stepStartDate[i],startDate)== -1){
            alert("步骤 '"+stepName[i]+"' 的开始日期必须在招聘计划的招聘时间之后！");
            return false;
            break;
        }
        if(compareDate(stepStartDate[i],stepEndDate[i]) == 1) {
            alert("步骤 '"+stepName[i]+"' 的开始日期必须在其结束日期之前或等于结束日期！")
            return false;
            break;
        }

        //检察步骤之间的开始时间是否有效
        for(var j=i+1;j<stepName.length;j++){
               if(compareDate(stepStartDate[i],stepStartDate[j]) == 1){
                 alert("步骤'"+stepName[i]+"'的开始日期必须小于或等于 步骤'"+stepName[j]+"'的开始日期！");
                 return false;
                 break;
               }
        }
    }


     return true;
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
</script>
</BODY>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
