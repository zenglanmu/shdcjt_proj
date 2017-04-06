<%@page import="com.weaver.integration.util.IntegratedSapUtil"%>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.lang.*" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="java.text.DecimalFormat" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="browserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="SapBrowserComInfo" class="weaver.parseBrowser.SapBrowserComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
</head>
<%

	DecimalFormat decimalFormat=new DecimalFormat("0.00");//使用系统默认的格式

	String imagefilename = "/images/hdMaintenance.gif";
	String titlename = SystemEnv.getHtmlLabelName(17998,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
	
	String maintable = "";
	rs.executeSql("select tablename from workflow_bill where id="+formid);
	if(rs.next()) maintable = Util.null2String(rs.getString("tablename"));
		
	String dbnamesForCompare_main = ",";
	
	rs.executeSql("select fieldname from workflow_billfield where viewtype=0 and billid="+formid);
	while(rs.next()){
		dbnamesForCompare_main += rs.getString("fieldname").toUpperCase()+",";
	}
	int dsporder = 0;
	ArrayList dbnamesForCompare_Detail_Arrays = new ArrayList();
	ArrayList detailname_Arrays = new ArrayList();
	rs.executeSql("select tablename from Workflow_billdetailtable where billid="+formid+" order by orderid");
	while(rs.next()){
		String dbnamesForCompare_Detail = ",";
		String detailTableName = Util.null2String(rs.getString("tablename"));
		detailname_Arrays.add(detailTableName);
		rs1.executeSql("select fieldname from workflow_billfield where viewtype=1 and billid="+formid+" and detailtable='"+detailTableName+"'");
		while(rs1.next()){
			dbnamesForCompare_Detail += Util.null2String(rs1.getString("fieldname")).toUpperCase()+",";
		}
		dbnamesForCompare_Detail_Arrays.add(dbnamesForCompare_Detail);
		%>
		<input type="hidden" value="<%=dbnamesForCompare_Detail%>" name="<%=detailTableName%>">
		<%}	

String mainselect="FieldHtmlType.options[0]=new Option('"+SystemEnv.getHtmlLabelName(688,user.getLanguage())+"',1);"+"\n"+
		          "FieldHtmlType.options[1]=new Option('"+SystemEnv.getHtmlLabelName(689,user.getLanguage())+"',2);"+"\n"+
		          "FieldHtmlType.options[2]=new Option('"+SystemEnv.getHtmlLabelName(695,user.getLanguage())+"',3);"+"\n"+
		          "FieldHtmlType.options[3]=new Option('"+SystemEnv.getHtmlLabelName(691,user.getLanguage())+"',4);"+"\n"+
		          "FieldHtmlType.options[4]=new Option('"+SystemEnv.getHtmlLabelName(690,user.getLanguage())+"',5);"+"\n"+
		          "FieldHtmlType.options[5]=new Option('"+SystemEnv.getHtmlLabelName(17616,user.getLanguage())+"',6);"+"\n"+
		          "FieldHtmlType.options[6]=new Option('"+SystemEnv.getHtmlLabelName(21691,user.getLanguage())+"',7);"+"\n";

String detailselect="FieldHtmlType.options[0]=new Option('"+SystemEnv.getHtmlLabelName(688,user.getLanguage())+"',1);"+"\n"+
		            "FieldHtmlType.options[1]=new Option('"+SystemEnv.getHtmlLabelName(689,user.getLanguage())+"',2);"+"\n"+
		            "FieldHtmlType.options[2]=new Option('"+SystemEnv.getHtmlLabelName(695,user.getLanguage())+"',3);"+"\n"+
		            "FieldHtmlType.options[3]=new Option('"+SystemEnv.getHtmlLabelName(691,user.getLanguage())+"',4);"+"\n"+
		            "FieldHtmlType.options[4]=new Option('"+SystemEnv.getHtmlLabelName(690,user.getLanguage())+"',5);"+"\n";
		            
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:history.back(-1),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form name="form1" method="post" action="/workflow/form/form_operation.jsp" >
	<input type="hidden" value="addFieldSingle" name="src">
	<input type="hidden" value="<%=formid%>" name="formid">
	<input type="hidden" value="<%=dbnamesForCompare_main%>" name="<%=maintable%>">
	<input type="hidden" value="0" name="choiceRows_rows">

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
							<table class="viewform">
						   <COL width="5%">
						   <COL width="30%">
						   <COL width="35%">
						   <COL width="30%"> 
								<TR class="Title"><TH colSpan=6><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH></TR>
								<TR class=Spacing style="height: 1px"><TD class="Line1" colSpan=4></TD></TR>
								<tr>
    							<td><%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
    							<td colspan=3 class=field>
    								<input class=Inputstyle type="text" name="fieldname" size="40" maxlength="30" value=""	onBlur='checkinput_char_num("fieldname");checkinput("fieldname","fieldnamespan")'>
    								<span id=fieldnamespan><IMG src="/images/BacoError.gif" align=absMiddle></span><br><span class=fontred><%=SystemEnv.getHtmlLabelName(15441,user.getLanguage())%>,<%=SystemEnv.getHtmlLabelName(19881,user.getLanguage())%>."id,requestId"(<%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%>),"id,mainid"(<%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%>)<%=SystemEnv.getHtmlLabelName(21810,user.getLanguage())%></span>
    							</td>
    						</tr>
								<TR class=Spacing style="height: 1px"><TD class="Line" colSpan=4></TD></TR>
								<tr>
    							<td><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></td>
    							<td colspan=3 class=field>
    								<input class=Inputstyle type="text" name="fieldlabelname" size="40" maxlength="30" value=""	onBlur='checkinput_char_num("fieldname");checkinput("fieldlabelname","fieldlabelnamespan")'>
    								<span id=fieldlabelnamespan><IMG src="/images/BacoError.gif" align=absMiddle></span>
    							</td>
    						</tr>
    						<TR class=Spacing style="height: 1px"><TD class="Line" colSpan=4></TD></TR>
    						
								<tr>
    							<td><%=SystemEnv.getHtmlLabelName(17997	,user.getLanguage())%></td>
    							<td colspan=3 class=field>
    								<select id="updateTableName" name="updateTableName" onchange="OnChangeUpdateTableName(this)">
    									<option value="<%=maintable%>"><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></option>
    									<%
    									for(int i=0;i<detailname_Arrays.size();i++){
    									%>
    									<option value="<%=detailname_Arrays.get(i)%>"><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=i+1%></option>
    									<%}%>
    								</select>
    							</td>
    						</tr>
    						<TR class=Spacing style="height: 1px"><TD class="Line" colSpan=4></TD></TR>
    						
								<tr>
    							<td valign=top><%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%></td>
    							<td class=field>
									  <select class='InputStyle' id="FieldHtmlType" name="FieldHtmlType" onchange="OnChangeFieldHtmlType()">
									  	<option value='1' ><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%></option>
									  	<option value='2' ><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%></option>
									  	<option value='3' ><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></option>
									  	<option value='4' ><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%></option>
									  	<option value='5' ><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></option>
									  	<option value='6' ><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%></option>
									    <option value='7' ><%=SystemEnv.getHtmlLabelName(21691,user.getLanguage())%></option>
									  </select>
									  
									  <div id="div1" style="display:inline">
									  	<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
										  <select class='InputStyle' id="DocumentType" name="DocumentType" onchange="OnChangeDocumentType()">
										  	<option value='1' ><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
										  	<option value='2' ><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
										  	<option value='3' ><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
												<option value='4' ><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%></option>
												<option value='5' ><%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%></option>
											</select>
										</div>
										<div id="div1_1" style="display:inline">
											<%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>
											<input class='InputStyle' type='text' size=3 maxlength=3 value='' id='itemFieldScale1' name='itemFieldScale1' onKeyPress='ItemPlusCount_KeyPress()' onblur="checkPlusnumber1(this),checklength('itemFieldScale1','itemFieldScale1span');checkcount1(itemFieldScale1)" style='text-align:right;padding-right:2px;'>
											<span id=itemFieldScale1span><IMG src='/images/BacoError.gif' align=absMiddle></span>
										</div>
										<div id="div1_3" style="display:none">
											<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
											<select id="decimaldigits" name="decimaldigits">
												<option value="1" >1</option>
												<option value="2" selected>2</option>
												<option value="3" >3</option>
												<option value="4" >4</option>
											</select>
										</div>
										<div id="div2" style="display:none">
									  	<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>
									  	<input class='InputStyle' type='text' size=4 maxlength=2 value='4' id='textheight' name='textheight' onKeyPress='ItemPlusCount_KeyPress()' onblur='checkPlusnumber1(this),checkcount1(textheight)' style='text-align:right;'>
									  	<%=SystemEnv.getHtmlLabelName(222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15449,user.getLanguage())%>
									  	<input type='checkbox' id="htmledit" name="htmledit" onclick="onfirmhtml()" value="1">
									  </div>
									  <div id="div3" style="display:none">
									  	<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
									  	<select class='InputStyle' id="browsertype" name="browsertype" onchange="OnChangeBrowserType()">
									  		<%
									  			String IsOpetype=IntegratedSapUtil.getIsOpenEcology70Sap();
									  			while(browserComInfo.next()){%>
									  			<%
									  				if(browserComInfo.getBrowserurl().equals("")){
									  					 continue;
									  				 }
									  				 if("1".equals(IsOpetype)&&("224".equals(browserComInfo.getBrowserid()))||"225".equals(browserComInfo.getBrowserid())){
									  				 		continue;
									  				 }
									  				 
									  				 if("0".equals(IsOpetype)&&("226".equals(browserComInfo.getBrowserid()))||"227".equals(browserComInfo.getBrowserid())){
									  				 		continue;
									  				 }
									  				 
									  			%>
									  			<option value="<%=browserComInfo.getBrowserid()%>"><%=SystemEnv.getHtmlLabelName(Util.getIntValue(browserComInfo.getBrowserlabelid(),0),user.getLanguage())%></option>
									  		<%}%>
									  	</select>
									  	<script type="text/javascript">
									  	  //browsertype 下拉框选项按照字母顺序排序
									  	  function sortRule(a,b) {
													var x = a._text;
													var y = b._text;
													return x.localeCompare(y);
												}
												function op(){
													var _value;
													var _text;
												}
										  function sortOption(){
													var obj = document.getElementById("browsertype");
													var tmp = new Array();
													for(var i=0;i<obj.options.length;i++){
														var ops = new op();
														ops._value = obj.options[i].value;
														ops._text = obj.options[i].text;
														tmp.push(ops);
													}
													tmp.sort(sortRule);
													for(var j=0;j<tmp.length;j++){
														obj.options[j].value = tmp[j]._value;
														obj.options[j].text = tmp[j]._text;
													}
										 }
										 sortOption();
									  	</script>
									  </div>
									  <div id="div3_4" style="display:none">
										 <select class=inputstyle  name=sapbrowser id=sapbrowser onchange="OnChangeSapBroswerType()">
										 <option value=""></option>
							    	     	<%
							                 List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
								             for(int j=0;j<AllBrowserId.size();j++){
							                %>
							                <option value=<%=AllBrowserId.get(j)%>><%=AllBrowserId.get(j)%></option>
							                 <%}%>
							    	     </select>
										</div>
										
										<div id="div3_5" style="display:none">
								    	     <button type="button" class="browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
								    	     <span id="showinner" name="showinner"></span>
								    	     <span id="showimg" name="showimg">
								    	     	<IMG src='/images/BacoError.gif' align=absMiddle>
								    	     </span>
								    	     <input id="showvalue" type="hidden" name="showvalue">
								  		</div>
								  		
								  		
									  <div id="div3_1" style="display:none">
									  	<span><IMG src='/images/BacoError.gif' align=absMiddle></span>
									  </div>
									  <div id="div3_2" style="display:none">
											<select class='InputStyle' name='definebroswerType' id='definebroswerType' onchange="OnChangeDefineBroswerType()">
											<%
											List l=StaticObj.getServiceIds(Browser.class);
				            	for(int j=0;j<l.size();j++){
				             	%>
				              	<option value="<%=l.get(j)%>"><%=l.get(j)%></option>
											<%}%>
											</select>
										</div>
										<div id="div3_3" style="display:none">
									  	<%=SystemEnv.getHtmlLabelName(19340,user.getLanguage())%>
									  	<select class='InputStyle' name='decentralizationbroswerType' id='decentralizationbroswerType'>
									  		<option value='1' ><%=SystemEnv.getHtmlLabelName(18916,user.getLanguage())%></option>
	                      <option value='2' ><%=SystemEnv.getHtmlLabelName(18919,user.getLanguage())%></option>
									  	</select>
								  	</div>
								  	
								  	<div id="div5" style="display:none">
									  	<BUTTON type='button' class=btn id=btnaddRow name=btnaddRow onclick='addoTableRow()'><%=SystemEnv.getHtmlLabelName(15443,user.getLanguage())%></BUTTON>
									  	<BUTTON type='button' class=btn id=btnsubmitClear name=btnsubmitClear onclick='submitClear()'><%=SystemEnv.getHtmlLabelName(15444,user.getLanguage())%></BUTTON>
				<span id="childfieldNotesSpan"><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
				<BUTTON type='button' id="showChildFieldBotton" class=Browser onClick="onShowChildField(childfieldidSpan, childfieldid)"></BUTTON>
				<span id="childfieldidSpan"></span>
				<input type="hidden" value="" name="childfieldid" id="childfieldid">
									  	<table class='ViewForm' id='choiceTable' cols=6 border=0>
									  		<col width=5%>
											<col width=25%>
											<col width=5%>
											<col width=5%>
											<col width=38%>
											<col width=22%>
									  		<tr>
									  			<td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
									  			<td><%=SystemEnv.getHtmlLabelName(15442,user.getLanguage())%></td>
									  			<td><%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%></td>
									  			<td><%=SystemEnv.getHtmlLabelName(19206,user.getLanguage())%></td>
									  			<td><%=SystemEnv.getHtmlLabelName(19207,user.getLanguage())%></td>
												<td><%=SystemEnv.getHtmlLabelName(22663,user.getLanguage())%></td>
									  		</tr>
									  	</table>
								  	</div>
                                    <DIV id="div6" style="display:none">
                                        <%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
                                        <select id=uploadtype name=uploadtype onchange=onuploadtype(this)>
                                          <OPTION value="1"><%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%></OPTION>
                                          <OPTION value="2"><%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%></OPTION>
                                        </select>
                                    </DIV>
                                    <div id="div6_1" style="display:none">
                                        <%=SystemEnv.getHtmlLabelName(24030,user.getLanguage())%>
    	   	                            <input   type=input class="InputStyle" size=10 maxlength=3 name="strlength" value="5" onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this)">
                                        <%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%>
    	   	                            <input   type=input class="InputStyle" size=10 maxlength=4 name="imgwidth" value="100" onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this)">
                                        <%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%>
    	   	                            <input   type=input class="InputStyle" size=10 maxlength=4 name="imgheight" value="100" onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this)">
                                    </div>
                                    <DIV id="div7" style="display:none">
                                        <%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
                                        <select id=specialfield name=specialfield onchange=specialtype(this)>
                                          <OPTION value="1"><%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%></OPTION>
                                          <OPTION value="2"><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%></OPTION>
                                        </select>
                                    </DIV>
                                    <div id="div7_1" style="display:none"><table width="100%"><tr><td width="25%"><%=SystemEnv.getHtmlLabelName(606,user.getLanguage())%>　<input class=inputstyle type=text name=displayname size=20 value="" maxlength=1000>　</td><td><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%>　<input class=inputstyle type=text size=50 name=linkaddress value="" maxlength=1000><br><%=SystemEnv.getHtmlLabelName(18391,user.getLanguage())%></td></tr></table></div>

