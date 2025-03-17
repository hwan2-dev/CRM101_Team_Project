trigger LeadTrigger on Lead (after insert, before delete, after update) {
    
    if (Trigger.isAfter) {
        if (Trigger.isInsert) LeadTriggerHandler.afterInsert(Trigger.new);
        if (Trigger.isUpdate) LeadTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
    }

    if (Trigger.isBefore) {
        if (Trigger.isDelete) LeadTriggerHandler.beforeDelete(Trigger.old);
    }
}