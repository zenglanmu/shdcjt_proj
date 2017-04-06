<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page"/>
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="dm" class="weaver.docs.docs.DocManager" scope="page" />


<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>


<%
String from = Util.null2String(request.getParameter("from"));
Enumeration em = request.getParameterNames();
boolean isinit = true;
while(em.hasMoreElements())
{
	String paramName = (String)em.nextElement();
	if(!paramName.equals("")&&!paramName.equals("splitflag"))
		isinit = false;
	break;
}
int date2during= Util.getIntValue(request.getParameter("date2during"),0) ;
int olddate2during = 0;
BaseBean baseBean = new BaseBean();
String date2durings = "";
try
{
	date2durings = Util.null2String(baseBean.getPropValue("docdateduring", "date2during"));
}
catch(Exception e)
{}
String[] date2duringTokens = Util.TokenizerString2(date2durings,",");
if(date2duringTokens.length>0)
{
	olddate2during = Util.getIntValue(date2duringTokens[0],0);
}
if(olddate2during<0||olddate2during>36)
{
	olddate2during = 0;
}
if(isinit)
{
	date2during = olddate2during;
}
String islink = Util.null2String(request.getParameter("islink"));
String searchid = Util.null2String(request.getParameter("searchid"));
//String searchmainid = Util.null2String(request.getParameter("searchmainid"));
String searchsubject = Util.null2String(request.getParameter("searchsubject"));
String searchcreater = Util.null2String(request.getParameter("searchcreater"));
String searchdatefrom = Util.null2String(request.getParameter("searchdatefrom"));
String searchdateto = Util.null2String(request.getParameter("searchdateto"));
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String initwhere = Util.null2String(request.getParameter("initwhere"));
String crmId = Util.null2String(request.getParameter("txtCrmId"));

String sqlwhere = "" ;

String secCategory = Util.null2String(request.getParameter("secCategory"));
String path= Util.null2String(request.getParameter("path"));
if (!secCategory.equals("")) path = "/"+CategoryUtil.getCategoryPath(Util.getIntValue(secCategory));


    if(!initwhere.equals("")) {
        if(!sqlwhere1.equals("")) {
            sqlwhere = sqlwhere1 + " and "+initwhere+" and (docstatus !='3' and ((doccreaterid !="+user.getUID()+" and docstatus !='0') or doccreaterid ="+user.getUID()+")) ";
        }
        else {
            sqlwhere = " where "+initwhere+" and  (docstatus !='3' and ((doccreaterid !="+user.getUID()+" and docstatus !='0') or doccreaterid ="+user.getUID()+")) ";
        }
    }else{
        if(!sqlwhere1.equals("")) {
            sqlwhere = sqlwhere1 + " and (docstatus !='3' and ((doccreaterid !="+user.getUID()+" and docstatus !='0') or doccreaterid ="+user.getUID()+")) ";
        }
        else {
            sqlwhere = " where (docstatus !='3' and ((doccreaterid !="+user.getUID()+" and docstatus !='0') or doccreaterid ="+user.getUID()+")) ";
        }
    }
    //System.out.println("sqlwhere = " + sqlwhere);

if(!islink.equals("1")) {
    DocSearchComInfo.resetSearchInfo() ;

    if(!searchid.equals("")) DocSearchComInfo.setDocid(searchid) ; 
    //if(!searchmainid.equals("")) DocSearchComInfo.setMaincategory(searchmainid) ;
    if(!secCategory.equals("")) DocSearchComInfo.setSeccategory(secCategory) ;
    if(!searchsubject.equals("")) DocSearchComInfo.setDocsubject(searchsubject) ;
    if(!searchcreater.equals("")) {
        DocSearchComInfo.setOwnerid(searchcreater) ;
        DocSearchComInfo.setUsertype("1");
    }
    if(!crmId.equals("")) {
        DocSearchComInfo.setDoccreaterid(crmId) ;   
         DocSearchComInfo.setUsertype("2");    
    }
    
    if(!searchdatefrom.equals("")) DocSearchComInfo.setDoclastmoddateFrom(searchdatefrom) ;
    if(!searchdateto.equals(""))  DocSearchComInfo.setDoclastmoddateTo(searchdateto) ;

    DocSearchComInfo.setOrderby("4") ;
}

String docstatus[] = new String[]{"1","2","5","7"};
for(int i = 0;i<docstatus.length;i++){
   	DocSearchComInfo.addDocstatus(docstatus[i]);
}

