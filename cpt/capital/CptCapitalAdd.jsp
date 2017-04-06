<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<% if(!(user.getLogintype()).equals("1")) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<% 
//modify under popedom by dongping for TD559
if(!HrmUserVarify.checkUserRight("Capital:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />

<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
Calendar today = Calendar.getInstance();
	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

boolean hasFF = true;
/*缺省币种*/
String defcurrenyid ="";
RecordSet.executeProc("FnaCurrency_SelectByDefault","");
if(RecordSet.next()){
 defcurrenyid = RecordSet.getString(1);
}
RecordSet.executeProc("Base_FreeField_Select","cp");
if(RecordSet.getCounts()<=0)
	hasFF = false;
else
	RecordSet.first();
	
int blongsubcompany = Util.getIntValue(request.getParameter("blongsubcompany"));//所属分部

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(1509,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:submitData(this),_TOP} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM name=frmain id=frmain action="CptCapitalOperation.jsp" method=post enctype="multipart/form-data" >
<input type=hidden name=operation value="addcapital">
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
				<COLGROUP> <COL width="49%"> <COL width=10> <COL width="49%"> <TBODY> 
				<TR> 
				  <TD vAlign=top> 
					<TABLE width="100%">
					  <COLGROUP> <COL width=30%> <COL width=70%><TBODY> 
					  <TR class=Title> 
						<TH colSpan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
					  </TR>
					  <TR class= Spacing style="height:1px;"> 
						<TD class=Line1 colSpan=2></TD>
					  </TR>
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
						<td class=Field> 
						  <input class=InputStyle maxlength=60 name="name" size=30 
						onChange='checkinput("name","nameimage")'>
						  <span id=nameimage><img src="/images/BacoError.gif" align=absMiddle></span></td>
					  </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(1507,user.getLanguage())%></td>
						<td class=Field><button type=button  class=Browser id=SelectResourceID onClick="onShowResourceID()"></button> 
						  <span 
						id=resourceidspan><IMG src='/images/BacoError.gif' align=absMiddle></span> 
						  <input class=InputStyle id=resourceid type=hidden name=resourceid>
						</td>
					  </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  
					  <!-- 所属分部 -->
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></td>
						<td class=Field><button type=button  class=Browser onClick="onShowSubcompany('blongsubcompanyspan', 'blongsubcompany')"></button> 
						  <span id=blongsubcompanyspan><IMG src='/images/BacoError.gif' align=absMiddle><%=SubCompanyComInfo.getSubCompanyname(String.valueOf(blongsubcompany))%>
						  </span> 
						  <input class=InputStyle id=blongsubcompany type=hidden name=blongsubcompany value="<%=blongsubcompany%>">
						</td>
					  </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>

					  <!--tr> 
						<td><%=SystemEnv.getHtmlLabelName(120,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></td>
						<td class=Field> 
						  <input class=InputStyle maxlength=3 size=5 
						name=seclevel onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("seclevel");checkinput("seclevel","seclevelimage")' value="10">
						  <span id=seclevelimage></span> </td>
					  </tr-->
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(1363,user.getLanguage())%></td>
						<td class=Field> 
						  <input type=checkbox  name="sptcount" value="1">
						</td>
					  </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  </TBODY> 
					</TABLE>
				  </TD>
				  <TD vAlign=top width="100%"> 
					<TABLE width="100%">
					  <COLGROUP> <COL width=30%> <COL width=70%> <TBODY> 
					  <TR class=Title> 
						<TH colSpan=2>&nbsp;</TH>
					  </TR>
					  <TR class=Spacing style="height:1px;"> 
						<TD class=Line1 colSpan=2></TD>
					  </TR>
					  <TR> 
						<TD><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></TD>
						<TD class=Field> 
						  <input type="file" name="capitalimage" class="InputStyle">
						</TD>
					  </TR>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  </TBODY> 
					</TABLE>
				  </TD>
				</TR>
				<TR> 
				  <TD vAlign=top>
					<table width="100%">
					  <colgroup> <col width=30%> <col width=70%> <tbody> 
					  <tr class=Title> 
						<th colspan=2 ><%=SystemEnv.getHtmlLabelName(410,user.getLanguage())%></th>
					  </tr>
					  <tr class=Spacing style="height:1px;"> 
						<td class=Line1 colspan=2></td>
					  </tr>
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(904,user.getLanguage())%></td>
						<td class=Field> 
						  <input class=InputStyle maxlength=60 size=30 name="capitalspec" >
						</td>
					  </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(603,user.getLanguage())%></td>
						<td class=Field> 
						  <input class=InputStyle maxlength=30 size=30 name="capitallevel" >
						</td>
					  </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(1364,user.getLanguage())%></td>
						<td class=Field> 
						  <input class=InputStyle maxlength=100 size=30 name="manufacturer" >
						</td>
					  </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(703,user.getLanguage())%></td>
						<td class=Field> <button type=button  class=Browser onClick="onShowCapitaltypeid()"></button> 
						  <span id=capitaltypeidspan><IMG src='/images/BacoError.gif' align=absMiddle></span> 
						  <input type=hidden name=capitaltypeid>
						</td>
					  </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></td>
						<td class=Field> <button type=button  class=Browser onClick="onShowCapitalgroupid()"></button> 
						  <span id=capitalgroupidspan><img src="/images/BacoError.gif" align=absMiddle></span> 
						  <input type=hidden name=capitalgroupid>
						</td>
					  </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(138,user.getLanguage())%></td>
						<td class=Field> <button type=button  class=Browser onClick="onShowCustomerid()"></button> 
						  <span id=customeridspan></span> 
						  <input type=hidden name=customerid>
						</td>
					  </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></td>
						<td class=Field> 
						  <select class=InputStyle id=attribute name=attribute>
							<option value=1 selected><%=SystemEnv.getHtmlLabelName(1367,user.getLanguage())%></option>
							<option value=0><%=SystemEnv.getHtmlLabelName(1366,user.getLanguage())%></option>
							<option value=2><%=SystemEnv.getHtmlLabelName(1368,user.getLanguage())%></option>
							<option value=3><%=SystemEnv.getHtmlLabelName(1369,user.getLanguage())%></option>
							<option value=4><%=SystemEnv.getHtmlLabelName(60,user.getLanguage())%></option>
							<option value=5><%=SystemEnv.getHtmlLabelName(1370,user.getLanguage())%></option>
							<option value=6><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></option>
						  </select>
						</td>
					  </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></td>
						<td class=Field> <button type=button  class=Browser onClick="onShowUnitid()"></button> 
						  <span id=unitidspan><img src="/images/BacoError.gif" align=absMiddle></span> 
						  <input type=hidden name=unitid>
						</td>
					  </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(1371,user.getLanguage())%></td>
						<td class=Field> <button type=button  class=Browser onClick="onShowReplacecapitalid()"></button> 
						  <span id=replacecapitalidspan></span> 
						  <input type=hidden name=replacecapitalid>
						</td>
					  </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%></td>
						<td class=Field> 
						  <input class=InputStyle maxlength=60 size=30 name=version>
						</td>
					  </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  </tbody> 
					</table>

<!-- 
					<!-- 附属设备 --//>
					<table width="100%" class=liststyle id=equipment>
					  <tr> 
						<th align="left" colspan=3><%=SystemEnv.getHtmlLabelName(22341,user.getLanguage())%></th>
						<th align="right" colspan=3>
							<button type=button  Class=BtnFlow type=button accessKey=A onclick="addRow1()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
				            <button type=button  Class=BtnFlow type=button accessKey=E onclick="if(isdel()){deleteRow1();}"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
				        </th>
					  </tr>
					  <tr class=Spacing style="height:1px;"> 
						<td class=Line1 colspan=6></td>
					  </tr>
					  <tr class=header> 
						<td width="5%"><input type=checkbox class=inputstyle name="equipment_select_all" id="equipment_select_all" onclick="selectall1(this)"></td>
						<td width="15%"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
						<td width="15%"><%=SystemEnv.getHtmlLabelName(16314,user.getLanguage())%></td>
						<td width="15%"><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></td>
						<td width="15%"><%=SystemEnv.getHtmlLabelName(22349,user.getLanguage())%></td>
						<td width="15%"><%=SystemEnv.getHtmlLabelName(22350,user.getLanguage())%></td>
					  </tr>
					  <TR> 
						<TD class=Line colSpan=6></TD>
					  </TR>
						<tr style="display:none"></tr>                 					
					</table>

					<!-- 用于复制 --//>
					<table id=equipmenttable style="display:none">
						<tr class=datalight> 
							<td><input type="checkbox" class=inputstyle name="equipment_select"></td>
							<td><input type=text name="equipmentname" class=inputstyle size="10"></td>
							<td><input type=text name="equipmentspec" class=inputstyle size="10"></td>
							<td><input type=text name="equipmentsum" class=inputstyle size="10" onKeyPress="ItemNum_KeyPress()" onchange="checkinputnumber(this)"></td>
							<td><input type=text name="equipmentpower" class=inputstyle size="10"></td>
							<td><input type=text name="equipmentvoltage" class=inputstyle size="10"></td>
						</tr>
						<TR> 
							<TD class=Line colSpan=6></TD>
						</TR>
					</table>
					<!-- 用于复制 --//>

					<!-- 备品配件 --//>
					<table width="100%" class=liststyle id=parts>
					  <tr> 
						<th align="left" colspan=3><%=SystemEnv.getHtmlLabelName(22342,user.getLanguage())%></th>
						<th align="right" colspan=3>
							<button type=button  Class=BtnFlow type=button accessKey=A onclick="addRow2()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
				            <button type=button  Class=BtnFlow type=button accessKey=E onclick="if(isdel()){deleteRow2();}"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
				        </th>
					  </tr>
					  <tr class=Spacing style="height:1px;"> 
						<td class=Line1 colspan=6></td>
					  </tr>
					  <tr class=header> 
						<td width="5%"><input type=checkbox class=inputstyle name="parts_select_all" id="parts_select_all" onclick="selectall2(this)"></td>
						<td width="15%"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
						<td width="15%"><%=SystemEnv.getHtmlLabelName(16314,user.getLanguage())%></td>
						<td width="15%"><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></td>
						<td width="15%"><%=SystemEnv.getHtmlLabelName(22351,user.getLanguage())%></td>
						<td width="15%"><%=SystemEnv.getHtmlLabelName(22352,user.getLanguage())%></td>
					  </tr>
					  <TR> 
						<TD class=Line colSpan=6></TD>
					  </TR>
						<tr style="display:none"></tr>
					</table>

					<!-- 用于复制 --//>
					<table id=partstable style="display:none">
						<tr class=datalight> 
							<td><input type="checkbox" class=inputstyle name="parts_select"></td>
							<td><input type=text name="partsname" class=inputstyle size="10"></td>
							<td><input type=text name="partsspec" class=inputstyle size="10"></td>
							<td><input type=text name="partssum" class=inputstyle size="10" onKeyPress="ItemNum_KeyPress()" onchange="checkinputnumber(this)"></td>
							<td><input type=text name="partsweight" class=inputstyle size="10"></td>
							<td><input type=text name="partssize" class=inputstyle size="10"></td>
						</tr>
						<TR> 
							<TD class=Line colSpan=6></TD>
						</TR>
					</table>
					<!-- 用于复制 --//>
-->

					<table width="100%">
					  <colgroup> <col width=30%> <col width=70%> <tbody> 
					  <tr class=Title> 
						<th colspan=2><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></th>
					  </tr>
					  <tr class=Spacing style="height:1px;"> 
						<td class=Line1 colspan=2></td>
					  </tr>
					  <tr> 
						<td class=Field colspan=2> 
						  <textarea class="InputStyle"  style="width:100%" name=remark rows="6"></textarea>
						</td>
					  </tr>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  </tbody> 
					</table>
				  </TD>
				  <TD vAlign=top> 
				  <TABLE width="100%">
					  <COLGROUP> <COL width=30%> <COL width=70%> <TBODY> 
					  <TR class=Title> 
						<TH colSpan=2><%=SystemEnv.getHtmlLabelName(726,user.getLanguage())%></TH>
					  </TR>
					  <tr class=Spacing style="height:1px;"> 
						<TD class=Line1 colSpan=2></TD>
					  </TR>
					  <TR> 
						<td><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></td>
						<td class=Field><button type=button  class=Browser 
						id=SelectCurrencyID onClick="onShowCurrencyID()"></button> <span  
						id=currencyidspan><%if(defcurrenyid.equals("")){%><IMG src='/images/BacoError.gif' align=absMiddle><%}else{%><%=Util.toScreen(CurrencyComInfo.getCurrencyname(defcurrenyid),user.getLanguage())%><%}%></span> 
						  <input id=currencyid type=hidden name=currencyid value=<%=defcurrenyid%>>
						</td>
					  </TR>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  <TR> 
						<td><%=SystemEnv.getHtmlLabelName(191,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(726,user.getLanguage())%></td>
						<td class=Field> 
						  <input class=InputStyle 
						maxlength=16 size=10 value=0 name="startprice" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("startprice");checkinput("startprice","startpriceimage")'>
						  <span id=startpriceimage></span> </td>
					  </TR>
					  <TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  </TBODY> 
					</TABLE>

					<TABLE width="100%">
					  <COLGROUP> <COL width=30%> <COL width=70%> <TBODY> 
                      <!--折旧信息-->
					  <TR class=Title> 
						<TH colSpan=2><%=SystemEnv.getHtmlLabelName(1374,user.getLanguage())%></TH>
					  </TR>
					  <tr class=Spacing style="height:1px;"> 
						<TD class=Line1 colSpan=2></TD>
					  </TR>
                      <!--折旧年限-->
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(19598,user.getLanguage())%></td>
						<td class=Field id=txtLocation>
                          <input class=InputStyle maxlength=16 size=10 value=0 name="depreyear" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("depreyear")'>
						</td>
					  </tr>
						<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
                      <!--残值率-->
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(1390,user.getLanguage())%></td>
						<td class=Field id=txtLocation>
                            <input class=InputStyle maxlength=16 size=10 value=0 name="deprerate" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("deprerate")'>%
						</td>
					  </tr>
						<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  </TBODY> 
					</TABLE>

					<table width="100%">
					  <colgroup> <col width="30%"> <col width=70%> <tbody> 
					   <tr class=Title> 
						<th colspan=2><%=SystemEnv.getHtmlLabelName(17088,user.getLanguage())%></th>
					  </tr>
					  <tr class=Spacing style="height:1px;"> 
						<td class=Line1 colspan=2></td>
					  </tr>

<!-- 
					  <!-- 是否海关监管 --//>
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(22339,user.getLanguage())%></td>
						<td class=Field> 
							<select name="issupervision">
								<option value="1"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
								<option value="2"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
							</select>
						</td>
					  </tr>
						<TR> 
						<TD class=Line colSpan=2></TD>
					  </TR>

						<!-- 已付金额 --//>
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(22338,user.getLanguage())%></td>
						<td class=Field> 
						  <input class=InputStyle 
						maxlength=16 size=10 value=0 name="amountpay" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("amountpay")'>
					    </td>
					  </tr>
						<TR> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					
						<!-- 采购状态 --//>
					  <tr> 
						<td><%=SystemEnv.getHtmlLabelName(22333,user.getLanguage())%></td>
						<td class=Field> 
							<SELECT name="purchasestate">
								<OPTION value="1"><%=SystemEnv.getHtmlLabelName(22334,user.getLanguage())%></OPTION>
								<OPTION value="2"><%=SystemEnv.getHtmlLabelName(22335,user.getLanguage())%></OPTION>
								<OPTION value="3"><%=SystemEnv.getHtmlLabelName(22336,user.getLanguage())%></OPTION>
								<OPTION value="4"><%=SystemEnv.getHtmlLabelName(22337,user.getLanguage())%></OPTION>
							</SELECT>
						</td>
					  </tr>
						<TR> 
						<TD class=Line colSpan=2></TD>
					  </TR>
-->

					  <%
			if(hasFF)
			{
				for(int i=1;i<=5;i++)
				{
					if(RecordSet.getString(i*2+1).equals("1"))
					{%>
					  <tr> 
						<td><%=RecordSet.getString(i*2)%></td>
						<td class=Field> <button type=button  class=Calendar onClick="getProjdate(<%=i%>)"></button> 
						  <span id=datespan<%=i%> style="FONT-SIZE: x-small"></span> 
						  <input type="hidden" name="dff0<%=i%>" id="dff0<%=i%>">
						</td>
					  </tr>
						<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  <%}
				}
				for(int i=1;i<=5;i++)
				{
					if(RecordSet.getString(i*2+11).equals("1"))
					{%>
					  <tr> 
						<td><%=RecordSet.getString(i*2+10)%></td>
						<td class=Field> 
						  <input class=InputStyle maxlength=30 name="nff0<%=i%>" value="0.0" style="width:95%">
						</td>
					  </tr>
						<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>			
					  <%}
				}
				for(int i=1;i<=5;i++)
				{
					if(RecordSet.getString(i*2+21).equals("1"))
					{%>
					  <tr> 
						<td><%=RecordSet.getString(i*2+20)%></td>
						<td class=Field> 
						  <input class=InputStyle maxlength=100 name="tff0<%=i%>" style="width:95%">
						</td>
					  </tr>
						<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  <%}
				}
				for(int i=1;i<=5;i++)
				{
					if(RecordSet.getString(i*2+31).equals("1"))
					{%>
					  <tr> 
						<td><%=RecordSet.getString(i*2+30)%></td>
						<td class=Field> 
						  <input type=checkbox  name="bff0<%=i%>" value="1">
						</td>
					  </tr>
						<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  <%}
				}
				for(int i=1;i<=5;i++)
				{//多文档
					if(RecordSet.getString(i*2+41).equals("1"))
					{%>
					  <tr> 
						<td><%=RecordSet.getString(i*2+40)%></td>
						<td class=Field> 
						  <button type=button  class=Browser onClick='onShowMDocid("docff0<%=i%>","docff0<%=i%>span")'></button>
						  <span name="docff0<%=i%>span" id="docff0<%=i%>span"></span>
						  <input type=hidden name="docff0<%=i%>" class=inputstyle>
						</td>
					  </tr>
						<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  <%}
				}
				for(int i=1;i<=5;i++)
				{//多部门
					if(RecordSet.getString(i*2+51).equals("1"))
					{%>
					  <tr> 
						<td><%=RecordSet.getString(i*2+50)%></td>
						<td class=Field> 
						  <button type=button  class=Browser onClick='onShowDepartmentMutil("depff0<%=i%>span","depff0<%=i%>")'></button>
						  <SPAN id="depff0<%=i%>span" name="depff0<%=i%>span"></SPAN>
						  <input type=hidden name="depff0<%=i%>" class=inputstyle>
						</td>
					  </tr>
						<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  <%}
				}
				for(int i=1;i<=5;i++)
				{//多客户
					if(RecordSet.getString(i*2+61).equals("1"))
					{%>
					  <tr> 
						<td><%=RecordSet.getString(i*2+60)%></td>
						<td class=Field> 
						  <button type=button  class=Browser onClick='onShowCRM("crmff0<%=i%>","crmff0<%=i%>span")'></button>
						  <span id="crmff0<%=i%>span" name="crmff0<%=i%>span"></span>
						  <input type=hidden name="crmff0<%=i%>" class=inputstyle>
						</td>
					  </tr>
						<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  <%}
				}
				for(int i=1;i<=5;i++)
				{//多请求
					if(RecordSet.getString(i*2+71).equals("1"))
					{%>
					  <tr> 
						<td><%=RecordSet.getString(i*2+70)%></td>
						<td class=Field> 
						  <button type=button  class=Browser onClick='onShowRequest("reqff0<%=i%>","reqff0<%=i%>span")'></button>
						  <span id="reqff0<%=i%>span" name="reqff0<%=i%>span"></span>
						  <input type=hidden name="reqff0<%=i%>" class=inputstyle>
						</td>
					  </tr>
						<TR style="height:1px;"> 
						<TD class=Line colSpan=2></TD>
					  </TR>
					  <%}
				}
			}
			%>
					  </tbody> 
					</table>
				  </TD>
				</TR>
				</TBODY> 
			  </table>
			  <tr>
<td>
<table class=ReportStyle>
<TBODY>
<TR><TD>
<B><%=SystemEnv.getHtmlLabelName(21777,user.getLanguage())%>&nbsp;</B>
<Br>
<%=SystemEnv.getHtmlLabelName(21769,user.getLanguage())%>&nbsp;
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(21770,user.getLanguage())%>
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(21771,user.getLanguage())%>&nbsp;
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(21772,user.getLanguage())%>&nbsp;
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(21773,user.getLanguage())%>&nbsp;
<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(21774,user.getLanguage())%>&nbsp;
<BR>
</TD>
</TR>
</TBODY>
</table>
</td>
</tr>

</TABLE>
</td>
<td></td>
</tr>
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
</FORM>

<script type="text/javascript">
function onShowCRM(inputname, spanname) {
	var temp = $GetEle(inputname).value;
	id1 = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="
							+ temp, "", "dialogWidth:550px;dialogHeight:550px;");
	if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0).length > 500) { // '500为表结构相关客户字段的长度
			alert("您选择的相关客户数量太多，数据库将无法保存所有的相关客户，请重新选择！");
			$GetEle(spanname).innerHTML = "";
			$GetEle(inputname).value = "";
		} else if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			var resourceids = wuiUtil.getJsonValueByIndex(id1, 0).substr(1);
			var resourcename = wuiUtil.getJsonValueByIndex(id1, 1).substr(1);
			var sHtml = "";

			$GetEle(inputname).value = resourceids;

			var resourceidArray = resourceids.split(",");
			var resourcenameArray = resourcename.split(",");

			for ( var _i = 0; _i < resourceidArray.length; _i++) {
				var curid = resourceidArray[_i];
				var curname = resourcenameArray[_i];

				sHtml = sHtml
						+ "<a href=javascript:openFullWindowForXtable('/CRM/data/ViewCustomer.jsp?CustomerID="
						+ curid + "')>" + curname + "</a>&nbsp";
			}

			$GetEle(spanname).innerHTML = sHtml;
		} else {
			$GetEle(spanname).innerHTML = "";
			$GetEle(inputname).value = "";
		}
	}
}

