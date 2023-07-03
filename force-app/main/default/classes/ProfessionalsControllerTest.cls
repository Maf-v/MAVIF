@isTest
private class ProfessionalsControllerTest {
    @TestSetup
    static void makeData(){
        Profile p = [select id from Profile where name='Chatter Free User'];

		String json = '[{\"firstName\":\"Gerardo\",\"lastName\":\"Houten\",\"email\":\"ghouten0@delicious.com\"},'+
		'{\"firstName\":\"Grace\",\"lastName\":\"Dingate\",\"email\":\"gdingate1@mozilla.com\"},'+
		'{\"firstName\":\"Ermanno\",\"lastName\":\"Karys\",\"email\":\"ekarys2@dailymail.co.uk\"},'+
		'{\"firstName\":\"Brnaby\",\"lastName\":\"Terrington\",\"email\":\"bterrington3@ebay.co.uk\"},'+
		'{\"firstName\":\"Kristos\",\"lastName\":\"Fursey\",\"email\":\"kfursey4@angelfire.com\"},'+
		'{\"firstName\":\"Kliment\",\"lastName\":\"Bruneton\",\"email\":\"kbruneton5@google.de\"},'+
		'{\"firstName\":\"Arthur\",\"lastName\":\"Shirrell\",\"email\":\"ashirrell6@goodreads.com\"},'+
		'{\"firstName\":\"Korey\",\"lastName\":\"Quaif\",\"email\":\"kquaif7@joomla.org\"},'+
		'{\"firstName\":\"Giustina\",\"lastName\":\"Robinette\",\"email\":\"grobinette8@phpbb.com\"},'+
		'{\"firstName\":\"Carlyn\",\"lastName\":\"Stayte\",\"email\":\"cstayte9@yelp.com\"},'+
		'{\"firstName\":\"Debby\",\"lastName\":\"Beneteau\",\"email\":\"dbeneteaua@google.es\"},'+
		'{\"firstName\":\"Andonis\",\"lastName\":\"Whotton\",\"email\":\"awhottonb@wunderground.com\"},'+
		'{\"firstName\":\"Demeter\",\"lastName\":\"Arndt\",\"email\":\"darndtc@nasa.gov\"},'+
		'{\"firstName\":\"Imogene\",\"lastName\":\"Duffill\",\"email\":\"iduffilld@bloglines.com\"},'+
		'{\"firstName\":\"Beckie\",\"lastName\":\"Allibon\",\"email\":\"ballibone@yellowbook.com\"},'+
		'{\"firstName\":\"Hyacinthe\",\"lastName\":\"Bartell\",\"email\":\"hbartellf@jimdo.com\"},'+
		'{\"firstName\":\"Lamont\",\"lastName\":\"Simmance\",\"email\":\"lsimmanceg@scientificamerican.com\"},'+
		'{\"firstName\":\"Lucinda\",\"lastName\":\"Alonso\",\"email\":\"lalonsoh@php.net\"},'+
		'{\"firstName\":\"Geralda\",\"lastName\":\"Baltrushaitis\",\"email\":\"gbaltrushaitisi@japanpost.jp\"},'+
		'{\"firstName\":\"Joshia\",\"lastName\":\"Bend\",\"email\":\"jbendj@pinterest.com\"},'+
		'{\"firstName\":\"Denny\",\"lastName\":\"Newitt\",\"email\":\"dnewittk@printfriendly.com\"},'+
		'{\"firstName\":\"Peta\",\"lastName\":\"Doudney\",\"email\":\"pdoudneyl@unicef.org\"},'+
		'{\"firstName\":\"Ray\",\"lastName\":\"Haughian\",\"email\":\"rhaughianm@bbb.org\"},'+
		'{\"firstName\":\"Susanne\",\"lastName\":\"Southern\",\"email\":\"ssouthernn@youku.com\"},'+
		'{\"firstName\":\"Kiele\",\"lastName\":\"Kunzler\",\"email\":\"kkunzlero@xinhuanet.com\"},'+
		'{\"firstName\":\"Gabbie\",\"lastName\":\"Zink\",\"email\":\"gzinkp@harvard.edu\"},'+
		'{\"firstName\":\"Christopher\",\"lastName\":\"Jellett\",\"email\":\"cjellettq@domainmarket.com\"},'+
		'{\"firstName\":\"Hanna\",\"lastName\":\"Jerosch\",\"email\":\"hjeroschr@epa.gov\"},'+
		'{\"firstName\":\"Vincents\",\"lastName\":\"Gaythor\",\"email\":\"vgaythors@pbs.org\"},'+
		'{\"firstName\":\"Genia\",\"lastName\":\"Stegers\",\"email\":\"gstegerst@google.ru\"}]';

        List<JSON2Apex> listObj = JSON2Apex.parse(json);

        WorkTypeGroup wTG = new WorkTypeGroup(Name = 'Test WTG', GroupType = 'Default');
        insert wTG;

        List<User> listUsers = new List<User>();

        for(Integer i = 0; i < listObj.size(); i++){
                String alias = listObj[i].lastName + i + 'test';
                User u = new User(alias = alias.substring(0, 5), email='test' + listObj[i].email,
                        emailencodingkey='UTF-8', firstName=listObj[i].firstName, lastname=listObj[i].lastName, languagelocalekey='en_US',
                        localesidkey='en_US', profileid = p.id,
                        timezonesidkey='Europe/London', username='test' + listObj[i].email);
            listUsers.add(u);
        }

        insert listUsers;

        List<ServiceResource> listServResources = new List<ServiceResource>();
        for(User newUser : listUsers){
            ServiceResource servResource = new ServiceResource(RelatedRecordId = newUser.Id, ResourceType = 'T', Name = newUser.firstName + ' ' + newUser.lastName, IsActive = true);
            listServResources.add(servResource);
        }

        insert listServResources;

        List<Shift> listShifts = new List<Shift>();
        for(ServiceResource servResource : listServResources){
            Shift newShift = new Shift(StartTime = DateTime.now(), EndTime = DateTime.now().addMinutes(15), WorkTypeId = null, WorkTypeGroupId = wTG.Id, ServiceResourceId = servResource.Id);
            listShifts.add(newShift);
        }

        insert listShifts;

        List<ServiceAppointment> listServAppointment = new List<ServiceAppointment>();
        for(Integer i = 0; i < listObj.size(); i++) {
            ServiceAppointment newServAppointment = new ServiceAppointment(ParentRecordId = '0016e00003N4TTsAAN', EarliestStartTime = DateTime.now(), DueDate = DateTime.now(), Status = 'Scheduled');
            listServAppointment.add(newServAppointment);
        }

        insert listServAppointment;

        Map<Integer,String> comentarios = new Map<Integer,String>{1 => 'No demostro interes en mi problema', 2 => 'No me senti comodo', 3 => 'No fue puntual', 4 => '¡Muy profesional!',5 => '¡Excelente profesional! Recomendado.'};

        List<Review__c> listReviews = new List<Review__c>();
        for(ServiceAppointment servAppointment : listServAppointment) {
            Integer random = Integer.valueof((Math.random() * 5) + 1);
            Review__c newReview = new Review__c(Name = servAppointment.AppointmentNumber, Service_Appointment__c = servAppointment.Id, Valoracion__c = random, Comentario__c = comentarios.get(random));
            listReviews.add(newReview);
        } 

        insert listReviews;

        List<AssignedResource> listAssigResource = new List<AssignedResource>();
        for(Integer i = 0; i < listObj.size(); i++) {
            AssignedResource newAssigResource = new AssignedResource(ServiceAppointmentId = listServAppointment[i].Id, ServiceResourceId = listServResources[i].Id);
            listAssigResource.add(newAssigResource);
        }

        insert listAssigResource;
    }

    @isTest
    static void getProfessionalsByTypeTest() {

        List<User> listUser = [SELECT Id FROM User WHERE CreatedDate = TODAY];
        System.assertEquals(30, listUser.size());

        List<ServiceResource> listProfessionals = ProfessionalsController.getProfessionalsByType('Test WTG');
        System.assertEquals(30, listProfessionals.size());
    }

    @isTest
    static void getReviewsByProfessionalNameTest(){
        List<User> listUser = [SELECT Id FROM User WHERE CreatedDate = TODAY];
        System.assertEquals(30, listUser.size());

        List<Review__c> listReviews = ProfessionalsController.getReviewsByProfessionalName('Grace Dingate');
        System.assertEquals(1, listReviews.size());
    }
}