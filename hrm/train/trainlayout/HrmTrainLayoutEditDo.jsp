<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<jsp:useBean id="TrainLayoutComInfo" class="weaver.hrm.train.TrainLayoutComInfo" scope="page" />
<html>
<%
if(!HrmUserVarify.checkUserRight("HrmTrainLayoutEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	
String id = request.getParameter("id");	
int userid = user.getUID();
TrainLayoutComInfo tl = new TrainLayoutComInfo();

/*Add by Huang Yu ,Check if trainLayout has been used by train plan*/
   boolean canDelete =true;
   if(!id.equals("")){
       String sqlstr ="Select count(ID) as Count FROM HrmTrainPlan WHERE layoutid = "+id;
       rs.executeSql(sqlstr);
       rs.next();
       if(rs.getInt("Count") > 0 ){
           canDelete = false;
       }
   }

  String name = "";
  String typeid = "";
  String startdate="";
  String enddate = "";
  String content="";
  String aim = "";
  String testdate = "";
  String assessor = "";

  String sql = "select * from HrmTrainLayout where id = "+id;
  rs.executeSql(sql);
  while(rs.next()){
     name = Util.null2String(rs.getString("layoutname"));
     typeid = Util.null2String(rs.getString("typeid"));
     startdate = Util.null2String(rs.getString("layoutstartdate"));
     enddate = Util.null2String(rs.getString("layoutenddate"));
     content = Util.toScreenToEdit(rs.getString("layoutcontent"),user.getLanguage());
     aim = Util.toScreenToEdit(rs.getString("layoutaim"),user.getLanguage());
     testdate = Util.null2String(rs.getString("layouttestdate"));
     assessor = Util.null2String(rs.getString("layoutassessor"));
  }
 
    
 boolean bl = tl.isAssessor(userid,id);
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename =SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6128,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmTrainLayoutEdit:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmTrainLayoutDelete:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:dodelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/trainlayout/HrmTrainLayoutEdit.jsp?id="+id+",_self} " ;
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

<FORM id=weaver name=frmMain action="TrainLayoutOperation.jsp" method=post >
<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6128,user.getLanguage())%></TH></TR>
  <TR class= Spacing  style="height:2px">
    <TD class=line1 colSpan=2 ></TD>
  </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=text size=30 name="layoutname" value="<%=name%>" onchange='checkinput("layoutname","layoutnameimage")'>
          <SPAN id=layoutnameimage></SPAN>
          </td>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6130,user.getLanguage())%></TD>
          <TD class=Field>
	    <INPUT class=wuiBrowser id=typeid type=hidden name=typeid value="<%=typeid%>" onchange='checkinput("typeid","typeidspan")'
	    _url="/systeminfo/BrowserMain.jsp?url=/hrm/train/traintype/TrainTypeBrowser.jsp" _required=yes
	    _displayText="<%=TrainTypeComInfo.getTrainTypename(typeid)%>">           
          </TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
          <td class=Field>
            <BUTTON class=Calendar type="button" id=selectlayoutstartdate onclick="getDate(layoutstartdatespan,layoutstartdate)"></BUTTON> 
            <SPAN id=layoutstartdatespan ><%=startdate%></SPAN> 
            <input class=inputstyle type="hidden" id="layoutstartdate" name="layoutstartdate" value="<%=startdate%>">            
          </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>          
          <td class=Field>
            <BUTTON class=Calendar type="button" id=selectlayoutenddate onclick="getDate(layoutenddatespan,layoutenddate)"></BUTTON> 
            <SPAN id=layoutenddatespan ><%=enddate%></SPAN> 
            <input class=inputstyle type="hidden" id="layoutenddate" name="layoutenddate" value="<%=enddate%>">            
          </td>            
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></td>
          <td class=Field>
            <textarea class=inputstyle cols=50 rows=4 name=layoutcontent value="<%=content%>"><%=content%></textarea>
          </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%> </td>
          <td class=Field>
            <textarea class=inputstyle cols=50 rows=4 name=layoutaim value="<%=aim%>"><%=aim%></textarea>          
          </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(15696,user.getLanguage())%> </td>
          <td class=Field>
            <BUTTON class=Calendar type="button" id=selectlayouttestdatedate onclick="getDate(layouttestdatespan,layouttestdate)"></BUTTON> 
            <SPAN id=layouttestdatespan ><%=testdate%></SPAN> 
            <input class=inputstyle type="hidden" id="layouttestdate" name="layouttestdate" value="<%=testdate%>">            
          </td>                      
        </tr>       
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(15695,user.getLanguage())%> </td>
          <td class=Field>
	      <INPUT class=wuiBrowser id=layoutassessor type=hidden name=layoutassessor value="<%=assessor%>"
	      _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" _required=yes
	      _diaplayTemplate="<a href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</a>&nbsp;"
	      _displayText="<%=ResourceComInfo.getMulResourcename(assessor)%>">
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
    	spanname.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
    	inputname.value="0"
	end if
	end if
end sub

sub onShowType()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/train/traintype/TrainTypeBrowser.jsp")
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
    if(check_formM(document.frmMain,'layoutname,typeid,layoutassessor')&&checkDateRange(frmMain.layoutstartdate,frmMain.layoutenddate,"<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>")){
    document.frmMain.operation.value="edit";
    document.frmMain.submit();
    }
  }
   function check_formM(thiswins,items){
	thiswin = thiswins
	items = ","+items + ",";
	
	for(i=1;i<=thiswin.length;i++)
	{
	tmpname = thiswin.elements[i-1].name;
	tmpvalue = thiswin.elements[i-1].value;
	if(tmpname=="layoutassessor"){
		if(tmpvalue == 0){
			alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>"); 
			return false;
		}
	}
    if(tmpvalue==null){
        continue;
    }
	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	
	if(tmpname!="" &&items.indexOf(","+tmpname+",")!=-1 && tmpvalue == ""){
		 alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
		 return false;
		}

	}
	return true;
}
  function dodelete(){
     <%if(canDelete) {%>
    if(confirm("<%=SystemEnv.getHtmlLabelName(17048,user.getLanguage())%>")){
      document.frmMain.operation.value = "delete";
      document.frmMain.submit();
    }
	<%}else{%>
			alert("<%=SystemEnv.getHtmlLabelName(17049,user.getLanguage())%>");
		<%}%>
  }
  function doassess(){    
     location="TrainLayoutAssess.jsp?id=<%=id%>";
  }  
</script>
<%@include file="/hrm/include.jsp"%>
</BODY>
 <SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
