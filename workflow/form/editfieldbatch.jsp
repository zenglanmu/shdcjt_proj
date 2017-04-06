<%@page import="com.weaver.integration.util.IntegratedSapUtil"%>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="weaver.general.StaticObj"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet"/>
<jsp:useBean id="rs_child" class="weaver.conn.RecordSet"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="InputReportItemManager" class="weaver.datacenter.InputReportItemManager" scope="page" />
<jsp:useBean id="browserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="formmanager" class="weaver.workflow.form.FormManager" scope="page"/>
<jsp:useBean id="FormFieldTransMethod" class="weaver.general.FormFieldTransMethod" scope="page"/>
<jsp:useBean id="SapBrowserComInfo" class="weaver.parseBrowser.SapBrowserComInfo" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>


<%
	if(!HrmUserVarify.checkUserRight("FormManage:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");
    	
		return;
	}
%>

<%
int formid = Util.getIntValue(request.getParameter("formid"),0);
boolean isoracle = (rs.getDBType()).equals("oracle") ;
boolean canDelete = true;
String tablename = "";
rs.executeSql("select tablename from workflow_bill where id="+formid);//如果表单已使用，则表单字段不能删除
if(rs.next()){
	tablename = Util.null2String(rs.getString("tablename"));
	if(!tablename.equals("")){
		String sql_tmp = "";
		if("ORACLE".equalsIgnoreCase(rs.getDBType())){
			sql_tmp = "select * from "+tablename+" where rownum<2";
		}else{
			sql_tmp = "select top 1 * from "+tablename;
		}
		rs.executeSql(sql_tmp);//如果表单已使用，则表单字段不能删除
		if(rs.next()) canDelete = false;
	}
}

boolean canChange = false;
rs.executeSql("select 1 from workflow_base where formid="+formid);
if(rs.getCounts()<=0){//如果表单还没有被引用，字段可以修改。
    canChange = true;
}

int rowsum = 0;
String dbfieldnamesForCompare = ",";
String sql = "select * from workflow_billfield where billid="+formid+" and viewtype=0 order by dsporder,id";
RecordSet.executeSql(sql);
while(RecordSet.next()){
    rowsum++;
    String fieldname = RecordSet.getString("fieldname");
    dbfieldnamesForCompare += fieldname.toUpperCase()+",";
}

RecordSet.executeSql("select * from Workflow_billdetailtable where billid="+formid+" order by orderid");
while(RecordSet.next()){
    String tableNumber = RecordSet.getString("orderid");
    String detailtablename = RecordSet.getString("tablename");
    RecordSet1.executeSql("select * from workflow_billfield where billid="+formid+" and viewtype=1 and detailtable='"+detailtablename+"' order by dsporder,id");
    int detailnum =  RecordSet1.getCounts();
%>
<input type="hidden" id="detailTable_num_<%=tableNumber%>" value="<%=detailnum%>">
<%    
}

	
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(20839,user.getLanguage())+SystemEnv.getHtmlLabelName(17998,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<script language=javascript>
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showdetaildata(){
    var ajax=ajaxinit();
    ajax.open("POST", "editfieldbatchdetail.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("formid=<%=formid%>");
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                document.all("detaildata").innerHTML=ajax.responseText;
            }catch(e){
                return false;
            }
        }
    }
}
</script>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%
DecimalFormat decimalFormat=new DecimalFormat("0.00");//使用系统默认的格式
int detailtables = 0;
int detailtableMaxIndex = 0;
String detailtableIndexs = ",";
RecordSet.executeSql("select * from Workflow_billdetailtable where billid="+formid+" order by orderid");
while(RecordSet.next()){
	detailtables++;
	detailtableMaxIndex = RecordSet.getInt("orderid");
	detailtableIndexs += ""+detailtableMaxIndex+",";
	String detailtablename = RecordSet.getString("tablename");
%>
<input type="hidden" id="detailTable_name_<%=detailtableMaxIndex%>" value="<%=detailtablename%>">
<% 
}
%>
<FORM id="frmMain" name="frmMain" action="form_operation.jsp" method="post" >
	<input type="hidden" name=src value="addfieldbatch">
	<input type="hidden" name=formid value=<%=formid%>>
	<input type="hidden" value="0" name="recordNum">
	<input type="hidden" value="" name="delids">
	<input type="hidden" value="" name="changeRowIndexs">
	
	<input type="hidden" value="<%=detailtables%>" name="detailtables">
	<input type="hidden" value="<%=detailtableIndexs%>" name="detailtableIndexs">
<div style="display:none">
<table id="hidden_tab" cellpadding='0' width=0 cellspacing='0'>
</table>
</div>	
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<tr>
	<td valign="top" width="100%">
			<div id="detaildata">
				<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
				<script>showdetaildata();</script>
			<div>
	</td>
</tr>
</table>

 </form>
</BODY></HTML>
<script language="JavaScript">
	function setChangeDetail(tableid,rowid){
		var oldDetailChangeRowIndexs = document.all("detailChangeRowIndexs_"+tableid).value;
		if(oldDetailChangeRowIndexs.indexOf(rowid + ",")<0)
			document.all("detailChangeRowIndexs_"+tableid).value += rowid + ",";
		try{
			var dbnames = document.all("dbdetailfieldnamesForCompare_"+tableid).value;
			var dbname = document.all("olditemDspName_detail"+tableid+"_"+rowid).value.toUpperCase();
			document.all("dbdetailfieldnamesForCompare_"+tableid).value = dbnames.replace(","+dbname+",",",");
		}catch(e){}
	}
	detailtables = <%=detailtableMaxIndex%>;
	
	//添加明细表 start
	//2012-08-20 ypc 修改  定义了 width='20%'  width='80%'
	function addDetailTable(){
		detailtables = detailtables*1+1;
		document.all("detailtables").value = document.all("detailtables").value*1 + 1;
		document.all("detailtableIndexs").value = document.all("detailtableIndexs").value + detailtables + ",";
		oRow = addDetail.insertRow();
		oCell = oRow.insertCell();
		oCell.noWrap=true;
		var oDiv = document.createElement("div");
		var sHtml = "<table id='detailTable_"+detailtables+"' class=ListStyle cols=5  border=0 cellspacing=1>"+
								"<input type='hidden' value='' name='detaildelids_"+detailtables+"'>"+
								"<input type='hidden' value='' name='detailChangeRowIndexs_"+detailtables+"'>"+
								"<tr>"+
									"<td colspan=2 style='width:20%'><b><%=SystemEnv.getHtmlLabelName(18550,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%>"+document.all("detailtables").value+"</b></td>"+
									"<td colspan=3 align='right' style='width:80%'>"+
										"<button type='button' class=btn onClick='addDetailRow("+detailtables+")'><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>"+
										"<button type='button' class=btn onClick='deleteDetailRow("+detailtables+")'><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>"+
										"<button type='button' class=btn onClick='copyDetailRow("+detailtables+")'><%=SystemEnv.getHtmlLabelName(77,user.getLanguage())%></button></td>"+
								"</tr>"+
								"<tr style='height:1px;'><td colspan=5 class=line1 colSpan=2 style='padding:0px;'></td></tr>"+
								"<tr class=header>"+
									"<td NOWRAP width='5%'><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>"+
									"<td NOWRAP width='20%'><%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>"+
									"<td NOWRAP width='30%'><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></td>"+
									"<td NOWRAP width='35%'><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></td>"+
									"<td NOWRAP width='10%'><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></td>"+
								"</tr>"+
								"<input type=\"hidden\" name=\"detailTable_num_"+detailtables+"\" value=0>"+
								"</table>";
		oDiv.innerHTML = sHtml;
		oCell.appendChild(oDiv);
	}
//添加明细表 end

