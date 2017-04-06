<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %> 

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RightComInfo" class="weaver.systeminfo.systemright.RightComInfo" scope="page" />



<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String id= Util.null2String(request.getParameter("id"));
String rightName= Util.null2String(request.getParameter("rightName"));    
String mark="";
String description="";
String notes="";
int index=0;
String rightid = "";

rs.executeSql("select detachable from SystemSet");
int detachable=0;
if(rs.next()){
    detachable=rs.getInt("detachable");
    session.setAttribute("detachable",String.valueOf(detachable));
}

//add by zhouquan 
int hasRecord=Util.getIntValue(request.getParameter("hasRecord"));

if(!id.equals("-1")) {
	rs.execute("SystemRightGroup_sbygroupid",id);
	rs.next() ;
	mark=rs.getString(1);
	description=rs.getString(2);
	notes=rs.getString(3);
}
boolean canedit = HrmUserVarify.checkUserRight("SystemGroupEdit:Edit",user) ;
String imagefilename = "/images/hdSystem.gif";
String titlename = "";
if(!id.equals("-1")) titlename =SystemEnv.getHtmlLabelName(492,user.getLanguage())+" - " + description;
else titlename = SystemEnv.getHtmlLabelName(492,user.getLanguage())+" - " +SystemEnv.getHtmlLabelName(332,user.getLanguage());
String needfav ="1";
String needhelp ="1";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
if(id.equals("-1")) {
    RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:OnSearch(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(!id.equals("-1")) {
	if(canedit && !id.equals("-2")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onEdit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	}

	if(HrmUserVarify.checkUserRight("SystemGroupAdd:Add",user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",SystemRightGroupAdd.jsp,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	}

	if(HrmUserVarify.checkUserRight("SystemRightGroupEdit:Delete",user) && !id.equals("-2")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	}

	if(HrmUserVarify.checkUserRight("SystemRightGroup:Log",user)){
	if(rs.getDBType().equals("db2")){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=28,_self} " ;
    }else{
     RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=28,_self} " ;

    }
	
	RCMenuHeight += RCMenuHeightStep ;
	}
}
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/systeminfo/systemright/SystemRightGroup.jsp,_self} " ;
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
        <%if(id.equals("-1")){%>
        <form name="searchForm" action="SystemRightGroupEdit.jsp?id=-1" method="POST">
        <table class="viewform">
            <tbody>
                <tr>
                <td width="10%"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
                <td class=Field width="*"><input class=InputStyle name=rightName value="<%=rightName%>" ></td>
                <tr>
                <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
            </tbody>
        </table>
        </form>
        <script>
            function OnSearch() {
                document.searchForm.submit();
            }
        </script>
        <%}%>
<FORM id=SystemRightGroupEdit name=SystemRightGroupEdit action=SystemRightGroupOperation.jsp method=post>        
<% if(!id.equals("-1")) {%>


			<table class=ViewForm>
			  <colgroup> <col width="15%"> <col width="85%">
			  <%if(hasRecord == 1){
					%>
					<span class=fontred>&nbsp&nbsp<%=SystemEnv.getHtmlLabelName(17567,user.getLanguage())%></span>
				<%
				}
				%>
			  <tbody> 
			  <tr> 
				<td ><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></td>
				<td class=Field > 
					 <% if(canedit && !id.equals("-2")) {%>
					<input class=InputStyle maxlength=10 size=10 
				  name=mark value="<%=Util.toScreenToEdit(mark,user.getLanguage())%>"onchange='checkinput("mark","markimage")'>
					<SPAN ID=markimage></SPAN>
					<%} else {%><%=Util.toScreen(mark,user.getLanguage())%><%}%>
				  </td>
					  </tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
						<td class=Field><nobr> <% if(canedit && !id.equals("-2")) {%>
					<input class=InputStyle maxlength=60 size=60 
				  name=description value="<%=Util.toScreenToEdit(description,user.getLanguage())%>" onchange='checkinput("description","descriptionimage")'>
					<SPAN ID=descriptionimage></SPAN>
					<%} else {%><%=Util.toScreen(description,user.getLanguage())%><%}%>
				  </td>
					  </tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
					  <tr> 
						<td valign=top><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
						<td class=Field ><% if(canedit && !id.equals("-2")) {%> 
					<textarea class=InputStyle name=notes rows=8 cols=60><%=Util.toScreenToEdit(notes,user.getLanguage())%></textarea>
					<%} else {%> <%=Util.toScreen(notes,user.getLanguage())%><%}%>
					<input type=hidden name=operationType value="">
					<input type=hidden name=groupID value="<%=id%>">
						</td>
					  </tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
					  </tbody> 
					</table>
			<% }%>
				  <br>

			  <table class=ListStyle cellspacing="1">
			   <COLGROUP>
			  <COL width="10%">
              <%if(detachable==1){%>
                  <COL width="30%">
                  <COL width="30%">
                  <COL width="10%">
                  <COL width="10%">
              <%}else{%>
                  <COL width="30%">
                  <COL width="30%">
                  <COL width="20%">
              <%}%>
			 <% if(!id.equals("-1")) {%> <COL width="10%"> <%}%>
				<tbody> 
				 <tr class=Header> 
				 <% if(!id.equals("-1") && canedit && !id.equals("-2")) {%>
				  <td>
				  <%}else{%>
				  <%if(detachable==1){%>
                      <td colspan=5>
                  <%}else{%>
                      <td colspan=4>
                  <%}%>
				  <%}%>
				  <%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%></td>
				  <% if(!id.equals("-1") && canedit && !id.equals("-2")) {%>
				  <td align="right" colspan=5><%=SystemEnv.getHtmlLabelName(193,user.getLanguage())%><button type=button  class=Browser id=SelectRightID onclick="onShowRight()"></button>
				  </td>
				  <% }%>
				</tr>
				<tr class=Header> 
				  <td><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></td>
				  <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
                  <td><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td>
                  <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
                  <%if(detachable==1){%>
                    <td><%=SystemEnv.getHtmlLabelName(17861,user.getLanguage())%></td>
                  <%}%>
			 <% if(!id.equals("-1")  && canedit && !id.equals("-2")) {%>  
				  <td><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></td>
				  <%} %>
				</tr>
				<%	if(!id.equals("-1")) 
                        if(!id.equals("-2")) 
                            rs.execute("systemright_Srightsbygroup",id);
                        else
                            rs.execute("select distinct a.id,a.detachable,a.righttype from SystemRights a left join SystemRightToGroup b on a.id=b.rightid where b.rightid is null order by a.righttype asc,a.id asc ");
					else rs.execute("select id,detachable from SystemRights order by righttype,id");
					int i=0;
					while(rs.next()){
                        index++;
                        String labId = "delLabel_"+index;
                        rightid = rs.getString(1);

                        String coulddetach = rs.getString(2);
                        char separator = Util.getSeparator() ;
                        RecordSet.executeProc("SystemRightsLanguage_SByIDLang", rightid + separator + user.getLanguage());
                        RecordSet.next();
                        String righttype = RecordSet.getString("righttype");
                        String rightname = Util.toScreen(RecordSet.getString("rightname"), user.getLanguage());
                        String rightdesc = Util.toScreen(RecordSet.getString("rightdesc"), user.getLanguage());
                        String typename = "";
                        if(id.equals("-1")&&!rightName.equals("")&&rightname.indexOf(rightName)<0) continue;
                        if (righttype.equals("0")) typename = SystemEnv.getHtmlLabelName(147, user.getLanguage());
                        else if (righttype.equals("1")) typename = SystemEnv.getHtmlLabelName(58, user.getLanguage());
                        else if (righttype.equals("2")) typename = SystemEnv.getHtmlLabelName(189, user.getLanguage());
                        else if (righttype.equals("3")) typename = SystemEnv.getHtmlLabelName(179, user.getLanguage());
                        else if (righttype.equals("8")) typename = SystemEnv.getHtmlLabelName(535, user.getLanguage());
                        else if (righttype.equals("5")) typename = SystemEnv.getHtmlLabelName(259, user.getLanguage());
                        else if (righttype.equals("6")) typename = SystemEnv.getHtmlLabelName(101, user.getLanguage());
                        else if (righttype.equals("7")) typename = SystemEnv.getHtmlLabelName(468, user.getLanguage());
                    if(i==0){
						i=1;
					%>
					<TR class=DataLight>
					<%
					}else{
						i=0;
					%>
					<TR class=DataDark>
					<%
					}
					%>
				  <td><a 
				  href="SystemRightRoles.jsp?id=<%=rightid%>&detachable=<%=detachable%>&coulddetach=<%=coulddetach%>&groupID=<%=id%>"><%=rightid%></a></td>
				  <td><%=rightname%></td>
                  <td><%=rightdesc%></td>
                  <td><%=typename%></td>  
            <%if(detachable==1){%>
                <%if(coulddetach.equals("1")){%>
                    <td><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></td>
                <%}else{%>
                    <td><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></td>
                <%}%>
            <%}%>
			 <% if(!id.equals("-1")  && canedit && !id.equals("-2")) {
                        
                        %>	  <td><a name = "delLabel_<%=index%>" href=
                            "SystemRightGroupOperation.jsp?operationType=deleteright&rightid=<%=rightid%>&groupID=<%=id%>&id=<%=index%>"><img border=0 src="/images/icon_delete.gif"></a></td> <%}%>
				</tr>
			<%
			}
			%>
				
				</tbody> 
			  </table>

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
 
</FORM> 
<script language="javascript">
function onShowRight() {
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/systeminfo/systemright/SystemRightBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			window.location = "SystemRightGroupOperation.jsp?operationType=addright&groupID=<%=id%>&rightid=" + wuiUtil.getJsonValueByIndex(id, 0);
		}
	}
}
</script> 
	  
<script language="javascript">
  
  function onEdit(){
  	if(check_form(document.SystemRightGroupEdit,"mark,description")) {
	  document.SystemRightGroupEdit.operationType.value="editgroup";
	  document.SystemRightGroupEdit.submit();
	}
  }
  function onDelete(){
	  if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")){
		document.SystemRightGroupEdit.operationType.value="deletegroup";
		document.SystemRightGroupEdit.submit();
	  }
  }
  /**
  function onDeleteRight(index,rightId,groupId){
      if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")){
            var address = "SystemRightGroupOperation.jsp?operationType=deleteright&rightid=";
            address+=rightId;
            address+="&groupID=";
            address+=groupId;
            document.all("delLabel_"+index).href=address; 
            document.all("delLabel_"+index).deleteRow(index);           
      }
  }
  **/
</script> 

</BODY></HTML>