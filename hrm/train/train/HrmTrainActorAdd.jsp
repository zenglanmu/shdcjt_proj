<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo" %>
<%@ page import='java.util.*'%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />
<jsp:useBean id="TrainResourceComInfo" class="weaver.hrm.train.TrainResourceComInfo" scope="page" />
<%
/*if(!HrmUserVarify.checkUserRight("HrmTrainEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}*/
%>	
<html>
<%	
String trainid = request.getParameter("trainid");

/**
 * Added By Charoes Huang on May 18,2004
 * Get the startDate and endDate of the HrmTrain
  */
String sqlstr ="";
String startDate ="";
String endDate ="";
if(!trainid.equals("")){
    sqlstr = "Select startdate,enddate from HrmTrain WHERE id="+trainid;
    rs.executeSql(sqlstr);
    rs.next();
    startDate = rs.getString("startdate");
    endDate = rs.getString("enddate");
}

// TD 24259 add by yangdacheng 20111216
String sql ="";

ArrayList trainAct= new ArrayList();
if(!trainid.equals(""))
{
	sql = "select traindate from  HrmTrainDay where trainid = '"+trainid+"'";
	rs.execute(sql);
	while(rs.next())
	{
		trainAct.add(rs.getString("traindate"));
	}
	
}



%>
<HTML>
<HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(678,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(1867,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/train/HrmTrainEdit.jsp?id="+trainid+",_self} " ;
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

<FORM id=weaver name=frmMain action="TrainOtherOperation.jsp" method=post >

<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6128,user.getLanguage())%></TH></TR>
  <TR class=Spacing>
    <TD class=Line1 colSpan=2 ></TD>
  </TR>               
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(16140,user.getLanguage())%> </td>
          <td class=Field>
	      <BUTTON class=Browser onClick="onShowResource(actor,actorspan)">
	      </BUTTON> 
	      <span class=inputstyle id=actorspan>
	      </span> 
	      <INPUT class=inputstyle id=actor type=hidden name=actor>
	      </td>	   
        </tr> 
        <TR><TD class=Line colSpan=2></TD></TR> 
           <tr>
          <td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
          <td class=Field>
            <BUTTON class=Calendar id=selectstartdate onclick="getDate(startspan,startdate_)"></BUTTON> 
            <SPAN id=startspan ><IMG src="/images/BacoError.gif" align=absMiddle></SPAN> 
            <input class=inputstyle type="hidden" id="startdate_" name="startdate_" onchange="checkinput(startdate_,startspan)">            
          </td>
        </tr>    
        <TR><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
          <td class=Field>
            <BUTTON class=Calendar id=selectenddate onclick="getDate(endspan,enddate_)"></BUTTON> 
            <SPAN id=endspan ><IMG src="/images/BacoError.gif" align=absMiddle></SPAN> 
            <input class=inputstyle type="hidden" id="enddate_" name="enddate_" onchange="checkinput(enddate_,endspan)">            
          </td>
        </tr>    
        <TR><TD class=Line colSpan=2></TD></TR>
  </TBODY>
</TABLE> 
<input class=inputstyle type="hidden" name=operation> 
<input class=inputstyle type=hidden name=trainid value=<%=trainid%>>
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


 
<script language=javascript>

function onShowResource(inputname,spanname){
	 var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp");
	 if((id.id!="")){
	  var resourceids = id.id;
	  var resourcename = id.name;
	  var sHtml = "";
	  var ids=resourceids.split(",");
	  var names=resourcename.split(",");
	  inputname.value= resourceids.substring(1,resourceids.length);
	 for(var i=1;i<ids.length;i++){
	   sHtml += "<a href='javascript:window.showModalDialog(\"../../../hrm/resource/HrmResourceBase.jsp?id="+ids[i]+"\");'>"+names[i]+"</a>&nbsp;";
	  }
	  spanname.innerHTML = sHtml;
	 }else{
		 spanname.innerHTML = "<IMG src=\"/images/BacoError.gif\" align=absMiddle>";
	     inputname.value="0";
	}
}

function dosave(){
  if(check_form(document.frmMain,"startdate_","enddate_")&&checkDateValidity()){
    document.frmMain.operation.value="addactor";
    document.frmMain.submit();
  }
}

/* 
* TD 24259 add by yangdacheng 20111216
*/


function checkDateValidity(){
    var isValid = false;
    var startdate_ = frmMain.startdate_.value;
    var enddate_ = frmMain.enddate_.value;
    var startDate ="<%=startDate%>";
    var endDate ="<%=endDate%>";
    var trainDate ="";
    
    var my_array = new Array();
    <%
    for(int i = 0; i<trainAct.size(); i++)
    {
    %>
    	my_array[<%=i%>] = '<%=Util.null2String((String)trainAct.get(i))%>';
    <%
    }
    %>
   	if(compareDate(startdate_,enddate_,startDate,endDate)&&compareDate2(my_array,startdate_,enddate_))
   	{
   		isValid = true;
   	}
    
 
    return isValid;
}




function compareDate(pstartdate,penddate,started,endend){

	var ischeck = false;
    var startDate ="<%=startDate%>";
    var endDate ="<%=endDate%>";
    

    if(pstartdate>penddate){
    alert("<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>");
     
     }
	else if(started<=pstartdate&&penddate<=endend)

	{
		ischeck = true;
	}
	else
	{
		alert("开始日期必须在"+startDate+"和"+endDate+"之间");
	}

    return ischeck;
}

function compareDate2(obj,startdate,endend){

	var ischeck = false;
	for(var i=0;i<obj.length; i++)
	{
		var date1=obj[i];
		if(date1>=startdate&&date1<=endend)
		{
			ischeck = true;
			break;
		}
	}
	if(!ischeck)
	{
		alert("<%=SystemEnv.getHtmlLabelName(27623,user.getLanguage())%>");
	}
    return ischeck;
}

 </script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
