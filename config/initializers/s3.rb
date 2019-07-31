if Rails.env == "production" 
   S3_CREDENTIALS = { 
     :access_key_id => 'AKIAJXHBB5NZM6KKEY6Q', 
     :secret_access_key => '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', 
     :bucket => 'apexadmissions_production'} 
 else 
   S3_CREDENTIALS = Rails.root.join("config/s3.yml")
end