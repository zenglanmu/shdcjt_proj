<%@ page language="java" contentType="text/html; charset=gbk" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="chk" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<%
int[] ids = chk.getSubComByUserEditRightId(user.getUID(), "Album:Maint");

//如果系统未启用分权管理，而当前用户没有相册维护权限，则可查看分部调整为空
rs.executeSql("select detachable from SystemSet");
int detachable=0;
if(rs.next()){
	detachable=rs.getInt("detachable");
}

if(detachable!=1){
	if(!HrmUserVarify.checkUserRight("Album:Maint", user)){
		ids=new int[0];
	}
}

String _ids = ",";
for(int i=0;i<ids.length;i++){
	_ids += ids[i] + ",";
}

String imagefilename = "/images/hdMaintenance.gif";
//String titlename = "" + SystemEnv.getHtmlLabelName(20207,user.getLanguage());
String titlename = "" + SystemEnv.getHtmlLabelName(20290,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<html>
<head>
<title></title>
<link rel="stylesheet" type="text/css" href="/css/Weaver.css" />
<style>

</style>
<script type="text/javascript" src="/js/weaver.js"></script>
<script type="text/javascript">

</script>
</head>

<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table style="width:100%;height:92%;border-collapse:collapse">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td valign="top">
		<table class="Shadow">
		<colgroup>
			<col width="10"/>
			<col width=""/>
			<col width="10"/>
		</colgroup>
		<tr>
		<td></td>
		<td valign="top">
<!--==========================================================================================-->
<table class="liststyle" cellspacing="1">
<tr class="header">
<td style="width:25%"><%=SystemEnv.getHtmlLabelName(20003,user.getLanguage())%></td>
<td style="width:15%"><%=SystemEnv.getHtmlLabelName(20004,user.getLanguage())%>(MB)</td>
<td style="width:15%"><%=SystemEnv.getHtmlLabelName(20005,user.getLanguage())%>(MB)</td>
<td style="width:15%"><%=SystemEnv.getHtmlLabelName(20006,user.getLanguage())%>(MB)</td>
<td style="width:30%"><%=SystemEnv.getHtmlLabelName(20007,user.getLanguage())%></td>
</tr>
<tr class="Line"><td colspan="5"></td></tr>
<%
int i = 0;
String subcompanyId = "";
String subcompanyName = "";
double albumSize=0,albumSizeUsed=0.0,albumSizeFree=0.0;
double albumSizePercent=0.00;
String strAlbumSize = "0";
String _albumSizeUsed = "0.00";
String _albumSizePercent = "0.00";
//rs.executeSql("SELECT a.*,b.* FROM HrmSubcompany a LEFT JOIN AlbumSubcompany b ON a.id=b.subcompanyId WHERE a.supsubcomid=0 ORDER BY showOrder");
rs.executeSql("SELECT distinct a.*,b.* FROM HrmSubcompany a LEFT JOIN AlbumSubcompany b ON a.id=b.subcompanyId  ORDER BY showOrder");
while(rs.next()){
	subcompanyId = rs.getString("id");
	if(_ids.indexOf(","+subcompanyId+",")==-1&&!subcompanyId.equals(""+user.getUserSubCompany1())) continue;
	
	String cancelstr = rs.getString("canceled");
	if("1".equals(cancelstr)) continue;
	
	subcompanyName = rs.getString("subcompanyname");
	_albumSizeUsed = Util.null2String(rs.getString("albumSizeUsed"));
	albumSize = Double.parseDouble(rs.getString("albumSize"))/1000;
	strAlbumSize = String.valueOf(albumSize);
	strAlbumSize = strAlbumSize.substring(0,strAlbumSize.indexOf("."));
	albumSizeUsed = _albumSizeUsed.equals("") ? 0.00 : Double.parseDouble(rs.getString("albumSizeUsed"))/1000;
	albumSizeFree = albumSize-albumSizeUsed;
	albumSizePercent = Double.parseDouble(String.valueOf(albumSizeUsed))/Double.parseDouble(String.valueOf(albumSize))*100;
	_albumSizePercent = Util.round(String.valueOf(albumSizePercent), 2);
%>
<tr <%if((i%2)!=0){out.println("style='background-color:#EEE'");}%> height="20">
<td><%=subcompanyName%></td>
<td><%=strAlbumSize%></td>
<td><%=Util.round(String.valueOf(albumSizeUsed),3)%></td>
<td><%=Util.round(String.valueOf(albumSizeFree),3)%></td>
<td>
	<table style="wdith:100%;border-collapse:collapse;">
	<tr>
	<td>
		<table style="width:200px;border:1px solid #000;height:14px;border-collapse:collapse;margin-top:3px">
		<tr>
			<td style="background-image:url(/images/percentBarGreen.gif)" width="<%=albumSizePercent%>%"></td>
			<td style="background-color:#FFF" width="<%=100-albumSizePercent%>%"></td>
		</tr>
		</table>
	</td>
	<td><%=_albumSizePercent%>%</td>
	</table>
</td>
</tr>
<%i++;}%>
</table>
<!--==========================================================================================-->
		</td>
		<td></td>
		</tr>
		</table>
	</td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
</body>
</html>
