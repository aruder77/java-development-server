# Java-development support-server on Ubuntu 12.04 using Vagrant

This project enables you to set up a support-server vm for Java development projects running Ubuntu 12.04, using
[Vagrant] and [Puppet]. 

It provides an Oracle 11g XE installation, a glassfish server, an LXDE desktop, an Oracle Java SDK, Apache Maven and more.

## Acknowledgements

This project was created based the GitHub repo [vagrant-ubuntu-oracle-xe] by Hilverd Reker which is itself based on the information in
[Installing Oracle 11g R2 Express Edition on Ubuntu 64-bit] by Manish Raj, and the GitHub repository
[vagrant-oracle-xe] by Stefan Glase. The former explains how to install Oracle XE 11g on Ubuntu
12.04, without explicitly providing a Vagrant or provisioner configuration. The latter has the same
purpose as this project but uses Ubuntu 11.10.

Thanks to André Kelpe, Brandon Gresham, Charles Walker, Chris Thompson, Jeff Caddel, Joe FitzGerald,
Justin Harringa, Mark Crossfield, Matthew Buckett, Richard Kolb, and Steven Hsu for various
contributions.

## Requirements

* You need to have [Vagrant] installed.
* The host machine probably needs at least 4 GB of RAM (I have only tested 8 GB of RAM).
* As Oracle 11g XE is only available for 64-bit machines at the moment, the host machine needs to
  have a 64-bit architecture.
* You may need to [enable virtualization] manually.

## Installation

* Check out this project:

        git clone https://github.com/aruder77/java-development-server.git

* Install [vbguest]:

        vagrant plugin install vagrant-vbguest

* Install [vagrant-proxyconf]

        vagrant plugin install vagrant-proxyconf 

* Download [Oracle Database 11g Express Edition] for Linux x64. Place the file
  `oracle-xe-11.2.0-1.0.x86_64.rpm.zip` in the directory `modules/oracle/files` of this
  project. (Alternatively, you could keep the zip file in some other location and make a hard link
  to it from `modules/oracle/files`.)

* Download [Oracle SDK for Java] for Linux x64. Place the file
  `jdk-7u51-linux-x64.gz` in the directory `modules/jdk/files` of this
  project. 
  
* Download [Oracle Glassfish Server]. Place the file
  `ogs-3.1.2.2.zip` in the directory `modules/glassfish/files` of this
  project. 

* Download [Apache Maven]. Place the file
  `apache-maven-3.0.5-bin.tar.gz` in the directory `modules/maven/files` of this
  project. 

* If you're behind a proxy-server, set the environment variables HTTP_PROXY and HTTPS_PROXY accordingly.

* Run `vagrant up` from the base directory of this project. This should take a few minutes. Please
  note that building the VM involves downloading an Ubuntu 12.04
  [base box](http://docs.vagrantup.com/v2/boxes.html) which is 323MB in size.

## Connecting

### Login

You should be automatically logged in as user/password `vagrant`/`vagrant`.

### Oracle

You should now be able to
[connect](http://www.oracle.com/technetwork/developer-tools/sql-developer/downloads/index.html) to
the new database at `localhost:1521/XE` as `system` with password `manager`. For example, if you
have `sqlplus` installed on the host machine you can do

    sqlplus system/manager@//localhost:1521/XE

To make sqlplus behave like other tools (history, arrow keys etc.) you can do this:

    rlwrap sqlplus system/manager@//localhost:1521/XE

You might need to add an entry to your `tnsnames.ora` file first:

    XE =
      (DESCRIPTION =
        (ADDRESS = (PROTOCOL = TCP)(HOST = 127.0.0.1)(PORT = 1521))
        (CONNECT_DATA =
          (SERVER = DEDICATED)
          (SERVICE_NAME = XE)
        )
      )

### Glassfish

Glassfish is installed in `/opt/glassfish3`. Is is not automatically started nor is a domain configured. The tool `asadmin` is on the path for user `vagrant`.

## Troubleshooting

It is important to assign enough memory to the virtual machine, otherwise you will get an error

    ORA-00845: MEMORY_TARGET not supported on this system

during the configuration stage. In the `Vagrantfile` 512 MB is assigned. Lower values may also work,
as long as (I believe) 2 GB of virtual memory is available for Oracle, swap is included in this
calculation.

If you want to raise the limit of the number of concurrent connections, say to 200, then according
to [How many connections can Oracle Express Edition (XE) handle?] you should run

    ALTER SYSTEM SET processes=200 scope=spfile

and restart the database.

[Vagrant]: http://www.vagrantup.com/

[Puppet]: http://puppetlabs.com/

[Oracle Database 11g Express Edition]: http://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html

[Oracle Database 11g EE Documentation]: http://docs.oracle.com/cd/E17781_01/index.htm

[Installing Oracle 11g R2 Express Edition on Ubuntu 64-bit]: http://meandmyubuntulinux.blogspot.co.uk/2012/05/installing-oracle-11g-r2-express.html

[Oracle SDK for Java]: http://www.oracle.com/technetwork/java/javase/downloads/index.html 

[Oracle Glassfish Server]: http://www.oracle.com/technetwork/java/javaee/downloads/index.html

[Apache Maven]: http://maven.apache.org/download.cgi

[vagrant-ubuntu-oracle-xe]: https://github.com/hilverd/vagrant-ubuntu-oracle-xe

[vagrant-oracle-xe]: https://github.com/codescape/vagrant-oracle-xe

[vbguest]: https://github.com/dotless-de/vagrant-vbguest

[How many connections can Oracle Express Edition (XE) handle?]: http://stackoverflow.com/questions/906541/how-many-connections-can-oracle-express-edition-xe-handle

[enable virtualization]: http://www.sysprobs.com/disable-enable-virtualization-technology-bios
