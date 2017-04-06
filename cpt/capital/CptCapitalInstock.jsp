<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetInner" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<%
String rightStr = "";
if(!HrmUserVarify.checkUserRight("CptCapital:InStock", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}else{
	rightStr = "CptCapital:InStock";
	session.setAttribute("cptuser",rightStr);
}
RecordSet1.executeSql("select detachable from SystemSet");
int detachable=0;
if(RecordSet1.next()){
    detachable=RecordSet1.getInt("detachable");
    session.setAttribute("detachable",String.valueOf(detachable));
}
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String needcheck="CheckerID,StockInDate,CptDept_to";
String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
RecordSet.executeProc("CptStockInMain_SelectByid",id);
RecordSet.next();
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(6050,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(6050,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver name=frmain method=post action="CapitalInStockOperation.jsp" >
<input name=id type="hidden" value="<%=id%>">
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
			  <TABLE class=ViewForm>
			  <COLGROUP> <COL width="10%"><COL width="90%"> <TBODY>
                
                <!--发票号码-->
                <!--<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(900,user.getLanguage())%></td>
				  <td class=Field><%=Util.toScreen(RecordSet.getString("invoice"),user.getLanguage())%>
				  <INPUT class=InputStyle type=hidden name="Invoice" value="<%=RecordSet.getString("invoice")%>"></td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR> -->
				
                <!--采购人-->
                <TR>
					  <TD><%=SystemEnv.getHtmlLabelName(913,user.getLanguage())%></TD>
					  <TD class=Field><A href="/hrm/resource/HrmResource.jsp?id=<%=user.getUID()%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("buyerid")),user.getLanguage())%></a>
					  <INPUT class=InputStyle type=hidden name="BuyerID" value="<%=RecordSet.getString("buyerid")%>"></TD>
				</TR>
				<TR><TD class=Line colSpan=2></TD></TR> 
				
                <!--供应商-->
                <!--<tr> 
					<td><%=SystemEnv.getHtmlLabelName(138,user.getLanguage())%></td>
					<td class=Field><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("supplierid")),user.getLanguage())%>
					  <input type=hidden name=customerid value="<%=RecordSet.getString("supplierid")%>">
					</td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR> -->
				 
                 <!--验收人-->
                 <tr> 
					<td><%=SystemEnv.getHtmlLabelName(901,user.getLanguage())%></td>
					<td class=Field><!--<BUTTON class=Browser id=SelectCheckerID onClick="onShowHrmID(Checkerspan,CheckerID)"></BUTTON> --><span 
						id=Checkerspan><A href="/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("checkerid")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("checkerid")),user.getLanguage())%></A></span> 
						  <INPUT class=InputStyle type=hidden name="CheckerID" value="<%=RecordSet.getString("checkerid")%>">
					</td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR> 
				 
                 <!--入库部门人-->
                 <tr> 
				  <td><%=SystemEnv.getHtmlLabelName(15301,user.getLanguage())%></td>
					  <TD class=Field><button type="button" class=Browser id=SelDeparment onClick="ToDeparment_1()"></button> 
						  <span class=InputStyle id=ToDeparment><IMG src='/images/BacoError.gif' align=absMiddle></span> 
					   <input id=CptDept_to type=hidden name="CptDept_to" value=""></TD>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR> 
				
                <!--入库日期-->
                <TR>
					  <TD><%=SystemEnv.getHtmlLabelName(753,user.getLanguage())%></TD>
					  <TD class=Field>
						  <BUTTON type="button" class=calendar id=SelectDate onclick=compare_clear();getdiscardDate(StockInDateSpan,StockInDate)></BUTTON>&nbsp;
						  <SPAN id=StockInDateSpan ><%=currentdate%></SPAN>
						  <input type="hidden" name="StockInDate" value=<%=currentdate%> onpropertychange="compare_date()">
						  <input type="hidden" name="checked" value=<%=currentdate%>>
					  </TD>
				 </TR>
				<TR><TD class=Line colSpan=2></TD></TR> 

				 <TR class=separator>
					  <TD class=Sep1 colSpan=2></TD></TR>
			  <tr>
			  <td colSpan=2>
			  <table Class=ListStyle cellspacing=1 cols=9><COLGROUP>
                <COL width="10%">
                <COL width="10%">
                <COL width="12%">
				<COL width="10%">
				<COL width="12%">
                <COL width="10%">
                <COL width="12%">
                <COL width="7%">
                <COL width="7%">
                <COL width="10%">
			   <tr class=header> 
                    <!--合同号-->
					<td><%=SystemEnv.getHtmlLabelName(21282,user.getLanguage())%></td>
                    <!--发票号码-->
                    <td><%=SystemEnv.getHtmlLabelName(900,user.getLanguage())%></td>
                    <!--供应商-->
                    <td><%=SystemEnv.getHtmlLabelName(138,user.getLanguage())%></td>
                    <!--购置日期-->
                    <td><%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%></td>
                    <!--资产资料-->
					<td><%=SystemEnv.getHtmlLabelName(1509,user.getLanguage())%></td>
                    <!--规格型号-->
                    <td><%=SystemEnv.getHtmlLabelName(904,user.getLanguage())%></td>
                    <!--单价-->
                    <td><%=SystemEnv.getHtmlLabelName(1330,user.getLanguage())%></td>
                    <!--入库数量-->
                    <td><%=SystemEnv.getHtmlLabelName(15302,user.getLanguage())%></td>
                    <!--实收数量-->
                    <td><%=SystemEnv.getHtmlLabelName(906,user.getLanguage())%></td>
                    <!--存放地点-->
                    <td><%=SystemEnv.getHtmlLabelName(1387,user.getLanguage())%></td>
			   </tr>
			<%
			int num = 0;
			boolean isLight=false;
			RecordSetInner.executeProc("CptStockInDetail_SByStockid",id);
			while (RecordSetInner.next()){
                if(isLight){%>	
                    <TR CLASS=DataDark>
                <%}else{%>
                    <TR CLASS=DataLight>
                <%}%>
                <input type="hidden" name="node_<%=num%>_id" id="node_<%=num%>_id" value='<%=RecordSetInner.getString("id")%>'>
                <!--发票号码-->
                <td style="word-break:break-all" valign="top"><%=Util.toScreen(RecordSetInner.getString("contractno"),user.getLanguage())%>
                <input type="hidden" name="node_<%=num%>_contractno" id="node_<%=num%>_contractno" value='<%=RecordSetInner.getString("contractno")%>'>
                </td>
                <!--发票号码-->
                <td style="word-break:break-all" valign="top"><%=Util.toScreen(RecordSetInner.getString("Invoice"),user.getLanguage())%>
                <input type="hidden" name="node_<%=num%>_Invoice" id="node_<%=num%>_Invoice" value='<%=RecordSetInner.getString("Invoice")%>'>
                </td>
                <!--供应商-->
                <td style="word-break:break-all" valign="top"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetInner.getString("customerid")),user.getLanguage())%>
                <input type="hidden" name="node_<%=num%>_customerid" id="node_<%=num%>_customerid" value='<%=RecordSetInner.getString("customerid")%>'>
                </td>
                <!--购置日期-->
                <td style="word-break:break-all" valign="top"><%=Util.toScreen(RecordSetInner.getString("selectDate"),user.getLanguage())%>
                <input type="hidden" name="node_<%=num%>_stockindate" id="node_<%=num%>_stockindate" value='<%=RecordSetInner.getString("selectDate")%>'>
                </td>
                <!--资产资料-->
                <td style="word-break:break-all" valign="top"><%=Util.toScreen(CapitalComInfo.getCapitalname(RecordSetInner.getString("cpttype")),user.getLanguage())%> 
                <input type="hidden" name="node_<%=num%>_cptid" id="node_<%=num%>_cptid" value='<%=RecordSetInner.getString("cpttype")%>'>
                </td>
                <!--规格型号-->
                <td style="word-break:break-all" valign="top"><%=Util.toScreen(RecordSetInner.getString("capitalspec"),user.getLanguage())%>
                <input type="hidden" name="node_<%=num%>_capitalspec" id="node_<%=num%>_capitalspec" value='<%=RecordSetInner.getString("capitalspec")%>'>
                </td>
                <!--单价-->
                <td style="word-break:break-all" valign="top"><%=Util.toScreen(RecordSetInner.getString("price"),user.getLanguage())%>
                <input type="hidden" name="node_<%=num%>_unitprice" id="node_<%=num%>_unitprice" value='<%=RecordSetInner.getString("price")%>'></td>
                <!--入库数量-->
                <td style="word-break:break-all" valign="top"><%=Util.toScreen(RecordSetInner.getString("plannumber"),user.getLanguage())%>
                <input type="hidden" name="node_<%=num%>_plannumber" id="node_<%=num%>_plannumber" value='<%=RecordSetInner.getString("plannumber")%>'>
                </td>
                <!--实收数量-->
                <td style="word-break:break-all" valign="top"><input name="node_<%=num%>_innumber" id="node_<%=num%>_innumber" value='<%=RecordSetInner.getString("plannumber")%>' onKeyPress="ItemNum_KeyPress()" onBlur='CheckNumInMorePlan("node_<%=num%>_plannumber","node_<%=num%>_innumber","node_<%=num%>_innumberspan")' class="InputStyle" size=6><span class=InputStyle id="node_<%=num%>_innumberspan"></span></td>
                <!--存放地点-->
                <td><%=Util.toScreen(RecordSetInner.getString("location"),user.getLanguage())%>
                <input type="hidden" name="node_<%=num%>_location" id="node_<%=num%>_location" value='<%=RecordSetInner.getString("location")%>'>
                </td>
                </tr>

                <%
                needcheck+="," + "node_" + num + "_innumber";
                num++;
                isLight = !isLight;
             }%>
             <TR><TD class=Line colSpan=9></TD></TR> 
			  </table>
			  <input type="hidden" name="totaldetail" value="<%=num%>"> 
			  </td>
			  </tr>
			  <tr>
			  </tr>	
				</TBODY> 

			  </TABLE>
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

 </form>
 
 <script language=vbs>
 sub ToDeparment_1()
	if <%=detachable%> <> 1 then
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmain.CptDept_to.value)
	else
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser2.jsp?rightStr=<%=rightStr%>&selectedids="&frmain.CptDept_to.value)
end if
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	ToDeparment.innerHtml ="<A href='/hrm/company/HrmDepartmentDsp.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmain.CptDept_to.value=id(0)
	else
	ToDeparment.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	frmain.CptDept_to.value=""
	end if
	end if
