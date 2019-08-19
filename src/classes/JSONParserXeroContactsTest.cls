/**
 * Created by ronanwilliams on 2019-08-14.
 */

@IsTest
public class JSONParserXeroContactsTest {

    static testMethod void testParse() {
        String json=		'{'+
                '  "Id": "b6cbceb1-06bf-48ea-84a4-7a3d29b52bf1",'+
                '  "Status": "OK",'+
                '  "ProviderName": "CeternaGroup",'+
                '  "DateTimeUTC": "Date(1565779189319)",'+
                '  "Contacts": ['+
                '    {'+
                '      "ContactID": "53756052-a10e-43e6-af02-58c4d2165035",'+
                '      "ContactStatus": "ACTIVE",'+
                '      "Name": "Medical Research Network",'+
                '      "FirstName": "",'+
                '      "LastName": "",'+
                '      "EmailAddress": "Finance@Themrn.co.uk",'+
                '      "BankAccountDetails": "",'+
                '      "Addresses": ['+
                '        {'+
                '          "AddressType": "STREET",'+
                '          "City": "",'+
                '          "Region": "",'+
                '          "PostalCode": "",'+
                '          "Country": "",'+
                '          "AttentionTo": ""'+
                '        },'+
                '        {'+
                '          "AddressType": "POBOX",'+
                '          "AddressLine1": "Talon House",'+
                '          "AddressLine2": "Presley Way",'+
                '          "AddressLine3": "Milton Keynes",'+
                '          "AddressLine4": "Buckinghamshire\nMK8 0ES",'+
                '          "City": "",'+
                '          "Region": "",'+
                '          "PostalCode": "",'+
                '          "Country": "",'+
                '          "AttentionTo": ""'+
                '        }'+
                '      ],'+
                '      "Phones": ['+
                '        {'+
                '          "PhoneType": "DDI",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        },'+
                '        {'+
                '          "PhoneType": "DEFAULT",'+
                '          "PhoneNumber": "01908261153",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        },'+
                '        {'+
                '          "PhoneType": "FAX",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        },'+
                '        {'+
                '          "PhoneType": "MOBILE",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        }'+
                '      ],'+
                '      "UpdatedDateUTC": "Date(1556030946943+0000)",'+
                '      "ContactGroups": [],'+
                '      "IsSupplier": false,'+
                '      "IsCustomer": true,'+
                '      "DefaultCurrency": "GBP",'+
                '      "ContactPersons": [],'+
                '      "HasAttachments": false,'+
                '      "HasValidationErrors": false'+
                '    },'+
                '    {'+
                '      "ContactID": "bca54e56-b198-4934-9eb1-056db929293d",'+
                '      "ContactStatus": "ACTIVE",'+
                '      "Name": "Parkdean Resorts",'+
                '      "FirstName": "Accounts",'+
                '      "LastName": "Payable",'+
                '      "EmailAddress": "accounts.payable@parkdean-resorts.com",'+
                '      "BankAccountDetails": "",'+
                '      "Addresses": ['+
                '        {'+
                '          "AddressType": "STREET",'+
                '          "City": "",'+
                '          "Region": "",'+
                '          "PostalCode": "",'+
                '          "Country": "",'+
                '          "AttentionTo": ""'+
                '        },'+
                '        {'+
                '          "AddressType": "POBOX",'+
                '          "AddressLine1": "2nd Floor",'+
                '          "AddressLine2": "One Gosforth Park Way, Gosforth Business Park",'+
                '          "AddressLine3": "Newcastle Upon Tyne",'+
                '          "AddressLine4": "NE12 8ET",'+
                '          "City": "",'+
                '          "Region": "",'+
                '          "PostalCode": "",'+
                '          "Country": "",'+
                '          "AttentionTo": ""'+
                '        }'+
                '      ],'+
                '      "Phones": ['+
                '        {'+
                '          "PhoneType": "DDI",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        },'+
                '        {'+
                '          "PhoneType": "DEFAULT",'+
                '          "PhoneNumber": "01912561799",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        },'+
                '        {'+
                '          "PhoneType": "FAX",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        },'+
                '        {'+
                '          "PhoneType": "MOBILE",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        }'+
                '      ],'+
                '      "UpdatedDateUTC": "Date(1556814206917+0000)",'+
                '      "ContactGroups": [],'+
                '      "IsSupplier": false,'+
                '      "IsCustomer": true,'+
                '      "DefaultCurrency": "GBP",'+
                '      "Balances": {'+
                '        "AccountsReceivable": {'+
                '          "Outstanding": 18000.00,'+
                '          "Overdue": 0.00'+
                '        },'+
                '        "AccountsPayable": {'+
                '          "Outstanding": 0.00,'+
                '          "Overdue": 0.00'+
                '        }'+
                '      },'+
                '      "ContactPersons": [],'+
                '      "HasAttachments": false,'+
                '      "HasValidationErrors": false'+
                '    },'+
                '    {'+
                '      "ContactID": "3e219c64-f609-4fef-937a-efd7d4a7c2a0",'+
                '      "ContactStatus": "ACTIVE",'+
                '      "Name": "Impact Data Solutions",'+
                '      "FirstName": "Ben",'+
                '      "LastName": "Parker",'+
                '      "EmailAddress": "ben.parker@impactds.com",'+
                '      "BankAccountDetails": "",'+
                '      "Addresses": ['+
                '        {'+
                '          "AddressType": "STREET",'+
                '          "City": "",'+
                '          "Region": "",'+
                '          "PostalCode": "",'+
                '          "Country": "",'+
                '          "AttentionTo": ""'+
                '        },'+
                '        {'+
                '          "AddressType": "POBOX",'+
                '          "AddressLine1": "Vernon Yard",'+
                '          "AddressLine2": "96 Clarence Road",'+
                '          "AddressLine3": "Fleet",'+
                '          "AddressLine4": "HampshireGU51 3XU",'+
                '          "City": "",'+
                '          "Region": "",'+
                '          "PostalCode": "",'+
                '          "Country": "",'+
                '          "AttentionTo": ""'+
                '        }'+
                '      ],'+
                '      "Phones": ['+
                '        {'+
                '          "PhoneType": "DDI",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        },'+
                '        {'+
                '          "PhoneType": "DEFAULT",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        },'+
                '        {'+
                '          "PhoneType": "FAX",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        },'+
                '        {'+
                '          "PhoneType": "MOBILE",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        }'+
                '      ],'+
                '      "UpdatedDateUTC": "Date(1557739214843+0000)",'+
                '      "ContactGroups": [],'+
                '      "IsSupplier": false,'+
                '      "IsCustomer": true,'+
                '      "DefaultCurrency": "GBP",'+
                '      "ContactPersons": [],'+
                '      "HasAttachments": false,'+
                '      "HasValidationErrors": false'+
                '    },'+
                '    {'+
                '      "ContactID": "d77bfc1b-e002-4ba0-95f8-60c43fe8d269",'+
                '      "ContactStatus": "ACTIVE",'+
                '      "Name": "Nominet",'+
                '      "FirstName": "FNANCE",'+
                '      "LastName": "",'+
                '      "EmailAddress": "fin@nominet.uk",'+
                '      "BankAccountDetails": "",'+
                '      "Addresses": ['+
                '        {'+
                '          "AddressType": "STREET",'+
                '          "City": "",'+
                '          "Region": "",'+
                '          "PostalCode": "",'+
                '          "Country": "",'+
                '          "AttentionTo": ""'+
                '        },'+
                '        {'+
                '          "AddressType": "POBOX",'+
                '          "AddressLine1": "Minerva House Edmund Halley Road,",'+
                '          "AddressLine2": "Oxford Science Park",'+
                '          "AddressLine3": "Oxford",'+
                '          "AddressLine4": "OX4 4DQ\nENGLAND, UK",'+
                '          "City": "",'+
                '          "Region": "",'+
                '          "PostalCode": "",'+
                '          "Country": "",'+
                '          "AttentionTo": ""'+
                '        }'+
                '      ],'+
                '      "Phones": ['+
                '        {'+
                '          "PhoneType": "DDI",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        },'+
                '        {'+
                '          "PhoneType": "DEFAULT",'+
                '          "PhoneNumber": "07767852541",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        },'+
                '        {'+
                '          "PhoneType": "FAX",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        },'+
                '        {'+
                '          "PhoneType": "MOBILE",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        }'+
                '      ],'+
                '      "UpdatedDateUTC": "Date(1557828837620+0000)",'+
                '      "ContactGroups": [],'+
                '      "IsSupplier": false,'+
                '      "IsCustomer": true,'+
                '      "DefaultCurrency": "GBP",'+
                '      "Balances": {'+
                '        "AccountsReceivable": {'+
                '          "Outstanding": 570.00,'+
                '          "Overdue": 0.00'+
                '        },'+
                '        "AccountsPayable": {'+
                '          "Outstanding": 0.00,'+
                '          "Overdue": 0.00'+
                '        }'+
                '      },'+
                '      "ContactPersons": [],'+
                '      "HasAttachments": false,'+
                '      "HasValidationErrors": false'+
                '    },'+
                '    {'+
                '      "ContactID": "dd7eccdc-4e76-46df-aa31-6d7f6c033f36",'+
                '      "ContactStatus": "ACTIVE",'+
                '      "Name": "Sharps Bedrooms Limited",'+
                '      "FirstName": "Stephen",'+
                '      "LastName": "Morley",'+
                '      "EmailAddress": "stephen.morley@sharps.co.uk",'+
                '      "BankAccountDetails": "",'+
                '      "Addresses": ['+
                '        {'+
                '          "AddressType": "STREET",'+
                '          "City": "",'+
                '          "Region": "",'+
                '          "PostalCode": "",'+
                '          "Country": "",'+
                '          "AttentionTo": ""'+
                '        },'+
                '        {'+
                '          "AddressType": "POBOX",'+
                '          "AddressLine1": "Regal House",'+
                '          "AddressLine2": "18 The High Street",'+
                '          "AddressLine3": "Bagshot",'+
                '          "AddressLine4": "Surrey\nGU19 5AA",'+
                '          "City": "",'+
                '          "Region": "",'+
                '          "PostalCode": "",'+
                '          "Country": "",'+
                '          "AttentionTo": ""'+
                '        }'+
                '      ],'+
                '      "Phones": ['+
                '        {'+
                '          "PhoneType": "DDI",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        },'+
                '        {'+
                '          "PhoneType": "DEFAULT",'+
                '          "PhoneNumber": "07768217420",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        },'+
                '        {'+
                '          "PhoneType": "FAX",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        },'+
                '        {'+
                '          "PhoneType": "MOBILE",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        }'+
                '      ],'+
                '      "UpdatedDateUTC": "Date(1558431329440+0000)",'+
                '      "ContactGroups": [],'+
                '      "IsSupplier": false,'+
                '      "IsCustomer": true,'+
                '      "DefaultCurrency": "GBP",'+
                '      "ContactPersons": [],'+
                '      "HasAttachments": false,'+
                '      "HasValidationErrors": false'+
                '    },'+
                '    {'+
                '      "ContactID": "a2e5df4f-79a6-4d54-8c3e-9e90345bf04d",'+
                '      "ContactStatus": "ACTIVE",'+
                '      "Name": "Resource On Demand Limited",'+
                '      "EmailAddress": "",'+
                '      "BankAccountDetails": "",'+
                '      "Addresses": ['+
                '        {'+
                '          "AddressType": "STREET",'+
                '          "City": "",'+
                '          "Region": "",'+
                '          "PostalCode": "",'+
                '          "Country": ""'+
                '        },'+
                '        {'+
                '          "AddressType": "POBOX",'+
                '          "City": "",'+
                '          "Region": "",'+
                '          "PostalCode": "",'+
                '          "Country": ""'+
                '        }'+
                '      ],'+
                '      "Phones": ['+
                '        {'+
                '          "PhoneType": "DDI",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        },'+
                '        {'+
                '          "PhoneType": "DEFAULT",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        },'+
                '        {'+
                '          "PhoneType": "FAX",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        },'+
                '        {'+
                '          "PhoneType": "MOBILE",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        }'+
                '      ],'+
                '      "UpdatedDateUTC": "Date(1558439996670+0000)",'+
                '      "ContactGroups": [],'+
                '      "IsSupplier": true,'+
                '      "IsCustomer": false,'+
                '      "Balances": {'+
                '        "AccountsReceivable": {'+
                '          "Outstanding": 0.00,'+
                '          "Overdue": 0.00'+
                '        },'+
                '        "AccountsPayable": {'+
                '          "Outstanding": 9225.00,'+
                '          "Overdue": 4725.00'+
                '        }'+
                '      },'+
                '      "ContactPersons": [],'+
                '      "HasAttachments": false,'+
                '      "HasValidationErrors": false'+
                '    },'+
                '    {'+
                '      "ContactID": "8ec6988e-330d-481d-b240-34599e41a22e",'+
                '      "ContactStatus": "ACTIVE",'+
                '      "Name": "Smyle",'+
                '      "FirstName": "Matt",'+
                '      "LastName": "",'+
                '      "EmailAddress": "matt@smyle.co.uk",'+
                '      "BankAccountDetails": "",'+
                '      "Addresses": ['+
                '        {'+
                '          "AddressType": "STREET",'+
                '          "City": "",'+
                '          "Region": "",'+
                '          "PostalCode": "",'+
                '          "Country": "",'+
                '          "AttentionTo": ""'+
                '        },'+
                '        {'+
                '          "AddressType": "POBOX",'+
                '          "AddressLine1": "The Lockhouse, Mead Lane",'+
                '          "AddressLine2": "Hertford",'+
                '          "AddressLine3": "SG13 7AX",'+
                '          "AddressLine4": "UK",'+
                '          "City": "",'+
                '          "Region": "",'+
                '          "PostalCode": "",'+
                '          "Country": "",'+
                '          "AttentionTo": ""'+
                '        }'+
                '      ],'+
                '      "Phones": ['+
                '        {'+
                '          "PhoneType": "DDI",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        },'+
                '        {'+
                '          "PhoneType": "DEFAULT",'+
                '          "PhoneNumber": "01992- 535535",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        },'+
                '        {'+
                '          "PhoneType": "FAX",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        },'+
                '        {'+
                '          "PhoneType": "MOBILE",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        }'+
                '      ],'+
                '      "UpdatedDateUTC": "Date(1559028423203+0000)",'+
                '      "ContactGroups": [],'+
                '      "IsSupplier": false,'+
                '      "IsCustomer": true,'+
                '      "DefaultCurrency": "GBP",'+
                '      "ContactPersons": [],'+
                '      "HasAttachments": false,'+
                '      "HasValidationErrors": false'+
                '    },'+
                '    {'+
                '      "ContactID": "f3dbdb90-29d1-4c6c-b579-a61b112ad807",'+
                '      "ContactStatus": "ACTIVE",'+
                '      "Name": "Meridian Audio",'+
                '      "FirstName": "Shruthi",'+
                '      "LastName": "",'+
                '      "EmailAddress": "Accounts@meridian.co.uk",'+
                '      "BankAccountDetails": "",'+
                '      "Addresses": ['+
                '        {'+
                '          "AddressType": "STREET",'+
                '          "City": "",'+
                '          "Region": "",'+
                '          "PostalCode": "",'+
                '          "Country": "",'+
                '          "AttentionTo": ""'+
                '        },'+
                '        {'+
                '          "AddressType": "POBOX",'+
                '          "AddressLine1": "Latham Road",'+
                '          "AddressLine2": "Huntingdon",'+
                '          "AddressLine3": "Cambridgeshire PE29 6YE",'+
                '          "AddressLine4": "United Kingdom",'+
                '          "City": "",'+
                '          "Region": "",'+
                '          "PostalCode": "",'+
                '          "Country": "",'+
                '          "AttentionTo": ""'+
                '        }'+
                '      ],'+
                '      "Phones": ['+
                '        {'+
                '          "PhoneType": "DDI",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        },'+
                '        {'+
                '          "PhoneType": "DEFAULT",'+
                '          "PhoneNumber": "07921039017",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        },'+
                '        {'+
                '          "PhoneType": "FAX",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        },'+
                '        {'+
                '          "PhoneType": "MOBILE",'+
                '          "PhoneNumber": "",'+
                '          "PhoneAreaCode": "",'+
                '          "PhoneCountryCode": ""'+
                '        }'+
                '      ],'+
                '      "UpdatedDateUTC": "Date(1559034132097+0000)",'+
                '      "ContactGroups": [],'+
                '      "IsSupplier": false,'+
                '      "IsCustomer": true,'+
                '      "DefaultCurrency": "GBP",'+
                '      "ContactPersons": [],'+
                '      "HasAttachments": false,'+
                '      "HasValidationErrors": false'+
                '    },'+
                '      ],'+
                '      "UpdatedDateUTC": "Date(1559632071893+0000)",'+
                '      "ContactGroups": [],'+
                '      "IsSupplier": false,'+
                '      "IsCustomer": true,'+
                '      "DefaultCurrency": "GBP",'+
                '      "Balances": {'+
                '        "AccountsReceivable": {'+
                '          "Outstanding": 8156.70,'+
                '          "Overdue": 0.00'+
                '        },'+
                '        "AccountsPayable": {'+
                '          "Outstanding": 0.00,'+
                '          "Overdue": 0.00'+
                '        }'+
                '      },'+
                '      "ContactPersons": [],'+
                '      "HasAttachments": false,'+
                '      "HasValidationErrors": false'+
                '    },'+
                '      ],'+
                '      "UpdatedDateUTC": "Date(1565733664463+0000)",'+
                '      "ContactGroups": [],'+
                '      "IsSupplier": false,'+
                '      "IsCustomer": true,'+
                '      "DefaultCurrency": "GBP",'+
                '      "ContactPersons": [],'+
                '      "HasAttachments": false,'+
                '      "HasValidationErrors": false'+
                        '    }'+
                        '  ]'+
                        '}'+
                        '';
        JSONParserXeroContacts obj = JSONParserXeroContacts.parse(json);
        System.assert(obj != null);
    }

}