@isTest
private without sharing class AccountTriggerHandlerTest {
  @TestSetup
  static void makeData() {
    List<Account> listAccounts = new List<Account>();
    listAccounts.add(new Account(LastName = 'Test1', Active__c = true));
    listAccounts.add(new Account(LastName = 'Test2', Active__c = false));
    insert listAccounts;
  }

  @isTest
  static void activeValidationTest() {
    List<Account> listAccounts = [
      SELECT Id, Active__c
      FROM Account
      WHERE LastName LIKE 'Test%'
      LIMIT 2
    ];

    Test.startTest();
    List<Database.DeleteResult> dbDeleteResults = Database.delete(
      listAccounts,
      false
    );
    System.assertEquals(
      2,
      dbDeleteResults.size(),
      'Se realizaron dos operaciones DML'
    );
    Test.stopTest();

    List<Database.Error> errors = new List<Database.Error>();
    for (Database.DeleteResult dbDeleteResult : dbDeleteResults) {
      if (!dbDeleteResult.isSuccess()) {
        errors.add(dbDeleteResult.getErrors().get(0));
      }
    }
    System.assertEquals(1, errors.size(), 'Una de las operaciones dio error');
  }
}