function onShowRequest(inputname, spanname) {
	var temp = $GetEle(inputname).value;
	id1 = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids="
							+ temp, "", "dialogWidth:550px;dialogHeight:550px;");
	if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0).length > 500) { // '500为表结构相关流程字段的长度
			alert("您选择的相关流程数量太多，数据库将无法保存所有的相关流程，请重新选择！");
			$GetEle(spanname).innerHTML = "";
			$GetEle(inputname).value = "";
		} else if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			var resourceids = wuiUtil.getJsonValueByIndex(id1, 0).substr(1);
			var resourcename = wuiUtil.getJsonValueByIndex(id1, 1).substr(1);
			var sHtml = "";

			$GetEle(inputname).value = resourceids;

			var resourceidArray = resourceids.split(",");
			var resourcenameArray = resourcename.split(",");

			for ( var _i = 0; _i < resourceidArray.length; _i++) {
				var curid = resourceidArray[_i];
				var curname = resourcenameArray[_i];

				sHtml = sHtml
						+ "<a href=javascript:openFullWindowForXtable('/workflow/request/ViewRequest.jsp?requestid="
						+ curid + "')>" + curname + "</a>&nbsp";
			}

			$GetEle(spanname).innerHTML = sHtml;
		} else {
			$GetEle(spanname).innerHTML = "";
			$GetEle(inputname).value = "";
		}
	}
}

