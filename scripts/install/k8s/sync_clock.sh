echo '同步时钟...'

yum install ntpdate -y
ntpdate time.windows.com

echo '同步时钟完成'
