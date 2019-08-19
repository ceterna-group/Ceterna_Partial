/**
 * Created by ronanwilliams on 2019-08-14.
 */

public class XeroConfigUtils {

    public static void bindAccountsToContacts(){
        // get all contacts from Xero
        HttpResponse response = XeroCalloutUtility.executeCallout('GET', 'api','Contacts', null);

        JSONParserXeroContacts xeroContacts = JSONParserXeroContacts.parse(response.getBody());
        Map<String,String> nameToIdMap      = new Map<String,String>();

        for (JSONParserXeroContacts.cls_Contacts contact : xeroContacts.Contacts){
            nameToIdMap.put(contact.Name, contact.ContactID);
        }

        List<Account> accountsMissingId = [SELECT Name, Id
                                            FROM Account
                                            WHERE Name IN :nameToIdMap.keySet()
                                            AND XeroContactId__c = NULL];

        for (Account account : accountsMissingId){
            account.XeroContactId__c = nameToIdMap.get(account.Name);
        }

        update accountsMissingId;
    }
}