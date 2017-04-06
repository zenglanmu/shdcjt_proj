<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.company.*" %>
<%@ page import="weaver.hrm.performance.goal.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="compInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="subCompInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
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
if (HrmUserVarify.checkUserRight("SubBudget:Maint", user)) {
    //out.println(subCompInfo.getFnaSubCompanyTreeJSByComp2());
	out.println(subCompInfo.getFnaSubCompanyTreeJSByComp(user.getUID(),"SubBudget:Maint"));
}
%>
document.write(tree);
tree.expand();
</script>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="FnaBudgetView.jsp" method=post target="contentframe">
<input class=inputstyle type="hidden" name="organizationid" >
<input class=inputstyle type="hidden" name="organizationtype" >
</FORM>
</body>
</html>


<script type="text/javascript">
function hiddleTree() {
    //window.parent.middleframe.document.body.click();
    jQuery(window.parent.middleframe.document.body).trigger("click");
}
function setCompany(id){
    hiddleTree();

    document.all("organizationtype").value="0"; //集团
    document.all("organizationid").value="1";

    document.SearchForm.submit();
}
function setSubcompany(nodeid){
    hiddleTree();

    subid=nodeid.substring(nodeid.lastIndexOf("_")+1)
    document.all("organizationtype").value="1"; //分部
    document.all("organizationid").value=subid;

    document.SearchForm.submit();
}
function setDepartment(nodeid){
    hiddleTree();

    deptid=nodeid.substring(nodeid.lastIndexOf("_")+1)
    document.all("organizationtype").value="2"; //部门
    document.all("organizationid").value=deptid;

    document.SearchForm.submit();
}

function setHrm(nodeid){
    hiddleTree();

    hrmid=nodeid.substring(nodeid.lastIndexOf("_")+1)
    document.all("organizationtype").value="3"; //人力资源
    document.all("organizationid").value=hrmid;

    document.SearchForm.submit();
}
</script>
<%--
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<HTML><HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
    <link href="/css/deepTree.css" rel="stylesheet" type="text/css">
</HEAD>


<%
    String needsystem = Util.null2String(request.getParameter("needsystem"));
    String seclevelto = Util.fromScreen(request.getParameter("seclevelto"), user.getLanguage());

    String type = Util.null2String(request.getParameter("type"));
    String id = Util.null2String(request.getParameter("id"));
    String nodename = Util.null2String(request.getParameter("nodename"));
    String level = Util.null2String(request.getParameter("level"));
    String subid = Util.null2String(request.getParameter("subid"));

    String rightStr = Util.null2String(request.getParameter("rightStr"));

    int uid = user.getUID();
    int tabid = 0;


    String nodeid = null;
    String rem = (String) session.getAttribute("treeleft");
    if (rem == null) {
        Cookie[] cks = request.getCookies();

        for (int i = 0; i < cks.length; i++) {
            //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
            if (cks[i].getName().equals("treeleft" + uid)) {
                rem = cks[i].getValue();
                break;
            }
        }
    }
    if (rem != null) {
        rem = tabid + rem.substring(1);
        session.setAttribute("treeleft", rem);
        Cookie ck = new Cookie("treeleft" + uid, rem);
        ck.setMaxAge(30 * 24 * 60 * 60);
        response.addCookie(ck);

        String[] atts = Util.TokenizerString2(rem, "|");
        if (atts.length > 1)
            nodeid = atts[1];
    }

    boolean exist = false;
    if (nodeid != null && nodeid.indexOf("com") > -1) {
        exist = SubCompanyComInfo.getSubCompanyname(nodeid.substring(nodeid.lastIndexOf("_") + 1)).equals("") ? false : true;
    } else if (nodeid != null && nodeid.indexOf("dept") > -1) {
        String deptname = DepartmentComInfo.getDepartmentname(nodeid.substring(nodeid.lastIndexOf("_") + 1));
        String subcom = DepartmentComInfo.getSubcompanyid1(nodeid.substring(nodeid.lastIndexOf("_") + 1));
        if (!deptname.equals("") && subcom.equals(nodeid.substring(nodeid.indexOf("_") + 1, nodeid.lastIndexOf("_"))))
            exist = true;
        else
            exist = false;
    }
    if (!exist)
        nodeid = null;


%>

