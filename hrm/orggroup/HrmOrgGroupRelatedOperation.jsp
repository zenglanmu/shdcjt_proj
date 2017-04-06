<%@ page language="java" contentType="text/html; charset=GBK" %>

<jsp:useBean id="DocDetailLog" class="weaver.docs.DocDetailLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<%@ include file="/systeminfo/init.jsp" %>

<%
if(!HrmUserVarify.checkUserRight("GroupsSet:Maintenance", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
    String operation =  Util.null2String(request.getParameter("operation"));
    if ("Delete".equals(operation)){

        int orgGroupId = Util.getIntValue(request.getParameter("orgGroupId"),0);
        int type = Util.getIntValue(request.getParameter("type"),-1);
        String content = Util.null2String(request.getParameter("content"));

        String checkedCheckboxIds = Util.null2String(request.getParameter("checkedCheckboxIds"));

        if (!"".equals(checkedCheckboxIds)){

		    if(checkedCheckboxIds.startsWith(",")){
			    checkedCheckboxIds = checkedCheckboxIds.substring(1);
			}
			if(checkedCheckboxIds.endsWith(",")){
				checkedCheckboxIds = checkedCheckboxIds.substring(0,checkedCheckboxIds.length()-1);
			}
			if(!checkedCheckboxIds.equals("")){
				RecordSet.executeSql("delete from HrmOrgGroupRelated where id in("+checkedCheckboxIds+")");
			}
        }     
        response.sendRedirect("/hrm/orggroup/HrmOrgGroupRelated.jsp?orgGroupId="+orgGroupId+"&type="+type+"&content="+content);        
    }else if("addMutil".equals(operation)){   

        int orgGroupId = Util.getIntValue(request.getParameter("orgGroupId"),0);

		int type = 0;//关联类型
		String content = "";

		int contentPartId=0;
		int rolelevelValue= 0;
		int secLevelFrom = 0;
		int secLevelTo = 0;
		
        String[] shareValues = request.getParameterValues("txtShareDetail"); 
        if (shareValues!=null) {       
            for (int i=0;i<shareValues.length;i++){
               
                String[] paras = Util.TokenizerString2(shareValues[i],"_");//关联类型 + 关联者ID +关联角色级别 +安全级别最小值+安全级别最大值
                type = Util.getIntValue(paras[0],0);
                content = Util.null2String(paras[1]);
                rolelevelValue = Util.getIntValue(paras[2],0);
                secLevelFrom = Util.getIntValue(paras[3],0);
                secLevelTo = Util.getIntValue(paras[4],0);

	            ArrayList contentList=Util.TokenizerString(content,",");
				for(int j=0;j<contentList.size();j++){
					contentPartId=Util.getIntValue((String)contentList.get(j),0);

				    if(type==4){//如果当关联的类型为角色的时候. 其值为角色ID角色级别ID(0: 表部门 1：表分部 2：表总部)格式如 230其中最后一位表示角色级别ID
                        contentPartId = Util.getIntValue(String.valueOf(contentPartId)+String.valueOf(rolelevelValue),0);				    
				    }
					
					RecordSet.executeSql("select 1 from HrmOrgGroupRelated where orgGroupId="+orgGroupId+" and type="+type+" and content="+contentPartId+" and secLevelFrom="+secLevelFrom+" and secLevelTo="+secLevelTo);
					if(!RecordSet.next()){
						RecordSet.executeSql("insert into HrmOrgGroupRelated(orgGroupId,type,content,secLevelFrom,secLevelTo )  values("+orgGroupId+","+type+","+contentPartId+","+secLevelFrom+","+secLevelTo+")");
					}
				}
            }
        }	  
       
       response.sendRedirect("/hrm/orggroup/HrmOrgGroupRelated.jsp?orgGroupId="+orgGroupId); 
	   return;
    }
%>