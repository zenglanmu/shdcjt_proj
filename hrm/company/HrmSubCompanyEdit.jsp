<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<script type='text/javascript' src='/dwr/interface/Validator.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<script type="text/javascript">
	jQuery(function($){
		$(".wuiBrowser").modalDialog();
		 
		});
</script>
</head>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String subcompanyname = SubCompanyComInfo.getSubCompanyname(""+id);
String subcompanydesc = SubCompanyComInfo.getSubCompanydesc(""+id);
int companyid = Util.getIntValue(SubCompanyComInfo.getCompanyid(""+id),0);
String companyname = CompanyComInfo.getCompanyname(""+companyid);

String supsubcomid=SubCompanyComInfo.getSupsubcomid(""+id);
String url=SubCompanyComInfo.getUrl(""+id);
String showorder=SubCompanyComInfo.getShoworder(""+id);
if(msgid>0){
    supsubcomid=Util.null2String(request.getParameter("supsubcomid"));
    //url=Util.null2String(request.getParameter("url"));
    //showorder=Util.null2String(request.getParameter("showorder"));
    //subcompanyname = Util.null2String(request.getParameter("subcompanyname"));
    //subcompanydesc = Util.null2String(request.getParameter("subcompanydesc"));
	url=Util.null2String((String)session.getAttribute("url"));
	showorder=Util.null2String((String)session.getAttribute("showorder"));
	subcompanyname=Util.null2String((String)session.getAttribute("subcompanyname"));
	subcompanydesc=Util.null2String((String)session.getAttribute("subcompanydesc"));
	session.removeAttribute("url");
	session.removeAttribute("showorder");
	session.removeAttribute("subcompanyname");
	session.removeAttribute("subcompanydesc");

}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(141,user.getLanguage())+":"+companyname+"-"+subcompanyname;
String needfav ="1";
String needhelp ="";

