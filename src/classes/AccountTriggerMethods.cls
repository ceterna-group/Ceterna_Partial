public with sharing class AccountTriggerMethods 
{/*
	public static void createProjectLines(Map<ID,Account> mapOldAccounts, Map<ID,Account> mapNewAccounts)
	{
		List<Project_Line__c> lstProjectLines = new List<Project_Line__c>();

		Map<ID,Set<String>> mapAccountIdProjectLines = new Map<ID,Set<String>>();
		
		System.debug('mapOldAccounts : ' + mapOldAccounts);
		
		if(mapOldAccounts != null)
		{
			System.debug('mapNewAccounts.keySet() : ' + mapNewAccounts.keySet());
			
			Map<ID,Project_Line__c> mapProjectLines = new Map<ID,Project_Line__c>([Select Id, Name, Account__c from Project_Line__c where Account__c in :mapNewAccounts.keySet()]);
			
			System.debug('mapProjectLines : ' + mapProjectLines);
			
			if(mapProjectLines != null && !mapProjectLines.isEmpty())
			{
				for(Project_Line__c pl : mapProjectLines.values())
				{
					if(!mapAccountIdProjectLines.containsKey(pl.Account__c))
					{
						Set<String> projectLineNames = new Set<String>();
						mapAccountIdProjectLines.put(pl.Account__c, projectLineNames);
					}

					mapAccountIdProjectLines.get(pl.Account__c).add(pl.Name);
				}
			}
		}
		
		System.debug('mapAccountIdProjectLines : ' + mapAccountIdProjectLines);
		
		
		for(Account acc : mapNewAccounts.values())
		{
			// Appraisals
			if((mapOldAccounts == null && acc.Appraisals__c == true) || (acc.Appraisals__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Appraisals__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Appraisals';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}
			
			// Associate Management
			if((mapOldAccounts == null && acc.Associate_management__c == true) || (acc.Associate_management__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Associate_management__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Associate Management';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}
			
			// Campaigns Management
			if((mapOldAccounts == null && acc.Campaigns_management__c == true) || (acc.Campaigns_management__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Campaigns_management__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Campaigns Management';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}
			
			// Contract Management
			if((mapOldAccounts == null && acc.Contract_management__c == true) || (acc.Contract_management__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Contract_management__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Contract Management';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}
			
			// Credit Control
			if((mapOldAccounts == null && acc.Credit_Control__c == true) || (acc.Credit_Control__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Credit_Control__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Credit Control';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}
			
			// Customer Services
			if((mapOldAccounts == null && acc.Customer_Services__c == true) || (acc.Customer_Services__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Customer_Services__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Customer Services';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}

			// Event Management
			if((mapOldAccounts == null && acc.Event_management__c == true) || (acc.Event_management__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Event_management__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Event Management';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}

			// Expense Management
			if((mapOldAccounts == null && acc.Expense_management__c == true) || (acc.Expense_management__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Expense_management__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Expense Management';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}

			// Expenses
			if((mapOldAccounts == null && acc.Expenses__c == true) || (acc.Expenses__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Expenses__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Expenses';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}

			// Field Sales
			if((mapOldAccounts == null && acc.Field_Sales__c == true) || (acc.Field_Sales__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Field_Sales__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Field Sales';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}

			System.debug('Field Support : ' + acc.Field_support__c);
			
			// Field Support
			if((mapOldAccounts == null && acc.Field_support__c == true) || (acc.Field_support__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Field_support__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Field Support';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					System.debug('mapAccountIdProjectLines.isEmpty() : ' + mapAccountIdProjectLines.isEmpty());
					
					if(!mapAccountIdProjectLines.isEmpty())
					{
						System.debug('mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)) : ' + mapAccountIdProjectLines.get(acc.Id).contains(pl.Name));
						System.debug('mapAccountIdProjectLines.containsKey(acc.Id) : ' + mapAccountIdProjectLines.containsKey(acc.Id));
					}
					
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}
			
			// Grading
			if((mapOldAccounts == null && acc.Grading__c == true) || (acc.Grading__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Grading__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Grading';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}
			
			// In House Support Desk
			if((mapOldAccounts == null && acc.In_house_support_desk__c == true) || (acc.In_house_support_desk__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).In_house_support_desk__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'In House Support Desk';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}


			// Internal Sales
			if((mapOldAccounts == null && acc.Internal_Sales__c == true) || (acc.Internal_Sales__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Internal_Sales__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Internal Sales';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}

			// Price Books
			if((mapOldAccounts == null && acc.Price_books__c == true) || (acc.Price_books__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Price_books__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Price Books';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}

			// Product Configuration
			if((mapOldAccounts == null && acc.Product_configuration__c == true) || (acc.Product_configuration__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Product_configuration__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Product Configuration';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}

			// Product Management
			if((mapOldAccounts == null && acc.Product_management__c == true) || (acc.Product_management__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Product_management__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Product Management';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}

			// Project Management
			if((mapOldAccounts == null && acc.Project_management__c == true) || (acc.Project_management__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Project_management__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Project Management';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}

			// Recruitment
			if((mapOldAccounts == null && acc.Recruitment__c == true) || (acc.Recruitment__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Recruitment__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Recruitment';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}

			// Reseller Sales
			if((mapOldAccounts == null && acc.Reseller_Sales__c == true) || (acc.Reseller_Sales__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Reseller_Sales__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Reseller Sales';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}

			// Resource Management
			if((mapOldAccounts == null && acc.Resource_management__c == true) || (acc.Resource_management__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Resource_management__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Resource Management';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}

			// Salary Reviews
			if((mapOldAccounts == null && acc.Salary_reviews__c == true) || (acc.Salary_reviews__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Salary_reviews__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Salary Reviews';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}

			// Satisfaction Surveys
			if((mapOldAccounts == null && acc.Satisfaction_surveys__c == true) || (acc.Satisfaction_surveys__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Satisfaction_surveys__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Satisfaction Surveys';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}
			
			// Service Provider Management
			if((mapOldAccounts == null && acc.Service_provider_management__c == true) || (acc.Service_provider_management__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Service_provider_management__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Service Provider Management';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}

			// Social Media
			if((mapOldAccounts == null && acc.Social_Media__c == true) || (acc.Social_Media__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Social_Media__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Social Media';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}
			
			// Telemarketing
			if((mapOldAccounts == null && acc.Telemarketing__c == true) || (acc.Telemarketing__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Telemarketing__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Telemarketing';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}

			// Time Management
			if((mapOldAccounts == null && acc.Time_management__c == true) || (acc.Time_management__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Time_management__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Time Management';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}

			// Training
			if((mapOldAccounts == null && acc.Training__c == true) || (acc.Training__c == true && mapOldAccounts != null && mapOldAccounts.get(acc.Id).Training__c == false))
			{
				Project_Line__c pl = new Project_Line__c();
				pl.Name = 'Training';
				pl.Account__c = acc.Id;
				
				if(mapOldAccounts != null)
				{
					if(!(!mapAccountIdProjectLines.isEmpty() && mapAccountIdProjectLines.containsKey(acc.Id) && mapAccountIdProjectLines.get(acc.Id).contains(pl.Name)))
					{
						lstProjectLines.add(pl);		
					}
				}
				else
				{
					lstProjectLines.add(pl);
				}
			}
		}
		
		
		//if(lstProjectLines.size() > 0)
		//{
		//	insert lstProjectLines;
		//}
	}*/
}