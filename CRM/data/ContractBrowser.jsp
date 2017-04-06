<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ContractTypeComInfo" class="weaver.crm.Maint.ContractTypeComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<HTML><HEAD>

<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String name = Util.null2String(request.getParameter("name"));
String typeId = Util.null2String(request.getParameter("typeId"));
String status = Util.null2String(request.getParameter("status"));
String sqlwhere = "";
String userid = ""+user.getUID();
String logintype = ""+user.getLogintype();

int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!name.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.name like '%";
		sqlwhere += Util.fromScreen2(name,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and t1.name like '%";
		sqlwhere += Util.fromScreen2(name,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!typeId.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.typeId = " + typeId;
	}
	else{
		sqlwhere += " and t1.typeId = " + typeId;
	}
}
if(!status.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.status = " + status;
	}
	else{
		sqlwhere += " and t1.status = " + status;
	}
}
if (sqlwhere.equals("")) {
	sqlwhere = "where t1.id != 0" ;
}

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>


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

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="ContractBrowser.jsp" method=post>
<input type=hidden name=sqlwhere value="<%=sqlwhere1%>">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>

</DIV>
<table width=100% class=ViewForm>
<TR class=Spacing style="height: 1px"><TD class=Line1 colspan=4></TD></TR>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
<TD width=35% class=field><input class=InputStyle  name=name value="<%=name%>"></TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(6083,user.getLanguage())%></TD>
<TD width=15% class=Field>
          <select class=InputStyle id=typeId 
              name=typeId>
			  <option value="" <%if(typeId.equals("")){%> selected <%}%>> </option>
          <% 
            while(ContractTypeComInfo.next()){ %>
            <option value=<%=ContractTypeComInfo.getContractTypeid()%> <%if(typeId.equals(ContractTypeComInfo.getContractTypeid())){%> selected <%}%>><%=ContractTypeComInfo.getContractTypename()%></option>
            <%}%>
			</select>
</TD>
</TR><tr style="height: 1px"><td class=Line colspan=4></td></tr>

<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
<TD width=35% class=field>
  <select class=InputStyle id=status  name=status >
    <option value="" <%if(status.equals("")){%> selected <%}%> ></option>
    <option value=0 <%if(status.equals("0")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></option>
    <option value=1 <%if(status.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%></option>
    <option value=2 <%if(status.equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(6095,user.getLanguage())%></option>
	 <option value=3 <%if(status.equals("3")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></option>
    </TD>
<TD width=15%></TD>
<TD width=15% class=Field></TD>
</TR><tr style="height: 1px"><td class=Line colspan=4></td></tr>

<TR class=Spacing style="height: 1px"><TD class=Line1 colspan=4></TD></TR>
</table>
<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 width="100%">
<TR class=DataHeader>
<TH width=30%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(6083,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TH>
</tr><TR class=Line style="height: 1px"><TH colSpan=4></TH></TR>
<%
String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
int i=0;
if(logintype.equals("1")){
	sqlwhere = "select distinct t1.* from CRM_Contract t1 ,"+leftjointable+" t2 "+sqlwhere+" and t1.crmId = t2.relateditemid order by t1.id  desc ";
}else{
	sqlwhere = "select distinct t1.* from CRM_Contract t1 ,CRM_CustomerInfo t2 "+sqlwhere+" and t1.crmId = t2.id and t2.agent=" + userid + " order by t1.id  desc ";
}

RecordSet.execute(sqlwhere);

while(RecordSet.next()){
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
	<TD><%=RecordSet.getString("id")%></A></TD>
	<TD><%=RecordSet.getString("name")%></TD>
	<TD><%=ContractTypeComInfo.getContractTypename(RecordSet.getString("typeId"))%></TD>
	<TD>
	<%
		  String statusStr = "";
		  switch (RecordSet.getInt("status"))
		  {
			 case 0 : statusStr=SystemEnv.getHtmlLabelName(615,user.getLanguage()); break;
			 case 1 : statusStr=SystemEnv.getHtmlLabelName(359,user.getLanguage()); break;
			 case 2 : statusStr=SystemEnv.getHtmlLabelName(6095,user.getLanguage()); break;
			 case 3 : statusStr=SystemEnv.getHtmlLabelName(555,user.getLanguage()); break;
			 default: break;
		  }
		  %>
	<%=statusStr%>
	</TD>
</TR>
<%}%>
</TABLE></FORM>
              
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>     
<script type="text/javascript">
jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
			
		window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
			window.parent.close()
		})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})

})


function submitClear()
{
	window.parent.returnValue = {id:"",name:""};
	window.parent.close()
}
  
</script>     
</BODY></HTML>