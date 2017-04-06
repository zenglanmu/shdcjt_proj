<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(122,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(385,user.getLanguage());
String needfav ="1";
String needhelp ="1";

String roleId = Util.null2String(request.getParameter("id")) ;
%>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <link href="/css/Weaver.css" type=text/css rel=stylesheet>
  </head>
  
  <body>
  <%@ include file="/systeminfo/TopTitle.jsp" %>
  <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
  
  <%
  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;
  RCMenuHeight += RCMenuHeightStep ;
  RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/roles/HrmRolesFucRightSet.jsp?id="+roleId+",_self} " ;
  RCMenuHeight += RCMenuHeightStep ;
  %>
  <%@ include file="/systeminfo/RightClickMenu.jsp" %>

<%
String sqlstr ="";
String sqlstr2 ="";
String languageid = ""+user.getLanguage();
int type =Util.getIntValue(String.valueOf(session.getAttribute("role_type")));
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);

if(detachable==0){
    //不分权：返回所有功能
    sqlstr =" select distinct b.id,rightname,d.id as groupid,d.rightgroupname "+
            " from SystemRights a, SystemRightsLanguage b, systemrighttogroup c, SystemRightGroups d" +
            " where a.id = b.id and languageid= "+languageid +
            " and a.id=c.rightid and c.groupid=d.id order by d.id";
    //没有归组的权限
    sqlstr2=" select distinct(a.id),b.rightname,-2 as groupid,'其它权限组' as rightgroupname "+
            " from SystemRights a, SystemRightsLanguage b "+
            " where a.id = b.id and languageid= "+languageid +
            " and a.id in(select e.id from SystemRights e left join SystemRightToGroup f on e.id=f.rightid where f.rightid is null) "+
            " order by a.id";
}else{
    if(user.getUID()==1){
        if(type==0){
            //sysadmin、赋权角色：返回所有功能
            sqlstr =" select distinct b.id,rightname,d.id as groupid,d.rightgroupname "+
                    " from SystemRights a, SystemRightsLanguage b, systemrighttogroup c, SystemRightGroups d" +
                    " where a.id = b.id and languageid= "+languageid +
                    " and a.id=c.rightid and c.groupid=d.id order by d.id";
            //没有归组的权限
            sqlstr2=" select distinct(a.id),b.rightname,-2 as groupid,'其它权限组' as rightgroupname "+
                    " from SystemRights a, SystemRightsLanguage b "+
                    " where a.id = b.id and languageid= "+languageid +
                    " and a.id in(select e.id from SystemRights e left join SystemRightToGroup f on e.id=f.rightid where f.rightid is null) "+
                    " order by a.id";
        }else{
            //sysadmin、分权角色：返回所有可分权功能
            sqlstr =" select distinct b.id,rightname,d.id as groupid,d.rightgroupname "+
                    " from SystemRights a , SystemRightsLanguage b, systemrighttogroup c, SystemRightGroups d" +
                    " where a.id = b.id and languageid= "+languageid +
                    " and a.id=c.rightid and c.groupid=d.id "+
                    " and a.detachable=1 order by d.id";
            //没有归组的权限
            sqlstr2=" select distinct(a.id),b.rightname,-2 as groupid,'其它权限组' as rightgroupname "+
                    " from SystemRights a, SystemRightsLanguage b "+
                    " where a.id = b.id and languageid= "+languageid +
                    " and a.id in(select e.id from SystemRights e left join SystemRightToGroup f on e.id=f.rightid where f.rightid is null) "+
                    " and a.detachable=1 order by a.id";
        }
    }else{
        if(type==0){
            //非sysadmin、赋权角色：返回所有上级赋予的功能
            sqlstr =" select distinct b.id,rightname,f.id as groupid,f.rightgroupname "+
                    " from SystemRights a, SystemRightsLanguage b, systemrighttogroup e, SystemRightGroups f" +
                    " where a.id = b.id and languageid= "+languageid +
                    " and a.id=e.rightid and e.groupid=f.id "+
                    " and a.id in(select distinct(c.rightid) from SystemRightRoles c, HrmRoleMembers d where c.roleid=d.roleid and d.resourceid="+user.getUID()+") order by f.id";
            //没有归组的权限
            sqlstr2=" select distinct a.id,b.rightname,-2 as groupid,'其它权限组' as rightgroupname "+
                    " from SystemRights a, SystemRightsLanguage b "+
                    " where a.id = b.id and languageid= "+languageid + 
                    " and a.id in(select e.id from SystemRights e left join SystemRightToGroup f on e.id=f.rightid where f.rightid is null) "+
                    " and a.id in(select distinct(c.rightid) from SystemRightRoles c, HrmRoleMembers d where c.roleid=d.roleid and d.resourceid="+user.getUID()+") "+
                    " order by a.id";
        }else{
            //非sysadmin、分权角色：返回所有上级赋予的分权功能
            sqlstr =" select distinct b.id,rightname,f.id as groupid,f.rightgroupname "+
                    " from SystemRights a , SystemRightsLanguage b, systemrighttogroup e, SystemRightGroups f" +
                    " where a.id = b.id and languageid= "+languageid +" and a.detachable=1 " +
                    " and a.id=e.rightid and e.groupid=f.id "+
                    " and a.id in(select distinct(c.rightid) from SystemRightRoles c, HrmRoleMembers d where c.roleid=d.roleid and d.resourceid="+user.getUID()+") order by f.id";
            //没有归组的权限
            sqlstr2=" select distinct a.id,b.rightname,-2 as groupid,'其它权限组' as rightgroupname "+
                    " from SystemRights a, SystemRightsLanguage b "+
                    " where a.id = b.id and languageid= "+languageid + 
                    " and a.id in(select e.id from SystemRights e left join SystemRightToGroup f on e.id=f.rightid where f.rightid is null) "+
                    " and a.id in(select distinct(c.rightid) from SystemRightRoles c, HrmRoleMembers d where c.roleid=d.roleid and d.resourceid="+user.getUID()+") "+
                    " and a.detachable=1 order by a.id";
        }
    }
}

