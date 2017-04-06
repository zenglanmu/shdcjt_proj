<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
boolean hasright=true;
if(!HrmUserVarify.checkUserRight("Compensation:Maintenance", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
int departmentid=Util.getIntValue(request.getParameter("departmentid"));
String title="";
String sqlwhere=" where 1=2" ;
String subcomidstr = "";
if(subcompanyid>0){
    title=SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
    String allrightcompany = SubCompanyComInfo.getRightSubCompany(user.getUID(), "Compensation:Maintenance",-1);
    ArrayList allrightcompanyid = Util.TokenizerString(allrightcompany, ",");
    subcomidstr = SubCompanyComInfo.getRightSubCompanyStr1("" + subcompanyid, allrightcompanyid);
    sqlwhere=" where subcompanyid in("+subcomidstr+")";
}
if(departmentid>0){
    title=DepartmentComInfo.getDepartmentname(""+departmentid);
    subcompanyid=Util.getIntValue(DepartmentComInfo.getSubcompanyid1(""+departmentid));
    sqlwhere=" where departmentid="+departmentid;
}
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
int detachable=Util.getIntValue((String)session.getAttribute("detachable"));
if(detachable==1){
    if(subcompanyid>0){
    int operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Compensation:Maintenance",subcompanyid);
    if(operatelevel==-1){
            response.sendRedirect("/notice/noright.jsp");
            return;
    }
    if(operatelevel<1){
        hasright=false;
    }
    }else{
       hasright=false;
    }
}
//判断是否为部门级权限
int maxlevel=0;
rs.executeSql("select c.rolelevel from SystemRightDetail a, SystemRightRoles b,HrmRoleMembers c where b.roleid=c.roleid and a.rightid = b.rightid and a.rightdetail='Compensation:Maintenance' and c.resourceid="+user.getUID()+" order by c.rolelevel");
while(rs.next()){
    int rolelevel=rs.getInt(1);
    if(maxlevel<rolelevel) maxlevel=rolelevel;
    if(rolelevel==0){
        if(user.getUserDepartment()!=departmentid)
        hasright=false;
        else
        hasright=true;
    }
}
if(user.getUID()==1){
	hasright=true;
}
if(maxlevel<1 && !hasright){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
String imagefilename = "/images/hdHRM.gif";
String titlename = SystemEnv.getHtmlLabelName(19430,user.getLanguage())+"："+title;
String needfav ="1";
String needhelp ="";
ArrayList yearslist=new ArrayList();
ArrayList [] monthlist=null;
rs.executeSql("select CompensationYear from HRM_CompensationTargetInfo "+sqlwhere+" group by CompensationYear");
if(rs.next()){
    if(rs.getCounts()>0){
    monthlist=new ArrayList[rs.getCounts()];
    }
}
if(monthlist!=null){
for(int i=0;i<monthlist.length;i++){
    monthlist[i]=new ArrayList();
}
}
rs.executeSql("select CompensationYear,CompensationMonth from HRM_CompensationTargetInfo "+sqlwhere+" group by CompensationYear,CompensationMonth order by CompensationYear desc,CompensationMonth desc");
while(rs.next()){
    String tempyear=Util.add0(rs.getInt("CompensationYear"),4);
    String tempmonth=Util.add0(rs.getInt("CompensationMonth"),2);
    if(yearslist.indexOf(tempyear)==-1) {
        yearslist.add(tempyear);
    }
    monthlist[yearslist.size()-1].add(tempmonth);
}
int rownum=(yearslist.size()+2)/3;
//System.out.println("rownum:"+rownum);
%>
<body>

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(hasright && subcompanyid>0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location.href=\"CompensationTargetMaintEdit.jsp?subCompanyId="+subcompanyid+"&departmentid="+departmentid+"\",_self} " ;
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
    int index=0;
    for(int i=0;i<3;i++){
     %>
 	<table class="ViewForm">
		<tr>
		  <td>
 	<%
     for(int k=1;k<=rownum;k++){
     if(yearslist.size()>((k-1)*3+i)){
    %>
	<ul><li><b><%=yearslist.get(index)%><%=SystemEnv.getHtmlLabelName(17138,user.getLanguage())%></b>
	<%
         if(monthlist.length>index){
         for(int m=0;m<monthlist[index].size();m++){
	%>
		<ul><li><a href="javascript:onlinks('<%=yearslist.get(index)%>','<%=monthlist[index].get(m)%>');">
		<%=monthlist[index].get(m)%><%=SystemEnv.getHtmlLabelName(19398,user.getLanguage())%></a></ul></li>
	<%
        }
        }
    %>
		</ul></li>
    <%
    if(k<rownum-1){
    %>
    </td></tr><tr><td>
    <%
        }
        index++;
        }
        }
    %>
    </td></tr>
    </table>
	</td><td width="30%" align=left valign=top>
	<%
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

</body>
<script language="javascript">
function onlinks(years,months){
	location="CompensationTargetMaintView.jsp?subCompanyId=<%=subcompanyid%>&departmentid=<%=departmentid%>&CompensationYear="+years+"&CompensationMonth="+months;
}
</script>
</html>