<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
char flag=Util.getSeparator();
String ProcPara = "";
String id = Util.null2String(request.getParameter("id"));
String method = Util.null2String(request.getParameter("method"));
String secid = Util.null2String(request.getParameter("secid")); 

if (secid.equals("")) secid=Util.null2o(request.getParameter("docid"));  //1 docid用目录ID   2 docid 为文档ID,根据上个页面的来源
AclManager am = new AclManager();
if(!HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) && !am.hasPermission(Integer.parseInt(secid), AclManager.CATEGORYTYPE_SEC, user, AclManager.OPERATION_CREATEDIR)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

if(method.equals("delete"))
{

	RecordSet.executeProc("DocSecCategoryShare_Delete",id);
	response.sendRedirect("DocSecCategoryEdit.jsp?id="+secid+"&tab=1");
	return;
}


if(method.equals("add"))
{
    String relatedshareid = Util.null2String(request.getParameter("relatedshareid")); 
    String sharetype = Util.null2String(request.getParameter("sharetype")); 
    String rolelevel = Util.null2String(request.getParameter("rolelevel")); 
    String seclevel = Util.null2String(request.getParameter("seclevel"));
    String sharelevel = Util.null2String(request.getParameter("sharelevel"));
    String orgGroupId="0";
    String userid = "0" ;
    String departmentid = "0" ;
    String subcompanyid="0";
    String roleid = "0" ;
    String foralluser = "0" ;
    String crmid="0";    
    /** ===/proj/data/AddShare.jsp ;/cpt/cptcapitalAddShare.jsp ;  /CRM/data/AddShare.jsp ========*/
    String downloadlevel="1";//TD12005(TODO默认可下载)
    	
    if(sharetype.equals("1")) userid = relatedshareid ;
    if(sharetype.equals("2")) subcompanyid = relatedshareid ;
    if(sharetype.equals("3")) departmentid = relatedshareid ;
    if(sharetype.equals("4")) roleid = relatedshareid ;
    if(sharetype.equals("5")) foralluser = "1" ;
    if(sharetype.equals("6")) orgGroupId = relatedshareid ;

	ProcPara = secid;
	ProcPara += flag+sharetype;
	ProcPara += flag+seclevel;
	ProcPara += flag+rolelevel;
	ProcPara += flag+sharelevel;
	ProcPara += flag+userid;
	ProcPara += flag+subcompanyid;
	ProcPara += flag+departmentid;
	ProcPara += flag+roleid;
	ProcPara += flag+foralluser;
    ProcPara += flag+crmid;
    ProcPara += flag+orgGroupId;
    ProcPara += flag+downloadlevel;//TD12005
    
    //RecordSet.executeProc("DocSecCategoryShare_Insert",ProcPara);
    RecordSet.executeProc("DocSecCategoryShare_Ins_G",ProcPara);
	response.sendRedirect("DocSecCategoryEdit.jsp?id="+secid+"&tab=1");
	return;
}


if(method.equals("addMutil")){   
        secid = Util.null2String(request.getParameter("docid")); 
        String[] shareValues = request.getParameterValues("txtShareDetail"); 
        if (shareValues!=null) {       
            for (int i=0;i<shareValues.length;i++){
               
                //out.println(shareValues[i]+"<br>");
                String[] paras = Util.TokenizerString2(shareValues[i],"_");
                String sharetype = paras[0];
                String seclevel=paras[3] ;
                String sharelevel=paras[4] ;
                String roleid="0";
                String rolelevel="0";
                 String userid = "0" ;
                String departmentid = "0" ;
                String subcompanyid="0";                
                String foralluser = "0" ;
                String crmid="0";
                String orgGroupId="0";
                String downloadlevel=paras[5];//TD12005
                
                if(sharetype.equals("4")) {
                    roleid = paras[1] ;
                    rolelevel=paras[2] ;
                }
                if(sharetype.equals("5")) foralluser = "1" ;
                // for TD.4240 edit by wdl
                /*
                if(sharetype.equals("2")) { //分部
                    subcompanyid = paras[1] ;
                }*/
                if ("1".equals(sharetype)||"3".equals(sharetype)||"9".equals(sharetype)||sharetype.equals("2")||sharetype.equals("6")){  //1:多人力资源    3:多部门...2:多分部	6:多群组
                    String tempStrs[]=Util.TokenizerString2(paras[1],",");
                    for(int k=0;k<tempStrs.length;k++){
                        
                        String tempStr = tempStrs[k];
                        if ("1".equals(sharetype)) userid=tempStr;
                        if ("3".equals(sharetype)) departmentid=tempStr;
                        if ("9".equals(sharetype)) crmid=tempStr;
                        if ("2".equals(sharetype))  subcompanyid =tempStr;
                        if ("6".equals(sharetype))  orgGroupId =tempStr;
                        // end
                        ProcPara = secid;
                        ProcPara += flag+sharetype;
                        ProcPara += flag+seclevel;
                        ProcPara += flag+rolelevel;
                        ProcPara += flag+sharelevel;
                        ProcPara += flag+userid;
                        ProcPara += flag+subcompanyid;
                        ProcPara += flag+departmentid;
                        ProcPara += flag+roleid;
                        ProcPara += flag+foralluser;     
                        ProcPara += flag+crmid;  
                        ProcPara += flag+orgGroupId;						
                        ProcPara += flag+downloadlevel;//TD12005
                        //System.out.println(ProcPara);
                        //RecordSet.executeProc("DocSecCategoryShare_Insert",ProcPara);
                        RecordSet.executeProc("DocSecCategoryShare_Ins_G",ProcPara);
                    }                       
                } else {
                    ProcPara = secid;
                    ProcPara += flag+sharetype;
                    ProcPara += flag+seclevel;
                    ProcPara += flag+rolelevel;
                    ProcPara += flag+sharelevel;
                    ProcPara += flag+userid;
                    ProcPara += flag+subcompanyid;
                    ProcPara += flag+departmentid;
                    ProcPara += flag+roleid;
                    ProcPara += flag+foralluser;                  
                     ProcPara += flag+crmid;  
                     ProcPara += flag+downloadlevel;//TD12005
                    RecordSet.executeProc("DocSecCategoryShare_Insert",ProcPara);
                }

                //for (int j=0;j<paras.length;j++){
                //   out.println(paras[j]+"<br>");
                //}
                //out.println("==========================");
            }
        }       
    response.sendRedirect("DocSecCategoryEdit.jsp?id="+secid+"&tab=1");
	return;
}
if(method.equals("delMShare")) {
    String[] delShareIds = request.getParameterValues("chkShareId");
    if (delShareIds!=null){
        for (int i=0;i<delShareIds.length;i++){
            RecordSet.executeProc("DocSecCategoryShare_Delete",delShareIds[i]);    
        }
    }
    response.sendRedirect("DocSecCategoryEdit.jsp?id="+secid+"&tab=1");
    return;
}
%>
