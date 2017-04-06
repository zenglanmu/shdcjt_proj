<%--
  Created by IntelliJ IDEA.
  User: sean
  Date: 2006-3-28
  Time: 17:40:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page" />
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
rs.executeSql("select detachable from SystemSet");
int detachable=0;
if(rs.next()){
    detachable=rs.getInt("detachable");
}
int belid = user.getUserSubCompany1();
int userId = user.getUID();
char flag=Util.getSeparator();
String CurrentUser = ""+user.getUID();
String userType = user.getLogintype();
String userSubCompany=""+DepartmentComInfo.getSubcompanyid1(resourceComInfo.getDepartmentID(CurrentUser));
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String name = Util.null2String(request.getParameter("name"));
String mark = Util.null2String(request.getParameter("mark"));
String fnamark = Util.null2String(request.getParameter("fnamark"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String capitalSpec = Util.null2String(request.getParameter("capitalSpec"));
String stateid = Util.null2String(request.getParameter("stateid"));
String sptcount = Util.null2String(request.getParameter("sptcount"));
String sqlwhere = " ";
String tempwhere = sqlwhere1;
String isCapital = Util.null2String(request.getParameter("isCapital"));
String isInit = Util.null2String(request.getParameter("isInit"));
String rightStr = "";
if(HrmUserVarify.checkUserRight("Capital:Maintenance",user)){
	rightStr = "Capital:Maintenance";
}
String blonsubcomid = "";

String capitalgroupid = Util.null2String(request.getParameter("capitalgroupid"));
if(!capitalgroupid.equals("")) isInit = "1";//从树点击转到的请求
//out.println("isInit===="+isInit);
//资产流转情况页面 可以查看数量是0的资产
String inculdeNumZero = Util.null2String(request.getParameter("inculdeNumZero"));
String cptuse = Util.null2String(request.getParameter("cptuse"));

//判断是否有资产组条件
int indexofsql;
if((indexofsql=tempwhere.indexOf("capitalgroupid"))!=-1){
	String tempstr = tempwhere.substring(indexofsql+15);
	tempwhere = tempwhere.substring(0,indexofsql-1);
	tempstr = " (capitalgroupid = "+tempstr.trim()+" or capitalgroupid in(select id from CptCapitalAssortment where supassortmentstr like '%|"+tempstr.trim()+"|%'))";
	tempwhere = tempwhere.concat(tempstr);

}

int ishead = 0;
int isdata = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += tempwhere;
	}
	if(sqlwhere1.indexOf("isdata")!=-1){
		String sqlwhere_tmp = sqlwhere1.substring(sqlwhere1.indexOf("isdata")+1);
		int index1 = sqlwhere_tmp.indexOf("'1'");
		int index2 = sqlwhere_tmp.indexOf("'2'");
		if(index1==-1 && index2>-1){
			isdata = 2;
		}else if(index1>-1 && index2==-1){
			isdata = 1;
		}
	}
	else{
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where isdata = '2' ";
		}
		else{
			sqlwhere += " and isdata = '2' ";
		}
	}
}
else{
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where isdata = '2' ";
	}
	else{
		sqlwhere += " and isdata = '2' ";
	}
}

if(!name.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where name like '%";
		sqlwhere += Util.fromScreen2(name,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and name like '%";
		sqlwhere += Util.fromScreen2(name,user.getLanguage());
		sqlwhere += "%'";
	}
}

if(!mark.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where mark like '%";
		sqlwhere += Util.fromScreen2(mark,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and mark like '%";
		sqlwhere += Util.fromScreen2(mark,user.getLanguage());
		sqlwhere += "%'";
	}
}

if(!fnamark.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where fnamark like '%";
		sqlwhere += Util.fromScreen2(fnamark,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and fnamark like '%";
		sqlwhere += Util.fromScreen2(fnamark,user.getLanguage());
		sqlwhere += "%'";
	}
}

if(!stateid.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where stateid in (";
		sqlwhere += Util.fromScreen2(stateid,user.getLanguage());
		sqlwhere += ") ";
	}
	else{
		sqlwhere += " and stateid in (";
		sqlwhere += Util.fromScreen2(stateid,user.getLanguage());
		sqlwhere += ") ";
	}
}


if(!sptcount.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where sptcount = '";
		sqlwhere += Util.fromScreen2(sptcount,user.getLanguage());
		sqlwhere += "'";
	}
	else{
		sqlwhere += " and sptcount = '";
		sqlwhere += Util.fromScreen2(sptcount,user.getLanguage());
		sqlwhere += "'";
	}
}

