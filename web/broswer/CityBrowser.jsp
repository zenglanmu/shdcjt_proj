<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String countryid = Util.null2String(request.getParameter("countryid"));
if (countryid.equals("") ){
countryid = user.getCountryid();
}
String provinceid = Util.null2String(request.getParameter("provinceid"));
if (provinceid.equals("") ){
provinceid = ""+user.getProvince();
}
String cityname = Util.null2String(request.getParameter("cityname"));
String sqlwhere = " ";
boolean isOracleCity = rs.getDBType().equals("oracle");

if(!sqlwhere1.equals("")){
    if(isOracleCity) {
	    sqlwhere += " and nvl(canceled,0) <> 1";
    }else{
        sqlwhere += " and ISNULL(canceled,0) <> 1";
    }
}else{
    if(isOracleCity) {
	    sqlwhere = " where nvl(canceled,0) <> 1";
    }else{
        sqlwhere = " where ISNULL(canceled,0) <> 1";
    }
}
if(!countryid.equals("") && !countryid.equals("0")){
		sqlwhere += " and countryid = ";
		sqlwhere += Util.fromScreen2(countryid,user.getLanguage());
}
if(!provinceid.equals("") && !provinceid.equals("0")){
		sqlwhere += " and provinceid = ";
		sqlwhere += Util.fromScreen2(provinceid,user.getLanguage());
}
if(!cityname.equals("")){
		sqlwhere += " and cityname like '%";
		sqlwhere += Util.fromScreen2(cityname,user.getLanguage());
		sqlwhere += "%'";
}
%>
<BODY>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="CityBrowser.jsp" method=post>
<input type=hidden name=sqlwhere value="<%=sqlwhere1%>">

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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
		