function copyDetailRow(detailtables){//复制明细
	var copyedRow="";
	len = document.getElementsByName("check_select_detail_"+detailtables).length;
	var i=0;
	for(i=len-1; i >= 0;i--){
			if(document.getElementsByName("check_select_detail_"+detailtables)[i].checked==true){//选中的复制
				checkSelectValue=document.getElementsByName("check_select_detail_"+detailtables)[i].value;
				checkSelectArray=checkSelectValue.split("_");
				rowNum=checkSelectArray[1];
				copyedRow+=","+rowNum;
			}
	}
	var copyedRowArray =copyedRow.split(",");
	fromRow=0;
	for (loop=copyedRowArray.length-1; loop >=0 ;loop--){
		fromRow=copyedRowArray[loop] ;
		if(fromRow==""){
			continue;
		}
		itemDspName=$G("itemDspName_detail"+detailtables+"_"+fromRow).value;
		itemDspName=trim(itemDspName);
		itemFieldName=$G("itemFieldName_detail"+detailtables+"_"+fromRow).value;
		itemFieldName=trim(itemFieldName);
		itemFieldType=$G("itemFieldType_"+detailtables+"_"+fromRow).value;
		addDetailRow(detailtables);//插入新行
		obj_table = $G("detailTable_"+detailtables);
		nowRowIndex = obj_table.rows.length-3;
		//为新行赋值
		$G("itemDspName_detail"+detailtables+"_"+nowRowIndex).value = itemDspName;
		if(itemDspName!="") $G("itemDspName_detail"+detailtables+"_"+nowRowIndex+"_span").innerHTML = "";
		$G("itemFieldName_detail"+detailtables+"_"+nowRowIndex).value = itemFieldName;
		if(itemFieldName!="") $G("itemFieldName_detail"+detailtables+"_"+nowRowIndex+"_span").innerHTML = "";
		$G("itemFieldType_"+detailtables+"_"+nowRowIndex).value = itemFieldType;
		if(itemFieldType==1){//单行文本框
			documentType_index = $G("documentType_"+detailtables+"_"+fromRow).value;
			$G("documentType_"+detailtables+"_"+nowRowIndex).value=documentType_index;
			if(documentType_index == 1){
				$G("detail_div1_1_"+detailtables+"_"+nowRowIndex).style.display="";
				doclength = $G("itemFieldScale1_"+detailtables+"_"+fromRow).value;
				if(doclength!=""){
					$G("itemFieldScale1_"+detailtables+"_"+nowRowIndex).value = doclength;
					$G("itemFieldScale1span_"+detailtables+"_"+nowRowIndex).innerHTML = "";
				}
				$G("detail_div1_3_"+detailtables+"_"+nowRowIndex).style.display="none";
				onChangDetailType(detailtables,nowRowIndex);
			}else if(documentType_index == 3){//浮点数
				$G("detail_div1_1_"+detailtables+"_"+nowRowIndex).style.display="none";
				$G("detail_div1_3_"+detailtables+"_"+nowRowIndex).style.display="";
				onChangDetailType(detailtables,nowRowIndex);
			}else{
				$G("detail_div1_1_"+detailtables+"_"+nowRowIndex).style.display="none";
				$G("detail_div1_3_"+detailtables+"_"+nowRowIndex).style.display="none";
			}
		}
		if(itemFieldType==2){//多行文本框
			$G("detail_div1_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div1_1_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div1_3_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div2_"+detailtables+"_"+nowRowIndex).style.display="inline";
			$G("textheight_"+detailtables+"_"+nowRowIndex).value = $G("textheight_"+detailtables+"_"+fromRow).value;
			$G("htmledit_"+detailtables+"_"+nowRowIndex).checked = $G("htmledit_"+detailtables+"_"+fromRow).checked;
		}
		if(itemFieldType==3){//浏览按钮
			$G("detail_div1_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div1_1_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div1_3_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div3_"+detailtables+"_"+nowRowIndex).style.display="inline";
			broswerType_value = $G("broswerType_"+detailtables+"_"+fromRow).value;
			$G("broswerType_"+detailtables+"_"+nowRowIndex).value=broswerType_value;
			if(broswerType_value==161||broswerType_value==162){
				$G("detail_div3_0_"+detailtables+"_"+nowRowIndex).style.display='inline';
				$G("detail_div3_1_"+detailtables+"_"+nowRowIndex).style.display='inline';
				$G("detail_div3_4_"+detailtables+"_"+nowRowIndex).style.display='none';
				//$G("definebroswerType_"+detailtables+"_"+nowRowIndex).selectedIndex=$G("definebroswerType_"+detailtables+"_"+fromRow).selectedIndex;
				$G("definebroswerType_"+detailtables+"_"+nowRowIndex).value=$G("definebroswerType_"+detailtables+"_"+fromRow).value;
			}else if(broswerType_value==224||broswerType_value==225){
				$G("detail_div3_0_"+detailtables+"_"+nowRowIndex).style.display='inline';
				$G("detail_div3_1_"+detailtables+"_"+nowRowIndex).style.display='none';
				$G("detail_div3_4_"+detailtables+"_"+nowRowIndex).style.display='inline';
				//$G("definebroswerType_"+detailtables+"_"+nowRowIndex).selectedIndex=$G("definebroswerType_"+detailtables+"_"+fromRow).selectedIndex;
				$G("sapbrowser_"+detailtables+"_"+nowRowIndex).value=$G("sapbrowser_"+detailtables+"_"+fromRow).value;
			}
			else if(broswerType_value==226||broswerType_value==227){
				//zzl
				$G("detail_div3_0_"+detailtables+"_"+nowRowIndex).style.display='none';
				$G("detail_div3_1_"+detailtables+"_"+nowRowIndex).style.display='none';
				$G("detail_div3_4_"+detailtables+"_"+nowRowIndex).style.display='none';
				$G("detail_div3_5_"+detailtables+"_"+nowRowIndex).style.display='inline';
				//if($G("showvalue_"+detailtables+"_"+fromRow).value=="")
				//{
					$G("showimg_"+detailtables+"_"+nowRowIndex).style.display='inline';
				//}else
				//{
					//$G("showinner_"+detailtables+"_"+nowRowIndex).innerHTML=$G("showinner_"+detailtables+"_"+fromRow).innerHTML;
					//$G("showvalue_"+detailtables+"_"+nowRowIndex).value=$G("showvalue_"+detailtables+"_"+fromRow).value;
					//$G("showimg_"+detailtables+"_"+nowRowIndex).style.display='none';
				//}
				$G("showimg_"+detailtables+"_"+nowRowIndex).style.display='inline';
				//$G("sapbrowser_"+detailtables+"_"+nowRowIndex).value=$G("sapbrowser_"+detailtables+"_"+fromRow).value;
			}
			else{
				$G("detail_div3_0_"+detailtables+"_"+nowRowIndex).style.display='none';
				$G("detail_div3_1_"+detailtables+"_"+nowRowIndex).style.display='none';
				$G("detail_div3_4_"+detailtables+"_"+nowRowIndex).style.display='none';
			}
			if(broswerType_value==165||broswerType_value==166||broswerType_value==167||broswerType_value==168){
				$G("detail_div3_2_"+detailtables+"_"+nowRowIndex).style.display='inline';
				//$G("decentralizationbroswerType_"+detailtables+"_"+nowRowIndex).selectedIndex=$G("decentralizationbroswerType_"+detailtables+"_"+fromRow).selectedIndex;
				$G("decentralizationbroswerType_"+detailtables+"_"+nowRowIndex).value=$G("decentralizationbroswerType_"+detailtables+"_"+fromRow).value;
			}else{
				$G("detail_div3_2_"+detailtables+"_"+nowRowIndex).style.display='none';
			}
		}
		if(itemFieldType==4||itemFieldType==6){//check框或附件上传
			$G("detail_div1_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div1_1_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div1_3_"+detailtables+"_"+nowRowIndex).style.display="none";
		}
		if(itemFieldType==5){//选择框
			$G("detail_div1_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div1_1_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div1_3_"+detailtables+"_"+nowRowIndex).style.display="none";
			$G("detail_div5_"+detailtables+"_"+nowRowIndex).style.display="inline";
			$G("detail_div5_1_"+detailtables+"_"+nowRowIndex).style.display="inline";
			fromrows = $G("choiceTable_"+detailtables+"_"+fromRow).rows.length;
			for(var tempindex=1;tempindex<fromrows;tempindex++){
				addDetailTableRow(detailtables,nowRowIndex);
				$G("field_count_"+detailtables+"_"+nowRowIndex+"_"+tempindex+"_name").value = $G("field_count_"+detailtables+"_"+fromRow+"_"+tempindex+"_name").value;
				var field_name = $G("field_"+detailtables+"_"+fromRow+"_"+tempindex+"_name").value;
				if(field_name!=""){
					$G("field_"+detailtables+"_"+nowRowIndex+"_"+tempindex+"_name").value = field_name;
					$G("field_"+detailtables+"_"+nowRowIndex+"_"+tempindex+"_span").innerHTML = "";
				}
				if($G("field_checked_"+detailtables+"_"+fromRow+"_"+tempindex+"_name").checked)
					$G("field_checked_"+detailtables+"_"+nowRowIndex+"_"+tempindex+"_name").checked = true;
				$G("mypath_"+detailtables+"_"+nowRowIndex+"_"+tempindex).innerHTML = $G("mypath_"+detailtables+"_"+fromRow+"_"+tempindex).innerHTML;
				$G("pathcategory_"+detailtables+"_"+nowRowIndex+"_"+tempindex).value = $G("pathcategory_"+detailtables+"_"+fromRow+"_"+tempindex).value;
				$G("maincategory_"+detailtables+"_"+nowRowIndex+"_"+tempindex).value = $G("maincategory_"+detailtables+"_"+fromRow+"_"+tempindex).value;
			}
		}
		//为新行赋值
	}
}
function deleteDetailRow(detailtables){
    var flag = false;
	var ids = document.getElementsByName("check_select_detail_"+detailtables);
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
        if(isdel()){
            var deleteIds = document.all("detaildelids_"+detailtables).value;
            var detailChangeRowIndexs = document.all("detailChangeRowIndexs_"+detailtables).value;
            obj_table1 = $G("detailTable_"+detailtables);
            len = document.getElementsByName("check_select_detail_"+detailtables).length;
            var i=0;
            var rowsum1 = 0;
            for(i=len-1; i >= 0;i--){
                if(document.getElementsByName("check_select_detail_"+detailtables)[i].checked==true) {
                    checkSelectValue=document.getElementsByName("check_select_detail_"+detailtables)[i].value;
                    checkSelectArray=checkSelectValue.split("_");
                    itemId=checkSelectArray[0];
                    if(itemId!='0'){//新添加的行该标记为“0”，不用在后台做删除操作。
                        deleteIds +=itemId+",";
                    }
                    try{
                        var dbnames = document.all("dbdetailfieldnamesForCompare_"+detailtables).value;
                        var dbname = document.all("itemDspName_detail"+detailtables+"_"+checkSelectArray[1]).value.toUpperCase();
                        document.all("dbdetailfieldnamesForCompare_"+detailtables).value = dbnames.replace(","+dbname+",",",");
                    }catch(e){}
                    detailChangeRowIndexs = detailChangeRowIndexs.replace(checkSelectArray[1]+",","");
                obj_table1.deleteRow(i+3);
                }
            }
            document.all("detaildelids_"+detailtables).value = deleteIds;
            document.all("detailChangeRowIndexs_"+detailtables).value = detailChangeRowIndexs;
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}

function addDetailRow(detailtables){
    obj_table = $G("detailTable_"+detailtables);
    //detailrowindex = obj_table.rows.length-2;//明细行号
    detailrowindex = $G("detailTable_num_"+detailtables).value*1+1;
    $G("detailTable_num_"+detailtables).value = detailrowindex;
    document.all("detailChangeRowIndexs_"+detailtables).value += detailrowindex+",";
	//ncol = obj_table.cols;
	ncol=5;
	oRow = obj_table.insertRow(-1);
	if((detailrowindex%2)==1){
       oRow.className="DataDark";
    }
    else{
       oRow.className="DataLight";
    }
	oRow.style.height=24;
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(j);
		oCell.noWrap=true;
		//oCell.style.background=rowColor;
		switch(j){
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input   type='checkbox' name='check_select_detail_"+detailtables+"' value='0_"+detailrowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;	
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text' size='15' maxlength='30' name='itemDspName_detail"+detailtables+"_"+detailrowindex+"' style='width:90%'  onblur=\"checkKey(this);checkinput_char_num('itemDspName_detail"+detailtables+"_"+detailrowindex+"');checkinput('itemDspName_detail"+detailtables+"_"+detailrowindex+"','itemDspName_detail"+detailtables+"_"+detailrowindex+"_span')\"><span id='itemDspName_detail"+detailtables+"_"+detailrowindex+"_span'><IMG src='/images/BacoError.gif' align=absMiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text'  name='itemFieldName_detail"+detailtables+"_"+detailrowindex+"' style='width:90%'   onchange=\"checkinput('itemFieldName_detail"+detailtables+"_"+detailrowindex+"','itemFieldName_detail"+detailtables+"_"+detailrowindex+"_span')\" onblur=\"checkKey(this)\"><span id='itemFieldName_detail"+detailtables+"_"+detailrowindex+"_span'><IMG src='/images/BacoError.gif' align=absMiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<select class='InputStyle' name='itemFieldType_"+detailtables+"_"+detailrowindex+"'  onChange='onChangDetailItemFieldType("+detailtables+","+detailrowindex+")'>"+
	                     "<option value='1' selected><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%></option>"+
	                    "<option value='2'><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%></option>"+
	                    "<option value='3'><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></option>"+
	                    "<option value='4'><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%></option>"+
	                    "<option value='5'><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></option>"+
	                   "</select>"+
	                   "<div id=detail_div5_"+detailtables+"_"+detailrowindex+" style='display:none'>"+
	                   	"<button type='button' class=btn id=btnaddRow name=btnaddRow onclick='addDetailTableRow("+detailtables+","+detailrowindex+")'><%=SystemEnv.getHtmlLabelName(15443,user.getLanguage())%></BUTTON>"+
	   		              "<button type='button' class=btn id=btnsubmitClear name=btnsubmitClear onclick='submitDetailClear("+detailtables+","+detailrowindex+")'><%=SystemEnv.getHtmlLabelName(15444,user.getLanguage())%></BUTTON>"+
	   		              "<span><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>"+
	   		              "<button type='button' id='showChildFieldBotton' class=Browser onClick=\"onShowChildField(childfieldidSpan_detail"+detailtables+"_"+detailrowindex+",childfieldid_detail"+detailtables+"_"+detailrowindex+",'_detail"+detailtables+"_"+detailrowindex+"')\"></BUTTON>"+
	   		              "<span id='childfieldidSpan_detail"+detailtables+"_"+detailrowindex+"'></span>"+
	   		              "<input type='hidden' value='' name='childfieldid_detail"+detailtables+"_"+detailrowindex+"' id='childfieldid_detail"+detailtables+"_"+detailrowindex+"'>"+
	                   "</div>"+
	                   "<div id=detail_div5_1_"+detailtables+"_"+detailrowindex+" style='display:none'>"+
	                  	"<table class='ViewForm' id='choiceTable_"+detailtables+"_"+detailrowindex+"' cols=6 border=0>"+
	                   	"<col width=5%><col width=25%><col width=5%><col width=8%><col width=35%><col width=22%>"+
	                   		"<tr><td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>"+
	   		              	"<td><%=SystemEnv.getHtmlLabelName(15442,user.getLanguage())%></td>"+
	   		              	"<td><%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%></td>"+
	   		              	"<td><%=SystemEnv.getHtmlLabelName(19206,user.getLanguage())%></td>"+
	   		              	"<td><%=SystemEnv.getHtmlLabelName(19207,user.getLanguage())%></td>"+
	   		           		"<td><%=SystemEnv.getHtmlLabelName(22663,user.getLanguage())%></td></tr>"+
	   		           		"<input type='hidden' value='0' name='choiceRows_"+detailtables+"_"+detailrowindex+"'>"+
	   		              "</table>"+
	                   "</div>"+
	                   "<div id=detail_div1_"+detailtables+"_"+detailrowindex+" style='display:inline'>"+
	                   	"<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>"+
	                   	"<select class='InputStyle' name='documentType_"+detailtables+"_"+detailrowindex+"'  onChange='onChangDetailType("+detailtables+","+detailrowindex+")'>"+
	                     	"<option value='1'><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>"+
	                      	"<option value='2'><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>"+
	                     	"<option value='3'><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>"+
	                      	"<option value='4'><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%></option>"+
	                      	"<option value='5'><%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%></option>"+
	                    "</select>"+
	                   "</div>"+
	                   "<div id=detail_div1_1_"+detailtables+"_"+detailrowindex+" style='display:inline'>"+
	                   	"<%=SystemEnv.getHtmlLabelName(698,user.getLanguage())+" "%>"+
	                   	"<input class='InputStyle' type='text' size=3 maxlength=3 id='itemFieldScale1_"+detailtables+"_"+detailrowindex+"' name='itemFieldScale1_"+detailtables+"_"+detailrowindex+"' onKeyPress='ItemPlusCount_KeyPress()' onblur='checkPlusnumber1(this);checklength(itemFieldScale1_"+detailtables+"_"+detailrowindex+",itemFieldScale1span_"+detailtables+"_"+detailrowindex+");checkcount1(itemFieldScale1_"+detailtables+"_"+detailrowindex+")' style='text-align:right;'><span id=itemFieldScale1span_"+detailtables+"_"+detailrowindex+"><IMG src='/images/BacoError.gif' align=absMiddle></span>"+
	                   "</div>"+
	                   "<div id=detail_div1_3_"+detailtables+"_"+detailrowindex+" style='display:none'>"+
	               	"<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>"+
	               	"<select id='decimaldigits_"+detailtables+"_"+detailrowindex+"' name='decimaldigits_"+detailtables+"_"+detailrowindex+"'>"+
				"<option value='1' >1</option>"+
				"<option value='2' selected>2</option>"+
				"<option value='3' >3</option>"+
				"<option value='4' >4</option>"+
				"</select>"+
				"</div>"+
					   //明细表中的多行文本框字段html格式不可用, 故将其设为disabled
	                   "<div id=detail_div2_"+detailtables+"_"+detailrowindex+" style='display:none'>"+
	                   	"<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>"+
	                   	"<input class='InputStyle' type='text' value=4 size=4 maxlength=2 id=textheight_"+detailtables+"_"+detailrowindex+" name='textheight_"+detailtables+"_"+detailrowindex+"' onKeyPress='ItemPlusCount_KeyPress()' onblur='checkPlusnumber1(this);checkcount1(textheight_"+detailtables+"_"+detailrowindex+")' style='text-align:right;'>"+
	                   	"<%=SystemEnv.getHtmlLabelName(222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15449,user.getLanguage())%>"+
	                   	"<input type='checkbox' value='1' name='htmledit_"+detailtables+"_"+detailrowindex+"' id='htmledit_"+detailtables+"_"+detailrowindex+"' disabled onclick='onfirmdetailhtml("+detailtables+","+detailrowindex+")'>"+
	                   "</div>"+
	                   "<div id=detail_div3_"+detailtables+"_"+detailrowindex+" style='display:none'>"+
	                   	"<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>"+
	                   	"<select class='InputStyle' name='broswerType_"+detailtables+"_"+detailrowindex+"' onChange='onChangDetailBroswerType("+detailtables+","+detailrowindex+")'>";
	                   	<%
		                   	String IsOpetype=IntegratedSapUtil.getIsOpenEcology70Sap();
		                   	while(browserComInfo.next()){
	                   	%>
	                   	<%if(browserComInfo.getBrowserurl().equals("")){ continue;}%>
	                   	<%
                      		 if("1".equals(IsOpetype)&&("224".equals(browserComInfo.getBrowserid()))||"225".equals(browserComInfo.getBrowserid())){
			                   		 	//存在新的，就不能建老的sap
				  				 		continue;
				  			}
				  			 if("0".equals(IsOpetype)&&("226".equals(browserComInfo.getBrowserid()))||"227".equals(browserComInfo.getBrowserid())){
			                   		 	//存在老的，就不能建新的sap
				  				 		continue;
				  			}
                      	%>
	            sHtml += "<option value='<%=browserComInfo.getBrowserid()%>'><%=SystemEnv.getHtmlLabelName(Util.getIntValue(browserComInfo.getBrowserlabelid(),0),user.getLanguage())%></option>";     		
	                   	<%}%>
	            sHtml += "</select>"+
	                   "</div>"+
	             			"<div id=detail_div3_0_"+detailtables+"_"+detailrowindex+" style='display:none'> "+
	             				"<span><IMG src='/images/BacoError.gif' align=absMiddle></span>"+
	                   "</div>"+
	                   "<div id=detail_div3_1_"+detailtables+"_"+detailrowindex+" style='display:none'> "+
	                   	"<select class='InputStyle' name='definebroswerType_"+detailtables+"_"+detailrowindex+"' onChange='detaildiv3_0_show("+detailtables+","+detailrowindex+")'>";
	                   	<%
	                   	List l=StaticObj.getServiceIds(Browser.class);
	                   	for(int j=0;j<l.size();j++){
	                   	%>
	            sHtml += "<option value='<%=l.get(j)%>'><%=l.get(j)%></option>";
	                   	<%}%>
	            sHtml += "</select>"+
	                   "</div>"+
	                   
	                   "<div id=detail_div3_4_"+detailtables+"_"+detailrowindex+" style='display:none'> "+
	                	"<select class='InputStyle' name='sapbrowser_"+detailtables+"_"+detailrowindex+"' onChange='detaildiv3_4_show("+detailtables+","+detailrowindex+")'>";
	                	<%
	                	List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
	                	for(int j=0;j<AllBrowserId.size();j++){
	                	%>
	         				sHtml += "<option value='<%=AllBrowserId.get(j)%>'><%=AllBrowserId.get(j)%></option>";
	                	<%}%>
	         				sHtml += "</select>"+
	                "</div>"+
	                
	                "<div id=detail_div3_5_"+detailtables+"_"+detailrowindex+" style='display:none'> "+
	                	"<button type=button  class='browser' name='newsapbrowser_"+detailtables+"_"+detailrowindex+"' id='newsapbrowser_"+detailtables+"_"+detailrowindex+"'  onclick=OnNewChangeSapBroswerTypeDetails("+detailtables+","+detailrowindex+")></button>"+
				  		 "<span id='showinner_"+detailtables+"_"+detailrowindex+"'></span>"+
						"<span id='showimg_"+detailtables+"_"+detailrowindex+"'><IMG src='/images/BacoError.gif' align=absMiddle></span>"+
						"<input type='hidden'  name='showvalue_"+detailtables+"_"+detailrowindex+"' id='showvalue_"+detailtables+"_"+detailrowindex+"' >"+
						"<input type='hidden' value=''  id='updateTableName_"+detailtables+"_"+detailrowindex+"'>"+
	                "</div>"+
	                 "<div id=detail_div3_2_"+detailtables+"_"+detailrowindex+" style='display:none'> "+
	                   	"<%=SystemEnv.getHtmlLabelName(19340,user.getLanguage())%>"+
	                   	"<select class='InputStyle' name='decentralizationbroswerType_"+detailtables+"_"+detailrowindex+"'>"+
	                   	"<option value='1' selected><%=SystemEnv.getHtmlLabelName(18916,user.getLanguage())%></option>"+
	                     "<option value='2'><%=SystemEnv.getHtmlLabelName(18919,user.getLanguage())%></option>"+
	                      "</select>"+
	                    "</div>"+
	                    "";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 4:
				var oDiv = document.createElement("div");
				var sHtml = " <input class='InputStyle' type='text' size=10 maxlength=7 name='itemDspOrder_detail"+detailtables+"_"+detailrowindex+"' value='"+detailrowindex+".00'  onKeyPress='ItemNum_KeyPress(\"itemDspOrder_detail"+detailtables+"_"+detailrowindex+"\")' onchange='checknumber(\"itemDspOrder_detail"+detailtables+"_"+detailrowindex+"\");checkDigit(\"itemDspOrder_detail"+detailtables+"_"+detailrowindex+"\",15,2)' style='text-align:right;'>";						   
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;				
			case 5:
				var oDiv = document.createElement("div");
				var sHtml = "<button type='button' class=\"Browser\" onClick=\"onShowChildSelectItem(childItemSpan_detail"+detailtables+"_"+choicerowindex+",childItem_detail"+detailtables+"_"+choicerowindex+",'_detail"+detailtables+"')\" id=\"selectChildItem_detail"+detailtables+"_"+choicerowindex+"\" name=\"selectChildItem_detail"+detailtables+"_"+choicerowindex+"\"></BUTTON>"
							+ "<input type=\"hidden\" id=\"childItem_detail"+detailtables+"_"+choicerowindex+"\" name=\"childItem_detail"+detailtables+"_"+choicerowindex+"\" value=\"\" >"
							+ "<span id=\"childItemSpan_detail"+detailtables+"_"+choicerowindex+"\" name=\"childItemSpan_detail"+detailtables+"_"+choicerowindex+"\"></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
}

//明细表字段 选择框 删除选项
function submitDetailClear(tableid,rowid){
	setChangeDetail(tableid,rowid);
	var flag = false;
	var ids = document.getElementsByName('chkDetailField');
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
        if(isdel()){
		    deleteRow2(tableid,rowid);
            }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}
//明细表字段 选择框 删除选项
function deleteRow2(tableid,rowid){
	var objTbl = $G("choiceTable_"+tableid+"_"+rowid);
	var objChecks=objTbl.getElementsByTagName("INPUT");	
	for(var i=objChecks.length-1;i>=0;i--){
		if(objChecks[i].name=="chkDetailField" && objChecks[i].checked) {
		   objTbl.deleteRow(objChecks[i].parentElement.parentElement.parentElement.rowIndex);
		}   
	}	 
}

//明细表字段 选择框 添加选项
function addDetailTableRow(tableid,tablerowid){
  rowColor1 = getRowBg();
  obj1 = $G("choiceTable_"+tableid+"_"+tablerowid);
  choicerowindex = $G("choiceRows_"+tableid+"_"+tablerowid).value*1+1;
  $G("choiceRows_"+tableid+"_"+tablerowid).value = choicerowindex;
  ncol1 = obj1.rows[0].cells.length;
  oRow1 = obj1.insertRow(-1);
	for(j=0; j<ncol1; j++) {
		oCell1 = oRow1.insertCell(-1);
		switch(j) {
			case 0:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<input   type='checkbox' name='chkDetailField' index='"+choicerowindex+"' value='0'>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 1:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<input class='InputStyle' type='text' size='10' name='field_"+tableid+"_"+tablerowid+"_"+choicerowindex+"_name' style='width=90%'"+
							" onchange=checkinput('field_"+tableid+"_"+tablerowid+"_"+choicerowindex+"_name','field_"+tableid+"_"+tablerowid+"_"+choicerowindex+"_span')>"+
							" <span id='field_"+tableid+"_"+tablerowid+"_"+choicerowindex+"_span'><IMG src='/images/BacoError.gif' align=absMiddle></span>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 2:
				var oDiv1 = document.createElement("div");
				var sHtml1 = " <input class='InputStyle' type='text' size='4' value = '0.00' name='field_count_"+tableid+"_"+tablerowid+"_"+choicerowindex+"_name' style='width=90%'"+
							" onKeyPress=ItemNum_KeyPress('field_count_"+tableid+"_"+tablerowid+"_"+choicerowindex+"_name') onchange=checknumber('field_count_"+tableid+"_"+tablerowid+"_"+choicerowindex+"_name')>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 3:
				var oDiv1 = document.createElement("div");
				var sHtml1 = " <input type='checkbox' name='field_checked_"+tableid+"_"+tablerowid+"_"+choicerowindex+"_name' onclick='if(this.checked){this.value=1;}else{this.value=0}'>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 4:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<input type='checkbox' name='isAccordToSubCom"+tableid+"_"+tablerowid+"_"+choicerowindex+"' value='1' ><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;"
							+ "<button type='button' class=Browser onClick=\"onShowDetailCatalog(mypath_"+tableid+"_"+tablerowid+"_"+choicerowindex+","+tableid+","+tablerowid+","+choicerowindex+")\" name=selectCategory></BUTTON>"
							+ "<span id=mypath_"+tableid+"_"+tablerowid+"_"+choicerowindex+"></span>"
						    + "<input type=hidden id='pathcategory_" + tableid+"_"+tablerowid + "_"+choicerowindex+"' name='pathcategory_" + tableid+"_"+tablerowid + "_"+choicerowindex+"' value=''>"
						    + "<input type=hidden id='maincategory_" + tableid+"_"+tablerowid + "_"+choicerowindex+"' name='maincategory_" + tableid+"_"+tablerowid + "_"+choicerowindex+"' value=''>";

				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 5:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<button type='button' class=\"Browser\" onClick=\"onShowChildSelectItem(childItemSpan_" + tableid+"_"+tablerowid + "_"+choicerowindex+",childItem_" + tableid+"_"+tablerowid + "_"+choicerowindex+",'_detail"+tableid+"_"+tablerowid+"')\" id=\"selectChildItem_" + tableid+"_"+tablerowid + "_"+choicerowindex+"\" name=\"selectChildItem_" + tableid+"_"+tablerowid + "_"+choicerowindex+"\"></BUTTON>"
							+ "<input type=\"hidden\" id=\"childItem_" + tableid+"_"+tablerowid + "_"+choicerowindex+"\" name=\"childItem_" + tableid+"_"+tablerowid + "_"+choicerowindex+"\" value=\"\" >"
							+ "<span id=\"childItemSpan_" + tableid+"_"+tablerowid + "_"+choicerowindex+"\" name=\"childItemSpan_" + tableid+"_"+tablerowid + "_"+choicerowindex+"\"></span>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
		}		
	}
}
function detaildiv3_0_show(detailtableid,detailtablerowid){
	detaildiv3_1_value = $G("definebroswerType_"+detailtableid+"_"+detailtablerowid).value;
	if(detaildiv3_1_value=="")
		$G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display='inline';
	else
		$G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display='none';
}
function detaildiv3_4_show(detailtableid,detailtablerowid){
	detaildiv3_4_value = $G("sapbrowser_"+detailtableid+"_"+detailtablerowid).value;
	if(detaildiv3_4_value==""){
		$G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display='inline';
	}else{
		$G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display='none';
	}
}
function onChangDetailItemFieldType(detailtableid,detailtablerowid){
		itemFieldType = $G("itemFieldType_"+detailtableid+"_"+detailtablerowid).value;
		broswerType = $G("broswertype_"+detailtableid+"_"+detailtablerowid).value;
		if(itemFieldType==1){
			$G("detail_div1_"+detailtableid+"_"+detailtablerowid).style.display='inline';
			$G("detail_div1_1_"+detailtableid+"_"+detailtablerowid).style.display='inline';
			$G("documentType_"+detailtableid+"_"+detailtablerowid).selectedIndex=0;
			$G("detail_div1_3_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div2_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_2_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_4_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_5_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div5_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div5_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
		}
		if(itemFieldType==2){
			$G("detail_div1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div1_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div1_3_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div2_"+detailtableid+"_"+detailtablerowid).style.display='inline';
			$G("detail_div3_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_2_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_4_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_5_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div5_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div5_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
		}
		if(itemFieldType==3){
			$G("detail_div1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div1_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div1_3_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div2_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_"+detailtableid+"_"+detailtablerowid).style.display='inline';
			$G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_2_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_4_"+detailtableid+"_"+detailtablerowid).style.display='none';
			if(broswerType=="226"||broswerType=="227"){
				$G("detail_div3_5_"+detailtableid+"_"+detailtablerowid).style.display='inline';
			}else{
				$G("detail_div3_5_"+detailtableid+"_"+detailtablerowid).style.display='none';
			}
			$G("detail_div5_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div5_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
		}
		if(itemFieldType==4){
			$G("detail_div1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div1_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div1_3_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div2_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_2_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_4_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_5_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div5_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div5_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
		}
    if(itemFieldType==5){
			$G("detail_div1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div1_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div1_3_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div2_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_2_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_4_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_5_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div5_"+detailtableid+"_"+detailtablerowid).style.display='inline';
			$G("detail_div5_1_"+detailtableid+"_"+detailtablerowid).style.display='inline';
		}
    if(itemFieldType==6){
			$G("detail_div1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div1_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div1_3_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div2_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_2_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_5_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div3_4_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div5_"+detailtableid+"_"+detailtablerowid).style.display='none';
			$G("detail_div5_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
		}
}
function onChangDetailType(detailtableid,detailtablerowid){
	itemFieldType = $G("documentType_"+detailtableid+"_"+detailtablerowid).value;
	if(itemFieldType==1){
		$G("detail_div1_1_"+detailtableid+"_"+detailtablerowid).style.display='inline';
		$G("detail_div1_3_"+detailtableid+"_"+detailtablerowid).style.display='none';
		$G("detail_div2_"+detailtableid+"_"+detailtablerowid).style.display='none';
	}else if(itemFieldType==3){
		$G("detail_div1_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
		$G("detail_div1_3_"+detailtableid+"_"+detailtablerowid).style.display='inline';
		$G("detail_div2_"+detailtableid+"_"+detailtablerowid).style.display='none';
	}else{
		$G("detail_div1_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
		$G("detail_div1_3_"+detailtableid+"_"+detailtablerowid).style.display='none';
		$G("detail_div2_"+detailtableid+"_"+detailtablerowid).style.display='none';
	}
}
function onfirmdetailhtml(detailtableid,detailtablerowid){
	if($G("htmledit_"+detailtableid+"_"+detailtablerowid).checked==true){
		alert('<%=SystemEnv.getHtmlLabelName(20867,user.getLanguage())%>');
		document.all("htmledit_"+detailtableid+"_"+detailtablerowid).value=2;
	}
	//else{
	//	document.all("htmledit_"+detailtableid+"_"+detailtablerowid).value=1;
	//}
}
function onChangDetailBroswerType(detailtableid,detailtablerowid){
	broswerType = $G("broswerType_"+detailtableid+"_"+detailtablerowid).value;
	if(broswerType==161||broswerType==162){
		//$G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display='inline';
		$G("detail_div3_1_"+detailtableid+"_"+detailtablerowid).style.display='inline';
		$G("detail_div3_4_"+detailtableid+"_"+detailtablerowid).style.display='none';
		$G("detail_div3_5_"+detailtableid+"_"+detailtablerowid).style.display='none';
		var defineBrowserOptionValue = $G("definebroswerType_"+detailtableid+"_"+detailtablerowid).value;
		if(defineBrowserOptionValue==''||defineBrowserOptionValue==0){
		    $G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display="inline"
		}else{
		    $G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display="none"
		}
	}else if(broswerType==224||broswerType==225){
		$G("detail_div3_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
		$G("detail_div3_4_"+detailtableid+"_"+detailtablerowid).style.display='inline';
		//zzl
		$G("detail_div3_5_"+detailtableid+"_"+detailtablerowid).style.display='none';
		var sapbrowserOptionValue = $G("sapbrowser_"+detailtableid+"_"+detailtablerowid).value;
		if(sapbrowserOptionValue==''||sapbrowserOptionValue==0){
		    $G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display="inline"
		}else{
		    $G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display="none"
		}
	}else if(broswerType==226||broswerType==227){
		//zzl
		$G("detail_div3_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
		$G("detail_div3_4_"+detailtableid+"_"+detailtablerowid).style.display='none';
		$G("detail_div3_5_"+detailtableid+"_"+detailtablerowid).style.display='inline';
		var sapbrowserOptionValue = $G("showvalue_"+detailtableid+"_"+detailtablerowid).value;
		if(sapbrowserOptionValue==''){
		    $G("showimg_"+detailtableid+"_"+detailtablerowid).style.display="inline"
		}else{
		    $G("showimg_"+detailtableid+"_"+detailtablerowid).style.display="none"
		}
	}
	else{
		$G("detail_div3_0_"+detailtableid+"_"+detailtablerowid).style.display='none';
		$G("detail_div3_1_"+detailtableid+"_"+detailtablerowid).style.display='none';
		$G("detail_div3_4_"+detailtableid+"_"+detailtablerowid).style.display='none';
		//zzl
		$G("detail_div3_5_"+detailtableid+"_"+detailtablerowid).style.display='none';
	}
	if(broswerType==165||broswerType==166||broswerType==167||broswerType==168){
		$G("detail_div3_2_"+detailtableid+"_"+detailtablerowid).style.display='inline';
	}else{
		$G("detail_div3_2_"+detailtableid+"_"+detailtablerowid).style.display='none';
	}
}

function onShowDetailCatalog(spanName, tableid, index, choicerowindex){
	var isAccordToSubCom=0;
	if($G("isAccordToSubCom"+tableid+"_"+index+"_"+choicerowindex)!=null){
		if($G("isAccordToSubCom"+tableid+"_"+index+"_"+choicerowindex).checked){
			isAccordToSubCom=1;
		}
	}
	if(isAccordToSubCom==1){
		onShowDetailCatalogSubCom(spanName, tableid, index, choicerowindex);
	}else{
		onShowDetailCatalogHis(spanName, tableid, index, choicerowindex);
	}
}
function onShowDetailCatalogHis(spanName, tableid, index, choicerowindex) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp");
    if (result != null){
    	var rid = wuiUtil.getJsonValueByIndex(result, 0);
    	var rname = wuiUtil.getJsonValueByIndex(result, 1);
    	var rkey3 = wuiUtil.getJsonValueByIndex(result, 2);
    	var rkey4 = wuiUtil.getJsonValueByIndex(result, 3);
    	var rkey5 = wuiUtil.getJsonValueByIndex(result, 4);
        if (rid > 0){
        	setChangeDetail(tableid,index);
            spanName.innerHTML = rkey3;
            $G("pathcategory_"+tableid+"_"+index+"_"+choicerowindex).value= rkey3;
            $G("maincategory_"+tableid+"_"+index+"_"+choicerowindex).value= rkey4+","+rrkey5+","+rname;
        }else{
            spanName.innerHTML="";
            $G("pathcategory_"+tableid+"_"+index+"_"+choicerowindex).value="";
            $G("maincategory_"+tableid+"_"+index+"_"+choicerowindex).value="";
       }
    }
}
function onShowDetailCatalogSubCom(spanName, tableid, index, choicerowindex) {
	if($G("selectvalue"+tableid+"_"+index+"_"+choicerowindex)==null){
		alert("<%=SystemEnv.getHtmlLabelName(24460,user.getLanguage())%>");
		return;
	}

	var fieldid = $G("modifyflag_"+tableid+"_"+index).value;
	var selectvalue=$G("selectvalue"+tableid+"_"+index+"_"+choicerowindex).value;
	url =escape("/workflow/field/SubcompanyDocCategoryBrowser.jsp?fieldId="+fieldid+"&isBill=1&selectValue="+selectvalue)
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
}


</script>
<script language="JavaScript" src="/js/addRowBg.js" >
</script>
<script language=javascript>
rowindex = "<%=rowsum%>";
delids = ",";
changeRowIndexs = ",";
var rowColor="" ;
var paraStr="";
function addRow(){			
    rowColor = getRowBg();
	ncol = oTable.rows[0].cells.length;
	oRow = oTable.insertRow(-1);
	oRow.style.height=24;
	setChange(rowindex);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(j);
		oCell.noWrap=true;
		//oCell.style.height=24;
		oCell.style.background=rowColor;
		switch(j){
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input   type='checkbox' name='check_select' value='0_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
				
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text' size='15' maxlength='30' name='itemDspName_"+rowindex+"' style='width:90%'  onblur=\"checkKey(this);checkinput_char_num('itemDspName_"+rowindex+"');checkinput('itemDspName_"+rowindex+"','itemDspName_"+rowindex+"_span')\"><span id='itemDspName_"+rowindex+"_span'><IMG src='/images/BacoError.gif' align=absMiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text'  name='itemFieldName_"+rowindex+"' style='width:90%'   onchange=\"checkinput('itemFieldName_"+rowindex+"','itemFieldName_"+rowindex+"_span')\" onblur=\"checkKey(this)\"><span id='itemFieldName_"+rowindex+"_span'><IMG src='/images/BacoError.gif' align=absMiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<%=formmanager.getItemFieldTypeSelectForAddMainRow(user)%>";	
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 4:
				var oDiv = document.createElement("div");
				var sHtml = " <input class='InputStyle' type='text' size=10 maxlength=7 name='itemDspOrder_"+rowindex+"' value='"+(rowindex*1 +1)+".00'  onKeyPress='ItemNum_KeyPress(\"itemDspOrder_"+rowindex+"\")' onchange='checknumber(\"itemDspOrder_"+rowindex+"\");checkDigit(\"itemDspOrder_"+rowindex+"\",15,2)' style='text-align:right;'>";						   
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;				
		}
	}
	rowindex = rowindex*1 +1;
}
function checkmaxlength(maxlen,elementname){
    tmpvalue = elementname.value;
    if(tmpvalue < maxlen){
        alert("<%=SystemEnv.getHtmlLabelName(23548,user.getLanguage())%>");
        elementname.value = maxlen;
    }
}
function checklength(elementname,spanid){
	tmpvalue = elementname.value;
	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	if(tmpvalue!=""&&tmpvalue!=0){
		 spanid.innerHTML='';
	}
	else{
	 spanid.innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";
	 elementname.value = "";
	}
}
function deleteRow(){
	var flag = false;
	var ids = document.getElementsByName('check_select');
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
        if(isdel()){
            len = document.getElementsByName("check_select").length;
            var i=0;
            var rowsum1 = 0;
            var deleteFlag = false;
            for(i=len-1; i >= 0;i--){
                if(document.getElementsByName("check_select")[i].checked==true) {
                    checkSelectValue=document.getElementsByName("check_select")[i].value;
                    checkSelectArray=checkSelectValue.split("_");
                    itemId=checkSelectArray[0];
                    if(itemId!='0'){
                    //	if("<%=canDelete%>"=="false"){//如果表单已被流程引用，则表单已有字段不能删除
                    //		document.getElementsByName("check_select")[i].checked=false;
                    //		deleteFlag = true;
                    //		continue;
                    //	}
                        delids +=itemId+",";
                    }
                    changeRowIndexs = changeRowIndexs.replace(checkSelectArray[1]+",","");

                    try{
                    var dbfieldname = document.all("itemDspName_"+checkSelectArray[1]).value.toUpperCase();
                    dbfieldnames = dbfieldnames.replace(","+dbfieldname+",",",");
                    }catch(e){}

                oTable.deleteRow(i+1);
                }
            }
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}

function copyRow(){
	var copyedRow="";
	len = document.getElementsByName("check_select").length;
	var i=0;
	for(i=len-1; i >= 0;i--){
			if(document.getElementsByName("check_select")[i].checked==true) {
				checkSelectValue=document.getElementsByName("check_select")[i].value;
				checkSelectArray=checkSelectValue.split("_");
				rowNum=checkSelectArray[1];
				copyedRow+=","+rowNum;
			}
	}
	
	var copyedRowArray =copyedRow.substring(1).split(",");
	fromRow=0;
	for (loop=copyedRowArray.length-1; loop >=0 ;loop--){
		setChange(rowindex);
		fromRow=copyedRowArray[loop] ;
		if(fromRow==""){
			continue;
		}
		itemDspName=$G("itemDspName_"+fromRow).value;
		itemDspName=trim(itemDspName);
		itemFieldName=$G("itemFieldName_"+fromRow).value;
		itemFieldName=trim(itemFieldName);
		itemFieldType=$G("itemFieldType_"+fromRow).value;

		rowColor = getRowBg();
	  ncol = oTable.rows[0].cells.length;
	  oRow = oTable.insertRow(-1);
	  
	  var rowsLen=oTable.rows.length;
	  if(rowsLen%2==0)
	     oRow.className="DataLight";
	  else
	     oRow.className="DataDark";   

	  for(i=0; i<ncol; i++) {
		oCell = oRow.insertCell(i);
		oCell.noWrap=true;
		oCell.style.height=24;
		//oCell.style.background=rowColor;
		switch(i) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input   type='checkbox' name='check_select' value='0_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text' size='35' maxlength='30' name='itemDspName_"+rowindex+"' value='"+itemDspName+"' style='width:90%'   onblur=\"checkKey(this);checkinput_char_num('itemDspName_"+rowindex+"');checkinput('itemDspName_"+rowindex+"','itemDspName_"+rowindex+"_span')\"><span id='itemDspName_"+rowindex+"_span'>";
				if(itemDspName==""){
					sHtml+="<IMG src='/images/BacoError.gif' align=absMiddle>";
				}
				sHtml+="</span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text'  name='itemFieldName_"+rowindex+"' value='"+itemFieldName+"' style='width:90%'   onchange=\"checkinput('itemFieldName_"+rowindex+"','itemFieldName_"+rowindex+"_span')\" onblur=\"checkKey(this)\"><span id='itemFieldName_"+rowindex+"_span'>";
				if(itemFieldName==""){
					sHtml+="<IMG src='/images/BacoError.gif' align=absMiddle>";
				}
				sHtml+="</span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<%=formmanager.getItemFieldTypeSelectForAddMainRow(user)%>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				itemFieldType_index = $G("itemFieldType_"+fromRow).value;
				$G("itemFieldType_"+rowindex).value=itemFieldType_index;
				if(itemFieldType_index==1){
					var documentType_index = $G("documentType_"+fromRow).value;
					$G("documentType_"+rowindex).value=documentType_index;
					if(documentType_index == 1){
						$G("div1_1_"+rowindex).style.display="";
						doclength = $G("itemFieldScale1_"+fromRow).value;
						if(doclength!=""){
							$G("itemFieldScale1_"+rowindex).value = doclength;
							$G("itemFieldScale1span_"+rowindex).innerHTML = "";
						}
						$G("div1_3_"+rowindex).style.display="none";
						onChangType(rowindex);
					}else if(documentType_index == 3){
						$G("div1_1_"+rowindex).style.display="none";
						$G("div1_3_"+rowindex).style.display="";
						onChangType(rowindex);
					}else{
						$G("div1_1_"+rowindex).style.display="none";
						$G("div1_3_"+rowindex).style.display="none";
					}
				}
				if(itemFieldType_index==2){
					$G("div1_"+rowindex).style.display="none";
					$G("div1_1_"+rowindex).style.display="none";
					$G("div1_3_"+rowindex).style.display="none";
					$G("div2_"+rowindex).style.display="inline";
					$G("textheight_"+rowindex).value = $G("textheight_"+fromRow).value;
					$G("htmledit_"+rowindex).checked = $G("htmledit_"+fromRow).checked;
				}
				if(itemFieldType_index==3){
					$G("div1_"+rowindex).style.display="none";
					$G("div1_1_"+rowindex).style.display="none";
					$G("div1_3_"+rowindex).style.display="none";
					$G("div3_"+rowindex).style.display="inline";
					$G("broswerType_"+rowindex).value=$G("broswerType_"+fromRow).value;
					
					var broswerType_index = $G("broswerType_"+fromRow).value;
					//alert(broswerType_index);
					if(broswerType_index==161||broswerType_index==162){
						$G("div3_1_"+rowindex).style.display="inline";
						if($G("definebroswerType_"+fromRow).value=="") $G("div3_0_"+rowindex).style.display="inline";
						$G("definebroswerType_"+rowindex).value=$G("definebroswerType_"+fromRow).value;
					}
					if(broswerType_index==224||broswerType_index==225){
						$G("div3_4_"+rowindex).style.display="inline";
						if($G("sapbrowser_"+fromRow).value=="") $G("div3_0_"+rowindex).style.display="inline";
						$G("sapbrowser_"+rowindex).value=$G("sapbrowser_"+fromRow).value;
					}
					//zzl
					if(broswerType_index==226||broswerType_index==227){
						$G("div3_5_"+rowindex).style.display="inline";
						//if($G("showvalue_"+fromRow).value=="") 
						//{
						//	$G("showimg_"+rowindex).style.display="inline";
						//}else
						//{
							//$G("showimg_"+rowindex).style.display="none";
						//}
						$G("showimg_"+rowindex).style.display="inline";
						//$G("showvalue_"+rowindex).value=$G("showvalue_"+fromRow).value;
						//$G("showinner_"+rowindex).innerHTML=$G("showinner_"+fromRow).innerHTML;
					}
					
					if(broswerType_index==165||broswerType_index==166||broswerType_index==167||broswerType_index==168){
						$G("div3_2_"+rowindex).style.display="inline";
						$G("decentralizationbroswerType_"+rowindex).value=$G("decentralizationbroswerType_"+fromRow).value;
					}
				}
				if(itemFieldType_index==4){
					$G("div1_"+rowindex).style.display="none";
					$G("div1_1_"+rowindex).style.display="none";
					$G("div1_3_"+rowindex).style.display="none";
				}
				if(itemFieldType_index==5){
					$G("div1_"+rowindex).style.display="none";
					$G("div1_1_"+rowindex).style.display="none";
					$G("div1_3_"+rowindex).style.display="none";
					$G("div5_"+rowindex).style.display="inline";
					$G("div5_5_"+rowindex).style.display="inline";
					fromrows = $G("choiceTable_"+fromRow).rows.length;
					for(var tempindex=1;tempindex<fromrows;tempindex++){
						addoTableRow(rowindex);
						dbfieldnames+=itemDspName.toUpperCase()+",";
						$G("field_count_"+rowindex+"_"+tempindex+"_name").value = $G("field_count_"+fromRow+"_"+tempindex+"_name").value;
						var field_name = $G("field_"+fromRow+"_"+tempindex+"_name").value;
						if(field_name!=""){
							$G("field_"+rowindex+"_"+tempindex+"_name").value = field_name;
							$G("field_"+rowindex+"_"+tempindex+"_span").innerHTML = "";
						}
						if($G("field_checked_"+fromRow+"_"+tempindex+"_name").checked)
							$G("field_checked_"+rowindex+"_"+tempindex+"_name").checked = true;
						$G("mypath_"+rowindex+"_"+tempindex).innerHTML = $G("mypath_"+fromRow+"_"+tempindex).innerHTML;
						$G("pathcategory_"+rowindex+"_"+tempindex).value = $G("pathcategory_"+fromRow+"_"+tempindex).value;
						$G("maincategory_"+rowindex+"_"+tempindex).value = $G("maincategory_"+fromRow+"_"+tempindex).value;
					}
				}
				if(itemFieldType_index==6){
					$G("div1_"+rowindex).style.display="none";
					$G("div1_1_"+rowindex).style.display="none";
					$G("div1_3_"+rowindex).style.display="none";
					
					onChangItemFieldType(rowindex);
					var _uploadtype_fromRow = $G("uploadtype_"+fromRow);
					var _uploadtype_rowindex = $G("uploadtype_"+rowindex);
					for(var itemFieldType_i=0;itemFieldType_i<_uploadtype_rowindex.options.length;itemFieldType_i++){
						_uploadtype_rowindex.options[itemFieldType_i].selected
							=_uploadtype_fromRow.options[itemFieldType_i].selected;
						if(_uploadtype_fromRow.options[itemFieldType_i].selected){
							break;
						}
					}
					onuploadtype(_uploadtype_rowindex, rowindex);
					var uploadtype_value = _uploadtype_fromRow.value;
					if(uploadtype_value==2){
						$G("strlength_"+rowindex).value=$G("strlength_"+fromRow).value;
						$G("imgwidth_"+rowindex).value=$G("imgwidth_"+fromRow).value;
						$G("imgheight_"+rowindex).value=$G("imgheight_"+fromRow).value;
					}
				}
				if(itemFieldType_index==7){
					$G("div1_"+rowindex).style.display="none";
					$G("div1_1_"+rowindex).style.display="none";
					$G("div1_3_"+rowindex).style.display="none";
				    $G("div7_"+rowindex).style.display="inline";
				    var specialfieldtype = $G("specialfield_"+fromRow).value;

				    if(specialfieldtype==1){
					    $G("div7_1_"+rowindex).style.display="";
					    $G("div7_2_"+rowindex).style.display="none";
					    $G("displayname_"+rowindex).value = $G("displayname_"+fromRow).value;
					    $G("linkaddress_"+rowindex).value = $G("linkaddress_"+fromRow).value;					
					}else{
					    $G("div7_1_"+rowindex).style.display="none";
					    $G("div7_2_"+rowindex).style.display="";
				    	$G("descriptivetext_"+rowindex).value = $G("descriptivetext_"+fromRow).value;					
					}
				}
				break;	
			case 4:
				var oDiv = document.createElement("div");
				var sHtml = " <input class='InputStyle' type='text' size=10 maxlength=7 name='itemDspOrder_"+rowindex+"' value='"+(rowindex*1 +1)+".00' onKeyPress='ItemNum_KeyPress(\"itemDspOrder_"+rowindex+"\")' onchange='checknumber(\"itemDspOrder_"+rowindex+"\");checkDigit(\"itemDspOrder_"+rowindex+"\",15,2)'  style='text-align:right;'>";
						   
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;				
			case 5:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<button type='button' class=\"Browser\" onClick=\"onShowChildSelectItem(childItemSpan_"+index+"_"+choicerowindex+",childItem_"+index+"_"+choicerowindex+",'_"+index+"')\" id=\"selectChildItem_"+index+"_"+choicerowindex+"\" name=\"selectChildItem_"+index+"_"+choicerowindex+"\"></BUTTON>"
							+ "<input type=\"hidden\" id=\"childItem_"+index+"_"+choicerowindex+"\" name=\"childItem_"+index+"_"+choicerowindex+"\" value=\"\" >"
							+ "<span id=\"childItemSpan_"+index+"_"+choicerowindex+"\" name=\"childItemSpan_"+index+"_"+choicerowindex+"\"></span>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
		}
	  }
	  rowindex = rowindex*1 +1;
	}
}
function onChangType(rowNum){
	itemFieldType = $G("documentType_"+rowNum).value;
	if(itemFieldType==1){
		$G("div1_1_"+rowNum).style.display='inline';
		$G("div1_3_"+rowNum).style.display='none';
		$G("div2_"+rowNum).style.display='none';
	}else if(itemFieldType==3){
		$G("div1_1_"+rowNum).style.display='none';
		$G("div1_3_"+rowNum).style.display='inline';
		$G("div2_"+rowNum).style.display='none';
	}else{
		$G("div1_1_"+rowNum).style.display='none';
		$G("div1_3_"+rowNum).style.display='none';
		$G("div2_"+rowNum).style.display='none';
	}
}
function onfirmhtml(index){
	if (document.all("htmledit_"+index).checked==true){
		alert('<%=SystemEnv.getHtmlLabelName(20867,user.getLanguage())%>');
		document.all("htmledit_"+index).value=2;
	}
	//else{
	//	document.all("htmledit_"+index).value=1;
	//}
}
function onChangItemFieldType(rowNum){

		itemFieldType = $G("itemFieldType_"+rowNum).value;
		broswerType = $G("broswerType_"+rowNum).value;
		if(itemFieldType==1){
			$G("div1_"+rowNum).style.display='inline';
			$G("div1_1_"+rowNum).style.display='inline';
			$G("documentType_"+rowNum).selectedIndex=0;
			$G("div1_3_"+rowNum).style.display='none';
			$G("div2_"+rowNum).style.display='none';
			$G("div3_"+rowNum).style.display='none';
			$G("div3_0_"+rowNum).style.display='none';
			$G("div3_1_"+rowNum).style.display='none';
			$G("div3_2_"+rowNum).style.display='none';
			$G("div3_4_"+rowNum).style.display='none';
			$G("div3_5_"+rowNum).style.display='none';
			$G("div5_"+rowNum).style.display='none';
			$G("div5_5_"+rowNum).style.display='none';
            $G("div6_"+rowNum).style.display="none";
		    $G("div6_1_"+rowNum).style.display="none";
		    $G("div7_"+rowNum).style.display="none";
		    $G("div7_1_"+rowNum).style.display="none";
		    $G("div7_2_"+rowNum).style.display="none";
		}
		if(itemFieldType==2){
			$G("div1_"+rowNum).style.display='none';
			$G("div1_1_"+rowNum).style.display='none';
			$G("div1_3_"+rowNum).style.display='none';
			$G("div2_"+rowNum).style.display='inline';
			$G("div3_"+rowNum).style.display='none';
			$G("div3_0_"+rowNum).style.display='none';
			$G("div3_1_"+rowNum).style.display='none';
			$G("div3_2_"+rowNum).style.display='none';
			$G("div3_4_"+rowNum).style.display='none';
			$G("div3_5_"+rowNum).style.display='none';
			$G("div5_"+rowNum).style.display='none';
			$G("div5_5_"+rowNum).style.display='none';
            $G("div6_"+rowNum).style.display="none";
		    $G("div6_1_"+rowNum).style.display="none";
		    $G("div7_"+rowNum).style.display="none";
		    $G("div7_1_"+rowNum).style.display="none";
		    $G("div7_2_"+rowNum).style.display="none";
		}
		if(itemFieldType==3){
			$G("div1_"+rowNum).style.display='none';
			$G("div1_1_"+rowNum).style.display='none';
			$G("div1_3_"+rowNum).style.display='none';
			$G("div2_"+rowNum).style.display='none';
			$G("div3_"+rowNum).style.display='inline';
			$G("div3_0_"+rowNum).style.display='none';
			$G("div3_1_"+rowNum).style.display='none';
			$G("div3_2_"+rowNum).style.display='none';
			$G("div3_4_"+rowNum).style.display='none';
			if(broswerType=="226"||broswerType=="227"){
				$G("div3_5_"+rowNum).style.display='inline';
			}else{
				$G("div3_5_"+rowNum).style.display='none';	
			}
			

			$G("div5_"+rowNum).style.display='none';
			$G("div5_5_"+rowNum).style.display='none';
            $G("div6_"+rowNum).style.display="none";
		    $G("div6_1_"+rowNum).style.display="none";
		    $G("div7_"+rowNum).style.display="none";
		    $G("div7_1_"+rowNum).style.display="none";
		    $G("div7_2_"+rowNum).style.display="none";
		}
		if(itemFieldType==4){
			$G("div1_"+rowNum).style.display='none';
			$G("div1_1_"+rowNum).style.display='none';
			$G("div1_3_"+rowNum).style.display='none';
			$G("div2_"+rowNum).style.display='none';
			$G("div3_"+rowNum).style.display='none';
			$G("div3_0_"+rowNum).style.display='none';
			$G("div3_1_"+rowNum).style.display='none';
			$G("div3_2_"+rowNum).style.display='none';
			$G("div3_4_"+rowNum).style.display='none';
			$G("div3_5_"+rowNum).style.display='none';
			$G("div5_"+rowNum).style.display='none';
			$G("div5_5_"+rowNum).style.display='none';
            $G("div6_"+rowNum).style.display="none";
		    $G("div6_1_"+rowNum).style.display="none";
		    $G("div7_"+rowNum).style.display="none";
		    $G("div7_1_"+rowNum).style.display="none";
		    $G("div7_2_"+rowNum).style.display="none";
		}
        if(itemFieldType==5){
			$G("div1_"+rowNum).style.display='none';
			$G("div1_1_"+rowNum).style.display='none';
			$G("div1_3_"+rowNum).style.display='none';
			$G("div2_"+rowNum).style.display='none';
			$G("div3_"+rowNum).style.display='none';
			$G("div3_0_"+rowNum).style.display='none';
			$G("div3_1_"+rowNum).style.display='none';
			$G("div3_2_"+rowNum).style.display='none';
			$G("div3_4_"+rowNum).style.display='none';
			$G("div3_5_"+rowNum).style.display='none';
			$G("div5_"+rowNum).style.display='inline';
			$G("div5_5_"+rowNum).style.display='inline';
            $G("div6_"+rowNum).style.display="none";
		    $G("div6_1_"+rowNum).style.display="none";
		    $G("div7_"+rowNum).style.display="none";
		    $G("div7_1_"+rowNum).style.display="none";
		    $G("div7_2_"+rowNum).style.display="none";
		}
        if(itemFieldType==6){
            $G("strlength_"+rowNum).value='5';
            $G("imgwidth_"+rowNum).value='100';
            $G("imgheight_"+rowNum).value='100';
			$G("div1_"+rowNum).style.display='none';
			$G("div1_1_"+rowNum).style.display='none';
			$G("div1_3_"+rowNum).style.display='none';
			$G("div2_"+rowNum).style.display='none';
			$G("div3_"+rowNum).style.display='none';
			$G("div3_0_"+rowNum).style.display='none';
			$G("div3_1_"+rowNum).style.display='none';
			$G("div3_2_"+rowNum).style.display='none';
			$G("div3_4_"+rowNum).style.display='none';
			$G("div3_5_"+rowNum).style.display='none';
			$G("div5_"+rowNum).style.display='none';
			$G("div5_5_"+rowNum).style.display='none';
            $G("div6_"+rowNum).style.display="inline";
		    $G("div6_1_"+rowNum).style.display="none";
		    $G("div7_"+rowNum).style.display="none";
		    $G("div7_1_"+rowNum).style.display="none";
		    $G("div7_2_"+rowNum).style.display="none";
            $G("uploadtype_"+rowNum).options[0].selected=true;
		}
        if(itemFieldType==7){
			$G("div1_"+rowNum).style.display='none';
			$G("div1_1_"+rowNum).style.display='none';
			$G("div1_3_"+rowNum).style.display='none';
			$G("div2_"+rowNum).style.display='none';
			$G("div3_"+rowNum).style.display='none';
			$G("div3_0_"+rowNum).style.display='none';
			$G("div3_1_"+rowNum).style.display='none';
			$G("div3_2_"+rowNum).style.display='none';
			$G("div3_4_"+rowNum).style.display='none';
			$G("div3_5_"+rowNum).style.display='none';
			$G("div5_"+rowNum).style.display='none';
			$G("div5_5_"+rowNum).style.display='none';
            $G("div6_"+rowNum).style.display="none";
		    $G("div6_1_"+rowNum).style.display="none";
		    $G("div7_"+rowNum).style.display="inline";
		    $G("div7_1_"+rowNum).style.display="";
		    $G("div7_2_"+rowNum).style.display="none";
            $G("specialfield_"+rowNum).options[0].selected=true;
		}	
}
function onuploadtype(obj,index) {
    if (obj.value == 1) {
        $G("div6_1_" + index).style.display = "none";
    } else {
        $G("div6_1_" + index).style.display = "";
    }
}


//zzl
function OnNewChangeSapBroswerType(tempindex)
{
	//broswerType_4
	var updateTableName="";//得到主表名字
	var browsertype=$G("broswerType_"+tempindex).value;
	var mark=$G("showinner_"+tempindex).innerHTML;
	var showinner=$G("showinner_"+tempindex);
	var showimg=$G("showimg_"+tempindex);
	var showvalue=$G("showvalue_"+tempindex);
	var left = Math.ceil((screen.width - 1086) / 2);   //实现居中
    var top = Math.ceil((screen.height - 600) / 2);  //实现居中
    var tempstatus = "dialogWidth:1086px;dialogHeight:600px;scroll:yes;status:no;dialogLeft:"+left+";dialogTop:"+top+";";
    var urls = "/integration/browse/integrationBrowerMain.jsp?browsertype="+browsertype+"&mark="+mark+"&formid=<%=formid%>&updateTableName="+updateTableName;
	var temp=window.showModalDialog(urls,"",tempstatus);

	if(temp)
	{
		showvalue.value=temp;
		showinner.innerHTML=temp;
		showimg.innerHTML="";
	}
	//else
	//{
		//showvalue.value="";
		//showinner.innerHTML="";
		//showimg.innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";
	//}
	//showimg.style.display='';
}

//zzl
function OnNewChangeSapBroswerTypeDetails(detailtables,detailrowindex)
{
	 var updateTableName="";
	 try
	 {
	    updateTableName=$G("detailTable_name_"+detailtables).value;//得到明细表的名字
	 }catch(e)
	 {
	 	updateTableName="$_$";
	 }
	var mark=$G("showinner_"+detailtables+"_"+detailrowindex).innerHTML;
	var browsertype=$G("broswerType_"+detailtables+"_"+detailrowindex).value;
	var showinner=$G("showinner_"+detailtables+"_"+detailrowindex);
	var showimg=$G("showimg_"+detailtables+"_"+detailrowindex);
	var showvalue=$G("showvalue_"+detailtables+"_"+detailrowindex);
	var left = Math.ceil((screen.width - 1086) / 2);   //实现居中
    var top = Math.ceil((screen.height - 600) / 2);  //实现居中
    var tempstatus = "dialogWidth:1086px;dialogHeight:600px;scroll:yes;status:no;dialogLeft:"+left+";dialogTop:"+top+";";
    var urls = "/integration/browse/integrationBrowerMain.jsp?browsertype="+browsertype+"&mark="+mark+"&formid=<%=formid%>&updateTableName="+updateTableName;
	var temp=window.showModalDialog(urls,"",tempstatus);
	if(temp)
	{
		showvalue.value=temp;
		showinner.innerHTML=temp;
		showimg.innerHTML="";
	}
	//else
	//{
		//alert("s");
		//showvalue.value="";
		//showinner.innerHTML="";
		//showimg.innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";
	//}
	//showimg.style.display='';
}
	
	
function specialtype(obj,index){
    if(obj.value==1){
        $G("div7_1_"+index).style.display="";
	    $G("div7_2_"+index).style.display="none";
    }else{
        $G("div7_1_"+index).style.display="none";
	    $G("div7_2_"+index).style.display="";
    }
}
function onChangBroswerType(index){
	broswerType = $G("broswerType_"+index).value;
	if(broswerType==161||broswerType==162){
		//$G("div3_0_"+index).style.display='inline';
		$G("div3_1_"+index).style.display='inline';
		$G("div3_4_"+index).style.display='none';
		var defineBrowserOptionValue = $G("definebroswerType_"+index).value;
		if(defineBrowserOptionValue==''||defineBrowserOptionValue==0){
		    $G("div3_0_"+index).style.display="inline"
		}else{
		    $G("div3_0_"+index).style.display="none"
		}
	}else if(broswerType==224||broswerType==225){
		$G("div3_1_"+index).style.display='none';
		$G("div3_4_"+index).style.display='inline';
		$G("div3_5_"+index).style.display='none';
		var sapbrowserOptionValue = $G("sapbrowser_"+index).value;
		if(sapbrowserOptionValue==''||sapbrowserOptionValue==0){
		    $G("div3_0_"+index).style.display="inline"
		}else{
		    $G("div3_0_"+index).style.display="none"
		}
	}else if(broswerType==226||broswerType==227){
		//zzl
		$G("div3_1_"+index).style.display='none';
		$G("div3_4_"+index).style.display='none';
		$G("div3_5_"+index).style.display='inline';
		var sapbrowserOptionValue = $G("showvalue_"+index).value;
		if(sapbrowserOptionValue==''){
		    $G("showimg_"+index).style.display="inline"
		}else{
		    $G("showimg_"+index).style.display="none"
		}
	}
	
	else{
		$G("div3_0_"+index).style.display='none';
		$G("div3_1_"+index).style.display='none';
		$G("div3_4_"+index).style.display='none';
		//zzl
		$G("div3_5_"+index).style.display='none';
	}
	if(broswerType==165||broswerType==166||broswerType==167||broswerType==168){
		$G("div3_2_"+index).style.display='inline';
	}else{
		$G("div3_2_"+index).style.display='none';
	}
}
function div3_0_show(index){
	div3_1_value = $G("definebroswerType_"+index).value;
	if(div3_1_value=="")
		$G("div3_0_"+index).style.display='inline';
	else
		$G("div3_0_"+index).style.display='none';
}
function div3_4_show(index){
	div3_4_value = $G("sapbrowser_"+index).value;
	if(div3_4_value=="")
		$G("div3_0_"+index).style.display='inline';
	else
		$G("div3_0_"+index).style.display='none';
}

//主表选择框字段删除选项
function submitClear(index){
  setChange(index);
  var flag = false;
	var ids = document.getElementsByName('chkField');
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
        if(isdel()){
		    deleteRow1(index);
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}

//主表选择框字段删除选项
function deleteRow1(index){
	var objTbl = $G("choiceTable_"+index);
	var objChecks=objTbl.getElementsByTagName("INPUT");	
	
	for(var i=objChecks.length-1;i>=0;i--){
		if(objChecks[i].name=="chkField" && objChecks[i].checked) {
			objTbl.deleteRow(objChecks[i].parentElement.parentElement.parentElement.rowIndex);
		}
	}
}

//主表字段 选择框 添加选项
function addoTableRow(index){
  setChange(index);
  rowColor1 = getRowBg();
  obj1 = $G("choiceTable_"+index);
  choicerowindex =$G("choiceRows_"+index).value*1+1;
  $G("choiceRows_"+index).value = choicerowindex;
	ncol1 = obj1.rows[0].cells.length;
	oRow1 = obj1.insertRow(-1);
	for(j=0; j<ncol1; j++) {
		oCell1 = oRow1.insertCell(j);
		switch(j) {
			case 0:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<input   type='checkbox' name='chkField' index='"+choicerowindex+"' value='0'>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 1:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<input class='InputStyle' type='text' size='10' name='field_"+index+"_"+choicerowindex+"_name' style='width=90%'"+
							" onchange=\"checkinput('field_"+index+"_"+choicerowindex+"_name','field_"+index+"_"+choicerowindex+"_span'),setChange("+index+")\">"+
							" <span id='field_"+index+"_"+choicerowindex+"_span'><IMG src='/images/BacoError.gif' align=absMiddle></span>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 2:
				var oDiv1 = document.createElement("div");
				var sHtml1 = " <input class='InputStyle' type='text' size='4' value = '0.00' onchange='setChange("+index+")' name='field_count_"+index+"_"+choicerowindex+"_name' style='width=90%'"+
							" onKeyPress=ItemNum_KeyPress('field_count_"+index+"_"+choicerowindex+"_name') onchange=checknumber('field_count_"+index+"_"+choicerowindex+"_name')>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 3:
				var oDiv1 = document.createElement("div");
				var sHtml1 = " <input type='checkbox' name='field_checked_"+index+"_"+choicerowindex+"_name' onchange='setChange("+index+")' onclick='if(this.checked){this.value=1;}else{this.value=0}'>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 4:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<input type='checkbox' name='isAccordToSubCom"+index+"_"+choicerowindex+"' value='1' ><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;"
							+ "<button type='button' class=Browser onClick=\"onShowCatalog(mypath_"+index+"_"+choicerowindex+","+index+","+choicerowindex+")\" name=selectCategory></BUTTON>"
							+ "<span id=mypath_"+index+"_"+choicerowindex+"></span>"
						    + "<input type=hidden id='pathcategory_" + index + "_"+choicerowindex+"' name='pathcategory_" + index + "_"+choicerowindex+"' value=''>"
						    + "<input type=hidden id='maincategory_" + index + "_"+choicerowindex+"' name='maincategory_" + index + "_"+choicerowindex+"' value=''>";

				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 5:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<button type='button' class=\"Browser\" onClick=\"onShowChildSelectItem(childItemSpan_"+index+"_"+choicerowindex+",childItem_"+index+"_"+choicerowindex+",'_"+index+"')\" id=\"selectChildItem_"+index+"_"+choicerowindex+"\" name=\"selectChildItem_"+index+"_"+choicerowindex+"\"></BUTTON>"
							+ "<input type=\"hidden\" id=\"childItem_"+index+"_"+choicerowindex+"\" name=\"childItem_"+index+"_"+choicerowindex+"\" value=\"\" >"
							+ "<span id=\"childItemSpan_"+index+"_"+choicerowindex+"\" name=\"childItemSpan_"+index+"_"+choicerowindex+"\"></span>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
		}		
	}
}
function onShowCatalog(spanName, index, choicerowindex){
	var isAccordToSubCom=0;
	if($G("isAccordToSubCom"+index+"_"+choicerowindex)!=null){
		if($G("isAccordToSubCom"+index+"_"+choicerowindex).checked){
			isAccordToSubCom=1;
		}
	}
	if(isAccordToSubCom==1){
		onShowCatalogSubCom(spanName, index, choicerowindex);
	}else{
		onShowCatalogHis(spanName, index, choicerowindex);
	}
}
function onShowCatalogHis(spanName, index, choicerowindex) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp");
    if (result != null){
        if (wuiUtil.getJsonValueByIndex(result,0)> 0){
        		setChange(index);
            spanName.innerHTML=wuiUtil.getJsonValueByIndex(result,2);
            $G("pathcategory_"+index+"_"+choicerowindex).value=wuiUtil.getJsonValueByIndex(result,2);
            $G("maincategory_"+index+"_"+choicerowindex).value=wuiUtil.getJsonValueByIndex(result,3)+","+wuiUtil.getJsonValueByIndex(result,4)+","+wuiUtil.getJsonValueByIndex(result,1);
        }else{
            spanName.innerHTML="";
            $G("pathcategory_"+index+"_"+choicerowindex).value="";
            $G("maincategory_"+index+"_"+choicerowindex).value="";
       }
    }
}
function onShowCatalogSubCom(spanName, index, choicerowindex) {
	if($G("selectvalue"+index+"_"+choicerowindex)==null){
		alert("<%=SystemEnv.getHtmlLabelName(24460,user.getLanguage())%>");
		return;
	}

	var fieldid = $G("modifyflag_"+index).value;
	var selectvalue=$G("selectvalue"+index+"_"+choicerowindex).value;
	url =escape("/workflow/field/SubcompanyDocCategoryBrowser.jsp?fieldId="+fieldid+"&isBill=1&selectValue="+selectvalue)
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
}


function check_formself(thiswins, items){
	if(items == ""){
		return true;
	}
	var itemlist = items.split(",");
	for(var i=0;i<itemlist.length;i++){
		if($G(itemlist[i])){
			var tmpname = $G(itemlist[i]).name;
			var tmpvalue = $G(itemlist[i]).value;
			if(tmpvalue==null){
				continue;
			}
			while(tmpvalue.indexOf(" ") >= 0){
				tmpvalue = tmpvalue.replace(" ", "");
			}
			while(tmpvalue.indexOf("\r\n") >= 0){
				tmpvalue = tmpvalue.replace("\r\n", "");
			}

			if(tmpvalue == ""){
				if($G(itemlist[i]).getAttribute("temptitle")!=null){
					alert("\""+$G(itemlist[i]).getAttribute("temptitle")+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
					return false;
				}else{
					alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>！");
					return false;
				}
			}
		}
	}
	return true;
}


var dbfieldnames = "<%=dbfieldnamesForCompare%>";
function onSave(obj){
	changeRows = 0;
	var changeRowIndexsArray;
	if(changeRowIndexs!=","){
		changeRowIndexsArray = changeRowIndexs.substring(1,changeRowIndexs.length-1).split(",");
		changeRows = changeRowIndexsArray.length;
	}
	var itemDspNames = ",";
	for(i=0;i<changeRows;i++){//主字段检查
			j=changeRowIndexsArray[i];
			if(j.indexOf("detail") == 0){
				j = j.substring(6, j.length);
			}
			check_String = "itemDspName_"+j+",itemFieldName_"+j;
			if(check_formself(frmMain,check_String)){
				if($G("documentType_"+j).value==1&&$G("itemFieldType_"+j).value==1){
					if($G("itemFieldScale1_"+j).value==""){//单行文本框的文本长度必填
						alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				if($G("itemFieldType_"+j).value==3&&($G("broswerType_"+j).value==161||$G("broswerType_"+j).value==162)){
					if($G("definebroswerType_"+j).value==""){//自定义浏览框必选
						alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				if(document.all("itemFieldType_"+j).value==3&&(document.all("broswerType_"+j).value==224||document.all("broswerType_"+j).value==225)){
					if(document.all("sapbrowser_"+j).value==""){//自定义浏览框必选
						alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				//zzl
				if(document.all("itemFieldType_"+j).value==3&&(document.all("broswerType_"+j).value==226||document.all("broswerType_"+j).value==227)){
					if(document.all("showvalue_"+j).value==""){//集成浏览按钮
						alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				
				if($G("itemFieldType_"+j).value==5){//选择框可选项文字check
					var choiceRows = $G("choiceRows_"+j).value * 1;
					for(var tempchoiceRows=1;tempchoiceRows<=choiceRows;tempchoiceRows++){
						//选择框的可选项文字必填
						if($G("field_"+j+"_"+tempchoiceRows+"_name")&&$G("field_"+j+"_"+tempchoiceRows+"_name").value==""){
							alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
							return;
						}
					}
				}
				var itemDspName = $G("itemDspName_"+j).value;
				if(itemDspName=="id"||itemDspName=="requestId"){
					alert(itemDspName+"<%=SystemEnv.getHtmlLabelName(21810,user.getLanguage())%>");
					$G("itemDspName_"+j).select();
					return;
				}
				if(dbfieldnames.indexOf(","+itemDspName.toUpperCase()+",")>=0||itemDspNames.indexOf(","+itemDspName.toUpperCase()+",")>=0){//数据库字段名称不能重复
					alert("<%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())%>");
					$G("itemDspName_"+j).select();
					return;
				}else{itemDspNames += itemDspName.toUpperCase()+",";}
			}else{
				return;
			}
	}
	var detailTableNums = $G("detailtables").value;
	var detailtableIndexs = $G("detailtableIndexs").value;
	var detailtableIndexsArray;
	if(detailtableIndexs!=",")
		detailtableIndexsArray = detailtableIndexs.substring(0,detailtableIndexs.length-1).split(",");
	for(var tempi=1;tempi<=detailTableNums;tempi++){//明细字段检查
		var i = detailtableIndexsArray[tempi];
		var detailTableChangeRows = 0;
		var detailTableChangeRowsArray;
		var detailChangeRowIndexs = $G("detailChangeRowIndexs_"+i).value;
		if(detailChangeRowIndexs!=""){
			detailTableChangeRowsArray = detailChangeRowIndexs.substring(0,detailChangeRowIndexs.length-1).split(",");
			detailTableChangeRows = detailTableChangeRowsArray.length;
		}
		
		var dbfieldnames_detail = "";
		if($G("dbdetailfieldnamesForCompare_"+i))
			dbfieldnames_detail = $G("dbdetailfieldnamesForCompare_"+i).value;
		
		var itemDspNamesDetail = ",";
		for(var j=0;j<detailTableChangeRows;j++){
			var tIndex = detailTableChangeRowsArray[j];
			check_String = "itemDspName_detail"+i+"_"+tIndex+",itemFieldName_detail"+i+"_"+tIndex;
			if(check_formself(frmMain,check_String)){
				if($G("documentType_"+i+"_"+tIndex).value==1&&$G("itemFieldType_"+i+"_"+tIndex).value==1){//单行文本框的文本长度必填
					if($G("itemFieldScale1_"+i+"_"+tIndex).value==""){
						alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				if($G("itemFieldType_"+i+"_"+tIndex).value==3&&($G("broswerType_"+i+"_"+tIndex).value==161||$G("broswerType_"+i+"_"+tIndex).value==162)){
					if($G("definebroswerType_"+i+"_"+tIndex).value==""){//自定义浏览框必选
						alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				if(document.all("itemFieldType_"+i+"_"+tIndex).value==3&&(document.all("broswerType_"+i+"_"+tIndex).value==224||document.all("broswerType_"+i+"_"+tIndex).value==225)){
					if(document.all("sapbrowser_"+i+"_"+tIndex).value==""){//自定义浏览框必选
						alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				
				//zzl
				if(document.all("itemFieldType_"+i+"_"+tIndex).value==3&&(document.all("broswerType_"+i+"_"+tIndex).value==226||document.all("broswerType_"+i+"_"+tIndex).value==227)){
					if(document.all("showvalue_"+i+"_"+tIndex).value==""){//集成浏览按钮
						alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				if($G("itemFieldType_"+i+"_"+tIndex).value==5){//选择框可选项文字check
					var choiceRows = $G("choiceRows_"+i+"_"+tIndex).value * 1;
					for(var tempchoiceRows=1;tempchoiceRows<=choiceRows;tempchoiceRows++){
						if($G("field_"+i+"_"+tIndex+"_"+tempchoiceRows+"_name")&&$G("field_"+i+"_"+tIndex+"_"+tempchoiceRows+"_name").value==""){//选择框的可选项文字必填
							alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
							return;
						}
					}
				}
				var itemDspNameDetail = $G("itemDspName_detail"+i+"_"+tIndex).value;
				if(itemDspNameDetail=="id"||itemDspNameDetail=="mainid"){
					alert(itemDspNameDetail+"<%=SystemEnv.getHtmlLabelName(21810,user.getLanguage())%>");
					$G("itemDspName_detail"+i+"_"+tIndex).select();
					return;
				}
				if(dbfieldnames_detail.indexOf(","+itemDspNameDetail.toUpperCase()+",")>=0||itemDspNamesDetail.indexOf(","+itemDspNameDetail.toUpperCase()+",")>=0){//数据库字段名称不能重复
					alert("<%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())%>");
					$G("itemDspName_detail"+i+"_"+tIndex).select();
					return;
				}else{itemDspNamesDetail += ","+itemDspNameDetail.toUpperCase()+",";}

			}else{
				return;
			}
		}
	}
	
	//主字段中的选择框转换
	for(i=0;i<changeRows;i++){
		j=changeRowIndexsArray[i];
		if(j.indexOf("detail") == 0){
			j = j.substring(6, j.length);
		}
		
		//只对选择框进行处理
		if($G("itemFieldType_"+j).value == 5){
			var choiceRows = $G("choiceRows_"+j).value * 1;
			//遍历选择框的所有选项
			for(var tempchoiceRows=1; tempchoiceRows<=choiceRows; tempchoiceRows++){
				var optionObj = $G("field_"+j+"_"+tempchoiceRows+"_name");
				if(optionObj != null){
					optionObj.value = dealSpecial(optionObj.value);
				}
			}
		}
	}
	
	//对每个明细表中的选择框进行转换
	for(var tempi=1;tempi<=detailTableNums;tempi++){
		var i = detailtableIndexsArray[tempi];
		var detailTableChangeRows = 0;
		var detailTableChangeRowsArray;
		var detailChangeRowIndexs = $G("detailChangeRowIndexs_"+i).value;
		if(detailChangeRowIndexs!=""){
			detailTableChangeRowsArray = detailChangeRowIndexs.substring(0,detailChangeRowIndexs.length-1).split(",");
			detailTableChangeRows = detailTableChangeRowsArray.length;
		}
		
		//遍历单个明细表中的每个字段
		for(var j=0;j<detailTableChangeRows;j++){
			var tIndex = detailTableChangeRowsArray[j];
			if($G("itemFieldType_"+i+"_"+tIndex).value==5){
				var choiceRows = $G("choiceRows_"+i+"_"+tIndex).value * 1;
				for(var tempchoiceRows=1; tempchoiceRows<=choiceRows; tempchoiceRows++){
					var optionObj = $G("field_"+i+"_"+tIndex+"_"+tempchoiceRows+"_name");
					if(optionObj != null){
						optionObj.value = dealSpecial(optionObj.value);
					}
				}
			}
		}
	}

	obj.disabled=true;
	document.frmMain.recordNum.value=rowindex;
	document.frmMain.delids.value=delids;
	document.frmMain.changeRowIndexs.value=changeRowIndexs;	
	document.frmMain.submit();
	enableAllmenu();
}

//对特殊符号进行处理
function dealSpecial(val){
	//本字符串是欧元符号的unicode码, GBK编辑中不支持欧元符号(需更改为UTF-8), 故只能使用unicode码
	var euro = "\u20AC";
	//本字符串是欧元符号在HTML中的特别表现形式
	var symbol = "&euro;";
	var reg = new RegExp(euro);
	while(val.indexOf(euro) != -1){
		val = val.replace(reg, symbol);
	}  
	return val;
}

	function checkKey(obj){
		var keys=",PERCENT,PLAN,PRECISION,PRIMARY,PRINT,PROC,PROCEDURE,PUBLIC,RAISERROR,READ,READTEXT,RECONFIGURE,REFERENCES,REPLICATION,RESTORE,RESTRICT,RETURN,REVOKE,RIGHT,ROLLBACK,ROWCOUNT,ROWGUIDCOL,RULE,SAVE,SCHEMA,SELECT,SESSION_USER,SET,SETUSER,SHUTDOWN,SOME,STATISTICS,SYSTEM_USER,TABLE,TEXTSIZE,THEN,TO,TOP,TRAN,TRANSACTION,TRIGGER,TRUNCATE,TSEQUAL,UNION,UNIQUE,UPDATE,UPDATETEXT,USE,USER,VALUES,VARYING,VIEW,WAITFOR,WHEN,WHERE,WHILE,WITH,WRITETEXT,EXCEPT,EXEC,EXECUTE,EXISTS,EXIT,FETCH,FILE,FILLFACTOR,FOR,FOREIGN,FREETEXT,FREETEXTTABLE,FROM,FULL,FUNCTION,GOTO,GRANT,GROUP,HAVING,HOLDLOCK,IDENTITY,IDENTITY_INSERT,IDENTITYCOL,IF,IN,INDEX,INNER,INSERT,INTERSECT,INTO,IS,JOIN,KEY,KILL,LEFT,LIKE,LINENO,LOAD,NATIONAL,NOCHECK,NONCLUSTERED,NOT,NULL,NULLIF,OF,OFF,OFFSETS,ON,OPEN,OPENDATASOURCE,OPENQUERY,OPENROWSET,OPENXML,OPTION,OR,ORDER,OUTER,OVER,ADD,ALL,ALTER,AND,ANY,AS,ASC,AUTHORIZATION,BACKUP,BEGIN,BETWEEN,BREAK,BROWSE,BULK,BY,CASCADE,CASE,CHECK,CHECKPOINT,CLOSE,CLUSTERED,COALESCE,COLLATE,COLUMN,COMMIT,COMPUTE,CONSTRAINT,CONTAINS,CONTAINSTABLE,CONTINUE,CONVERT,CREATE,CROSS,CURRENT,CURRENT_DATE,CURRENT_TIME,CURRENT_TIMESTAMP,CURRENT_USER,CURSOR,DATABASE,DBCC,DEALLOCATE,DECLARE,DEFAULT,DELETE,DENY,DESC,DISK,DISTINCT,DISTRIBUTED,DOUBLE,DROP,DUMMY,DUMP,ELSE,END,ERRLVL,ESCAPE,";
		//以下for oracle.update by cyril on 2008-12-08 td:9722
		keys+="ACCESS,ADD,ALL,ALTER,AND,ANY,AS,ASC,AUDIT,BETWEEN,BY,CHAR,"; 
		keys+="CHECK,CLUSTER,COLUMN,COMMENT,COMPRESS,CONNECT,CREATE,CURRENT,";
		keys+="DATE,DECIMAL,DEFAULT,DELETE,DESC,DISTINCT,DROP,ELSE,EXCLUSIVE,";
		keys+="EXISTS,FILE,FLOAT,FOR,FROM,GRANT,GROUP,HAVING,IDENTIFIED,";
		keys+="IMMEDIATE,IN,INCREMENT,INDEX,INITIAL,INSERT,INTEGER,INTERSECT,";
		keys+="INTO,IS,LEVEL,LIKE,LOCK,LONG,MAXEXTENTS,MINUS,MLSLABEL,MODE,";
		keys+="MODIFY,NOAUDIT,NOCOMPRESS,NOT,NOWAIT,NULL,NUMBER,OF,OFFLINE,ON,";
		keys+="ONLINE,OPTION,OR,ORDER,PCTFREE,PRIOR,PRIVILEGES,PUBLIC,RAW,";
		keys+="RENAME,RESOURCE,REVOKE,ROW,ROWID,ROWNUM,ROWS,SELECT,SESSION,";
		keys+="SET,SHARE,SIZE,SMALLINT,START,SUCCESSFUL,SYNONYM,SYSDATE,TABLE,";
		keys+="THEN,TO,TRIGGER,UID,UNION,UNIQUE,UPDATE,USER,VALIDATE,VALUES,";
		keys+="VARCHAR,VARCHAR2,VIEW,WHENEVER,WHERE,WITH,";
		var fname=obj.value;
		if (fname!=""){
			fname=","+fname.toUpperCase()+",";
			if (keys.indexOf(fname)>0){
				alert('<%=SystemEnv.getHtmlLabelName(19946,user.getLanguage())%>');
				obj.focus();
				return false;
			}
		}
		return true;
	}
/*
p（精度）
指定小数点左边和右边可以存储的十进制数字的最大个数。精度必须是从 1 到最大精度之间的值。最大精度为 38。

s（小数位数）
指定小数点右边可以存储的十进制数字的最大个数。小数位数必须是从 0 到 p 之间的值。默认小数位数是 0，因而 0 <= s <= p。最大存储大小基于精度而变化。
*/
function checkDigit(elementName,p,s){
	tmpvalue = $G(elementName).value;

    var len = -1;
    if(elementName){
		len = tmpvalue.length;
    }

	var integerCount=0;
	var afterDotCount=0;
	var hasDot=false;

    var newIntValue="";
	var newDecValue="";
    for(i = 0; i < len; i++){
		if(tmpvalue.charAt(i) == "."){ 
			hasDot=true;
		}else{
			if(hasDot==false){
				integerCount++;
				if(integerCount<=p-s){
					newIntValue+=tmpvalue.charAt(i);
				}
			}else{
				afterDotCount++;
				if(afterDotCount<=s){
					newDecValue+=tmpvalue.charAt(i);
				}
			}
		}		
    }

    var newValue="";
	if(newDecValue==""){
		newValue=newIntValue;
	}else{
		newValue=newIntValue+"."+newDecValue;
	}
    $G(elementName).value=newValue;
}

function setChange(rowIndex){
	if(changeRowIndexs.indexOf(","+rowIndex+",")<0){
		changeRowIndexs+=rowIndex+",";
	}
	try{
	var olddbfieldname = document.all("olditemDspName_"+rowIndex).value.toUpperCase();
	dbfieldnames = dbfieldnames.replace(","+olddbfieldname+",",",");
	}catch(e){}
}

function checkItemFieldScale(oldObj,newObj,minValue,maxValue){
	oldValue=oldObj.value;
	newValue=newObj.value;

    try{
        oldValue=parseInt(oldValue);
        if(isNaN(oldValue)){
            oldValue=0;
        }
    }catch(e){
        oldValue=0;
    }

    try{
        newValue=parseInt(newValue);
        if(isNaN(newValue)){
            newValue=0;
        }
    }catch(e){
        newValue=0;
    }

	if(newValue<oldValue){
		alert("<%=SystemEnv.getHtmlLabelName(20881,user.getLanguage())%>");
		newObj.value=oldValue;
		return ;
	}
	if(newValue<minValue||newValue>maxValue){
		alert("<%=SystemEnv.getHtmlLabelName(20882,user.getLanguage())%>："+minValue+"-"+maxValue);
		newObj.value=oldValue;
		return ;
	}
}

function checkItemFieldScaleForAdd(newObj,minValue,maxValue,defaultValue){

	newValue=newObj.value;

    try{
        newValue=parseInt(newValue);
        if(isNaN(newValue)){
            newValue=0;
        }
    }catch(e){
        newValue=0;
    }

	if(newValue<minValue||newValue>maxValue){
		alert("<%=SystemEnv.getHtmlLabelName(20882,user.getLanguage())%>："+minValue+"-"+maxValue);
		newObj.value=defaultValue;
		return ;
	}
}


function onChangeChildField(childstr){
	var len = document.frmMain.elements.length;
	if(childstr.indexOf("_detail") == 0){
		childstr = "_"+childstr.substring(7, childstr.length);
	}
    for(i=len-1; i>=0; i--) {
        if(document.frmMain.elements[i].id.indexOf("childItem"+childstr) == 0){
			var inputObj = document.frmMain.elements[i];
			var idstr = document.frmMain.elements[i].id;
			idstr = idstr.substring(("childItem"+childstr).length, idstr.length);
			var spanid = "childItemSpan"+childstr+idstr;
			var spanObj = $G(spanid);
			try{
				inputObj.value = "";
				spanObj.innerHTML = "";
			}catch(e){}
    	}
	}
}
function setChangeChild(childstr){
	var index = getDetailTableIndex(childstr);
	var indexNum = getIndexNum(childstr);
	if(index == -1){
		setChange(indexNum);
	}else{
		setChangeDetail(index, indexNum);
	}
}
function getIndexNum(childstr){
	var indexNum = "";
	var s = childstr.substring(1, childstr.length);
	var index = s.indexOf("_");
	if(index > -1){
		indexNum = s.substring(index+1, s.length);
	}else{
		indexNum = s;
	}
	return indexNum;
}
function getDetailTableIndex(childstr){
	var index = "-1";
	var s = childstr.substring(1, childstr.length);
	var i = s.indexOf("_");
	if(i > -1){
		index = s.substring(6, i);
	}
	return index;
}
function getParentField(childstr){
	var pfieldidsql = "";
	try{
		if(childstr.indexOf("detail")>-1){
			childstr = "_"+childstr.substring(7, childstr.length);
		}
		var pfield = document.all("modifyflag"+childstr).value;
		pfieldidsql = " and id<>"+pfield+" ";
	}catch(e){}
	return pfieldidsql;
}
function getDetailTableName(childstr){
	var tablename = "";
	try{
		if(childstr.indexOf("detail")>-1){
			childstr = "_"+childstr.substring(7, childstr.lastIndexOf("_"));
			tablename = $G("detailTable_name"+childstr).value;
		}
	}catch(e){}
	return tablename;
}
function onShowChildField(spanname, inputname, childstr) {
    isdetail = "0";
    hasdetail=childstr.indexOf("detail");
    if (hasdetail > 0) {
        isdetail = "1";
    }

    pfieldidsql = getParentField(childstr);
    oldvalue = inputname.value;
    hasdetail=childstr.indexOf("detail");
    if (hasdetail > 0) {
        tablename = getDetailTableName(childstr);
        //将"&&" 更改为 (SQL语句中)查询条件的 "And" 
        pfieldidsql = pfieldidsql + " AND detailtable='" + tablename + "' ";
    }
	url = escape("/workflow/workflow/fieldBrowser.jsp?sqlwhere=where fieldhtmltype=5 and billid=<%=formid%>" + pfieldidsql + "&isdetail=" + isdetail + "&isbill=1");
    id = showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url);
    if (id) {
        if (wuiUtil.getJsonValueByIndex(id,0)!= "") {
            inputname.value =wuiUtil.getJsonValueByIndex(id,0);
            spanname.innerHTML =wuiUtil.getJsonValueByIndex(id,1);
        } else {
            inputname.value = "";
            spanname.innerHTML = "";
        }
    }
    if (oldvalue != inputname.value) {
        onChangeChildField(childstr);
        setChangeChild(childstr);
    }
}

function onShowChildSelectItem(spanname, inputname, childidstr) {

    cfid = $G("childfieldid" + childidstr).value;
    oldids = inputname.value;
    //url = escape("/workflow/field/SelectItemBrowser.jsp?isbill=1+isdetail=1+childfieldid=" + cfid + "+resourceids=" + oldids);
    url = escape("/workflow/field/SelectItemBrowser.jsp?isbill=1&isdetail=1&childfieldid=" + cfid + "&resourceids=" + oldids);
    id = showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url);
    if (id) {
        if (wuiUtil.getJsonValueByIndex(id,0)!= "") {
            resourceids =wuiUtil.getJsonValueByIndex(id,0);
            resourcenames =wuiUtil.getJsonValueByIndex(id,1);
            //resourceids = Mid(resourceids, 2, len(resourceids));
            //resourcenames = Mid(resourcenames, 2, len(resourcenames));
            
            resourceids =resourceids.substr(1);
            resourcenames =resourcenames.substr(1);             
            
            inputname.value = resourceids;
            spanname.innerHTML = resourcenames;
        } else {
            inputname.value = "";
            spanname.innerHTML = "";
        }
        setChangeChild(childidstr);
    }
}

</script>

<script language="VBScript">
sub onShowChildField1(spanname, inputname, childstr)
	isdetail = "0"
	hasdetail = Instr(childstr, "detail")
	if hasdetail>0 then
		isdetail = "1"
	end if

	pfieldidsql = getParentField(childstr)
	oldvalue = inputname.value
	hasdetail = Instr(childstr, "detail")
	if hasdetail>0 then
		tablename = getDetailTableName(childstr)
		pfieldidsql = pfieldidsql&" and detailtable='"&tablename&"' "
	end if
	url=escape("/workflow/workflow/fieldBrowser.jsp?sqlwhere=where fieldhtmltype=5 and billid=<%=formid%>"+pfieldidsql+"&isdetail="+isdetail+"&isbill=1")
	id = showModalDialog("/systeminfo/BrowserMain.jsp?url="&url)
	if Not isempty(id) then
		if id(0) <> "" then
			inputname.value = id(0)
			spanname.innerHTML = id(1)
		else
			inputname.value = ""
			spanname.innerHTML = ""
		end if
	end if
	if oldvalue <> inputname.value then
		onChangeChildField childstr
		setChangeChild childstr
	end if
end sub

sub onShowChildSelectItem1(spanname, inputname, childidstr)

	cfid = document.all("childfieldid"+childidstr).value
	oldids = inputname.value
	url=escape("/workflow/field/SelectItemBrowser.jsp?isbill=1&isdetail=1&childfieldid="&cfid&"&resourceids="&oldids)
	id = showModalDialog("/systeminfo/BrowserMain.jsp?url="&url)
	if Not isempty(id) then
		if id(0) <> "" then
			resourceids = id(0)
			resourcenames = id(1)
			resourceids = Mid(resourceids, 2, len(resourceids))
			resourcenames = Mid(resourcenames, 2, len(resourcenames))
			inputname.value = resourceids
			spanname.innerHTML = resourcenames
		else
			inputname.value = ""
			spanname.innerHTML = ""
		end if
		setChangeChild childidstr
	end if
end sub

</script>
  





  