function onShowMDocid(inputename, spanname) {
	var tmpids = $GetEle(inputename).value;
	var id1 = window.showModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="
					+ tmpids, "", "dialogWidth:550px;dialogHeight:550px;");
	if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
		var DocIds = wuiUtil.getJsonValueByIndex(id1, 0).substr(1);
		var DocName = wuiUtil.getJsonValueByIndex(id1, 1).substr(1);
		var sHtml = "";

		$GetEle(inputename).value = DocIds;

		var docIdArray = DocIds.split(",");
		var DocNameArray = DocName.split(",");

		for ( var _i = 0; _i < docIdArray.length; _i++) {
			var curid = docIdArray[_i];
			var curname = DocNameArray[_i];

			sHtml = sHtml + "<a href=/docs/docs/DocDsp.jsp?id=" + curid + ">"
					+ curname + "</a>&nbsp";
		}

		$GetEle(spanname).innerHTML = sHtml;

	} else {
		$GetEle(spanname).innerHTML = "";
		$GetEle(inputename).value = "";
	}
}

function onShowCostCenter() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/hrm/company/CostcenterBrowser.jsp?sqlwhere= where departmentid="
							+ $GetEle("departmentid").value, "",
					"dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != 0) {
			$GetEle("costcenterspan").innerHTML = wuiUtil.getJsonValueByIndex(
					id, 1);
			$GetEle("costcenterid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("costcenterspan").innerHTML = "";
			$GetEle("costcenterid").value = "";
		}
	}
}

