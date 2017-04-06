<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="weaver.docs.category.security.AclManager" %>



<%@ include file="/systeminfo/init.jsp" %>


<%
String method = Util.null2String(request.getParameter("method"));
int categoryid = Integer.parseInt(Util.null2String(request.getParameter("categoryid")));
int categorytype = Integer.parseInt(Util.null2String(request.getParameter("categorytype")));
AclManager am = new AclManager();

if (!HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) && !am.hasPermission(categoryid, categorytype, user, AclManager.OPERATION_CREATEDIR)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
if (method.equals("add")) {
    int operationcode = Integer.parseInt(Util.null2String(request.getParameter("operationcode")));
    int permissiontype = Integer.parseInt(Util.null2String(request.getParameter("permissiontype")));
    int seclevel = Integer.parseInt(Util.null2String(request.getParameter("seclevel")));
    
	String hisSecCategoryCreater="";
    switch (permissiontype) {
        case 1:
        /* for TD.4240 edited by wdl(增加多部门) */
        int ismutil = Util.getIntValue(Util.null2o(request.getParameter("mutil")));
        if(ismutil!=0) {


			/*if(categorytype==2){
			    hisSecCategoryCreater=UserDefaultManager.getSecCategoryCreater(String.valueOf(categoryid));
			}*/
			
            String tempStrs[] = Util.TokenizerString2(Util.null2String(request.getParameter("departmentid")),",");
            for(int k=0;k<tempStrs.length;k++){
                int departmentid = Util.getIntValue(Util.null2o(tempStrs[k]));
                if(departmentid>0)
                    am.grantDirPermission1(categoryid, categorytype, operationcode, departmentid, seclevel);
            }
			/*if(categorytype==2){
                UserDefaultManager.addDocCategoryDefault(String.valueOf(categoryid),hisSecCategoryCreater);
			}*/

            response.sendRedirect(CategoryUtil.getCategoryEditPage(categorytype, categoryid));
        } else {

			/*if(categorytype==2){
			    hisSecCategoryCreater=UserDefaultManager.getSecCategoryCreater(String.valueOf(categoryid));
			}*/
            int departmentid = Integer.parseInt(Util.null2String(request.getParameter("departmentid")).split(",")[1]);
            am.grantDirPermission1(categoryid, categorytype, operationcode, departmentid, seclevel);
			/*if(categorytype==2){
                UserDefaultManager.addDocCategoryDefault(String.valueOf(categoryid),hisSecCategoryCreater);
			}*/
            response.sendRedirect(CategoryUtil.getCategoryEditPage(categorytype, categoryid));
        }
        /* end */
        break;

        case 6:
            int ismutilsub = Util.getIntValue(Util.null2o(request.getParameter("mutil")));
            if(ismutilsub!=0) {


            	/*if(categorytype==2){
    			    hisSecCategoryCreater=UserDefaultManager.getSecCategoryCreater(String.valueOf(categoryid));
    			}*/
    			
                String tempStrs[] = Util.TokenizerString2(Util.null2String(request.getParameter("subcompanyid")),",");
                for(int k=0;k<tempStrs.length;k++){
                    int subcompanyid = Util.getIntValue(Util.null2o(tempStrs[k]));
                    if(subcompanyid>0)
                        am.grantDirPermission6(categoryid, categorytype, operationcode, subcompanyid, seclevel);
                }
    			/*if(categorytype==2){
                    UserDefaultManager.addDocCategoryDefault(String.valueOf(categoryid),hisSecCategoryCreater);
    			}*/

                response.sendRedirect(CategoryUtil.getCategoryEditPage(categorytype, categoryid));
            } else {

    			/*if(categorytype==2){
    			    hisSecCategoryCreater=UserDefaultManager.getSecCategoryCreater(String.valueOf(categoryid));
    			}*/
                int subcompanyid = Integer.parseInt(Util.null2String(request.getParameter("subcompanyid")).split(",")[1]);
                am.grantDirPermission6(categoryid, categorytype, operationcode, subcompanyid, seclevel);
    			/*if(categorytype==2){
                    UserDefaultManager.addDocCategoryDefault(String.valueOf(categoryid),hisSecCategoryCreater);
    			}*/
                response.sendRedirect(CategoryUtil.getCategoryEditPage(categorytype, categoryid));
            }
            break;
        
        case 2:        
        int roleid = Integer.parseInt(Util.null2String(request.getParameter("roleid")));
        int rolelevel = Integer.parseInt(Util.null2String(request.getParameter("rolelevel")));

		/*if(categorytype==2){
			hisSecCategoryCreater=UserDefaultManager.getSecCategoryCreater(String.valueOf(categoryid));
		}*/
        am.grantDirPermission2(categoryid, categorytype, operationcode, roleid, rolelevel, seclevel);
		/*if(categorytype==2){
            UserDefaultManager.addDocCategoryDefault(String.valueOf(categoryid),hisSecCategoryCreater);
		}*/
	    response.sendRedirect(CategoryUtil.getCategoryEditPage(categorytype, categoryid));
        break;

        case 3:

		/*if(categorytype==2){
			hisSecCategoryCreater=UserDefaultManager.getSecCategoryCreater(String.valueOf(categoryid));
		}*/
        am.grantDirPermission3(categoryid, categorytype, operationcode, seclevel);
		/*if(categorytype==2){
            UserDefaultManager.addDocCategoryDefault(String.valueOf(categoryid),hisSecCategoryCreater);
		}*/
	    response.sendRedirect(CategoryUtil.getCategoryEditPage(categorytype, categoryid));
        break;

        case 4:

		/*if(categorytype==2){
			hisSecCategoryCreater=UserDefaultManager.getSecCategoryCreater(String.valueOf(categoryid));
		}*/
        int usertype = Integer.parseInt(Util.null2String(request.getParameter("usertype")));
        am.grantDirPermission4(categoryid, categorytype, operationcode, usertype, seclevel);
		/*if(categorytype==2){
            UserDefaultManager.addDocCategoryDefault(String.valueOf(categoryid),hisSecCategoryCreater);
		}*/
	    response.sendRedirect(CategoryUtil.getCategoryEditPage(categorytype, categoryid));
        break;

        case 5:

		/*if(categorytype==2){
			hisSecCategoryCreater=UserDefaultManager.getSecCategoryCreater(String.valueOf(categoryid));
		}*/
        String[] tmpuserid = Util.TokenizerString2(Util.null2String(request.getParameter("userid")),",");
        int userid = 0;
        for(int i=0;tmpuserid!=null&&tmpuserid.length>0&&i<tmpuserid.length;i++){
        	userid = Util.getIntValue(tmpuserid[i]);
        	if(userid>0) am.grantDirPermission5(categoryid, categorytype, operationcode, userid);
        }
        /*if(categorytype==2){
            UserDefaultManager.addDocCategoryDefault(String.valueOf(categoryid),hisSecCategoryCreater);
		}*/
        response.sendRedirect(CategoryUtil.getCategoryEditPage(categorytype, categoryid));
        break;
    }
} else if (method.equals("delete")) {
	String mainids = Util.null2String(request.getParameter("mainids"));
    int mainid = Util.getIntValue(Util.null2String(request.getParameter("mainid")));
	List dirIdDirTypeOperationCodeList=null;
    if(mainids!=null&&!"".equals(mainids)){
		dirIdDirTypeOperationCodeList=am.getDirIdDirTypeOperationCodeList(mainids);
    	String[] tids = Util.TokenizerString2(mainids,",");
    	for(int i=0;tids!=null&&tids.length>0&&i<tids.length;i++){
    		am.depriveDirPermission(Util.getIntValue(tids[i]));
		}
    } else {
		dirIdDirTypeOperationCodeList=am.getDirIdDirTypeOperationCodeList(""+mainid);
    	am.depriveDirPermission(mainid);
    }
	am.updateDirAccessPermissionData(dirIdDirTypeOperationCodeList);
	response.sendRedirect(CategoryUtil.getCategoryEditPage(categorytype, categoryid));
	return;
}
%>