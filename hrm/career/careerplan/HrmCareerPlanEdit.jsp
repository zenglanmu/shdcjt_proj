<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="MailMouldComInfo" class="weaver.docs.mail.MailMouldComInfo" scope="page" />
<jsp:useBean id="CareerPlanComInfo" class="weaver.hrm.career.CareerPlanComInfo" scope="page" />
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%!


%>
<%
boolean isoracle = rs.getDBType().equals("oracle") ;
String id = request.getParameter("id");

boolean isFin = CareerPlanComInfo.isFinish(id);
boolean canDelete = CareerPlanComInfo.canDelete(id);

String topic = "";
String principalid = "";
String informmanid = "";
String startdate = "";
String budgettype = "";
String budget = "";
String emailmould = "";
String memo = "";

String sql = "select * from HrmCareerPlan where id ="+id;
rs.executeSql(sql); 
while(rs.next()){
  topic = Util.null2String(rs.getString("topic"));
  principalid = Util.null2String(rs.getString("principalid"));
  budgettype = Util.null2String(rs.getString("budgettype"));
  informmanid = Util.null2String(rs.getString("informmanid"));  
  startdate = Util.null2String(rs.getString("startdate"));
  budget = Util.null2String(rs.getString("budget"));
  emailmould = Util.null2String(rs.getString("emailmould"));
  memo = Util.null2String(rs.getString("memo"));
}

boolean haseditright = false ;
boolean haseditdetailright = false;


if( HrmUserVarify.checkUserRight("HrmCareerPlanEdit:Edit", user) || principalid.equals(""+user.getUID())) {
    haseditright = true ;
    haseditdetailright = true;
}

boolean isAssessor = false;
boolean isPrincipal = false;
boolean isInformman = false;

if(principalid.equals(""+user.getUID()))
    isPrincipal = true;
if(informmanid.equals(""+user.getUID()))
    isInformman = true;
 /**
  * Added By Huang Yu
  * 如果没有查看权限则 看是否试招聘信息的审核人
  */
