CarrierWave.configure do |config|
	if Rails.env.development? or Rails.env.test?
		config.storage = :file
	else
		config.fog_credentials = {
			:provider               => 'AWS',
			:aws_access_key_id      => '',
			:aws_secret_access_key  => '',
			:region                 => ''
		}
		config.fog_directory  = ""
		config.fog_attributes = {'Cache-Control'=>"max-age=#{365.day.to_i}"} # optional, defaults to {} 
	end
end