rs.executeSql(sqlstr);
String rightid_tmp = "";
String rightname_tmp = "";
String rightgroup_tmp = "";
String groupid_tmp = "";
String groupname_tmp = "";
ArrayList rightids=new ArrayList();
ArrayList rightnames=new ArrayList();
ArrayList rightgroups=new ArrayList();
ArrayList groupids=new ArrayList();
ArrayList groupnames=new ArrayList();
while(rs.next()){
    rightid_tmp = rs.getString("id");
    rightname_tmp = rs.getString("rightname");
    rightgroup_tmp =rs.getString("groupid");
    rightids.add(rightid_tmp);
    rightnames.add(rightname_tmp);
    rightgroups.add(rightgroup_tmp);
    if(!groupid_tmp.equals(rs.getString("groupid"))){
        groupid_tmp = rs.getString("groupid");
        groupname_tmp = rs.getString("rightgroupname");
        groupids.add(groupid_tmp);
        groupnames.add(groupname_tmp);
    }
}

rs.executeSql(sqlstr2);
while(rs.next()){
    rightid_tmp = rs.getString("id");
    rightname_tmp = rs.getString("rightname");
    rightgroup_tmp =rs.getString("groupid");
    rightids.add(rightid_tmp);
    rightnames.add(rightname_tmp);
    rightgroups.add(rightgroup_tmp);
    if(!groupid_tmp.equals(rs.getString("groupid"))){
        groupid_tmp = rs.getString("groupid");
        groupname_tmp = rs.getString("rightgroupname");
        groupids.add(groupid_tmp);
        groupnames.add(groupname_tmp);
    }
}
%>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td ></td>
<td valign="top">
<TABLE class="Shadow">
<tr>
<td valign="top">

<FORM id="frmmain" action="HrmRoleRightOperation.jsp" name="frmmain" method=post >
<input type=hidden name="roleId" value="<%=roleId%>">
<input type=hidden name=operationType value="addRoleRight">

<TABLE class=ViewForm style="width:100%">
<COLGROUP>
<COL width="20%">
<COL width="80%">

