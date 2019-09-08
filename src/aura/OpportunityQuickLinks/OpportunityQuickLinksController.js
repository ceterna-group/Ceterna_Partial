/**
 * Created by ronanwilliams on 2019-08-22.
 */

({

    doInit : function($C,$E,$H){

        if ($C.get('v.opp')){
            var state = $C.get('v.opp.StageName');
            $C.set('v.state',state);
            console.log('setting state is ' + state);
        }



    },
    handleMavenlink : function($C,$E,$H){
        var mavenlinkId = $C.get('v.opp.MavenlinkId__c');

        if (mavenlinkId){
            $H.navigateToURL('https://ceterna.mavenlink.com/workspaces/' + mavenlinkId);
        } else {
            $C.set('v.pendingMavenklink', true);

        }
    },
    handleAsana : function($C,$E,$H){
        var asanaId = $C.get('v.opp.AsanaId__c');

        if (asanaId){
            $H.navigateToURL('https://app.asana.com/0/' + asanaId);
        }
    },
    handleXero : function($C,$E,$H){
        var xeroId = $C.get('v.opp.XeroId__c');

        if (xeroId){
            $H.navigateToURL('https://projects.xero.com/project/' + xeroId);
        }
    },
    handleFreshdesk : function($C,$E,$H){
        var freshdeskId = $C.get('v.opp.FreshdeskId__c');

        if (freshdeskId){
            $H.navigateToURL('http://www.ceternasupport.com/a/companies/' + freshdeskId);
        }
    },
    recordUpdated : function($C,$E,$H){
        var state = $C.get('v.state');

        console.log('old state is ' + state);
        console.log('new state is ' + $C.get('v.opp.StageName'));

        if (state){
            if ($C.get('v.opp.StageName') !== state){
                console.log('updated to ' + $C.get('v.opp.StageName'));

                $C.set('v.pendingAll',true);
            }
        } else {
            state = $C.get('v.opp.StageName');
            $C.set('v.state',state);
            console.log('setting state is ' + state);
        }
    }



});