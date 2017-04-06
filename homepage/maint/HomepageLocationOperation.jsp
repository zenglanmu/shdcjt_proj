<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Hashtable" %>

 <jsp:useBean id="hpc" class= "weaver.homepage.cominfo.HomepageCominfo" scope="page" />
 <jsp:useBean id="hpu" class= "weaver.homepage.HomepageUtil" scope="page" />
 <jsp:useBean id="rs" class= "weaver.conn.RecordSet" scope="page" />
<%
  
	if(!HrmUserVarify.checkUserRight("hporder:maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	
	String method = Util.null2String(request.getParameter("method"));	
	if(method.equals("edit")){
		String[] hpids = request.getParameterValues("hpid");
		String[] orderNums= request.getParameterValues("orderNum");

        if(hpids!=null){
                /*得到1级菜单LIST*/
            ArrayList oneList=new ArrayList();
            Hashtable oneHpList=new Hashtable();
            for(int k=0;k<orderNums.length;k++){
              String orderNum=orderNums[k];
              orderNum = Util.null2o(orderNum.trim());
              orderNums[k]=orderNum;
              int piontLoc=orderNum.indexOf(".");
			  if(piontLoc!=-1){
				if(orderNum.length()-piontLoc<3) {
					oneList.add(Float.valueOf(Util.getFloatValue(orderNum)));
					oneHpList.put(Float.valueOf(orderNum).toString(),hpids[k]);
                }
			  } else {
				  oneList.add(Float.valueOf(Util.getFloatValue(orderNum)));
                  oneHpList.put(Float.valueOf(orderNum).toString(),hpids[k]);
              }
            }
            Collections.sort(oneList);
			//Collections.reverse(oneList);
            

            String parenthpid="0";
			for(int i=0;i<hpids.length;i++){
			    parenthpid="0";
				String hpid=hpids[i];
				String orderNum=orderNums[i];
				
				int showtype=1;
				int piontLoc=orderNum.indexOf(".");
				if(piontLoc!=-1){
					if(orderNum.length()-piontLoc>=3) showtype=2;
				}

				if(showtype==2) {  //二级菜单则需要查找仅比自己大的一级首页的ID
				    Float lastOneMenu=(Float)oneList.get(oneList.size()-1);
					if(Util.getFloatValue(orderNum)>lastOneMenu.floatValue()) {
						int tempPos=oneList.indexOf(lastOneMenu);
						if(tempPos!=-1) parenthpid=(String)oneHpList.get(lastOneMenu.toString());
					} else {
						for(int t=0;t<oneList.size();t++){
							Float tempStr=(Float)oneList.get(t);							
							if(Util.getFloatValue(orderNum)<tempStr.floatValue()) {
								
								if(t>0){
									Float tempOrderNum=(Float)oneList.get(t-1);
									int tempPos=oneList.indexOf(tempOrderNum);
									if(tempPos!=-1) parenthpid=(String)oneHpList.get(tempOrderNum.toString());
								} else {
									//表示其值比我们的1级菜单的1级列表还小
									response.sendRedirect("HomepageLocation.jsp?msg=seterror&code="+orderNum);
									return;
									/*String tempOrderNum=(String)oneList.get(t);
									int tempPos=oneList.indexOf(tempOrderNum);

									if(tempPos!=-1) parenthpid=(String)oneHpList.get(tempPos);*/
								}
								//System.out.println(hpid+" 's parenthpid:"+parenthpid);
								break;
							}
						}
					}
				} 

        	    
				String strSql="update hpinfo set orderNum='"+orderNum+"',showtype="+showtype+",parenthpid='"+parenthpid+"' where id="+hpid;

				//System.out.println(strSql);
				rs.executeSql(strSql);
			}		
		}
		response.sendRedirect("HomepageLocation.jsp");
		return;
	}
%>