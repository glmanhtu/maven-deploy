
# Your application name
default['maven-deploy']['application']['name'] = ''

default['maven-deploy']['application']['port'] = 8080

default['maven-deploy']['application']['integration-test'] = true

default['maven-deploy']['application']['ssl']['enable'] = false

default['maven-deploy']['application']['ssl']['key_store'] = ''

default['maven-deploy']['application']['ssl']['key_store_password'] = ''

default['maven-deploy']['application']['ssl']['trust_store'] = ''

default['maven-deploy']['application']['ssl']['trust_store_password'] = ''

default['maven-deploy']['application']['prevent-deploy-file'] = 'application.status'

# Location, which our application will save
default['maven-deploy']['dir'] = '/usr/local/maven-deploy'

# Execute your main maven application
default['maven-deploy']['jar']['name'] = ''

# Location of your executable jar, usually in target
default['maven-deploy']['jar']['location'] = 'target'

# JVM argument 
default['maven-deploy']['jar']['arg']	=	''

# Default spring active profile
default['maven-deploy']['profile'] = 'production'

# Your git URL
# Please make sure your host machine can connect & clone source code from this git
default['maven-deploy']['git']['url'] = ''

# Select git branch
default['maven-deploy']['git']['branch'] = 'master'
default['maven-deploy']['git']['private'] = false
default['maven-deploy']['git']['databag']['name'] = 'databag'
default['maven-deploy']['git']['databag']['key'] = 'private'
default['maven-deploy']['git']['databag']['property'] = 'private_ssh_key'


default['maven-deploy']['forward']['enable'] = false
default['maven-deploy']['forward']['from']['host'] = ''
default['maven-deploy']['forward']['from']['port'] = '80'
default['maven-deploy']['forward']['to']['host'] = ''
default['maven-deploy']['forward']['to']['port'] = '8080'