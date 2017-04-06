<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("DocMouldEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
%>
<html><head>
<link href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext.js"></script>

</head>
<jsp:useBean id="MouldManager" class="weaver.docs.mouldfile.MouldManager" scope="page" />
<%
int id = Util.getIntValue(request.getParameter("id"),0);
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int subcompanyid1= -1;
    if(detachable==1){
    	subcompanyid1=Util.getIntValue(request.getParameter("subcompanyid1"),-1);
        if(subcompanyid1 == -1){
            subcompanyid1 = user.getUserSubCompany1();
        }
    }
String urlfrom = request.getParameter("urlfrom");

MouldManager.setId(id);
MouldManager.getMouldInfoById();
MouldManager.getMouldSubInfoById();
String mouldname=MouldManager.getMouldName();
String mouldtext=MouldManager.getMouldText();
int mouldType= MouldManager.getMouldType();
int subcompanyid = MouldManager.getSubcompanyid1();
MouldManager.closeStatement();

if(mouldType >1 ){
    response.sendRedirect("DocMouldEditExt.jsp?id="+id+"&urlfrom="+urlfrom+"&subcompanyid1="+subcompanyid1+"");//Modify by 杨国生 2004-10-25 For TD1271
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = "";
if(urlfrom.equals("hr")){
  titlename = SystemEnv.getHtmlLabelName(614,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(64,user.getLanguage());
}else{
  titlename = SystemEnv.getHtmlLabelName(16449,user.getLanguage())+"："+mouldname;
}
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(222,user.getLanguage())+",javascript:switchEditMode(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
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
		<table class=Shadow>
		<tr>
		<td valign="top">

<form id=weaver name=weaver action="UploadDoc.jsp" method=post enctype="multipart/form-data">
<input type=hidden name=urlfrom value="<%=urlfrom%>">
<br>
<table class=ViewForm>
<tbody>
<tr class=Spacing><td aligh=left colspan=2>
<b>
<%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%>
</b>
</td></tr>
<tr class=Spacing style="height: 1px"><td class=Line1 colspan=2></td></tr>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></td>
<td width=85% class=field>
<%=id%>
</td>
</tr>
<tr style="height: 1px">
	<td class=Line colSpan=2></td>
</tr>

<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></td>
<td width=85% class=field>
<input class=InputStyle size=70 name=mouldname  value="<%=mouldname%>" onChange="checkinput('mouldname','mouldnamespan')">
<span id=mouldnamespan>
<%if(mouldname==null||mouldname.trim().equals("")){%><IMG src='/images/BacoError.gif' align=absMiddle><%}%>
</span>

</td>
</tr>

<%if(urlfrom.equals("hr")){%>
<tr>
<%if(detachable==1){%>
    <tr>
        <td ><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></td>
        <td colspan=5 class=field >
                <BUTTON class=Browser type="button" id=SelectSubCompany onclick="onShowSubcompany()"></BUTTON>
            <SPAN id=subcompanyid1span> <%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subcompanyid))%>
            </SPAN>
		    <INPUT class=inputstyle id=subcompanyid1 type=hidden name=subcompanyid1 value="<%=subcompanyid%>">
			
        </td>
    </tr>
    <tr class="Spacing" style="height: 1px"><td colspan=6 class="Line" style="padding: 0"></td></tr>
<%}%>
</span>

</td>
</tr>
<%}%>

<tr style="height: 1px">
	<td class=Line colSpan=2></td>
</tr>

</tbody>
</table>
<div id=imgfield>
</div>
<table class=ViewForm>
<tbody>

</td></tr>
<tr style="height: 1px">
	<td class=Line1 colSpan=2></td>
</tr>
<%
int oldpicnum = 0;
int pos = mouldtext.indexOf("/weaver/weaver.file.FileDownload");

while(pos!=-1){    
     try {
       
            pos = mouldtext.indexOf("?fileid=",pos);
            if(pos == -1) {
                pos = mouldtext.indexOf("/weaver/weaver.file.FileDownload",pos+1);
                continue ;
            }
            int endpos = mouldtext.indexOf("\"",pos);
            String tmpid = mouldtext.substring(pos+8,endpos);
            int startpos = mouldtext.lastIndexOf("\"",pos);
            String servername = request.getServerName();
			if(request.getServerPort()!=80)servername+=":"+request.getServerPort();
            String tmpcontent = mouldtext.substring(0,startpos+1);          

            tmpcontent += mouldtext.substring(startpos+1);
            mouldtext=tmpcontent;
        %>
        <input type=hidden name=olddocimages<%=oldpicnum%> value="<%=tmpid%>">
        <%
            pos = mouldtext.indexOf("/weaver/weaver.file.FileDownload",endpos);
            oldpicnum += 1;    
    }catch(Exception ex){        
        System.out.println(ex);   
        pos = mouldtext.indexOf("/weaver/weaver.file.FileDownload",pos+1);
        continue ;
    }
}

%>
<input type=hidden name=olddocimagesnum value="<%=oldpicnum%>">

<tr><td colspan=2>
<textarea name=mouldtext id="mouldtext" style="display:none;width:100%;height:500px"><%=Util.encodeAnd(mouldtext)%></textarea>

</td>
</tr>
</TBODY>
</table>
<input type=hidden name=operation>
<input type=hidden name=id value="<%=id%>">
</form>

		</td>
		</tr>
		</table>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

<script>
function switchEditMode(ename){
	
	var oEditor = CKEDITOR.instances.mouldtext;
	oEditor.execCommand("source");
}
function onSave(){
	if(check_form(document.weaver,'mouldname,subcompanyid1')){

		var editor_data = CKEDITOR.instances.mouldtext.getData();
		jQuery("#mouldname").val(editor_data);
		
		
		document.weaver.operation.value='edit';
		document.weaver.submit();
	}
}

function onHtml(){
	if(document.weaver.mouldtext.style.display==''){
	
		text = document.weaver.mouldtext.innerText;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML=text;
		document.weaver.mouldtext.style.display='none';
		divifrm.style.display='';
	}
	else{
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.weaver.mouldtext.innerText=text;
		document.weaver.mouldtext.style.display='';
		divifrm.style.display='none';
	}
}
function onShowSubcompany(){
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
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=DocMouldEdit:Edit&selectedids="+weaver.subcompanyid1.value,"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	issame = false
	if (data){
		if (data.id!=""){
			if (data.id == weaver.subcompanyid1.value){
				issame = true
			}
			subcompanyid1span.innerHtml = data.name
			weaver.subcompanyid1.value=data.id
		}else{
			subcompanyid1span.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			weaver.subcompanyid1.value=""
		}
	}
}
</script>
<script language="javascript" type="text/javascript">
	jQuery(document).ready(function(){
		var lang=<%=(user.getLanguage()==8)?"true":"false"%>;
		//FCKEditorExt.initEditor('weaver','mouldtext',lang);
		CkeditorExt.initEditor('weaver','mouldtext',lang,'',500)
	})
</script>
</body>