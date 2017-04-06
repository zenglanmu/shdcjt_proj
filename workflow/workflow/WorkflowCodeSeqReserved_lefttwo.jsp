<%@ page language="java" contentType="text/html; charset=GBK" %> 

<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>

<script type="text/javascript" src="/js/xtree.js"></script>
<script type="text/javascript" src="/js/xmlextras.js"></script>
<script type="text/javascript" src="/js/cxloadtree.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree2.css" />

</HEAD>

<%

String isTemplate=Util.getIntValue(Util.null2String(request.getParameter("isTemplate")),0)+"";
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodename=Util.null2String(request.getParameter("nodename"));
String level=Util.null2String(request.getParameter("level"));
String subid=Util.null2String(request.getParameter("subid"));

String rightStr=Util.null2String(request.getParameter("rightStr"));
String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));

int uid=user.getUID();

String cnodeid=Util.null2String((String)session.getAttribute("treeleft_cnodeid"+isTemplate));

String nodeid=Util.null2String(request.getParameter("nodeid"));
String rem=(String)session.getAttribute("treeleft"+isTemplate);
        if(rem==null || cnodeid.equals("")){
        Cookie[] cks= request.getCookies();
        
        for(int i=0;i<cks.length;i++){

        if(rem==null && cks[i].getName().equals("treeleft"+isTemplate+uid)){
        rem=cks[i].getValue();
        }
        if(cnodeid.equals("") && cks[i].getName().equals("treeleft_cnodeid"+isTemplate+uid)){
            cnodeid=cks[i].getValue();
            }
        if(rem!=null && !cnodeid.equals("")) break;
        }
        }
if(rem!=null){
session.setAttribute("treeleft"+isTemplate,rem);
Cookie ck = new Cookie("treeleft"+isTemplate+uid,rem);  
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);
nodeid=rem;
}
if(!cnodeid.equals("")) {
	session.setAttribute("treeleft_cnodeid"+isTemplate,cnodeid);
	Cookie ck = new Cookie("treeleft_cnodeid"+isTemplate+uid,cnodeid);  
	ck.setMaxAge(30*24*60*60);
	response.addCookie(ck);
}


int subCompanyId=-1;
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel=0;

    if(detachable==1){  
        if(request.getParameter("subCompanyId")==null){
            subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("WorkflowCodeSeqReserved_subCompanyId")),-1);
        }else{
            subCompanyId=Util.getIntValue(request.getParameter("subCompanyId"),-1);
        }
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        session.setAttribute("WorkflowCodeSeqReserved_subCompanyId",String.valueOf(subCompanyId));
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"ReservedCode:Maintenance",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("ReservedCode:Maintenance", user))
            operatelevel=2;
    }
%>

<BODY onload="initTree()">
    <FORM NAME=SearchForm STYLE="margin-bottom:0" action="WorkflowCodeSeqReservedSet.jsp" method=post target="wfmainFrame">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>	

<table height="100%" width=100% class="ViewForm" valign="top">
	
	<!--######## Search Table Start########-->
	
	
	
	<TR>
	<td>
	<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" />
	<td>
	</tr>
	
	
	</table>
  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=sqlwhere%>'>
  <input class=inputstyle type="hidden" name="subCompanyId" >
  <input class=inputstyle type="hidden" name="nodeid" >
  <input class=inputstyle type="hidden" name="cnodeid" >

  <input type="hidden" name="isTemplate" value="<%=isTemplate%>">
    <!--########//Search Table End########-->
	</FORM>


<script language="javascript">
function initTree(){

//设置选中的ID
<%
String cxtree_id = "workflowtype_1";
if(!cnodeid.equals("") && !cnodeid.equals("0")) {
	cxtree_id = "workflow_"+cnodeid;
}
else {
	if(!Util.null2String(nodeid).equals("") && !nodeid.equals("0"))
		cxtree_id = "workflowtype_"+nodeid;
}
%>
cxtree_id = '<%=cxtree_id%>';

CXLoadTreeItem("", "/workflow/workflow/WorkflowCodeSeqReserved_lefttwoXML.jsp?&init=true&subCompanyId=<%=subCompanyId%>&operatelevel=<%=operatelevel%>&nodeid=<%=nodeid%>&sqlwhere=<%=sqlwhere%>");
var tree = new WebFXTree();
tree.add(cxtree_obj);

document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();

}



function top(){
<%if(nodeid!=null){%>
try{
deeptree.scrollTop=workflowtype_<%=nodeid%>.offsetTop;
deeptree.HighlightNode(workflowtype_<%=nodeid%>.parentElement);
deeptree.ExpandNode(workflowtype_<%=nodeid%>.parentElement);
}catch(e){}
<%}%>
}

function showcom(node){
}
function check(node){
	alert(node);
if(typeof(select.selObj.length)=='undefined'){
highlight(node);
deeptree.ExpandNode(node.parentElement);
return;
}
for(i=0;i<select.selObj.length;i++){
highlight(select.selObj[i].previousSibling);
}
deeptree.ExpandNode(node.parentElement); 
}


//end


function highlight(node){
if(node.nextSibling.checked)
node.style.color='red';
else
node.style.color='black';

}


    
function setSubCompany(subCompanyId){
    document.all("subCompanyId").value=subCompanyId;
    document.SearchForm.submit();
}


</script>



</BODY>
</HTML>