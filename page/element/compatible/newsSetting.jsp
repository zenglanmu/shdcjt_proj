<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="weaver.conn.RecordSet"  %>
<%@ page import="weaver.general.GCONST"  %>
<%@ page import="weaver.docs.news.DocNewsComInfo" %>
<%@ page import="weaver.docs.docs.DocComInfo"%>
<%@ page import="weaver.docs.category.*" %>
<%@page import="java.net.*"%>
<%@ page import="weaver.file.Prop"  %>
<jsp:include page="/systeminfo/init.jsp"></jsp:include>
<link href='/css/Weaver.css' type=text/css rel=stylesheet>
<script type='text/javascript' src='/js/weaver.js'></script>
<style>
body   {   
  overflow-y   :   auto   ;   
  overflow-x   :   hidden   ;   
    
  }
</style>
<%
 String userLanguageId = Util.null2String(request.getParameter("userLanguageId"));
 String eid = Util.null2String(request.getParameter("eid"));
 String tabId = Util.null2String(request.getParameter("tabId"));
 String tabTitle = Util.null2String(request.getParameter("tabTitle"));	
 tabTitle = URLDecoder.decode(tabTitle, "utf-8");
 String value = Util.null2String(request.getParameter("value"));
 String topDocIds = "";
 String topDocNames = "";
 RecordSet rs = new RecordSet();
 rs.execute("select tabtitle from hpnewstabinfo where eid="+eid+" and tabid="+tabId);
 if(rs.next()){
	 tabTitle = rs.getString("tabtitle");
 }
 if(value.indexOf("^topdoc^")!=-1){
		//out.println(strsqlwhere);	
		value = Util.StringReplace(value, "^topdoc^","#");
		String[] temp = Util.TokenizerString2(value, "#");
		//out.println(temp.length);	
		value = Util.null2String(temp[0]);
		if(temp.length==2){
			topDocIds = Util.null2String(temp[1]);	
		}
		if(!topDocIds.equals("")){
			DocComInfo dci=new DocComInfo();	 			
			topDocNames=dci.getMuliDocName2(topDocIds);
		}
	}
 String divString ="";
 String setValue1="";
	String setValue2=""; 
	String setValue3="";
	String setValue4="";

 //if("^,^1".equals(value)||"^,^2".equals(value)||"^,^3".equals(value))  return divString;
	if(value.length()<5) {
		setValue1="0";
		setValue2="1"; 
		setValue3="None";
		setValue4="0";
		
	} else {
		if("^,^".equals(value.substring(0,3)))  {
			divString="1|0|0"+divString;
			//return divString;
		}

	   
		if(!"".equals(value)){
			try {
				value = Util.StringReplace(value, "^,^","&");
			} catch (Exception e) {					
				e.printStackTrace();
			}
			ArrayList newsSetList=Util.TokenizerString(value,"&");
			setValue1=(String)newsSetList.get(0);
			if(newsSetList.size()>1){
				setValue2=(String)newsSetList.get(1);
			}
			if(newsSetList.size()>=4) {
				setValue3=(String)newsSetList.get(2);
				setValue4=(String)newsSetList.get(3);
			}

			if(newsSetList.size()==3) {
				setValue1 = "";
				setValue2 = (String)newsSetList.get(0);
				setValue3 = (String)newsSetList.get(1);
				setValue4 = (String)newsSetList.get(2);
			}
		}
	}
	try {
		DocNewsComInfo dnc=new DocNewsComInfo();
		divString="<table class=viewForm style=''>";
		divString+="<colgroup>";
		divString+="<col width='20%'/>";
		divString+="<col width='80%'/>";
		divString+="</colgroup>";
		divString+="<TR style='height:1px;'><TD CLASS=LINE COLSPAN=2></TD></TR>";
		divString+="<TR><TD>";
		tabTitle = Util.toHtml2(tabTitle.replaceAll("&","&amp;"));
		divString+="<TR valign=middle><TD>&nbsp;"+SystemEnv.getHtmlLabelName(229,Util.getIntValue(userLanguageId))+"</TD><TD class=field><input  class=inputStyle id='tabTitle_"+eid+"' type='text' value=\""+tabTitle+"\"  onchange='checkinput(\"tabTitle_"+eid+"\",\"tabTitleSpan_"+eid+"\")' /><SPAN id='tabTitleSpan_"+eid+"'>";
		
		if(tabTitle.equals("")){
			divString+="<IMG src=\"/images/BacoError.gif\" align=absMiddle>";
		}
		divString+="</SPAN></TD></TR>";
		divString+="<TR style='height:1px;'><TD CLASS=LINE COLSPAN=2></TD></TR>";
		divString+="<TR valign=middle><TD>&nbsp;"+SystemEnv.getHtmlLabelName(23784,Util.getIntValue(userLanguageId))+"</TD><TD class=field> <input type=hidden  name=rdi_"+eid+" id=topdocids_"+eid+"  value='"+topDocIds+"' >"+
		"		<BUTTON class=Browser onclick=onShowMDocs(topdocids_"+eid+",spantopdocids_"+eid+","+eid+")></BUTTON>" +     
		 "       <SPAN ID=spantopdocids_"+eid+">"+topDocNames+"</SPAN></TD></TR>" + 
		 "<TR style='height:1px;'><TD CLASS=LINE COLSPAN=2></TD></TR>"+
			"<TD>&nbsp;" +SystemEnv.getHtmlLabelName(20532,Util.getIntValue(userLanguageId))+"</TD>" +
			"<!--文档来源-->" +
			"<TD  class=''>" ;
		
		//文档来源设置部分的修改开始
		String srcType="";
		
		String strSrcType1="";
		String strSrcType2=""; 
		String strSrcType3="";
		String strSrcType4="";
		String strSrcType5="";
		String strSrcType6="";
		
		String srcContent="";
		String strSrcContent1="0";
		String strSrcContent2="0";
		String strSrcContent3="0";
		String strSrcContent4="0"; 
		String strSrcContent5="0"; 
		String strSrcContent6="0"; 
		
		String strSrcContentName1="";
		String strSrcContentName2="";
		String strSrcContentName3="";
		String strSrcContentName4="";
		String strSrcContentName5="";
		String strSrcContentName6="";
		
		String srcReply="0";
		String srcReply1="";
		String srcReply2="";
		String srcReply3="";
		String srcReply4=""; 
		String srcReply5=""; 
		String srcReply6=""; 
		
		
		ArrayList docSrcList=Util.TokenizerString(setValue1, "|");
		if (docSrcList.size()>0) srcType=(String)docSrcList.get(0);
		if (docSrcList.size()>1) srcContent=(String)docSrcList.get(1);
		if (docSrcList.size()>2) srcReply=(String)docSrcList.get(2);
		String initValue="";
		if("1".equals(srcType)) {
			strSrcType1=" checked ";
			strSrcContent1=srcContent;
			if("1".equals(srcReply)) srcReply1=" checked ";
			if(!"".equals(srcContent)){
				strSrcContentName1="<a href='/docs/news/NewsDsp.jsp?id="+srcContent+"' target='_blank'>"+dnc.getDocNewsname(srcContent)+"</a>";
			}
			initValue="1|"+srcContent+"|"+srcReply; 
		} 
		else if("2".equals(srcType)) {
			
			if("1".equals(srcReply)) srcReply2=" checked ";
			strSrcType2=" checked "; 
			strSrcContent2=srcContent;
			SecCategoryComInfo scc=new SecCategoryComInfo();
			ArrayList secidList=Util.TokenizerString(srcContent, ",");
			for(int i=0;i<secidList.size();i++){
				String secid=(String)secidList.get(i);
				String secname=scc.getSecCategoryname(secid);		
				strSrcContentName2+="<a href='/docs/search/DocSummaryList.jsp?showtype=0&displayUsage=0&seccategory="+secid+"'>"+secname+"</a>&nbsp;";
			}
			
			//strSrcContentName2=scc.getPath(srcContent);
			initValue="2|"+srcContent+"|"+srcReply;
		}
		else if("3".equals(srcType)) {
			if("1".equals(srcReply)) srcReply3=" checked ";
			strSrcType3=" checked ";
			strSrcContent3=srcContent;
			DocTreeDocFieldComInfo dtfci=new DocTreeDocFieldComInfo();
			strSrcContentName3=dtfci.getMultiTreeDocFieldNameOther(srcContent);
			initValue="3|"+srcContent+"|"+srcReply; 
		}
		else if("4".equals(srcType)) {
			if("1".equals(srcReply)) srcReply4=" checked ";
			strSrcType4=" checked ";
			strSrcContent4=srcContent;
			DocComInfo dci=new DocComInfo();	 			
			strSrcContentName4=dci.getMuliDocName2(srcContent);
			initValue="4|"+srcContent+"|"+srcReply; 
		}
		/*else if("5".equals(srcType)) {
			if("1".equals(srcReply)) srcReply5=" checked ";
			strSrcType5=" checked ";
			strSrcContent5=srcContent+"|"+srcReply; 
						
			strSrcContentName5="";
			initValue="5|"+srcContent;
		}else if("6".equals(srcType)) {
			if("1".equals(srcReply)) srcReply6=" checked ";
			strSrcType6=" checked "; 
			strSrcContent6=srcContent; 
						
			strSrcContentName6="";
			initValue="6|"+srcContent+"|"+srcReply; 
		}*/
		
		divString+="<input type=hidden id=_whereKey_"+eid+" name=_whereKey_"+eid+" value='"+initValue+"'>" +
		  "<TABLE class=viewform bgcolor=#efefef>  " +
			"<TD>" +
			"	<input type=radio "+strSrcType1+" onclick=onNewContentCheck(this,"+eid+",'news')  name=rdi_"+eid+" id=news_"+eid+"  value='"+strSrcContent1+"' selecttype=1 >" +
			"	"+SystemEnv.getHtmlLabelName(16356,Util.getIntValue(userLanguageId))+"<!--新闻中心-->&nbsp;&nbsp;" +
				 
			"	<BUTTON type='button' class=Browser  onclick=onShowNew(news_"+eid+",spannews_"+eid+","+eid+")></BUTTON>" +
		     "   <SPAN id=spannews_"+eid+">"+strSrcContentName1+"</SPAN>" +
		"	</TD>" +
		 " </TR>" +

		  "<TR>" +
			"<TD>" +
			"	<input type=radio  "+strSrcType2+" onclick=onNewContentCheck(this,"+eid+",'cate')  name=rdi_"+eid+" id=cate_"+eid+" value='"+strSrcContent2+"' selecttype=2 >" +
			"	"+SystemEnv.getHtmlLabelName(16398,Util.getIntValue(userLanguageId))+"<!--文档目录-->&nbsp;&nbsp;" +				
			"	<BUTTON type='button' class=Browser  onclick=onShowMultiCatalog(cate_"+eid+",spancate_"+eid+","+eid+")></BUTTON>" +
		     "   <SPAN id=spancate_"+eid+">"+strSrcContentName2+"</SPAN>" +
		     "&nbsp;&nbsp;<input id=chkcate_"+eid+" type=checkbox value=1 "+srcReply2+" onclick=\"chkReplyClick(this,'"+eid+"','cate')\">"+SystemEnv.getHtmlLabelName(20568,Util.getIntValue(userLanguageId))+
			"</TD>" +
		  "</TR>" + 

		  "<TR>" +
			"<TD>" +	
			"	<input type=radio  "+strSrcType3+" onclick=onNewContentCheck(this,"+eid+",'dummy')  name=rdi_"+eid+" id=dummy_"+eid+"  value='"+strSrcContent3+"' selecttype=3 >" +
			"	"+SystemEnv.getHtmlLabelName(20482,Util.getIntValue(userLanguageId))+"<!--虚拟目录-->&nbsp;&nbsp;" +

			"	<BUTTON type='button' class=Browser onClick=onShowMutiDummy(dummy_"+eid+",spandummy_"+eid+","+eid+")></BUTTON>" +
		     "   <span id=spandummy_"+eid+" name=spandummy_"+eid+">"+strSrcContentName3+"</span>	" +
		     "&nbsp;&nbsp;<input id=chkdummy_"+eid+" type=checkbox value=1 "+srcReply3+"  onclick=\"chkReplyClick(this,'"+eid+"','dummy')\">"+SystemEnv.getHtmlLabelName(20568,Util.getIntValue(userLanguageId))+
			"</TD>" +
		  "</TR>" +

		"  <TR>" +
		"	<TD>" +
		"		<input type=radio "+strSrcType4+"  onclick=onNewContentCheck(this,"+eid+",'docids')  name=rdi_"+eid+" id=docids_"+eid+"  value='"+strSrcContent4+"' selecttype=4>" +
		"		"+SystemEnv.getHtmlLabelName(20533,Util.getIntValue(userLanguageId))+"<!--指定文档-->&nbsp;&nbsp;" +

		"		<BUTTON type='button' class=Browser onclick=onShowMDocs(docids_"+eid+",spandocids_"+eid+","+eid+")></BUTTON>" +     
		 "       <SPAN ID=spandocids_"+eid+">"+strSrcContentName4+"</SPAN>" +
		"	</TD>" +
		 " </TR>" +
//		 "  <TR>" +
//			"	<TD>" +
//			"		<input type=radio "+strSrcType5+"  onclick=onNewContentCheck(this,"+eid+")  name=rdi_"+eid+" id=stids_"+eid+"  value='"+strSrcContent5+"' selecttype=5>" +
//			"		"+SystemEnv.getHtmlLabelName(20549,Util.getIntValue(userLanguageId))+"<!--搜索模板-->&nbsp;&nbsp;" +
//			"		<BUTTON class=Browser onclick=onShowSearchTemplet(stids_"+eid+",spanstids_"+eid+","+eid+")></BUTTON>" +     
//			 "       <SPAN ID=spanstids_"+eid+">"+strSrcContentName5+"</SPAN>" +				
//			"	</TD>" +
//			 " </TR>" +
//		 "  <TR>" +
//			"	<TD>" +
//			"		<input type=radio "+strSrcType6+"  onclick=onNewContentCheck(this,"+eid+")  name=rdi_"+eid+" id=sc_"+eid+"  value='"+strSrcContent6+"' selecttype=6>" +
//			"		"+SystemEnv.getHtmlLabelName(20550,Util.getIntValue(userLanguageId))+"<!--搜索条件-->&nbsp;&nbsp;" +
//			"		<BUTTON class=Browser onclick=onShowSearchCondition(sc_"+eid+",spansc_"+eid+","+eid+")></BUTTON>" +     
//			 "       <SPAN ID=spansc_"+eid+">"+strSrcContentName6+"</SPAN>" +			
//			"	</TD>" +
//			 " </TR>" +
		  "</TABLE>";
		
		//文档来源设置部分的修改结束				
			
//			"	<select name=\"_whereKey_"+eid+"\">" ;
//		while(dnc.next())	{
//			String selectedStr="";
//			String docNewsid=dnc.getDocNewsid();
//			if(docNewsid.equals(setValue1)) selectedStr=" selected ";
//			divString+="<option value="+dnc.getDocNewsid()+" "+selectedStr+" >"+dnc.getDocNewsname()+"</option>" ;
//		}
//		
//		divString+=	"   </select>";
		
		
		
		String showMode1="";
		String showMode2="";
		String showMode3="";
     String showMode4="";
     String showMode5 ="";

     if("1".equals(setValue2)) showMode1=" selected ";
		if("2".equals(setValue2)) showMode2=" selected ";
		if("3".equals(setValue2)) showMode3=" selected ";
     if("4".equals(setValue2)) showMode4=" selected ";
     if("5".equals(setValue2))showMode5 = "selected";

     divString+=	"</TD>" +            
			"<TR style='height:1px;'><TD CLASS=LINE COLSPAN=2></TD></TR>"+
			"<TD>&nbsp;" +SystemEnv.getHtmlLabelName(89,Util.getIntValue(userLanguageId))+SystemEnv.getHtmlLabelName(599,Util.getIntValue(userLanguageId))+"</TD>" +
			"<!--显示方式-->" +
			"<TD  class=field><select name=\"_whereKey_"+eid+"\">" +
					"<option value=1 "+showMode1+">"+SystemEnv.getHtmlLabelName(19525,Util.getIntValue(userLanguageId))+"</option>" +
                 "<option value=4 "+showMode4+">"+SystemEnv.getHtmlLabelName(19525,Util.getIntValue(userLanguageId))+"2</option>" +
                 "<option value=2 "+showMode2+">"+SystemEnv.getHtmlLabelName(19526,Util.getIntValue(userLanguageId))+"</option>" +
					"<option value=3 "+showMode3+">"+SystemEnv.getHtmlLabelName(19527,Util.getIntValue(userLanguageId))+"</option>" +
					"<option value=5 "+showMode5+">"+SystemEnv.getHtmlLabelName(23804,Util.getIntValue(userLanguageId))+"</option>" +
					"</select>" ;
		divString+="</TD></TR>";

		
		
		
		String showDirection0="";
		String showDirection1="";
		String showDirection2="";
		String showDirection3="";
     String showDirection4="";

     if("None".equals(setValue3)) showDirection0=" selected ";
		if("Left".equals(setValue3)) showDirection1=" selected ";
		if("Right".equals(setValue3)) showDirection2=" selected ";
     if("Up".equals(setValue3)) showDirection3=" selected ";
		if("Down".equals(setValue3)) showDirection4=" selected ";

		divString+="<TR style='height:1px;'><TD CLASS=LINE COLSPAN=2></TD></TR>";
		divString+="	<TR valign='top'><TD>&nbsp;"+SystemEnv.getHtmlLabelName(20281,Util.getIntValue(userLanguageId))+"</TD>" +
			"<!--滚动方向-->" +
			"<TD  class=field>" +
			"<select  name=\"_whereKey_"+eid+"\">"+
			"	<option value=\"None\" "+showDirection0+">"+SystemEnv.getHtmlLabelName(557,Util.getIntValue(userLanguageId))+"</option>"+
			"	<option value=\"Left\" "+showDirection1+">"+SystemEnv.getHtmlLabelName(20282,Util.getIntValue(userLanguageId))+"</option>"+
			"	<option value=\"Right\" "+showDirection2+">"+SystemEnv.getHtmlLabelName(20283,Util.getIntValue(userLanguageId))+"</option>"+
			"	<option value=\"Up\" "+showDirection3+">"+SystemEnv.getHtmlLabelName(20284,Util.getIntValue(userLanguageId))+"</option>"+
			"	<option value=\"Down\" "+showDirection4+">"+SystemEnv.getHtmlLabelName(20285,Util.getIntValue(userLanguageId))+"</option>"+
		    "</select> "+
			"</TD>	" +
			"</TR>";
		String showOpenFirsetAss0="";
		String showOpenFirsetAss1="";
		if("0".equals(setValue4)) showOpenFirsetAss0=" selected ";
		if("1".equals(setValue4)) showOpenFirsetAss1=" selected ";
		divString+="<TR style='height:1px;'><TD CLASS=LINE COLSPAN=2></TD></TR>";
		divString+="	<TR valign='top'><TD>&nbsp;"+SystemEnv.getHtmlLabelName(20895,Util.getIntValue(userLanguageId))+"</TD>" +
			"<!--直接打开附件-->" +
			"<TD  class=field>" +
			"<select  name=\"_whereKey_"+eid+"\">"+
			"	<!--不是--><option value=\"0\" "+showOpenFirsetAss0+">"+SystemEnv.getHtmlLabelName(19843,Util.getIntValue(userLanguageId))+"</option>"+
			"	<!--是--><option value=\"1\" "+showOpenFirsetAss1+">"+SystemEnv.getHtmlLabelName(163,Util.getIntValue(userLanguageId))+"</option>"+
		    "</select>&nbsp("+SystemEnv.getHtmlLabelName(20896,Util.getIntValue(userLanguageId))+") "+
			"</TD>	" +
			"</TR>";
		    divString+="<TR style='height:1px;'><TD CLASS=LINE COLSPAN=2></TD></TR>";
		divString+="</table>";
out.print(divString);
} catch (Exception e) {			
e.printStackTrace();
}

