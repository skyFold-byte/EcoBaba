public with sharing class EcoConnectCertificateService {
 
    // Wrapper for Flow
    public class InputWrapper {
        @InvocableVariable(required=true)
        public Id volunteerId;
    }
 
    @InvocableMethod(label='Generate EcoConnect Certificate'
                     description='Generates certificate when volunteer completes 10 hours')
    public static void generateCertificate(List<InputWrapper> inputs) {
 
        if(inputs == null || inputs.isEmpty()){
            return;
        }
 
        for(InputWrapper input : inputs){
 
            // Null protection
            if(input == null || input.volunteerId == null){
                continue;
            }
 
            try {
 
                Id volunteerId = input.volunteerId;
 
                // Get Volunteer
                Volunteer__c vol = [
                    SELECT Id, Name, Email__c, Certificate_Issued__c
                    FROM Volunteer__c
                    WHERE Id = :volunteerId
                    LIMIT 1
                ];
 
                // Prevent duplicate certificate
                if(vol.Certificate_Issued__c == true){
                    continue;
                }
 
                // Calculate total attended hours using Aggregate
                AggregateResult result = [
                    SELECT SUM(Hours_Contributed__c) totalHours
                    FROM Drive_Participation__c
                    WHERE Volunteer__c = :volunteerId
                    AND Attendance_Status__c = 'Attended'
                ];
 
                Decimal totalHours = 0;
 
                if(result.get('totalHours') != null){
                    totalHours = (Decimal) result.get('totalHours');
                }
 
                // Only generate if >= 10 hours
                if(totalHours < 10){
                    continue;
                }
 
                // Generate PDF
                PageReference pdfPage = Page.EcoConnectCertificatePDF;
                pdfPage.getParameters().put('id', volunteerId);
                pdfPage.getParameters().put('hours', String.valueOf(totalHours));
 
                Blob pdfBlob = pdfPage.getContentAsPDF();
 
                // Save File
                ContentVersion cv = new ContentVersion();
                cv.Title = 'EcoConnect_Certificate_' + vol.Name;
                cv.PathOnClient = 'EcoConnect_Certificate.pdf';
                cv.VersionData = pdfBlob;
                cv.FirstPublishLocationId = volunteerId;
                insert cv;
 
                // Send Email (if email exists)
                if(vol.Email__c != null){
 
                    Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
                    attachment.setFileName('EcoConnect_Certificate.pdf');
                    attachment.setBody(pdfBlob);
                    attachment.setContentType('application/pdf');
 
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(new String[]{vol.Email__c});
                    mail.setSubject('Congratulations! Your EcoConnect Certificate');
                    mail.setPlainTextBody(
                        'Dear ' + vol.Name + ',\n\n' +
                        'Congratulations on completing ' + totalHours + ' hours of contribution.\n' +
                        'Your certificate is attached.\n\n' +
                        'Regards,\nEcoConnect Team'
                    );
                    mail.setFileAttachments(new Messaging.EmailFileAttachment[]{attachment});
 
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
                }
 
                // Mark certificate issued
                vol.Certificate_Issued__c = true;
                update vol;
 
            } catch(Exception e) {
                // Prevent Flow from breaking save
                System.debug('Certificate Generation Error: ' + e.getMessage());
            }
        }
    }
}