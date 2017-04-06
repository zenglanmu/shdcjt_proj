<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetS" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />

<%
String rightStr = "";
if(!HrmUserVarify.checkUserRight("CptCapital:MoveIn", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}else{
	rightStr = "CptCapital:MoveIn";
	session.setAttribute("cptuser",rightStr);
}
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String capitalid = Util.null2String(request.getParameter("capitalid"));
String sptcount="";
String sql="";
String hrmid=Util.null2String(request.getParameter("hrmid"));

if (!capitalid.equals("")){
	sql="select sptcount from CptCapital where id="+ capitalid;
	RecordSetS.executeSql(sql);
	RecordSetS.next(); 
	sptcount = RecordSetS.getString("sptcount");
}

int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(886,user.getLanguage());
String needfav ="1";
String needhelp ="";
String needcheck="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSubmit(this),_self} " ;
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

<FORM id=frmain name=frmain method=post action="/cpt/capital/CapitalUseOperation.jsp"    >

    <table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
        <colgroup>
        <col width="10">
        <col width="">
        <col width="10">
        <tr  style="height:0px">
            <td height="0" colspan="3"></td>
        </tr>
        <tr>
        <td ></td>
        <td valign="top">

        <TABLE class=Shadow>
            <tr>
            <td valign="top">

            <TABLE class=ViewForm>
                <TBODY>

                <tr>
                    <td colSpan=2 align="right">
                        <div>
                            <button type=button  Class=btnNew type=button accessKey=A onclick="addRow();">
                                <U>A</U>-<%=SystemEnv.getHtmlLabelName(551,user.getLanguage())%>
                            </BUTTON>
                            <button type=button  Class=btnDelete type=button accessKey=E onclick="if(isdel()){deleteRow1();}">
                                <U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>
                            </BUTTON>
                        </div>
                    </td>
                </tr>

                <tr>
                <td colSpan=1>
                <table Class=ListStyle cols=12 id="oTable" cellspacing="1"><COLGROUP>
                    <COL width="3%">
                    <COL width="8%">
                    <COL width="14%">
                    <COL width="10%">
                    <COL width="10%">
                    <COL width="6%">
                    <COL width="3%">
                    <COL width="10%">
                    <COL width="10%">
                    <COL width="10%">
                    <COL width="8%">
                    <COL width="8%">
                    <tr class=header> 
                    <!--选中-->
                    <td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
                    <!--申请人-->
                    <td><%=SystemEnv.getHtmlLabelName(368,user.getLanguage())%></td>
                    <!--领用日期-->
                    <td><%=SystemEnv.getHtmlLabelName(1412,user.getLanguage())%></td>
                    <!--领用资产-->
                    <td><%=SystemEnv.getHtmlLabelName(15312,user.getLanguage())%></td>
                    <!--领用数量-->
                    <td><%=SystemEnv.getHtmlLabelName(15313,user.getLanguage())%></td>
                    <!--库存数量-->
                    <td><%=SystemEnv.getHtmlLabelName(1446,user.getLanguage())%></td>
                    <!--单位-->
                    <td><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></td>
                    <!--编号-->
                    <td><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>                    
                    <!--财务编号-->
                    <td><%=SystemEnv.getHtmlLabelName(15293,user.getLanguage())%></td>
                    <!--规格型号-->
                    <td><%=SystemEnv.getHtmlLabelName(904,user.getLanguage())%></td>
                    <!--存放地点-->
                    <td><%=SystemEnv.getHtmlLabelName(1387,user.getLanguage())%></td>
                    <!--备注-->
                    <td><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
                    </tr>
                    
                </table>

                <input type="hidden" name="totaldetail" value=0> 
                </td>
                </tr>
                </TBODY >
            </TABLE>

            </td>
            </tr>
        </TABLE>

        </td>
        <td></td>
        </tr>
        <tr style="height:0px">
        <td height="0" colspan="3"></td>
        </tr>
    </table>
</form>
<script type="text/javascript">
function onShowHrmid(rownum) {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != ""
				&& wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			$GetEle("node_" + rownum + "_hrmidspan").innerHTML = "<A href='HrmResource.jsp?id="
					+ wuiUtil.getJsonValueByIndex(id, 0)
					+ "'>"
					+ wuiUtil.getJsonValueByIndex(id, 1) + "</A>";
			$GetEle("node_" + rownum + "_hrmid").value = wuiUtil
					.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("node_" + rownum + "_hrmidspan").innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
			$GetEle("node_" + rownum + "_hrmid").value = "";
		}
	}
}

