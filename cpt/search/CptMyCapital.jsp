<%--
@Date July 16,2004
@Modified Charoes Huang
@Description: For bug 119
--%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page" />
<jsp:useBean id="CapitalAssortmentList" class="weaver.cpt.maintenance.CapitalAssortmentList" scope="page" />
<jsp:useBean id="CptGetMyCapital" class="weaver.cpt.search.CptGetMyCapital" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML><HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=GBK">
<META NAME="AUTHOR" CONTENT="InetSDK">
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%

String resourceid = Util.null2String(request.getParameter("id"));
String closeassortmentid = Util.null2String(request.getParameter("closeassortmentid"));
String requestid = resourceid;
if(resourceid.equals("")){
resourceid = ""+user.getUID();
}

String sqlstatus = "select status from HrmResource where id = "+resourceid;
RecordSet.executeSql(sqlstatus);
RecordSet.next();
int status = RecordSet.getInt("status");
boolean isCpt = ResourceComInfo.isCapInfoView(user.getUID(),resourceid);

int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

String selectedid ="" ;
String oldselectedid = Util.null2String(request.getParameter("selectedid"));
String newselectedid = Util.null2String(request.getParameter("newselectedid"));
String addorsub = Util.null2String(request.getParameter("addorsub"));
//刚进入该页面时展开显示所有级别资产组-begin
if(addorsub.equals("3")){
	addorsub="1";
    while(CapitalAssortmentComInfo.next())  {
      String assortmentid = CapitalAssortmentComInfo.getAssortmentId() ;
      String subassortmentcount = CapitalAssortmentComInfo.getSubAssortmentCount() ;
	  if(!subassortmentcount.equals("0")){
		newselectedid += "|"+assortmentid ;
	  }
	}
	if(!newselectedid.equals(""))  newselectedid=newselectedid.substring(1);
}
//刚进入该页面时展开显示所有级别资产组-end

if(!newselectedid.equals("")) {
	if(addorsub.equals("1")) selectedid = oldselectedid+newselectedid+"|" ;
	else selectedid = Util.StringReplace(oldselectedid,newselectedid+"|" , "") ;
}

CapitalAssortmentList.initCapitalAssortmentList(selectedid);
int rootassortmentcount = CapitalAssortmentComInfo.getRootAssortmentNum();
int rownum = 0;
int tmp =rootassortmentcount/2;
if((tmp * 2)== rootassortmentcount)
	rownum = tmp;
else
	rownum = tmp+1;
String imagefilename = "/images/hdMaintenance.gif";

//modified by lupeng 2004.2.6
String titlename = SystemEnv.getHtmlLabelName(1209,user.getLanguage());
    if (!requestid.equals("") && !requestid.equals(String.valueOf(user.getUID())))
        titlename = ResourceComInfo.getLastname(requestid) + " - " + SystemEnv.getHtmlLabelName(535,user.getLanguage());
//end

String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(15360,user.getLanguage())+",/cpt/search/SearchOperation.jsp?resourceid="+resourceid+"&type=mycpt&isdata=2,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:onReSearchMycpt(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

