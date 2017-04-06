<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<html>

<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<body>
<%
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(716,user.getLanguage());
String needfav ="1";
String needhelp ="";
int subcompanyid=-1;
int operatelevel = 0;
if(detachable==1){
        subcompanyid=Util.getIntValue(request.getParameter("subcompanyid1"),-1);
    	operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmContractTypeAdd:Add",subcompanyid);
}else{
	if(HrmUserVarify.checkUserRight("HrmContractTypeAdd:Add", user) || HrmUserVarify.checkUserRight("HrmContractType:Log", user))
		operatelevel=2;
}
if(subcompanyid==-1 && detachable==1)
{
   String s="<TABLE class=viewform><colgroup><col width='10'><col width=''><TR class=Title><TH colspan='2'>"+SystemEnv.getHtmlLabelName(19010,user.getLanguage())+"</TH></TR><TR class=spacing><TD class=line1 colspan='2'></TD></TR><TR><TD></TD><TD><li>";
    if(user.getLanguage()==8){s+="Click on the left branch of the Division for the contract template set</li></TD></TR></TABLE>";}
    else{s+=""+SystemEnv.getHtmlLabelName(22206,user.getLanguage())+"</li></TD></TR></TABLE>";}
    out.println(s);
    return;
}
%>

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(operatelevel >0){
	if(HrmUserVarify.checkUserRight("HrmContractTypeAdd:Add", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",/hrm/contract/contracttype/HrmContractTypeAdd.jsp?subcompanyid="+subcompanyid+",_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	}
}
if(HrmUserVarify.checkUserRight("HrmContractType:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+81+",_self} " ;
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
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=templet name=templet action="HrmConTypeOperation.jsp" method=post>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>   
    <COL width="20%">
    <COL width="20%"> 
    <COL width="35%"> 
    <COL width="10%"> 
    <COL width="15%"> 
  <TBODY>
  <TR class=header>
    <TH colSpan=5><%=SystemEnv.getHtmlLabelName(6158,user.getLanguage())%></TH>
  </TR>
   <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(15775,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15786,user.getLanguage())%></TD>    
      
    <TD><%=SystemEnv.getHtmlLabelName(15787,user.getLanguage())%></TD>        
    <TD><%=SystemEnv.getHtmlLabelName(15788,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15789,user.getLanguage())%></TD>
  </TR>  
  
<%
  int needchange = 0;
  String sql = "";
  String temp = "";
  if(detachable==1){
  sql = "select type.id,type.typename,type.saveurl,type.contracttempletid,type.ishirecontract,type.remindaheaddate,template.templetname,template.templetdocid from HrmContractType type,HrmContractTemplet template WHERE type.contracttempletid = template.ID and type.subcompanyid = "+subcompanyid+" order by type.id";
  }else{
  sql = "select type.id,type.typename,type.saveurl,type.contracttempletid,type.ishirecontract,type.remindaheaddate,template.templetname,template.templetdocid from HrmContractType type,HrmContractTemplet template WHERE type.contracttempletid = template.ID order by type.id";
  }
  String id="";
  String typename="";
  String saveurl="";
  String templetid="";
  String templetname="";
  String templetdocid ="";
  int ishire,aheaddate;
  rs.executeSql(sql);
  int pathNumber;
  String path;
  while(rs.next()){
    id = Util.null2String(rs.getString("id"));
    typename  = Util.null2String(rs.getString("typename"));
    saveurl  = Util.null2String(rs.getString("saveurl"));   
	pathNumber = Util.getIntValue(saveurl,-1);
	path = CategoryUtil.getCategoryPath(pathNumber);
    templetid  = Util.null2String(rs.getString("contracttempletid"));
    templetname =Util.null2String(rs.getString("templetname"));
	templetdocid = Util.null2String(rs.getString("templetdocid"));
	ishire = Util.getIntValue(rs.getString("ishirecontract"),0);
    aheaddate = Util.getIntValue(rs.getString("remindaheaddate"),0);

    if(needchange%2==0){
      
%>  
    <TR class=datalight>
<%
    }else{    
%>
    <TR class=datadark>
<%
}
%>    
   <td><a href="HrmContractTypeEdit.jsp?id=<%=id%>&subcompanyid=<%=subcompanyid%>"><%=typename%></a></td> 
   <td>
    <a href="/docs/mouldfile/DocMouldDsp.jsp?id=<%=templetdocid%>&urlfrom=hr&subcompanyid1=<%=subcompanyid%>"><%=templetname%></a>
  
    </td> 
    
    <td><%=path.equals("/")?"":"/"+path%></td>
    <td>
    <%if(ishire == 1){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}%>
    <%if(ishire == 0){%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
    </td>
    <td><%=aheaddate%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></td>
<%
  needchange++;
  }
%>
  </tbody>      
</table>
</form>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
</body>
</html>