if(!haseditright){
    String sqlStr ="";
    sqlStr = "";
     if(isoracle) {
         sqlStr = "SELECT DISTINCT t1.id,t1.topic,t1.principalid,t1.informmanid,t1.startdate  From HrmCareerPlan t1 , HrmCareerInvite t2  , HrmCareerInviteStep t3 WHERE t1.ID = t2.CareerPlanID(+) and t2.ID = t3.InviteID(+) and (t1.enddate = '' or t1.enddate is null) and t1.id = "+id+"and (t1.principalid = "+user.getUID()+" or t1.informmanid = "+user.getUID()+" or t3.assessor = "+user.getUID()+")";
     }
     else{
         sqlStr ="SELECT DISTINCT t1.id,t1.topic,t1.principalid,t1.informmanid,t1.startdate  From HrmCareerPlan t1 LEFT JOIN HrmCareerInvite t2 ON (t1.ID = t2.CareerPlanID) LEFT JOIN HrmCareerInviteStep t3 ON (t2.ID = t3.InviteID) WHERE (t1.enddate = '' or t1.enddate is null) and t1.id ="+id+" and (t1.principalid = "+user.getUID()+" or t1.informmanid = "+user.getUID()+" or t3.assessor = "+user.getUID()+")";
     }
    rs.executeSql(sqlStr);
    if(rs.getCounts() >0){
        isAssessor = true ;
        haseditright = true ;
    }
}
if(!haseditright){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
boolean canEdit = false;
    canEdit =  HrmUserVarify.checkUserRight("HrmCareerPlanEdit:Edit", user);
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(6132,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(89,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(!isFin && (canEdit || isPrincipal)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:doedit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(principalid.equals(""+user.getUID())) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(6133,user.getLanguage())+",/hrm/career/HrmCareerApplyList.jsp?id="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(!isFin && (canEdit || isPrincipal)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(405,user.getLanguage())+",javascript:doclose(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
/**
 * Modified By Charoes Huang On May 19 ,2004, 非负责人不能查看日志信息
 */
if(isPrincipal){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+70+" and relatedid="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if( (canEdit || isPrincipal)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/career/careerplan/HrmCareerPlan.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{-}" ;	
if((canEdit || isPrincipal)&&!isFin){
RCMenu += "{"+SystemEnv.getHtmlLabelName(17153,user.getLanguage())+",/hrm/career/HrmCareerInviteAdd.jsp?plan="+id+"&isplan="+1+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//招聘管理菜单
if(!principalid.equals(""+user.getUID())&&(HrmUserVarify.checkUserRight("HrmCareerPlanAdd:Add", user) || isPrincipal)|| isAssessor){
RCMenu += "{"+SystemEnv.getHtmlLabelName(6133,user.getLanguage())+",/hrm/career/HrmCareerApplyList.jsp?id="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if((canEdit || isPrincipal) && !isFin){
RCMenu += "{"+SystemEnv.getHtmlLabelName(15781,user.getLanguage())+SystemEnv.getHtmlLabelName(15761,user.getLanguage())+",javascript:doInform(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
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
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6132,user.getLanguage())%></TH></TR>
  <TR class= Spacing style="height:2px">
    <TD class=Line1 colSpan=2 ></TD>
  </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
          <TD class=Field>
            <%=topic%>
          </td>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
          <TD class=Field>            
               <%=ResourceComInfo.getResourcename(principalid)%> 
          </td>
        </TR>    
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(15669,user.getLanguage())%></td>
          <td class=Field >                         
               <%=ResourceComInfo.getResourcename(informmanid)%>               
          </td>
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <!--  去掉 并没有什么用处
        <tr>
          <td>通知邮件模板</td>
          <td class=Field>            
              <%=MailMouldComInfo.getMailMouldname(emailmould)%>              
          </td>
        </tr>
        -->
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(15744,user.getLanguage())%></td>
          <td class=Field>
            <%=startdate%>
          </td>
        </tr> 
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<!--               
        <TR>
          <TD>预算</TD>
          <TD class=Field>
            <%=budget%>
          </TD>
        </TR>
        <TR>
          <TD>预算类型</TD>
          <TD class=Field>
            <%=BudgetfeeTypeComInfo.getBudgetfeeTypename(budgettype)%>	    
          </TD>
        </TR>           
-->        
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
          <td class=Field>
            <%=memo%>
          </td>
        </tr>     
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    </TBODY>
    </TABLE>
      <br>
       <TABLE width="100%"  class=ListStyle cellspacing=1  cols=4 id="oTable">
	   <TBODY> 
          <TR class=Header> 
            <TH colspan=4><%=SystemEnv.getHtmlLabelName(15745,user.getLanguage())%></TH>
	     <tr class=header>       
	    <td ><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
	    <td ><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
	    <td ><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
          </tr> 

<%
  int rowindex = 0;
  sql = "select * from HrmCareerPlanStep where planid = "+id+" order by id";
  rs.executeSql(sql);
  while(rs.next()){
        String stepstartdate = Util.null2String(rs.getString("stepstartdate"));
	String stependdate = Util.null2String(rs.getString("stependdate"));
	String stepname = Util.null2String(rs.getString("stepname"));			
%>
	      <tr class=datadark>            
	        <TD class=Field> 
             <%=stepname%>
            </TD>	        
	        <TD class=Field width=150> 
             <%=stepstartdate%>
            </TD>
	        <TD class=Field width=150> 
             <%=stependdate%>
            </TD>            	        
	      </tr> 
<%
	rowindex++;
  }

%>        
      </tbody>
</table>
  <br>
<TABLE class=ListStyle cellspacing=1 >
  <TBODY>
  <TR class=Header>
    <Th><%=SystemEnv.getHtmlLabelName(366,user .getLanguage())%></Th>
    <td align=right>
    </td>  
  </TR>
  </TBODY>
  </TABLE>

<TABLE class=ListStyle cellspacing=1 >
  <THEAD>
  <COLGROUP>
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <COL width="10%">
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(1860,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(1861,user.getLanguage())%></TH>
	<TH><%=SystemEnv.getHtmlLabelName(1862,user.getLanguage())%></TH>
	<TH></TH>
	</TR>

    </THEAD>
<%
int i= 0;
String sqlstr = "";
    /**
     * Add BY HUang Yu
     * 如果 不是 负责人通知人，则只显示和他相关的招聘信息
     */
if(isPrincipal || isInformman|| HrmUserVarify.checkUserRight("HrmCareerPlanEdit:Edit", user)  ){
    sqlstr  ="select id,careername,careerpeople,careersex,careeredu,createrid,createdate from HrmCareerInvite where careerplanid = "+id;
}else{
    sqlstr ="select DISTINCT t1.id,careername,careerpeople,careersex,careeredu,createrid,createdate from HrmCareerInvite t1 ,HrmCareerInviteStep t2 WHERE t1.ID = t2.Inviteid and t2.assessor = "+user.getUID()+" and t1.careerplanid = "+id;
}

rs.executeSql(sqlstr);
while(rs.next()) {
	String inviteid = rs.getString("id") ;	
	String careername = Util.toScreen(rs.getString("careername"),user.getLanguage()) ;
	String careerpeople = Util.null2String(rs.getString("careerpeople")) ;
	String careersex = Util.null2String(rs.getString("careersex")) ; 
	String careeredu = Util.null2String(rs.getString("careeredu")) ;
	String createrid = Util.null2String(rs.getString("createrid")) ;
	String createdate = Util.null2String(rs.getString("createdate"));
	String careersexstr="";
	String careeredustr="";
	if (careersex.equals("0")) careersexstr = SystemEnv.getHtmlLabelName(417,user.getLanguage());
	else if	(careersex.equals("1")) careersexstr = SystemEnv.getHtmlLabelName(418,user.getLanguage());
	else if (careersex.equals("2")) careersexstr = SystemEnv.getHtmlLabelName(763,user.getLanguage());
	if (careeredu.equals("0")) careeredustr = SystemEnv.getHtmlLabelName(764,user.getLanguage());
	else if	(careeredu.equals("1")) careeredustr = SystemEnv.getHtmlLabelName(765,user.getLanguage());
	else if (careeredu.equals("2")) careeredustr = SystemEnv.getHtmlLabelName(766,user.getLanguage());
	else if (careeredu.equals("3")) careeredustr = SystemEnv.getHtmlLabelName(767,user.getLanguage());
	else if (careeredu.equals("4")) careeredustr = SystemEnv.getHtmlLabelName(768,user.getLanguage());
	else if (careeredu.equals("5")) careeredustr = SystemEnv.getHtmlLabelName(769,user.getLanguage());	
	else if (careeredu.equals("6")) careeredustr = SystemEnv.getHtmlLabelName(763,user.getLanguage());	

if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
    <TD><a href='/hrm/career/HrmCareerApplyViewDetail.jsp?paraid=<%=inviteid%>&isplan=1&plan=<%=id%>'><%=Util.add0(Util.getIntValue(inviteid),12)%></a></TD>
	<TD><%=JobTitlesComInfo.getJobTitlesname(careername)%></TD>
	<TD><%=careerpeople%></TD>
	<TD><%=careersexstr%></TD>
	<TD><%=careeredustr%></TD>
	<TD><%=Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage())%></TD>
	<TD><%=createdate%></TD>
	<TD>
        <%if(haseditdetailright){%>
        <A HREF="/hrm/career/HrmCareerInviteEdit.jsp?paraid=<%=inviteid%>&isplan=1">
            <%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></A>
       <%}%>
    </TD>
    </TR>
<%}%>
  </TABLE>

<input  class=inputstyle type="hidden" name=operation>
<input class=inputstyle type=hidden name=id value="<%=id%>">
<input class=inputstyle type=hidden name=oldprincipalid value="<%=principalid%>">
<input class=inputstyle type=hidden name=oldinformmanid value="<%=informmanid%>">
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
	inputspan.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else
	inputspan.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub
</script>
 <script language=javascript>
 function doInform(obj){
    if(confirm("<%=SystemEnv.getHtmlLabelName(15782,user.getLanguage())%>")){
        obj.disabled = true;
        document.location = "CareerPlanInformOperation.jsp?CareerPlanID=<%=id%>";
    }
 }
 function doedit(){
   location="HrmCareerPlanEditDo.jsp?id=<%=id%>";
 }
 function dodelete(){
   if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
     document.frmMain.operation.value="delete";
     document.frmMain.submit();
   }
 }
 function doclose(){
   if(!<%=isFin%>){
   location="HrmCareerPlanFinish.jsp?id=<%=id%>";
   }else{
   location="HrmCareerPlanFinishView.jsp?id=<%=id%>";
   }
 }
 
rowindex = <%=rowindex%>;
function addRow()
{
	ncol = oTable.cols;
	oRow = oTable.insertRow();

	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell();
		oCell.style.height=24;
		oCell.style.background= "#efefef";
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
				var sHtml = "<BUTTON class=Calendar  id=selectstepstartdate onclick='getDate(stepstartdatespan_"+rowindex+" , stepstartdate_"+rowindex+")' > </BUTTON><SPAN id='stepstartdatespan_"+rowindex+"'></SPAN> <input class=inputstyle type=hidden id='stepstartdate_"+rowindex+"' name='stepstartdate_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
                		oCell.style.width=150;
				var oDiv = document.createElement("div");
				var sHtml = "<BUTTON class=Calendar  id=selectstependdate onclick='getDate(stependdatespan_"+rowindex+" , stependdate_"+rowindex+")' > </BUTTON><SPAN id='stependdatespan_"+rowindex+"'></SPAN> <input class=inputstyle type=hidden id='stependdate_"+rowindex+"' name='stependdate_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	rowindex = rowindex*1 +1;
}

function deleteRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
    for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
					rowsum1 += 1;
		}
	}

	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				oTable.deleteRow(rowsum1+2);
			}
			rowsum1 -=1;
		}
	}
}

</script>
</BODY>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>

