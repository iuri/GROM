#      Initializes datastrctures for the installer.

#      @creation-date 02 October 2000
#      @author Bryan Quinn
#      @cvs-id $Id: installer-init.tcl,v 1.2 2010/10/19 20:10:29 po34demo Exp $


# Create a mutex for the installer
nsv_set acs_installer mutex [ns_mutex create oacs:installer]
