<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ProjTempletUtil" class="weaver.proj.Templet.ProjTempletUtil" scope="page"/>
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page"/>
<HTML>
	<HEAD>
	    <LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
	    <SCRIPT language="javascript" src="/js/weaver.js"></SCRIPT>
	</HEAD>

<%
    boolean canEdit = false ;
    //判断是否具有项目编码的维护权限
    if (HrmUserVarify.checkUserRight("ProjCode:Maintenance",user)) {
        canEdit = true ;   
    }
    
    String imagefilename = "/images/sales.gif";
	String titlename = SystemEnv.getHtmlLabelName(18375,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(172,user.getLanguage())+" ("+SystemEnv.getHtmlLabelName(18504,user.getLanguage())+")";
	String needfav ="1";
	String needhelp ="";//取得相应设置的值
    

    ArrayList projectColList = new ArrayList();
    //ArrayList secondColList = new ArrayList();

    int firstColNum = 0;
    int totalProjectType = ProjectTypeComInfo.getProjectTypeNum();
    if (totalProjectType%2==0)   firstColNum = totalProjectType/2;
    else firstColNum = totalProjectType/2+1;

      
    int i=0;
    while(ProjectTypeComInfo.next()){
        String projectTypeId = ProjectTypeComInfo.getProjectTypeid();       
        //if (i>=firstColNum) {
            //firstColList.add(projectTypeId);
        //} else {
            //secondColList.add(projectTypeId);
        //}
        projectColList.add(projectTypeId);
        i++;
    }
    
    /* edited by wdl 2006-05-24 left menu new requirement ?fromadvancedmenu=1&infoId=-140 */
    int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
    int infoId = Util.getIntValue(request.getParameter("infoId"),0);
    String selectedContent = Util.null2String(request.getParameter("selectedContent"));
	
    String selectArr = "";
    
    if(selectedContent!=null && selectedContent.startsWith("key_")){
		String menuid = selectedContent.substring(4);
		RecordSet.executeSql("select * from menuResourceNode where contentindex = '"+menuid+"'");
		selectedContent = "";
		while(RecordSet.next()){
			String keyVal = RecordSet.getString(2);
			selectedContent += keyVal +"|";
		}
		if(selectedContent.indexOf("|")!=-1)
			selectedContent = selectedContent.substring(0,selectedContent.length()-1);
	}
    
	boolean navigateTo = false;
	int proTypeId = 0;
    if(fromAdvancedMenu==1){//目录选择来自高级菜单设置
    	LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
    	LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
    	if(info!=null){
    		selectArr = info.getSelectedContent();
    		List projectNum = Util.TokenizerString(selectArr,"|");
    		int tnum = 0;
    		for(Iterator it = projectNum.iterator();it.hasNext();){
    			if(((String)it.next()).startsWith("P")) tnum++;
    		}
    		if(tnum==1) navigateTo = true;
    	}
    }
    if(navigateTo){
        if(!selectArr.equals("")) proTypeId = Util.getIntValue(selectArr.substring(1));
    	response.sendRedirect("/proj/data/AddProject.jsp?projTypeId="+proTypeId);
    	return;
    }
    if(!"".equals(selectedContent))
    {
    	selectArr = selectedContent;
    }
    if(!selectArr.equals("")) selectArr+="|";
    /* end */
    
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%	
if(fromAdvancedMenu==1){
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(16346,user.getLanguage())+",javascript:onuserdefault(0),_self} " ;
	//RCMenuHeight += RCMenuHeightStep;
}
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<COLGROUP>
<COL width="10">
<COL width="">
<COL width="10">
<TR>
    <TD height="10" colspan="3"></TD>
</TR>
<TR>
    <TD></TD>
    <TD valign="top">
         <TABLE class=Shadow>
            <TR>
                <TD valign="top">
                    <TABLE width="100%">     
                    <colgroup>
                    <col width="45%">
                    <col width="10%">
                    <col width="45%">
                    
                    <TR>
	                    <TD valign="top">
	                        <TABLE  width="100%" valign="top">
		                    <%
		                    for (int j=0;j<projectColList.size();j++){
		                    	String projectId = (String)projectColList.get(j);
		                    	if(fromAdvancedMenu==1 && selectArr.indexOf("P"+projectId+"|") == -1) continue;
		                    %>
								<% if(j==projectColList.size()/2){ %>
	                                </TABLE>
	                            </TD>
	                            <TD></TD>
	                            <TD valign="top">
	                                <TABLE width="100%" valign="top">
		                        <% } %>
	                            <%
	                            out.println("<tr><td>"+ProjTempletUtil.getProjectTypeSelectStr(request,projectId)+"</td></tr>");
	                            %>
                            <% } %>

                            </TABLE>
                        </TD>
                    </TR>
                    </TABLE>
                </TD>
            </TR>            
         </TABLE>
    </TD>
    <TD></TD>
</TR>
<TR>
    <TD height="10" colspan="3"></TD>
</TR>
</TABLE>
<script>
function onuserdefault(flag){
	if(flag==0)
		location='/proj/Templet/ProjTempletSele.jsp';
	else
		location='/proj/Templet/ProjTempletSele.jsp?fromadvancedmenu=1&infoId=-152';
}
</script>
</BODY>
</HTML>