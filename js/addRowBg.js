var isLightBool = false ;
var rowBgValue = "" ;
function getRowBg()
{	
	isLightBool = !isLightBool ;
	if (isLightBool)
	{
		rowBgValue = "rgb(245, 250, 250)";//"#e7e7e7" ;
	}
	else
	{	
		rowBgValue = "rgb(245, 250, 250)";
	}
	return rowBgValue ;
}
