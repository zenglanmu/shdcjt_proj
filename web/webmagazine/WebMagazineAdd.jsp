<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WebMagazine:Main", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
Calendar today = Calendar.getInstance();
int currentyear = today.get(Calendar.YEAR) ;
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard.gif";
String titlename = "期刊";
String needfav ="1";
String needhelp ="";
String needcheck = "name";
String typeID = ""+Util.getIntValue(request.getParameter("typeID"),0);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",WebMagazineList.jsp?typeID="+typeID+",_self} " ;
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
			<FORM name="Magazine"  action="WebMagazineOperation.jsp" method="post">
			<TABLE class=ViewForm>			
			<input type="hidden" name="method" value="MagazineAdd">
			<input type="hidden" name="typeID" value="<%=typeID%>">
			<COLGROUP><COL width="10%"><COL width="90%">
			<TBODY>
			<tr> 
				<td>
					刊名
				</td>
				<td class=Field>
				<%
					String typeName = "";
					RecordSet.executeSql("select * from WebMagazineType where id = " + typeID);
					if (RecordSet.next()) 
					{
						typeName = Util.null2String(RecordSet.getString("name"));
					}
					out.print(typeName);
				%>
				</td>
			</tr>
			<TR style="height: 1px!important;">
				<TD class=Line colSpan=2></TD>
			</TR> 
			<tr> 
				<td>
					刊号
				</td>
				<td class=Field>
					<!--年份-->
					<select class=InputStyle  name = "releaseYear">
					<%
					for (int i = 2000 ; i <= currentyear+10 ; i++) {
					%>
					<option value=<%=i%> <%if (i == currentyear) {%> selected <%}%>><%=i%></option>
					<%}%>
					</select>
					年	
					<INPUT class="InputStyle" type="text" name="name" onchange='checkinput("name","NameSpan")'>
					<span id="NameSpan" name="NameSpan"><IMG src='/images/BacoError.gif' align=absMiddle></span>
				</td>
			</tr>
			<TR style="height: 1px!important;">
				<TD class=Line colSpan=2></TD>
			</TR> 
			<TR>
				<TD>
					刊首文章
				</TD>
				<TD class=Field>
					<BUTTON class=Browser type="button" onclick="onShowMDocs('HeadDoc','HeadDocSpan')"></BUTTON>  
					<input id="HeadDoc" name="HeadDoc" type="hidden">
					<SPAN ID="HeadDocSpan" name="HeadDocSpan"></SPAN>
				</TD>
			</TR>
			<TR style="height: 1px!important;">
				<TD class=Line colSpan=2></TD>
			</TR>			
			</TABLE>

			<div>
			<BUTTON Class=Btn type=button accessKey=A onclick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
			<BUTTON Class=Btn type=button accessKey=E onclick="if(isdel()){deleteRow1();}">
			<U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>
			</BUTTON>
			</div>
			<table Class=ListStyle cols=4 id="oTable" cellspacing="1"><COLGROUP>
					<COL width="5%">
				<COL width="35%">
				<COL width="30%">
				<COL width="30%">
			  <tr class=header> 
					<td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
					<td>组名</td>
					<td>是否显示组名</td>
					<td>文档</td>
			   </tr>
			   <TR class=Line style="height: 1px!important;"><TD style="padding: 0px!important;" colspan="4" ></TD></TR> 
			  </table>
			  <input type="hidden" name="totaldetail" value=0> 
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
</BODY>
</HTML>
<script language="JavaScript" src="/js/addRowBg.js" >   
</script>  
<script language="javascript">
var rowindex = 0;
var totalrows=0;
var needcheck = "<%=needcheck%>";
var rowColor="" ;
function addRow()
{
	ncol = oTable.rows.item(0).cells.length ;	
	oRow = oTable.insertRow(-1);
	//oRow.style.height=24;
	rowColor = getRowBg();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(j); 
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='"+rowindex+"'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			
			case 1: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
					sHtml = "<input class='InputStyle' type='text' name='node_"+rowindex+"_group' onBlur=checkinput('node_"+rowindex+"_group','node_"+rowindex+"_groupspan')><span id='node_"+rowindex+"_groupspan'>";
					sHtml += "<img src='/images/BacoError.gif' align=absmiddle>";
					sHtml+="</span>";
					needcheck += ","+"node_"+rowindex+"_group";
        			oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
					sHtml = "<input type='checkbox' name='node_"+rowindex+"_isview' value='1' checked>";
	        		oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
			case 3: 
				var oDiv = document.createElement("div"); 
				var sHtml = "";
					sHtml = "<BUTTON class=Browser type='button' onclick=onShowMDocs('node_"+rowindex+"_docs','node_"+rowindex+"_docsspan')></BUTTON>";
					sHtml += "<input id='node_"+rowindex+"_docs' name='node_"+rowindex+"_docs' type='hidden'>";
					sHtml += "<SPAN id='node_"+rowindex+"_docsspan' name='node_"+rowindex+"_docsspan'></SPAN>";
					oDiv.innerHTML = sHtml;   
					oCell.appendChild(oDiv);  
				break;
				
		}
	}
	rowindex = rowindex*1 +1;
	document.all.totaldetail.value=rowindex;
	totalrows = rowindex;
}


function deleteRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 2;
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
							needcheck = needcheck.replace(",node_"+tmprow+"_group","");
						if(j==3)
							needcheck = needcheck.replace(",node_"+tmprow+"_docs","");
				
				}
				oTable.deleteRow(rowsum1-1);	
			}
			rowsum1 -=1;
		}
	
	}	
}

function submitData()
{
	if (check_form(Magazine,needcheck))
		Magazine.submit();
}
function onShowMDocs(input,span){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			_displayTemplate:"#b{name}",
			_displaySelector:"",
			_required:"no",
			_displayText:"",
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;

	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="+$("#"+input).val(),"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	
	if (datas){
	if (datas.id!=""){
	ids = datas.id.split(",");
	names =datas.name.split(",");
	sHtml = "";
	for( var i=0;i<ids.length;i++){
	if(ids[i]!=""){
	sHtml = sHtml+"<a href=/docs/docs/DocDsp.jsp?id="+ids[i]+">"+names[i]+"</a>&nbsp";
	}
	}
	$("#"+span).html(sHtml);
	$("#"+input).val(datas.id);

	}else {
	$("#"+span).html("");
	$("#"+input).val("");
	}
	}
	}

</script>
