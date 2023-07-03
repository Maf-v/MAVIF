// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents
Profile p = [select id from Profile where name='Chatter Free User'];

		String json = '[{\"firstName\":\"Madeleine\",\"lastName\":\"Dawson\",\"email\":\"mdawson0@drupal.org\"},'+
		'{\"firstName\":\"Isidor\",\"lastName\":\"Holtaway\",\"email\":\"iholtaway1@pen.io\"},'+
		'{\"firstName\":\"Mattias\",\"lastName\":\"Parrish\",\"email\":\"mparrish2@joomla.org\"},'+
		'{\"firstName\":\"Ariel\",\"lastName\":\"Rissom\",\"email\":\"arissom3@ibm.com\"},'+
		'{\"firstName\":\"Leola\",\"lastName\":\"Jacobbe\",\"email\":\"ljacobbe4@deliciousdays.com\"},'+
		'{\"firstName\":\"Thomasa\",\"lastName\":\"Sarfas\",\"email\":\"tsarfas5@4shared.com\"},'+
		'{\"firstName\":\"Elane\",\"lastName\":\"Arrigucci\",\"email\":\"earrigucci6@ftc.gov\"},'+
		'{\"firstName\":\"Holly-anne\",\"lastName\":\"Fawlo\",\"email\":\"hfawlo7@symantec.com\"},'+
		'{\"firstName\":\"Whitney\",\"lastName\":\"Mixworthy\",\"email\":\"wmixworthy8@qq.com\"},'+
		'{\"firstName\":\"Basilius\",\"lastName\":\"Pol\",\"email\":\"bpol9@mozilla.com\"},'+
		'{\"firstName\":\"Ted\",\"lastName\":\"Guierre\",\"email\":\"tguierrea@gravatar.com\"},'+
		'{\"firstName\":\"Godfrey\",\"lastName\":\"Fosse\",\"email\":\"gfosseb@senate.gov\"},'+
		'{\"firstName\":\"Karina\",\"lastName\":\"Kain\",\"email\":\"kkainc@bing.com\"},'+
		'{\"firstName\":\"Jodee\",\"lastName\":\"Bacop\",\"email\":\"jbacopd@i2i.jp\"},'+
		'{\"firstName\":\"Esther\",\"lastName\":\"Huskisson\",\"email\":\"ehuskissone@multiply.com\"},'+
		'{\"firstName\":\"Fedora\",\"lastName\":\"Barbe\",\"email\":\"fbarbef@comsenz.com\"},'+
		'{\"firstName\":\"Mandy\",\"lastName\":\"Mc Curlye\",\"email\":\"mmccurlyeg@jimdo.com\"},'+
		'{\"firstName\":\"Graham\",\"lastName\":\"Chaddock\",\"email\":\"gchaddockh@g.co\"},'+
		'{\"firstName\":\"Burch\",\"lastName\":\"Lapley\",\"email\":\"blapleyi@zdnet.com\"},'+
		'{\"firstName\":\"Gayelord\",\"lastName\":\"Collumbell\",\"email\":\"gcollumbellj@businessweek.com\"},'+
		'{\"firstName\":\"Stacee\",\"lastName\":\"Insoll\",\"email\":\"sinsollk@shop-pro.jp\"},'+
		'{\"firstName\":\"Carolann\",\"lastName\":\"Whalley\",\"email\":\"cwhalleyl@wordpress.com\"},'+
		'{\"firstName\":\"Davide\",\"lastName\":\"Bart\",\"email\":\"dbartm@amazon.de\"},'+
		'{\"firstName\":\"Tova\",\"lastName\":\"Willbond\",\"email\":\"twillbondn@yandex.ru\"},'+
		'{\"firstName\":\"Jenelle\",\"lastName\":\"Lyffe\",\"email\":\"jlyffeo@cnbc.com\"},'+
		'{\"firstName\":\"Sheelagh\",\"lastName\":\"McCuis\",\"email\":\"smccuisp@sbwire.com\"},'+
		'{\"firstName\":\"Alexandre\",\"lastName\":\"Bowdrey\",\"email\":\"abowdreyq@drupal.org\"},'+
		'{\"firstName\":\"Nana\",\"lastName\":\"Scanlin\",\"email\":\"nscanlinr@friendfeed.com\"},'+
		'{\"firstName\":\"Kristo\",\"lastName\":\"Tejada\",\"email\":\"ktejadas@upenn.edu\"},'+
		'{\"firstName\":\"Yul\",\"lastName\":\"Balchin\",\"email\":\"ybalchint@exblog.jp\"}]';

List<JSON2Apex> listObj = JSON2Apex.parse(json);

WorkTypeGroup WTG = [SELECT Id FROM WorkTypeGroup WHERE Name = 'Psicologia'];

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
    Shift newShift = new Shift(StartTime = DateTime.now(), EndTime = DateTime.now().addMinutes(15), WorkTypeId = null, WorkTypeGroupId = WTG.Id, ServiceResourceId = servResource.Id);
	listShifts.add(newShift);
}

insert listShifts;
System.debug(listShifts);