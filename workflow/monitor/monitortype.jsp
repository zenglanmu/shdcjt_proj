<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/systeminfo/init.jsp"%>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<HTML>
	<HEAD>
		<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
		<script type="text/javascript" src="/js/xtree.js"></script>
		<script type="text/javascript" src="/js/xmlextras.js"></script>
		<script type="text/javascript" src="/js/cxloadtree.js"></script>
		<link type="text/css" rel="stylesheet" href="/css/xtree2.css" />
	</HEAD>


	<%
		String needsystem = Util.null2String(request.getParameter("needsystem"));
		String seclevelto = Util.fromScreen(request.getParameter("seclevelto"), user.getLanguage());
		String isTemplate = Util.getIntValue(Util.null2String(request.getParameter("isTemplate")), 0) + "";
		String type = Util.null2String(request.getParameter("type"));
		String id = Util.null2String(request.getParameter("id"));
		String nodename = Util.null2String(request.getParameter("nodename"));
		String level = Util.null2String(request.getParameter("level"));
		String subid = Util.null2String(request.getParameter("subid"));

		String rightStr = Util.null2String(request.getParameter("rightStr"));

		int uid = user.getUID();
		int tabid = 0;

		//modified by cyril on 2008-08-20 for td:9215
		String cnodeid = Util.null2String((String) session.getAttribute("treeleft_cnodeid" + isTemplate));
		//out.println("1 cnodeid="+cnodeid);
		String nodeid = Util.null2String(request.getParameter("nodeid"));
		String rem = (String) session.getAttribute("treeleft" + isTemplate);
		if (rem == null || cnodeid.equals(""))
		{
			Cookie[] cks = request.getCookies();

			for (int i = 0; i < cks.length; i++)
			{
				//System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
				if (rem == null && cks[i].getName().equals("treeleft" + isTemplate + uid))
				{
					rem = cks[i].getValue();
				}
				if (cnodeid.equals("") && cks[i].getName().equals("treeleft_cnodeid" + isTemplate + uid))
				{
					cnodeid = cks[i].getValue();
				}
				if (rem != null && !cnodeid.equals(""))
					break;
			}
		}
		if (rem != null)
		{
			session.setAttribute("treeleft" + isTemplate, rem);
			Cookie ck = new Cookie("treeleft" + isTemplate + uid, rem);
			ck.setMaxAge(30 * 24 * 60 * 60);
			response.addCookie(ck);
			nodeid = rem;
		}
		if (!cnodeid.equals(""))
		{
			session.setAttribute("treeleft_cnodeid" + isTemplate, cnodeid);
			Cookie ck = new Cookie("treeleft_cnodeid" + isTemplate + uid, cnodeid);
			ck.setMaxAge(30 * 24 * 60 * 60);
			response.addCookie(ck);
		}

		int subcompanyid = -1;
		int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);
		int operatelevel = 0;

		if (detachable == 1)
		{
			//if (request.getParameter("subcompanyid") == null)
			//{
			//	subcompanyid = Util.getIntValue(String.valueOf(session.getAttribute("managemonitor_subcompanyid")), -1);
			//}
			//else
			//{
			//	subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"), -1);
			//}
			//if (subcompanyid == -1)
			//{
			//	subcompanyid = user.getUserSubCompany1();
			//}
			subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"), -1);
			//session.setAttribute("managemonitor_subcompanyid", String.valueOf(subcompanyid));
			if(subcompanyid>0)
				operatelevel = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowMonitor:All", subcompanyid);
		}
		else
		{
			if (HrmUserVarify.checkUserRight("WorkflowMonitor:All", user))
				operatelevel = 2;
		}
	%>

	<BODY onload="initTree()">
		<FORM NAME=SearchForm STYLE="margin-bottom: 0" action="/system/systemmonitor/workflow/systemMonitorStatic.jsp"
			method=post target="wfmainFrame">
			<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
			<%@ include file="/systeminfo/RightClickMenu.jsp"%>
			<script>
				rightMenu.style.visibility='hidden'
			</script>

			<table height="100%" width=100% class="ViewForm" valign="top">
				<TR>
					<td>
						<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" />
					<td>
				</tr>
			</table>
			<input class=inputstyle type="hidden" name="sqlwhere" value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
			<input class=inputstyle type="hidden" name="tabid">
			<input class=inputstyle type="hidden" name="companyid">
			<input class=inputstyle type="hidden" name="subcompanyid">
			<input class=inputstyle type="hidden" name="departmentid">
			<input class=inputstyle type="hidden" name="nodeid">
			<input class=inputstyle type="hidden" name="cnodeid">
			<input class=inputstyle type=hidden name=seclevelto value="<%=seclevelto%>">
			<input class=inputstyle type=hidden name=needsystem value="<%=needsystem%>">
			<input type="hidden" name="isTemplate" value="<%=isTemplate%>">
			<!--########//Search Table End########-->
		</FORM>


		<script language="javascript">
