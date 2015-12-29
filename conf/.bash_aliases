########## Basic commands ##########
# allow aliases in sudo (http://askubuntu.com/a/22043)
alias sudo="sudo "
alias ll="ls -al"

########## PHP ##########
alias xdebugoff="sudo mv /etc/php5/apache2/conf.d/20-xdebug.ini /etc/php5/apache2/conf.d/20-xdebug.ini.bk && sudo service apache2 restart"
alias xdebugon="sudo mv /etc/php5/apache2/conf.d/20-xdebug.ini.bk /etc/php5/apache2/conf.d/20-xdebug.ini && sudo service apache2 restart"
