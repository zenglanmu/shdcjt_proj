<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>

<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
    <script type="text/javascript" src="/js/xtree.js"></script>
	<script type="text/javascript" src="/js/xmlextras.js"></script>
	<script type="text/javascript" src="/js/cxloadtree.js"></script>
    <link type="text/css" rel="stylesheet" href="/css/xtree2.css" />
</HEAD>
<%
int uid=user.getUID();
String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodename=Util.null2String(request.getParameter("nodename"));
String level=Util.null2String(request.getParameter("level"));
String subid=Util.null2String(request.getParameter("subid"));
String selectedDepartmentIds = Util.null2String(request.getParameter("selectedDepartmentIds"));
String rightStr=Util.null2String(request.getParameter("rightStr"));
String scope=Util.null2String(request.getParameter("scope"));

String selectedids = Util.null2String(request.getParameter("selectedids"));
String[] selecteds = selectedids.split("[,]");
String selectnode = "";
if(!"".equals(selectedids)&&!"0".equals(selectedids)){
	for(int i=0;i<selecteds.length;i++){
		if(!"".equals(selecteds[i])&&!"0".equals(selecteds[i])){
			selectnode = ",com_"+selecteds[i]+selectnode;
		}
	}
}
if(selectnode.startsWith(",")){
	selectnode = selectnode.substring(1);
}

String[] idss=Util.TokenizerString2(selectedDepartmentIds,",");

//System.out.println("nodeid:"+nodeid);

%>


