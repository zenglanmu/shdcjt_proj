<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetInner" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
String rightStr = "";
if(!HrmUserVarify.checkUserRight("CptCapital:InStock", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}else{
	rightStr = "CptCapital:InStock";
	session.setAttribute("cptuser",rightStr);
}

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String needcheck="BuyerID,CheckerID,StockInDate";
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(751,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{-}" ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(886,user.getLanguage())+",/cpt/capital/CptCapitalUse.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(883,user.getLanguage())+",/cpt/capital/CptCapitalMove.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6051,user.getLanguage())+",/cpt/capital/CptCapitalLend.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6054,user.getLanguage())+",/cpt/capital/CptCapitalLoss.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6052,user.getLanguage())+",/cpt/capital/CptCapitalDiscard.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(22459,user.getLanguage())+",/cpt/capital/CptCapitalMend.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6055,user.getLanguage())+",/cpt/capital/CptCapitalModifyOperation.jsp?isdata=2,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15305,user.getLanguage())+",/cpt/capital/CptCapitalBack.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15306,user.getLanguage())+",/cpt/capital/CptCapitalInstock1.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15307,user.getLanguage())+",/cpt/search/CptInstockSearch.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver name=weaver method=post action="CapitalInstock1Operation.jsp" >
<INPUT  type=hidden name="method" value="add">
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
				  <td class=Field><input class=InputStyle name=Invoice STYLE="width:30%">
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> -->

                <!--采购人-->
				<TR>
					  <TD><%=SystemEnv.getHtmlLabelName(913,user.getLanguage())%></TD>
					  <TD class=Field>
					  <button type=button  class=Browser id=SelectBuyerID onClick="onShowHrmID('Buyerspan', 'BuyerID')"></BUTTON> <span 
						id=Buyerspan><A href="/hrm/resource/HrmResource.jsp?id=<%=user.getUID()%>"><%=Util.toScreen(ResourceComInfo.getResourcename(""+user.getUID()),user.getLanguage())%></a></span> 
						  <INPUT class=InputStyle type=hidden name="BuyerID" value="<%=user.getUID()%>"></TD>
				</TR>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
                
                <!--供应商-->
				<!--<tr> 
					<td><%=SystemEnv.getHtmlLabelName(138,user.getLanguage())%></td>
					<td class=Field> <button type=button  class=Browser onClick="onShowCustomerid(customeridspan,customerid,customertextspan)"></button> 
					  <span id=customeridspan></span> 
                      <span id=customertextspan><input class=InputStyle name=customertext STYLE="width:30%"></span> 
					  <input type=hidden name=customerid>
					</td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> -->
                
                <!--验收人-->
				 <tr> 
					<td><%=SystemEnv.getHtmlLabelName(901,user.getLanguage())%></td>
					<td class=Field>  <button type=button  class=Browser id=SelectCheckerID onClick="onShowHrmID('Checkerspan','CheckerID')"></BUTTON> <span 
						id=Checkerspan><IMG src='/images/BacoError.gif' align=absMiddle></span> 
						  <INPUT class=InputStyle type=hidden name="CheckerID">
					</td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
                
                <!--入库日期-->
				<TR>
					  <TD><%=SystemEnv.getHtmlLabelName(753,user.getLanguage())%></TD>
					  <TD class=Field>
						  <button type=button  class=calendar id=SelectDate onclick="onShowDate(StockInDateSpan,StockInDate)"></BUTTON>&nbsp;
						  <SPAN id="StockInDateSpan" ><%=currentdate%></SPAN>
						  <input type="hidden" name="StockInDate" value=<%=currentdate%>>		  
					  </TD>
				 </TR>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				
				<tr>
			  <td colSpan=2 align="right">
			  <div>
			<button type=button  Class=btnNew type=button accessKey=A onclick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,user.getLanguage())%></BUTTON>
			<button type=button  Class=btnDelete type=button accessKey=E onclick="if(isdel()){deleteRow1();}">
			<U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>
			</BUTTON>
			</div>
			  </td>
			  </tr>

			  <tr>
			  <td colSpan=2>
			  <table Class=ListStyle cols=11 id="oTable" cellspacing="1"><COLGROUP>
				<COL width="3%">
				<COL width="8%">
                <COL width="10%">
				<COL width="12%">
				<COL width="12%">
				<COL width="13%">
                <COL width="10%">
                <COL width="8%">
                <COL width="8%">
                <COL width="5%">
                <COL width="10%">
			  <tr class=header> 
                    <!--选中-->
					<td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
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
                    <!--数量-->
                    <td><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></td>
                    <!--单位-->
					<td><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></td>
                    <!--存放地点-->
                    <td><%=SystemEnv.getHtmlLabelName(1387,user.getLanguage())%></td>
			   </tr>
			  </table>
			  <input type="hidden" name="totaldetail" value=0> 
			  </td>
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
 <script type="text/javascript">
