<%@ page import = "weaver.general.Util" %>
<%@ page import = "java.util.*" %>
<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id = "DepartmentComInfo" class = "weaver.hrm.company.DepartmentComInfo" scope = "page"/>
<jsp:useBean id = "ResourceComInfo" class = "weaver.hrm.resource.ResourceComInfo" scope = "page"/>
<jsp:useBean id = "ScheduleDiffComInfo" class="weaver.hrm.schedule.HrmScheduleDiffComInfo" scope="page"/>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file = "/systeminfo/init.jsp" %>

<%
if(!HrmUserVarify.checkUserRight("HrmArrangeShiftMaintance:Maintance", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>

<HTML><HEAD>
<LINK href = "/css/Weaver.css" type = text/css rel = STYLESHEET>
<script language = "javascript" src = "/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdReport.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(16692 , user.getLanguage()) ;  
String needfav = "1" ; 
String needhelp = "" ; 

String rightlevel = HrmUserVarify.getRightLevel("HrmArrangeShiftMaintance:Maintance" , user ) ;

String isself = Util.null2String(request.getParameter("isself"));

String fromdate = Util.fromScreen(request.getParameter("fromdate") , user.getLanguage()) ; //排班日期从
String enddate = Util.fromScreen(request.getParameter("enddate") , user.getLanguage()) ; //排班日期到
String department = Util.fromScreen(request.getParameter("department") , user.getLanguage()) ; //部门
if(!department.equals("")) isself = "1" ;

Calendar thedate = Calendar.getInstance() ; //

String currentdate =  Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
                Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
                Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ;   // 当天

// 如果用户选择的开始日期或者结束日期为空，则默认为下周一到下周日
if( fromdate.equals("") || enddate.equals("")) {
    while( thedate.get(Calendar.DAY_OF_WEEK) != 2 ) thedate.add(Calendar.DATE, 1) ; 
    fromdate = Util.add0(thedate.get(Calendar.YEAR), 4) + "-" + 
               Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
               Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
    thedate.add(Calendar.DATE , 6) ; 
    enddate = Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
              Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
              Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
} 

ArrayList selectdates = new ArrayList() ; 
ArrayList selectweekdays = new ArrayList() ; 
ArrayList shiftids = new ArrayList() ; 
ArrayList shiftnames = new ArrayList() ; 
ArrayList reesourceshiftdates = new ArrayList() ; 
ArrayList resouceshiftids = new ArrayList() ; 
String sql = "" ;
int selectcolcount = 0 ;

if(isself.equals("1")) {

    // 将开始日期到结束日期的每一天及其对应的星期放入缓存
    

    int fromyear = Util.getIntValue(fromdate.substring(0 , 4)) ; 
    int frommonth = Util.getIntValue(fromdate.substring(5 , 7)) ; 
    int fromday = Util.getIntValue(fromdate.substring(8 , 10)) ; 
    String tempdate = fromdate ; 

    thedate.set(fromyear,frommonth - 1 , fromday) ; 

    while( tempdate.compareTo(enddate) <= 0 ) {
        selectdates.add(tempdate) ; 
        selectweekdays.add("" + thedate.get(Calendar.DAY_OF_WEEK)) ; 

        thedate.add(Calendar.DATE , 1) ; 
        tempdate =  Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
                    Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
                    Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
    }

    selectcolcount = selectdates.size() + 1 ; // 列数


    String sqlwhere1="";
    String sqlwhere2="";

    if(!fromdate.equals("")) { 
        sqlwhere1 += " and shiftdate >='" + fromdate + "'" ; 
    } 

    if(!enddate.equals("")) { 
        sqlwhere1 += " and shiftdate <='" + enddate + "'" ; 
    } 

    if(!department.equals("")) { 
        sqlwhere1 += " and b.departmentid = " + department ; 
        sqlwhere2 +=  " and departmentid = " + department ; 
    } 

    if(rightlevel.equals("0") ) {
        sqlwhere1 += " and b.departmentid = " + user.getUserDepartment() ; 
        sqlwhere2 +=  " and departmentid = " + user.getUserDepartment() ; 
    }
    else if(rightlevel.equals("1") ) {
        sqlwhere1 += " and b.subcompanyid1 = " + user.getUserSubCompany1() ; 
        sqlwhere2 +=  " and subcompanyid1 = " + user.getUserSubCompany1() ; 
    }

    sql = " select id from hrmresource where id in ( select resourceid from HrmArrangeShiftSet ) " + sqlwhere2 + " order by departmentid " ; 


    // 得到所有当前的排班种类，放入缓存
    

    RecordSet.executeSql("select id, shiftname from HrmArrangeShift where ishistory='0' order by id ") ; 
    while ( RecordSet.next() ) { 
        String id = Util.null2String(RecordSet.getString("id")) ; 
        String shiftname = Util.toScreen(RecordSet.getString("shiftname") , user.getLanguage()) ; 

        shiftids.add(id) ; 
        shiftnames.add(shiftname) ; 
    } 

    // 得到选定人力资源范围和时间范围内的所有排班信息放入缓存，以人力资源加排班时间作为索引
    RecordSet.executeSql(" select a.* from HrmArrangeShiftInfo a , Hrmresource b where a.resourceid = b.id and b.id in ( select resourceid from HrmArrangeShiftSet ) " + sqlwhere1 ) ; 

    while( RecordSet.next() ) { 
        String resourceid = Util.null2String(RecordSet.getString("resourceid")) ; 
        String shiftdate = Util.null2String(RecordSet.getString("shiftdate")) ; 
        String shiftid = Util.null2String(RecordSet.getString("shiftid")) ; 

        int reesourceshiftdateindex = reesourceshiftdates.indexOf(resourceid+"_"+shiftdate) ;
        if( reesourceshiftdateindex == -1 ) {
            reesourceshiftdates.add(resourceid+"_"+shiftdate) ;
            ArrayList tempshiftids = new ArrayList() ;
            tempshiftids.add(shiftid) ;
            resouceshiftids.add(tempshiftids) ;
        }
        else {
            ArrayList tempshiftids = (ArrayList) resouceshiftids.get(reesourceshiftdateindex) ;
            tempshiftids.add(shiftid) ;
            resouceshiftids.set(reesourceshiftdateindex ,tempshiftids) ;
        }
    } 
}

%>
<BODY>
<%@ include file = "/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15839,user.getLanguage())+",/hrm/schedule/HrmArrangeShiftProcess.jsp?department="+department+"&fromdate="+fromdate+"&enddate="+enddate+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(16749,user.getLanguage())+",/hrm/schedule/HrmArrangeShiftSet.jsp?department="+department+"&fromdate="+fromdate+"&enddate="+enddate+",_self} " ;
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
<form id = frmmain name = frmmain method = post action="HrmArrangeShiftMaintance.jsp">
<input class=inputstyle type="hidden" name="operation" value=save>
<input type="hidden" name="isself" value="1">

<table class =viewform>
<tbody>
  <TR class=Title>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%></TH>
  </TR>

<TR CLASS=Spacing style="height:1px"><TD colspan = 4 class=Line1></TD></TR>
<tr>
    <TD width=10%><%=SystemEnv.getHtmlLabelName(124 , user.getLanguage())%></TD>
    <TD width="28%" class = Field>

    <input class="wuiBrowser" id=department type=hidden name=department value="<%=department%>"
	_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
	_displayText="<%=Util.toScreen(DepartmentComInfo.getDepartmentmark(department),user.getLanguage())%>">
    </TD>
    <td width=9% align="left"><%=SystemEnv.getHtmlLabelName(16694 , user.getLanguage())%></td>
    <td width="53%" class = field>
    <BUTTON class = calendar type="button" id = SelectDate onclick = getDate(fromdatespan,fromdate)></BUTTON>&nbsp;
    <SPAN id = fromdatespan><%=fromdate%></SPAN>
    <input class=inputstyle type = "hidden" name = "fromdate" value=<%=fromdate%>>
    －&nbsp;&nbsp;<BUTTON class = calendar type="button" id = SelectDate onclick=getDate(enddatespan,enddate)></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=enddate%></SPAN>
    <input class=inputstyle type="hidden" name="enddate" value=<%=enddate%>>  
    </td>
</tr>
 <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
</tbody>
</table>

<% if(isself.equals("1")) { %>

<% 
for(int j=0 ; j< selectdates.size() ; j++ ) { 
    String thetempdate = (String) selectdates.get(j) ; 
%>
<input type = hidden name = "selectdate" value="<%=thetempdate%>">
<%}%>

<TABLE class=ListStyle cellspacing=1 >
<TBODY>
  <TR class = Header>
    <TH colspan=<%=selectcolcount%>><%=SystemEnv.getHtmlLabelName(16695 , user.getLanguage())%></TH>
  </TR>
  <TR class = Header>
    <TH><%=SystemEnv.getHtmlLabelName(413 , user.getLanguage())%></TH>
  <%
    for(int i = 0 ; i < selectdates.size() ; i++ ) { 
        String thetempdate = (String) selectdates.get(i) ; 
        int thetempweekday = Util.getIntValue( (String) selectweekdays.get(i) ) ; 
  %>
    <TH><%=thetempdate%><br>
        <% if( thetempweekday == 1 ) { %><%=SystemEnv.getHtmlLabelName(398 , user.getLanguage())%>
        <% } else if( thetempweekday == 2 ) { %><%=SystemEnv.getHtmlLabelName(392 , user.getLanguage())%>
        <% } else if( thetempweekday == 3 ) { %> <%=SystemEnv.getHtmlLabelName(393 , user.getLanguage())%>
        <% } else if( thetempweekday == 4 ) { %><%=SystemEnv.getHtmlLabelName(394 , user.getLanguage())%>
        <% } else if( thetempweekday == 5 ) { %><%=SystemEnv.getHtmlLabelName(395 , user.getLanguage())%>
        <% } else if( thetempweekday == 6 ) { %><%=SystemEnv.getHtmlLabelName(396 , user.getLanguage())%>
        <% } else if( thetempweekday == 7 ) { %><%=SystemEnv.getHtmlLabelName(397 , user.getLanguage())%>
        <% } %>
    </TH>
  <% } %>
    </TR>
  <%
    boolean isLight = false ;
    boolean disablebutton = false  ; // 将今日之前 （包括今日）的排班设置disabled
    int recordecount = 0 ;           // 为每20条显示一个顶部栏来计算条数
    RecordSet.executeSql(sql) ; 
    while(RecordSet.next()) { 	
        String resourceid = Util.null2String(RecordSet.getString("id")) ; 
        isLight = !isLight ; 
        recordecount ++ ;
        if(recordecount>20) {                   // 每20条显示一个顶部栏
            recordecount = 0 ;          
  %> 
        <TR class = Header>
            <TH><%=SystemEnv.getHtmlLabelName(413 , user.getLanguage())%></TH>
          <%
            for(int i = 0 ; i < selectdates.size() ; i++ ) { 
                String thetempdate = (String) selectdates.get(i) ; 
                int thetempweekday = Util.getIntValue( (String) selectweekdays.get(i) ) ; 
          %>
            <TH><%=thetempdate%><br>
                <% if( thetempweekday == 1 ) { %><%=SystemEnv.getHtmlLabelName(398 , user.getLanguage())%>
                <% } else if( thetempweekday == 2 ) { %><%=SystemEnv.getHtmlLabelName(392 , user.getLanguage())%>
                <% } else if( thetempweekday == 3 ) { %> <%=SystemEnv.getHtmlLabelName(393 , user.getLanguage())%>
                <% } else if( thetempweekday == 4 ) { %><%=SystemEnv.getHtmlLabelName(394 , user.getLanguage())%>
                <% } else if( thetempweekday == 5 ) { %><%=SystemEnv.getHtmlLabelName(395 , user.getLanguage())%>
                <% } else if( thetempweekday == 6 ) { %><%=SystemEnv.getHtmlLabelName(396 , user.getLanguage())%>
                <% } else if( thetempweekday == 7 ) { %><%=SystemEnv.getHtmlLabelName(397 , user.getLanguage())%>
                <% } %>
            </TH>
          <% } %>
            </TR>
 <%       }  %>
       <TR class='<%=( isLight ? "datalight" : "datadark" )%>'> 
        <TD><nobr><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid) , user.getLanguage())%>
            <input class=inputstyle type = hidden name = "selectresource" value="<%=resourceid%>" >
        </TD>
  <%
        for(int j = 0 ; j < selectdates.size() ; j++ ) {
            String thetempdate = (String) selectdates.get(j) ; 
            if( Util.dayDiff(currentdate,thetempdate) < -2 ) disablebutton=true ;  // 排班日期小于当天的前一天
            else disablebutton = false ;
  %>
        <TD>
  <%        
            int reesourceshiftdateindex = reesourceshiftdates.indexOf(resourceid+"_"+thetempdate) ;
            String shiftidstr = "" ;
            String shiftnamestr = "" ;
            if( reesourceshiftdateindex != -1 ) {
                ArrayList tempshiftids = (ArrayList) resouceshiftids.get(reesourceshiftdateindex) ;
                for(int k=0 ; k<tempshiftids.size(); k++) {
                    String tempshiftid = (String)tempshiftids.get(k) ;
                    int tempshiftidindex = shiftids.indexOf(tempshiftid) ;
                    if(tempshiftidindex != -1) {
                        if(shiftidstr.equals("")) {
                            shiftidstr = tempshiftid ;
                            shiftnamestr = (String)shiftnames.get(tempshiftidindex) ;
                        }
                        else {
                            shiftidstr += "," + tempshiftid ;
                            shiftnamestr += "," +(String)shiftnames.get(tempshiftidindex) ;
                        }
                    }
                }
            }
  %>
  <%        if(!disablebutton) {%>
      <BUTTON type="button" class=Browser onClick="onShowShift('<%=resourceid%>_<%=thetempdate%>_span','<%=resourceid%>_<%=thetempdate%>')"></BUTTON><input class=inputstyle id="<%=resourceid%>_<%=thetempdate%>" type=hidden name="<%=resourceid%>_<%=thetempdate%>" value="<%=shiftidstr%>">
 <%         } %>
      <span class=inputstyle id="<%=resourceid%>_<%=thetempdate%>_span" name="<%=resourceid%>_<%=thetempdate%>_span"><%=shiftnamestr%></span> 
     </TD>
  <%    } %>
     </TR> 
  <% } %>
  </TBODY>
 </TABLE>
 <%}%>
 </form>
 <BR>
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
<script language = vbs>  
sub onShowDepartment(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&inputname.value)
	if Not isempty(id) then
	if id(0)<> 0 then
        spanname.innerHtml = id(1)
        inputname.value=id(0)
	else
        spanname.innerHtml = ""
        inputname.value=""
	end if
	end if