<BODY onload="initTree()">
    <DIV align=right>
    <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
    <%
        RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSave(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(19323,user.getLanguage())+",javascript:needSelectAll(!parent.selectallflag,this),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;

    %>
    <%@ include file="/systeminfo/RightClickMenu.jsp" %>
    <script>
     rightMenu.style.visibility='hidden'
    </script>
    </DIV>

    <table   width=100% height=100% border="0" cellspacing="0" cellpadding="0" >
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
                <TABLE  class=Shadow >
                    <tr>
                        <td valign="top">
                            <FORM NAME=select STYLE="margin-bottom:0" action="MutiSubCompanyByRightBrowser.jsp" method=post>
                                <input class=inputstyle type=hidden name=type value="<%=type%>">
                                <input class=inputstyle type=hidden name=id value="<%=id%>">
                                <input class=inputstyle type=hidden name=level value="<%=level%>">
                                <input class=inputstyle type=hidden name=subid value="<%=subid%>">
                                <input class=inputstyle type=hidden name=nodename value="<%=nodename%>">

                                <TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width:100%;">
                                     <TR class=Line1><TH colspan="4" ></TH></TR>
                                      <TR>
                                          <TD height=400 colspan="4" >
                                            <div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" onclick="rightMenu.style.visibility='hidden'"/>
                                          </TD>
                                      </TR>
                                </TABLE>
                            </FORM>
                         </td>
                    </tr>
                </TABLE>
            </td>
            <td></td>
        </tr>
        <tr> <td height="10" colspan="3"></td></tr>
        <tr>
        <td align="center" valign="bottom" colspan=3>
	<BUTTON class=btn accessKey=O  id=btnok onclick="onSave()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<BUTTON class=btn accessKey=2  id=btnclear onclick="onClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
        <BUTTON class=btnReset accessKey=T  id=btncancel onclick="window.parent.close()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
        </td>
        </tr>
    </table>
</BODY>
</HTML>

<script language="javaScript"><!--
//to use deeptree,you must implement following methods
var selectallflag=false;
var appendimg = 'Home';
var appendname = 'selObj';
var allselect = "all";
var typename = "checkbox";
var selectreview = "openall";
var selectedids = "<%=selectedids%>";
if(selectedids!="0"&&selectedids!=""){
	cxtree_id = "<%=selectnode%>";
	cxtree_ids = cxtree_id.split(',');
	cxtree_id = cxtree_ids[0];
} 
var xmlHttp;
var ajaxvalue;
function showAjax(subId,suptype){
	if(window.ActiveXObject){
        xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    else if(window.XMLHttpRequest){
        xmlHttp = new XMLHttpRequest();
    }
    xmlHttp.onreadystatechange = getReturnValue;
	xmlHttp.open("get","MutiDepartmentAjax.jsp?subId="+subId+"&suptype="+suptype,false); 
	xmlHttp.send(); 
}
function getReturnValue(){
	if(xmlHttp.readystate==4){ 
		if(xmlHttp.status==200){
			var returnTemp = xmlHttp.responseText;
			ajaxvalue = returnTemp;
		}
	}
}
function initTree(){
	CXLoadTreeItem("", "/hrm/finance/salary/SubcompanyMultiByRightXML.jsp?rightStr=<%=rightStr%>&subcompanyid=<%=subcompanyid%>&scope=<%=scope%>");
	var tree = new WebFXTree();
	tree.add(cxtree_obj);
	document.getElementById('deeptree').innerHTML = tree;
	cxtree_obj.expand();
	}

function onSaveJavaScript(){      
    var nameStr="";
    if(select.selObj==null) return "";
    if(typeof(select.selObj.length)=="undefined") {
	if(select.selObj.checked) {
		nameStr =  select.selObj.value;
	}
} else {
	for(var i=0;i<select.selObj.length;i++) {
		if(select.selObj[i].checked) {
			if(selectallflag){
				if(nameStr.indexOf(select.selObj[i].value)>=0){
					continue;
				}else{
					nameStr = nameStr + select.selObj[i].value + ",";
					showAjax(select.selObj[i].value.split("_")[1],"subcom");
					nameStr = nameStr + ajaxvalue;
				}
			}else{
				nameStr = nameStr + select.selObj[i].value + ",";
			}
		}
	}
}
arrayname = nameStr.split(",");
var resultStr1="";
var resultStr2="";
for(var j=0;j<arrayname.length;j++){
	arraytemp = arrayname[j].split("_");
	if(arraytemp.length==1){
		break;
	}
	resultStr1 = resultStr1 + "," + arraytemp[1];
	var strtmp2 = "";
	for(var i=0;i<arraytemp.length;i++){
		if(i>1){
			strtmp2 = strtmp2 + "_" + arraytemp[i];
		}
	}
	resultStr2 = resultStr2 + "," + strtmp2.substring(1);
}
    return resultStr1+"$"+resultStr2;
}

function showallcheckbox(node){
	for(var i=0;i<node.childNodes.length;i++){
		if(node.childNodes[i].folder){
			if(node.childNodes[i].icon.indexOf(appendimg)<1){
				if(selectallflag){
					document.getElementById(node.childNodes[i].id+'_radio').getElementsByTagName('INPUT')[0].style.display="";	
				}else{
					document.getElementById(node.childNodes[i].id+'_radio').getElementsByTagName('INPUT')[0].style.display="none";
				}
			}
			showallcheckbox(node.childNodes[i]);
		}else{
			continue;
		}
	}
}

function needSelectAll(flag,obj){
	selectallflag=flag;
	   showallcheckbox(cxtree_obj);
	   i=obj.value.indexOf('>');
	   if(selectallflag)
	   a=obj.value.substring(0,i+1)+' <%=SystemEnv.getHtmlLabelName(19324,user.getLanguage())%> ';
	   else
	   a=obj.value.substring(0,i+1)+' <%=SystemEnv.getHtmlLabelName(19323,user.getLanguage())%>';
	   obj.value=a;
}
function onSave(){
	var trunStr;
	var returnid,returnname;
	trunStr =  onSaveJavaScript();
	returnid=trunStr.split("$")[0];
	returnname=trunStr.split("$")[1];
	window.parent.returnValue={id:returnid,name:returnname};
	window.parent.close();
}

function onClear(){
	window.parent.returnValue = {id:'',name:''};
	window.parent.close();
}
</script>
