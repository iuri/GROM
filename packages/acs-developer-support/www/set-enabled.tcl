# File:        set-enabled.tcl
# Package:     developer-support
# Author:      jsalz@mit.edu
# Date:        22 June 2000
# Description: Enables or disables developer support data collection.
#
# $Id: set-enabled.tcl,v 1.1.1.1 2005/06/24 17:56:26 cvs Exp $

ad_page_variables {
    enabled_p
}

ds_require_permission [ad_conn package_id] "admin"

nsv_set ds_properties enabled_p $enabled_p
ad_returnredirect "index"
