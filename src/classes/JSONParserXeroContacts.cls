/**
 * Created by ronanwilliams on 2019-08-14.
 */

public class JSONParserXeroContacts {

    public String Id;	//b6cbceb1-06bf-48ea-84a4-7a3d29b52bf1
    public String Status;	//OK
    public String ProviderName;	//CeternaGroup
    public String DateTimeUTC;	///Date(1565779189319)/
    public cls_Contacts[] Contacts;

    public class cls_Contacts {
        public String ContactID;	//53756052-a10e-43e6-af02-58c4d2165035
        public String ContactStatus;	//ACTIVE
        public String Name;	//Medical Research Network
        public String FirstName;	//
        public String LastName;	//
        public String EmailAddress;	//Finance@Themrn.co.uk
        public String BankAccountDetails;	//
        public cls_Addresses[] Addresses;
        public cls_Phones[] Phones;
        public String UpdatedDateUTC;	///Date(1556030946943+0000)/
        public cls_ContactGroups[] ContactGroups;
        public boolean IsSupplier;
        public boolean IsCustomer;
        public String DefaultCurrency;	//GBP
        public cls_ContactPersons[] ContactPersons;
        public boolean HasAttachments;
        public boolean HasValidationErrors;
    }

    public class cls_Addresses {
        public String AddressType;	//STREET
        public String City;	//
        public String Region;	//
        public String PostalCode;	//
        public String Country;	//
        public String AttentionTo;	//
    }

    public class cls_Phones {
        public String PhoneType;	//DDI
        public String PhoneNumber;	//
        public String PhoneAreaCode;	//
        public String PhoneCountryCode;	//
    }
    public class cls_ContactGroups {
    }
    public class cls_ContactPersons {
    }
    public static JSONParserXeroContacts parse(String json){
        return (JSONParserXeroContacts) System.JSON.deserialize(json, JSONParserXeroContacts.class);
    }

}