%>

<script type="text/javascript">
<!--

//-->
function getNewsSettingString(eid){
	var whereKeyStr="";
	var _whereKeyObjs=document.getElementsByName("_whereKey_"+eid);
	//得到上传的SQLWhere语句
	for(var k=0;k<_whereKeyObjs.length;k++){
		var _whereKeyObj=_whereKeyObjs[k];	
		if(_whereKeyObj.nodeName=="INPUT" && _whereKeyObj.type=="checkbox" &&! _whereKeyObj.checked) continue;			
		whereKeyStr+=_whereKeyObj.value+"^,^";			
	}
	if(whereKeyStr!="") whereKeyStr=whereKeyStr.substring(0,whereKeyStr.length-3);	
	var topDocIds = document.getElementById("topdocids_"+eid).value;
	return whereKeyStr+"^topdoc^"+topDocIds;
}


function chkReplyClick(obj,eid,name){

		onNewContentCheck(document.getElementById(name+"_"+eid),eid,name);
	}


	function onNewContentCheck(obj,eid,name){	
		obj.checked=true;			
		var isHaveReply="0";
		try{
			if(document.getElementById("chk"+name+"_"+eid).checked) isHaveReply="1";
		} catch(e){
		}
		document.getElementById("_whereKey_"+eid).value=$(obj).attr("selecttype")+"|"+obj.value+"|"+isHaveReply;		
		
	}

	function onShowCatalog(input,span,eid) {
		var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
		var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
		if (result != null) {
		    if (result[0] > 0)  {
				input.value=result[1];
				span.innerHTML=result[5];
			}else{
				input.value="0";
				span.innerHTML="";
			}
		}
		onNewContentCheck(input,eid,'cate');
	}


