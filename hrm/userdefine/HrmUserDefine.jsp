<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
int userid = user.getUID();
boolean flagaccount = weaver.general.GCONST.getMOREACCOUNTLANDING();//账号类型
boolean issys = false;
boolean isfin = false;
boolean ishr  = false;

String sql = "select hrmid from HrmInfoMaintenance where id = 1";
rs.executeSql(sql);
while(rs.next()){
  int hrmid = Util.getIntValue(rs.getString(1));
  if(userid == hrmid){
    issys = true;
    break;
  }
}
sql = "select hrmid from HrmInfoMaintenance where id = 2";
rs.executeSql(sql);
while(rs.next()){
  int hrmid = Util.getIntValue(rs.getString(1));
  if(userid == hrmid){
    isfin = true;
    break;
  }
}
if(HrmUserVarify.checkUserRight("HrmResourceAdd:Add",user)) {
  ishr = true;
}

String hasresourceid="";
String hasresourcename="";
String hasjobtitle    ="";
String hasactivitydesc="";
String hasjobgroup    ="";
String hasjobactivity ="";
String hascostcenter  ="";
String hascompetency  ="";
String hasresourcetype="";
String hasstatus      ="";
String hassubcompany  ="";
String hasdepartment  ="";
String haslocation    ="";
String hasmanager     ="";
String hasassistant   ="";
String hasroles       ="";
String hasseclevel    ="";
String hasjoblevel    ="";
String hasworkroom    ="";
String hastelephone   ="";
String hasstartdate   ="";
String hasenddate     ="";
String hascontractdate="";
String hasbirthday    ="";
String hassex         ="";
String hasaccounttype = "";
String hasage         ="";
String projectable    ="";
String crmable        ="";
String itemable       ="";
String docable        ="";
String workflowable   ="";
String subordinateable="";
String trainable      ="";
String budgetable     ="";
String fnatranable    ="";
String dspperpage     ="";
String workplanable   ="";

String hasworkcode = "";
String hasjobcall = "";
String hasmobile = "";
String hasmobilecall = "";
String hasfax = "";
String hasemail = "";
String hasfolk = "";
String hasnativeplace = "";
String hasregresidentplace = "";
String hasmaritalstatus = "";
String hascertificatenum = "";
String hastempresidentnumber = "";
String hasresidentplace = "";
String hashomeaddress = "";
String hashealthinfo = "";
String hasheight = "";
String hasweight = "";
String haseducationlevel = "";
String hasdegree = "";
String hasusekind = "";
String haspolicy = "";
String hasbememberdate = "";
String hasbepartydate = "";
String hasislabouunion = "";
String hasbankid1 = "";
String hasaccountid1 = "";
String hasaccumfundaccount = "";
String hasloginid = "";
String hassystemlanguage = "";

RecordSet.executeProc("HrmUserDefine_SelectByID",""+userid);

