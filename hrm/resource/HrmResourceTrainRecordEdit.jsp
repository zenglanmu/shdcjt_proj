<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page"/>
<jsp:useBean id="TrainComInfo" class="weaver.hrm.train.TrainComInfo" scope="page" />
<jsp:useBean id="TrainResourceComInfo" class="weaver.hrm.train.TrainResourceComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
char separator = Util.getSeparator() ;
boolean canedit = HrmUserVarify.checkUserRight("HrmResourceTrainRecordEdit:Edit", user) ;
String paraid = Util.null2String(request.getParameter("paraid")) ;//培训记录ID
String id = Util.null2String(request.getParameter("resourceid")) ;//培训人员ID
String trainrecordid = paraid ;
String traintypeid = Util.null2String(request.getParameter("traintypeid")) ;//培训内容ID

RecordSet.executeProc("HrmTrainRecord_SelectByID",trainrecordid);
RecordSet.next();

String resourceid = Util.null2String(RecordSet.getString("resourceid"));
String trainstartdate = Util.toScreen(RecordSet.getString("trainstartdate"),user.getLanguage());
String trainenddate = Util.toScreen(RecordSet.getString("trainenddate"),user.getLanguage());
String traintype = Util.null2String(RecordSet.getString("traintype"));
int trainrecord = Util.getIntValue(RecordSet.getString("trainrecord"));
int trainhour = (int)RecordSet.getFloat("trainhour");
String trainunit = Util.toScreenToEdit(RecordSet.getString("trainunit"),user.getLanguage());

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(816,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/resource/HrmResourceTrainRecord.jsp?resourceid="+id+",_self} " ;
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
<FORM name=frmain action=HrmResourceTrainRecordOperation.jsp? method=post>
<input class=inputstyle type="hidden" name="operation">
<input class=inputstyle type="hidden" name="resourceid" value="<%=resourceid%>">
<input class=inputstyle type="hidden" name="trainrecordid" value="<%=trainrecordid%>">

  <TABLE class=viewForm>
    <COLGROUP> 
    <COL width="15%"> 
    <COL width="85%">
    <TBODY> 
    <TR class=title> 
      <TH colSpan=5><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%> <a href="HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></a></TH>
    </TR>
    <TR class=spacing style="height:2px"> 
      <TD class=line1 colSpan=2></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
      <td class=Field>         
        <%=trainstartdate%>        
      </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
      <td class=Field> 
        <%=trainenddate%>        
      </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(6136,user.getLanguage())%></TD>
      <TD class=Field> 
        <%=Util.toScreen(TrainComInfo.getTrainname(traintype),user.getLanguage())%>         
      </TD>
    </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <TR> 
      <td ><%=SystemEnv.getHtmlLabelName(15920,user.getLanguage())%></td>
      <td class=Field >         
        <%if(trainhour==0){%><%=SystemEnv.getHtmlLabelName(16130,user.getLanguage())%> <%}%>
        <%if(trainhour==1){%> <%=SystemEnv.getHtmlLabelName(16131,user.getLanguage())%>  <%}%>
        <%if(trainhour==2){%><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%>   <%}%>
        <%if(trainhour==3){%><%=SystemEnv.getHtmlLabelName(824,user.getLanguage())%>   <%}%>
      </td>
    </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <TR>
      <td><%=SystemEnv.getHtmlLabelName(15879,user.getLanguage())%></td>
      <td class=Field>         
        <%=TrainResourceComInfo.getResourcename(trainunit)%>
      </td>
    </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <TR> 
      <TD ><%=SystemEnv.getHtmlLabelName(15738,user.getLanguage())%></TD>
      <TD class=Field>        
        <%if(trainrecord==0){%><%=SystemEnv.getHtmlLabelName(15661,user.getLanguage())%> <%}%>
       <%if(trainrecord==1){%> <%=SystemEnv.getHtmlLabelName(15660,user.getLanguage())%>  <%}%>
       <%if(trainrecord==2){%><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>   <%}%>
       <%if(trainrecord==3){%><%=SystemEnv.getHtmlLabelName(15700,user.getLanguage())%>   <%}%>
       <%if(trainrecord==4){%><%=SystemEnv.getHtmlLabelName(16132,user.getLanguage())%>   <%}%>
      </TD>
    </TR>
    </TBODY> 
  </TABLE>
<table class=ListStyle cellspacing=1 >
  <COLGROUP> 
    <COL width="15%">
    <COL width="70%">
    <COL width="15%">
  <tbody>
  <TR class=Header> 
      <TH align=left colSpan=3><%=SystemEnv.getHtmlLabelName(16133,user.getLanguage())%></TH>
    </TR>
    <tr class=header>
    <th><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></th>    
    <th><%=SystemEnv.getHtmlLabelName(16134,user.getLanguage())%></th>   
    <th><%=SystemEnv.getHtmlLabelName(2187,user.getLanguage())%></th>     
  </tr> 
   
<%
  int line = 0;
  String sql = "select * from HrmTrainDay where trainid="+traintypeid+" order by id asc";//trainid:培训活动id
  RecordSet.executeSql(sql);
  while(RecordSet.next()){
    String dayid = RecordSet.getString("id");
    String data = RecordSet.getString("traindate");
    String content = RecordSet.getString("daytraincontent");
    sql = "select isattend from HrmTrainActor where traindayid="+dayid+" and resourceid = "+id;//isattend:是否参与
    rs.executeSql(sql);
    rs.next();
    int isattend = Util.getIntValue(rs.getString("isattend"));
    if(line%2 ==0){
%>
   <tr class=datalight>
<%    
    }else{
%>
   <tr class=datadark>
<%    
    }
%>
   <td><%=data%></td>
   <td><%=content%></td>
   <td> 
     <%if(isattend==1){%><%=SystemEnv.getHtmlLabelName(2195,user.getLanguage())%><%}%>
     <%if(isattend==0){%><%=SystemEnv.getHtmlLabelName(16135,user.getLanguage())%><%}%>
   </td>
<%    
  }
%>   
</tbody>
</table>
</FORM>
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
<SCRIPT language=VBS>
sub onShowTrainType()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/tools/TrainTypeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	traintypespan.innerHtml = id(1)
	frmain.traintype.value=id(0)
	else 
	traintypespan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	frmain.traintype.value="" 
	end if
	end if
end sub

</SCRIPT>

<SCRIPT language="javascript">
function OnSubmit(){
    if(check_form(document.frmain,"traintype"))
	{	
		document.frmain.operation.value="edit";
		document.frmain.submit();
	}
}
function onDelete(){
    if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
        document.frmain.operation.value="delete";
        document.frmain.submit();
		}
}
</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
