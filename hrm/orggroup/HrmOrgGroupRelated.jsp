<%@ page language="java" contentType="text/html; charset=GBK" %> 

<jsp:useBean id="HrmOrgGroupComInfo" class="weaver.hrm.orggroup.HrmOrgGroupComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />


<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ include file="/systeminfo/init.jsp" %>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%

    boolean canEdit=false;
    if(HrmUserVarify.checkUserRight("GroupsSet:Maintenance", user)){
		canEdit=true;
	}

int orgGroupId = Util.getIntValue(request.getParameter("orgGroupId"));


String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(24662,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(24002,user.getLanguage()) + "&nbsp;&nbsp;-&nbsp;&nbsp;"+HrmOrgGroupComInfo.getOrgGroupName(""+orgGroupId);
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%

    RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javaScript:frmMain.submit(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;

if(canEdit){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",/hrm/orggroup/HrmOrgGroupRelatedAdd.jsp?orgGroupId="+orgGroupId+",_self} " ;
    RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javaScript:oDelete(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%

    int type = Util.getIntValue(request.getParameter("type"),-1);
    String content = Util.null2String(request.getParameter("content"));

    String sqlwhere =" where orgGroupId="+orgGroupId;

    String contentSpan="";
    
    if (type>0) {
  	    sqlwhere = sqlwhere + " and type = "+type;
    }
    if (!content.equals("")) {
  	    sqlwhere = sqlwhere + " and content in ("+content+")";
    }

	if(type==2&&!content.equals("")){//分部
	    int contentPartId=0;
	    ArrayList contentList=Util.TokenizerString(content,",");
		for(int i=0;i<contentList.size();i++){
			contentPartId=Util.getIntValue((String)contentList.get(i),0);
			contentSpan+="<a href='/hrm/company/HrmSubCompanyDsp.jsp?id="+contentPartId+"' target='_blank'>"+SubCompanyComInfo.getSubCompanyname(""+contentPartId)+"&nbsp</a>"+"&nbsp";
		}
	}else if(type==3&&!content.equals("")){//部门
	    int contentPartId=0;
	    ArrayList contentList=Util.TokenizerString(content,",");
		for(int i=0;i<contentList.size();i++){
			contentPartId=Util.getIntValue((String)contentList.get(i),0);
			contentSpan+="<a href='/hrm/company/HrmDepartmentDsp.jsp?id="+contentPartId+"' target='_blank'>"+DepartmentComInfo.getDepartmentname(""+contentPartId)+"&nbsp</a>"+"&nbsp";
		}
	}

	String tabletype="";
	if(canEdit){
		tabletype="checkbox";
	}else{
		tabletype="none";
	}


int perpage=Util.getIntValue(request.getParameter("perpage"),0);

if(perpage<=1 )	perpage=10;
String backfields = "id,type,content,secLevelFrom,secLevelTo";
String fromSql  = " from HrmOrgGroupRelated ";
String orderby = " type,id " ;
String tableString =" <table instanceid=\"HrmOrgGroup\" tabletype=\""+tabletype+"\" pagesize=\""+perpage+"\" >"+
                 "	   <sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+orderby+"\" sqlprimarykey=\"id\"   sqlsortway=\"asc\" />"+
                 "			<head>"+
                 "				<col width=\"40%\"   text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"type\" orderkey=\"type\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.hrm.orggroup.SptmForOrgGroup.getRelatedType\" />"+
                 "				<col width=\"40%\"   text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"content\" otherpara=\"column:type+"+user.getLanguage()+"\" transmethod=\"weaver.hrm.orggroup.SptmForOrgGroup.getRelatedName\" />"+
                 "				<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"secLevelFrom\" orderkey=\"secLevelFrom\" otherpara=\"column:secLevelTo\" transmethod=\"weaver.hrm.orggroup.SptmForOrgGroup.getRelatedSecLevel\" />"+               
                 "			</head>"+
                 " </table>";
  %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<!--add by dongping for fiveStar request-->

<form name="frmMain" method="post" action="">
<input class=inputstyle type="hidden" name=orgGroupId value="<%=orgGroupId%>">
<input type="hidden" name="operation">
<input type="hidden" name="checkedCheckboxIds">
	<table class="ViewForm">
	  <COLGROUP>
	  <COL width="15%">
	  <COL width="85%">

      <TR class=Title>
          <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%></TH>
      </TR>
      <TR class=Spacing style="height:2px">
          <TD class=Line1 colSpan=2></TD>
      </TR>

		<tr>
			<td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%><SELECT class=InputStyle  name=type onChange="onChangeType()" >
				    <option value="-1"></option>
				    <option value="2" <%if(type==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
                    <option value="3" <%if(type==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
  			    </SELECT>			
			</td>
			<td class="Field">

				<BUTTON class=Browser type="button" style="display:<%if(type==-1){%><%}else{%>none<%}%>" onClick="onShowPrompt()" name=defaultButton></BUTTON> 
				<BUTTON class=Browser type="button" style="display:<%if(type==2){%><%}else{%>none<%}%>" onClick="onShowSubcompany(content,contentSpan)" name=showsubcompany></BUTTON> 
				<BUTTON class=Browser type="button" style="display:<%if(type==3){%><%}else{%>none<%}%>" onClick="onShowDepartment(content,contentSpan)" name=showdepartment></BUTTON>
				<INPUT type=hidden name=content  id="content" value="<%=content%>">
				<span id=contentSpan name=contentSpan><%=contentSpan%></span>     				
			</td>	
		</tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>   
        <tr><td colSpan=2> <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" /></td></tr>
    </table>
</form>

</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
</table>

 
</BODY></HTML>


<script language=javascript>

function oDelete(){
	if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")) {
        var checkedCheckboxIds = _xtable_CheckedCheckboxId();
        if (checkedCheckboxIds==""){
            alert("<%=SystemEnv.getHtmlLabelName(24244,user.getLanguage())%>");
            return ;
        }
        document.frmMain.action="/hrm/orggroup/HrmOrgGroupRelatedOperation.jsp"
        document.frmMain.operation.value="Delete";        
        document.frmMain.checkedCheckboxIds.value=checkedCheckboxIds;
        document.frmMain.submit();
    }
}


function onChangeType(){
	var thisvalue = jQuery("select[name=type]").val();

	jQuery("#content").val("");
	jQuery("#contentSpan").html("");

	if(thisvalue==-1){
 		jQuery("button[name=defaultButton]").show();
	}else{
		jQuery("button[name=defaultButton]").hide();
	}

	if(thisvalue==2){
 		jQuery("button[name=showsubcompany]").show();
	}else{
		jQuery("button[name=showsubcompany]").hide();
	}

	if(thisvalue==3){
 		jQuery("button[name=showdepartment]").show();
	}else{
		jQuery("button[name=showdepartment]").hide();
	}

}

function onShowPrompt(){
	alert("<%=SystemEnv.getHtmlLabelName(21134,user.getLanguage())%>!");
}

var opts={
		_dwidth:'550px',
		_dheight:'550px',
		_url:'about:blank',
		_scroll:"no",
		_dialogArguments:"",
		
		value:""
	};
var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
opts.top=iTop;
opts.left=iLeft;

function onShowSubcompany(inputname,spanname){
    linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id=";
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
    
    if (data!=null) {
		if (data.id!= "") {	
			ids = data.id.split(",");
			names =data.name.split(",");
            sHtml = "";
			for( var i=0;i<ids.length;i++){
				if(ids[i]!=""){
                sHtml = sHtml+"<a href="+linkurl+ids[i]+" target='_blank'>"+names[i]+"</a>&nbsp;";
				}
			}
			jQuery(spanname).html(sHtml);
			jQuery("input[name="+inputname+"]").val(data.id);
		} else {
			jQuery(spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			jQuery("input[name="+inputname+"]").val("");
	    }
}
}

function onShowDepartment(inputname,spanname){
linkurl="/hrm/company/HrmDepartmentDsp.jsp?id=";
data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
if (data!=null){
    if (data.id!=""){
    	ids = data.id.split(",");
		names =data.name.split(",");
		sHtml = "";
		for( var i=0;i<ids.length;i++){
			if(ids[i]!=""){
		    sHtml = sHtml+"<a href="+linkurl+ids[i]+" target='_blank'>"+names[i]+"</a>&nbsp;";
			}
		}
		jQuery(spanname).html(sHtml);
		jQuery("input[name="+inputname+"]").val(data.id);
	} else {
		jQuery(spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
		jQuery("input[name="+inputname+"]").val("");
    }
    }
}
</script>
