package ln;

import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;

import net.sf.json.JSONObject;
import weaver.general.BaseBean;
import _2._15._1._10.dcfwpt.services.platform.PlatformImplServiceLocator;
import _2._15._1._10.dcfwpt.services.platform.PlatformImpl;

public class test extends BaseBean{
	public static void main(String[] args) throws Exception {
		System.out.println(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
		PlatformImplServiceLocator psl = new PlatformImplServiceLocator();
		URL url = new URL("http://10.1.15.2:7001/dcfwpt/services/platform?wsdl");
		PlatformImpl psbs = psl.getplatform(url);
		String respStr = psbs.validateLogin("chengli", "284d98dd20ef46b522f8ffc1c9dab988");
//		String respStr = psbs.validateLogin("chengli", "asdf23456");
		System.out.println("respStr=" + respStr);
		JSONObject jo = JSONObject.fromObject(respStr);
		System.out.println(jo.get("result"));
		System.out.println(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
	}
}
