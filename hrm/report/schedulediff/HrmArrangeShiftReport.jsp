<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file = "/systeminfo/init.jsp" %>
<%@ page import = "weaver.general.Util,weaver.file.*,java.util.*" %>
<%@ page import = "" %>
<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id = "DepartmentComInfo" class = "weaver.hrm.company.DepartmentComInfo" scope = "page"/>
<jsp:useBean id = "ResourceComInfo" class = "weaver.hrm.resource.ResourceComInfo" scope = "page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>

<HTML><HEAD>
<LINK href = "/css/Weaver.css" type = text/css rel = STYLESHEET>
<script language = "javascript" src = "/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdReport.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(16674,user.getLanguage()); 
String needfav = "1" ; 
String needhelp = "" ; 

String fromdate = Util.fromScreen(request.getParameter("fromdate") , user.getLanguage()) ; //排班日期从
String enddate = Util.fromScreen(request.getParameter("enddate") , user.getLanguage()) ; //排班日期到
String department = Util.fromScreen(request.getParameter("department") , user.getLanguage()) ; //部门

String isself = Util.null2String(request.getParameter("isself"));

String sql = "" ;
int selectcolcount = 0 ;

Calendar thedate = Calendar.getInstance() ; //

// 如果用户选择的开始日期或者结束日期为空，则默认为当天前7天和后7天的时间 
if( fromdate.equals("") || enddate.equals("")) {
//    while( thedate.get(Calendar.DAY_OF_WEEK) != 2 ) thedate.add(Calendar.DATE, 1) ; 
    thedate.add(Calendar.DATE , -7) ; 
    fromdate = Util.add0(thedate.get(Calendar.YEAR), 4) + "-" + 
               Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
               Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
    thedate.add(Calendar.DATE , 14) ; 
    enddate = Util.add0(thedate.get(Calendar.YEAR) , 4) + "-" + 
              Util.add0(thedate.get(Calendar.MONTH) + 1 , 2) + "-" + 
              Util.add0(thedate.get(Calendar.DAY_OF_MONTH) , 2) ; 
} 

// 将开始日期到结束日期的每一天及其对应的星期放入缓存
ArrayList selectdates = new ArrayList() ; 
ArrayList selectweekdays = new ArrayList() ; 
// 得到所有当前的排班种类，放入缓存
ArrayList shiftids = new ArrayList() ; 
ArrayList shiftnames = new ArrayList() ; 
// 得到选定人力资源范围和时间范围内的所有排班信息放入缓存，以人力资源加排班时间作为索引
ArrayList reesourceshiftdates = new ArrayList() ; 
ArrayList resouceshiftids = new ArrayList() ; 

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
        sqlwhere2 =  " and departmentid = " + department ; 
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
        
        reesourceshiftdates.add(resourceid + "_" + shiftdate + "_" + shiftid ) ; 
    } 
}

// 导出EXCEL 
ExcelFile.init ();
String filename = SystemEnv.getHtmlLabelName(16674,user.getLanguage());
ExcelFile.setFilename(filename+fromdate+"_"+enddate) ;

// 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
ExcelStyle es = ExcelFile.newExcelStyle("Header") ;
es.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
es.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
es.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
es.setAlign(ExcelStyle.WeaverHeaderAlign) ;

ExcelSheet et = ExcelFile.newExcelSheet(filename) ;

// 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度  
et.addColumnwidth(8000) ;

%>
<BODY>
<%@ include file = "/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,_self} " ;
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

<form id = frmmain name = frmmain method = post action="HrmArrangeShiftReport.jsp">
<input type="hidden" name="operation" value=save>
<input type="hidden" name="isself" value="1">

<% 
for(int j=0 ; j< selectdates.size() ; j++ ) { 
    String thetempdate = (String) selectdates.get(j) ; 
%>
<input type = hidden name = "selectdate" value="<%=thetempdate%>">
<%}%>
<table class = viewform>
<tbody>
<TR CLASS = separator><TD colspan = 4 class = sep2></TD></TR>
<tr>
    <TD width=10%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD class = Field>
   <input class=wuiBrowser id=department type=hidden name=department value="<%=department%>" 
	_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
	displayText="<%=Util.toScreen(DepartmentComInfo.getDepartmentname(department),user.getLanguage())%>"
	>
    </TD>
    <td width=10%><%=SystemEnv.getHtmlLabelName(16694,user.getLanguage())%></td>
    <td class = field>
    <BUTTON type="button" class = calendar id = SelectDate onclick = getDate(fromdatespan,fromdate)></BUTTON>&nbsp;
    <SPAN id = fromdatespan><%=fromdate%></SPAN>
    <input type = "hidden" name = "fromdate" value=<%=fromdate%>>
    －<BUTTON type="button" class = calendar id = SelectDate onclick=getDate(enddatespan,enddate)></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=enddate%></SPAN>
    <input type="hidden" name="enddate" value=<%=enddate%>>  
    </td>
</tr>
</tbody>
</table>

