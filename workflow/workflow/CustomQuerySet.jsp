<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ReportTypeComInfo" class="weaver.workflow.report.ReportTypeComInfo" scope="page" />
<jsp:useBean id="formComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="billComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="subCompInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>    
</head>
<%
if(!HrmUserVarify.checkUserRight("WorkflowCustomManage:All", user))
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(20773,user.getLanguage())+SystemEnv.getHtmlLabelName(19653,user.getLanguage());
String needfav ="1";
String needhelp ="";


String shortName = Util.null2String(request.getParameter("shortName"));
String otype=Util.null2String(request.getParameter("otype"));
String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel=0;
List subcompanyid2 = new ArrayList();
if(detachable==1)
{
	if(Util.getIntValue(subcompanyid,0)>0)
		operatelevel = checkSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowCustomManage:All", Util.getIntValue(subcompanyid,0));
	else
	{
		int tempsubcompanyid2[] = checkSubCompanyRight.getSubComByUserRightId(user.getUID(), "WorkflowCustomManage:All",2);
		if(null!=tempsubcompanyid2)
		{
			for(int i = 0;i<tempsubcompanyid2.length;i++)
			{
				subcompanyid2.add(""+tempsubcompanyid2[i]);
			}
		}
	}
}
else
{
	operatelevel = 2;
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javaScript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

if(operatelevel>1||subcompanyid2.size()>0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javaScript:doAdd(),_self} " ;
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

<form name="frmSearch" method="post">
	<table class="ViewForm">
	  <COLGROUP>
	  <COL width="20%">
	  <COL width="80%">
		<tr>
			<td>
			<%=SystemEnv.getHtmlLabelName(20773,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>
			</td>
			<td class="Field">
				<input type="text" name="shortName" class="inputStyle" value="<%=shortName%>">
			</td>
		</tr>
	</table>
</form>

<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="30%">
  <COL width="30%">
  <COL width="20%">
  <%if (detachable == 1){ %><COL align=left width="20%"><%} %>
  <TBODY>
  <TR class=Header>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(20773,user.getLanguage())%></TH></TR>
    <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(20773,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
    <%if (detachable == 1){ %><Td><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></Td><%} %><!-- 所属分部 -->
    </TR>
    <TR class=Line style="height:1px;" ><TD colspan="3" style="padding:0;"></TD></TR>

<%
	String sql="select * from workflow_custom where 1=1 ";
	if("".equals(shortName))
	{
		if(Util.getIntValue(otype,0)>0)
		{
			if(rs.getDBType().equals("oracle"))
			{
		  		sql+=" and nvl(QUERYTYPEID,0)="+Util.getIntValue(otype,0);
			}
			else
			{
				sql+=" and isnull(QUERYTYPEID,0)="+Util.getIntValue(otype,0);
			}
		}
		if(Util.getIntValue(subcompanyid,0)>0)
		{
			if(rs.getDBType().equals("oracle"))
			{
				sql+="and nvl(subcompanyid,0)="+Util.getIntValue(subcompanyid,0);
			}
			else
			{
				sql+="and isnull(subcompanyid,0)="+Util.getIntValue(subcompanyid,0);
			}
		}
	}
	else
		sql+=" and Customname like '%"+shortName+"%'";
	if(detachable==1)
	{
		if(user.getUID()!=1)
		{
			 //获取具有查看权限的所有机构
    		int[] subCompany = checkSubCompanyRight.getSubComByUserRightId(user.getUID(), "WorkflowCustomManage:All");
   			String subCompanyString="";
    		for(int j = 0; j < subCompany.length; j++)
			{
				subCompanyString += subCompany[j] + ",";
			}
			if(!"".equals(subCompanyString) && null != subCompanyString)
			{
				subCompanyString = subCompanyString.substring(0, subCompanyString.length() - 1);
			}
			if(!"".equals(subCompanyString) && null != subCompanyString)
			{
     			if(rs.getDBType().equals("oracle"))
   				{
     				sql+=" and subcompanyid in("+subCompanyString+")";
   				}
   				else
   				{
   					sql+=" and subcompanyid in("+subCompanyString+")";
   				}
      		}
      		else
      		{
      			sql+=" and 1=2 ";
      		}
		}
    }
    sql += "  order by Customname,id";
   	//out.println(sql);
    rs.executeSql(sql);
    int needchange = 0;
    while(rs.next())
    {
       try
       {
            String formID = Util.null2String(rs.getString("formID"));
			String formName = "";
			String isBill = Util.null2String(rs.getString("isBill"));
	        String Customname= Util.null2String(rs.getString("Customname"));
	        if(Customname.equals("")) Customname=SystemEnv.getHtmlLabelName(15863, user.getLanguage());
			if("0".equals(isBill))
			{
			    formName = formComInfo.getFormname(formID);
			}
			else if("1".equals(isBill))
			{
			    formName = SystemEnv.getHtmlLabelName(Util.getIntValue(billComInfo.getBillLabel(formID)), user.getLanguage());
			}
	       	if(needchange ==0)
	       	{
	       		needchange = 1;
%>
  <TR class=datalight>
  <%
		  	}else
		  	{
		  		needchange=0;
  %><TR class=datadark>
  <%  	
  			}
  %>
    <TD><a href="CustomEdit.jsp?id=<%=rs.getString("id")%>"><%=Customname%></a></TD>
    <TD><%=formName%></TD>
    <TD><%=rs.getString("Customdesc")%></TD>
    <%if (detachable == 1){ %><TD><%=Util.toScreen(subCompInfo.getSubCompanyname(rs.getString("subcompanyid")),user.getLanguage())%></TD><%} %>
  </TR>
<%
      }catch(Exception e){
        System.out.println(e.toString());
      }
    }
%>
 </TBODY>
 </TABLE>
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
<script type="text/javascript">
    function doSubmit(){
        enableAllmenu();
        document.frmSearch.submit();
    }
    function doAdd(){
        enableAllmenu();
      	<%if(detachable==1){%>
        location.href="/workflow/workflow/CustomQueryAdd.jsp?Querytypeid=<%=otype%>&subcompanyid=<%=subcompanyid%>";
        <%}else{%>
        location.href="/workflow/workflow/CustomQueryAdd.jsp?Querytypeid=<%=otype%>";
        <%}%>
    }
</script>

</BODY></HTML>