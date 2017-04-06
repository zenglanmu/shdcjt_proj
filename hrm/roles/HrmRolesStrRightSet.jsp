<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.systeminfo.role.StructureRightHandler,weaver.systeminfo.role.StructureRightInfo"%>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />


<HTML>
<HEAD>
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
    <script language=javascript src="/js/weaver.js"></script>
</HEAD>

<%
/*
    String imagefilename = "/images/hdHRMCard.gif";
    String titlename =SystemEnv.getHtmlLabelName(122,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17865,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
	*/
    int id=Util.getIntValue(request.getParameter("id"),0);//角色ID
    int flag=Util.getIntValue(request.getParameter("flag"),0);

    String para=""+id;
    rs.execute("hrmroles_selectSingle",para);
    rs.next();

    String rolesmark=rs.getString(1);
    String rolesname=rs.getString(2);
    int docid=Util.getIntValue(rs.getString(3),0);
    int roletype=Util.getIntValue(rs.getString(4),0);
    String structureid=rs.getString(5);
%>

<BODY>
<!--%@ include file="/systeminfo/TopTitle.jsp" %-->
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
    String tempSql = "select isdefault from HrmRoles where id = "+id;
    rs.executeSql(tempSql);
    rs.next();
    int isDefault = rs.getInt("isdefault");

    int operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmRolesAdd:Add",Integer.parseInt(structureid));

    if(operatelevel>0){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onEdit(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doReturn(),_self} " ;
	//RCMenuHeight += RCMenuHeightStep ;
    if(operatelevel>0){
        if(rs.getDBType().equals("db2")){
                    RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)="+103+" and relatedid="+id+",_self} " ;
    }else{
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+103+" and relatedid="+id+",_self} " ;
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
        
    <tr><td height="10" colspan="3"></td></tr>
    <tr><td ></td><td valign="top"><TABLE class=Shadow><tr>
    <td valign="top">
        <% if(flag==11) {%>
            <DIV><font color=red size=2> <%=SystemEnv.getErrorMsgName(flag,user.getLanguage())%></font></DIV>
        <%}%>

<form method=post name=HrmRolesStrRightSet action=HrmRolesStrRightOperation.jsp>

<TABLE class=ViewForm>
    <col width='20%'>
    <col width='80%'>
    <TR class=Title><TD COLSPAN=4><B><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></B></TD></TR>
    <TR class=Title><TD COLSPAN=4 class=Line1></TD></TR>
    
    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(15068,user.getLanguage())%></TD>
        <TD CLASS=FIELD><%=Util.toScreen(rolesmark,user.getLanguage())%></TD>
    </TR>
    <TR><TD class=Line colSpan=2></TD></TR> 
    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
        <TD CLASS=FIELD ><%=Util.toScreen(rolesname,user.getLanguage())%></TD>
    </TR>
    <TR><TD class=Line colSpan=2></TD></TR> 

    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></TD>
        <TD class=Field ><%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(structureid),user.getLanguage())%>
        <span id=structureid value=<%=structureid%>></span></TD>
    </TR>
    <TR><TD class=Line colSpan=2></TD></TR>

    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
        <%if(roletype==0){%>
            <TD class=Field ><%=SystemEnv.getHtmlLabelName(17866,user.getLanguage())%></TD>
        <%}if(roletype==1){%>
            <TD class=Field ><%=SystemEnv.getHtmlLabelName(17867,user.getLanguage())%></TD>
        <%}%>
        </TD>
    </TR>
    <TR><TD class=Line colSpan=2></TD></TR>

    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD>
        <TD class=Field >
            <SPAN ID=relativedocid><a href='/docs/docs/DocDsp.jsp?id=<%=docid%>'><%=DocComInfo.getDocname(""+docid)%></a></SPAN>
            <INPUT class=inputStyle type=hidden name=docid value="<%=docid%>">
        </TD>
    </TR>
    <TR><TD class=Line colSpan=2></TD></TR>
    <input class=inputstyle type=hidden name=id value=<%=id%>>
</TABLE>

