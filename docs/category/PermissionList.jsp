<!--
传入参数：
labels 要显示的提示
user 用户
id 目录id
categoryname 目录名称
categorytype 目录类型
operationcode 操作类型
canEdit 是否可以编辑
am 安全管理器
RecordSet
DepartmentComInfo
ResourceComInfo
CustomerTypeComInfo
RolesComInfo
-->
<table class=ViewForm>
  <colgroup> 
  <col width="8%">
  <col width="35%"> 
  <col width="*">
  <tr class=Title> 
    <th colspan=2 noWrap><%=am.getMultiLabel(labels,user.getLanguage())%></th>
    <td align=right>&nbsp;
    <%if(canEdit){%>
	<input type="checkbox" name="chkPermissionAll<%=operationcode%>" onclick="chkPermissionAllClick<%=operationcode%>(this)">(<%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%>)
    &nbsp;                         
    <a href="AddCategoryPermission.jsp?categoryid=<%=id%>&categorytype=<%=categorytype%>&operationcode=<%=operationcode%>&titlename=<%=am.getMultiLabel(labels,user.getLanguage())%>" <%--target="mainFrame"--%>><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>
    <a href="#" onclick="javaScript:onPermissionDelShare<%=operationcode%>();" target="iframeAlert"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>    
    <%--		<a href="PermissionOperation.jsp?method=delete&mainid=<%=RecordSet.getInt("mainid")%>&categoryid=<%=id%>&categorytype=<%=categorytype%>" <% --target="mainFrame"-- %>><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a> 
    --%>
    <%}%>
    </td>
  </tr>
  <tr class=Spacing style="height: 1px!important;"> 
    <td class=Line1 colspan=3></td>
  </tr>
  
<%
  RecordSet.executeProc("Doc_DirAcl_SByDirID",""+id+Util.getSeparator()+categorytype+Util.getSeparator()+operationcode);
  while(RecordSet.next()){
	 
    if(RecordSet.getInt("permissiontype")==1)	{%>
    <TR>
      <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("mainid")%>" NAME='chkPermissionShareId<%=operationcode%>' <%if(!canEdit) out.print("disabled");%>></TD>
      <TD class=Field><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
	  <TD class=Field>
		<a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=RecordSet.getString("departmentid")%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSet.getString("departmentid")),user.getLanguage())%></a>
		/
		<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
		:
		<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>
	  </TD>
    </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
<%}else if(RecordSet.getInt("permissiontype")==2)	{%>
    <TR>
      <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("mainid")%>" NAME='chkPermissionShareId<%=operationcode%>' <%if(!canEdit) out.print("disabled");%>></TD>
      <TD class=Field><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
	  <TD class=Field>
		<%
			RecordSet2.executeSql("select rolesmark from hrmroles where id ="+RecordSet.getString("roleid"));
			RecordSet2.next();
		%>
		<%=Util.toScreen(RecordSet2.getString(1),user.getLanguage())%>
		/
		<% if(RecordSet.getInt("rolelevel")==0)%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
		<% if(RecordSet.getInt("rolelevel")==1)%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
		<% if(RecordSet.getInt("rolelevel")==2)%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
		/
		<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
		:
		<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>
	  </TD>
    </TR>
            <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
<%}else if(RecordSet.getInt("permissiontype")==3)	{%>
    <TR>
      <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("mainid")%>" NAME='chkPermissionShareId<%=operationcode%>' <%if(!canEdit) out.print("disabled");%>></TD>
      <TD class=Field><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></TD>
	  <TD class=Field>
		<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
		:
		<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>
	  </TD>
    </TR>
            <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
<%}else if(RecordSet.getInt("permissiontype")==4)	{%>
    <TR>
      <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("mainid")%>" NAME='chkPermissionShareId<%=operationcode%>' <%if(!canEdit) out.print("disabled");%>></TD>
      <TD class=Field><%=SystemEnv.getHtmlLabelName(7179,user.getLanguage())%></TD>
	  <TD class=Field>
	    <%=(RecordSet.getInt("usertype")==0)?SystemEnv.getHtmlLabelName(131,user.getLanguage()).trim():CustomerTypeComInfo.getCustomerTypename(RecordSet.getString("usertype"))%>
	    /
		<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
		:
		<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>
	  </TD>
    </TR>
            <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
<%} else if(RecordSet.getInt("permissiontype")==5)	{%>
    <TR>
      <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("mainid")%>" NAME='chkPermissionShareId<%=operationcode%>' <%if(!canEdit) out.print("disabled");%>></TD>
      <TD class=Field><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
	  <TD class=Field>
	    <a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("userid")%>" target="_blank"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("userid")),user.getLanguage())%></a>
	  </TD>
    </TR>
            <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
<%} else if(RecordSet.getInt("permissiontype")==6)	{%>
    <TR>
      <TD><INPUT TYPE='CHECKBOX'  CLASS='INPUTSTYLE' VALUE="<%=RecordSet.getInt("mainid")%>" NAME='chkPermissionShareId<%=operationcode%>' <%if(!canEdit) out.print("disabled");%>></TD>
      <TD class=Field><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></TD>
	  <TD class=Field>
		<a href="/hrm/company/HrmSubCompanyDsp.jsp?id=<%=RecordSet.getString("subcompanyid")%>" target="_blank"><%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(RecordSet.getString("subcompanyid")),user.getLanguage())%></a>
		/
		<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
		:
		<%=Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage())%>
	  </TD>
    </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
<%}
}%>
</table>
<script language="javascript">
function chkPermissionAllClick<%=operationcode%>(obj){
    var chks = document.getElementsByName("chkPermissionShareId<%=operationcode%>");    
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        chk.checked=obj.checked;
    }    
}
function onPermissionDelShare<%=operationcode%>(){
	var mainids = "";
    var chks = document.getElementsByName("chkPermissionShareId<%=operationcode%>");    
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        if(chk.checked)
        	mainids = mainids + "," + chk.value;
    }    
    window.parent.location = "PermissionOperation.jsp?method=delete&mainids="+mainids+"&categoryid=<%=id%>&categorytype=<%=categorytype%>";
}
</script>