<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuUtil" %>
<%@ page import="org.jdom.*" %>
<%@ page import="weaver.systeminfo.menuconfig.*" %>
<HTML>
<HEAD> 

<%@ include file="/systeminfo/template/templateCss.jsp" %>
<script type="text/javascript" src="/js/poslib.js"></script>
<script type="text/javascript" src="/js/scrollbutton.js"></script>
<script type="text/javascript" src="/js/menu4.js"></script>
</HEAD>
<BODY style="margin:0;background-color:<%=UsrTemplate.getTopBgColor()%>">

<textarea id="areaInfo" style="display:none"></textarea>
<script type="text/javascript">
//<![CDATA[
Menu.prototype.cssFile = "/skins/officexp/officexp.css";
Menu.prototype.mouseHoverDisabled = false;

var tmp;
var mb = new MenuBar;


<%
	MenuUtil mu=new MenuUtil("top", 3,user.getUID(),user.getLanguage());
	Document menuDoc=mu.getMenuXmlObj(0,"hidden");	
	Element root=menuDoc.getRootElement();
	
	List childList=root.getChildren();
	for(int i=0;i<childList.size();i++){
		String returnStr="";
		Element e=(Element)childList.get(i);
		
		int menuid=Util.getIntValue(e.getAttributeValue("id"));		
			
		menuid=10000-menuid;
		
		returnStr="menu_"+menuid+" = new Menu();\n";
		returnStr+="mb.add(new MenuButton(\""+e.getAttributeValue("text")+"\",menu_"+menuid+",\""+e.getAttributeValue("linkAddress")+"\",\""+e.getAttributeValue("baseTarget")+"\"));\n";

		out.println(returnStr);

		returnStr=mu.getChildStrForMenu4(e,"");


		out.println(returnStr);
	}

	
	
%>
		
<%   
//MainMenuUtil mainMenuUtil = new MainMenuUtil(user);
//String menuStr = mainMenuUtil.getMenuString();
//out.println(menuStr);
%>

mb.write();
//]]>
</script>
</BODY>
</HTML>