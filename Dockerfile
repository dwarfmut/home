FROM centos:6
RUN rpm --nosignature -i https://repo.varnish-cache.org/redhat/varnish-4.0.el6.rpm
RUN rpm --import https://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs
RUN rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
RUN yum install -y puppet
RUN yum install -y epel-release
RUN yum install -y varnish
EXPOSE 80
ENTRYPOINT [ "/usr/sbin/varnishd", "-a", ":80", "-f", "/etc/varnish/default.vcl", "-T", "127.0.0.1:6082", "-d"]
