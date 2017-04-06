<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<% if(!HrmUserVarify.checkUserRight("CrmProduct:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="AssetTypeComInfo" class="weaver.lgc.maintenance.AssetTypeComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="CountTypeComInfo" class="weaver.lgc.maintenance.CountTypeComInfo" scope="page"/>
<jsp:useBean id="LgcAssortmentComInfo" class="weaver.lgc.maintenance.LgcAssortmentComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
<script language="javascript" type="text/javascript">
function initImg(img,w,h){
	var getResize=function(width,height,SCALE_WIDTH,SCALE_HEIGHT){
		var sizes=new Array(2);
		var rate=0;
		if(width<=SCALE_WIDTH && height<=SCALE_HEIGHT){
			sizes[0]=width;
			sizes[1]=height;
			return sizes;
		}
			
		if(width>=height){
			rate=height/width;
			sizes[0]=SCALE_WIDTH;
			sizes[1]=Math.ceil(SCALE_WIDTH*rate);
		}else{//height>width.
			rate=width/height;
			sizes[0]=Math.ceil(SCALE_HEIGHT*rate);
			sizes[1]=SCALE_HEIGHT;
		}
		return sizes;
	}
	var srcImg=new Image();
	srcImg.src=img.src;
	var size=getResize(parseInt(srcImg.width),parseInt(srcImg.height),w,h);
	img.width=size[0];
	img.height=size[1];
}

</script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String paraid = Util.null2String(request.getParameter("paraid")) ;
String assetid = paraid ;
String assetcountryid = Util.null2String(request.getParameter("assetcountryid")) ;
char separator = Util.getSeparator() ;

RecordSet.executeProc("LgcAsset_SelectById",assetid+separator+assetcountryid);
RecordSet.next();

String assetmark = RecordSet.getString("assetmark");
String barcode = RecordSet.getString("barcode");
String seclevel = RecordSet.getString("seclevel");
String assetimageid = RecordSet.getString("assetimageid");
String assettypeid = RecordSet.getString("assettypeid");
String assetunitid = RecordSet.getString("assetunitid");
String replaceassetid = RecordSet.getString("replaceassetid");
String assetversion = RecordSet.getString("assetversion");
String assetattribute = RecordSet.getString("assetattribute");
String counttypeid = RecordSet.getString("counttypeid");
String assortmentid = RecordSet.getString("assortmentid");
String assortmentstr = RecordSet.getString("assortmentstr");
String relatewfid = RecordSet.getString("relatewfid");
String assetname = RecordSet.getString("assetname");
String assetcountyid = RecordSet.getString("assetcountyid");
String startdate = RecordSet.getString("startdate");
String enddate = RecordSet.getString("enddate");
String departmentid = RecordSet.getString("departmentid");
String resourceid = RecordSet.getString("resourceid");
String assetremark = RecordSet.getString("assetremark");
String currencyid = RecordSet.getString("currencyid");
String salesprice = RecordSet.getString("salesprice");
String costprice = RecordSet.getString("costprice");
String isdefault = RecordSet.getString("isdefault");

String dff01 = RecordSet.getString("datefield1");
String dff02 = RecordSet.getString("datefield2");
String dff03 = RecordSet.getString("datefield3");
String dff04 = RecordSet.getString("datefield4");
String dff05 = RecordSet.getString("datefield5");
String nff01 = RecordSet.getString("numberfield1");
String nff02 = RecordSet.getString("numberfield2");
String nff03 = RecordSet.getString("numberfield3");
String nff04 = RecordSet.getString("numberfield4");
String nff05 = RecordSet.getString("numberfield5");
String tff01 = RecordSet.getString("textfield1");
String tff02 = RecordSet.getString("textfield2");
String tff03 = RecordSet.getString("textfield3");
String tff04 = RecordSet.getString("textfield4");
String tff05 = RecordSet.getString("textfield5");
String bff01 = RecordSet.getString("tinyintfield1");
String bff02 = RecordSet.getString("tinyintfield2");
String bff03 = RecordSet.getString("tinyintfield3");
String bff04 = RecordSet.getString("tinyintfield4");
String bff05 = RecordSet.getString("tinyintfield5");

String createrid = RecordSet.getString("createrid");
String createdate = RecordSet.getString("createdate");
String lastmoderid = RecordSet.getString("lastmoderid");
String lastmoddate = RecordSet.getString("lastmoddate");

RecordSetFF.executeProc("LgcAssetAssortment_SelectByID",assortmentid);
RecordSetFF.next();

String imagefilename = "/images/hdMaintenance.gif";
String titlename = Util.toScreen("产品",user.getLanguage(),"2")+" : "+assetname;
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
<FORM name=frmain action=LgcAssetOperation.jsp?Action=2 method=post enctype="multipart/form-data" >
<DIV style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSave accessKey=S onclick='OnSubmit()'><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<% 
if(HrmUserVarify.checkUserRight("CrmProduct:Add", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnDelete id=Delete accessKey=D onClick="onDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%}%>
 </DIV>
<input type="hidden" name="assetattribute">
<input type="hidden" name="operation" value="editasset">
<input type="hidden" name="assetid" value="<%=assetid%>">
<input type="hidden" name="assetcountryid" value="<%=assetcountryid%>">

<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="49%">
  <COL width=10>
  <COL width="49%">
  <TBODY>
  <TR>
    <TD vAlign=top><!-- Item info -->
        <TABLE class=ViewForm>
          <COLGROUP> <COL width=120> <TBODY> 
          <TR class=Title> 
            <TH colSpan=3>一般</TH>
          </TR>
          <TR class=Spacing style="height: 1px"> 
            <TD class=Line1 colSpan=3></TD>
          </TR>
<!--
          <TR> 
            <TD>标识</TD>
            <td class=FIELD><%=Util.toScreenToEdit(assetmark,user.getLanguage())%></td>
            <input type="hidden" name="assetmark" value="<%=assetmark%>">
          </TR>
-->
          <tr> 
            <td>名称</td>
            <td class=FIELD> <input class=InputStyle  accesskey=Z name=assetname size="30" onChange='checkinput("assetname","assetnameimage")' value='<%=Util.toScreenToEdit(assetname,user.getLanguage())%>'><span id=assetnameimage></span> </td>
          </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
<!--
          <tr> 
            <td>条形码</td>
            <td class=FIELD> 
              <input accesskey=Z name=barcode size="30" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("barcode")' value='<%=Util.toScreenToEdit(barcode,user.getLanguage())%>'>
            </td>
          </tr>
          <TR> 
            <TD>国家</TD>
            <td class=Field id=txtLocation> <BUTTON class=Browser id=SelectCountryID onclick="onShowCountryID()"></BUTTON> 
              <SPAN id=countryidspan STYLE="width:40%"> 
              <%if (assetcountyid.equals("0")) {%>
              全球 
              <% } else {%>
              <%=Util.toScreen(CountryComInfo.getCountrydesc(assetcountyid),user.getLanguage())%> 
              <%}%>
              </SPAN> 
              <INPUT id=assetcountyid type=hidden name=assetcountyid value='<%=Util.toScreen(assetcountyid,user.getLanguage())%>'>
            </TD>
          </TR>
          <TR>
            <td>默认</td>
            <td class=Field> 
              <input type=checkbox  name="isdefault" value="1" <%if (isdefault.equals("1")) {%>checked disabled<%}%>>
            </td>
          </TR>
          <TR> 
            <TD>生效至</TD>
            <TD class=Field><BUTTON class=Calendar id=selectenddate onclick="getendDate()"></BUTTON> 
              <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN> 
              <input type="hidden" name="enddate" value='<%=Util.toScreen(enddate,user.getLanguage())%>'>
            </TD>
          </TR>
          <tr> 
            <td>安全级别</td>
            <td class=Field> 
              <input accesskey=Z name=seclevel size="2" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("seclevel");checkinput("seclevel","seclevelimage")' value='<%=Util.toScreenToEdit(seclevel,user.getLanguage())%>'>
              <span id=seclevelimage></span> </td>
          </tr>
          <TR> 
            <TD>部门</TD>
            <TD class=Field colSpan=2> <button class=Browser id=SelectDeparment onClick="onShowDepartment()"></button> 
              <span <input class=InputStyle  id=departmentspan><a  href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=departmentid%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></a></span> 
              <input id=departmentid type=hidden name=departmentid value='<%=Util.toScreen(departmentid,user.getLanguage())%>'>
            </TD>
          </TR>
          <TR> 
            <TD>人力资源</TD>
            <td class=Field> <BUTTON class=Browser id=SelectResourceID onClick="onShowResourceID()"></BUTTON> 
              <span id=resourceidspan><A href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></A></span> 
              <INPUT <input class=InputStyle  type=hidden name=resourceid value='<%=resourceid%>'>
            </td>
          </TR>
-->
<!--
          <TR class=Title> 
            <TH colSpan=3>价格</TH>
          </TR>
          <TR class=Spacing> 
            <TD class=sep2 colSpan=3></TD>
          </TR>
-->
		  <TR> 
            <TD>币种</TD>
            <TD class=Field>
              <INPUT <input class=wuiBrowser _url="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp" _displayText="<%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%>"  id=currencyid type=hidden name=currencyid value='<%=currencyid%>'>
            </TD>
          </TR><tr  style="height: 1px"><td class=Line colspan=3></td></tr>
          <TR> 
            <TD>基本售价</TD> 
            <TD class=Field> 
              <INPUT <input class=InputStyle  id=salesprice size=14  name=salesprice onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("salesprice")' value='<%=Util.toScreenToEdit(salesprice,user.getLanguage())%>'>
            </TD>
          </TR><tr  style="height: 1px"><td class=Line colspan=3></td></tr>
<!--
          <TR> 
            <TD>成本</TD>
            <TD class=Field> 
              <INPUT <input class=InputStyle  id=CostPriceStandard size=14  name=costprice
		onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("costprice")' value='<%=Util.toScreenToEdit(costprice,user.getLanguage())%>'>
			</TD>
          </TR>
-->
        <!-- Type -->
<!--
          <tr class=Title> 
            <th colspan=2>其它</th>
          </tr>
          <tr class=Spacing> 
            <td class=sep2 colspan=2></td>
          </tr>
-->
          <tr> 
            <td>类别</td>
            <td class=Field>
              <INPUT <input class=wuiBrowser _displayText="<%=Util.toScreen(LgcAssortmentComInfo.getAssortmentFullName(assortmentid),user.getLanguage())%>" _url="/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowser.jsp" _required="yes" type=hidden name=assortmentid value = '<%=assortmentid%>'>
            </TD>
          </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
          <tr> 
            <td>计量单位</td>
            <td class=Field> 
              <INPUT <input class=wuiBrowser _displayText="<%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(assetunitid),user.getLanguage())%>" _url="/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssetUnitBrowser.jsp" _required="yes" type=hidden name=assetunitid value = '<%=Util.toScreen(assetunitid,user.getLanguage())%>'>
            </TD>
<!--
          <tr> 
            <td>替代</td>
            <td class=Field> <BUTTON class=Browser id=SelectReplaceAssetID onClick="onShowReplaceAssetID()"></BUTTON> 
              <span id=replaceassetidspan><%=Util.toScreen(AssetComInfo.getAssetName(replaceassetid),user.getLanguage())%></span> 
              <INPUT <input class=InputStyle  type=hidden name=replaceassetid value='<%=replaceassetid%>'>
            </TD>
          </tr>
          <tr> 
            <td>版本</td>
            <td class=Field> 
              <input accesskey=z size='20' name=assetversion value='<%=Util.toScreenToEdit(assetversion,user.getLanguage())%>'>
            </td>
          </tr>
          <tr> 
            <td>相关工作流</td>
            <td class=Field><button class=Browser id=SelectRelateWFID onClick="onShowRelateWFID(relatewfid,relatewfidspan)"></button> 
              <span id=relatewfidspan><% if(relatewfid.equals("0")){%>无特定工作流
		  <%} else if(relatewfid.equals("1")){%>资产借用申请 
		  <%} else if(relatewfid.equals("2")){%>会议室使用申请 
		  <%} else if(relatewfid.equals("3")){%>小车使用申请 
		  <%} else if(relatewfid.equals("4")){%>大车使用申请<%}%></span> 
              <input <input class=InputStyle  type=hidden id=relatewfid name=relatewfid value="<%=relatewfid%>">
            </td>-->
          </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>

          </tbody> 
        </table>

      </TD>
    <TD></TD>
    <TD vAlign=top><!-- Remarks -->
      <TABLE class=ViewForm>
        <TBODY>
        <TR class=Title>
            <TH>备注</TH>
          </TR>
<TR style="height: 1px"><TD class=Line1 colSpan=2></TD></TR>
          <TD vAlign=top> 
          <TEXTAREA <input class=InputStyle  style="WIDTH: 100%" name=assetremark rows=8><%=Util.toScreenToEdit(assetremark,user.getLanguage())%></TEXTAREA>
          </TD>
       </TR><tr style="height: 1px"><td class=Line colspan=1></td></tr>
        </TBODY>
	  </TABLE>
      <TABLE class=ViewForm>
        <TBODY>
        <TR class=Title>
          <TH>图片</TH></TR>
<TR style="height: 1px"><TD class=Line1 colSpan=1></TD></TR>
            <TD class=Field>
			  <% if(assetimageid.equals("") || assetimageid.equals("0")) {%> 
              <input type="file" name="assetimage">
			  <%} else {%>
              <img onload="initImg(this,500,500)" border=0 src="/weaver/weaver.file.FileDownload?fileid=<%=assetimageid%>"> 
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(74,user.getLanguage())+",javascript:onDelPic(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
              <BUTTON class=btnDelete id=Delete accessKey=P style="display:none"  onclick="onDelPic()"><U>P</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></BUTTON> 
              <% } %>
              <input type="hidden" name="oldassetimage" value="<%=assetimageid%>">
            </TD>
		</TR><tr style="height: 1px"><td class=Line colspan=1></td></tr>
		</TBODY>
	  </TABLE>

	 </td>
  </TR>
  <TR>
    <TD vAlign=top>
<!--
      <TABLE class=ViewForm>
        <TBODY>
        <TR class=Title>
          <TH colSpan=3>属性</TH></TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=3></TD></TR>
        <TR>
          <TD vAlign=top width="33%">
              <TABLE cellSpacing=0 cellPadding=0 width="100%">
                <TBODY> 
                <TR> 
                  <TD> 
                    <INPUT <input class=InputStyle  id=sales type=checkbox name="sales" <%if(assetattribute.indexOf("1|")!=-1){%>checked<%}%>>
                    销售
				  </TD>
                </TR>
                </TBODY> 
              </TABLE>
              <table cellspacing=0 cellpadding=0 width="100%">
                <tbody> 
                <tr> 
                  <td> 
                    <input <input class=InputStyle  id=netsales type=checkbox name="netsales" <%if(assetattribute.indexOf("4|")!=-1){%>checked<%}%>>
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
                    <INPUT <input class=InputStyle  id=purchase name="purchase" <%if(assetattribute.indexOf("2|")!=-1){%>checked<%}%>
                  type=checkbox>               
                    采购</TD>
                </TR>
                </TBODY> 
              </TABLE>
              <table cellspacing=0 cellpadding=0 width="100%">
                <tbody> 
                <tr> 
                  <td> 
                    <input <input class=InputStyle  id=batchnumber type=checkbox name="batchnumber" <%if (assetattribute.indexOf("5|")!=-1){%>checked<%}%> >                
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
                    <INPUT <input class=InputStyle  id=stock name="stock" <%if(assetattribute.indexOf("3|")!=-1){%>checked<%}%>
                  type=checkbox>           
                    库存</TD>
                </TR>
                </TBODY> 
              </TABLE>
            </TD></TR></TBODY></TABLE>

        <TABLE class=ViewForm>
          <COLGROUP> <COL width=120> <TBODY> 
          <TR class=Title> 
            <TH colSpan=2>财务</TH>
          </TR>
          <TR class=Spacing> 
            <TD class=Sep2 colSpan=2></TD>
          </TR>
          <TR> 
            <TD>核算方法</TD>
            <td class=Field>
			<BUTTON class=Browser id=SelectCountTypeID onClick="onShowCountTypeID()"></BUTTON> 
			<span id=counttypeidspan><%=Util.toScreen(CountTypeComInfo.getCountTypename(counttypeid),user.getLanguage())%></span> 
              <INPUT <input class=InputStyle  type=hidden name=counttypeid value='<%=counttypeid%>'></TD>
            
          </TR>
          </TBODY> 
        </TABLE>
-->
      </TD>
    <TD></TD>
    <TD vAlign=top>
        <!-- User fields -->
        <!-- User fields -->
        <br>
        <br>
        <br>
<!--
        <TABLE class=ViewForm>
        <COLGROUP>
        <COL width=120>
        <TBODY>
        <TR class=Title>
          <TH colSpan=2>空闲字段</TH></TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
<%
	String tmpstr="";
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+11).equals("1"))
		{
			if (i==1) tmpstr = dff01;
			if (i==2) tmpstr = dff02;
			if (i==3) tmpstr = dff03;
			if (i==4) tmpstr = dff04;
			if (i==5) tmpstr = dff05;
		%>
        <TR>
          <TD><%=Util.toScreen(RecordSetFF.getString(i*2+10),user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Calendar onclick="getDate(<%=i%>)"></BUTTON> 
              <SPAN id=datespan<%=i%> ><%=Util.toScreen(tmpstr,user.getLanguage())%></SPAN> 
              <input type="hidden" name="dff0<%=i%>" id="dff0<%=i%>" value="<%=tmpstr%>">
          </TD>
        </TR>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+21).equals("1"))
		{
			if (i==1) tmpstr = nff01;
			if (i==2) tmpstr = nff02;
			if (i==3) tmpstr = nff03;
			if (i==4) tmpstr = nff04;
			if (i==5) tmpstr = nff05;
		%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+20)%></TD>
          <TD class=Field><INPUT <input class=InputStyle  maxLength=30 name="nff0<%=i%>" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("nff0<%=i%>")' value="<%=Util.toScreenToEdit(tmpstr,user.getLanguage())%>" STYLE="width:95%"></TD>
        </TR>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+31).equals("1"))
		{
			if (i==1) tmpstr = tff01;
			if (i==2) tmpstr = tff02;
			if (i==3) tmpstr = tff03;
			if (i==4) tmpstr = tff04;
			if (i==5) tmpstr = tff05;	
		%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+30)%></TD>
          <TD class=Field><INPUT <input class=InputStyle  maxLength=100 name="tff0<%=i%>" STYLE="width:95%" value="<%=Util.toScreenToEdit(tmpstr,user.getLanguage())%>"></TD>
        </TR>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+41).equals("1"))
		{
			if (i==1) tmpstr = bff01;
			if (i==2) tmpstr = bff02;
			if (i==3) tmpstr = bff03;
			if (i==4) tmpstr = bff04;
			if (i==5) tmpstr = bff05;
		%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+40)%></TD>
          <TD class=Field>
          <INPUT type=checkbox  name="bff0<%=i%>" <%if (tmpstr.equals("1")) {%>checked <%}%> value='1'></TD>
        </TR>
		<%}
	}