function onShowCapitalid(rownum) {
	// 只显示状态为库存的资产cptstateid=1
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='2'&cptstateid=1&cptuse=1",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != ""
				&& wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			$GetEle("node_" + rownum + "_cptspan").innerHTML = "<a href='/cpt/capital/CptCapital.jsp?id="
					+ wuiUtil.getJsonValueByIndex(id, 0)
					+ "'>"
					+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			$GetEle("node_" + rownum + "_capitalid").value = wuiUtil
					.getJsonValueByIndex(id, 0);
			$GetEle("node_" + rownum + "_sptcount").value = wuiUtil
					.getJsonValueByIndex(id, 12);
			$GetEle("node_" + rownum + "_capitalspec").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 9);
			$GetEle("node_" + rownum + "_capitalnumspan").innerHTML = "";
			$GetEle("node_" + rownum + "_capitalnum").value = "1";
			$GetEle("node_" + rownum + "_capitalcountspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 7);
			$GetEle("node_" + rownum + "_capitalcount").value = wuiUtil
					.getJsonValueByIndex(id, 7);
			$GetEle("node_" + rownum + "_unitspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 11);
			$GetEle("node_" + rownum + "_codespan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 8);
			$GetEle("node_" + rownum + "_ficodespan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 5);
			$GetEle("node_" + rownum + "_location").value = wuiUtil
					.getJsonValueByIndex(id, 10);
		} else {
			$GetEle("node_" + rownum + "_cptspan").innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
			$GetEle("node_" + rownum + "_capitalid").value = "";
			$GetEle("node_" + rownum + "_sptcount").value = "";
			$GetEle("node_" + rownum + "_capitalspec").innerHTML = "";
			$GetEle("node_" + rownum + "_capitalnumspan").innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
			$GetEle("node_" + rownum + "_capitalnum").value = "";
			$GetEle("node_" + rownum + "_capitalcountspan").innerHTML = "";
			$GetEle("node_" + rownum + "_capitalcount").value = 0;
			$GetEle("node_" + rownum + "_unitspan").innerHTML = "";
			$GetEle("node_" + rownum + "_codespan").innerHTML = "";
			$GetEle("node_" + rownum + "_ficodespan").innerHTML = "";
			$GetEle("node_" + rownum + "_location").value = "";
		}
	}
}

function checkstock(rownum) {
	if ($GetEle("node_" + rownum + "_capitalnum").value != ""
			&& $GetEle("node_" + rownum + "_capitalcount").value != "") {
		if (parseInt($GetEle("node_" + rownum + "_capitalnum").value) > parseInt($GetEle("node_"
				+ rownum + "_capitalcount").value)) {
			alert("领用数量大于库存数量。");
			$GetEle("node_" + rownum + "_capitalnum").value = $GetEle("node_"
					+ rownum + "_capitalcount").value;
		}
	}
}
</script>

<script language="JavaScript" src="/js/addRowBg.js" >   
</script>  
<script language="javascript">
var rowindex = 0;
var totalrows=0;
var needcheck = "<%=needcheck%>";
var rowColor="" ;
var currentdate = "<%=currentdate%>";
function addRow(){
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
			//<!--申请人-->
            case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
                    sHtml = "<button type=button  class=Browser onClick=\"onShowHrmid('"+rowindex+"')\"></button> " + 
        					"<span id=node_"+rowindex+"_hrmidspan><img src='/images/BacoError.gif' align=absmiddle></span> " +
					        "<input type='hidden' name='node_"+rowindex+"_hrmid' id='node_"+rowindex+"_hrmid'>";
                    needcheck += ","+"node_"+rowindex+"_hrmid";					
                    oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
            //<!--领用日期-->
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
                	sHtml = "<button type=button  class=calendar id=node_"+rowindex+"_SelectDate onclick=getdiscardDate(node_"+rowindex+"_StockInDateSpan,node_"+rowindex+"_StockInDate)></BUTTON>&nbsp;"+
						    "<SPAN id=node_"+rowindex+"_StockInDateSpan >"+currentdate+"</SPAN>"+
						    "<input type='hidden' name='node_"+rowindex+"_StockInDate' value='"+currentdate+"'>";
                    needcheck += ","+"node_"+rowindex+"_StockInDate";
					oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
            //<!--领用资产-->
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
                    sHtml = "<button type=button  class=Browser onClick=\"onShowCapitalid('"+rowindex+"')\"></button> " + 
        					"<span id=node_"+rowindex+"_cptspan><img src='/images/BacoError.gif' align=absmiddle></span> " +
					        "<input type='hidden' name='node_"+rowindex+"_capitalid' id='node_"+rowindex+"_capitalid'>" +
                            "<input type='hidden' name='node_"+rowindex+"_sptcount' id='node_"+rowindex+"_sptcount'>";
                    needcheck += ","+"node_"+rowindex+"_capitalid";
        			oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
			//<!--领用数量-->
			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
					sHtml = "<input class='InputStyle' type='text' name='node_"+rowindex+"_capitalnum' onKeyPress='ItemNum_KeyPress()' onBlur=checkinput('node_"+rowindex+"_capitalnum','node_"+rowindex+"_capitalnumspan');checkstock('"+rowindex+"') size=5 maxLength='8'>";
					sHtml += "<span id='node_"+rowindex+"_capitalnumspan'><img src='/images/BacoError.gif' align=absmiddle>";
					sHtml +="</span>";
					needcheck += ","+"node_"+rowindex+"_capitalnum";
	        		oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
            //<!--库存数量-->
			case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<span id=node_"+rowindex+"_capitalcountspan></span> ";
                    sHtml += "<input type='hidden' name='node_"+rowindex+"_capitalcount' id='node_"+rowindex+"_capitalcount'>";
					oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
            //<!--单位-->
			case 6: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<span id=node_"+rowindex+"_unitspan></span> ";
					oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
            //<!--编号-->
			case 7: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<span id=node_"+rowindex+"_codespan></span> ";
					oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
            //<!--财务编号-->
			case 8: 
				var oDiv = document.createElement("div"); 
				var oDiv = document.createElement("div"); 
				var sHtml = "<span id=node_"+rowindex+"_ficodespan></span> ";
					oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
            //<!--规格型号-->
			case 9: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<span id=node_"+rowindex+"_capitalspec></span> ";
					oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
            //<!--存放地点-->
			case 10: 
				var oDiv = document.createElement("div"); 
                var sHtml = "<input class=InputStyle name='node_"+rowindex+"_location' maxlength=100 size=10> ";
					oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
			//<!--备注-->
            case 11: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input class=InputStyle name='node_"+rowindex+"_remark' maxlength=100 size=12> ";
					oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
		}
	}
	rowindex = rowindex*1 +1;
	frmain.totaldetail.value=rowindex;
	totalrows = rowindex;
}

function deleteRow1(){
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

function onSubmit(obj){
    document.frmain.action="CapitalUseOperation.jsp";
    if(check_form(document.frmain,needcheck)) {
        document.frmain.submit();
        obj.disabled=true;
    }
}

function back(){
    window.history.back(-1);
}
</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>