if(RecordSet.next()){
       hasresourceid=RecordSet.getString("hasresourceid");
       hasresourcename=RecordSet.getString("hasresourcename");
       hasjobtitle    =RecordSet.getString("hasjobtitle");
       hasactivitydesc=RecordSet.getString("hasactivitydesc");
       hasjobgroup    =RecordSet.getString("hasjobgroup");
       hasjobactivity =RecordSet.getString("hasjobactivity");
       hascostcenter  =RecordSet.getString("hascostcenter");
       hascompetency  =RecordSet.getString("hascompetency");
       hasresourcetype=RecordSet.getString("hasresourcetype");
       hasstatus      =RecordSet.getString("hasstatus");
       hassubcompany  =RecordSet.getString("hassubcompany");
       hasdepartment  =RecordSet.getString("hasdepartment");
       haslocation    =RecordSet.getString("haslocation");
       hasmanager     =RecordSet.getString("hasmanager");
       hasassistant   =RecordSet.getString("hasassistant");
       hasroles       =RecordSet.getString("hasroles");
       hasseclevel    =RecordSet.getString("hasseclevel");
       hasjoblevel    =RecordSet.getString("hasjoblevel");
       hasworkroom    =RecordSet.getString("hasworkroom");
       hastelephone   =RecordSet.getString("hastelephone");
       hasstartdate   =RecordSet.getString("hasstartdate");
       hasenddate     =RecordSet.getString("hasenddate");
       hascontractdate=RecordSet.getString("hascontractdate");
       hasbirthday    =RecordSet.getString("hasbirthday");
       hassex         =RecordSet.getString("hassex");
       hasaccounttype = RecordSet.getString("hasaccounttype");
       hasage         =RecordSet.getString("hasage");
       projectable    =RecordSet.getString("projectable");
       crmable        =RecordSet.getString("crmable");
       itemable       =RecordSet.getString("itemable");
       docable        =RecordSet.getString("docable");
       workflowable   =RecordSet.getString("workflowable");
       subordinateable=RecordSet.getString("subordinateable");
       trainable      =RecordSet.getString("trainable");
       budgetable     =RecordSet.getString("budgetable");
       fnatranable    =RecordSet.getString("fnatranable");
       dspperpage     =RecordSet.getString("dspperpage");
       workplanable   =RecordSet.getString("workplanable");
       
	 hasworkcode = RecordSet.getString("hasworkcode");
	 hasjobcall = RecordSet.getString("hasjobcall");
	 hasmobile = RecordSet.getString("hasmobile");
	 hasmobilecall = RecordSet.getString("hasmobilecall");
	 hasfax = RecordSet.getString("hasfax");
	 hasemail = RecordSet.getString("hasemail");
	 hasfolk = RecordSet.getString("hasfolk");
	 hasnativeplace = RecordSet.getString("hasnativeplace");
	 hasregresidentplace = RecordSet.getString("hasregresidentplace");
	 hasmaritalstatus = RecordSet.getString("hasmaritalstatus");
	 hascertificatenum = RecordSet.getString("hascertificatenum");
	 hastempresidentnumber = RecordSet.getString("hastempresidentnumber");
	 hasresidentplace = RecordSet.getString("hasresidentplace");
	 hashomeaddress = RecordSet.getString("hashomeaddress");
	 hashealthinfo = RecordSet.getString("hashealthinfo");
	 hasheight = RecordSet.getString("hasheight");
	 hasweight = RecordSet.getString("hasweight");
	 haseducationlevel = RecordSet.getString("haseducationlevel");
	 hasdegree = RecordSet.getString("hasdegree");
	 hasusekind = RecordSet.getString("hasusekind");
	 haspolicy = RecordSet.getString("haspolicy");
	 hasbememberdate = RecordSet.getString("hasbememberdate");
	 hasbepartydate = RecordSet.getString("hasbepartydate");
	 hasislabouunion = RecordSet.getString("hasislabouunion");
	 hasbankid1 = RecordSet.getString("hasbankid1");
	 hasaccountid1 = RecordSet.getString("hasaccountid1");
	 hasaccumfundaccount = RecordSet.getString("hasaccumfundaccount");
	 hasloginid = RecordSet.getString("hasloginid");
	 hassystemlanguage = RecordSet.getString("hassystemlanguage");

}

String ischecked = "";