　　                                     <div id="div7_2" style="display:none"><table width="100%"><tr><td width="8%"><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%>　</td><td><textarea class='inputstyle' style='width:60%;height:100px' name=descriptivetext></textarea></td></tr></table></div>

								  </td>
    						</tr>
    						<TR class=Spacing style="height: 1px"><TD class="Line" colSpan=4></TD></TR>
    						<tr>
    							<td><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></td>
    							<td>
    								<input class='InputStyle' type="text" size=10 maxlength=7 name="itemDspOrder" onKeyPress="ItemNum_KeyPress(this.name)" onblur="checknumber('itemDspOrder');checkDigit('itemDspOrder',15,2)" style="text-align:right;"></td>
    						</tr>
    						<TR class=Spacing style="height: 1px"><TD class="Line" colSpan=4></TD></TR>
							</table>
						</td>
					</tr>
				</TABLE>
			</td>
			<td ></td>
		</tr>
	</table>
</form>
</body>
</html>
<script language="JavaScript">
var choicerowindex = 1;
	function checklength(elementname,spanid){
		tmpvalue = $G(elementname).value;
		while(tmpvalue.indexOf(" ") == 0)
			tmpvalue = tmpvalue.substring(1,tmpvalue.length);
		if(tmpvalue!=""&&tmpvalue!=0){
			 $G(spanid).innerHTML='';
		}
		else{
		 $G(spanid).innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";
		 $G(elementname).value = "";
		}
	}
	function addoTableRow(){
	  rowColor1 = "";
	  obj = document.getElementById("choiceTable");
		ncol=obj.rows[0].cells.length;
		oRow = obj.insertRow(-1);
		for(i=0; i<ncol; i++){
			oCell1 = oRow.insertCell(i);
			oCell1.style.height=24;
			oCell1.style.background=rowColor1;
			switch(i){
				case 0:
					var oDiv1 = document.createElement("div");
					var sHtml1 = "<input type='checkbox' name='chkField' index='"+choicerowindex+"' value='0'>";
					oDiv1.innerHTML = sHtml1;
					oCell1.appendChild(oDiv1);
					break;
				case 1:
					var oDiv1 = document.createElement("div");
					var sHtml1 = "<input class='InputStyle styled input' type='text' size='10' id='field_name_"+choicerowindex+"' name='field_name_"+choicerowindex+"' style='width=90%'"+
											 " onchange=checkinput('field_name_"+choicerowindex+"','field_span_"+choicerowindex+"')>"+
											 " <span id='field_span_"+choicerowindex+"'><IMG src='/images/BacoError.gif' align=absMiddle></span>";
					oDiv1.innerHTML = sHtml1;
					oCell1.appendChild(oDiv1);
					break;
				case 2:
					var oDiv1 = document.createElement("div");
					var sHtml1 = " <input class='InputStyle styled input' type='text' size='4' value = '0.00' name='field_count_name_"+choicerowindex+"' style='width=90%'"+
								" onKeyPress=ItemNum_KeyPress('field_count_name_"+choicerowindex+"') onchange=checknumber('field_count_name_"+choicerowindex+"')>";
					oDiv1.innerHTML = sHtml1;
					oCell1.appendChild(oDiv1);
					break;
				case 3:
					var oDiv1 = document.createElement("div");
					var sHtml1 = " <input type='checkbox' name='field_checked_name_"+choicerowindex+"' onclick='if(this.checked){this.value=1;}else{this.value=0}'>";
					oDiv1.innerHTML = sHtml1;
					oCell1.appendChild(oDiv1);
					break;
				case 4:
					var oDiv1 = document.createElement("div");
					var sHtml1 = "<input type='checkbox' name='isAccordToSubCom"+choicerowindex+"' value='1' ><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;"
								+ "<BUTTON type='button' class=Browser onClick=\"onShowCatalog(mypath_"+choicerowindex+","+choicerowindex+")\" name=selectCategory></BUTTON>"
								+ "<span id=mypath_"+choicerowindex+"></span>"
							    + "<input type=hidden id='pathcategory_"+choicerowindex+"' name='pathcategory_"+choicerowindex+"' value=''>"
							    + "<input type=hidden id='maincategory_"+choicerowindex+"' name='maincategory_"+choicerowindex+"' value=''>";
	
					oDiv1.innerHTML = sHtml1;
					oCell1.appendChild(oDiv1);
					break;
				case 5:
					var oDiv1 = document.createElement("div");
					var sHtml1 = "<BUTTON type='button' class=\"Browser\" onClick=\"onShowChildSelectItem('childItemSpan"+choicerowindex+"', 'childItem"+choicerowindex+"')\" id=\"selectChildItem"+choicerowindex+"\" name=\"selectChildItem"+choicerowindex+"\"></BUTTON>"
								+ "<input type=\"hidden\" id=\"childItem"+choicerowindex+"\" name=\"childItem"+choicerowindex+"\" value=\"\" >"
								+ "<span id=\"childItemSpan"+choicerowindex+"\" name=\"childItemSpan"+choicerowindex+"\"></span>";
					oDiv1.innerHTML = sHtml1;
					oCell1.appendChild(oDiv1);
					break;
			}		
		}
		choicerowindex++;
	}
	function submitClear(){
		//检查是否选中要删除的数据项
		var flag = false;
		var col = document.getElementsByName("chkField");
		for(var i = 0; i<col.length; i++){
			if(col[i] && col[i].checked){
				flag = true;
				break;
			}
		}
		if(flag){
			if (isdel()){
				deleteRow1();
			}
		} else {
			alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>");
			return false;
		}
	}
	function deleteRow1(){
		var objTbl = document.getElementById("choiceTable");
		var objChecks=objTbl.getElementsByTagName("INPUT");	
		for(var i=objChecks.length-1;i>=0;i--){
			if(objChecks[i].name=="chkField" && objChecks[i].checked) objTbl.deleteRow(objChecks[i].parentElement.parentElement.parentElement.rowIndex);	
		}	 
	}
	function onShowCatalog(spanName,choicerowindex){
		var isAccordToSubCom=0;
		if(document.getElementById("isAccordToSubCom"+choicerowindex)!=null){
			if(document.getElementById("isAccordToSubCom"+choicerowindex).checked){
				isAccordToSubCom=1;
			}
		}
		if(isAccordToSubCom==1){
			onShowCatalogSubCom();
		}else{
			onShowCatalogHis(spanName, choicerowindex);
		}
	}
	function onShowCatalogHis(spanName, choicerowindex) {
		var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp");
	    if (result != null){
	        if (wuiUtil.getJsonValueByIndex(result, 0)> 0){
	            spanName.innerHTML=wuiUtil.getJsonValueByIndex(result, 2);
	            $G("pathcategory_"+choicerowindex).value=wuiUtil.getJsonValueByIndex(result, 2);
	            $G("maincategory_"+choicerowindex).value=wuiUtil.getJsonValueByIndex(result, 3)+","+wuiUtil.getJsonValueByIndex(result, 4)+","+wuiUtil.getJsonValueByIndex(result, 1);
	        }else{
	            spanName.innerHTML="";
	            $G("pathcategory_"+choicerowindex).value="";
	            $G("maincategory_"+choicerowindex).value="";
	       }
	    }
	}
	function onShowCatalogSubCom() {
		alert("<%=SystemEnv.getHtmlLabelName(24460,user.getLanguage())%>");
	}

	var dbnamesForCompare = "<%=dbnamesForCompare_main%>";
	function submitData(){
		if(check_form(form1,"fieldname,fieldlabelname")){
			fieldhtmltype = $G("FieldHtmlType").value;
			documentType = $G("DocumentType").value;
			if(fieldhtmltype==1&&documentType==1&&$G("itemFieldScale1").value==""){//单行文本框——文本时，文本长度必填。
				alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
				return;
			}
			if(fieldhtmltype==5){
				for(var tempchoiceRows=1; tempchoiceRows<=choicerowindex; tempchoiceRows++){
					if($G("field_name_"+tempchoiceRows)&&$G("field_name_"+tempchoiceRows).value==""){//选择框的可选项文字必填
						alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				if(document.getElementById("choiceTable")){
					$G("choiceRows_rows").value=choicerowindex;
				}
			}
			if(fieldhtmltype==3){
			    if(document.getElementById("browsertype").value==224){
			    	if(document.getElementById("sapbrowser").value==""){
				    	alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
				    	return;
			    	}
				}
				//必要信息不完整
				if(document.getElementById("browsertype").value==226||document.getElementById("browsertype").value==227){
			    	if(document.getElementById("showvalue").value==""){
				    	alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
				    	return;
			    	}
				}
				
			}
			var fieldname = $G("fieldname").value;
			if (!checkKey())  return false;
			var updateTableName = $G("updateTableName").value;
			if(updateTableName.indexOf("_dt")>0){
				if(fieldname=="id"||fieldname=="mainid"){
					alert(fieldname+"<%=SystemEnv.getHtmlLabelName(21810,user.getLanguage())%>");
					$G("fieldname").select();
					return;
				}
			}else{
				if(fieldname=="id"||fieldname=="requestId"){
					alert(fieldname+"<%=SystemEnv.getHtmlLabelName(21810,user.getLanguage())%>");
					$G("fieldname").select();
					return;
				}
			}
			if(dbnamesForCompare.indexOf(","+fieldname.toUpperCase()+",")>=0){
				alert("<%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())%>");
				return;
			}
			
			//对选择框中的欧元符号进行特殊处理
			if(fieldhtmltype==5){
				for(var i=1; i<=choicerowindex; i++){
					var myObj = document.getElementById("field_name_" + i);
					if(myObj){
						myObj.value = dealSpecial(myObj.value);
					}
				}
			}
			form1.submit();
		}
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
	
	function checkKey()
	{
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
    var fname=window.document.forms[0].fieldname.value;
	if (fname!="")
		{fname=","+fname.toUpperCase()+",";
	if (keys.indexOf(fname)>0)
		{
	    alert('<%=SystemEnv.getHtmlLabelName(19946,user.getLanguage())%>');
		window.document.forms[0].fieldname.focus();
        return false;
	    }
		}
	return true;
	}
	function deleteData(){
		if (isdel()){
			$G("src").value="deleteField";
			form1.submit();
		}
	}
	function OnChangeFieldHtmlType(){
		var fieldHtmlType = $G("FieldHtmlType").value;
		if(fieldHtmlType==1){
			document.getElementById("div1").style.display="inline";
			document.getElementById("div1_1").style.display="inline";
			document.getElementById('DocumentType').selectedIndex=0;
			document.getElementById("div1_3").style.display="none";
			document.getElementById("div2").style.display="none";
			document.getElementById("div3").style.display="none";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none"
			document.getElementById("div3_5").style.display="none"
			document.getElementById("div5").style.display="none";
            document.getElementById("div6").style.display="none";
		    document.getElementById("div6_1").style.display="none";
		    document.getElementById("div7").style.display="none";
		    document.getElementById("div7_1").style.display="none";
		    document.getElementById("div7_2").style.display="none";
		}
		if(fieldHtmlType==2){
			document.getElementById("div1").style.display="none";
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="none";
			document.getElementById("div2").style.display="inline";
			document.getElementById("div3").style.display="none";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none"
			document.getElementById("div3_5").style.display="none"
			document.getElementById("div5").style.display="none";
            document.getElementById("div6").style.display="none";
		    document.getElementById("div6_1").style.display="none";
		    document.getElementById("div7").style.display="none";
		    document.getElementById("div7_1").style.display="none";
		    document.getElementById("div7_2").style.display="none";
		}
		if(fieldHtmlType==3){
			document.getElementById("div1").style.display="none";
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="none";
			document.getElementById("div2").style.display="none";
			document.getElementById("div3").style.display="inline";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none"
			document.getElementById("div3_5").style.display="none"
			document.getElementById("div5").style.display="none";
            document.getElementById("div6").style.display="none";
		    document.getElementById("div6_1").style.display="none";
		    document.getElementById("div7").style.display="none";
		    document.getElementById("div7_1").style.display="none";
		    document.getElementById("div7_2").style.display="none";
		    if(document.getElementById("browsertype").value==224){
		    	document.getElementById("div3_4").style.display="inline";
		    	if(document.getElementById("sapbrowser").value==""){
		    		document.getElementById("div3_1").style.display="inline";
		    	}
			}
			if(document.getElementById("browsertype").value==226||document.getElementById("browsertype").value==227){
		    	document.getElementById("div3_5").style.display="inline";
		    	document.getElementById("div3_1").style.display="none";
		    	if(document.getElementById("showvalue").value==""){
		    		document.getElementById("showimg").style.display="inline";
		    	}
			}
		}
		if(fieldHtmlType==4){
			document.getElementById("div1").style.display="none";
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="none";
			document.getElementById("div2").style.display="none";
			document.getElementById("div3").style.display="none";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none"
			document.getElementById("div3_5").style.display="none"
			document.getElementById("div5").style.display="none";
            document.getElementById("div6").style.display="none";
		    document.getElementById("div6_1").style.display="none";
		    document.getElementById("div7").style.display="none";
		    document.getElementById("div7_1").style.display="none";
		    document.getElementById("div7_2").style.display="none";
		}
		if(fieldHtmlType==5){
			document.getElementById("div1").style.display="none";
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="none";
			document.getElementById("div2").style.display="none";
			document.getElementById("div3").style.display="none";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none"
			document.getElementById("div5").style.display="inline";
            document.getElementById("div6").style.display="none";
		    document.getElementById("div6_1").style.display="none";
		    document.getElementById("div7").style.display="none";
		    document.getElementById("div7_1").style.display="none";
		    document.getElementById("div7_2").style.display="none";
		}
		if(fieldHtmlType==6){
            document.getElementById("strlength").value='5';
            document.getElementById("imgwidth").value='100';
            document.getElementById("imgheight").value='100';
			document.getElementById("div1").style.display="none";
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="none";
			document.getElementById("div2").style.display="none";
			document.getElementById("div3").style.display="none";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none"
			document.getElementById("div5").style.display="none";
            document.getElementById("div6").style.display="inline";
		    document.getElementById("div6_1").style.display="none";
		    document.getElementById("div7").style.display="none";
		    document.getElementById("div7_1").style.display="none";
		    document.getElementById("div7_2").style.display="none";
            document.getElementById("uploadtype").options[0].selected=true;
		}
		if(fieldHtmlType==7){
			document.getElementById("div1").style.display="none";
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="none";
			document.getElementById("div2").style.display="none";
			document.getElementById("div3").style.display="none";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none"
			document.getElementById("div5").style.display="none";
            document.getElementById("div6").style.display="none";
		    document.getElementById("div6_1").style.display="none";
		    document.getElementById("div7").style.display="inline";
		    document.getElementById("div7_1").style.display="";
		    document.getElementById("div7_2").style.display="none";
            document.getElementById("specialfield").options[0].selected=true;
		}
	}
    function onuploadtype(obj){
        if(obj.value==1){
            document.getElementById("div6_1").style.display="none";
        }else{
            document.getElementById("div6_1").style.display="";
        }
    }
    function specialtype(obj){
        if(obj.value==1){
            document.getElementById("div7_1").style.display="";
		    document.getElementById("div7_2").style.display="none";
        }else{
            document.getElementById("div7_1").style.display="none";
		    document.getElementById("div7_2").style.display="";
        }
    }
	function OnChangeDocumentType(){
		var documentType = document.getElementById("DocumentType").value;
		if(documentType==1){
			document.getElementById("div1_1").style.display="inline";
			document.getElementById("div1_3").style.display="none";
		}else if(documentType==3){
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="inline";
		}else{
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="none";
		}
	}
	function OnChangeBrowserType(){
		var browserType = $G("browsertype").value;
		if(browserType==161||browserType==162){
			//document.getElementById("div3_1").style.display="inline"
			document.getElementById("div3_2").style.display="inline";
			var defineBrowserOptionValue = document.getElementById("definebroswerType").value;
			if(defineBrowserOptionValue==''||defineBrowserOptionValue==0){
			    document.getElementById("div3_1").style.display="inline";
			}else{
			    document.getElementById("div3_1").style.display="none";
			}
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
		}else if(browserType==224||browserType==225){
				document.getElementById("div3_4").style.display="inline"
				document.getElementById("div3_5").style.display="none";
				var sapbrowserOptionValue = document.getElementById("sapbrowser").value;
				if(sapbrowserOptionValue==''||sapbrowserOptionValue==0){
				    document.getElementById("div3_1").style.display="inline"
				}else{
				    document.getElementById("div3_1").style.display="none"
				}
				document.getElementById("div3_2").style.display="none"
				document.getElementById("div3_3").style.display="none"
		}else if(browserType==226||browserType==227){
				document.getElementById("div3_4").style.display="none";
				document.getElementById("div3_5").style.display="inline"
				var sapbrowserOptionValue = document.getElementById("showvalue").value;
				if(sapbrowserOptionValue==''){
				    document.getElementById("showimg").style.display="inline"
				}else{
				    document.getElementById("showimg").style.display="none"
				}
				document.getElementById("div3_1").style.display="none";
				document.getElementById("div3_2").style.display="none"
				document.getElementById("div3_3").style.display="none"
		}
		else if(browserType==165||browserType==166||browserType==167||browserType==168){
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="inline";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
		}else{
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
		}
	}
	function onfirmhtml(){
		if ($G("htmledit").checked==true){
			alert('<%=SystemEnv.getHtmlLabelName(20867,user.getLanguage())%>');
			$G("htmledit").value=2;
		}
	}
	function OnChangeDefineBroswerType(){
		if ($G("definebroswerType").value==""){
			document.getElementById("div3_1").style.display="inline";
		}else{
			document.getElementById("div3_1").style.display="none";
		}
	}
	function OnChangeSapBroswerType(){
		if ($G("sapbrowser").value==""){
			document.getElementById("div3_1").style.display="inline"
		}else{
			document.getElementById("div3_1").style.display="none"
		}
	}
	function OnNewChangeSapBroswerType(){
	
		var updateTableName=$G("updateTableName").value;//得到主表或明细表的名字
		var browsertype=$G("browsertype").value;
		var mark=$G("showinner").innerHTML;
		var left = Math.ceil((screen.width - 1086) / 2);   //实现居中
	    var top = Math.ceil((screen.height - 600) / 2);  //实现居中
		var tempstatus = "dialogWidth:1086px;dialogHeight:600px;dialogLeft:"+left+";dialogTop:"+top;+"scroll:yes;status:no;";
		var urls = "/integration/browse/integrationBrowerMain.jsp?browsertype="+browsertype+"&mark="+mark+"&formid=<%=formid%>&updateTableName="+updateTableName;
		var temp=window.showModalDialog(urls,"",tempstatus);
		if(temp){
			document.getElementById("showimg").style.display="none"
			$G("showvalue").value=temp;
			$G("showinner").innerHTML=temp;
		}else{
			//document.getElementById("showimg").style.display="inline"
			//$G("showvalue").value="";
			//$G("showinner").innerHTML="";
		}
	}
	function OnChangeUpdateTableName(obj){
        FieldHtmlType = document.getElementById("FieldHtmlType");
        //主表
        if(obj.value=="<%=maintable%>"){
           for(var count = FieldHtmlType.options.length - 1; count >= 0; count--){
	           FieldHtmlType.options[count] = null;
           }
           <%=mainselect%>
           $G("FieldHtmlType").value = "1";
           OnChangeFieldHtmlType(); 
           $G("DocumentType").value = "1";
           OnChangeDocumentType();
           //明细表中的多行文本框字段html格式可用
           $GetEle("htmledit").disabled = false;
        //明细表
        }else{
           for(var count = FieldHtmlType.options.length - 1; count >= 0; count--){
	           FieldHtmlType.options[count] = null;
           }
           <%=detailselect%>           
           $G("FieldHtmlType").value = "1";
           OnChangeFieldHtmlType();
           $G("DocumentType").value = "1";
           OnChangeDocumentType();
           //明细表中的多行文本框字段html格式不可用
           $GetEle("htmledit").disabled = true;
        }
                        
        var updateTableName = $G("updateTableName").value;
		dbnamesForCompare = $G(updateTableName).value;
	}
	/*
	p（精度）
	指定小数点左边和右边可以存储的十进制数字的最大个数。精度必须是从 1 到最大精度之间的值。最大精度为 38。
	
	s（小数位数）
	指定小数点右边可以存储的十进制数字的最大个数。小数位数必须是从 0 到 p 之间的值。默认小数位数是 0，因而 0 <= s <= p。最大存储大小基于精度而变化。
	*/
	function checkDigit(elementName,p,s){
		tmpvalue = document.getElementById(elementName).value;
	
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
	    document.getElementById(elementName).value=newValue;
	}
	function getIsDetail(){
		var updateTableName = document.getElementById("updateTableName").value;
		var isdetail = "0";
		if(updateTableName.indexOf("_dt") > -1){
			isdetail = "1";
		}
		return isdetail;
	}
	function getDetailTableSql(){
		var updateTableName = document.getElementById("updateTableName").value;
		var detailTableSql = "";
		if(updateTableName.indexOf("_dt") > -1){
			detailTableSql = " and detailtable='"+updateTableName+"' ";
		}
		return detailTableSql;
	}
	function onChangeChildField(){
		var rownum = parseInt(choicerowindex);
		for(var i=0; i<rownum; i++){
			var inputObj = $G("childItem"+i);
			var spanObj = $G("childItemSpan"+i);
			try{
				if(inputObj!=null && spanObj!=null){
					inputObj.value = "";
					spanObj.innerHTML = "";
				}
			}catch(e){}
		}
	}
	
function onShowChildSelectItem(spanname, inputname){
	var cfid = $G("childfieldid").value;
	var resourceids = $G(inputname).value;
	var isdetail = getIsDetail();
	var url=escape("/workflow/field/SelectItemBrowser.jsp?isbill=1&isdetail=" + isdetail + "&childfieldid=" + cfid + "&resourceids=" + resourceids);
	var id = showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url);
	if (id != null) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		if (rid != "") {
			var resourceids = rid.substr(1);
			var resourcenames = rname.substr(1);
			
			$G(inputname).value = resourceids;
			$G(spanname).innerHTML = resourcenames;
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
		}
	}
}	

function onShowChildField(spanname, inputname) {
    oldvalue = inputname.value;
    isdetail = getIsDetail();
    detailTableSql = getDetailTableSql();
    url = escape("/workflow/workflow/fieldBrowser.jsp?sqlwhere=where fieldhtmltype=5 and billid=<%=formid%>" + detailTableSql + "&isdetail=" + isdetail + "&isbill=1");
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
        onChangeChildField();
    }
}
</script>
<script language="VBScript">
sub onShowChildField1(spanname, inputname)
	oldvalue = inputname.value
	isdetail = getIsDetail()
	detailTableSql = getDetailTableSql()
	url=escape("/workflow/workflow/fieldBrowser.jsp?sqlwhere=where fieldhtmltype=5 and billid=<%=formid%>"+detailTableSql+"&isdetail="+isdetail+"&isbill=1")
	id = showModalDialog("/systeminfo/BrowserMain.jsp?url="&url)
	if Not isempty(id) then
		if id(0) <> "" then
			inputname.value = id(0)
			spanname.innerHtml = id(1)
		else
			inputname.value = ""
			spanname.innerHtml = ""
		end if
	end if
	if oldvalue <> inputname.value then
		onChangeChildField
	end if
end sub

sub onShowChildSelectItem1(spanname, inputname)
	cfid = form1.childfieldid.value
	resourceids = inputname.value
	isdetail = getIsDetail()
	url=escape("/workflow/field/SelectItemBrowser.jsp?isbill=1&isdetail="+isdetail+"&childfieldid="&cfid&"&resourceids="&resourceids)
	id = showModalDialog("/systeminfo/BrowserMain.jsp?url="&url)
	if Not isempty(id) then
		if id(0) <> "" then
			resourceids = id(0)
			resourcenames = id(1)
			resourceids = Mid(resourceids, 2, len(resourceids))
			resourcenames = Mid(resourcenames, 2, len(resourcenames))
			inputname.value = resourceids
			spanname.innerHtml = resourcenames
		else
			inputname.value = ""
			spanname.innerHtml = ""
		end if
	end if

end sub
</script>