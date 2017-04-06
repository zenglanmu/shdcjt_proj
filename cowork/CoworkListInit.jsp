<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.URLDecoder"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
int userid=user.getUID();
// 查看类型
String type = Util.null2String(request.getParameter("type"));
//关注的或者直接参与的协作
String viewType = Util.null2String(request.getParameter("viewtype"));
//排序方式
String orderType = Util.null2String(request.getParameter("orderType"));
//是否是搜索操作
String isSearch = Util.null2String(request.getParameter("isSearch"));
//关键字
String name =URLDecoder.decode( Util.null2String(request.getParameter("name")));
//协作区ID
String typeid = Util.null2String(request.getParameter("typeid"));
//协作状态
String status = Util.null2String(request.getParameter("status"));
//参与类型
String jointype = Util.null2String(request.getParameter("jointype"));
// 创建者
String creater = Util.null2String(request.getParameter("creater"));
//负责人
String principal = Util.null2String(request.getParameter("principal"));
//开始时间
String startdate = Util.null2String(request.getParameter("startdate"));
// 结束时间
String enddate = Util.null2String(request.getParameter("enddate"));

String labelid=Util.null2String(request.getParameter("labelid"));

int index=Util.getIntValue(request.getParameter("index"));                 //下标 
int pagesize=Util.getIntValue(request.getParameter("pagesize"));           //每一次取多少
String disattention=Util.null2String(request.getParameter("disattention"));
String disdirect=Util.null2String(request.getParameter("disdirect"));

String projectid=Util.null2String(request.getParameter("projectid"));
String taskIds=Util.null2String(request.getParameter("taskIds"));

String searchStr="";
  if(isSearch.equals("true")){
	if(!name.equals("")){
		searchStr += " and name like '%"+name+"%' "; 
	}
	if(!typeid.equals("")){
		searchStr += "  and typeid='"+typeid+"'  ";
	}
	if(!status.equals("")){
		searchStr += " and status ="+status+"";
	}
	if(jointype.equals("")){        //参与 关注
		searchStr += " and jointype is not null";
	}else if(jointype.equals("1")){ //关注
		searchStr += " and jointype=1";
	}else if(jointype.equals("2")){ //参与
		searchStr += " and jointype=0";
	}
	if(!creater.equals("")){
		searchStr += " and creater='"+creater+"'  ";
	}
	if(!principal.equals("")){
		searchStr += " and principal='"+principal+"'  "; 
	}
	if(!startdate.equals("")){
		searchStr +=" and begindate >='"+startdate+"'  ";
	}
	if(!enddate.equals("")){
		searchStr +=" and enddate <='"+enddate+"'  ";
	}
  }else{
    searchStr += " and status =1";
  }
  
  if(!projectid.equals("")){
	   if(RecordSet.getDBType().equalsIgnoreCase("oracle"))
		 searchStr +=" and mutil_prjs||',' like '%"+projectid+",%'";
	   else 
		 searchStr +=" and mutil_prjs+',' like '%"+projectid+",%'";
    }
    
 if(!taskIds.equals("")){
		 searchStr +=" and id in ("+taskIds+")";
   } 
   
String sqlStr ="";

int departmentid=user.getUserDepartment();   //用户所属部门
int subCompanyid=user.getUserSubCompany1();  //用户所属分部
String seclevel=user.getSeclevel();          //用于安全等级

int iTotal =Util.getIntValue(request.getParameter("total"),0);
int iNextNum =index;
int ipageset = pagesize;
if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
if(iTotal < pagesize) ipageset = iTotal;

