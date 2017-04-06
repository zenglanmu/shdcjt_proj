<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.docs.category.security.AclManager,
                 weaver.docs.category.CategoryTree,
                 weaver.docs.category.CommonCategory" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(73,user.getLanguage());
String needfav ="1";
String needhelp ="";
String  saved=Util.null2String(request.getParameter("saved"));
%>
<script language=javascript>
function onLoad(){
    if(<%=(saved.equals("true")?"true":"false")%>){
        alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>!");
    }
}
</script>
<BODY onload="onLoad()">
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0" id="allContent">
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

<%
int userid=0;
userid=user.getUID();
String logintype = user.getLogintype();
String usertype="";
if(logintype.equals("1"))
     usertype = "0";
if(logintype.equals("2"))
     usertype = "1";
char flag=2;

UserDefaultManager.setUserid(userid);
UserDefaultManager.selectUserDefault();
ArrayList selectArr=UserDefaultManager.getSelectedcategory();
String useUnselected = UserDefaultManager.getUseunselected();
int numperpage=UserDefaultManager.getNumperpage();
String commonuse = UserDefaultManager.getCommonuse();
%>
<FORM id=weaver name=frmmain action="DocUserDefaultOperation.jsp" method=post >
<input type="hidden" name="id" value=<%=UserDefaultManager.getId()%>>
<input type="hidden" name="useUnselected" value="true">
<table class=ViewForm>
  <tr class=Title>
      	<TH colSpan=2><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></TH>
  </tr>
  <TR class=Spacing>
        <TD class=Line1 colSpan=2></TD>
  </TR>
  <tr class=field>
  	<td width="50%">
  		<input type="checkbox" name="hascreater" value="1"<%if(UserDefaultManager.getHascreater().equals("1")){%> checked <%}%>>
  		<%=SystemEnv.getHtmlLabelName(79,user.getLanguage())%>
  	</td>

	<%--
  	<td width="50%">
  		<input type="checkbox" name="hasdocid" value="1" <%if(UserDefaultManager.getHasdocid().equals("1")){%>checked <%}%>>
  		<%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%>
  	</td>
  	--%>
  	<td width="50%">
  		<input type="checkbox" name="hascreatedate" value="1" <%if(UserDefaultManager.getHascreatedate().equals("1")){%>checked <%}%>>
  		<%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>
  	</td>
  </tr>
  <tr class=field>
  	<td width="50%">
  		<input type="checkbox" name="hascategory" value="1" <%if(UserDefaultManager.getHascategory().equals("1")){%>checked <%}%>>
  		<%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%>
  	</td>
  	<td width="50%">
  		<input type="checkbox" name="hascreatetime" value="1" <%if(UserDefaultManager.getHascreatetime().equals("1")){%>checked <%}%>>
  		<%=SystemEnv.getHtmlLabelName(723,user.getLanguage())%>
  	</td>
  </tr>
  <tr class=field>
  	<td width="50%">
  		<input type="checkbox" name="hasreplycount" value="1" <%if(UserDefaultManager.getHasreplycount().equals("1")){%>checked <%}%>>
  		<%=SystemEnv.getHtmlLabelName(2006,user.getLanguage())%>
  	</td>
  	<td width="50%">
  		<input type="checkbox" name="hasaccessorycount" value="1" <%if(UserDefaultManager.getHasaccessorycount().equals("1")){%>checked <%}%>>
  		<%=SystemEnv.getHtmlLabelName(2007,user.getLanguage())%>
  	</td>
  </tr>
  <tr class=field>
  	<td width="50%">
  		<input type="checkbox" name="hasoperate" value="1" <%if(UserDefaultManager.getHasoperate().equals("1")){%>checked <%}%>>
  		<%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%><!-- 操作 -->
  	</td>
  	<td width="50%">
  		&nbsp;
  	</td>
  </tr>
  <tr>
      	<TH colSpan=2>&nbsp;</TH>
  </tr>
  
  <tr class=Title>
      	<TH colSpan=2><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></TH>
  </tr>
  <TR class=Spacing>
        <TD class=Line1 colSpan=2></TD>
  </TR>
  <tr class=field>
  	<td>
      <%=SystemEnv.getHtmlLabelName(265,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(264,user.getLanguage())%>
      <input type="text" class=InputStyle name="numperpage" value=<%=numperpage%> size="3" maxlength=2 onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)'>
      <%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%>
  	</td>
  	<td>
  	  <input type="checkbox" name="commonuse" value="1" <%if(!commonuse.equals("-1")){%>checked <%}%>>
      <%=SystemEnv.getHtmlLabelName(28183,user.getLanguage())%>
      
  	</td>
  </tr>
  <%
      ArrayList mainids=new ArrayList();
      ArrayList subids=new ArrayList();
      ArrayList secids=new ArrayList();

      AclManager am = new AclManager();
      CategoryTree tree = am.getPermittedTree(user, AclManager.OPERATION_CREATEDOC);
      Vector alldirs = tree.allCategories;
      for (int i=0;i<alldirs.size();i++) {
          CommonCategory temp = (CommonCategory)alldirs.get(i);
          if (temp.type == AclManager.CATEGORYTYPE_MAIN) {
              mainids.add(Integer.toString(temp.id));
          } else if (temp.type == AclManager.CATEGORYTYPE_SEC) {
              secids.add(Integer.toString(temp.id));
              if (subids.indexOf(Integer.toString(temp.superiorid)) == -1) {
                  subids.add(Integer.toString(temp.superiorid));
              }
          }
      }


      //RecordSet.executeProc("DocUserCategory_SMainByUser",""+userid+flag+usertype);
      //while(RecordSet.next()){
      //    mainids.add(RecordSet.getString("mainid"));
      //}
      //RecordSet.executeProc("DocUserCategory_SSubByUser",""+userid+flag+usertype);
      //while(RecordSet.next()){
      //    subids.add(RecordSet.getString("subid"));
      //}
  %>

  <tr>
      	<TH colSpan=2>&nbsp;</TH>
  </tr>

  <tr class=Title>
      	<TH colSpan=2><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%> - <%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%></TH>
  </tr>
  <TR class=Spacing>
        <TD class=Line1 colSpan=2></TD>
  </TR>
  <%
	int maincate = mainids.size();
	int rownum = maincate/2;
	if((maincate-rownum*2)!=0)  rownum=rownum+1;
  %>
  <tr class=field id="treeTable">
        <td width="50%" align=left valign=top>
        <%
 	int needtd=rownum;
 	for(int i=0;i<mainids.size();i++){
 		String mainid = (String)mainids.get(i);
 		String mainname=MainCategoryComInfo.getMainCategoryname(mainid);
 		needtd--;
 	%>
 	<table class=ViewForm >
		<tr class=field>
		  <td colspan=2 align=left>
		  <%if(useUnselected.equals("true")){ %>
			  <% if(selectArr.size()==0||selectArr.indexOf("M"+mainid)!=-1){%>
			  <input type="checkbox" name="m<%=mainid%>" value="M<%=mainid%>" onclick="checkMain('<%=mainid%>')">
			  <%} else {%>
			  <input type="checkbox" name="m<%=mainid%>" value="M<%=mainid%>" onclick="checkMain('<%=mainid%>')" checked>
			  <%}%>
		  <%}else{ %>
		  	  <% if(selectArr.indexOf("M"+mainid)==-1){%>
			  <input type="checkbox" name="m<%=mainid%>" value="M<%=mainid%>" onclick="checkMain('<%=mainid%>')">
			  <%} else {%>
			  <input type="checkbox" name="m<%=mainid%>" value="M<%=mainid%>" onclick="checkMain('<%=mainid%>')" checked>
			  <%}%>
		  <%} %>
		  <b><%=mainname%></b> </td></tr>
 	<%
		for(int j=0;j<subids.size();j++){
			String subid = (String)subids.get(j);
			String subname=SubCategoryComInfo.getSubCategoryname(subid);
		 	String curmainid = SubCategoryComInfo.getMainCategoryid(subid);
		 	if(!curmainid.equals(mainid)) continue;
	%>
		<tr class="field">
		  <td width="20%"></td>
		  <td>
		  <%if(useUnselected.equals("true")){ %>
			  <% if(selectArr.size()==0||selectArr.indexOf("S"+subid)!=-1){%>
			  <input type="checkbox" name="s<%=mainid%>" value="S<%=subid%>" onclick="checkSub('<%=mainid%>')">
			  <%} else {%>
			  <input type="checkbox" name="s<%=mainid%>" value="S<%=subid%>" onclick="checkSub('<%=mainid%>')" checked>
			  <%}%>
		  <%}else{ %>
		  	  <% if(selectArr.indexOf("S"+subid)==-1){%>
			  <input type="checkbox" name="s<%=mainid%>" value="S<%=subid%>" onclick="checkSub('<%=mainid%>')">
			  <%} else {%>
			  <input type="checkbox" name="s<%=mainid%>" value="S<%=subid%>" onclick="checkSub('<%=mainid%>')" checked>
			  <%}%>
		  <%} %>
		  <%=subname%></td></tr>
	<%
		}
	%>
	</table>
	<%
		if(needtd==0){
			needtd=maincate/2;
	%>
		</td><td align=left valign=top>
	<%
		}
	}
	%>
  </tr>
