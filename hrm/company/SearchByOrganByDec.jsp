<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML><HEAD>

<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<link href="/css/deepTree.css" rel="stylesheet" type="text/css">
<!-- added by cyril on 2008-08-12 for td:9109 -->
<script type="text/javascript" src="/js/xtree.js"></script>
<script type="text/javascript" src="/js/xmlextras.js"></script>
<script type="text/javascript" src="/js/cxloadtree.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree.css" />
<!-- end by cyril on 2008-08-12 for td:9109 -->
</HEAD>


<%
ArrayList departments=Util.TokenizerString(Util.null2String(request.getParameter("departments")),",");
ArrayList subcompanyids=Util.TokenizerString(Util.null2String(request.getParameter("subcompanyids")),",");
String isall=Util.null2String(request.getParameter("isall"));
String onlyselfdept=Util.null2String(request.getParameter("onlyselfdept"));
int uid=user.getUID();
int beagenter = Util.getIntValue((String)session.getAttribute("beagenter_"+user.getUID()));
if(beagenter <= 0){
	beagenter = uid;
}
int tabid=0;
String rem=null;
    Cookie[] cks = request.getCookies();

    for (int i = 0; i < cks.length; i++) {
        if (cks[i].getName().equals("departmentmultiDecOrder" + uid)) {
            rem = cks[i].getValue();
            break;
        }
    }   
String nodeid=null;    
if(rem!=null){
String[] atts=Util.TokenizerString2(rem,"|");
if(atts.length>1)
nodeid=atts[1];
}
boolean exist=false;
String tmpnodeid="";
if(nodeid!=null) tmpnodeid=nodeid.substring(nodeid.lastIndexOf("_")+1);
if(nodeid!=null&&nodeid.indexOf("com")>-1){
if(isall.equals("true")){
	exist=SubCompanyComInfo.getIdIndexKey(tmpnodeid)<0?false:true;
}else{
	exist=subcompanyids.indexOf(tmpnodeid)>-1?true:false;
}
}else if(nodeid!=null&&nodeid.indexOf("dept")>-1){
	if(isall.equals("true")){
		exist=DepartmentComInfo.getIdIndexKey(tmpnodeid)<0?false:true;
	}else{
		exist=subcompanyids.indexOf(DepartmentComInfo.getSubcompanyid1(tmpnodeid))>-1?true:false;
	}
}
if(!exist)
nodeid=null;
String deptid=ResourceComInfo.getDepartmentID(""+beagenter);
if(nodeid==null&&(isall.equals("true")||departments.indexOf(deptid)>-1||subcompanyids.indexOf(DepartmentComInfo.getSubcompanyid1(deptid))>-1)) 

nodeid="com_"+DepartmentComInfo.getSubcompanyid1(deptid);

String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));

%>

<body onload="initTree()">
	<form name="SearchForm" style="margin-bottom:0" action="MultiSelect.jsp" method="post" target="frame2">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>


	<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	%>
	<BUTTON class=btn accessKey=O style="display:none" id="btnok" onclick="btnok_onclick();"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	%>
	<BUTTON class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>

<table width=100% class="ViewForm" valign="top" style="margin-top:28px;*margin-top:0px;">
	<!--######## Search Table Start########-->
	<tr>
		<td height=170>
			<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" style="height:100%;"/>
		<td>
	</tr>
	</table>
  <input class="inputstyle" type="hidden" name="subcompanyid" >
  <input class="inputstyle" type="hidden" name="sqlwhere" value='<%=sqlwhere%>'>
  <input class="inputstyle" type="hidden" name="resourceids">
  <input class="inputstyle" type="hidden" name="showsubdept">
  <input class="inputstyle" type="hidden" name="tabid" >
  <input class="inputstyle" type="hidden" name="nodeid" >
  <input class="inputstyle" type="hidden" name="companyid" >
  <input class="inputstyle" type="hidden" name="departmentid" >
	<!--########//Search Table End########-->
</FORM>
<!--
<SCRIPT LANGUAGE=VBS>
resourceids =""
resourcenames = ""

Sub btnclear_onclick()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub


Sub btnok_onclick()
	 setResourceStr()
     replaceStr()
     window.parent.returnvalue = Array(resourceids,resourcenames)
    window.parent.close
End Sub

Sub btnsub_onclick()
	setResourceStr()
    document.all("resourceids").value = resourceids.substring(1)
    document.SearchForm.submit
End Sub
</SCRIPT>  -->


