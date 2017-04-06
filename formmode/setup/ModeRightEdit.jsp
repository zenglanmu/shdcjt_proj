<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="modeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
</head>
<%
	if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%
int modeId = Util.getIntValue(request.getParameter("modeId"),0);

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(16526,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<BODY> 
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(modeId >0 ){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(30245,user.getLanguage())+",javascript:createmenu(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(30254,user.getLanguage())+",javascript:createmenu1(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(30255,user.getLanguage())+",javascript:viewmenu1(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%
modeRightInfo.setUser(user);
modeRightInfo.setModeId(modeId);
Map allRightMap = modeRightInfo.getAllRightList();			//所有权限Map

List viewRightList = modeRightInfo.getViewRightList();		//查看权限
List addRightList = modeRightInfo.getAddRightList();		//新建权限
List editRightList = modeRightInfo.getEditRightList();		//编辑权限
List controlRightList = modeRightInfo.getControlRightList();//完全控制权限
List monitorRightList = modeRightInfo.getMonitorRightList();//监控权限
List batchRightList = modeRightInfo.getBatchRightList();//批量导入权限

int creator = Util.getIntValue((String)allRightMap.get("creator"),3);				//创建人本人
int creatorleader = Util.getIntValue((String)allRightMap.get("creatorleader"),99);	//创建人直接上级
int creatorSub = Util.getIntValue((String)allRightMap.get("creatorSub"),99);		//创建人本分部
int creatorSubsl = Util.getIntValue((String)allRightMap.get("creatorSubsl"),10);
int creatorDept = Util.getIntValue((String)allRightMap.get("creatorDept"),99);		//创建人本部门
int creatorDeptsl = Util.getIntValue((String)allRightMap.get("creatorDeptsl"),10);
%>
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
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<FORM id=weaver name=weaver action="ModeRightOperation.jsp" method=post>
<input type=hidden name="method" value="saveForCreator">
<input type=hidden name=modeId id=modeId value=<%=modeId %>>
<input type=hidden name=mainids id=mainids>
 <TABLE class=ViewForm>
  <TBODY>
  <TR>
    <TD vAlign=top>
        <TABLE class=ViewForm >
          <COLGROUP> <col width="8%"><col width="35%"><col width="*">	 
		  <TBODY>
          <TR class=Title>
          <!-- 创建权限 -->
            <th colspan=2 noWrap><%=SystemEnv.getHtmlLabelName(21945,user.getLanguage())%></th>
    		<td align=right>&nbsp;
    		  <input type="checkbox" name="chkPermissionAll0" onclick="chkAllClick(this,0)">(<%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%>)
    		  <a class=href href="ModeShareAdd.jsp?trighttype=1&modeId=<%=modeId%>"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>
    		  <a class=href href="#" onclick="javaScript:doDelShare(0);"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>    
            </td>
          </TR>
          <TR style="height: 1px!important;"><TD class=Line1 colSpan=3></TD></TR>
          <%
          Map datamap = null;
          for(int i=0 ;i < addRightList.size();i++){
        	  datamap = (Map)addRightList.get(i);
        	  String rightid = (String)datamap.get("rightId");
        	  String sharetypetext = (String)datamap.get("sharetypetext");
        	  String detailText = (String)datamap.get("detailText");
          %>
          <tr>
            <td><input type="checkbox" name="rightid" id="rightid0" value="<%=rightid %>"></td>
            <td class="field"><%=sharetypetext %></td>
            <td class="field"><%=detailText%></td>
          </tr>
          <TR style="height: 1px"> <TD class=Line colSpan=3></TD></TR>
          <%}%>
        </TABLE>
        
        <table class=ViewForm >
          <COLGROUP> <col width="30%"><col width="40%"><col width="*">
		  <TBODY>
          <TR class=Title>
          <!-- 默认共享（与创建人相关） -->
            <th colspan=2 noWrap>
              <%=SystemEnv.getHtmlLabelName(15059,user.getLanguage())%>
              (<%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(522,user.getLanguage())%>)
            </th>
          </TR>
          <TR style="height: 1px!important;"><TD class=Line1 colSpan=3></TD></TR>
          <!-- 创建人本人 -->
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(15079,user.getLanguage())%></td>
            <td class=Field></td>
            <td class=Field> 
            	<select name="creator">
                   <option value="99" <%if(creator==99){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option>
                   <option value="1" <%if(creator==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
                   <option value="2" <%if(creator==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option> 
                   <option value="3" <%if(creator==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> 
                </select>
            </td>
          </tr>
          <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
          <!-- 创建人直接上级 -->
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(18583,user.getLanguage())%></td>
            <td class=Field></td>
            <td class=Field> 
            	<select name="creatorleader">
                   <option value="99" <%if(creatorleader==99){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option>
                   <option value="1" <%if(creatorleader==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
                   <option value="2" <%if(creatorleader==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option> 
                   <option value="3" <%if(creatorleader==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> 
                </select>
            </td>
          </tr>
          <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
          <!-- 创建人本分部 -->
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(15577,user.getLanguage())%></td>
            <td class=Field>
              <Div id="createrSubLDiv" <%if(creatorSub==99) {out.println(" style=\"display:none\"" );}%> align="left">                            
                 <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>= 
                 <input value="<%=creatorSubsl%>"  class="inputStyle" type="text" size="4" name="creatorSubsl">
              </Div>
            </td>
            <td class=Field> 
            	<select name="creatorSub"  onchange="onSelectChange(this,createrSubLDiv);">
                   <option value="99" <%if(creatorSub==99){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option>
                   <option value="1" <%if(creatorSub==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
                   <option value="2" <%if(creatorSub==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option> 
                   <option value="3" <%if(creatorSub==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> 
                </select>
            </td>
          </tr>
          <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
          <!-- 创建人本部门 -->
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%></td>
            <td class=Field>
             <Div id="createrDepartLDiv" <%if(creatorDept==99) {out.println(" style=\"display:none\"" );}%> align="left">                            
                 <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>= 
                 <input value="<%=creatorDeptsl%>"  class="inputStyle" type="text" size="4" name="creatorDeptsl">
             </Div>
            </td>
            <td class=Field> 
            	<select name="creatorDept" onchange="onSelectChange(this,createrDepartLDiv);">
                   <option value="99" <%if(creatorDept==99){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2011,user.getLanguage())%></option>
                   <option value="1" <%if(creatorDept==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
                   <option value="2" <%if(creatorDept==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option> 
                   <option value="3" <%if(creatorDept==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option> 
                </select>
            </td>
          </tr>
          <TR style="height: 1px!important;"><TD class=Line colSpan=3></TD></TR>
        </table>
          
        <table class=ViewForm >  
         <COLGROUP> <col width="8%"><col width="35%"><col width="*">	 
		  <TBODY>
          <TR class=Title>
          <!-- 默认共享 -->
            <th colspan=2 noWrap><%=SystemEnv.getHtmlLabelName(15059,user.getLanguage())%></th>
    		<td align=right>&nbsp;
    		  <input type="checkbox" name="chkPermissionAll2" onclick="chkAllClick(this,2)">(<%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%>)
    		  <a class=href href="ModeShareAdd.jsp?modeId=<%=modeId%>"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>
    		  <a class=href href="#" onclick="javaScript:doDelShare(2);"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>    
            </td>
          </TR>
          <TR style="height: 1px!important;"><TD class=Line1 colSpan=3></TD></TR>
          <%//查看
          for(int i=0 ;i < viewRightList.size();i++){
        	  datamap = (Map)viewRightList.get(i);
        	  String rightid = (String)datamap.get("rightId");
        	  String sharetypetext = (String)datamap.get("sharetypetext");
        	  String detailText = (String)datamap.get("detailText");
          %>
          <tr>
            <td><input type="checkbox" name="rightid2" id="rightid2" value="<%=rightid %>"></td>
            <td class="field"><%=sharetypetext %></td>
            <td class="field"><%=detailText%></td>
          </tr>
          <TR style="height: 1px"> <TD class=Line colSpan=3></TD></TR>
          <%}%>
          <%//编辑
          for(int i=0 ;i < editRightList.size();i++){
        	  datamap = (Map)editRightList.get(i);
        	  String rightid = (String)datamap.get("rightId");
        	  String sharetypetext = (String)datamap.get("sharetypetext");
        	  String detailText = (String)datamap.get("detailText");
          %>
          <tr>
            <td><input type="checkbox" name="rightid2" id="rightid2" value="<%=rightid %>"></td>
            <td class="field"><%=sharetypetext %></td>
            <td class="field"><%=detailText%></td>
          </tr>
          <TR style="height: 1px"> <TD class=Line colSpan=3></TD></TR>
          <%}%>
          <%//完全控制
          for(int i=0 ;i < controlRightList.size();i++){
        	  datamap = (Map)controlRightList.get(i);
        	  String rightid = (String)datamap.get("rightId");
        	  String sharetypetext = (String)datamap.get("sharetypetext");
        	  String detailText = (String)datamap.get("detailText");
          %>
          <tr>
            <td><input type="checkbox" name="rightid2" id="rightid2" value="<%=rightid %>"></td>
            <td class="field"><%=sharetypetext %></td>
            <td class="field"><%=detailText%></td>
          </tr>
          <TR style="height: 1px"> <TD class=Line colSpan=3></TD></TR>
          <%}%>
          
          <TR class=Title>
          <!-- 监控权限 -->
            <th colspan=2 noWrap><%=SystemEnv.getHtmlLabelName(20305,user.getLanguage())%></th>
    		<td align=right>&nbsp;
    		  <input type="checkbox" name="chkPermissionAll3" onclick="chkAllClick(this,3)">(<%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%>)
    		  <a class=href href="ModeShareAdd.jsp?trighttype=2&modeId=<%=modeId%>"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>
    		  <a class=href href="#" onclick="javaScript:doDelShare(3);"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>    
            </td>
          </TR>
          <TR style="height: 1px!important;"><TD class=Line1 colSpan=3></TD></TR>
          <%//监控
          for(int i=0 ;i < monitorRightList.size();i++){
        	  datamap = (Map)monitorRightList.get(i);
        	  String rightid = (String)datamap.get("rightId");
        	  String sharetypetext = (String)datamap.get("sharetypetext");
        	  String detailText = (String)datamap.get("detailText");
          %>
          <tr>
            <td><input type="checkbox" name="rightid3" id="rightid3" value="<%=rightid %>"></td>
            <td class="field"><%=sharetypetext %></td>
            <td class="field"><%=detailText%></td>
          </tr>
          <TR style="height: 1px"> <TD class=Line colSpan=3></TD></TR>
          <%}%>
          
          <TR class=Title>
          <!-- 批量导入权限 -->
            <th colspan=2 noWrap><%=SystemEnv.getHtmlLabelName(30253,user.getLanguage())%></th>
    		<td align=right>&nbsp;
    		  <input type="checkbox" name="chkPermissionAll4" onclick="chkAllClick(this,4)">(<%=SystemEnv.getHtmlLabelName(2241,user.getLanguage())%>)
    		  <a class=href href="ModeShareAdd.jsp?trighttype=4&modeId=<%=modeId%>"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>
    		  <a class=href href="#" onclick="javaScript:doDelShare(4);"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>    
            </td>
          </TR>
          <TR style="height: 1px!important;"><TD class=Line1 colSpan=3></TD></TR>
          <%//批量导入权限
          for(int i=0 ;i < batchRightList.size();i++){
        	  datamap = (Map)batchRightList.get(i);
        	  String rightid = (String)datamap.get("rightId");
        	  String sharetypetext = (String)datamap.get("sharetypetext");
        	  String detailText = (String)datamap.get("detailText");
          %>
          <tr>
            <td><input type="checkbox" name="rightid4" id="rightid4" value="<%=rightid %>"></td>
            <td class="field"><%=sharetypetext %></td>
            <td class="field"><%=detailText%></td>
          </tr>
          <TR style="height: 1px"> <TD class=Line colSpan=3></TD></TR>
          <%}%>
        </table>
     </TD>
   </TR>
  </TBODY>
 </TABLE>
</form>

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
<script language="javascript">
$(document).ready(function(){//onload事件
	$(".loading", window.parent.document).hide(); //隐藏加载图片
	if($("#modeId").val()=='0'){
		if(confirm("请先保存基本信息！")){
			window.parent.document.getElementById('modeBasicTab').click();
		}else{
			$('.href').hide();
		}
	}
})

function onSave(){
	enableAllmenu();
	$(".loading", window.parent.document).show();
	weaver.submit();
}

function createmenu(){
	var url = "/formmode/search/CustomSearch.jsp?modeid=<%=modeId%>&monitor=1";
	//location.href = url;
	window.open(url);
}

function createmenu1(){
	var url = "/formmode/interfaces/ModeDataBatchImport.jsp?modeid=<%=modeId%>";
	window.open("/formmode/menu/CreateMenu.jsp?menuaddress="+escape(url));
}
function viewmenu1(){
	var url = "/formmode/interfaces/ModeDataBatchImport.jsp?modeid=<%=modeId%>";
	prompt("<%=SystemEnv.getHtmlLabelName(28624,user.getLanguage())%>",url);
}

function chkAllClick(obj,types){
    var chks = document.getElementsByName("rightid"+types);    
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        chk.checked=obj.checked;
    }    
}

function doDelShare(type){
	var mainids = "";
    var chks = document.getElementsByName("rightid"+type);   
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        if(chk.checked)
        	mainids += "," + chk.value;
    }    
    if(mainids == ''){
    	alert("<%=SystemEnv.getHtmlLabelName(22346,user.getLanguage())%>");
    }else{
    	if(confirm("<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage())%>")){
    		weaver.method.value="delete";
    		weaver.mainids.value=mainids;
    		$(".loading", window.parent.document).show();
    		weaver.submit();
    		//window.location = "ModeRightOperation.jsp?method=delete&mainids="+mainids+"&modeId=<%=modeId%>";
    	}
    }
}
function onSelectChange(obj1,obj2){
     var selectValue = obj1.value;
     if (selectValue!=99) obj2.style.display="";
     else  obj2.style.display="none";           
}
</script>
</BODY></HTML>