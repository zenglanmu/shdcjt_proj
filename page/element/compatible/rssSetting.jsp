<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="weaver.conn.RecordSet"  %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.net.*"%>
<jsp:useBean id="sci" class="weaver.system.SystemComInfo" scope="page" />
<link href='/css/Weaver.css' type=text/css rel=stylesheet>
<script type='text/javascript' src='/js/jquery/jquery.js'></script>
<script type='text/javascript' src='/js/weaver.js'></script>
<%
String userLanguageId = Util.null2String(request.getParameter("userLanguageId"));
String eid = Util.null2String(request.getParameter("eid"));
String tabId = Util.null2String(request.getParameter("tabId"));
String tabTitle = Util.null2String(request.getParameter("tabTitle"));	
tabTitle = URLDecoder.decode(tabTitle, "utf-8");
String value = Util.null2String(request.getParameter("value"));
RecordSet rssRs = new RecordSet();
rssRs.execute("select * from hpNewsTabInfo where eid="+eid +" and tabid="+tabId+" order by tabId");
if(rssRs.next()){
	tabTitle = rssRs.getString("tabTitle");
	value = rssRs.getString("sqlWhere");
}


String setValue1="";
String setValue2=""; 
String setValue3="";
String setValue4="";

if(!"".equals(value))
{
    ArrayList rssSetList=Util.TokenizerString(value,"^,^");
  
    if(rssSetList.size()>=3)
    {
    	
    	if(rssSetList.size()>=4){
    		
    		setValue1=Util.null2String((String)rssSetList.get(0));
        	setValue2=Util.null2String((String)rssSetList.get(1));
        	setValue3=Util.null2String((String)rssSetList.get(2));
        	setValue4 = Util.null2String((String)rssSetList.get(3));
    	}else{
    		setValue2=Util.null2String((String)rssSetList.get(0));
        	setValue3=Util.null2String((String)rssSetList.get(1));
        	setValue4=Util.null2String((String)rssSetList.get(2));
    	}
    }
    else if(rssSetList.size()==2)
    {
    	String tsetValue1=Util.null2String((String)rssSetList.get(0));
    	String tsetValue2=Util.null2String((String)rssSetList.get(1));
    	if((tsetValue1.equals("1")&&value.indexOf("^,^1")==0)||(tsetValue1.equals("2")&&value.indexOf("^,^2")==0))
    	{
    		setValue1 = "";
    		setValue2 = tsetValue1;
    		setValue3 = tsetValue2;
    	}
    	else
    	{
    		setValue1 = tsetValue1;
    		setValue2 = tsetValue2;
    		setValue3 = "3";
    	}
    }
}
else
{
	setValue1 = "";
	setValue2 = "1";
	setValue3 = "3";
}
if(setValue4.equals("")){
	setValue4 = sci.getRsstype();
}

setValue2 = setValue2.equals("")?"1":setValue2;
setValue3 = setValue3.equals("")?"3":setValue3;  


String rssSettingStr="";
rssSettingStr="<table class=viewForm>";
rssSettingStr+="<colgroup>";
rssSettingStr+="<col width='20%'/>";
rssSettingStr+="<col width='80%'/>";
rssSettingStr+="</colgroup>";
rssSettingStr+="<TR><TD>";
tabTitle = Util.toHtml2(tabTitle.replaceAll("&","&amp;"));
rssSettingStr+="<TR valign=middle><TD>&nbsp;"+SystemEnv.getHtmlLabelName(229,Util.getIntValue(userLanguageId))+"</TD><TD class=field><input style=\"width:96%\" class=inputStyle id='tabTitle_"+eid+"' type='text' value=\""+tabTitle+"\"  onchange='checkinput(\"tabTitle_"+eid+"\",\"tabTitleSpan_"+eid+"\")' /><SPAN id='tabTitleSpan_"+eid+"' >";

if(tabTitle.equals("")){
	rssSettingStr+="<IMG src=\"/images/BacoError.gif\" align=absMiddle>";
}
rssSettingStr+="</SPAN></TD></TR>";
rssSettingStr+="<TR><TD CLASS=LINE COLSPAN=2></TD></TR>";
rssSettingStr+="	<TR valign='top'><TD>&nbsp;" +SystemEnv.getHtmlLabelName(15935,Util.getIntValue(userLanguageId))+"</TD>" +
		"<!--显示内容-->" +
		"<TD  class=field><INPUT TYPE='text' name=\"_whereKey_"+eid+"\" value='"+setValue1+"' class='inputStyle' " +
				"style=\"width:98%\">";


