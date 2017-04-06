<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<% if(!HrmUserVarify.checkUserRight("CrmProduct:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="LgcAssortmentComInfo" class="weaver.lgc.maintenance.LgcAssortmentComInfo" scope="page"/>


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String paraid = Util.null2String(request.getParameter("paraid")) ;
String assortmentid = paraid ;
String assortmentstr = "" ;
String assortmentname = "" ;
assortmentname = Util.toScreen(LgcAssortmentComInfo.getAssortmentFullName(assortmentid),user.getLanguage());

RecordSet.executeProc("FnaCurrency_SelectByDefault","");
RecordSet.next();
String defcurrenyid = RecordSet.getString(1);

String imagefilename = "/images/hdMaintenance.gif";
String titlename = Util.toScreen("新建产品",user.getLanguage(),"2");
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
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<FORM name=frmain action=LgcAssetOperation.jsp?Action=2 method=post enctype="multipart/form-data" >
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<input type="hidden" name="assetattribute">
<input type="hidden" name="operation" value="addasset">

  <TABLE class=ViewForm width="926">
   
    <TR> 
      <TD vAlign=top> 
      </TD>
        <!-- Item info -->
<!--
          <TR> 
            <TD>标识</TD>
            <td class=FIELD> 
              <input accesskey=Z name=assetmark size="30" onChange='checkinput("assetmark","assetmarkimage")'>
              <span id=assetmarkimage><img src="/images/BacoError.gif" align=absMiddle></span> 
            </td>
          </TR><tr><td class=Line colspan=3></td></tr>
-->
<!--
          <tr> 
            <td>条形码</td>
            <td class=FIELD> 
              <input accesskey=Z name=barcode size="30" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("barcode")'>
            </td>
          </TR><tr><td class=Line colspan=3></td></tr>
          <TR> 
            <TD>国家</TD>
            <td class=Field id=txtLocation> <BUTTON class=Browser id=SelectCountryID onclick="onShowCountryID()"></BUTTON> 
              <SPAN id=countryidspan STYLE="width:40%"></SPAN> 
              <INPUT id=assetcountyid type=hidden name=assetcountyid>
            </TD>
          </TR><tr><td class=Line colspan=3></td></tr>
          <TR> 
            <TD>生效日</TD>
            <TD class=Field><BUTTON class=Calendar id=selectstartdate onclick="getstartDate()"></BUTTON> 
              <SPAN id=startdatespan ></SPAN> 
              <input type="hidden" name="startdate">
            </TD>
          </TR><tr><td class=Line colspan=3></td></tr>
          <TR> 
            <TD>生效至</TD>
            <TD class=Field><BUTTON class=Calendar id=selectenddate onclick="getendDate()"></BUTTON> 
              <SPAN id=enddatespan ></SPAN> 
              <input type="hidden" name="enddate">
            </TD>
          </TR><tr><td class=Line colspan=3></td></tr>
          <tr> 
            <td>安全级别</td>
            <td class=Field> 
              <input accesskey=Z name=seclevel size="2" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("seclevel");checkinput("seclevel","seclevelimage")'>
              <span id=seclevelimage><img src="/images/BacoError.gif" align=absMiddle></span> 
            </td>
          </TR><tr><td class=Line colspan=3></td></tr>
          <TR> 
            <TD>部门</TD>
            <TD class=Field colSpan=2> <button class=Browser id=SelectDeparment onClick="onShowDepartment()"></button> 
              <span <input class=InputStyle  id=departmentspan></span> 
              <input id=departmentid type=hidden name=departmentid>
            </TD>
          </TR><tr><td class=Line colspan=3></td></tr>
          <TR> 
            <TD>人力资源</TD>
            <td class=Field> <BUTTON class=Browser id=SelectResourceID onClick="onShowResourceID()"></BUTTON> 
              <span id=resourceidspan></span> 
              <INPUT <input class=InputStyle  type=hidden name=resourceid>
            </TD>
          </TR><tr><td class=Line colspan=3></td></tr>
-->
      <TD vAlign=top rowspan="2"> 
        <!-- Remarks -->
        <TABLE class=ViewForm>
          <TBODY> 
          <TR class=Title> 
            <TH>备注</TH>
          </TR>
<TR style="height: 1px"><TD class=Line1 colSpan=3></TD></TR>
          <TR> 
            <TD vAlign=top> 
              <TEXTAREA <input class=InputStyle  style="WIDTH: 100%" name=assetremark rows=8></TEXTAREA>
            </TD>
          </TR><tr style="height: 1px"><td class=Line colspan=3></td></tr>
          </TBODY> 
        </TABLE>
        <table class=ViewForm>
          <tbody> 
          <tr class=Title> 
            <th>图片</th>
          </TR><tr style="height: 1px"><td class=Line1 colspan=3></td></tr>
          <tr> 
            <td class=Field> 
              <input class=InputStyle  type="file" name=assetimage>
            </td>
          </TR><tr style="height: 1px"><td class=Line colspan=3></td></tr>
          </tbody> 
        </table>
<!--
        <table class=ViewForm>
          <colgroup> <col width=120> <tbody> 
          <tr class=Title> 
            <th colspan=2>空闲字段</th>
          </tr>
           <TR class=Spacing style='height:1px'> 
            <td class=Line1 colspan=2></td>
          </tr>
          <%
	for(int i=1;i<=5;i++)
	{
		if(RecordSet.getString(i*2+11).equals("1"))
		{%>
          <tr> 
            <td><%=Util.toScreen(RecordSet.getString(i*2+10),user.getLanguage())%></td>
            <td class=Field> <button class=Calendar onClick="getDate(<%=i%>)"></button> 
              <span id=datespan<%=i%> ></span> 
              <input type="hidden" name="dff0<%=i%>" id="dff0<%=i%>">
            </td>
          </tr>
          <%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSet.getString(i*2+21).equals("1"))
		{%>
          <tr> 
            <td><%=RecordSet.getString(i*2+20)%></td>
            <td class=Field> 
              <input <input class=InputStyle  maxlength=30 name="nff0<%=i%>" value="0.0" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("nff0<%=i%>")'  style="width:95%">
            </td>
          </tr>
          <%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSet.getString(i*2+31).equals("1"))
		{%>
          <tr> 
            <td><%=RecordSet.getString(i*2+30)%></td>
            <td class=Field> 
              <input <input class=InputStyle  maxlength=100 name="tff0<%=i%>" style="width:95%">
            </td>
          </tr>
          <%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSet.getString(i*2+41).equals("1"))
		{%>
          <tr> 
            <td><%=RecordSet.getString(i*2+40)%></td>
            <td class=Field> 
              <input type=checkbox  name="bff0<%=i%>" value="1">
            </td>
          </tr>
          <%}
	}
%>
          </tbody> 
        </table>
-->
        <br>
        <br>
        <br>
      </TD>
    </TR>
    <TR> 
      <TD vAlign=top> 
        <TABLE class=ViewForm>
          <COLGROUP> <COL width=120> <TBODY> 
          <TR class=Title> 
            <TH colSpan=3>一般</TH>
          </TR>
           <TR class=Spacing style='height:1px'> 
            <TD class=Line1 colSpan=3></TD>
          </TR>
<!--
          <TR class=Title> 
            <TH colSpan=3>价格</TH>
          </TR>
           <TR class=Spacing style='height:1px'> 
            <TD class=sep2 colSpan=3></TD>
          </TR>
-->
          <tr> 
            <td>名称</td>
            <td class=FIELD> 
              <input class=InputStyle  accesskey=Z name=assetname size="30" onChange='checkinput("assetname","assetnameimage")'>
              <span id=assetnameimage><img src="/images/BacoError.gif" align=absMiddle></span> 
            </td>
          </TR><tr style="height: 1px"><td class=Line colspan=3></td></tr>
          <TR> 
            <TD>币种</TD>
            <TD class=Field>
              <input class=wuiBrowser _displayText="<%=Util.toScreen(CurrencyComInfo.getCurrencyname(defcurrenyid),user.getLanguage())%>" _url="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp"  id=currencyid type=hidden value=<%=defcurrenyid%> name=currencyid>
            </TD>
          </TR><tr style="height: 1px"><td class=Line colspan=3></td></tr>
          <TR> 
            <TD>基本售价</TD>
            <TD class=Field> 
              <input class=InputStyle  id=salesprice size=14 value=0.00 name=salesprice>
            </TD>
          </TR><tr style="height: 1px"><td class=Line colspan=3></td></tr>
<!--
          <TR> 
            <TD>成本</TD>
            <TD class=Field> 
              <INPUT <input class=InputStyle  id=CostPriceStandard size=14 value=0.00 name=costprice>
            </TD>
          </TR>
-->
          </TBODY> 
<!--
          <tr class=Title> 
            <th colspan=2>其它</th>
          </tr>
-->
<!--           <TR class=Spacing style='height:1px'> 
            <td class=sep2 colspan=2></td>
          </tr>
-->
          <tr> 
            <td>类别</td>
            <td class=Field>  
               
              <input class=wuiBrowser _url="/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowser.jsp" _displayText="<%=assortmentname%>" _required="yes" type=hidden name=assortmentid value=<%=assortmentid%>>
            </TD>
          </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
          <tr> 
            <td>计量单位</td>
            <td class=Field> 
              <input class=wuiBrowser _required="yes" _url="/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssetUnitBrowser.jsp"  type=hidden name=assetunitid>
            </TD>
          </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
<!--
          <tr> 
            <td>替代</td>
            <td class=Field> <BUTTON class=Browser id=SelectReplaceAssetID onClick="onShowReplaceAssetID()"></BUTTON> 
              <span id=replaceassetidspan></span> 
              <INPUT <input class=InputStyle  type=hidden name=replaceassetid>
            </TD>
          </tr>
          <tr> 
            <td>版本</td>
            <td class=Field> 
              <input accesskey=z size='20' name=assetversion>
            </td>
          </tr>
          <tr> 
            <td>相关工作流</td>
            <td class=Field><BUTTON class=Browser id=SelectRelateWFID onClick="onShowRelateWFID(relatewfid,relatewfidspan)"></BUTTON> 
              <span id=relatewfidspan></span> 
              <INPUT <input class=InputStyle  type=hidden id=relatewfid name=relatewfid> </td>
          </tr>
-->
          </tbody> 
        </table>
<!-- 
        <TABLE class=ViewForm>
          <TBODY> 
          <TR class=Title> 
            <TH colSpan=3>属性</TH>
          </TR>
           <TR class=Spacing style='height:1px'> 
            <TD class=Line1 colSpan=3></TD>
          </TR>
          <TR> 
            <TD vAlign=top width="33%"> 
              <TABLE cellSpacing=0 cellPadding=0 width="100%">
                <TBODY> 
                <TR> 
                  <TD> 
                    <INPUT <input class=InputStyle  id=sales type=checkbox name="sales">
                    销售 </TD>
                </TR>
                </TBODY> 
              </TABLE>
              <table cellspacing=0 cellpadding=0 width="100%">
                <tbody> 
                <tr> 
                  <td> 
                    <input <input class=InputStyle  id=netsales type=checkbox name="netsales">
                    网上销售</td>
                </tr>
                </tbody> 
              </table>
            </TD>
            <TD vAlign=top width="33.33%"> 
              <TABLE cellSpacing=0 cellPadding=0 width="100%">
                <TBODY> 
                <TR> 
                  <TD> 
                    <INPUT <input class=InputStyle  id=purchase name="purchase"
                  type=checkbox>
                    采购</TD>
                </TR>
                </TBODY> 
              </TABLE>
              <table cellspacing=0 cellpadding=0 width="100%">
                <tbody> 
                <tr> 
                  <td> 
                    <input <input class=InputStyle  id=batchnumber
                  type=checkbox name="batchnumber">
                    批号</td>
                </tr>
                </tbody> 
              </table>
            </TD>
            <TD vAlign=top width="33.33%"> 
              <TABLE cellSpacing=0 cellPadding=0 width="100%">
                <TBODY> 
                <TR> 
                  <TD> 
                    <INPUT <input class=InputStyle  id=stock name="stock"
                  type=checkbox>
                    库存</TD>
                </TR>
                </TBODY> 
              </TABLE>
            </TD>
          </TR>
          </TBODY> 
        </TABLE>

        <TABLE class=ViewForm>
          <COLGROUP> <COL width=120> <TBODY> 
          <TR class=Title> 
            <TH colSpan=2>财务</TH>
          </TR>
           <TR class=Spacing style='height:1px'> 
            <TD class=Sep2 colSpan=2></TD>
          </TR>
          <TR> 
            <TD>核算方法</TD>
            <td class=Field> <BUTTON class=Browser id=SelectCountTypeID onClick="onShowCountTypeID()"></BUTTON> 
              <span id=counttypeidspan></span> 
              <INPUT <input class=InputStyle  type=hidden name=counttypeid>
            </TD>
          </TR>
          </TBODY> 
        </TABLE>
 -->
      </TD>
    </TR>
    </TBODY> 
  </TABLE>
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


<SCRIPT language="javascript">
function CombineCheckedAttribute() {
var str="";
if(document.frmain.sales.checked) str+="1|";
if(document.frmain.purchase.checked) str+="2|";
if(document.frmain.stock.checked) str+="3|";
if(document.frmain.netsales.checked) str+="4|";
if(document.frmain.batchnumber.checked) str+="5|";
return str;
}
function OnSubmit(){
    if(check_form(document.frmain,"assetname,assortmentid,assetunitid"))
	{	
		//document.frmain.assetattribute.value=CombineCheckedAttribute();
		document.frmain.submit();
	}
}
</script>
</BODY>
</HTML>