String canceled = "";
String subcompanycode = "";
rs.executeSql("select canceled,subcompanycode from HrmSubCompany where id="+id);
if(rs.next()){
 canceled = rs.getString("canceled");
 subcompanycode = Util.null2String(rs.getString("subcompanycode"));
}

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);//是否分级管理
boolean isdftsubcom = false;//是否默认分部
int sublevel=0;
if(detachable==1){
	sublevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmSubCompanyEdit:Edit",id);
    rs.executeProc("SystemSet_Select","");
    while(rs.next()){
	    int dftsubcomid = rs.getInt("dftsubcomid");
	    if(dftsubcomid==id)isdftsubcom = true;
    }
}else{
    if(HrmUserVarify.checkUserRight("HrmSubCompanyEdit:Edit", user))
        sublevel=2;
	if(id==1)isdftsubcom = true;	
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(sublevel>0 && ("0".equals(canceled) || "".equals(canceled))){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_parent} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(sublevel>1 && ("0".equals(canceled) || "".equals(canceled))){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_parent} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(sublevel>0 && ("0".equals(canceled) || "".equals(canceled))){
	  	RCMenu += "{"+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+",javascript:doCanceled(),_self} " ;
	  	RCMenuHeight += RCMenuHeightStep ;
}else{
     if(sublevel>0){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(22152,user.getLanguage())+",javascript:doISCanceled(),_self} " ;
	  	RCMenuHeight += RCMenuHeightStep ;
	 }
}

if(sublevel>0){
    if(rs.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(141,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=11 and relatedid="+id+",_self} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(141,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=11 and relatedid="+id+",_self} " ;
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

<FORM id=weaver name=frmMain action="SubCompanyOperation.jsp" method=post target="_parent">

<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TH></TR>
  <TR class= Spacing style="height:2px">
    <TD class=line1 colSpan=2 ></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
            <TD class=Field><%if(sublevel>0){%>
            <INPUT class=inputstyle maxLength=60 size=50 name="subcompanyname" value="<%=subcompanyname%>" onblur="checkLength('subcompanyname',60,'','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')"  onchange='checkinput("subcompanyname","subcompanynameimage")'>
            
            <SPAN id=subcompanynameimage></SPAN>
            <%}else{%><%=subcompanyname%><%}%></TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
          <TD class=Field><%if(sublevel>0){%>
          <INPUT class=inputstyle type=text maxLength=60 size=50 name="subcompanydesc" value="<%=subcompanydesc%>" onblur="checkLength('subcompanydesc',60,'','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')" onchange='checkinput("subcompanydesc","subcompanydescimage")'>
          
          <SPAN id=subcompanydescimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>
		  <script>
            checkinput("subcompanydesc","subcompanydescimage")
            </script>
          <%}else{%><%=subcompanydesc%><%}%></TD>
        
        
        </TR> 
		<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
        <TR>
        <TD><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())+SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
          <TD class=Field><%if(sublevel>0){%>
          
     
      <input class=wuiBrowser id=supsubcomid type=hidden name=supsubcomid value="<%=supsubcomid%>"
      _url="/hrm/company/SubcompanyBrowser2.jsp?rightStr=HrmSubCompanyEdit:Edit&isedit=1&excludeid=<%=id %>" _displayText="<%=SubComanyComInfo.getSubCompanyname(""+supsubcomid)%>"> 
       <%}else{%><%=SubComanyComInfo.getSubCompanyname(""+supsubcomid)%><%}%>
        </TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD ><%=SystemEnv.getHtmlLabelName(76,user.getLanguage())%></TD>  
          <TD class=Field><%if(sublevel>0){%><INPUT class=inputstyle size=50 name="url" value="<%=url%>"  >
          <%}else{%><%=url%><%}%></TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>  
          <TD class=Field><%if(sublevel>0){%><INPUT class=inputstyle size=50 name="showorder" value="<%=showorder%>"  >
          <%}else{%><%=showorder%><%}%></TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></TD>  
          <TD class=Field><%if(sublevel>0){%><INPUT class=inputstyle size=50 maxlength=100 name="subcompanycode" value="<%=subcompanycode%>"  >
          <%}else{%><%=subcompanycode%><%}%></TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>     
             
              
 </TBODY></TABLE>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="50%">
  <COL width="50%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=1><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TH>
    <td colSpan=1 align=right>
    </td>
  </TR>
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
    	if(id!=0 && Util.getIntValue(tmpid,0)!=id) continue;
        String tmpname = SubCompanyComInfo.getSubCompanyname();                    	
      while(DepartmentComInfo.next()){        
      	String cursubcompanyid = "";
      	if(companyid==1)
      		cursubcompanyid = DepartmentComInfo.getSubcompanyid1();     	
      	
      	if(!tmpid.equals(cursubcompanyid)) continue;
      	
      	String caceledstate = "";
        String caceled = "";
        rs.executeSql("select canceled from HrmDepartment where id = "+DepartmentComInfo.getDepartmentid());
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
    <TD><a href="/hrm/company/HrmSubCompanyEdit.jsp?id=<%=cursubcompanyid%>"><%=isfirst==1?tmpname:""%></a></TD>
    <TD><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=DepartmentComInfo.getDepartmentid()%>"><%=DepartmentComInfo.getDepartmentname()%></a><%=caceledstate %></TD>    
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
 <input class=inputstyle type=hidden name=operation>
 <input class=inputstyle type=hidden name=companyid value="<%=companyid%>">
 <input class=inputstyle type=hidden name=id value="<%=id%>">
 </form> 
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

<script language=vbs>
sub onShowSubcompany()
    url=encode("/hrm/company/SubcompanyBrowser2.jsp?excludeid=<%=id%>&rightStr=HrmSubCompanyEdit:Edit&isedit=1&selectedids="&frmMain.supsubcomid.value)
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url)
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	if id(0) = frmMain.supsubcomid.value then
		issame = true 
	end if
	supsubcomspan.innerHtml = id(1)
	frmMain.supsubcomid.value=id(0)
	else
	supsubcomspan.innerHtml = ""
	frmMain.supsubcomid.value=""
	end if
	end if
end sub
</script>
<script>
function onSave(){
	if(check_form(document.frmMain,'subcompanyname,subcompanydesc')){
	 	document.frmMain.operation.value="editsubcompany";
		document.frmMain.submit();
	}
}
function onDelete(){
	if(<%=isdftsubcom%>){
		alert("<%=SystemEnv.getHtmlNoteName(89,user.getLanguage())%>");
	}else{
		invoke(<%=id%>);
	}
}

function check(o){
     if(o)
     	alert("<%=SystemEnv.getHtmlNoteName(88,user.getLanguage())%>");
     else{
       if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="deletesubcompany";
			document.frmMain.submit();
           }
     }
     return o;
 }
function invoke(id){

     Validator.subCompanyIsUsed(id,check) ;
 }
function encode(str){
    return escape(str);
}

function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}

function doCanceled(){
    if(confirm("<%=SystemEnv.getHtmlLabelName(22153, user.getLanguage())%>")){
	  var ajax=ajaxinit();
      ajax.open("POST", "HrmCanceledCheck.jsp", true);
      ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      ajax.send("deptorsupid=<%=id%>&userid=<%=user.getUID()%>&operation=subcompany");
      ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
	            if(ajax.responseText == 1){
	              alert("<%=SystemEnv.getHtmlLabelName(22155, user.getLanguage())%>");
	              parent.leftframe.location.reload();
	              window.location.href = "HrmSubCompanyDsp.jsp?id=<%=id%>";
	            }else{
	              alert("<%=SystemEnv.getHtmlLabelName(22253, user.getLanguage())%>");
	            }
            }catch(e){
                return false;
            }
        }
     }
  }
}

 function doISCanceled(){
   if(confirm("<%=SystemEnv.getHtmlLabelName(22154, user.getLanguage())%>")){
	  var ajax=ajaxinit();
      ajax.open("POST", "HrmCanceledCheck.jsp", true);
      ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      ajax.send("deptorsupid=<%=id%>&cancelFlag=1&userid=<%=user.getUID()%>&operation=subcompany");
      ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
	            if(ajax.responseText == 1){
	              alert("<%=SystemEnv.getHtmlLabelName(22156, user.getLanguage())%>");
	              parent.leftframe.location.reload();
	              window.location.href = "HrmSubCompanyDsp.jsp?id=<%=id%>";
	            } else {
	               alert("<%=SystemEnv.getHtmlLabelName(24298, user.getLanguage())%>");
	               return;
	            }
            }catch(e){
                return false;
            }
        }
     }
   }
 }

 </script>
</BODY>
</HTML>