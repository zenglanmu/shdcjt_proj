<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="AssetAssortmentList" class="weaver.lgc.maintenance.AssetAssortmentList" scope="page" />
<jsp:useBean id="LgcAssortmentComInfo" class="weaver.lgc.maintenance.LgcAssortmentComInfo" scope="page"/>

<HTML><HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=GBK">
<META NAME="AUTHOR" CONTENT="InetSDK">
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

String selectedid ="" ;
String oldselectedid = Util.null2String(request.getParameter("selectedid"));
String newselectedid = Util.null2String(request.getParameter("newselectedid"));
String addorsub = Util.null2String(request.getParameter("addorsub"));

//
    while(LgcAssortmentComInfo.next())  {
      String assortmentid = LgcAssortmentComInfo.getAssortmentId() ;
      String subassortmentcount = LgcAssortmentComInfo.getSubAssortmentCount() ;
		selectedid += "|"+assortmentid ;
	}
//

//刚进入该页面时展开显示所有级别资产组-begin

if(addorsub.equals("3")){
	addorsub="1";
    while(LgcAssortmentComInfo.next())  {
      String assortmentid = LgcAssortmentComInfo.getAssortmentId() ;
      String subassortmentcount = LgcAssortmentComInfo.getSubAssortmentCount() ;
	  if(!subassortmentcount.equals("0")){
		newselectedid += "|"+assortmentid ;
	  }
	}
	if(!newselectedid.equals("")) newselectedid=newselectedid.substring(1);
}
//刚进入该页面时展开显示所有级别资产组-end

if(!newselectedid.equals("")) {
	if(addorsub.equals("1")) selectedid = oldselectedid+newselectedid+"|" ;
	else selectedid = Util.StringReplace(oldselectedid,newselectedid+"|" , "") ;
}

AssetAssortmentList.initAssetAssortmentList(selectedid);
int rootassortmentcount = LgcAssortmentComInfo.getRootAssortmentNum();
int rownum = 0;
int tmp =rootassortmentcount/2;
if((tmp * 2)== rootassortmentcount)
	rownum = tmp;
else
	rownum = tmp+1;
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(178,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>


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
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<FORM id=weaver name=frmmain method=post action="LgcAssortmentAdd.jsp">
  <div style="display:none"> 
    <%
if(HrmUserVarify.checkUserRight("CrmProduct:Add", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javascript:submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
    <BUTTON class=btnNew accessKey=N onclick="submit()"><U>N</U>-<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%></BUTTON> 
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(16513,user.getLanguage())+",javascript:addproduct(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
    <BUTTON class=btnNew accessKey=P onclick="addproduct()"><U>P</U>-<%=SystemEnv.getHtmlLabelName(16513,user.getLanguage())%></BUTTON> 
<% } %>
<!--
<% 
if(HrmUserVarify.checkUserRight("LgcAssortment:Log", user)){
%>
    <BUTTON class=BtnLog accessKey=L name=button2 onclick="location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =43'"><U>L</U>-<%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></BUTTON> 
    <%}
%>
-->
    <input type="hidden" name="paraid">
  </div>
</form>
<TABLE class=ListStyle>

  <TBODY>

  <TR class=Field>
    <TD align=left valign=top >
    <table >
 <%
 int needtd=rownum;
 int cloumnum = 1;
 boolean changetableflag = false;
%>
<tr><td height="8"></td></tr>
<%
	AssetAssortmentList.setAssetAssortmentList("0");
	while(AssetAssortmentList.next()){
		String assortmentstep = AssetAssortmentList.getAssortmentStep();
		String assortmentid = AssetAssortmentList.getAssortmentId();
		String assortmentmark = AssetAssortmentList.getAssortmentMark();
		String assortmentname = AssetAssortmentList.getAssortmentName();
		String assortmentimage = AssetAssortmentList.getAssortmentImage();
		String assetcount     =  AssetAssortmentList.getAssetCount();
		String subassortmentcount = AssetAssortmentList.getSubAssortmentCount();
		String supassortmentid = AssetAssortmentList.getSupAssortmentId();
		int tdwidth = Util.getIntValue(assortmentstep)*15 ;

	if (supassortmentid.equals("0"))
	{
		if (changetableflag)
		{
 %>
 </table></td><td align=left valign=top><table >
<tr><td height="8"></td></tr>
 <%		  changetableflag = false;
		  needtd = rownum; cloumnum++;
	    }
		needtd--;
		if (needtd==0 && cloumnum<2)
		{
			changetableflag=true;
		}
	}
%>
<tr><td>
<table width="100%" border="0" cellspacing="0" cellpadding="0"><tr>
<td width="<%=tdwidth%>"><!-- <img src="0.gif" width="<%=tdwidth%>" height="1"> --></td>
<td WIDTH="20px" align="left">
<% if(assortmentimage.equals("0")) {%><IMG SRC="/images/imgBullet.gif" BORDER="0" HEIGHT="12px" WIDTH="12px">
<%} else if(assortmentimage.equals("1")) {%>
<A HREF="LgcAssortment.jsp?selectedid=<%=selectedid%>&newselectedid=<%=assortmentid%>&addorsub=1"><IMG SRC="\images\btnDocExpand.gif" BORDER="0" HEIGHT="12px" WIDTH="12px"></A>
<%} else if(assortmentimage.equals("2")) {%>
<A HREF="LgcAssortment.jsp?selectedid=<%=selectedid%>&newselectedid=<%=assortmentid%>&addorsub=0"><IMG SRC="\images\btnDocCollapse.gif" BORDER="0" HEIGHT="12px" WIDTH="12px"></A>
<% } %>
</td>
<td  align="left" id="<%=assortmentid%>" onClick="clicktable(this)" ondblclick="dblclicktable(this)">
<%=assortmentmark%>&nbsp;-&nbsp;<%=assortmentname%>&nbsp;
<A HREF="/lgc/search/LgcSearchProduct.jsp?assortmentid=<%=assortmentid%>">(<%=Util.null2String(assetcount)%>) </td>
</tr></table>
</td></tr>
<% }%>

</table></TD>
</TR>
</table>
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script  language="javascript">
var lastclickid ;
var flag=0;
function clicktable(thetd){
	if(thetd.id != lastclickid) {
		document.all(lastclickid).className = "" ;
		lastclickid = thetd.id ;
		thetd.className = "Selected" ;
		frmmain.paraid.value= lastclickid ;
	}
	else if (!flag){
		thetd.className = "";
		frmmain.paraid.value = "";
		flag = true;
	}
	else {
		thetd.className = "Selected";
		frmmain.paraid.value = thetd.id;
		flag = false;
	}
}

function dblclicktable(thetd){
	thetableid = thetd.id ;
	location.href='LgcAssortmentView.jsp?paraid='+thetableid;
}

function submit(){
   frmmain.submit() ;	
}

function addproduct(){
	document.frmmain.action="/lgc/asset/LgcAssetAdd.jsp";
   frmmain.submit() ;	
}
</script>