<BR>

<!--表明细开始！-->
<TABLE class=ViewForm>
<TR class=Title>
  <TD>
    <B><%=SystemEnv.getHtmlLabelName(17865,user.getLanguage())%></B>
  </TD>
</TR>
<TR class=Spacing><TD CLASS=Sep3></TD></TR>
</TABLE>

<TABLE class=ListStyle cellspacing=1 >
<col width='70%'>
<col width='30%'>
<TR CLASS=Header>
  <TD><%=SystemEnv.getHtmlLabelName(17871,user.getLanguage())%></TD>
  <TD><%=SystemEnv.getHtmlLabelName(17872,user.getLanguage())%></TD>
</TR>
<TR class=Line><TD colspan="2" ></TD></TR> 

<TR class=DataLight><TD colspan="2" >
&nbsp&nbsp<IMG src='/images/treeimages/Home.gif' align=absMiddle><%=CompanyComInfo.getCompanyname(""+1)%>
</TD></TR> 
<%  int i =0;
    StructureRightInfo mSri=null;
    StructureRightHandler mSriHander=new StructureRightHandler();
    mSriHander.StructureRightInfoDo(id,user.getUID());
    int structureCount=mSriHander.size();
    for(int j=0;j<structureCount;j++){
      mSri=mSriHander.get(j);
    if(i==0){i=1;
    %>
    <TR class=DataDark>
    <%}else{i=0;%>
    <TR class=DataLight>
    <%}%>
    <TD>
    <!--第一列-->
    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
    <%for(int k=0;k<mSri.getTabNo();k++){%>
    &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
    <%}%>
    <IMG src='/images/treeimages/folderopen.gif' align=absMiddle>
    <%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(mSri.getId()),user.getLanguage())%>
    <%if(mSri.getNodetype()==1){%>
      <input type="checkbox" id='chk1_<%=mSri.getParent_list()%>_' value="1" 
      <% if(mSri.getBeChecked()==1) {%>checked<%}%>
      <% if(mSri.getIsdisable()==1) {%>disabled<%}%>
      onclick="checkSubchk('<%=mSri.getParent_list()%>_')" <%if(operatelevel<1){%>style="display:none"<%}%>>
      <input type="checkbox" name='chk_<%=j%>' id='chk2_<%=mSri.getParent_list()%>_' value="1" 
      <% if(mSri.getBeChecked()==1) {%>checked<%}%> style="display:none">
    <%}%>
    <input class=inputstyle type=hidden name='subid_<%=j%>' value=<%=mSri.getId()%> >
    </TD>
    <TD>
    <!--第二列-->
    <%if(mSri.getNodetype()==1){%>
     <span ID='span_<%=mSri.getParent_list()%>_' <%if(mSri.getBeChecked()==0){%>style="display:none"<%}%>>
       <%if(operatelevel>0){%>
           <select name='sel_<%=j%>' id='sel_<%=mSri.getParent_list()%>' 
           <%if(mSri.getIsleaf()== 1){%>onclick="checkSubsel(this,'<%=mSri.getParent_list()%>_')"<%}%>>
              <option value="-1" <%if(mSri.getOperateType_select()==-1){%>selected<%}%> >
              <%=SystemEnv.getHtmlLabelName(17875,user.getLanguage())%>&nbsp&nbsp&nbsp&nbsp</OPTION>
              <%if(mSri.getOperateType_Range()>-1){%>
                <option value="0" <%if(mSri.getOperateType_select()==0){%>selected<%}%> >
                <%=SystemEnv.getHtmlLabelName(17873,user.getLanguage())%></OPTION>
              <%}%>
              <%if(mSri.getOperateType_Range()>0){%>
                <option value="1" <%if(mSri.getOperateType_select()==1){%>selected<%}%> >
                <%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></OPTION>
              <%}%>
              <%if(mSri.getOperateType_Range()>1){%>
                <option value="2" <%if(mSri.getOperateType_select()==2){%>selected<%}%> >
                <%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></OPTION>
              <%}%>
           </select>
           <%if(mSri.getIsleaf()== 1){%>
            <input type="checkbox" id='leaf_<%=mSri.getParent_list()%>_' checked>
            <%=SystemEnv.getHtmlLabelName(17876,user.getLanguage())%>
           <%}%>
       <%}else{%>
            <%if(mSri.getOperateType_select()==0){%>
                <%=SystemEnv.getHtmlLabelName(17873,user.getLanguage())%>
            <%}%>
            <%if(mSri.getOperateType_select()==1){%>              
                <%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
            <%}%>
            <%if(mSri.getOperateType_select()==2){%>
                <%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%>
            <%}%>
       <%}%>
     </span>
    <%}%>
    </TD></TR>
