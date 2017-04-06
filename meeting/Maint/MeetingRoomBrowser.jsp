<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String fullname = Util.null2String(request.getParameter("fullname"));
String description = Util.null2String(request.getParameter("description"));
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
String subcompanyid= Util.null2String(request.getParameter("subcompanyid"));
int isfrist=Util.getIntValue(request.getParameter("isfrist"),0);

RecordSet.executeSql("select detachable from SystemSet");
int detachable=0;
if(RecordSet.next()){
    detachable=RecordSet.getInt("detachable");
    session.setAttribute("detachable",String.valueOf(detachable));
}
boolean hasRight = false;
if(detachable==1){
    ArrayList subcompanylist=SubCompanyComInfo.getRightSubCompany(user.getUID(),"MeetingRoomAdd:Add");
    String subcompanys="";
    for(int i=0;i<subcompanylist.size();i++){
        subcompanys+=((String)subcompanylist.get(i)+",");
    }
    if(subcompanys.length()>1){
    	hasRight = true;
        subcompanys=subcompanys.substring(0,subcompanys.length()-1);
        if(ishead==0){
            ishead=1;
            sqlwhere="where subcompanyid in("+subcompanys+") ";
        }else{
            sqlwhere+=" and subcompanyid in("+subcompanys+") ";
        }
    }else{
        if(HrmUserVarify.checkUserRight("MeetingRoomAdd:Add",user)){
        	hasRight = true;
        	if(ishead==0){
        		ishead=1;
	        	sqlwhere="where 1=2 ";
        	}else{
        		sqlwhere=" and 1=2 ";
        	}
    	}else{
    	    if(subcompanyid.equals("") && isfrist==0){
    	        if(user.getUID()!=1)  subcompanyid=""+user.getUserSubCompany1();
    	    }
    		if(ishead==0){
        		ishead=1;
	    		sqlwhere="where subcompanyid="+user.getUserSubCompany1()+" ";
    		}else{
    			sqlwhere=" and subcompanyid="+user.getUserSubCompany1()+" ";
    		}
    	}
    }
}
if(!fullname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where name like '%";
		sqlwhere += Util.fromScreen2(fullname,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and name like '%";
		sqlwhere += Util.fromScreen2(fullname,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!description.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where roomdesc like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and roomdesc like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!subcompanyid.equals("")){
    String subcoms=SubCompanyComInfo.getSubCompanyTreeStr(""+subcompanyid);
    if(subcoms.length()>1){
        subcoms=subcoms+subcompanyid;
    }else{
        subcoms=""+subcompanyid;
    }
    if(ishead==0){
		ishead = 1;
		sqlwhere += " where subcompanyid in(" + subcoms+")";
	}
	else
		sqlwhere += " and subcompanyid in(" + subcoms+")";
}
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MeetingRoomBrowser.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="<%=sqlwhere1%>">
<input type="hidden" name="isfrist" value='1'>
<DIV align=right style="display:none">

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=ViewForm>
<TR class=separator style="height: 1px"><TD class=Sep1 colspan=4></TD></TR>
<TR>
<TD width=12%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
<TD width=38% class=field><input class=inputstyle name=fullname value="<%=fullname%>"></TD>
<TD width=12%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
<TD width=38% class=field><input class=inputstyle name=description value="<%=description%>"></TD>
</TR>
<%if(detachable==1){%>
   <TR>
      <TD width=12%><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></TD>
      <TD width=38% class=field>
          <BUTTON class=Browser id=SelectSubCompany onclick="adfonShowSubcompany()" <%if(hasRight==false){%>disabled<%}%>></BUTTON>
          <SPAN id=subcompanyspan name=subcompanyspan>
              <%if(!subcompanyid.equals("")){%><%=SubCompanyComInfo.getSubCompanyname(subcompanyid)%><%}%>
          </SPAN>
        <INPUT class=inputstyle id=subcompanyid type=hidden name=subcompanyid value="<%=subcompanyid%>">
      </TD>
    </TR>
    <%}%>
<TR class=spacing style="height: 1px"><TD class=line1 colspan=4></TD></TR>
</table>
<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 STYLE="margin-top:0" width="100%">
<TR class=DataHeader>
<TH width=10%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TH>
<%if(detachable==1){%><th width=30%><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></th><%}%>
<TH width=30%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
</tr><TR class=Line style="height: 1px"><TH colSpan=4></TH></TR>
<%
int i=0;
sqlwhere = "select * from MeetingRoom "+sqlwhere+ " order by id";
RecordSet.execute(sqlwhere);
while(RecordSet.next()){
	if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
	<%
	}
	%>
	<TD><A HREF=#><%=RecordSet.getString("id")%></A></TD>
	<TD><%=Util.forHtml(RecordSet.getString("name"))%></TD>
    <%if(detachable==1){%><td><%=SubCompanyComInfo.getSubCompanyname(RecordSet.getString("subcompanyid"))%></td><%}%>
    <TD><%=Util.forHtml(RecordSet.getString("roomdesc"))%></TD>
	
</TR>
<%}%>
</TABLE></FORM>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script type="text/javascript">
function adfonShowSubcompany(){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=MeetingRoomAdd:Add&selectedids="+SearchForm.subcompanyid.value,
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	var issame = false
	if (data){
		if (data.id!="0"){
			if (data.id = SearchForm.subcompanyid.value){
				issame = true
			}
			subcompanyspan.innerHTML = data.name
			SearchForm.subcompanyid.value=data.id
		}else{
			subcompanyspan.innerHTML = ""
			SearchForm.subcompanyid.value=""
		}
	}
}

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
		 var id0  = $(this).find("td:first").next().text();
	     id0 = id0.replace("<","&lt;")
	     id0 = id0.replace(">","&gt;")
		window.parent.returnValue = {id:$(this).find("td:first").text(),name:id0};
			window.parent.close()
		})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})

})


function submitClear()
{
	window.parent.returnValue = {id:"",name:""};
	window.parent.close()
}

</script>
</BODY></HTML>

