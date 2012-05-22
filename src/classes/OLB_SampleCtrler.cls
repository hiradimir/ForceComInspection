public with sharing class OLB_SampleCtrler extends OLB_BaseCtrler{
	
	public SampleJSON sample {get;set;}
	
	public class SampleJSON{
		public String result {get;set;}
	}
	
	public PageReference init(){
		String token = ApexPages.currentPage().getCookies().get('olb-token').getValue();
		
		HTTPResponse resp = OLB_Service.sample(token);
		
		if(resp.getStatusCode() != 401){
			sample = (SampleJSON)JSON.deserialize(resp.getBody(), SampleJSON.class);
		}else{
			return Page.SiteLogout;
		}
		return null;
	}
	
	public OLB_SampleCtrler(){
	}

}