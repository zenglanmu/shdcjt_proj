<%@ page language="java" contentType="text/html; charset=GBK" %>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RolesLink" class="weaver.hrm.roles.RolesLink" scope="page"/>

<%@ include file="/systeminfo/init.jsp" %>
<% if(!(user.getLogintype()).equals("1")) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>




<BODY>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(122,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
//初始化值
String rolesnameq = Util.null2String(request.getParameter("rolesnameq"));
int subCompanyId= 0;
int operatelevel= 0;
//页标题

if(operatelevel>-1 && subCompanyId!=-1){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(this),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
}
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
if(detachable==1){
    if(request.getParameter("subCompanyId")==null){
        subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("role_subCompanyId")),-1);
    }else{
        subCompanyId=Util.getIntValue(request.getParameter("subCompanyId"),-1);
    }
    session.setAttribute("role_subCompanyId",String.valueOf(subCompanyId));
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmRolesAdd:Add",subCompanyId);
}else{
	if(HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user))
		operatelevel=2;
}
if(operatelevel>0 && subCompanyId!=-1){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/hrm/roles/HrmRolesAdd.jsp,_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
if(operatelevel>0 && subCompanyId!=-1){
	if(rs.getDBType().equals("db2")){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)="+16+",_self} " ;
	}else{
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+16+",_self} " ;
	}
    RCMenuHeight += RCMenuHeightStep ;
}



//backFields
String label1=SystemEnv.getHtmlLabelName(17864,user.getLanguage());
String label2=SystemEnv.getHtmlLabelName(17865,user.getLanguage());
String backFields=Util.toHtmlForSplitPage("'"+label1+"' as label1,'"+label2+"' as label2,id,roleid,rolesmark,rolesname,type,cnt");

//from
String sqlFrom = "(select t1.id,t2.roleid,t1.rolesmark,t1.rolesname,t1.type,count(t2.roleid) as cnt from hrmroles t1 left join HrmRoleMembers t2 on t1.id=t2.roleid group by t1.id,t1.rolesmark,t1.rolesname,t1.type,t2.roleid)  a";

if(detachable==1){
            if(subCompanyId==0){
                if("".equals(rolesnameq)){
                    sqlFrom = "(select t1.id,t2.roleid,t1.rolesmark,t1.rolesname,t1.type,count(t2.roleid) as cnt from hrmroles t1 left join HrmRoleMembers t2 on t1.id=t2.roleid group by t1.id,t1.rolesmark,t1.rolesname,t1.type,t2.roleid)  a";
                }else{
                    sqlFrom = "(select t1.id,t2.roleid,t1.rolesmark,t1.rolesname,t1.type,count(t2.roleid) as cnt from hrmroles t1 left join HrmRoleMembers t2 on t1.id=t2.roleid where t1.rolesmark like '%"+rolesnameq+"%'group by t1.id,t1.rolesmark,t1.rolesname,t1.type,t2.roleid)  a";
                }
            }else{
                if("".equals(rolesnameq)){
                    sqlFrom = "(select t1.id,t2.roleid,t1.rolesmark,t1.rolesname,t1.type,count(t2.roleid) as cnt from hrmroles t1 left join HrmRoleMembers t2 on t1.id=t2.roleid where t1.subcompanyid="+subCompanyId+" group by t1.id,t1.rolesmark,t1.rolesname,t1.type,t2.roleid)  a";
                }else{
                    sqlFrom = "(select t1.id,t2.roleid,t1.rolesmark,t1.rolesname,t1.type,count(t2.roleid) as cnt from hrmroles t1 left join HrmRoleMembers t2 on t1.id=t2.roleid where t1.subcompanyid="+subCompanyId+" and t1.rolesmark like '%"+rolesnameq+"%'group by t1.id,t1.rolesmark,t1.rolesname,t1.type,t2.roleid)  a";
                }
            }
        }else{
            if("".equals(rolesnameq)){
                sqlFrom = "(select t1.id,t2.roleid,t1.rolesmark,t1.rolesname,t1.type,count(t2.roleid) as cnt from hrmroles t1 left join HrmRoleMembers t2 on t1.id=t2.roleid where t1.type=0 group by t1.id,t1.rolesmark,t1.rolesname,t1.type,t2.roleid)  a";
            }else{
                sqlFrom = "(select t1.id,t2.roleid,t1.rolesmark,t1.rolesname,t1.type,count(t2.roleid) as cnt from hrmroles t1 left join HrmRoleMembers t2 on t1.id=t2.roleid   where t1.type=0 and t1.rolesmark like '%"+rolesnameq+"%'group by t1.id,t1.rolesmark,t1.rolesname,t1.type,t2.roleid)  a";
            }
        }