String showMode1="";
String showMode2=""; 
String showMode3="";
String showMode4="";
String showMode5="";
String showMode6="";



if("1".equals(setValue2)) showMode1=" selected ";
if("2".equals(setValue2)) showMode2=" selected ";
if("3".equals(setValue3)) showMode3=" selected ";
if("4".equals(setValue3)) showMode4=" selected ";
if("1".equals(setValue4)) showMode5=" selected ";
if("2".equals(setValue4)) showMode6=" selected ";


rssSettingStr+="<TR><TD CLASS=LINE COLSPAN=2></TD></TR>";
rssSettingStr+="<TR valign='top'><TD>&nbsp;" +SystemEnv.getHtmlLabelName(19669,Util.getIntValue(userLanguageId))+"<!--所在位置-->" +
			   "	<TD  class=field>" +
			   "		<select  name=\"_whereKey_"+eid+"\" >" +
			   "			<option "+showMode1+" value=1>" +SystemEnv.getHtmlLabelName(19670,Util.getIntValue(userLanguageId))+"</option>" +
			   "			<option "+showMode2+" value=2>" +SystemEnv.getHtmlLabelName(19671,Util.getIntValue(userLanguageId))+"</option>" +
			   "		</select>&nbsp;(" +SystemEnv.getHtmlLabelName(19672,Util.getIntValue(userLanguageId))+")";
rssSettingStr+="</TD></TR>";
rssSettingStr+="<TR><TD CLASS=LINE COLSPAN=2></TD></TR>";
rssSettingStr+="<TR valign='top'><TD>&nbsp;" +SystemEnv.getHtmlLabelName(24020,Util.getIntValue(userLanguageId))+"</TD>" +
				"<!--查询组合-->" +
				"<TD  class=field>" +
				"	<select  name=\"_whereKey_"+eid+"\" >" +
			    "		<option "+showMode3+" value=3>and</option>" +
			    "		<option "+showMode4+" value=4>or</option>" +
			    "	</select>&nbsp;<img title='" +SystemEnv.getHtmlLabelName(24022,Util.getIntValue(userLanguageId))+"' align='absMiddle' src='/images/remind.png' complete='complete'/></TD>	" +
				"</TR>";
rssSettingStr+="<TR><TD CLASS=LINE COLSPAN=2></TD></TR>";


rssSettingStr+="	<TR valign='top'><TD>&nbsp;" +SystemEnv.getHtmlLabelName(24661,Util.getIntValue(userLanguageId))+"</TD>" +
"<!--读取方式-->" +
"<TD  class=field><select  name=\"_whereKey_"+eid+"\">"+
"<option "+showMode5+" value=1>"+SystemEnv.getHtmlLabelName(108,Util.getIntValue(userLanguageId))+"</option>"+
"<option "+showMode6+" value=2>"+SystemEnv.getHtmlLabelName(15038,Util.getIntValue(userLanguageId))+"</option>"+
"</select>";

rssSettingStr+="</TD></TR>";
rssSettingStr+="<TR><TD CLASS=LINE COLSPAN=2></TD></TR>";
rssSettingStr+="</table>";

out.println(rssSettingStr);
%>
<script type="text/javascript">
//获取所有设置条件的值
function getNewsSettingString(eid){
	var whereKeyStr="";
	var _whereKeyObjs=document.getElementsByName("_whereKey_"+eid);
	//得到上传的SQLWhere语句
	for(var k=0;k<_whereKeyObjs.length;k++){
		var _whereKeyObj=_whereKeyObjs[k];	
		if(_whereKeyObj.tagName=="INPUT" && _whereKeyObj.type=="checkbox" &&! _whereKeyObj.checked) continue;			
		whereKeyStr+=_whereKeyObj.value+"^,^";			
	}
	if(whereKeyStr!="") whereKeyStr=whereKeyStr.substring(0,whereKeyStr.length-3);	
	//var topDocIds = document.getElementById("topdocids_"+eid).value;
	return whereKeyStr;
}

</script>