if(status != 10 ){
    if(isCpt){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(886,user.getLanguage())+",/cpt/capital/CptCapitalUse.jsp,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	}
}
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<FORM id=weaver name=frmmain method=post action="CptAssortmentAdd.jsp">
  <div> 
    <input type="hidden" name="paraid">
    <input type="hidden" name="paraid">
  </div>
</form>
<FORM id=cptfrmmain name=cptfrmmain method=post action="CptMyCapital.jsp">
	<input type="hidden" name="selectedid" value="<%=selectedid%>">
	<input type="hidden" name="id" value="<%=requestid%>">
	<input type="hidden" name="newselectedid" value="<%=newselectedid%>">
	<input type="hidden" name="id" value="<%=requestid%>">
	<input type="hidden" name="addorsub" value="">
	<input type="hidden" name="closeassortmentid" value="<%=closeassortmentid%>">
</form>

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

		<TABLE class=ViewForm>
		  <COLGROUP>
		  <COL width="50%">
		  <COL width="50%">
		  <TBODY>
		  <TR >
			<TD align=left valign=top>
			<table class=ViewForm>
		 <%
		 int needtd=rownum;
		 int cloumnum = 1;
		 boolean changetableflag = true;
		%>

		<%
			String sql = "";
			String allsupgroupids = "";
			ArrayList tempgroupids = new ArrayList() ;
			ArrayList tempgroupcounts = new ArrayList() ;
			ArrayList tempstrarray = new ArrayList() ;
			HashMap tree = new HashMap(); 
			HashMap groupcount = new HashMap();
			HashMap displaygroup = new HashMap();
			sql = "select a.count,a.capitalgroupid,b.supassortmentstr,b.supassortmentid from (select count(id) as count , capitalgroupid from CptCapital where resourceid = "+resourceid+" and isdata = '2' and stateid <> 1 group by capitalgroupid) a, cptcapitalassortment b where a.capitalgroupid = b.id";			
			RecordSet.executeSql(sql);
			while(RecordSet.next()){
				String tempgroupid = RecordSet.getString("capitalgroupid");
				String tempgroupcount = RecordSet.getString("count");
				String tempstr = CapitalAssortmentComInfo.getSupAssortmentStr(tempgroupid);
				tempgroupids.add(tempgroupid) ;
				tempgroupcounts.add(tempgroupcount) ;
				tempstrarray.add(tempstr) ;
				allsupgroupids += tempgroupid+"|"+RecordSet.getString("supassortmentstr");
				groupcount.put(tempgroupid,tempgroupcount);
			}
			
			if(!allsupgroupids.equals("")) allsupgroupids = allsupgroupids + "-1";
			allsupgroupids = Util.StringReplace(allsupgroupids,"|",",");			
			
			if(!allsupgroupids.equals("")){
				sql = "select * from cptcapitalassortment where id in ("+allsupgroupids+") order by supassortmentstr asc";
				RecordSet.executeSql(sql);
				while(RecordSet.next()){
					String id = RecordSet.getString("id");
					String supassortmentid = RecordSet.getString("supassortmentid");
					String temp = Util.null2String((String)tree.get(supassortmentid));
					if(temp.equals("")) tree.put(supassortmentid,id);
					else tree.put(supassortmentid,temp+"|"+id);
				}
			}
			
			String closeassortmentids[] = Util.TokenizerString2(closeassortmentid,",");			
			for(int i=0;i<closeassortmentids.length;i++){
				if(!closeassortmentids[i].equals("")){
					sql = "select * from cptcapitalassortment where id in ("+allsupgroupids+") and supassortmentstr like '%|"+closeassortmentids[i]+"|%'";
					RecordSet.executeSql(sql);
					while(RecordSet.next()){
						String id = RecordSet.getString("id");
						displaygroup.put(id,id);
					}					
				}
			}
						
			CptGetMyCapital.capitalsort(tree,groupcount,"0",1);
			ArrayList assortmentids = CptGetMyCapital.getAssortmentid();
			ArrayList assortmentsteps = CptGetMyCapital.getAssortmentstep();
			ArrayList capitalcounts = CptGetMyCapital.getCapitalcount();			
			
			for(int i=0;i<assortmentids.size();i++){								
				String assortmentstep = Util.null2String((String)assortmentsteps.get(i));//级别
				String assortmentid = Util.null2String((String)assortmentids.get(i));//资产组id
				String capitalcount = Util.null2String((String)capitalcounts.get(i));//非末级为0
				String assortmentname = CapitalAssortmentComInfo.getAssortmentName(assortmentid) ;//资产组名称
				String assortmentimage = "";//末级为0，展开为2,收缩后的为1
				if(capitalcount.equals("")) assortmentimage = "2";
				else assortmentimage = "0";
				String supassortmentid = CapitalAssortmentComInfo.getSupAssortmentId(assortmentid);//上级资产组id
				String subassortmentcount = CapitalAssortmentComInfo.getSubAssortmentCount(assortmentid);//下级资产组个数？
				int tdwidth = Util.getIntValue(assortmentstep)*15 ;
				boolean canView = true;				
				
				if((","+closeassortmentid+",").indexOf(","+assortmentid+",")>-1) assortmentimage = "1";
				if(!Util.null2String((String)displaygroup.get(assortmentid)).equals("")) canView = false ;
				
				
			if (supassortmentid.equals("0"))
			{
				if (changetableflag)
				{
		 %>
		 </table></td></tr><tr><td align=left valign=top><table class=ViewForm>
		<tr><td height="8"></td></tr>
		 <%		  
				}else{
%>
		 </table></td><td align=left valign=top><table class=ViewForm>
		<tr><td height="8"></td></tr>
<%					
				}				
				changetableflag=!changetableflag;
			}
		%>
		<%if(canView){		
		%>
		<tr><td>
		<table width="100%" border="0" cellspacing="0" cellpadding="0"><tr>
		<td width="<%=tdwidth%>"><img src="0.gif" width="<%=tdwidth%>" height="1"></td>
		<td WIDTH="20px" align="left">
		<% if(assortmentimage.equals("0")) {%><IMG SRC="/images/imgBullet.gif" BORDER="0" HEIGHT="12px" WIDTH="12px">
		<%} else if(assortmentimage.equals("1")) {%>
		<A HREF="javascript:doSearch(1,<%=assortmentid%>)"><IMG SRC="/images/btnDocExpand.gif" BORDER="0" HEIGHT="12px" WIDTH="12px"></A>
		<%} else if(assortmentimage.equals("2")) {%>
		<A HREF="javascript:doSearch(0,<%=assortmentid%>)"><IMG SRC="/images/btnDocCollapse.gif" BORDER="0" HEIGHT="12px" WIDTH="12px"></A>
		<% } %>
		</td>
		<td  align="left" id="<%=assortmentid%>" onClick="clicktable(this)" ondblclick="dblclicktable(this)">
		<%=assortmentname%>&nbsp;
		<%if (subassortmentcount.equals("0")) {%><%if (!capitalcount.equals("0")) {%><A HREF="SearchOperation.jsp?type=mycptdetail&resourceid=<%=resourceid%>&isdata=2&capitalgroupid=<%=assortmentid%>"><%}%>(<%=Util.null2String(capitalcount)%>)<%if (!capitalcount.equals("0")) {%></A><%}}%> </td>
		</tr></table>
		</td></tr>
		<% }%>
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

<script>
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
	location.href='SearchOperation.jsp?resourceid=<%=resourceid%>&isdata=2&capitalgroupid='+thetableid;
}

function submit(){
   frmmain.submit() ;	
}

function onReSearchMycpt(){
	location.href="/cpt/search/CptSearch.jsp?isdata=2&resourceid=<%=resourceid%>&type=mycpt";
}

function doSearch(addorsub,closeassortmentid){
	//0,显示
	//1，不显示
	var tempcloseassortmentid = document.cptfrmmain.closeassortmentid.value;
	if(addorsub=="1"&&tempcloseassortmentid!=""){
		var _temp = tempcloseassortmentid;
		if(!_temp.substring(0,1)==",") _temp = "," + _temp;		
		if(!_temp.substring(_temp.length-1,_temp.length)==",") _temp = _temp + ",";	
		var _tempcloseassortmentid = _temp.replace(eval("/"+closeassortmentid+"/g"),",");
		document.cptfrmmain.closeassortmentid.value = _tempcloseassortmentid;
	}else{
		document.cptfrmmain.closeassortmentid.value += ","+closeassortmentid;
	}
	
	
	document.cptfrmmain.addorsub.value=addorsub;
	cptfrmmain.submit() ;
}
</script>
