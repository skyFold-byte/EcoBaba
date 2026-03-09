public WITHOUT SHARING class EcoAuthController {

    @AuraEnabled
    public static String registerUser(String fName, String lName, String email, String password) {
        try {
            // 1. Fetch the 'Citizen' Account
            List<Account> accs = [SELECT Id, Owner.UserRoleId FROM Account WHERE Name = 'Citizen' LIMIT 1];
            if (accs.isEmpty()) throw new AuraHandledException('Account "Citizen" not found.');
            
            // 2. Owner Role Check (The #1 reason User creation fails)
            if (accs[0].Owner.UserRoleId == null) {
                throw new AuraHandledException('The owner of the "Citizen" account must have a Role assigned.');
            }

            // 3. Prepare User Object
            User u = new User();
            u.FirstName = fName;
            u.LastName = lName;
            u.Email = email;
            u.Username = email + '.ecobaba'; // Append suffix for global uniqueness
            u.CommunityNickname = fName + '_' + Crypto.getRandomInteger();
            
            // 4. Create User
            // This method creates the Contact and User in one atomic transaction.
            // If the User fails, the Contact will NOT be orphaned.
            String userId = Site.createExternalUser(u, accs[0].Id, password);
            
            if (userId == null) {
                throw new AuraHandledException('Platform rejected user creation. Check Password Policies.');
            }
            return userId;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String loginUser(String username, String password) {
        // Ensure we check for the suffix if they only entered the email
        String fullUsername = username.contains('.ecobaba') ? username : username + '.ecobaba';
        
        ApexPages.PageReference lgn = Site.login(fullUsername, password, '/');
        if (lgn != null) return lgn.getUrl();
        
        throw new AuraHandledException('Login failed. Please check your credentials.');
    }

}