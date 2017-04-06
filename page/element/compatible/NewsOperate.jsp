<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<%	
	
	String eid=Util.null2String(request.getParameter("eid"));	
	String method=Util.null2String(request.getParameter("method"));	
	
	String tabId=Util.null2String(request.getParameter("tabId"));	
	String tabTitle=Util.null2String(request.getParameter("tabTitle"));	
	//tabTitle = Util.toHtml2(tabTitle);
	tabTitle = tabTitle.replaceAll("'","''");
	String tabWhere=Util.null2String(request.getParameter("tabWhere"));
		
	Hashtable tabAddList =null;
	ArrayList tabRemoveList = null;
	
	
	if(session.getAttribute(eid+"_Add")!=null){
		tabAddList = (Hashtable)session.getAttribute(eid+"_Add");
	}else{
		tabAddList = new Hashtable();
		
	}
	
	if(session.getAttribute(eid+"_Remove")!=null){
		
		tabRemoveList = (ArrayList)session.getAttribute(eid+"_Remove");
	}else{
		tabRemoveList = new ArrayList();
	}
	
	if(method.equals("add")||method.equals("edit")){
		Hashtable hasTabParam = new Hashtable();	
		hasTabParam.put("eid",eid+"");
		hasTabParam.put("tabId",tabId);
		hasTabParam.put("tabTitle",tabTitle);
		hasTabParam.put("tabWhere",tabWhere);
		tabAddList.put(tabId,hasTabParam);
		session.setAttribute(eid+"_Add",tabAddList);
	}else if(method.equals("delete")){
		
		if(tabAddList.containsKey(tabId)){
			tabAddList.remove(tabId);	
		
		}
		tabRemoveList.add(tabId);
			
		session.setAttribute(eid+"_Remove",tabRemoveList);
	}else if(method.equals("submit")){
		
		Enumeration e =tabAddList.elements(); 
		boolean isfirst=true;
		while(e.hasMoreElements()){ 
			Hashtable hasParam = (Hashtable)e.nextElement();
			String tabSql = "select * from hpNewsTabInfo where eid="+hasParam.get("eid")+" and tabId='"+hasParam.get("tabId")+"'";
			rs.execute(tabSql);
			if(rs.next()){
				tabSql = "update hpNewsTabInfo set sqlWhere = '"+hasParam.get("tabWhere")+"', tabTitle='"+hasParam.get("tabTitle")+"' where eid="+hasParam.get("eid")+" and tabId='"+hasParam.get("tabId")+"'";
			}else{
				tabSql = "insert into hpNewsTabInfo (eid,tabid,tabTitle,sqlWhere) values("+hasParam.get("eid")+",'"+hasParam.get("tabId")+"','"+hasParam.get("tabTitle")+"','"+hasParam.get("tabWhere")+"')";
			}
			if(isfirst){
				rs.execute("update hpelement set strsqlwhere='"+hasParam.get("tabWhere")+"' where id = "+hasParam.get("eid"));
				
				hpec.updateHpElementCache(eid);
				isfirst = false;
			}
			rs.execute(tabSql);
		} 
		for(int i=0;i<tabRemoveList.size();i++){
			rs.execute("delete from hpNewsTabInfo where eid="+eid+" and tabId='"+tabRemoveList.get(i)+"'");
			
		}
		//if(tabAddList.)
		session.removeAttribute(eid+"_Add");
		session.removeAttribute(eid+"_Remove");
	} else if(method.equals("cancel")){
		session.removeAttribute(eid+"_Add");
		session.removeAttribute(eid+"_Remove");
	}
%>