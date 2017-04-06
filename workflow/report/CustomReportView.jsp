<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ReportTypeComInfo" class="weaver.workflow.report.ReportTypeComInfo" scope="page" />
<jsp:useBean id="ReportComInfo" class="weaver.workflow.report.ReportComInfo" scope="page" />
<jsp:useBean id="ReportShare" class="weaver.workflow.report.ReportShare" scope="page" />
<%

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(15101,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(16532,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17615,user.getLanguage());
String needfav ="1";
String needhelp ="";

int userid=0;
userid=user.getUID();

if(userid > 1) {
    RecordSet.executeSql("select departmentid,seclevel from hrmresource where id="+userid);
	if(RecordSet.next()) {
	   ReportShare.SetNewHrmReportShare(""+userid,RecordSet.getString("departmentid"),RecordSet.getString("seclevel"));
	}	
}

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <link href="/css/Weaver.css" type=text/css rel=stylesheet>
  </head>
  
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
			
			<TABLE class="Shadow">
			<tr>
			<td valign="top">

		<TABLE class=ListStyle cellspacing=1>
		<COLGROUP>
		<COL width="50%">
        <COL width="50%">


		<TR class=Header>
			<TH colspan=2><%=SystemEnv.getHtmlLabelName(17615,user.getLanguage())%></TH>
		</TR>

        <TR class=Header>
            <TD><%=SystemEnv.getHtmlLabelName(15434,user.getLanguage())%></TD>
            <TD><%=SystemEnv.getHtmlLabelName(15517,user.getLanguage())%></TD>
        </TR>
		
        <TR class=Line>
			<TD colSpan=3></TD>
		</TR>	

			<%
			ArrayList hasrightreports = new ArrayList() ;
			ArrayList hasrightreportsbytypes = new ArrayList() ;
                           
            String sql = "select reportid from WorkflowReportShareDetail where userid="+user.getUID()+" and usertype=1 ";
			RecordSet.executeSql(sql);

			while(RecordSet.next()) {
				String tempreportid = Util.null2String(RecordSet.getString(1)) ;
				hasrightreports.add(tempreportid) ;
			}
			String linkStr = "" ;
			String linkName = "" ;
			String trClass="DataLight";
			ReportTypeComInfo.setTofirstRow() ;
			while(ReportTypeComInfo.next()) {
				hasrightreportsbytypes.clear() ;
				ReportComInfo.setTofirstRow() ;
				while(ReportComInfo.next(ReportTypeComInfo.getReportTypeid())) {
					String tempreportid = ReportComInfo.getReportid() ;
			        if(hasrightreports.indexOf(tempreportid) < 0) continue ;
						hasrightreportsbytypes.add(tempreportid) ;
				}	
				if(hasrightreportsbytypes.size() == 0)  {
					continue ;
				}
                String typeName = Util.toScreen(ReportTypeComInfo.getReportTypename(),user.getLanguage());
				for(int i = 0 ; i< hasrightreportsbytypes.size() ; i++) {	
                        

            %>
                    <TR class=<%=trClass%>>
                        <TD><%=typeName%>
                        </TD>
			            <TD><a href="/workflow/report/ReportCondition.jsp?id=<%=hasrightreportsbytypes.get(i)%>"><%=Util.toScreen(ReportComInfo.getReportname((String)hasrightreportsbytypes.get(i)),user.getLanguage())%></a>
                        </TD>
		            </TR>
            <%
			          typeName = "";
					  if(trClass.equals("DataLight")){
						  trClass="DataDark";
				      }else{
						  trClass="DataLight";
				      }
				} 
            }
			%>
			
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
    
  </body>
</html>
