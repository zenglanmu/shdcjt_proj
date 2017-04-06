<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />


<%
String CustomerID = request.getParameter("CustomerID");
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
int rownum=0;
String needcheck="subject";

%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(2227,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY onbeforeunload="protectSellChance()">
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location='/CRM/sellchance/ListSellChance.jsp?isfromtab="+isfromtab+"&CustomerID="+CustomerID+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

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
<FORM id=weaver name=weaver action="/CRM/sellchance/SellChanceOperation.jsp" method=post  >

  <input type="hidden" name="method" value="add">
  <input type="hidden" name="endtatusid" value="0">
  <input type="hidden" name="isfromtab" value="<%=isfromtab%>">
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
		<COL width="30%">
		<COL width="70%">
		<TBODY>
		<TR class=Title>
		<TH colSpan=2><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
		</TR>
		<TR class=Spacing style="height: 1px">
		<TD class=Line1 colSpan=2></TD></TR>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
		<TD class=Field><INPUT text class=InputStyle maxLength=50 size=30 name="subject" onchange='checkinput("subject","subjectimage")'><SPAN id=subjectimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%if(!user.getLogintype().equals("2")) {%>	
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></TD>
		<TD class=Field>
	
		<INPUT  class=wuiBrowser _displayText="<a href='/hrm/resource/HrmResource.jsp?id=<%=user.getUID()%>'><%=user.getUsername()%></a>" _required="yes" _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" type=hidden name="Creater" value="<%=user.getUID()%>"></TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15239,user.getLanguage())%></TD>
		<TD class=Field>
		 
		<input class="wuiBrowser" _displayTemplate="<A href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</A>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type in (3,4)" type=hidden name=Agent></TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%} else {%>
		<INPUT type=hidden name=Creater value="<%=user.getManagerid()%>">
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15239,user.getLanguage())%></TD>
		<TD class=Field>
		<span text class=InputStyle id=Agentspan><a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=user.getUID()%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+user.getUID()),user.getLanguage())%></a></span> 
		<input type=hidden name=Agent value="<%=user.getUID()%>"></TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>   

		<%}%>      
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>  </TD>

		<TD class=Field>
		<INPUT class=wuiBrowser _displayTemplate="<A href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</A>" _displayText="<a href='/CRM/data/ViewCustomer.jsp?log=n&CustomerID=<%=CustomerID%>'><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(CustomerID),user.getLanguage())%></a>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" type=hidden name="customer" value="<%=CustomerID%>"></TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>

		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15240,user.getLanguage())%>  </TD>
		<TD class=Field>
		<input class="wuiBrowser" type=hidden _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/ContactLogBrowser.jsp?CustomerID=<%=CustomerID%>" id="Comefrom" name="Comefrom" value="">
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>

		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15103,user.getLanguage())%></TD>
		<TD class=Field>
		<select text class=InputStyle id=sufactorid 
		name=sufactorid style="width:75%">
		<option value="0"  > </option>
		<%  
		String theid_s="";
		String thename_s="";
		String sql_1="select * from CRM_Successfactor ";
		RecordSet.executeSql(sql_1);
		while(RecordSet.next()){
		theid_s = RecordSet.getString("id");
		thename_s = RecordSet.getString("fullname");
		if(!thename_s.equals("")){
		%>
		<option value=<%=theid_s%>  ><%=thename_s%></option>
		<%}
		}%>
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15104,user.getLanguage())%></TD>
		<TD class=Field>
		<select text class=InputStyle id=defactorid 
		name=defactorid style="width:75%">
		<option value="0"  > </option>
		<%  
		String theid_f="";
		String thename_f="";
		String sql_2="select * from CRM_Failfactor ";
		RecordSet.executeSql(sql_2);
		while(RecordSet.next()){
		theid_f = RecordSet.getString("id");
		thename_f = RecordSet.getString("fullname");
		if(!thename_f.equals("")){
		%>
		<option value=<%=theid_f%>  ><%=thename_f%></option>
		<%}
		}%>
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<!-- TR>
		<TD>归档状态</TD>
		<TD class=Field>
		<select text class=InputStyle id=endtatusid  name=endtatusid >
		<option value=1 selected > 成 功 </option>
		<option value=0  > 失 败 </option>
		</TD >
		</TR -->    
		</TBODY>
    </TABLE>
    </TD>

    <TD></TD>

    <TD vAlign=top>

	<TABLE class=ViewForm>
		<COLGROUP>
		<COL width="30%">
		<COL width="70%">
		<TBODY>
		<TR class=Title>
		<TH colSpan=2>&nbsp</TH>
		</TR>
		<TR class=Spacing style="height: 1px">
		<TD class=Line1 colSpan=2></TD></TR>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(2247,user.getLanguage())%></TD>
		<TD class=Field>
		<BUTTON type="button" class=Calendar onclick="onShowDate_1(preselldatespan,preselldate)"></BUTTON> <SPAN id=preselldatespan ><IMG src='/images/BacoError.gif' align=absMiddle></SPAN> <input type="hidden" name="preselldate">
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(2248,user.getLanguage())%></TD>
		<TD class=Field><INPUT text class=InputStyle maxLength=50 size=30 id="preyield" name="preyield"   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield")'>
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(2249,user.getLanguage())%></TD>
		<TD class=Field><INPUT text class=InputStyle maxLength=10 size=7 name="probability" onchange='checkinput("probability","probabilityimage")'  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("probability");checkvalue()'>
		<SPAN id=probabilityimage ><IMG src='/images/BacoError.gif' align=absMiddle></SPAN></TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(2250,user.getLanguage())%>   </TD>
		<TD class=Field>
		<select text class=InputStyle id=sellstatusid 
		name=sellstatusid style="width:80px">
		<%  
		String theid="";
		String thename="";
		String sql="select * from CRM_SellStatus ";
		RecordSet.executeSql(sql);
		while(RecordSet.next()){
		theid = RecordSet.getString("id");
		thename = RecordSet.getString("fullname");
		if(!thename.equals("")){
		%>
		<option value=<%=theid%>  ><%=thename%></option>
		<%}
			}%>
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<!--TR>
		<TD>创建日期</TD>
		<TD class=Field>
		<BUTTON class=Calendar onclick="onShowDate('CreateDatespan','createdate')"></BUTTON> <SPAN id=CreateDatespan ><IMG src='/images/BacoError.gif' align=absMiddle></SPAN> <input type="hidden" name="createdate">
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD>创建时间</TD>
		<TD class=Field><button class=Clock onclick="onShowTime('CreateTimespan','createtime')"></button><span id="CreateTimespan"><IMG src='/images/BacoError.gif' align=absMiddle></span><INPUT type=hidden name="createtime"></TD>
		</TR -->
		</TBODY>
	</TABLE>
    </TD>


    </TR></TBODY></TABLE>


	<TABLE class=ViewForm cellpadding=1  cols=7 id="oTable">
	<input type="hidden" name="rownum" value="0">  
	<TR class=Title>
	<TH colspan=2><%=SystemEnv.getHtmlLabelName(15115,user.getLanguage())%></TH>

	<Td align=right colSpan=5>
	<BUTTON class=btnNew type="button" accessKey=A onClick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(15128,user.getLanguage())%></BUTTON>
	<BUTTON class=btnDelete type="button" accessKey=D onClick="javascript:if(isdel()){deleteRow1()};"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
	</Td>       
	</TR>
	<TR class=Spacing style="height: 1px">
	<TD class=Line1 colSpan=7></TD></TR>

	<tr class=header>
	<td class=Field></td>
	<td class=Field><%=SystemEnv.getHtmlLabelName(15129,user.getLanguage())%></td>
	<td class=Field><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></td>
	<td class=Field><%=SystemEnv.getHtmlLabelName(649,user.getLanguage())%></td>
	<td class=Field><%=SystemEnv.getHtmlLabelName(1330,user.getLanguage())%></td>
	<td class=Field><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></td>
	<td class=Field><%=SystemEnv.getHtmlLabelName(2019,user.getLanguage())%></td>
	</TR><tr style="height: 1px"><td class=Line colspan=7></td></tr>
	</table>  	

	<!--TABLE class=ViewForm>
	<COLGROUP>
	<COL width="50%">
	<TR>
	<TD><B>描述</B></TD>
	</TR>
	<TR class=Spacing>
	<TD class=Line1 colSpan=1></TD></TR>
	<TR>
	<TD class=Field><TEXTAREA text class=InputStyle name="content" ROWS=4 STYLE="width:100%"></TEXTAREA></TD>
	</TR>
	</TABLE -->