if(!capitalgroupid.equals("")&&!capitalgroupid.equals("0")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where (capitalgroupid = "+capitalgroupid+" or capitalgroupid in(select id from CptCapitalAssortment where supassortmentstr like '%|"+capitalgroupid+"|%')) ";
	}
	else{
		sqlwhere += " and (capitalgroupid = "+capitalgroupid+" or capitalgroupid in(select id from CptCapitalAssortment where supassortmentstr like '%|"+capitalgroupid+"|%')) ";
	}
}

if(!capitalSpec.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where capitalSpec like '%";
		sqlwhere += Util.fromScreen2(capitalSpec,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and capitalSpec like '%";
		sqlwhere += Util.fromScreen2(capitalSpec,user.getLanguage());
		sqlwhere += "%'";
	}
}

//权限条件 modify by ds Td:9699
if(detachable == 1 && userId!=1){
	 if(isdata ==2){
		String sqltmp = "";
		rs2.executeProc("HrmRoleSR_SeByURId", ""+userId+flag+rightStr);
		while(rs2.next()){
		    blonsubcomid=rs2.getString("subcompanyid");
			sqltmp += (", "+blonsubcomid);
		}
		if(!"".equals(sqltmp)){//角色设置的权限
			sqltmp = sqltmp.substring(1);
			if(ishead==0){
				sqlwhere += " where blongsubcompany in ("+sqltmp+") ";
			}else{
				sqlwhere += " and blongsubcompany in ("+sqltmp+") ";
			}
		}else{
			if(ishead==0){
				sqlwhere += " where blongsubcompany in ("+belid+") ";
			}else{
				sqlwhere += " and blongsubcompany in ("+belid+") ";
			}
		}
	}else if(isdata==1){
		int allsubids[] = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),rightStr);
		String allsubid = "";
		for(int i=0;i<allsubids.length;i++){
			if(allsubids[i]>0){
				allsubid += (allsubid.equals("")?"":",") + allsubids[i];
			}	
		}
		if(allsubid.equals("")) allsubid = user.getUserSubCompany1() + "";
		if(!"".equals(allsubid)){//角色设置的权限
			if(ishead==0){
				sqlwhere += " where blongsubcompany in ("+allsubid+") ";
			}else{
				sqlwhere += " and blongsubcompany in ("+allsubid+") ";
			}
		}else{
			if(ishead==0){
				sqlwhere += " where blongsubcompany in ("+allsubid+") ";
			}else{
				sqlwhere += " and blongsubcompany in ("+allsubid+") ";
			}
		}
	}
}
	if(!departmentid.equals("")){//组合查询的部门选择条件
			if(ishead==0){
				ishead = 1;
				sqlwhere += " where departmentid = ";
				sqlwhere += Util.fromScreen2(departmentid,user.getLanguage());
			}
			else{
				sqlwhere += " and departmentid = ";
				sqlwhere += Util.fromScreen2(departmentid,user.getLanguage());
			}
		}

%>
<BODY > <!--style="overflow:scroll"-->
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

    <TABLE ID=BrowseTable class=BroswerStyle cellspacing="1" width="100%"  >
    <%
    if (isCapital.equals("0"))
        sqlwhere = "select distinct t1.id,t1.name,t1.blongsubcompany,mark,resourceid,capitalgroupid,departmentid,stateid,capitalnum,capitalspec,unitid,startprice from CptCapital t1 "+sqlwhere;
    else
        sqlwhere = "select distinct t1.id,t1.name,t1.blongsubcompany,resourceid,mark,fnamark,capitalgroupid,departmentid,stateid,capitalnum,capitalspec,unitid,location,sptcount,frozennum from CptCapital t1,CptShareDetail t2 "+sqlwhere+" and ( t1.id=t2.cptid and t2.userid="+ CurrentUser + " ) and t2.usertype = "+userType;

    boolean isLight = false;
    String blsubid = "";
    String tempid = "";
    String tempcapitalgroupid = "";
    String tempsupid = "";
    String temprootid = "";
    String departmentids = "";
    String tempstateid = "";
    String tempmark = "";
    double cptNum = 0.0f;
    String m_owner = "";  // added by lupeng 2004-07-27 for TD573
    String m_capitalspec="";
    String m_unitid="";
    String m_startprice="";
    String m_location="";
    String m_sptcount="";

