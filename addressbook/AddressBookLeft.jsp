<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.company.*" %>
<%@ page import="weaver.hrm.performance.goal.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="compInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="subCompInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<%!
private String getSubCompanyTreeJSByComp2() throws Exception{
    String subCompanyIcon = "/images/treeimages/home16.gif";
    String departmentIcon = "/images/treeimages/dept16.gif";
    String hrmResourceIcon = "/images/treeimages/user16.gif";
    RecordSet budgetrs = new RecordSet();

    String str = "";
    SubCompanyComInfo rs = new SubCompanyComInfo();
    rs.setTofirstRow();
    while(rs.next()){
        String supsubcomid = rs.getSupsubcomid();
        if(!supsubcomid.equals("0")) continue;
        String id = rs.getSubCompanyid();
        String name = rs.getSubCompanyname(); 
        String canceled = rs.getCompanyiscanceled();
        String flowName = GoalUtil.getCheckFlow(Integer.parseInt(id),"1");
        if(!"1".equals(canceled))
        {
            str += "tree.add(rti = new WebFXLoadTreeItem('"+name+"','AddressBookLeftTree.jsp?subCompanyId="+id+"',\"setSubcompany('com_"+id+"')\",'','"+subCompanyIcon+"','"+subCompanyIcon+"'));";
        }
        else
        {
            String sql = "select * from FnaBudgetInfo a where a.budgetorganizationid="+id;
            budgetrs.execute(sql);
            if(budgetrs.next())
            {
                str += "tree.add(rti = new WebFXLoadTreeItem('"+name+"','AddressBookLeftTree.jsp?subCompanyId="+id+"',\"setSubcompany('com_"+id+"')\",'','"+subCompanyIcon+"','"+subCompanyIcon+"'));";
            }
        }
    }
    return str;
}
%>

<%
String imagefilename = "/images/hdHRM.gif";
String titlename = SystemEnv.getHtmlLabelName(18041,user.getLanguage()) + " - " + SystemEnv.getHtmlLabelName(18043,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%
String companyIcon = "/images/treeimages/global16.gif";
String flowName = GoalUtil.getCheckFlow(0,"0");
%>
<HTML>
<HEAD>
<link type="text/css" rel="stylesheet" href="/css/Weaver.css">
<link type="text/css" rel="stylesheet" href="/js/xloadtree/xtree.css">
<style>
TABLE.Shadow A {
	COLOR: #333; TEXT-DECORATION: none
}
TABLE.Shadow A:hover {
	COLOR: #333; TEXT-DECORATION: none
}

TABLE.Shadow A:link {
	COLOR: #333; TEXT-DECORATION: none
}
TABLE.Shadow A:visited {
	TEXT-DECORATION: none
}
</style>
<script type="text/javascript" src="/js/xloadtree/xtree4goal.js"></script>
<script type="text/javascript" src="/js/xloadtree/xloadtree4goal.js"></script>
<script type="text/javascript" src="/js/xmlextras.js"></script>
</head>
<body style="padding:5px">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<script type="text/javascript">
webFXTreeConfig.blankIcon		= "/images/xp2/blank.png";
webFXTreeConfig.lMinusIcon		= "/images/xp2/Lminus.png";
webFXTreeConfig.lPlusIcon		= "/images/xp2/Lplus.png";
webFXTreeConfig.tMinusIcon		= "/images/xp2/Tminus.png";
webFXTreeConfig.tPlusIcon		= "/images/xp2/Tplus.png";
webFXTreeConfig.iIcon			= "/images/xp2/I.png";
webFXTreeConfig.lIcon			= "/images/xp2/L.png";
webFXTreeConfig.tIcon			= "/images/xp2/T.png";

var tree = new WebFXTree('<%=compInfo.getCompanyname("1")%>','<%if (HrmUserVarify.checkUserRight("HeadBudget:Maint", user)){%>setCompany(0);<%}%>','','<%=companyIcon%>','<%=companyIcon%>');
<%
//if (HrmUserVarify.checkUserRight("SubBudget:Maint", user)) {
    out.println(getSubCompanyTreeJSByComp2());
//}
%>
document.write(tree);
tree.expand();
</script>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="AddressBookView.jsp" method=post target="contentframe">
<input class=inputstyle type="hidden" name="organizationid" >
<input class=inputstyle type="hidden" name="organizationtype" >
</FORM>
</body>
</html>


<script type="text/javascript">
function hiddleTree() {
    window.parent.middleframe.document.body.click();
}
function setCompany(id){
    //hiddleTree();

    document.all("organizationtype").value="0"; //集团
    document.all("organizationid").value="1";

    document.SearchForm.submit();
}
function setSubcompany(nodeid){
    //hiddleTree();

    subid=nodeid.substring(nodeid.lastIndexOf("_")+1)
    document.all("organizationtype").value="1"; //分部
    document.all("organizationid").value=subid;

    document.SearchForm.submit();
}
function setDepartment(nodeid){
    //hiddleTree();

    deptid=nodeid.substring(nodeid.lastIndexOf("_")+1)
    document.all("organizationtype").value="2"; //部门
    document.all("organizationid").value=deptid;

    document.SearchForm.submit();
}

function setHrm(nodeid){
    //hiddleTree();

    hrmid=nodeid.substring(nodeid.lastIndexOf("_")+1)
    document.all("organizationtype").value="3"; //人力资源
    document.all("organizationid").value=hrmid;

    document.SearchForm.submit();
}
</script>