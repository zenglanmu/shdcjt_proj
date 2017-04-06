<!-- 
|last modified by cyril on 2008-07-31
|改写人力资源树
|将deepTree改成xtree,取消HTC控件
 -->
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<!-- added by cyril on 2008-07-31 for td:9109 -->
<script type="text/javascript" src="/js/xtree.js"></script>
<script type="text/javascript" src="/js/xmlextras.js"></script>
<script type="text/javascript" src="/js/cxloadtree.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree2.css" />
<!-- end by cyril on 2008-07-31 for td:9109 -->
</HEAD>


<%
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodename=Util.null2String(request.getParameter("nodename"));
String level=Util.null2String(request.getParameter("level"));
String subid=Util.null2String(request.getParameter("subid"));

int uid=user.getUID();
int tabid=0;


String nodeid=null;
String rem=(String)session.getAttribute("jobtitlesingle");
        if(rem==null){
        Cookie[] cks= request.getCookies();
        
        for(int i=0;i<cks.length;i++){
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if(cks[i].getName().equals("jobtitlesingle"+uid)){
        rem=cks[i].getValue();
        break;
        }
        }
        }
if(rem!=null){
rem=tabid+rem.substring(1);
session.setAttribute("jobtitlesingle",rem);
Cookie ck = new Cookie("jobtitlesingle"+uid,rem);
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

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

<BODY >
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MutiSelect.jsp" method=post target="frame2">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
BaseBean baseBean_self = new BaseBean();
int userightmenu_self = 1;
try{
	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
if(userightmenu_self == 1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:SearchForm.btnok.click(),_self} " ;//确定
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+", javascript:SearchForm.btnclear.click(),_self} " ;//清楚
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:SearchForm.btncancel.click(),_self} " ;//取消
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<BUTTON class=btn accessKey=1 style="display:none" id=btnok><U>1</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>

<BUTTON class=btn accessKey=2 style="display:none" id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>

<BUTTON class=btn accessKey=3 style="display:none" onclick="window.parent.close()" id=btncancel><U>3</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	
	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%if(userightmenu_self == 1){%>
<script>
rightMenu.style.visibility='hidden'
</script>	
<%}%>
<table width=100% class="ViewForm" valign="top" height="100%">
	
	<!--######## Search Table Start########-->
	
	
	
	<TR>
	<td height=170>
	<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" />
	<td>
	</tr>
	
	
	</table>
  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
  <input class=inputstyle type="hidden" name="tabid" >
  <input class=inputstyle type="hidden" name="companyid" >
  <input class=inputstyle type="hidden" name="subcompanyid" >
  <input class=inputstyle type="hidden" name="departmentid" >
  <input class=inputstyle type="hidden" name="nodeid" >
  <input class=inputstyle type="hidden" name="jobtitles" >
  <input class=inputstyle type="hidden" name="jobtitlesnames" >
	<!--########//Search Table End########-->
	</FORM>


<script language="javascript">
$(function(){
	initTree();
});
function initTree(){
cxtree_id = '<%=Util.null2String(nodeid)%>';
CXLoadTreeItem("", "/hrm/tree/ResourceSingleXML.jsp<%if(nodeid!=null){%>?init=true&nodeid=<%=nodeid%><%}%>");
var tree = new WebFXTree();
tree.add(cxtree_obj);
document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();
}


function top(){
<%if(nodeid!=null){%>
deeptree.scrollTop=<%=nodeid%>.offsetTop;
deeptree.HighlightNode(<%=nodeid%>.parentElement);
deeptree.ExpandNode(<%=nodeid%>.parentElement);
<%}%>
}

function showcom(node){
}

function check(node){
}

var jobtitles="";
var jobtitlesname="";

function setJobStr(){
	
	var jobtitles1 ="";
	var jobtitlesname1 = ""
    try{
		for(var i=0;i<parent.frame2.resourceArray.length;i++){
			jobtitles1 += ","+parent.frame2.resourceArray[i].split("~")[0] ;		
			jobtitlesname1 += ","+parent.frame2.resourceArray[i].split("~")[1] ;
		}
		jobtitles=jobtitles1;
		jobtitlesname=jobtitlesname1		
		//jobtitles=jobtitles.substring(1);
		//jobtitlesname=jobtitlesname.substring(1)
    }catch(err){}	
		
}

function replaceStr(){
    var re=new RegExp("[ ]*[|][^|]*[|]","g")
    jobtitlesname=jobtitlesname.replace(re,"|")
    re=new RegExp("[|][^,]*","g")
    jobtitlesname=jobtitlesname.replace(re,"")
}

function doSearch()
{
	setJobStr();
    document.all("jobtitles").value = jobtitles ;
    document.SearchForm.submit();
}

function setCompany(id){
    
    document.all("departmentid").value="";
    document.all("subcompanyid").value="";
    document.all("companyid").value=id;
    document.all("tabid").value=0;
    doSearch();
}
function setSubcompany(nodeid){ 
    
    subid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    document.all("companyid").value="";
    document.all("departmentid").value="";
    document.all("subcompanyid").value=subid;
    document.all("tabid").value=0;
    document.all("nodeid").value=nodeid;
    doSearch();
}
function setDepartment(nodeid){
    
    deptid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    document.all("subcompanyid").value="";
    document.all("companyid").value="";
    document.all("departmentid").value=deptid;
    document.all("tabid").value=0;
    document.all("nodeid").value=nodeid;
    doSearch();
}

function btnok_onclick(){
	alert("");
	setJobStr();
    replaceStr();
    window.parent.parent.returnValue = Array(jobtitles,jobtitlesname);
    window.parent.parent.close();
}

function btnclear_onclick(){
	window.parent.parent.returnValue = Array("0","")
    window.parent.parent.close
}

function btncancel_onclick(){
    window.parent.close();
}
$(function(){
	$("#btnok").click(btnok_onclick);
	$("#btnclear").click(btnclear_onclick);
	$("#btncancel").click(btncancel_onclick);
});
</script>
</SCRIPT>
</BODY>
</HTML>