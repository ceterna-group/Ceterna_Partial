/**
 * Created by ronanwilliams on 2019-08-30.
 */

({

    navigateToURL : function(url){

        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": url
        });
        urlEvent.fire();
    }

});