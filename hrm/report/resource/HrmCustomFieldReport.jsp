<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.systeminfo.menuconfig.HrmCustomField" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ReportTypeComInfo" class="weaver.workflow.report.ReportTypeComInfo" scope="page" />
<jsp:useBean id="ReportComInfo" class="weaver.workflow.report.ReportComInfo" scope="page" />
<%

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(16530,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17602,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17088,user.getLanguage());
String needfav ="1";
String needhelp ="";

int userid=0;
userid=user.getUID();

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
			<TH colspan=2><%=SystemEnv.getHtmlLabelName(17088,user.getLanguage())%></TH>
		</TR>

        <TR class=Header>
            <TD><%=SystemEnv.getHtmlLabelName(15434,user.getLanguage())%></TD>
            <TD><%=SystemEnv.getHtmlLabelName(15517,user.getLanguage())%></TD>
        </TR>
		
			<%
			ArrayList parentFields = new ArrayList() ;
                           
            String sql = "SELECT id , parentId , formLabel " +
                          " FROM cus_treeform " +
                          "WHERE scope= 'HrmCustomFieldByInfoType' " +
                          "  AND parentid = 0 ";
			RecordSet.executeSql(sql);

			while(RecordSet.next()) {
				int id = RecordSet.getInt("id") ;
                int parentId = RecordSet.getInt("parentId") ;
                String formLabel = Util.null2String(RecordSet.getString("formLabel")) ;
				
                HrmCustomField field = new HrmCustomField(id);
                field.setParentId(parentId);
                field.setFormLabel(formLabel);

                parentFields.add(field);
			}
            %>
            <%
            for(int i=0;i<parentFields.size();i++){
                HrmCustomField parentField = (HrmCustomField)parentFields.get(i);

                int parentId = parentField.getId();
                String parentFormLabel = parentField.getFormLabel();
                
                sql = "SELECT id , parentId , formLabel " +
                          " FROM cus_treeform " +
                      "    WHERE viewtype = '1' " +
                    "        AND parentid = " + parentId;

                RecordSet.executeSql(sql);

                int j=0;
                while(RecordSet.next()) {
                    j++;
                    int id = RecordSet.getInt("id") ;
                    String formLabel = Util.null2String(RecordSet.getString("formLabel")) ;

                    if((j%2)==1){
            %>
        <TR class=DataDark>
            <%      }else{      
            %>
        <TR class=DataLight>
            <%      }
            %>
        <TD><%=parentFormLabel%>
        </TD>
		<TD><a href="/hrm/report/resource/HrmRpSubSearch.jsp?scopeid=<%=id%>"><%=formLabel%></a>
        </TD>
		</TR>
            <%      
                parentFormLabel = "";
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
