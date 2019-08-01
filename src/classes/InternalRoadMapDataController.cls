public with sharing class InternalRoadMapDataController 
{/*
	public Account customer {get; private set;}
	public List<ProjectLine> data {get; private set;}
		
	public InternalRoadMapDataController(ApexPages.StandardController stdController)
	{
		data = new List<ProjectLine>();
		
		customer = (Account)stdController.getRecord();
		
		// get project lines
		Map<ID,Project_Line__c> mapProjectLines = new Map<ID,Project_Line__c>([Select Id, Name, Start_Date__c, End_Date__c, Status__c, DT_Progress__c from Project_Line__c where Account__c =:customer.Id]);
		
		if(mapProjectLines != null && !mapProjectLines.isEmpty())
		{
			for(Project_Line__c pl : mapProjectLines.values())
			{
				string title = pl.Name + ' (' + pl.Status__c + ') ' + pl.DT_Progress__c + '%';
				data.add(new ProjectLine(pl.Id, title, pl.Name, pl.Name, pl.Status__c, pl.Start_Date__c, pl.End_Date__c, 'https://c.eu1.content.force.com/servlet/servlet.ImageServer?id=015D0000000tbUT&oid=00DD0000000Cl9q', true));
			}
		}
		
		// get tasks
		Set<ID> taskWhatIds = new Set<ID>();
		if(mapProjectLines != null && !mapProjectLines.isEmpty())
		{
			taskWhatIds.addAll(mapProjectLines.keySet());	
		}
		taskWhatIds.add(customer.Id);
		
		List<Task> lstTasks = [Select Id, Subject, Status, ActivityDate from Task where WhatId in :taskWhatIds];
		if(lstTasks != null && lstTasks.size() > 0)
		{
			for(Task t : lstTasks)
			{
				string img = '/img/icon/calendar16.png';
				if(t.Subject != null && t.Subject != '')
				{
					if (t.Subject.startsWith('SFDC Upsell'))
                    {
                        img = 'https://c.eu1.content.force.com/servlet/servlet.ImageServer?id=015D0000000tatg&oid=00DD0000000Cl9q';
                    }
                    else if (t.Subject.StartsWith('SFDC New Licenses'))
                    {
                        img = 'https://c.eu1.content.force.com/servlet/servlet.ImageServer?id=015D0000000tatg&oid=00DD0000000Cl9q';
                    }
                    else if (t.Subject.StartsWith('Review Call'))
                    {
                        img = 'https://c.eu1.content.force.com/servlet/servlet.ImageServer?id=015D0000000tatl&oid=00DD0000000Cl9q';
                    }
				}
				
				data.add(new ProjectLine(t.Id, t.Subject, t.Subject, t.Subject, t.Status, t.ActivityDate, t.ActivityDate, img, false));
			}
		}
		
		// get events
		Set<ID> eventWhatIds = new Set<ID>();
		if(mapProjectLines != null && !mapProjectLines.isEmpty())
		{
			eventWhatIds.addAll(mapProjectLines.keySet());	
		}
		eventWhatIds.add(customer.Id);
		
		List<Event> lstEvents = [Select Id, Subject, ActivityDate from Event where WhatId in :eventWhatIds];
		if(lstEvents != null && lstEvents.size() > 0)
		{
			for(Event e : lstEvents)
			{
				data.add(new ProjectLine(e.Id, e.Subject, e.Subject, e.Subject, '', e.ActivityDate, e.ActivityDate, '/img/icon/calendar16.png', false));
			}
		}
		
		// get Opportunities
		List<Opportunity> lstOpportunities = [Select Id, Name, CloseDate from Opportunity where AccountId =:customer.Id];
		if(lstOpportunities != null && lstOpportunities.size() > 0)
		{
			for(Opportunity o : lstOpportunities)
			{
				data.add(new ProjectLine(o.Id, o.Name, o.Name, o.Name, '', o.CloseDate, o.CloseDate, '/img/icon/opportunities16.png', false));
			}
		}
	}
	
	public string getXMLData()
	{
		XmlStreamWriter w = new XmlStreamWriter();
	    w.writeStartDocument('UTF-8', '1.0');
	    w.writeStartElement(null, 'data', null);
	    
	    if(data != null && data.size() > 0)
	    {
	    	System.debug('data : ' + data);
	    	
	    	for(ProjectLine pl : data)
	    	{
	    		string startDate = '';
	    		string endDate = '';
	    		
	    		System.debug('pl.name start : ' + pl.name);
	    		System.debug('pl.startDate : ' + pl.startDate);	
	    		System.debug('pl.endDate : ' + pl.endDate);
	    				
	    		if(pl.startDate != null)
	    		{
	    			startDate = datetime.newInstance(pl.startDate, Time.newInstance(0, 0, 0, 0)).format('MM/dd/yyyy');
	    			System.debug('startDate : ' + startDate);	
	    		}
	    		
	    		if(pl.endDate != null)
	    		{
	    			endDate = datetime.newInstance(pl.endDate, Time.newInstance(0, 0, 0, 0)).format('MM/dd/yyyy');
	    			System.debug('endDate : ' + endDate);
	    		}
	    		
	    		if(startDate != '' && endDate != '')
	    		{
		    		// start event tag
		    		w.writeStartElement(null, 'event', null);
		    		
		    		w.writeAttribute(null, null, 'start', startDate);
		    		w.writeAttribute(null, null, 'end', endDate);
		    		w.writeAttribute(null, null, 'title', pl.title);
		    		w.writeAttribute(null, null, 'link', '/' + pl.id);
		    		w.writeAttribute(null, null, 'icon', pl.icon);
		    		w.writeAttribute(null, null, 'color', pl.color);
		    		w.writeAttribute(null, null, 'textColor', '#000000');
		    		w.writeAttribute(null, null, 'isDuration', string.valueOf(pl.isDuration));
		    		w.writeAttribute(null, null, 'description', 'description');
	    		
		    		w.writeCharacters('Name: ' + pl.name);
		    		 
		    		// end event tag
		    		w.writeEndElement();
		    		
		    		System.debug('pl.name end : ' + pl.name);
	    		}
	    	}
	    }
	    
      	w.writeEndElement(); //end data  

      	w.writeEndDocument();
      	String xmlOutput = w.getXmlString();
      	w.close();
      
      	return xmlOutput;
	}
	
	public class ProjectLine
	{
		public string id {get; private set;}
		public string title {get; private set;}
		public string name {get; private set;}
		public string description {get; private set;}
		public Date startDate {get; private set;}
		public Date endDate {get; private set;}
		public string icon {get; private set;}
		public boolean isDuration {get; private set;}
		public string color {get; private set;}
		 
		public ProjectLine(string recId, string t, string n, string d, string s, Date dtStart, Date dtEnd, string i, boolean b)
		{
			id = recId;
			title = t;
			name = n;
			description = d;
			startDate = dtStart;
			endDate = dtEnd;
			icon = i;
			isDuration = b;
			
			s = s.toLowerCase();
			
			if(s == 'potential')
			{
				color = '#FF0000'; // red
			}
			else if(s == 'pending')
			{
				color = '#0000FF'; // blue
			}
			else if(s == 'in progress')
			{
				color = '#FF8040'; // Orange
			}
			else if(s == 'completed')
			{
				color = '#00FF00'; // Green
			}
			else if(s == 'declined')
			{
				color = '#999999'; // Grey
			}
			else
			{
				color = '#000000';
			}
		}
	}*/
}