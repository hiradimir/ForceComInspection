public with sharing class OLB_LogoutCtrler {
	
	public OLB_LogoutCtrler(){
		String token = ApexPages.currentPage().getCookies().get('olb-token').getValue();
		try{
			OLB_Service.logout(token);
		}catch(Exception ex){
			
		}
		// set forward url
	}

}