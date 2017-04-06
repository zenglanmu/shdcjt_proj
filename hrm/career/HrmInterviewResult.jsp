<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CareerApplyComInfo" class="weaver.hrm.career.HrmCareerApplyComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String id = Util.null2String(request.getParameter("id"));
String planid = Util.null2String(request.getParameter("planid"));
int result = Util.getIntValue(request.getParameter("result"));

String sql = "select lastname from HrmCareerApply where id ="+id;
rs.executeSql(sql);
rs.next();
String name = Util.null2String(rs.getString("lastname"));

String step = CareerApplyComInfo.getStep(id);
String stepname = CareerApplyComInfo.getStepname(id);


String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(6134,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(356,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
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
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
  <FORM name=resource id=resource action="HrmInterviewManageOperation.jsp" method=post>    
    <input class=inputstyle type=hidden name=planid value="<%=planid%>">
      <TABLE class=viewForm>
      <COLGROUP> 
      <COL width="49%"> 
      <COL width=10> 
      <COL width="49%"> 
      <TBODY>
      <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> 
          <COL width=30%> 
          <COL width=70%> 
          <TBODY> 
          <TR class=title> 
            <TH colSpan=2 height="19"><%=SystemEnv.getHtmlLabelName(15729,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=2></TD>
          </TR>   
          
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15730,user.getLanguage())%></TD>
            <TD class=Field>
              <%=name%>
              <input class=inputstyle type=hidden name=resourceid value=<%=id%>>              
            </TD>
          </TR>
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(15731,user.getLanguage())%></td>
            <td class=Field>
              <%=stepname%>       
              <input class=inputstyle type=hidden name=step value=<%=step%>>
            </td>
          </TR>   
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(15737,user.getLanguage())%></td>
            <td class=Field>                               
                <%if(result==0){%><%=SystemEnv.getHtmlLabelName(15690,user.getLanguage())%> <%}%>
                <%if(result==1){%><%=SystemEnv.getHtmlLabelName(15376,user.getLanguage())%> <%}%>
                <%if(result==2){%><%=SystemEnv.getHtmlLabelName(15689,user.getLanguage())%><%}%>                
            </td>
          </TR>   
          <TR><TD class=Line colSpan=2></TD></TR> 
          <TR>
            <td><%=SystemEnv.getHtmlLabelName(15698,user.getLanguage())%></td>
            <td class=Field>
              <textarea class=inputstyle rows=5 cols=40 name="remark" ></textarea>
            </td>
          </TR>   
          <TR><TD class=Line colSpan=2></TD></TR> 
      </tbody>
    </table>
    <br>
    <table class=liststyle cellspacing=1>
      <tbody>
      <TR class=header>
        <TH colSpan=4><%=SystemEnv.getHtmlLabelName(15738,user.getLanguage())%></TH>
      </TR>
         <tr class=header>
        <td><%=SystemEnv.getHtmlLabelName(15739,user.getLanguage())%></td>
        <td><%=SystemEnv.getHtmlLabelName(15696,user.getLanguage())%></td>
        <td><%=SystemEnv.getHtmlLabelName(15697,user.getLanguage())%></td>
        <td><%=SystemEnv.getHtmlLabelName(15698,user.getLanguage())%></td>
      </tr>
      <TR class=Line><TD colspan="4" ></TD></TR> 
<%
  int line = 0;
  sql = "select * from HrmInterviewAssess where resourceid="+id +" and stepid = "+step;
  rs.executeSql(sql);
  while(rs.next()){
    String assessor = Util.null2String(rs.getString("assessor"));
    String assessdate = Util.null2String(rs.getString("assessdate"));
    int assessresult = Util.getIntValue(rs.getString("result"),0);
    String assessremark = Util.null2String(rs.getString("remark"));
    if(line%2==0){
      line++;
%>
   <tr class=datalight>
<%      
    }else{
      line++;
%>
   <tr class=datadark>
<%    
    }
%>
     <td><%=ResourceComInfo.getResourcename(assessor)%></td>
     <td><%=assessdate%></td>
     <td>
       <%if(assessresult==0){%><%=SystemEnv.getHtmlLabelName(15699,user.getLanguage())%><%}%>
       <%if(assessresult==1){%><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%><%}%>
       <%if(assessresult==2){%><%=SystemEnv.getHtmlLabelName(15700,user.getLanguage())%><%}%>
     </td>
     <td><%=assessremark%></td>
   </tr>  
<%    
  }
%>      
      </tbody>
    </table>
<input class=inputstyle type=hidden name=operation>    
</FORM>
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
<script language=vbs>  
sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?status=1 ")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	resource.resourceid.value=id(0)
	else 
	resourceidspan.innerHtml = ""
	resource.resourceid.value=""
	end if
	end if
end sub

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

</script>
<script language=javascript>
function doSave() {
   if(<%=result%>==0){
     if(confirm("<%=SystemEnv.getHtmlLabelName(15740,user.getLanguage())%>")){
       document.resource.operation.value="delete";
       document.resource.submit() ;
     }
   }
   if(<%=result%>==1){
     if(confirm("<%=SystemEnv.getHtmlLabelName(15741,user.getLanguage())%>")){
       document.resource.operation.value="pass";
       document.resource.submit() ;
     }
   }
   if(<%=result%>==2){
     if(confirm("<%=SystemEnv.getHtmlLabelName(15742,user.getLanguage())%>")){
       document.resource.operation.value="backup";
       document.resource.submit() ;
     }
   }
}
function doBack() {
   if("<%=planid%>"==""){
     location="HrmCareerApplyEdit.jsp?applyid=<%=id%>";
   }else{
     location="HrmCareerApplyList.jsp?id=<%=planid%>";
   }
}
</script>
</body>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>