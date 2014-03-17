# define: selinux::dircontext
#
# Change SELinux file security context.
#
# You can examine the current SELinux attributes on a file via 'ls -Z'.
# For example:
#
#     $ ls -Zd /dir
#     drwxrwxrwx. root apache unconfined_u:object_r:file_t:s0  /dir
#
# You might want to compare the folder that cannot be accessed by
# a given process (e.g. httpd) with one that can:
#
#     $ ls -Zd /var/www/html
#     drwxr-xr-x. root root system_u:object_r:httpd_sys_content_t:s0 /var/www/html
# To see all existing file paths with contexts set:
#     # semanage fcontext -l
#     SELinux fcontext       type               Context
#     /                      directory          system_u:object_r:root_t:s0 
#     /.*                    all files          system_u:object_r:default_t:s0 
#     [...]
#
# To allow httpd to access the /dir directory and everyting it contains,
# we want to use the httpd_sys_content_t SELinux type.  We can do so with
# the following rule:
#
#     selinux::dircontext { '/dir':
#       seltype => 'httpd_sys_content_t',
#     }
#
# This will run the 'semanage' and 'restorecon' tools to apply the specified
# SELinux Type to the specified object persistently and immediately,
# respectively.
#
# If the directory in question already has a unique type that you do not
# want to change, because it is needed for some other policy, you might
# prefer to instead create a new policy for httpd and install it, so that
# the web server can access files of this type as well.  See policy.pp.
#
define selinux::dircontext (
  $object = $title,
  $seltype
) {

  selinux::filecontext { $title:
    seltype => $seltype,
    recurse => true,
  }

}