sqlStr="("+
		" select t1.mutil_prjs,t1.id,t1.name,t1.status,t1.typeid,t1.creater,t1.principal,t1.begindate,t1.enddate,t1.remark,"+
		" case when  t3.sourceid is not null then 1 when t2.cotypeid is not null then 0 end as jointype,"+
		" case when  t4.coworkid is not null then 0 else 1 end as isnew,"+
		" case when  t5.coworkid is not null then 1 else 0 end as important,"+
		" case when  t6.coworkid is not null then 1 else 0 end as ishidden"+
		(type.equals("label")?" ,case when  t7.coworkid is not null then 1 else 0 end as islabel":"")+
		" from cowork_items  t1 left join "+
		//关注的协作
		" (select distinct cotypeid from  cotype_sharemanager where (sharetype=1 and sharevalue like '%,"+userid+",%' )"+
		" or (sharetype=2 and sharevalue like '%,"+departmentid+",%' and "+seclevel+">=seclevel) "+
		" or (sharetype=3 and sharevalue like '%,"+subCompanyid+",%'  and "+seclevel+">=seclevel)"+
		" or (sharetype=4 and exists (select id from hrmrolemembers  where resourceid="+userid+"  and  sharevalue=Cast(roleid as varchar(100))) and "+seclevel+">=seclevel)"+
		" or (sharetype=5 and "+seclevel+">=seclevel)"+
		" )  t2 on t1.typeid=t2.cotypeid left join "+
        //直接参与的协作
		" (select distinct sourceid from coworkshare where"+
		" (type=1 and  (content='"+userid+"' or content like '%,"+userid+",%') )"+
		" or (type=2 and content like '%,"+subCompanyid+",%'  and "+seclevel+">=seclevel) "+
		" or (type=3 and content like '%,"+departmentid+",%' and "+seclevel+">=seclevel)"+
		" or (type=4 and exists (select id from hrmrolemembers  where resourceid="+userid+"  and content=Cast(roleid as varchar(100))) and "+seclevel+">=seclevel)"+
		" or (type=5 and "+seclevel+">=seclevel)"+
		" )  t3 on t3.sourceid=t1.id"+
        //阅读|重要|隐藏
		" left join (select distinct coworkid,userid from cowork_read where userid="+userid+")  t4 on t1.id=t4.coworkid"+       //阅读状态
		" left join (select distinct coworkid,userid from cowork_important where userid="+userid+" )  t5 on t1.id=t5.coworkid"+ //重要性
		" left join (select distinct coworkid,userid from cowork_hidden where userid="+userid+" )  t6 on t1.id=t6.coworkid"+    //是否隐藏
		(type.equals("label")?" left join (select distinct coworkid from cowork_item_label where labelid="+labelid+") t7 on t1.id=t7.coworkid":"")+ 
		" ) t where 1=1 and jointype is not null "+searchStr;

		if("unread".equals(type)){
			sqlStr=sqlStr+" and isnew=1 and ishidden<>1";
		}else if("important".equals(type)){
			sqlStr=sqlStr+" and important=1 and ishidden<>1";
		}else if("hidden".equals(type)){
			sqlStr=sqlStr+" and ishidden=1";
		}else if("all".equals(type)){
			sqlStr=sqlStr+" and ishidden<>1";
		}else if("coworkArea".equals(type)){
            sqlStr=sqlStr+" and ishidden<>1 and typeid="+typeid;
        }else if("label".equals(type)){
        	sqlStr=sqlStr+" and ishidden<>1 and islabel=1";
        }	
		
	 if(RecordSet.getDBType().equals("oracle")){
		    sqlStr="select *  from "+sqlStr;
		    if(orderType.equals("unread")){	
		       sqlStr=sqlStr+" order by jointype desc,isnew desc,important desc,id desc";
			}else{
			   sqlStr=sqlStr+" order by jointype desc,important desc,isnew desc,id desc";
			 }
			sqlStr = "select t1.*,rownum rn from (" + sqlStr + ") t1 where rownum <= " + iNextNum;
			sqlStr = "select t2.* from (" + sqlStr + ") t2 where rn > " + (iNextNum - pagesize);	 
		  
	 }else{
		 sqlStr="select top "+iNextNum+" *  from "+sqlStr;
		 if(orderType.equals("unread")){	
			   
	           sqlStr=sqlStr+" order by jointype desc,isnew desc,important desc,id desc";
	           sqlStr = "select top " + ipageset +" t1.* from (" + sqlStr + ") t1 order by t1.jointype asc,t1.isnew asc,t1.important asc,t1.id asc";
	           sqlStr = "select top " + ipageset +" t2.* from (" + sqlStr + ") t2 order by t2.jointype desc,t2.isnew desc,t2.important desc,t2.id desc";
		   }    
		   else{
			   sqlStr=sqlStr+" order by jointype desc,important desc,isnew desc,id desc";
			   sqlStr = "select top " + ipageset +" t1.* from (" + sqlStr + ") t1 order by t1.jointype asc,t1.important asc,t1.isnew asc,t1.id asc";
	           sqlStr = "select top " + ipageset +" t2.* from (" + sqlStr + ") t2 order by t2.jointype desc,t2.important desc,t2.isnew desc,t2.id desc";
		   }
	 }
%>