function onShowResourceID() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("resourceidspan").innerHTML = "<A href='/hrm/resource/HrmResource.jsp?id="
					+ wuiUtil.getJsonValueByIndex(id, 0)
					+ "'>"
					+ wuiUtil.getJsonValueByIndex(id, 1) + "</A>";
			$GetEle("resourceid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("resourceidspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			$GetEle("resourceid").value = "";
		}
	}
}

function onShowCurrencyID() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("currencyidspan").innerHTML = wuiUtil.getJsonValueByIndex(
					id, 1);
			$GetEle("currencyid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("currencyidspan").innerHTML = "";
			$GetEle("currencyid").value = "";
		}
	}
}

function onShowDepremethod1() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/DepremethodBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 1) != "") {
			$GetEle("depremethod1span").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("depremethod1").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("depremethod1span").innerHTML = "";
			$GetEle("depremethod1").value = "";
		}
	}
}

function onShowDepremethod2() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/DepremethodBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("depremethod2span").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("depremethod2").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("depremethod2span").innerHTML = "";
			$GetEle("depremethod2").value = "";
		}
	}
}

function onShowCapitaltypeid() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalTypeBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != ""&&wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			$GetEle("capitaltypeidspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("capitaltypeid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("capitaltypeidspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			$GetEle("capitaltypeid").value = "";
		}
	}
}