</FORM>


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
<script language="JavaScript" src="/js/addRowBg.js">   
</script>  
<script language=javascript>
function onGetProduct(spanname1,inputename1,spanname2,inputename2,spanname3,inputename3,inputename4,inputename5){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/search/LgcProductBrowser.jsp",
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	
	if (data){
		if (data.id!=""){
			spanname1.innerHTML = "<A href='/lgc/asset/LgcAsset.jsp?paraid="+wuiUtil.getJsonValueByIndex(data,0)+"'>"+wuiUtil.getJsonValueByIndex(data,1)+"</A>"
			inputename1.value=wuiUtil.getJsonValueByIndex(data,0)
			spanname2.innerHTML = wuiUtil.getJsonValueByIndex(data,3)
			inputename2.value = wuiUtil.getJsonValueByIndex(data,2)
			spanname3.innerHTML = wuiUtil.getJsonValueByIndex(data,5)
			inputename3.value = wuiUtil.getJsonValueByIndex(data,4)
			inputename4.value = wuiUtil.getJsonValueByIndex(data,6)
			inputename5.value = wuiUtil.getJsonValueByIndex(data,6)
		}else{
			spanname1.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			inputename1.value = ""
			spanname2.innerHTML = ""
			inputename2.value = ""
			spanname3.innerHTML = ""
			inputename3.value = ""
			inputename4.value = "0"
			inputename5.value = "0"
		}
	}
}
rowindex = "<%=rownum%>";
var rowColor="" ;
function addRow()
{
	ncol = jQuery(oTable).attr("cols");
	oRow = oTable.insertRow(-1);
	rowColor = getRowBg();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1); 
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
            case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='0' >"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;			
			case 1:
				var oDiv = document.createElement("div");
				var sHtml =  "<button type='button' class=Browser onClick=onGetProduct(productname_"+rowindex+"span,productname_"+rowindex+",assetunitid_"+rowindex+"span,assetunitid_"+rowindex+",currencyid_"+rowindex+"Span,currencyid_"+rowindex+",salesprice_"+rowindex+",totelprice_"+rowindex+")></button> " + 
        					"<span text class=InputStyle id=productname_"+rowindex+"span></span> "+
        					"<input type='hidden' name='productname_"+rowindex+"'  id=productname_"+rowindex+">";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<span text class=InputStyle id=assetunitid_"+rowindex+"span></span> "+
        					"<input type='hidden' name='assetunitid_"+rowindex+"'  id=assetunitid_"+rowindex+">";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;	
			case 3:
				var oDiv = document.createElement("div");
				var sHtml =  "<input class='wuiBrowser' type='hidden' _url='/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp' name='currencyid_"+rowindex+"' id=currencyid_"+rowindex+">";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				jQuery(oDiv).find(".wuiBrowser").modalDialog();
				break;                
			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text id='salesprice_"+rowindex+"'  name='salesprice_"+rowindex+"' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);changenumber("+rowindex+")' size=10>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text  name='number_"+rowindex+"' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);changenumber("+rowindex+")' size=10 value='1'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;               
            case 6: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text  id='totelprice_"+rowindex+"'  name='totelprice_"+rowindex+"' onKeyPress='ItemNum_KeyPress(this.id)' onBlur='checknumber1(this),sumpreyield()' size=25>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
		}
	}
	rowindex = rowindex*1 +1;
 
}


