<%@ page language="java" contentType="text/html; charset=GB18030" pageEncoding="GB18030"%>

<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.setting.*" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.general.GCONST"%>
<%@ include file="/wui/common/page/initWui.jsp" %>
<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<%
//Map skinConfig = getProperties(this.getServletConfig().getServletContext().getRealPath("/") + "wui/skins/default/config.properties");
/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
  response.sendRedirect("/login/Login.jsp");
  return;
}
//当前主题
String curTheme = "";
//当前皮肤
String cskin = "";

curTheme = getCurrWuiConfig(session, user, "theme");
cskin = getCurrWuiConfig(session, user, "skin");

String ely6flg = "";
if ("ecology6".equals(curTheme.toLowerCase())) {
	curTheme = "ecology7";
	ely6flg = "ecology6";
}

List syskinsConfig = (List)application.getAttribute("APPLICATION_SYSTEM_SKINS_CONFIG");

if (syskinsConfig == null || syskinsConfig.isEmpty()) {
	String projectPath = this.getServletConfig().getServletContext().getRealPath("/");
	if (projectPath.lastIndexOf("/") != (projectPath.length() - 1) && projectPath.lastIndexOf("\\") != (projectPath.length() - 1)) {
		projectPath += "/";
	}
	
	syskinsConfig =  getAllSkinInfo(projectPath + "wui/theme/ecology7/skins/");	
	application.setAttribute("APPLICATION_SYSTEM_SKINS_CONFIG", syskinsConfig);
}
%>

<%

String theme = "";
String skin = "";
String logoTop = "";
String logoBottom = "";
int isopen = 0;
int islock = 0;
String lockProj = "";
weaver.systeminfo.template.UserTemplate  userTemplate = new weaver.systeminfo.template.UserTemplate();
userTemplate.getTemplateByUID(user.getUID(),user.getUserSubCompany1());

int extendtempletvalueid = userTemplate.getExtendtempletvalueid();
String sqltemplateid1 = "(select id from extandHpTheme where id=" + extendtempletvalueid + ")";
if(userTemplate.getTemplateId()==1&&user.getUserSubCompany1()!=0){
	sqltemplateid1 = "(select id from extandHpTheme where templateId=1 and subcompanyid = "+user.getUserSubCompany1()+")";
}
rsExtend.executeSql("select * from extandHpThemeItem where extandHpThemeId="+sqltemplateid1+" and isopen=1");
Map tepDbThemekv = new HashMap();
%>


<%!
private List getAllSkinInfo(String path) {
    List syskinsConfig = null;
    if (path == null || "".equals(path)) {
        return null;
    }
    
    File parentFile = new File(path);
    
    if (!parentFile.exists() || !parentFile.isDirectory()) {
        return null;
    }
    syskinsConfig = new ArrayList();
    File[] files = parentFile.listFiles();
    for (int i = 0; i < files.length; i++) {
        File item = files[i];
        if (item.isDirectory()) {
        	syskinsConfig.add(getProperties(path + item.getName() + "/config.properties"));
        }
    }
    
    return syskinsConfig;
}

private Map getProperties(String propertyPath) {
	Map skinConfig = new HashMap();
	
	Properties config = new Properties();
	try {
		config.load(new FileInputStream(propertyPath));
	} catch (IOException e) {
		e.printStackTrace();
		return skinConfig;
	} 
	
	Enumeration enumeration = config.propertyNames();
	
	while (enumeration.hasMoreElements()) {
		String key = (String)enumeration.nextElement();
		String value = config.getProperty(key, "");
		skinConfig.put(key, value);
	}
	return skinConfig;
}
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<!-- jquery1.4 -->
<script type="text/javascript" src="/wui/common/jquery/jquery.js"></script>

<title></title>
<script type="text/javascript">

$(document).ready(function(){
	//皮肤项缩略效果
	$(".sltFlgClass").hover(function() {
		$(this).removeClass("skinItemThumbnailBg");	
		$(this).addClass("skinItemThumbnailSltBg");	
	}, function () {
		$(this).removeClass("skinItemThumbnailSltBg");
		$(this).addClass("skinItemThumbnailBg");	
	});
	
	$(".moreFlgClass").hover(function() {
		$(this).css("background", "url(/wui/theme/ecology7/page/images/skin/moreSlt.png) no-repeat");	
		
	}, function () {
		$(this).css("background", "url(/wui/theme/ecology7/page/images/skin/more.png) no-repeat");	
	});
});

function changeSysSkin(clickEle) {
    if (clickEle != null && clickEle != undefined) {
	    var skinFolder = $(clickEle).attr("_skin");
	    var themeName = $(clickEle).attr("_theme");
	    if (skinFolder != null && skinFolder != undefined && skinFolder != "") {
	        if (window.confirm("切换主题会重新加载页面，您确定要切换吗？")) {
	           parent.window.location.href = "/wui/theme/ecology7/page/skinSetting.jsp?skin=" + skinFolder + "&theme=" + themeName;
	           parentDialog.close();
	           return;
	        }
	    }
    }
    
}
</script>

<style type="text/css">
/* 皮肤Block */
.skinListBlock {
	width:420px;
}

/* 皮肤单项Block */
.skinItemBlock {
	width:130px;height:110px;margin-left:5px;margin-right:5px;margin-bottom:10px;float:left;
}

/* 皮肤单项缩略图Block */
.skinItemThumbnailBlock {
	height:80px;width:130px;margin-top:5px;margin-bottom:0px;border:none;
}

/* 皮肤单项缩略图 */
.skinItemThumbnail {
	height:68px;width:118px;border:none;margin:6px;
}

