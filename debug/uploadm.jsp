<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="javax.servlet.http.HttpServletRequest"%>
<%@ page import="javax.servlet.ServletInputStream"%>
<%@ include file="init.jsp" %>
<%
    int maxLength = 5 * 1024 * 1024;
    Hashtable values = new Hashtable();
    Hashtable files = new Hashtable();
    String contentType = request.getContentType();
    int contentLength = request.getContentLength();

    if (contentLength > maxLength) {
        // TODO 应该提醒附件上传不能超过最大值
        response.sendRedirect("debugm.jsp");
        return;
    }
    if (contentType == null || !contentType.startsWith("multipart/form-data")) {
        return;
    }
    //get out the boudary from content-type
    int start = contentType.indexOf("boundary=");
    //这里应该
    int boundaryLen = new String("boundary=").length();
    String boundary = contentType.substring(start + boundaryLen);
    boundary = "--" + boundary;
    //用字节表示，以免 String  和 byte 数组的长度不一致
    boundaryLen = bytesLen(boundary);

    //把request 中的数据读入一个byte数组
    byte buffer[] = new byte[contentLength];
    int once = 0;
    int total = 0;
    DataInputStream in = new DataInputStream(request.getInputStream());
    while ((total < contentLength) && (once >= 0)) {
        once = in.read(buffer, total, contentLength);
        total += once;
    }
    //对buffer中的数据进行拆分
    int pos1 = 0; //pos1 记录 在buffer 中下一个 boundary 的位置
    //pos0,pos1 用于 subBytes 的两个参数
    int pos0 = byteIndexOf(buffer, boundary, 0); //pos0 记录 boundary 的第一个字节在buffer 中的位置
    do {
        pos0 += boundaryLen; //记录boundary后面第一个字节的下标
        pos1 = byteIndexOf(buffer, boundary, pos0);
        if (pos1 == -1)
            break;
        //
        pos0 += 2; //考虑到boundary后面的 \r\n

        parse(subBytes(buffer, pos0, pos1 - 2), values, files); //考虑到boundary后面的 \r\n
        pos0 = pos1;
    } while (true);
    Object store = null;
    Object[] fks = files.keySet().toArray();
    for(int i=0; i<fks.length; i++){
        Vector v = (Vector) files.get(fks[i]);
        if (v == null) {
            continue;
        }
        if (v.size() > 0) {
            Object[] oa = (Object[]) v.get(0);
            ObjectInputStream ois = new ObjectInputStream(new ByteArrayInputStream((byte[]) oa[0]));

            store = ois.readObject();

            break;
        }
    }
    
    if(store != null){
        Class dataClass = Class.forName("com.weaver.onlinedebug.data.DebugDataStore");
        Class util = Class.forName("com.weaver.onlinedebug.util.Util");
        Object dd = util.getDeclaredMethod("importDebugData",new Class[]{dataClass}).invoke(null, new Object[]{store});
        
        session.setAttribute(debugDataKey,dd);
        response.sendRedirect("debugm.jsp");
    }

    //System.out.println("fiels=" + files.size() + "   values=" + values.size());
%>

<%!private static void parse(byte[] buffer, Hashtable values, Hashtable files) {
        String[] tokens = { "name=\"", "\"; filename=\"", "\"\r\n", "Content-Type: ", "\r\n\r\n" };
        //                          0           1                               2          3                         4
        int[] position = new int[tokens.length];

        for (int i = 0; i < tokens.length; i++) {
            position[i] = byteIndexOf(buffer, tokens[i], 0);
        }
        if (position[1] > 0 && position[1] < position[2]) {
            //包含tokens 中的第二个元素，说明是个文件数据段
            //1.得到字段名
            String name = subBytesString(buffer, position[0] + bytesLen(tokens[0]), position[1]);
            //2.得到文件名
            String file = subBytesString(buffer, position[1] + bytesLen(tokens[1]), position[2]);
            if (file.equals(""))
                return;
            file = new File(file).getName(); //this is the way to get the name from a path string
            //3.得到 Content-Type
            String contentType = subBytesString(buffer, position[3] + bytesLen(tokens[3]), position[4]);
            //4.得到文件内容
            byte[] b = subBytes(buffer, position[4] + bytesLen(tokens[4]), buffer.length);
            Object[] f = new Object[] { b, contentType, file, name };
            Vector v = (Vector) files.get(name);
            if (v == null) {
                v = new Vector();
            }
            if (!v.contains(f)) {
                v.add(f);
            }
            files.put(name, v);
            //同时将 name 属性和 file 属性作为普通字段，存入values;
            v = (Vector) values.get(name);
            if (v == null) {
                v = new Vector();
            }
            if (!v.contains(file)) {
                v.add(file);
            }
            values.put(name, v);
        } else {
            //            String[] tokens={"name=\"","\"; filename=\"", "\"\r\n","Content-Type: ","\r\n\r\n"}
            //             index                      0           1                               2          3                         4
            //不包含tokens 中的第二个元素，说明是个 name/value 型的数据段
            //所以没有tokens[1]和 tokens[3]
            //name 在 tokens[0] 和 tokens[2] 之间
            //value 在 tokens[4]之后
            //1.得到name
            String name = subBytesString(buffer, position[0] + bytesLen(tokens[0]), position[2]);
            String value = subBytesString(buffer, position[4] + bytesLen(tokens[4]), buffer.length);
            Vector v = (Vector) values.get(name);
            if (v == null) {
                v = new Vector();
            }
            if (!v.contains(value)) {
                v.add(value);
            }
            values.put(name, v);
        }
    }

    private static int byteIndexOf(byte[] source, String search, int start) {
        return byteIndexOf(source, search.getBytes(), start);
    }

    private static int byteIndexOf(byte[] source, byte[] search, int start) {
        int i;
        if (search.length == 0) {
            return 0;
        }
        int max = source.length - search.length;
        if (max < 0)
            return -1;
        if (start > max)
            return -1;
        if (start < 0)
            start = 0;
        // 在source中找到search的第一个元素
        searchForFirst: for (i = start; i <= max; i++) {
            if (source[i] == search[0]) {
                //找到了search中的第一个元素后，比较剩余的部分是否相等
                int k = 1;
                while (k < search.length) {
                    if (source[k + i] != search[k]) {
                        continue searchForFirst;
                    }
                    k++;
                }
                return i;
            }
        }
        return -1;
    }

    private static byte[] subBytes(byte[] source, int from, int end) {
        byte[] result = new byte[end - from];
        System.arraycopy(source, from, result, 0, end - from);
        return result;
    }

    private static String subBytesString(byte[] source, int from, int end) {
        return new String(subBytes(source, from, end));
    }

    private static int bytesLen(String s) {
        return s.getBytes().length;
    }%>