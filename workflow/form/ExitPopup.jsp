<%@ page contentType="text/html; charset=GBK" %>

<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language="javascript">
function button_yes_onClick() {
	window.returnValue=1;
	window.close();
}
function button_no_onClick() {
	window.returnValue=2;
	window.close();
}

function button_cancel_onClick() {
	window.close();
}
</script>
<html>
<head><title>退出</title></head>
<base target="_self">
<body bgcolor=#cccccc>
  <table width="100%" height="100%" cellpadding="0">
  <tr>
      <td valign="top" align="center">
        <div style="width:100%; height:100%; overflow: auto">
        <br>
        是否保存后退出？
        </div>
      </td>
    </tr>
     <tr height="50">
      <td align="center">
        <input type=button  onclick="button_yes_onClick();" value=" 是 ">
        <input type=button  onclick="button_no_onClick();" value=" 否 ">
        <input type=button   onclick="button_cancel_onClick();" value="取消">
      </td>
    </tr>
  </table>

</body>
</html>
