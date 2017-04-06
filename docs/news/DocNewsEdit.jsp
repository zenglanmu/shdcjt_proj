<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>

<%

%>
<jsp:useBean id="DocNewsManager" class="weaver.docs.news.DocNewsManager" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="PicUploadComInfo" class="weaver.docs.tools.PicUploadComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<script type='text/javascript' src='/dwr/interface/DocDwrUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
</head>
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(68,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(70,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY onbeforeunload="checkLeave()">
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>

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
int id = Util.getIntValue(request.getParameter("id"),0);
DocNewsManager.setId(id);
DocNewsManager.getDocNewsInfoById();

//如果新闻设置表其他人在修改，直接跳转到查看页面，否则将将新闻设置表状态改为签出状态
if(DocNewsManager.getCheckOutStatus()==1 && DocNewsManager.getCheckOutUserId()!=user.getUID()){
	String checkOutUserName="";
	checkOutUserName=ResourceComInfo.getResourcename(""+DocNewsManager.getCheckOutUserId());
	String checkOutMessage=SystemEnv.getHtmlLabelName(19695,user.getLanguage())+SystemEnv.getHtmlLabelName(19690,user.getLanguage())+"："+checkOutUserName;
	checkOutMessage=URLEncoder.encode(checkOutMessage);
	response.sendRedirect("NewsDsp.jsp?id="+id+"&checkOutMessage="+checkOutMessage);
    return ;
}else{
	RecordSet.executeSql("update DocFrontpage set checkOutStatus=1,checkOutUserId="+user.getUID()+" where id="+id);
}

String frontpagename = DocNewsManager.getFrontpagename();
String frontpagedesc = DocNewsManager.getFrontpagedesc();
String isactive = DocNewsManager.getIsactive();
int departmentid = DocNewsManager.getDepartmentid();
String linktype = DocNewsManager.getLinktype();
String hasdocsubject = DocNewsManager.getHasdocsubject();
String hasfrontpagelist = DocNewsManager.getHasfrontpagelist();
int newsperpage = DocNewsManager.getNewsperpage();
int titlesperpage = DocNewsManager.getTitlesperpage();
int defnewspicid = DocNewsManager.getDefnewspicid();
int backgroundpicid = DocNewsManager.getBackgroundpicid();
String importdocid = DocNewsManager.getImportdocid();
int headerdocid = DocNewsManager.getHeaderdocid();
int footerdocid = DocNewsManager.getFooterdocid();
String secopt = DocNewsManager.getSecopt();
int seclevelopt = DocNewsManager.getSeclevelopt();
int departmentopt = DocNewsManager.getDepartmentopt();
int dateopt = DocNewsManager.getDateopt();
int languageopt = DocNewsManager.getLanguageopt();
String clauseopt = Util.toScreenToEdit(DocNewsManager.getClauseopt(),user.getLanguage());
String newsclause = DocNewsManager.getNewsclause();
int languageid =DocNewsManager.getLanguageid();
int publishtype =DocNewsManager.getPublishtype();


int newstypeid =DocNewsManager.getNewstypeid();
int typeordernum =DocNewsManager.getTypeordernum();
DocNewsManager.closeStatement();

    //判断此新闻是否被外部网站所引用
    boolean isRefByWeb = false;
    RecordSet.executeSql("select count(*) from website where newsid ="+id);
    if(RecordSet.next()){
        if(RecordSet.getInt(1)>0){
            isRefByWeb = true;
        }
    }
%>
<FORM id=weaver name=weaver action="NewsOperation.jsp" method=post>
<div>
<%
if(HrmUserVarify.checkUserRight("DocFrontpageEdit:Edit", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(HrmUserVarify.checkUserRight("DocFrontpageAdd:add", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='DocNewsAdd.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/news/DocNews.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(HrmUserVarify.checkUserRight("DocFrontpageEdit:Delete", user)&&!isRefByWeb){    //如果被外部网站引用也不能被删除
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(HrmUserVarify.checkUserRight("DocFrontpage:log", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?secid=65&sqlwhere=where operateitem=6 and relatedid="+id+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}
%>
</div>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<TABLE class=ViewForm>
    <COLGROUP>
    <COL width="15%"> <COL width="35%">
     <COL width=15> <COL width="35%">
     <TBODY>
    <TR class=Title>
      <TH colSpan=4><%=SystemEnv.getHtmlLabelName(316,user.getLanguage())%></TH>
    </TR>
    <TR class=Spacing style="height: 1px!important;">
      <TD class=Line1 colSpan=4></TD>
    </TR>
    <TR>
      <td><%=SystemEnv.getHtmlLabelName(1996,user.getLanguage())%></td>
      <td class=field>
        <input type=radio name="languageid" value="7" <%if(languageid==7){%> checked <%}%>><%=SystemEnv.getHtmlLabelName(1997,user.getLanguage())%>
        <input type=radio name="languageid" value="8" <%if(languageid==8){%> checked <%}%>><%=SystemEnv.getHtmlLabelName(1998,user.getLanguage())%>
        <input type=radio name="languageid" value="9" <%if(languageid==9){%> checked <%}%>><%=SystemEnv.getHtmlLabelName(23261,user.getLanguage())%>
      </td>
      <TD ><%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%></TD>
      <TD class=Field>
      <%
      String ischecked = "";
      if(isactive.equals("1"))
      	ischecked = " checked";
      %>
        <INPUT class=InputStyle name=isactive value=1 type=checkbox <%=ischecked%>></TD>
    </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=4></TD></TR>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(70,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
      <TD class=Field>
	    <INPUT type=input class=InputStyle name=frontpagename value="<%=frontpagename%>" onChange="checkinput('frontpagename','frontpagespan')">
       <span id=frontpagespan><%if(frontpagename.equals("")){%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></span></TD>


           <TD><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%>
      </TD>
      <TD class=Field>
     <!--  <BUTTON class=Browser onClick="showDocPic()"></BUTTON>
      <SPAN class=InputStyle id=defnewspicname></SPAN>
       -->
        <INPUT  class="wuiBrowser" type=hidden name=defnewspicid value="<%=defnewspicid%>" _displayTemplate="<a href='/docs/tools/DocPicUploadEdit.jsp?id=#b{id}'>#b{name}</a>"  _url="/systeminfo/BrowserMain.jsp?url=/docs/tools/DocPicBrowser.jsp?pictype=1" _displayText="<a href='/docs/tools/DocPicUploadEdit.jsp?id=<%=defnewspicid%>'><%=PicUploadComInfo.getPicname(""+defnewspicid)%></a>">
      </TD>
    </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=4></TD></TR>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>
      </TD>
      <TD class=Field>
        <input class=InputStyle name=frontpagedesc value="<%=frontpagedesc%>">
      </TD>
      <TD><%=SystemEnv.getHtmlLabelName(334,user.getLanguage())%></TD>
      <TD class=Field>
      <!-- 
	      <BUTTON class=Browser onClick="showDocBkPic()"></BUTTON>
	      <SPAN class=InputStyle id=backgroundpicname><a href='/docs/tools/DocPicUploadEdit.jsp?id=<%=backgroundpicid%>'><%=PicUploadComInfo.getPicname(""+backgroundpicid)%></a></SPAN>
	   -->
        <INPUT class=wuiBrowser _displayTemplate="<a href='/docs/tools/DocPicUploadEdit.jsp?id=#b{id}'>#b{name}</a>" _url="/systeminfo/BrowserMain.jsp?url=/docs/tools/DocPicBrowser.jsp?pictype=3" _displayText="<a href='/docs/tools/DocPicUploadEdit.jsp?id=<%=backgroundpicid%>'><%=PicUploadComInfo.getPicname(""+backgroundpicid)%></a>" type=hidden name=backgroundpicid value="<%=backgroundpicid%>">
      </TD>
    </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=4></TD></TR>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>
      </TD>
      <TD class=Field>
      <%
      ischecked = "";
      if(hasdocsubject.equals("1"))
      	ischecked = " checked";
      %>
        <INPUT class=InputStyle name=hasdocsubject value=1 type=checkbox <%=ischecked%>></TD>

      <TD><%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(70,user.getLanguage())%></TD>
      <TD class=Field>
      <%
      ischecked = "";
      if(hasfrontpagelist.equals("1"))
      	ischecked = " checked";
      %>
      <INPUT class=InputStyle name=hasfrontpagelist value=1 type=checkbox <%=ischecked%>></TD>
    </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=4></TD></TR>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(264,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(265,user.getLanguage())%></TD>
      <TD class=Field>
        <INPUT class=InputStyle maxLength=2 size=13 name=newsperpage value="<%=newsperpage%>">
      </TD>

      <TD><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(265,user.getLanguage())%></TD>
      <TD class=Field>
        <INPUT class=InputStyle maxLength=2 size=13 name=titlesperpage value="<%=titlesperpage%>">
      </TD>
    </TR>

    <TR style="height: 1px!important;"><TD class=Line colSpan=4></TD></TR>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(19789,user.getLanguage())%></TD>
      <TD class=Field>
         <select class=InputStyle  name=newstypeid style="width:35%">
			<%
				rs.executeSql("select id,typename from newstype order by dspnum");
				while(rs.next()){
					String  strSelected="";
					if(newstypeid==rs.getInt("id")) strSelected="selected";
			%>
				<option value="<%=rs.getString("id")%>" <%=strSelected%>><%=Util.forHtml(Util.null2String(rs.getString("typename")))%></option>
			<%}%>
		 </select>
      </TD>

      <TD><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>
      <TD class=Field>
        <INPUT class=InputStyle maxLength=3 size=3 name=typeordernum value="<%=typeordernum%>">
      </TD>
    </TR>



<TR style="height: 1px!important;"><TD class=Line colSpan=4></TD></TR>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(1993,user.getLanguage())%></td>
      <td class=field>
        <select class=InputStyle  name=publishtype size=1>
        	<option value="1" <%if(publishtype==1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1994,user.getLanguage())%></option>
        	<option value="0" <%if(publishtype==0){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%></option>
<%if(isgoveproj==0){%>
<%if(isPortalOK){%><!--portal begin-->
       <%while(CustomerTypeComInfo.next()){
       		String curid=CustomerTypeComInfo.getCustomerTypeid();
       		String curname=CustomerTypeComInfo.getCustomerTypename();
       		String value="-"+curid;
       %>
       		<option value="<%=value%>" <%if(publishtype==Util.getIntValue(value,0)){%> selected <%}%>><%=Util.toScreen(curname,user.getLanguage())%></option>
       <%
       }%>
<%}%><!--portal end-->
<%}%>
        </select>
      </td>

    </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=4></TD></TR>

    <TR class=Title>
      <TH colSpan=4><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TH>
    </TR>
<TR style="height: 1px!important;"><TD class=Line1 colSpan=4></TD></TR>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(224,user.getLanguage())%></TD>
      <TD class=Field colspan=3>
      <!-- 
      <BUTTON class=Browser onClick="showHeaderDoc()"></BUTTON>
      <SPAN ID=headerdocidname><a href='/docs/docs/DocDsp.jsp?id=<%=headerdocid%>'><%=DocComInfo.getDocname(""+headerdocid)%></a></SPAN>
        -->
        
        <INPUT class=wuiBrowser _url="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?initwhere=doctype<>2" _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>"  _displayText="<a href='/docs/docs/DocDsp.jsp?id=<%=headerdocid%>'><%=DocComInfo.getDocname(""+headerdocid)%></a>" type=hidden name=headerdocid value="<%=headerdocid%>">
      </TD>
    </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=4></TD></TR>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(322,user.getLanguage())%></TD>
      <TD class=Field colspan=3>
       <%
	       String importdocidtext="";
	       String[] tempdocids = Util.TokenizerString2(importdocid,",");
	       for(int i=0;i<tempdocids.length;i++) {
	    	   importdocidtext +="<a href='/docs/docs/DocDsp.jsp?id="+tempdocids[i]+"'>"+DocComInfo.getDocname(tempdocids[i])+"</a>&nbsp;";     
	      }%>
	      
        <INPUT class=wuiBrowser _displayText="<%=importdocidtext %>" _url="/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids=<%=importdocid%>" 
        _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>"  type=hidden name=importdocid value="<%=importdocid%>">
        
        
        <!--
        <button class=Browser type="button" onClick="onShowMDocs('importdocidname','importdocid')"></button>  
        <INPUT  type=hidden name=importdocid value="<%=importdocid%>">
        -->
      </TD>
    </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=4></TD></TR>
     <TR>
      <TD><%=SystemEnv.getHtmlLabelName(323,user.getLanguage())%></TD>
      <TD class=Field colspan=3>
      <!--
       <BUTTON class=Browser onClick="showFooterDoc()"></BUTTON>
      <SPAN ID=footerdocidname></SPAN>
        <INPUT class=InputStyle type=hidden name=footerdocid value="<%=footerdocid%>">
        -->
     
      <INPUT class=wuiBrowser _url="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?initwhere=doctype<>2" _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>"  _displayText="<a href='/docs/docs/DocDsp.jsp?id=<%=footerdocid%>'><%=DocComInfo.getDocname(""+footerdocid)%></a>" type=hidden name=footerdocid value="<%=footerdocid%>">   
      
      </TD>
    </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=4></TD></TR>
    </TBODY>
  </TABLE>
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="15%">
  <COL width="33%">
  <COL width=24>
  <COL width="15%">
  <COL width="33%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=5><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH></TR>
<TR style="height: 1px!important;"><TD class=Line1 colSpan=5></TD></TR></TBODY></TABLE>
<TABLE class=ViewForm>
  <COLGROUP>
 <COL width="15%"> <COL width="35%">
 <COL width=15> <COL width="35%">
  <TBODY>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD class=Field>
    
   <!--  <BUTTON class=Browser onClick="onShowDept('continuedepartname','continuedepart')"></BUTTON> -->
      
      <INPUT class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp" _displayText="<%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentopt+""),user.getLanguage())%>" type=hidden name=continuedepart value="<%=departmentopt%>">
     </TD>    
    <%if(isMultilanguageOK){   //  多语言版本， 在 init.jsp 中获得判断 %>
    <TD><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></TD>
   <!-- 
   	  <TD class=Field><BUTTON class=Browser onClick="onShowLanguage()"></BUTTON>
      <SPAN  id=continuelanguagename><%=LanguageComInfo.getLanguagename(""+languageopt)%></SPAN>
    -->
    
      <td class=Field>
      <INPUT class="wuiBrowser" _url="/systeminfo/language/LanguageBrowser.jsp" _displayText="<%=LanguageComInfo.getLanguagename(""+languageopt)%>" type=hidden name=continuelanguagenameid value="<%=languageopt%>">
      </TD>
    <% } else { %>
      <TD></TD>
    <TD></TD>
    <%}%>
      </TR>
<TR style="height: 1px!important;"><TD class=Line colSpan=5></TD></TR>
  <TR>
      <TD><%=SystemEnv.getHtmlLabelName(328,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
    <TD class=Field>
        <input class=InputStyle maxlength=2 size=10 name=continuetime value="<%=dateopt%>">
        <%=SystemEnv.getHtmlLabelName(329,user.getLanguage())%></TD>   
      <TD></TD>
    <TD></TD>
   </TR>
    <TR style="height: 1px!important;"><TD class=Line colSpan=5></TD></TR>
  <TR>
    <TD valign=top><%=SystemEnv.getHtmlLabelName(15610,user.getLanguage())%></TD>
    <TD class=Field colspan=3>
        <TEXTAREA name=condition class=InputStyle rows=3 style="width:100%"><%=clauseopt%></TEXTAREA>
    </TD>       
   </TR>
   <TR style="height: 1px!important;"><TD class=Line colSpan=5></TD></TR>
   <TR>
    <TD></TD>
    <TD class=Field colspan=3>
        <%=SystemEnv.getHtmlLabelName(18541,user.getLanguage())%>:maincategory=29 and subcategory=23
    </TD>       
   </TR>  
       <TR style="height: 1px!important;"><TD class=Line colSpan=5></TD></TR>
   </TBODY></TABLE>
  

</SPAN>

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

<input type=hidden name=operation>
<input type=hidden name=id value="<%=id%>">
<input type=hidden name=frontpagename value="<%=frontpagename%>">
</FORM>
<script>
jQuery(document).ready(function(){
	jQuery(".wuiBrowser").modalDialog();
})

var isCheckLeave = true;
function onSave(){
	DocDwrUtil.ifNewsCheckOutByCurrentUser(<%=id%>,<%=user.getUID()%>,
		{callback:function(result){
			if(result){

	var languageid=<%=user.getLanguage()%>;
	if(check_form(document.weaver,'frontpagename')){
    if(document.all("newsperpage").value != "" && document.all("newsperpage").value*1<=0){
	    	alert("<%=SystemEnv.getHtmlLabelName(23259,user.getLanguage())%>");
        return;
    }else if(document.all("titlesperpage").value != "" && document.all("titlesperpage").value*1<=0){
	    	alert("<%=SystemEnv.getHtmlLabelName(23260,user.getLanguage())%>");
        return;
    }
	document.weaver.operation.value="edit";
	document.weaver.submit();}
	
			}else{
				alert("<%=SystemEnv.getHtmlLabelName(26097,user.getLanguage())%>");
				return;
			}
		}
		}
	)
}

function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		document.weaver.operation.value="delete";
		document.weaver.submit();
	}
}

function onCheckIn(id){
		isCheckLeave = false;
		DocDwrUtil.checkInNewsDsp(id,
			{callback:function(result){
				if(result){
					window.location.href="/docs/news/NewsDsp.jsp?id="+id;
				}
			}
			}
		)
}

function checkLeave(){
	if(isCheckLeave){
		DocDwrUtil.checkInNewsDsp(<%=id%>,
			{callback:function(result){
			}
			}
		)
	}
}
</script>
</BODY></HTML>
