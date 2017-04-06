<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/docs/common.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cici" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" /> 
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
if(!HrmUserVarify.checkUserRight("RpReadView:View", user))  {
        response.sendRedirect("/notice/noright.jsp") ;
	    return ;
    }
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(104,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(260,user.getLanguage());
String needfav ="1";
String needhelp ="";

String resource = Util.null2String(request.getParameter("resource")) ;
String creater = Util.null2String(request.getParameter("creater")) ;
String fromdate = Util.null2String(request.getParameter("fromdate")) ;
String todate = Util.null2String(request.getParameter("todate")) ;
String object = Util.null2String(request.getParameter("object")) ;

int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getPerpageLog();
if(perpage<10) perpage=10;

String whereclause = "";
if(!resource.equals("")) whereclause +="where operateuserid ="+resource ;
if(!creater.equals("")) {
	if(whereclause.equals("")) whereclause +="where doccreater ="+creater;
	else whereclause +=" and doccreater ="+creater;
}
if(!fromdate.equals("")) {
	if(whereclause.equals("")) whereclause +="where operatedate >='"+fromdate+"'" ;
	else whereclause +=" and operatedate >='"+fromdate+"'" ;
}
if(!todate.equals("")) {
	if(whereclause.equals("")) whereclause +="where operatedate <='"+todate+"'" ;
	else whereclause +=" and operatedate <='"+todate+"'" ;
}

if(whereclause.equals("")) whereclause +="where operatetype='0'" ;
else whereclause +=" and operatetype='0'" ;

if(whereclause.equals("")) whereclause +="where t1.docid=t2.sourceid  ";
else whereclause +=" and t1.docid=t2.sourceid  ";

String temptable = "projtemptable"+ Util.getRandom() ;
String sql="";
if(RecordSet.getDBType().equals("oracle")){
	sql = "create table "+temptable+"  as select * from (select operateuserid, operatedate, operatetime, t1.docid, doccreater, docsubject,creatertype,usertype from DocDetailLog  t1,"+tables+"  t2 " +whereclause +" order by operatedate desc , operatetime desc ) where rownum<"+ (pagenum*perpage+2);
}else if(RecordSet.getDBType().equals("db2")){
	sql = "create table "+temptable+"  as  (select operateuserid, operatedate, operatetime, t1.docid, doccreater, docsubject,creatertype,usertype from DocDetailLog  t1,"+tables+"   t2 ) definition only ";

    RecordSet.executeSql(sql);

    sql="insert into "+temptable+" (select  operateuserid, operatedate, operatetime, t1.docid, doccreater, docsubject,creatertype,usertype from DocDetailLog  t1,"+tables+"   t2 " +whereclause +" order by operatedate desc , operatetime desc fetch first  "+(pagenum*perpage+1)+" rows only)";
}else{
	sql="select  top "+(pagenum*perpage+1)+" operateuserid, operatedate, operatetime, t1.docid, doccreater, docsubject,creatertype,usertype " + "into "+temptable+" from DocDetailLog  t1,"+tables+"   t2 " +whereclause +" order by operatedate desc , operatetime desc ";
}

RecordSet.executeSql(sql);
rs.executeSql("select count(*) from DocDetailLog  t1,"+tables+"   t2 " +whereclause);
rs.next();
int total=rs.getInt(1);
RecordSet.executeSql("Select count(*) RecordSetCounts from "+temptable);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}

if(RecordSet.getDBType().equals("oracle")){
	sql="select * from (select * from  "+temptable+" order by operatedate , operatetime) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else if(RecordSet.getDBType().equals("db2")){
    sql="select  * from "+temptable+"  order by operatedate , operatetime fetch first "+(RecordSetCounts-(pagenum-1)*perpage)+" rows only ";
}else{
	sql="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by operatedate , operatetime";
}