function disModalDialog(url, spanobj, inputobj, need, curl) {

	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}



function onShowCustomerid(spanname,inputname,textspan) {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type=2"
			, $GetEle(spanname)
			, $GetEle(inputname)
			, false);
	if ($GetEle(inputname).value != "") {
		$GetEle(textspan).style.visibility="hidden";
	} else {
		$GetEle(textspan).style.visibility="inherit";
	}
}

function onShowCustomerid_Dtl(rownum) {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type=2"
			, $GetEle("node_"+rownum+"_customeridspan")
			, $GetEle("node_"+rownum+"_customerid")
			, false);
	
	if ($GetEle("node_"+rownum+"_customerid").value != "") {
		$GetEle("node_"+rownum+"_customertextspan").innerHTML = "";
	} else {
		$GetEle("node_"+rownum+"_customertextspan").innerHTML = "<input class=InputStyle name='node_"+rownum+"_customertext' size=13>";
	}
}

function onShowHrmID(getSpan,getInput) {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			, $GetEle(getSpan)
			, $GetEle(getInput)
			, true);
}

function onShowAsset(rownum) {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='1'&isdata=1",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != ""
				&& wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			$GetEle("node_" + rownum + "_cptspan").innerHTML = "<a href='/cpt/capital/CptCapital.jsp?id="
					+ wuiUtil.getJsonValueByIndex(id, 0)
					+ "'>"
					+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			$GetEle("node_" + rownum + "_cptid").value = wuiUtil
					.getJsonValueByIndex(id, 0);
			$GetEle("node_" + rownum + "_capitalspec").value = wuiUtil
					.getJsonValueByIndex(id, 5);
			$GetEle("node_" + rownum + "_unitprice").value = wuiUtil
					.getJsonValueByIndex(id, 6);
			$GetEle("node_" + rownum + "_unitspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 7);
			if (wuiUtil.getJsonValueByIndex(id, 6) != "") {
				$GetEle("node_" + rownum + "_unitpricespan").innerHTML = "";
			} else {
				$GetEle("node_" + rownum + "_unitpricespan").innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
			}
			if (wuiUtil.getJsonValueByIndex(id, 5) != "") {
				$GetEle("node_" + rownum + "_capitalspecspan").innerHTML = "";
			} else {
				$GetEle("node_" + rownum + "_capitalspecspan").innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
			}
		} else {
			$GetEle("node_" + rownum + "_cptspan").innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
			$GetEle("node_" + rownum + "_cptid").value = "";
			$GetEle("node_" + rownum + "_capitalspec").value = "";
			$GetEle("node_" + rownum + "_unitprice").value = "";
			$GetEle("node_" + rownum + "_unitspan").innerHTML = "";
			$GetEle("node_" + rownum + "_unitpricespan").innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
			$GetEle("node_" + rownum + "_capitalspecspan").innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
		}
	}
}
 </script>


