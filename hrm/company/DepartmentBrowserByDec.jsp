<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@ page import="weaver.hrm.company.CompanyTreeNode"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
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
int beagenter = Util.getIntValue((String)session.getAttribute("beagenter_"+user.getUID()));
if(beagenter <= 0){
	beagenter = uid;
}
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String excludeid=Util.null2String(request.getParameter("excludeid"));
String nodename=Util.null2String(request.getParameter("nodename"));
String level=Util.null2String(request.getParameter("level"));
String subid=Util.null2String(request.getParameter("subid"));
String selectedDepartmentIds = Util.null2String(request.getParameter("selectedDepartmentIds"));
String passedDepartmentIds = Util.null2String(request.getParameter("passedDepartmentIds"));
String rightStr = Util.null2String(request.getParameter("rightStr"));
if ("".equals(rightStr)) {
	rightStr = "Departments:decentralization";
}
String selectedids = Util.null2String(request.getParameter("selectedids"));
int deptlevel = 0;
if(!"".equals(selectedids)&&!"0".equals(selectedids)){
	deptlevel = DepartmentComInfo.getLevelByDepId(selectedids);
}
String selectnode = selectedids;
String supcompanyid = "";
if(!"".equals(selectedids)&&!"0".equals(selectedids)){
supcompanyid = DepartmentComInfo.getSubcompanyid1(selectedids);
selectnode = supcompanyid+"_"+selectnode;
}

String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
int fieldid=Util.getIntValue(request.getParameter("fieldid"));
    int isdetail=Util.getIntValue(request.getParameter("isdetail"));
    int isbill=Util.getIntValue(request.getParameter("isbill"),1);
    boolean onlyselfdept=CheckSubCompanyRight.getDecentralizationAttr(beagenter, rightStr,fieldid,isdetail,isbill);
    boolean isall=CheckSubCompanyRight.getIsall();
    if(!isall){
        if(onlyselfdept){
            sqlwhere=" where departmentid in("+CheckSubCompanyRight.getDepartmentids()+")";
        }else{
            sqlwhere=" where subcompanyid1 in("+CheckSubCompanyRight.getSubcompanyids()+")";
        }
    }
String nodeid=null;
Cookie[] cks= request.getCookies();
String rem=null;
for(int i=0;i<cks.length;i++){
//System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
if(cks[i].getName().equals("departmentsingle"+uid)){
  rem=cks[i].getValue();
  break;
}
}
if(rem!=null&&rem.length()>0)
nodeid=rem;

boolean exist=false;
if(nodeid!=null&&nodeid.indexOf("dept")>-1){
    String deptname=DepartmentComInfo.getDepartmentname(nodeid.substring(nodeid.lastIndexOf("_")+1));
    String subcom=DepartmentComInfo.getSubcompanyid1(nodeid.substring(nodeid.lastIndexOf("_")+1));
    if(!deptname.equals("")&&subcom.equals(nodeid.substring(nodeid.indexOf("_")+1,nodeid.lastIndexOf("_")))&&!nodeid.substring(nodeid.lastIndexOf("_")+1).equals(excludeid))
        exist=true;
        if(!excludeid.equals("")){

            String idInCookie=nodeid.substring(nodeid.lastIndexOf("_")+1);
            List l=new ArrayList();
            SubCompanyComInfo.getDepartTreeList(l,subcom,excludeid,0,999,"",null,null);
            for(Iterator iter=l.iterator();iter.hasNext();){
                   CompanyTreeNode node=(CompanyTreeNode)iter.next() ;
                   if(node.getType().equals("dept")&&node.getId().equals(idInCookie)){
                       exist=false;
                       break;
                   }
            }

        }

}
if(!exist)
nodeid=null;
%>


<BODY onload="initTree()">
    <DIV align=right>
    <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
    <%
    BaseBean baseBean_self = new BaseBean();
    int userightmenu_self = 1;
    try{
    	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
    }catch(Exception e){}
    if(userightmenu_self == 1){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSave(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }
    %>
    <%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%if(userightmenu_self == 1){%>
    <script>
     rightMenu.style.visibility='hidden'
    </script>
<%}%>
    </DIV>

    <table   width=100% height=100% border="0" cellspacing="0" cellpadding="0">
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
                <TABLE  class=Shadow>
                    <tr>
                        <td valign="top">
                            <FORM NAME=select STYLE="margin-bottom:0" action="DepartmentBrowserByDec.jsp" method=post>
                                <input class=inputstyle type=hidden name=type value="<%=type%>">
                                <input class=inputstyle type=hidden name=id value="<%=id%>">
                                <input class=inputstyle type=hidden name=level value="<%=level%>">
                                <input class=inputstyle type=hidden name=subid value="<%=subid%>">
                                <input class=inputstyle type=hidden name=nodename value="<%=nodename%>">
                                <textarea style="display:none" name=passedDepartmentIds ><%=passedDepartmentIds%></textarea>
                                <textarea style="display:none" name=selectedDepartmentIds ><%=selectedDepartmentIds%></textarea>
                                <TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width:100%;">
                                     <TR class=Line1><TH colspan="4" ></TH></TR>
                                      <TR>
                                          <TD height=400 colspan="4" >
                                            <div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" />
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

<script language="javaScript">
//to use deeptree,you must implement following methods
var appendimg = 'subCopany_Colse';
var appendname = 'selObj';
var allselect = "all";
var selectedids = "<%=selectedids%>";
if(selectedids!="0"&&selectedids!=""){
	cxtree_id = "dept_<%=selectnode%>";
}
function initTree(){
CXLoadTreeItem("", "/hrm/tree/DepartmentSingleXMLByDec.jsp?rightStr=<%=rightStr%>&deptlevel=<%=deptlevel%>&onlyselfdept=<%=onlyselfdept%>&excludeid=<%=excludeid%><%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>&mathrandom="+Math.random());
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
				nameStr =  select.selObj[i].value;
				break;
			}
		}
	}
	arraytemp = nameStr.split("_");
    //----TD13905 start----
    //var resultStr=arraytemp[2];
    var resultStr = "0";
    if(arraytemp.length > 2) {
        resultStr=arraytemp[2];
    }
    //----TD13905 end------
	var strtmp2 = "";
	for(var i=0;i<arraytemp.length;i++){
		if(i>2){
			strtmp2 = strtmp2 + "_" + arraytemp[i];
		}
	}
	resultStr = resultStr + "$" + strtmp2.substring(1);
    return resultStr;   
    }
function onSave(){
	 var trunStr,returnVBArray;
 trunStr =  onSaveJavaScript();
 returnVBArray = trunStr.split("$");

 window.parent.parent.returnValue  = {id:returnVBArray[0],name:returnVBArray[1]};
 window.parent.parent.close();
}

function onClear(){
	window.parent.returnValue = {id:"",name:""};
  window.parent.close()
}
</script>
