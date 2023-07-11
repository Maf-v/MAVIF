public without sharing class AccountTriggerHandler {
  public static void activeValidation(List<Account> listAccounts) {
    for (Account acct : listAccounts) {
      if (acct.Active__c == true) {
        acct.addError('No puede ser eliminado porque se encuentra activo.');
      }
    }
  }
}
