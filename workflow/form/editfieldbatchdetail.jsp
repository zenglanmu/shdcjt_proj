<%@page import="com.weaver.integration.util.IntegratedSapUtil"%>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="weaver.general.StaticObj"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser"%>
<%@ include file="/systeminfo/init.jsp" %>
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

<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
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
String IsOpetype=IntegratedSapUtil.getIsOpenEcology70Sap();
boolean canChange = false;
rs.executeSql("select 1 from workflow_base where formid="+formid);
if(rs.getCounts()<=0){//如果表单还没有被引用，字段可以修改。
    canChange = true;
}
	
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(699,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(20839,user.getLanguage())+SystemEnv.getHtmlLabelName(17998,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<Table>
<TBODY>

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
}
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


  <TABLE class=viewform>
    <COLGROUP> 
	<COL width="20%"> 
	<COL width="80%"> 
	<TBODY> 
    <TR class=title> 
      <td><b><%=SystemEnv.getHtmlLabelName(18549,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></b></td>
      <td align=right>
	  <button type='button' class=btn accessKey=A onClick="addRow()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button> 
	  <button type='button' class=btn accessKey=E onClick="deleteRow()"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
      <button type='button' class=btn accessKey=C onClick="copyRow()"><U>C</U>-<%=SystemEnv.getHtmlLabelName(77,user.getLanguage())%></button>
      </td>
    </TR>
    <TR class=spacing> 
      <TD class=line1 colSpan=2 ></TD>
    </TR>
    </TBODY> 
  </TABLE> 
  	  <table class=ListStyle id="oTable" cols=5  border=0 cellspacing=1>
      	<COLGROUP>
		<COL width="5%">
		<COL width="20%">
		<COL width="30%">
		<COL width="45%">
		<COL width="10%">
          <tr class=header>
            <td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></td>
          </tr>
<%

			String trClass="DataLight";
			int rowsum=0;
			String dbfieldnamesForCompare = ",";

			String fieldname = "";//数据库字段名称
  		int fieldlabel = 0;//字段显示名标签id
  		String fielddbtype = "";//字段数据库类型
  		String fieldhtmltype = "";//字段页面类型
  		String type = "";//字段详细类型
  		String dsporder = "";//显示顺序
  		String imgwidth="";
        String imgheight="";
        int textheight = 0;
			
			String sql = "select * from workflow_billfield where billid="+formid+" and viewtype=0 order by dsporder,id";
			RecordSet.executeSql(sql);
			while(RecordSet.next()){
				String fieldid = RecordSet.getString("id");
				fieldname = RecordSet.getString("fieldname");
				dbfieldnamesForCompare += fieldname.toUpperCase()+",";
				fieldlabel = RecordSet.getInt("fieldlabel");
				String fieldlabelname = SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage());
				fielddbtype = RecordSet.getString("fielddbtype");
				String fieldlength = "";
				fieldhtmltype = RecordSet.getString("fieldhtmltype");
				type = RecordSet.getString("type");
				if(fieldhtmltype.equals("1")&&type.equals("1")){
					fieldlength = fielddbtype.substring(fielddbtype.indexOf("(")+1,fielddbtype.indexOf(")"));
				}
				dsporder = Util.null2String(RecordSet.getString("dsporder"));
				textheight = Util.getIntValue(Util.null2String(RecordSet.getString("textheight")),0);
				imgwidth = ""+Util.getIntValue(Util.null2String(RecordSet.getString("imgwidth")),0);
                imgheight = ""+Util.getIntValue(Util.null2String(RecordSet.getString("imgheight")),0);
				int childfieldid_tmp = Util.getIntValue(RecordSet.getString("childfieldid"));
				String childfieldStr = "";
				Hashtable childItem_hs = new Hashtable();
				if(childfieldid_tmp > 0){
					rs_child.execute("select fieldlabel from workflow_billfield where id="+childfieldid_tmp);
					if(rs_child.next()){
						int childfieldlabel = rs_child.getInt("fieldlabel");
						childfieldStr = SystemEnv.getHtmlLabelName(childfieldlabel, user.getLanguage());
					}
					rs_child.execute("select * from workflow_SelectItem where isbill=1 and fieldid="+childfieldid_tmp);
					while(rs_child.next()){
						int selectvalue_tmp = Util.getIntValue(rs_child.getString("selectvalue"), -1);
						String selectname_tmp = Util.null2String(rs_child.getString("selectname"));
						childItem_hs.put("item_"+selectvalue_tmp, selectname_tmp);
					}
				}
				String para = fieldname+"+0+"+fieldhtmltype+"+ +"+formid;
				String canDeleteCheckBox = FormFieldTransMethod.getCanCheckBox(para);
%>
          <TR class=<%=trClass%>>
			<td  height="23" >
			    <input type='checkbox' name='check_select' value="<%=fieldid%>_<%=rowsum%>" <%if(canDeleteCheckBox.equals("false")){%>disabled<%}%> >
			    <input type='hidden' name='modifyflag_<%=rowsum%>' value="<%=fieldid%>">
		    </td>
			<td NOWRAP >
			  <%if(!canChange){%>
			  <input   class=Inputstyle type=hidden name="itemDspName_<%=rowsum%>" style="width:90%"  value="<%=Util.toScreen(fieldname,user.getLanguage())%>">
			  <span id="itemDspName_<%=rowsum%>_span"><%=Util.toScreen(fieldname,user.getLanguage())%></span>
			  <%}else{%>
			  <input class=Inputstyle type=text name="itemDspName_<%=rowsum%>" style="width:90%"  value="<%=Util.toScreen(fieldname,user.getLanguage())%>" onchange="checkinput('itemDspName_<%=rowsum%>','itemDspName_<%=rowsum%>_span');setChange(<%=rowsum%>)">
			  <span id="itemDspName_<%=rowsum%>_span"></span>
			  <%}%>
			  <input type="hidden" name="olditemDspName_<%=rowsum%>" value="<%=Util.toScreen(fieldname,user.getLanguage())%>" >
			</td>
			<td NOWRAP >
			  <input   class=Inputstyle type=text name="itemFieldName_<%=rowsum%>" style="width:90%"   value="<%=Util.toScreen(fieldlabelname,user.getLanguage())%>"   onchange="checkinput('itemFieldName_<%=rowsum%>','itemFieldName_<%=rowsum%>_span');setChange(<%=rowsum%>)">
			  <span id="itemFieldName_<%=rowsum%>_span"></span>
			</td>
			<td NOWRAP >
				  <select class='InputStyle' name='itemFieldType_<%=rowsum%>' <%if(!canChange){%>disabled<%}%> onChange="onChangItemFieldType(<%=rowsum%>);setChange(<%=rowsum%>)">
				  	<option value='1' <%if(fieldhtmltype.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%></option>
				  	<option value='2' <%if(fieldhtmltype.equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%></option>
				  	<option value='3' <%if(fieldhtmltype.equals("3")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></option>
				  	<option value='4' <%if(fieldhtmltype.equals("4")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%></option>
				  	<option value='5' <%if(fieldhtmltype.equals("5")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></option>
				  	<option value='6' <%if(fieldhtmltype.equals("6")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%></option>
					<option value='7' <%if(fieldhtmltype.equals("7")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(21691,user.getLanguage())%></option>
				  </select>
				  <%if(!canChange){%>
				  <input type="hidden" value="<%=fieldhtmltype%>" name="itemFieldType_<%=rowsum%>">
				  <%}%>
				  
				  <div id="div1_<%=rowsum%>" <%if(fieldhtmltype.equals("1")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
					  <%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
					  <select class='InputStyle' name='documentType_<%=rowsum%>' <%if(!canChange){%>disabled<%}%> onChange='onChangType(<%=rowsum%>);setChange(<%=rowsum%>)'>
					  	<option value='1' <%if(type.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
					  	<option value='2' <%if(type.equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
					  	<option value='3' <%if(type.equals("3")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
					  	<option value='4' <%if(type.equals("4")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%></option>
					  	<option value='5' <%if(type.equals("5")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%></option>
					  </select>
						<%if(!canChange){%><input type="hidden" value="<%=type%>" name="documentType_<%=rowsum%>"><%}%>
					</div>
					<div id="div1_1_<%=rowsum%>" <%if(fieldhtmltype.equals("1")&&type.equals("1")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
					  <%
					      int maxlength = 0;
					      if(isoracle){
					          rs.executeSql("select max(lengthb("+fieldname+")) from "+tablename);
					          if(rs.next()) maxlength = Util.getIntValue(rs.getString(1),0);
					      }else{
					          rs.executeSql("select max(datalength("+fieldname+")) from "+tablename);
					          if(rs.next()) maxlength = Util.getIntValue(rs.getString(1),0);
					      }
					      //out.println("maxlength=="+maxlength);
					  %>
				  		<%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>
					  	<input class='InputStyle' type='text' size=3 maxlength=3 value='<%=fieldlength%>' id='itemFieldScale1_<%=rowsum%>' name='itemFieldScale1_<%=rowsum%>' onKeyPress='ItemPlusCount_KeyPress()' onchange='setChange(<%=rowsum%>)' onblur='checkPlusnumber1(this);checklength(itemFieldScale1_<%=rowsum%>,itemFieldScale1span_<%=rowsum%>);checkcount1(itemFieldScale1_<%=rowsum%>);checkmaxlength(<%=maxlength%>,itemFieldScale1_<%=rowsum%>)' style='text-align:right;'><span id=itemFieldScale1span_<%=rowsum%>><%if(fieldlength.equals("")){%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></span>
					</div>
					<div id="div1_3_<%=rowsum%>" <%if(fieldhtmltype.equals("1")&&type.equals("3")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
					  <%
					      int decimaldigits = 2;
						if(fieldhtmltype.equals("1")&&type.equals("3")){
							int digitsIndex = fielddbtype.indexOf(",");
				        	if(digitsIndex > -1){
				        		decimaldigits = Util.getIntValue(fielddbtype.substring(digitsIndex+1, fielddbtype.length()-1), 2);
				        	}else{
				        		decimaldigits = 2;
				        	}
						}
					  %>
				  		<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
						<%if(!canChange){%>
							<input type="hidden" id="decimaldigits_<%=rowsum%>" name="decimaldigits_<%=rowsum%>" value="<%=decimaldigits%>">
							<select id="decimaldigitshidden_<%=rowsum%>" name="decimaldigitshidden_<%=rowsum%>" size="1" disabled>
						<%}else{%>
							<select id="decimaldigits_<%=rowsum%>" name="decimaldigits_<%=rowsum%>" size="1">
						<%}%>
								<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
								<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
								<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
								<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
							</select>
					</div>
				  <div id="div2_<%=rowsum%>" <%if(fieldhtmltype.equals("2")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
				  	<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>
				  	<input class='InputStyle' type='text' size=4 maxlength=2 value='<%=textheight%>' id='textheight_<%=rowsum%>' name='textheight_<%=rowsum%>' onKeyPress='ItemPlusCount_KeyPress()' onchange='setChange(<%=rowsum%>)' onblur='checkPlusnumber1(this);checkcount1(textheight_<%=rowsum%>)' style='text-align:right;'>
				  	<%=SystemEnv.getHtmlLabelName(222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15449,user.getLanguage())%>
				  	<input type='checkbox' <%if(type.equals("2")){%> checked <%}%> <%if(!canChange){%>disabled<%}%>>
				  	<%if(!canChange){%><input type="hidden" value="<%=type%>" name="htmledit_<%=rowsum%>"><%}%>
					</div>
				  
				  <div id="div3_<%=rowsum%>" <%if(fieldhtmltype.equals("3")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
				  	<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
				  	<select class='InputStyle' name='broswerType_<%=rowsum%>' <%if(!canChange){%>disabled<%}%> onChange="onChangBroswerType(<%=rowsum%>);setChange(<%=rowsum%>)">
				  		<%while(browserComInfo.next()){
				  				if("1".equals(IsOpetype)&&("224".equals(browserComInfo.getBrowserid()))||"225".equals(browserComInfo.getBrowserid())){
				  				 		continue;
				  				 }
				  				 
				  				 if("0".equals(IsOpetype)&&("226".equals(browserComInfo.getBrowserid()))||"227".equals(browserComInfo.getBrowserid())){
				  				 		continue;
				  				 }
				  		%>
				  			
				  			<option value="<%=browserComInfo.getBrowserid()%>" <%if(type.equals(""+browserComInfo.getBrowserid())){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(Util.getIntValue(browserComInfo.getBrowserlabelid(),0),user.getLanguage())%></option>
				  		<%}%>
				  	</select>
				  	<%if(!canChange){%><input type="hidden" value="<%=type%>" name="broswerType_<%=rowsum%>" id="broswerType_<%=rowsum%>" ><%}%>
				  </div>
				  <div id="div3_0_<%=rowsum%>" <%if(fieldhtmltype.equals("3")&&(type.equals("161")||type.equals("162")||type.equals("224")||type.equals("225")||type.equals("226")||type.equals("227"))&&fielddbtype.equals("")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
				  	<span><IMG src='/images/BacoError.gif' align=absMiddle></span>
				  </div>
				  
					<div id="div3_1_<%=rowsum%>" <%if(fieldhtmltype.equals("3")&&(type.equals("161")||type.equals("162"))){%>style="display:inline"<%}else{%>style="display:none"<%}%>> 
				  		<select class='InputStyle' name='definebroswerType_<%=rowsum%>' <%if(!canChange){%>disabled<%}%> onChange="div3_0_show(<%=rowsum%>);setChange(<%=rowsum%>)">
				  			<%
				  			List l=StaticObj.getServiceIds(Browser.class);
				  			for(int j=0;j<l.size();j++){
				  			%>
				  			<option value='<%=l.get(j)%>' <%if(fielddbtype.equals(""+l.get(j))){%>selected<%}%>><%=l.get(j)%></option>
				  			<%}%>
				  		</select>
				  		<%if(!canChange){%><input type="hidden" value="<%=fielddbtype%>" name="definebroswerType_<%=rowsum%>"><%}%>
					</div>
					
					<div id="div3_4_<%=rowsum%>" <%if(fieldhtmltype.equals("3")&&(type.equals("224")||type.equals("225"))){%>style="display:inline"<%}else{%>style="display:none"<%}%>> 
				  		<select class='InputStyle' name='sapbrowser_<%=rowsum%>' <%if(!canChange){%>disabled<%}%> onChange="div3_4_show(<%=rowsum%>);setChange(<%=rowsum%>)">
				  			<%
				  			List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
				  			for(int j=0;j<AllBrowserId.size();j++){
				  			%>
				  			<option value='<%=AllBrowserId.get(j)%>' <%if(fielddbtype.equals(""+AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
				  			<%}%>
				  		</select>
				  		<%if(!canChange){%><input type="hidden" value="<%=fielddbtype%>" name="definebroswerType_<%=rowsum%>"><%}%>
				  		<%if(!canChange){%><input type="hidden" value="<%=fielddbtype%>" name="sapbrowser_<%=rowsum%>"><%}%>
					</div>
					
					<!-- zzl--start -->
						
					<div id="div3_5_<%=rowsum%>" <%if(fieldhtmltype.equals("3")&&(type.equals("226")||type.equals("227"))){%>style="display:inline"<%}else{%>style="display:none"<%}%>> 
				  		<button type=button  class='browser' name='newsapbrowser_<%=rowsum%>' id='newsapbrowser_<%=rowsum%>'  onclick='OnNewChangeSapBroswerType(<%=rowsum%>)'></button>
						 <span id='showinner_<%=rowsum%>'><%if(type.equals("226")||type.equals("227")){out.print(fielddbtype);}%></span>
						<span id='showimg_<%=rowsum%>'><%if(type.equals("226")||type.equals("227")){out.print("");}else{out.println("<IMG src='/images/BacoError.gif' align=absMiddle>");}%></span>
				  		<input type="hidden" value="<%if(type.equals("226")||type.equals("227")){out.print(fielddbtype);}%>" name="definebroswerType_<%=rowsum%>">
				  		<input type="hidden" value="<%if(type.equals("226")||type.equals("227")){out.print(fielddbtype);}%>" name='showvalue_<%=rowsum%>' id='showvalue_<%=rowsum%>' >
						</div>
					
					<!-- zzl--end -->
					
					<div id="div3_2_<%=rowsum%>" <%if(fieldhtmltype.equals("3")&&(type.equals("165")||type.equals("166")||type.equals("167")||type.equals("168"))){%>style="display:inline"<%}else{%>style="display:none"<%}%>> 
				  		<%=SystemEnv.getHtmlLabelName(19340,user.getLanguage())%>
				  		<select class='InputStyle' name='decentralizationbroswerType_<%=rowsum%>' <%if(!canChange){%>disabled<%}%> onChange="setChange(<%=rowsum%>)">
				  			<option value='1' <%if(RecordSet.getString("textheight").equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18916,user.getLanguage())%></option>
				  			<option value='2' <%if(RecordSet.getString("textheight").equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18919,user.getLanguage())%></option>
				  		</select>
				  		<%if(!canChange){%><input type="hidden" value="<%=RecordSet.getString("textheight")%>" name="decentralizationbroswerType_<%=rowsum%>"><%}%>
					</div>  
				  
				  <div id="div5_<%=rowsum%>" <%if(fieldhtmltype.equals("5")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
				  	<button type='button' class=btn id=btnaddRow name=btnaddRow onclick='addoTableRow(<%=rowsum%>)'><%=SystemEnv.getHtmlLabelName(15443,user.getLanguage())%></BUTTON>
				  	<button type='button' class=btn id=btnsubmitClear name=btnsubmitClear onclick='submitClear(<%=rowsum%>)'><%=SystemEnv.getHtmlLabelName(15444,user.getLanguage())%></BUTTON>
					<span><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
					<button type='button' id='showChildFieldBotton' class=Browser onClick="onShowChildField(childfieldidSpan_<%=rowsum%>,childfieldid_<%=rowsum%>,'_<%=rowsum%>')"></BUTTON>
					<span id='childfieldidSpan_<%=rowsum%>'><%=childfieldStr%></span>
					<input type='hidden' value='<%=childfieldid_tmp%>' name='childfieldid_<%=rowsum%>' id='childfieldid_<%=rowsum%>'>
					</div>
					<div id="div5_5_<%=rowsum%>" <%if(fieldhtmltype.equals("5")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
				  	<table class='ViewForm' id='choiceTable_<%=rowsum%>' cols=7 border=0>
						<COL width="3%">
						<COL width="20%">
						<COL width="20%">
						<COL width="15%">
						<COL width="16%">
						<COL width="26%">
						<col width="10%">
				  		<tr>
				  			<td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
				  			<td><%=SystemEnv.getHtmlLabelName(15442,user.getLanguage())%></td>
				  			<td><%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%></td>
				  			<td><%=SystemEnv.getHtmlLabelName(19206,user.getLanguage())%></td>
				  			<td><%=SystemEnv.getHtmlLabelName(19207,user.getLanguage())%></td>
							<td><%=SystemEnv.getHtmlLabelName(22663,user.getLanguage())%></td>
				  			<td><%=SystemEnv.getHtmlLabelName(22151,user.getLanguage())%></td>
						</tr>
				  		<%
				  		int recordchoicerowindex = 0;
				  		RecordSet1.executeSql("select * from workflow_SelectItem where isbill=1 and fieldid="+fieldid+" order by selectvalue ");
				  		while(RecordSet1.next()){
				  		recordchoicerowindex+=1;
						String childitemid_tmp = Util.null2String(RecordSet1.getString("childitemid"));
						String childitemidStr = "";
						int isAccordToSubCom_tmp = Util.getIntValue(RecordSet1.getString("isaccordtosubcom"), 0);
						String isAccordToSubCom_Str = "";
						if(isAccordToSubCom_tmp == 1){
							isAccordToSubCom_Str = " checked ";
						}
						String[] childitemid_sz = Util.TokenizerString2(childitemid_tmp, ",");
						for(int cx=0; (childitemid_sz!=null && cx<childitemid_sz.length); cx++){
							String childitemidTemp = Util.null2String(childitemid_sz[cx]);
							String childitemnameTemp = Util.null2String((String)childItem_hs.get("item_"+childitemidTemp));
							if(!"".equals(childitemnameTemp)){
								childitemidStr += (childitemnameTemp+",");
							}
						}
						if(!"".equals(childitemidStr)){
							childitemidStr = childitemidStr.substring(0, childitemidStr.length()-1);
						}
				  		%>
				  	<tr>
				  		<td><div><input type="checkbox" name="chkField" index="<%=recordchoicerowindex%>" value="0" <%if(canDeleteCheckBox.equals("false")){%>disabled<%}%>></div></td>
				  		<td><div><input class="InputStyle" value="<%=RecordSet1.getString("selectname")%>" type="text" size="10" name="field_<%=rowsum%>_<%=recordchoicerowindex%>_name" style="width=90%" onchange="checkinput('field_<%=rowsum%>_<%=recordchoicerowindex%>_name','field_<%=rowsum%>_<%=recordchoicerowindex%>_span');setChange(<%=rowsum%>)">
				  			<span id="field_<%=rowsum%>_<%=recordchoicerowindex%>_span"><%if(RecordSet1.getString("selectname").equals("")){%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></span></div></td>
				  		<td><div><input class="InputStyle" type="text" size="4" value = "<%=RecordSet1.getString("listorder")%>" name="field_count_<%=rowsum%>_<%=recordchoicerowindex%>_name" style="width=90%" onchange="setChange(<%=rowsum%>)" onKeyPress="ItemNum_KeyPress('field_count_<%=rowsum%>_<%=recordchoicerowindex%>_name')"></div></td>
				  		<td><div><input type="checkbox" name="field_checked_<%=rowsum%>_<%=recordchoicerowindex%>_name" onchange='setChange(<%=rowsum%>)' onclick="if(this.checked){this.value=1;}else{this.value=0}" <%if(RecordSet1.getString("isdefault").equals("y")){%>checked<%}%> value="1"></div></td>
				  			
				  		<td><div><input type="hidden" id="selectvalue<%=rowsum%>_<%=recordchoicerowindex%>" name="selectvalue<%=rowsum%>_<%=recordchoicerowindex%>" value="<%=RecordSet1.getString("selectvalue")%>">
							<input type='checkbox' name='isAccordToSubCom<%=rowsum%>_<%=recordchoicerowindex%>'   onchange='setChange(<%=rowsum%>)'  value='1' <%=isAccordToSubCom_Str%>><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;
							<button type='button' class=Browser name="selectCategory" onClick="onShowCatalog(mypath_<%=rowsum%>_<%=recordchoicerowindex%>,'<%=rowsum%>','<%=recordchoicerowindex%>');setChange(<%=rowsum%>)"></BUTTON>
							<span id="mypath_<%=rowsum%>_<%=recordchoicerowindex%>"><%=RecordSet1.getString("docPath")%></span>
						  	<input type=hidden id="pathcategory_<%=rowsum%>_<%=recordchoicerowindex%>" name="pathcategory_<%=rowsum%>_<%=recordchoicerowindex%>" value="<%=RecordSet1.getString("docPath")%>">
						  	<input type=hidden id="maincategory_<%=rowsum%>_<%=recordchoicerowindex%>" name="maincategory_<%=rowsum%>_<%=recordchoicerowindex%>" value="<%=RecordSet1.getString("docCategory")%>"></div></td>
						<td><div>
							<button type='button' class="Browser" onClick="onShowChildSelectItem(childItemSpan_<%=rowsum%>_<%=recordchoicerowindex%>,childItem_<%=rowsum%>_<%=recordchoicerowindex%>,'_<%=rowsum%>')" id="selectChildItem_<%=rowsum%>_<%=recordchoicerowindex%>" name="selectChildItem_<%=rowsum%>_<%=recordchoicerowindex%>"></BUTTON>
							<input type="hidden" id="childItem_<%=rowsum%>_<%=recordchoicerowindex%>" name="childItem_<%=rowsum%>_<%=recordchoicerowindex%>" value="<%=childitemid_tmp%>" >
							<span id="childItemSpan_<%=rowsum%>_<%=recordchoicerowindex%>" name="childItemSpan_<%=rowsum%>_<%=recordchoicerowindex%>"><%=childitemidStr%></span>
						</div></td>
				  		<td><div><input type="checkbox" name="cancel_<%=rowsum%>_<%=recordchoicerowindex%>_name" onchange='setChange(<%=rowsum%>)'  value="<%=RecordSet1.getString("cancel")%>" onclick="if(this.checked){this.value=1;}else{this.value=0}" <%if(RecordSet1.getString("cancel").equals("1")){%>checked<%}%>></div></td> 
					</tr>
				  		<%}%>
				  		<input type="hidden" value="<%=recordchoicerowindex%>" name="choiceRows_<%=rowsum%>">
				  	</table>
				  </div>
				  
          <div id="div6_<%=rowsum%>" <%if(fieldhtmltype.equals("6")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
				  	<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
					  <select class='InputStyle' name='uploadtype_<%=rowsum%>' <%if(!canChange){%>disabled<%}%> onChange="onuploadtype(this, <%=rowsum%>);setChange(<%=rowsum%>)">
					  	<option value='1' <%if(type.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%></option>
					  	<option value='2' <%if(type.equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%></option>
					  </select>
					  <%if(!canChange){%><input type="hidden" value="<%=type%>" name="uploadtype_<%=rowsum%>"><%}%>
					</div>
					<div id="div6_1_<%=rowsum%>" <%if(fieldhtmltype.equals("6")&&type.equals("2")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
						<%=SystemEnv.getHtmlLabelName(24030,user.getLanguage())%>
						<input   type=input class="InputStyle" size=6 maxlength=3 name="strlength_<%=rowsum%>" onchange='setChange(<%=rowsum%>)' onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkPlusnumber1(this)' value="<%=textheight%>">
						<%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%>
						<input   type=input class="InputStyle" size=6 maxlength=4 name="imgwidth_<%=rowsum%>"  onchange='setChange(<%=rowsum%>)' onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkPlusnumber1(this)' value="<%=imgwidth%>">
						<%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%>
						<input   type=input class="InputStyle" size=6 maxlength=4 name="imgheight_<%=rowsum%>" onchange='setChange(<%=rowsum%>)' onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkPlusnumber1(this)' value="<%=imgheight%>">
					</div>
                
				<div id="div7_<%=rowsum%>" <%if(fieldhtmltype.equals("7")){%>style="display:inline"<%}else{%>style="display:none"<%}%>>
				  	<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
					  <select class='InputStyle' name='specialfield_<%=rowsum%>' <%if(!canChange){%>disabled<%}%> onChange="specialtype(this, <%=rowsum%>);setChange(<%=rowsum%>)">
					  	<option value='1' <%if(type.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%></option>
					  	<option value='2' <%if(type.equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%></option>
					  </select>
					  <%if(!canChange){%><input type="hidden" value="<%=type%>" name="specialfield_<%=rowsum%>"><%}%>
				</div>
				  <%
				  String displayname = "";
				  String linkaddress = "";
				  String descriptivetext = "";
				  if(fieldhtmltype.equals("7")){
				     rs.executeSql("select * from workflow_specialfield where fieldid = " + fieldid + " and isbill = 1");
				     rs.next();
				     displayname = rs.getString("displayname");
				     linkaddress = rs.getString("linkaddress");
				     descriptivetext = rs.getString("descriptivetext");
				  }
				  %>
			  <div id="div7_1_<%=rowsum%>" <%if(fieldhtmltype.equals("7")&&type.equals("1")){%>style="display:inline"<%}else{%>style="display:none"<%}%>><table width="100%"><tr><td width="100%"><%=SystemEnv.getHtmlLabelName(606,user.getLanguage())%>　　<input class=inputstyle type=text name=displayname_<%=rowsum%> id=displayname_<%=rowsum%> size=25 value="<%=displayname%>" maxlength=1000 onchange='setChange(<%=rowsum%>)'>　</td></tr><tr><td><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%>　<input class=inputstyle type=text size=25 name=linkaddress_<%=rowsum%> id=linkaddress_<%=rowsum%> value="<%=linkaddress%>" maxlength=1000 onchange='setChange(<%=rowsum%>)'><br><%=SystemEnv.getHtmlLabelName(18391,user.getLanguage())%></td></tr></table></div>	
　　		<div id="div7_2_<%=rowsum%>" <%if(fieldhtmltype.equals("7")&&!type.equals("1")){%>style="display:inline"<%}else{%>style="display:none"<%}%>><table width="100%"><tr><td width="12%"><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%>　</td><td><textarea class='inputstyle' style='width:88%;height:100px' name=descriptivetext_<%=rowsum%> id=descriptivetext_<%=rowsum%> onchange='setChange(<%=rowsum%>)'><%=Util.StringReplace(descriptivetext,"<br>","\n")%></textarea></td></tr></table></div>				  
				 
				  				  		    		
		    </td>
		    <td NOWRAP >
          <input class='InputStyle' type='text' size=10 maxlength=7 name='itemDspOrder_<%=rowsum%>'  value = '<%=dsporder%>' onKeyPress='ItemNum_KeyPress("itemDspOrder_<%=rowsum%>")' onchange='checknumber("itemDspOrder_<%=rowsum%>");checkDigit("itemDspOrder_<%=rowsum%>",15,2);setChange(<%=rowsum%>)' style='text-align:right;'   >
    		</td>
		</tr>
<%	
				if(trClass.equals("DataLight")){
					trClass="DataDark";
			    }else{
					trClass="DataLight";
				}
				rowsum++;
			}
%>


	  </table>
  <TABLE class=viewform>
		<TBODY>
	    <TR>
	      <td>
		  		<button type='button' class=btnNew onClick="addDetailTable()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18903,user.getLanguage())%></button>
	      </td>
	    </TR>
	    <TR height=10><td></td></TR>
	    <%
	    int tempint = 0;
	   	RecordSet.executeSql("select * from Workflow_billdetailtable where billid="+formid+" order by orderid");
	   	while(RecordSet.next()){
	   		tempint++;
	   		String detailtablename = RecordSet.getString("tablename");
	   		String tableNumber = RecordSet.getString("orderid");
	    %>
	    <TR>
	    	<td>
	    		<table id="detailTable_<%=tableNumber%>" class=ListStyle cols=5  border=0 cellspacing=1>
	    				<input type="hidden" value="" name="detaildelids_<%=tableNumber%>">
							<input type="hidden" value="" name="detailChangeRowIndexs_<%=tableNumber%>">
							<tr>
								<td colspan=2><b><%=SystemEnv.getHtmlLabelName(18550,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())+tempint%></b></td>
								<td colspan=3 align="right">
									<button type='button' class=btn onClick="addDetailRow(<%=tableNumber%>)"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>
									<button type='button' class=btn onClick="deleteDetailRow(<%=tableNumber%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
									<button type='button' class=btn onClick="copyDetailRow(<%=tableNumber%>)"><%=SystemEnv.getHtmlLabelName(77,user.getLanguage())%></button>
								</td>
							</tr>
							<tr style='height:1px;'><td colspan=5 class=line1 colSpan=2 style="padding: 0px;"></td></tr>
							<tr class=header>
								<td NOWRAP width='5%'><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
								<td NOWRAP width='20%'><%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
								<td NOWRAP width='30%'><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></td>
								<td NOWRAP width='45%'><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></td>
								<td NOWRAP width='10%'><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></td> 
						</tr>
	    			<%
	    			String dbdetailfieldnamesForCompare = ",";
	    			String trDetailClass="DataLight";
	    			int detailrowsum=0;
	    			
						String detailfieldname = "";//数据库字段名称
			  		int detailfieldlabel = 0;//字段显示名标签id
			  		String detailfielddbtype = "";//字段数据库类型
			  		String detailfieldhtmltype = "";//字段页面类型
			  		String detailtype = "";//字段详细类型
			  		String detaildsporder = "";//显示顺序
  		
	    			RecordSet1.executeSql("select * from workflow_billfield where billid="+formid+" and viewtype=1 and detailtable='"+detailtablename+"' order by dsporder,id");
	    			while(RecordSet1.next()){
	    				detailrowsum++;
							String detailfieldid = RecordSet1.getString("id");
							detailfieldname = RecordSet1.getString("fieldname");
							dbdetailfieldnamesForCompare += detailfieldname.toUpperCase()+",";
							detailfieldlabel = RecordSet1.getInt("fieldlabel");
							String detailfieldlabelname = SystemEnv.getHtmlLabelName(detailfieldlabel,user.getLanguage());
							detailfielddbtype = RecordSet1.getString("fielddbtype");
							String detailfieldlength = "";
							detailfieldhtmltype = RecordSet1.getString("fieldhtmltype");
							detailtype = RecordSet1.getString("type");
							if(detailfieldhtmltype.equals("1")&&detailtype.equals("1")){
								detailfieldlength = detailfielddbtype.substring(detailfielddbtype.indexOf("(")+1,detailfielddbtype.indexOf(")"));
							}
							detaildsporder = Util.null2String(RecordSet1.getString("dsporder"));
							int childfieldid_tmp = Util.getIntValue(RecordSet1.getString("childfieldid"));
							String childfieldStr = "";
							Hashtable childItem_hs = new Hashtable();
							if(childfieldid_tmp > 0){
								rs_child.execute("select fieldlabel from workflow_billfield where id="+childfieldid_tmp);
								if(rs_child.next()){
									int childfieldlabel = rs_child.getInt("fieldlabel");
									childfieldStr = SystemEnv.getHtmlLabelName(childfieldlabel, user.getLanguage());
								}
								rs_child.execute("select * from workflow_SelectItem where isbill=1 and fieldid="+childfieldid_tmp);
								while(rs_child.next()){
									int selectvalue_tmp = Util.getIntValue(rs_child.getString("selectvalue"), -1);
									String selectname_tmp = Util.null2String(rs_child.getString("selectname"));
									childItem_hs.put("item_"+selectvalue_tmp, selectname_tmp);
								}
							}
              String para = detailfieldname+"+1+"+detailfieldhtmltype+"+"+detailtablename+"+"+formid;
              String canDeleteCheckBox = FormFieldTransMethod.getCanCheckBox(para);
	    			%>
	    				<TR class=<%=trDetailClass%>>
	    					<td  height="23" >
							    <input type='checkbox' name='check_select_detail_<%=tableNumber%>' value="<%=detailfieldid%>_<%=detailrowsum%>" <%if(canDeleteCheckBox.equals("false")){%>disabled<%}%> >
							    <input type='hidden' name='modifyflag_<%=tableNumber%>_<%=detailrowsum%>' value="<%=detailfieldid%>">
						    </td>
								<td NOWRAP >
								  <%if(!canChange){%>
								  <input class=Inputstyle type=hidden maxlength=30 name="itemDspName_detail<%=tableNumber%>_<%=detailrowsum%>" style="width:90%"  value="<%=Util.toScreen(detailfieldname,user.getLanguage())%>" >
								  <span id="itemDspName_detail<%=tableNumber%>_<%=detailrowsum%>_span"><%=Util.toScreen(detailfieldname,user.getLanguage())%></span>
								  <%}else{%>
								  <input class=Inputstyle type=text maxlength=30 name="itemDspName_detail<%=tableNumber%>_<%=detailrowsum%>" style="width:90%"  value="<%=Util.toScreen(detailfieldname,user.getLanguage())%>" onchange="checkinput('itemDspName_detail<%=tableNumber%>_<%=detailrowsum%>','itemDspName_detail<%=tableNumber%>_<%=detailrowsum%>_span');setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)">
								  <span id="itemDspName_detail<%=tableNumber%>_<%=detailrowsum%>_span"></span>
								  <%}%>
								  <input type=hidden name="olditemDspName_detail<%=tableNumber%>_<%=detailrowsum%>" value="<%=Util.toScreen(detailfieldname,user.getLanguage())%>">
								</td>			
								<td NOWRAP >
								  <input class=Inputstyle type=text name="itemFieldName_detail<%=tableNumber%>_<%=detailrowsum%>" style="width:90%"   value="<%=Util.toScreen(detailfieldlabelname,user.getLanguage())%>"   onchange="checkinput('itemFieldName_detail<%=tableNumber%>_<%=detailrowsum%>','itemFieldName_detail<%=tableNumber%>_<%=detailrowsum%>_span');setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)">
								  <span id="itemFieldName_detail<%=tableNumber%>_<%=detailrowsum%>_span"></span>
								</td>
								<td NOWRAP >
								  <select class='InputStyle' name="itemFieldType_<%=tableNumber%>_<%=detailrowsum%>" <%if(!canChange){%>disabled<%}%> onChange="onChangDetailItemFieldType(<%=tableNumber%>,<%=detailrowsum%>);setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)">
								  	<option value='1' <%if(detailfieldhtmltype.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%></option>
								  	<option value='2' <%if(detailfieldhtmltype.equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%></option>
								  	<option value='3' <%if(detailfieldhtmltype.equals("3")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></option>
								  	<option value='4' <%if(detailfieldhtmltype.equals("4")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%></option>
								  	<option value='5' <%if(detailfieldhtmltype.equals("5")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></option>
								  </select>
								  <%if(!canChange){%><input type="hidden" value="<%=detailfieldhtmltype%>" name="itemFieldType_<%=tableNumber%>_<%=detailrowsum%>"><%}%>
								  
								  <div id="detail_div1_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("1")){%>style='display:inline'<%}else{%>style='display:none'<%}%>>
								  	<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
									  <select class='InputStyle' name="documentType_<%=tableNumber%>_<%=detailrowsum%>" <%if(!canChange){%>disabled<%}%> onChange="onChangDetailType(<%=tableNumber%>,<%=detailrowsum%>);setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)">
									  	<option value='1' <%if(detailtype.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
									  	<option value='2' <%if(detailtype.equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
									  	<option value='3' <%if(detailtype.equals("3")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
									  	<option value='4' <%if(detailtype.equals("4")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%></option>
									  	<option value='5' <%if(detailtype.equals("5")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%></option>
									  </select>
									  <%if(!canChange){%><input type="hidden" value="<%=detailtype%>" name="documentType_<%=tableNumber%>_<%=detailrowsum%>"><%}%>
									</div>
									  <%
									      int maxlength = 0;
									      if(isoracle){
									          rs.executeSql("select max(lengthb("+detailfieldname+")) from "+detailtablename);
									          if(rs.next()) maxlength = Util.getIntValue(rs.getString(1),0);
									      }else{
									          rs.executeSql("select max(datalength("+detailfieldname+")) from "+detailtablename);
									          if(rs.next()) maxlength = Util.getIntValue(rs.getString(1),0);
									      }
									      //out.println("maxlength=="+maxlength);
									  %>
									<div id="detail_div1_1_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("1")&&detailtype.equals("1")){%>style='display:inline'<%}else{%>style='display:none'<%}%>>
								  		<%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>
									  	<input class='InputStyle' type='text' size=3 maxlength=3 value='<%=detailfieldlength%>' id='itemFieldScale1_<%=tableNumber%>_<%=detailrowsum%>' name='itemFieldScale1_<%=tableNumber%>_<%=detailrowsum%>' onKeyPress='ItemPlusCount_KeyPress()' onchange='setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)' onblur='checkPlusnumber1(this);checklength(itemFieldScale1_<%=tableNumber%>_<%=detailrowsum%>,itemFieldScale1span_<%=tableNumber%>_<%=detailrowsum%>);checkcount1(itemFieldScale1_<%=tableNumber%>_<%=detailrowsum%>);checkmaxlength(<%=maxlength%>,itemFieldScale1_<%=tableNumber%>_<%=detailrowsum%>)' style='text-align:right;'><span id=itemFieldScale1span_<%=tableNumber%>_<%=detailrowsum%>><%if(detailfieldlength.equals("")){%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></span>
									</div>
									<div id="detail_div1_3_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("1")&&detailtype.equals("3")){%>style='display:inline'<%}else{%>style='display:none'<%}%>>
										<%
											int decimaldigits = 2;
											if(detailfieldhtmltype.equals("1")&&detailtype.equals("3")){
												int digitsIndex = detailfielddbtype.indexOf(",");
									        	if(digitsIndex > -1){
									        		decimaldigits = Util.getIntValue(detailfielddbtype.substring(digitsIndex+1, detailfielddbtype.length()-1), 2);
									        	}else{
									        		decimaldigits = 2;
									        	}
											}
										%>
								  		<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>
										<%if(!canChange){%>
											<input type="hidden" id="decimaldigits_<%=tableNumber%>_<%=detailrowsum%>" name="decimaldigits_<%=tableNumber%>_<%=detailrowsum%>" value="<%=decimaldigits%>">
											<select id="decimaldigitshidden_<%=tableNumber%>_<%=detailrowsum%>" name="decimaldigitshidden_<%=tableNumber%>_<%=detailrowsum%>" size="1" disabled>
										<%}else{%>
											<select id="decimaldigits_<%=tableNumber%>_<%=detailrowsum%>" name="decimaldigits_<%=tableNumber%>_<%=detailrowsum%>" size="1">
										<%}%>
												<option value="1" <%if(decimaldigits==1){out.print("selected");}%>>1</option>
												<option value="2" <%if(decimaldigits==2){out.print("selected");}%>>2</option>
												<option value="3" <%if(decimaldigits==3){out.print("selected");}%>>3</option>
												<option value="4" <%if(decimaldigits==4){out.print("selected");}%>>4</option>
											</select>
									</div>
									<div id="detail_div2_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("2")){%>style='display:inline'<%}else{%>style='display:none'<%}%>>
								  	<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>
								  	<input class='InputStyle' type='text' size=4 maxlength=2 value='<%=RecordSet1.getString("textheight")%>' id='textheight_<%=tableNumber%>_<%=detailrowsum%>' name='textheight_<%=tableNumber%>_<%=detailrowsum%>' onKeyPress='ItemPlusCount_KeyPress()' onchange='setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)' onblur='checkPlusnumber1(this);checkcount1(textheight_<%=tableNumber%>_<%=detailrowsum%>)' style='text-align:right;'>
								  	<%=SystemEnv.getHtmlLabelName(222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15449,user.getLanguage())%>
								  	<input type='checkbox' <%if(detailtype.equals("2")){%> checked <%}%> <%if(!canChange){%>disabled<%}%>>
								  	<%if(!canChange){%><input type="hidden" value="<%=detailtype%>" name="htmledit_<%=tableNumber%>_<%=detailrowsum%>"><%}%>
								  </div>
								  
								  <div id="detail_div3_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("3")){%>style='display:inline'<%}else{%>style='display:none'<%}%>>
								  	<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
								  	<select class='InputStyle' name="broswerType_<%=tableNumber%>_<%=detailrowsum%>" <%if(!canChange){%>disabled<%}%> onChange='onChangDetailBroswerType(<%=tableNumber%>,<%=detailrowsum%>);setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)'>
								  		<%while(browserComInfo.next()){
								  				if("1".equals(IsOpetype)&&("224".equals(browserComInfo.getBrowserid()))||"225".equals(browserComInfo.getBrowserid())){
								  				 		continue;
								  				 }
								  				 
								  				 if("0".equals(IsOpetype)&&("226".equals(browserComInfo.getBrowserid()))||"227".equals(browserComInfo.getBrowserid())){
								  				 		continue;
								  				 }
								  			%>
								  			<option value="<%=browserComInfo.getBrowserid()%>" <%if(detailtype.equals(""+browserComInfo.getBrowserid())){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(Util.getIntValue(browserComInfo.getBrowserlabelid(),0),user.getLanguage())%></option>
								  		<%}%>
								  	</select>
								  	<%if(!canChange){%><input type="hidden" value="<%=detailtype%>" name="broswerType_<%=tableNumber%>_<%=detailrowsum%>" id="broswerType_<%=tableNumber%>_<%=detailrowsum%>"><%}%>
								  </div>
								  
								  <div id="detail_div3_0_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("3")&&(detailtype.equals("161")||detailtype.equals("162")||detailtype.equals("224")||detailtype.equals("225")||detailtype.equals("226")||detailtype.equals("227"))&&detailfielddbtype.equals("")){%>style='display:inline'<%}else{%>style='display:none'<%}%>>
								  	<span><IMG src='/images/BacoError.gif' align=absMiddle></span>
								  </div>
								  
								  <div id="detail_div3_1_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("3")&&(detailtype.equals("161")||detailtype.equals("162"))){%>style='display:inline'<%}else{%>style='display:none'<%}%>>
								  		<select class='InputStyle' name='definebroswerType_<%=tableNumber%>_<%=detailrowsum%>' <%if(!canChange){%>disabled<%}else{%>onChange='setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)'<%}%>>
								  			<%
                      	List l=StaticObj.getServiceIds(Browser.class);
                      	for(int j=0;j<l.size();j++){
                      	%>
                      	<option value='<%=l.get(j)%>' <%if(detailfielddbtype.equals(""+l.get(j))){%>selected<%}%>><%=l.get(j)%></option>
								  			<%}%>
								  		</select>
								  		<%if(!canChange){%><input type="hidden" value="<%=detailfielddbtype%>" name="definebroswerType_<%=tableNumber%>_<%=detailrowsum%>"><%}%>
								  </div>
								  
								  <div id="detail_div3_4_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("3")&&(detailtype.equals("224")||detailtype.equals("225"))){%>style='display:inline'<%}else{%>style='display:none'<%}%>>
								  		<select class='InputStyle' name='sapbrowser_<%=tableNumber%>_<%=detailrowsum%>' <%if(!canChange){%>disabled<%}%> onchange="setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)">
								  			<%
                      						List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
                      						for(int j=0;j<AllBrowserId.size();j++){
                      						%>
                      						<option value='<%=AllBrowserId.get(j)%>' <%if(detailfielddbtype.equals(""+AllBrowserId.get(j))){%>selected<%}%>><%=AllBrowserId.get(j)%></option>
								  			<%}%>
								  		</select>
								  		<%if(!canChange){%><input type="hidden" value="<%=detailfielddbtype%>" name="sapbrowser_<%=tableNumber%>_<%=detailrowsum%>"><%}%>
								  </div>
								  <!-- zzl--start -->
									<div id="detail_div3_5_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("3")&&(detailtype.equals("226")||detailtype.equals("227"))){%>style='display:inline'<%}else{%>style='display:none'<%}%>> 
								  		<button type=button  class='browser' name='newsapbrowser_<%=tableNumber%>_<%=detailrowsum%>' id='newsapbrowser_<%=tableNumber%>_<%=detailrowsum%>'  onclick="OnNewChangeSapBroswerTypeDetails('<%=tableNumber%>','<%=detailrowsum%>')"></button>
								  		 <span id='showinner_<%=tableNumber%>_<%=detailrowsum%>'><%if(detailtype.equals("226")||detailtype.equals("227")){out.print(detailfielddbtype);}%></span>
										<span id='showimg_<%=tableNumber%>_<%=detailrowsum%>'><%if(detailtype.equals("226")||detailtype.equals("227")){out.print("");}else{out.print("<IMG src='/images/BacoError.gif' align=absMiddle>");}%></span>
								  		<input type="hidden" value="<%if(type.equals("226")||type.equals("227")){out.print(detailfielddbtype);}%>" name='showvalue_<%=tableNumber%>_<%=detailrowsum%>' id='showvalue_<%=tableNumber%>_<%=detailrowsum%>' >
									</div>
								<!-- zzl--end -->
					
								  <div id="detail_div3_2_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("3")&&(detailtype.equals("165")||detailtype.equals("166")||detailtype.equals("167")||detailtype.equals("168"))){%>style='display:inline'<%}else{%>style='display:none'<%}%>>
								  		<%=SystemEnv.getHtmlLabelName(19340,user.getLanguage())%>
								  		<select class='InputStyle' name='decentralizationbroswerType_<%=tableNumber%>_<%=detailrowsum%>' <%if(!canChange){%>disabled<%}%>>
								  			<option value=1 <%if(RecordSet1.getString("textheight").equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18916,user.getLanguage())%></option>
								  			<option value=2 <%if(RecordSet1.getString("textheight").equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18919,user.getLanguage())%></option>
								  		</select>
								  		<%if(!canChange){%><input type="hidden" value="<%=RecordSet1.getString("textheight")%>" name="decentralizationbroswerType_<%=tableNumber%>_<%=detailrowsum%>"><%}%>
								  </div>								  
								  
								  <div id="detail_div5_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("5")){%>style='display:inline'<%}else{%>style='display:none'<%}%>>
								  	<button type='button' class=btn id=btnaddRow name=btnaddRow onclick='addDetailTableRow(<%=tableNumber%>,<%=detailrowsum%>);setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)'><%=SystemEnv.getHtmlLabelName(15443,user.getLanguage())%></BUTTON>
								  	<button type='button' class=btn id=btnsubmitClear name=btnsubmitClear onclick='submitDetailClear(<%=tableNumber%>,<%=detailrowsum%>);setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)'><%=SystemEnv.getHtmlLabelName(15444,user.getLanguage())%></BUTTON>
					<span><%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%>&nbsp;</span>
  	   		        <button type='button' id='showChildFieldBotton' class=Browser onClick="onShowChildField(childfieldidSpan_detail<%=tableNumber%>_<%=detailrowsum%>,childfieldid_detail<%=tableNumber%>_<%=detailrowsum%>,'_detail<%=tableNumber%>_<%=detailrowsum%>');setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)"></BUTTON>
  	   		        <span id='childfieldidSpan_detail<%=tableNumber%>_<%=detailrowsum%>'><%=childfieldStr%></span>
  	   		        <input type='hidden' value='<%=childfieldid_tmp%>' name='childfieldid_detail<%=tableNumber%>_<%=detailrowsum%>' id='childfieldid_detail<%=tableNumber%>_<%=detailrowsum%>'>
  	   		      	</div>
  	   		      	<div id="detail_div5_1_<%=tableNumber%>_<%=detailrowsum%>" <%if(detailfieldhtmltype.equals("5")){%>style='display:inline'<%}else{%>style='display:none'<%}%>>
								  	<table class='ViewForm' id='choiceTable_<%=tableNumber%>_<%=detailrowsum%>' cols=7 border=0>
										<COL width="3%">
										<COL width="20%">
										<COL width="20%">
										<COL width="15%">
										<COL width="16%">
										<COL width="26%">
										<col width=10%>
										<tr>
											<td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
											<td><%=SystemEnv.getHtmlLabelName(15442,user.getLanguage())%></td>
											<td><%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%></td>
											<td><%=SystemEnv.getHtmlLabelName(19206,user.getLanguage())%></td>
											<td><%=SystemEnv.getHtmlLabelName(19207,user.getLanguage())%></td>
											<td><%=SystemEnv.getHtmlLabelName(22663,user.getLanguage())%></td>
											<td><%=SystemEnv.getHtmlLabelName(22151,user.getLanguage())%></td>
										</tr>
								  		<%
								  		int recordchoicerowindex = 0;
								  		RecordSet2.executeSql("select * from workflow_SelectItem where isbill=1 and fieldid="+detailfieldid+" order by selectvalue ");
								  		while(RecordSet2.next()){
								  		recordchoicerowindex++;
										String childitemid_tmp = Util.null2String(RecordSet2.getString("childitemid"));
										String childitemidStr = "";
										int isAccordToSubCom_tmp = Util.getIntValue(RecordSet2.getString("isaccordtosubcom"));
										String isAccordToSubCom_Str = "";
										if(isAccordToSubCom_tmp == 1){
											isAccordToSubCom_Str = " checked ";
										}
										String[] childitemid_sz = Util.TokenizerString2(childitemid_tmp, ",");
										for(int cx=0; (childitemid_sz!=null && cx<childitemid_sz.length); cx++){
											String childitemidTemp = Util.null2String(childitemid_sz[cx]);
											String childitemnameTemp = Util.null2String((String)childItem_hs.get("item_"+childitemidTemp));
											if(!"".equals(childitemnameTemp)){
												childitemidStr += (childitemnameTemp+",");
											}
										}
										if(!"".equals(childitemidStr)){
											childitemidStr = childitemidStr.substring(0, childitemidStr.length()-1);
										}
								  		%>
								  	<tr>
								  		<td><div><input type="checkbox" name="chkDetailField" index="<%=recordchoicerowindex%>" value="0"></div></td>
								  		<td><div><input class="InputStyle" value="<%=RecordSet2.getString("selectname")%>" type="text" size="10" name="field_<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>_name" style="width=90%" onchange="checkinput('field_<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>_name','field_<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>_span');setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)">
								  			<span id="field_<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>_span"><%if(RecordSet2.getString("selectname").equals("")){%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></span></div></td>
								  		<td><div><input class="InputStyle" type="text" size="4" value = "<%=RecordSet2.getString("listorder")%>" name="field_count_<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>_name" style="width=90%" onchange="setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)" onKeyPress="ItemNum_KeyPress('field_count_<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>_name')"></div></td>
								  		<td><div><input type="checkbox" name="field_checked_<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>_name" onchange='setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)' onclick="if(this.checked){this.value=1;}else{this.value=0}" <%if(RecordSet2.getString("isdefault").equals("y")){%>checked<%}%> value="1"></div></td>
								  			
								  		<td><div><input type="hidden" id="selectvalue<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>" name="selectvalue<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>" value="<%=RecordSet2.getString("selectvalue")%>">
											<input type='checkbox' name='isAccordToSubCom<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>' onchange='setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)' value='1' <%=isAccordToSubCom_Str%>><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;
											<button type='button' class=Browser name="selectCategory" onClick="onShowDetailCatalog(mypath_<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>,<%=tableNumber%>,<%=detailrowsum%>,<%=recordchoicerowindex%>);setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)"></BUTTON>
											<span id="mypath_<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>"><%=RecordSet2.getString("docPath")%></span>
										  	<input type=hidden id="pathcategory_<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>" name="pathcategory_<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>" value="<%=RecordSet2.getString("docPath")%>">
										  	<input type=hidden id="maincategory_<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>" name="maincategory_<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>" value="<%=RecordSet2.getString("docCategory")%>"></div></td>
										<td><div>
										  <button type='button' class="Browser" onClick="onShowChildSelectItem(childItemSpan_<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>,childItem_<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>,'_detail<%=tableNumber%>_<%=detailrowsum%>')" id="selectChildItem_<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>" name="selectChildItem_<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>"></BUTTON>
											<input type="hidden" id="childItem_<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>" name="childItem_<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>" value="<%=childitemid_tmp%>" >
											<span id="childItemSpan_<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>" name="childItemSpan_<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>"><%=childitemidStr%></span>
										</div></td>
								  		<td><div><input type="checkbox" name="cancel_<%=tableNumber%>_<%=detailrowsum%>_<%=recordchoicerowindex%>_name" onchange='setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)' value="<%=RecordSet2.getString("cancel")%>" onclick="if(this.checked){this.value=1;}else{this.value=0}" <%if(RecordSet2.getString("cancel").equals("1")){%>checked<%}%>></div></td>  
								  	</tr>
								  		<%}%>
								  		<input type="hidden" value="<%=recordchoicerowindex%>" name="choiceRows_<%=tableNumber%>_<%=detailrowsum%>">
								  	</table>
								  </div>
								  
								  
						    </td>
						    <td NOWRAP >
				          <input class='InputStyle' type='text' size=10 maxlength=7 name='itemDspOrder_detail<%=tableNumber%>_<%=detailrowsum%>'  value = '<%=detaildsporder%>' onKeyPress='ItemNum_KeyPress("itemDspOrder_detail<%=tableNumber%>_<%=detailrowsum%>")' onchange='checknumber("itemDspOrder_detail<%=tableNumber%>_<%=detailrowsum%>");checkDigit("itemDspOrder_detail<%=tableNumber%>_<%=detailrowsum%>",15,2);setChangeDetail(<%=tableNumber%>,<%=detailrowsum%>)' style='text-align:right;'   >
				    		</td>
	    				</TR>
	    			<%
	    			if(trDetailClass.equals("DataLight")){
							trDetailClass="DataDark";
					  }else{
							trDetailClass="DataLight";
						}
	    			}%>
	    			<input type="hidden" value="<%=dbdetailfieldnamesForCompare%>" name="dbdetailfieldnamesForCompare_<%=tableNumber%>">
	    		</table>
	    	</td>
	    </TR>
	    <%}%>
	    <TR>
	    	<td>
	    		<table id="addDetail" class=ListStyle cols=5  border=0 cellspacing=1>
	    		</table>
	    	</td>
	    </TR>
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

</TBODY>
</table>