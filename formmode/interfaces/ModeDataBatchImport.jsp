<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.file.*," %>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="FieldInfo" class="weaver.formmode.data.FieldInfo" scope="page"/>
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<HTML>
<%
	
	String imagefilename = "/images/hdMaintenance.gif";
	String titlename = SystemEnv.getHtmlLabelName(26601, user.getLanguage());
	String needfav = "";
	String needhelp = "";
	
	int modeid = Util.getIntValue(request.getParameter("modeid"),0);
	String flag = Util.null2String(request.getParameter("flag"));
	String msg = Util.null2String((String)session.getAttribute(flag));
	int type = 4;//批量导入权限
	if(type == 4){//监控权限判断
		ModeRightInfo.setModeId(modeid);
		ModeRightInfo.setType(type);
		ModeRightInfo.setUser(user);
		boolean isRight = false;
		isRight = ModeRightInfo.checkUserRight(type);
		if(!isRight){
			if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
				response.sendRedirect("/notice/noright.jsp");
				return;
			}
		}
	}
%>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
    <SCRIPT language="javascript" src="/js/weaver.js"></script>
	<style>
		#loading{
		    position:absolute;
		    left:45%;
		    background:#ffffff;
		    top:40%;
		    padding:8px;
		    z-index:20001;
		    height:auto;
		    border:1px solid #ccc;
		}
	</style>
</HEAD>
<body>
<%
    
    String sql = "";
    String modename = "";
    int formid = 0;
    if(modeid > 0){
    	sql = "select * from modeinfo where Id="+modeid;
    	rs.executeSql(sql);
    	if(rs.next()){
    		formid = rs.getInt("formid");
    		modename = Util.null2String(rs.getString("modename"));
    		
    		ArrayList editfields=new ArrayList();//可编辑字段
    		
    		sql = "select * from workflow_billfield where billid="+formid+" order by viewtype asc,detailtable asc";
    		rs.executeSql(sql);
    		while(rs.next()){
    			editfields.add("field"+rs.getString("fieldid"));
    		}
    		ExcelSheet es = null;
    		ExcelFile.init() ;
    		ExcelFile.setFilename(modename) ;
    		ExcelStyle ess = ExcelFile.newExcelStyle("Header") ;
    		ess.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
            ess.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
            ess.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
            ess.setAlign(ExcelStyle.WeaverHeaderAlign) ;
            
            FieldInfo.setUser(user);
            FieldInfo.GetManTableField(formid, 1, user.getLanguage());//获得主字段
            ArrayList ManTableFieldlabel = FieldInfo.getManTableFieldlabel();
            ArrayList ManTableFieldHtmltypes = FieldInfo.getManTableFieldHtmltypes();
            es = new ExcelSheet() ;   // 初始化一个EXCEL的sheet对象
            ExcelRow er = es.newExcelRow () ;
            es.addColumnwidth(6000);
            er.addStringValue("ID","Header");
            for(int i=0;i<ManTableFieldlabel.size();i++){
            	String htmlyype = Util.null2String((String)ManTableFieldHtmltypes.get(i));
            	if(htmlyype.equals("6") || htmlyype.equals("7")) continue;
                String label = Util.null2String((String)ManTableFieldlabel.get(i));
                es.addColumnwidth(6000);
                er.addStringValue(label,"Header");
                es.addExcelRow(er);//加入一行
            }
            ExcelFile.addSheet(SystemEnv.getHtmlLabelName(21778, user.getLanguage()), es) ; //为EXCEL文件插入一个SHEET
            
            FieldInfo.GetDetailTableField(formid, 1, user.getLanguage());//获得明细字段
            ArrayList detailtablefieldlables=FieldInfo.getDetailTableFieldNames();
            ArrayList detailtablefieldids=FieldInfo.getDetailTableFields();
            for(int i=0;i<detailtablefieldlables.size();i++){
                es = new ExcelSheet() ;   // 初始化一个EXCEL的sheet对象
                er = es.newExcelRow () ;  //准备新增EXCEL中的一行
                es.addColumnwidth(6000);
                er.addStringValue("MAINID","Header");
                ArrayList detailfieldnames=(ArrayList)detailtablefieldlables.get(i);
                ArrayList detailfieldids=(ArrayList)detailtablefieldids.get(i);
                boolean hasfield=false;
                for(int j=0;j<detailfieldids.size();j++){
                    //以下为EXCEL添加多个列
                    es.addColumnwidth(6000);
                    er.addStringValue((String)detailfieldnames.get(j),"Header");
                    hasfield=true;
                }
                if(hasfield){
                    es.addExcelRow(er) ;   //加入一行
                    ExcelFile.addSheet(SystemEnv.getHtmlLabelName(17463, user.getLanguage())+(i+1), es) ; //为EXCEL文件插入一个SHEET
                }
            }
    	}
    }
    
