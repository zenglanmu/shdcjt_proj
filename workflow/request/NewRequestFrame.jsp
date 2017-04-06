<%@ page language="java" contentType="text/html; charset=GBK" %>
<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/ext-all.css" />
<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/xtheme-gray.css" />
<link rel="stylesheet" type="text/css" href="/css/weaver-ext.css" />	
<link rel="stylesheet" type="text/css" href="/css/column-tree.css" />
<%if(user.getLanguage()==7) {%>
	<script type='text/javascript' src='/js/weaver-lang-cn-gbk.js'></script>
<%} else if(user.getLanguage()==8) {%>
	<script type='text/javascript' src='/js/weaver-lang-en-gbk.js'></script>
<%} else if(user.getLanguage()==9) {%>
	<script type='text/javascript' src='/js/weaver-lang-tw-gbk.js'></script>
<%}%>
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
#mainRequestFrame {

 height: 98%;
 TOP: 3px; 
 LEFT: 3px;
 margin-right:5px;
}
.requestContentBody {
 width: 100%;
 height: 100%;
 padding-top:27px;
 padding-bottom:26px;
}
#mainRequestFrame>.requestContentBody {
 height:auto;
 position:absolute;
}
#toolbarmenudiv, #toolbarmenuCoverdiv {
 height:26px;
 *height:30px;
 width:100%;
 position:absolute;
 top:0px;
 BACKGROUND-COLOR:#ECECEC;
 border:1px solid #979797;
 margin-right:8px;
}
#requestTabButton {
 height:26px;
 width:100%;
 position:absolute;
 bottom:0px;
 _bottom:-1px; /*-- for IE6.0 --*/
 margin-top:3px;
}

#toolbarmenudiv .x-btn-mc em button {
	height:20px;
}

#toolbarmenuCoverdiv .x-btn-mc em button {
	height:20px;
}

</style>

<script type="text/javascript">

jQuery(function () {
	mainDivResize();
	divWfBillResize();
	jQuery("#bodyiframe").css("overflow-x", "hidden");
	
	jQuery("#bodyiframe").bind("load", function () {
		jQuery(this.contentWindow.document.getElementById("flowbody")).css("overflow-x", "scroll");
		
		var detailAreaWidth = jQuery(this.contentWindow.document.getElementById("flowbody")).width();
		if (window.ActiveXObject) {
			detailAreaWidth -= 20;
		} else {
			jQuery(this.contentWindow.document.getElementById("flowbody")).css("overflow-y", "scroll");
			detailAreaWidth = jQuery(this.contentWindow.document.getElementById("flowbody")).width();
		} 
		jQuery(this.contentWindow.document.getElementById("workflowDetailArea")).css("width", detailAreaWidth);
		jQuery(this.contentWindow.document.getElementById("workflowDetailArea")).css("overflow-x", "auto");
		
	});
	/*
	if (window.ActiveXObject) {
		document.body.onresize = bodyresize;
	} else {
		*/
		window.onresize = bodyresize;
		/*
	}
		*/
});
function bodyresize() {
	mainDivResize();
	divWfBillResize();
}
function mainDivResize() {
	/*
	if (window.ActiveXObject) {
	*/
	jQuery("#mainRequestFrame").css("height", document.body.clientHeight-30);
		/*
	} else {
		$("#mainRequestFrame").css("height", document.body.clientHeight - 30);
	}
		*/
}

function divWfBillResize() {
	if (!window.ActiveXObject) {
		jQuery("#divWfBill").css("height", document.body.clientHeight-92);
		jQuery("#divWfLog").css("height", document.body.clientHeight-92);
		jQuery("#divWfPic").css("height", document.body.clientHeight-92);
		if (jQuery("#divWfText")[0]) {
			jQuery("#divWfText").css("height", document.body.clientHeight-92);
		}
	}
}

</script>

<div id="loading">
	<span><img src="/images/loading2.gif" align="absmiddle"></span>
	<span  id="loading-msg"><%=SystemEnv.getHtmlLabelName(19945, user.getLanguage())%></span>
