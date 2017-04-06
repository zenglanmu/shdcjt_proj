<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%
String acceptlanguage = request.getHeader("Accept-Language");
if(!"".equals(acceptlanguage))
	acceptlanguage = acceptlanguage.toLowerCase();
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gbk" />
<title>ActiveX</title>
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
}
.STYLE1 {
	color: #3169ce;
	font-weight: bold;
	font-size: 13px;
}
.STYLE2 {font-size: 13px}
.STYLE3 {
	color: #3169ce;
	font-size: 12px;
}
.STYLE4 {font-size: 12px}
.STYLE8 {font-size: 12px; font-weight: bold; }
-->
</style>
<script language="javascript" src="/js/activex/ActiveX.js"></script>
		<script language="javascript">
            <!--
function getOuterLanguage()
{
	return '<%=acceptlanguage%>';
}
if (window.Event)
  document.captureEvents(Event.MOUSEUP);

function nocontextmenu()
{
 event.cancelBubble = true
 event.returnValue = false;

 return false;
}

function norightclick(e)
{
 if (window.Event)
 {
  if (e.which == 2 || e.which == 3)
   return false;
 }
 else
  if (event.button == 2 || event.button == 3)
  {
   event.cancelBubble = true
   event.returnValue = false;
   return false;
  }

}

document.oncontextmenu = nocontextmenu;  // for IE5+
document.onmousedown = norightclick;  // for all others
//-->
			// Array(控件名称, ProgID, 版本, 说明)
			var aActiveXs = new Array();

			function window.onload()
			{
				insertActiveXRows(<%=user.getLanguage()%>);
                window.setInterval("refreshState()", 5000);
			}

			// 插入控件行，创建控件列表
			function insertActiveXRows(language)
			{
                var chasm = screen.availWidth;
                var mount = screen.availHeight;
                if(chasm<650) chasm=650;
                if(mount<700) mount=700;
				var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
				xmlDoc.async = false;
				xmlDoc.resolveExternals = false;
				if(language==8){
                    xmlDoc.load("/activex/ActiveXEN.xml");
                }
                <%if(acceptlanguage.indexOf("zh-tw")>-1||acceptlanguage.indexOf("zh-hk")>-1){%>
		            xmlDoc.load("/activex/ActiveXBIG5.xml");
		        <%}else{%>
		        if(language!=8){
		            xmlDoc.load("/activex/ActiveX.xml");
		        }
		        <%}%>
				if (xmlDoc.parseError.errorCode != 0)
				{
					var myError = xmlDoc.parseError;
					alert("You have error " + myError.reason);
				}
				else
				{
					var xmlActveXNodes;
					var sName, sCLSID, sCLSName, sProgID, sVersion, sCheckPageURL;

					// 找所有控件节点，生成行记录数据
					xmlActveXNodes = xmlDoc.selectNodes("//activex");
					for (var i = 0; i < xmlActveXNodes.length; i++)
					{
						sName = xmlActveXNodes[i].selectSingleNode("name").text;
						sCLSID = xmlActveXNodes[i].selectSingleNode("clsid").text;
						sCLSName = xmlActveXNodes[i].selectSingleNode("clsname").text;
						sProgID = xmlActveXNodes[i].selectSingleNode("progid").text;
						sVersion = xmlActveXNodes[i].selectSingleNode("version").text;
						sCheckPageURL = xmlActveXNodes[i].selectSingleNode("checkpageurl").text;
						aActiveXs[aActiveXs.length] = new Array(sName, sCLSID, sCLSName, sProgID, sVersion, sCheckPageURL);
					}


					// 插入行
					var oTable, oTr, oTd;
					var aProgID, acheckver, bInstalled;

					oTable = document.all("tblActiveXList");
					for (var i = 0; i < aActiveXs.length; i++)
					{
						bInstalled = true;
                        aProgID=aActiveXs[i][3];
						if (!Detect(aProgID))
						{
							bInstalled = false;
						}

						oTr = oTable.insertRow();
						oTr.style.height = 40;

						oTd = oTr.insertCell(0);
                        oTd.width=38;
                        oTd.align = "center";
						oTd.innerHTML = "<span class=STYLE4>"+(i+1).toString(10)+"</span>";
                        oTd = oTr.insertCell(1);
                        oTd.width=2;
						oTd.innerHTML ="";

						oTd = oTr.insertCell(2);
                        oTd.width=90;
						oTd.innerHTML = "<span class=STYLE4>"+aActiveXs[i][0]+"</span>";
                        oTd = oTr.insertCell(3);
                        oTd.width=2;
						oTd.innerHTML ="";

						oTd = oTr.insertCell(4);
                        oTd.width=220;
						oTd.innerHTML = "<span class=STYLE4>"+aActiveXs[i][1]+"</span>";
                        oTd = oTr.insertCell(5);
                        oTd.width=2;
						oTd.innerHTML ="";

						oTd = oTr.insertCell(6);
                        oTd.width=150;
						oTd.innerHTML = "<span class=STYLE4>"+aActiveXs[i][2]+"</span>";
                        oTd = oTr.insertCell(7);
                        oTd.width=2;
						oTd.innerHTML ="";

						oTd = oTr.insertCell(8);
                        oTd.width=50;
						oTd.innerHTML = "<span class=STYLE4>"+aActiveXs[i][4]+"</span>";
                        oTd = oTr.insertCell(9);
                        oTd.width=2;
						oTd.innerHTML ="";

						oTd = oTr.insertCell(10);
                        oTd.width=50;
                        oTd.align = "center";
                        oTd.id="oTd10_"+i;
						oTd.innerHTML = bInstalled?"<img src='/images/plugin/status.gif' width=14 height=14 />":"<img src='/images/plugin/wrong.gif' width=14 height=14 />";
                        if(bInstalled&&aProgID=="CHINAEXCELWEB.FormvwCtrl.1"){
                            bInstalled=checkActivexVersion(ChinaExcel,aActiveXs[i][4]);
                            if(bInstalled){
                                oTr.cells[10].innerHTML="<img src='/images/plugin/status.gif' width=14 height=14 /><br><span style='color:red;font-size:12px;'>(<%=SystemEnv.getHtmlLabelName(22007,user.getLanguage())%>)</span>";
                            }
                        }
                        oTd = oTr.insertCell(11);
                        oTd.width=2;
						oTd.innerHTML ="";

						oTd = oTr.insertCell(12);
                        oTd.width=50;
						oTd.innerHTML = "<img src='/images/plugin/botton.gif' style='cursor:hand;' width=50 height=21 onclick=\"Winopen('" + aActiveXs[i][5] + "','','scrollbars=yes,resizable=no,width=690,Height=615,top="+(mount-700)/2+",left="+(chasm-650)/2+"')\"/>";
                        oTr = oTable.insertRow();
                        oTd = oTr.insertCell();
                        oTd.colSpan = 13;
                        oTd.innerHTML="<img src='/images/plugin/line_0.gif'  height=1 >";
					}
				}
                delete(xmlDoc);
			}
            // 定时刷新状态
			function refreshState()
			{
				if (aActiveXs)
				{
					var oTable;
					var aProgID, bInstalled;
					var allInstalled=true;
					oTable = document.all("tblActiveXList");
					for (var i = 0; i < aActiveXs.length; i++)
					{
						bInstalled = true;
						aProgID = aActiveXs[i][3];
						if (!Detect(aProgID))
						{
							bInstalled = false;
						}
						document.all("oTd10_"+i).innerHTML = bInstalled?"<img src='/images/plugin/status.gif' width=14 height=14 />":"<img src='/images/plugin/wrong.gif' width=14 height=14 />";

                        if(bInstalled&&aProgID=="CHINAEXCELWEB.FormvwCtrl.1"){
                            bInstalled=checkActivexVersion(ChinaExcel,aActiveXs[i][4]);
                            if(bInstalled){
                                document.all("oTd10_"+i).innerHTML="<img src='/images/plugin/status.gif' width=14 height=14 /><br><span style='color:red;font-size:12px;'>(<%=SystemEnv.getHtmlLabelName(22007,user.getLanguage())%>)</span>";
                            }
                        }
					}
				}
			}
		</script>
