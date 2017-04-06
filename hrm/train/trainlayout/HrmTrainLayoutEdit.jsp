<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<jsp:useBean id="TrainLayoutComInfo" class="weaver.hrm.train.TrainLayoutComInfo" scope="page" />
<html>
<%
Calendar todaycal = Calendar.getInstance ();
  String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
                 	
String id = request.getParameter("id");	
int userid = user.getUID();
TrainLayoutComInfo tl = new TrainLayoutComInfo();

  String name = "";
  String typeid = "";
  String startdate="";
  String enddate = "";
  String content="";
  String aim = "";
  String testdate = "";
  String assessor = "";
int errormsg = 1;
  String sql = "select * from HrmTrainLayout where id = "+id;
  rs.executeSql(sql);
  while(rs.next()){
     errormsg = 0;
     name = Util.null2String(rs.getString("layoutname"));
     typeid = Util.null2String(rs.getString("typeid"));
     startdate = Util.null2String(rs.getString("layoutstartdate"));
     enddate = Util.null2String(rs.getString("layoutenddate"));
     content = Util.null2String(rs.getString("layoutcontent"));
     aim = Util.null2String(rs.getString("layoutaim"));
     testdate = Util.null2String(rs.getString("layouttestdate"));
     assessor = Util.null2String(rs.getString("layoutassessor"));
  }    
 boolean bl = tl.isAssessor(userid,id);
 /*
  //Commented by Charoes Huang On May 30 For Bug 277,all user has right to view train layout
if(!HrmUserVarify.checkUserRight("HrmTrainLayoutEdit:Edit", user)&&!bl){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
*/
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename =SystemEnv.getHtmlLabelName(89,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6128,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmTrainLayoutEdit:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmTrainLayoutEdit:Edit", user)&&today.equals(testdate)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(16149,user.getLanguage())+",javascript:doinfo(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//if(bl || HrmUserVarify.checkUserRight("HrmTrainLayoutEdit:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(6102,user.getLanguage())+",javascript:doassess(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//}
if(HrmUserVarify.checkUserRight("HrmTrainLayout:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+67+" and relatedid="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/trainlayout/HrmTrainLayout.jsp,_self} " ;
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

<FORM id=weaver name=frmMain action="TrainLayoutOperation.jsp" method=post >
<%if(errormsg == 1){%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getHtmlLabelName(16157,user.getLanguage())%>
</div>
<%}%>
<TABLE class=Viewform >
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6128,user.getLanguage())%></TH></TR>
  <TR class=spacing style="height:2px">
    <TD class=Line1 colSpan=2 ></TD>
  </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><%=name%></td>
        </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6130,user.getLanguage())%></TD>
          <TD class=Field>
            <%=TrainTypeComInfo.getTrainTypename(typeid)%>	    
          </TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
          <td class=Field>
            <%=startdate%>
          </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>          
          <td class=Field>
            <%=enddate%>
          </td>            
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>   
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></td>
          <td class=Field>
            <%=content%>
          </td>
        </tr> 
                <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 

        <tr>
          <td><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%> </td>
          <td class=Field>
            <%=aim%>
          </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(15696,user.getLanguage())%> </td>
          <td class=Field>
            <%=testdate%></SPAN>             
          </td>                      
        </tr>    
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(15695,user.getLanguage())%> </td>
          <td class=Field>
	      <%=ResourceComInfo.getMulResourcename(assessor)%>	      
	  </td>	   
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  
<input class=inputstyle type="hidden" name=operation>
<input class=inputstyle type=hidden name=id value="<%=id%>">
 </TBODY></TABLE>
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
			sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
		spanname.innerHtml = sHtml
	else	
    	spanname.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
    	inputname.value="0"
	end if
	end if
end sub

sub onShowType()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/train/traintype/TraintypeBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	typeidspan.innerHtml = id(1)
	frmMain.typeid.value=id(0)
	else
	typeidspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	frmMain.typeid.value=""
	end if
	end if
end sub
</script>
<script language=javascript>
  function dosave(){
    location="HrmTrainLayoutEditDo.jsp?id=<%=id%>";
  }
  function doinfo(){
    if(confirm("<%=SystemEnv.getHtmlLabelName(15782,user.getLanguage())%>")){
      document.frmMain.operation.value="info";
      document.frmMain.submit();
    }
  }
  function doassess(){    
     location="TrainLayoutAssess.jsp?id=<%=id%>";
  }  
</script>
 
</BODY>
 <SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