String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(343,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/search/HrmResourceSearch.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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


<FORM id=weaver name=frmMain action="UserDefineOperation.jsp" method=post>

<TABLE cellSpacing=0 cellPadding=0 width="100%">
  <TBODY>
  <TR>
    <TD vAlign=top width="84%">
        <TABLE class=ViewForm width="100%">
          <COLGROUP> <COL width="49%"> <COL width=24> <COL width="49%"> <TBODY> 
          <TR class=Title> 
            <TH colSpan=3><%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
          </TR>
          <TR class=Spacing style="height:2px"> 
            <TD class=Line1 colSpan=3></TD>
          </TR>
          <TR> 
            <TD vAlign=top width="41%"> 
              <TABLE>
<!--                <tr> 
                  <td>标识</td>
                  <td> 
                  <%
                  ischecked = "";
                  if(hasresourceid.equals("1"))
                  	ischecked = " checked";
                  %>
                    <input type=checkbox name=hasresourceid value=1 <%=ischecked%>>
                  </td>
                </tr>
-->                
                <tr> 
                  <td> 
				  <%
                  ischecked = "";
                  if(hasworkcode.equals("1"))
                  	ischecked = " checked";
                  %>
				  <input type=checkbox name=hasworkcode value=1 <%=ischecked%>></td> 
                  
                  <td><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
                </tr> 
				
                <tr> 
                  <td>
				  <%
                  ischecked = "";
                  if(hasresourcename.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasresourcename value=1 <%=ischecked%>></td>
                  
				  <td><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td>     
                </tr>

                <tr>  
                  <td>
				  <%
                  ischecked = "";
                  if(hassex.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hassex value=1 <%=ischecked%>></td>
                  
				  <td><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></td>
                </tr>   
				<%if(flagaccount) {%>
				<tr>  
                  <td>
				  <%
                  ischecked = "";
                  if(hasaccounttype.equals("1"))
                	  ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasaccounttype value=1 <%=ischecked%>></td>
                  
				  <td><%=SystemEnv.getHtmlLabelName(17745,user.getLanguage())%></td>
                </tr> 
				<%}%>
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasdepartment.equals("1"))
                  	ischecked = " checked";
                  %>  
				  <input type=checkbox name=hasdepartment value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
                   
                  
                </tr>                 
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hassubcompany.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hassubcompany value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
                    
                  
                </tr>
<!--                
                 <tr> 
                  <td class=Field>成本中心</td>
                  <td> 
                  <%
                  ischecked = "";
                  if(hascostcenter.equals("1"))
                  	ischecked = " checked";
                  %>
                    <input type=checkbox name=hascostcenter value=1 <%=ischecked%>>
                  </td>
                </tr>
-->                
                <!--
                  <tr> 
                  <td><%=SystemEnv.getHtmlLabelName(384,user.getLanguage())%></td>
                  <td> 
                  <%
                  ischecked = "";
                  if(hascompetency.equals("1"))
                  	ischecked = " checked";
                  %>
                    <input type=checkbox name=hascompetency value=1 <%=ischecked%>>
                  </td>
                </tr>
                <tr> 
                  <td>类型</td>
                  <td> 
                  <%
                  ischecked = "";
                  if(hasresourcetype.equals("1"))
                  	ischecked = " checked";
                  %>
                    <input type=checkbox name=hasresourcetype value=1 <%=ischecked%>>
                  </td>
                </tr>
-->             
<%
//  if(ishr){
%>
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasstatus.equals("1"))
                  	ischecked = " checked";
                  %>  
				  <input type=checkbox name=hasstatus value=1 <%=ischecked%>></td>
                  
                  <td><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
                   
                </tr>                
<%
//  }
%>                
                </TBODY> 
              </TABLE>
            </TD>
            <TD valign="top" width="38%"> 
              <table> 
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasjobtitle.equals("1"))
                  	ischecked = " checked";
                  %>  
				  <input type=checkbox name=hasjobtitle value=1 <%=ischecked%>> </td>
                  <td><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></td>
                </tr>                                                                 
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasactivitydesc.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasactivitydesc value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(15856,user.getLanguage())%></td>
                    
                  
                </tr>               
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasjobgroup.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasjobgroup value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(15854,user.getLanguage())%></td>
                    
                 
                </tr>
                 <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasjobactivity.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasjobactivity value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></td>
                    
                  
                </tr>                
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasjobcall.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasjobcall value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(806,user.getLanguage())%></td>
                    
                  
                </tr>                
                </tr>
                 <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasjoblevel.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasjoblevel value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(1909,user.getLanguage())%></td>
                    
                 
                </tr>                 
                <tr> 
                  
                  <td> <input type=checkbox name=hasmanager value=1 <%=ischecked%>> </td>
				  <%
                  ischecked = "";
                  if(hasmanager.equals("1"))
                  	ischecked = " checked";
                  %>
				  
                  <td><%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%></td>

                </tr>
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasassistant.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasassistant value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(441,user.getLanguage())%></td>
                    
                  
                 <colgroup> <col width="40%"> <col width="60%"> <tbody> </tbody> 
              </table>
            </TD>
            <TD vAlign=top align=left width="21%"> 
              <TABLE>
                <COLGROUP> <COL width="20%"> <COL width="80%"> <TBODY> 
                 <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(haslocation.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=haslocation value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(15712,user.getLanguage())%></td>
                </tr>                
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasworkroom.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasworkroom value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%></td>
                    
                  
                </tr>                
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hastelephone.equals("1"))
                  	ischecked = " checked";
                  %>
				  <input type=checkbox name=hastelephone value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(15713,user.getLanguage())%></td>
                    
                  
                </tr>
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasmobile.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasmobile value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></td>
                    
                  
                </tr>         
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasmobilecall.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasmobilecall value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(15714,user.getLanguage())%></td>
                    
                  
                </tr>             
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasfax.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasfax value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></td>
                    
                  
                </tr>
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasemail.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasemail value=1 <%=ischecked%>></td>
                  <td>E-mail</td>
                    
                  
                </tr>                          
                 </TBODY> 
              </TABLE>
            </TD>
          </TR>
