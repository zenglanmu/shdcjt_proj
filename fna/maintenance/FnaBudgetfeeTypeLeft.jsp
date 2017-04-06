<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.PageManagerUtil " %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="recordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="recordSet3" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session"/>

<HTML><HEAD>
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
    boolean canedit = HrmUserVarify.checkUserRight("FnaBudgetfeeTypeEdit:Edit", user);

    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(1011, user.getLanguage());
    String needfav = "1";
    String needhelp = "";
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver name=frmmain action=FnaBudgetfeeTypeView.jsp method=post STYLE="margin-bottom:0" target="contentframe">
    <input class=inputstyle type=hidden name=operation value="search">

<table width=100% border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td align="left"><img src="/images/treeimages/global.gif" onClick="onExtend(this,0,0,false);">
		<!--</td>
        <td width="90%">--><a href="#"
                           onClick="onParent('','0');"><%=SystemEnv.getHtmlLabelName(235, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(585, user.getLanguage())%></a>
        </td>
    </tr>
    <tr id="first_level" >
        <td width="100%" colspan=2 align=right>
            <table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
                <%
                    String sqlstr = "select id,name,feelevel from FnaBudgetfeeType where feelevel = 1 order by name";
                    recordSet.executeSql(sqlstr);
                    int i = 1;
                    while (recordSet.next()) {
                        String tmp1id = recordSet.getString(1);
                        String tmp1name = recordSet.getString(2);
                        String tmp1level = recordSet.getString(3);
                        String tmp1img = "";
                        if (i == recordSet.getCounts()) tmp1img = "/images/xp2/Lminus.png";
                        else tmp1img = "/images/xp2/Tminus.png";
                %>
                <tr>
                    <td align="left"><img src="<%=tmp1img%>"
                                          onClick="onExtend(this,'<%=tmp1id%>','<%=tmp1level%>',<%=(i==recordSet.getCounts())%>);">
                    <!--</td>
                    <td align="left">--><img src="/images/treeimages/Home.gif"><!--</td>
                    <td width="80%">--><a href="#" onClick="onParent('<%=tmp1id%>','<%=tmp1level%>');"><%=tmp1name%></a>
                    </td>
                </tr>
                <tr id="second_level_<%=tmp1id%>" style="display:block;">
                    <td width="100%" colspan=3 align=right>
                        <table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
                            <%
                                sqlstr = "select id,name,feelevel from FnaBudgetfeeType where feelevel = 2 and supsubject = " + tmp1id + " order by name";
                                recordSet2.executeSql(sqlstr);
                                int j = 1;
                                while (recordSet2.next()) {
                                    String tmp2id = recordSet2.getString(1);
                                    String tmp2name = recordSet2.getString(2);
                                    String tmp2level = recordSet2.getString(3);
                                    String tmp2img = "";
                                    if (j == recordSet2.getCounts()) tmp2img = "/images/xp2/L.png";
                                    else tmp2img = "/images/xp2/T.png";
                            %>
                            <tr>
                                <td><%if (i != recordSet.getCounts()) {%><img src="/images/xp2/I.png"><%} else {%><img
                                        src="/images/xp2/blank.png"><%}%></td>
                                <td align="left"><img src="<%=tmp2img%>"
                                                      onClick="onExtend(this,'<%=tmp2id%>','<%=tmp2level%>',<%=(j==recordSet2.getCounts())%>);">
                                </td>
                                <td align="left"><img src="/images/xp/openfolder.png"></td>
                                <td width="80%"><a href="#"
                                                   onClick="onParent('<%=tmp2id%>','<%=tmp2level%>');"><%=tmp2name%></a>
                                </td>
                            </tr>
                            <%
                                    j++;
                                }
                            %>
                        </table>
                    </td>
                </tr>
                <%
                        i++;
                    }
                %>
            </table>
        </td>
    </tr>
</table>
</FORM>

</body>
<SCRIPT language="javascript">
    function onExtend(img, id, level, islast) {
        if (level == 0) {
            if (document.getElementById("first_level").style.display == "none") {
                //img.src = "/images/xp/openfolder.png";
                document.getElementById("first_level").style.display = "block";
            } else {
                //img.src = "/images/xp/folder.png";
                document.getElementById("first_level").style.display = "none";
            }
        } else if (level == 1) {
            if (document.getElementById("second_level_" + id).style.display == "none") {
                if (islast) img.src = "/images/xp2/Lminus.png";
                else img.src = "/images/xp2/Tminus.png";
                document.getElementById("second_level_" + id).style.display = "block";
            } else {
                if (islast) img.src = "/images/xp2/Lplus.png";
                else img.src = "/images/xp2/Tplus.png";
                document.getElementById("second_level_" + id).style.display = "none";
            }
        }
    }
    function onParent(id, level) {
        document.frmmain.action = "FnaBudgetfeeTypeView.jsp?parent=" + id + "&level=" + level;
        document.frmmain.operation.value = "search";
        document.frmmain.submit();
    }
</script>
</html>