function onShowCapitalgroupid() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("capitalgroupidspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("capitalgroupid").value = wuiUtil
					.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("capitalgroupidspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			$GetEle("capitalgroupid").value = "";
		}
	}
}

function onShowCustomerid() {
	var id = window.showModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type=2",
			"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("customeridspan").innerHTML = wuiUtil.getJsonValueByIndex(
					id, 1);
			$GetEle("customerid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("customeridspan").innerHTML = "";
			$GetEle("customerid").value = "";
		}
	}
}

function onShowStateid() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalStateBrowser.jsp?from=search",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 1) != "") {
			$GetEle("Stateidspan").innerHTML = wuiUtil.getJsonValueByIndex(id,
					1);
			$GetEle("Stateid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("Stateidspan").innerHTML = "";
			$GetEle("Stateid").value = "";
		}
	}
}

function onShowReplacecapitalid() {
	var id = window.showModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp",
			"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("replacecapitalidspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("replacecapitalid").value = wuiUtil.getJsonValueByIndex(id,
					0);
		} else {
			$GetEle("replacecapitalidspan").innerHTML = "";
			$GetEle("replacecapitalid").value = "";
		}
	}
}

function onShowSubcompany(tdname, inputename) {
	var result = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=Capital:Maintenance&selectedids="+$G(inputename).value);
	if(result){
	    if(result.id!=""&&result.id!="0"){
			$G(tdname).innerHTML=result.name;
			$G(inputename).value=result.id;
		}else{
			$G(tdname).innerHTML= "<IMG src='/images/BacoError.gif' align=absMiddle>";
			$G(inputename).value="";
		}
	}
}