<script language="javascript">
	function initTree(){
	webFXTreeConfig.rootIcon		= "/images/xp/folder.png";
	webFXTreeConfig.openRootIcon	= "/images/xp/openfolder.png";
	webFXTreeConfig.folderIcon		= "/images/xp/folder.png";
	webFXTreeConfig.openFolderIcon	= "/images/xp/openfolder.png";
	//webFXTreeConfig.fileIcon		= "/images/xp/file.png";
	webFXTreeConfig.fileIcon		= "/images_face/ecologyFace_2/LeftMenuIcon/level3.gif";
	webFXTreeConfig.lMinusIcon		= "/images/xp/Lminus.png";
	webFXTreeConfig.lPlusIcon		= "/images/xp/Lplus.png";
	webFXTreeConfig.tMinusIcon		= "/images/xp/Tminus.png";
	webFXTreeConfig.tPlusIcon		= "/images/xp/Tplus.png";
	webFXTreeConfig.iIcon			= "/images/xp/I.png";
	webFXTreeConfig.lIcon			= "/images/xp/L.png";
	webFXTreeConfig.tIcon			= "/images/xp/T.png";
	
	cxtree_id = '<%=Util.null2String(nodeid)%>';
	CXLoadTreeItem("", "/hrm/tree/DepartmentMultiXMLByDecOrder.jsp<%if(nodeid!=null){%>?init=true&nodeid=<%=nodeid%>&onlyselfdept=<%=onlyselfdept%><%}

else{%>?onlyselfdept=<%=onlyselfdept%><%}%>");
	var tree = new WebFXTree();
	tree.add(cxtree_obj);
	//document.write(tree);
	document.getElementById('deeptree').innerHTML = tree;
	cxtree_obj.expand();
	//end by cyril on 2008-08-12 for td:9109
	}
	
	//to use xtree,you must implement top() and showcom(node) functions
	
	function top(){
	<%if(nodeid!=null){%>
	try{
	deeptree.scrollTop=<%=nodeid%>.offsetTop;
	deeptree.HighlightNode(<%=nodeid%>.parentElement);
	deeptree.ExpandNode(<%=nodeid%>.parentElement);
	    setCookie("departmentmultiDecOrder<%=uid%>","<%=tabid%>|<%=nodeid%>");
	 }catch(e){
	
	    }
	<%}%>
	}
</script>

<script language="javascript">
function btnclear_onclick(){
    window.parent.parent.returnValue = {id:"",name:""};
    window.parent.parent.close();
}
function btnok_onclick(){
	setResourceStr();
    replaceStr();
    window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
	window.parent.parent.close();
}
function showcom(node){
}

function check(node){
}
function setCookie(name,val){
	var Then = new Date();
	Then.setTime(Then.getTime() + 30*24*3600*1000 );
	document.cookie = name+"="+val+";expires="+ Then.toGMTString() ;
}
function setResourceStr(){

	var resourceids1 =""
        var resourcenames1 = ""
       try{
	for(var i=0;i<parent.frame2.resourceArray.length;i++){
		resourceids1 += ","+parent.frame2.resourceArray[i].split("~")[0] ;

		resourcenames1 += ","+parent.frame2.resourceArray[i].split("~")[1] ;
	}
	resourceids=resourceids1
	resourcenames=resourcenames1
       }catch(err){}


}

function replaceStr(){
    var re=new RegExp("[ ]*[|]*[|]","g");
    resourcenames=resourcenames.replace(re,"|");
    re=new RegExp("[|][^,]*","g");
    resourcenames=resourcenames.replace(re,"");   
}

function doSearch()
{
	setResourceStr();
    document.all("resourceids").value = resourceids.substring(1) ;
    if(parent.document.all("showsubdept").checked){
        document.all("showsubdept").value ="1" ;
    }else{
        document.all("showsubdept").value ="0" ;
    }
    document.SearchForm.submit();
}
function setCompany(id){
    document.all("departmentid").value=""
    document.all("subcompanyid").value=""
    document.all("companyid").value=id
    document.all("tabid").value=0
    doSearch()
}
function setSubcompany(nodeid){
    setCookie("departmentmultiDecOrder<%=uid%>","<%=tabid%>|"+nodeid);
    subid=nodeid.substring(nodeid.lastIndexOf("_")+1)
    document.all("companyid").value=""
    document.all("departmentid").value=""
    document.all("subcompanyid").value=subid
    document.all("tabid").value=0
    document.all("nodeid").value=nodeid
    doSearch()
}
function setDepartment(nodeid){
    setCookie("departmentmultiDecOrder<%=uid%>","<%=tabid%>|"+nodeid);
    deptid=nodeid.substring(nodeid.lastIndexOf("_")+1)
    document.all("subcompanyid").value=""
    document.all("companyid").value=""
    document.all("departmentid").value=deptid
    document.all("tabid").value=0
    document.all("nodeid").value=nodeid
    doSearch()
}
</script>
</BODY>
</HTML>