<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DocShare" class="weaver.docs.DocShare" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="SpopForDoc" class="weaver.splitepage.operate.SpopForDoc" scope="page"/>

 
<%
    int docid = Util.getIntValue(request.getParameter("docid"),0); 

	//文档名称链接放在页面顶部  开始  fanggsh 20060424
    String  docsubject = DocComInfo.getDocname(""+docid);
	//文档名称链接放在页面顶部  结束

//3:共享
//user info
int userid=user.getUID();
String logintype = user.getLogintype();
String userSeclevel = user.getSeclevel();
String userType = ""+user.getType();
String userdepartment = ""+user.getUserDepartment();
String usersubcomany = ""+user.getUserSubCompany1();

boolean canEdit = false;
boolean canShare = false ;
String userInfo=logintype+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
ArrayList PdocList = SpopForDoc.getDocOpratePopedom(""+docid,userInfo);
if (((String)PdocList.get(1)).equals("true")) canEdit = true ;
if (((String)PdocList.get(3)).equals("true")) canShare = true ;
if(canEdit){
    canShare = true;
}
%>
<HTML>
<HEAD>
    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
    <BODY>
    <%
    String imagefilename = "/images/hdReport.gif";

	//文档名称链接放在页面顶部  开始  fanggsh 20060424
    //String titlename = SystemEnv.getHtmlLabelName(18644,user.getLanguage());
    //String titlename = SystemEnv.getHtmlLabelName(18644,user.getLanguage())+": <a href='DocDsp.jsp?id="+docid+"'>"+ docsubject + "</a>";
    String titlename = SystemEnv.getHtmlLabelName(18644,user.getLanguage())+": "+ docsubject ;
	//文档名称链接放在页面顶部  结束

    String needfav ="1";
    String needhelp ="";
    %> 
    <%@ include file="/systeminfo/RightClickMenuConent.jsp" %> 
    <%
        RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSubmit(this),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;       
    %>
    <%@ include file="/systeminfo/RightClickMenu.jsp" %>
        
		

    </BODY>
</HTML>
<%@ include file="/docs/docs/DocCommExt.jsp"%>
<%
BaseBean baseBean_self = new BaseBean();
int userightmenu_self = 1;
String marginStr="";
try{
	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
if(userightmenu_self==1){
	marginStr = "0 8 5 5";
}else{
	marginStr = "30 8 5 5";
}
%>
<SCRIPT LANGUAGE="JavaScript">
var docid="<%=docid%>";

Ext.onReady(function(){
	var viewport = new Ext.Viewport({
        layout:'border',        
        items:[
            {
                region:'center',
                margins : '<%=marginStr%>',
				layout:'fit',
				border:false,
				items:new DocShareSnip(docid,<%=canShare%>).getGrid(),
				buttons:[
				         {text:'<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>',handler:function(){doSubmit(this)}},
				         {text:'<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>',handler:function(){window.parent.close()}}
				],
				buttonAlign:'center'				
            }
		]
	});
	//.render(Ext.getBody());
	
	Ext.get('loading').fadeOut();
});


function doSubmit(obj){
    obj.disabled = true ; 
    window.location="DocShareOperation.jsp?method=finish&docid=<%=docid%>&blnOsp=true";
}
function doModify(obj){ 
    obj.disabled = true ; 
    window.location="DocShare.jsp?docid=<%=docid%>&blnOsp=true";
}

</SCRIPT>

<script type="text/javascript" src="/js/doc/DocShareSnip.js"></script>