String tempsqlwhere = DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
String orderclause = DocSearchComInfo.FormatSQLOrder() ;
String orderclause2 = DocSearchComInfo.FormatSQLOrder2() ;

if(!tempsqlwhere.equals("")) sqlwhere += " and " + tempsqlwhere ;

/* added by wdl 2007-03-16 不显示历史版本 */
sqlwhere+=" and (ishistory is null or ishistory = 0) ";
/* added end */
sqlwhere += dm.getDateDuringSql(date2during);

//System.out.println("tempsqlwhere = " + tempsqlwhere);
int perpage = 10 ;
int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;

%>


<BODY scroll="auto">
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


<FORM NAME=SearchForm STYLE="margin-bottom:0" action="DocBrowser.jsp" method=post>
<input type=hidden name=sqlwhere value="<%=sqlwhere1%>">
<input type=hidden name=initwhere value="<%=initwhere%>">
<input type="hidden" name="from" value="<%=from %>">
<DIV align=right style="display:none">
<%
BaseBean baseBeanRigthMenu1 = new BaseBean();
int userightmenu1 = 1;
try{
	userightmenu1 = Util.getIntValue(baseBeanRigthMenu1.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
if(userightmenu1 == 0){
	RCMenuHeight += RCMenuHeightStep ; //取消右键按钮 看不到按钮，只能查看3个！
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
//td19320

RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<BUTTON type="button" class=btnReset accessKey=T id=reset onclick="reset_onclick()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:document.SearchForm.btnclose.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=1 id="btnclose" onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=2 id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>

<table width=100% class=ViewForm>
<TR class=Spacing><TD class=Line1 colspan=4></TD></TR>
<TR>
<TD width=15%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD>
<TD width=35% class=field><input class=InputStyle id=searchid name=searchid value="<%=searchid%>" onKeyPress="ItemNum_KeyPress()" onBlur='checkcount1(this)'></TD>
<TD width=15%><%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%></TD>
<TD width=35% class=field>
    
    <INPUT type=hidden class="wuiBrowser" id="secCategory" name="secCategory" value="<%=secCategory%>" _url="/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp"
    	_displayTemplate="#b{path}" _displayText="<%=path %>"/>
</TD>
</TR><tr style="height:1px;"><td class=Line colspan=4></td></tr>
<TR>
	<TD width=15%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
	<TD width=35% class=field><input class=InputStyle  name=searchsubject value="<%=searchsubject%>"></TD>	
	<TD width=15%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TD>
	<TD width=35% class=field>
	    <button type="button" class=Calendar id=selectdate1 onClick="getDate(searchdatefromspan,searchdatefrom)"></button>
	              <span id=searchdatefromspan ><%=searchdatefrom%></span> -
	    <button type="button" class=Calendar id=selectdate2 onClick="getDate(searchdatetospan,searchdateto)"></button>
	              <span id=searchdatetospan ><%=searchdateto%></span>
	
	    <input type=hidden id =searchdatefrom name=searchdatefrom maxlength=10 size=10 value="<%=searchdatefrom%>">
	    <input type=hidden id =searchdateto name=searchdateto maxlength=10 size=10 value="<%=searchdateto%>">
	</td>
</TR>
<tr style="height:1px;"><td class=Line colspan=4></td></tr>
<%if(!user.getLogintype().equals("2")){%>
	<TR>
		<TD width=15%><%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%></TD>
	    <TD width=35% class=field>
	       
	        <input type=hidden id="searchcreater" class="wuiBrowser" name="searchcreater" value="<%=searchcreater%>" _displayText="<%=Util.toScreen(ResourceComInfo.getResourcename(searchcreater),user.getLanguage())%>"
	        	_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" />
	    </TD>
        <TD width=15%><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></TD>
         <TD width=35% class=field>
           
            <input type=hidden id=txtCrmId name=txtCrmId class="wuiBrowser" value="<%=crmId%>" _displayText="<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmId),user.getLanguage())%>"
           		_url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" />
        </TD>
	</TR>
    <tr style="height:1px;"><td class=Line colspan=4></td></tr>
<%}%>
<%if(date2duringTokens.length>0){ %>
<tr>
 <td class="lable"><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></td>
 <td class="field">
  <select class=inputstyle  size=1 id=date2during name=date2during style=width:80%>
  	<option value="">&nbsp;</option>
  	<%
  	for(int i=0;i<date2duringTokens.length;i++)
  	{
  		int tempdate2during = Util.getIntValue(date2duringTokens[i],0);
  		if(tempdate2during>36||tempdate2during<1)
  		{
  			continue;
  		}
  	%>
  	<!-- 最近个月 -->
  	<option value="<%=tempdate2during %>" <%if (date2during==tempdate2during) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(24515,user.getLanguage())%><%=tempdate2during %><%=SystemEnv.getHtmlLabelName(26301,user.getLanguage())%></option>
  	<%
  	} 
  	%>
  	<!-- 全部 -->
  	<option value="38" <%if (date2during==38) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
  </select>
 </td>
 <TD  colspan="2"></TD>
</tr>
<tr style="height:1px;"><td class=Line colspan=4></td></tr>
<%} %>
<TR class=Spacing><TD class=Line1 colspan=4></TD></TR>
</table>
<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 width="100%">
<TR class=DataHeader>
<TH width=0% style="display:none"></TH>
<TH width=50%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TH>
<TH width=18%><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></TH>
<TH width=14%><%=SystemEnv.getHtmlLabelName(2094,user.getLanguage())%></TH>
<TH width=18%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TH>
</tr><TR class=Line><TH colSpan=5></TH></TR>
<%


if("hpelement".equals(from)){
	sqlwhere = sqlwhere+ " and doctype=1";
}

//out.println(sqlwhere);    

int i=0;
DocSearchManage.setPagenum(pagenum) ;
DocSearchManage.setPerpage(perpage) ;
DocSearchManage.getSelectResult(sqlwhere,orderclause,orderclause2,user) ;

while(DocSearchManage.next()) {
		String docid = ""+DocSearchManage.getID();
		String mainid = ""+DocSearchManage.getMainCategory();
		String subject = DocSearchManage.getDocSubject();
		String createrid = ""+DocSearchManage.getOwnerId();
		String modifydate = DocSearchManage.getDocLastModDate();
		String usertype=Util.null2String(DocSearchManage.getUsertype());

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
		<TD width=0% style="display:none"><A HREF=#><%=docid%></A></TD>
		<TD><%=subject%></TD>
		<TD ><%=MainCategoryComInfo.getMainCategoryname(mainid)%></TD>
		<TD><%if(usertype.equals("1")){%>
				<%=Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage())%>
				<%}else{%>
				<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(createrid),user.getLanguage())%>
				<%}%>
		</TD>
		<TD><%=modifydate%></TD>
	</TR>
	<%}%>
</TABLE>
<br>
<table width=100% class=Data>
<tr>
<td align=center><%=Util.makeNavbarInternational(user.getLanguage(),pagenum, DocSearchManage.getRecordersize() , perpage, "DocBrowser.jsp?from="+from+"&islink="+islink+"&searchid="+searchid+"&secCategory="+secCategory+"&searchsubject="+searchsubject+"&searchcreater="+searchcreater+"&searchdatefrom="+searchdatefrom+"&searchdateto="+searchdateto+"&sqlwhere="+sqlwhere1+"&initwhere="+initwhere+"&txtCrmId="+crmId)%></td>
</tr>
</table>
<br>
</FORM>

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
</BODY></HTML>

<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>

<script language="javascript" >

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
   var e=e||event;
   var target=e.srcElement||e.target;

   if( target.nodeName =="TD"||target.nodeName =="A"  ){
     window.parent.parent.returnValue = {id:jQuery(jQuery(target).parents("tr")[0].cells[0]).text(),name:replaceToHtml(jQuery(jQuery(target).parents("tr")[0].cells[1]).text())};
	 window.parent.parent.close();
	}
}

jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
function reset_onclick(e){
	document.SearchForm.searchid.value=""
	document.SearchForm.searchsubject.value=""
	document.SearchForm.searchdatefrom.value=""
	document.SearchForm.searchdateto.value=""
	document.SearchForm.searchcreater.value=""
	document.SearchForm.txtCrmId.value=""
	document.SearchForm.secCategory.value=""
	$("#secCategorySpan").empty();
	$("#searchdatefromspan").empty();
	$("#searchdatetospan").empty();
	$("#searchcreaterSpan").empty();
	$("#txtCrmIdSpan").empty();
}

function btnclear_onclick(){
     window.parent.returnValue = {id:"",name:""};
     window.parent.close();
}
</script>
<script type="text/javascript">
function replaceToHtml(str){
	var re = str;
	var re1 = "<";
	var re2 = ">";
	do{
		re = re.replace(re1,"&lt;");
		re = re.replace(re2,"&gt;");
        re = re.replace(",","，");
	}while(re.indexOf("<")!=-1 || re.indexOf(">")!=-1)
	return re;
}



</script>