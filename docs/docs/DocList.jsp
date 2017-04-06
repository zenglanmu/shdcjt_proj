<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>

<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=GBK">
<META NAME="AUTHOR" CONTENT="InetSDK">
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<LINK href="/wui/skins/default/wui.css" type=text/css rel=STYLESHEET>
<LINK href="/wui/skins/default/style1.css" type=text/css rel=STYLESHEET>
<style>
.listbox1 ul{
	width: 100%;
}
</style>
</head>
<%
    String tmptopage="";
    int showall= Util.getIntValue(request.getParameter("showall"),0);  //0:表示 不显示全部 1:表示显示全部
    int isOpenNewWind =  Util.getIntValue(request.getParameter("isOpenNewWind"),1); //0:表示不重新弹出窗口 1:表示重新弹出窗口
    String isExpDiscussion = Util.null2String(request.getParameter("isExpDiscussion")); //表示是否来自讨论沟通
    String topage=Util.null2String(request.getParameter("topage")); //表示文档来源
	String workflowid=Util.null2String(request.getParameter("workflowid"));   //流程中来，带流程ID
    String topageURLEncoder = URLEncoder.encode(topage);
    String prjid = Util.null2String(request.getParameter("prjid"));
    String crmid=Util.null2String(request.getParameter("crmid"));
    String hrmid=Util.null2String(request.getParameter("hrmid"));
    String coworkid=Util.null2String(request.getParameter("coworkid"));
    String showsubmit=Util.null2String(request.getParameter("showsubmit"));
    
    if(!showsubmit.equals("0"))  
        showsubmit="1";
    
    int userid=user.getUID();
    String seclevel = ResourceComInfo.getSeclevel(""+user.getUID());
    int customertype=user.getType();
    //String Seclevel=user.getSeclevel();
    String logintype = user.getLogintype();
    String usertype="";
    
    if(logintype.equals("1"))
        usertype = "0";
    if (logintype.equals("2")) 
    {
        usertype = Integer.toString(user.getType());
		seclevel = user.getSeclevel();
    }
    
    char flag=2;
    String selectsubid = Util.null2String(request.getParameter("selectsubid"));
    int messageid = Util.getIntValue(request.getParameter("messageid"),0);
    String isuserdefault=Util.null2String(request.getParameter("isuserdefault"));  //自定义为1(无自定义目录显示全部)或2（无自定义显示空），全部目录为0

    
    /* edited by wdl 2006-05-24 left menu new requirement ?fromadvancedmenu=1&infoId=-140 */
    int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
    int infoId = Util.getIntValue(request.getParameter("infoId"),0);
    
    String selectedContent = Util.null2String(request.getParameter("selectedContent"));
    
    String selectArr = "";
    String useUnselected ="";
    String commonuse = "";
    
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
    if(fromAdvancedMenu==1){//目录选择来自高级菜单设置
    	LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
    	LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
    	if(info!=null){
    		selectArr = info.getSelectedContent();
    	}
    } else {
	    UserDefaultManager.setUserid(user.getUID());
	    UserDefaultManager.selectUserDefault();
	    selectArr=UserDefaultManager.getSelectedcategoryString();
	    useUnselected = UserDefaultManager.getUseunselected();
	    commonuse = UserDefaultManager.getCommonuse();
    }    
    if(!"".equals(selectedContent))
    {
    	selectArr = selectedContent;
    }
    /* edited end */
    
    
    if(!selectArr.equals(""))   
        selectArr+="|";           
        
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(58,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
    
    /*保存toPage的来源*/
    session.setAttribute("doc_topage",URLDecoder.decode(topage));

    
	
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
	/* edited by wdl 2006-05-24 left menu new requirement ?fromadvancedmenu=1&infoId=-140 */
	if(fromAdvancedMenu==0){
		if ((isuserdefault.equals("1") && !"".equals(selectArr)) || "2".equals(isuserdefault))
	    {
	        RCMenu += "{"+SystemEnv.getHtmlLabelName(18464,user.getLanguage())+",javascript:onuserdefault(0),_top} " ;
	        RCMenuHeight += RCMenuHeightStep;
	    } 
	    else 
	    {
	        RCMenu += "{"+SystemEnv.getHtmlLabelName(18465,user.getLanguage())+",javascript:onuserdefault(1),_top} " ;
	        RCMenuHeight += RCMenuHeightStep;    
	    }
    } else {//如果来自高级菜单
        //RCMenu += "{"+SystemEnv.getHtmlLabelName(18464,user.getLanguage())+",javascript:onuserdefault(0),_top} " ;
        //RCMenuHeight += RCMenuHeightStep;
    	
        //RCMenu += "{"+SystemEnv.getHtmlLabelName(18465,user.getLanguage())+",javascript:onuserdefault(1),_top} " ;
        //RCMenuHeight += RCMenuHeightStep;    
    }
	/* edited by wdl end */

	if(usertype.equals("0")){
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(73,user.getLanguage())+",javascript:location.href='/docs/tools/DocUserDefault.jsp',_top} " ;
	    RCMenuHeight += RCMenuHeightStep; 
	}
    if (showall==0)
    {
        RCMenu += "{"+SystemEnv.getHtmlLabelName(15315,user.getLanguage())+",javascript:expandAll(1),_top} " ;
    	RCMenuHeight += RCMenuHeightStep;
    } 
    else 
    {
       RCMenu += "{"+SystemEnv.getHtmlLabelName(18466,user.getLanguage())+",javascript:expandAll(0),_top} " ;
       RCMenuHeight += RCMenuHeightStep;
    }
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<form name="frmDocAddList" method="post" action="DocList.jsp">
	<input type="hidden" name="isuserdefault" value="<%=isuserdefault%>">	
	<input type="hidden" name="selectsubid" value="<%=selectsubid%>">
	<input type="hidden" name="showall" value="<%=showall%>">
	<input type="hidden" name="isOpenNewWind" value="<%=isOpenNewWind%>">
	<input type="hidden" name="isExpDiscussion" value="<%=isExpDiscussion%>">
	<input type="hidden" name="topage" value="<%=topage%>">
	<input type="hidden" name="prjid" value="<%=prjid%>">
	<input type="hidden" name="crmid" value="<%=crmid%>">
	<input type="hidden" name="hrmid" value="<%=hrmid%>">
	<input type="hidden" name="coworkid" value="<%=coworkid%>">
	<input type="hidden" name="showsubmit" value="<%=showsubmit%>">
	<input type="hidden" name="messageid" value="<%=messageid%>">
    
    <%-- edited by wdl 2006-05-24 left menu new requirement ?fromadvancedmenu=1&infoId=-140 --%>
    <input type="hidden" name="fromadvancedmenu" value="<%=fromAdvancedMenu%>">
    <input type="hidden" name="selectedContent" value="<%=selectedContent%>">
    <input type="hidden" name="infoId" value="<%=infoId%>">
    <%-- edited end --%>
	
</form>

<%






    ArrayList mainids=new ArrayList();
    ArrayList subids=new ArrayList();
    ArrayList secids=new ArrayList();
    
    String tempsubcategoryid="";
    AclManager am = new AclManager();
    char separator = Util.getSeparator();
    String callparam = "" + user.getUID() + separator + user.getLogintype() + separator + user.getSeclevel() + separator + AclManager.OPERATION_CREATEDOC+separator+user.getUserDepartment()+separator+user.getUserSubCompany1()+separator+am.getUserAllRoleAndRoleLevel(user.getUID());
    CategoryTree tree = am.getPermittedTree(user, AclManager.OPERATION_CREATEDOC);
    Vector alldirs = tree.allCategories;

    for (int i=0; i < alldirs.size(); i++)
    {
        CommonCategory temp = (CommonCategory)alldirs.get(i);

        if (temp.type == AclManager.CATEGORYTYPE_MAIN) 
        {
            mainids.add(Integer.toString(temp.id));
        } 
        else if (temp.type == AclManager.CATEGORYTYPE_SEC) 
        {
            secids.add(Integer.toString(temp.id));
            
          /*  if (subids.indexOf(Integer.toString(temp.superiorid)) == -1) 
            {
                subids.add(Integer.toString(temp.superiorid));
            }*/
        }
        else if(temp.type == AclManager.CATEGORYTYPE_SUB)
        {
            subids.add(Integer.toString(temp.id));
        }
    }


    //  处理分列显示
    int maincate = mainids.size();
    int rownum=0;           
    
    if(fromAdvancedMenu==1 || isuserdefault.equals("2") || (isuserdefault.equals("1") && !"".equals(selectArr)))
    {
        maincate = 0;
        int curpos=0;
        String tmpstring = selectArr;
        curpos = tmpstring.indexOf("M",curpos);
       
        while(curpos != -1)
        {
            maincate += 1;
            tmpstring = tmpstring.substring(curpos+1,tmpstring.length());
            curpos = tmpstring.indexOf("M");
        }
        
        if(useUnselected.equals("true")){
        	maincate = mainids.size() - maincate;
        }
    }
    
   
    
    int tmp = maincate/3;

    if((tmp * 3 )== maincate)
	   rownum = tmp;
    else
	   rownum = tmp+1;
%>

<table  height=100% border="0" cellspacing="0" cellpadding="0" width="100%">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height: 5px!important;">
	<td height="5" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top" width="100%">
		<TABLE class=Shadow>
		<tr>
		<td valign="top" width="100%">
			<TABLE class=ViewForm width="100%">
				<COLGROUP> <COL width="49%"> <COL width=10> <COL width="49%"> 
				</COLGROUP>
				<TBODY>
				<TR>
				 <td valign="top" width="100%">

<TABLE class=ViewForm>
 
  <TBODY>
  
<tr style="height: 10px!important;">
			<td style="height:10px" colspan="3"></td>
		</tr>

  <TR class=>
    <TD align=left valign=top>
    <table class="ViewForm">
		
    	<tr><td>
    	<%
    		
    	%>
    	<%if(fromAdvancedMenu!=1&&usertype.equals("0")&&!commonuse.equals("-1")){ %>
    	<!-- 常用目录 开始 -->
    	<%
    		if(RecordSet.getDBType().equals("oracle")){
    			RecordSet.execute("SELECT * FROM (select secid from DocCategoryUseCount a where exists(select 1 from DirAccessControlDetail b where b.sourceid = a.secid and ((type=1 and content="+user.getUserDepartment()+" and seclevel<="+user.getSeclevel()+") or (type=2 and content in ("+am.getUserAllRoleAndRoleLevel(user.getUID())+") and seclevel<="+user.getSeclevel()+") or (type=3 and seclevel<="+user.getSeclevel()+") or (type=4 and content="+user.getType()+" and seclevel<="+user.getSeclevel()+") or (type=5 and content="+user.getUID()+") or (type=6 and content="+user.getUserSubCompany1()+" and seclevel<="+user.getSeclevel()+")) and b.sharelevel=0 ) and a.userid='"+user.getUID()+"' order by count desc,secid asc ) WHERE ROWNUM <= 10 ORDER BY ROWNUM ASC");
    		}else{
    			RecordSet.execute("select top 10 secid from DocCategoryUseCount a where exists(select 1 from DirAccessControlDetail b where b.sourceid = a.secid and ((type=1 and content="+user.getUserDepartment()+" and seclevel<="+user.getSeclevel()+") or (type=2 and content in ("+am.getUserAllRoleAndRoleLevel(user.getUID())+") and seclevel<="+user.getSeclevel()+") or (type=3 and seclevel<="+user.getSeclevel()+") or (type=4 and content="+user.getType()+" and seclevel<="+user.getSeclevel()+") or (type=5 and content="+user.getUID()+") or (type=6 and content="+user.getUserSubCompany1()+" and seclevel<="+user.getSeclevel()+")) and b.sharelevel=0 ) and a.userid='"+user.getUID()+"' order by count desc,secid asc");
    		}
    		//System.out.println("select top 10 secid from DocCategoryUseCount a where exists(select 1 from DirAccessControlDetail b where b.sourceid = a.secid and ((type=1 and content="+user.getUserDepartment()+" and seclevel<="+user.getSeclevel()+") or (type=2 and content in ("+am.getUserAllRoleAndRoleLevel(user.getUID())+") and seclevel<="+user.getSeclevel()+") or (type=3 and seclevel<="+user.getSeclevel()+") or (type=4 and content="+user.getLogintype()+" and seclevel<="+user.getSeclevel()+") or (type=5 and content="+user.getUID()+") or (type=6 and content="+user.getUserSubCompany1()+" and seclevel<="+user.getSeclevel()+")) and b.sharelevel=0 ) and a.userid='"+user.getUID()+"' order by count desc,secid asc");
    		if(RecordSet.getCounts()>0){
    		
    	%>
    	<div class="listbox1">
    	 <table width="100%" height="20px" border="0" cellspacing="0" cellpadding="0">
        	<tr>
				
        		<td class="t-center"></span>&nbsp;
        			<span><b><%=SystemEnv.getHtmlLabelName(28183,user.getLanguage()) %></b></span>
        			</td><td class="t-right"></td>
        			
        			
			</tr>
        </table>
        <ul>
        <ol style='padding-left:0px'>
         <%
         	while(RecordSet.next()){
         		String subid=SecCategoryComInfo.getSubCategoryid(RecordSet.getString("secid"));
         		String mainid = SubCategoryComInfo.getMainCategoryid(subid);
         %>
        			  <LI>                    
                <A HREF="javaScript:addSecIdUseCount('<%=RecordSet.getString("secid") %>');openNewWindow('DocAdd.jsp?mainid=<%=mainid %>&subid=<%=subid %>&secid=<%=RecordSet.getString("secid") %>')">
                <font class='smallfont' style="font-size:9pt "><%=SecCategoryComInfo.getSecCategoryname(RecordSet.getString("secid"))%></font></A>          
           		 </LI>
           	<%} %>	 
           		 </ol>
        			</ul>
        </div>
        <%} %>
        <!-- 常用目录 结束 -->
        <%} %>
<%
	int i=0;
	int needtd=rownum;
	
    for(int j=0; j < mainids.size(); j++)
    {
        String mainid = (String)mainids.get(j);
        String mainname = MainCategoryComInfo.getMainCategoryname(mainid);
		if(useUnselected.equals("true")){
	        if((fromAdvancedMenu==1 || isuserdefault.equals("2") || (isuserdefault.equals("1") && !"".equals(selectArr))) && selectArr.indexOf("M"+mainid+"|") != -1)
	        {
	            continue;
	        }
		}else{
			if((fromAdvancedMenu==1 || isuserdefault.equals("2") || (isuserdefault.equals("1") && !"".equals(selectArr))) && selectArr.indexOf("M"+mainid+"|") == -1)
	        {
	            continue;
	        }
		}
        needtd--;
%>
    <div class="listbox1">
        
        <table width="100%" height="20px" border="0" cellspacing="0" cellpadding="0">
        	<tr>
				
        		<td class="t-center"></span>&nbsp;
        			<span><b><%=mainname%></b></span>
        			</td><td class="t-right"></td>
			</tr>
        </table>
        
    	<ul>
<%
        for(int m = 0; m < subids.size(); m++)
        {
            String subid = (String)subids.get(m);
            String subname = SubCategoryComInfo.getSubCategoryname(subid);
            String curmainid = SubCategoryComInfo.getMainCategoryid(subid);
        
            if(!curmainid.equals(mainid))
                continue;
            if(useUnselected.equals("true")){
	            if((fromAdvancedMenu==1 || isuserdefault.equals("2") || (isuserdefault.equals("1") && !"".equals(selectArr))) && selectArr.indexOf("S"+subid+"|")!=-1)
	            { continue;}
            }else{
            	if((fromAdvancedMenu==1 || isuserdefault.equals("2") || (isuserdefault.equals("1") && !"".equals(selectArr))) && selectArr.indexOf("S"+subid+"|")==-1)
	            { continue;}
            }

            i++;
%>
    	
        
<%
            String linkUrl ="" ;   //linkUrl :指的是点击链接时链接所执行的程序
            String srcImage="";

            if(selectsubid.equals(subid)||showall==1)
            {
                linkUrl ="0";
                srcImage="\\images\\btnDocCollapse.gif";
				%><li class="flag_2_forDocList_open"><%
            }
            else
            {
                linkUrl=subid;
                srcImage="\\images\\btnDocExpand.gif";
				%><li class="flag_2_forDocList_close"><%
            }
%>
            <A id="aTag<%=j%><%=m%>" HREF="javaScript:onImgClick('<%=linkUrl%>','aTag<%=j%><%=m%>')"><!--<IMG SRC="<%=srcImage%>" BORDER="0" HEIGHT="12px" WIDTH="12px">--><%=subname%></a>
       </li>
        
<%
            if(subid.equals(selectsubid)&&showall==0)
            {
%>
		
        <ol>
<%
                for(int n=0;n<secids.size();n++)
                {
                    String secid = (String)secids.get(n);
                    String secname=SecCategoryComInfo.getSecCategoryname(secid);
                    String cursubid = SecCategoryComInfo.getSubCategoryid(secid);
                    if(!cursubid.equals(subid)) 
                       continue;
%>
            <LI>                    
                <A HREF="javaScript:addSecIdUseCount('<%=secid%>');openNewWindow('DocAdd.jsp?mainid=<%=mainid%>&subid=<%=subid%>&secid=<%=secid%>')">
                <font class='smallfont'><%=secname%></font></A>          
            </LI>
<%
                }
%>
       </ol>
    
<%
            }

            if(showall==1)
            {
%>
	 
       <ol>
<%
                for(int n=0;n<secids.size();n++)
                {
                    String secid = (String)secids.get(n);
                    String secname=SecCategoryComInfo.getSecCategoryname(secid);
                    String cursubid = SecCategoryComInfo.getSubCategoryid(secid);
                    if(!cursubid.equals(subid)) 
                       continue;
%>
        <LI> <A HREF="javaScript:addSecIdUseCount('<%=secid%>');openNewWindow('DocAdd.jsp?mainid=<%=mainid%>&subid=<%=subid%>&secid=<%=secid%>')">
		  <%=secname%></A></LI>
<%
                }
%>
       </ol>
<%
            }
        }
	%>
		</ul>
		</div>
	<%
        	
        if(needtd==0)
        {
            needtd=rownum;
%>
        </table>
        
        </td>
        <td width="15"></td>
		<td align=left valign=top>
			<table class="ViewForm">
			<tr><td>
<%
        }
    }
%>
    </td></tr></table></TD>
    </TR>
</table>

        </td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr style="height: 10px!important;">
	<td height="10" colspan="3"></td>
</tr>
</table>
<script>
function onuserdefault(isuserdefault){
	document.frmDocAddList.isuserdefault.value=isuserdefault;
    <%-- edited by wdl 2006-05-24 left menu new requirement ?fromadvancedmenu=1&infoId=-140 --%>
	if(<%=fromAdvancedMenu%>==1){
		document.frmDocAddList.fromadvancedmenu.value="0";
	}
	<%-- edited by wdl end --%>
    document.frmDocAddList.submit();
}

function expandAll(state){	
	if (state==1){
		document.frmDocAddList.showall.value="1";
	} else {
		document.frmDocAddList.showall.value="0";
	}
	
   document.frmDocAddList.submit();
}
function onImgClick(str,anchorname) {		
	document.frmDocAddList.selectsubid.value=str;
	if (document.body.scrollTop==0){
		document.frmDocAddList.action="DocList.jsp";
	} else {
		document.frmDocAddList.action="DocList.jsp#"+anchorname;
	}
    document.frmDocAddList.submit();
}
function addSecIdUseCount(secid){
	jQuery.post('AddSecIdUseCount.jsp',{secid:secid});
}
function openNewWindow(actionStr){
	
	if (<%=isOpenNewWind%>==1){
		actionStr+="";	
	    window.openFullWindowHaveBar(actionStr+'&showsubmit=<%=showsubmit%>&coworkid=<%=coworkid%>&prjid=<%=prjid%>&isExpDiscussion=<%=isExpDiscussion%>&crmid=<%=crmid%>&hrmid=<%=hrmid%>&topage=<%=topage%>')
	} else {
      actionStr+="&topage=<%=topageURLEncoder%>";
      document.frmDocAddList.action=actionStr;
	  document.frmDocAddList.submit();
	}
}
</script>
<%

  //如果从流程中来，根据流程ID获得新建文档存放的目录，直接进入新建页面
	if (!workflowid.equals(""))
	{
    RecordSet.execute("select newdocpath from workflow_base where id="+workflowid);

	if (RecordSet.next())
		{
	    String docsecid=RecordSet.getString(1);
		
        if (!docsecid.equals(""))
			{docsecid = docsecid.substring(docsecid.lastIndexOf(',')+1,docsecid.length());
		   String subidtemp=SecCategoryComInfo.getSubCategoryid(docsecid);
		   String mainidtemp=SubCategoryComInfo.getMainCategoryid(subidtemp);%>
           <script>
			
		   openNewWindow('DocAdd.jsp?mainid=<%=mainidtemp%>&subid=<%=subidtemp%>&secid=<%=docsecid%>')
		   </script>
		   <%return;
		
		}
	}
	}
%>
