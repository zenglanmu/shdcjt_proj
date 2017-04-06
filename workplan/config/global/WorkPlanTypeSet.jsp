<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ include file="/systeminfo/init.jsp" %>

<%@ page import="weaver.general.Util" %>

<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />

<%
    if(!HrmUserVarify.checkUserRight("WorkPlanTypeSet:Set", user))
    {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }	
%>

<HTML>
<HEAD>
	<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
	<SCRIPT language="javascript" src="/js/weaver.js"></SCRIPT>
	<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog.js"></script>
	<style>
		.colorPicker{vertical-align:middle;margin-left:4px;cursor:pointer}
		.colorPane td{padding:0 !important;height:18px;};
	</style>
</HEAD>

<BODY>
<!--============================= 标题栏：设置:日程类型 =============================-->
<%
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(19653, user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(16094, user.getLanguage());
    String needhelp ="";
    String needfav = "";
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>


<!--============================= 右键菜单开始 =============================-->
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    RCMenu += "{" + SystemEnv.getHtmlLabelName(86,user.getLanguage()) + ",javascript:doSave(this),_self}";
    RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
   	<COLGROUP>
     	<COL width="10">
	    <COL width="">
	    <COL width="10">
   	<TR>
       	<TD height="10" colspan="3"></TD>
       </TR>
   	<TR>
       	<TD ></TD>
       	<TD valign="top">
     
       		<TABLE class=Shadow >
				<TR>
            		<TD valign="top">
            			<TABLE width=100%>
            				<TR>
            					<TD align=right>
            						<BUTTON Class=Btn type=button accessKey=A onClick="addRow()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
            						<BUTTON Class=Btn type=button accessKey=E onClick="removeRow()"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
            					</TD>
            				</TR>
          				</TABLE>
            		
              			<FORM name="weaver" action="WorkPlanTypeSetOperation.jsp" method="post">                                    
                   			<!--============================= 日程类型显示开始 =============================-->
                        	<TABLE class="listStyle" id="oTable" name="oTable">
                            	<COLGROUP>
		                            <COL width="7%" align="center">
		                            <COL width="53%" align="left">
		                            <COL width="25%" align="center">
		                            <COL width="15%" align="center">
		                        <TR class="header">
		                            <TD align="center"><INPUT type="checkbox" name="chkAll" onClick="chkAllClick(this)"></TD>
		                            <TD align="center"><%=SystemEnv.getHtmlLabelName(19774,user.getLanguage())%></TD>
		                            <TD align="center"><%=SystemEnv.getHtmlLabelName(495,user.getLanguage())%></TD>
		                            <TD align="center"><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></TD>
		                        </TR>
		                        <TR class=line>
                            		<TD ColSpan=4></TD>
                          		</TR>
		                                             		
                        	</TABLE>
                    		<!--============================= 日程类型显示结束 =============================-->
              			</FORM>
            		</TD>
          		</TR>	
       		</TABLE> 
             
   		</TD>
   		<TD></TD>
   	</TR>
   	<TR>
   		<TD height="10" COLspan="3"></TD>
   	</TR>
   	
</TABLE>

</BODY>
</HTML>
<style tyle="text/css">
	.colorBox{
		color:red;
		position:absolute;
		top:0;
	}
</style>
<SCRIPT LANGUAGE="JavaScript">
function checkItems(receive,checkItem)
  {
      var　temp　=　-1;　　
　　　　for　(var　i=0;　i<receive.length;　i++){
　　　　　　　　if　(receive[i].value==checkItem.value){
　　　　　　　　　　　　temp　=　i;
　　　　　　　　　　　　break;
　　　　　　　　}
　　　　}
　　　　return　temp;
   }

   function ifRepeat(receive)
  {
      var flag = false;
　　　　var　arrResult　=　new　Array();
      arrResult.push(receive[0]);　
　　　　for　(var　i=1;　i<receive.length;　i++){
　　　　　　　　if　(checkItems(arrResult,receive[i])　==　-1){　
　　　　　　　　　　　 arrResult.push(receive[i]);
　　　　　　　　}else{
                 flag = true;
                 break;
             }
　　　　}
　　　　return　flag;
   }
</SCRIPT>
<SCRIPT LANGUAGE="JavaScript">

	function addRow()
    {        
        var oRow = oTable.insertRow(-1);
        var oRowIndex = oRow.rowIndex;

        if (0 == oRowIndex % 2)
        {
            oRow.className = "dataLight";
        }
        else
        {
            oRow.className = "dataDark";
        }
		
		/*============ 选择 ============*/
        var oCell = oRow.insertCell(-1);
        var oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT type='checkbox' name='workPlanTypeID'><INPUT type='hidden' name='workPlanTypeIDs' value='-1'>";                        
        oCell.appendChild(oDiv);
        
        /*============ 名称 ============*/
        oCell = oRow.insertCell(-1);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT class='Inputstyle' maxlength='80' type='text' name='workPlanTypeName' size='55' value='' onBlur='setworkPlanTypeName(this)'><SPAN><IMG src='/images/BacoError.gif' align=absmiddle></SPAN>";                        
        oCell.appendChild(oDiv);
        
        /*============ 颜色 ============*/
        oCell = oRow.insertCell(-1);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<TABLE class='colorPane'><colgroup><col width='0'><col width='16'><col width='60'></colgroup><TR><TD rowspan='2'><INPUT type='hidden' class='InputStyle' maxlength='7' size='10' id='color' name='color' value='1' onBlur='setMenubarBgColor(this)'/></TD><TD><IMG src='/images/ColorPicker.gif' class='colorPicker' onClick='getColorFromColorPicker(this);'></TD><TD id='menubarBgColor' style='height:4px;background-color:"+getColor(1,0)+";'></TD></TR></TABLE>";                 
        //alert(oDiv.innerHTML);
        oCell.appendChild(oDiv);
        
        /*============ 启用 ============*/
        oCell = oRow.insertCell(-1);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT type='checkbox' onClick='setAvailable(this)'><INPUT type='hidden' name='available' value='0'>";                        
        oCell.appendChild(oDiv);
    }
        
    function removeRow()
    {
    	if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>"))
    	{
	        var chks = document.getElementsByName("workPlanTypeID");
	       
	        for (var i = chks.length - 1; i >= 0; i--)
	        {
	            var chk = chks[i];
	            //alert(chk.parentElement.parentElement.parentElement.rowIndex);
	            if (chk.checked)
	            {
	                oTable.deleteRow(chk.parentElement.parentElement.parentElement.rowIndex)
	            }
	        }
	    }
    }
    
    function setAvailable(o)
    {
        
    	if(o.checked)
    	{
    		o.parentElement.lastChild.value = "1";
    	}
    	else
    	{
    		o.parentElement.lastChild.value = "0";
    	}
    }
    
    function chkAllClick(obj)
    {
        var chks = document.getElementsByName("workPlanTypeID");
        
        for (var i = 0; i < chks.length; i++)
        {
            var chk = chks[i];
            
            if(false == chk.disabled)
            {
            	chk.checked = obj.checked;
            }
        }
    }
    
    function doSave(obj)
    {    	
    	if(checkFormInput(weaver, "workPlanTypeName","color","workplanname", "wcolor"))
    	{
			var name = document.getElementsByName('workPlanTypeName');
		    if(ifRepeat(name)){
		       alert('<%=SystemEnv.getHtmlLabelName(21943,user.getLanguage())%>!');
		       return;
		    }
    		obj.disabled = true;
        	document.weaver.submit();
        }
    }
    

	function checkFormInput(checkForm, checkItems, checkSpecialItems)
	{
		var thisForm = checkForm;
		var checkItems = checkItems + ",";
		var checkSpecialItems = checkSpecialItems + ",";
		
		for(var i = 1; i <= thisForm.length; i++)
		{
			var tmpName = thisForm.elements[i-1].name;
			var tmpValue = thisForm.elements[i-1].value;
			
			while(0 == tmpValue.indexOf(" "))
			{
				tmpValue = tmpValue.substring(1, tmpValue.length);
			}
		
			if("" != tmpName && ((-1 != checkItems.indexOf(tmpName+",") && "" == tmpValue) || (-1 != checkSpecialItems.indexOf(tmpName+",") && "#" == tmpValue)))
			{
				alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
			 	return false;
			}
		}
		return true;
	}

	function checkRepetitiveColor(inputColor, nowColor)
	//检测所选颜色是否可以使用  true：可以使用输入颜色  false：不可以使用输入颜色
	{
		var count = 0;
		var total = 1;
		var inputColor = inputColor.toUpperCase();
		var nowColor = nowColor.toUpperCase();

		for(var i = 1; i <= weaver.length; i++)
		{
			var tmpName = weaver.elements[i-1].name;
			var tmpValue = weaver.elements[i-1].value.toUpperCase();

			if("color" == tmpName && "#" != tmpValue && inputColor == tmpValue)
			{
				if(inputColor == nowColor && count < total)
				{
					count++;
				}
				else
				{
					alert("<%=SystemEnv.getHtmlLabelName(19778,user.getLanguage())%>");
				 	return false;
				}
			}
		}
		return true;
	}

	function setworkPlanTypeName(o)
	{
		if("" != o.value)
		{
			o.parentElement.lastChild.innerHTML = "";  //去除必须输入符号
		}
		else
		{
			o.parentElement.lastChild.innerHTML = "<IMG src='/images/BacoError.gif' align=absmiddle>";  //增加必须输入符号
		}
	}
	
	function setMenubarBgColor(o)
    {
    	var reg = /^#(([a-f]|[A-F]|\d){6})$/;
		//);
		if(!reg.test(o.value))
		{
			alert("<%=SystemEnv.getHtmlLabelName(19777,user.getLanguage())%>");			
			jQuery(o).parent().parent().parent().children(":last-child").children(":first-child")[0].style.backgroundColor = "";  //颜色显示
			jQuery(o).parent().parent().parent().children(":first-child").children(":first-child").children(":first-child").text("#");  //数据输入
			jQuery(o).parent().parent().parent().children(":first-child").children(":first-child").children(":last-child")[0].innerHTML = "<IMG src='/images/BacoError.gif' align=absmiddle>";  //增加必须输入符号
		}
		else if(!checkRepetitiveColor(o.value, o.value))
		{
			jQuery(o).parent().parent().parent().children(":last-child").children(":first-child")[0].style.backgroundColor = "";  //颜色显示
			jQuery(o).parent().parent().parent().children(":first-child").children(":first-child").children(":first-child").text("#");  //数据输入
			jQuery(o).parent().parent().parent().children(":first-child").children(":first-child").children(":last-child")[0].innerHTML = "<IMG src='/images/BacoError.gif' align=absmiddle>";  //增加必须输入符号		
		}
		else
		{
			jQuery(o).parent().parent().parent().children(":last-child").children(":first-child")[0].style.backgroundColor = o.value;  //颜色显示
    		jQuery(o).parent().parent().parent().children(":first-child").children(":first-child").children(":last-child")[0].innerHTML = "";  //去除必须输入符号    	
		}		
	}
		 
    function getColorFromColorPicker(o)
    {
    	
		var colorPane=$(o).parents(".colorPane")[0];
		var cells=colorPane.rows[0].cells;
		
		var dialog=new Dialog();
		dialog.URL="WorkplanThemeBrowser.jsp?themeId="+$(cells[0]).find("input").val();
		dialog.Height=320;
		dialog.Width=480;
		dialog.OKEvent=function(){
			value=dialog.innerFrame.contentWindow.document.getElementsByName('themeid')[0].value;
			$(cells[0]).find("input").val(value);
			$(cells[2]).css("background",getColor(value,0));
			dialog.close();
		}
		dialog.show();
		
	}
	
	function initOverPlan()
	{
		<%
			String sql = "select * from overworkplan";
			recordSet.executeSql(sql);
			while (recordSet.next()) 
			{
				String workPlanID = recordSet.getString("id");
				String workplanname = recordSet.getString("workplanname");
				String workplancolor = recordSet.getString("workplancolor");
				String wavailable = recordSet.getString("wavailable");
				
		%>
		var oRow = oTable.insertRow(-1);
        var oRowIndex = oRow.rowIndex;

        if (0 == oRowIndex % 2)
        {
            oRow.className = "dataLight";
        }
        else
        {
            oRow.className = "dataDark";
        }
	
		/*============ 选择 ============*/
        var oCell = oRow.insertCell(-1);
        var oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT type='checkbox' disabled='true' name='workPlanID'><INPUT type='hidden' name='workPlanIDs' value='<%=workPlanID%>'>";                        
        oCell.appendChild(oDiv);
        
        /*============ 名称 ============*/
        oCell = oRow.insertCell(-1);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT class='Inputstyle' type='text' name='workplanname' size='55' value='<%=workplanname%>' readonly onBlur='setworkPlanTypeName(this)'><SPAN></SPAN>";                        
        oCell.appendChild(oDiv);
        
        /*============ 颜色 ============*/
        oCell = oRow.insertCell(-1);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<TABLE class='colorPane'><colgroup><col width='0'><col width='16'><col width='60'></colgroup><TR><TD rowspan='2'><INPUT type='hidden' class='InputStyle' maxlength='7' size='10' id='wcolor' name='wcolor' value='<%=workplancolor%>' onBlur='setMenubarBgColor(this)'/><SPAN></SPAN></TD><TD><IMG src='/images/ColorPicker.gif' class='colorPicker' onClick='getColorFromColorPicker(this);'></TD><TD id='menubarBgColor' style='height:4px;background-color:"+getColor(<%=workplancolor%>,0)+";'></TD></TR></TABLE>";                 
        oCell.appendChild(oDiv);
        
        /*============ 启用 ============*/
        oCell = oRow.insertCell(-1);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT type='checkbox' onClick='setAvailable(this)' <%if("1".equals(wavailable)){%>checked='true'<%}%>><INPUT type='hidden' name='wavailable' value='<%=wavailable%>'>";                        
        oCell.appendChild(oDiv);
		<%
			}
		%>
	}
	function init()
	{
<%
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("SELECT DISTINCT workPlanType.*, workPlan.type_n");
		stringBuffer.append(" FROM WorkPlanType workPlanType");
		stringBuffer.append(" LEFT JOIN WorkPlan workPlan");
		stringBuffer.append(" ON workPlanType.workPlanTypeId = workPlan.type_n");
		stringBuffer.append(" ORDER BY workPlanType.displayOrder ASC");
		recordSet.executeSql(stringBuffer.toString());
		
		while (recordSet.next()) 
		{
            int attribute = recordSet.getInt("workPlanTypeAttribute");
            String available = recordSet.getString("available");
            String typeUsed = recordSet.getString("type_n");
            boolean used = (null == typeUsed || "".equals(typeUsed)) ? false : true;
%>
			var oRow = oTable.insertRow(-1);
	        var oRowIndex = oRow.rowIndex;
	
	        if (0 == oRowIndex % 2)
	        {
	            oRow.className = "dataLight";
	        }
	        else
	        {
	            oRow.className = "dataDark";
	        }
		
			/*============ 选择 ============*/
	        var oCell = oRow.insertCell(-1);
	        var oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT type='checkbox' name='workPlanTypeID' <%= checkRightCheckBox(used, attribute) %> ><INPUT type='hidden' name='workPlanTypeIDs' value='<%= recordSet.getInt("workPlanTypeID") %>'>";                        
	        oCell.appendChild(oDiv);
	        
	        /*============ 名称 ============*/
	        oCell = oRow.insertCell(-1);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT class='Inputstyle' maxlength='80' type='text' name='workPlanTypeName' size='55' value=\"<%= Util.toHtml(Util.null2String(recordSet.getString("workPlanTypeName")).replace("\\","\\\\"),false) %>\" onBlur='setworkPlanTypeName(this)' <%= checkRightInput(attribute) %> ><SPAN></SPAN>";                        
	        oCell.appendChild(oDiv);
	        
	        /*============ 颜色 ============*/
	        oCell = oRow.insertCell(-1);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<TABLE class='colorPane'><colgroup><col width='0'><col width='16'><col width='60'></colgroup><TR><TD rowspan='2'><INPUT type='hidden' class='InputStyle' maxlength='7' size='10' id='color' name='color' value='<%= recordSet.getString("workPlanTypeColor") %>' onBlur='setMenubarBgColor(this)' <%= checkRightColorInput(attribute) %>/><SPAN></SPAN></TD><TD><IMG src='/images/ColorPicker.gif' class='colorPicker' <%= checkRightColorpallette(attribute) %> ></TD><TD id='menubarBgColor' style='height:4px;background-color:"+getColor(<%= recordSet.getString("workPlanTypeColor") %>,0)+";'></TD></TR></TABLE>";                 
	        oCell.appendChild(oDiv);
	        
	        /*============ 启用 ============*/
	        oCell = oRow.insertCell(-1);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT type='checkbox' <%= checkRightValidCheckBox(attribute) %> onClick='setAvailable(this)' <% if("1".equals(available)) { %> checked='true'<% } %>><INPUT type='hidden' name='available' value='<% if("1".equals(available)) { %>1<% } else { %>0<% } %>'>";                        
	        oCell.appendChild(oDiv);
<%
		}
		
		String note = (String)request.getAttribute("note");
		if(null != note && !"".equals(note))
		{
%>
			alert("<%= note %>");
<%
		}
%>
	}
	initOverPlan();
	init();

	function getColor(i,j){
		
		var  d = "666666888888aaaaaabbbbbbdddddda32929cc3333d96666e69999f0c2c2b1365fdd4477e67399eea2bbf5c7d67a367a994499b373b3cca2cce1c7e15229a36633cc8c66d9b399e6d1c2f029527a336699668cb399b3ccc2d1e12952a33366cc668cd999b3e6c2d1f01b887a22aa9959bfb391d5ccbde6e128754e32926265ad8999c9b1c2dfd00d78131096184cb05288cb8cb8e0ba52880066aa008cbf40b3d580d1e6b388880eaaaa11bfbf4dd5d588e6e6b8ab8b00d6ae00e0c240ebd780f3e7b3be6d00ee8800f2a640f7c480fadcb3b1440edd5511e6804deeaa88f5ccb8865a5aa87070be9494d4b8b8e5d4d47057708c6d8ca992a9c6b6c6ddd3dd4e5d6c6274878997a5b1bac3d0d6db5a69867083a894a2beb8c1d4d4dae54a716c5c8d8785aaa5aec6c3cedddb6e6e41898951a7a77dc4c4a8dcdccb8d6f47b08b59c4a883d8c5ace7dcce";
		
		return "#" + d.substring(i * 30 + j * 6, i * 30 + (j + 1) * 6);
	
	}
</SCRIPT>

<%!
	/*
	 *	7：标题无  颜色无  启用删除无 
	 *  6：标题无  颜色可  启用删除无 
	 *  0：标题可  颜色可  启用删除可 
	 *
	 */
	public String checkRightCheckBox(boolean used, int rightLevel)
	{
		if(used)
		{
			return " disabled='true' ";
		}
		else if(7 == rightLevel)
		{
			return " disabled='true' ";
		}
		else if(6 == rightLevel)
		{
			return " disabled='true' ";
		}
		else if(0 == rightLevel)
		{
			return "";
		}

		return "";
	}

	/*
	 *	7：标题无  颜色无  启用删除无 
	 *  6：标题无  颜色可  启用删除无 
	 *  0：标题可  颜色可  启用删除可 
	 *
	 */
	public String checkRightValidCheckBox(int rightLevel)
	{
		if(7 == rightLevel)
		{
			return " disabled='true' ";
		}
		else if(6 == rightLevel)
		{
			return " disabled='true' ";
		}
		else if(0 == rightLevel)
		{
			return "";
		}

		return "";
	}
	
	/*
	 *	7：标题无  颜色无  启用删除无 
	 *  6：标题无  颜色可  启用删除无 
	 *  0：标题可  颜色可  启用删除可 
	 *
	 */
	public String checkRightInput(int rightLevel)
	{
		if(7 == rightLevel)
		{
			return " readonly ";
		}
		else if(6 == rightLevel)
		{
			return " readonly ";
		}
		else if(0 == rightLevel)
		{
			return "";
		}
		
		return "";	
	}
	
	/*
	 *	7：标题无  颜色无  启用删除无 
	 *  6：标题无  颜色可  启用删除无 
	 *  0：标题可  颜色可  启用删除可 
	 *
	 */
	public String checkRightColorInput(int rightLevel)
	{
		if(7 == rightLevel)
		{
			return " readonly ";
		}
		else if(6 == rightLevel)
		{
			return "";
		}
		else if(0 == rightLevel)
		{
			return "";
		}

		return "";	
	}
	
	/*
	 *	7：标题无  颜色无  启用删除无 
	 *  6：标题无  颜色可  启用删除无 
	 *  0：标题可  颜色可  启用删除可 
	 *
	 */
	public String checkRightColorpallette(int rightLevel)
	{
		if(7 == rightLevel)
		{
			return "";
		}
		else if(6 == rightLevel)
		{
			return " onClick='getColorFromColorPicker(this);' ";
		}
		else if(0 == rightLevel)
		{
			return " onClick='getColorFromColorPicker(this);' ";
		}

		return "";	
	}
%>
