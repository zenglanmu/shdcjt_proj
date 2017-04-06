<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo" scope="page"/>
<jsp:useBean id="mhsc" class="weaver.page.style.MenuHStyleCominfo" scope="page" />
<jsp:useBean id="mvsc" class="weaver.page.style.MenuVStyleCominfo" scope="page" />
<jsp:useBean id="MenuCenterCominfo" class="weaver.page.menu.MenuCenterCominfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="pm" class="weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(23141,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";    

int userId = 0;
userId = user.getUID();
int loginTemplateId = Util.getIntValue(request.getParameter("id"));
String saved = Util.null2String(request.getParameter("saved"));
if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<link href="/css/Weaver.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
<style>input{width:340px} .radio{width:20px}</style>
</head>

<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(221,user.getLanguage())+",javascript:preview(event),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

if(loginTemplateId!=1 && loginTemplateId!=2){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(event),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(350,user.getLanguage())+"...,javascript:saveAs(event),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

if(loginTemplateId!=1 && loginTemplateId!=2){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:del(event),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",loginTemplateList.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>


<%

String canCustom = pm.getConfig().getString("portal.custom");


String loginTemplateName="",loginTemplateTitle="",templateType="",imageId="",isCurrent="",modeid="",menuId="",menuType="",menuTypeId="",floatwidth="",floatheight="",windowwidth="",windowheight="",docId="",docName="",openWindowLink="",defaultshow = "";
String imageId2 = "";
String backgroundColor = "";
int extendloginid=0;
String leftmenuid="";
String leftmenustyleid="";
String sql = "SELECT * FROM SystemLoginTemplate WHERE loginTemplateId="+loginTemplateId;
rs.executeSql(sql);
if(rs.next()){
	loginTemplateName = rs.getString("loginTemplateName");
	loginTemplateTitle = rs.getString("loginTemplateTitle");
	templateType = rs.getString("templateType");
	imageId = rs.getString("imageId");
	isCurrent = rs.getString("isCurrent");
	extendloginid = rs.getInt("extendloginid");
	modeid = rs.getString("modeid");
	menuId = rs.getString("menuid");
	menuType = rs.getString("menutype");
	menuTypeId = rs.getString("menutypeid");
	floatwidth = rs.getString("floatwidth");
	floatheight = rs.getString("floatheight");
	windowwidth = rs.getString("windowwidth");
	windowheight = rs.getString("windowheight");
	docId = rs.getString("docId");
	openWindowLink = rs.getString("openWindowLink");
	defaultshow = rs.getString("defaultshow");
	if("#".equals(defaultshow)){
		defaultshow = "";
	}
	leftmenuid = rs.getString("leftmenuid");
	leftmenustyleid = rs.getString("leftmenustyleid");
	imageId2 = rs.getString("imageId2");
	backgroundColor = rs.getString("backgroundColor");
}

List imageId2List=Util.TokenizerString(imageId2,",");
int imageid2Size=imageId2List.size();

//获取浮动窗口显示文档的名称
if(!"".equals(docId))
	docName = DocComInfo.getDocname(docId);


//菜单名称
String menuName = "";
//菜单样式名称
String menuTypeName = "";
//获取菜单样式的链接地址
String tmenuTypeLink = "";
String menuTypeLink = "";


if(!"".equals(menuId))
{
	MenuCenterCominfo.setTofirstRow();
	while (MenuCenterCominfo.next())
	{
		
		String tmenuType = MenuCenterCominfo.getMenutype();
		if(menuId.equals(MenuCenterCominfo.getId()))
		{
			menuName = MenuCenterCominfo.getMenuname();
		}
	}
}

%>
<FORM style="margin:0" name="frmMain" method="post" enctype="multipart/form-data" action="loginTemplateOperation.jsp">
<input id="operationType" name="operationType" type="hidden" value="editLoginTemplate"/>
<input name="loginTemplateId" type="hidden" value="<%=loginTemplateId%>"/>
<input type="hidden" name="imageIdOld" value="<%=imageId%>"/>
<input type="hidden" name="imageId2Old" id="imageId2Old" value="<%=imageId2%>"/>
<input type="hidden" name="imageId2OldTemp" id="imageId2OldTemp" value="<%=imageId2%>"/>
<input type="hidden" id="isCurrent" name="isCurrent" value="<%=isCurrent%>"/>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
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

<TABLE class="Shadow">
	<tr>
		<td valign="top">
		
<!--=============================================================-->
<TABLE class=ViewForm>
<COLGROUP>
<COL width="30%">
<COL width="70%">
<TBODY>

<TR class=Title><TH colSpan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH></TR>
<TR class=Spacing><TD class=Line1 colSpan=2></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(19069,user.getLanguage())%></td>
<td class=Field>
	<input type="hidden" id="oldLoginTemplateName" value="<%=loginTemplateName%>">
	<INPUT class=InputStyle maxLength=50  id="loginTemplateName" name="loginTemplateName" value="<%=loginTemplateName%>" onchange="checkinput('loginTemplateName','loginTemplateNameImage')">
	<SPAN id=loginTemplateNameImage></SPAN>
</td>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

<tr>
<td><%=SystemEnv.getHtmlLabelName(19070,user.getLanguage())%></td>
<td class=Field>
	<INPUT class=InputStyle maxLength=50  name="loginTemplateTitle" value="<%=loginTemplateTitle%>">
</td>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>

<tr>
<td><%=SystemEnv.getHtmlLabelName(19071,user.getLanguage())%></td>
<td class=Field>
	<%if(loginTemplateId==1){%>
		<%=SystemEnv.getHtmlLabelName(19073,user.getLanguage())%><input type="hidden" name="templateType" value="V">
	<%}else if(loginTemplateId==2){%>
        <%=SystemEnv.getHtmlLabelName(19072,user.getLanguage())%><input type="hidden" name="templateType" value="H">
    <%}else if(loginTemplateId==3){%>
        <%=SystemEnv.getHtmlLabelName(19072,user.getLanguage())%>2<input type="hidden" name="templateType" value="H2">
	<%}else{%>
		<%if(templateType.equals("H")){%>
			<input type="radio" name="templateType" class="radio" value="H" checked onclick="changeImgSize('H')"><%=SystemEnv.getHtmlLabelName(19072,user.getLanguage())%>
			<input type="radio" name="templateType" class="radio" value="V" onclick="changeImgSize('V')"><%=SystemEnv.getHtmlLabelName(19073,user.getLanguage())%>
			<input type="radio" name="templateType" class="radio" value="H2" onclick="changeImgSize('H2')"><%=SystemEnv.getHtmlLabelName(19072,user.getLanguage())%>2
			<%if("true".equals(canCustom)){ %>
			<input type="radio" name="templateType" class="radio" value="site" onclick="changeImgSize('site')"><%=SystemEnv.getHtmlLabelName(23035,user.getLanguage())%>
			<%} %>
		<%}else if(templateType.equals("V")){%>
            <input type="radio" name="templateType" class="radio" value="H" onclick="changeImgSize('H')"><%=SystemEnv.getHtmlLabelName(19072,user.getLanguage())%>
            <input type="radio" name="templateType" class="radio" value="V" checked onclick="changeImgSize('V')"><%=SystemEnv.getHtmlLabelName(19073,user.getLanguage())%>
            <input type="radio" name="templateType" class="radio" value="H2" onclick="changeImgSize('H2')"><%=SystemEnv.getHtmlLabelName(19072,user.getLanguage())%>2
            <%if("true".equals(canCustom)){ %>
            <input type="radio" name="templateType" class="radio" value="site" onclick="changeImgSize('site')"><%=SystemEnv.getHtmlLabelName(23035,user.getLanguage())%>
            <%} %>
        <%}else if(templateType.equals("H2")){%>
            <input type="radio" name="templateType" class="radio" value="H" onclick="changeImgSize('H')"><%=SystemEnv.getHtmlLabelName(19072,user.getLanguage())%>
            <input type="radio" name="templateType" class="radio" value="V" onclick="changeImgSize('V')"><%=SystemEnv.getHtmlLabelName(19073,user.getLanguage())%>
            <input type="radio" name="templateType" class="radio" value="H2" checked onclick="changeImgSize('H2')"><%=SystemEnv.getHtmlLabelName(19072,user.getLanguage())%>2
            <%if("true".equals(canCustom)){ %>
            <input type="radio" name="templateType" class="radio" value="site" onclick="changeImgSize('site')"><%=SystemEnv.getHtmlLabelName(23035,user.getLanguage())%>
            <%} %>
		<%} else {%>
			<input type="radio" name="templateType" class="radio" value="H" onclick="changeImgSize('H')"><%=SystemEnv.getHtmlLabelName(19072,user.getLanguage())%>
			<input type="radio" name="templateType" class="radio" value="V" onclick="changeImgSize('V')"><%=SystemEnv.getHtmlLabelName(19073,user.getLanguage())%>
			<input type="radio" name="templateType" class="radio" value="H2" onclick="changeImgSize('H2')"><%=SystemEnv.getHtmlLabelName(19072,user.getLanguage())%>2
			<%if("true".equals(canCustom)){ %>
			<input type="radio" name="templateType" class="radio" value="site" checked  onclick="changeImgSize('site')"><%=SystemEnv.getHtmlLabelName(23035,user.getLanguage())%>
			<%} %>
		<%}%>
	<%}%>
</td>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
</TABLE>

<%
String styleExtend="";
String styleCommon="";
String styleH2Extend="";
if(templateType.equals("site")){
	styleExtend=" ";
	styleCommon=" style=\"display:none\" ";
	styleH2Extend = " style=\"display:none\" ";
} else if (templateType.equals("H2")){
    styleExtend="style=\"display:none\"";
    styleCommon="  ";
    styleH2Extend = "  ";
} else {
    styleExtend="style=\"display:none\"";
    styleCommon="  ";
    styleH2Extend = " style=\"display:none\" ";
}%>

<TABLE class=ViewForm <%=styleCommon%>  id="tblTypeContentCommon">
	<COLGROUP>
	<COL width="30%">
	<COL width="70%">
	
	<tr>
		<td valign="top" id="tdTypeMsg">
			<%=SystemEnv.getHtmlLabelName(19074,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(19075,user.getLanguage())%>:
			<%if(templateType.equals("V")){out.println("489*623");} else if(templateType.equals("H2")){out.println("990*610");} else{out.println("1020*370");}%>)
		</td>
		
		<td class=Field>	
		
			<%if(templateType.equals("V") && imageId.equals("")){%>
				<img src="/images_face/login/left.jpg" width="350">
			<%}else if(templateType.equals("H") && imageId.equals("")){%>
                <img src="/images_face/login/loginLanguage.jpg" width="350">
            <%}else if(templateType.equals("H2") && imageId.equals("")){%>
                <img src="/wui/theme/ecology7/page/images/login/login_cbg.png" width="350">
			<%}else{%>
				<img src="/LoginTemplateFile/<%=imageId%>" width="350">	
			<%}%>
		    <br/>
			<%if(loginTemplateId!=1 && loginTemplateId!=2 && loginTemplateId != 3){%>
				<input class="inputstyle" type="file" name="imageId" value="">
			<%}%>
		</td>
	</tr>
	<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
</TABLE>

<TABLE class=ViewForm <%=styleH2Extend%>  id="tblloginTemplateBgSetting" >
    <COLGROUP>
    <COL width="30%">
    <COL width="70%">
    <!-- 背景色 -->
    <tr>
        <td valign="top"><%=SystemEnv.getHtmlLabelName(2077,user.getLanguage())%></td>
        <td class=Field>    
            <%if(loginTemplateId!=1 && loginTemplateId!=2 && loginTemplateId != 3){%>
                <INPUT class=InputStyle maxLength=50 id="backgroundColor"  name="backgroundColor" value="<%=backgroundColor %>"/>
            <%} else {%>
                <%=backgroundColor %>
            <%} %>
        </td>
    </tr>
    <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
    <!-- 幻灯片图片设置 -->
    <%if(loginTemplateId!=3){%>
    <tr>
        <td valign="top"><%=SystemEnv.getHtmlLabelName(27747,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(2036,user.getLanguage())%>920*260)</td> <!-- 幻灯片图片 -->
        <td class=Field>
            <%
            for(int i=0;i<imageid2Size;i++){
            	String imageid2temp=(String)imageId2List.get(i);
            %> 	
               <div id='imgIndex<%=i+1%>'>
                <img src="/LoginTemplateFile/<%=imageid2temp%>" width="350px"><br>
                <input class='inputstyle' type='file' name='imageId_<%=i+1%>' value='' imageid2temp='<%=imageid2temp%>'> <input type='button' style='width:45px;height: 24px;' imageid2temp='<%=imageid2temp%>' onclick='delImg(this,<%=i+1%>)' value='删除'/>
               </div>
            <% } %>
            <!-- 添加 -->
            <input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="addImg()" id="addImgBtn" style="width: 45px;height: 24px;">
            
        </td>
    </tr>
    <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
   <%}%>
    
</TABLE>
<TABLE class=ViewForm <%=styleExtend%>  id="tblTypeContentExtend">
	<COLGROUP>
	<COL width="30%">
	<COL width="70%">
	</COLGROUP>
	<tr>
		<td valign="top"><%=SystemEnv.getHtmlLabelName(23140,user.getLanguage())%></td>
		<td class="field">
			
				<select name="modeid" style="width:45%" >
					<%
					rs.executeSql("select * from pagetemplate order by id");
					while (rs.next()){
					%>
					<option value="<%=rs.getString("id")%>" <%=rs.getString("id").equals(modeid)?" selected ":""%> ><%=rs.getString("templatename")%></option>
					<%}%>
				</select>
			
		</td>
	</tr>
	<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
	<tr>
		<td valign="top"><%=SystemEnv.getHtmlLabelName(20611,user.getLanguage())%></td><!--顶部导航菜单-->
		<td class="field">
			
			<select name="menuId" style="width:45%" >
				<%
				MenuCenterCominfo.setTofirstRow();						
				while(MenuCenterCominfo.next()){
					if(!MenuCenterCominfo.getMenutype().equals("1")){
						continue;
					}
				%>
				<option value="<%=MenuCenterCominfo.getId()%>" <%=MenuCenterCominfo.getId().equals(menuId)?" selected ":""%>><%=MenuCenterCominfo.getMenuname()%></option>
				<%}%>
			</select>	
		</td>
	</tr>
	<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
	<tr>
		
		<td valign="top"><%=SystemEnv.getHtmlLabelName(22432,user.getLanguage())+SystemEnv.getHtmlLabelName(22916,user.getLanguage())%>1</td>
		<td class="field">
		
			<INPUT id="tempMenuType" type=hidden value="menuh" name="tempMenuType">
			<INPUT id="menuTypeId"  type=hidden class="wuiBrowser" value="<%=menuTypeId %>" name="menuTypeId"
				_displayTemplate="<a href='/page/maint/style/MenuStyleEditH.jsp?styleid=#b{id}&type=menuh&from=list' target='_blank'>#b{name}</a>"
				_url="/systeminfo/BrowserMain.jsp?url=/page/element/Menu/MenuTypesBrowser.jsp?type=menuh">
			<SPAN id=spanMenuTypeId>
			<%
			if(!"".equals(menuTypeId))
			{ 
			%>
			<a href="/page/maint/style/MenuStyleEditV.jsp?styleid=<%=menuTypeId%>&type=menuh&from=list" target="_blank"><%=mhsc.getTitle(menuTypeId) %></a>
			<%
			}
			%>
			</SPAN>
		</td>
	</tr>
	<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
	<tr>
		<td valign="top"><%=SystemEnv.getHtmlLabelName(17596,user.getLanguage())%></td><!--左侧菜单-->
		<td class="field">
			
			<select name="leftmenuId" style="width:45%" >
				<%
				MenuCenterCominfo.setTofirstRow();						
				while(MenuCenterCominfo.next()){
					if(!MenuCenterCominfo.getMenutype().equals("1")){
						continue;
					}
				%>
				<option value="<%=MenuCenterCominfo.getId()%>" <%=MenuCenterCominfo.getId().equals(leftmenuid)?" selected ":""%>><%=MenuCenterCominfo.getMenuname()%></option>
				<%}%>
			</select>	
		</td>
	</tr>
	<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
	<tr>
		<td valign="top"><%=SystemEnv.getHtmlLabelName(17596,user.getLanguage())+SystemEnv.getHtmlLabelName(1014,user.getLanguage())%></td>
		<td class="field">
		
			<INPUT id="lefttempMenuType" type=hidden value="menuv" name="lefttempMenuType">
				<INPUT id="leftmenuTypeId"  type=hidden class="wuiBrowser" value="<%=menuTypeId %>" name="leftmenuTypeId"
				_displayTemplate="<a href='/page/maint/style/MenuStyleEditV.jsp?styleid=#b{id}&type=menuh&from=list' target='_blank'>#b{name}</a>"
				_url="/systeminfo/BrowserMain.jsp?url=/page/element/Menu/MenuTypesBrowser.jsp?type=menuv">
			<SPAN id=leftspanMenuTypeId>
			<%
			if(!"".equals(leftmenustyleid))
			{ 
			%>
			<a href="/page/maint/style/MenuStyleEditV.jsp?styleid=<%=leftmenustyleid%>&type=menuv&from=list" target="_blank"><%=mvsc.getTitle(leftmenustyleid) %></a>
			<%
			}
			%>
			</SPAN>
		</td>
	</tr>
	<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
	<tr>
		<td><%=SystemEnv.getHtmlLabelName(23103,user.getLanguage())%></td>
		<td width="90%"  class="field">
			<input type="text" id="defaultshow" name="defaultshow" class='inputstyle' value="<%=defaultshow %>" style="width: 260;">
			<BUTTON class=Browser onclick=onShowLoginPages(defaultshow,defaultshowSpan,"")></BUTTON>
			<span id=defaultshowSpan name=defaultshowSpan></span>
		</td>
	</tr>
	<TR style="display:none"  style="height:1px;"><TD class=Line colSpan=2></TD></TR>
	<tr style="display:none">
		<td valign="top"><%=SystemEnv.getHtmlLabelName(23085,user.getLanguage())%></td>
		<td>
			<TABLE class="viewform" width="100%">
				<colgroup>
					<col width="100%" />
				</colgroup>
				<TBODY>
					<TR>
						<td class="field">
							<%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>:
							<INPUT class="inputstyle"
								title="<%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>"
								style="WIDTH: 100px" name="floatwidth"
								value="<%=floatwidth %>"  onchange="javascript:checkMumber(this);"/>
							<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>:
							<INPUT class="inputstyle"
								title="<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>"
								style="WIDTH: 100px" name="floatheight"
								value="<%=floatheight %>"  onchange="javascript:checkMumber(this);"/>
							&nbsp;
						</td>
					</TR>
					<TR style="height:1px;">
						<TD class="LINE" colSpan="1"></TD>
					</TR>
					<TR>
						<td class="field">
							<%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%>:
							<INPUT id="docId" type=hidden value="<%=docId %>" name="docId">
							<BUTTON class=Browser onclick=onShowDocs(docId,spanDocId)></BUTTON>
							<SPAN id=spanDocId>
								<%
								if(!"".equals(docId))
								{ 
								%>
								<a href="/docs/docs/DocDsp.jsp?id=<%=docId %>" target="_blank"><%=docName %></a>
								<%
								}
								%>
							</SPAN>
						</td>
					</TR>
				</TBODY>
			</TABLE>
		</td>
	</tr>
	<TR style="display:none" style="height:1px;"><TD class=Line colSpan=2></TD></TR>
	<tr style="display:none">
		<td valign="top"><%=SystemEnv.getHtmlLabelName(18717,user.getLanguage())%></td>
		<td>
			<TABLE class="viewform" width="100%">
				<colgroup>
					<col width="100%" />
				</colgroup>
				<TBODY>
					<TR>
						<td class="field">
							<%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>:
							<INPUT class="inputstyle"
								title="<%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>"
								style="WIDTH: 100px" name="windowwidth"
								value="<%=windowwidth %>" onchange="javascript:checkMumber(this);"/>
							<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>:
							<INPUT class="inputstyle"
								title="<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>"
								style="WIDTH: 100px" name="windowheight"
								value="<%=windowheight %>" onchange="javascript:checkMumber(this);"/>
						</td>
					</TR>
					<TR style="height:1px;">
						<TD class="LINE" colSpan="1"></TD>
					</TR>
					<TR>
						<td class="field">
						<%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>:
							<INPUT class=InputStyle maxLength=50  name="openWindowLink" value="<%=openWindowLink%>">
						</td>
					</TR>
				</TBODY>
			</TABLE>
		</td>
	</tr>
	<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
</TABLE>

<!--=============================================================-->		
		
		</td>
	</tr>
</TABLE>

</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
</FORM>


</body>
</html>

<script language="javascript">
var saved ="<%=saved%>";
function preview(){
	
	if(!saved){
		alert("<%=SystemEnv.getHtmlLabelName(20822,user.getLanguage())%>")
		return;
	}
	//alert($("#templateType"))
	var templateType =  $("input[type=radio][checked]").val();
	var ids = "";
	if(templateType=="site"){
		ids =  "loginTemplateName,modeid"
	}else{
		ids =  "loginTemplateName"
	}
	
	if(check_form(frmMain,ids)){
		frmMain.enctype = "application/x-www-form-urlencoded";
		frmMain.target = "_blank";
		frmMain.action = "loginTemplatePreview.jsp?loginTemplateId=<%=loginTemplateId%>";
		frmMain.submit();
		frmMain.enctype = "multipart/form-data";
		frmMain.target = "";
		frmMain.action = "loginTemplateOperation.jsp";
	}

}
function checkMumber(o)
{
	var value = o.value;
	var r = /^-?[0-9]+$/g;　　//整数 
    var flag = r.test(value);
    if(!flag)
    {
    	alert("<%=SystemEnv.getHtmlLabelName(23086,user.getLanguage())%>!");
    	o.value="";
    	o.focus(true,100);
		return;
    }
}
function checkSubmit(e){

	jQuery("input[type=file]").each(function(){
	   if(jQuery(this).val()!=""&&jQuery(this).attr("imageid2temp"))
	       delImg(this);  
	});

	var templateType =  $("input[type=radio][checked]").val();
	var ids = "";
	if(templateType=="site"){
		ids =  "loginTemplateName,modeid"
	}else{
		ids =  "loginTemplateName"
	}
	if(check_form(frmMain,ids)){
		document.frmMain.submit();
		(e.srcElement||e.target).disabled=true;
	}
}

function saveAs(e){
	var templateType =  $("input[type=radio][checked]").val();
	var ids = "";
	if(templateType=="site"){
		ids =  "loginTemplateName,modeid"
	}else{
		ids =  "loginTemplateName"
	}
	if(check_form(frmMain,ids)){
		if($("#oldLoginTemplateName").val()==$("#loginTemplateName").val()){
			if(confirm("<%=SystemEnv.getHtmlLabelName(18971,user.getLanguage())%>")){
				document.getElementById("operationType").value = "saveasLoginTemplate";
				document.frmMain.submit();
				(e.srcElement||e.target).disabled=true;
			}
		}else{
			document.getElementById("operationType").value = "saveasLoginTemplate";
			document.frmMain.submit();
			(e.srcElement||e.target).disabled=true;
		}
	}
}

function del(e){
	if(document.getElementById("isCurrent").value=="1"){
		alert("<%=SystemEnv.getHtmlLabelName(18970,user.getLanguage())%>");
		return false;
	}else{
		if(isdel()){
			document.getElementById("operationType").value = "delete";
			document.frmMain.submit();
			(e.srcElement||e.target).disabled=true;
		}
	}
}

function deleteBgImage(imgStr){
	if(confirm()){
		document.getElementById("operationType").value = "deleteBgImage";
		document.getElementById("bgImage").value = imgStr;
		document.frmMain.submit();
		this.disabled = true;
	}
}

function changeImgSize(t){
	if(t=="V"){
		tdTypeMsg.innerHTML="<%=SystemEnv.getHtmlLabelName(19074,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(19075,user.getLanguage())%>:489*623)";
		tblTypeContentExtend.style.display="none";
		tblTypeContentCommon.style.display="";
		tblloginTemplateBgSetting.style.display = "none";
	} else if(t=="H"){
        tdTypeMsg.innerHTML="<%=SystemEnv.getHtmlLabelName(19074,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(19075,user.getLanguage())%>:1020*370)";
        tblTypeContentExtend.style.display="none";
        tblTypeContentCommon.style.display="";
        tblloginTemplateBgSetting.style.display = "none";
    } else if(t=="H2"){
        tdTypeMsg.innerHTML="<%=SystemEnv.getHtmlLabelName(19074,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(19075,user.getLanguage())%>:990*610)";
        tblTypeContentExtend.style.display="none";
        tblTypeContentCommon.style.display="";
        tblloginTemplateBgSetting.style.display = "";
	} else if(t=="site"){
		tdTypeMsg.innerHTML="<%=SystemEnv.getHtmlLabelName(20615,user.getLanguage())%>";
		tblTypeContentExtend.style.display="";
		tblTypeContentCommon.style.display="none";
		tblloginTemplateBgSetting.style.display = "none";
	}
}
function clearMenuType(o)
{	
	var menuType = document.getElementById("menuTypeId");
	var spanMenuType = document.getElementById("spanMenuTypeId");
	var tempMenuType = document.getElementById("tempMenuType");
	var mTypes = document.getElementById("menuType");
	menuType.value = "";
	spanMenuType.innerHTML = "";
	tempMenuType.value = o.value;
}

var index=<%=imageid2Size%>+1;
function addImg(){
   index++;
   var htmlstr="<div id='imgIndex"+index+"'><input class='inputstyle' type='file' name='imageId_"+index+"' value=''> <input type='button' style='width:45px;height: 24px;' onclick='delImg(this,"+index+")' value='删除'/></div>";
   jQuery("#addImgBtn").before(htmlstr);
}

function delImg(obj,index){
   var isDel=1;
   var imageid2temp=jQuery(obj).attr("imageid2temp");
   if(index&&imageid2temp){
      if(confirm("<%=SystemEnv.getHtmlLabelName(27748,user.getLanguage())%>")) //确认删除图片？
         jQuery("#imgIndex"+index).remove();
      else
         isDel=0 ; 
   }
   
   if(isDel==1){
      var imageId2OldTemp=jQuery("#imageId2OldTemp").val();
      imageId2OldTemp=imageId2OldTemp.replace(imageid2temp,"");
      jQuery("#imageId2OldTemp").val(imageId2OldTemp);
      jQuery("#imgIndex"+index).remove();
   }
}


</script>
<script language=vbs>
	sub onShowModes(input,span)
		id = window.showModalDialog("/systeminfo/template/loginTemplateBrowser.jsp")
		if (Not IsEmpty(id)) then
			if id(0)<> "" then
				span.innerHtml = "<a href='/page/maint/template/login/Edit.jsp?id="&id(0)&"' target='_blank'>" & id(1) &"</a>"
				input.value=id(0)
			else 
				span.innerHtml = " <IMG src='/images/BacoError.gif' align=absMiddle>"
				input.value=""
			end if
		end if
	end sub
	sub onShowDocs(input,span)
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
		if (Not IsEmpty(id)) then
			if id(0)<> "" then
				span.innerHtml = "<a href='/docs/docs/DocDsp.jsp?id="&id(0)&"' target='_blank'>" & id(1) &"</a>"
				input.value=id(0)
			else 
				span.innerHtml = ""
				input.value="0"
			end if
		end if
	end sub
	sub onShowMenus(input,span)
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/page/maint/menu/MenusBrowser.jsp?menutype=1")
		if (Not IsEmpty(id)) then
			if id(0)<> "" then
				if id(0) = "hp" Then
					span.innerHtml = "<a href='/homepage/maint/HomepageLocation.jsp' target='_blank'>" & id(1) &"</a>"
 				ElseIf id(0) = "sys" Then
					span.innerHtml = "<a href='/systeminfo/menuconfig/MenuMaintFrame.jsp?type="&id(0)&"' target='_blank'>" & id(1) &"</a>"
				else
					span.innerHtml = "<a href='/page/maint/menu/MenuEdit.jsp?id="&id(0)&"' target='_blank'>" & id(1) &"</a>"
			    end if 
				input.value=id(0)
			else 
				span.innerHtml = ""
				input.value="0"
			end if
		end if
	end sub

	sub onShowMenuTypes(input,span,menutype)
		menutype = menutype.value
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/page/element/Menu/MenuTypesBrowser.jsp?type="&menutype)
		menulink = ""
		if menutype = "element" then
			menulink = "ElementStyleEdit.jsp"
		ElseIf menutype = "menuh" Then
			menulink = "MenuStyleEditH.jsp"
		else
			menulink = "MenuStyleEditV.jsp"
		end if
		if (Not IsEmpty(id)) then
			if id(0)<> "" then
				span.innerHtml = "<a href='/page/maint/style/"&menulink&"?styleid="&id(0)&"&type="&menutype&"&from=list' target='_blank'>"&id(1)&"</a>"
				input.value=id(0)
			else 
				span.innerHtml = ""
				input.value="0"
			end if
		end if
	end sub
sub onShowLoginPages(input,span,eid)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/homepage/maint/LoginPageBrowser.jsp?menutype=1")
	if (Not IsEmpty(id)) then
		if id(0)<> "" then
			span.innerHtml = "<a href='/homepage/LoginHomepage.jsp?hpid="&id(0)&"' target='_blank'>" & id(1) &"</a>"
			input.value="/homepage/LoginHomepage.jsp?hpid="&id(0)
		else 
			span.innerHtml = ""
			input.value=""
		end if
	end if
end sub

</script>