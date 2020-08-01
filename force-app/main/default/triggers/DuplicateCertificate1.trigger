trigger DuplicateCertificate1 on Certification_Request__c (before insert) {
    for(Certification_Request__c cr: trigger.new){
        for(Certification_Request__c cr1:[select Certification__c, Status__c,Employee_Id__c from Certification_Request__c]){
            if(cr.Certification__c == cr1.Certification__c || (cr.Employee_Id__c == cr1.Employee_Id__c && cr1.Status__c!='Passed')){
                cr.addError('This Certificate is already assigned.');
            }
        }
    }
}