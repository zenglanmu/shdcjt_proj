var NowImg = 1;
var bStart = 0;
var bStop =0;

function fnToggle() 
{
	var next = NowImg + 1;

	if(next == MaxImg+1) 
	{
		NowImg = MaxImg;
		next = 1;
	}
	if(bStop!=1)
	{

		if(bStart == 0)
		{
			bStart = 1;		
			setTimeout('fnToggle()', 4000);
			return;
		}
		else
		{
			oTransContainer.filters[0].Apply();

			document.images['oDIV'+next].style.display = "";
			document.images['oDIV'+NowImg].style.display = "none"; 

			oTransContainer.filters[0].Play(duration=2);

			if(NowImg == MaxImg) 
				NowImg = 1;
			else
				NowImg++;
		}
		setTimeout('fnToggle()', 5000);
	}
}


function toggleTo(img,obj){	
	try{
		var newObj=obj.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode
		var imgs=newObj.getElementsByTagName("IMG");
		bStop=1;
		if(img==1)	{
			for(var i=0;i<imgs.length;i++){
				var img=imgs[i];
				if(img.id=="oDIV1") img.style.display = "";
				else if(img.id=="oDIV2") img.style.display = "none";
				else if(img.id=="oDIV3") img.style.display = "none";
				else if(img.id=="oDIV4") img.style.display = "none";
				else if(img.id=="oDIV5") img.style.display = "none";
			}			
		}else if(img==2)	{
			for(var i=0;i<imgs.length;i++){
				var img=imgs[i];
				if(img.id=="oDIV1") img.style.display = "none";
				else if(img.id=="oDIV2") img.style.display = "";
				else if(img.id=="oDIV3") img.style.display = "none";
				else if(img.id=="oDIV4") img.style.display = "none";
				else if(img.id=="oDIV5") img.style.display = "none";
			}			

		}else if(img==3)	{
			for(var i=0;i<imgs.length;i++){
				var img=imgs[i];
				if(img.id=="oDIV1") img.style.display = "none";
				else if(img.id=="oDIV2") img.style.display = "none";
				else if(img.id=="oDIV3") img.style.display = "";
				else if(img.id=="oDIV4") img.style.display = "none";
				else if(img.id=="oDIV5") img.style.display = "none";
			}	
		}else if(img==4){
			for(var i=0;i<imgs.length;i++){
				var img=imgs[i];
				if(img.id=="oDIV1") img.style.display = "none";
				else if(img.id=="oDIV2") img.style.display = "none";
				else if(img.id=="oDIV3") img.style.display = "none";
				else if(img.id=="oDIV4") img.style.display = "";
				else if(img.id=="oDIV5") img.style.display = "none";
			} 
		}else if(img==5)	{
			for(var i=0;i<imgs.length;i++){
				var img=imgs[i];
				if(img.id=="oDIV1") img.style.display = "none";
				else if(img.id=="oDIV2") img.style.display = "none";
				else if(img.id=="oDIV3") img.style.display = "none";
				else if(img.id=="oDIV4") img.style.display = "none";
				else if(img.id=="oDIV5") img.style.display = "";
			}
		}
	}catch(e){
	}

}