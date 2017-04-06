<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
    boolean hasright = true;
    if (!HrmUserVarify.checkUserRight("Compensation:Manager", user)) {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
    int subcompanyid = Util.getIntValue(request.getParameter("subCompanyId"));
    int departmentid = Util.getIntValue(request.getParameter("departmentid"));
    String title = "";
    String sqlwhere = " where id=payid ";
    String subcompanystr = "";
    String departmentstr = "";
    String allrightcompany = SubCompanyComInfo.getRightSubCompany(user.getUID(), "Compensation:Manager", -1);
    ArrayList allrightcompanyid = Util.TokenizerString(allrightcompany, ",");
    if (departmentid > 0) {
        title = DepartmentComInfo.getDepartmentname("" + departmentid);
        subcompanyid = Util.getIntValue(DepartmentComInfo.getSubcompanyid1("" + departmentid));
        departmentstr=SubCompanyComInfo.getDepartmentTreeStr(""+departmentid)+departmentid;
        sqlwhere += " and departmentid in(" + departmentstr+")";
    } else if (subcompanyid > 0) {
        title = SubCompanyComInfo.getSubCompanyname("" + subcompanyid);
        subcompanystr = SubCompanyComInfo.getRightSubCompanyStr1("" + subcompanyid, allrightcompanyid);
        sqlwhere += " and departmentid in (select id from Hrmdepartment where subcompanyid1 in(" + subcompanystr + "))";
    } else {
        sqlwhere += " and 1=2";
    }
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
    int detachable = Util.getIntValue((String) session.getAttribute("detachable"));
    if (detachable == 1) {
        if (subcompanyid > 0) {
            int operatelevel = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "Compensation:Manager", subcompanyid);
            if (operatelevel == -1) {
                response.sendRedirect("/notice/noright.jsp");
                return;
            }
            if (operatelevel < 1) {
                hasright = false;
            }
        } else {
            hasright = false;
        }
    }

    String imagefilename = "/images/hdHRM.gif";
    String titlename = SystemEnv.getHtmlLabelName(19590, user.getLanguage()) + "：" + title;
    String needfav = "1";
    String needhelp = "";
    ArrayList yearslist = new ArrayList();
    ArrayList[] monthlist = null;
    ArrayList[] statuslist = null;
    String sql = "";
    if (rs.getDBType().equals("oracle")) {
        sql = "select distinct substr(paydate,1,4) payyear from HrmSalarypay ,HrmSalarypaydetail " + sqlwhere;
    } else {
        sql = "select distinct substring(paydate,1,4) payyear from HrmSalarypay ,HrmSalarypaydetail " + sqlwhere;
    }
//System.out.println(sql);
    rs.executeSql(sql);
    if (rs.next()) {
        if (rs.getCounts() > 0) {
            monthlist = new ArrayList[rs.getCounts()];
            statuslist = new ArrayList[rs.getCounts()];
        }
    }
    if (monthlist != null) {
        for (int i = 0; i < monthlist.length; i++) {
            monthlist[i] = new ArrayList();
            statuslist[i] = new ArrayList();
        }
        if (rs.getDBType().equals("oracle")) {
            sql = "select distinct substr(paydate,1,4) payyear,substr(paydate,6,8) paymonth,min(status) status from HrmSalarypay ,HrmSalarypaydetail " + sqlwhere + " group by substr(paydate,1,4) ,substr(paydate,6,8) order by substr(paydate,1,4) desc,substr(paydate,6,8) desc";
        } else {
            sql = "select distinct substring(paydate,1,4) payyear,substring(paydate,6,8) paymonth,min(status) status from HrmSalarypay ,HrmSalarypaydetail " + sqlwhere + " group by substring(paydate,1,4) ,substring(paydate,6,8) order by substring(paydate,1,4) desc,substring(paydate,6,8) desc";
        }
//System.out.println(sql);
        rs.executeSql(sql);
        while (rs.next()) {
            String tempyear = rs.getString("payyear");
            String tempmonth = rs.getString("paymonth");
            String status = rs.getString("status");
            if (status.equals("1")) {
                status = SystemEnv.getHtmlLabelName(309, user.getLanguage());
            } else {
                status = SystemEnv.getHtmlLabelName(360, user.getLanguage());
            }
            if (yearslist.indexOf(tempyear) == -1) {
                yearslist.add(tempyear);
            }
            monthlist[yearslist.size() - 1].add(tempmonth);
            statuslist[yearslist.size() - 1].add(status);
        }
    }
    int rownum = (yearslist.size() + 2) / 3;
//System.out.println("rownum:"+rownum);
%>
<body>

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
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
        <td width="33%" align=left valign=top>
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
		<ul><li><a href="javascript:onlinks('<%=yearslist.get(index)%>-<%=monthlist[index].get(m)%>');">
		<%=monthlist[index].get(m)%><%=SystemEnv.getHtmlLabelName(19398,user.getLanguage())%></a>(<%=statuslist[index].get(m)%>)</ul></li>
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
	</td><td width="33%" align=left valign=top>
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
function onlinks(yearmonth){
	location="HrmSalaryManageView.jsp?subCompanyId=<%=subcompanyid%>&departmentid=<%=departmentid%>&yearmonth="+yearmonth;
}
</script>
</html>