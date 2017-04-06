<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%
int filterlevel = Util.getIntValue(request.getParameter("level"),0);

int filterfeetype = 0;
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
if(sqlwhere.indexOf("feetype='1'")>0) filterfeetype=1;
else if(sqlwhere.indexOf("feetype='2'")>0) filterfeetype=2;
if(filterfeetype>0&&filterlevel==0) filterlevel=3;
%>

<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<!-- added by cyril on 2008-10-29 for td:9332 -->
<script type="text/javascript" src="/js/xtree.js"></script>
<script type="text/javascript" src="/js/xmlextras.js"></script>
<script type="text/javascript" src="/js/cxloadtree.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree2.css" />
<!-- end by cyril on 2008-10-29 for td:9332 -->
</HEAD>

<BODY onload="initTree()">
    <DIV align=right>
    <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
    <%
    BaseBean baseBean_self = new BaseBean();
    int userightmenu_self = 1;
    try{
    	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
    }catch(Exception e){}
    if(userightmenu_self == 1){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSave(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;       
        RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.parent.close(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }
    %>	
    <%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%if(userightmenu_self == 1){%>
    <script>
     rightMenu.style.visibility='hidden'
    </script>
<%}%>
    </DIV>

    <table   width=100% height=100% border="0" cellspacing="0" cellpadding="0">
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
                <TABLE  class=Shadow>
                    <tr>
                        <td valign="top">
                            <FORM NAME=select STYLE="margin-bottom:0" action="CityBrowser.jsp" method=post>


                                <TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">     
                                     <TR class=Line1><TH colspan="4" ></TH></TR>
                                      <TR>
                                          <TD height=450 colspan="4" >
                                            <div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" />   
                                          </TD>
                                      </TR>    
									  <tr> <td height="25" colspan="3"></td></tr>
										<tr>
										<td align="center" valign="bottom" colspan=3>  
									<BUTTON class=btn accessKey=O  id=btnok onclick="onSave()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
									<BUTTON class=btn accessKey=2  id=btnclear onclick="onClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
										<BUTTON class=btnReset accessKey=T  id=btncancel onclick="window.parent.parent.close();"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
										</td>
										</tr>
                                </TABLE>
                            </FORM>
                         </td>
                    </tr>
                </TABLE>
            </td>
            <td></td>
        </tr>
        
    </table>
    <script language="javaScript">
			//要把声明 radio的代码写在body里面(body加载的时候就要实例化)
				var temp_imgname = '';
				<%
				if(filterlevel==0) {
				%>
				temp_imgname = '3';
				<%
				}
				else {
				%>
				temp_imgname = '<%=filterlevel%>';
				<%
				}
				%>
				var appendimg = 'subject'+temp_imgname;
				var appendname = 'selObj';
				
				//保存的js函数要写在body 里面 谷歌浏览器才识别
				function onSave(){    
					var trunStr="",returnVBArray="";
					trunStr = onSaveJavaScript();
					var pos=trunStr.indexOf("_");
					if(pos!=-1){
						var str1 = trunStr.substring(0,pos);
						var str2 = trunStr.substring(pos+1);
						window.parent.returnValue  = {id:str1,name:str2};
						window.parent.close();
					}else{
						alert("<%=SystemEnv.getHtmlLabelName(18214, user.getLanguage())
									+ SystemEnv.getHtmlLabelName(1462, user.getLanguage())
									+ "!"%>")
					}
				}
				//保存的js函数要写在body 里面 谷歌浏览器才识别
				function onSaveJavaScript(){
				    var nameStr="";
				    if(select.selObj==null) return "";
				    if(typeof(select.selObj.length)=="undefined") {
						if(select.selObj.checked) {
							nameStr =  select.selObj.value;
						}
					} else {
						for(var i=0;i<select.selObj.length;i++) {
							if(select.selObj[i].checked) {
								nameStr =  select.selObj[i].value;
								break;
							}
						}
					}
				    return nameStr;   
				} 
				//取消的js函数也需要写在body中 谷歌浏览器才识别 并且兼容IE 火狐
				function onClear(){
					// window.parent.returnValue = Array(0,"","")
					window.parent.returnValue = {id:0,name:""};
					window.parent.close()
				}
		</script>
</BODY>
</HTML>

<script language="javaScript">
function initTree(){
//deeptree.init("/fna/maintenance/SubjectSingleXML.jsp?init=true&type=L0&level=<%=filterlevel%>&feetype=<%=filterfeetype%>");
//added by cyril on 2008-07-31 for td:9109
//设置选中的ID
cxtree_id = '';
CXLoadTreeItem("", "/fna/maintenance/SubjectSingleXML.jsp?init=true&type=L0&level=<%=filterlevel%>&feetype=<%=filterfeetype%>");
var tree = new WebFXTree();
tree.add(cxtree_obj);
//document.write(tree);
document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();
//end by cyril on 2008-07-31 for td:9109
}

function top(){

}
//node is a DIV object
function showcom(node){
}

function check(node){
if(typeof(select.selObj.length)=='undefined'){
highlight(node);
deeptree.ExpandNode(node.parentElement);
return;
}
for(i=0;i<select.selObj.length;i++){
highlight(select.selObj[i].previousSibling);
}
deeptree.ExpandNode(node.parentElement);
}


//end

//node is a SPAN object
function highlight(node){
if(node.nextSibling.checked)
node.style.color='red';
else
node.style.color='black';

}
</script>
