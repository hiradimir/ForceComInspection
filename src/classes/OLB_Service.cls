public with sharing class OLB_Service {
	
	HttpRequest req = new HttpRequest();
	
	public OLB_Service(){
		req.setMethod('GET');
	}
	
	public OLB_Service setEndpoint(String url){
		req.setEndpoint(url);
		return this;
	}
	
	public OLB_Service setMethod(String method){
		req.setMethod(method);
		return this;
	}
	
	public OLB_Service setToken(String token){
		req.setHeader('x-token', token);
		return this;
	}
	
	public HTTPResponse call(){
		Http http = new Http();
		return http.send(req);
	}
	
	public static String endpoint = 'http://ec2-175-41-204-105.ap-northeast-1.compute.amazonaws.com:8080/';
	
	public static HTTPResponse loginInfo(){
		return new OLB_Service().setEndpoint(endpoint + 'logininfo').call();
	}
	public static HTTPResponse logout(String token){
		return new OLB_Service().setEndpoint(endpoint + 'logout2').setToken(token).call();
	}
	public static HTTPResponse sample(String token){
		return new OLB_Service().setEndpoint(endpoint + 'sample').setToken(token).call();
	}
	public static HTTPResponse checkAuth(){
		return new OLB_Service().setEndpoint(endpoint + 'checkauth').call();
	}

}