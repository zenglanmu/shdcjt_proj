<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
boolean hasright=true;
int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
String msg1=Util.null2String(request.getParameter("msg1"));
int Targetid=Util.getIntValue(request.getParameter("id"));
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
int detachable=Util.getIntValue((String)session.getAttribute("detachable"));
if(detachable==1){
    if(subcompanyid>0){
    int operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Compensation:Setting",subcompanyid);
    if(subcompanyid!=0 && operatelevel<1){
        hasright=false;
    }
    }else{
       hasright=false;
    }
}
if(!HrmUserVarify.checkUserRight("Compensation:Setting", user) && !hasright){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
String rightlevel=HrmUserVarify.getRightLevel("Compensation:Setting", user);
String TargetName="";
String Explain="";
int AreaType=-1;
String Areaids="";
String memo="";
String Areaname="";
double  showOrder=1;
if(Targetid<=0){
	RecordSet.executeSql("select max(showOrder) as maxShowOrder from HRM_CompensationTargetSet");
	if(RecordSet.next()){
		showOrder=Util.getDoubleValue(RecordSet.getString("maxShowOrder"),0);
		showOrder++;
	}
}
if(Targetid>0){
    RecordSet.executeSql("select a.TargetName,a.Explain,a.AreaType,b.companyordeptid,a.memo,a.showOrder from HRM_CompensationTargetSet a,HRM_ComTargetSetDetail b where a.id=b.Targetid and a.id="+Targetid);
    while(RecordSet.next()){
        TargetName=Util.null2String(RecordSet.getString("TargetName"));
        Explain=Util.null2String(RecordSet.getString("Explain"));
        AreaType=RecordSet.getInt("AreaType");
        String companyordeptid=RecordSet.getString("companyordeptid");
        memo=Util.null2String(RecordSet.getString("memo"));
        showOrder = Util.getDoubleValue(RecordSet.getString("showOrder"),0);  
        if(AreaType==3){
            Areaids+=companyordeptid+",";
            Areaname+=" "+SubCompanyComInfo.getSubCompanyname(companyordeptid);
        }
        if(AreaType==4){
            Areaids+=companyordeptid+",";
            Areaname+=" "+DepartmentComInfo.getDepartmentname(companyordeptid);
        }
    }
}
if(Areaids.equals(""))  Areaids="-1";
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdHRM.gif";
String titlename = SystemEnv.getHtmlLabelName(19427,user.getLanguage())+":"+SubCompanyComInfo.getSubCompanyname(""+subcompanyid);
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onsave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(Targetid>0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:ondelete(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location.href=\"CompensationTargetSet.jsp?subCompanyId="+subcompanyid+"\",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=weaver name=frmMain action="CompensationTargetSetOperation.jsp" method=post >
<input type="hidden" id="option" name="option" value="add">
<input type="hidden" id="Targetid" name="Targetid" value="<%=Targetid%>">
<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <%if(msg1.equals("1")){%>
  <tr><TD colspan="2"><font color="red"><%=SystemEnv.getHtmlLabelName(17049,user.getLanguage())%></font></TD></tr>    
  <%}%>
  <tr><TD colspan="2"><b><%=SystemEnv.getHtmlLabelName(19427,user.getLanguage())%></b></TD></tr>
  <TR class= Spacing style="height:2px"><TD class=Line1 colSpan=2></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type="text"  name="TargetName" maxlength="50" value="<%=Util.toScreenToEdit(TargetName,user.getLanguage())%>" onBlur="checkinput('TargetName','TargetNamespan')">
              <span id=TargetNamespan name=TargetNamespan><%if(TargetName.equals("")){%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></span>
              </TD>
   </TR>
   <TR class= Spacing style="height:1px"><TD class=Line colSpan=2></TD></TR>
   <TR>
          <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type="text"  name="Explain" size=40 maxlength="100" value="<%=Util.toScreenToEdit(Explain,user.getLanguage())%>"></TD>
   </TR>
   <TR class= Spacing style="height:1px"><TD class=Line colSpan=2></TD></TR>
   <TR>
          <TD><%=SystemEnv.getHtmlLabelName(19374,user.getLanguage())%></TD>
          <TD class=Field>
              <select name="AreaType" onchange="onChangeLevel()">
                  <%if(rightlevel.equals("2")){%>
                  <option value="0" <%if(AreaType==0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
                  <%}%>
                  <option value="1" <%if(AreaType==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18919,user.getLanguage())%></option>
                  <option value="2" <%if(AreaType==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19436,user.getLanguage())%></option>
                  <option value="3" <%if(AreaType==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%></option>
                  <option value="4" <%if(AreaType==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%></option>
              </select>&nbsp;&nbsp;
              <BUTTON class=Browser type=button <%if(AreaType==3){%>style="display:block"<%}else{%>style="display:none"<%}%> onClick="onShowSubcompany('Areaname','Areaids')" name=showsubcompany></BUTTON>
              <BUTTON class=Browser type=button <%if(AreaType==4){%>style="display:block"<%}else{%>style="display:none"<%}%> onClick="onShowMutiDepartment('Areaname','Areaids')" name=showdepartment></BUTTON>
			  <span id=Areaname name=Areaname <%if(AreaType==3 || AreaType==4){%>style="visibility:visible;"<%}else{%>style="visibility:hidden"<%}%>><%if(Areaids.equals("")){%><IMG src='/images/BacoError.gif' align=absMiddle><%}else{%><%=Areaname%><%}%></span>
              <input type="hidden" id="Areaids" name="Areaids" value="<%=Areaids%>">
          </TD>
   </TR>
   <TR class= Spacing style="height:1px"><TD class=Line colSpan=2></TD></TR>
   <TR>
          <TD><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TD>
          <TD class=Field><textarea name="memo" rows="5" cols="60"><%=Util.toScreenToEdit(memo,user.getLanguage())%></textarea></TD>
   </TR>
   <TR class= Spacing style="height:1px"><TD class=Line colSpan=2></TD></TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
    <TD class=FIELD  colspan=3><INPUT class=inputStyle maxLength=15 size=15
    name=showOrder value="<%=showOrder%>" onKeyPress='ItemDecimal_KeyPress("showOrder",15,2)'  onchange='checknumber("showOrder");checkDigit("showOrder",15,2);checkinput("showOrder","showOrderImage")'>
	<SPAN id=showOrderImage></SPAN>
	</TD>
  </TR>
    <TR class= Spacing style="height:1px"><TD class=Line colSpan=4></TD></TR>
 </TBODY></TABLE>
<input type='hidden' id="subcompanyid" name="subcompanyid" value="<%=subcompanyid%>">
</FORM>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
<script language=javascript>
function onsave(obj) {
 var checkstr="TargetName,showOrder";
 if(frmMain.AreaType.value>2){
     checkstr+=",Areaids";
 }
 if(check_form(frmMain,checkstr)){
    <%if(Targetid>0){%>
    frmMain.option.value="edit";
    <%}%>
    obj.disabled=true;
    frmMain.submit();
 }
}
function ondelete(obj){
    frmMain.option.value="delete";
    obj.disabled=true;
    frmMain.submit();
}
function onChangeLevel(){
	thisvalue=document.frmMain.AreaType.value;
	if(thisvalue==3){
        <%if(AreaType==3 && !Areaname.equals("")){%>
        document.frmMain.Areaids.value="<%=Areaids%>";
        Areaname.innerHTML = "<%=Areaname%>";
        <%}else{%>
        document.frmMain.Areaids.value="";
        Areaname.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
        <%}%>
        document.all("showdepartment").style.display='none';
        document.all("showsubcompany").style.display='';
        document.all("Areaname").style.visibility='visible';
    }
	else if(thisvalue==4){
        <%if(AreaType==4 && !Areaname.equals("")){%>
        document.frmMain.Areaids.value="<%=Areaids%>";
        Areaname.innerHTML = "<%=Areaname%>";
        <%}else{%>
        document.frmMain.Areaids.value="";
        Areaname.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
        <%}%>
        document.all("showsubcompany").style.display='none';
        document.all("showdepartment").style.display='';
        document.all("Areaname").style.visibility='visible';
    }else{
        Areaname.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
        document.frmMain.Areaids.value="-1";
        document.all("showsubcompany").style.display='none';
        document.all("showdepartment").style.display='none';
        document.all("Areaname").style.visibility='hidden';
    }
}
function encode(str){
    return escape(str);
}

function onShowMutiDepartment(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentByRightBrowser.jsp");
	if (data!=null) {
	    if (data.id!="") {
	    	$("#"+tdname).html(data.name.substring(1));
	    	$("#"+inputename).val(data.id);
	    }else{
	    	$("#"+tdname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
	    	$("#"+inputename).val("");
	    }
	}
}

function onShowSubcompany(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubCompanyByRightBrowser.jsp");
	
	if (data!=null) {
	    if (data.id!="") {
	    	$("#"+tdname).html(data.name.substring(1));
	    	$("#"+inputename).val(data.id);
	    }else{
	    	$("#"+tdname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
	    	$("#"+inputename).val("");
	    }
	}
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

</BODY>
</HTML>