<% if(isself.equals("1")) { %>
<TABLE class = ListStyle>
  <TBODY>
  <TR class = Header>
    <TH colspan=<%=selectcolcount%>><%=SystemEnv.getHtmlLabelName(16674,user.getLanguage())%></TH>
  </TR>
  <TR class = spacing>
    <TD class = Sep1 colspan=<%=selectcolcount%>></TD>
  </TR>
  <TR class = Header>
    <TH><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TH>
  <%
// 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度  
    et.addColumnwidth(8000) ;

    ExcelRow er = null ;
    er = et.newExcelRow() ;
    er.addStringValue(SystemEnv.getHtmlLabelName(413,user.getLanguage()), "Header" ) ; 


    for(int i = 0 ; i < selectdates.size() ; i++ ) { 
        String thetempdate = (String) selectdates.get(i) ; 
        int thetempweekday = Util.getIntValue( (String) selectweekdays.get(i) ) ; 
        et.addColumnwidth(4000) ; // 设置每一列的宽度, 如果不设置, 将按照excel默认的宽度
  %>

   <TH><%=thetempdate%><br>
        <% if( thetempweekday == 1 ) { 
               er.addStringValue(thetempdate+"/"+SystemEnv.getHtmlLabelName(398,user.getLanguage()), "Header" ) ; 
        %> <%=SystemEnv.getHtmlLabelName(398,user.getLanguage())%>
        <% } else if( thetempweekday == 2 ) { 
               er.addStringValue(thetempdate+"/"+SystemEnv.getHtmlLabelName(392,user.getLanguage()), "Header" ) ; 
        %> <%=SystemEnv.getHtmlLabelName(392,user.getLanguage())%>
        <% } else if( thetempweekday == 3 ) { 
               er.addStringValue(thetempdate+"/"+SystemEnv.getHtmlLabelName(393,user.getLanguage()), "Header" ) ; 
        %> <%=SystemEnv.getHtmlLabelName(393,user.getLanguage())%>
        <% } else if( thetempweekday == 4 ) { 
               er.addStringValue(thetempdate+"/"+SystemEnv.getHtmlLabelName(394,user.getLanguage()), "Header" ) ; 
        %> <%=SystemEnv.getHtmlLabelName(394,user.getLanguage())%>
        <% } else if( thetempweekday == 5 ) { 
               er.addStringValue(thetempdate+"/"+SystemEnv.getHtmlLabelName(395,user.getLanguage()), "Header" ) ; 
        %> <%=SystemEnv.getHtmlLabelName(395,user.getLanguage())%>
        <% } else if( thetempweekday == 6 ) { 
               er.addStringValue(thetempdate+"/"+SystemEnv.getHtmlLabelName(396,user.getLanguage()), "Header" ) ; 
        %> <%=SystemEnv.getHtmlLabelName(396,user.getLanguage())%>
        <% } else if( thetempweekday == 7 ) { 
               er.addStringValue(thetempdate+"/"+SystemEnv.getHtmlLabelName(397,user.getLanguage()), "Header" ) ; 
        %> <%=SystemEnv.getHtmlLabelName(397,user.getLanguage())%>
        <% } %>
    </TH>
  <% } %>
    </TR>
   <TR class=Line><TD colspan=<%=selectcolcount%> ></TD></TR> 
  <%
    boolean isLight = false ; 
    RecordSet.executeSql(sql) ; 
    while(RecordSet.next()) { 	
        er = et.newExcelRow() ;
        String resourceid = Util.null2String(RecordSet.getString("id")) ; 
        er.addStringValue(Util.toScreen(ResourceComInfo.getResourcename(resourceid) , user.getLanguage())) ; 
        isLight = !isLight ; 
  %> 
       <TR class='<%=( isLight ? "datalight" : "datadark" )%>'> 
        <TD><nobr><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid) , user.getLanguage())%></TD>
  <%
        for(int j = 0 ; j < selectdates.size() ; j++ ) {
            String thetempdate = (String) selectdates.get(j) ; 
  %>
        <TD>
  <%        String shiftname = "" ;
            for( int k=0 ; k< shiftids.size() ; k++) {
                String shiftid = (String) shiftids.get(k) ; 
                int shiftindex = reesourceshiftdates.indexOf(resourceid + "_" + thetempdate + "_" + shiftid ) ; 
                if( shiftindex != -1 ) {
                    if(shiftname.equals("")) shiftname += (String) shiftnames.get(k) ; 
                    else shiftname += "<br>" + (String) shiftnames.get(k) ; 
                }
            }
            
            er.addStringValue(shiftname) ;
  %>
      <%=shiftname%>
     </TD>
  <% } %>
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
<script language=javascript>  
function submitData() {
 jQuery("#frmmain").submit();
}
</script>

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
</script>

<script language=javascript>
 function doSave() {
    document.frmmain.action="HrmArrangeShiftMaintanceOperation.jsp" ; 
   	document.frmmain.operation.value="save" ; 
	document.frmmain.submit() ; 
}

</script>
</body> 
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