<%
  if(software.equals("ALL") || software.equals("HRM")){
     if(ishr){
%>          
          <tr class=Title> 
            <th colspan=3><%=SystemEnv.getHtmlLabelName(15687,user.getLanguage())%></th>
          </tr>
          <!--tr class=Spacing> 
            <td class=Sep3 colspan=3></td>
          </tr-->
		  <TR class=Spacing style="height:2px"> 
            <TD class=Line1 colSpan=3></TD>
          <tr> 
            <td valign=top align=left width="41%"> 
              <table width="143">
                <colgroup> <col width="20%"> <col width="80%"> <tbody> 
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasbirthday.equals("1"))
                  	ischecked = " checked";
                  %>
				  <input type=checkbox name=hasbirthday value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(464,user.getLanguage())%></td>
                    
                  
                </tr>                               
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasage.equals("1"))
                  	ischecked = " checked";
                  %>
				  <input type=checkbox name=hasage value=1 <%=ischecked%>>
                  <td><%=SystemEnv.getHtmlLabelName(671,user.getLanguage())%></td>
                    
                  </td>
                </tr>                                
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasfolk.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasfolk value=1 <%=ischecked%>>
                  <td><%=SystemEnv.getHtmlLabelName(1886,user.getLanguage())%></td>
                    
                  </td>
                </tr>
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasnativeplace.equals("1"))
                  	ischecked = " checked";
                  %>
				  <input type=checkbox name=hasnativeplace value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(1840,user.getLanguage())%></td>
                    
                  
                </tr>
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasregresidentplace.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasregresidentplace value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(15683,user.getLanguage())%></td>
                    
                  
                </tr>
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasmaritalstatus.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasmaritalstatus value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></td>
                    
                  
                </tr>         
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hascertificatenum.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hascertificatenum value=1 <%=ischecked%>>
                  <td><%=SystemEnv.getHtmlLabelName(1887,user.getLanguage())%></td>
                    
                  </td>
                </tr>       
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hastempresidentnumber.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hastempresidentnumber value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(15685,user.getLanguage())%></td>
                    
                 
                </tr>                                
                </tbody> 
              </table>
            </td>
            <td width="38%" valign="top"> 
              <table width="152">
                <colgroup> <col width="20%"> <col width="80%"> <tbody> 
                 <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasresidentplace.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasresidentplace value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(1829,user.getLanguage())%></td>
                    
                  
                </tr>
              <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hashomeaddress.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hashomeaddress value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(16018,user.getLanguage())%></td>
                    
                  
                </tr>
               <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hashealthinfo.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hashealthinfo value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(1827,user.getLanguage())%></td>
                    
                  
                </tr>
		<tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasheight.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasheight value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(1826,user.getLanguage())%></td>
                    
                  
                </tr>
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasweight.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasweight value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(15674,user.getLanguage())%></td>
                    
                  
                </tr>     
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(haseducationlevel.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=haseducationlevel value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></td>
                    
                  
                </tr>     
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasdegree.equals("1"))
                  	ischecked = " checked";
                  %>
				  <input type=checkbox name=hasdegree value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(1833,user.getLanguage())%></td>
                    
                  
                </tr>     
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasusekind.equals("1"))
                  	ischecked = " checked";
                  %>
				  <input type=checkbox name=hasusekind value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(804,user.getLanguage())%></td>
                    
                  
                </tr>
<!--                                                                 
                <tr> 
                  <td class=Field>人力资源类型</td>
                  <td> 
                  <%
                  ischecked = "";
                  if(workflowable.equals("1"))
                  	ischecked = " checked";
                  %>
                    <input type=checkbox name=workflowable value=1 <%=ischecked%>>
                  </td>
                </tr>                                                                 