</script>
<script type="text/javascript">
<!--

function onShowNew(input,span,eid){
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/news/NewsBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if (datas){
		if(datas.id!=""){
			$(span).html("<a href='/docs/news/NewsDsp.jsp?id="+datas.id+"' target='_blank'>"+datas.name+"</a>");
			$(input).val(datas.id);
		}
		else {
			$(span).html("");
			$(input).val("");
		}
		onNewContentCheck(input,eid,"news");
	}
}

function onShowMDocs(input,span,eid){
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="+input.value,"",
		"dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
		if (datas){
			if (datas.id!=""){
				ids = datas.id.split(",");
				names =datas.name.split(",");
				sHtml = "";
				for( var i=0;i<ids.length;i++){
					if(ids[i]!=""){
						sHtml = sHtml+"<a href=/docs/docs/DocDsp.jsp?id="+ids[i]+">"+names[i]+"</a>&nbsp";
					}
				}
				$(span).html(sHtml);
				$(input).val(datas.id);
				
			}else {
				$(span).html("");
				$(input).val("");
			}
			
			if (input.type=="radio") {
				 onNewContentCheck(input,eid,"");
			}
		}
}

function onShowMultiCatalog(input,span,eid){
	splitflag = ",,,";
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MutilCategoryBrowser.jsp?para="+input.value+"&splitflag="+splitflag,"",
			"dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if (datas) {
		if (datas.id!= "") {
			ids = datas.id.split(",");
			names =datas.name.split(",");
			sHtml = "";
			for( var i=0;i<ids.length;i++){
				if(ids[i]!=""){
					sHtml = sHtml+"<a href='/docs/search/DocSearchView.jsp?showtype=0&displayUsage=0&fromadvancedmenu=0&infoId=0&showDocs=0&showTitle=1&maincategory=&subcategory=&seccategory="+ids[i]+"'>"+names[i]+"</a>&nbsp";
				}
			}
			$(span).html(sHtml);
			$(input).val(datas.id);
		}
		else {
			$(span).html("");
			$(input).val("");
		}
	}
	onNewContentCheck(input,eid,"cate");
} 
function onShowMutiDummy(input,span,eid){	
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+input.value,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	
	if (datas) {
		if (datas.id!= ""){
			dummyidArray=datas.id.split(",");
			dummynames=datas.name.split(",");
			dummyLen=dummyidArray.length;
			sHtml="";
			for(var k=0;k<dummyLen;k++){
				sHtml = sHtml+"<a href='/docs/docdummy/DocDummyList.jsp?dummyId="+dummyidArray[k]+"'>"+dummynames[k]+"</a>&nbsp;";
			}
			input.value=datas.id;
			span.innerHTML=sHtml;
		}
		else{			
			input.value="";
			span.innerHTML="";
		}
		onNewContentCheck(input,eid,"");
	}
}
//-->
</script>

<span id="encodeHTML" style="display:none"></span> 