<%}%>
<input class=inputstyle type=hidden name=structureCount value=<%=structureCount%>>
<input class=inputstyle type=hidden name=roleid value=<%=String.valueOf(id)%>>

</TABLE>
</FORM>

<script language=vbs>
sub showHeaderDoc()
  id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
  if NOT isempty(id) then
     if id(0)<> 0 then
    hrmrolesedit.docid.value=id(0)&""
    relativedocid.innerHtml = "<a href='/docs/docs/DocDsp.jsp?id="&id(0)&"'>"&id(1)&"</a>"
     else
      hrmrolesedit.docid.value=""
    relativedocid.innerHtml = empty
     end if
  end if
  
end sub
</script>

<script>
function onEdit(){
  document.HrmRolesStrRightSet.submit();
}

function checkSubchk(parlist) {
    len = document.HrmRolesStrRightSet.elements.length;
    var i=0;
    for( i=0; i<len; i++) {
    if (document.HrmRolesStrRightSet.elements[i].id=='chk1_'+parlist) {
      if(document.HrmRolesStrRightSet.elements[i].checked){
        var j=0;
        for(j=0; j<len; j++){
          var obj=document.HrmRolesStrRightSet.elements[j];
          if (obj.id.substr(0,parlist.length+5)=='chk1_'+parlist){
            if (obj.id=='chk1_'+parlist){
              obj.checked=true;
            }else{
              obj.checked=true;
              obj.disabled =true;
            }
            var row= obj.parentElement.parentElement;
            var cell2 = row.cells(1);
            var spanObj = cell2.firstChild.nextSibling;
            spanObj.style.display=''
          }
          if (obj.id.substr(0,parlist.length+5)=='chk2_'+parlist){
              obj.checked=true;
          }
          if (obj.id.substr(0,parlist.length+5)=='leaf_'+parlist){
            obj.checked=true;
          }
        }
      }else{
        for(j=0; j<len; j++){
          var obj=document.HrmRolesStrRightSet.elements[j];
          if (obj.id.substr(0,parlist.length+5)=='chk1_'+parlist){
            if (obj.id=='chk1_'+parlist){
              obj.checked=false;
            }else{
              obj.checked=false;
              obj.disabled =false;
            }
            var row= obj.parentElement.parentElement;
            var cell2 = row.cells(1);
            var spanObj = cell2.firstChild.nextSibling;
            spanObj.style.display='none'
          }
          if (obj.id.substr(0,parlist.length+5)=='chk2_'+parlist){
              obj.checked=false;
          }
        }
      }
      return;
      }
    }
}

function checkSubsel(thisobj,parlist) {
  len = document.HrmRolesStrRightSet.elements.length;
  var i=0;
  for( i=0; i<len; i++) {
    if (document.HrmRolesStrRightSet.elements[i].id=='leaf_'+parlist) {
      if(document.HrmRolesStrRightSet.elements[i].checked){
        var j=0;
        for(j=0; j<len; j++){
          var obj=document.HrmRolesStrRightSet.elements[j];
          if (obj.id.substr(0,parlist.length+4)=='sel_'+parlist){
            obj.selectedIndex =thisobj.selectedIndex ;
          }
        }
      }


    }
  }
}
function doReturn(){
	window.parent.location="/hrm/roles/HrmRoles.jsp";
}
</script>
<BR>
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

</BODY>

</HTML>