<script language="JavaScript" src="/js/addRowBg.js" >   
</script>  
<script language=javascript>
var rowindex = 0;
var totalrows=0;
var needcheck = "<%=needcheck%>";
var rowColor="" ;
function addRow()
{
	ncol = jQuery(jQuery(oTable).children("tbody").children("tr")[0]).children("td").length;	
	oRow = oTable.insertRow(-1);
	rowColor = getRowBg();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1); 
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
            //<!--选中-->
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='"+rowindex+"' >"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			//<!--合同号-->
            case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=InputStyle name='node_"+rowindex+"_contractno' maxlength=100 size=9> ";
					oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
			//<!--发票号码-->
            case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=InputStyle name='node_"+rowindex+"_Invoice' maxlength=100 size=9> ";
					oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
            //<!--供应商-->
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
                    sHtml = "<button type=button  class=Browser onClick=\"onShowCustomerid_Dtl('"+rowindex+"')\"></button> "+
                            "<span id='node_"+rowindex+"_customeridspan' ></span>" +
                            "<span id='node_"+rowindex+"_customertextspan' ><input class=InputStyle name='node_"+rowindex+"_customertext' size=12></span>" +
                            "<input type=hidden name='node_"+rowindex+"_customerid' >";
					oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
            //<!--购置日期-->
			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
                	sHtml = "<button type=button  class=calendar id=node_"+rowindex+"_SelectDate onclick=onShowDate(node_"+rowindex+"_StockInDateSpan,node_"+rowindex+"_StockInDate)></BUTTON>&nbsp;"+
						    "<SPAN id=node_"+rowindex+"_StockInDateSpan >"+weaver.StockInDate.value+"</SPAN>"+
						    "<input type='hidden' name='node_"+rowindex+"_StockInDate' value='"+weaver.StockInDate.value+"'>";
					oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
			//<!--资产资料-->
			case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
					sHtml = "<button type=button  class=Browser onClick=\"onShowAsset('"+rowindex+"')\"></button> " + 
        					"<span class=InputStyle id=node_"+rowindex+"_cptspan><img src='/images/BacoError.gif' align=absmiddle></span> " +
					        "<input type='hidden' name='node_"+rowindex+"_cptid' id='node_"+rowindex+"_cptid'>";
					needcheck += ","+"node_"+rowindex+"_cptid";
        			oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
            //<!--规格型号-->
			case 6: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=InputStyle maxlength=60 size=15 name='node_"+rowindex+"_capitalspec' onBlur=checkinput('node_"+rowindex+"_capitalspec','node_"+rowindex+"_capitalspecspan')>" +
					        "<span id='node_"+rowindex+"_capitalspecspan'><img src='/images/BacoError.gif' align=absmiddle></span>";
					needcheck += ","+"node_"+rowindex+"_capitalspec";
					oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
            //<!--单价-->
			case 7: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
					sHtml = "<input class='InputStyle' type='text'  name='node_"+rowindex+"_unitprice' size=7 onKeyPress='ItemNum_KeyPress()' onBlur=checknumber('node_"+rowindex+"_unitprice') onchange=checkinput('node_"+rowindex+"_unitprice','node_"+rowindex+"_unitpricespan') >" +
					        "<span id='node_"+rowindex+"_unitpricespan'><img src='/images/BacoError.gif' align=absmiddle></span>";
					needcheck += ","+"node_"+rowindex+"_unitprice";
					oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
            //<!--数量-->
			case 8: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
					sHtml = "<input class='InputStyle' type='text' name='node_"+rowindex+"_number' onKeyPress='ItemNum_KeyPress()' onBlur=checknumber('node_"+rowindex+"_number') onchange=checkinput('node_"+rowindex+"_number','node_"+rowindex+"_numberspan') size=7 maxLength='8'><span id='node_"+rowindex+"_numberspan'>";
					sHtml += "<img src='/images/BacoError.gif' align=absmiddle>";
					sHtml+="</span>";
					needcheck += ","+"node_"+rowindex+"_number";
	        		oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
            //<!--单位-->
			case 9: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<span class=InputStyle id=node_"+rowindex+"_unitspan></span> ";
					oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
			//<!--存放地点-->
            case 10: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=InputStyle name='node_"+rowindex+"_location' maxlength=100 size=9> ";
					oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
		}
	}
	rowindex = rowindex*1 +1;
	weaver.totaldetail.value=rowindex;
	totalrows = rowindex;
}


function deleteRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 1;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				tmprow = document.forms[0].elements[i].value;
				for(j=1; j<4; j++) {
				
						if(j==1)
							needcheck = needcheck.replace(",node_"+tmprow+"_cptid","");
						if(j==2)
							needcheck = needcheck.replace(",node_"+tmprow+"_number","");
						if(j==3)
							needcheck = needcheck.replace(",node_"+tmprow+"_unitprice","");
				
				}
				oTable.deleteRow(rowsum1-1);	
			}
			rowsum1 -=1;
		}
	
	}	
}

function onSubmit()
{
   if(check_form(document.weaver,needcheck)) {
       len = document.forms[0].elements.length;
       var i=0;
       var rowsum1 = 0;
       for(i=len-1; i >= 0;i--) {
		  if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
       }
       //alert("rowsum1:"+rowsum1);
       if(rowsum1>0){
         document.weaver.submit();
       }else{
         alert("请至少输入一条资产资料明细记录！");
       }
   }
}

</script>
 <script language="javascript">
 function back()
{
	window.history.back(-1);
}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
