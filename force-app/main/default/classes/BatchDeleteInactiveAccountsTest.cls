@isTest
private class BatchDeleteInactiveAccountsTest {
    @TestSetup
    static void makeData(){
        List<Account> listAcc = new List<Account>();
        listAcc.add(new Account(Name = 'Test Account 1'));
        listAcc.add(new Account(Name = 'Test Account 2'));

        insert listAcc;

        List<AccountHistory> listAccHistory = new List<AccountHistory>();
        // Crea un AccountHistory cuyo cambio fue hace mas de 6 meses 
        // Deberia eliminarse este Account
        listAccHistory.add(new AccountHistory(AccountId = listAcc[0].Id, Field = 'Active__c', OldValue = true, NewValue = false, CreatedDate = Datetime.now().addMonths(-7)));

        // Crea un AccountHistory para otra Account, y cuyo cambio fue hace solo 1 mes
        // No deberia eliminarse
        listAccHistory.add(new AccountHistory(AccountId = listAcc[1].Id, Field = 'Active__c', OldValue = true, NewValue = false, CreatedDate = Datetime.now().addMonths(-1)));
        
        insert listAccHistory;
    }

    @isTest
    static void executeTest() {
        System.assertEquals(2, [SELECT Id FROM Account WHERE NAME = 'Test Account 1' OR NAME = 'Test Account 2']);
        
    }
}