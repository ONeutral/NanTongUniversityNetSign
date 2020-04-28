/**
 * @author ONeutral
 * @date 2020/4/28 10:13 下午
 */
public class Start {
    public static void main(String[] args) {
        //发送 GET 请求
        String id="";//输入你的学号
        String password="";//输入你的密码
        String ip="";//输入你的教育公ip地址
        String v="8880";//输入v（这个不清楚到底是个啥(四位数
        String s = HttpRequest.sendGet("http://210.29.79.141:801", "c=Portal&a=login&callback=dr1003&login_method=1&user_account=%2C0%2C"+id+"%40telecom&user_password="+password+"&wlan_user_ip="+ip+"&wlan_user_ipv6=&wlan_user_mac=000000000000&wlan_ac_ip=&wlan_ac_name=&jsVersion=3.3.2&v="+v);
        System.out.println(s);
    }
}