//add by zhouquan TD1427 增加在缓存表CptBorrowBuffer中的过滤
sqlwhere+=" and t1.id not in( select cptid from CptBorrowBuffer)";
if(isInit.equals("0")) {
	sqlwhere += " and 1=2"; 
}
if(request.getParameter("currpage")!=null) {
	String pageSqlKey = Util.null2String( request.getParameter("pagesql"));
	sqlwhere ="";
	if(session.getAttribute(pageSqlKey)!=null){
		sqlwhere = (String)session.getAttribute(pageSqlKey);
	}
}
int pagecnt = 20;//每页显示数
int currpage = Util.getIntValue(Util.null2String(request.getParameter("currpage")), 1);//当前页
int startpagenum = (currpage-1)*pagecnt;
int cnt = 0;
boolean hasnextpage = false;
RecordSet.execute(sqlwhere);
    while (RecordSet.next()) {
		
    	blsubid = RecordSet.getString("blongsubcompany");//所属分部ID
        tempid = RecordSet.getString("id");
        tempcapitalgroupid = RecordSet.getString("capitalgroupid");
        tempsupid = CapitalAssortmentComInfo.getSupAssortmentId(tempcapitalgroupid);
        temprootid = tempsupid;
        departmentids = RecordSet.getString("departmentid");
        tempstateid = RecordSet.getString("stateid");
        tempmark = "";

        m_owner = Util.null2String(RecordSet.getString("resourceid"));    // added by lupeng 2004-07-27 for TD573
        m_owner = resourceComInfo.getLastname(m_owner);

        m_capitalspec=Util.null2String(RecordSet.getString("capitalspec"));
        m_startprice=Util.null2String(RecordSet.getString("startprice"));
        m_unitid=AssetUnitComInfo.getAssetUnitname(RecordSet.getString("unitid"));
        m_location=Util.null2String(RecordSet.getString("location"));
        m_sptcount=Util.null2String(RecordSet.getString("sptcount"));

        if (isCapital.equals("1")) {
            cptNum = Util.getDoubleValue(RecordSet.getString("capitalnum"));
            cptNum = cptNum-Util.getDoubleValue(RecordSet.getString("frozennum"));
            if (cptNum<=0&&!inculdeNumZero.equals("1"))
                continue;
        }
        if(isCapital.equals("0") || isCapital.equals("1")) cnt++;
		if(cnt<=startpagenum) continue;//从第几条开始显示
		if(cnt>currpage*pagecnt) {
    		if(RecordSet.getCounts()>=cnt) hasnextpage = true;//判断是否有下页
    		break;//显示每页足够数量返回
    	}
        isLight = !isLight;
    %>
    <TR class="<%=(isLight ? "DataLight" : "DataDark")%>">

        <!--资产资料列表-->
        <%if(isCapital.equals("0")){%>        
            <!-- 0,6,1,2,3,7,8,9,5,10,11,12,13 -->
            <TD style='display:none'><A HREF=# ><%=tempid+"_#_"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"_#_"+tempsupid+"_#_"+temprootid+"_#_"+m_owner+"_#_"+m_capitalspec+"_#_"+m_startprice+"_#_"+m_unitid+"_#_"+Util.toScreen(RecordSet.getString("mark"),user.getLanguage())+"_#_"+"_#_"+"_#_"+"_#_"%></A></TD>

			<TD width=25% style="LEFT: 0px; WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;"><%=SubCompanyComInfo.getSubCompanyname(String.valueOf(blsubid))%></TD>
            <TD width=30% style="LEFT: 0px; WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;"><%=Util.toScreen(RecordSet.getString("mark"),user.getLanguage())%></TD>
            <TD width=45% style="LEFT: 0px; WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;"><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%></TD>

        <%}%>

        <!--资产列表-->
        <%if(isCapital.equals("1")){%>
            <!-- 0,6,1,2,3,7,8,9,5,10,11,12,13 -->
            <TD style='display:none'><A HREF=# ><%=tempid+"_#_"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"_#_"+tempsupid+"_#_"+temprootid+"_#_"+m_owner+"_#_"+Util.toScreen(RecordSet.getString("fnamark"),user.getLanguage())+"_#_"+Util.toScreen(CapitalStateComInfo.getCapitalStatename(tempstateid),user.getLanguage())+"_#_"+String.valueOf(cptNum)+"_#_"+Util.toScreen(RecordSet.getString("mark"),user.getLanguage())+"_#_"+m_capitalspec+"_#_"+m_location+"_#_"+m_unitid+"_#_"+m_sptcount%></A></TD>

			<TD width=15% style="LEFT: 0px; WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;"><%=SubCompanyComInfo.getSubCompanyname(String.valueOf(blsubid))%></TD>
            <TD width=15% style="LEFT: 0px; WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;"><%=Util.toScreen(RecordSet.getString("mark"),user.getLanguage())%></TD>
            <TD width=25% style="LEFT: 0px; WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;"><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%></TD>
            <TD width=15% style="LEFT: 0px; WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;"><%=Util.toScreen(RecordSet.getString("fnamark"),user.getLanguage())%></TD>
            <TD width=8%  style="LEFT: 0px; WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;"><%=Util.toScreen(CapitalStateComInfo.getCapitalStatename(tempstateid),user.getLanguage())%></TD>
            <TD width=9%  style="LEFT: 0px; WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;"><%=String.valueOf(cptNum)%></TD>
            <TD width=23% style="LEFT: 0px; WORD-WRAP: break-word;TEXT-VALIGN: left;word-break:break-all;"><%=m_capitalspec%></TD>

        <%}%>
    
    </TR>
    <%}%>
    </TABLE>
    <%
		String currentdata=Util.getEncrypt(Util.getRandom()); 
        session.setAttribute(currentdata,sqlwhere);	
	%>
    <FORM ID=SearchForm NAME=SearchForm STYLE="margin-bottom:0" action="/cpt/capital/CapitalBrowserList.jsp" method=post>
    <input type=hidden name=sqlwhere value="<%=sqlwhere1%>">
	<input type=hidden id=stateid name=stateid value="<%=stateid%>">
	<input type=hidden id=sptcount name=sptcount value="<%=sptcount%>">
	<input type=hidden id=isCapital name=isCapital value="<%=isCapital%>">
	<input type=hidden id=inculdeNumZero name=inculdeNumZero value="<%=inculdeNumZero%>">
	<input type=hidden id=capitalgroupid name=capitalgroupid value="<%=capitalgroupid%>"> <!--Only for CapitalBrowserTree-->
	<input type=hidden id=cptuse name=cptuse value="<%=cptuse%>">
	<input type=hidden id=rightStr name=rightStr value="<%=rightStr%>">
	<input type=hidden id=isInit name=isInit value="1">
	<input type=hidden id=currpage name=currpage value="<%=currpage%>">
	<textarea name="pagesql" style="display:none"><%=currentdata%></textarea>
	</form>