/* 皮肤单项名称Block */
.skinItemNameBlock {
	height:18px;width:100%;text-align:center;overflow:hidden;font-size:12px;margin-top:0px;color:#3399cc;
}

.skinItemThumbnailBg {
	background:url(/wui/theme/ecology7/page/images/skin/previewBorder.png) no-repeat;
}
.skinItemThumbnailSltBg {
	background:url(/wui/theme/ecology7/page/images/skin/previewSltBorder.png) no-repeat;
}
</style>
</head>
<script type="text/javascript">
  document.oncontextmenu=function(){return   false;}
</script>
<body style="font-family:微软雅黑;font-size:12px;" onclick="">
<table cellpadding="0" cellspacing="0" width="470px">
	<tr>
		<td align="center" width="100%">
		
<div class="skinListBlock">
	<span style="margin-left:10px;width:100%;display:block;text-align:left;color:#3399cc;font-size:12px;">
		<span style="font-size:12px;">您可以在下面7.0系统主题列表中选择符合您操作习惯的主题。</span>
	</span>
	<span style="margin-left:10px;width:420px;;height:3px;overflow:hidden;display:block;margin-bottom:10px;margin-top:5px;border-top:1px dotted #bfbfbf;"></span>
	<table cellpadding="0px" cellspacing="0px" width="100%">
		<tr align="center">
			<td>
		<%
		
		int trflag = 0;
		for (int i=0; rsExtend.next(); i++) {
			//至多显示5个
			if (i >= 5) {
				break;
			}
			theme = Util.null2String(rsExtend.getString("theme"));
			skin = Util.null2String(rsExtend.getString("skin"));
			
			String projectPath = this.getServletConfig().getServletContext().getRealPath("/");
			if (projectPath.lastIndexOf("/") != (projectPath.length() - 1) && projectPath.lastIndexOf("\\") != (projectPath.length() - 1)) {
				projectPath += "/";
			}
			
			Map skinConfig = getProperties(projectPath + "wui/theme/" + theme + "/skins/" + skin + "/config.properties");
			String id = (String)skinConfig.get("id");
			String name = (String)skinConfig.get("name");
			String description = (String)skinConfig.get("description");
			String date = (String)skinConfig.get("date");
			String author = (String)skinConfig.get("author");
			String isBuy = (String)skinConfig.get("isBuy");
			String preview = (String)skinConfig.get("preview");
			String home = (String)skinConfig.get("home");
			
 		%>
				<div class="skinItemBlock">
					<div class="skinItemThumbnailBlock skinItemThumbnailBg sltFlgClass" _theme="<%=theme %>" _skin="<%=skin %>" <%=(cskin.equals(skin) && curTheme.equals(theme)) ? "" : "onclick=\"javascript:changeSysSkin(this);\" style='cursor:hand;'" %>>
						<img src="/wui/theme/<%=theme%>/skins/<%=skin%>/preview.png" class="skinItemThumbnail" title="<%=theme %>-<%=name %>"/>
					</div>
					<div class="skinItemNameBlock"><%=theme %>-<%=name %></div>
				</div>
		<%
		}
		String isOpenSoftAndSiteTempate=GCONST.getsystemThemeTemplate(); //是否启用软件模板和网站模板 0:不启用 其他：启用
		if(!isOpenSoftAndSiteTempate.equals("0")&&false){
		%>
				<div class="skinItemBlock">
					<div class="skinItemThumbnailBlock skinItemThumbnailBg sltFlgClass" _theme="ecology6"  _skin="default" <%=(cskin.equals("default") && curTheme.equals("ecology6")) ? "" : "onclick=\"javascript:changeSysSkin(this);\" style='cursor:hand;'" %>>
						<img src="/wui/theme/ecology7/page/images/skin/ecology6.gif" class="skinItemThumbnail" title="ecology6经典主题"/>
					</div>
					<div class="skinItemNameBlock">ecology6-经典主题</div>
				</div>
				<div class="skinItemBlock">
					<div class="skinItemThumbnailBlock skinItemThumbnailBg sltFlgClass" onclick="javascript:parent.location.href='/portal/plugin/homepage/webcustom/index.jsp?templateId=1';parentDialog.close();" style='cursor:hand;'>
						<img src="/wui/theme/ecology7/page/images/skin/ecologyInt.png" class="skinItemThumbnail" title="网站模式"/>
					</div>
					<div class="skinItemNameBlock">网站模式</div>
				</div>
		<%} %>			
				<div class="skinItemBlock">
					<div class="skinItemThumbnailBlock moreFlgClass" style="background:url(/wui/theme/ecology7/page/images/skin/more.png) no-repeat;cursor:hand;" title="<%=SystemEnv.getHtmlLabelName(26277 ,user.getLanguage())%>" onclick="javascript:alert('对不起，泛微官方社区正在建设中...');">
					</div>
					<div class="skinItemNameBlock" style="margin-top:6px;"><%=SystemEnv.getHtmlLabelName(26277 ,user.getLanguage())%></div>
				</div>
		</td>
	</table>
	<span style="margin-left:10px;width:420px;;height:3px;overflow:hidden;display:block;margin-top:20px;margin-bottom:5px;border-top:1px dotted #bfbfbf;"></span>
	<!--
		<span style="margin-left:10px;width:100%;display:block;text-align:left;color:#3399cc;font-size:12px;">
			<span style="font-size:13px;font-weight:bold;"><%=SystemEnv.getHtmlLabelName(26279 ,user.getLanguage())%>：</span>
			更多主题请访问
			<a href="#" onclick="javascript:alert('对不起，泛微官方社区正在建设中...');">
				泛微官方社区
			</a>
		</span>
	 -->
</div>
</td>
	</tr>
</table>
</body>

</html>