<table width=100% class=ViewForm>
<TR class=separator style="height: 1px"><TD class=Sep1 colspan=6></TD></TR>
<TR>
<TD><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></TD><!-- 国家 -->
<TD class=field>
<select id="country" name=countryid size=1 class=inputstyle onChange="SearchForm.submit();" onmouseover="changeTitle('country', this.value);" width=10 style="width:140px">
     <option value=""></option>
     <%-- <%while(CountryComInfo.next()){
     	String selected="";
     	String curcountryid=CountryComInfo.getCountryid();
     	String curcountryname=CountryComInfo.getCountryname();
     	if(curcountryid.equals(countryid+""))	selected="selected";
     %> --%>
     <%
        boolean isOracleCountry = rs.getDBType().equals("oracle");
        String countrySql = "";
        if(isOracleCountry){
        	countrySql = "select * from HrmCountry where nvl(canceled,0) <> 1";
        }else{
     		countrySql = "select * from HrmCountry where ISNULL(canceled,0) <> 1";
     	}
     	rs.execute(countrySql);
     	while(rs.next()) {
     		String selected="";
	     	String curcountryid=Util.null2String(rs.getString("id"));
	     	String curcountryname=Util.null2String(rs.getString("countryname"));
	     	if(curcountryid.equals(countryid+""))	selected="selected";
      %>
     <option value="<%=curcountryid%>" <%=selected%>><%=Util.toScreen(curcountryname,user.getLanguage())%></option>
     <%
     }%>
     </select>
</TD>
<TD><%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%></TD><!-- 省份 -->
<TD class=field>
<select id='provinceid' name=provinceid size=1 class=saveHistory  onChange="SearchForm.submit();" style="width:50px" onmouseover="changeTitle('provinceid', this.value);">
     <option value=""></option>
     <%-- <%
	  rs.executeProc("HrmProvince_Select",countryid);
	  while(rs.next()){
     	String selected="";
     	String curprovinceid=rs.getString(1);
     	String curprovincename=rs.getString(2);
     	if(curprovinceid.equals(provinceid+""))	selected="selected";
     %> --%>
     <%
     boolean isOracleProvince = rs.getDBType().equals("oracle");
	 String provinceSql = "";
     if(isOracleProvince){
      	provinceSql = "select * from HrmProvince where countryid = " + countryid + " and nvl(canceled,0) <> 1";
     }else{
     	provinceSql = "select * from HrmProvince where countryid = " + countryid + " and ISNULL(canceled,0) <> 1";
   	 }
   	 rs.execute(provinceSql);
     while(rs.next()) {
     	String selected="";
     	String curprovinceid=rs.getString(1);
     	String curprovincename=rs.getString(2);
     	if(curprovinceid.equals(provinceid+""))	selected="selected";
      %>
     <option value="<%=curprovinceid%>" <%=selected%>><%=Util.toScreen(curprovincename,user.getLanguage())%></option>
     <%
     }%>
     </select>
</TD>
<TD><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD><!-- 城市 -->
<TD class=field><input name=cityname value="<%=cityname%>" class=inputstyle width="60px"></TD>
</TR>
<TR class=separator style="height: 1px"><TD class=Sep1 colspan=6></TD></TR>
</table>
<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 width="100%">
<TR class=DataHeader>
<TH width=30%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%></TH>
<%
int i=0;
String sqlstr = "";
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int	perpage=20;

if(rs.getDBType().equals("oracle")){
		sqlstr = " (select * from (select distinct * from HrmCity " + sqlwhere + " order by id) where rownum<"+ (pagenum*perpage+2) + ") s";
}else{
		sqlstr = " (select distinct top "+(pagenum*perpage+1)+" * from HrmCity " + sqlwhere + " order by id) as s" ;
}

rs.executeSql("Select count(id) RecordSetCounts from "+sqlstr);

boolean hasNextPage=false;
int RecordSetCounts = 0;
if(rs.next()){
	RecordSetCounts = rs.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}

String sqltemp="";
if(rs.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+sqlstr+" order by id desc) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+sqlstr+"  order by id desc";
}
rs.execute(sqltemp);
int totalline=1;
if(rs.last()){
do{
	if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
	<%
	}
	%>
	<TD><%=rs.getString(1)%></TD>
	<TD><%=rs.getString(2)%></TD>	<TD><%=Util.toScreen(ProvinceComInfo.getProvincename(rs.getString(5)),user.getLanguage())%></TD>
	
</TR>
<%
        if(hasNextPage){
			totalline+=1;
			if(totalline>perpage)	break;
		}
    }while(rs.previous());
    }
%>
</TABLE></FORM>
<%if(pagenum>1){%>

		<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",CityBrowser.jsp?pagenum="+(pagenum-1)+"&countryid="+countryid+"&provinceid="+provinceid+"&cityname="+cityname+"&sqlwhere="+sqlwhere1+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%> <%}%>
	   <%if(hasNextPage){%>
		<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",CityBrowser.jsp?pagenum="+(pagenum+1)+"&countryid="+countryid+"&provinceid="+provinceid+"&cityname="+cityname+"&sqlwhere="+sqlwhere1+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%> <%}%>
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
<script type="text/javascript">
//***********默认设置定义.*********************
var tPopWait=50;//停留tWait豪秒后显示提示。
var tPopShow=5000;//显示tShow豪秒后关闭提示
var showPopStep=20;
var popOpacity=99;
//***************内部变量定义*****************
var sPop=null;
var curShow=null;
var tFadeOut=null;
var tFadeIn=null;
var tFadeWaiting=null;
document.write("<style   type='text/css'id='defaultPopStyle'>");
document.write(".cPopText   { background-color: #F8F8F5;color:#000000; border:1px #000000 solid;font-color: font-size:12px;   padding-right:   4px;   padding-left:   4px;   height:   20px;   padding-top:   2px;   padding-bottom:   2px;   filter:   Alpha(Opacity=0)}");
document.write("</style>");
document.write("<div   id='dypopLayer' style='position:absolute;z-index:1000;' class='cPopText'></div>");
document.close();
function showPopupText(event){
	event=$.event.fix(event)
	var o=event.target;

	MouseX=event.pageX;
	MouseY=event.pageY;
	if(o.alt!=null && o.alt!=""){
		o.dypop=o.alt;
		o.alt="";
	}
	if(o.title!=null && o.title!=""){
		o.dypop=o.title;
		o.title="";
	}
	if(o.dypop!=sPop){
		sPop=o.dypop;
		clearTimeout(curShow);
		clearTimeout(tFadeOut);
		clearTimeout(tFadeIn);
		clearTimeout(tFadeWaiting);
		if(sPop==null || sPop==""){
			dypopLayer.innerHTML="";
			//dypopLayer.style.filter="Alpha()";
			//dypopLayer.filters.Alpha.opacity=0;
		}else{
			if(o.dyclass!=null){
				popStyle=o.dyclass;
			}else{
				popStyle="cPopText";
			}
			curShow=setTimeout("showIt()",tPopWait);
		}
	}
}

function showIt(){
	dypopLayer.className=popStyle;
	dypopLayer.innerHTML=sPop;
	popWidth=dypopLayer.clientWidth;
	popHeight=dypopLayer.clientHeight;
	if(MouseX+12+popWidth>document.body.clientWidth){
		popLeftAdjust=-popWidth-24;
	}else{
		popLeftAdjust=0;
	}
	if(MouseY+12+popHeight>document.body.clientHeight){
		popTopAdjust=-popHeight-24;
	}else{
		popTopAdjust=0;
	}
	dypopLayer.style.left=MouseX+12+document.body.scrollLeft+popLeftAdjust;
	dypopLayer.style.top=MouseY+12+document.body.scrollTop+popTopAdjust;
	//dypopLayer.style.filter="Alpha(Opacity=0)";
	fadeOut();
}

function fadeOut(){
	tFadeOut=setTimeout("fadeOut()",1);
}

function fadeIn(){
	tFadeIn=setTimeout("fadeIn()",1);
}
jQuery("mouseover",showPopupText);
function changeTitle(id, title){
	var s = document.getElementById(id);
	//alert(title);
	var isStr = s.options[s.selectedIndex].innerText;
//	for(var i=0;i<s.options.length;i++){
//		if(title == s.options[i].value){
//			isStr = s.options[i].innerText;
//		}
//	}
	s.title = isStr;
	//alert(s.title);
}

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
			
		window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
			window.parent.close()
		})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})

})


function submitClear()
{
	window.parent.returnValue = {id:"0",name:""};
	window.parent.close()
}

</script>
</BODY>
</HTML>