</BODY>
</HTML>
<%
if(currpage>1) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:prepage(this),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(hasnextpage) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:nextpage(this),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<script type="text/javascript">
function prepage(obj) {
	var topage = SearchForm.currpage.value*1-1;
	if(topage==0) topage = 1;
	SearchForm.currpage.value = topage;
	SearchForm.submit();
	obj.disabled=true;
}
function nextpage(obj) {
	var topage = SearchForm.currpage.value*1+1;
	SearchForm.currpage.value = topage;
	SearchForm.submit();
	obj.disabled=true;
}

function btnclear_onclick(){
	window.parent.parent.returnValue = {id:"",name:""};
	window.parent.parent.close();
}
function BrowseTable_onmouseover(e){
	e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
}
function BrowseTable_onmouseout(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
      p=jQuery(target).parents("tr")[0];
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark"
      }else{
         p.className = "DataLight"
      }
   }
}
function BrowseTable_onclick(e){
 var target = e.srcElement||e.target;
if( target.tagName == "TD" ){
	 v = $($(target).parent().children("TD").children("A")[0]).text().split("_#_");
 	window.parent.parent.returnValue = {id:v[0],name:v[1],other1:v[2],other2:v[3],other3:v[4],other4:v[5],other5:v[6],other6:v[7],other7:v[8],other8:v[9],other9:v[10],other10:v[11],other11:v[12]};
   window.parent.parent.close();
}
else if( e.tagName == "A" ){
	 v = $($(target).parent().children("TD").children("A")[0]).text().split("_#_");
   window.parent.parent.returnValue = {id:v[0],name:v[1],other1:v[2],other2:v[3],other3:v[4],other4:v[5],other5:v[6],other6:v[7],other7:v[8],other8:v[9],other9:v[10],other10:v[11],other11:v[12]};
   window.parent.parent.close();
}
}

jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
})
</script>