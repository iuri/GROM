ad_page_contract {
    Schedules all -procs.tcl and xql files of a package to be watched.


    @author Peter Marklund
    @cvs-id $Id: package-watch.tcl,v 1.3 2010/10/19 20:10:04 po34demo Exp $
} {
    package_key
    {return_url "index"}
} 

apm_watch_all_files $package_key

ad_returnredirect $return_url