function initTree()
{
	//设置选中的ID
	<%
	String cxtree_id = "workflowmonitor_1";
	if(!cnodeid.equals("") && !cnodeid.equals("0")) {
		cxtree_id = "workflowmonitor_"+cnodeid;
	}
	else {
		if(!Util.null2String(nodeid).equals("") && !nodeid.equals("0"))
			cxtree_id = "workflowmonitor_"+nodeid;
	}
	%>
	cxtree_id = '<%=cxtree_id%>';
	CXLoadTreeItem("", "/workflow/monitor/MonitorXML.jsp?isTemplate=<%=isTemplate%>&init=false&subcompanyid=<%=subcompanyid%>&operatelevel=<%=operatelevel%>&nodeid=<%=nodeid%>");
	var tree = new WebFXTree();
	tree.add(cxtree_obj);
	document.getElementById('deeptree').innerHTML = tree;
	cxtree_obj.expand();
}

function top()
{
	<%if(nodeid!=null){%>
	try{
		deeptree.scrollTop=workflowmonitor_<%=nodeid%>.offsetTop;
		deeptree.HighlightNode(workflowmonitor_<%=nodeid%>.parentElement);
		deeptree.ExpandNode(workflowmonitor_<%=nodeid%>.parentElement);
	}catch(e){}
	<%}%>
}

function showcom(node)
{
	
}
function check(node)
{
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
function highlight(node){
	if(node.nextSibling.checked)
		node.style.color='red';
	else
		node.style.color='black';
}

function onSaveJavaScript()
{
    var idStr="";
    var nameStr="";
    var nodeidStr="";
    if(typeof(select.selObj.length)=="undefined") 
    {
		if(select.selObj.checked) 
		{
			var kids = select.selObj.parentNode.childNodes;
			
			for(var j=0;j<kids.length;j++){
				if(kids[j].type=="label") {
					
						nameStr +=kids[j].innerText;
						nodeidStr+=kids[j].id;
						var temp = select.selObj.value;
				                idStr+=temp;													
						break;
						
				}
			}
		}
	}
	else 
	{
		for(var i=0;i<select.selObj.length;i++) {
			if(select.selObj[i].checked) {
			var kids = select.selObj[i].parentNode.childNodes;
				for(var j=0;j<kids.length;j++){
					if(kids[j].type=="label") {
					        				    
						nameStr +=kids[j].innerText;
						nodeidStr+=kids[j].id;
						var temp = select.selObj[i].value;
				                idStr+=temp;													
						break;
						
					}
				}
							
											
				
			}
		}
	}
    return idStr +"_" + nameStr;   
}
    
function setSubCompany(subcompanyid){
    document.all("subcompanyid").value=subcompanyid;
    document.SearchForm.submit();
}


</script>
<script language="vbScript">
 sub onSave()    
    dim trunStr,returnVBArray
    trunStr =  onSaveJavaScript() 
    returnVBArray = Split(trunStr,"_",-1,0)    
    window.parent.returnValue  = returnVBArray
    window.parent.close     
end sub

sub onClear()
     window.parent.returnValue = Array(0,"","")
     window.parent.close
end sub
</script>
</BODY>
</HTML>