-->                
                </tbody> 
              </table>
            </td>
            <td width="38%" valign="top"> 
              <table width="152">
                <colgroup> <col width="20%"> <col width="80%"> <tbody> 
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(haspolicy.equals("1"))
                  	ischecked = " checked";
                  %>
				  <input type=checkbox name=haspolicy	 value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(1837,user.getLanguage())%></td>
                    
                  
                </tr>
                 <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasbememberdate.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasbememberdate value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(1834,user.getLanguage())%></td>
                    
                  
                </tr>                
               <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasbepartydate.equals("1"))
                  	ischecked = " checked";
                  %>
				  <input type=checkbox name=hasbepartydate value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(1835,user.getLanguage())%></td>
                    
                  
                </tr>                
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasroles.equals("1"))
                  	ischecked = " checked";
                  %>
				  <input type=checkbox name=hasroles value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></td>
                    
                  
                </tr>                
                
               <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasislabouunion.equals("1"))
                  	ischecked = " checked";
                  %>
				  <input type=checkbox name=hasislabouunion value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(15684,user.getLanguage())%></td>
                    
                  
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasstartdate.equals("1"))
                  	ischecked = " checked";
                  %>
				  <input type=checkbox name=hasstartdate value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(1970,user.getLanguage())%></td>
                    
                  
                </tr>
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasenddate.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasenddate value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(15236,user.getLanguage())%></td>
                    
                  
                </tr>
                
                
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hascontractdate.equals("1"))
                  	ischecked = " checked";
                  %>
				  <input type=checkbox name=hascontractdate value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(15778,user.getLanguage())%></td>
                    
                  
                </tr>                
               
                </tbody> 
              </table>
            </td>            
            <td width="21%">&nbsp; </td>
          </tr>