function onShowUnitid() {
	var id = window.showModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssetUnitBrowser.jsp",
			"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("unitidspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 2);
			$GetEle("unitid").value = wuiUtil.getJsonValueByIndex(id,
					0);
		} else {
			$GetEle("unitidspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			$GetEle("unitid").value = "";
		}
	}
}

function onShowItemid() {
	var id = window.showModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp",
			"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("itemidspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("itemid").value = wuiUtil.getJsonValueByIndex(id,
					0);
		} else {
			$GetEle("itemidspan").innerHTML = "";
			$GetEle("itemid").value = "";
		}
	}
}

</script>
<script language="javascript">

function   addRow1(){ //增加附属设备明细   
   
	var   alltbDetailUsed=    $GetEle("equipment").rows;   
	var   theFirstSelectedDetail=alltbDetailUsed.length;   	
	var   newRow   =    $GetEle("equipmenttable").rows[0].cloneNode(true);   
	var   desRow   =   alltbDetailUsed[theFirstSelectedDetail-1];   
	desRow.parentElement.insertBefore(newRow,desRow );
  
	alltbDetailUsed=    $GetEle("equipment").rows;   
	theFirstSelectedDetail=alltbDetailUsed.length;   	
	newRow   =    $GetEle("equipmenttable").rows[1].cloneNode(true);   
	desRow   =   alltbDetailUsed[theFirstSelectedDetail-1];   
	desRow.parentElement.insertBefore(newRow,desRow );       
}   
    