</head>

<body>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="1" colspan="3"></td>
</tr>
<tr>
	<td width="10"></td>
	<td align="center" valign="top">
		<TABLE border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="57759F">
		<tr>
		<td >

<table width="100%" height="329" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
      <tr>
        <td height="64" background="/images/plugin/back.gif"><table width="231" height="24" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="35" height="24" rowspan="2" align="right" valign="middle"><img src="/images/plugin/icon_5.gif" width="24" height="26" align="absmiddle" /></td>
            <td width="196" height="22" valign="bottom"><span class="STYLE1"><span class="STYLE2">&nbsp;<%=SystemEnv.getHtmlLabelName(22006,user.getLanguage())%></span></span></td>
          </tr>
          <tr>
            <td height="2" valign="bottom">&nbsp;<img src="/images/plugin/line_1.gif" width="80" height="2" align="absmiddle" /></td>
          </tr>
        </table></td>
        </tr>
      <tr>
        <td  align="center" valign="middle">
            <table id="tblActiveXList" width="660" height="15" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38" align="center" valign="middle" background="/images/plugin/back_1.gif"><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></span></td>
            <td width="2" valign="middle" background="/images/plugin/back_1.gif"><img src="/images/plugin/line_2.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="90" align="center" valign="middle" background="/images/plugin/back_1.gif"><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(22009,user.getLanguage())%></span></td>
            <td width="2" background="/images/plugin/back_1.gif"><img src="/images/plugin/line_2.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="220" align="center" valign="middle" background="/images/plugin/back_1.gif"><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(22037,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></span></td>
            <td width="2" background="/images/plugin/back_1.gif"><img src="/images/plugin/line_2.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="150" align="center" valign="middle" background="/images/plugin/back_1.gif"><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(22037,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22009,user.getLanguage())%></span></td>
            <td width="2" background="/images/plugin/back_1.gif"><img src="/images/plugin/line_2.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="50" align="center" valign="middle" background="/images/plugin/back_1.gif"><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%></span></td>
            <td width="2" background="/images/plugin/back_1.gif"><img src="/images/plugin/line_2.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="45" align="center" valign="middle" background="/images/plugin/back_1.gif"><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></span></td>
            <td width="2" background="/images/plugin/back_1.gif"><img src="/images/plugin/line_2.gif" width="2" height="14" align="absmiddle" /></td>
            <td width="55" align="center" valign="middle" background="/images/plugin/back_1.gif"><span class="STYLE3"><%=SystemEnv.getHtmlLabelName(22011,user.getLanguage())%></span></td>
          </tr>
          <tr>
              <td colspan="13"><img src='/images/plugin/line_0.gif'  height=1 ></td>
          </tr>
        </table></td>
        </tr>

      <tr>
        <td height="10" align="center" valign="middle"></td>
      </tr>
      <tr>
        <td height="22"><img src="/images/plugin/icon_4.gif" width="25" height="25" align="absmiddle" /><span class="STYLE8">&nbsp;<%=SystemEnv.getHtmlLabelName(22019,user.getLanguage())%></span></td>
      </tr>
      <tr>
        <td height="22"><span class="STYLE4">&nbsp;<%=SystemEnv.getHtmlLabelName(22020,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%> C:\WINDOWS\Downloaded Program Files<%=SystemEnv.getHtmlLabelName(22024,user.getLanguage())%></span></td>
      </tr>
      <tr>
        <td height="22"><span class="STYLE4">&nbsp;<%=SystemEnv.getHtmlLabelName(22021,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22025,user.getLanguage())%></span></td>
      </tr>
      <tr>
        <td height="22"><span class="STYLE4">&nbsp;<%=SystemEnv.getHtmlLabelName(22022,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22026,user.getLanguage())%></span></td>
      </tr>
      <tr>
        <td height="22"><span class="STYLE4">&nbsp;&nbsp;1、<%=SystemEnv.getHtmlLabelName(22027,user.getLanguage())%> regedit.exe；</span></td>
      </tr>
      <tr>
        <td height="22"><span class="STYLE4">&nbsp;&nbsp;2、<%=SystemEnv.getHtmlLabelName(22028,user.getLanguage())%> {23739A7E-5741-4D1C-88D5-</span></td>
      </tr>
      <tr>
        <td height="22">&nbsp;&nbsp;<span class="STYLE4">D50B18F7C347}；</span></td>
      </tr>
      <tr>
        <td height="22"><span class="STYLE4">&nbsp;&nbsp;3、<%=SystemEnv.getHtmlLabelName(22029,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22027,user.getLanguage())%>“regsvr32 /u</span></td>
      </tr>
      <tr>
        <td height="22"><span class="STYLE4">&nbsp;&nbsp;&lt;<%=SystemEnv.getHtmlLabelName(22030,user.getLanguage())%>&gt;”<%=SystemEnv.getHtmlLabelName(22031,user.getLanguage())%></span></td>
      </tr>
      <tr>
        <td height="22"><span class="STYLE4">&nbsp;<%=SystemEnv.getHtmlLabelName(22023,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18890,user.getLanguage())%> <a href="#" style="color:blue;" onclick="OnCheckPage('/weaverplugin/PluginMaintenance.jsp',700,700)"><b><%=SystemEnv.getHtmlLabelName(22012,user.getLanguage())%></b></a> <%=SystemEnv.getHtmlLabelName(22032,user.getLanguage())%></span></td>
      </tr>
      <tr>
        <td height="10"><span class="STYLE4"></span></td>
      </tr>
      <tr>
        <td height="22"><span class="STYLE8 STYLE4">&nbsp;2、<%=SystemEnv.getHtmlLabelName(22033,user.getLanguage())%></span></td>
      </tr>
      <tr>
        <td height="22"><span class="STYLE4">&nbsp;<%=SystemEnv.getHtmlLabelName(22034,user.getLanguage())%></span></td>
      </tr>

      <tr>
        <td height="20">&nbsp;</td>
      </tr>
    </table>

</td>
		</tr>
	</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="1" colspan="3"></td>
</tr>
</table>
<div style="DISPLAY:none">
			<OBJECT id="ChinaExcel" height="0" hspace="0" width="0" vspace="0" classid="clsid:15261F9B-22CC-4692-9089-0C40ACBDFDD8"></OBJECT>
        </div>
</body>
</html>