end sub

sub onShowCustomerid(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type=2")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
	else
	spanname.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	inputname.value=""
	end if
	end if
end sub

sub onShowHrmID(getSpan,getInput)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	getSpan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	getInput.value=id(0)
	else 
	getSpan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	getInput.value=""
	end if
	end if
end sub

sub onShowAsset(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='1' ")
	if NOT isempty(id) then
	    if id(0)<> "" and id(0)<> "0" then
		spanname.innerHtml = "<a href='/cpt/capital/CptCapital.jsp?id="&id(0)&"'>"&id(1)&"</a>"
		inputname.value=id(0)
		else
		spanname.innerHtml =  "<img src='/images/BacoError.gif' align=absmiddle>"
		inputname.value=""
		end if
	end if
end sub

</script>

<script language=javascript>
var rowindex = 0;
var totalrows=0;
var needcheck = "<%=needcheck%>";
var numindex = <%=num%>;

function doSubmit(obj) {
   if(check_form(document.weaver,needcheck)) {
       document.weaver.submit();
       obj.disabled = true;
   }
}

function CheckNumInMorePlan(getInput1,getInput2,getSpan)
{
   checkinput(getInput2,getSpan);
   innum=eval(document.all(getInput2).value);
   plannum=eval(document.all(getInput1).value);
   if(innum > plannum) {
   document.all(getInput2).value=document.all(getInput1).value;

   }
}

function compare_date(){
	 var time1 =document.getElementById('StockInDateSpan').innerHTML;
	 var time2 =document.all.checked.value;
	 if (time1 != "<IMG src='/images/BacoError.gif' align=absMiddle>"){
		  if(time1!=time2){
	    	 var dateIn = time1.replace(/-/g,"");
	    	 document.all.checked.value = time1;
				if (numindex>0){
			 		for (var i=0;i<numindex;i++){
						if (document.all("node_"+i+"_stockindate").value.replace(/-/g,"")>dateIn){
						    compare_clear();
						    document.getElementById('StockInDateSpan').innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
							alert("入库时间选择不正确，入库时间应该大于购置日起!");
				    		return false;
						}
					}
				} 
		  }
	  }
}

function compare_clear(){
	document.all.StockInDate.value="";
}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