</div>
<DIV id=mainRequestFrame class=" x-panel-body x-panel-body-noheader">
	<DIV id=toolbarmenudiv style="display:none;z-index:999!important;" class="x-toolbar x-small-editor">
		<TABLE style="WIDTH: auto;" cellSpacing=0>
			<TBODY>
				<TR id=toolbarmenu class=x-toolbar-left-row>
				</TR>
			</TBODY>
		</TABLE>
	</DIV>
	<DIV id="toolbarmenuCoverdiv" style="display:none;z-index:1000!important;filter:alpha(opacity=20);-moz-opacity:0.2;-khtml-opacity: 0.2;opacity: 0.2;" class="x-toolbar x-small-editor">
	</DIV>
	<!--此处为流程图-->
		<div id="divWfPic" class='requestContentBody' style="height:100%;overflow:auto;display:none">
			<IFRAME src='' id=piciframe name=piciframe style='width:100%;height:100%' BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></IFRAME>
		</div>

		<!--此处为流转状态-->
		<div id="divWfLog" class='requestContentBody' style="height:100%;overflow:auto;display:none">
			<IFRAME src='' id="statiframe" name="statiframe" style='width:100%;height:100%' BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></IFRAME>
		</div>

		<!--此处为流程表单-->
		<div id="divWfBill" class='requestContentBody'  style="height:100%;overflow:auto;display:none;margin-top:5px;">
			<IFRAME src='' id=bodyiframe name=bodyiframe style='width:100%;height:100%' BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></IFRAME>
		</div>
	<%if(isworkflowdoc.equals("1")){ %>
		<div id="divWfText" class='requestContentBody' style="height:100%;overflow:auto;display:none">
			<IFRAME src='' id=workflowtext  name=workflowtext style='width:100%;height:100%'  BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></IFRAME>
		</div>
	<%} %>
	
	<DIV id="toolbarbottommenu" style="display:none;z-index:1000!important;filter:alpha(opacity=20);-moz-opacity:0.2;-khtml-opacity: 0.2;opacity: 0.2;" class="x-toolbar x-small-editor">
	</DIV>
	<DIV id=requestTabButton class=x-tab-panel-footer>
		<DIV class=x-tab-strip-wrap>
			<UL class="x-tab-strip x-tab-strip-bottom">
				<LI id=WfBill
					class=" x-tab-with-icon x-tab-strip-active" onclick="changeTabToWf('WfBill',this);">
					<A class=x-tab-strip-close onclick="return false;"></A>
					<A class=x-tab-right onclick="return false;" href="#">
					<EM class=x-tab-left>
						<SPAN style="WIDTH: 130px" class=x-tab-strip-inner><SPAN class="x-tab-strip-text btn_add"><script language=javascript>document.write(wmsg.wf.bill);</script></SPAN></SPAN>
					</EM>
					</A>
				</LI>
				<LI id=WfPic class=" x-tab-with-icon " onclick="changeTabToWf('WfPic',this);">
					<A class=x-tab-strip-close onclick="return false;"></A>
					<A class=x-tab-right onclick="return false;"href="#">
					<EM class=x-tab-left>
						<SPAN style="WIDTH: 130px" class=x-tab-strip-inner><SPAN class="x-tab-strip-text btn_add"><script language=javascript>document.write(wmsg.wf.pic);</script></SPAN></SPAN>
					</EM>
					</A>
				</LI>
				<LI id=WfLog class=" x-tab-with-icon " onclick="changeTabToWf('WfLog',this);">
					<A class=x-tab-strip-close onclick="return false;"></A>
					<A class=x-tab-right onclick="return false;" href="#">
					<EM class=x-tab-left>
						<SPAN style="WIDTH: 130px" class=x-tab-strip-inner><SPAN class="x-tab-strip-text btn_add"><script language=javascript>document.write(wmsg.wf.status);</script></SPAN></SPAN>
					</EM>
					</A>
				</LI>
				<%if(isworkflowdoc.equals("1")){ %>
				<LI id=WfText class=" x-tab-with-icon " onclick="changeTabToWf('WfText',this);">
					<A class=x-tab-strip-close onclick="return false;"></A>
					<A class=x-tab-right onclick="return false;" href="#">
					<EM class=x-tab-left>
						<SPAN style="WIDTH: 130px" class=x-tab-strip-inner><SPAN class="x-tab-strip-text btn_add"><script language=javascript>document.write(wmsg.wf.text);</script></SPAN></SPAN>
					</EM>
					</A>
				</LI>
				<%} %>
				<LI id=ext-gen32 class=x-tab-edge></LI>
			</UL>
		</DIV>
	</DIV>
</div>
<script type="text/javascript" src="/js/newwf.js"></script>