function   deleteRow1(){ //删除附属设备明细     
	var   alltbDetailUsed=    $GetEle("equipment").rows;   
	for(var   i=4;i<alltbDetailUsed.length-1;i=i+2){   
		if (alltbDetailUsed[i].all("equipment_select").checked==true){   
			 $GetEle("equipment").deleteRow(i);   
			 $GetEle("equipment").deleteRow(i);   
			i=i-2;   
		}   
	}   
	 $GetEle("equipment_select_all").checked=false;
}

function selectall1(obj){//附属设备全选    
	var   tureorfalse=obj.checked;   
	var   theDetail=equipment.rows;   
	for(var   i=4;i<theDetail.length-1;i=i+2){   
		theDetail[i].all("equipment_select").checked=tureorfalse;   
	}    	
}

function   addRow2(){ //增加备品配件明细   
   
	var   alltbDetailUsed=    $GetEle("parts").rows;   
	var   theFirstSelectedDetail=alltbDetailUsed.length;   	
	var   newRow   =    $GetEle("partstable").rows[0].cloneNode(true);   
	var   desRow   =   alltbDetailUsed[theFirstSelectedDetail-1];   
	desRow.parentElement.insertBefore(newRow,desRow );
  
	alltbDetailUsed=    $GetEle("parts").rows;   
	theFirstSelectedDetail=alltbDetailUsed.length;   	
	newRow   =    $GetEle("partstable").rows[1].cloneNode(true);   
	desRow   =   alltbDetailUsed[theFirstSelectedDetail-1];   
	desRow.parentElement.insertBefore(newRow,desRow );       
}   
    