%>
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
<SCRIPT language=VBS>
/////////////////////////////////////////////////////////////////////////////////

sub onShowRelateWFID(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/asset/RelateWFBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = id(1)
	inputname.value=id(0)
	else 
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub


sub getDate(i)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	document.all("datespan"&i).innerHtml= returndate
	document.all("dff0"&i).value=returndate
end sub

sub onShowCountryID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	countryidspan.innerHtml = id(1)
	frmain.assetcountyid.value=id(0)
	else 
	countryidspan.innerHtml = ""
	frmain.assetcountyid.value="0" //"0" means global
	end if
	end if
end sub

sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmain.departmentid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	departmentspan.innerHtml = id(1)
	frmain.departmentid.value=id(0)
	else
	departmentspan.innerHtml = ""
	frmain.departmentid.value=""
	end if
	end if
end sub

sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmain.resourceid.value=id(0)
	else 
	resourceidspan.innerHtml = ""
	frmain.resourceid.value=""
	end if
	end if
end sub

sub onShowAssetTypeID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssetTypeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	assettypeidspan.innerHtml = id(1)
	frmain.assettypeid.value=id(0)
	else 
	assettypeidspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	frmain.assettypeid.value=""
	end if
	end if
end sub

sub onShowAssortmentID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	assortmentidspan.innerHtml = id(1)
	frmain.assortmentid.value=id(0)
	else 
	assortmentidspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	frmain.assortmentid.value=""
	end if
	end if
end sub




</SCRIPT>

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
		//document.frmain.isdefault.disabled=false;
		//document.frmain.assetattribute.value=CombineCheckedAttribute();
		document.frmain.submit();
	}
}

function onDelPic(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(8,user.getLanguage())%>")) {
		document.frmain.operation.value="delpic";
		document.frmain.submit();
	}
}

function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmain.operation.value="deleteasset";
			document.frmain.submit();
		}
}
</script>
</BODY>
</HTML>