<BODY onload="initTree()">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/hrm/search/HrmResourceSearchTmp.jsp" method=post
      target="contentframe">
    <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>


    <BUTTON class=btn accessKey=2 style="display:none" id=btnclear><U>2</U>
        -<%=SystemEnv.getHtmlLabelName(311, user.getLanguage())%></BUTTON>

    <%@ include file="/systeminfo/RightClickMenu.jsp" %>
    <script>
        rightMenu.style.visibility = 'hidden'
    </script>

    <table height="100%" width=100% class="ViewForm" valign="top">

        <!--######## Search Table Start########-->


        <TR>
            <td height="100%">
                <div id="deeptree" class="deeptree" CfgXMLSrc="/css/TreeConfig.xml"/>
            <td>
        </tr>


    </table>
    <input class=inputstyle type="hidden" name="sqlwhere"
           value='<%=Util.null2String(request.getParameter("sqlwhere"))%>'>
    <input class=inputstyle type="hidden" name="tabid">
    <input class=inputstyle type="hidden" name="companyid">
    <input class=inputstyle type="hidden" name="subCompanyId">
    <input class=inputstyle type="hidden" name="departmentid">
    <input class=inputstyle type="hidden" name="id">
    <input class=inputstyle type=hidden name=seclevelto value="<%=seclevelto%>">
    <input class=inputstyle type=hidden name=needsystem value="<%=needsystem%>">
    <!--########//Search Table End########-->
</FORM>


<script language="javascript">
    function initTree() {
        deeptree.init("/hrm/tree/HrmCompany_XML.jsp?rightStr=<%=rightStr%><%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>");
    }

    //to use xtree,you must implement top() and showcom(node) functions

    function top() {
    <%if(nodeid!=null){%>
        deeptree.scrollTop =
    <%=nodeid%>.
        offsetTop;
        deeptree.HighlightNode(<%=nodeid%>.parentElement
    )
        ;
        deeptree.ExpandNode(<%=nodeid%>.parentElement
    )
        ;
    <%}%>
    }

    function showcom(node) {
    }

    function check(node) {
    }

    function setCompany(nodeid) {

        comid = nodeid.substring(nodeid.lastIndexOf("_") + 1);
        document.all("departmentid").value = "";
        document.all("subCompanyId").value = "";
        document.all("id").value = comid;
        document.all("tabid").value = 0;
        document.SearchForm.action = "/fna/budget/FnaBudgetView.jsp?organizationid=" + comid + "&organizationtype=0";
        document.SearchForm.submit();
    }
    function setSubcompany(nodeid) {

        subid = nodeid.substring(nodeid.lastIndexOf("_") + 1);
        document.all("companyid").value = "";
        document.all("departmentid").value = "";
        document.all("subCompanyId").value = subid;
        document.all("tabid").value = 0;
        document.all("id").value = subid;
        document.SearchForm.action = "/fna/budget/FnaBudgetView.jsp?organizationid=" + subid + "&organizationtype=1";
        document.SearchForm.submit();
    }
    function setDepartment(nodeid) {

        deptid = nodeid.substring(nodeid.lastIndexOf("_") + 1);
        document.all("subCompanyId").value = "";
        document.all("companyid").value = "";
        document.all("departmentid").value = deptid;
        document.all("tabid").value = 0;
        document.all("id").value = deptid;
        document.SearchForm.action = "/fna/budget/FnaBudgetView.jsp?organizationid=" + deptid + "&organizationtype=2";
        document.SearchForm.submit();
    }
    <%
    /* Todo 人力资源
    function setHrm(nodeid){
         document.all("type_d").value="3" //人力资源
        hrmid=nodeid.substring(nodeid.lastIndexOf("_")+1)
        document.all("subcompanyid").value=""
        document.all("companyid").value=""
        document.all("departmentid").value=""
        document.all("hrmid").value=hrmid
        document.all("objId").value=hrmid
        document.all("tabid").value=0
        document.all("nodeid").value=nodeid
        doSearch(hrmid)
    }
    */
    %>
</script>


<SCRIPT LANGUAGE=VBS>
    Sub btnclear_onclick()
    window.parent.returnvalue = Array("", "")
    window.parent.close
    End Sub
</SCRIPT>
</BODY>
</HTML>
--%>