function   deleteRow2(){ //删除备品配件明细     
	var   alltbDetailUsed=    $GetEle("parts").rows;   
	for(var   i=4;i<alltbDetailUsed.length-1;i=i+2){   
		if (alltbDetailUsed[i].all("parts_select").checked==true){   
			 $GetEle("parts").deleteRow(i);   
			 $GetEle("parts").deleteRow(i);   
			i=i-2;   
		}   
	}   
	 $GetEle("parts_select_all").checked=false;
}

function selectall2(obj){//备品配件全选    
	var   tureorfalse=obj.checked;   
	var   theDetail=parts.rows;   
	for(var   i=4;i<theDetail.length-1;i=i+2){   
		theDetail[i].all("parts_select").checked=tureorfalse;   
	}    	
}

function checkinputnumber(obj){
	
	valuechar = obj.value.split("");
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { 
	    charnumber = parseInt(valuechar[i]) ; 
	    if( isNaN(charnumber)&& valuechar[i]!="." && valuechar[i]!="-") 
	    isnumber = true ;
	}
	if(isnumber) obj.value="";
}

function onShowDepartmentMutil(spanname, inputname) {
    
    url=escape("/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+ $GetEle(inputname).value);
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url, "", "dialogWidth:550px;dialogHeight:550px;");
    try {
        jsid = new Array();jsid[0] = wuiUtil.getJsonValueByIndex(id, 0); jsid[1] = wuiUtil.getJsonValueByIndex(id, 1);
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0" && jsid[1]!="") {
            $GetEle(spanname).innerHTML = jsid[1].substring(1);
            $GetEle(inputname).value = jsid[0].substring(1);
        }else {
            $GetEle(spanname).innerHTML = "";
            $GetEle(inputname).value = "";
        }
    }
}
  
function submitData(obj){

	if (check_form($GetEle("frmain"),'name,resourceid,currencyid,capitaltypeid,capitalgroupid,unitid,blongsubcompany')){
		obj.disabled = true;
		$GetEle("frmain").submit();
	}
}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
