public class BatchDeleteInactiveAccounts implements Database.Batchable<SObject> {
  public QueryLocator start(Database.BatchableContext bc) {
    // Fue activado el History Tracking en el campo Active__c
    // Se obtiene todas las veces que se cambio el valor de Active__c, trayendo el Id del Account y la fecha en que sucedio
    return Database.getQueryLocator(
      'SELECT AccountId, Field, OldValue, NewValue, CreatedDate FROM AccountHistory WHERE Field = \"Active__c\"'
    );
  }

  public void execute(
    Database.BatchableContext bc,
    List<AccountHistory> listAccountHistory
  ) {
    if (!eventList.isEmpty()) {
      Map<Id, Datetime> mapAccLastUpdate = new Map<Id, Datetime>();
      for (AccountHistory accHistory : listAccountHistory) {
        // Si el campo Active paso a estar desactivado y ese account todavia no se encuentra en el map, agregarlo
        if (
          !accHistory.NewValue && !mapAccLastUpdate.get(accHistory.AccountId)
        ) {
          mapAccLastUpdate.put(accHistory.AccountId, accHistory.CreatedDate);
          // Si el campo Active paso a estar desactivado y la fecha es mayor a la actual en el map, cambiarla
          // porque se quiere que cada account Id este asociado a su ulitmo cambio
        } else if (
          !accHistory.NewValue &&
          mapAccLastUpdate.get(accHistory.AccountId) &&
          mapAccLastUpdate.get(accHistory.AccountId) < accHistory.CreatedDate
        ) {
          mapAccLastUpdate.get(accHistory.AccountId)
            .Field = accHistory.CreatedDate;
          // Si el campo paso a estar activado, se quita el account del map
        } else if (
          accHistory.NewValue &&
          mapAccLastUpdate.get(accHistory.AccountId) &&
          mapAccLastUpdate.get(accHistory.AccountId) < accHistory.CreatedDate
        ) {
          mapAccLastUpdate.remove(accHistory.AccountId);
        }
      }

      List<Id> listAccIds = new List<Id>();
      // itera sobre los accounts Ids del map
      for (Id accId : mapAccLastUpdate.keySet()) {
        // obtiene la ultima fecha de modificacion para cada uno, y si es mayor a 6 meses se incluye en la lista a eliminar
        if (mapAccLastUpdate.get(accId) < Datetime.now().addMonths(-6)) {
          listAccIds.add(accId);
        }
      }

      delete listAccIds;
    }
  }

  public void finish(Database.BatchableContext bc) {
    System.debug(bc);
  }
}