//where
String sqlWhere = " ";
     sqlFrom=Util.toHtmlForSplitPage(sqlFrom);
if(operatelevel<1){
    sqlWhere=" 1>2 ";
}
//orderBy
String orderBy = "id";
//primarykey
String primarykey = "id";
//pagesize

int pagesize=10;
//colString
       String colString;
      if(detachable==1){
       colString="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15068,user.getLanguage())+"\" column=\"rolesmark\" transmethod=\"weaver.hrm.roles.RolesLink.getlinkname\" otherpara=\"column:id\" />";
       colString +="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"type\"  transmethod=\"weaver.hrm.roles.RolesComInfo.getRoleTypeName\" otherpara=\""+user.getLanguage()+"\" />";
       colString +="<col name=\"id\" width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(17864,user.getLanguage())+"\" column=\"label1\"  transmethod=\"weaver.hrm.roles.RolesLink.getfunctionright\" otherpara=\"column:id\" />";
       colString +="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(17865,user.getLanguage())+"\" column=\"label2\"  linkkey=\"id\" transmethod=\"weaver.hrm.roles.RolesLink.getstructureright\" otherpara=\"column:id\" />";
       colString +="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(431,user.getLanguage())+"\" column=\"cnt\" linkkey=\"id\" transmethod=\"weaver.hrm.roles.RolesLink.getrolesnum\" otherpara=\"column:id\" />";
      }else{
       colString="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15068,user.getLanguage())+"\" column=\"rolesmark\" orderkey=\"rolesmark\" transmethod=\"weaver.hrm.roles.RolesLink.getlinkname\" otherpara=\"column:id\" />";
       colString +="<col name=\"id\" width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(17864,user.getLanguage())+"\" column=\"label1\"  transmethod=\"weaver.hrm.roles.RolesLink.getfunctionright\" otherpara=\"column:id\" />";
       colString +="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(431,user.getLanguage())+"\" column=\"cnt\" linkkey=\"id\" transmethod=\"weaver.hrm.roles.RolesLink.getrolesnum\" otherpara=\"column:id\" />";
      }
//operateString




String tableString="<table  pagesize=\""+pagesize+"\" tabletype=\"none\">";
       tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\"/>";
       tableString+="<head>"+colString+"</head>";

       tableString+="</table>";
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0" valign="top">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<TD valign="top">
		<TABLE class=Shadow valign="top">
		<TR>
            <TD valign="top">
            <FORM name="frmSearch" method="post" action="">
                <TABLE class=ViewForm valign="top">
                    <TR valign="top">
                        <TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(15068,user.getLanguage())%></TD>
                         <TD CLASS="Field" WIDTH=*>
                          <INPUT type=text name=rolesnameq class=InputStyle size=20 value="<%=rolesnameq%>" >
                         </TD>

                    </TR>
                    <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
                     <TR>
                         <TD valign="top" colspan=2>
                             <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run"/>
                          </TD>
                     </TR>
                </TABLE>
                </FORM>
             </TD>
         </TR>
         </TABLE>
    </TD>
    <td ></td>
</TR>
</TABLE>

</BODY>
</HTML>
<script language="javaScript">
    function onSearch(){
        frmSearch.submit();
    }


    function doCptShare(cptid){
        var url = "/cpt/share/CptShare.jsp?cptid="+cptid;
        openFullWindowHaveBar(url);

    }


</script>


<script>
function onShowDate(spanname,inputname){
    returndate = window.showModalDialog("/systeminfo/Calendar.jsp",null,"dialogHeight:320px;dialogwidth:275px")
    if (returndate!=null&&returndate!=""){
        if(spanname.id=="dealdatefromspan"){
            enddate=document.getElementById("dealdatetospan").innerHTML;
            if(enddate!=null&&enddate!=""){
                if(returndate>enddate){
                    alert("开始日期不能晚于结束日期！")
                    return;
                }
            }
        }
        if(spanname.id=="dealdatetospan"){
            fromdate=document.getElementById("dealdatefromspan").innerHTML;
            if(fromdate!=null&&fromdate!=""){
                if(returndate<fromdate){
                    alert("结束日期不能早于开始日期！")
                    return;
                }
            }
        }
    spanname.innerHTML = returndate;
    inputname.value=returndate;
    }else{
    spanname.innerHTML = "";
    inputname.value="";
    }
}
</script>