<%
}
%>
<%
  if(isgoveproj==0){
  if( ishr || isfin ) {
%>          
          <tr class=Spacing> 
            <td class=Sep3 colspan=3></td>
          </tr>
		  <tr class=Title> 
            <th colspan=3><%=SystemEnv.getHtmlLabelName(15805,user.getLanguage())%></th>
          </tr>
          
		  <TR class=Spacing style="height:2px"> 
            <TD class=Line1 colSpan=3></TD>
          <tr> 
            <td valign=top align=left width="41%"> 
              <table width="143">
                <colgroup> <col width="20%"> <col width="80%"> <tbody> 
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasbankid1.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasbankid1 value=1 <%=ischecked%>> </td>
                  <td><%=SystemEnv.getHtmlLabelName(15812,user.getLanguage())%></td>
                    
                 
                </tr>
                </tbody> 
              </table>
            </td>
            <td width="38%" valign="top"> 
              <table width="152">
                <colgroup> <col width="20%"> <col width="80%"> <tbody> 
               <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasaccountid1.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasaccountid1 value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(16016,user.getLanguage())%></td>
                    
                  
                </tr>
                </tbody> 
              </table>
            </td>
            <td width="38%" valign="top"> 
              <table width="152">
                <colgroup> <col width="20%"> <col width="80%"> <tbody> 
               <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasaccumfundaccount.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasaccumfundaccount value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(1939,user.getLanguage())%></td>
                    
                  
                </tr>
                </tbody> 
              </table>
            </td>            
            <td width="21%">&nbsp; </td>
          </tr>
<%
  }
}
}
%>
<%
  if(issys || ishr){
%>          
         <tr class=Spacing> 
            <td class=Sep3 colspan=3></td>
          </tr> 
          <tr class=Title> 
            <th colspan=3><%=SystemEnv.getHtmlLabelName(15804,user.getLanguage())%></th>
          </tr>
          
		  <TR class=Spacing style="height:2px"> 
            <TD class=Line1 colSpan=3></TD>
          <tr> 
            <td valign=top align=left width="41%"> 
              <table width="143">
                <colgroup> <col width="20%"> <col width="80%"> <tbody> 
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasseclevel.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasseclevel value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td>
                    
                  
                </tr>                                
              </table>
            </td>
            <td width="38%" valign="top"> 
              <table width="152">
                <colgroup> <col width="20%"> <col width="80%"> <tbody> 
               <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hasloginid.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hasloginid value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(16017,user.getLanguage())%></td>
                    
                 
                </tr>
                 
                </tbody> 
              </table>
            </td>
            <td width="38%" valign="top"> 
              <table width="152">
                <colgroup> <col width="20%"> <col width="80%"> <tbody> 
               <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(hassystemlanguage.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=hassystemlanguage value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(16066,user.getLanguage())%></td>
                    
                  
                </tr>
                 
                </tbody> 
              </table>
            </td>            
            <td width="21%">&nbsp; </td>
          </tr>
<%
  }
%>          
          <tr class=Spacing> 
            <td class=Sep3 colspan=3></td>
          </tr>
		  <tr class=Title> 
            <th colspan=3><%=SystemEnv.getHtmlLabelName(16168,user.getLanguage())%></th>
          </tr>
          
		  <TR class=Spacing style="height:2px"> 
            <TD class=Line1 colSpan=3></TD>
          <tr> 
            <td valign=top align=left width="41%"> 
              <table width="143">
                <colgroup> <col width="20%"> <col width="80%"> <tbody> 
				<%if(isgoveproj==0){%>
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(projectable.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=projectable value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></td>
                    
                  
                </tr>
<%if(software.equals("ALL") || software.equals("CRM")){%>                
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(crmable.equals("1"))
                  	ischecked = " checked";
                  %>
				  <input type=checkbox name=crmable value=1 <%=ischecked%>></td>
                  <td>CRM</td>
                    
                  
                </tr>
<%}%>
<%}%>
<%if(software.equals("ALL")){%>
               <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(itemable.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=itemable value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></td>
                    
                  
                </tr>
<%}%>
                 <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(docable.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=docable value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></td>
                    
                  
                </tr>
                
                <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(workplanable.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=workplanable value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(407,user.getLanguage())%></td>
                    
                  
                </tr>
                </tbody> 
              </table>
            </td>
            <td width="38%" valign="top"> 
              <table width="152">
                <colgroup> <col width="20%"> <col width="80%"> <tbody> 
               <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(subordinateable.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=subordinateable value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(442,user.getLanguage())%></td>
                    
                  
                </tr>
                 <!-- tr> 
                  <td><%=SystemEnv.getHtmlLabelName(532,user.getLanguage())%></td>
                  <td> 
                  <%
                  ischecked = "";
                  if(trainable.equals("1"))
                  	ischecked = " checked";
                  %>
                    <input type=checkbox name=trainable value=1 <%=ischecked%>>
                  </td>
                </tr -->
			  <%if(isgoveproj==0){%>
              <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(budgetable.equals("1"))
                  	ischecked = " checked";
                  %> 
				  <input type=checkbox name=budgetable value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></td>
                    
                  
                </tr>
               <tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(fnatranable.equals("1"))
                  	ischecked = " checked";
                  %>
				  <input type=checkbox name=fnatranable value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(428,user.getLanguage())%></td>
                    
                  
                </tr>
				<%}%>
				<tr> 
                  
                  <td>
				  <%
                  ischecked = "";
                  if(workflowable.equals("1"))
                  	ischecked = " checked";
                  %>
				  <input type=checkbox name=workflowable value=1 <%=ischecked%>></td>
                  <td><%=SystemEnv.getHtmlLabelName(1207,user.getLanguage())%></td>
                    
                  
                </tr>
                </tbody> 
              </table>
            </td>
            <td width="21%">&nbsp; </td>
          </tr>
          <TR class=Spacing> 
            <TD class=Sep3 colSpan=3></TD>
          </TR>
          <TR class=Title> 
            <TH colSpan=3><%=SystemEnv.getHtmlLabelName(16169,user.getLanguage())%></TH>
          </TR>
          
		  <TR class=Spacing style="height:2px"> 
            <TD class=Line1 colSpan=3></TD>
          <TR> 
            <TD vAlign=top align=left width="41%"> 
              <table width="214">
                 <tbody> 
                <tr> 
				  <td><%=SystemEnv.getHtmlLabelName(321,user.getLanguage())%> 
                    <input type="text" class=InputStyle name="dspperpage" value=<%=dspperpage%> size="3" maxlength=2 onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)'>
					<%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%>
                  </td>
     
                </tr>
                </tbody> 
              </table>
              <p>&nbsp;</p>
              <p>&nbsp;</p>
            </td>
            <td width="38%">&nbsp;</td>
            <td width="21%">&nbsp; </td>
          </TR>
          </TBODY> 
        </TABLE>
      </TD></TR></TBODY></TABLE>
 <input type=hidden name=userid value="<%=userid%>">
 <input type=hidden name=returnurl value='<%=Util.null2String(request.getParameter("returnurl"))%>'>
 </FORM>
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
<script language=javascript>
function submitData() {
 frmMain.submit();
}
</script>