%>

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    //RCMenu += "{" + SystemEnv.getHtmlLabelName(18596, user.getLanguage()) + ",javascript:onSave(this),_self} ";
    //RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<div id="loading" style="display:none">
	<span><img src="/images/loading2.gif" align="absmiddle"></span>
	<!-- 数据导入中，请稍等... -->
	<span  id="loading-msg"><%=SystemEnv.getHtmlLabelName(28210,user.getLanguage())%></span>
</div>

<div id="content">
	<table width=100% height=90% border="0" cellspacing="0" cellpadding="0">
	<colgroup>
		<col width="10">
		<col width="">
		<col width="10">
	</colgroup>
	<tr>
	    <td height="10" colspan="3"></td>
	</tr>
	<tr>
		<td></td>
		<td valign="top">
			<TABLE class=Shadow>
				<tr>
					<td valign="top">
						<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
						<form name="detailimportform" method="post" action="/formmode/interfaces/ModeDataBatchImportOperation.jsp" enctype="multipart/form-data">
							<input type=hidden name="modeid" value="<%=modeid%>">
							<TABLE class=viewform cellspacing=1 id="freewfoTable" width="100%">
								<colgroup>
								    <col width="20%">
								    <col width="80%">
							    </colgroup>
								<TBODY>
									<TR>
									    <TD>1、<%=SystemEnv.getHtmlLabelName(258, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(64, user.getLanguage())%></TD>
									    <TD class="Field"><a href="/weaver/weaver.file.ExcelOut" style="color:blue;"><%=modename%></a></TD>
									</TR>
									<TR class="Spacing">
									    <TD class="Line" colspan="2"></TD>
									</TR>
									<TR>
									    <TD>2、<%=SystemEnv.getHtmlLabelName(16630, user.getLanguage())%></TD>
									    <TD class="Field"><input type="file" name="excelfile" size="35"></TD>
									</TR>
									<TR class="Spacing">
									    <TD class="Line1" colspan="2"></TD>
									</TR>
									<tr>
										<td>
											<!-- 导入 -->
											3、<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>
										</td>
										<td class=Field>
											<button type=BUTTON  class=btnSave onclick="onSave(this);" title="<%=SystemEnv.getHtmlLabelName(25649,user.getLanguage())%>">
												<!-- 开始导入-->
												<%=SystemEnv.getHtmlLabelName(25649,user.getLanguage())%>
											</button>
										</td>
									</tr>
									<TR class=Spacing style="height:1px;">
										<TD class=Line colSpan=2></TD>
									</TR>
									<%
										if(!flag.equals("") && msg.equals("")){
									%>
										<tr>
											<td><%=SystemEnv.getHtmlLabelName(24960,user.getLanguage())%></td>
											<td><font color="red"><%=SystemEnv.getHtmlLabelName(28450,user.getLanguage())%></font></td>
										</tr>
										<TR class="Spacing">
										    <TD class="Line" colspan="2"></TD>
										</TR>
									<%
										}else if(!msg.equals("")) {
									%>
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(24960,user.getLanguage())%></td>
												<td><font color="red"><%=msg.replace("\\n", "<br>") %></font></td>
											</tr>
											<TR class="Spacing">
											    <TD class="Line" colspan="2"></TD>
											</TR>
									<%
										}
									%>
									<TR>
									    <TD colspan="2">
									        <br><b><%=SystemEnv.getHtmlLabelName(27577, user.getLanguage())%>：</b><br>
									        <!-- 
									        1）请先下载<a href="/weaver/weaver.file.ExcelOut" style="color:blue;"><%=modename%></a>模板进行填写导入表单内容，第一行为表单字段的名称。<br>
									        2）请在第2步中选择填写好的Excel文件，并点击开始导入。<br>
									        3）点击"开始导入"。<br><br>
									        <b><%=SystemEnv.getHtmlLabelName(27581, user.getLanguage())%></b><br>
									        1）模板中第一行为表单字段名称，从第二行开始填写需要导入的数据。<br>
									        2）数据之间不能有空行。<br>
									        3）主字段为一个SHEET页，如果有明细时模板中会有多个SHEET，一个明细一个SHEET。<br>
									        4）每条主数据都有一个ID字段，同时每条明细数据里面都有MAINID字段，这两个字段的作用为明细数据和主数据的关联关系，ID的值必须为数字或者字母。<br>
									        5）数字类型字段不要有特殊格式，例如：科学计数法，千分位，货币符号等。<br>
									        6）浏览类型字段直接输入名称，例如：人力资源字段直接输入人员名称。<br>
									        7）check类型字段输入"1/0"或"是/否"。<br>
									        8）下拉选择框类型字段输入下拉选择框显示名称。<br>
									         -->

									        1）<%=SystemEnv.getHtmlLabelName(27578, user.getLanguage())%><a href="/weaver/weaver.file.ExcelOut" style="color:blue;"><%=modename%></a><%=SystemEnv.getHtmlLabelName(30765, user.getLanguage())%><br>
									        2）<%=SystemEnv.getHtmlLabelName(30766, user.getLanguage())%><br>
									        3）<%=SystemEnv.getHtmlLabelName(30767, user.getLanguage())%><br><br>
									        <b><%=SystemEnv.getHtmlLabelName(27581, user.getLanguage())%></b><br>
									        1）<%=SystemEnv.getHtmlLabelName(30768, user.getLanguage())%><br>
									        2）<%=SystemEnv.getHtmlLabelName(30769, user.getLanguage())%><br>
									        3）<%=SystemEnv.getHtmlLabelName(30770, user.getLanguage())%><br>
									        4）<%=SystemEnv.getHtmlLabelName(30771, user.getLanguage())%><br>
									        5）<%=SystemEnv.getHtmlLabelName(27587, user.getLanguage())%><br>
									        6）<%=SystemEnv.getHtmlLabelName(27588, user.getLanguage())%><br>
									        7）<%=SystemEnv.getHtmlLabelName(30774, user.getLanguage())%><br>
									        8）<%=SystemEnv.getHtmlLabelName(27590, user.getLanguage())%><br>
									    </TD>
									</TR>
								</TBODY>
							</TABLE>
						</form>
					</td>
				</tr>
			</TABLE>
		</td>
		<td></td>
	</tr>
	<tr>
	    <td height="10" colspan="3"></td>
	</tr>
	</table>
</div>

<script language=javascript>
	$(document).ready(function(){//onload事件
		$(".loading", window.parent.document).hide(); //隐藏加载图片
		if($("#modeid").val()=='0'){
			if(confirm("<%=SystemEnv.getHtmlLabelName(30776,user.getLanguage())%>")){
				window.parent.document.getElementById('modeBasicTab').click();
			}else{
				$('.href').hide();
			}
		}
	});

    function onSave(obj) {
        var fileName=$G("excelfile").value;
		if(fileName!=""&&fileName.length>4){
			if(fileName.substring(fileName.length-4).toLowerCase()!=".xls"){
				alert('<%=SystemEnv.getHtmlLabelName(20890,user.getLanguage())%>');
				return;
			}
			jQuery("#loading").show();
			jQuery("#content").hide();
			$G("detailimportform").submit();//上传文件
            obj.disabled=true;
		}else{
            alert('<%=SystemEnv.getHtmlLabelName(20890,user.getLanguage())%>');
        }
    }

    function onClose() {
        window.parent.close();
    }

</script>
</body>
</html>