</table>
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
<style>
#loading{
    position:absolute;
    left:45%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
    display:none;
}
</style>
<div id="loading">	
		<span><img src="/images/loading2.gif" align="absmiddle"></span>
		<span  id="loading-msg"><%=SystemEnv.getHtmlLabelName(19945, user.getLanguage())%></span>
</div>
<script>
function checkMain(id) {
len = document.frmmain.elements.length;
var mainchecked=document.all("m"+id).checked ;
var i=0;
for( i=0; i<len; i++) {
if (document.frmmain.elements[i].name=='s'+id) {
document.frmmain.elements[i].checked= mainchecked ;
}
}
}

function checkSub(id) {
len = document.frmmain.elements.length;
var i=0;
for( i=0; i<len; i++) {
if (document.frmmain.elements[i].name=='s'+id) {
	if(document.frmmain.elements[i].checked){
		document.all("m"+id).checked=true;
		return;
		}
	}
}
document.all("m"+id).checked=false;
}

function onSave(){
    if(document.all("numperpage").value != ""&& document.all("numperpage").value*1<=0 ){
        alert("每页记录条数必须大于零");
        return;
    }

    jQuery("#allContent").hide();
	jQuery("#loading").show();
    if(jQuery("#treeTable").find("input:checked").length>0){
    	
	    jQuery("#treeTable").find("input[type=checkbox]").each(function(){
			//alert($(this).attr("checked"))
			$(this).attr("checked",!$(this).attr("checked"))
	    })
    }
    frmmain.submit();
}
</script>
</body>
</html>