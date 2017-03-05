
# Your application name
default['maven-deploy']['application']['name'] = ''

# Location, which our application will save
default['maven-deploy']['dir'] = '/usr/local/maven-deploy'

# Execute your main maven application
default['maven-deploy']['jar']['name'] = ''

# Location of your executable jar, usually in target
default['maven-deploy']['jar']['location'] = 'target'

# Default spring active profile
default['maven-deploy']['profile'] = 'production'

# Your git URL
# Please make sure your host machine can connect & clone source code from this git
default['maven-deploy']['git']['url'] = ''

# Select git branch
default['maven-deploy']['git']['branch'] = 'master'
default['maven-deploy']['git']['key'] = ''


