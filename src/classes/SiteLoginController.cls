/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class SiteLoginController {
    global String username {get; set;}
    global String password {get; set;}
    global Boolean force{get;set;}

		class LoginInfo{
			public String token {get; set;}
		}

    global PageReference forcelogin() {
    	
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        PageReference ref = Site.login(username, password, startUrl);
        LoginInfo li = (LoginInfo)JSON.deserialize(OLB_Service.loginInfo().getBody(), LoginInfo.class);
        Cookie olb_token = new Cookie('olb-token', li.token, null, -1, false);
        ref.setCookies(new Cookie[]{olb_token});
        return ref;
    }
    global PageReference login() {
        
        HTTPResponse authResp = OLB_Service.checkAuth();
        //
        if(authResp.getStatusCode() != 401){
        	force = true;
        	return null;
        }
        
        return forcelogin();
    }
    
   	global SiteLoginController () {force=false;}
    
    @IsTest(SeeAllData=true) global static void testSiteLoginController () {
        // Instantiate a new controller with all parameters in the page
        SiteLoginController controller = new SiteLoginController ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 
                
        System.assertEquals(controller.login(),null);                           
    }    
}