<TR class=Title><TD COLSPAN=2><B><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></B></TD></TR>
<TR class=Title style="height:1px;"><TD COLSPAN=2 class=Line1></TD></TR>
    
<TBODY>
<TR>
<TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
<TD class=Field><%=Util.toScreen(RolesComInfo.getRolesRemark(roleId),user.getLanguage())%></TD>
</TR>
<TR style="height:1px;"><TD class=Line colspan=2></TD></TR>
<TR>
<TD><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TD>
<TD class="field">
<SELECT ID=roleLevel CLASS=saveHistory NAME=roleLevel>
    <OPTION VALUE="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></OPTION>
    <OPTION VALUE="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></OPTION>
    <OPTION VALUE="0" SELECTED><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></OPTION>
</SELECT>
</TD>
</TR>
<TR style="height:1px;"><TD class=Line colspan=2></TD></TR>
</TBODY>
</TABLE>


<BR>
<TABLE class=ViewForm style="width:100%">
<TR class=Title><TD COLSPAN=2><B><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%></B></TD></TR>
<TR class=Title style="height:1px;"><TD COLSPAN=2 class=Line1></TD></TR>

<%
int typecate = groupids.size();
int rownum = typecate/2;
if((typecate-rownum*2)!=0)  rownum=rownum+1;
%>
<tr class=field>
<td width="50%" align=left valign=top>
<%
int needtd=rownum;
int k=0;
for(int i=0;i<groupids.size();i++){
    String groupid = (String)groupids.get(i);
    String groupname=(String)groupnames.get(i);
    needtd--;
%>
<table class="viewform">
    <tr class=field>
    <td colspan=2 align=left>
    <input type="checkbox" id="t<%=groupid%>" value="<%=groupid%>" onclick="checkMain('<%=groupid%>')">
    <b><%=groupname%></b> </td></tr>	
    
    <%
    for(int j=0;j<rightgroups.size();j++){
    String rightgroup = (String)rightgroups.get(j);
    if(!groupid.equals(rightgroup)) 
    continue;
    String rightid=(String)rightids.get(j);
    String rightname=(String)rightnames.get(j);
    %>
    <tr class="field">
        <td width="20%"></td>
        <td>
        <input type="checkbox" name='chk_<%=k%>' id="w<%=groupid%>" value="1" onclick="checkSub('<%=groupid%>')">
        <%=rightname%></td>
        <input class=inputstyle type=hidden name='rightid_<%=k%>' value=<%=rightid%> >
		<input class=inputstyle type=hidden name='rightname_<%=k%>' value=<%=rightname%> >
    </tr>
    <%k++;%>
    <%}%>
</table>
<%
if(needtd==0){
    needtd=typecate/2;%>
    </td><td align=left valign=top>
<%}
}%>		
</tr>

</TABLE>

</td>
</tr>
</TABLE>
<input type=hidden name="rightcount" value="<%=new Integer(k)%>">
</FORM>

</td>
<td></td>
</tr>
<tr><td height="10" colspan="3"></td></tr>
</table>




<script language="javascript">
function doSubmit(){
	if (check_form(frmmain,"rightId")){
		frmmain.operationType.value = "addRoleRight";
		frmmain.submit();
		enableAllmenu();
	}
}

function checkMain(id) {
    len = $GetEle("frmmain").elements.length;
    var mainchecked=$GetEle("t"+id).checked ;
    var i=0;
    for( i=0; i<len; i++) {
        if ($GetEle("frmmain").elements[i].id=='w'+id) {
            $GetEle("frmmain").elements[i].checked= mainchecked ;
        } 
    } 
}


function checkSub(id) {
    len = $GetEle("frmmain").elements.length;
    var i=0;
    for( i=0; i<len; i++) {
    if ($GetEle("frmmain").elements[i].id=='w'+id) {
    	if($GetEle("frmmain").elements[i].checked){
    		$GetEle("t"+id).checked=true;
    		return;
    		}
    	} 
    }
    $GetEle("t"+id).checked=false; 
}
</script>

</body>
</html>

