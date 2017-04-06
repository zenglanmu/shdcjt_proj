<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet4" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetP" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ContractTypeComInfo" class="weaver.crm.Maint.ContractTypeComInfo" scope="page" />
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page" />
<jsp:useBean id="RecordSetEX" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ContractComInfo" class="weaver.crm.Maint.ContractComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
String CustomerID = request.getParameter("CustomerID");
String contractId = request.getParameter("id");
String isrequest = Util.null2String(request.getParameter("isrequest"));
int msg = Util.getIntValue(request.getParameter("msg"),0);
CustomerID = ContractComInfo.getContractcrmid(contractId);
int rownum=0;
int rownum1=0;
String needcheck="before";

String useridcheck=""+user.getUID();

boolean canview=false;
boolean canedit=false;
boolean canappove=true;

String ViewSql="select * from ContractShareDetail where contractid="+contractId+" and usertype="+user.getLogintype()+" and userid="+user.getUID();

RecordSetV.executeSql(ViewSql);

while(RecordSetV.next())
{
	 canview=true;
	 if(RecordSetV.getString("sharelevel").equals("2")){
		canedit=true;	  
	 }else if (RecordSetV.getString("sharelevel").equals("3") || RecordSetV.getString("sharelevel").equals("4")){
		canedit=true;
	 }
}
String sql = "select * from bill_crmcontract where contractid="+contractId;
RecordSetV.executeSql(sql);
if(RecordSetV.next()){
	canappove = false;
}
if(!canview && isrequest.equals("1")){
	RecordSetV.executeSql("insert into ContractShareDetail (contractid,userid,usertype,sharelevel) values ("+contractId+","+user.getUID()+",1,1)");
	canview = true;
}
if (!canview) response.sendRedirect("/notice/noright.jsp") ;
/*check right end*/

RecordSet.executeProc("CRM_Contract_SelectById",contractId);
RecordSet.next();

