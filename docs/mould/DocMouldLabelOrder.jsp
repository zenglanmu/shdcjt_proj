<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MouldManager" class="weaver.docs.mould.MouldManager" scope="page" />

<html>
<%


boolean canEdit=false;
if(HrmUserVarify.checkUserRight("DocMouldEdit:Edit", user)){
	canEdit=true;
}

int mouldId = Util.getIntValue(request.getParameter("mouldId"),0);

MouldManager.setId(mouldId);
MouldManager.getMouldInfoById();
String mouldname=MouldManager.getMouldName();

%>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(16450,user.getLanguage())+"："+mouldname;
String needfav ="";
String needhelp ="";
%>
</head>

<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%


if(canEdit){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location='DocMouldDspExt.jsp?id="+mouldId+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;

%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>


<form id="weaver" name="weaver" method=post action="DocMouldLabelOrderOperation.jsp" >

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

        <TABLE class=ViewForm width="100%">
          <COLGROUP>
          <COL width="30%">
          <COL width="70%">
          <TBODY>
          <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
          </TR>
          <TR class=Spacing>
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR>
            <TD><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD>
            <TD class=FIELD><%=mouldId%></TD>
          </TR>
          <TR><TD class=Line colSpan=2></TD></TR> 

			<TR> 
				<TD><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></TD>
				 <TD class=FIELD><%=mouldname%></TD>
			  </TR>
			<TR><TD class=Line colSpan=2></TD></TR> 

          </TBODY>
        </TABLE>

        <TABLE class=ViewForm width="100%">
          <COLGROUP>
          <COL width="30%">
          <COL width="70%">
          <TBODY>
		  <tr><td height="10" colspan="2"></td></tr>
          <TR class=Title>
            <TH><%=SystemEnv.getHtmlLabelName(21412,user.getLanguage())%></TH>
          </TR>
          <TR class=Spacing>
            <TD class=line1 colSpan=2></TD>
          </TR>

          </TBODY>
        </TABLE>

<%
int rowNum=0;
%>


<table class=liststyle cellspacing=1   cols=3 >
    <COLGROUP>

  	<COL width="30%">
  	<COL width="30%">
  	<COL width="40%">
	  <tr class=header>
	    <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
	    <td><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td>
	    <td><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></td>
	  </tr>
	  <tr class="Line"><td colspan="3"> </td></tr>
<%

String trClass="DataLight";

int tempRecordId=0;
String tempName=null;
String tempDescript=null;
double tempShowOrder=0;


RecordSet.executeSql("select * from MouldBookMark where mouldId="+mouldId+" order by showOrder asc,id asc");
while(RecordSet.next()){

	tempRecordId  =Util.getIntValue(RecordSet.getString("id"),0);
	tempName=Util.null2String(RecordSet.getString("name"));
	tempDescript=Util.null2String(RecordSet.getString("descript"));
	tempShowOrder=Util.getDoubleValue(RecordSet.getString("showOrder"),0);
    if(tempShowOrder==0){
		tempShowOrder=rowNum;
	}

%>
<TR class="<%=trClass%>">

	<td  height="23" align="left"><%=tempName%></td>
    <td  height="23" align="left"><%=tempDescript%></td>

      <input type="hidden" name="labelOrder<%=rowNum%>_recordId" value="<%=tempRecordId%>">
    <td  height="23" align="left">
<%if(canEdit){%>
		<input class=Inputstyle type="text" name="labelOrder<%=rowNum%>_showOrder" size=7 maxlength=7  value="<%=tempShowOrder%>" onKeyPress='ItemDecimal_KeyPress("labelOrder<%=rowNum%>_showOrder",6,2)'   onchange='checknumber("labelOrder<%=rowNum%>_showOrder");checkDigit("labelOrder<%=rowNum%>_showOrder",6,2);'>
<%}else{%>
		<%=tempShowOrder%>
<%}%>
	</td>
</tr>

<%
    rowNum+=1;
    if(trClass.equals("DataLight")){
		trClass="DataDark";
	}else{
		trClass="DataLight";
	}
  }

%>
</table>




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
<input type="hidden" value="<%=mouldId%>" name="mouldId">
<input type="hidden" value="<%=rowNum%>" name="rowNum">

</form>



</body>
</html>


<Script language=javascript>


function onSave(obj) {

		obj.disabled = true;
		document.weaver.action="DocMouldLabelOrderOperation.jsp" ;
		document.weaver.submit();

}


/*
p（精度）
指定小数点左边和右边可以存储的十进制数字的最大个数。精度必须是从 1 到最大精度之间的值。最大精度为 38。

s（小数位数）
指定小数点右边可以存储的十进制数字的最大个数。小数位数必须是从 0 到 p 之间的值。默认小数位数是 0，因而 0 <= s <= p。最大存储大小基于精度而变化。
*/
function checkDigit(elementName,p,s){
	tmpvalue = document.all(elementName).value;

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
    document.all(elementName).value=newValue;
}


</script>