<%
ConnStatement statement=new ConnStatement();
try {
    statement.setStatementSql(sqlStr);
    statement.executeQuery();
	boolean dataLight=true;
    int flag=1;
    while(statement.next()){
    	int coworkid=statement.getInt("id");
    	String unread="";
    	String read="";
    	String important="";
    	String normal="";
    	String joinType=statement.getString("jointype");
		String coworkName=statement.getString("name");
    	
    	if(statement.getString("important").equals("1")){
    		important="true";
    		normal="false";
    	}else{
    		normal = "true";
    		important ="false";
    	}
    	
    	if(statement.getString("isnew").equals("1")){
    		unread = "true";
    		read = "false";
    	}else{
    		unread = "fasle";
    		read = "true";
    	}
    	
    	String labelStr ="";
    	RecordSet.execute("select t2.id,t2.name,t2.labelColor,t2.textColor from cowork_item_label t1,cowork_label t2 where t2.userid='"+userid+"' and t1.coworkid='"+coworkid+"' and t1.Labelid=t2.id");
    	while(RecordSet.next()){
    		String labelColor =RecordSet.getString("labelColor");
    		String textColor=RecordSet.getString("textColor");
    		String id=RecordSet.getString("id");
    		String labelName=RecordSet.getString("name");
    		double labelLength=Math.ceil(new String(labelName.getBytes("GBK"), "ISO8859_1").length()/2.0);
    	    labelStr+="<span class='label' labelid='"+id+"'><div style='background: "+labelColor+";width:"+(labelLength*12+6)+"px'>"+
					  "<div class='rtop'><div class='r2' style='background:"+labelColor+";border-bottom:"+labelColor+" 1px solid'></div><div class='r3' style='background:"+labelColor+";border-bottom:"+labelColor+" 1px solid'></div></div>"+
					  "<div class='labelTitle' style='background:"+labelColor+";color:"+textColor+"'>"+labelName+"</div>"+
					  "<div class='rbottom'><div class='r3' style='background:"+labelColor+";border-bottom:"+labelColor+" 1px solid'></div><div class='r2' style='background:"+labelColor+";border-bottom:"+labelColor+" 1px solid'></div></div>"+
				      "</div></span>";
    	}
    	
    	if(!labelStr.equals("")){
    		labelStr = ""+labelStr;
    	}
    	
    	
		if(joinType.equals("1")&&flag!=0)
			flag=1;
		else if(flag!=2)
			flag=0;
    	if(joinType.equals("1")&&flag==1&&disdirect.equals("true")){
    		flag=0;
 %>
		<!-- 直接参与 -->
        <TR class="Header">
           <th colspan="3"><%=SystemEnv.getHtmlLabelName(17691,user.getLanguage())%></th>
           <script>disdirect=false;</script>
        </TR>
 <%   		
    	}
    	if(joinType.equals("0")&&flag==0&&disattention.equals("true")){
    		flag=2;
 %>
        <!-- 关注 -->
        <TR class="Header">
           <th colspan="3"><%=SystemEnv.getHtmlLabelName(17692,user.getLanguage())%></th>
           <script>disattention=false;</script>
        </TR>
 <%}%>
	<tr class="<%=dataLight?"dataLight":"dataDark"%>">
	  <td nowrap style="padding-left: 0px;padding-right: 0px;padding-top: 8px">
		 <input type="checkbox" id="" value=<%=coworkid%> unread="<%=unread %>"  read="<%=read %>" important="<%=important %>" normal="<%=normal %>">
	  </td>
	  <td>
	     <img style="cursor:pointer;padding-left: 0px;padding-right: 0px;" align="absmiddle" onclick="parent.markImportant(this,<%=coworkid%>)" important="<%=important%>" src="<%if(important.equals("true")){%>/cowork/images/importent.gif<%}else{%>/cowork/images/notimportent.gif<%}%>"/>
	  </td>
	  <td onclick="parent.openCowork(this,<%=coworkid%>)" valign="middle"  title="<%=coworkName%>" style="word-break:break-all;cursor:pointer;">
	    <div class="title" style="<%if(unread.equals("true")){%>font-weight:bold<%}%>">
	        <%=statement.getString("name") %>
	    </div>
	    <div class='labelContaner'>
	       <%=labelStr%>
        </div>
	  </td>
	</tr>
 <% 
    dataLight=dataLight?false:true;
    }
}catch(Exception e){
	e.printStackTrace();
}finally{
    statement.close();
}
%>
