<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />
<jsp:useBean id="TrainResourceComInfo" class="weaver.hrm.train.TrainResourceComInfo" scope="page" />

<html>
<%	
//HrmDateCheck check= new HrmDateCheck();
//check.checkDate();

String planid = request.getParameter("planid");	
int userid = user.getUID();
  String name = "";  
  String organizer = "";
  String startdate="";
  String enddate = "";
  String content="";
  String aim = "";  
  String address = "";
  String resource = "";   
  
  String sql = "select * from HrmTrainPlan where id = "+planid;
  rs.executeSql(sql);
  while(rs.next()){
     name = Util.null2String(rs.getString("planname"));     
     organizer = Util.null2String(rs.getString("planorganizer"));
     startdate = Util.null2String(rs.getString("planstartdate"));
     enddate = Util.null2String(rs.getString("planenddate"));
     content = Util.toScreenToEdit(rs.getString("plancontent"),user.getLanguage());
     aim = Util.toScreenToEdit(rs.getString("planaim"),user.getLanguage());//Util.null2String(rs.getString("planaim"));
     address = Util.null2String(rs.getString("planaddress"));     
     resource = Util.null2String(rs.getString("planresource"));               
  } 
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(678,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/train/HrmTrain.jsp,_self} " ;
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
<FORM id=weaver name=frmMain action="TrainOperation.jsp" method=post >
<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6136,user.getLanguage())%></TH></TR>
  <TR class=spacing style="height:2px">
    <TD class=line1 colSpan=2 ></TD>
  </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field>
            <input class=inputstyle type=text size=30 name="name" onchange='checkinput("name","nameimage")'>
          <SPAN id=nameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>
          </td>
        </TR>   
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6156,user.getLanguage())%></TD>
          <TD class=Field>            
	       	 <%=name%>     
	       <INPUT class=inputStyle id=layoutid type=hidden name=planid value="<%=planid%>">           
          </TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(16141,user.getLanguage())%> </td>
          <td class=Field>
	      <INPUT class=wuiBrowser id=organizer type=hidden name=organizer value="<%=organizer%>"
	      _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
	      _displayText="<%=ResourceComInfo.getMulResourcename(organizer)%>"
	      _displayTemplate="<a href=javascript:openFullWindowForXtable('/hrm/resource/HrmResource.jsp?id=#b{id}')>#b{name}</a>&nbsp;">
	  </td>	   
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
          <td class=Field>
            <BUTTON class=Calendar type=button id=selectstartdate onclick="getDate(startdatespan,startdate)"></BUTTON> 
            <SPAN id=startdatespan ><%=startdate%></SPAN> 
            <input class=inputstyle type="hidden" id="startdate" name="startdate" value="<%=startdate%>">            
          </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>          
          <td class=Field>
            <BUTTON class=Calendar type=button id=selectenddate onclick="getDate(enddatespan,enddate)"></BUTTON> 
            <SPAN id=enddatespan ><%=enddate%></SPAN> 
            <input class=inputstyle type="hidden" id="enddate" name="enddate" value="<%=enddate%>">            
          </td>            
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></td>
          <td class=Field>
            <textarea class=inputstyle cols=50 rows=4 name=content value="<%=content%>"><%=content%></textarea>
          </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%> </td>
          <td class=Field>
            <textarea class=inputstyle cols=50 rows=4 name=aim value="<%=aim%>"><%=aim%></textarea>            
          </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1395,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=text size=30 name="address" value="<%=address%>">
          </td>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15879,user.getLanguage())%></TD>
          <TD class=Field>
	        <input class=wuiBrowser type=hidden name=resource value="<%=resource%>"
	        _url="/systeminfo/BrowserMain.jsp?url=/hrm/train/trainresource/HrmTrainResourceBrowser.jsp"
	        _displayText="<%=TrainResourceComInfo.getResourcename(resource)%>"> 	       
          </td>
        </TR> 
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(6102,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15781,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
          <td class=Field>
            <BUTTON class=Calendar type=button id=selecttestdate onclick="getDate(testdatespan,testdate)"></BUTTON>
            <SPAN id=testdatespan ></SPAN>
            <input class=inputstyle type="hidden" id="testdate" name="testdate">
          </td>
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    </TBODY>
    </TABLE>
  <input class=inputstyle type="hidden" name=operation>
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
			sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
		spanname.innerHtml = sHtml
	else
    	spanname.innerHtml = ""
    	inputname.value="0"
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

</script>
<script language=javascript>
function dosave(){
  if(check_form(document.frmMain,'name')&&checkDateValidity(frmMain.startdate.value,frmMain.enddate.value)){
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
 </script>
 </BODY>
 <SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
 </HTML>