RecordSet.executeSql(sql);
//System.out.println(sql);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onReSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(pagenum>1)
{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",RpReadView.jsp?pagenum="+(pagenum-1)+"&resource="+resource+"&creater="+creater+"&fromdate="+fromdate+"&todate="+todate+",_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(hasNextPage)
{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",RpReadView.jsp?pagenum="+(pagenum+1)+"&resource="+resource+"&creater="+creater+"&fromdate="+fromdate+"&todate="+todate+",_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=report name=report action=RpReadView.jsp method=post>
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

			<TABLE class=ViewForm>
			<COLGROUP>
			  <COL width="15%">
			  <COL width="25%">
			  <COL width="15%">
			  <COL width="45%">
			  <TBODY>
			  <TR class=Spacing >
				<TD    class=Line1 colSpan=4></TD>
			  </TR>
			  <TR>
				  <TD><%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%></TD>
				<TD class=Field colspan=3>
				  <INPUT  class=wuiBrowser  id="resource"  _displayText="<%=ResourceComInfo.getResourcename(resource)%>" 
				   _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				   _displayTemplate="<A  target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name} </a>"
				   id=resource type=hidden name=resource value="<%=resource%>">
				  </TD>
				</TR>
				<TR style="height:2px"  ><TD class=Line colSpan=4></TD></TR>
			  <TR>
				  <TD><%=SystemEnv.getHtmlLabelName(271,user.getLanguage())%></TD>
				<TD class=Field>
		
				 <INPUT  class="wuiBrowser"  _displayText="<%=ResourceComInfo.getResourcename(creater)%>" id=creater type=hidden name=creater value="<%=creater%>"
				   _displayTemplate="<A  target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name} </a>"
				  _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" >
				  </TD>
				  <TD><%=SystemEnv.getHtmlLabelName(260,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TD>
				<TD class=Field><input  type="hidden"  class=wuiDate   name="fromdate" value="<%=fromdate%>" />
				  -&nbsp;&nbsp; <input type="hidden" class=wuiDate  name="todate" value="<%=todate%>" />
				
				  </TD>
				  </TR>
				  <TR style="height:2px" ><TD class=Line colSpan=4></TD>
				  </TR>
				</TBODY>
				</TABLE>
				<BR>
			<TABLE class=ListStyle cellspacing=1>
			  <TBODY>
			  <TR class=Header>
				  <TD><%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%></TD>
				  <TD><%=SystemEnv.getHtmlLabelName(260,user.getLanguage())%></TD>
				  <!-- TD><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD -->
				  <TD><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD>
				  <TD><%=SystemEnv.getHtmlLabelName(271,user.getLanguage())%></TD>

				</TR>
				<%
				boolean islight=true;
			int totalline=1;
			if(RecordSet.last()){
				do{
					  String operateuserid = Util.null2String(RecordSet.getString("operateuserid")) ;
					  String operatedate = Util.null2String(RecordSet.getString("operatedate")) ;
					  String operatetime = Util.null2String(RecordSet.getString("operatetime")) ;
					  String docid = Util.null2String(RecordSet.getString("docid")) ;
					  String doccreater = Util.null2String(RecordSet.getString("doccreater")) ;
					  String docsubject = RecordSet.getString("docsubject") ;
                      String opreatertype = RecordSet.getString("usertype") ;
                      String creatertype = RecordSet.getString("creatertype") ;
                      //System.out.println("opreatertype : "+opreatertype);
                      //System.out.println("creatertype : "+creatertype);
				%>
			  <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>              
				<TD noWrap>
                    <%if("1".equals(opreatertype)){%>
                        <A href="/hrm/resource/HrmResource.jsp?id=<%=operateuserid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(operateuserid),user.getLanguage())%></A>
                    <%}else{%>
                        <A href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=operateuserid%>"><%=Util.toScreen(cici.getCustomerInfoname(operateuserid),user.getLanguage())%></A>
                    <%}%>                    
                </TD>
				<TD noWrap><%=operatedate%> <%=operatetime%></TD>
				<TD><A
				href="/docs/docs/DocDsp.jsp?id=<%=docid%>"><%=Util.toScreen(docsubject,user.getLanguage())%></A></TD>
				<TD>
                    <%if("1".equals(creatertype)||"".equals(creatertype)){%>
                        <A href="/hrm/resource/HrmResource.jsp?id=<%=doccreater%>"><%=Util.toScreen(ResourceComInfo.getResourcename(doccreater),user.getLanguage())%></A>
                    <%}else{%>
                        <A href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=doccreater%>"><%=Util.toScreen(cici.getCustomerInfoname(doccreater),user.getLanguage())%></A>
                    <%}%>
                </TD>
				</TR>
			<%
				islight=!islight;
				if(hasNextPage){
					totalline+=1;
					if(totalline>perpage)	break;
				}
			}while(RecordSet.previous());
			}
			RecordSet.executeSql("drop table "+temptable);
			%>
			<tr>
			 <td colspan="4">   
			  <%
	           out.println(Util.makeNavbar2(pagenum, total , perpage, "RpReadView.jsp?resource="+resource+"&creater="+creater+"&fromdate="+fromdate+"&todate="+todate+"&object="+object));
              %>
              </td>
			</tr>
			  </TBODY>
			</TABLE>
		</td>
		</tr>
		</TABLE>
		<TABLE width="100%" border=0>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<script language=vbs>
sub getfromDate()
returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
fromdatespan.innerHtml= returndate
report.fromdate.value=returndate
end sub
sub gettoDate()
returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
todatespan.innerHtml= returndate
report.todate.value= returndate
end sub

sub onShowResource(tdname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		document.all(tdname).innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
//		document.all(tdname).innerHtml =id(1)
		document.all(inputname).value=id(0)
		else
		document.all(tdname).innerHtml = empty
		document.all(inputname).value=""
		end if
	end if
end sub
</script>
<script>
function onReSearch(){
	report.submit();
}
</script>
</FORM>
</BODY>
<script type="text/javascript" src="/js/datetime.js"></script>
<script type="text/javascript" src="/js/JSDateTime/WdatePicker.js"></script>

</HTML>
