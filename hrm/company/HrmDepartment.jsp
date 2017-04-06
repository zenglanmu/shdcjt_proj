<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
int companyid = Util.getIntValue(request.getParameter("companyid"),1);
int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),0);

String canceled = "";
rs.executeSql("select canceled from HrmSubCompany where id="+subcompanyid);
if(rs.next()){
 canceled = rs.getString("canceled");
}

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String nowdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(140,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(124,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmDepartmentAdd:Add", user) && ("0".equals(canceled) || "".equals(canceled))){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/company/HrmDepartmentAdd.jsp?subcompanyid="+subcompanyid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(HrmUserVarify.checkUserRight("HrmDepartment:Log", user)){
    if(rs.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(124,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)="+12+",_self} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(124,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+12+",_self} " ;
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
<FORM id=weaver name=frmMain action="HrmDepartment.jsp" method=post>
<TABLE class=Viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="30%">
  <COL width="20%">
  <COL width="30%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></TH></TR>
  <TR class=Spacing style="height:2px">
    <TD class=line1 colSpan=4 ></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></TD>
          <TD class=Field>
          <%
          while(CompanyComInfo.next()){
            String companyname = "";
            String curid = CompanyComInfo.getCompanyid();
            if(Util.getIntValue(curid,0)==companyid){
              companyname = CompanyComInfo.getCompanyname();
            }
          %>
             <a href="/hrm/company/HrmCompanyEdit.jsp?id=<%=companyid%>"><%= companyname%></a>
           <%
           }
           %>
<!--           <select class=inputStyle name="companyid" >
           <%
           while(CompanyComInfo.next()){
           	String isselected = "";
           	String curid = CompanyComInfo.getCompanyid();
           	String curname = CompanyComInfo.getCompanyname();
           	if(Util.getIntValue(curid,0)==companyid)
           		isselected=" selected";
           %>
           <option value="<%=curid%>" <%=isselected%>><%=curname%></option>
           <%}%>
           </select>-->
          </TD>
  </TR>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
 </TBODY>
 </TABLE>

 </form>

 <br>

<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="50%">
  <COL width="50%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TH></TR>

  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>

  </TR>
<%

    int needchange = 0;
    int hasshowrow = 0;
    while(SubCompanyComInfo.next()){
    	int isfirst = 1;
    	String tmpcompanyid = SubCompanyComInfo.getCompanyid().trim();
    	if(Util.getIntValue(tmpcompanyid,0)!=companyid) continue;

    	String tmpid = SubCompanyComInfo.getSubCompanyid().trim();
    	if(subcompanyid!=0 && Util.getIntValue(tmpid,0)!=subcompanyid) continue;
        String tmpname = SubCompanyComInfo.getSubCompanyname();
      while(DepartmentComInfo.next()){
      	String cursubcompanyid = "";
      	if(companyid==1)
      		cursubcompanyid = DepartmentComInfo.getSubcompanyid1();

      	if(!tmpid.equals(cursubcompanyid)) continue;


       try{
    	    String caceledstate = "";
	        String caceled = "";
	        rs.executeSql("select canceled from HrmDepartment where id = "+DepartmentComInfo.getDepartmentid());
	        if(rs.next()) caceled = rs.getString("canceled");
	        if("1".equals(caceled))
	        {
	      	   caceledstate = "<span><font color=\"red\">("+SystemEnv.getHtmlLabelName(22205,user.getLanguage())+")</font></span>";
	        }
       		if(needchange ==0){
       			needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <%  	}%>
    <TD><a href="/hrm/company/HrmSubCompanyEdit.jsp?id=<%=cursubcompanyid%>"><%=isfirst==1?tmpname:""%></a></TD>
    <TD><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=DepartmentComInfo.getDepartmentid()%>"><%=DepartmentComInfo.getDepartmentmark()%></a><%=caceledstate %></TD>    
  </TR>
<%isfirst=0;
hasshowrow=1;
      }catch(Exception e){
        System.out.println(e.toString());
      }
    }
%>
<%}%>
 </TBODY></TABLE>
 <BR>
 <%
if(hasshowrow==0){
%>
<DIV class=HdrProps><font color=red>
<%=SystemEnv.getHtmlNoteName(12,user.getLanguage())%></font>
</DIV>
<%}%>

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

</BODY></HTML>
