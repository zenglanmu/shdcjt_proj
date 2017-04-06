<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%


RecordSet.executeSql("select * from outter_sys");


String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(19667,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
String systemid = Util.null2String(request.getParameter("systemid"));
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="AccountOperation.jsp">
 <input type=hidden name=operate value="insert">
 <table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>
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
				<COLGROUP> <COL width="20%"> <COL width="80%">
                </colgroup>
                    <TBODY>
                <%while(RecordSet.next()){
                 String account ="";
                 String password="";
                 String logintype="1";%>
                <TR class=Title>
				  <TH colSpan=2><%=RecordSet.getString("name")+" "+SystemEnv.getHtmlLabelName(19667,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing style="height:2px">
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<%
				RecordSet1.executeSql("select * from outter_sys where sysid='"+RecordSet.getString("sysid")+"'");
				if(RecordSet1.next()){
                    int basetype1=Util.getIntValue(RecordSet1.getString("basetype1"),0);
					int basetype2=Util.getIntValue(RecordSet1.getString("basetype2"),0);
				 %>
				<tr>
                  <%  
                      RecordSet1.executeSql("select * from outter_account where sysid='"+RecordSet.getString("sysid")+"' and userid="+user.getUID());                    
                      if(RecordSet1.next()){                    
                              account=RecordSet1.getString("account");
                              password=RecordSet1.getString("password");
                              logintype=RecordSet1.getString("logintype");
                      }
                  %>
                  <td><%=SystemEnv.getHtmlLabelName(20970,user.getLanguage())%></td>
				  <td class=Field>
				  <%if(basetype1==0){%>
					<input  name=account_999_<%=RecordSet.getString("sysid")%>  value="<%=account%>" maxlength="50" style="width :50%" class="InputStyle">
			      <%}else{%>
				    <span><%=SystemEnv.getHtmlLabelName(20974,user.getLanguage())%><span>
				    <input  type=hidden name=account_999_<%=RecordSet.getString("sysid")%>  value="<%=account%>" maxlength="50" style="width :50%" class="InputStyle">
					<%}%>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				
                <tr>
				  <td><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></td>
				  <td class=Field>
				  <%if(basetype2==0){%>
					<input name=password_999_<%=RecordSet.getString("sysid")%> type=password value="<%=password%>" maxlength="50" style="width :50%" class="InputStyle">
					<%}else{%>
                    <span><%=SystemEnv.getHtmlLabelName(20975,user.getLanguage())%><span>
				    <input type=hidden name=password_999_<%=RecordSet.getString("sysid")%> type=password value="<%=password%>" maxlength="50" style="width :50%" class="InputStyle">
					<%}%>
				  </td>
				</tr>
                                <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
					<%}%>
				  <%
				RecordSet1.executeSql("select * from outter_sysparam where paramtype=1 and  sysid='"+RecordSet.getString("sysid")+"'");
				while(RecordSet1.next()){
                    String labelname=RecordSet1.getString("labelname");
					String paramname=RecordSet1.getString("paramname");
					String paramvalue="";
                    RecordSet2.executeSql("select * from outter_params where sysid='"+RecordSet.getString("sysid")+"'"+" and userid="+user.getUID()+" and paramname='"+paramname+"'");
					if(RecordSet2.next()) paramvalue=RecordSet2.getString("paramvalue");
				 %>
                  <tr>
				  <td><%=labelname%></td>
				  <td class=Field>			  
					<input name=<%=paramname+"_"+RecordSet.getString("sysid")%>  value="<%=paramvalue%>" maxlength="50" style="width :50%" class="InputStyle">
				  </td>
				</tr>
                                <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<%}%>
				  <tr>	
				  <td><%=SystemEnv.getHtmlLabelName(20971,user.getLanguage())%></td>                            
				  <td class=Field>
                      <select name=logintype_999_<%=RecordSet.getString("sysid")%> >
                          <option value="1" <%if(logintype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(20972,user.getLanguage())%></option>
                          <option value="2" <%if(logintype.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(20973,user.getLanguage())%></option>
                      </select>                  
				  </td>
				</tr> 

				
        <%}%> 

        </TBODY>
			 
        </TABLE>
	</td>
	</table>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

  </FORM>
</BODY>

<script language="javascript">
function onSubmit()
{
	frmMain.submit();
}

</script>
</HTML>
