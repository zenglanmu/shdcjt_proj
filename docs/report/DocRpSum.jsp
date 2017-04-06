<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.teechart.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="DocRpSum" class="weaver.docs.docs.DocRpSum" scope="page" />
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>

<%
    String optional=Util.null2String(request.getParameter("optional"));
    int lableid=0;
    if  ("t1.doccreaterid".equals(optional)) lableid=271;
    else if  ("t1.crmid".equals(optional)) lableid=136;
    else if  ("t1.hrmresid".equals(optional)) lableid=1867;
    else if  ("t1.projectid".equals(optional)) lableid=1353;
    else if  ("t1.docdepartmentid".equals(optional)) lableid=15390;
    else if  ("t1.doclangurage".equals(optional)) lableid=231;

    String imagefilename = "/images/hdReport.gif";
    String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(lableid,user.getLanguage());
    String needfav ="1";
    String needhelp =""; 
    int total=0;
    int linecolor=0;
    char separator = Util.getSeparator() ; 
    int userid=user.getUID();
%>

<BODY>
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

            <TABLE class=ListStyle width="100%" cellspacing=1>
              <COLGROUP>
              <COL align=left width="15%">
              <COL align=left width="19%">
              <COL align=right width="7%">
              <COL align=right width="10%">
              <COL align=left width="19%">
              <COL align=right width="7%">
              <COL align=right width="9%">
              <COL align=right width="6%">
              <COL align=right width="9%">
              <TBODY>
              <TR class=header>
                <TH colspan=9><%=SystemEnv.getHtmlLabelName(356,user.getLanguage())%></TH>
              </TR>
              <TR class=Header>
                <TH><nobr><%=SystemEnv.getHtmlLabelName(lableid,user.getLanguage())%></TH>
                <TH><nobr><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TH>
                <TH><nobr><%=SystemEnv.getHtmlLabelName(363,user.getLanguage())%></TH>
                <TH>%</TH>
                <TH><nobr><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%> - <%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></TH>
                <TH><nobr><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></TH>
                <TH>%</TH>
                <TH><nobr><%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></TH>
                <TH>%</TH></TR>
            <TR class=Line><TD colSpan=9></TD></TR>
                <% 
                ArrayList resultList=DocRpSum.getDocRpSumList(optional,user);
				PieTeeChart pie=null;
                if(resultList.size()!=0){
                for(int i=0;i<resultList.size();i++){     
                    ArrayList tempList=(ArrayList)resultList.get(i);  
                    int resultcount = Util.getIntValue((String)tempList.get(1),0);
                    total+=resultcount;
                }
				/****************************************/
				pie=TeeChartFactory.createPieChart(SystemEnv.getHtmlLabelName(lableid,user.getLanguage()),700,400,PieTeeChart.SMS_LabelPercent);
				//pie.isDebug();
				
				/**该句表示，是项目统计的话，默认转换为柱状图*/
				if("t1.projectid".equals(optional)) pie.setExternalJs("WeaverChart.changeSeiesType(1,'"+pie.getObjectId()+"');");
				
				/*****************************************************/
                for(int i=0;i<resultList.size();i++){           
                      ArrayList tempList=(ArrayList)resultList.get(i);
                      String resultid = (String)tempList.get(0);        
                      int resultcount = Util.getIntValue((String)tempList.get(1),0);
                      int replycount=Util.getIntValue((String)tempList.get(2),0);
                      int normalcount=resultcount-replycount;
                      float resultpercent=(float)resultcount*100/(float)total;
                      resultpercent=(float)((int)(resultpercent*100))/100;
                      float normalpercent=(float)normalcount*100/(float)resultcount;
                      normalpercent=(float)((int)(normalpercent*100))/100;
                      float replypercent=(float)replycount*100/(float)resultcount;
                      replypercent=(float)((int)(replypercent*100))/100;
						float resultpercentOfwidth=0;
						resultpercentOfwidth = resultpercent;
						if(resultpercentOfwidth<1&&resultpercentOfwidth>0) resultpercentOfwidth=1;
                %>
              <TR <%if(linecolor%2==0){%>class=datalight <%} else {%> class=datadark <%}%>>
                <TD>
               
                <%
                String showname="";
                if  ("t1.doccreaterid".equals(optional)) showname=ResourceComInfo.getResourcename(resultid);
                else if  ("t1.crmid".equals(optional)) showname=CustomerInfoComInfo.getCustomerInfoname(resultid);
                else if  ("t1.hrmresid".equals(optional)) showname=ResourceComInfo.getResourcename(resultid);
                else if  ("t1.projectid".equals(optional)) showname=ProjectInfoComInfo.getProjectInfoname(resultid);
                else if  ("t1.docdepartmentid".equals(optional)) showname=DepartmentComInfo.getDepartmentname(resultid);
                else if  ("t1.doclangurage".equals(optional)) showname=LanguageComInfo.getLanguagename(resultid);              
				pie.addSeries(showname,resultcount);//添加饼图项
                %>
                <%=showname%>                
                </TD>
               <TD>
                  <TABLE height="100%" cellSpacing=0 width="100%">
                    <TBODY>
                    <TR>
                        <TD class=redgraph width="<%=resultpercentOfwidth%>%">&nbsp;</TD>
                        <TD width="<%=1-resultpercent%>%">&nbsp;</TD>
                     </TR>
                    </TBODY>
                   </TABLE>
                 </TD>
                <TD><%=resultcount%></TD>
                <TD><%=resultpercent%>%</TD>
               <TD>
                  <TABLE height="100%" cellSpacing=0 width="100%">
                    <TBODY>
                    <TR>
                      <TD class=bluegraph width="<%=normalpercent%>%" <%if(normalpercent==0.0) out.println("style='display:none'");%>>&nbsp;</TD>
                      <TD class=greengraph width="<%=replypercent%>%" <%if(replypercent==0.0) out.println("style='display:none'");%>>&nbsp;</TD>          
                     </TR>
                    </TBODY>
                   </TABLE>
                 </TD>
                <TD><%=normalcount%></TD>
                <TD><%=normalpercent%>%</TD>
                <TD><%=replycount%></TD>
                <TD><%=replypercent%>%</TD></TR>
              <% 
                 }
              }
              %>
              </TBODY></TABLE>  
		<div class="chart">
		<%
		if ("true".equals(isIE)){
			if(pie!=null)pie.print(out);
		}else{   %>
		<p height="100%" width="100%" align="center" style="color:red;font-size:14px;">
					您当前使用的浏览器不支持【报表视图】，如需使用该功能，请使用IE浏览器！
		</p>
		<%} %>	
		<br>
		</div> 
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
</BODY>
</HTML>
