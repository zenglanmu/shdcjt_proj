<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>

</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(19397,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(320,user.getLanguage());
String needfav ="1";
String needhelp ="";

String buttonname=SystemEnv.getHtmlLabelName(82,user.getLanguage());
String orgtype="com";
String subid=Util.null2String(request.getParameter("subcompanyid"));
String orgid=subid;
String deptid=Util.null2String(request.getParameter("departmentid"));

    if(subid.equals("")&&deptid.equals(""))
{
   String s="<TABLE class=viewform><colgroup><col width='10'><col width=''><TR class=Title><TH colspan='2'>"+SystemEnv.getHtmlLabelName(19010,user.getLanguage())+"</TH></TR><TR class=spacing><TD class=line1 colspan='2'></TD></TR><TR><TD></TD><TD><li>";
    if(user.getLanguage()==8){s+="click left organization tree,set the organization's monthly schedule record</li></TD></TR></TABLE>";}
    else if(user.getLanguage()==9){s+="點擊左邊組織對該組織進行考勤月記錄維護</li></TD></TR></TABLE>";}
    else{s+="点击左边组织对该组织进行考勤月记录维护</li></TD></TR></TABLE>";}
    out.println(s);
    return;
}
if(subid.equals("")){
      orgtype="dept";
      subid=DepartmentComInfo.getSubcompanyid1(deptid);
      orgid=deptid;
}
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel=-1;
if(detachable==1){
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmScheduleMaintanceAdd:Add",Integer.parseInt(subid));
}else{
    if(HrmUserVarify.checkUserRight("HrmScheduleMaintanceAdd:Add", user))
        operatelevel=2;
}
if(operatelevel<0){
    		response.sendRedirect("/notice/noright.jsp") ;
    		return ;
}
boolean CanAdd=false;
if(operatelevel>0)
    CanAdd=true;
String sql="";

    if(orgtype.equals("com"))
    sql="select distinct theyear,themonth from hrmschedulemonth a,hrmresource b where a.hrmid=b.id  and b.subcompanyid1="+subid+" order by theyear desc,themonth desc";
    else{
     String deptids=SubCompanyComInfo.getDepartmentTreeStr(deptid);
     deptids=deptid+","+deptids;
     deptids=deptids.substring(0,deptids.length()-1);
     sql="select distinct theyear,themonth from hrmschedulemonth a,hrmresource b where a.hrmid=b.id  and b.departmentid in("+deptids+") order by theyear desc,themonth desc";}
    RecordSet.executeSql(sql);
    ArrayList l=new ArrayList();
    while(RecordSet.next()){
        if(!l.contains(RecordSet.getString("theyear")))
        l.add(RecordSet.getString("theyear"));

    }

%>
<body>

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(CanAdd) {
RCMenu += "{"+buttonname+",javascript:onSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
}
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form name=subform method=post>
<%

int rownum=(l.size()+2)/3;
%>


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

<table class="ViewForm">

   <tr class=field>
        <td width="30%" align=left valign=top>
<%
 	int i=0;
 	int needtd=rownum;
    Iterator iter=l.iterator();
     while(iter.hasNext()){
 		String theyear=(String)iter.next();
         needtd--;
 	%>
 	<table class="ViewForm">
		<tr>
		  <td>



	    <ul><li><b><%=theyear+SystemEnv.getHtmlLabelName(17138,user.getLanguage())%></b>
        <%RecordSet.beforFirst();
        while(RecordSet.next()){
        if(RecordSet.getString("theyear").equals(theyear)){%>
		<ul><li><%if(CanAdd){%><a href="HrmScheduleMonthList.jsp?year=<%=theyear%>&month=<%=RecordSet.getString("themonth")%>&type=<%=orgtype%>&id=<%=orgid%>"><%}%>
		<%=RecordSet.getString("themonth")+SystemEnv.getHtmlLabelName(19398,user.getLanguage())%><%if(CanAdd){%></a><%}%></ul></li>
	<%
		}
        }
	%>
		</ul></li></td></tr>
	</table>
	<%
		if(needtd==0){
			needtd=rownum;
	%>
	</td><td width="30%" align=left valign=top>
	<%
		}
	}
	%>
	</td>
  </tr>
</table>
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


</form>
</body>
 <script>
     function onSubmit(obj){
         obj.disabled=true;
         location="/hrm/schedule/HrmScheduleMonthAdd.jsp?type=<%=orgtype%>&id=<%=orgid%>";
     }
 </script>
</html>