end sub

sub onShowShift1(spanname , inputname)
    shiftidvalue = document.all(inputname).value 
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/schedule/HrmMutiArrangeShiftBrowser.jsp?shiftids="&shiftidvalue)
	if (Not IsEmpty(id)) then
        if id(0)<> "" then
            document.all(spanname).innerHtml = Mid(id(1),2,len(id(1)))
            document.all(inputname).value=Mid(id(0),2,len(id(0)))
        else 
            document.all(spanname).innerHtml = ""
            document.all(inputname).value=""
	end if
	end if
end sub

</script>

<script language=javascript>
 function doSave(obj) {
    document.frmmain.action="HrmArrangeShiftMaintanceOperation.jsp" ; 
   	document.frmmain.operation.value="save" ; 
    obj.disabled = true ;
	document.frmmain.submit() ; 
}
function submitData() {
 frmmain.submit();
}

function onShowShift(spanname , inputname){
    shiftidvalue = $G(inputname).value 
	results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/schedule/HrmMutiArrangeShiftBrowser.jsp?shiftids="+shiftidvalue);
	if (results) {
        if (results.id!="") {
            $G(spanname).innerHTML =results.name;
            $G(inputname).value=results.id;
        }else{ 
            $G(spanname).innerHTML = "";
            $G(inputname).value="";
        }    
	}
  }


</script>
</body> 
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>