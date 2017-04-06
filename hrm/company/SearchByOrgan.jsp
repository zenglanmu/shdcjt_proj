<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<link href="/css/deepTree.css" rel="stylesheet" type="text/css">
<!-- added by cyril on 2008-07-31 for td:9109 -->
<script type="text/javascript" src="/js/xtree.js"></script>
<script type="text/javascript" src="/js/xmlextras.js"></script>
<script type="text/javascript" src="/js/cxloadtree.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree.css" />
<!-- end by cyril on 2008-07-31 for td:9109 -->

<style type="text/css">

BODY {
   margin-top:1px; 
}

.cxtree {
	padding-top:8px;
}

</style>

</HEAD>

<%


int uid=user.getUID();
int tabid=0;

String nodeid=null;
String rem=null;
        Cookie[] cks= request.getCookies();

        for(int i=0;i<cks.length;i++){
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if(cks[i].getName().equals("departmentmultiOrder"+uid)){
        rem=cks[i].getValue();
        break;
        }
        }
if(rem!=null){
String[] atts=Util.TokenizerString2(rem,"|");
if(atts.length>1)
nodeid=atts[1];
}
boolean exist=false;
if(nodeid!=null&&nodeid.indexOf("com")>-1){
exist=SubCompanyComInfo.getSubCompanyname(nodeid.substring(nodeid.lastIndexOf("_")+1)).equals("")?false:true;
}else if(nodeid!=null&&nodeid.indexOf("dept")>-1){
String deptname=DepartmentComInfo.getDepartmentname(nodeid.substring(nodeid.lastIndexOf("_")+1));
String subcom=DepartmentComInfo.getSubcompanyid1(nodeid.substring(nodeid.lastIndexOf("_")+1));
    if(!deptname.equals("")&&subcom.equals(nodeid.substring(nodeid.indexOf("_")+1,nodeid.lastIndexOf("_"))))
       exist=true;
    else
      exist=false;
}
if(!exist)
nodeid=null;

%>

<BODY onload="initTree()" oncontextmenu="return false;">
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MultiSelect.jsp" method=post target="frame2">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>


	<%
	loadTopMenu = 0; //1-加载头部操作按钮，0-不加载头部操作按钮，主要用于多部门查询框。
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<!-- 2012-08-15 ypc 修改 添加了onclick() 事件 -->
	<BUTTON class=btn accessKey=O style="display:none" id=btnok onclick="btnok_onclick();"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>



	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<!-- 2012-08-15 ypc 修改 添加了onclick() 事件 -->
	<BUTTON class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>

<table width=100% class="ViewForm" valign="top">

	<!--######## Search Table Start########-->



	<TR>
	<td height=200 width="100%">
	<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" />
	<td>
	</tr>


	</table>
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
  <input class=inputstyle type="hidden" name="resourceids" >
  <input class=inputstyle type="hidden" name="showsubdept" >      
  <input class=inputstyle type="hidden" name="tabid" >
  <input class=inputstyle type="hidden" name="nodeid" >
  <input class=inputstyle type="hidden" name="companyid" >
  <input class=inputstyle type="hidden" name="subcompanyid" >
  <input class=inputstyle type="hidden" name="departmentid" >
	<!--########//Search Table End########-->
	<!-- 把body之外的js函数移到body体内 和radio不能选中同样道理需要初始化的函数写在body内 Google才识别 -->
	
	<script type="text/javascript">
		//2012-08-15 ypc 添加 原因是：本页面的 确定右键菜单的 事件处理是用vbs编写的 在Google和火狐是不能解析的 所以改为js start
		function btnok_onclick(){
			setResourceStr();
		    replaceStr();
		    window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
		    window.parent.parent.close();
		}
		
		function btnclear_onclick(){
		     window.parent.parent.returnValue = {id:"",name:""};
		     window.parent.parent.close();
		}
		//2012-08-15 ypc 添加 原因是：本页面的 确定右键菜单的 事件处理是用vbs编写的 在Google和火狐是不能解析的 所以改为js end
		function replaceStr(){
		    var re=new RegExp("[ ]*[|]*[|]","g")
		    resourcenames=resourcenames.replace(re,"|")
		    re=new RegExp("[|][^,]*","g")
		    resourcenames=resourcenames.replace(re,"")
		}
		function setSubcompany(nodeid){
		    setCookie("departmentmultiOrder<%=uid%>","<%=tabid%>|"+nodeid);
		    subid=nodeid.substring(nodeid.lastIndexOf("_")+1)
		    document.all("companyid").value=""
		    document.all("departmentid").value=""
		    document.all("subcompanyid").value=subid
		    document.all("tabid").value=0
		    document.all("nodeid").value=nodeid
		    doSearch()
		}
		function setCookie(name,val){
			var Then = new Date();
			Then.setTime(Then.getTime() + 30*24*3600*1000 );
			document.cookie = name+"="+val+";expires="+ Then.toGMTString() ;
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
		
		function btnsub_onclick(){
	//window.parent.parent.frame1.SearchForm.btnsub.click();
		var curDoc;
		if(document.all){
			curDoc=window.parent.frames["frame1"].document
		}
		else{
			curDoc=window.parent.document.getElementById("frame1").contentDocument	
		}
		$(curDoc).find("#btnsub")[0].click();
}
	</script>
</FORM>


<script language="javascript">
function initTree(){
//deeptree.init("/hrm/tree/ResourceMultiXML.jsp<%if(nodeid!=null){%>?init=true&nodeid=<%=nodeid%><%}%>");
//added by cyril on 2008-07-31 for td:9109
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

//设置选中的ID
cxtree_id = '<%=Util.null2String(nodeid)%>';
CXLoadTreeItem("", "/hrm/tree/ResourceMultiXML.jsp<%if(nodeid!=null){%>?init=true&nodeid=<%=nodeid%><%}%>");
var tree = new WebFXTree();
tree.add(cxtree_obj);
//document.write(tree);
document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();
//end by cyril on 2008-07-31 for td:9109
}
//to use xtree,you must implement top() and showcom(node) functions

function top(){
<%if(nodeid!=null){%>
try{
deeptree.scrollTop=<%=nodeid%>.offsetTop;
deeptree.HighlightNode(<%=nodeid%>.parentElement);
deeptree.ExpandNode(<%=nodeid%>.parentElement);
    setCookie("departmentmultiOrder<%=uid%>","<%=tabid%>|<%=nodeid%>");
 }catch(e){

    }
<%}%>
}

function showcom(node){
}

function check(node){
}
		function setCompany(id){
		    document.all("departmentid").value=""
		    document.all("subcompanyid").value=""
		    document.all("companyid").value=id
		    document.all("tabid").value=0
		    doSearch()
		}

		function setDepartment(nodeid){
			setCookie("departmentmultiOrder<%=uid%>","<%=tabid%>|"+nodeid);
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