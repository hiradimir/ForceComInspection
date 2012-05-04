public with sharing class InspectCtler {
	
	public class ExceptionWrapper{
		public String message{get;set;}
		public Integer lineNumber{get;set;}
		public String stackTrace{get;set;}
		public String typeName{get;set;}
		public ExceptionWrapper(Exception ex){
			message = ex.getMessage();
			lineNumber = ex.getLineNumber();
			stackTrace = ex.getStackTraceString();
			typeName = ex.getTypeName();
		}
	}
	
	public interface Executor{
		String execute();
	}
	
	public static Performance measurementPerformance(Executor exec){
		Performance perf = new Performance();
		perf.execute(exec);
		return perf;
	}
	
	public class Performance{
		public Long start_time;
		public Long end_time;
		public Long cost;
		public String result;
		public Executor exec;
		public void execute(Executor exec){
			this.exec = exec;
			try{
				start_time = System.currentTimeMillis();
				result = exec.execute();
			}catch(Exception ex){
				result = JSON.serialize(new ExceptionWrapper(ex));
			}finally{
				end_time = System.currentTimeMillis();
				cost = end_time - start_time;
			}
		}
	}
	
	public class JsonDeserializeExecutor implements Executor{
		public String name{get{return 'JsonDeserializeExecutor';}}
		public String typeString{get{if(typeString == null || typeString == ''){return 'List<Map<String,String>>';} return typeString;}set;}
		public String jsString{get;set;}
		public Long jsStringLength{get;set;}
		public String execute(){
			jsStringLength = jsString.length();
			return JSON.serialize(JSON.deserialize(jsString, Type.forName(typeString)));
		}
	}
	
	public class CallOutExecutor implements Executor{
		public String name{get{return 'CallOutExecutor';}}
		public String url{get;set;}
		public Boolean isHttps{get{return url.indexOf('https')==0;}set;}
		public String execute(){
			HttpRequest req = new HttpRequest();
			req.setEndpoint(url);
			req.setMethod('GET');
			if(url.indexOf('https')==0){
				//req.setClientCertificateName('InspectionEC201');
			}
			Http http = new Http();
			HTTPResponse res = http.send(req);
			return res.getBody();
		}
	}
	
	public static String inspectCallout(String url, String typeString){
		List<Performance> performances = new List<Performance>();
		CallOutExecutor coe = new CallOutExecutor();
		coe.url = url;
		Performance coeperf = measurementPerformance(coe);
		JsonDeserializeExecutor jde = new JsonDeserializeExecutor();
		jde.jsString = coeperf.result;
		jde.typeString = typeString;
		Performance jdeperf = measurementPerformance(jde);
		performances.add(coeperf);
		performances.add(jdeperf);
		return JSON.serialize(performances);
	}
	
	public String dataString {
		get{
			if(mode == ModeEnum.kb){
				List<KBDataClass> kbArray = new List<KBDataClass>();
				KBDataClass kbunit = new KBDataClass();
				for(Integer i = 0 ; i < kbSize ; i ++){
					kbArray.add(kbunit);
				}
				return JSON.serialize(kbArray);
			}else if(mode == ModeEnum.url){
				
				return inspectCallout(url, '');
			}
			return 'invalid request';
		}
		set;
	}
	
	enum ModeEnum{
		kb,
		url
	}
	
	public ModeEnum mode{
		get{
			if(mode == null){
				this.mode = ApexPages.currentPage().getParameters().get('kbSize') != null ? ModeEnum.kb : ModeEnum.url;
			}
			return this.mode;
		}
		set;
	}
	
	public Integer kbSize {
		get{
			Integer value = 10;//default
			try{
				value = Integer.valueOf(ApexPages.currentPage().getParameters().get('kbSize'));
			}catch(Exception ex){
				ApexPages.currentPage().getParameters().put('kbSize', '10');
			}
			return value;
		}
	}
	public String url {
		get{
			String value = ApexPages.currentPage().getParameters().get('url');
			value = value != null ? value : 'http://www.yahoo.com'; //default
			return value;
		}
	}
	
	public class KBDataClass {
		public String kb{get;set;}
		public KBDataClass(){
			kb = '';
			for(Integer i = 0; i < 64 ;i++){
				kb += '0123456789ABCDEF';
			}
		}
	}
	
	public InspectCtler(){
	}
	
	@isTest(SeeAllData=false) public static void testUrl() {
		InspectCtler ctler = new InspectCtler();
		try{
			Integer test;
			test.format();
		}catch(Exception ex){
			ExceptionWrapper ew = new ExceptionWrapper(ex);
		}
		JsonDeserializeExecutor jde = new JsonDeserializeExecutor();
		jde.jsString='[{"kb":"test"},{"kb":"test"}]';
		measurementPerformance(jde);
		
		try{
			String test = ctler.dataString;
		}catch(Exception ex){
		}
	}
	
	@isTest(SeeAllData=false) public static void testKb() {
		InspectCtler ctler = new InspectCtler();
		ctler.mode = ModeEnum.kb;
		try{
			String test = ctler.dataString;
		}catch(Exception ex){
		}
		System.assertEquals(true, false);
	}
	
}