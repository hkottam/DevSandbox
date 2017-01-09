public with sharing class expenseController {
    
    @AuraEnabled
    public static List<expense__c> getExpenses(){
        
        return [Select Id, Name,Amount__c, Client__c, Date__c,
               Reimbursed__c, createdDate from Expense__c];
        
    }

}