if(RecordSet.getInt("status")==0&&!canappove) canappove = true;
if(RecordSet.getInt("status")==-1) canappove = false;
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(614,user.getLanguage()) + SystemEnv.getHtmlLabelName(367,user.getLanguage())+" : " + "<a href =/CRM/data/ViewCustomer.jsp?CustomerID=" + CustomerID + ">" +  Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(CustomerID),user.getLanguage()) + "</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

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
		<%if (msg==1) {%>
		<span style="color:red"><%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(16248,user.getLanguage())%>!</span>
		<%}
		if (msg==-1) {%>
		<span style="color:red"><%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15173,user.getLanguage())%>!</span>
		<%}%>
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<FORM id=weaver name=weaver action="/CRM/data/ContractOperation.jsp" method=post  >
<input id="savePart" name="savePart" type="hidden">
<DIV>
<!-- status:0为提交，1为审批结束状态,2为签单,3为执行完成,增加一个新的状态：-1，用来表示审批进行中状态-->
<%if (canedit && RecordSet.getInt("status")==0) {%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:location='/CRM/data/ContractEdit.jsp?CustomerID="+CustomerID+"&contractId="+contractId+"',_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>

<%if (canedit && (RecordSet.getInt("status")==0)&& canappove) {%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(15143,user.getLanguage())+",javascript:location='/CRM/data/ContractOperation.jsp?method=approve&crmId="+CustomerID+"&contractId="+contractId+"',_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>

<%if (canedit && (RecordSet.getInt("status")==1)) {%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(6095,user.getLanguage())+",javascript:location='/CRM/data/ContractOperation.jsp?method=isCustomerCheck&crmId="+CustomerID+"&contractId="+contractId+"',_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>

<%if (canedit && (RecordSet.getInt("status")==2)) {%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(15144,user.getLanguage())+",javascript:location='/CRM/data/ContractOperation.jsp?method=isSuccess&crmId="+CustomerID+"&contractId="+contractId+"',_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>

<%if(canedit && RecordSet.getInt("status")>=1){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(244,user.getLanguage())+",javascript:location='/CRM/data/ContractOperation.jsp?method=reopen&crmId="+CustomerID+"&contractId="+contractId+"',_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>

<%if(canedit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(2112,user.getLanguage())+",javascript:location='/CRM/data/ContractShareAdd.jsp?contractId="+contractId+"&CustomerID="+CustomerID+"',_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}%>


<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
  
</DIV>
  <input type="hidden" name="method" value="view">
  <input type="hidden" name="contractId" value="<%=contractId%>">
  <input type="hidden" name="crmId" value="<%=CustomerID%>">
  <input type="hidden" name="ProjID" value="<%=RecordSet.getString("projid")%>">
  <input type="hidden" name="name" value="<%=RecordSet.getString("name")%>">
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="49%">
  <COL width=10>
  <COL width="49%">
  <TBODY>
  <TR>

	<TD vAlign=top>
	
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
        <TBODY>
        <TR class=Title>
         <TH colSpan=2><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
         </TR>
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(614,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2> </td></tr>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(6083,user.getLanguage())%></TD>
          <TD class=Field> <%=Util.toScreen(ContractTypeComInfo.getContractTypename(RecordSet.getString("TypeId")),user.getLanguage())%>
            </TD>
         </TR><tr  style="height: 1px"><td class=Line colspan=2> </td></tr>        
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(1265,user.getLanguage())%></TD>
          <TD class=Field> 
			<%if(!RecordSet.getString("docId").equals("")){
				ArrayList arrayDocids = Util.TokenizerString(RecordSet.getString("docId"),",");
				for(int i=0;i<arrayDocids.size();i++){
			%>
						<A href='/docs/docs/DocDsp.jsp?id=<%=""+arrayDocids.get(i)%>'><%=DocComInfo.getDocname(""+arrayDocids.get(i))%></a>&nbsp
			<%}}%>
		  </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2> </td></tr>   	
		<TR>
		 <TD><%=SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(534,user.getLanguage())%></TD>
          <TD class=Field>
		  <%=Util.toScreen(RecordSet.getString("price"),user.getLanguage())%>
		  </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2> </td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></TD>
          <TD class=Field><a href="/CRM/data/ViewCustomer.jsp?log=n&CustomerID=<%=RecordSet.getString("crmId")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("crmId")),user.getLanguage())%></a>
            </TD>
         </TR><tr  style="height: 1px"><td class=Line colspan=2> </td></tr>

          <TR>
          <TD><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></TD>
          <TD class=Field><a href='/CRM/data/ViewContacter.jsp?log=n&ContacterID=<%=RecordSet.getString("contacterId")%>'> <%=Util.toScreen(CustomerContacterComInfo.getCustomerContacternameByID(RecordSet.getString("contacterId")),user.getLanguage())%></a>
		  </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2> </td></tr>
          <%
          	String sellChanceIdSpanTemp = "";
          	String sellChanceId = "";
          	String sellChanceId2 = Util.toScreen(RecordSet.getString("sellChanceId"),user.getLanguage());
          	if(!sellChanceId2.equals("")){
	          	String sellChanceName = "";
	          	RecordSet2.executeSql("select subject from CRM_SellChance where id="+sellChanceId2);
	          	if(RecordSet2.next()){
	          		sellChanceName = RecordSet2.getString("subject");
	          		sellChanceIdSpanTemp = "<A href='/CRM/sellchance/ViewSellChance.jsp?id="+sellChanceId2+"'>"+sellChanceName+"</A>";
	          	}
          	}
          %>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(2227,user.getLanguage())%></TD>
          <TD class=Field>
          <span id=sellChanceIdSpan><%=sellChanceIdSpanTemp%></span>
          <INPUT class=InputStyle type=hidden name="sellChanceId" value="<%=sellChanceId%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2> </td></tr> 

		<%
		RecordSetC.executeProc("CRM_CustomerInfo_SelectByID",RecordSet.getString("crmId")); 
		RecordSetC.next();
		%>
         <TR>
		<TD><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(6097,user.getLanguage())%></TD>
		<TD class=Field><%=RecordSetC.getString("CreditAmount")%></TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2> </td></tr>

         </TBODY>
    </TABLE>
    </TD>

    <TD></TD>

    <TD vAlign=top>

    	<TABLE class=ViewForm>
        <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
        <TBODY>
        <TR class=Title>
        <TH colSpan=2>&nbsp</TH>
        </TR>
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>

		 <TR>
          <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
          <TD class=Field>
		  <%
		  String statusStr = "";
		  switch (RecordSet.getInt("status"))
		  {
			 case 0 : statusStr=SystemEnv.getHtmlLabelName(615,user.getLanguage()); break;
			 case -1 : statusStr=SystemEnv.getHtmlLabelName(2242,user.getLanguage()); break;
			 case 1 : statusStr=SystemEnv.getHtmlLabelName(1423,user.getLanguage()); break;
			 case 2 : statusStr=SystemEnv.getHtmlLabelName(6095,user.getLanguage()); break;
			 case 3 : statusStr=SystemEnv.getHtmlLabelName(555,user.getLanguage()); break;
			 default: break;
		  }
		  %>
		  <%=statusStr%>
		  </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2> </td></tr>

		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
          <TD class=Field><a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("manager")%>">		 
		  <%= Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("manager")),user.getLanguage())%></a>
		 </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2> </td></tr>
        <input type="hidden" name = "manager" value="<%=RecordSet.getString("manager")%>">
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1970,user.getLanguage())%></TD>
          <TD class=Field> <%=Util.toScreen(RecordSet.getString("startDate"),user.getLanguage())%>
          </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2> </td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
          <TD class=Field> <%=Util.toScreen(RecordSet.getString("endDate"),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2> </td></tr>

         <TR>
          	<TD><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></TD>
            <TD class=Field><A href="/proj/data/ViewProject.jsp?ProjID=<%=RecordSet.getString("projid")%>"><%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(RecordSet.getString("projid")),user.getLanguage())%></a>
            </TD>
      	  </TR><tr  style="height: 1px"><td class=Line colspan=2> </td></tr>

		  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6078,user.getLanguage())%></TD>
          <TD class=Field>
		  <%if (RecordSet.getInt("status")==2 && canedit) {%>
			  <INPUT type=checkbox name="isremind"  value=0 <% if (RecordSet.getInt("isRemind") == 0) {%>checked<%}%> onclick="changeDiv()">
		  <%} else {
			   if (RecordSet.getInt("isRemind") == 0) {%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%} 
			   else 
			   {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
		   <%}%>
		</TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2> </td></tr>


		<TR>
		<TD colspan=2>
		<div id=beforeDiv style="display:<%if (RecordSet.getInt("isRemind") == 0) {%>''<%} else {%>'none'<%}%>">
			<TABLE class=ViewForm>
			<COLGROUP>
			<COL width="20%">
			<COL width="80%">
			<TBODY>
			<TR>
				 <TD><%=SystemEnv.getHtmlLabelName(6077,user.getLanguage())%></TD>
				 <TD class=Field>
					<%if (RecordSet.getInt("status")==2 && canedit) {%>
						<INPUT class=InputStyle maxLength=2 size=10 name="before" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("before")' onchange='checkinput("before","beforeimage")' value = "<%=RecordSet.getString("remindDay")%>" ><SPAN id=beforeimage></SPAN>
					<%} else {%>
						<%=Util.toScreen(RecordSet.getString("remindDay"),user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
					<%}%>
				  </TD>
			 </TR><tr  style="height: 1px"><td class=Line colspan=2> </td></tr>

			 </TBODY>
			 </TABLE>
		</div>
		</TD>
		</TR>

		<TR>	<TD><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(6098,user.getLanguage())%></TD>
		<TD class=Field><%=RecordSetC.getString("CreditTime")%></TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2> </td></tr>
        </TBODY>
    </TABLE>
    </TD>
    </TR></TBODY></TABLE>

<%
int colNumber=10;
if (RecordSet.getInt("status")>=2) {
    colNumber=14;
}else{
    colNumber=10;
}
%>
   <TABLE class=ListStyle cellspacing=1  cols="<%=colNumber%>" id="oTable">
   <input type="hidden" name = "proId" >
  <input type="hidden" name = "proInfoId" >
  <input type="hidden" name = "proFactNum" >
  <input type="hidden" name = "proFactDate" >
  <input type="hidden" name = "proFormNum" >
  <TABLE class=ListStyle cellspacing=1  cols="<%=colNumber%>" id="oTable">

     
      <TR bgcolor="#FFFFFF">
       <TH colspan=2 align="left"><%=SystemEnv.getHtmlLabelName(15115,user.getLanguage())%></TH>
       <Td align=right colSpan="<%if (RecordSet.getInt("status")>=2) {%>11<%} else {%>8<%}%>">
        <%if (canedit && (RecordSet.getInt("status")==2)) {%>
        <TD align=right >
        <BUTTON  class=Btn accessKey=X type=button onclick="doSave(2)"><U>X</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
        </TD>
        <%}%>  
      </Td>       
      </TR>

    	<tr class=header>
           <td class=Field>&nbsp;</td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(15129,user.getLanguage())%></td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(649,user.getLanguage())%></td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(1330,user.getLanguage())%></td>
		   <td class=Field><%=SystemEnv.getHtmlLabelName(15130,user.getLanguage())%></td>
           <td class=Field><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></td>
		   <td class=Field><%=SystemEnv.getHtmlLabelName(1050,user.getLanguage())%></td>
		   <%if (RecordSet.getInt("status")>=2) {%>
		   <td class=Field><%=SystemEnv.getHtmlLabelName(15465,user.getLanguage())%></td>
		   <td class=Field><%=SystemEnv.getHtmlLabelName(15145,user.getLanguage())%></td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(15146,user.getLanguage())%></td>
		   <td class=Field><%=SystemEnv.getHtmlLabelName(15147,user.getLanguage())%></td>
		   <%}%>
		   <td class=Field><%=SystemEnv.getHtmlLabelName(15148,user.getLanguage())%></td>
    	</tr>
		<TR class=Line><TD colSpan=<%=colNumber%> style="padding: 0px"></TD></TR>

		<%
		int i=0;
		boolean isLight = true;
		RecordSetP.executeProc("CRM_ContractProduct_Select",contractId);
		while (RecordSetP.next()) {
		if (isLight) {%>
		<tr class=datalight>
		<%} else {%>
		<tr class=datadark>
		<%}%>
           <td >&nbsp;
			<input type="hidden" name = "productId_<%=i%>" value="<%=RecordSetP.getString("id")%>">
			</td>
    	   <td ><a href = "/lgc/asset/LgcAsset.jsp?paraid=<%=RecordSetP.getString("productId")%>"><%=Util.toScreen(AssetComInfo.getAssetName(RecordSetP.getString("productId")),user.getLanguage())%></a></td>
    	   <td ><%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(RecordSetP.getString("unitId")),user.getLanguage())%></td>
    	   <td ><%=Util.toScreen(CurrencyComInfo.getCurrencyname(RecordSetP.getString("currencyId")),user.getLanguage())%></td>
    	   <td ><%=RecordSetP.getString("price")%></td>
		   <td ><%=RecordSetP.getString("depreciation")%>%</td>
           <td ><%=RecordSetP.getString("number_n")%></td>
    	   <td ><%=RecordSetP.getString("sumPrice")%></td>
		   <td ><%=RecordSetP.getString("planDate")%></td>
			<%if (RecordSet.getInt("status") == 2 && canedit) {%>

				<td >
				<input type=text  name="productFormNum_<%=i%>" size=9 class="InputStyle">	
				</td>
				<td >
				<input type=text  name="productFactNumber_<%=i%>" onKeyPress='ItemCount_KeyPress()' onBlur="checknumber1(this)" size=9 value="0" class="InputStyle">
				</td>
				<td>
				<BUTTON type=button class=Calendar onclick='onShowDate("productFactDatespan_<%=i%>","productFactDate_<%=i%>")'></BUTTON> <SPAN id="productFactDatespan_<%=i%>"><%=RecordSetP.getString("factDate")%></SPAN> <input type="hidden" name = "productFactDate_<%=i%>" value="<%=RecordSetP.getString("factDate")%>">
				</td>
				<td>
				<INPUT type=checkbox name="productisFinish_<%=i%>"  value=0 <% if (RecordSetP.getInt("isFinish") == 0) {%>checked<%}%>>
				</td>

			<%} else if (RecordSet.getInt("status") >= 2){%>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>
					<%if (RecordSetP.getInt("isFinish") == 0) {%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
				</td>

			<%}%>

		   <td >
			<%if (RecordSet.getInt("status")==2 && canedit) {%>
				<INPUT type=checkbox name="productisRemind_<%=i%>"  value="0" <% if (RecordSetP.getInt("isRemind") == 0) {%>checked<%}%>>
			<%}else {
					if (RecordSetP.getInt("isRemind") == 0) {%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>	
			<%}%>
			</td>
    	</tr>
		<!--加入发货记录-->
		
		<%//发货记录
		String proId= RecordSetP.getString("id");
		rs1.executeProc("CRM_ContractProInfo_Select",proId);
		int k=0;
		while(rs1.next()){  
			String proInfoId= rs1.getString("id");
			k++;
		%>
	   
			<%if (isLight) {%>
			<tr class=datalight>
			<%} else {%>
			<tr class=datadark>
			<%}%>
			
			<%if (RecordSet.getInt("status")==2 && canedit) {%>
				<td >&nbsp;<input type="hidden" name = "proid_<%=proId%>_<%=k%>" value="<%=proInfoId%>"></td>  
				<td align=right colspan=8><img border=0 src="/images/ArrowRightBlue.gif"></img>
				</td>
				<td>
					<input type=text  name="proFormNum_<%=proId%>_<%=k%>" size=9 value="<%=Util.toScreen(rs1.getString("formNum"),user.getLanguage())%>" class="InputStyle">
				</td>
				<td>
					<input type=text  name="proFactNum_<%=proId%>_<%=k%>" onKeyPress='ItemNum_KeyPress()' onBlur="checknumber1(this)" size=9 value="<%=Util.toScreen(rs1.getString("factNum"),user.getLanguage())%>" class="InputStyle"></td>
				<td>
					<BUTTON type=button class=Calendar onclick='onShowDate("proFactDateSpan_<%=proId%>_<%=k%>","proFactDate_<%=proId%>_<%=k%>")'></BUTTON> <SPAN id="proFactDateSpan_<%=proId%>_<%=k%>"><%=rs1.getString("factDate")%></SPAN> <input type="hidden" name = "proFactDate_<%=proId%>_<%=k%>" value="<%=rs1.getString("factDate")%>"></td>
				
				<td  colspan=2>
					<a href='javascript: doSave_1("<%=proId%>","<%=k%>","<%=proInfoId%>")'><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></a>&nbsp
					<a href="/CRM/data/ContractOperation.jsp?method=prodel&crmId=<%=CustomerID%>&ProjID=<%=RecordSet.getString("projid")%>&contractId=<%=contractId%>&proInfoId=<%=proInfoId%>&proId=<%=proId%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a></td>

			<%}else if (RecordSet.getInt("status") >= 2){%>
					<td >&nbsp;</td>                
					<td align=right colspan=8><img border=0 src="/images/ArrowRightBlue.gif"></img></td>
					<td><%=rs1.getString("formNum")%></td>
					<td><%=rs1.getString("factNum")%></td>
					<td><%=rs1.getString("factDate")%></td>            
					<td >&nbsp</td>
					<td >&nbsp</td>
				<%}%>
			</tr>  	
		<%}%> 
		<%if (RecordSet.getInt("status") >= 2){%>
		<%if (isLight) {%>
			<tr class=datalight>
			<%} else {%>
			<tr class=datadark>
			<%}%>	
				<td colspan=9>&nbsp;</td>			
				<td align=left style="color:red">
				<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%>
				</td>
				<td align=left style="color:red" colspan=4onShowMDoc>
				<%=Util.getIntValue(RecordSetP.getString("factnumber_n"),0)%>
				</td>
			</tr>
		<%}%>

		<%
		isLight =!isLight;
		i++;	
		}
		rownum = RecordSetP.getCounts();
		%>
		<input type="hidden" name="rownum" value="<%=rownum%>">  
   </table>  
 
<BR><BR>

  <input type="hidden" name = "PayInfoId" >
  <input type="hidden" name = "pay_id" >
  <input type="hidden" name = "paytrueprice" >
  <input type="hidden" name = "paytrueday" >
  <input type="hidden" name = "payFormNum" >



<%
if (RecordSet.getInt("status")>=2) {
    colNumber=13;
}else{
    colNumber=10;
}
%>
   <TABLE class=ListStyle cellspacing=1  cols="<%if (RecordSet.getInt("status")>=2) {%>13<%} else {%>8<%}%>" id="mTable">
       
      <TR bgcolor="#FFFFFF">
       <TH colspan=2 align="left"><%=SystemEnv.getHtmlLabelName(15131,user.getLanguage())%></TH>
       <Td align=right colSpan="<%if (RecordSet.getInt("status")>=2) {%>10<%} else {%>6<%}%>">
      </Td> 
        <%if (canedit && (RecordSet.getInt("status")==2)) {%>
        <TD align=right >
        <BUTTON class=Btn accessKey=Z type=button onclick="doSave(3)"><U>Z</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
        </TD>
        <%}%>      
      </TR>
<%if (RecordSet.getInt("status")>=2) {%>
    <COLGROUP>
    <COL width=2%>
    <COL width=12%>
    <COL width=9%>
    <COL width=9%>
    <COL width=10%>
    <COL width=12%>
    <COL width=9%>
    <COL width=7%>
    <COL width=6%>
    <COL width=9%>
    <COL width=10%>
    <COL width=3%>
	<COL width=3%>
<%}%>  
	<tr class=header>

           <td class=Field>&nbsp;</td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(15132,user.getLanguage())%></td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(15133,user.getLanguage())%></td>
           <td class=Field><%=SystemEnv.getHtmlLabelName(1462,user.getLanguage())%></td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(15134,user.getLanguage())%></td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(15135,user.getLanguage())%></td>
		   <td class=Field><%=SystemEnv.getHtmlLabelName(15136,user.getLanguage())%></td>
		   <%if (RecordSet.getInt("status")>=2) {%>
           <td class=Field><%=SystemEnv.getHtmlLabelName(1811,user.getLanguage())%></td>
		   <td class=Field><%=SystemEnv.getHtmlLabelName(15465,user.getLanguage())%></td>
		   <td class=Field><%=SystemEnv.getHtmlLabelName(15149,user.getLanguage())%></td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(15150,user.getLanguage())%></td>
		   <td class=Field><%=SystemEnv.getHtmlLabelName(15147,user.getLanguage())%></td>
		   <%}%>
		   <td class=Field><%=SystemEnv.getHtmlLabelName(15148,user.getLanguage())%></td>
    	</tr>
		<TR class=Line><TD colSpan=<%=colNumber%> style="padding: 0px"></TD></TR>
		<%
		int j=0;
		isLight = true;
		RecordSetM.executeProc("CRM_ContractPayMethod_Select",contractId);
		while (RecordSetM.next()) {
		if (isLight) {%>
		<tr class=datalight>
		<%} else {%>
		<tr class=datadark>
		<%}%>
			<td >&nbsp;
			<input type="hidden" name = "paymethodId_<%=j%>" value="<%=RecordSetM.getString("id")%>">
			</td>
    	   <td ><%=RecordSetM.getString("prjName")%></td>
    	   <td ><% if (RecordSetM.getInt("typeId") == 1) {%><%=SystemEnv.getHtmlLabelName(15137,user.getLanguage())%><%} else {%><%=SystemEnv.getHtmlLabelName(15138,user.getLanguage())%><%}%></td>
           <td ><%=Util.toScreen(BudgetfeeTypeComInfo.getBudgetfeeTypename(RecordSetM.getString("feetypeid")),user.getLanguage())%></td>
    	   <td ><%=RecordSetM.getString("payPrice")%></td>
    	   <td ><%=RecordSetM.getString("payDate")%></td>
			<td ><%=RecordSetM.getString("qualification")%></td>

            <%
            double price_cc= Util.getDoubleValue(RecordSetM.getString("factPrice"),0);
            double sum = Util.getDoubleValue(RecordSetM.getString("payPrice"));
            double remainsum = sum - price_cc;    
            //如果金额巨大，机器用科学计数法的，要把它转化为String
            String SS=""+remainsum; 
            %>
						
			
			<%if (RecordSet.getInt("status")==2 && canedit) {%>
                <td><%if(SS.indexOf("E") != -1){ //modify TD2084 by xys%>
                    		<%=Util.getPointValue(Util.getfloatToString(""+remainsum))%>
                    <%}else{%>
                    		<%=Util.getPointValue(""+remainsum)%>
                    <%}%>
                </td>

				<td >
				<input type=text  name="paymethodFormNum_<%=j%>" size=7>	
				</td>
				<td >
				<input type=text  name="paymethodFactPrice_<%=j%>" onKeyPress='ItemNum_KeyPress()' onBlur="checknumber1(this)" size=7 value="0.00">	
				</td>
				<td>
				<BUTTON type=button class=Calendar onclick='onShowDate("paymethodFactDatespan_<%=j%>","paymethodFactDate_<%=j%>")'></BUTTON> <SPAN id="paymethodFactDatespan_<%=j%>"></SPAN> <input type="hidden" name = "paymethodFactDate_<%=j%>" value="">
				</td>
				<td>
				<INPUT type=checkbox name="paymethodisFinish_<%=j%>"  value=0 width=5% <% if (RecordSetM.getInt("isFinish") == 0) {%>checked<%}%>>
				</td>

			<%} else if (RecordSet.getInt("status") >= 2){%>
                <td><%if(SS.indexOf("E") != -1){ //modify TD2084 by xys%>
                    		<%=Util.getPointValue(Util.getfloatToString(""+remainsum))%>
                    <%}else{%>
                    		<%=Util.getPointValue(""+remainsum)%>
                    <%}%>
                </td>
				<td >&nbsp;</td>
				<td >&nbsp;</td>
				<td >&nbsp;</td>
				</td>
				<td>
					<%if (RecordSetM.getInt("isFinish") == 0) {%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
				</td>

			<%}%>
           <td >
				<%if (RecordSet.getInt("status")==2 && canedit) {%>
					<INPUT type=checkbox name="paymethodisRemind_<%=j%>"  value=0 <% if (RecordSetM.getInt("isRemind") == 0) {%>checked<%}%>>
				<%} else {	
					 if (RecordSetM.getInt("isRemind") == 0) {%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
				<%}%>
			</td>

    <%//先查看该付款有否记录
    String payid= RecordSetM.getString("id");
    rs.executeProc("CRM_PayInfo_SelectAll",payid);
    int k=0;
    if(rs.getCounts()>0){
        while(rs.next()){    
            String PayInfoId= rs.getString("id");
    %>
   
		<%if (isLight) {%>
		<tr class=datalight>
		<%} else {%>
		<tr class=datadark>
		<%}%>
        
        <%if (RecordSet.getInt("status")==2 && canedit) {%>
            <td >&nbsp;<input type="hidden" name = "payid_<%=payid%>_<%=k%>" value="<%=PayInfoId%>"></td>  
            <td align=right colspan=7><img border=0 src="/images/ArrowRightBlue.gif"></img>
            </td>
			<td>
                <input type=text  name="payFormNum_<%=payid%>_<%=k%>" size=7 value="<%=rs.getString("formNum")%>">
			</td>
            <td>
                <input type=text  name="trueprice_<%=payid%>_<%=k%>" onKeyPress='ItemNum_KeyPress()' onBlur="checknumber1(this)" size=7 value="<%=rs.getString("factprice")%>"></td>
            <td>
                <BUTTON type=button class=Calendar onclick='onShowDate("tureDatespan_<%=payid%>_<%=k%>","tureDate_<%=payid%>_<%=k%>")'></BUTTON> <SPAN id="tureDatespan_<%=payid%>_<%=k%>"><%=rs.getString("factdate")%></SPAN> <input type="hidden" name = "tureDate_<%=payid%>_<%=k%>" value="<%=rs.getString("factdate")%>"></td>
            
            <td  colspan=2>
                <a href='javascript: doSave_0("<%=payid%>","<%=k%>","<%=PayInfoId%>")'><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></a>&nbsp
                <a href="/CRM/data/ContractOperation.jsp?method=paydel&crmId=<%=CustomerID%>&ProjID=<%=RecordSet.getString("projid")%>&contractId=<%=contractId%>&PayInfoId=<%=PayInfoId%>&payid=<%=payid%>"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a></td>

        <%}else if (RecordSet.getInt("status") >= 2){%>
                <td >&nbsp;</td>                
                <td align=right colspan=7><img border=0 src="/images/ArrowRightBlue.gif"></img></td>
				<td><%=rs.getString("formNum")%></td>
                <td><%=rs.getString("factprice")%></td>
                <td><%=rs.getString("factdate")%></td>            
                <td >&nbsp</td>
                <td >&nbsp</td>
            <%}%>
        </tr>  
 
            
    <%
        k++;
        }%> 
    <%}%>

		<%if (RecordSet.getInt("status") >= 2){%>
		<%if (isLight) {%>
			<tr class=datalight>
			<%} else {%>
			<tr class=datadark>
			<%}%>	
				<td colspan=8>&nbsp;</td>			
				<td align=left style="color:red">
				<%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%>
				</td>
				<td align=left style="color:red" colspan=4>
				<%=Util.getPointValue(RecordSetM.getString("factPrice"),2,"0")%>
				</td>
			</tr>
		<%}%>

		<%
		isLight =!isLight;
		j++;
		}
		rownum1 = RecordSetM.getCounts();
		%>
		<input type="hidden" name="rownum1" value="<%=rownum1%>">  
   </table> 
   </FORM>

<%if (RecordSet.getInt("status")>=2) {%>
<!--BR><BR>
	<FORM id=Exchange name=Exchange action="/CRM/data/ContractExchangeOperation.jsp" method=post>
	 <input type="hidden" name="method1" value="add">
	 <input type="hidden" name="ForContractId" value="<%=contractId%>">
	 <input type="hidden" name="ForCustomerID" value="<%=CustomerID%>">
   <TABLE class=ListStyle cellpadding=1  >
      <TR class=Title>
       <TH >备注</TH>
       <Td align=right >
		<BUTTON class=Btn accessKey=S onclick="doSave1()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
      </Td>       
      </TR>
	   <TR class=Spacing>
    	  <TD class=Line1 colSpan="2"></TD>
	   </TR>
	   <TR >
    	  <TD class=Field colSpan="2">
		  <TEXTAREA class=InputStyle NAME=ExchangeInfo ROWS=3 STYLE="width:100%"></TEXTAREA>
		 </TD>
	   </TR>
	 </TABLE>
	</FORM>

  <TABLE class=ListStyle>
        <COLGROUP>
		<COL width="30%">
  		<COL width="30%">
  		<COL width="40%">
        <TBODY>
	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></th>
	    </TR>
<%
isLight = false;
RecordSetC.executeProc("CRM_ContractExch_Select",contractId);
while(RecordSetC.next())
{
		if(isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
          <TD><%=RecordSetC.getString("createDate")%></TD>
          <TD><%=RecordSetC.getString("createTime")%></TD>
          <TD>
			<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetC.getString("creater")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetC.getString("creater")),user.getLanguage())%></a>
		  </TD>
        </TR>
<%		if(isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
          <TD colSpan=3><%=Util.toScreen(RecordSetC.getString("remark"),user.getLanguage())%></TD>
        </TR>
<%
	isLight = !isLight;
}
%>	  </TBODY>
	  </TABLE -->
<%}%>

	<FORM id=Exchange name=Exchange action="/discuss/ExchangeOperation.jsp" method=post>
	 <input type="hidden" name="method1" value="add">
     <input type="hidden" name="types" value="CH">	
     <input type="hidden" name="CustomerID" value="<%=CustomerID%>">	
	 <input type="hidden" name="sortid" value="<%=contractId%>">
   <TABLE class=ListStyle cellspacing=1  >
      <TR class=header>
       <TH ><%=SystemEnv.getHtmlLabelName(15153,user.getLanguage())%></TH>
       <Td align=right >
		<BUTTON type=button class=Btn accessKey=S onclick="doSave1()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
      </Td>       
      </TR>
<TR class=Line><TD colSpan=2></TD></TR>
	   <TR >
    	  <TD class=Field colSpan="2">
		  <TEXTAREA class=InputStyle NAME=ExchangeInfo ROWS=3 STYLE="width:100%"></TEXTAREA>
		 </TD>
	   </TR>
       <TR>
       
        </TR>
	 </TABLE>
  <TABLE class=ViewForm>
    <TR class=title>
          <TD style="width: 10%"><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></TD>
          <TD class=field style="width: 90%">
          
             <INPUT class="wuiBrowser" _displayTemplate="<a href=/docs/docs/DocDsp.jsp?id=#b{id}>#b{name}</a>&nbsp" 
        	 
        	_url="/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp" _param="documentids" type=hidden name=docids >
		  </TD>
        
        </TR>
	 </TABLE>
	</FORM>
  <TABLE class=ListStyle cellspacing=1>
        <COLGROUP>
		<COL width="15%">
  		<COL width="15%">
  		<COL width="15%">
        <COL width="55%">
        <TBODY>
	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></th>
          <th><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></th>
	    </TR>
<TR class=Line><TD colSpan=4 style="padding: 0px"></TD></TR>
<%
 isLight = false;
char flag0=2;
int nLogCount=0;
RecordSetEX.executeProc("ExchangeInfo_SelectBID",contractId+flag0+"CH");
while(RecordSetEX.next())
{
nLogCount++;
if (nLogCount==2) {
%>
</tbody></table>
<div  id=WorkFlowDiv style="display:none">
    <table class=ListStyle>
           <COLGROUP>
		<COL width="15%">
  		<COL width="15%">
  		<COL width="15%">
        <COL width="55%">
    <tbody> 
<%}
		if(isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
          <TD><%=RecordSetEX.getString("createDate")%></TD>
          <TD><%=RecordSetEX.getString("createTime")%></TD>
          <TD>
			<%if(Util.getIntValue(RecordSetEX.getString("creater"))>0){%>
			<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetEX.getString("creater")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetEX.getString("creater")),user.getLanguage())%></a>
			<%}else{%>
			<A href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetEX.getString("creater").substring(1)%>'><%=CustomerInfoComInfo.getCustomerInfoname(""+RecordSetEX.getString("creater").substring(1))%></a>
			<%}%>
		  </TD>
<%
        String docids_0=  Util.null2String(RecordSetEX.getString("docids"));
        String docsname="";
        if(!docids_0.equals("")){

            ArrayList docs_muti = Util.TokenizerString(docids_0,",");
            int docsnum = docs_muti.size();

            for( i=0;i<docsnum;i++){
                docsname= docsname+"<a href=/docs/docs/DocDsp.jsp?id="+docs_muti.get(i)+">"+Util.toScreen(DocComInfo.getDocname(""+docs_muti.get(i)),user.getLanguage())+"</a>" +" ";               
            }
        }
        
 %>
            <td>
            <%=docsname%>
            </td>
        </TR>
<%		if(isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
          <TD colSpan=4><%=Util.toScreen(RecordSetEX.getString("remark"),user.getLanguage())%></TD>
        </TR>
<%
	isLight = !isLight;
}
%>	  </TBODY>
	  </TABLE>
<% if (nLogCount>=2) { %> </div> <%}%>
        <table class=ListStyle cellspacing=1>
        <COLGROUP>
		<COL width="30%">
  		<COL width="10%">
  		<COL width="10%">
        <COL width="50%">
          <tbody> 
          <tr class=header> 
            <% if (nLogCount>=2) { %>
            <td  colspan=4 align=right><SPAN id=WorkFlowspan><a href='#' onClick="displaydiv_1()"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a></span></td>
            <%}%></td>

          </tr>
         </tbody> 
        </table>
      </td>
    </tr>
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script language=vbs>


sub onShowMDoc(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="&tmpids)
        if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all(inputename).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href=/docs/docs/DocDsp.jsp?id="&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href=/docs/docs/DocDsp.jsp?id="&resourceids&">"&resourcename&"</a>&nbsp"
					document.all(spanname).innerHtml = sHtml
					
				else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
				end if
         end if
end sub

sub onShowManagerID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	managerSpan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	weaver.manager.value=id(0)
	else 
	managerSpan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	weaver.manager.value=""
	end if
	end if
end sub

sub onGetProduct(spanname1,inputename1,spanname2,inputename2,spanname3,inputename3,inputename4,inputename5)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/search/LgcProductBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname1.innerHtml = "<A href='/lgc/asset/LgcAsset.jsp?para="&id(0)&"'>"&id(1)&"</A>"
	inputename1.value=id(0)
	spanname2.innerHtml = id(3)
	inputename2.value = id(2)
	spanname3.innerHtml = id(5)
	inputename3.value = id(4)
	inputename4.value = id(6)
	inputename5.value = id(6)
	else 
	spanname1.innerHtml = ""
	inputename1.value = ""
	spanname2.innerHtml = ""
	inputename2.value = ""
	spanname3.innerHtml = ""
	inputename3.value = ""
	inputename4.value = ""
	inputename5.value = ""
	end if
	end if
end sub

sub onShowCurrencyID(spanname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp")
	if NOT isempty(id) then
		if id(0)<> "" then
		spanname.innerHtml = id(1)
		inputename.value=id(0)
		else
		spanname.innerHtml = ""
		inputename.value= ""
		end if
	end if
end sub

sub onShowProj()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	ProjIDspan.innerHtml = "<A href='/proj/data/ViewProject.jsp?ProjID="&id(0)&"'>"&id(1)&"</A>"
	weaver.ProjID.value=id(0)
	else 
	ProjIDspan.innerHtml = ""
	weaver.ProjID.value=""
	end if
	end if
end sub

sub onShowComefrom(spanname,inputename,crmid)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/ContactLogBrowser.jsp?CustomerID="&crmid)
	if NOT isempty(id) then
		if id(0)<> "" then
		spanname.innerHtml = id(1)
		inputename.value=id(0)
		else
		spanname.innerHtml = ""
		inputename.value= ""
		end if
	end if
end sub

sub showDoc()
	id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if Not isempty(id) then
		if id(1)<> "" then
		weaver.docId.value=id(0)
		Documentname.innerHtml = "<a href='/docs/docs/DocDsp.jsp?id="&id(0)&"'>"&id(1)&"</a>"
		else
		weaver.docId.value=""
		Documentname.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		end if
	end if	
end sub

sub onShowContacterID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/ContactBrowser.jsp?sqlwhere=where customerid=<%=CustomerID%>")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	contacterIDspan.innerHtml = "<A href='/CRM/data/ViewContacter.jsp?ContacterID="&id(0)&"'>"&id(1)&"</A>"
	weaver.contacterID.value=id(0)
	else 
	contacterIDspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	weaver.contacterID.value=""
	end if
	end if
end sub

sub onShowCustomerID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	crmIdspan.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="&id(0)&"'>"&id(1)&"</A>"
	weaver.crmId.value=id(0)
	else 
	crmIdspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	weaver.crmId.value=""
	end if
	end if
end sub

</script>


<script language=javascript>

rowindex = "<%=rownum%>";
rowindex1 = "<%=rownum1%>";


function changeDiv(){
	if (document.all("beforeDiv").style.display == "")
	document.all("beforeDiv").style.display = 'none' ;
	else 
	document.all("beforeDiv").style.display = ''	;
}


function doSave(savePart){
	if(check_form(document.weaver,'<%=needcheck%>')){
		document.all("savePart").value=savePart;
		document.weaver.submit();
	}
}

function doSave1(){
	if(check_form(document.Exchange,"ExchangeInfo")){
		document.Exchange.submit();
	}
}


function doSave_0(payid,k,payinfoid){
        r_price = eval(toFloat(document.all("trueprice_"+payid+"_"+k).value,0));
        r_date = document.all("tureDate_"+payid+"_"+k).value;        
        document.all("PayInfoId").value= payinfoid;
        document.all("pay_id").value= payid;
        document.all("paytrueprice").value= r_price;
        document.all("paytrueday").value = r_date;
		document.all("payFormNum").value = document.all("payFormNum_"+payid+"_"+k).value; 
		document.all("method").value = "payedit";
		document.weaver.submit();	
}

function doSave_1(proid,k,proinfoid){
        document.all("proInfoId").value= proinfoid;
        document.all("proId").value= proid;
        document.all("proFactNum").value= document.all("proFactNum_"+proid+"_"+k).value;
        document.all("proFactDate").value = document.all("proFactDate_"+proid+"_"+k).value;
        document.all("proFormNum").value = document.all("proFormNum_"+proid+"_"+k).value;		
        document.all("method").value = "proedit";
		document.weaver.submit();	
}



function displaydiv_1()
	{
		if(WorkFlowDiv.style.display == ""){
			WorkFlowDiv.style.display = "none";
			WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
		}
		else{
			WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></a>";
			WorkFlowDiv.style.display = "";
		}
	}


function toFloat(str , def) {
	if(isNaN(parseFloat(str))) return def ;
	else return str ;
}
</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