function changenumber(rowval){
	
	
	count_total = 0 ;
    count_number = 0;
    count_preyield =0;

    count_total = eval(toFloat($GetEle("salesprice_"+rowval).value,0));
	count_number = eval(toFloat($GetEle("number_"+rowval).value,0));
    
    count_total = toFloat(count_total) * toFloat(count_number);

	$GetEle("totelprice_"+rowval).value = toPrecision(count_total,4) ; 

    sumpreyield();
	//alert(count_preyield);
}


function deleteRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
    for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	} 
	
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				oTable.deleteRow(rowsum1+2);	
			}
			rowsum1 -=1;
		}	
	}
    sumpreyield();
}



function sumpreyield(){
    
    count_sum=0;
    for(i=0;i<rowindex;i++){
        if($GetEle("totelprice_"+i) != null){
            count_sum += eval(toFloat($GetEle("totelprice_"+i).value,0));
        }
        
    }
   document.weaver.preyield.value = toPrecision(count_sum,2);
}
function toPrecision(aNumber,precision){
	var temp1 = Math.pow(10,precision);
	var temp2 = new Number(aNumber);

	return isNaN(Math.round(temp1*temp2) /temp1)?0:Math.round(temp1*temp2) /temp1 ;
}

function doSave(obj){
	window.onbeforeunload=null;
	if(check_form(document.weaver,'<%=needcheck%>,Creater,preselldate,probability')){
		obj.disabled=true;
		document.weaver.rownum.value = rowindex;
		document.weaver.submit();
	}
}

function protectSellChance(){
	if(!checkDataChange())//added by cyril on 2008-06-13 for TD:8828
		event.returnValue="<%=SystemEnv.getHtmlLabelName(19005,user.getLanguage())%>";
}

function toFloat(str , def) {
	if(isNaN(parseFloat(str))) return def ;
	else return str ;
}
function toInt(str , def) {
	if(isNaN(parseInt(str))) return def ;
	else return str ;
}


function checkvalue(){
    check_value=eval(toFloat($GetEle("probability").value,0));
    if(check_value>1){
        alert("<%=SystemEnv.getHtmlLabelName(15241,user.getLanguage())%>");
        $GetEle("probability").value=0;
    }
}

</script>

</BODY>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
<!-- added by cyril on 2008-06-13 for TD:8828 -->
<script language=javascript src="/js/checkData.js"></script>
<!-- end by cyril on 2008-06-13 for TD:8828 -->
</HTML>
