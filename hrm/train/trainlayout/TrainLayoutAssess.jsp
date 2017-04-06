<%@ page import="weaver.general.Util,
                 java.text.SimpleDateFormat" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainLayoutComInfo" class="weaver.hrm.train.TrainLayoutComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String id = request.getParameter("id");
int userid = user.getUID();

String currentDate ="";
SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
currentDate = format.format(Calendar.getInstance().getTime()) ;

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(6101,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6102,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<%
/**
 * Add by Charoes Huang For
 */
boolean isAssessor = TrainLayoutComInfo.isAssessor(userid,id);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(isAssessor){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(),_self} " ;
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
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=weaver name=frmMain action="TrainLayoutOperation.jsp" method=post >
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="20%">
  <COL width="10%">
  <COL width="15%">
  <COL width="25%">
  <COL width="30%">
  <TBODY>
    <TR class=Header>
    <TH colSpan=5><%=SystemEnv.getHtmlLabelName(15693,user.getLanguage())%></TH></TR>
    <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(15696,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15695,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(16158,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(16159,user.getLanguage())%></TD>
  </TR>
  <TR class=Line><TD colspan="5" ></TD></TR>
<% 
String sql = "select * from HrmTrainLayoutAssess where layoutid="+id ;
rs.executeSql(sql); 
int needchange = 0; 

while(rs.next()){ 
  String assessdate=Util.null2String(rs.getString("assessdate"));
  String implement = rs.getString("implement"); 
  String explain =  Util.null2String(rs.getString("explain")); 
  String advice =  Util.null2String(rs.getString("advice")) ;
  String assessorid = rs.getString("assessorid");
try{
  if(needchange ==0){ 
  needchange = 1; 
%> 
  <TR class=datalight> 
<% 
}else{ needchange=0; 
%>
  <TR class=datadark> 
<%
} 
%> 
   <TD><%=assessdate%></TD>
   <TD><A href="/hrm/resource/HrmResource.jsp?id=<%=assessorid%>"><%=ResourceComInfo.getResourcename(assessorid)%></A></TD>
   <TD>
     <%if(implement.equals("0")){%><%=SystemEnv.getHtmlLabelName(16132,user.getLanguage())%> <%}%>
     <%if(implement.equals("1")){%><%=SystemEnv.getHtmlLabelName(16160,user.getLanguage())%> <%}%>
     <%if(implement.equals("2")){%><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%> <%}%>
     <%if(implement.equals("3")){%><%=SystemEnv.getHtmlLabelName(15660,user.getLanguage())%> <%}%>
     <%if(implement.equals("4")){%><%=SystemEnv.getHtmlLabelName(15661,user.getLanguage())%> <%}%>     
     
   </TD>    
   <TD><%=explain%></TD> 
   <TD><%=advice%></TD> 
  </TR>
  
<% 
  }catch(Exception e){ 
  System.out.println(e.toString()); }  
 } 
%>

</TBODY>
</TABLE>

<%if(isAssessor){%>
    <table class=viewForm>
      <TBODY>
      <COLGROUP>
      <COL width="20%">
      <COL width="80%">
      <TR class=title>
        <TH colSpan=3><%=SystemEnv.getHtmlLabelName(16161,user.getLanguage())%></TH>
      </TR>
        <TR class=spacing>
        <TD class=line1 colSpan=2 ></TD>
      </TR>
      <tr >
        <td><%=SystemEnv.getHtmlLabelName(16158,user.getLanguage())%></td>
        <td class=field>
        <select class=inputstyle name=implement value="2">
         <option value="0"><%=SystemEnv.getHtmlLabelName(16132,user.getLanguage())%></option>
         <option value="1"><%=SystemEnv.getHtmlLabelName(16160,user.getLanguage())%></option>
         <option value="2" selected><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></option>
         <option value="3"><%=SystemEnv.getHtmlLabelName(15660,user.getLanguage())%></option>
         <option value="4"><%=SystemEnv.getHtmlLabelName(15661,user.getLanguage())%></option>
        </select>
        </td>
      </tr>
      <TR><TD class=Line colSpan=2></TD></TR>
      <tr>
        <td><%=SystemEnv.getHtmlLabelName(15696,user.getLanguage())%></td>
        <td class=field>
           <!-- <% //COMMENTED BY Charoes Huang%>
          <BUTTON class=Calendar id=selectassessdate onclick="getDate(assessdatespan,assessdate)"></BUTTON>
          -->
          <SPAN id=assessdatespan ><%=currentDate%></SPAN>
          <input class=inputstyle type="hidden" id="assessdate" name="assessdate" value="<%=currentDate%>" >
        </td>
      </tr>
      <TR><TD class=Line colSpan=2></TD></TR>
      <tr>
        <td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
        <td class=field>
          <textarea class=inputstyle cols=50 rows=4 name=explain></textarea>
        </td>
      </tr>
      <TR><TD class=Line colSpan=2></TD></TR>
      <tr>
        <td><%=SystemEnv.getHtmlLabelName(16159,user.getLanguage())%></td>
        <td class=field>
          <textarea class=inputstyle cols=50 rows=4 name=advice></textarea>
        </td>
      </tr>
    <TR><TD class=Line colSpan=2></TD></TR>   </tbody>
    </table>
<%}%>
<input class=inputstyle type=hidden name=operation>
<input class=inputstyle type=hidden name=id value="<%=id%>">
</form>
<script language=vbs>
sub getDate(spanname,inputname)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	spanname.innerHtml= returndate
	inputname.value=returndate
end sub
</script> 
<script language=javascript>
  function dosave(){
    document.frmMain.operation.value="addAssess";
    document.frmMain.submit();
  }  
</script>
</BODY>
 <SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
