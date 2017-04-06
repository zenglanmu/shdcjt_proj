<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SalaryComInfo" class="weaver.hrm.finance.SalaryComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%
boolean hasright=true;
if(!HrmUserVarify.checkUserRight("Compensation:Manager", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel=0;
if(detachable==1){
    operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"Compensation:Manager",Util.getIntValue(DepartmentComInfo.getSubcompanyid1(ResourceComInfo.getDepartmentID(""+user.getUID()))));
    if(operatelevel<1){
        if(operatelevel<0){
            response.sendRedirect("/notice/noright.jsp");
            return;
        }else{
            hasright=false;
        }
    }
}
String subcompanyids=SubCompanyComInfo.getRightSubCompany(user.getUID(),"Compensation:Manager",0);
ArrayList subcompanylist=Util.TokenizerString(subcompanyids,",");
ArrayList itemlist=new ArrayList();
String items="";
for(int i=0;i<subcompanylist.size();i++){
    ArrayList tempitems=SalaryComInfo.getSubCompanyItemByType(Util.getIntValue((String)subcompanylist.get(i)),"'1'",false);
    for(int j=0;j<tempitems.size();j++){
        if(itemlist.indexOf((String)tempitems.get(j))<0){
            itemlist.add((String)tempitems.get(j));
        }
    }
}
for(int i=0;i<itemlist.size();i++){
    if(items.equals("")){
        items=(String)itemlist.get(i);
    }else{
        items+=","+itemlist.get(i);
    }
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(2218,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY onload="showdata()">
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(hasright){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
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
function showdata(){
    var ajax=ajaxinit();
    ajax.open("POST", "HrmSalaryChangeData.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("subcompanyids=<%=subcompanyids%>");
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
                jQuery("#showdatadiv").html(ajax.responseText);
            }catch(e){
                return false;
            }
        }
    }
}
</script>
<div id="showdatadiv">
	<table id="scrollarea" name="scrollarea" width="100%" height="100%" style="display:inline;zIndex:-1" >
	<tr>
			<td align="center" valign="center">
				<fieldset style="width:30%">
					<img src="/images/loading2.gif"><%=SystemEnv.getHtmlLabelName(20204,user.getLanguage())%></fieldset>
			</td>
	</tr>
	</table>
</div>
</td>
<td></td>
</tr>
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
</table>
<script language=javascript>  
function submitData() {
 if(check_form(document.frmmain,"multresourceid,itemid,salary")){
 document.frmmain.submit();
 }
}

function onShowResource(spanname , inputname){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?sqlwhere=where subcompanyid1 in(<%=subcompanyids%>) ");
	if (data!=null){
	    if (data.id!= ""){ 
	        spanname.innerHTML = data.name.substr(1,data.name.length);
	        inputname.value = data.id.substr(1,data.id.length);
	    }else{
	        spanname.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	        inputname.value = "";
	    }
	}
}

function onShowItemId(tdname,inputename){
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/finance/salary/SalaryItemBrowser.jsp?sqlwhere=where id in(<%=items%>) and itemtype = '1' ");
	if (data!=null){ 
		if (data.id!=0){
	        tdname.innerHTML = data.name;
	        inputename.value=data.id;
		}else{
	        tdname.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	        inputename.value = "";
		}
	}
}
</script>
</BODY>
</HTML>