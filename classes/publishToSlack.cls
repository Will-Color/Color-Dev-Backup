public class publishToSlack{
     
    public class slackRequest { 
        @InvocableVariable(label='Slack Message' required=true) 
        public String slackMessage; 
        @InvocableVariable(label='Channel/User to post to' required=true) 
        public String channel; 
    } 
    
    @InvocableMethod(label='Publish to Slack')
    public static void publishToSlack(List<slackRequest> requests) {
        String webhookURL='https://hooks.slack.com/services/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'; 
        for(slackRequest r:requests){
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject(); //Inserts {
            gen.writeStringField('text', r.slackMessage);
            gen.writeStringField('channel', r.channel);
            gen.writeStringField('username', 'Adoptionbot');
            gen.writeStringField('icon_emoji', ':ticket:');
            gen.writeEndObject(); //Inserts }
 
            String body = gen.getAsString(); //Translates JSONGenerator to string to be passed to callout
            System.debug(body);
            System.enqueueJob(new qCallOut(webhookURL, 'POST', body));
        } 
    }
   
    public class qCallOut implements System.Queueable, Database.AllowsCallouts {
         
        private final String url;
        private final String method;
        private final String body;
         
        public qCallOut(String url, String method, String body) {
            this.url = url;
            this.method = method;
            this.body = body;
        }
         
        public void execute(System.QueueableContext ctx) {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod(method);
            req.setBody(body);
            Http http = new Http();
            HttpResponse res = http.send(req);
        }
    }
}