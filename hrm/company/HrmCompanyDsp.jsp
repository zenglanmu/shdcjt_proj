<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
String companyname = CompanyComInfo.getCompanyname(""+id);
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(140,user.getLanguage())+":"+companyname;
String needfav ="1";
String needhelp =""; 
boolean canEdit = false;
boolean canlinkbudget = HrmUserVarify.checkUserRight("SubBudget:Maint", user);
boolean canlinkexpense = HrmUserVarify.checkUserRight("FnaTransaction:All",user);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCompanyEdit:Edit", user)){
	canEdit = true;
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
    if(canlinkexpense){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(428,user.getLanguage())+",/fna/report/expense/FnaExpenseDetail.jsp?organizationid="+id+"&organizationtype=0,_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    }
    if( canlinkbudget ){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(386,user.getLanguage())+",/fna/budget/FnaBudgetView.jsp?organizationid="+id+"&organizationtype=0,_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    }
if(HrmUserVarify.checkUserRight("HrmCompany:Log", user)){

if(rs.getDBType().equals("db2")){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(140,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=10 and relatedid="+id+",_self} " ;
}
else{

RCMenu += "{"+SystemEnv.getHtmlLabelName(140,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=10 and relatedid="+id+",_self} " ;
}

RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{-}" ;
if(HrmUserVarify.checkUserRight("HrmSubCompanyAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(141,user.getLanguage())+",/hrm/company/HrmSubCompanyAdd.jsp?companyid="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmCompany:Log", user)){
    if(rs.getDBType().equals("db2")){
            RCMenu += "{"+SystemEnv.getHtmlLabelName(141,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)="+11+",_self} " ;

    }else{
    RCMenu += "{"+SystemEnv.getHtmlLabelName(141,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+11+",_self}" ;
    }
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
<FORM id=weaver name=frmMain action="HrmCompanyEdit.jsp" method=post >

  <TABLE class=ViewForm>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></TH></TR>
  <TR class= Spacing>
    <TD class=Line1 colSpan=2 ></TD></TR>
<%
  String sql = "select * from HrmCompany where id = "+ id;
  rs.executeSql(sql);
  while(rs.next()){
%>    
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
          <TD class=Field><%=rs.getString("companyname")%></TD>
        </TR>
              <TR><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
          <TD class=Field><%=rs.getString("companydesc")%></TD>
        </TR>
              <TR><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15768,user.getLanguage())%></TD>
          <TD class=Field><%=rs.getString("companyweb")%></TD>
        </TR>    
              <TR><TD class=Line colSpan=2></TD></TR> 
        <input class=inputStyle type=hidden name="id" value=<%=id%>>    
<%
}
%>        
 </TBODY>
 </TABLE>
 </form>
 

<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="20%">
  <COL width="60%">
  <COL width="20%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TH></TR>
   <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
  </TR>
    <TR class=Line><TD colspan="3" ></TD></TR> 

<%
    
      int needchange = 0;
      while(SubCompanyComInfo.next()){
      int companyid = Util.getIntValue(SubCompanyComInfo.getCompanyid(),0);
      if(companyid != id) continue;
      
      String caceledstate = "";
      String caceled = "";
      rs.executeSql("select canceled from HrmSubCompany where id = "+SubCompanyComInfo.getSubCompanyid());
      if(rs.next()) caceled = rs.getString("canceled");
      if("1".equals(caceled)){
    	   caceledstate = "<span><font color=\"red\">("+SystemEnv.getHtmlLabelName(22205,user.getLanguage())+")</font></span>";
      }    
      
       try{
       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <%  	}%>
    <TD><a href="/hrm/company/HrmSubCompanyEdit.jsp?id=<%=SubCompanyComInfo.getSubCompanyid()%>"><%=SubCompanyComInfo.getSubCompanyname()%></a><%=caceledstate %></TD>
    <TD><%=SubCompanyComInfo.getSubCompanydesc()%></TD>
    <TD><a href="/hrm/company/HrmDepartment.jsp?companyid=<%=companyid%>&subcompanyid=<%=SubCompanyComInfo.getSubCompanyid()%>"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></a></TD>
  </TR>
<%
      }catch(Exception e){
        System.out.println(e.toString());
      }
    }
%>
    
 </TBODY></TABLE> 
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
 frmMain.submit();
}
</script>

</BODY></HTML>
